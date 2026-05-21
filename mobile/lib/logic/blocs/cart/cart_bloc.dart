import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';


class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    
    on<AddProductToCartEvent>((event, emit) {
      // 1. Crear nueva lista para que sea inmutable
      final List<dynamic> updatedList = List.from(state.cartItems);
      updatedList.add(event.product);

      // 2. Calcular total
      double newTotal = 0;
      for (var p in updatedList) {
        newTotal += double.parse(p.price.toString());
      }

      // 3. Emitir NUEVO ESTADO
      emit(CartState(cartItems: updatedList, total: newTotal));
    });
  }
}