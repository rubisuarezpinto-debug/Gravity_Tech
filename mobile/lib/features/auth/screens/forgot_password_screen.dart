import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                      child: Text('Recuperar acceso',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0x664c2f9e),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.violet, width: 2),
                  ),
                  child: const Icon(Icons.key_rounded, size: 28, color: AppColors.lavender),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('¿Olvidaste la contraseña?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Ingresa tu correo para recibir un código de recuperación',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.lavender),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const GtInput(hint: 'Correo electrónico', icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              GtButton(label: 'Continuar', onTap: () => context.push('/verify')),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x1E4c2f9e),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Flujo continúa:',
                        style: TextStyle(fontSize: 12, color: AppColors.lavender, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text('1. Ingresar correo\n2. Recibir código\n3. Validar código\n4. Nueva contraseña',
                        style: TextStyle(fontSize: 11, color: AppColors.gray, height: 1.7)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
