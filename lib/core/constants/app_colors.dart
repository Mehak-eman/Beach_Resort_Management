import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0096C7);
  static const Color secondary = Color(0xFFFFC300);

  static const Color background = Color(0xFFF8FBFD);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1D3557);
  static const Color textSecondary = Color(0xFF6C757D);

  static const Color border = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00B4D8),
      Color(0xFF0077B6),
    ],
  );

  static Color? get scaffoldBackground => null;
}