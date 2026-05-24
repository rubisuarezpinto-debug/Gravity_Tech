import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiClient {
  static String? _token; // Se guarda tras el login

  // ── Guardar / limpiar token ────────────────────────────────────────────────
  static void setToken(String token) => _token = token;
  static void clearToken()           => _token = null;

  // ── Headers base ──────────────────────────────────────────────────────────
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ── GET ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final res  = await http.get(uri, headers: _headers)
        .timeout(ApiConfig.receiveTimeout);
    return _handle(res);
  }

  // ── POST ──────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final res  = await http
        .post(uri, headers: _headers, body: jsonEncode(body))
        .timeout(ApiConfig.receiveTimeout);
    return _handle(res);
  }

  // ── PUT ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final res  = await http
        .put(uri, headers: _headers, body: jsonEncode(body))
        .timeout(ApiConfig.receiveTimeout);
    return _handle(res);
  }

  // ── DELETE ────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final res  = await http.delete(uri, headers: _headers)
        .timeout(ApiConfig.receiveTimeout);
    return _handle(res);
  }

  // ── Manejo de respuesta ────────────────────────────────────────────────────
  static Map<String, dynamic> _handle(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    }
    // Lanza el mensaje de error que devuelve el servidor
    throw ApiException(
      statusCode: res.statusCode,
      message: body['message'] ?? 'Error desconocido',
    );
  }
}

// ── Excepción personalizada ────────────────────────────────────────────────────
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException [$statusCode]: $message';
}