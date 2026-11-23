import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import 'screen_10_verification_code.dart';

class Screen09IdentityMunicipality extends StatefulWidget {
  final String fullName;
  final String phone;
  final String email;
  final UserRole role;

  const Screen09IdentityMunicipality({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.role,
  });

  @override
  State<Screen09IdentityMunicipality> createState() =>
      _Screen09IdentityMunicipalityState();
}

class _Screen09IdentityMunicipalityState
    extends State<Screen09IdentityMunicipality> {
  final _formKey = GlobalKey<FormState>();

  final _nationalIdController = TextEditingController(text: '119850239481');
  final _branchOfficeController = TextEditingController();
  final _farmerCardController = TextEditingController();

  String _selectedMunicipality = 'ترهونة';

  final List<String> _municipalities = [
    'ترهونة',
    'السواني بن آدم',
    'العزيزية',
    'سيدي السائح',
    'قصر بن غشير',
    'عين زارة',
    'تاجوراء',
    'مصراتة',
    'زليتن',
    'الخمس ومسلاتة',
    'الزاوية الغرب',
    'صرمان وصبراتة',
    'غريان',
    'بني وليد',
    'المرج والبيضاء',
    'بنغازي وسلوق',
    'سبها ووادي الآجال',
  ];

  @override
  void dispose() {
    _nationalIdController.dispose();
    _branchOfficeController.dispose();
    _farmerCardController.dispose();
    super.dispose();
  }

  void _submitIdentity() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // حفظ بيانات المستخدم في حالة التطبيق.
    AppState().setCustomUserData(
      name: widget.fullName,
      phone: widget.phone,
      nationalId: _nationalIdController.text.trim(),
      municipality: _selectedMunicipality,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen10VerificationCode(
          destinationPhone: widget.phone,
          isPasswordReset: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(title: const Text('بيانات الهوية والبلدية')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'التثبت من الهوية الوطنية',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'خطوة 2 من 3: يرجى إدخال الرقم الوطني والبلدية '
                  'التابع لها الحقل الزراعي بدقة لمطابقة السجلات.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 24),

                // الرقم الوطني.
                TextFormField(
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الوطني الليبي (12 رقماً) *',
                    hintText: '119xxxxxxxx',
                    prefixIcon: Icon(
                      Icons.badge_rounded,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length != 12) {
                      return 'الرقم الوطني يجب أن يتكون من 12 رقماً تماماً';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // اختيار البلدية.
                DropdownButtonFormField<String>(
                  initialValue: _selectedMunicipality,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'البلدية أو الفرع البلدي *',
                    prefixIcon: Icon(
                      Icons.location_city_rounded,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                  items: _municipalities.map((municipality) {
                    return DropdownMenuItem<String>(
                      value: municipality,
                      child: Text(municipality),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMunicipality = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // المكتب الزراعي أو المحلة.
                TextFormField(
                  controller: _branchOfficeController,
                  decoration: const InputDecoration(
                    labelText: 'المكتب الزراعي أو المحلة (اختياري)',
                    hintText: 'مثال: مكتب إرشاد سيدي السائح',
                    prefixIcon: Icon(
                      Icons.apartment_rounded,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // بطاقة الفلاح أو الحيازة السابقة.
                TextFormField(
                  controller: _farmerCardController,
                  decoration: const InputDecoration(
                    labelText: 'رقم بطاقة فلاح أو الحيازة السابقة (اختياري)',
                    hintText: 'مثال: LY-AGR-4021',
                    prefixIcon: Icon(
                      Icons.credit_card_rounded,
                      color: AppColors.forestPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ملاحظة الخصوصية.
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColors.forestPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'تستخدم هذه البيانات حصراً لمطابقة '
                          'السجل العقاري الزراعي مع منصة جُذور.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeBright,
                    foregroundColor: AppColors.forestDarkest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submitIdentity,
                  child: Text(
                    'إرسال رمز التحقق (SMS)',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
