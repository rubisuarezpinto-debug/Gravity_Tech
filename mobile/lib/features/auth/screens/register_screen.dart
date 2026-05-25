import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                      child: Text('Crear cuenta',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Completa tu registro',
                  style: TextStyle(fontSize: 13, color: AppColors.lavender)),
              const SizedBox(height: 24),
              const GtInput(hint: 'Nombre completo', icon: Icons.person_outline_rounded),
              const SizedBox(height: 12),
              const GtInput(hint: 'Correo electrónico', icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              const GtInput(hint: 'Contraseña', icon: Icons.lock_outline_rounded, obscure: true),
              const SizedBox(height: 12),
              const GtInput(hint: 'Confirmar contraseña', icon: Icons.lock_outline_rounded, obscure: true),
              const SizedBox(height: 24),
              GtButton(
                label: 'Enviar código',
                variant: GtButtonVariant.pink,
                onTap: () => context.push('/verify'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.pop(),
                child: const Center(
                  child: Text('¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(fontSize: 11, color: AppColors.rose)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
