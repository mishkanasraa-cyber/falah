import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/app_logo.dart';
import '../home/14_farmer_home_screen.dart';
import '../home/15_field_surveyor_home_screen.dart';
import 'screen_08_create_account.dart';
import 'screen_11_forgot_password.dart';

class Screen07Login extends StatefulWidget {
  const Screen07Login({super.key});

  @override
  State<Screen07Login> createState() => _Screen07LoginState();
}

class _Screen07LoginState extends State<Screen07Login> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates Libyan phone: starts with 091/092/093/094, exactly 10 digits
  String? _validatePhone(String? val) {
    final v = val?.trim().replaceAll(' ', '') ?? '';
    if (!RegExp(r'^09[1-4]\d{7}$').hasMatch(v)) {
      return 'أدخل رقماً صحيحاً مثل 0912345678';
    }
    return null;
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _isLoading = false);
    if (!mounted) return;

    final appState = AppState();
    if (appState.currentRole == UserRole.fieldSurveyor) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Screen15FieldSurveyorHome()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Screen14FarmerHome()),
        (route) => false,
      );
    }
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
              // ─── Top decoration + logo ──────────────────────────────
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    // Top-right green blob
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 130,
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6EDD0),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(120),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 80,
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBF5E6),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(80),
                          ),
                        ),
                      ),
                    ),

                    // Logo + brand centered
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          const AppLogo(size: 85),
                          const SizedBox(height: 8),
                          Text(
                            'فلاح',
                            style: TextStyle(
                              fontSize: 22,
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

              // ─── Page title ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1B2E22),
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // ─── Form ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Phone
                      _field(
                        controller: _phoneController,
                        hint: '09XXXXXXXX',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: _validatePhone,
                      ),

                      const SizedBox(height: 14),

                      // Password
                      _field(
                        controller: _passwordController,
                        hint: 'كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.length < 6) {
                            return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Forgot password — aligned start (right in RTL)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const Screen11ForgotPassword()),
                          ),
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2B6040),
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login button
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
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white),
                                )
                              : Text(
                                  'تسجيل الدخول',
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

                      // ─── "ليس لديك حساب؟ إنشاء حساب" ───────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟ ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const Screen08CreateAccount()),
                            ),
                            child: Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2B6040),
                                fontFamilyFallback:
                                    AppTypography.arabicFontFamilyFallback,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Farm illustration bottom
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 85,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFE8F5E9),
                                Color(0xFFA5D6A7),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Greenhouse silhouette
                              Positioned(
                                bottom: 0,
                                left: 16,
                                child: CustomPaint(
                                  size: const Size(70, 55),
                                  painter: _GreenhousePainter(),
                                ),
                              ),
                              // Palm trees
                              Positioned(
                                bottom: 0,
                                right: 30,
                                child: CustomPaint(
                                  size: const Size(20, 60),
                                  painter: _PalmPainter(),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 65,
                                child: CustomPaint(
                                  size: const Size(16, 48),
                                  painter: _PalmPainter(),
                                ),
                              ),
                              // Ground lines
                              Positioned(
                                bottom: 10,
                                left: 90,
                                right: 100,
                                child: Column(
                                  children: List.generate(
                                    4,
                                    (i) => Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      height: 1.5,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50)
                                            .withValues(alpha: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      style: TextStyle(
        fontSize: 14,
        color: const Color(0xFF1B2E22),
        fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
        ),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints:
            const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        counterText: '',
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
          borderSide:
              const BorderSide(color: Color(0xFF2B6040), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
        errorMaxLines: 2,
      ),
      validator: validator,
    );
  }
}

// ─── Painters ─────────────────────────────────────────────────────────────────

class _GreenhousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF4CAF50).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.35, size.width, size.height * 0.65),
        const Radius.circular(4),
      ),
      p,
    );
    // Roof triangle
    final roof = Path()
      ..moveTo(0, size.height * 0.37)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.37)
      ..close();
    canvas.drawPath(roof, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _PalmPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final trunk = Paint()
      ..color = const Color(0xFF795548)
      ..strokeWidth = size.width * 0.3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        Offset(size.width / 2, size.height),
        Offset(size.width / 2, size.height * 0.3),
        trunk);

    final leaf = Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height * 0.3;
    final dirs = [
      [cx - size.width * 1.5, cy - size.height * 0.15],
      [cx + size.width * 1.5, cy - size.height * 0.15],
      [cx - size.width, cy - size.height * 0.4],
      [cx + size.width, cy - size.height * 0.4],
      [cx, cy - size.height * 0.3],
    ];
    for (final d in dirs) {
      canvas.drawLine(Offset(cx, cy), Offset(d[0], d[1]), leaf);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
