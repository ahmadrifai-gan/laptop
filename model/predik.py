import pandas as pd
import pickle
import json
from typing import Dict, List

import config


class LaptopPredictor:
    """Class untuk melakukan prediksi kategori laptop"""
    
    def __init__(self):
        """Load model dan preprocessor"""
        self.model = None
        self.scaler = None
        self.encoders = None
        self.target_encoder = None
        self.df_original = None
        
        self._load_model()
        self._load_data()
    
    def _load_model(self):
        """Load trained model, scaler, dan encoders"""
        try:
            with open(config.MODEL_PATH, 'rb') as f:
                self.model = pickle.load(f)
            
            with open(config.SCALER_PATH, 'rb') as f:
                self.scaler = pickle.load(f)
            
            with open(config.ENCODER_PATH, 'rb') as f:
                self.encoders = pickle.load(f)
            
            target_encoder_path = config.ENCODER_PATH.replace('encoders', 'target_encoder')
            with open(target_encoder_path, 'rb') as f:
                self.target_encoder = pickle.load(f)
            
            print("[OK] Model loaded successfully!")
        
        except FileNotFoundError as e:
            print("[ERROR] Model not found: {}".format(e))
            print("[ERROR] Jalankan train_model.py terlebih dahulu!")
            raise
    
    def _load_data(self):
        """Load original data untuk rekomendasi"""
        try:
            self.df_original = pd.read_excel(config.CSV_PATH, engine='openpyxl')
        except:
            try:
                self.df_original = pd.read_excel(config.CSV_PATH, engine='xlrd')
            except:
                self.df_original = pd.read_csv(config.CSV_PATH, encoding='latin-1')
    
    def _preprocess_input(self, user_input: Dict) -> pd.DataFrame:
        """Preprocess user input menjadi format yang bisa di-predict"""
        
        # Create DataFrame dari user input
        df_input = pd.DataFrame([user_input])
        
        # Clean Ram
        if isinstance(df_input.loc[0, 'Ram'], str):
            df_input['Ram'] = df_input['Ram'].str.replace('GB', '')
        df_input['Ram'] = df_input['Ram'].astype(int)
        
        # Clean Memory - extract numeric value
        if isinstance(df_input.loc[0, 'Memory'], str):
            df_input['Memory'] = df_input['Memory'].str.extract(r'(\d+)').astype(int)
        else:
            df_input['Memory'] = df_input['Memory'].astype(int)
        
        # Clean Weight
        if isinstance(df_input.loc[0, 'Weight'], str):
            df_input['Weight'] = df_input['Weight'].str.replace('kg', '')
        df_input['Weight'] = df_input['Weight'].astype(float)
        
        # Extract CPU
        df_input['Cpu'] = df_input['Cpu'].str.extract(
            r'(i3|i5|i7|i9|Ryzen 3|Ryzen 5|Ryzen 7|Ryzen 9|Celeron|Pentium)'
        )
        df_input['Cpu'] = df_input['Cpu'].fillna('Other')
        
        # Clean GPU
        df_input['Gpu'] = df_input['Gpu'].str.split().str[0]
        
        # Encode categorical features
        for col in config.CATEGORICAL_COLUMNS:
            if col in df_input.columns:
                try:
                    df_input[col] = self.encoders[col].transform(df_input[col])
                except:
                    # Jika value tidak ada di encoder, ambil unknown/default
                    df_input[col] = 0
        
        return df_input
    
    def predict(self, user_input: Dict) -> Dict:
        """
        Prediksi kategori laptop dari user input
        
        Args:
            user_input: Dict dengan keys: TypeName, Ram, Memory, Cpu, Gpu, Weight, Price_euros
        
        Returns:
            Dict dengan hasil prediksi dan rekomendasi
        """
        
        # Preprocess input
        df_input = self._preprocess_input(user_input)
        
        # Select features
        X_input = df_input[config.FEATURE_COLUMNS]
        
        # Scale
        X_scaled = self.scaler.transform(X_input)
        
        # Predict
        prediction_encoded = self.model.predict(X_scaled)[0]
        
        # Decode prediction
        kategori_predicted = self.target_encoder.inverse_transform([prediction_encoded])[0]
        
        # Get neighbors
        distances, indices = self.model.kneighbors(X_scaled)
        
        return {
            'prediction': kategori_predicted,
            'confidence': self._calculate_confidence(distances[0]),
            'neighbors_indices': indices[0].tolist(),
            'distances': distances[0].tolist()
        }
    
    def _calculate_confidence(self, distances: List[float]) -> float:
        """Calculate confidence dari distances"""
        # Semakin kecil distance, semakin tinggi confidence
        # Normalize distance ke 0-1 range
        avg_distance = sum(distances) / len(distances)
        confidence = 1 / (1 + avg_distance)
        return round(confidence * 100, 2)
    
    def get_recommendations(self, user_input: Dict, top_n: int = 5) -> Dict:
        """
        Dapatkan rekomendasi laptop berdasarkan prediksi kategori
        
        Args:
            user_input: Dict dengan user preferences
            top_n: Jumlah rekomendasi yang dikembalikan
        
        Returns:
            Dict dengan kategori dan rekomendasi laptop
        """
        
        # Get prediction
        prediction_result = self.predict(user_input)
        kategori = prediction_result['prediction']
        
        # Preprocess untuk bisa mengakses kategori di df_original
        try:
            df_temp = pd.read_excel(config.CSV_PATH, engine='openpyxl')
        except:
            try:
                df_temp = pd.read_excel(config.CSV_PATH, engine='xlrd')
            except:
                df_temp = pd.read_csv(config.CSV_PATH, encoding='latin-1')
        
        # Clean data terlebih dahulu
        from train_model import categorize_laptop, clean_data
        df_temp = clean_data(df_temp)
        
        # Filter berdasarkan kategori
        df_rekomendasi = df_temp[df_temp['Kategori'] == kategori]
        
        # Sort by price (ascending untuk rekomendasi termurah)
        df_rekomendasi = df_rekomendasi.sort_values('Price_euros', ascending=True)
        
        # Ambil top N
        top_laptops = df_rekomendasi.head(top_n)
        
        recommendations = {
            'kategori_diprediksi': kategori,
            'confidence': prediction_result['confidence'],
            'jumlah_rekomendasi': len(top_laptops),
            'rekomendasi': top_laptops.to_dict('records') if len(top_laptops) > 0 else []
        }
        
        return recommendations


