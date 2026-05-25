import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class ProductService {
  static String? _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('images.unsplash.com') && !url.contains('?')) {
      return '$url?w=600&q=80&auto=format&fit=crop';
    }
    return url;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final res = await http
        .get(Uri.parse('${AppConfig.apiBase}/products'), headers: await _authHeaders())
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return (body['products'] as List)
          .cast<Map<String, dynamic>>()
          .map((p) => {
                ...p,
                'image_url': _fixImageUrl(p['image_url'] as String?),
              })
          .toList();
    }
    throw Exception('Error al cargar productos');
  }

  static Future<Map<String, dynamic>> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
  }) async {
    final res = await http
        .post(
          Uri.parse('${AppConfig.apiBase}/products'),
          headers: await _authHeaders(),
          body: jsonEncode({
            'name': name,
            'description': description,
            'price': price,
            'stock': stock,
            'category_id': 1,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 201) return body['product'] as Map<String, dynamic>;
    throw Exception(body['error'] ?? body['message'] ?? body['errors']?.toString() ?? 'Error al crear producto');
  }

  static Future<void> deleteProduct(int id) async {
    final res = await http
        .delete(Uri.parse('${AppConfig.apiBase}/products/$id'), headers: await _authHeaders())
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw Exception(body['error'] ?? body['message'] ?? 'Error al eliminar producto');
    }
  }

  static Future<Map<String, dynamic>> updateStock(int id, int stock) async {
    final res = await http
        .put(
          Uri.parse('${AppConfig.apiBase}/products/$id'),
          headers: await _authHeaders(),
          body: jsonEncode({'stock': stock}),
        )
        .timeout(const Duration(seconds: 15));

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) return body['product'] as Map<String, dynamic>;
    throw Exception(body['error'] ?? body['message'] ?? 'Error al actualizar producto');
  }
}
