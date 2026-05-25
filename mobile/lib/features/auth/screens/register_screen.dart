import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';
import '../../../core/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;
    if (name.length < 2) return 'El nombre debe tener al menos 2 caracteres';
    if (!RegExp(r'^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s-]+$').hasMatch(name)) {
      return 'El nombre solo puede contener letras';
    }
    if (email.isEmpty) return 'Ingresa tu correo electrónico';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) return 'El correo no es válido';
    if (pass.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    if (pass != confirm) return 'Las contraseñas no coinciden';
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
      await AuthService.register(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!mounted) return;
      context.go('/client/home');
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
              GtInput(
                hint: 'Nombre completo',
                icon: Icons.person_outline_rounded,
                controller: _nameCtrl,
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              GtInput(
                hint: 'Confirmar contraseña',
                icon: Icons.lock_outline_rounded,
                obscure: true,
                controller: _confirmCtrl,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
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
              const SizedBox(height: 24),
              GtButton(
                label: 'Crear cuenta',
                variant: GtButtonVariant.pink,
                loading: _loading,
                onTap: _submit,
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
