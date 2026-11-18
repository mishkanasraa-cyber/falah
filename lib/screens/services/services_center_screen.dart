import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_app_bar.dart';
import '../lands/add_land_screen.dart';
import '../ai_assistant/crop_disease_scanner_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import 'fertilizer_calculator_screen.dart';
import 'seeds_catalog_screen.dart';

class ServicesCenterScreen extends StatelessWidget {
  const ServicesCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return Scaffold(
      appBar: const FalahAppBar(
        title: 'مركز الخدمات الزراعية الشامل',
        subtitle: 'المعاملات، الأراضي، الأسمدة والدعم الفني',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category 1: Gemini AI Features
            _buildCategorySection(
              title: 'تقنيات الذكاء الاصطناعي (Gemini AI)',
              icon: Icons.psychology_rounded,
              color: AppColors.limeDark,
              items: [
                _ServiceTileData(
                  title: 'مساعد فلاح الذكي والمستشار',
                  subtitle: 'محادثة تفاعلية فورية للإرشاد الزراعي وحل المشكلات',
                  icon: Icons.chat_rounded,
                  isAi: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                    );
                  },
                ),
                _ServiceTileData(
                  title: 'تشخيص أمراض النبات بالصور',
                  subtitle: 'التقط صورة لورقة أو ثمرة واعرف المرض والعلاج فوراً',
                  icon: Icons.camera_alt_rounded,
                  isAi: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CropDiseaseScannerScreen()),
                    );
                  },
                ),
                _ServiceTileData(
                  title: 'حاسبة التسميد والري الذكية',
                  subtitle: 'برنامج دقيق لمعدلات اليوريا والداب والبوتاسيوم',
                  icon: Icons.calculate_rounded,
                  isAi: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FertilizerCalculatorScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category 2: Lands & Cadastral Records
            _buildCategorySection(
              title: 'تسجيل وتوثيق الأراضي والحيازات',
              icon: Icons.landscape_rounded,
              color: AppColors.forestPrimary,
              items: [
                _ServiceTileData(
                  title: 'تسجيل حيازة زراعية جديدة',
                  subtitle: 'رفع الكروكي وتوثيق الحدود بالسجل العقاري الزراعي',
                  icon: Icons.add_location_alt_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddLandScreen()),
                    );
                  },
                ),
                _ServiceTileData(
                  title: 'استعراض سجل الأراضي والمخطط',
                  subtitle: 'متابعة تدقيق الحدود والمطابقة المساحية للمزارع',
                  icon: Icons.map_rounded,
                  onTap: () => appState.setTabIndex(1),
                ),
                _ServiceTileData(
                  title: 'طلب فرز أو نقل ملكية زراعية',
                  subtitle: 'إجراءات التنازل وقسمة التركات للأراضي الزراعية',
                  icon: Icons.assignment_outlined,
                  onTap: () {
                    _showServiceNotice(context, 'طلب فرز حيازة زراعية');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category 3: Seeds, Fertilizers & Seasons
            _buildCategorySection(
              title: 'البذور، الأسمدة والروزنامة الزراعية',
              icon: Icons.science_rounded,
              color: const Color(0xFFD97706),
              items: [
                _ServiceTileData(
                  title: 'دليل البذور والشتلات المعتمدة',
                  subtitle: 'أصناف القمح والشعير والزيتون المناسبة لليبيا',
                  icon: Icons.grass_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SeedsCatalogScreen()),
                    );
                  },
                ),
                _ServiceTileData(
                  title: 'حصص الأسمدة والمبيدات المدعومة',
                  subtitle: 'جدول توزيع اليوريا والداب عبر الجمعيات التعاونية',
                  icon: Icons.inventory_2_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SeedsCatalogScreen()),
                    );
                  },
                ),
                _ServiceTileData(
                  title: 'طلب حفر بئر أو صيانة مضخة',
                  subtitle: 'تصاريح وزارة الموارد المائية ومراقبة الزراعة',
                  icon: Icons.water_drop_rounded,
                  onTap: () {
                    _showServiceNotice(context, 'تصريح حفر بئر ارتوازي');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Category 4: Support & Requests
            _buildCategorySection(
              title: 'المعاملات والدعم الفني',
              icon: Icons.help_outline_rounded,
              color: const Color(0xFF0284C7),
              items: [
                _ServiceTileData(
                  title: 'تجديد البطاقة الزراعية (بطاقة فلاح)',
                  subtitle: 'تحديث بيانات الحيازة واستخراج الرقم التعاوني',
                  icon: Icons.credit_card_rounded,
                  onTap: () {
                    _showServiceNotice(context, 'تجديد بطاقة فلاح');
                  },
                ),
                _ServiceTileData(
                  title: 'بلاغ عن آفة أو وباء نباتي طارئ',
                  subtitle: 'إخطار فرق المكافحة الحشرية لوزارة الزراعة',
                  icon: Icons.pest_control_rounded,
                  onTap: () {
                    _showServiceNotice(context, 'بلاغ طارئ لمكافحة الآفات');
                  },
                ),
                _ServiceTileData(
                  title: 'دليل الجمعيات التعاونية الزراعية',
                  subtitle: 'عناوين وأرقام فروع الجمعيات في كل البلديات',
                  icon: Icons.storefront_rounded,
                  onTap: () {
                    _showServiceNotice(context, 'دليل الجمعيات الزراعية');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceNotice(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(serviceName, style: AppTypography.titleLarge),
        content: Text(
          'تم تفعيل خدمة "$serviceName" إلكترونياً. يمكنك تعبئة النموذج وإرفاق المستندات المطلوبة وسيتم إشعارك بقرار اللجنة.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً، فهمت'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required IconData icon,
    required Color color,
    required List<_ServiceTileData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.forestDarkest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: item.isAi ? AppColors.limeBorder.withValues(alpha: 0.6) : AppColors.surfaceBorder,
                width: item.isAi ? 1.5 : 1.0,
              ),
            ),
            child: ListTile(
              onTap: item.onTap,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.isAi ? AppColors.limeLight : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: item.isAi ? AppColors.limeDark : AppColors.forestPrimary,
                  size: 22,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  if (item.isAi) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.limeLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Gemini',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.limeDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                item.subtitle,
                style: AppTypography.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
            ),
          );
        }),
      ],
    );
  }
}

class _ServiceTileData {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isAi;
  final VoidCallback onTap;

  _ServiceTileData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isAi = false,
    required this.onTap,
  });
}
