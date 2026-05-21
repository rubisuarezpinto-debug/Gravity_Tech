import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/product/product_bloc.dart';
import '../../logic/blocs/product/product_event.dart';
import '../../logic/blocs/product/product_state.dart';
import 'worker_product_form_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadHomeProductsEvent());

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(title: const Text("Inventario"), backgroundColor: Colors.transparent),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) return const Center(child: CircularProgressIndicator());
          
          if (state is HomeProductsLoadedState) {
            final products = state.featuredProducts;
            final criticalCount = products.where((p) => p.stock <= 5).length;

            return Column(
              children: [
                _buildMetricCard(products.length, criticalCount),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, i) {
                      final prod = products[i];
                      final isCritical = prod.stock <= 5;
                      
                      return ListTile(
                        // AQUÍ ESTABA EL ERROR: Cambiamos .nombre por .name
                        title: Text(prod.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Stock: ${prod.stock}", 
                          style: TextStyle(color: isCritical ? Colors.redAccent : Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => Navigator.push(context, 
                            MaterialPageRoute(builder: (_) => WorkerProductFormScreen(product: prod))),
                        ),
                        leading: isCritical ? const Icon(Icons.warning, color: Colors.redAccent) : null,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProductFormScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ... _buildMetricCard e _infoBox se mantienen igual
  Widget _buildMetricCard(int total, int critical) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(child: _infoBox("Total", "$total", Colors.white)),
        const SizedBox(width: 10),
        Expanded(child: _infoBox("Crítico", "$critical", Colors.redAccent)),
      ],
    ),
  );

  Widget _infoBox(String title, String value, Color color) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
    child: Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}