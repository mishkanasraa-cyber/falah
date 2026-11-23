import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../widgets/falah_logo.dart';
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _selectedMunicipality;
  String? _selectedUserType;

  final List<String> _municipalities = [
    'ترهونة',
    'السواني بن آدم',
    'العزيزية',
    'سيدي السائح',
    'قصر بن غشير',
    'عين زارة',
    'تاجوراء',
    'مصراتة',
    'زليتن',
    'الخمس',
    'الزاوية',
    'صبراتة',
    'غريان',
    'بني وليد',
    'المرج',
    'البيضاء',
    'بنغازي',
    'سبها',
  ];

  final List<String> _userTypes = [
    'مزارع / صاحب حيازة',
    'موظف حصر زراعي',
    'مهندس زراعي',
    'مشرف بلدي',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Screen09IdentityMunicipality(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Real logo
                const FalahLogo(size: 80),

                const SizedBox(height: 8),

                // Brand name
                Text(
                  'فلاح',
                  style: AppTypography.headlineLarge.copyWith(
                    color: const Color(0xFF1A2E26),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                ),

                const SizedBox(height: 16),

                // Page title
                Text(
                  'إنشاء حساب جديد',
                  style: AppTypography.displayMedium.copyWith(
                    color: const Color(0xFF1A2E26),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                  ),
                ),

                const SizedBox(height: 20),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full name
                      _buildInputField(
                        controller: _nameController,
                        hint: 'الاسم الكامل',
                        icon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().length < 3) {
                            return 'يرجى إدخال الاسم الكامل';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Phone
                      _buildInputField(
                        controller: _phoneController,
                        hint: 'رقم الهاتف',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().length < 8) {
                            return 'يرجى إدخال رقم هاتف صحيح';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Email
                      _buildInputField(
                        controller: _emailController,
                        hint: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 12),

                      // Municipality dropdown
                      _buildDropdownField(
                        value: _selectedMunicipality,
                        hint: 'البلدية',
                        icon: Icons.location_on_outlined,
                        items: _municipalities,
                        onChanged: (val) =>
                            setState(() => _selectedMunicipality = val),
                        validator: (val) {
                          if (val == null) return 'يرجى اختيار البلدية';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // User type dropdown
                      _buildDropdownField(
                        value: _selectedUserType,
                        hint: 'نوع المستخدم',
                        icon: Icons.people_outline_rounded,
                        items: _userTypes,
                        onChanged: (val) =>
                            setState(() => _selectedUserType = val),
                        validator: (val) {
                          if (val == null) return 'يرجى اختيار نوع المستخدم';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Password
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

                      const SizedBox(height: 12),

                      // Confirm password
                      _buildInputField(
                        controller: _confirmPasswordController,
                        hint: 'تأكيد كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (val) {
                          if (val != _passwordController.text) {
                            return 'كلمتا المرور غير متطابقتين';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Create account button
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
                          onPressed: _proceed,
                          child: Text(
                            'إنشاء الحساب',
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

                      const SizedBox(height: 16),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب؟',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontFamilyFallback:
                                  AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: const Size(0, 32),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Screen07Login(),
                                ),
                              );
                            },
                            child: Text(
                              'تسجيل الدخول',
                              style: AppTypography.bodySmall.copyWith(
                                color: const Color(0xFF2E6B40),
                                fontWeight: FontWeight.w700,
                                fontFamilyFallback:
                                    AppTypography.arabicFontFamilyFallback,
                              ),
                            ),
                          ),
                        ],
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
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildDropdownField({
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
      style: TextStyle(
        fontSize: 14,
        color: const Color(0xFF1A2E26),
        fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textMuted,
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
        fillColor: const Color(0xFFF8F8F8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1A2E26),
              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
