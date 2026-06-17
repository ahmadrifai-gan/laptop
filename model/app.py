import sys
import os

# Reconfigure stdout and stderr to use UTF-8 encoding (fixes Windows emoji printing errors)
if sys.platform.startswith('win'):
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except AttributeError:
        pass

import math
import pandas as pd
from flask import Flask, request, jsonify
from flask_cors import CORS
import pymongo
from bson import ObjectId

# Add current directory to path to import local modules
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import config
from predik import LaptopPredictor

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Initialize MongoDB Connection
try:
    mongo_client = pymongo.MongoClient("mongodb://127.0.0.1:27017/", serverSelectionTimeoutMS=5000)
    db = mongo_client["Laptop"]
    mongo_collection = db["data"]
    # Quick test connection
    mongo_client.server_info()
    print("[OK] MongoDB connected successfully!")
except Exception as e:
    print(f"[ERROR] Failed to connect to MongoDB: {e}")
    mongo_collection = None

# Initialize Laptop Predictor
try:
    predictor = LaptopPredictor()
    print("[OK] LaptopPredictor ML model loaded successfully!")
except Exception as e:
    print(f"[ERROR] Failed to load LaptopPredictor: {e}")
    predictor = None

# Mapping configurations (matching Laravel's mappings in Laptop.php)
COMPANY_MAP = {
    0: "Acer", 1: "Apple", 2: "Asus", 3: "Chuwi", 4: "Dell", 5: "Fujitsu",
    6: "Google", 7: "HP", 8: "Huawei", 9: "LG", 10: "Lenovo", 11: "MSI",
    12: "Mediacom", 13: "Microsoft", 14: "Razer", 15: "Samsung", 16: "Toshiba",
    17: "Vero", 18: "Xiaomi"
}

TYPENAME_MAP = {
    0: "2 in 1 Convertible", 1: "Gaming", 2: "Netbook", 3: "Notebook",
    4: "Ultrabook", 5: "Workstation"
}

CPU_MAP = {
    0: "Celeron", 1: "Other", 2: "Pentium", 3: "Core i3", 4: "Core i5", 5: "Core i7"
}

GPU_MAP = {
    0: "AMD", 1: "ARM", 2: "Intel", 3: "Nvidia"
}

def decode_laptop(doc):
    """Decode integer encoded fields from MongoDB into readable string labels"""
    if not doc:
        return {}
    
    doc_id = str(doc.get('_id'))
    company_val = doc.get('Company', 0)
    typename_val = doc.get('TypeName', 0)
    cpu_val = doc.get('Cpu', 0)
    gpu_val = doc.get('Gpu', 0)
    
    company_label = COMPANY_MAP.get(company_val, f"Unknown ({company_val})")
    typename_label = TYPENAME_MAP.get(typename_val, f"Unknown ({typename_val})")
    cpu_label = CPU_MAP.get(cpu_val, f"Unknown ({cpu_val})")
    gpu_label = GPU_MAP.get(gpu_val, f"Unknown ({gpu_val})")
    
    ram = doc.get('Ram', 0)
    memory = doc.get('Memory', 0)
    weight = doc.get('Weight', 0.0)
    price = doc.get('Price_euros', 0.0)
    
    # Try converting Memory to int if it's float/numeric
    try:
        memory_int = int(float(memory))
    except:
        memory_int = 0

    return {
        "id": doc_id,
        "laptop_id": doc.get('laptop_ID'),
        "company": company_label,
        "product": doc.get('Product'),
        "type_name": typename_label,
        "inches": doc.get('Inches'),
        "screen_resolution": doc.get('ScreenResolution'),
        "cpu": cpu_label,
        "ram": ram,
        "ram_label": f"{ram}GB",
        "memory": memory,
        "memory_label": f"{memory_int}GB",
        "gpu": gpu_label,
        "op_sys": doc.get('OpSys'),
        "weight": weight,
        "weight_label": f"{weight}kg",
        "price_euros": price,
        "price_formatted": f"€{price:,.2f}",
        "kategori": doc.get('Kategori')
    }

