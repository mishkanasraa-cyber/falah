import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/falah_logo.dart';
import 'screen_07_login.dart';
import 'screen_08_create_account.dart';

class Screen05Welcome extends StatelessWidget {
  const Screen05Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top decorative green band
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Light green decorative background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: size.height * 0.20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDF5E8),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                    ),
                  ),

                  // Corner accent
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 100,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7ECC8),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Real logo
                      const FalahLogo(size: 110),

                      const SizedBox(height: 20),

                      // Welcome title
                      Text(
                        'مرحباً بك في فلاح',
                        style: AppTypography.displayMedium.copyWith(
                          color: const Color(0xFF1A2E26),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          fontFamilyFallback:
                              AppTypography.arabicFontFamilyFallback,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'منصتك الذكية لتسجيل الأراضي\nالزراعية وإدارة بيانات محاصيلك\nبكل سهولة.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.7,
                            fontFamilyFallback:
                                AppTypography.arabicFontFamilyFallback,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom buttons section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Login button (filled green)
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B40),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Screen07Login(),
                            ),
                          );
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamilyFallback:
                                AppTypography.arabicFontFamilyFallback,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Create account button (outlined)
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A2E26),
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Screen08CreateAccount(),
                            ),
                          );
                        },
                        child: Text(
                          'إنشاء حساب جديد',
                          style: AppTypography.labelLarge.copyWith(
                            color: const Color(0xFF1A2E26),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
                        const Icon(
                          Icons.eco_rounded,
                          size: 14,
                          color: Color(0xFF2E6B40),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'معاً نحو زراعة رقمية مستدامة',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            fontFamilyFallback:
                                AppTypography.arabicFontFamilyFallback,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
