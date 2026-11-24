import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/falah_ui.dart';
import 'screen_07_login.dart';
import 'screen_09_identity_municipality.dart';

class Screen08CreateAccount extends StatefulWidget {
  final UserRole selectedRole;
  const Screen08CreateAccount(
      {super.key, this.selectedRole = UserRole.farmer});

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
  bool _hidePass = true;
  bool _hideConfirm = true;
  String? _municipality;
  String? _userType;

  static const _municipalities = [
    'ترهونة', 'السواني بن آدم', 'العزيزية', 'سيدي السائح',
    'قصر بن غشير', 'عين زارة', 'تاجوراء', 'مصراتة', 'زليتن',
    'الخمس', 'الزاوية', 'صبراتة', 'غريان', 'بني وليد',
    'المرج', 'البيضاء', 'بنغازي', 'سبها',
  ];

  static const _userTypes = [
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

  // ── Shared dropdown ──
  Widget _dropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c));

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: FalahColors.hint),
      hint: Text(label,
          style: const TextStyle(color: FalahColors.hint, fontSize: 14)),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'اختر $label' : null,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1B2E22)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: FalahColors.hint, size: 20),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: const TextStyle(
            fontSize: 11, color: FalahColors.errorSoft, height: 1.2),
        errorMaxLines: 1,
        border: b(FalahColors.fieldBorder),
        enabledBorder: b(FalahColors.fieldBorder),
        focusedBorder: b(FalahColors.darkGreen),
        errorBorder: b(FalahColors.errorBorder),
        focusedErrorBorder: b(FalahColors.errorSoft),
      ),
    );
  }

  Widget _eye(bool hidden, VoidCallback onTap) => IconButton(
        icon: Icon(
          hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: FalahColors.hint,
          size: 20,
        ),
        onPressed: onTap,
      );

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 12);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Top-left blob ──
          const TopLeftBlob(),

          SafeArea(
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
                    const SizedBox(height: 14),

                    // Title
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          color: FalahColors.darkGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. Full name
                    FalahField(
                      controller: _nameCtrl,
                      label: 'الاسم الكامل',
                      icon: Icons.person_outline,
                      validator: (v) => (v ?? '').trim().length >= 3
                          ? null
                          : 'أدخل الاسم الكامل',
                    ),
                    gap,

                    // 2. Phone
                    FalahField(
                      controller: _phoneCtrl,
                      label: 'رقم الهاتف',
                      hint: '09XXXXXXXX',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: validateLibyanPhone,
                    ),
                    gap,

                    // 3. Email
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
                    gap,

                    // 4. Municipality
                    _dropdown(
                      label: 'البلدية',
                      icon: Icons.location_on_outlined,
                      items: _municipalities,
                      value: _municipality,
                      onChanged: (v) =>
                          setState(() => _municipality = v),
                    ),
                    gap,

                    // 5. User type
                    _dropdown(
                      label: 'نوع المستخدم',
                      icon: Icons.group_outlined,
                      items: _userTypes,
                      value: _userType,
                      onChanged: (v) => setState(() => _userType = v),
                    ),
                    gap,

                    // 6. Password
                    FalahField(
                      controller: _passCtrl,
                      label: 'كلمة المرور',
                      icon: Icons.lock_outline,
                      obscure: _hidePass,
                      validator: validatePassword,
                      suffix: _eye(
                          _hidePass,
                          () => setState(() => _hidePass = !_hidePass)),
                    ),
                    gap,

                    // 7. Confirm password
                    FalahField(
                      controller: _confirmCtrl,
                      label: 'تأكيد كلمة المرور',
                      icon: Icons.lock_outline,
                      obscure: _hideConfirm,
                      validator: (v) => v == _passCtrl.text
                          ? null
                          : 'كلمتا المرور غير متطابقتين',
                      suffix: _eye(
                          _hideConfirm,
                          () =>
                              setState(() => _hideConfirm = !_hideConfirm)),
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    PrimaryButton(
                        text: 'إنشاء الحساب', onPressed: _proceed),
                    const SizedBox(height: 14),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(
                              color: Color(0xFF5A7A65), fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Screen07Login()),
                          ),
                          child: const Text(
                            'تسجيل الدخول',
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
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
