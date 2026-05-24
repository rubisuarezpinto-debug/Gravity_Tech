class ApiConfig {
  // ── Cambia esta IP por la de tu máquina cuando pruebes en dispositivo físico ──
  // En emulador Android usa: 10.0.2.2
  // En emulador iOS usa:     127.0.0.1
  // En dispositivo físico:   la IP local de tu PC (ej: 192.168.1.X)
  static const String _host = '10.0.2.2';
  static const String _port = '3000';

  static const String baseUrl = 'http://$_host:$_port/api';

  // ── Tiempos de espera ──────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}