import 'package:flutter/material.dart';

/// Centralized color palette extracted from UI design mockups.
abstract class AppColors {
  // Primary (Orange)
  static const Color primary = Color(0xFFF08A24);
  static const Color primaryLight = Color(0xFFF5A623);
  static const Color primaryDark = Color(0xFFD47516);

  // Secondary (Warm Brown)
  static const Color secondary = Color(0xFF8B4513);
  static const Color secondaryLight = Color(0xFFA0522D);
  static const Color secondaryDark = Color(0xFF5D2E0C);

  // Backgrounds
  static const Color background = Color(0xFFFFF3E4);
  static const Color scaffoldBackground = Color(0xFFFDECD8);

  // Surfaces and Cards
  static const Color surface = Color(0xFFF5DDBF);
  static const Color surfaceVariant = Color(0xFFF0D2AC);
  static const Color surfaceDark = Color(0xFFF0D2AC);
  static const Color surfaceLight = Color(0xFFFFF0E0);

  // Typography
  static const Color textPrimary = Color(0xFF2B1B0E);
  static const Color textSecondary = Color(0xFF7A5230);
  static const Color textHint = Color(0xFFB8860B);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;

  // Status Indicators
  static const Color success = Color(0xFF2E9E44);
  static const Color warning = Color(0xFFE67E22);
  static const Color error = Color(0xFFC0392B);

  // Progress Bar Thresholds
  static const Color progressHigh = Color(0xFF2E9E44); // >= 85%
  static const Color progressMedium = Color(0xFFE67E22); // 50% - 84%
  static const Color progressLow = Color(0xFFC0392B); // < 50%

  // Borders & Accents
  static const Color border = Color(0xFFDEB887);
  static const Color borderLight = Color(0xFFE8D5B7);
  static const Color notificationBadge = Color(0xFFC0392B);
  static const Color divider = Color(0xFFE0C9A6);
  static const Color bottomNavBackground = Color(0xFF8B4513);
  static const Color iconDefault = Color(0xFF8B4513);
  static const Color chipSelected = Color(0xFF8B4513);
  static const Color chipUnselected = Colors.transparent;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1410);
  static const Color darkSurface = Color(0xFF2C2218);
  static const Color darkSurfaceVariant = Color(0xFF3D3024);
  static const Color darkTextPrimary = Color(0xFFF5EDE0);
  static const Color darkTextSecondary = Color(0xFFB8A08A);
}
