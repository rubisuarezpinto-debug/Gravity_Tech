import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/widgets/gt_button.dart';
import '../widgets/client_bottom_nav.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await CartService.getCart();
      if (!mounted) return;
      setState(() {
        _items = items;
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

  Future<void> _removeItem(int itemId) async {
    try {
      await CartService.removeItem(itemId);
      if (!mounted) return;
      setState(() => _items.removeWhere((i) => i['id'] == itemId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.rose,
        ),
      );
    }
  }

  double get _total =>
      _items.fold(0.0, (sum, item) => sum + (item['subtotal'] as num? ?? 0).toDouble());

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
                      ? _ErrorView(message: _error!, onRetry: _loadCart)
                      : RefreshIndicator(
                          onRefresh: _loadCart,
                          color: AppColors.violet,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Mi carrito',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white)),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        color: Color(0x33d4537e),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text('${_items.length}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.rose)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_items.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 32),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.shopping_cart_outlined,
                                              size: 48, color: AppColors.gray),
                                          SizedBox(height: 8),
                                          Text('Tu carrito está vacío',
                                              style: TextStyle(color: AppColors.gray, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  )
                                else ...[
                                  ..._items.map((item) => _CartItemTile(
                                        item: item,
                                        onRemove: () => _removeItem(item['id'] as int),
                                      )),
                                  const Divider(color: AppColors.border, height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total',
                                          style: TextStyle(fontSize: 13, color: AppColors.lavender)),
                                      Text('\$${_total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.white)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  GtButton(
                                    label: 'Proceder al pago',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Funcionalidad de pago próximamente'),
                                          backgroundColor: Color(0xFF4c2f9e),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
            ),
            ClientBottomNav(currentIndex: 2, onTap: (i) {
              switch (i) {
                case 0: context.go('/client/home');
                case 1: context.go('/client/catalog');
                case 3: context.go('/client/profile');
              }
            }),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item, required this.onRemove});
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final name = item['name'] as String? ?? '';
    final qty = item['quantity'] as int? ?? 1;
    final subtotal = (item['subtotal'] as num?)?.toDouble() ?? 0.0;

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
            child: const Icon(Icons.devices_rounded, size: 20, color: AppColors.lavender),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white)),
                Text('Cant: $qty', style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.rose)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.gray),
              ),
            ],
          ),
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