# ----------------- API ROUTES -----------------

@app.route('/api/categories', methods=['GET'])
def categories():
    """Get list of laptop categories"""
    return jsonify({
        "success": True,
        "data": {
            "categories": ["Gaming", "Programming", "Office"]
        }
    }), 200

@app.route('/api/predict', methods=['POST'])
def predict():
    """Predict laptop category from specifications"""
    if predictor is None:
        return jsonify({
            "success": False,
            "message": "Prediction model not loaded"
        }), 500
    
    try:
        data = request.get_json(silent=True) or {}
        required_fields = ['TypeName', 'Ram', 'Memory', 'Cpu', 'Gpu', 'Weight', 'Price_euros']
        
        # Check validation
        missing_fields = [f for f in required_fields if f not in data]
        if missing_fields:
            return jsonify({
                "success": False,
                "errors": {field: ["The field is required"] for field in missing_fields}
            }), 422
        
        # Run prediction
        result = predictor.predict(data)
        
        response = {
            "success": True,
            "prediction": result['prediction'],
            "confidence": result['confidence'],
            "neighbors": {
                "indices": result['neighbors_indices'],
                "distances": [round(d, 4) for d in result['distances']]
            }
        }
        
        return jsonify(response), 200
        
    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Internal server error",
            "error": str(e)
        }), 500

@app.route('/api/recommendations', methods=['POST'])
def recommendations():
    """Get laptop recommendations based on input specs"""
    if predictor is None:
        return jsonify({
            "success": False,
            "message": "Prediction model not loaded"
        }), 500
    
    try:
        data = request.get_json(silent=True) or {}
        required_fields = ['TypeName', 'Ram', 'Memory', 'Cpu', 'Gpu', 'Weight', 'Price_euros']
        
        # Check validation
        missing_fields = [f for f in required_fields if f not in data]
        if missing_fields:
            return jsonify({
                "success": False,
                "errors": {field: ["The field is required"] for field in missing_fields}
            }), 422
            
        top_n = data.get('top_n', 5)
        
        # Make a copy of input specs and remove top_n before passing to recommender
        input_specs = {k: v for k, v in data.items() if k != 'top_n'}
        
        # Get recommendations
        recs = predictor.get_recommendations(input_specs, top_n=top_n)
        
        # Clean recommendation data types and map keys to lowercase/snake_case for Flutter
        recom_key_map = {
            'Company': 'company',
            'Product': 'product',
            'TypeName': 'type_name',
            'Inches': 'inches',
            'ScreenResolution': 'screen_resolution',
            'Cpu': 'cpu',
            'Ram': 'ram',
            'Memory': 'memory',
            'Gpu': 'gpu',
            'OpSys': 'op_sys',
            'Weight': 'weight',
            'Price_euros': 'price_euros',
            'Kategori': 'kategori',
            'laptop_ID': 'laptop_id'
        }
        
        processed_recommendations = []
        if recs.get('rekomendasi'):
            for laptop in recs['rekomendasi']:
                processed_laptop = {}
                for key, value in laptop.items():
                    mapped_key = recom_key_map.get(key, key.lower())
                    if pd.isna(value):
                        processed_laptop[mapped_key] = None
                    elif isinstance(value, (int, float, str, bool)):
                        processed_laptop[mapped_key] = value
                    else:
                        processed_laptop[mapped_key] = str(value)
                
                # Add formatted labels and id required by Flutter
                if 'price_euros' in processed_laptop and processed_laptop['price_euros'] is not None:
                    try:
                        p = float(processed_laptop['price_euros'])
                        processed_laptop['price_formatted'] = f"€{p:,.2f}"
                    except:
                        pass
                if 'ram' in processed_laptop and processed_laptop['ram'] is not None:
                    processed_laptop['ram_label'] = f"{processed_laptop['ram']}GB"
                if 'memory' in processed_laptop and processed_laptop['memory'] is not None:
                    processed_laptop['memory_label'] = f"{processed_laptop['memory']}GB"
                if 'weight' in processed_laptop and processed_laptop['weight'] is not None:
                    processed_laptop['weight_label'] = f"{processed_laptop['weight']}kg"
                if 'id' not in processed_laptop or not processed_laptop['id']:
                    processed_laptop['id'] = str(laptop.get('laptop_ID', ''))
                
                processed_recommendations.append(processed_laptop)
                
        response = {
            "success": True,
            "kategori_diprediksi": recs['kategori_diprediksi'],
            "confidence": recs['confidence'],
            "total_recommendations": recs['jumlah_rekomendasi'],
            "recommendations": processed_recommendations
        }
        print(f"[DEBUG RECOMMENDATIONS] Returning: {response}")
        return jsonify(response), 200
        
    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Internal server error",
            "error": str(e)
        }), 500

