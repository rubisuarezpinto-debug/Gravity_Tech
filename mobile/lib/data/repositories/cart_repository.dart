import 'package:dio/dio.dart';
import '../../core/network/endpoints.dart';
import '../../data/api_config.dart';

class CartRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  // Obtener carrito
  Future<List<dynamic>> fetchCart() async {
    final response = await _dio.get(Endpoints.cart);
    return response.data is List ? response.data : [];
  }

  // Añadir producto (usa product_id como espera tu backend)
  Future<void> addItem(int productId, int quantity) async {
    await _dio.post(Endpoints.cart, data: {
      'product_id': productId,
      'quantity': quantity,
    });
  }

  // Actualizar cantidad
  Future<void> updateItem(int itemId, int quantity) async {
    await _dio.put('${Endpoints.cart}/$itemId', data: {'quantity': quantity});
  }

  // Eliminar item
  Future<void> removeItem(int itemId) async {
    await _dio.delete('${Endpoints.cart}/$itemId');
  }
}