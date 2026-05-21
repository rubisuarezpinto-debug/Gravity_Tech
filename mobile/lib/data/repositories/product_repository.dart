import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../core/network/endpoints.dart';
import '../../data/api_config.dart';

class ProductRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // Método auxiliar para parsear respuestas
  List<T> _parseResponse<T>(dynamic responseData, T Function(Map<String, dynamic>) fromJson) {
    // Tu backend suele envolver listas en 'o_datos'
    final data = (responseData is Map && responseData.containsKey('o_datos')) 
        ? responseData['o_datos'] 
        : responseData;
    
    if (data is List) {
      return data.map((json) => fromJson(json)).toList();
    }
    return [];
  }

  // --- GETTERS ---
  
  // Categorías
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await _dio.get('${Endpoints.products}/categorias');
    return List<Map<String, dynamic>>.from(response.data['o_datos'] ?? []);
  }

  // Catálogo (Destacados y General)
  Future<List<ProductModel>> fetchProducts() async {
    Future<List<ProductModel>> fetchProducts() async {
  try {
    final response = await _dio.get(Endpoints.products);
    print("DATOS RECIBIDOS EN APP: ${response.data}"); // Verifica si llega el JSON aquí
    return _parseResponse(response.data, (json) => ProductModel.fromJson(json));
  } catch (e) {
    print("--- ERROR CRÍTICO EN FLUTTER ---");
    print(e); // Esto nos dirá si es "Connection refused", "Timeout", o "404"
    rethrow;
  }
}
    final response = await _dio.get(Endpoints.products); 
    return _parseResponse(response.data, (json) => ProductModel.fromJson(json));
    
  }

  // Filtrado
  Future<List<ProductModel>> fetchFilteredCatalog({int? idCategoria, String? vBuscar}) async {
    final response = await _dio.get(
      Endpoints.products, 
      queryParameters: {
        'id_categoria': idCategoria,
        'v_buscar': vBuscar,
      },
    );
    return _parseResponse(response.data, (json) => ProductModel.fromJson(json));
  }

  // --- CRUD (Escritura) ---

  Future<void> createProduct(ProductModel product) async {
    // Recuerda que en tu router configuramos '/crear' como ruta dentro de /products
    await _dio.post('${Endpoints.products}/crear', data: product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _dio.put('${Endpoints.products}/actualizar/${product.id}', data: product.toJson());
  }

  Future<void> deleteProduct(int id) async {
    await _dio.delete('${Endpoints.products}/eliminar/$id');
  }
}