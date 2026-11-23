import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_state.dart';

class Screen21AddLandOwnerDetails extends StatefulWidget {
  const Screen21AddLandOwnerDetails({super.key});

  @override
  State<Screen21AddLandOwnerDetails> createState() =>
      _Screen21AddLandOwnerDetailsState();
}

class _Screen21AddLandOwnerDetailsState
    extends State<Screen21AddLandOwnerDetails> {
  final _formKey = GlobalKey<FormState>();
  final AppState _appState = AppState();

  late final TextEditingController _landNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _municipalityController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    final draft = _appState.activeDraft;

    _landNameController = TextEditingController(text: draft.landName);
    _ownerNameController = TextEditingController(text: draft.ownerName);
    _nationalIdController = TextEditingController(text: draft.ownerNationalId);
    _phoneController = TextEditingController(text: draft.ownerPhone);
    _municipalityController = TextEditingController(text: draft.municipality);
    _locationController = TextEditingController(text: draft.locationName);
  }

  @override
  void dispose() {
    _landNameController.dispose();
    _ownerNameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _municipalityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى تعبئة هذا الحقل';
    }

    return null;
  }

  void _saveDraft() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // تحديث المسودة الحالية دون إرسالها للمراجعة.
    _appState.updateDraft(
      landName: _landNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      ownerNationalId: _nationalIdController.text.trim(),
      ownerPhone: _phoneController.text.trim(),
      municipality: _municipalityController.text.trim(),
      locationName: _locationController.text.trim(),
      isDraft: true,
      isSynced: false,
    );

    _appState.saveCurrentDraftToRecords();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ بيانات الأرض كمسودة داخل التطبيق.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isOnBehalf = _appState.activeDraft.isEnteredOnBehalf;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('بيانات الأرض والمالك'),
        backgroundColor: AppColors.forestDarkest,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'تسجيل بيانات الأرض',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestDarkest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOnBehalf
                      ? 'إدخال بيانات الأرض نيابة عن المزارع.'
                      : 'أدخلي بيانات الأرض والمالك لحفظ مسودة التسجيل.',
                  style: const TextStyle(height: 1.6),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _landNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الأرض *',
                    hintText: 'مثال: مزرعة الزيتون',
                    prefixIcon: Icon(Icons.landscape_outlined),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المالك بالكامل *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'الرقم الوطني — 12 رقمًا *',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (!RegExp(r'^[0-9]{12}$').hasMatch(value?.trim() ?? '')) {
                      return 'يرجى إدخال 12 رقمًا للرقم الوطني';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم هاتف المالك *',
                    hintText: '09xxxxxxxx أو +2189xxxxxxxx',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    final phone = (value ?? '').replaceAll(
                      RegExp(r'[\s()-]'),
                      '',
                    );

                    if (!RegExp(r'^(?:0|\+218|218)9[0-9]{8}$')
                        .hasMatch(phone)) {
                      return 'يرجى إدخال رقم هاتف ليبي صحيح';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _municipalityController,
                  decoration: const InputDecoration(
                    labelText: 'البلدية *',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'المحلة أو وصف الموقع (اختياري)',
                    hintText: 'أقرب طريق أو معلم معروف',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'حفظ المسودة لا يعني إرسال السجل للمراجعة. '
                      'يلزم إكمال بيانات الموقع والحدود والمحاصيل '
                      'والمرفقات قبل الإرسال.',
                      style: TextStyle(height: 1.7),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _saveDraft,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('حفظ البيانات كمسودة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
