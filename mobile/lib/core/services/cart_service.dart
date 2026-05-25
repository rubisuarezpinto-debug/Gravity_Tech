import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class CartService {
  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Retorna lista de items: { id, quantity, product_id, name, price, image_url, subtotal }
  static Future<List<Map<String, dynamic>>> getCart() async {
    final res = await http
        .get(Uri.parse('${AppConfig.apiBase}/cart'), headers: await _authHeaders())
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return (body['items'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Error al cargar el carrito');
  }

  static Future<void> removeItem(int itemId) async {
    final res = await http
        .delete(Uri.parse('${AppConfig.apiBase}/cart/$itemId'), headers: await _authHeaders())
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception('Error al eliminar item del carrito');
    }
  }
}
