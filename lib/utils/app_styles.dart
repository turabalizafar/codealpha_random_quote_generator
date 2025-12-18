import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5F7FA); // Soft grey-white
  static const Color cardColor = Colors.white;
  static const Color primaryText = Color(0xFF2D3436); // Dark charcoal
  static const Color secondaryText = Color(0xFF636E72); // Grey
  static const Color accent = Color(0xFF0984E3); // Calming Blue
}

class AppTextStyles {
  static const TextStyle quote = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.primaryText,
    height: 1.5,
  );

  static const TextStyle author = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    letterSpacing: 1.1,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
