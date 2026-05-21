abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String v_mensaje;
  AuthError({required this.v_mensaje});
}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> o_usuario;
  final String v_token;
  final String e_rol;

  AuthAuthenticated({
    required this.o_usuario, 
    required this.v_token, 
    required this.e_rol
  });
}

class AuthVerificationRequired extends AuthState {
  final String v_email;
  AuthVerificationRequired({required this.v_email});
}

class AuthRecoveryCodeSent extends AuthState {
  final String v_mensaje;
  AuthRecoveryCodeSent({required this.v_mensaje});
}

class AuthPasswordResetSuccess extends AuthState {
  final String v_mensaje;
  AuthPasswordResetSuccess({required this.v_mensaje});
}
