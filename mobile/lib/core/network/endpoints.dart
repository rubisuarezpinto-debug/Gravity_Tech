import 'package:flutter/foundation.dart';

class Endpoints {
 
static const String baseUrl = 'http://192.168.0.102:3000/api';
  // Rutas base
  static const String products = '/api/products';
  static const String auth = '$baseUrl/auth';
  static const String cart = '$baseUrl/cart';
  static const String orders = '$baseUrl/orders';
  static const String admin = '$baseUrl/admin';

  // Autenticación
  static const String authMe = '$baseUrl/auth/me';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // Productos
  static const String getproducts = '$baseUrl/products';
  static String productDetail(int id) => '$baseUrl/products/$id';

  // Carrito
  static String cartItem(int id) => '$baseUrl/cart/$id';

  // Órdenes / Pedidos
  static String orderDetail(int id) => '$baseUrl/orders/$id';
  static const String checkout = '$baseUrl/orders/checkout';

  // Reseñas
  static const String reviews = '$baseUrl/reviews';
  static String productReviews(int productId) => '$baseUrl/reviews/product/$productId';

  // Administración
  static const String adminUsers = '$baseUrl/admin/users';
  static const String adminOrders = '$baseUrl/admin/orders';
  static String adminOrderStatus(int id) => '$baseUrl/admin/orders/$id/status';
}