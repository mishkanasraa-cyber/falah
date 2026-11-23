import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/attachment_sheet.dart';

class AddLandScreen extends StatefulWidget {
  const AddLandScreen({super.key});

  @override
  State<AddLandScreen> createState() => _AddLandScreenState();
}

class _AddLandScreenState extends State<AddLandScreen> {
  int _currentStep = 0;

  // Controllers
  final _titleController = TextEditingController();
  final _parcelNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _dunamsController = TextEditingController();

  String _selectedRegion = AppConstants.libyanRegions.first;
  String _selectedSoilType = AppConstants.soilTypes.first;
  String _selectedWaterSource = AppConstants.waterSources.first;
  final List<String> _selectedCrops = [];

  final List<String> _attachedDocuments = [];
  final List<String> _attachedPhotos = [];

  @override
  void initState() {
    super.initState();
    final user = AppState().currentUser;
    _ownerNameController.text = user.fullName;
    _nationalIdController.text = user.nationalId;
    _selectedCrops.add(AppConstants.cropCategories.first);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _parcelNumberController.dispose();
    _ownerNameController.dispose();
    _nationalIdController.dispose();
    _dunamsController.dispose();
    super.dispose();
  }

  void _addAttachment() async {
    final result = await AttachmentSheet.show(
      context,
      title: 'إرفاق وثيقة أو صورة لإثبات الحيازة',
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        if (result.type == AttachmentSourceType.document) {
          _attachedDocuments.add(result.fileName);
        } else {
          _attachedPhotos.add(result.fileName);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرفاق: ${result.label}'),
          backgroundColor: AppColors.forestPrimary,
        ),
      );
    }
  }

  void _submitLand() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المزرعة أو الحيازة')),
      );
      return;
    }

    final dunams = double.tryParse(_dunamsController.text.trim().replaceAll(',', '.'));
    if (dunams == null || !dunams.isFinite || dunams <= 0 ||
        _ownerNameController.text.trim().isEmpty ||
        !RegExp(r'^[0-9]{12}$').hasMatch(_nationalIdController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخلي اسم المالك ورقمًا وطنيًا من 12 رقمًا ومساحة موجبة.')));
      return;
    }
    final now = DateTime.now();
    final user = AppState().currentUser;
    final newLand = LandRecord(
      id: 'LND-${now.microsecondsSinceEpoch}',
      recordNumber: _parcelNumberController.text.trim().isEmpty
          ? 'DRAFT-${now.microsecondsSinceEpoch}' : _parcelNumberController.text.trim(),
      landName: _titleController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      ownerNationalId: _nationalIdController.text.trim(),
      ownerPhone: user.phone,
      municipality: _selectedRegion.split('(').first.trim(),
      locationName: _selectedRegion,
      latitude: 0, longitude: 0,
      estimatedAreaHectares: dunams * 0.25,
      estimatedAreaDunams: dunams,
      crops: [for (var i = 0; i < _selectedCrops.length; i++)
        CropItem(id: 'CROP-${now.microsecondsSinceEpoch}-$i',
          cropType: _selectedCrops[i], season: 'غير محدد',
          cultivatedAreaHectares: 0, notes: 'لم تدخل مساحة المحصول بعد.')],
      soilType: _selectedSoilType, waterSource: _selectedWaterSource,
      boundaryPoints: const [],
      status: LandReviewStatus.draft, isDraft: true, isSynced: false,
      attachments: [
        for (var i = 0; i < _attachedDocuments.length; i++)
          AttachmentItem(id: 'DOC-${now.microsecondsSinceEpoch}-$i',
            fileName: _attachedDocuments[i], isDocument: true, isUploaded: false),
        for (var i = 0; i < _attachedPhotos.length; i++)
          AttachmentItem(id: 'PHOTO-${now.microsecondsSinceEpoch}-$i',
            fileName: _attachedPhotos[i], isUploaded: false),
      ],
      reviewTimeline: const [], createdAt: now, updatedAt: now,
    );

    AppState().addLand(newLand);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الأرض كمسودة داخل التطبيق؛ الموقع والحدود يحتاجان استكمالًا'),
        backgroundColor: AppColors.forestPrimary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('تسجيل حيازة زراعية جديدة'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        elevation: 0,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            _submitLand();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentStep == 3 ? AppColors.limeBright : AppColors.forestPrimary,
                      foregroundColor: _currentStep == 3 ? AppColors.forestDarkest : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: details.onStepContinue,
                    child: Text(
                      _currentStep == 3 ? 'حفظ كمسودة' : 'المتابعة',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('السابق'),
                  ),
              ],
            ),
          );
        },
        steps: [
          // Step 1: Basic & Owner Info
          Step(
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text('الملكية'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات المالك والمنطقة',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.forestDarkest),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المزرعة أو الأرض *',
                    hintText: 'مثال: مزرعة الزيتون - وادي المجينين',
                    prefixIcon: Icon(Icons.landscape_rounded, color: AppColors.forestPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المالك الرباعي *',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.forestPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الوطني للمالك *',
                    prefixIcon: Icon(Icons.badge_rounded, color: AppColors.forestPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRegion,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'المنطقة الزراعية والفرع البلدي *',
                    prefixIcon: Icon(Icons.map_rounded, color: AppColors.forestPrimary),
                  ),
                  items: AppConstants.libyanRegions.map((region) {
                    return DropdownMenuItem(value: region, child: Text(region));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRegion = val);
                  },
                ),
              ],
            ),
          ),

          // Step 2: Parcel Dimensions & Cadastral
          Step(
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text('المساحة'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المخطط المساحي والأبعاد',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.forestDarkest),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _parcelNumberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم القطعة / الحوض المساحي',
                    hintText: 'مثال: قطعة 144 / حوض 12',
                    prefixIcon: Icon(Icons.grid_on_rounded, color: AppColors.forestPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dunamsController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'المساحة الإجمالية بالدونم (الكرمة)',
                    hintText: 'مثال: 40',
                    prefixIcon: Icon(Icons.square_foot_rounded, color: AppColors.forestPrimary),
                    suffixText: 'دونم',
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.gps_fixed_rounded, color: AppColors.forestPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'لم يتم ربط استخراج الإحداثيات تلقائيًا. تُحفظ الأرض بدون حدود إلى أن تُدخل فعليًا.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Step 3: Agricultural Attributes
          Step(
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            title: const Text('المحاصيل'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المواصفات الزراعية والتربة',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.forestDarkest),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSoilType,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'نوع التربة السائد',
                    prefixIcon: Icon(Icons.layers_rounded, color: AppColors.forestPrimary),
                  ),
                  items: AppConstants.soilTypes.map((st) {
                    return DropdownMenuItem(value: st, child: Text(st, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSoilType = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedWaterSource,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'مصدر المياه الرئيسي',
                    prefixIcon: Icon(Icons.water_drop_rounded, color: AppColors.forestPrimary),
                  ),
                  items: AppConstants.waterSources.map((ws) {
                    return DropdownMenuItem(value: ws, child: Text(ws, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedWaterSource = val);
                  },
                ),
                const SizedBox(height: 14),
                Text(
                  'المحاصيل المزروعة الحالية:',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: AppConstants.cropCategories.map((crop) {
                    final isSelected = _selectedCrops.contains(crop);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(crop.split('(').first.trim()),
                      selectedColor: AppColors.limeLight,
                      checkmarkColor: AppColors.limeDark,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCrops.add(crop);
                          } else {
                            _selectedCrops.remove(crop);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Step 4: Attachments
          Step(
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            title: const Text('المرفقات'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المستندات والصور الحقلية',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.forestDarkest),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeBright,
                        foregroundColor: AppColors.forestDarkest,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: _addAttachment,
                      icon: const Icon(Icons.add_a_photo_rounded, size: 16),
                      label: const Text('إرفاق ملف / صورة'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_attachedDocuments.isEmpty && _attachedPhotos.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.forestMedium),
                        const SizedBox(height: 8),
                        Text(
                          'يرجى إرفاق رسم كروكي أو شهادة عقارية وصور للحقل لإتمام التحقق المساحي.',
                          style: AppTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      ..._attachedDocuments.map((doc) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFDC2626)),
                              title: Text(doc, style: AppTypography.titleSmall),
                              subtitle: const Text('مستند عقاري مرفق'),
                            ),
                          )),
                      ..._attachedPhotos.map((photo) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.image_rounded, color: AppColors.limeDark),
                              title: Text(photo, style: AppTypography.titleSmall),
                              subtitle: const Text('صورة حقلية ملتقطة'),
                            ),
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
