# 📱 Flutter Integration - Complete Guide

## Overview

Complete Flutter mobile app untuk **Laptop Recommendation System**. App ini menggunakan KNN ML model via Laravel API backend untuk prediksi kategori laptop dan memberikan rekomendasi.

---

## 🎯 Features

### 1. **Smart Prediction**
- Input laptop specifications
- Predict category (Gaming, Programming, Office)
- Show confidence score
- Real-time validation

### 2. **Recommendations**
- Get top laptops berdasarkan kategori
- Sortir by price
- Detail specs untuk setiap laptop
- See neighbors yang digunakan KNN

### 3. **User-Friendly UI**
- Bottom navigation (4 screens)
- Preset buttons untuk quick selection
- Color-coded categories
- Loading states & error handling

### 4. **Server Management**
- Check server connection status
- Configure API URL
- Timeout handling
- Error recovery

---

## 📋 Screens

### 1. Home Screen
```
┌─────────────────────┐
│   LAPTOP RECOM      │
│   ┌──────────┐      │
│   │ 💻 ICON  │      │
│   └──────────┘      │
│                     │
│ ✅ Server Connected │
│                     │
│ Features:           │
│ • Smart Prediction  │
│ • Recommendations   │
│ • ML Powered        │
│                     │
│ [Get Started]       │
└─────────────────────┘
```

### 2. Input Specs Screen
```
┌─────────────────────┐
│ Laptop Specs        │
├─────────────────────┤
│ Presets: [Gaming] [Programming] [Office]
│                     │
│ Type Name: [____]   │
│ RAM: [16GB]         │
│ Memory: [512GB SSD] │
│ CPU: [Core i7]      │
│ GPU: [Nvidia 1650]  │
│ Weight: [1.5kg]     │
│ Price: [1500]       │
│                     │
│ [Predict & Recommend]
│ [Reset]             │
└─────────────────────┘
```

### 3. Results Screen
```
┌─────────────────────┐
│ Prediction Results  │
├─────────────────────┤
│ ┌─────────────────┐ │
│ │     GAMING      │ │
│ │ Confidence: 77% │ │
│ └─────────────────┘ │
│                     │
│ Recommendations:    │
│ #1 Dell XPS 15      │
│    €859.01          │
│    16GB | i7        │
│                     │
│ #2 Dell Gaming 15   │
│    €879.01          │
│    16GB | i7        │
└─────────────────────┘
```

### 4. Settings Screen
```
┌─────────────────────┐
│ Settings            │
├─────────────────────┤
│ API Configuration:  │
│ URL: [_______]      │
│                     │
│ Notes:              │
│ • Android: 10.0.2.2 │
│ • Device: 192.x.x   │
│                     │
│ App Info:           │
│ • Name: Laptop Rec  │
│ • Version: 1.0.0    │
│ • Model: KNN        │
│ • Accuracy: 96.93%  │
│                     │
│ [Save Configuration]│
└─────────────────────┘
```

---

## 🏗️ Architecture

### Provider Pattern
```
LaptopPredictionProvider (State Management)
    ├── specs: Map<String, dynamic>
    ├── predictionResult: PredictionResponse
    ├── recommendationsResult: RecommendationsResponse
    ├── isLoading: bool
    └── error: String?

    Methods:
    ├── predictLaptop()
    ├── getRecommendations(topN)
    ├── predictAndRecommend()
    ├── updateSpec(key, value)
    ├── resetSpecs()
    └── checkConnection()
```

### API Service Layer
```
ApiService (Singleton)
    Methods:
    ├── getCategories()
    ├── predictLaptop(specs)
    ├── getRecommendations(specs)
    ├── predictAndRecommend(specs)
    └── checkServerConnection()
```

### Models
```
CategoriesResponse
PredictionResponse
  ├── prediction: String
  ├── confidence: double
  ├── neighborIndices: List<int>
  └── distances: List<double>

RecommendationsResponse
  ├── kategoriDiprediksi: String
  ├── confidence: double
  ├── recommendations: List<LaptopRecommendation>

LaptopRecommendation
  ├── company: String
  ├── product: String
  ├── ram: int
  ├── memory: int
  ├── cpu: String
  ├── gpu: String
  ├── weight: double
  └── price: double

ApiError (Exception)
  ├── message: String
  ├── code: String
  └── originalError: dynamic
```

---

## 🔧 Configuration

### API URLs
```dart
// constants.dart
const String API_BASE_URL = 'http://10.0.2.2:8000';
const String API_PREDICT = '/api/predict';
const String API_RECOMMENDATIONS = '/api/recommendations';
const String API_CATEGORIES = '/api/categories';
```

### Timeout & Networking
```dart
const int API_TIMEOUT_SECONDS = 30;
// Requests akan timeout setelah 30 detik
```

### Default Specs
```dart
DefaultSpecs.empty    // Blank form
DefaultSpecs.gaming   // Gaming laptop
DefaultSpecs.programming // Programming laptop
DefaultSpecs.office   // Office laptop
```

---

## 📝 Usage Examples

