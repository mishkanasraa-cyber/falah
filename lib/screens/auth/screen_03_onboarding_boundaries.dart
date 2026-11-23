import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_04_onboarding_track.dart';
import 'screen_05_welcome.dart';

class Screen03OnboardingBoundaries extends StatelessWidget {
  const Screen03OnboardingBoundaries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Screen05Welcome()),
              );
            },
            child: Text(
              'تخطي',
              style: AppTypography.labelMedium.copyWith(color: AppColors.forestPrimary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),

              // Boundaries and GPS Graphic
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFFE0F2FE), Color(0xFFF0FDF4), Colors.transparent],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.forestDark,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.forestPrimary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.polyline_rounded, size: 72, color: AppColors.limeBright),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'الموقع وتحديد الحدود',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.forestDarkest,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'التقط إحداثيات موقعك عبر GPS الميداني أو ارسم أركان مضلع الأرض على الخريطة لحساب المساحة التقديرية بالدونم والهكتار (بشكل استرشادي غير معتمد كمساحة نهائية).',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildDot(false),
                      const SizedBox(width: 6),
                      _buildDot(true),
                      const SizedBox(width: 6),
                      _buildDot(false),
                    ],
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.limeBright,
                      foregroundColor: AppColors.forestDarkest,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Screen04OnboardingTrack()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'التالي',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.forestDarkest),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.forestPrimary : AppColors.surfaceBorder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
