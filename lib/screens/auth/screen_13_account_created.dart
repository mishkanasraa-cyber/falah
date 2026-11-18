import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../home/14_farmer_home_screen.dart';
import '../home/15_field_surveyor_home_screen.dart';

class Screen13AccountCreated extends StatelessWidget {
  const Screen13AccountCreated({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final isSurveyor = appState.currentRole == UserRole.fieldSurveyor;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Success Icon Animation
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.statusApprovedBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.statusApproved.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.statusApproved),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'تم إنشاء حسابك بنجاح!',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.forestDarkest,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'أهلاً بك يا ${appState.userName}، تم تفعيل حسابك كـ (${appState.currentRole.nameAr}) في السجل الزراعي الوطني.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Actual Next Step Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfacePure,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.limeLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.rocket_launch_rounded, color: AppColors.forestDark, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'الخطوة التالية المتاحة لك:',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isSurveyor
                          ? 'بصفتك موظف حصر زراعي، يمكنك التوجه إلى الشاشة الرئيسية للبحث عن المزارعين، التحقق من هوياتهم، وتوثيق الأراضي الميدانية المصرح لك بها.'
                          : 'يمكنك الآن البدء بتوثيق أول أرض زراعية لك، التقاط موقعها عبر GPS، رسم مضلع الحدود بالخريطة، وإرسالها للمراجعة في منصة جُذور.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.limeBright,
                  foregroundColor: AppColors.forestDarkest,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  if (isSurveyor) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Screen15FieldSurveyorHome()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Screen14FarmerHome()),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  'الانتقال إلى الرئيسية',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
