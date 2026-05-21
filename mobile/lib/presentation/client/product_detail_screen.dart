import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/models/product_model.dart';
import 'package:mobile/logic/blocs/cart/cart_bloc.dart';
import 'package:mobile/logic/blocs/cart/cart_event.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    print("DEBUG URL IMAGEN: '${product.imageUrl}'");
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Detalle'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: Image.network(
                product.imageUrl ?? '',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                // SOLUCIÓN AL ERROR DE IMAGEN:
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.white54)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Sin nombre',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(fontSize: 22, color: Colors.greenAccent),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description ?? 'No hay descripción disponible para este producto.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            context.read<CartBloc>().add(AddProductToCartEvent(product: product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} agregado al carrito')),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Agregar al Carrito', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}