import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_07_login.dart';

class Screen12SetNewPassword extends StatefulWidget {
  const Screen12SetNewPassword({super.key});

  @override
  State<Screen12SetNewPassword> createState() => _Screen12SetNewPasswordState();
}

class _Screen12SetNewPasswordState extends State<Screen12SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعيين كلمة المرور الجديدة بنجاح! يمكنك الآن تسجيل الدخول.'),
        backgroundColor: AppColors.forestPrimary,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Screen07Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تعيين كلمة المرور الجديدة'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'أنشئ كلمة مرور قوية',
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'اختر كلمة مرور آمنة لحماية حيازاتك وسجلاتك الزراعية.',
                  style: AppTypography.bodySmall,
                ),

                const SizedBox(height: 24),

                // New Password
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة *',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.forestPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'يجب أن لا تقل عن 6 أحرف أو أرقام';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة *',
                    prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.forestPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (val) {
                    if (val != _newPasswordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Requirements Checklist
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'شروط كلمة المرور:',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      _buildCheckItem('6 خانات على الأقل.'),
                      _buildCheckItem('تتضمن أرقاماً أو حروفاً واضحة.'),
                      _buildCheckItem('تجنب الأرقام المتتالية البسيطة مثل 123456.'),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeBright,
                    foregroundColor: AppColors.forestDarkest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _savePassword,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forestDarkest),
                        )
                      : Text(
                          'حفظ كلمة المرور والدخول',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
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

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.forestPrimary),
          const SizedBox(width: 8),
          Text(text, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
