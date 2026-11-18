import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const List<String> arabicFontFamilyFallback = [
    'FalahArabic',
    'Cairo',
    'Tajawal',
    'Almarai',
    'Segoe UI',
    'Roboto',
    'sans-serif',
  ];

  static TextStyle get displayLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.5,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
        letterSpacing: -0.3,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.35,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.4,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.45,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.45,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.5,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        fontFamilyFallback: arabicFontFamilyFallback,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        fontFamilyFallback: arabicFontFamilyFallback,
      );
}
