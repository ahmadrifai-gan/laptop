# 📱 Flutter Integration Guide

## Setup Instructions

### 1. Create New Flutter Project
```bash
flutter create laptop_recommendation
cd laptop_recommendation
```

### 2. Copy Integration Files
Copy all files from `flutter_integration/` folder:
- `constants.dart` → `lib/constants/constants.dart`
- `models.dart` → `lib/models/models.dart`
- `api_service.dart` → `lib/services/api_service.dart`
- `laptop_prediction_provider.dart` → `lib/providers/laptop_prediction_provider.dart`
- `screens/*.dart` → `lib/screens/`
- `main.dart` → `lib/main.dart`

### 3. Update pubspec.yaml
Replace content with:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.0
```

Run:
```bash
flutter pub get
```

### 4. Update API Configuration
Edit `lib/constants/constants.dart`:

**For Android Emulator:**
```dart
const String API_BASE_URL = 'http://10.0.2.2:8000';
```

**For Physical Device (replace 192.168.x.x with your server IP):**
```dart
const String API_BASE_URL = 'http://192.168.x.x:8000';
```

To find server IP:
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

### 5. Run Application
```bash
flutter run

# Or specific device
flutter run -d <device_id>
```

---

## Project Structure

```
lib/
├── main.dart                       # App entry point
├── constants/
│   └── constants.dart              # API URLs, defaults
├── models/
│   └── models.dart                 # Response models
├── services/
│   └── api_service.dart            # HTTP requests
├── providers/
│   └── laptop_prediction_provider.dart  # State management
└── screens/
    ├── home_screen.dart            # Home/info
    ├── input_specs_screen.dart     # Input form
    ├── results_screen.dart         # Predictions/recommendations
    └── settings_screen.dart        # Configuration
```

---

## Features

### 1. Home Screen
- App info dan features
- Server status indicator
- Model information

### 2. Input Specs Screen
- Text input untuk setiap spec
- Preset buttons (Gaming, Programming, Office)
- Quick selection untuk common use cases
- Validation otomatis

### 3. Results Screen
- Category prediction dengan color coding
- Confidence score
- Top recommended laptops
- Laptop details (specs, price)

### 4. Settings Screen
- API URL configuration
- Device configuration guide
- App information
- About section

---

## Usage Flow

1. **Navigate to Input Tab**
   - Enter laptop specifications
   - Atau gunakan preset buttons

2. **Click "Predict & Recommend"**
   - App akan call API
   - Show loading spinner

3. **View Results**
   - Go to Results tab
   - See predicted category
   - Browse recommended laptops

4. **Configure if needed**
   - Go to Settings
   - Update API URL jika diperlukan
   - Save configuration

---

## API Integration Details

### LaptopPredictionProvider
Provider untuk state management menggunakan `provider` package.

**Available Methods:**
```dart
// Get laptop categories
await provider.checkConnection();

// Make single prediction
await provider.predictLaptop();

// Get recommendations
await provider.getRecommendations(topN: 5);

// Predict and get recommendations
await provider.predictAndRecommend();

// Reset specs
provider.resetSpecs();

// Update single spec
provider.updateSpec('Ram', '32GB');

// Update multiple specs
provider.updateSpecs({'Ram': '32GB', 'Cpu': 'i9'});
```

**Available Getters:**
```dart
provider.specs              // Current specs
provider.predictionResult   // Prediction response
provider.recommendationsResult  // Recommendations response
provider.isLoading         // Loading state
provider.error             // Error message
provider.serverConnected   // Server status
provider.hasPrediction     // Has prediction result
provider.hasRecommendations // Has recommendations
```

---

## Error Handling

### Common Errors

**"Server Disconnected"**
- Check API_BASE_URL configuration
- Verify Laravel server is running
- Check network connectivity
- For Android emulator, use 10.0.2.2

**"Validation Error"**
- Check input format
- All fields must be filled
- Price must be numeric

**"Request Timeout"**
- Server taking too long
- Increase timeout in constants.dart
- Check server CPU/memory

### Handling in Code
```dart
try {
  await provider.predictAndRecommend();
} on ApiError catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
}
```

---

## Advanced Configuration

### Custom Models Setup

Create `lib/models/custom_models.dart`:
```dart
// Add custom models if needed
class UserProfile {
  final String userId;
  final List<String> savedRecommendations;
  
  UserProfile({...});
}
```

### Database Integration (Optional)

Add to pubspec.yaml:
```yaml
sqflite: ^2.2.0
path_provider: ^2.0.0
```

Use untuk:
- Cache API responses
- Save user history
- Offline support

### Firebase Integration (Optional)

```yaml
firebase_core: ^2.0.0
firebase_analytics: ^10.0.0
```

---

## Testing

### Unit Tests
```dart
// test/services/api_service_test.dart
void main() {
  test('API Service predicts correctly', () async {
    final service = ApiService();
    final result = await service.predictLaptop(...);
    expect(result.success, true);
  });
}
```

### Widget Tests
```dart
// test/screens/input_specs_screen_test.dart
testWidgets('Input screen displays correctly', (tester) async {
  await tester.pumpWidget(const LaptopRecommendationApp());
  expect(find.byType(InputSpecsScreen), findsOneWidget);
});
```

Run tests:
```bash
flutter test
```

---

## Performance Tips

1. **Image Optimization**
   - Use webp format
   - Compress images
   - Lazy load

2. **API Optimization**
   - Cache responses
   - Batch requests
   - Pagination

3. **Widget Optimization**
   - Use const constructors
   - ListView.builder untuk list panjang
   - Avoid rebuilds dengan Provider

---

## Deployment

### Android

```bash
# Build APK
flutter build apk --release

# Or App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build IPA
flutter build ios --release
```

### Web (Optional)

```bash
# Build web version
flutter build web --release
```

---

## Troubleshooting

### App Crashes on Startup
- Check pubspec.yaml dependencies
- Run `flutter pub get` again
- Clear build: `flutter clean`

### API Not Responding
- Verify server running: `php artisan serve`
- Check API URL in settings
- Test API with curl/Postman

### Provider Errors
- Ensure MultiProvider wraps MaterialApp
- Check Consumer<> generic type
- Verify provider initialization

### Network Errors
- Check Internet permission in AndroidManifest.xml
- Verify firewall settings
- Check API CORS (Laravel middleware)

---

## Useful Links

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [HTTP Package](https://pub.dev/packages/http)
- [Material Design](https://material.io/design)

---

## Next Steps

1. ✅ Setup project dengan files ini
2. ✅ Configure API URL
3. ✅ Run flutter app
4. ✅ Test predict & recommend
5. 🔄 Add database (optional)
6. 🔄 Add Firebase (optional)
7. 🔄 Deploy ke Play Store/App Store

---

**Status**: Ready to Deploy

Untuk pertanyaan, refer ke:
- `API_DOCUMENTATION.md` - Backend API
- `README.md` - Project overview
- Flutter docs - Framework documentation
