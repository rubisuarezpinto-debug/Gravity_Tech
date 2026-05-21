import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/product_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  const ProductLoaded({required this.products});
  @override
  List<Object> get props => [products];
}

class CatalogFilteredLoadedState extends ProductState {
  final List<ProductModel> filteredProducts;
  const CatalogFilteredLoadedState({required this.filteredProducts});
  @override
  List<Object> get props => [filteredProducts];
}

class HomeProductsLoadedState extends ProductState {
  final List<Map<String, dynamic>> categories;
  final List<ProductModel> featuredProducts;
  const HomeProductsLoadedState({required this.categories, required this.featuredProducts});
  @override
  List<Object> get props => [categories, featuredProducts];
}

class ProductErrorState extends ProductState {
  final String message;
  const ProductErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
class ProductOperationSuccessState extends ProductState {
  final String message;
  const ProductOperationSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}