import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0055FF); // Electric Blue
  static const Color secondary = Color(0xFF00D4FF); // Bright Cyan
  static const Color background = Color(0xFFF4F7FB); // Soft light blue-grey
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A); // Dark slate
  static const Color textSecondary = Color(0xFF64748B); // Slate
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5); // Emerald 100
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color errorDark = Color(0xFFB91C1C); // Red 700
  static const Color divider = Color(0xFFE2E8F0);
  static const Color primaryDark = Color(0xFF003DCC); // Darker Electric Blue
  static const Color cardShadow = Color(0x0A000000); // lighter shadow for light theme

  // Gradients based on the new palette
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF34D399)], // success to lighter emerald
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient practiceGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)], // Purple vibrant
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient examGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFFB7185)], // Rose vibrant
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
