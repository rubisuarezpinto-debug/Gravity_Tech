import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
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
                      child: Text('Verificación',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0x664c2f9e),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.violet, width: 2),
                ),
                child: const Icon(Icons.mark_email_read_outlined, size: 34, color: AppColors.lavender),
              ),
              const SizedBox(height: 20),
              const Text('Revisa tu correo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Ingresa el código de 6 dígitos enviado a tu email',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.lavender),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) => _CodeBox(index: i)),
              ),
              const SizedBox(height: 32),
              GtButton(label: 'Verificar', onTap: () => context.go('/client/home')),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: const Text('Reenviar código',
                    style: TextStyle(fontSize: 12, color: AppColors.rose)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 52,
      margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.violet),
      ),
      child: const Center(
        child: Text('_', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.lavender)),
      ),
    );
  }
}
