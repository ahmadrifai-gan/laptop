# 🚀 Flutter Quick Start Checklist

## ✅ Pre-Setup
- [ ] Flutter 3.0+ installed
- [ ] Android SDK / Xcode configured
- [ ] Emulator or physical device ready
- [ ] Laravel server running on `http://192.168.x.x:8000`

## ✅ Step 1: Create Flutter Project
```bash
flutter create laptop_recommendation
cd laptop_recommendation
```

## ✅ Step 2: Copy Files
Copy these files from `flutter_integration/`:

```
lib/
├── constants/
│   └── constants.dart
├── models/
│   └── models.dart
├── services/
│   └── api_service.dart
├── providers/
│   └── laptop_prediction_provider.dart
├── screens/
│   ├── main.dart
│   ├── home_screen.dart
│   ├── input_specs_screen.dart
│   ├── results_screen.dart
│   └── settings_screen.dart
```

## ✅ Step 3: Update pubspec.yaml
```bash
flutter pub get
```

## ✅ Step 4: Configure API URL
Edit `lib/constants/constants.dart`:

**Android Emulator:**
```dart
const String API_BASE_URL = 'http://10.0.2.2:8000';
```

**Physical Device (replace with your IP):**
```dart
const String API_BASE_URL = 'http://192.168.1.100:8000';
```

## ✅ Step 5: Run App
```bash
flutter run
```

## ✅ Step 6: Test
1. Go to Input tab
2. Fill laptop specs (or use preset)
3. Click "Predict & Recommend"
4. Check Results tab

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Server Disconnected" | Check API_BASE_URL & server status |
| "Port already in use" | Use different port: `php artisan serve --port=8001` |
| "Module not found" | Run `flutter pub get` |
| Build error | Run `flutter clean` then `flutter pub get` |

---

## 📝 Configuration for Different Devices

### Android Emulator
```dart
const String API_BASE_URL = 'http://10.0.2.2:8000';
```

### iPhone Simulator
```dart
const String API_BASE_URL = 'http://localhost:8000';
```

### Physical Android Device (Replace 192.168.x.x)
```bash
# Get your PC IP
ipconfig

# Find "IPv4 Address" like 192.168.1.100
```
```dart
const String API_BASE_URL = 'http://192.168.1.100:8000';
```

### Physical iPhone Device
Same as Android - use PC IP address

---

## 🎯 Next: Deployment

### Android (Google Play Store)
1. Update version in pubspec.yaml
2. Build: `flutter build appbundle --release`
3. Upload to Play Store

### iOS (Apple App Store)
1. Setup certificates in Xcode
2. Build: `flutter build ios --release`
3. Upload with Xcode or Transporter

---

**Everything Ready?** Start with `flutter run` 🚀
