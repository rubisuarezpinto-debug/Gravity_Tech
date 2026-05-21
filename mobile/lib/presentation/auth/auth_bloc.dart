  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'auth_event.dart';
  import 'auth_state.dart';
  import '../../data/repositories/auth_repository.dart';

  class AuthBloc extends Bloc<AuthEvent, AuthState> {
    final AuthRepository authRepository;

    AuthBloc({required this.authRepository}) : super(AuthInitial()) {
      
      // --- LOGIN ---
      on<LoginSubmitted>(_onLoginSubmitted);

      // --- REGISTRO ---
      on<RegisterSubmitted>(_onRegisterSubmitted);

      // --- VERIFICACIÓN ---
      on<EmailCodeSubmitted>(_onEmailCodeSubmitted);

      // --- LOGOUT ---
      on<LogoutRequested>((event, emit) => emit(AuthInitial()));
    }

    // MÉTODOS SEPARADOS PARA EVITAR ERRORES DE SINTAXIS
    
    Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.login(event.email, event.password);
        if (result['b_exito'] == true) {
          emit(AuthSuccess(
            v_token: result['o_datos']['v_token'] ?? '',
            v_rol: result['o_datos']['v_rol'] ?? 'CLIENTE',
          ));
        } else {
          emit(AuthFailure(v_mensaje: result['v_mensaje'] ?? 'Credenciales incorrectas.'));
        }
      } catch (e) {
        emit(AuthFailure(v_mensaje: 'Error al conectar con el servidor.'));
      }
    }

    Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.register(event.name, event.email, event.password, event.phone);
        
        if (result['b_exito'] == true) {
          // CORRECCIÓN AQUÍ: Usamos 'emit' para enviar el estado
          emit(AuthVerificationRequired(v_email: event.email)); 
        } else {
          emit(AuthFailure(v_mensaje: result['v_mensaje'] ?? 'Error en registro.'));
        }
      } catch (e) {
        emit(AuthFailure(v_mensaje: 'Error de red.'));
      }
    }

    Future<void> _onEmailCodeSubmitted(EmailCodeSubmitted event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.verifyEmail(event.email, event.code); 
        if (result['b_exito'] == true) {
          emit(AuthSuccess(
            v_token: result['o_datos']['v_token'] ?? '',
            v_rol: result['o_datos']['v_rol'] ?? 'CLIENTE',
          ));
        } else {
          emit(AuthFailure(v_mensaje: result['v_mensaje'] ?? 'Código incorrecto.'));
        }
      } catch (e) {
        emit(AuthFailure(v_mensaje: 'Error al validar.'));
      }
    }
  }