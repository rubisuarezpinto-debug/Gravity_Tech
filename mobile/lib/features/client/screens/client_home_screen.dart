import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/client_bottom_nav.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Hola, María 👋',
                                style: TextStyle(fontSize: 12, color: AppColors.lavender)),
                            SizedBox(height: 2),
                            Text('¿Qué buscas hoy?',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ],
                        ),
                        Row(
                          children: [
                            _IconBtn(icon: Icons.notifications_none_rounded, onTap: () {}),
                            const SizedBox(width: 8),
                            _LogoutBtn(onTap: () => context.go('/login')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SearchBar(),
                    const SizedBox(height: 16),
                    const Text('Categorías',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    _CategoryChips(),
                    const SizedBox(height: 16),
                    const Text('Destacados',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    _ProductsGrid(),
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

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, color: AppColors.lavender, size: 18),
          SizedBox(width: 10),
          Text('Buscar productos...', style: TextStyle(color: AppColors.gray, fontSize: 13)),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<String> _cats = const ['Todo', 'Electrónica', 'Audio', 'Accesorios'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _cats.asMap().entries.map((e) {
          final active = e.key == 0;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.purple : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: active ? null : Border.all(color: AppColors.border),
            ),
            child: Text(e.value,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: active ? AppColors.white : AppColors.lavender)),
          );
        }).toList(),
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<_ProductData> _products = const [
    _ProductData('Audífonos Pro', '\$89.99', Icons.headphones_rounded),
    _ProductData('Smartwatch X', '\$149.99', Icons.watch_rounded),
    _ProductData('Cable USB-C', '\$12.99', Icons.usb_rounded),
    _ProductData('Mouse Inalámbrico', '\$45.99', Icons.mouse_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: _products.map((p) => _ProductCard(data: p)).toList(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.data});
  final _ProductData data;

  @override
  Widget build(BuildContext context) {
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
              child: Center(child: Icon(data.icon, size: 28, color: AppColors.lavender)),
            ),
          ),
          const SizedBox(height: 8),
          Text(data.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.white)),
          Text(data.price, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.rose)),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: AppColors.lavender),
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
        child: Row(
          children: const [
            Icon(Icons.logout_rounded, size: 14, color: AppColors.rose),
            SizedBox(width: 4),
            Text('Salir', style: TextStyle(fontSize: 11, color: AppColors.rose)),
          ],
        ),
      ),
    );
  }
}

class _ProductData {
  const _ProductData(this.name, this.price, this.icon);
  final String name;
  final String price;
  final IconData icon;
}
