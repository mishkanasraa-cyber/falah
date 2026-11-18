import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/ai_diagnosis_model.dart';
import '../../models/crop_and_supply_model.dart';
import '../../services/gemini_service.dart';
import '../../widgets/attachment_sheet.dart';
import '../ministry/create_supply_request_dialog.dart';
import 'gemini_api_key_dialog.dart';

class CropDiseaseScannerScreen extends StatefulWidget {
  const CropDiseaseScannerScreen({super.key});

  @override
  State<CropDiseaseScannerScreen> createState() => _CropDiseaseScannerScreenState();
}

class _CropDiseaseScannerScreenState extends State<CropDiseaseScannerScreen> {
  String _selectedCrop = 'أشجار الزيتون (شملالي)';
  final _symptomsController = TextEditingController();
  String? _selectedAttachmentName;
  String? _sampleCaseId;

  CropDiagnosisResult? _diagnosisResult;
  bool _isLoading = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  void _choosePhoto() async {
    final result = await AttachmentSheet.show(
      context,
      title: 'التقاط أو اختيار صورة النبات للفحص',
      allowDocuments: false,
    );

    if (result != null) {
      setState(() {
        _selectedAttachmentName = result.fileName;
        _sampleCaseId = 'olive_peacock';
      });
    }
  }

  void _runDiagnosis({String? sampleId}) async {
    setState(() {
      _isLoading = true;
      _diagnosisResult = null;
    });

    final res = await GeminiService().diagnoseCrop(
      cropName: _selectedCrop,
      symptoms: _symptomsController.text.trim().isEmpty ? null : _symptomsController.text.trim(),
      sampleCaseId: sampleId ?? _sampleCaseId,
    );

    setState(() {
      _isLoading = false;
      _diagnosisResult = res;
    });
  }

