import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/falah_ui.dart';
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
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hidePass = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
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
      body: Stack(
        children: [
          // ── Top-left blob ──
          const TopLeftBlob(),

          SafeArea(
            child: Column(
              children: [
                // ── Upper: logo + form ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
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
                          const SizedBox(height: 18),

                          // Title
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: FalahColors.darkGreen,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Phone field
                          FalahField(
                            controller: _phoneCtrl,
                            label: 'رقم الهاتف',
                            hint: '09XXXXXXXX',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: validateLibyanPhone,
                          ),
                          const SizedBox(height: 12),

                          // Password field
                          FalahField(
                            controller: _passCtrl,
                            label: 'كلمة المرور',
                            icon: Icons.lock_outline,
                            obscure: _hidePass,
                            validator: validatePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _hidePass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: FalahColors.hint,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _hidePass = !_hidePass),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Forgot password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const Screen11ForgotPassword()),
                              ),
                              child: const Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: FalahColors.midGreen,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: FalahColors.midGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Login button
                          PrimaryButton(
                            text: 'تسجيل الدخول',
                            onPressed: _login,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 18),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟ ',
                                style: TextStyle(
                                    color: Color(0xFF5A7A65), fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const Screen08CreateAccount()),
                                ),
                                child: const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: FalahColors.darkGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: FalahColors.darkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom illustration (palms + greenhouse) ──
                const SizedBox(height: 150, child: Stack(children: [FarmScene(withPalms: true)])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
