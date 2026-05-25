import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBase {
    // Web (local con chrome o desplegado en Firebase) → siempre Render
    if (kIsWeb) {
      return 'https://gravity-tech.onrender.com/api';
    }
    // Android emulator
    return 'http://10.0.2.2:3000/api';
  }
}
