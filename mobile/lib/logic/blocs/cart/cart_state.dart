import 'package:equatable/equatable.dart';

// Heredar de Equatable es vital para que BLoC sepa cuándo reconstruir la UI
class CartState extends Equatable {
  final List<dynamic> cartItems;
  final double total;

  const CartState({this.cartItems = const [], this.total = 0.0});

  @override
  List<Object> get props => [cartItems, total]; // Esto le dice a Flutter qué observar
}