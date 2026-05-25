import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';
import '../../../core/widgets/gt_logo.dart';
import '../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty) return 'Ingresa tu correo electrónico';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) return 'El correo no es válido';
    if (pass.isEmpty) return 'Ingresa tu contraseña';
    if (pass.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    return null;
  }

  Future<void> _submit() async {
    final validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await AuthService.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (!mounted) return;
      final role = user['rol'] as String? ?? 'cliente';
      switch (role) {
        case 'administrador':
          context.go('/admin/home');
        case 'trabajador':
          context.go('/worker/home');
        default:
          context.go('/client/home');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                children: const [
                  GtLogo(size: 36),
                  SizedBox(width: 10),
                  Text('Gravity Tech',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.white)),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Iniciar sesión',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.white)),
              const SizedBox(height: 4),
              const Text('Bienvenido de vuelta', style: TextStyle(fontSize: 13, color: AppColors.lavender)),
              const SizedBox(height: 24),
              GtInput(
                hint: 'Correo electrónico',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailCtrl,
              ),
              const SizedBox(height: 12),
              GtInput(
                hint: 'Contraseña',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: _passCtrl,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push('/forgot-password'),
                  child: const Text('¿Olvidaste tu contraseña?',
                      style: TextStyle(fontSize: 11, color: AppColors.rose)),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0x33d4537e),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0x66d4537e)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.rose),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.rose)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              GtButton(
                label: 'Iniciar sesión',
                loading: _loading,
                onTap: _submit,
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
