import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth_bloc.dart';
import '../../logic/blocs/auth_event.dart';
import '../../logic/blocs/auth_state.dart';
import 'verification_screen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final phoneC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // 1. Manejo de errores
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.v_mensaje), backgroundColor: Colors.red),
            );
          }
          
          // 2. Navegación a Verificación
          if (state is AuthVerificationRequired) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(v_email: state.v_email),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: emailC, decoration: const InputDecoration(labelText: "Correo")),
                TextField(controller: phoneC, decoration: const InputDecoration(labelText: "Teléfono")),
                TextField(
                  controller: passC, 
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                
                // Muestra carga o botón
                state is AuthLoading 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(RegisterSubmitted(
                          name: nameC.text, 
                          email: emailC.text, 
                          password: passC.text, 
                          phone: phoneC.text
                        ));
                      },
                      child: const Text("Registrarme"),
                    )
              ],
            ),
          );
        },
      ),
    );
  }
}