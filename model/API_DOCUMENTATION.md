# 📚 API Documentation - Laptop Recommendation System

## Base URL
```
http://localhost:8000/api
```

## Endpoints

### 1. Get Categories
**Endpoint:** `GET /api/categories`

**Response:**
```json
{
  "success": true,
  "data": {
    "categories": ["Gaming", "Programming", "Office"]
  }
}
```

---

### 2. Predict Laptop Category
**Endpoint:** `POST /api/predict`

**Request Body:**
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
      "distances": [0.1234, 0.2345, 0.3456]
    }
  }
}
```

**Curl Example:**
```bash
curl -X POST http://localhost:8000/api/predict \
  -H "Content-Type: application/json" \
  -d '{
    "TypeName": "Ultrabook",
    "Ram": "16GB",
    "Memory": "512GB SSD",
    "Cpu": "Intel Core i7",
    "Gpu": "Nvidia GeForce GTX 1650",
    "Weight": "1.5kg",
    "Price_euros": 1500
  }'
```

**PHP/Guzzle Example:**
```php
$client = new \GuzzleHttp\Client();
$response = $client->post('http://localhost:8000/api/predict', [
    'json' => [
        'TypeName' => 'Ultrabook',
        'Ram' => '16GB',
        'Memory' => '512GB SSD',
        'Cpu' => 'Intel Core i7',
        'Gpu' => 'Nvidia GeForce GTX 1650',
        'Weight' => '1.5kg',
        'Price_euros' => 1500
    ]
]);
$data = json_decode($response->getBody(), true);
```

---

### 3. Get Recommendations
**Endpoint:** `POST /api/recommendations`

**Request Body:**
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
    "total_recommendations": 3,
    "recommendations": [
      {
        "laptop_ID": 123,
        "Company": "Dell",
        "Product": "XPS 15",
        "TypeName": "Notebook",
        "Ram": 16,
        "Memory": 512,
        "Cpu": "i7",
        "Gpu": "Nvidia",
        "Price_euros": 859.01,
        "Kategori": "Gaming"
      },
      {
        "laptop_ID": 124,
        "Company": "Dell",
        "Product": "Gaming 15",
        "TypeName": "Gaming",
        "Ram": 16,
        "Memory": 512,
        "Cpu": "i7",
        "Gpu": "Nvidia",
        "Price_euros": 879.01,
        "Kategori": "Gaming"
      },
      {
        "laptop_ID": 125,
        "Company": "Dell",
        "Product": "XPS 15 Pro",
        "TypeName": "Notebook",
        "Ram": 16,
        "Memory": 512,
        "Cpu": "i7",
        "Gpu": "Nvidia",
        "Price_euros": 899.0,
        "Kategori": "Gaming"
      }
    ]
  }
}
```

**Query Parameters:**
- `top_n` (optional): Number of recommendations to return (default: 5, max: 20)

**Curl Example:**
```bash
curl -X POST http://localhost:8000/api/recommendations \
  -H "Content-Type: application/json" \
  -d '{
    "TypeName": "Ultrabook",
    "Ram": "16GB",
    "Memory": "512GB SSD",
    "Cpu": "Intel Core i7",
    "Gpu": "Nvidia GeForce GTX 1650",
    "Weight": "1.5kg",
    "Price_euros": 1500,
    "top_n": 5
  }'
```

---

## Error Responses

### Validation Error (422)
```json
{
  "success": false,
  "errors": {
    "TypeName": ["The TypeName field is required."],
    "Ram": ["The Ram field is required."]
  }
}
```

### Server Error (500)
```json
{
  "success": false,
  "message": "Prediction service error",
  "error": "Error details here"
}
```

---

## Setup Instructions

### 1. Start Laravel Server
```bash
cd c:\laragon\www\laptop\Laptop-WEB
php artisan serve --host=localhost --port=8000
```

### 2. Server Running
```
Laravel development server started at [http://127.0.0.1:8000]
```

### 3. Test Endpoints
Use curl, Postman, or any HTTP client

---

## Integration Examples

### Flutter Example
```dart
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> predictLaptop({
  required String typeName,
  required String ram,
  required String memory,
  required String cpu,
  required String gpu,
  required String weight,
  required double price,
}) async {
  final response = await http.post(
    Uri.parse('http://192.168.x.x:8000/api/predict'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'TypeName': typeName,
      'Ram': ram,
      'Memory': memory,
      'Cpu': cpu,
      'Gpu': gpu,
      'Weight': weight,
      'Price_euros': price,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to predict');
  }
}
```

### React/JavaScript Example
```javascript
async function predictLaptop(specs) {
  const response = await fetch('http://localhost:8000/api/predict', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(specs),
  });
  
  const data = await response.json();
  return data;
}

// Usage
const specs = {
  TypeName: 'Ultrabook',
  Ram: '16GB',
  Memory: '512GB SSD',
  Cpu: 'Intel Core i7',
  Gpu: 'Nvidia GeForce GTX 1650',
  Weight: '1.5kg',
  Price_euros: 1500,
};

predictLaptop(specs).then(result => {
  console.log('Prediction:', result.data.prediction);
});
```

---

## Notes
- All endpoints require proper JSON request body (except GET)
- Prediction typically takes 2-5 seconds (Python model inference)
- Confidence score ranges from 0-100
- Default top_n recommendations is 5, maximum is 20
