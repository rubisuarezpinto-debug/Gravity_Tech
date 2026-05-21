abstract class AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String name, email, password, phone;
  RegisterSubmitted({required this.name, required this.email, required this.password, required this.phone});
}

class VerifyEmailSubmitted extends AuthEvent {
  final String v_email, v_code;
  VerifyEmailSubmitted({required this.v_email, required this.v_code});
}

class LoginSubmitted extends AuthEvent {
  final String v_email, v_password;
  LoginSubmitted({required this.v_email, required this.v_password});
}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String v_email;
  ForgotPasswordRequested({required this.v_email});
}

class ResetPasswordSubmitted extends AuthEvent {
  final String v_email, v_codigo, v_nueva_password;
  ResetPasswordSubmitted({required this.v_email, required this.v_codigo, required this.v_nueva_password});
}