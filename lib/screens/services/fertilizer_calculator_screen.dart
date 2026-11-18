import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/crop_and_supply_model.dart';
import '../../services/gemini_service.dart';
import '../ministry/create_supply_request_dialog.dart';

class FertilizerCalculatorScreen extends StatefulWidget {
  const FertilizerCalculatorScreen({super.key});

  @override
  State<FertilizerCalculatorScreen> createState() => _FertilizerCalculatorScreenState();
}

class _FertilizerCalculatorScreenState extends State<FertilizerCalculatorScreen> {
  final _areaController = TextEditingController(text: '20');
  String _selectedCrop = AppConstants.cropCategories.first;
  String _selectedSoil = AppConstants.soilTypes.first;
  String _selectedWater = AppConstants.waterSources.first;
  String _selectedStage = 'النمو الخضري النشط والتفرع';

  final List<String> _stages = [
    'التأسيس والتجهيز للزراعة',
    'النمو الخضري النشط والتفرع',
    'التزهير وتكوين العقد الثمري',
    'مرحلة تحجيم الثمار والنضج',
    'ما بعد الحصاد والجني',
  ];

  String? _calculatedResult;
  bool _isLoading = false;

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _calculate() async {
    final area = double.tryParse(_areaController.text) ?? 20.0;
    setState(() {
      _isLoading = true;
      _calculatedResult = null;
    });

    final plan = await GeminiService().calculateFertilizerPlan(
      crop: _selectedCrop,
      areaDunams: area,
      soilType: _selectedSoil,
      waterSource: _selectedWater,
      cropStage: _selectedStage,
    );

    setState(() {
      _isLoading = false;
      _calculatedResult = plan;
    });
  }

  void _requestMinistryFertilizer() {
    final area = double.tryParse(_areaController.text) ?? 20.0;
    final bags = (area * 0.5).toInt().clamp(2, 50);

    showDialog(
      context: context,
      builder: (_) => CreateSupplyRequestDialog(
        initialSupplyName: 'سماد يوريا 46% ومركب داب 18-46-0 (المجمع الصناعي)',
        initialCategory: SupplyCategory.fertilizers,
        initialQuantity: '$bags كيس (50 كجم)',
        isAiTriggered: true,
        aiReason: 'حساب دقيق لاحتياج مساحة $area دونم لمحصول ($_selectedCrop) بواسطة خوارزميات Gemini الذكية',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('حاسبة التسميد والري الذكية'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.limeLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.limeDark),
                const SizedBox(width: 4),
                Text(
                  'Gemini AI',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.limeDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfacePure,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.limeLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.science_rounded, color: AppColors.limeDark, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معادلة التسميد والربط مع وزارة الزراعة',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'يحسب الذكاء الاصطناعي الجرعات المثلى، ويمكّنك من رفع طلب صرف الحصة المدعومة للجمعية فوراً.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Form Inputs
            Text('معطيات الحقل والمحصول:', style: AppTypography.titleMedium),
            const SizedBox(height: 10),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.surfaceBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCrop,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'المحصول الزراعي',
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
                      controller: _areaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'المساحة المزروعة (بالدونم)',
                        prefixIcon: Icon(Icons.straighten_rounded, color: AppColors.forestPrimary),
                        suffixText: 'دونم',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStage,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'مرحلة نمو المحصول الحالية',
                        prefixIcon: Icon(Icons.timeline_rounded, color: AppColors.forestPrimary),
                      ),
                      items: _stages.map((st) {
                        return DropdownMenuItem(value: st, child: Text(st));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStage = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSoil,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'طبيعة التربة',
                        prefixIcon: Icon(Icons.layers_rounded, color: AppColors.forestPrimary),
                      ),
                      items: AppConstants.soilTypes.map((st) {
                        return DropdownMenuItem(value: st, child: Text(st, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSoil = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedWater,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'مصدر المياه وشبكة الري',
                        prefixIcon: Icon(Icons.water_drop_rounded, color: AppColors.forestPrimary),
                      ),
                      items: AppConstants.waterSources.map((ws) {
                        return DropdownMenuItem(value: ws, child: Text(ws, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedWater = val);
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.limeBright,
                          foregroundColor: AppColors.forestDarkest,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isLoading ? null : _calculate,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome_rounded),
                        label: Text(
                          _isLoading ? 'جاري الحساب عبر Gemini...' : 'احسب البرنامج التسميدي الذكي',
                          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_calculatedResult != null) ...[
              const SizedBox(height: 20),
              Text('البرنامج الموصى به من مساعد فلاح الذكي:', style: AppTypography.titleMedium),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfacePure,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.limeBorder, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.limeBright.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _calculatedResult!,
                      style: AppTypography.bodyMedium.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    // Ministry Quota CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forestPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _requestMinistryFertilizer,
                        icon: const Icon(Icons.account_balance_rounded),
                        label: const Text(
                          'طلب صرف هذه الحصة المدعومة من وزارة الزراعة والجمعية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
