import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../widgets/client_bottom_nav.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const _items = [
    _CartItem('Audífonos Pro', 1, '\$89.99', Icons.headphones_rounded),
    _CartItem('Smartwatch X', 1, '\$149.99', Icons.watch_rounded),
    _CartItem('Cable USB-C', 2, '\$24.99', Icons.usb_rounded),
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
                        const Text('Mi carrito',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0x33d4537e),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.rose)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._items.map((item) => _CartItemTile(item: item)),
                    const Divider(color: AppColors.border, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Total', style: TextStyle(fontSize: 13, color: AppColors.lavender)),
                        Text('\$264.97',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GtButton(label: 'Proceder al pago', onTap: () {}),
                  ],
                ),
              ),
            ),
            ClientBottomNav(currentIndex: 2, onTap: (i) {
              if (i == 0) context.go('/client/home');
            }),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});
  final _CartItem item;

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.gradientCard,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 20, color: AppColors.lavender),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white)),
                Text('Cant: ${item.qty}',
                    style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          Text(item.price,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.rose)),
        ],
      ),
    );
  }
}

class _CartItem {
  const _CartItem(this.name, this.qty, this.price, this.icon);
  final String name;
  final int qty;
  final String price;
  final IconData icon;
}
