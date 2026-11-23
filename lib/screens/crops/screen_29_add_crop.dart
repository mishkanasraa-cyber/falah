import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen29AddCrop extends StatefulWidget {
  const Screen29AddCrop({super.key});

  @override
  State<Screen29AddCrop> createState() => _Screen29AddCropState();
}

class _Screen29AddCropState extends State<Screen29AddCrop> {
  final _formKey = GlobalKey<FormState>();
  final _appState = AppState();

  final _cropController = TextEditingController();
  final _seasonController = TextEditingController();
  final _areaController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedLandId;

  @override
  void dispose() {
    _cropController.dispose();
    _seasonController.dispose();
    _areaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى تعبئة هذا الحقل';
    }
    return null;
  }

  double? _parseArea(String? value) {
    return double.tryParse((value ?? '').trim().replaceAll(',', '.'));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final landId = _selectedLandId;

    if (landId == null) {
      return;
    }

    final crop = CropItem(
      id: 'CROP-${DateTime.now().microsecondsSinceEpoch}',
      cropType: _cropController.text.trim(),
      season: _seasonController.text.trim(),
      cultivatedAreaHectares: _parseArea(_areaController.text)!,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final saved = _appState.addCropToLand(landId, crop);

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر الحفظ. تأكدي أن الأرض ما زالت قابلة للتعديل.'),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context, true);

    messenger.showSnackBar(
      const SnackBar(content: Text('تمت إضافة المحصول داخل التطبيق.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editableLands = _appState.lands.where((land) {
      return land.status == LandReviewStatus.draft ||
          land.status == LandReviewStatus.requiresModification;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('إضافة محصول'),
        backgroundColor: AppColors.forestDarkest,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: editableLands.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'لا توجد أرض قابلة للتعديل. '
                    'احفظي أرضًا كمسودة أولًا.',
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
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLandId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'الأرض المستفيدة *',
                        ),
                        items: editableLands.map((land) {
                          return DropdownMenuItem<String>(
                            value: land.id,
                            child: Text(
                              '${land.landName} — ${land.recordNumber}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLandId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'اختاري الأرض';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cropController,
                        decoration: const InputDecoration(
                          labelText: 'نوع المحصول *',
                          hintText: 'مثال: زيتون',
                        ),
                        validator: _requiredText,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _seasonController,
                        decoration: const InputDecoration(
                          labelText: 'الموسم *',
                          hintText: 'مثال: شتاء 2026',
                        ),
                        validator: _requiredText,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _areaController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'المساحة المزروعة بالهكتار *',
                        ),
                        validator: (value) {
                          final area = _parseArea(value);

                          if (area == null || !area.isFinite || area <= 0) {
                            return 'أدخلي مساحة رقمية أكبر من صفر';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات (اختياري)',
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('حفظ المحصول'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
