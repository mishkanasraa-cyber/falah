import 'package:flutter/material.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/falah_ui.dart';

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

  void _send() async {
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
      body: Stack(
        children: [
          const TopLeftBlob(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Logo
                  const AppLogo(size: 85),
                  const SizedBox(height: 6),
                  const Text(
                    'فلاح',
                    style: TextStyle(
                      color: FalahColors.darkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: FalahColors.blobLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: FalahColors.darkGreen,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      color: FalahColors.darkGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'أدخل بريدك الإلكتروني وسنرسل لك\nرابطاً لإعادة تعيين كلمة المرور.',
                    style: TextStyle(
                      color: FalahColors.hint,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  if (_emailSent) ...[
                    // Success state
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: FalahColors.blobLighter,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: FalahColors.blobLight, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.mark_email_read_outlined,
                              color: FalahColors.darkGreen, size: 42),
                          const SizedBox(height: 12),
                          const Text(
                            'تم الإرسال بنجاح!',
                            style: TextStyle(
                              color: FalahColors.darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'تم إرسال رابط إعادة التعيين إلى\n${_emailCtrl.text.trim()}',
                            style: const TextStyle(
                                color: FalahColors.hint,
                                fontSize: 13,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'العودة لتسجيل الدخول',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ] else ...[
                    // Form state
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          FalahField(
                            controller: _emailCtrl,
                            label: 'البريد الإلكتروني',
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                        .hasMatch((v ?? '').trim())
                                    ? null
                                    : 'أدخل بريداً إلكترونياً صحيحاً',
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: 'إرسال رابط الاسترداد',
                            onPressed: _send,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'العودة لتسجيل الدخول',
                              style: TextStyle(
                                color: FalahColors.darkGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
