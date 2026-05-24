import 'api_client.dart';

class AuthService {
  // ── POST /auth/register ────────────────────────────────────────────────────
  // Envía: nombre, correo, contraseña
  // Devuelve: mensaje de éxito, el servidor manda código al correo
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiClient.post('/auth/register', {
      'nombre':     name,
      'correo':     email,
      'contrasena': password,
    });
  }

  // ── POST /auth/verify-email ────────────────────────────────────────────────
  // Envía: código de 6 dígitos + correo
  // Devuelve: cuenta activada
  static Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    return await ApiClient.post('/auth/verify-email', {
      'correo': email,
      'codigo': code,
    });
  }

  // ── POST /auth/login ───────────────────────────────────────────────────────
  // Envía: correo, contraseña
  // Devuelve: { token, rol } → guarda el token en ApiClient
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiClient.post('/auth/login', {
      'correo':     email,
      'contrasena': password,
    });
    // Guarda el token automáticamente para todas las peticiones siguientes
    if (res['token'] != null) {
      ApiClient.setToken(res['token'] as String);
    }
    return res;
  }

  // ── POST /auth/forgot-password ─────────────────────────────────────────────
  // Envía: correo
  // Devuelve: código de recuperación enviado al correo
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    return await ApiClient.post('/auth/forgot-password', {
      'correo': email,
    });
  }

  // ── POST /auth/verify-reset-code ──────────────────────────────────────────
  // Envía: código de recuperación
  // Devuelve: confirmación de código válido
  static Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    return await ApiClient.post('/auth/verify-reset-code', {
      'correo': email,
      'codigo': code,
    });
  }

  // ── POST /auth/reset-password ──────────────────────────────────────────────
  // Envía: nueva contraseña
  // Devuelve: contraseña actualizada
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    return await ApiClient.post('/auth/reset-password', {
      'correo':          email,
      'nueva_contrasena': newPassword,
    });
  }

  // ── POST /auth/logout ──────────────────────────────────────────────────────
  // Invalida el token en el servidor y lo limpia localmente
  static Future<void> logout() async {
    await ApiClient.post('/auth/logout', {});
    ApiClient.clearToken();
  }
}