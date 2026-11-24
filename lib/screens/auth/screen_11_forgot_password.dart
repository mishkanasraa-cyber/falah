import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/app_logo.dart';

class Screen11ForgotPassword extends StatefulWidget {
  const Screen11ForgotPassword({super.key});

  @override
  State<Screen11ForgotPassword> createState() =>
      _Screen11ForgotPasswordState();
}

class _Screen11ForgotPasswordState extends State<Screen11ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final emailRegex =
        RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(val.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  void _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Top decoration ──────────────────────────────────────
              SizedBox(
                height: 170,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6EDD0),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(110),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 72,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBF5E6),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(72),
                          ),
                        ),
                      ),
                    ),
                    // Back button
                    Positioned(
                      top: 12,
                      left: 12,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF1B2E22),
                          size: 20,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          const AppLogo(size: 85),
                          const SizedBox(height: 6),
                          Text(
                            'فلاح',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1B2E22),
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Content ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _emailSent
                    ? _buildSuccessView()
                    : _buildFormView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Form view ─────────────────────────────────────────────────────────────
  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Lock icon
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF5E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 30,
                color: Color(0xFF2B6040),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1B2E22),
              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            'أدخل بريدك الإلكتروني المسجّل وسنرسل لك\nرابطاً لإعادة تعيين كلمة المرور.',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF6B7B72),
              height: 1.7,
              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Email field
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1B2E22),
              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
            ),
            decoration: InputDecoration(
              hintText: 'البريد الإلكتروني',
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.textMuted,
                size: 20,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFF2B6040), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFDC2626)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFFDC2626), width: 1.5),
              ),
            ),
            validator: _validateEmail,
          ),

          const SizedBox(height: 24),

          // Send button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B6040),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isLoading ? null : _sendResetEmail,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'إرسال رابط الاستعادة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamilyFallback:
                            AppTypography.arabicFontFamilyFallback,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Back to login
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'العودة لتسجيل الدخول',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B6040),
                  fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── Success view (after email sent) ───────────────────────────────────────
  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Success icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFEBF5E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              size: 40,
              color: Color(0xFF2B6040),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'تم إرسال الرابط!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1B2E22),
            fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        Text(
          'تم إرسال رابط إعادة تعيين كلمة المرور إلى:\n${_emailCtrl.text.trim()}\n\nيرجى مراجعة بريدك الإلكتروني واتباع التعليمات.',
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF6B7B72),
            height: 1.75,
            fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF5E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB8DDB0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Color(0xFF2B6040), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'إذا لم يصل البريد، تحقق من مجلد الرسائل غير المرغوب فيها (Spam).',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2B6040),
                    height: 1.5,
                    fontFamilyFallback:
                        AppTypography.arabicFontFamilyFallback,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B6040),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'العودة لتسجيل الدخول',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
