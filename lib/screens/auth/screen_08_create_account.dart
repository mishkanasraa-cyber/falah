import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../widgets/app_logo.dart';
import 'screen_07_login.dart';
import 'screen_09_identity_municipality.dart';

class Screen08CreateAccount extends StatefulWidget {
  final UserRole selectedRole;
  const Screen08CreateAccount({super.key, this.selectedRole = UserRole.farmer});

  @override
  State<Screen08CreateAccount> createState() => _Screen08CreateAccountState();
}

class _Screen08CreateAccountState extends State<Screen08CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _municipality;
  String? _userType;

  final List<String> _municipalities = [
    'ترهونة', 'السواني بن آدم', 'العزيزية', 'سيدي السائح',
    'قصر بن غشير', 'عين زارة', 'تاجوراء', 'مصراتة', 'زليتن',
    'الخمس', 'الزاوية', 'صبراتة', 'غريان', 'بني وليد',
    'المرج', 'البيضاء', 'بنغازي', 'سبها',
  ];

  final List<String> _userTypes = [
    'مزارع / صاحب حيازة',
    'موظف حصر زراعي',
    'مهندس زراعي',
    'مشرف بلدي',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  /// Libyan phone: 09[1-4] prefix + 7 digits = 10 total
  String? _validatePhone(String? val) {
    final v = val?.trim().replaceAll(' ', '') ?? '';
    if (!RegExp(r'^09[1-4]\d{7}$').hasMatch(v)) {
      return 'أدخل رقماً صحيحاً مثل 0912345678';
    }
    return null;
  }

  void _proceed() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen09IdentityMunicipality(
          fullName: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          role: widget.selectedRole,
        ),
      ),
    );
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
              // ─── Top decoration + logo ───────────────────────────────
              SizedBox(
                height: 185,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0, right: 0,
                      child: Container(
                        width: 120, height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6EDD0),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(110)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: Container(
                        width: 72, height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBF5E6),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(72)),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
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

              // Page title
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1B2E22),
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // ─── Form ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Full name
                      _field(
                        ctrl: _nameCtrl,
                        hint: 'الاسم الكامل',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().length < 3)
                            ? 'يرجى إدخال الاسم الكامل'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      // 2. Phone
                      _field(
                        ctrl: _phoneCtrl,
                        hint: 'رقم الهاتف',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: 10),

                      // 3. Email
                      _field(
                        ctrl: _emailCtrl,
                        hint: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),

                      // 4. Municipality dropdown
                      _dropdown(
                        value: _municipality,
                        hint: 'البلدية',
                        icon: Icons.location_on_outlined,
                        items: _municipalities,
                        onChanged: (v) => setState(() => _municipality = v),
                        validator: (v) =>
                            v == null ? 'يرجى اختيار البلدية' : null,
                      ),
                      const SizedBox(height: 10),

                      // 5. User type dropdown
                      _dropdown(
                        value: _userType,
                        hint: 'نوع المستخدم',
                        icon: Icons.people_outline_rounded,
                        items: _userTypes,
                        onChanged: (v) => setState(() => _userType = v),
                        validator: (v) =>
                            v == null ? 'يرجى اختيار نوع المستخدم' : null,
                      ),
                      const SizedBox(height: 10),

                      // 6. Password
                      _field(
                        ctrl: _passCtrl,
                        hint: 'كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePass,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          child: Icon(
                            _obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'لا تقل عن 6 أحرف'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      // 7. Confirm password
                      _field(
                        ctrl: _confirmCtrl,
                        hint: 'تأكيد كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                          child: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                        validator: (v) => v != _passCtrl.text
                            ? 'كلمتا المرور غير متطابقتين'
                            : null,
                      ),

                      const SizedBox(height: 24),

                      // Create account button
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
                          onPressed: _proceed,
                          child: Text(
                            'إنشاء الحساب',
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

                      const SizedBox(height: 14),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب؟ ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Screen07Login()),
                            ),
                            child: Text(
                              'تسجيل الدخول',
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

  // ─── Shared input field ─────────────────────────────────────────────────────
  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
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
                child: suffixIcon)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(focused: true),
        errorBorder: _border(error: true),
        focusedErrorBorder: _border(error: true, focused: true),
        errorMaxLines: 2,
      ),
      validator: validator,
    );
  }

  // ─── Shared dropdown ────────────────────────────────────────────────────────
  Widget _dropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textMuted),
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
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(focused: true),
        errorBorder: _border(error: true),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamilyFallback:
                          AppTypography.arabicFontFamilyFallback,
                    )),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  OutlineInputBorder _border({bool focused = false, bool error = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: error
            ? const Color(0xFFDC2626)
            : focused
                ? const Color(0xFF2B6040)
                : const Color(0xFFE0E0E0),
        width: focused ? 1.5 : 1.0,
      ),
    );
  }
}
