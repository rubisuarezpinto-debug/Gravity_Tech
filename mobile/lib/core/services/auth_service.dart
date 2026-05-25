import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Retorna el usuario autenticado. Lanza Exception con mensaje si falla.
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http
        .post(
          Uri.parse('${AppConfig.apiBase}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 15));

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && body['success'] == true) {
      final data = body['data'] as Map<String, dynamic>;
      await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
      return data['user'] as Map<String, dynamic>;
    }
    throw Exception(body['error'] ?? 'Error al iniciar sesión');
  }

  // Retorna el usuario creado. Lanza Exception con mensaje si falla.
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final res = await http
        .post(
          Uri.parse('${AppConfig.apiBase}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name, 'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 15));

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 201 && body['success'] == true) {
      final data = body['data'] as Map<String, dynamic>;
      await _saveSession(data['token'] as String, data['user'] as Map<String, dynamic>);
      return data['user'] as Map<String, dynamic>;
    }
    throw Exception(body['error'] ?? 'Error al registrarse');
  }
}
