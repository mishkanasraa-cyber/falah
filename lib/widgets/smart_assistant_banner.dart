import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../screens/ai_assistant/ai_assistant_screen.dart';

class SmartAssistantBanner extends StatelessWidget {
  final VoidCallback? onCustomTap;

  const SmartAssistantBanner({super.key, this.onCustomTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF0F3827),
            Color(0xFF14532D),
            Color(0xFF1B4D3E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.limeBorder.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3827).withValues(alpha: 0.25),
            offset: const Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative natural glow
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.limeBright.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Banner Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.limeLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: AppColors.limeDark, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            'مدعوم بتقنية Gemini API',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.limeDark,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: AppColors.limeBright,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Main Title & Subtitle
                Text(
                  'مساعد فلاح الذكي 🌿',
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تشخيص فوري لأمراض المحاصيل عبر الصور، وحساب دقيق لجرعات التسميد والري متوافق مع البيئة الليبية.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textOnDark.withValues(alpha: 0.9),
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 14),

                // Quick Feature Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildFeatureChip(
                      icon: Icons.camera_enhance_rounded,
                      label: 'فحص الأوراق والثمار',
                    ),
                    _buildFeatureChip(
                      icon: Icons.calculate_rounded,
                      label: 'حاسبة التسميد NPK',
                    ),
                    _buildFeatureChip(
                      icon: Icons.calendar_month_rounded,
                      label: 'الروزنامة الزراعية',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.limeBright,
                      foregroundColor: AppColors.forestDarkest,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onCustomTap ??
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AIAssistantScreen(),
                            ),
                          );
                        },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تحدث مع المستشار الزراعي الذكي',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.forestDarkest),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.limeBright),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
            ),
          ),
        ],
      ),
    );
  }
}
