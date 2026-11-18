import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/crop_and_supply_model.dart';
import '../../models/ministry_order_model.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class CreateSupplyRequestDialog extends StatefulWidget {
  final String? initialSupplyName;
  final SupplyCategory? initialCategory;
  final String? initialQuantity;
  final bool isAiTriggered;
  final String? aiReason;

  const CreateSupplyRequestDialog({
    super.key,
    this.initialSupplyName,
    this.initialCategory,
    this.initialQuantity,
    this.isAiTriggered = false,
    this.aiReason,
  });

  @override
  State<CreateSupplyRequestDialog> createState() =>
      _CreateSupplyRequestDialogState();
}

class _CreateSupplyRequestDialogState extends State<CreateSupplyRequestDialog> {
  final AppState _appState = AppState();
  late final bool _hasLands;
  late LandRecord _selectedLand;
  late SupplyCategory _selectedCategory;
  final _supplyNameController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCooperative =
      'مستودع الجمعية التعاونية الزراعية - فرع وادي المجينين وترهونة';

  final List<String> _cooperatives = [
    'مستودع الجمعية التعاونية الزراعية - فرع وادي المجينين وترهونة',
    'الجمعية التعاونية الزراعية - السواني والعزيزية (الجفارة)',
    'مجمع إكثار البذور ومستودع الأسمدة - مراقبة زراعة مصراتة',
    'مستودع الجمعية الزراعية - المرج والجبل الأخضر',
    'مستودع فرع وزارة الزراعة - سبها ووادي الآجال (فزان)',
  ];

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.initialCategory ?? SupplyCategory.fertilizers;

    _hasLands = _appState.lands.isNotEmpty;

    if (!_hasLands) {
      return;
    }

    _selectedLand = _appState.lands.first;

    _supplyNameController.text =
        widget.initialSupplyName ?? 'سماد يوريا نقي 46% (المجمع الصناعي)';

