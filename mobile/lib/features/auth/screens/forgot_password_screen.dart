import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_button.dart';
import '../../../core/widgets/gt_input.dart';
import '../../../core/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  bool _validEmail(String v) =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$', caseSensitive: false).hasMatch(v);

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    if (!_validEmail(email)) {
      setState(() => _error = 'Ingresa un correo válido.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      await AuthService.forgotPassword(email);
      if (!mounted) return;
      setState(() { _sent = true; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

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
                    'Ingresa tu correo y te enviaremos un enlace para restablecerla.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.lavender),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x1E22c55e),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x5522c55e)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.mark_email_read_rounded, color: Color(0xFF4ade80), size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Revisa tu bandeja de entrada. Si el correo está registrado, recibirás el enlace en breve.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF4ade80), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GtButton(label: 'Volver al inicio', onTap: () => context.pop()),
              ] else ...[
                GtInput(
                  hint: 'Correo electrónico',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailCtrl,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0x1Ed4537e),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0x59d4537e)),
                    ),
                    child: Text(_error!, style: const TextStyle(fontSize: 12, color: AppColors.rose)),
                  ),
                ],
                const SizedBox(height: 24),
                GtButton(label: 'Enviar enlace', loading: _loading, onTap: _submit),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
