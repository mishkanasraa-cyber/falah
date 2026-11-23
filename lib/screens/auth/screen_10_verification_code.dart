import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'screen_12_set_new_password.dart';
import 'screen_13_account_created.dart';

class Screen10VerificationCode extends StatefulWidget {
  final String destinationPhone;
  final bool isPasswordReset;

  const Screen10VerificationCode({
    super.key,
    required this.destinationPhone,
    this.isPasswordReset = false,
  });

  @override
  State<Screen10VerificationCode> createState() =>
      _Screen10VerificationCodeState();
}

class _Screen10VerificationCodeState extends State<Screen10VerificationCode> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimerSeconds = 59;
  Timer? _timer;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // رمز تجريبي معبأ مسبقًا.
    _codeControllers[0].text = '4';
    _codeControllers[1].text = '2';
    _codeControllers[2].text = '8';
    _codeControllers[3].text = '1';
    _codeControllers[4].text = '9';
    _codeControllers[5].text = '0';
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimerSeconds = 59);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds > 0) {
        setState(() => _resendTimerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _codeControllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  String get _maskedPhone {
    final phone = widget.destinationPhone;

    if (phone.length >= 7) {
      return '${phone.substring(0, 5)} *** **'
          '${phone.substring(phone.length - 2)}';
    }

    return phone;
  }

  Future<void> _verifyCode() async {
    if (_isLoading) return;

    final code = _codeControllers.map((controller) => controller.text).join();

    if (code.length < 6) {
      setState(() {
        _errorMessage = 'يرجى إدخال الرمز المكون من 6 أرقام كاملاً';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (widget.isPasswordReset) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen12SetNewPassword()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen13AccountCreated()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(title: const Text('التحقق من رقم الهاتف')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.limeLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_rounded,
                    size: 36,
                    color: AppColors.forestDark,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'أدخل رمز التحقق (OTP)',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.forestDarkest,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'تم إرسال رسالة نصية قصيرة تحتوي رمز التأكيد '
                'المكون من 6 أرقام إلى الرقم:',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _maskedPhone,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // خانات رمز التحقق.
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 46,
                      height: 56,
                      child: TextField(
                        controller: _codeControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.forestDarkest,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: AppColors.surfacePure,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.surfaceBorder,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.forestPrimary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }

                          if (index == 5 && value.isNotEmpty) {
                            _verifyCode();
                          }
                        },
                      ),
                    );
                  }),
                ), // إغلاق Row.
              ), // إغلاق Directionality.

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.statusAlert,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 28),
              Center(
                child: _resendTimerSeconds > 0
                    ? Text(
                        'إعادة إرسال الرمز بعد '
                        '00:${_resendTimerSeconds.toString().padLeft(2, '0')} ثانية',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      )
                    : TextButton.icon(
                        onPressed: _startTimer,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('إعادة إرسال رمز جديد'),
                      ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.limeBright,
                  foregroundColor: AppColors.forestDarkest,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isLoading ? null : _verifyCode,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.forestDarkest,
                        ),
                      )
                    : Text(
                        'تأكيد ومتابعة',
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
    );
  }
}
