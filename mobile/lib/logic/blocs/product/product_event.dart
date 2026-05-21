import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart'; // <--- AGREGA ESTO
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Evento para cargar el Home (Trae categorías y productos destacados)
class LoadHomeProductsEvent extends ProductEvent {}

// Evento para buscar o filtrar en el catálogo
class LoadFilteredCatalogEvent extends ProductEvent {
  final int? idCategoria;
  final String? vBuscar;

  const LoadFilteredCatalogEvent({this.idCategoria, this.vBuscar});

  @override
  List<Object?> get props => [idCategoria, vBuscar];
}


//
class CreateProductEvent extends ProductEvent { final ProductModel product; CreateProductEvent(this.product); }
class UpdateProductEvent extends ProductEvent { final ProductModel product; UpdateProductEvent(this.product); }
class DeleteProductEvent extends ProductEvent { 
  final int id; 
  // Agregamos las llaves {} para hacerlo un parámetro nombrado
  const DeleteProductEvent({required this.id}); 
}
