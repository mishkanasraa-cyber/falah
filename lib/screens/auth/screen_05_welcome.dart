import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_06_role_selection.dart';
import 'screen_07_login.dart';

class Screen05Welcome extends StatelessWidget {
  const Screen05Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Stack(
        children: [
          // Forest Green Hero Gradient Header
          Container(
            height: MediaQuery.of(context).size.height * 0.48,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.forestHeroGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.limeBright.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.eco_rounded, size: 48, color: AppColors.limeDark),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'FALAH | فـلاح',
                          style: AppTypography.displayLarge.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'المنصة الوطنية لتوثيق الأراضي والمحاصيل الزراعية',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.limeLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Card Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'مرحباً بك في منظومة فلاح',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اختر تسجيل الدخول بحسابك المسجل، أو ابدأ بإنشاء حساب جديد كمزارع أو موظف حصر معتمد.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Screen07Login()),
                      );
                    },
                    child: Text(
                      'تسجيل الدخول',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Create Account Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.forestDarkest,
                      side: const BorderSide(color: AppColors.forestPrimary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Screen06RoleSelection()),
                      );
                    },
                    child: Text(
                      'إنشاء حساب جديد',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'منظومة رسمية آمنة ومشفرة لمعلومات الحيازات',
                        style: AppTypography.bodySmall.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
