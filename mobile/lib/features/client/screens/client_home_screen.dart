import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/product_service.dart';
import '../widgets/client_bottom_nav.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filtered = [];
  String _userName = '';
  bool _loading = true;
  String? _error;
  String _selectedCategory = 'Todo';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ProductService.getProducts(),
        AuthService.getUser(),
      ]);
      final products = results[0] as List<Map<String, dynamic>>;
      final user = results[1] as Map<String, dynamic>?;
      if (!mounted) return;
      setState(() {
        _products = products;
        _filtered = products;
        _userName = user?['nombre'] as String? ?? 'Usuario';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _filterByCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      _filtered = cat == 'Todo'
          ? _products
          : _products.where((p) => (p['category'] as String? ?? '') == cat).toList();
    });
  }

  List<String> get _categories {
    final cats = _products.map((p) => p['category'] as String? ?? '').where((c) => c.isNotEmpty).toSet().toList();
    return ['Todo', ...cats];
  }

  Future<void> _logout() async {
    await AuthService.clearSession();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.violet))
                  : _error != null
                      ? _ErrorView(message: _error!, onRetry: _loadData)
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Hola, $_userName',
                                          style: const TextStyle(fontSize: 12, color: AppColors.lavender)),
                                      const SizedBox(height: 2),
                                      const Text('¿Qué buscas hoy?',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                                    ],
                                  ),
                                  _LogoutBtn(onTap: _logout),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(height: 16),
                              const Text('Categorías',
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                              const SizedBox(height: 10),
                              _CategoryChips(
                                categories: _categories,
                                selected: _selectedCategory,
                                onSelect: _filterByCategory,
                              ),
                              const SizedBox(height: 16),
                              Text('Productos (${_filtered.length})',
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                              const SizedBox(height: 10),
                              _filtered.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Text('No hay productos disponibles',
                                            style: TextStyle(color: AppColors.gray, fontSize: 13)),
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 1.1,
                                      ),
                                      itemCount: _filtered.length,
                                      itemBuilder: (_, i) => _ProductCard(product: _filtered[i]),
                                    ),
                            ],
                          ),
                        ),
            ),
            ClientBottomNav(currentIndex: 0, onTap: (i) {
              if (i == 2) context.go('/client/cart');
            }),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final active = cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.purple : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: active ? null : Border.all(color: AppColors.border),
              ),
              child: Text(cat,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: active ? AppColors.white : AppColors.lavender)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? '';
    final price = product['price'];
    final stock = product['stock'] as int? ?? 0;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradientCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.devices_rounded, size: 28, color: AppColors.lavender),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.white)),
          Text('\$${price?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.rose)),
          if (stock == 0)
            const Text('Sin stock',
                style: TextStyle(fontSize: 10, color: AppColors.gray)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
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
            Text(message,
                textAlign: TextAlign.center,
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

class _LogoutBtn extends StatelessWidget {
  const _LogoutBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0x26d4537e),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x4Dd4537e)),
        ),
        child: const Row(
          children: [
            Icon(Icons.logout_rounded, size: 14, color: AppColors.rose),
            SizedBox(width: 4),
            Text('Salir', style: TextStyle(fontSize: 11, color: AppColors.rose)),
          ],
        ),
      ),
    );
  }
}
