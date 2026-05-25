import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  static const _bars = [
    _BarData('L', 0.55, AppColors.violet),
    _BarData('M', 0.75, AppColors.violet),
    _BarData('X', 0.45, AppColors.violet),
    _BarData('J', 0.85, AppColors.pink),
    _BarData('V', 1.00, AppColors.pink),
    _BarData('S', 0.70, AppColors.blue),
    _BarData('D', 0.35, AppColors.blue),
  ];

  static const _topProducts = [
    _TopProduct('Audífonos Pro', '128 uds'),
    _TopProduct('Smartwatch X', '94 uds'),
    _TopProduct('Cable HDMI 4K', '76 uds'),
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
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/admin/home'),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16, color: AppColors.lavender),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text('Analítica de ventas',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: GtStatCard(label: 'Este mes', value: '\$28k', valueColor: AppColors.sky)),
                        SizedBox(width: 10),
                        Expanded(child: GtStatCard(label: 'Crecimiento', value: '+14%', valueColor: AppColors.rose)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ventas semanales',
                              style: TextStyle(fontSize: 11, color: AppColors.lavender)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: _bars.map((b) => _Bar(data: b)).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Productos más vendidos',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    ..._topProducts.map((p) => _TopProductRow(product: p)),
                  ],
                ),
              ),
            ),
            AdminBottomNav(currentIndex: 1, onTap: (i) {
              if (i == 0) context.go('/admin/home');
              if (i == 2) context.go('/admin/staff');
            }),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.data});
  final _BarData data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: FractionallySizedBox(
              heightFactor: data.height,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(data.day, style: const TextStyle(fontSize: 10, color: AppColors.gray)),
        ],
      ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  const _TopProductRow({required this.product});
  final _TopProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(product.name, style: const TextStyle(fontSize: 12, color: AppColors.gray)),
          Text(product.units, style: const TextStyle(fontSize: 12, color: AppColors.sky)),
        ],
      ),
    );
  }
}

class _BarData {
  const _BarData(this.day, this.height, this.color);
  final String day;
  final double height;
  final Color color;
}

class _TopProduct {
  const _TopProduct(this.name, this.units);
  final String name;
  final String units;
}