@app.route('/api/laptops', methods=['GET'])
def get_laptops():
    """Get laptops with filtering and pagination"""
    if mongo_collection is None:
        return jsonify({
            "success": False,
            "message": "Database connection not available"
        }), 500
        
    try:
        kategori = request.args.get('kategori')
        search = request.args.get('search')
        page = request.args.get('page', default=1, type=int)
        per_page = 20
        
        # Build query
        query = {}
        if kategori:
            query['Kategori'] = kategori
        if search:
            query['Product'] = {'$regex': search, '$options': 'i'}
            
        # Count total documents matching criteria
        total = mongo_collection.count_documents(query)
        
        # Query matching documents
        cursor = mongo_collection.find(query).sort('Price_euros', 1).skip((page - 1) * per_page).limit(per_page)
        
        laptops_list = [decode_laptop(doc) for doc in cursor]
        last_page = math.ceil(total / per_page) if total > 0 else 1
        
        # Return paginated JSON response
        return jsonify({
            "success": True,
            "data": {
                "current_page": page,
                "data": laptops_list,
                "per_page": per_page,
                "total": total,
                "last_page": last_page,
                "from": (page - 1) * per_page + 1 if total > 0 else None,
                "to": min(page * per_page, total) if total > 0 else None
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Failed to load laptops",
            "error": str(e)
        }), 500

@app.route('/api/laptops/<laptop_id>', methods=['GET'])
def get_laptop_by_id(laptop_id):
    """Get single laptop by its MongoDB ID"""
    if mongo_collection is None:
        return jsonify({
            "success": False,
            "message": "Database connection not available"
        }), 500
        
    try:
        doc = mongo_collection.find_one({"_id": ObjectId(laptop_id)})
        if not doc:
            return jsonify({
                "success": False,
                "message": "Laptop not found"
            }), 404
            
        return jsonify({
            "success": True,
            "data": decode_laptop(doc)
        }), 200
        
    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Invalid ID format or query failed",
            "error": str(e)
        }), 400

@app.route('/api/laptops/kategori/<kategori>', methods=['GET'])
def get_laptops_by_kategori(kategori):
    """Get all laptops for a specific category"""
    if mongo_collection is None:
        return jsonify({
            "success": False,
            "message": "Database connection not available"
        }), 500
        
    valid_categories = ["Gaming", "Programming", "Office"]
    if kategori not in valid_categories:
        return jsonify({
            "success": False,
            "message": "Kategori tidak valid. Gunakan: Gaming, Programming, atau Office"
        }), 422
        
    try:
        cursor = mongo_collection.find({"Kategori": kategori}).sort('Price_euros', 1)
        decoded_list = [decode_laptop(doc) for doc in cursor]
        
        return jsonify({
            "success": True,
            "kategori": kategori,
            "total": len(decoded_list),
            "data": decoded_list
        }), 200
        
    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Failed to retrieve laptops by category",
            "error": str(e)
        }), 500

if __name__ == '__main__':
    # Bind to 0.0.0.0 so that the app is accessible outside the host machine (e.g. from Android Emulator via 10.0.2.2)
    app.run(host='0.0.0.0', port=8000, debug=True, use_reloader=False)
