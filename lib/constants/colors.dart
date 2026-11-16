import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF060913);
  static const Color surface = Color(0xFF0E1426);
  static const Color card = Color(0xFF111833);
  static const Color border = Color(0xFF1F2A4A);

  static const Color primary = Color(0xFF22D3EE); // Cyan
  static const Color violet = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFFEC4899); // Pink accent
  static const Color amber = Color(0xFFF59E0B);
  static const Color green = Color(0xFF10B981);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, violet, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
