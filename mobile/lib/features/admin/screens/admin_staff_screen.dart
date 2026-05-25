import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_stat_card.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  static const _staff = [
    _StaffMember('Carlos Méndez', 'Trabajador — Inventario', 'CM', AppColors.lavender,
        Color(0x664c2f9e), 'Activo', AppColors.lavender, Color(0x4D7c5cbf)),
    _StaffMember('Ana López', 'Trabajadora — Ventas', 'AL', AppColors.rose,
        Color(0x33d4537e), 'Activo', AppColors.rose, Color(0x4Dd4537e)),
    _StaffMember('Jorge Ruiz', 'Trabajador — Logística', 'JR', AppColors.sky,
        Color(0x332979d4), 'Inactivo', AppColors.sky, Color(0x4D2979d4)),
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.white)),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.person_add_outlined, size: 18, color: AppColors.lavender),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: GtStatCard(label: 'Empleados', value: '12')),
                        SizedBox(width: 10),
                        Expanded(child: GtStatCard(label: 'Activos hoy', value: '9', valueColor: AppColors.sky)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._staff.map((s) => _StaffTile(member: s)),
                  ],
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

class _StaffTile extends StatelessWidget {
  const _StaffTile({required this.member});
  final _StaffMember member;

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(color: member.avatarBg, shape: BoxShape.circle),
            child: Center(
              child: Text(member.initials,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: member.avatarColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.white)),
                Text(member.role, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: member.badgeBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: member.badgeBorder),
            ),
            child: Text(member.status,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: member.avatarColor)),
          ),
        ],
      ),
    );
  }
}

class _StaffMember {
  const _StaffMember(
    this.name,
    this.role,
    this.initials,
    this.avatarColor,
    this.avatarBg,
    this.status,
    this.badgeColor,
    this.badgeBorder, {
    Color? badgeBg,
  }) : badgeBg = badgeBg ?? avatarBg;

  final String name;
  final String role;
  final String initials;
  final Color avatarColor;
  final Color avatarBg;
  final String status;
  final Color badgeColor;
  final Color badgeBorder;
  final Color badgeBg;
}
