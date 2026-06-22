# 🎯 Sistem Rekomendasi Laptop Berbasis KNN

Aplikasi web dan mobile untuk diagnosa dan rekomendasi laptop menggunakan algoritma **K-Nearest Neighbors (KNN)** dengan Python backend dan Laravel API.

## 📋 Daftar Isi
- [Fitur](#fitur)
- [Teknologi](#teknologi)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [API Documentation](#api-documentation)
- [Model Performance](#model-performance)
- [Cara Penggunaan](#cara-penggunaan)

---

## ✨ Fitur

1. **Prediksi Kategori Laptop**
   - Input: Spesifikasi laptop (RAM, CPU, GPU, dll)
   - Output: Kategori (Gaming, Programming, Office)
   - Confidence Score: 0-100%

2. **Rekomendasi Laptop**
   - Berdasarkan prediksi kategori
   - Top N rekomendasi (default 5)
   - Sorted by price (termurah)

3. **API RESTful**
   - Built with Laravel
   - Integrasi Python ML Model
   - JSON response

4. **Machine Learning Model**
   - Algoritma: K-Nearest Neighbors (K=3)
   - Akurasi: 96.93%
   - Dataset: 1303 laptop records
   - Features: 7 (TypeName, Ram, Memory, CPU, GPU, Weight, Price)

---

## 🛠️ Teknologi

### Backend
- **Framework**: Laravel 11
- **Language**: PHP 8.x
- **Database**: MySQL (optional)

### Machine Learning
- **Language**: Python 3.x
- **ML Library**: scikit-learn (KNN)
- **Data Processing**: Pandas, NumPy
- **File Format**: .pkl (model persistence)

### Frontend (Opsional)
- **Mobile**: Flutter
- **Web**: React/Vue.js

### Data Format
- **Dataset**: Excel (.xls)
- **API**: JSON

---

## 📁 Project Structure

```
laptop/
├── model/                          # Python ML Module
│   ├── laptop_price.xls            # Dataset (1303 records)
│   ├── config.py                   # Configuration & paths
│   ├── train_model.py              # Training script
│   ├── predik.py                   # Prediction class
│   ├── predict_api.py              # API wrapper untuk predict
│   ├── recommend_api.py            # API wrapper untuk recommend
│   ├── Untitled.ipynb              # Jupyter notebook (preprocessing)
│   ├── models/                     # Trained model files
│   │   ├── knn_model.pkl           # KNN model
│   │   ├── scaler.pkl              # StandardScaler
│   │   ├── encoders.pkl            # LabelEncoders
│   │   └── target_encoder.pkl      # Target encoder
│   ├── API_DOCUMENTATION.md        # API docs
│   └── README.md                   # This file
│
└── Laptop-WEB/                     # Laravel Backend
    ├── app/Http/Controllers/
    │   └── PredictionController.php # API handler
    ├── routes/
    │   ├── web.php                 # API routes
    │   └── api.php                 # API routes definition
    ├── .env                        # Environment variables
    ├── artisan                     # Laravel CLI
    └── ...
```

---

## 🚀 Setup Instructions

### Prerequisites
- Python 3.8+
- PHP 8.0+
- Laravel 11
- Composer
- pip

### Step 1: Install Python Dependencies
```bash
cd c:\laragon\www\laptop\model

# Install required packages
pip install pandas scikit-learn openpyxl xlrd numpy
```

### Step 2: Prepare Model
```bash
# Train model dan save (hanya sekali)
python train_model.py

# Output akan:
# - Train KNN model dengan K=3
# - Achieve accuracy ~96.93%
# - Save model files ke models/ folder
```

### Step 3: Setup Laravel
```bash
cd c:\laragon\www\laptop\Laptop-WEB

# Install dependencies
composer install

# Copy .env
copy .env.example .env
php artisan key:generate

# Create database (jika diperlukan)
php artisan migrate
```

### Step 4: Run Server
```bash
# Terminal 1: Start Laravel
cd c:\laragon\www\laptop\Laptop-WEB
php artisan serve --host=localhost --port=8000

# Output:
# Laravel development server started at [http://127.0.0.1:8000]
```

### Step 5: Test API
```bash
# Terminal 2: Test endpoint
curl -X GET http://localhost:8000/api/categories

# Response:
# {"success":true,"data":{"categories":["Gaming","Programming","Office"]}}
```

---

## 📡 API Documentation

### Available Endpoints

#### 1. GET /api/categories
Ambil list kategori laptop yang tersedia.

**Response:**
```json
{
  "success": true,
  "data": {
    "categories": ["Gaming", "Programming", "Office"]
  }
}
```

#### 2. POST /api/predict
Prediksi kategori laptop dari spesifikasi.

**Request:**
```json
{
  "TypeName": "Ultrabook",
  "Ram": "16GB",
  "Memory": "512GB SSD",
  "Cpu": "Intel Core i7",
  "Gpu": "Nvidia GeForce GTX 1650",
  "Weight": "1.5kg",
  "Price_euros": 1500
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "prediction": "Gaming",
    "confidence": 77.27,
    "neighbors": {
      "indices": [123, 456, 789],
      "distances": [0.12, 0.23, 0.34]
    }
  }
}
```

#### 3. POST /api/recommendations
Dapatkan rekomendasi laptop berdasarkan kategori yang diprediksi.

**Request:**
```json
{
  "TypeName": "Ultrabook",
  "Ram": "16GB",
  "Memory": "512GB SSD",
  "Cpu": "Intel Core i7",
  "Gpu": "Nvidia GeForce GTX 1650",
  "Weight": "1.5kg",
  "Price_euros": 1500,
  "top_n": 5
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "kategori_diprediksi": "Gaming",
    "confidence": 77.27,
    "total_recommendations": 5,
    "recommendations": [
      {
        "Company": "Dell",
        "Product": "XPS 15",
        "Ram": 16,
        "Price_euros": 859.01
      },
      ...
    ]
  }
}
```

Untuk dokumentasi lengkap, lihat [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

---

## 📊 Model Performance

### Training Results
- **Model**: K-Nearest Neighbors
- **K Value**: 3
- **Total Data**: 1303 records
- **Train-Test Split**: 80-20
- **Overall Accuracy**: **96.93%**

### Classification Report
```
              precision    recall  f1-score   support

Gaming (0)       0.94      1.00      0.97        34
Programming (1)  0.96      0.96      0.96        79
Office (2)       0.98      0.97      0.97       148

accuracy                           0.97       261
macro avg        0.96      0.98      0.97       261
weighted avg     0.97      0.97      0.97       261
```

### Features Used
1. **TypeName** - Tipe laptop (Ultrabook, Notebook, Gaming, dll)
2. **Ram** - RAM size (8GB, 16GB, 32GB)
3. **Memory** - Storage (512GB, 1TB, 2TB)
4. **Cpu** - Processor (i3, i5, i7, i9, Ryzen)
5. **Gpu** - Graphics (Nvidia, AMD, Intel)
6. **Weight** - Berat laptop (kg)
7. **Price_euros** - Harga dalam Euro

### Preprocessing Steps
1. Data cleaning (format standardization)
2. Label encoding (categorical features)
3. StandardScaler (feature normalization)
4. Train-test split (80-20)

---

## 💻 Cara Penggunaan

### 1. Dari Flutter App
```dart
// Import
import 'package:http/http.dart' as http;

// Predict function
Future<void> predictLaptop() async {
  final specs = {
    'TypeName': 'Ultrabook',
    'Ram': '16GB',
    'Memory': '512GB SSD',
    'Cpu': 'Intel Core i7',
    'Gpu': 'Nvidia GeForce GTX 1650',
    'Weight': '1.5kg',
    'Price_euros': 1500,
  };

  final response = await http.post(
    Uri.parse('http://SERVER_IP:8000/api/predict'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(specs),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print('Kategori: ${result['data']['prediction']}');
    print('Confidence: ${result['data']['confidence']}%');
  }
}
```

### 2. Dari Web/React
```javascript
async function getRecommendations(specs) {
  const response = await fetch('http://localhost:8000/api/recommendations', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(specs),
  });
  
  const result = await response.json();
  return result.data.recommendations;
}
```

### 3. Python Direct (Testing)
```bash
# Test prediction
cd model
python -c "from predik import LaptopPredictor; p = LaptopPredictor(); print(p.predict({'TypeName':'Ultrabook', 'Ram':'16GB', ...}))"
```

---

## 🔧 Troubleshooting

### Model Loading Error
```
Error: Model not found
Solution: Run 'python train_model.py' terlebih dahulu
```

### Excel File Error
```
Error: Invalid Excel format
Solution: Ensure file adalah .xls atau .xlsx dan tidak corrupt
```

### Python Not Found in Laravel
```
Error: Command 'python' not found
Solution: Gunakan full path: 'C:\Python\python.exe' atau set PATH environment variable
```

### Port Already in Use
```
Error: Port 8000 already in use
Solution: php artisan serve --host=localhost --port=8001
```

---

## 📝 Catatan Penting

1. **Model Persistence**: Model disimpan dalam format pickle (.pkl) dan bisa langsung digunakan tanpa retrain
2. **Performance**: Prediksi biasanya memakan waktu 2-5 detik (Python inference + data cleaning)
3. **Scalability**: Untuk dataset lebih besar, pertimbangkan menggunakan FastAPI atau celery
4. **Security**: Untuk production, gunakan HTTPS, authentication, rate limiting
5. **Optimization**: Bisa cache results untuk specs yang sering diminta

---

## 📚 File Reference

| File | Deskripsi |
|------|-----------|
| `config.py` | Configuration & paths |
| `train_model.py` | Training script - run once to create model |
| `predik.py` | Main prediction class |
| `predict_api.py` | API wrapper untuk single prediction |
| `recommend_api.py` | API wrapper untuk recommendations |
| `PredictionController.php` | Laravel controller untuk API |
| `routes/web.php` | Route definitions |

---

## 🎓 Learning Resources

- [scikit-learn KNN Documentation](https://scikit-learn.org/stable/modules/neighbors.html)
- [Laravel Documentation](https://laravel.com/docs)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Flutter HTTP Package](https://pub.dev/packages/http)

---

## 📞 Support

Untuk pertanyaan atau masalah:
1. Cek dokumentasi API di [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
2. Lihat error message di logs
3. Run training script untuk regenerate model

---

## 📄 License

Private Project - 2024

---

**Last Updated**: 2024-06-17  
**Status**: Production Ready ✅
