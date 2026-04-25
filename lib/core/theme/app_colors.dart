import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF3F3D56);
  static const Color secondary = Color(0xFF26C6DA);

  // Backgrounds
  static const Color background = Color(0xFFF3F4F6); // Soft gray
  static const Color surface = Colors.white;
  static const Color cardShadow = Color(0x1F000000);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFB9F6CA);
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937); // Tailord dark gray
  static const Color textSecondary = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient practiceGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient examGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
