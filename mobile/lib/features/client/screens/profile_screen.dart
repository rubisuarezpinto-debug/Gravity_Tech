import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../widgets/client_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getUser();
    if (!mounted) return;
    setState(() => _user = user);
  }

  Future<void> _logout() async {
    await AuthService.clearSession();
    if (!mounted) return;
    context.go('/login');
  }

  void _onNavTap(int i) {
    switch (i) {
      case 0: context.go('/client/home');
      case 1: context.go('/client/catalog');
      case 2: context.go('/client/cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre   = _user?['nombre']   as String? ?? 'Usuario';
    final email    = _user?['email']    as String? ?? '';
    final rol      = _user?['rol']      as String? ?? 'cliente';
    final telefono = _user?['telefono'] as String?;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(nombre,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purple.withAlpha(100)),
                        ),
                        child: Text(rol,
                            style: const TextStyle(fontSize: 11, color: AppColors.lavender)),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Info
                    _InfoCard(children: [
                      _InfoRow(icon: Icons.mail_outline_rounded, label: 'Correo', value: email),
                      if (telefono != null && telefono.isNotEmpty)
                        _InfoRow(icon: Icons.phone_outlined, label: 'Teléfono', value: telefono),
                      _InfoRow(icon: Icons.verified_user_outlined, label: 'Rol', value: rol),
                    ]),
                    const SizedBox(height: 20),

                    // Logout
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
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.rose)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClientBottomNav(currentIndex: 3, onTap: _onNavTap),
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
