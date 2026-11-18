import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../home/14_farmer_home_screen.dart';
import '../home/15_field_surveyor_home_screen.dart';
import 'screen_06_role_selection.dart';
import 'screen_11_forgot_password.dart';

class Screen07Login extends StatefulWidget {
  const Screen07Login({super.key});

  @override
  State<Screen07Login> createState() => _Screen07LoginState();
}

class _Screen07LoginState extends State<Screen07Login> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: '+218 91 234 5678');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
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
    final appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'أهلاً بك مجدداً',
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أدخل رقم هاتفك أو بريدك المسجل للوصول إلى سجلاتك الزراعية.',
                  style: AppTypography.bodyMedium,
                ),

                const SizedBox(height: 24),

                // Role Indicator Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        appState.currentRole == UserRole.farmer
                            ? Icons.agriculture_rounded
                            : Icons.assignment_ind_rounded,
                        color: AppColors.forestPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'الدور الحالي: ${appState.currentRole.nameAr}',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Screen06RoleSelection()),
                          );
                        },
                        child: const Text('تبديل الدور'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Phone or Email Input
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف أو البريد الإلكتروني *',
                    hintText: '091xxxxxxx أو email@domain.ly',
                    prefixIcon: Icon(Icons.phone_android_rounded, color: AppColors.forestPrimary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال رقم الهاتف أو البريد';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور *',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.forestPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'كلمة المرور يجب أن لا تقل عن 6 خانات';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Remember Me & Forgot Password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.forestPrimary,
                      onChanged: (val) => setState(() => _rememberMe = val ?? true),
                    ),
                    Text('تذكرني', style: AppTypography.bodySmall),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Screen11ForgotPassword()),
                        );
                      },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.forestPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Submit Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeBright,
                    foregroundColor: AppColors.forestDarkest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forestDarkest),
                        )
                      : Text(
                          'دخول',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                ),

                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ليس لديك حساب بعد؟', style: AppTypography.bodyMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Screen06RoleSelection()),
                        );
                      },
                      child: Text(
                        'إنشاء حساب جديد',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.forestPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
