abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class EmailCodeSubmitted extends AuthEvent { // Cambiado de SmsCodeSubmitted
  final String email;
  final String code;
  EmailCodeSubmitted({required this.email, required this.code});
}

class LogoutRequested extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  RegisterSubmitted({required this.name, required this.email, required this.password, required this.phone});
}