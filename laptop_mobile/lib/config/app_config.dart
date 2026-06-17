class AppConfig {
  // Use http://localhost:8000 for Flutter Web or iOS Simulator
  // Use http://10.0.2.2:8000 for Android Emulator
  // Use http://<your_PC_IP>:8000 for physical devices
  static const String baseUrl = 'http://localhost:8000';
  static const String apiUrl = '$baseUrl/api';
  static const int timeoutSeconds = 30;
}
