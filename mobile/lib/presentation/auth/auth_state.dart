abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String v_token;
  final String v_rol;
  AuthSuccess({required this.v_token, required this.v_rol});
}

class RegisterSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String v_mensaje;
  AuthFailure({required this.v_mensaje});
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