### Example 1: Simple Prediction
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LaptopPredictionProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: () async {
            await provider.predictLaptop();
          },
          child: Text('Predict'),
        );
      },
    );
  }
}
```

### Example 2: Display Results
```dart
Text('Category: ${provider.predictionResult?.prediction}'),
Text('Confidence: ${provider.predictionResult?.confidence}%'),
```

### Example 3: Show Recommendations
```dart
ListView.builder(
  itemCount: provider.recommendationsResult?.recommendations.length ?? 0,
  itemBuilder: (context, index) {
    final laptop = provider.recommendationsResult!.recommendations[index];
    return ListTile(
      title: Text(laptop.company ?? 'N/A'),
      subtitle: Text('€${laptop.price}'),
    );
  },
)
```

### Example 4: Error Handling
```dart
if (provider.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${provider.error}')),
  );
}
```

---

## 🚀 Deployment Checklist

### Pre-Deployment
- [ ] API URL configured correctly
- [ ] All dependencies installed
- [ ] App tested on multiple devices
- [ ] Error handling tested
- [ ] Network connectivity tested

### Android Release
- [ ] Update version: `pubspec.yaml`
- [ ] Generate keystore: `keytool -genkey -v ...`
- [ ] Build: `flutter build appbundle --release`
- [ ] Test on device: `flutter install`
- [ ] Upload to Play Store

### iOS Release
- [ ] Setup certificates in Xcode
- [ ] Update version: `pubspec.yaml`
- [ ] Build: `flutter build ios --release`
- [ ] Archive in Xcode
- [ ] Upload with Transporter

---

## 🐛 Debugging Tips

### Debug Mode
```bash
flutter run -v  # Verbose output
```

### Hot Reload
```bash
# Press 'r' in terminal after changes
# Only for dart code, not native plugins
```

### Monitor Network
```bash
# Android
adb logcat

# iOS
iphone simulator console
```

### Check API Calls
Logs akan print di console:
```
[API] POST http://10.0.2.2:8000/api/predict
[API] Body: {"TypeName":"Ultrabook",...}
[API] Response: 200
[API] Body: {"success":true,...}
```

---

## 📊 Performance Optimization

### Memory
- Use `const` constructors
- Dispose controllers properly
- Avoid memory leaks dengan Stream

### Network
- Cache responses
- Batch API calls
- Use compression

### UI Rendering
- Use `ListView.builder` untuk long lists
- Avoid unnecessary rebuilds
- Use `RepaintBoundary` untuk expensive widgets

---

## 🔐 Security Considerations

### For Production
1. **HTTPS Only**
   - Use SSL certificates
   - Validate certificates

2. **API Keys**
   - Store securely
   - Use environment files
   - Rotate regularly

3. **User Data**
   - Encrypt sensitive data
   - Secure local storage
   - GDPR compliance

### Implementation
```dart
// Use secrets
const String API_KEY = String.fromEnvironment('API_KEY');

// Secure storage
import 'flutter_secure_storage/flutter_secure_storage.dart';
```

---

## 📱 Device Compatibility

### Minimum Requirements
- **Android**: 5.0 (API 21)
- **iOS**: 11.0
- **Flutter**: 3.0+

### Screen Sizes
- Phone: 4" - 6.7"
- Tablet: 7" - 12"
- Web: 1920x1080+

### Responsive Design
- `MediaQuery` untuk device size
- `LayoutBuilder` untuk responsive
- `Flexible` dan `Expanded` untuk layout

---

## 🎨 Customization

### Color Scheme
```dart
// Edit constants.dart
class CategoryColors {
  static const Map<String, int> colors = {
    'Gaming': 0xFFFF6B6B,      // Red
    'Programming': 0xFF4ECDC4, // Teal
    'Office': 0xFF95E1D3,      // Light teal
  };
}
```

### Font & Typography
Edit `pubspec.yaml`:
```yaml
fonts:
  - family: CustomFont
    fonts:
      - asset: assets/fonts/font.ttf
```

### Themes
```dart
MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    fontFamily: 'CustomFont',
  ),
)
```

---

## 📚 File Structure
```
lib/
├── main.dart                       # Entry point
├── constants/
│   └── constants.dart              # API URLs, defaults
├── models/
│   └── models.dart                 # Response models
├── services/
│   └── api_service.dart            # HTTP service
├── providers/
│   └── laptop_prediction_provider.dart  # State mgmt
└── screens/
    ├── home_screen.dart
    ├── input_specs_screen.dart
    ├── results_screen.dart
    └── settings_screen.dart

test/
├── unit/
│   └── api_service_test.dart       # API tests
└── widget/
    └── home_screen_test.dart       # Widget tests
```

---

## 🔗 Related Documentation

- [API Documentation](../API_DOCUMENTATION.md)
- [Backend README](../README.md)
- [Quick Start](./QUICK_START.md)
- [Integration Guide](./FLUTTER_INTEGRATION_GUIDE.md)

---

## 💡 Pro Tips

1. **Offline Support**
   - Cache API responses
   - Show cached data when offline
   - Sync when online

2. **Batch Operations**
   - Use `Future.wait()` untuk parallel requests
   - Reduce API calls

3. **User Experience**
   - Show loading states
   - Handle errors gracefully
   - Provide feedback

4. **Monitoring**
   - Track API performance
   - Monitor error rates
   - User analytics

---

## 🆘 Support

For issues:
1. Check QUICK_START.md
2. Review FLUTTER_INTEGRATION_GUIDE.md
3. Check API_DOCUMENTATION.md
4. Review error logs
5. Test with curl: `curl http://localhost:8000/api/categories`

---

**Status**: ✅ Production Ready

**Last Updated**: 2024-06-17  
**Version**: 1.0.0
