import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/worker_bottom_nav.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

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
                          onTap: () => context.pop(),
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
                            child: Text('Gestión de Productos',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                          ),
                        ),
                        const SizedBox(width: 36),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Selecciona una acción',
                        style: TextStyle(fontSize: 12, color: AppColors.lavender)),
                    const SizedBox(height: 20),
                    _ActionBtn(
                      label: 'Crear producto',
                      icon: Icons.add_circle_outline_rounded,
                      bgColor: const Color(0x664c2f9e),
                      textColor: AppColors.lavender,
                      borderColor: AppColors.violet,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      label: 'Eliminar producto',
                      icon: Icons.delete_outline_rounded,
                      bgColor: const Color(0x26d4537e),
                      textColor: AppColors.rose,
                      borderColor: const Color(0x66d4537e),
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      label: 'Actualizar / Reabastecer',
                      icon: Icons.refresh_rounded,
                      bgColor: const Color(0x332979d4),
                      textColor: AppColors.sky,
                      borderColor: const Color(0x662979d4),
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.border, height: 32),
                    const Text('Acciones recientes',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lavender)),
                    const SizedBox(height: 10),
                    ...[
                      '• Smartwatch X — stock actualizado',
                      '• Mouse Ergonómico — creado',
                      '• Cable VGA — eliminado',
                    ].map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(t, style: const TextStyle(fontSize: 12, color: AppColors.gray, height: 1.5)),
                        )),
                  ],
                ),
              ),
            ),
            WorkerBottomNav(currentIndex: 1, onTap: (i) {
              if (i == 0) context.go('/worker/home');
            }),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }
}
