import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import 'screen_08_create_account.dart';

class Screen06RoleSelection extends StatefulWidget {
  const Screen06RoleSelection({super.key});

  @override
  State<Screen06RoleSelection> createState() => _Screen06RoleSelectionState();
}

class _Screen06RoleSelectionState extends State<Screen06RoleSelection> {
  UserRole _selectedRole = UserRole.farmer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تحديد نوع الحساب'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ما هو دورك في منظومة فلاح؟',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.forestDarkest,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'حدد صفتك لتخصيص الشاشات والصلاحيات المسموح بها وفق الإجراءات المعتمدة.',
                style: AppTypography.bodyMedium,
              ),

              const SizedBox(height: 28),

              // Role 1: Farmer
              _buildRoleCard(
                role: UserRole.farmer,
                title: 'مزارع / صاحب حيازة',
                subtitle: 'توثيق وتعديل أراضيك الخاصة ومحاصيلك ومتابعة حالات المراجعة والاعتماد.',
                icon: Icons.agriculture_rounded,
                badge: 'الحساب الفردي للمالك',
              ),

              const SizedBox(height: 16),

              // Role 2: Field Surveyor
              _buildRoleCard(
                role: UserRole.fieldSurveyor,
                title: 'موظف حصر زراعي معتمد',
                subtitle: 'إجراء الحصر الميداني والبحث عن المزارعين وتوثيق الأراضي نيابة عنهم بموجب تصريح.',
                icon: Icons.assignment_ind_rounded,
                badge: 'للمفتشين والباحثين الميدانيين',
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
                  AppState().switchRole(_selectedRole);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Screen08CreateAccount(selectedRole: _selectedRole),
                    ),
                  );
                },
                child: Text(
                  'المتابعة كـ ${_selectedRole.nameAr}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.forestPrimary : AppColors.surfaceBorder,
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.forestPrimary.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.limeLight : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? AppColors.forestPrimary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Radio<UserRole>(
                        value: role,
                        groupValue: _selectedRole,
                        activeColor: AppColors.forestPrimary,
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedRole = val);
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.forestMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
