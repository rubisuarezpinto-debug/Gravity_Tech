import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.navy,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.purple,
          secondary: AppColors.pink,
          surface: AppColors.navy,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 20),
          titleLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 16),
          titleMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 14),
          bodyLarge: TextStyle(color: AppColors.white, fontSize: 14),
          bodyMedium: TextStyle(color: AppColors.lavender, fontSize: 12),
          bodySmall: TextStyle(color: AppColors.gray, fontSize: 11),
          labelSmall: TextStyle(color: AppColors.gray, fontSize: 10),
        ),
        iconTheme: const IconThemeData(color: AppColors.lavender),
        dividerColor: AppColors.border,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: AppColors.lavender),
        ),
      );
}