    _quantityController.text =
        widget.initialQuantity ??
        '${(_selectedLand.estimatedAreaDunams * 0.5).toInt()} كيس (50 كجم)';
  }

  @override
  void dispose() {
    _supplyNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onCategoryChange(SupplyCategory category) {
    setState(() {
      _selectedCategory = category;
      if (category == SupplyCategory.fertilizers) {
        _supplyNameController.text = 'سماد يوريا نقي 46% (المجمع الصناعي)';
        _quantityController.text =
            '${(_selectedLand.estimatedAreaDunams * 0.5).toInt()} كيس (50 كجم)';
      } else if (category == SupplyCategory.seeds) {
        _supplyNameController.text = 'بذور قمح صلب معتمدة (صنف كريم وشحات)';
        _quantityController.text =
            '${(_selectedLand.estimatedAreaDunams * 0.3).toInt()} كيس (50 كجم)';
      } else if (category == SupplyCategory.pesticides) {
        _supplyNameController.text = 'مبيد فطري نحاسي (هيدروكسيد النحاس 77%)';
        _quantityController.text = '4 عبوات (4 كجم)';
      } else {
        _supplyNameController.text = 'أنابيب ري بالتنقيط مقاومة للشمس (16 ملم)';
        _quantityController.text = '5 لفات (2000 متر)';
      }
    });
  }

  void _submit() {
    if (!_hasLands) {
      return;
    }

    if (_supplyNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد المادة الزراعية المطلوبة')),
      );
      return;
    }

    final user = _appState.currentUser;
    final orderId =
        'ORD-LY-2026-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final voucher =
        'LY-VOUCH-${DateTime.now().millisecondsSinceEpoch % 90000 + 10000}';

    double subsidy = 40.0;
    if (_selectedCategory == SupplyCategory.seeds) subsidy = 50.0;
    if (_selectedCategory == SupplyCategory.pesticides) subsidy = 30.0;

    final order = MinistrySupplyOrder(
      id: orderId,
      farmerName: user.fullName,
      nationalId: user.nationalId,
      agriculturalCardNumber: user.agriculturalCardNumber,
      landParcelNumber: _selectedLand.recordNumber,
      landTitle: _selectedLand.landName,
      supplyName: _supplyNameController.text.trim(),
      category: _selectedCategory,
      requestedQuantity: _quantityController.text.trim().isEmpty
          ? 'حسب الحصة المعتمدة'
          : _quantityController.text.trim(),
      approvedQuantity: 'قيد تدقيق المراقبة',
      subsidyPercentage: subsidy,
      officialPriceLYD: 50.0,
      farmerCostLYD: 300.0,
      status: OrderStatus.underReview,
      pickupCooperative: _selectedCooperative,
      recommendedByAi: widget.isAiTriggered,
      aiRecommendationReason: widget.aiReason,
      voucherCode: voucher,
      createdAt: DateTime.now(),
    );

    _appState.submitMinistryOrder(order);

    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context, order);

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.forestPrimary,
        content: Text(
          'تم حفظ الطلب التجريبي داخل التطبيق. رقم الطلب: $orderId',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLands) {
      return AlertDialog(
        title: const Text('لا توجد أراضٍ مسجّلة'),
        content: const Text(
          'سجّلي أرضًا أولًا، وبعدها افتحي نافذة طلب المستلزمات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surfacePure,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.forestDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.limeBright,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طلب صرف مدعوم من وزارة الزراعة',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'منظومة الربط المباشر مع الجمعيات الزراعية السيادية',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.forestPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (widget.isAiTriggered) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.limeLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.limeBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.limeDark,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.aiReason ?? 'تم تضمين هذه المادة بناءً على تشخيص وتحليل مساعد فلاح الذكي.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),

            // Form Fields
            // 1. Linked Registered Land
            Text(
              'الحيازة الزراعية المستفيدة:',
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<LandRecord>(
              initialValue: _selectedLand,
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.landscape_rounded,
                  color: AppColors.forestPrimary,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items: _appState.lands.map((land) {
                return DropdownMenuItem(
                  value: land,
                  child: Text(
                    '${land.landName} (${land.estimatedAreaDunams} دونم - ${land.status.label})',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (land) {
                if (land != null) {
                  setState(() {
                    _selectedLand = land;
                    if (_selectedCategory == SupplyCategory.fertilizers) {
                      _quantityController.text =
                          '${(_selectedLand.estimatedAreaDunams * 0.5).toInt()} كيس (50 كجم)';
                    }
                  });
                }
              },
            ),

            const SizedBox(height: 14),

            // 2. Supply Category Chips
            Text('تصنيف المادة المطلوبة:', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: SupplyCategory.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat.nameAr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.limeLight,
                  avatar: Icon(
                    cat.icon,
                    size: 14,
                    color: isSelected
                        ? AppColors.limeDark
                        : AppColors.textMuted,
                  ),
                  onSelected: (_) => _onCategoryChange(cat),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // 3. Supply Item Name
            TextField(
              controller: _supplyNameController,
              decoration: const InputDecoration(
                labelText: 'اسم الصنف أو الدواء أو السماد *',
                prefixIcon: Icon(
                  Icons.science_rounded,
                  color: AppColors.forestPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 4. Requested Quantity
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'الكمية المطلوبة وفق سقف الحصة *',
                prefixIcon: const Icon(
                  Icons.inventory_rounded,
                  color: AppColors.forestPrimary,
                ),
                helperText:
                    'الحد الأقصى المسموح لأرضك: ${(_selectedLand.estimatedAreaDunams * 0.6).toInt()} كيس',
              ),
            ),

            const SizedBox(height: 14),

            // 5. Pickup Cooperative
            Text(
              'مركز التوزيع ومستودع الاستلام:',
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCooperative,
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.forestPrimary,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items: _cooperatives.map((coop) {
                return DropdownMenuItem(
                  value: coop,
                  child: Text(
                    coop,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCooperative = val);
              },
            ),

            const SizedBox(height: 18),

            // Government Subsidy Guarantee Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: AppColors.statusApproved,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'جميع البذور والأسمدة والأدوية الموزعة أصلية ومطابقة لمواصفات وزارة الزراعة ومركز البحوث الزراعية الليبي.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.forestDarkest,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.limeBright,
                      foregroundColor: AppColors.forestDarkest,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      'إرسال الطلب لوزارة الزراعة',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
