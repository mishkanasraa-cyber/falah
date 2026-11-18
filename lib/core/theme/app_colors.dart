import 'package:flutter/material.dart';

class AppColors {
  // Deep Forest Green Palette (Emphasis, Headers, Navigation)
  static const Color forestDarkest = Color(0xFF071F15);
  static const Color forestDark = Color(0xFF0F3827);
  static const Color forestMedium = Color(0xFF1B4D3E);
  static const Color forestPrimary = Color(0xFF155E3D);
  static const Color forestSurface = Color(0xFF1E3A2F);
  static const Color forestAccent = Color(0xFF2D6A4F);

  // Fresh Lime Accents (Primary Actions, CTAs, Highlights)
  static const Color limeBright = Color(0xFF84CC16);
  static const Color limePrimary = Color(0xFF65A30D);
  static const Color limeDark = Color(0xFF4D7C0F);
  static const Color limeLight = Color(0xFFECFCCB);
  static const Color limeBorder = Color(0xFFA3E635);
  static const Color limeGlow = Color(0x4084CC16);

  // Warm Off-White & Earth Surfaces (Readability, Forms, Clean Cards)
  static const Color warmBackground = Color(0xFFF8FAF5);
  static const Color surfacePure = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF3F6EE);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceBorder = Color(0xFFE2E8DE);
  static const Color surfaceDivider = Color(0xFFEAEFE7);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A2E26);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);
  static const Color textOnDark = Color(0xFFF0FDF4);
  static const Color textOnLime = Color(0xFF0F291E);

  // Status Colors (Land Review & Agricultural Alerts)
  static const Color statusApproved = Color(0xFF15803D); // معتمد
  static const Color statusApprovedBg = Color(0xFFDCFCE7);
  static const Color statusReview = Color(0xFFD97706); // قيد المراجعة والتدقيق
  static const Color statusReviewBg = Color(0xFFFEF3C7);
  static const Color statusDraft = Color(0xFF64748B); // مسودة
  static const Color statusDraftBg = Color(0xFFF1F5F9);
  static const Color statusAlert = Color(0xFFDC2626); // تنبيه زراعي / آفة
  static const Color statusAlertBg = Color(0xFFFEE2E2);

  // Translucent / Glass Surfaces
  static const Color glassWhite = Color(0xEEFFFFFF);
  static const Color glassDark = Color(0xD00F3827);
  static const Color glassBorder = Color(0x332D6A4F);

  // Gradients
  static const LinearGradient forestHeroGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF0A291B),
      Color(0xFF0F3827),
      Color(0xFF1B4D3E),
    ],
  );

  static const LinearGradient limeActionGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFF84CC16),
      Color(0xFF65A30D),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xD9FFFFFF),
      Color(0xB3FFFFFF),
    ],
  );

  static const LinearGradient sunsetAgriculturalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x30155E3D),
      Color(0x1084CC16),
      Colors.transparent,
    ],
  );
}
