import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../../../core/services/cart_service.dart';
import '../widgets/client_bottom_nav.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_applySearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final products = await ProductService.getProducts();
      if (!mounted) return;
      setState(() { _products = products; _filtered = products; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  void _applySearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _products
          : _products.where((p) {
              final name = (p['name'] as String? ?? '').toLowerCase();
              final cat  = (p['category'] as String? ?? '').toLowerCase();
              return name.contains(q) || cat.contains(q);
            }).toList();
    });
  }

  void _addToCart(Map<String, dynamic> product) async {
    final id = product['id'] as int?;
    if (id == null) return;
    try {
      await CartService.addItem(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${product['name']} agregado al carrito'),
        backgroundColor: AppColors.purple,
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.rose,
      ));
    }
  }

  void _onNavTap(int i) {
    switch (i) {
      case 0: context.go('/client/home');
      case 2: context.go('/client/cart');
      case 3: context.go('/client/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Catálogo',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            style: const TextStyle(fontSize: 13, color: AppColors.white),
                            decoration: const InputDecoration(
                              hintText: 'Buscar producto...',
                              hintStyle: TextStyle(fontSize: 13, color: AppColors.gray),
                              prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.gray),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.violet))
                        : _error != null
                            ? _RetryView(message: _error!, onRetry: _load)
                            : _filtered.isEmpty
                                ? const Center(
                                    child: Text('Sin resultados',
                                        style: TextStyle(color: AppColors.gray, fontSize: 13)))
                                : RefreshIndicator(
                                    onRefresh: _load,
                                    color: AppColors.violet,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                      itemCount: _filtered.length,
                                      itemBuilder: (_, i) => _CatalogTile(
                                        product: _filtered[i],
                                        onAddToCart: () => _addToCart(_filtered[i]),
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
            ClientBottomNav(currentIndex: 1, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.product, required this.onAddToCart});
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final name     = product['name']     as String? ?? '';
    final price    = double.tryParse(product['price']?.toString() ?? '') ?? 0.0;
    final category = product['category'] as String? ?? '';
    final stock    = int.tryParse(product['stock']?.toString() ?? '') ?? 0;
    final imageUrl = product['image_url'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(_resolveImageUrl(imageUrl), fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => _IconBox())
                  : _IconBox(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.rose)),
              const SizedBox(height: 6),
              if (stock > 0)
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Agregar', style: TextStyle(fontSize: 10, color: AppColors.white)),
                  ),
                )
              else
                const Text('Agotado', style: TextStyle(fontSize: 10, color: AppColors.gray)),
            ],
          ),
        ],
      ),
    );
  }
}

String _resolveImageUrl(String url) {
  if (url.contains('images.unsplash.com') && !url.contains('?')) {
    return '$url?w=200&q=80&auto=format&fit=crop';
  }
  return url;
}

class _IconBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1a1f3a),
      child: const Center(child: Icon(Icons.devices_rounded, size: 24, color: AppColors.lavender)),
    );
  }
}

class _RetryView extends StatelessWidget {
  const _RetryView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.gray),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.gray, fontSize: 13)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text('Reintentar', style: TextStyle(color: AppColors.lavender, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
