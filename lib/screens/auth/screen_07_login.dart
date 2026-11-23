import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_logo.dart';
import '../home/14_farmer_home_screen.dart';
import '../home/15_field_surveyor_home_screen.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Real logo
                const FalahLogo(size: 90),

                const SizedBox(height: 10),

                // Brand name
                Text(
                  'فلاح',
                  style: AppTypography.headlineLarge.copyWith(
                    color: const Color(0xFF1A2E26),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                ),

                const SizedBox(height: 20),

                // Page title
                Text(
                  'تسجيل الدخول',
                  style: AppTypography.displayMedium.copyWith(
                    color: const Color(0xFF1A2E26),
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                ),

                const SizedBox(height: 28),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Phone field
                      _buildInputField(
                        controller: _phoneController,
                        hint: 'رقم الهاتف',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Password field
                      _buildInputField(
                        controller: _passwordController,
                        hint: 'كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (val) {
                          if (val == null || val.length < 6) {
                            return 'كلمة المرور يجب ألا تقل عن 6 أحرف';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Screen11ForgotPassword(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 32),
                          ),
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF2E6B40),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B40),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
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
                                  'تسجيل الدخول',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamilyFallback:
                                        AppTypography.arabicFontFamilyFallback,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Decorative farm illustration bottom area
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE8F5E9),
                              Color(0xFFC8E6C9),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '🌾  🌿  🌱',
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 14,
        color: const Color(0xFF1A2E26),
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
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF2E6B40), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}
