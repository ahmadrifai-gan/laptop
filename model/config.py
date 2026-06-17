import os

# Project Paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE_DIR, 'laptop_price.xls')
MODEL_DIR = os.path.join(BASE_DIR, 'models')
MODEL_PATH = os.path.join(MODEL_DIR, 'knn_model.pkl')
SCALER_PATH = os.path.join(MODEL_DIR, 'scaler.pkl')
ENCODER_PATH = os.path.join(MODEL_DIR, 'encoders.pkl')

# Ensure models directory exists
os.makedirs(MODEL_DIR, exist_ok=True)

# Model Parameters
K_VALUE = 3
TEST_SIZE = 0.2
RANDOM_STATE = 42

# Feature Columns
FEATURE_COLUMNS = [
    'TypeName',
    'Ram',
    'Memory',
    'Cpu',
    'Gpu',
    'Weight',
    'Price_euros'
]

# Categorical Columns for Encoding
CATEGORICAL_COLUMNS = [
    'Company',
    'TypeName',
    'Cpu',
    'Gpu'
]

# Target Column
TARGET_COLUMN = 'Kategori'

# Kategori Laptop
KATEGORI_MAPPING = {
    0: 'Gaming',
    1: 'Programming',
    2: 'Office'
}

# Reverse mapping untuk kategori
KATEGORI_REVERSE = {v: k for k, v in KATEGORI_MAPPING.items()}
