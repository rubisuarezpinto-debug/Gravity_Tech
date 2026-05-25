import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';
import '../../../core/widgets/gt_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const GtLogo(size: 36),
                  const SizedBox(width: 10),
                  const Text('Gravity Tech',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Iniciar sesión',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.white)),
              const SizedBox(height: 4),
              const Text('Bienvenido de vuelta', style: TextStyle(fontSize: 13, color: AppColors.lavender)),
              const SizedBox(height: 24),
              const GtInput(hint: 'Correo electrónico', icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              const GtInput(hint: 'Contraseña', icon: Icons.lock_outline_rounded, obscure: true),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push('/forgot-password'),
                  child: const Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(fontSize: 11, color: AppColors.rose)),
                ),
              ),
              const SizedBox(height: 20),
              GtButton(
                label: 'Iniciar sesión',
                onTap: () => context.go('/client/home'),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
              const SizedBox(height: 16),
              GtButton(
                label: 'Registrarse',
                variant: GtButtonVariant.secondary,
                onTap: () => context.push('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
