import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/product/product_bloc.dart';
import '../../logic/blocs/product/product_event.dart';
import '../../logic/blocs/product/product_state.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _baseUrl = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    // Disparamos el evento inicial
    context.read<ProductBloc>().add(LoadHomeProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("GRAVITY TECH", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          // Manejo de estado de carga
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)));
          }

          // Definición de variables locales para la UI
          List products = [];
          List categories = [];

          // Actualizamos según el estado
          if (state is HomeProductsLoadedState) {
            products = state.featuredProducts;
            categories = state.categories;
          } else if (state is CatalogFilteredLoadedState) {
            products = state.filteredProducts;
          } else if (state is ProductErrorState) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
          }

          return CustomScrollView(
            slivers: [
              _buildSearchBar(),
              if (categories.isNotEmpty) _buildCategories(categories),
              _buildProductGrid(products),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextField(
            onChanged: (val) {
              // Si el campo está vacío, recargamos el home, si no, filtramos
              if (val.isEmpty) {
                context.read<ProductBloc>().add(LoadHomeProductsEvent());
              } else {
                context.read<ProductBloc>().add(LoadFilteredCatalogEvent(vBuscar: val));
              }
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Buscar productos...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE040FB)),
              filled: true,
              fillColor: const Color(0xFF1C1F2E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
      );

  Widget _buildCategories(List categories) => SliverToBoxAdapter(
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FilterChip(
                backgroundColor: const Color(0xFF1C1F2E),
                selectedColor: const Color(0xFFE040FB),
                label: Text(categories[i]['nombre'] ?? 'Cat', style: const TextStyle(color: Colors.white)),
                onSelected: (_) => context.read<ProductBloc>().add(
                    LoadFilteredCatalogEvent(idCategoria: categories[i]['id_categoria'])),
              ),
            ),
          ),
        ),
      );

  Widget _buildProductGrid(List products) {
    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text("No se encontraron productos", style: TextStyle(color: Colors.white54))),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          final prod = products[i];
          final imgUrl = prod.imageUrl != null ? _baseUrl + prod.imageUrl! : null;

          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: prod))),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF1C1F2E), borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: imgUrl != null
                          ? Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity,
                              errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey))
                          : const Icon(Icons.image, color: Colors.white24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(prod.name, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis),
                        Text("\$${prod.price}", style: const TextStyle(color: Color(0xFFE040FB), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }, childCount: products.length),
      ),
    );
  }
}