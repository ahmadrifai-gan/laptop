// Constants untuk API configuration

const String API_BASE_URL = 'http://192.168.x.x:8000'; // Update dengan IP server
// Untuk testing lokal: 'http://10.0.2.2:8000' (Android emulator)
// Untuk physical device: gunakan IP dari ipconfig atau server

const String API_CATEGORIES = '/api/categories';
const String API_PREDICT = '/api/predict';
const String API_RECOMMENDATIONS = '/api/recommendations';

// Timeout configuration
const int API_TIMEOUT_SECONDS = 30;

// App constants
const String APP_NAME = 'Laptop Recommendation System';
const String APP_VERSION = '1.0.0';

// Laptop specs default values
class DefaultSpecs {
  static const Map<String, dynamic> empty = {
    'TypeName': '',
    'Ram': '8GB',
    'Memory': '256GB SSD',
    'Cpu': 'Intel Core i5',
    'Gpu': 'Intel UHD',
    'Weight': '1.5kg',
    'Price_euros': 500,
  };
  
  static const Map<String, dynamic> gaming = {
    'TypeName': 'Gaming',
    'Ram': '16GB',
    'Memory': '512GB SSD',
    'Cpu': 'Intel Core i7',
    'Gpu': 'Nvidia GeForce GTX 1650',
    'Weight': '2.0kg',
    'Price_euros': 1500,
  };
  
  static const Map<String, dynamic> programming = {
    'TypeName': 'Ultrabook',
    'Ram': '16GB',
    'Memory': '512GB SSD',
    'Cpu': 'Intel Core i7',
    'Gpu': 'Intel Iris',
    'Weight': '1.2kg',
    'Price_euros': 1200,
  };
  
  static const Map<String, dynamic> office = {
    'TypeName': 'Notebook',
    'Ram': '8GB',
    'Memory': '256GB SSD',
    'Cpu': 'Intel Core i5',
    'Gpu': 'Intel UHD',
    'Weight': '1.8kg',
    'Price_euros': 600,
  };
}

// Category colors
class CategoryColors {
  static const Map<String, int> colors = {
    'Gaming': 0xFFFF6B6B,      // Red
    'Programming': 0xFF4ECDC4, // Teal
    'Office': 0xFF95E1D3,      // Light teal
  };
}
