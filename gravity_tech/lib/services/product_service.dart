import 'api_client.dart';

class ProductService {
  // ── GET /products ──────────────────────────────────────────────────────────
  // Trae todos los productos (con paginación opcional)
  static Future<Map<String, dynamic>> getAll({int page = 1}) async {
    return await ApiClient.get('/products?page=$page');
  }

  // ── GET /products?category=id ──────────────────────────────────────────────
  // Filtra productos por categoría
  static Future<Map<String, dynamic>> getByCategory(String categoryId) async {
    return await ApiClient.get('/products?category=$categoryId');
  }

  // ── GET /products?search=texto ─────────────────────────────────────────────
  // Busca productos por nombre
  static Future<Map<String, dynamic>> search(String query) async {
    return await ApiClient.get('/products?search=$query');
  }

  // ── GET /products/low-stock ────────────────────────────────────────────────
  // Solo worker/admin — productos con stock bajo
  static Future<Map<String, dynamic>> getLowStock() async {
    return await ApiClient.get('/products/low-stock');
  }

  // ── GET /products/:id ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getById(String id) async {
    return await ApiClient.get('/products/$id');
  }

  // ── POST /products ─────────────────────────────────────────────────────────
  // Solo worker/admin — crea un producto
  static Future<Map<String, dynamic>> create({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    required int stock,
    required String imageUrl,
  }) async {
    return await ApiClient.post('/products', {
      'nombre':      name,
      'descripcion': description,
      'precio':      price,
      'categoriaId': categoryId,
      'stock':       stock,
      'imagen':      imageUrl,
    });
  }

  // ── PUT /products/:id ──────────────────────────────────────────────────────
  // Solo worker/admin — actualiza datos del producto
  static Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> fields) async {
    return await ApiClient.put('/products/$id', fields);
  }

  // ── PUT /products/:id/restock ──────────────────────────────────────────────
  // Solo worker/admin — agrega unidades al stock
  static Future<Map<String, dynamic>> restock(String id, int quantity) async {
    return await ApiClient.put('/products/$id/restock', {'cantidad': quantity});
  }

  // ── DELETE /products/:id ───────────────────────────────────────────────────
  // Solo worker/admin
  static Future<Map<String, dynamic>> delete(String id) async {
    return await ApiClient.delete('/products/$id');
  }
}