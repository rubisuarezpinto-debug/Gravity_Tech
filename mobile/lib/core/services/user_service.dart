import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class UserService {
  // Solo accesible por administradores. Retorna { id, name, email, role }
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final token = await AuthService.getToken();
    final res = await http
        .get(
          Uri.parse('${AppConfig.apiBase}/admin/users'),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return (body['users'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Error al cargar usuarios');
  }
}
