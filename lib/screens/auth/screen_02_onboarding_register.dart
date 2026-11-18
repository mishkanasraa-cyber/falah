import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_03_onboarding_boundaries.dart';
import 'screen_05_welcome.dart';

class Screen02OnboardingRegister extends StatelessWidget {
  const Screen02OnboardingRegister({super.key});

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

              // Rich Agricultural Atmosphere Graphic
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFFDCFCE7), Color(0xFFF0FDF4), Colors.transparent],
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
                    child: const Icon(Icons.add_business_rounded, size: 72, color: AppColors.limeBright),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'توثيق أرضك يبدأ بخطوة',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.forestDarkest,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                'سجّل حيازتك الزراعية، محاصيلك القائمة، ومستنداتك الرسمية بسهولة وأمان ضمن السجل الزراعي الوطني الموحد في ليبيا.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Indicators & Next
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: [
                      _buildDot(true),
                      const SizedBox(width: 6),
                      _buildDot(false),
                      const SizedBox(width: 6),
                      _buildDot(false),
                    ],
                  ),

                  // Next Button
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
                        MaterialPageRoute(builder: (_) => const Screen03OnboardingBoundaries()),
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
