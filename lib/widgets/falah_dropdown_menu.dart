import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/user_role.dart';
import '../services/app_state.dart';
import '../screens/ai_assistant/gemini_api_key_dialog.dart';

class FalahDropdownMenu {
  static void show(BuildContext context, RelativeRect position) {
    final appState = AppState();
    final user = appState.currentUser;
    final navigator = Navigator.of(context);

    showMenu<void>(
      context: context,
      position: position,
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      color: AppColors.surfacePure,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      items: [
        // User Header Card
        PopupMenuItem<void>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.surfaceDivider)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.forestPrimary,
                  child: Text(
                    user.avatarInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.limeLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user.role.badgeText,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.limeDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.city,
                              style: AppTypography.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick Role Switcher Header
        PopupMenuItem<void>(
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 2),
            child: Text(
              'تبديل دور المستخدم للتجربة:',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Role 1: Farmer
        PopupMenuItem<void>(
          onTap: () {
            appState.switchRole(UserRole.farmer);
          },
          child: Row(
            children: [
              Icon(
                Icons.agriculture_rounded,
                size: 18,
                color: user.role == UserRole.farmer ? AppColors.limeDark : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'فلاح / مزارع',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: user.role == UserRole.farmer ? FontWeight.bold : FontWeight.normal,
                    color: user.role == UserRole.farmer ? AppColors.forestPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (user.role == UserRole.farmer)
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.limePrimary),
            ],
          ),
        ),

        // Role 2: Agricultural Inspector
        PopupMenuItem<void>(
          onTap: () {
            appState.switchRole(UserRole.inspector);
          },
          child: Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 18,
                color: user.role == UserRole.inspector ? AppColors.limeDark : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'مهندس زراعي ومفتش',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: user.role == UserRole.inspector ? FontWeight.bold : FontWeight.normal,
                    color: user.role == UserRole.inspector ? AppColors.forestPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (user.role == UserRole.inspector)
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.limePrimary),
            ],
          ),
        ),

        // Role 3: Cooperative
        PopupMenuItem<void>(
          onTap: () {
            appState.switchRole(UserRole.cooperative);
          },
          child: Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 18,
                color: user.role == UserRole.cooperative ? AppColors.limeDark : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'مشرف جمعية زراعية',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: user.role == UserRole.cooperative ? FontWeight.bold : FontWeight.normal,
                    color: user.role == UserRole.cooperative ? AppColors.forestPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              if (user.role == UserRole.cooperative)
                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.limePrimary),
            ],
          ),
        ),

        const PopupMenuDivider(),

        // Gemini API Key Config
        PopupMenuItem<void>(
          onTap: () {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: navigator.context,
                builder: (ctx) => const GeminiApiKeyDialog(),
              );
            });
          },
          child: Row(
            children: [
              const Icon(Icons.psychology_rounded, size: 18, color: AppColors.forestPrimary),
              const SizedBox(width: 10),
              Text(
                'إعدادات مفتاح Gemini AI',
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        // About & Support
        PopupMenuItem<void>(
          onTap: () {
            Future.delayed(Duration.zero, () {
              showAboutDialog(
                context: navigator.context,
                applicationName: 'منظومة فلاح الزراعية',
                applicationVersion: '2.0.0 (دولة ليبيا)',
                applicationIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.forestDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco_rounded, color: AppColors.limeBright, size: 32),
                ),
                children: [
                  const Text(
                    'تطبيق فلاح هو منصة رقمية سيادية للتوثيق العقاري وحصر الحيازات الزراعية في ليبيا، '
                    'وربط المزارع بوزارة الزراعة لتوفير الأسمدة والأدوية والبذور الأصلية، '
                    'مدعومة بمستشار ذكي يستند إلى تقنيات Gemini.',
                    style: TextStyle(fontFamilyFallback: AppTypography.arabicFontFamilyFallback),
                  ),
                ],
              );
            });
          },
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text('عن فلاح والدعم الفني', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
