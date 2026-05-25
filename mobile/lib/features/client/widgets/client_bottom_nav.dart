import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ClientBottomNav extends StatelessWidget {
  const ClientBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Inicio'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Catálogo'),
    _NavItem(icon: Icons.shopping_cart_outlined, label: 'Carrito'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xE6080418),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.asMap().entries.map((e) {
          final active = e.key == currentIndex;
          return GestureDetector(
            onTap: () => onTap(e.key),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(e.value.icon,
                    size: 22, color: active ? AppColors.rose : AppColors.gray),
                const SizedBox(height: 3),
                Text(e.value.label,
                    style: TextStyle(
                        fontSize: 10,
                        color: active ? AppColors.rose : AppColors.gray)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
