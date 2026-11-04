import 'package:flutter/material.dart';

/// Dizayndagi ranglar (canvas'dagi MVP ekranlari bilan bir xil).
class AppColors {
  static const ink = Color(0xFF13233A);
  static const muted = Color(0xFF5A6678);
  static const accent = Color(0xFF2F5BEA);
  static const accentSoft = Color(0xFFEEF2FD);
  static const border = Color(0xFFE3E7EE);
  static const surface = Color(0xFFF2F4F7);
  static const background = Color(0xFFF5F7FA);
  static const success = Color(0xFF1F7A4D);
  static const successSoft = Color(0xFFE6F4EC);
  static const error = Color(0xFFC2362B);
  static const errorSoft = Color(0xFFFBEAE8);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accent,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
