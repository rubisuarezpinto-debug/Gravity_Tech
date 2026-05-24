import 'api_client.dart';

// ════════════════════════════════════════════════════════════════════════════
//  CATEGORÍAS
// ════════════════════════════════════════════════════════════════════════════
class CategoryService {
  // GET /categories
  static Future<Map<String, dynamic>> getAll() async =>
      await ApiClient.get('/categories');

  // GET /categories/:id
  static Future<Map<String, dynamic>> getById(String id) async =>
      await ApiClient.get('/categories/$id');

  // POST /categories  (admin)
  static Future<Map<String, dynamic>> create(String name) async =>
      await ApiClient.post('/categories', {'nombre': name});

  // PUT /categories/:id  (admin)
  static Future<Map<String, dynamic>> update(String id, String name) async =>
      await ApiClient.put('/categories/$id', {'nombre': name});

  // DELETE /categories/:id  (admin)
  static Future<Map<String, dynamic>> delete(String id) async =>
      await ApiClient.delete('/categories/$id');
}

// ════════════════════════════════════════════════════════════════════════════
//  CARRITO
// ════════════════════════════════════════════════════════════════════════════
class CartService {
  // GET /cart
  static Future<Map<String, dynamic>> getCart() async =>
      await ApiClient.get('/cart');

  // POST /cart/add
  static Future<Map<String, dynamic>> addItem({
    required String productId,
    required int quantity,
  }) async =>
      await ApiClient.post('/cart/add', {
        'productoId': productId,
        'cantidad':   quantity,
      });

  // PUT /cart/update
  static Future<Map<String, dynamic>> updateItem({
    required String itemId,
    required int quantity,
  }) async =>
      await ApiClient.put('/cart/update', {
        'itemId':   itemId,
        'cantidad': quantity,
      });

  // DELETE /cart/remove/:itemId
  static Future<Map<String, dynamic>> removeItem(String itemId) async =>
      await ApiClient.delete('/cart/remove/$itemId');
}

// ════════════════════════════════════════════════════════════════════════════
//  ÓRDENES
// ════════════════════════════════════════════════════════════════════════════
class OrderService {
  // POST /orders/checkout — crea el pedido y vacía el carrito
  static Future<Map<String, dynamic>> checkout(
      Map<String, dynamic> cartData) async =>
      await ApiClient.post('/orders/checkout', cartData);

  // GET /orders/my-orders
  static Future<Map<String, dynamic>> myOrders() async =>
      await ApiClient.get('/orders/my-orders');

  // PUT /orders/:id/status  (worker/admin)
  static Future<Map<String, dynamic>> changeStatus(
      String orderId, String status) async =>
      await ApiClient.put('/orders/$orderId/status', {'estado': status});
}

// ════════════════════════════════════════════════════════════════════════════
//  STAFF  (solo admin)
// ════════════════════════════════════════════════════════════════════════════
class StaffService {
  // GET /staff
  static Future<Map<String, dynamic>> getAll() async =>
      await ApiClient.get('/staff');

  // POST /staff
  static Future<Map<String, dynamic>> create({
    required String name,
    required String email,
    required String role,
  }) async =>
      await ApiClient.post('/staff', {
        'nombre': name,
        'correo': email,
        'rol':    role,
      });

  // PUT /staff/:id
  static Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> fields) async =>
      await ApiClient.put('/staff/$id', fields);

  // DELETE /staff/:id
  static Future<Map<String, dynamic>> delete(String id) async =>
      await ApiClient.delete('/staff/$id');
}

// ════════════════════════════════════════════════════════════════════════════
//  ANALYTICS  (solo admin)
// ════════════════════════════════════════════════════════════════════════════
class AnalyticsService {
  // GET /analytics/summary — ventas del día, pedidos, clientes, empleados
  static Future<Map<String, dynamic>> getSummary() async =>
      await ApiClient.get('/analytics/summary');

  // GET /analytics/sales?range=weekly
  static Future<Map<String, dynamic>> getWeeklySales() async =>
      await ApiClient.get('/analytics/sales?range=weekly');

  // GET /analytics/sales?range=monthly
  static Future<Map<String, dynamic>> getMonthlySales() async =>
      await ApiClient.get('/analytics/sales?range=monthly');

  // GET /analytics/top-products
  static Future<Map<String, dynamic>> getTopProducts() async =>
      await ApiClient.get('/analytics/top-products');
}

// ════════════════════════════════════════════════════════════════════════════
//  FAVORITOS
// ════════════════════════════════════════════════════════════════════════════
class FavoriteService {
  // GET /favorites
  static Future<Map<String, dynamic>> getAll() async =>
      await ApiClient.get('/favorites');

  // POST /favorites
  static Future<Map<String, dynamic>> add(String productId) async =>
      await ApiClient.post('/favorites', {'productoId': productId});

  // DELETE /favorites/:id
  static Future<Map<String, dynamic>> remove(String favoriteId) async =>
      await ApiClient.delete('/favorites/$favoriteId');
}

// ════════════════════════════════════════════════════════════════════════════
//  RESEÑAS
// ════════════════════════════════════════════════════════════════════════════
class ReviewService {
  // GET /reviews/product/:productId
  static Future<Map<String, dynamic>> getByProduct(String productId) async =>
      await ApiClient.get('/reviews/product/$productId');

  // POST /reviews
  static Future<Map<String, dynamic>> create({
    required String productId,
    required int rating,
    required String comment,
  }) async =>
      await ApiClient.post('/reviews', {
        'productoId': productId,
        'calificacion': rating,
        'comentario':   comment,
      });

  // DELETE /reviews/:id
  static Future<Map<String, dynamic>> delete(String reviewId) async =>
      await ApiClient.delete('/reviews/$reviewId');
}

// ════════════════════════════════════════════════════════════════════════════
//  DIRECCIONES
// ════════════════════════════════════════════════════════════════════════════
class AddressService {
  // GET /addresses
  static Future<Map<String, dynamic>> getAll() async =>
      await ApiClient.get('/addresses');

  // POST /addresses
  static Future<Map<String, dynamic>> add(Map<String, dynamic> address) async =>
      await ApiClient.post('/addresses', address);

  // PUT /addresses/:id
  static Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> address) async =>
      await ApiClient.put('/addresses/$id', address);

  // DELETE /addresses/:id
  static Future<Map<String, dynamic>> delete(String id) async =>
      await ApiClient.delete('/addresses/$id');
}

// ════════════════════════════════════════════════════════════════════════════
//  USUARIO
// ════════════════════════════════════════════════════════════════════════════
class UserService {
  // GET /users/profile
  static Future<Map<String, dynamic>> getProfile() async =>
      await ApiClient.get('/users/profile');

  // PUT /users/profile
  static Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async =>
      await ApiClient.put('/users/profile', data);

  // PUT /users/change-password
  static Future<Map<String, dynamic>> changePassword({
    required String current,
    required String newPass,
  }) async =>
      await ApiClient.put('/users/change-password', {
        'contrasena_actual': current,
        'nueva_contrasena':  newPass,
      });
}