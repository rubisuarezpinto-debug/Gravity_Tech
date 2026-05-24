import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // ← Se importa para conectar con el backend
import 'dart:convert';                  // ← Para formatear la petición JSON
import '../../theme/app_theme.dart';
import 'verification_screen.dart';       // ← Importamos la pantalla destino

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading    = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // 🌍 Si pruebas en Web dejas 'localhost'. Si usas emulador Android cambia a '10.0.2.2'
      final url = Uri.parse('http://localhost:3000/api/auth/forgot-password');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailCtrl.text.trim()}),
      );

      setState(() => _loading = false);

      if (!mounted) return;

      if (response.statusCode == 200) {
        // ✅ Éxito: El backend generó el código y Nodemailer lo envió
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código enviado a tu correo')),
        );

        // ➡️ Navega de una vez a la pantalla de verificación enviando el email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(email: _emailCtrl.text.trim()),
          ),
        );
      } else {
        // ❌ Error controlado por el backend (Ej: El correo no existe)
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Error al enviar el código')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar con el servidor: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back ─────────────────────────────────────────────
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: AppColors.textPrimary, size: 20),
                  padding: EdgeInsets.zero,
                ),

                const SizedBox(height: 40),

                // ── Icono ─────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.lock_reset,
                        color: AppColors.primary, size: 36),
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    '¿Olvidaste la contraseña?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Ingresa tu correo para recibir un código de recuperación',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Email ─────────────────────────────────────────────
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Correo electrónico'),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Correo inválido' : null,
                ),

                const SizedBox(height: 24),

                // ── Botón Continuar ───────────────────────────────────
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _continue,
                        child: const Text('Continuar'),
                      ),

                const SizedBox(height: 32),

                // ── Pasos del flujo ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Flujo completo',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      _Step(number: '1', text: 'Ingresar correo'),
                      _Step(number: '2', text: 'Recibir código'),
                      _Step(number: '3', text: 'Validar código'),
                      _Step(number: '4', text: 'Nueva contraseña'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}