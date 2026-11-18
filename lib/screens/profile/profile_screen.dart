import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/user_role.dart';
import '../../services/app_state.dart';
import '../../services/gemini_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/falah_app_bar.dart';
import '../ai_assistant/gemini_api_key_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _appState.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _appState.currentUser;
    final geminiService = GeminiService();
    final weatherService = WeatherService();

    return Scaffold(
      appBar: const FalahAppBar(
        title: 'الملف الزراعي والحساب',
        subtitle: 'بيانات الهوية وبطاقة فلاح الوطنية',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Digital Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF0F3827),
                    Color(0xFF1B4D3E),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.limeBorder.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.limeBright,
                        child: Text(
                          user.avatarInitials,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.forestDarkest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: AppTypography.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'بطاقة فلاح: ${user.agriculturalCardNumber}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.limeLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.limeBright,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.role.badgeText,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardMeta('الرقم الوطني:', user.nationalId),
                      _buildCardMeta('المنطقة:', user.city),
                      _buildCardMeta('الهاتف:', user.phone),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Role Switcher Section (Mandatory for Testing User Roles)
            Text('تبديل دور المستخدم (صلاحيات النظام):', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: UserRole.values.map((role) {
                  final isSelected = user.role == role;
                  return RadioListTile<UserRole>(
                    value: role,
                    groupValue: user.role,
                    activeColor: AppColors.limeDark,
                    title: Text(
                      role.nameAr,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.forestDarkest : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(role.descriptionAr, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                    onChanged: (newRole) {
                      if (newRole != null) {
                        _appState.switchRole(newRole);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم التبديل بنجاح إلى: ${newRole.nameAr}'),
                            backgroundColor: AppColors.forestPrimary,
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 22),

            // AI & Integrations Section
            Text('إعدادات الذكاء الاصطناعي والتكامل:', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.limeLight,
                      child: Icon(Icons.psychology_rounded, color: AppColors.limeDark),
                    ),
                    title: Text('مفتاح Gemini API', style: AppTypography.titleSmall),
                    subtitle: Text(
                      geminiService.isConfigured
                          ? 'متصل عبر السحابة بمفتاح خاص'
                          : 'يعمل بمحرك الخبرة الزراعية المدمج',
                      style: AppTypography.bodySmall,
                    ),
                    trailing: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const GeminiApiKeyDialog(),
                        );
                      },
                      child: Text(geminiService.isConfigured ? 'تعديل' : 'إدخال مفتاح'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.surfaceElevated,
                      child: Icon(Icons.satellite_alt_rounded, color: AppColors.forestPrimary),
                    ),
                    title: Text('محطة الأرصاد المناخية', style: AppTypography.titleSmall),
                    subtitle: Text(
                      weatherService.isConnected
                          ? 'متصل بـ: ${weatherService.connectedStation!.name}'
                          : 'غير متصل بمحطة رصد محلية',
                      style: AppTypography.bodySmall,
                    ),
                    trailing: Text(
                      weatherService.isConnected ? 'مفعل' : 'غير متصل',
                      style: AppTypography.labelSmall.copyWith(
                        color: weatherService.isConnected ? AppColors.statusApproved : AppColors.statusDraft,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // App System Info
            Text('عن المنومة والدعم:', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.forestPrimary),
                    title: Text('واجهة التطبيق', style: AppTypography.titleSmall),
                    subtitle: const Text('اللغة العربية (RTL) - مواءمة للبيئة الزراعية الليبية'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_rounded, color: AppColors.forestPrimary),
                    title: Text('الأمان والسيادة العقارية', style: AppTypography.titleSmall),
                    subtitle: const Text('جميع بيانات الحيازات والملكيات مشفرة ومطابقة للقوانين العقارية'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