def main():
    """Test prediksi"""
    # Initialize predictor
    predictor = LaptopPredictor()
    
    # Test input
    test_input = {
        'TypeName': 'Ultrabook',
        'Ram': '16GB',
        'Memory': '512GB SSD',
        'Cpu': 'Intel Core i7',
        'Gpu': 'Nvidia GeForce GTX 1650',
        'Weight': '1.5kg',
        'Price_euros': 1500
    }
    
    print("\n" + "="*50)
    print("[TEST] TEST PREDIKSI")
    print("="*50)
    print("Input: {}".format(test_input))
    
    # Predict
    result = predictor.predict(test_input)
    print("\n[OK] Prediksi: {}".format(result['prediction']))
    print("[INFO] Confidence: {}%".format(result['confidence']))
    
    # Get recommendations
    print("\n" + "="*50)
    print("[INFO] REKOMENDASI LAPTOP")
    print("="*50)
    recommendations = predictor.get_recommendations(test_input, top_n=5)
    print("Kategori: {}".format(recommendations['kategori_diprediksi']))
    print("Jumlah rekomendasi: {}".format(recommendations['jumlah_rekomendasi']))
    
    if recommendations['rekomendasi']:
        for i, laptop in enumerate(recommendations['rekomendasi'][:3], 1):
            print("\n{}. {} - {}".format(i, laptop.get('Company', 'N/A'), laptop.get('TypeName', 'N/A')))
            print("   Price: Euro {}".format(laptop.get('Price_euros', 'N/A')))
            print("   Specs: {} | {}".format(laptop.get('Ram', 'N/A'), laptop.get('Cpu', 'N/A')))


if __name__ == '__main__':
    main()
