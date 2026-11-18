import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
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
  bool _agreedToTerms = false;

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
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على شروط الاستخدام وسياسة حصر الحيازات')),
      );
      return;
    }

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
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text('إنشاء حساب (${widget.selectedRole.nameAr})'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'البيانات الأساسية للحساب',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'خطوة 1 من 3: أدخل بيانات الاتصال وكلمة المرور.',
                  style: AppTypography.bodySmall,
                ),

                const SizedBox(height: 24),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الرباعي الكامل *',
                    hintText: 'مثال: عمر البشير المريمي',
                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.forestPrimary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length < 3) {
                      return 'يرجى كتابة الاسم الثلاثي أو الرباعي الصحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف الليبي *',
                    hintText: '091xxxxxxx أو 092xxxxxxx',
                    prefixIcon: Icon(Icons.phone_rounded, color: AppColors.forestPrimary),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().length < 8) {
                      return 'يرجى إدخال رقم هاتف صحيح للتواصل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Optional Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني (اختياري)',
                    hintText: 'user@domain.ly',
                    prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.forestPrimary),
                  ),
                ),

                const SizedBox(height: 16),

                // Password
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
                      return 'كلمة المرور يجب أن لا تقل عن 6 أحرف أو أرقام';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور *',
                    prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.forestPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Terms and Conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      activeColor: AppColors.forestPrimary,
                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'أوافق على شروط الاستخدام وتعهد صحة البيانات المدخلة في السجل الزراعي السيادي.',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeBright,
                    foregroundColor: AppColors.forestDarkest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _proceed,
                  child: Text(
                    'متابعة إلى بيانات الهوية والبلدية',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('لديك حساب بالفعل؟', style: AppTypography.bodyMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Screen07Login()),
                        );
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.forestPrimary, fontWeight: FontWeight.bold),
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
