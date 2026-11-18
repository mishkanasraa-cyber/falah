import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_02_onboarding_register.dart';

class Screen01Splash extends StatefulWidget {
  const Screen01Splash({super.key});

  @override
  State<Screen01Splash> createState() => _Screen01SplashState();
}

class _Screen01SplashState extends State<Screen01Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Screen02OnboardingRegister()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestDarkest,
      body: Stack(
        children: [
          // Background Atmospheric Soil & Agriculture Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF071F15),
                  Color(0xFF0F3827),
                  Color(0xFF14532D),
                ],
              ),
            ),
          ),

          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Official Falah Leaf & Soil Badge
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.limeBright.withValues(alpha: 0.35),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.eco_rounded, size: 54, color: AppColors.limeDark),
                          Positioned(
                            bottom: 16,
                            child: Container(
                              width: 32,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5A2B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Brand Title
                    Text(
                      'FALAH | فلاح',
                      style: AppTypography.displayMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'المنظومة الرقمية لتوثيق الأراضي والمحاصيل في ليبيا',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.limeLight.withValues(alpha: 0.9),
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 34),

                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.limeBright),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              'دولة ليبيا • مشروع الحصر الزراعي السيادي 2027',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
