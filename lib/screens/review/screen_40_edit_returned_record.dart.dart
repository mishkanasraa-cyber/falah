import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen40EditReturnedRecord extends StatefulWidget {
  final LandRecord record;

  const Screen40EditReturnedRecord({
    super.key,
    required this.record,
  });

  @override
  State<Screen40EditReturnedRecord> createState() =>
      _Screen40EditReturnedRecordState();
}

class _Screen40EditReturnedRecordState
    extends State<Screen40EditReturnedRecord> {
  final _formKey = GlobalKey<FormState>();

  late final LandRecord _record;
  late final TextEditingController _landNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _municipalityController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    // استخدام أحدث نسخة محفوظة من السجل.
    _record = AppState().lands.firstWhere(
      (item) => item.id == widget.record.id,
      orElse: () => widget.record,
    );

    _landNameController = TextEditingController(
      text: _record.landName,
    );
    _ownerNameController = TextEditingController(
      text: _record.ownerName,
    );
    _municipalityController = TextEditingController(
      text: _record.municipality,
    );
    _locationController = TextEditingController(
      text: _record.locationName,
    );
  }

  @override
  void dispose() {
    _landNameController.dispose();
    _ownerNameController.dispose();
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

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appState = AppState();

    final exists = appState.lands.any(
      (item) => item.id == _record.id,
    );

    if (!exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر الحفظ: السجل غير موجود في قائمة الأراضي.'),
        ),
      );
      return;
    }

    final correctedRecord = _record.copyWith(
      landName: _landNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      municipality: _municipalityController.text.trim(),
      locationName: _locationController.text.trim(),
      updatedAt: DateTime.now(),
    );

    appState.resubmitReturnedRecord(correctedRecord);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final canEdit =
        _record.status == LandReviewStatus.requiresModification;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تعديل السجل المُرجع'),
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
                Text(
                  'رقم السجل: ${_record.recordNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestDarkest,
                  ),
                ),
                const SizedBox(height: 16),

                if (!canEdit) ...[
                  const Text(
                    'التعديل من هذه الصفحة متاح للسجلات '
                    'التي تتطلب تعديلًا فقط.',
                    style: TextStyle(
                      color: AppColors.statusAlert,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (_record.returnReason?.trim().isNotEmpty ??
                    false) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ملاحظات المراجع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusAlert,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _record.returnReason!,
                            style: const TextStyle(height: 1.7),
                          ),
                          if (_record.affectedFields.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'البيانات المطلوبة:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ..._record.affectedFields.map(
                              (field) => Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text('• $field'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextFormField(
                  controller: _landNameController,
                  enabled: canEdit,
                  decoration: const InputDecoration(
                    labelText: 'اسم الأرض',
                    prefixIcon: Icon(Icons.landscape_outlined),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ownerNameController,
                  enabled: canEdit,
                  decoration: const InputDecoration(
                    labelText: 'اسم المالك',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _municipalityController,
                  enabled: canEdit,
                  decoration: const InputDecoration(
                    labelText: 'البلدية',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  enabled: canEdit,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'وصف الموقع',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 20),
                const Text(
                  'هذه الصفحة تعدّل البيانات العامة فقط. '
                  'إذا كانت الملاحظات تخص الحدود أو المحاصيل '
                  'أو المرفقات، يلزم إكمال تعديلها قبل إعادة المراجعة.',
                  style: TextStyle(height: 1.6),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: canEdit ? _saveChanges : null,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'حفظ التعديلات وتحويل الحالة إلى قيد المراجعة',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}