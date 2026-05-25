import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const navy = Color(0xFF1a1040);
  static const purple = Color(0xFF4c2f9e);
  static const violet = Color(0xFF7c5cbf);
  static const lavender = Color(0xFFb39ddb);
  static const blue = Color(0xFF2979d4);
  static const sky = Color(0xFF5baef0);
  static const pink = Color(0xFFd4537e);
  static const rose = Color(0xFFf48fb1);
  static const light = Color(0xFFf0ecff);
  static const white = Color(0xFFffffff);
  static const gray = Color(0xFF8880a0);

  static const border = Color(0x3F7c5cbf);
  static const surface = Color(0x12ffffff);
  static const surfaceLight = Color(0x0Dffffff);

  static const gradientPrimary = LinearGradient(
    colors: [purple, blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientPink = LinearGradient(
    colors: [pink, Color(0xFFb03a64)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientSplash = LinearGradient(
    colors: [purple, blue, pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const gradientCard = LinearGradient(
    colors: [Color(0x667c5cbf), Color(0x4D2979d4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
