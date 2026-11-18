import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../widgets/interactive_boundary_map.dart';
import '../review/38_track_review_status_screen.dart';
import '../review/39_returned_record_explanation_screen.dart';
import '../review/screen_40_edit_returned_record.dart.dart';
import '../supplies/screen_46_agricultural_supplies_catalog.dart';

class Screen20LandRecordDetails extends StatelessWidget {
  final LandRecord record;

  const Screen20LandRecordDetails({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text(
          record.landName,
          style: AppTypography.titleLarge.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.forestDarkest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            tooltip: 'مشاركة ملخص السجل',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم نسخ رقم السجل الزراعي للمشاركة'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner
            _buildStatusBanner(context),
            const SizedBox(height: 16),

            // Return Reason Alert if requires modification
            if (record.status == LandReviewStatus.requiresModification &&
                record.returnReason != null)
              _buildReturnReasonCard(context),

            // General Land Information Card
            _buildGeneralInfoCard(),
            const SizedBox(height: 16),

            // Location & Boundary Map Card
            _buildMapCard(context),
            const SizedBox(height: 16),

            // Crops Card
            _buildCropsCard(),
            const SizedBox(height: 16),

            // Attachments Card
            _buildAttachmentsCard(),
            const SizedBox(height: 16),

            // Review Timeline Card
            _buildTimelineCard(context),
            const SizedBox(height: 24),

            // Actions Bottom Area
            _buildActionButtons(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: record.status.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: record.status.color.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              record.status.icon,
              color: record.status.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'حالة السجل: ${record.status.label}',
                      style: AppTypography.titleMedium.copyWith(
                        color: record.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      record.recordNumber,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(record.status),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(LandReviewStatus status) {
    switch (status) {
      case LandReviewStatus.draft:
        return 'هذا السجل محفوظ كمسودة على هذا الجهاز ولم يتم إرساله للتدقيق بعد.';
      case LandReviewStatus.underReview:
        return 'الملف قيد المراجعة الفنية والإدارية لدى فريق التدقيق في جُذور.';
      case LandReviewStatus.requiresModification:
        return 'تم إرجاع الطلب لوجود ملاحظات تتطلب التصحيح وإعادة الإرسال.';
      case LandReviewStatus.approved:
        return 'تم اعتماد السجل رسمياً وتأكيد صحة المخطط والمحاصيل.';
    }
  }

  Widget _buildReturnReasonCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF87171), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.feedback_rounded,
                color: AppColors.statusAlert,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'ملاحظات المدقق (منصة جُذور)',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.statusAlert,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.returnReason!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (record.affectedFields.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: record.affectedFields.map((field) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.statusAlert.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    'يتطلب تعديل: $field',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.statusAlert,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        Screen39ReturnedRecordExplanation(record: record),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('عرض التفاصيل والتعديل الآن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusAlert,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'بيانات الحيازة والمالك',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (record.isEnteredOnBehalf)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.limeLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'مسجل بواسطة مساح زراعي',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.limeDark,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 20),
          _buildInfoRow('اسم الأرض / المزرعة', record.landName),
          _buildInfoRow('المالك / صاحب الحيازة', record.ownerName),
          _buildInfoRow('الرقم الوطني للمالك', record.ownerNationalId),
          _buildInfoRow('رقم الهاتف', record.ownerPhone),
          _buildInfoRow('البلدية', record.municipality),
          _buildInfoRow('الموقع الإداري', record.locationName),
          if (record.enteredBySurveyorName != null)
            _buildInfoRow('المساح المعتمد', record.enteredBySurveyorName!),
        ],
      ),
    );
  }

  Widget _buildMapCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الموقع الجغرافي والحدود',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.limeLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${record.boundaryPoints.length} نقاط حدودية',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.forestPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Area summary pill
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warmBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('المساحة المقدرة', style: AppTypography.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${record.estimatedAreaHectares.toStringAsFixed(2)} هكتار',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(height: 30, width: 1, color: AppColors.surfaceBorder),
                Column(
                  children: [
                    Text('بالمقياس المحلي', style: AppTypography.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${record.estimatedAreaDunams.toStringAsFixed(1)} دونم',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(height: 30, width: 1, color: AppColors.surfaceBorder),
                Column(
                  children: [
                    Text('الإحداثيات', style: AppTypography.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${record.latitude.toStringAsFixed(3)}°, ${record.longitude.toStringAsFixed(3)}°',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Boundary Map Viewer
          SizedBox(
            height: 220,
            child: InteractiveBoundaryMap(
              centerLocation: GeoPoint(record.latitude, record.longitude),
              initialPoints: record.boundaryPoints,
              isEditable: false,
              height: 220,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المحاصيل الزراعية المسجلة (${record.crops.length})',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.eco_rounded, color: AppColors.forestPrimary),
            ],
          ),
          const Divider(height: 20),
          if (record.crops.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'لا توجد محاصيل مسجلة في هذا السجل بعد.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...record.crops.map((crop) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warmBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.limeLight,
                      child: const Icon(
                        Icons.grass_rounded,
                        color: AppColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.cropType,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'الموسم: ${crop.season} • المساحة: ${crop.cultivatedAreaHectares.toStringAsFixed(1)} هكتار',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المرفقات والوثائق (${record.attachments.length})',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.attach_file_rounded,
                color: AppColors.forestPrimary,
              ),
            ],
          ),
          const Divider(height: 20),
          if (record.attachments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'لا توجد مرفقات ملحقة بهذا السجل.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...record.attachments.map((att) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warmBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      att.isDocument
                          ? Icons.description_rounded
                          : Icons.photo_camera_rounded,
                      color: AppColors.forestPrimary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            att.fileName,
                            style: AppTypography.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (att.caption != null)
                            Text(
                              att.caption!,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.statusApproved,
                      size: 18,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مراحل مراجعة منصة جُذور',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Screen38TrackReviewStatus(record: record),
                    ),
                  );
                },
                child: const Text('تتبع مفصل'),
              ),
            ],
          ),
          const Divider(height: 16),
          ...record.reviewTimeline.map((step) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    step.isDone
                        ? Icons.check_circle_rounded
                        : (step.isCurrent
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked),
                    color: step.isDone
                        ? AppColors.statusApproved
                        : (step.isCurrent
                              ? AppColors.forestPrimary
                              : AppColors.textSecondary),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              step.title,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: step.isCurrent
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                            if (step.date != null)
                              Text(step.date!, style: AppTypography.labelSmall),
                          ],
                        ),
                        Text(
                          step.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (record.status == LandReviewStatus.requiresModification) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Screen40EditReturnedRecord(record: record),
            ),
          );
        },
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('تعديل الحقول المطلوبة وإعادة الإرسال'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    if (record.status == LandReviewStatus.approved) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Screen46AgriculturalSuppliesCatalog(),
                ),
              );
            },
            icon: const Icon(Icons.local_shipping_rounded),
            label: const Text('طلب البذور والأسمدة المعتمدة لهذه الأرض'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'جاري إنشاء وطباعة وثيقة الحيازة الرسمية PDF...',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.print_rounded),
            label: const Text('تحميل بطاقة الحيازة المعتمدة (PDF)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.forestPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }

    return OutlinedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Screen38TrackReviewStatus(record: record),
          ),
        );
      },
      icon: const Icon(Icons.track_changes_rounded),
      label: const Text('متابعة مراحل الفحص في منصة جُذور'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.forestPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
