import 'package:dio/dio.dart';
import '../../core/network/endpoints.dart'; // Usaremos la base que definimos antes

class AuthRepository {
  // Usamos Dio para que la gestión de errores sea igual en toda la App
  final Dio _dio = Dio(BaseOptions(
    // CAMBIA ESTO: Usa la IP real y quita "/auth" si tu baseUrl ya lo incluye
    // O mejor aún, usa la variable global que creamos:
    baseUrl: 'http://192.168.0.102:3000/api/auth', 
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // ── 1. REGISTRO ──
  Future<Map<String, dynamic>> register(String name, String email, String password, String phone) async {
    try {
      final response = await _dio.post('/register', data: {
        'v_nombre': name,
        'v_email': email,
        'v_password': password,
        'v_telefono': phone,
      });
      return response.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'b_exito': false, 'v_mensaje': 'Error de conexión'};
    }
  }

  // ── 2. LOGIN ──
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'v_email': email, 
        'v_password': password
      });
      return response.data;
    } on DioException catch (e) {
      // Manejo de estado pendiente
      if (e.response?.statusCode == 403 && e.response?.data['e_estado'] == 'PENDIENTE') {
        throw Exception('PENDIENTE');
      }
      return e.response?.data ?? {'b_exito': false, 'v_mensaje': 'Error al iniciar sesión'};
    }
  }

  // ── 3. VERIFICACIÓN DE EMAIL ──
  Future<Map<String, dynamic>> verifyEmail(String email, String codigo) async {
    try {
      final response = await _dio.post('/verify-email', data: {
        'v_email': email,
        'v_codigo': codigo,
      });
      return response.data;
    } on DioException catch (e) {
      return e.response?.data ?? {'b_exito': false, 'v_mensaje': 'Error de validación'};
    }
  }

  // ── 4 y 5. RECUPERACIÓN (Misma lógica) ──
Future<Map<String, dynamic>> solicitarRecuperacion(String v_email) async {
    try {
      final response = await _dio.post('/forgot-password', data: {'v_email': v_email});
      return response.data;
    } on DioException catch (e) {
      // Esto imprimirá el error real en tu consola de VS Code
      print("Error detallado: ${e.message}");
      return e.response?.data ?? {'b_exito': false, 'v_mensaje': 'Error al conectar.'};
    }
  }

 Future<Map<String, dynamic>> cambiarContrasenia(String v_email, String v_codigo, String v_nueva_password) async {
  try {
    final response = await _dio.post('/reset-password', data: {
      'v_email': v_email,
      'v_codigo': v_codigo,
      'v_nueva_password': v_nueva_password,
    });
    
    // Si la respuesta es exitosa (código 200)
    return response.data;
    
  } on DioException catch (e) {
    // Esto es crucial: el servidor suele enviar un mensaje de error (ej: "Código expirado")
    // que viene dentro de e.response?.data
    if (e.response != null) {
      print("Error del servidor: ${e.response?.data}");
      return e.response?.data; 
    }
    
    // Si no hay respuesta del servidor (error de red/timeout)
    print("Error de conexión: ${e.message}");
    return {
      'b_exito': false, 
      'v_mensaje': 'No se pudo conectar con el servidor. Revisa tu conexión.'
    };
    
  } catch (e) {
    // Para errores inesperados de lógica o formato
    print("Error inesperado: $e");
    return {'b_exito': false, 'v_mensaje': 'Ocurrió un error inesperado.'};
  }
}
}