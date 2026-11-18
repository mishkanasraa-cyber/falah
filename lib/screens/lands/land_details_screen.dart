import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/interactive_boundary_map.dart';
import '../../widgets/attachment_sheet.dart';

class LandDetailsScreen extends StatefulWidget {
  final LandRecord land;

  const LandDetailsScreen({super.key, required this.land});

  @override
  State<LandDetailsScreen> createState() => _LandDetailsScreenState();
}

class _LandDetailsScreenState extends State<LandDetailsScreen> {
  late LandRecord _land;

  @override
  void initState() {
    super.initState();
    _land = widget.land;
  }

  Future<void> _openAttachmentFlow() async {
    final result = await AttachmentSheet.show(context,
      title: 'إضافة وثيقة أو صورة للمزرعة');
    if (!mounted || result == null) return;
    final current = AppState().lands.firstWhere((item) => item.id == _land.id,
      orElse: () => _land);
    final attachment = AttachmentItem(
      id: 'ATT-${DateTime.now().microsecondsSinceEpoch}',
      fileName: result.fileName,
      isDocument: result.type == AttachmentSourceType.document,
      isUploaded: false);
    final saved = AppState().saveLandAttachments(current.id,
      [...current.attachments, attachment]);
    if (saved) setState(() => _land = AppState().lands.firstWhere((item) => item.id == current.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(saved
      ? 'تم حفظ اسم المرفق محليًا؛ لم يتم رفع ملف إلى خادم.'
      : 'إضافة المرفقات متاحة للمسودات والسجلات المُرجعة فقط.')));
  }

  Future<void> _showInspectorReviewDialog() async {
    final notesController = TextEditingController(text: _land.reviewNotes ?? '');
    var selectedStatus = LandReviewStatus.approved;
    await showDialog<void>(context: context, builder: (ctx) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: const Text('قرار المراجعة التجريبي'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<LandReviewStatus>(initialValue: selectedStatus,
            items: [LandReviewStatus.approved, LandReviewStatus.requiresModification]
              .map((status) => DropdownMenuItem(value: status, child: Text(status.label))).toList(),
            onChanged: (value) { if (value != null) setDialogState(() => selectedStatus = value); }),
          TextField(controller: notesController, maxLines: 3,
            decoration: const InputDecoration(labelText: 'الملاحظات — مطلوبة عند الإرجاع')),
        ])),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () {
            final saved = AppState().updateLandStatus(_land.id, selectedStatus, notesController.text);
            if (!saved) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
                Text('تعذر الحفظ؛ تحققي من دور المفتش وحالة السجل وسبب الإرجاع.')));
              return;
            }
            setState(() => _land = AppState().lands.firstWhere((item) => item.id == _land.id));
            Navigator.pop(ctx);
          }, child: const Text('حفظ القرار'))],
      )));
    // يبقى المتحكم حتى انتهاء حركة إغلاق الحوار.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInspector = AppState().currentUser.role == UserRole.inspector;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text(_land.landName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رابط إفادة الحيازة الزراعية')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cadastral Boundary Map
            _land.boundaryPoints.length >= 3
              ? InteractiveBoundaryMap(initialPoints: _land.boundaryPoints,
                  centerLocation: GeoPoint(_land.latitude, _land.longitude),
                  height: 220, isEditable: false, showSatelliteToggle: false)
              : const Padding(padding: EdgeInsets.all(20),
                  child: Text('حدود الأرض غير مسجلة.')),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Parcel Header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _land.status.bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _land.status.color.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(_land.status.icon, color: _land.status.color, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _land.status.label,
                                style: AppTypography.titleMedium.copyWith(
                                  color: _land.status.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _land.status.label,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.forestDarkest,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isInspector && _land.status == LandReviewStatus.underReview) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.forestPrimary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _showInspectorReviewDialog,
                        icon: const Icon(Icons.rate_review_rounded, color: AppColors.forestPrimary),
                        label: const Text('تدقيق واعتماد السجل العقاري (صلاحية المفتش)'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Basic Parcel & Land Registry Details
                  _buildSectionHeader('بيانات السجل العقاري والملكية', Icons.badge_rounded),
                  const SizedBox(height: 8),
                  _buildInfoCard([
                    _buildInfoRow('رقم القطعة والمخطط:', _land.recordNumber),
                    _buildInfoRow('اسم المالك المسجل:', _land.ownerName),
                    _buildInfoRow('الرقم الوطني:', _land.ownerNationalId),
                    _buildInfoRow('المنطقة والبلدية:', '${_land.locationName} - ${_land.municipality}'),
                    _buildInfoRow('المساحة الإجمالية:', '${_land.estimatedAreaDunams} دونم (${_land.estimatedAreaHectares} هكتار)'),
                  ]),

                  const SizedBox(height: 20),

                  // Agricultural Characteristics
                  _buildSectionHeader('المواصفات والبيانات الزراعية', Icons.eco_rounded),
                  const SizedBox(height: 8),
                  _buildInfoCard([
                    _buildInfoRow('المحاصيل القائمة:', _land.crops.map((crop) => crop.cropType).join('، ')),
                    _buildInfoRow('طبيعة التربة:', _land.soilType),
                    _buildInfoRow('مصدر مياه الري:', _land.waterSource),
                    _buildInfoRow('تاريخ التسجيل:', '${_land.createdAt.year}/${_land.createdAt.month}/${_land.createdAt.day}'),
                  ]),

                  const SizedBox(height: 20),

                  // Official Attachments & Documents
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('المرفقات والوثائق العقارية', Icons.attachment_rounded),
                      TextButton.icon(
                        onPressed: _openAttachmentFlow,
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                        label: const Text('إرفاق جديد'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildAttachmentsList(context),

                  if (_land.reviewNotes != null && _land.reviewNotes!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader('تقرير المفتش والملاحظات الفنية', Icons.notes_rounded),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        _land.reviewNotes!,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.forestPrimary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(color: AppColors.forestDarkest),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsList(BuildContext context) {
    final allAttachments = [
      ..._land.attachments.where((item) => item.isDocument).map((item) => _AttachmentItem(item.fileName, isPdf: true)),
      ..._land.attachments.where((item) => !item.isDocument).map((item) => _AttachmentItem(item.fileName, isPdf: false)),
    ];

    if (allAttachments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'لم يتم رفع مستندات أو صور حتى الآن. يمكنك الإرفاق لإكمال التدقيق.',
                style: AppTypography.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: allAttachments.map((item) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          color: AppColors.surfacePure,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.isPdf ? const Color(0xFFFEE2E2) : AppColors.limeLight,
              child: Icon(
                item.isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                color: item.isPdf ? const Color(0xFFDC2626) : AppColors.limeDark,
                size: 20,
              ),
            ),
            title: Text(
              item.name,
              style: AppTypography.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item.isPdf ? 'مستند عقاري موثق (PDF)' : 'صورة حقلية معتمدة',
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility_outlined, size: 20, color: AppColors.forestPrimary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('معاينة المرفق: ${item.name}')),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AttachmentItem {
  final String name;
  final bool isPdf;
  const _AttachmentItem(this.name, {required this.isPdf});
}
