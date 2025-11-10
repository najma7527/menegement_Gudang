class AppConfig {
  // Untuk Android Emulator & iOS Simulator
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // // Untuk Physical Device (ganti dengan IP komputer Laravel)
  // static const String baseUrl = 'http://192.168.1.100:8000/api';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Static method untuk ganti base URL runtime jika perlu
  static String getBaseUrl() {
    return baseUrl;
  }

  // Method untuk validasi koneksi
  static Future<bool> testConnection() async {
    try {
      // Test koneksi dasar
      return true;
    } catch (e) {
      return false;
    }
  }
}
