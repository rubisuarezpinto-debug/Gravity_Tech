import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/models/product_model.dart';
import 'product_state.dart';
import 'product_event.dart';
import 'product_state.dart'; // ESTO ES OBLIGATORIO PARA QUE NO SALGA EL ERROR "NOT DEFINED"

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitialState()) {
    
    // Rutas de lectura
    on<LoadHomeProductsEvent>(_onLoadHomeProducts);
    on<LoadFilteredCatalogEvent>(_onLoadFilteredCatalog);

    // Rutas de escritura
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadHomeProducts(LoadHomeProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      final categorias = await _productRepository.fetchCategories();
      final destacados = await _productRepository.fetchProducts();
      emit(HomeProductsLoadedState(categories: categorias, featuredProducts: destacados));
    } catch (e) {
      emit(ProductErrorState(message: 'Error al cargar inventario: ${e.toString()}'));
    }
  }

  Future<void> _onLoadFilteredCatalog(LoadFilteredCatalogEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      final filtrados = await _productRepository.fetchFilteredCatalog(
        idCategoria: event.idCategoria,
        vBuscar: event.vBuscar,
      );
      emit(CatalogFilteredLoadedState(filteredProducts: filtrados));
    } catch (e) {
      emit(ProductErrorState(message: 'Error al filtrar: ${e.toString()}'));
    }
  }

  // Se eliminó 'const' de todos los 'emit' para evitar errores de compilación
  Future<void> _onCreateProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await _productRepository.createProduct(event.product);
      emit(ProductOperationSuccessState(message: "Producto creado exitosamente"));
      add(LoadHomeProductsEvent()); 
    } catch (e) {
      emit(ProductErrorState(message: 'Error al crear: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());
    try {
      await _productRepository.updateProduct(event.product);
      emit(ProductOperationSuccessState(message: "Producto actualizado"));
      add(LoadHomeProductsEvent());
    } catch (e) {
      emit(ProductErrorState(message: 'Error al actualizar: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    try {
      await _productRepository.deleteProduct(event.id);
      emit(ProductOperationSuccessState(message: "Producto eliminado"));
      add(LoadHomeProductsEvent());
    } catch (e) {
      emit(ProductErrorState(message: 'Error al eliminar: ${e.toString()}'));
    }
  }
}