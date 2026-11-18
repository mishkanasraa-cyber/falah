import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_state.dart';

class Screen23AddLandChooseLocationMethod extends StatefulWidget {
  const Screen23AddLandChooseLocationMethod({super.key});

  @override
  State<Screen23AddLandChooseLocationMethod> createState() =>
      _Screen23AddLandChooseLocationMethodState();
}

class _Screen23AddLandChooseLocationMethodState
    extends State<Screen23AddLandChooseLocationMethod> {
  final _formKey = GlobalKey<FormState>();
  final _appState = AppState();

  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  late final String _draftId;
  late final String _landName;

  @override
  void initState() {
    super.initState();

    final draft = _appState.activeDraft;
    _draftId = draft.id;
    _landName = draft.landName;

    // لا نملأ الإحداثيات الافتراضية باعتبارها موقعًا مؤكدًا.
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  double? _parseCoordinate(String? value) {
    return double.tryParse((value ?? '').trim().replaceAll(',', '.'));
  }

  String? _validateCoordinate(String? value, double minimum, double maximum) {
    final coordinate = _parseCoordinate(value);

    if (coordinate == null ||
        !coordinate.isFinite ||
        coordinate < minimum ||
        coordinate > maximum) {
      return 'أدخلي قيمة بين $minimum و$maximum';
    }

    return null;
  }

  void _saveLocation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final draft = _appState.activeDraft;

    if (draft.id != _draftId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تغيّرت المسودة الحالية. أغلقي الصفحة وافتحيها من جديد.',
          ),
        ),
      );
      return;
    }

    // حماية من تعديل سجل أُرسل أو اعتُمد بالفعل.
    if (!draft.isDraft) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هذه الصفحة مخصصة للمسودة الحالية فقط.')),
      );
      return;
    }

    _appState.updateDraft(
      latitude: _parseCoordinate(_latitudeController.text)!,
      longitude: _parseCoordinate(_longitudeController.text)!,
      isDraft: true,
      isSynced: false,
    );

    _appState.saveCurrentDraftToRecords();

    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context, true);

    messenger.showSnackBar(
      const SnackBar(content: Text('تم حفظ إحداثيات الموقع في المسودة.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLandName = _landName.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تحديد موقع الأرض'),
        backgroundColor: AppColors.forestDarkest,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: !hasLandName
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'ابدئي بإضافة أرض وحفظ بياناتها كمسودة، '
                    'ثم افتحي هذه الصفحة لتحديد موقع المسودة الحالية.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _landName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'أدخلي الإحداثيات العشرية من مصدر موثوق. '
                        'الإحداثيات تحدد نقطة موقع فقط؛ '
                        'ولا تمثل حدود الأرض أو مساحتها.',
                        style: TextStyle(height: 1.7),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _latitudeController,
                        textDirection: TextDirection.ltr,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'خط العرض — Latitude',
                          hintText: 'مثال تنسيق: 32.123456',
                        ),
                        validator: (value) =>
                            _validateCoordinate(value, -90, 90),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _longitudeController,
                        textDirection: TextDirection.ltr,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'خط الطول — Longitude',
                          hintText: 'مثال تنسيق: 13.123456',
                        ),
                        validator: (value) =>
                            _validateCoordinate(value, -180, 180),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _saveLocation,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('حفظ موقع المسودة'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
