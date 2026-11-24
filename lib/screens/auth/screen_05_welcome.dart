import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/app_logo.dart';
import 'screen_07_login.dart';
import 'screen_08_create_account.dart';

class Screen05Welcome extends StatelessWidget {
  const Screen05Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Upper section ───────────────────────────────────────────
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  // Light-green top-right blob
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 130,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD6EDD0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(120),
                        ),
                      ),
                    ),
                  ),
                  // Smaller lighter blob inside
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 80,
                      height: 65,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBF5E6),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                        ),
                      ),
                    ),
                  ),

                  // Center content
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo — no circle background, just the image
                          const AppLogo(size: 130),

                          const SizedBox(height: 22),

                          // Title
                          Text(
                            'مرحباً بك في فلاح',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1B2E22),
                              height: 1.3,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Description
                          Text(
                            'منصتك الذكية لتسجيل الأراضي الزراعية\nوإدارة بيانات محاصيلك يكل سهولة.',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF6B7B72),
                              height: 1.75,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Buttons section ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Login — filled green
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B6040),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Screen07Login()),
                      ),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamilyFallback:
                              AppTypography.arabicFontFamilyFallback,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Create account — outlined
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1B2E22),
                        side: const BorderSide(
                            color: Color(0xFFBDBDBD), width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Screen08CreateAccount()),
                      ),
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B2E22),
                          fontFamilyFallback:
                              AppTypography.arabicFontFamilyFallback,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bottom tagline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_rounded,
                          size: 14, color: Color(0xFF2B6040)),
                      const SizedBox(width: 5),
                      Text(
                        'معاً نحو زراعة رقمية مستدامة',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontFamilyFallback:
                              AppTypography.arabicFontFamilyFallback,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
