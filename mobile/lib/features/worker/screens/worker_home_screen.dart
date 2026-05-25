import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/product_service.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/worker_bottom_nav.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  List<Map<String, dynamic>> _lowStock = [];
  int _totalProducts = 0;
  String _userName = '';
  bool _loading = true;
  String? _error;

  static const _lowStockThreshold = 5;

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
        _totalProducts = products.length;
        _lowStock = products
            .where((p) => (int.tryParse(p['stock']?.toString() ?? '') ?? 0) < _lowStockThreshold)
            .toList();
        _userName = user?['nombre'] as String? ?? 'Trabajador';
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
                      : RefreshIndicator(
                          onRefresh: _loadData,
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Panel Trabajador',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.white)),
                                        Text('Hola, $_userName',
                                            style: const TextStyle(fontSize: 12, color: AppColors.lavender)),
                                      ],
                                    ),
                                    _LogoutBtn(onTap: _logout),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                        child: GtStatCard(
                                            label: 'Productos',
                                            value: '$_totalProducts')),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: GtStatCard(
                                            label: 'Stock bajo',
                                            value: '${_lowStock.length}',
                                            valueColor: _lowStock.isNotEmpty ? AppColors.rose : null)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text('Alertas de inventario',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lavender)),
                                const SizedBox(height: 10),
                                if (_lowStock.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Sin alertas de inventario',
                                        style: TextStyle(fontSize: 13, color: AppColors.gray)),
                                  )
                                else
                                  ..._lowStock.map((p) => _StockAlertTile(product: p)),
                              ],
                            ),
                          ),
                        ),
            ),
            WorkerBottomNav(currentIndex: 0, onTap: (i) {
              if (i == 1) context.go('/worker/products');
              if (i == 2) context.go('/worker/profile');
            }),
          ],
        ),
      ),
    );
  }
}

class _StockAlertTile extends StatelessWidget {
  const _StockAlertTile({required this.product});
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    final name  = product['name'] as String? ?? '';
    final stock = int.tryParse(product['stock']?.toString() ?? '') ?? 0;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white)),
                Text('$stock unidades', style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x33d4537e),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x66d4537e)),
            ),
            child: Text(
              stock == 0 ? 'Sin stock' : 'Stock bajo',
              style: const TextStyle(fontSize: 10, color: AppColors.rose),
            ),
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
