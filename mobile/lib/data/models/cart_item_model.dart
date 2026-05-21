import 'product_model.dart';

class CartItem {
  final int idCarritoItem;
  final int idCarrito;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final String productName;
  final String? productImageUrl;

  CartItem({
    required this.idCarritoItem,
    required this.idCarrito,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.productName,
    this.productImageUrl,
  });

  // ✅ Conexión directa a las columnas de la consulta relacional de tu base de datos
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idCarritoItem: json['id_carrito_item'] ?? 0,
      idCarrito: json['id_carrito'] ?? 0,
      idProducto: json['id_producto'] ?? 0,
      cantidad: json['cantidad'] ?? 1,
// CAMBIA LA LÍNEA DEL PRECIO POR ESTA:
precioUnitario: double.tryParse(json['precio_unitario']?.toString() ?? '0.0') ?? 0.0,      productName: json['producto_nombre'] ?? json['nombre'] ?? 'Producto',
      productImageUrl: json['url'] ?? json['image_url'],
    );
  }
}