import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
                            Text('Administrador',
                                style: TextStyle(fontSize: 12, color: AppColors.lavender)),
                            SizedBox(height: 2),
                            Text('Panel general',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ],
                        ),
                        _LogoutBtn(onTap: () => context.go('/login')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.0,
                      children: const [
                        GtStatCard(label: 'Ventas hoy', value: '\$4.2k', valueColor: AppColors.sky),
                        GtStatCard(label: 'Pedidos', value: '38'),
                        GtStatCard(label: 'Personal', value: '12'),
                        GtStatCard(label: 'Clientes', value: '284', valueColor: AppColors.rose),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Actividad reciente',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    _ActivityItem(color: AppColors.sky, text: 'Nuevo pedido #1042 — Cliente: Ana M.'),
                    _ActivityItem(color: AppColors.rose, text: 'Reabastecimiento solicitado'),
                    _ActivityItem(color: AppColors.lavender, text: 'Empleado Jorge agregado'),
                  ],
                ),
              ),
            ),
            AdminBottomNav(currentIndex: 0, onTap: (i) {
              if (i == 1) context.go('/admin/analytics');
              if (i == 2) context.go('/admin/staff');
            }),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.gray))),
        ],
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
