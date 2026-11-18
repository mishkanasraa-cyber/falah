import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_10_verification_code.dart';

class Screen11ForgotPassword extends StatefulWidget {
  const Screen11ForgotPassword({super.key});

  @override
  State<Screen11ForgotPassword> createState() => _Screen11ForgotPasswordState();
}

class _Screen11ForgotPasswordState extends State<Screen11ForgotPassword> {
  final _controller = TextEditingController(text: '+218 91 234 5678');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen10VerificationCode(
          destinationPhone: _controller.text.trim(),
          isPasswordReset: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_reset_rounded, size: 36, color: AppColors.forestPrimary),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'نسيت كلمة المرور؟',
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'أدخل رقم هاتفك المسجل وسنرسل لك رمز تحقق مؤقت لتعيين كلمة مرور جديدة لحسابك.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف المسجل أو البريد *',
                    hintText: '091xxxxxxx',
                    prefixIcon: Icon(Icons.phone_rounded, color: AppColors.forestPrimary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال رقم الهاتف المسجل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeBright,
                    foregroundColor: AppColors.forestDarkest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _sendResetCode,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forestDarkest),
                        )
                      : Text(
                          'إرسال رمز الاستعادة',
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
}
