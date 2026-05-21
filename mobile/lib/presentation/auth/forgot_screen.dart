import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth_bloc.dart';
import '../../logic/blocs/auth_event.dart';
import '../../logic/blocs/auth_state.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _codeController     = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isCodeSent        = false; // Controla el cambio de fase en el diseño
  bool _obscurePassword   = true;

  // ── Paleta ──────────────────────────────────────────────────────────────────
  static const Color _rosa    = Color(0xFFE91E63);
  static const Color _violeta = Color(0xFF9C27B0);
  static const Color _fondo   = Color(0xFF121212);
  // ────────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Lógica intacta ──────────────────────────────────────────────────────────
  void _procesarAccion() {
    if (_formKey.currentState!.validate()) {
      if (!_isCodeSent) {
        context.read<AuthBloc>().add(
          ForgotPasswordRequested(v_email: _emailController.text.trim()),
        );
      } else {
        context.read<AuthBloc>().add(
          ResetPasswordSubmitted(
            v_email: _emailController.text.trim(),
            v_codigo: _codeController.text.trim(),
            v_nueva_password: _passwordController.text,
          ),
        );
      }
    }
  }
  // ────────────────────────────────────────────────────────────────────────────

  InputDecoration _fieldDecoration({
    required String label,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: _violeta),
      suffixIcon: suffix,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: _rosa, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _rosa),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: BlocConsumer<AuthBloc, AuthState>(
            // ── Listener intacto ─────────────────────────────────────────────
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.v_mensaje),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
              if (state is AuthRecoveryCodeSent) {
                setState(() => _isCodeSent = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.v_mensaje),
                    backgroundColor: _violeta,
                  ),
                );
              }
              if (state is AuthPasswordResetSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.v_mensaje),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            // ─────────────────────────────────────────────────────────────────
            builder: (context, state) {
              final bool isLoading = state is AuthLoading;

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Ícono dinámico según fase ────────────────────────────
                    Icon(
                      _isCodeSent
                          ? Icons.lock_reset
                          : Icons.mark_email_unread_outlined,
                      size: 80,
                      color: _rosa,
                    ),
                    const SizedBox(height: 14),

                    // ── Título dinámico según fase ───────────────────────────
                    Text(
                      _isCodeSent ? 'Restablecer Clave' : 'Recuperar Cuenta',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _rosa,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── FASE 1: correo ───────────────────────────────────────
                    if (!_isCodeSent) ...[
                      Text(
                        'Introduce tu correo registrado para enviarte un código de seguridad.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        style: const TextStyle(color: Colors.white),
                        decoration: _fieldDecoration(
                          label: 'Correo Electrónico',
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Ingresa tu correo'
                                : null,
                      ),
                    ]

                    // ── FASE 2: código + nueva contraseña ────────────────────
                    else ...[
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                        style: const TextStyle(color: Colors.white),
                        decoration: _fieldDecoration(
                          label: 'Código de 6 dígitos',
                          prefixIcon: Icons.pin,
                        ),
                        validator: (v) =>
                            v == null || v.trim().length != 6
                                ? 'Se requieren 6 dígitos'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        enabled: !isLoading,
                        style: const TextStyle(color: Colors.white),
                        decoration: _fieldDecoration(
                          label: 'Nueva Contraseña',
                          prefixIcon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white38,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? 'Ingresa tu nueva contraseña'
                                : null,
                      ),
                    ],
                    const SizedBox(height: 40),

                    // ── Botón de acción dinámico ─────────────────────────────
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _violeta,
                          disabledBackgroundColor: _violeta.withOpacity(0.5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading ? null : _procesarAccion,
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _isCodeSent ? 'Confirmar Cambio' : 'Enviar Código',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}