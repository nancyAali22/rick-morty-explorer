import 'package:flutter/material.dart';

/// Brand identity: warm, organic, premium — mint/beige/soft-brown palette.
/// Deliberately avoids the classic Rick & Morty green/blue.
class AppColors {
  const AppColors._();

  // Light theme
  static const Color lightBackground = Color(0xFFFBF7F1);
  static const Color lightSurface = Color(0xFFF1E9DC);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE3D8C4);
  static const Color lightTextPrimary = Color(0xFF2B241D);
  static const Color lightTextSecondary = Color(0xFF7A6F62);

  // Dark theme
  static const Color darkBackground = Color(0xFF1C1712);
  static const Color darkSurface = Color(0xFF2A231C);
  static const Color darkSurfaceElevated = Color(0xFF332B22);
  static const Color darkBorder = Color(0xFF3D362C);
  static const Color darkTextPrimary = Color(0xFFF3ECE1);
  static const Color darkTextSecondary = Color(0xFFB3A594);

  // Brand (shared)
  static const Color primaryBrown = Color(0xFF8A6D55);
  static const Color primaryBrownDark = Color(0xFF5E4A38);
  static const Color primaryBrownOnDark = Color(0xFFC9A98A);

  static const Color accentMint = Color(0xFF8FBFA3);
  static const Color accentMintDark = Color(0xFF7FB89B);
  static const Color accentMintDeep = Color(0xFF5F8C72);

  static const Color onBrand = Color(0xFFFFFFFF);

  // Status
  static const Color statusAlive = accentMint;
  static const Color statusDead = Color(0xFFC6725A);
  static const Color statusUnknown = Color(0xFFB3A594);

  static const Color error = Color(0xFFC6725A);
  static const Color warning = Color(0xFFD9A55C);
  static const Color info = Color(0xFF7C9CB8);
}