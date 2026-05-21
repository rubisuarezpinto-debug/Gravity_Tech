import 'package:flutter/material.dart';

class AppTheme {
  // ── 1. PALETA DE COLORES OFICIAL (VIOLETA Y ROSA) ──
  static const Color c_primario = Color(0xFF6200EE);    // Violeta principal
  static const Color c_secundario = Color(0xFFFF4081);  // Rosa brillante para acentos/botones
  static const Color c_fondo_claro = Color(0xFFF8F9FA);
  static const Color c_fondo_oscuro = Color(0xFF121212);
  static const Color c_error = Color(0xFFB00020);

  // ── 2. CONFIGURACIÓN DEL MODO CLARO ──
  static ThemeData get modoClaro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: c_primario,
        secondary: c_secundario,
        error: c_error,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: c_fondo_claro,
      
// Cambiado CardTheme por CardThemeData
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 1,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: c_primario, width: 2), // Borde violeta al enfocar
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: c_error),
        ),
      ),
    );
  }

  // ── 3. CONFIGURACIÓN DEL MODO OSCURO ──
  static ThemeData get modoOscuro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: c_primario,
        secondary: c_secundario,
        error: c_error,
        surface: Color(0xFF1E1E1E),
      ),
      scaffoldBackgroundColor: c_fondo_oscuro,
      
// Cambiado CardTheme por CardThemeData
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        labelStyle: const TextStyle(color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: c_secundario, width: 2), // Borde rosa en modo oscuro
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: c_error),
        ),
      ),
    );
  }
}