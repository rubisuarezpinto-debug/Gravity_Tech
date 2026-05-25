import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBase {
    if (kIsWeb) {
      // Release (Firebase) → Render; Debug (flutter run -d chrome) → localhost
      return kReleaseMode
          ? 'https://gravity-tech.onrender.com/api'
          : 'http://localhost:3000/api';
    }
    // Android emulator
    return 'http://10.0.2.2:3000/api';
  }
}