  void _requestMinistryMedicine(CropDiagnosisResult result) {
    String med = 'مبيد فطري نحاسي (هيدروكسيد النحاس 77%)';
    if (result.chemicalTreatments.isNotEmpty) {
      med = result.chemicalTreatments.first;
    }

    showDialog(
      context: context,
      builder: (_) => CreateSupplyRequestDialog(
        initialSupplyName: med,
        initialCategory: SupplyCategory.pesticides,
        initialQuantity: '4 عبوات (4 كجم)',
        isAiTriggered: true,
        aiReason: 'بناءً على تشخيص (${result.diagnosisName}) لمحصول (${result.cropName}) عبر مساعد فلاح الذكي',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('فحص وتشخيص النبات الذكي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key_rounded),
            tooltip: 'إعدادات مفتاح Gemini',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const GeminiApiKeyDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Intro Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF0F3827),
                    Color(0xFF14532D),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.limeBorder.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.limeLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_enhance_rounded, color: AppColors.limeDark, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'طبيب المحاصيل الذكي',
                              style: AppTypography.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.limeBright,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Gemini Vision',
                                style: TextStyle(
                                  color: AppColors.forestDarkest,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'حلل صور الأوراق المصابة، واطلب الدواء المعتمد مباشرة من وزارة الزراعة والجمعية التعاونية.',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textOnDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Form Inputs Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('بيانات العينة والفحص:', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCrop,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'نوع المحصول',
                        prefixIcon: Icon(Icons.grass_rounded, color: AppColors.forestPrimary),
                      ),
                      items: AppConstants.cropCategories.map((c) {
                        return DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCrop = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _symptomsController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'الأعراض الملاحظة (اختياري)',
                        hintText: 'مثال: اصفرار الأوراق، بقع رمادية، ذبول في القمة...',
                        prefixIcon: Icon(Icons.notes_rounded, color: AppColors.forestPrimary),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Photo Attachment Area
                    InkWell(
                      onTap: _choosePhoto,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _selectedAttachmentName != null ? AppColors.limeLight.withValues(alpha: 0.4) : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedAttachmentName != null ? AppColors.limeDark : AppColors.surfaceBorder,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _selectedAttachmentName != null ? Icons.check_circle_rounded : Icons.add_a_photo_rounded,
                              size: 32,
                              color: _selectedAttachmentName != null ? AppColors.limeDark : AppColors.forestMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedAttachmentName != null
                                  ? 'تم تحديد الصورة: $_selectedAttachmentName'
                                  : 'اضغط هنا لفتح الكاميرا أو اختيار صورة للورقة/الثمرة',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _selectedAttachmentName != null ? AppColors.limeDark : AppColors.forestDarkest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Quick Sample Buttons
                    Text(
                      'أو اختر عينة حقلية جاهزة للتجربة الفورية:',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.eco_rounded, size: 14, color: AppColors.forestPrimary),
                          label: Text('عين الطاووس (زيتون)', style: AppTypography.bodySmall),
                          onPressed: () {
                            setState(() {
                              _selectedCrop = 'أشجار الزيتون (شملالي)';
                              _selectedAttachmentName = 'olive_peacock_spot.jpg';
                              _sampleCaseId = 'olive_peacock';
                            });
                            _runDiagnosis(sampleId: 'olive_peacock');
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.pest_control_rounded, size: 14, color: Color(0xFFDC2626)),
                          label: Text('سوسة النخيل الحمراء', style: AppTypography.bodySmall),
                          onPressed: () {
                            setState(() {
                              _selectedCrop = 'نخيل التمور (صعيدي)';
                              _selectedAttachmentName = 'palm_weevil_sample.jpg';
                              _sampleCaseId = 'palm_weevil';
                            });
                            _runDiagnosis(sampleId: 'palm_weevil');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.limeBright,
                          foregroundColor: AppColors.forestDarkest,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isLoading ? null : () => _runDiagnosis(),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome_rounded),
                        label: Text(
                          _isLoading ? 'جاري الفحص عبر Gemini...' : 'تشخيص العينة بواسطة الذكاء الاصطناعي',
                          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results Section
            if (_diagnosisResult != null) ...[
              const SizedBox(height: 20),
              _buildDiagnosisResultView(_diagnosisResult!),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisResultView(CropDiagnosisResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.limeBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Condition & Confidence Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.diagnosisName,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.scientificName,
                      style: AppTypography.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.forestPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.limeLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'دقة ${result.confidencePercentage}%',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.limeDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Severity & Symptoms
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.statusReview),
                    const SizedBox(width: 6),
                    Text(
                      'مستوى الخطورة: ${result.severity}',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.statusReview,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(result.symptomSummary, style: AppTypography.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Immediate Actions Checklist
          Text('الإجراءات الفورية المطلوبة في الحقل:', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          ...result.immediateActions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.statusApproved),
                    const SizedBox(width: 8),
                    Expanded(child: Text(action, style: AppTypography.bodySmall)),
                  ],
                ),
              )),

          const SizedBox(height: 14),

          // Chemical Treatments
          Text('العلاج الكيميائي والمبيدات المصرح بها بوزارة الزراعة:', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          ...result.chemicalTreatments.map((chem) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.science_rounded, size: 16, color: AppColors.forestPrimary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(chem, style: AppTypography.bodySmall)),
                  ],
                ),
              )),

          const SizedBox(height: 14),

          // Local Libyan Availability Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warmBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded, color: AppColors.forestPrimary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result.localAvailabilityNote,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Core Ministry Link CTA Button!
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.limeLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.limeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_rounded, color: AppColors.forestDarkest, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'الربط المباشر مع وزارة الزراعة والجمعية:',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'وفر الدواء والمبيد الأصلي الموصى به مباشرة من مستودع الجمعية التعاونية التابعة لبلديتك بسعر مدعوم رسمياً.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _requestMinistryMedicine(result),
                    icon: const Icon(Icons.assignment_turned_in_rounded, size: 18),
                    label: const Text(
                      'طلب صرف هذا الدواء من وزارة الزراعة والجمعية',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
