// Asegúrate de que el nombre del archivo al final de esta línea coincida 
// con el nombre real de tu archivo en lib/data/models/
import 'package:mobile/data/models/product_model.dart'; 

abstract class CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final dynamic product;
  AddProductToCartEvent({required this.product});
}

class RemoveProductFromCartEvent extends CartEvent {
  final int productId;
  RemoveProductFromCartEvent({required this.productId});
}
class RemoveProductFromCart extends CartEvent {
  final ProductModel product;
  RemoveProductFromCart(this.product);
}