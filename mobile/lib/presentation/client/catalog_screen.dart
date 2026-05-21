import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// OBLIGATORIO: Usa estas rutas exactas para asegurar que el compilador
// reconozca que son los mismos archivos que usas en el Bloc.
import 'package:mobile/logic/blocs/product/product_bloc.dart';
import 'package:mobile/logic/blocs/product/product_state.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
      ),
      // BlocBuilder ahora reconocerá los tipos porque los imports coinciden
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is CatalogFilteredLoadedState) {
            return ListView.builder(
              itemCount: state.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = state.filteredProducts[index];
                return ListTile(
                  title: Text(product.name ?? 'Producto'),
                  subtitle: Text('\$${product.price ?? 0}'),
                );
              },
            );
          }

          if (state is ProductErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('Selecciona una categoría'));
        },
      ),
    );
  }
}