import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

enum AttachmentSourceType {
  camera,
  gallery,
  document,
  sample,
}

class AttachmentResult {
  final AttachmentSourceType type;
  final String fileName;
  final String label;

  const AttachmentResult({
    required this.type,
    required this.fileName,
    required this.label,
  });
}

class AttachmentSheet {
  static Future<AttachmentResult?> show(
    BuildContext context, {
    String title = 'إرفاق وثيقة أو صورة للمزرعة',
    bool allowDocuments = true,
  }) {
    return showModalBottomSheet<AttachmentResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfacePure,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.forestDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.attach_file_rounded, color: AppColors.limeBright, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(color: AppColors.forestDarkest),
                        ),
                        Text(
                          'مرفقات التوثيق العقاري وإثبات الحيازة أو فحص النبات',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 12),

              // Option 1: Live Field Camera
              _buildOptionTile(
                ctx,
                icon: Icons.photo_camera_rounded,
                iconColor: AppColors.limeDark,
                iconBg: AppColors.limeLight,
                title: 'التقاط صورة بكاميرا الحقل (مباشر)',
                subtitle: 'تصوير معالم الأرض، بئر المياه، أو أعراض إصابة النبات',
                onTap: () {
                  Navigator.pop(
                    ctx,
                    const AttachmentResult(
                      type: AttachmentSourceType.camera,
                      fileName: 'field_capture_2026.jpg',
                      label: 'صورة حقلية ملتقطة بالكاميرا',
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Option 2: Gallery
              _buildOptionTile(
                ctx,
                icon: Icons.photo_library_rounded,
                iconColor: AppColors.forestPrimary,
                iconBg: AppColors.surfaceElevated,
                title: 'اختيار صورة من ألبوم الجهاز',
                subtitle: 'رفع صور مسجلة مسبقاً لحدود المزرعة أو المحاصيل',
                onTap: () {
                  Navigator.pop(
                    ctx,
                    const AttachmentResult(
                      type: AttachmentSourceType.gallery,
                      fileName: 'farm_overview.jpg',
                      label: 'صورة من المعرض',
                    ),
                  );
                },
              ),

              if (allowDocuments) ...[
                const SizedBox(height: 8),
                // Option 3: Document / PDF
                _buildOptionTile(
                  ctx,
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: const Color(0xFFDC2626),
                  iconBg: const Color(0xFFFEE2E2),
                  title: 'إرفاق مستند عقاري رسمي (PDF/صورة)',
                  subtitle: 'شهادة عقارية، عقد انتفاع، حصر ورثة، أو مخطط كروكي مساحي',
                  onTap: () {
                    Navigator.pop(
                      ctx,
                      const AttachmentResult(
                        type: AttachmentSourceType.document,
                        fileName: 'شهادة_عقارية_رسمية.pdf',
                        label: 'مستند عقاري موثق',
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Quick Samples for Instant Testing
              Text(
                'نماذج سريعة للتجربة:',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    backgroundColor: AppColors.surfaceElevated,
                    avatar: const Icon(Icons.eco_rounded, size: 16, color: AppColors.forestPrimary),
                    label: Text('عينة شجرة زيتون', style: AppTypography.bodySmall),
                    onPressed: () {
                      Navigator.pop(
                        ctx,
                        const AttachmentResult(
                          type: AttachmentSourceType.sample,
                          fileName: 'sample_olive_field.jpg',
                          label: 'عينة بستان زيتون الجفارة',
                        ),
                      );
                    },
                  ),
                  ActionChip(
                    backgroundColor: AppColors.surfaceElevated,
                    avatar: const Icon(Icons.description_rounded, size: 16, color: AppColors.forestPrimary),
                    label: Text('مخطط مساحي معتمد', style: AppTypography.bodySmall),
                    onPressed: () {
                      Navigator.pop(
                        ctx,
                        const AttachmentResult(
                          type: AttachmentSourceType.sample,
                          fileName: 'sample_cadastral_map.pdf',
                          label: 'رسم كروكي هندسي',
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.surfacePure,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(fontSize: 11),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
      ),
    );
  }
}
