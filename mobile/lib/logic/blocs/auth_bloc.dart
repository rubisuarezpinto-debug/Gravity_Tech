import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<VerifyEmailSubmitted>(_onVerifyEmailSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  // ── 1. REGISTRO ──
  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.register(event.name, event.email, event.password, event.phone);
      if (result['b_exito'] == true) {
        emit(AuthVerificationRequired(v_email: event.email));
      } else {
        emit(AuthError(v_mensaje: result['v_mensaje'] ?? 'Error al registrar.'));
      }
    } catch (e) {
      emit(AuthError(v_mensaje: 'Error de conexión.'));
    }
  }

  // ── 2. VERIFICACIÓN ──
  Future<void> _onVerifyEmailSubmitted(VerifyEmailSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.verifyEmail(event.v_email, event.v_code);
      if (result['b_exito'] == true) {
        final d = result['o_datos'];
        emit(AuthAuthenticated(
          o_usuario: d['o_usuario'], 
          v_token: d['v_token'], 
          e_rol: d['o_usuario']['e_rol']
        ));
      } else {
        emit(AuthError(v_mensaje: result['v_mensaje'] ?? 'Código inválido.'));
      }
    } catch (e) {
      emit(AuthError(v_mensaje: 'Error al verificar.'));
    }
  }

  // ── 3. LOGIN ──
  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(event.v_email, event.v_password);
      if (result['b_exito'] == true) {
        final d = result['o_datos'];
        emit(AuthAuthenticated(
          o_usuario: d['o_usuario'], 
          v_token: d['v_token'], 
          e_rol: d['o_usuario']['e_rol']
        ));
      } else {
        emit(AuthError(v_mensaje: result['v_mensaje'] ?? 'Credenciales incorrectas.'));
      }
    } catch (e) {
      emit(AuthError(v_mensaje: e.toString().contains('PENDIENTE') 
          ? 'Cuenta requiere verificación.' 
          : 'Error de conexión.'));
    }
  }

  // ── 4. LOGOUT ──
  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  // ── 5. OLVIDÉ CONTRASEÑA ──
  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.solicitarRecuperacion(event.v_email);
      if (result['b_exito'] == true) {
        emit(AuthRecoveryCodeSent(v_mensaje: result['v_mensaje'] ?? 'Código enviado.'));
      } else {
        emit(AuthError(v_mensaje: result['v_mensaje'] ?? 'Error al solicitar código.'));
      }
    } catch (e) {
      emit(AuthError(v_mensaje: 'Error de conexión.'));
    }
  }

  // ── 6. RESETEAR CONTRASEÑA ──
  Future<void> _onResetPasswordSubmitted(ResetPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.cambiarContrasenia(
        event.v_email, event.v_codigo, event.v_nueva_password
      );
      if (result['b_exito'] == true) {
        emit(AuthPasswordResetSuccess(v_mensaje: result['v_mensaje'] ?? 'Contraseña actualizada.'));
      } else {
        emit(AuthError(v_mensaje: result['v_mensaje'] ?? 'Código incorrecto.'));
      }
    } catch (e) {
      emit(AuthError(v_mensaje: 'Error al actualizar contraseña.'));
    }
  }
}