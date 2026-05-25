import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/worker_bottom_nav.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  static const _alerts = [
    _StockAlert('Audífonos Pro', '2 unidades'),
    _StockAlert('Cable HDMI 4K', '1 unidad'),
    _StockAlert('Cargador Inalámbrico', '3 unidades'),
  ];

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
                        const Text('Panel Trabajador',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
                        _LogoutBtn(onTap: () => context.go('/login')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: GtStatCard(label: 'Productos', value: '142')),
                        const SizedBox(width: 10),
                        Expanded(child: GtStatCard(label: 'Stock bajo', value: '8', valueColor: AppColors.rose)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Alertas de inventario',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    ..._alerts.map((a) => _StockAlertTile(alert: a)),
                  ],
                ),
              ),
            ),
            WorkerBottomNav(currentIndex: 0, onTap: (i) {
              if (i == 1) context.go('/worker/products');
            }),
          ],
        ),
      ),
    );
  }
}

class _StockAlertTile extends StatelessWidget {
  const _StockAlertTile({required this.alert});
  final _StockAlert alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white)),
              Text(alert.qty, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x33d4537e),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x66d4537e)),
            ),
            child: const Text('Stock bajo', style: TextStyle(fontSize: 10, color: AppColors.rose)),
          ),
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

class _StockAlert {
  const _StockAlert(this.name, this.qty);
  final String name;
  final String qty;
}
