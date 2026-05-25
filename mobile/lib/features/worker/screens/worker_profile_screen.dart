import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/product_service.dart';
import '../widgets/worker_bottom_nav.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  Map<String, dynamic>? _user;
  int _totalProducts = 0;
  int _lowStockCount = 0;
  bool _loading = true;

  static const _lowStockThreshold = 5;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        AuthService.getUser(),
        ProductService.getProducts(),
      ]);
      final user = results[0] as Map<String, dynamic>?;
      final products = results[1] as List<Map<String, dynamic>>;
      if (!mounted) return;
      setState(() {
        _user = user;
        _totalProducts = products.length;
        _lowStockCount = products
            .where((p) => (int.tryParse(p['stock']?.toString() ?? '') ?? 0) < _lowStockThreshold)
            .length;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final user = await AuthService.getUser();
      if (!mounted) return;
      setState(() {
        _user = user;
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
    final nombre   = _user?['nombre']   as String? ?? 'Empleado';
    final email    = _user?['email']    as String? ?? '';
    final telefono = _user?['telefono'] as String?;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.violet))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mi perfil',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
                          const SizedBox(height: 24),

                          // Avatar
                          Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientCard,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.violet, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  nombre.isNotEmpty ? nombre[0].toUpperCase() : 'E',
                                  style: const TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(nombre,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.violet.withAlpha(50),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.violet.withAlpha(100)),
                              ),
                              child: const Text('Empleado',
                                  style: TextStyle(fontSize: 11, color: AppColors.lavender)),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Stats
                          Row(
                            children: [
                              Expanded(
                                child: _StatBox(
                                  label: 'Productos',
                                  value: '$_totalProducts',
                                  icon: Icons.inventory_2_outlined,
                                  color: AppColors.lavender,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StatBox(
                                  label: 'Stock bajo',
                                  value: '$_lowStockCount',
                                  icon: Icons.warning_amber_rounded,
                                  color: _lowStockCount > 0 ? AppColors.rose : AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Info
                          _InfoCard(children: [
                            _InfoRow(
                                icon: Icons.mail_outline_rounded,
                                label: 'Correo',
                                value: email),
                            if (telefono != null && telefono.isNotEmpty)
                              _InfoRow(
                                  icon: Icons.phone_outlined,
                                  label: 'Teléfono',
                                  value: telefono),
                            _InfoRow(
                                icon: Icons.badge_outlined,
                                label: 'Rol',
                                value: 'Empleado'),
                          ]),
                          const SizedBox(height: 20),

                          // Accesos rápidos
                          _QuickAction(
                            icon: Icons.inventory_2_outlined,
                            label: 'Gestionar productos',
                            color: AppColors.violet,
                            onTap: () => context.go('/worker/products'),
                          ),
                          const SizedBox(height: 10),

                          // Cerrar sesión
                          GestureDetector(
                            onTap: _logout,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0x26d4537e),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0x66d4537e)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout_rounded, size: 16, color: AppColors.rose),
                                  SizedBox(width: 8),
                                  Text('Cerrar sesión',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.rose)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            WorkerBottomNav(
              currentIndex: 2,
              onTap: (i) {
                if (i == 0) context.go('/worker/home');
                if (i == 1) context.go('/worker/products');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.white)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map((e) => Column(
                  children: [
                    e.value,
                    if (e.key < children.length - 1)
                      const Divider(height: 1, color: Color(0xFF1e2d4a)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.lavender),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontSize: 12, color: AppColors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
