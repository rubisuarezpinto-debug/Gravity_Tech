import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/user_service.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({super.key});

  @override
  State<AdminStaffScreen> createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await UserService.getUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
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

  List<Map<String, dynamic>> get _staff =>
      _users.where((u) => u['role'] == 'trabajador' || u['role'] == 'administrador').toList();

  List<Map<String, dynamic>> get _clients =>
      _users.where((u) => u['role'] == 'cliente').toList();

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'administrador':
        return 'Administrador';
      case 'trabajador':
        return 'Trabajador';
      default:
        return 'Cliente';
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'administrador':
        return AppColors.rose;
      case 'trabajador':
        return AppColors.lavender;
      default:
        return AppColors.sky;
    }
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
                      ? _ErrorView(message: _error!, onRetry: _loadUsers)
                      : RefreshIndicator(
                          onRefresh: _loadUsers,
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
                                    const Text('Gestión de personal',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.white)),
                                    GestureDetector(
                                      onTap: _loadUsers,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.refresh_rounded,
                                            size: 18, color: AppColors.lavender),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                        child: GtStatCard(
                                            label: 'Personal',
                                            value: '${_staff.length}')),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: GtStatCard(
                                            label: 'Clientes',
                                            value: '${_clients.length}',
                                            valueColor: AppColors.sky)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_staff.isNotEmpty) ...[
                                  const Text('Personal',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.lavender)),
                                  const SizedBox(height: 10),
                                  ..._staff.map((u) => _UserTile(
                                        user: u,
                                        initials: _initials(u['name'] as String? ?? ''),
                                        roleLabel: _roleLabel(u['role'] as String? ?? ''),
                                        roleColor: _roleColor(u['role'] as String? ?? ''),
                                      )),
                                  const SizedBox(height: 8),
                                ],
                                if (_clients.isNotEmpty) ...[
                                  const Text('Clientes',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.lavender)),
                                  const SizedBox(height: 10),
                                  ..._clients.take(10).map((u) => _UserTile(
                                        user: u,
                                        initials: _initials(u['name'] as String? ?? ''),
                                        roleLabel: 'Cliente',
                                        roleColor: AppColors.sky,
                                      )),
                                  if (_clients.length > 10)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '+${_clients.length - 10} clientes más',
                                        style: const TextStyle(fontSize: 12, color: AppColors.gray),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
            ),
            AdminBottomNav(currentIndex: 2, onTap: (i) {
              if (i == 0) context.go('/admin/home');
              if (i == 1) context.go('/admin/analytics');
            }),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.initials,
    required this.roleLabel,
    required this.roleColor,
  });

  final Map<String, dynamic> user;
  final String initials;
  final String roleLabel;
  final Color roleColor;

  @override
  Widget build(BuildContext context) {
    final name = user['name'] as String? ?? '';
    final email = user['email'] as String? ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(initials,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, color: roleColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white)),
                Text(email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withValues(alpha: 0.4)),
            ),
            child: Text(roleLabel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: roleColor)),
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
            const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.gray),
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
