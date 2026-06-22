import pandas as pd
import pickle
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, classification_report

import config


def categorize_laptop(row):
    """Kategorisasi laptop berdasarkan spesifikasi"""
    
    # Gaming: RAM >= 16GB dan GPU dengan Nvidia/AMD
    if row['Ram'] >= 16 and str(row['Gpu']).lower() in ['nvidia', 'amd']:
        return 'Gaming'
    
    # Programming: RAM >= 8GB
    elif row['Ram'] >= 8:
        return 'Programming'
    
    # Office: Default
    else:
        return 'Office'


def clean_data(df):
    """Clean dan preprocess data"""
    print("🧹 Cleaning data...")
    
    # Clean Ram
    df['Ram'] = df['Ram'].str.replace('GB', '')
    df['Ram'] = df['Ram'].astype(int)
    
    # Clean Weight
    df['Weight'] = df['Weight'].str.replace('kg', '')
    df['Weight'] = df['Weight'].astype(float)
    
    # Clean Memory - extract numeric value
    df['Memory'] = df['Memory'].str.extract('(\d+)').astype(int)
    
    # Extract CPU
    df['Cpu'] = df['Cpu'].str.extract(
        r'(i3|i5|i7|i9|Ryzen 3|Ryzen 5|Ryzen 7|Ryzen 9|Celeron|Pentium)'
    )
    df['Cpu'] = df['Cpu'].fillna('Other')
    
    # Clean GPU
    df['Gpu'] = df['Gpu'].str.split().str[0]
    
    # Add kategori
    df['Kategori'] = df.apply(categorize_laptop, axis=1)
    
    print("✅ Data cleaned!")
    return df


def encode_features(df):
    """Encode categorical features"""
    print("🔤 Encoding features...")
    
    encoders = {}
    
    for col in config.CATEGORICAL_COLUMNS:
        if col in df.columns:
            encoder = LabelEncoder()
            df[col] = encoder.fit_transform(df[col].astype(str))
            encoders[col] = encoder
    
    # Encode target
    target_encoder = LabelEncoder()
    df['Kategori'] = target_encoder.fit_transform(df['Kategori'])
    
    print("✅ Features encoded!")
    
    return df, encoders, target_encoder


def train_model(df):
    """Train KNN model"""
    print("🤖 Training KNN model...")
    
    # Prepare X dan y
    X = df[config.FEATURE_COLUMNS]
    y = df['Kategori']
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(
        X, y,
        test_size=config.TEST_SIZE,
        random_state=config.RANDOM_STATE
    )
    
    # Scale features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train KNN
    knn = KNeighborsClassifier(n_neighbors=config.K_VALUE)
    knn.fit(X_train_scaled, y_train)
    
    # Evaluate
    y_pred = knn.predict(X_test_scaled)
    accuracy = accuracy_score(y_test, y_pred)
    
    print(f"✅ Model trained!")
    print(f"📊 Accuracy: {accuracy*100:.2f}%")
    print("\n📈 Classification Report:")
    print(classification_report(y_test, y_pred))
    
    return knn, scaler


def save_model(knn, scaler, encoders, target_encoder):
    """Save model dan preprocessor"""
    print("\n💾 Saving model...")
    
    # Save model
    with open(config.MODEL_PATH, 'wb') as f:
        pickle.dump(knn, f)
    print(f"✅ Model saved to {config.MODEL_PATH}")
    
    # Save scaler
    with open(config.SCALER_PATH, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"✅ Scaler saved to {config.SCALER_PATH}")
    
    # Save encoders
    with open(config.ENCODER_PATH, 'wb') as f:
        pickle.dump(encoders, f)
    print(f"✅ Encoders saved to {config.ENCODER_PATH}")
    
    # Save target encoder
    target_encoder_path = config.ENCODER_PATH.replace('encoders', 'target_encoder')
    with open(target_encoder_path, 'wb') as f:
        pickle.dump(target_encoder, f)
    print(f"✅ Target encoder saved to {target_encoder_path}")


def main():
    """Main training pipeline"""
    print("="*60)
    print("🚀 TRAINING KNN MODEL FOR LAPTOP RECOMMENDATION")
    print("="*60)
    
    # Load data
    print(f"\n📂 Loading data from {config.CSV_PATH}...")
    try:
        # Coba baca dengan openpyxl dulu (untuk .xlsx atau .xls modern)
        df = pd.read_excel(config.CSV_PATH, engine='openpyxl')
    except:
        try:
            # Fallback ke xlrd untuk .xls lama
            df = pd.read_excel(config.CSV_PATH, engine='xlrd')
        except:
            # Fallback ke CSV
            df = pd.read_csv(config.CSV_PATH, encoding='latin-1')
    print(f"✅ Data loaded! Shape: {df.shape}")
    
    # Display initial info
    print(f"\nℹ️  Dataset info:")
    print(f"   Columns: {', '.join(df.columns)}")
    print(f"   Rows: {len(df)}")
    
    # Clean data
    df = clean_data(df)
    
    # Encode features
    df, encoders, target_encoder = encode_features(df)
    
    # Train model
    knn, scaler = train_model(df)
    
    # Save model
    save_model(knn, scaler, encoders, target_encoder)
    
    print("\n" + "="*60)
    print("✅ TRAINING COMPLETED SUCCESSFULLY!")
    print("="*60)
    print("\n📝 Next steps:")
    print("   1. Model saved and ready for production")
    print("   2. Use predik.py untuk testing")
    print("   3. Integrate dengan Laravel backend")


if __name__ == '__main__':
    main()
