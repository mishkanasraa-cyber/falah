import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_app_bar.dart';
import '../add_land/screen_21_add_land_owner_details.dart';
import '../crops/screen_28_crops_list.dart';
import '../supplies/screen_48_fertilizers_catalog.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../ai_assistant/crop_disease_scanner_screen.dart';
import '../ministry/ministry_orders_screen.dart';
import 'fertilizer_calculator_screen.dart';
import 'seeds_catalog_screen.dart';

class ServicesCenterScreen extends StatelessWidget {
  const ServicesCenterScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FalahAppBar(title: 'خدمات فلاح', subtitle: 'خطوات أبسط، ورعاية أفضل لأرضك'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('كيف نقدر نساعدك؟', style: AppTypography.headlineLarge),
            const SizedBox(height: 8),
            Text('اختر الخدمة المناسبة، وتابع من حيث وصلت.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 28),
            _section('أرضك ومحاصيلك', Icons.landscape_outlined),
            _tile(Icons.add_location_alt_outlined, 'تسجيل أرض جديدة', 'بيانات المالك، الحدود والمرفقات', () {
              AppState().resetDraft();
              _open(context, const Screen21AddLandOwnerDetails());
            }),
            _tile(Icons.map_outlined, 'سجل الأراضي', 'استعراض السجلات ومتابعة المراجعة', () => AppState().setTabIndex(1)),
            _tile(Icons.grass_rounded, 'المحاصيل المسجّلة', 'راجع محاصيل كل أرض وموسم زراعتها', () => _open(context, const Screen28CropsList())),
            const SizedBox(height: 22),
            _section('الإرشاد الزراعي', Icons.spa_outlined),
            _tile(Icons.auto_awesome_outlined, 'مساعد فلاح', 'محادثة للمساعدة في استفساراتك الزراعية', () => _open(context, const AIAssistantScreen())),
            _tile(Icons.document_scanner_outlined, 'فحص النبات', 'استعراض أداة التشخيص بالصور', () => _open(context, const CropDiseaseScannerScreen())),
            _tile(Icons.calculate_outlined, 'حاسبة التسميد', 'تقدير احتياجات المحصول', () => _open(context, const FertilizerCalculatorScreen())),
            const SizedBox(height: 22),
            _section('البذور والمستلزمات', Icons.inventory_2_outlined),
            _tile(Icons.eco_outlined, 'دليل البذور', 'أصناف ومعلومات عن مواسم الزراعة', () => _open(context, const SeedsCatalogScreen())),
            _tile(Icons.science_outlined, 'دليل الأسمدة', 'استعراض مستلزمات التسميد', () => _open(context, const Screen48FertilizersCatalog())),
            _tile(Icons.receipt_long_outlined, 'طلبات المستلزمات', 'متابعة الطلبات في النسخة التجريبية', () => _open(context, const MinistryOrdersScreen())),
            const SizedBox(height: 20),
            Text('الخدمات التجريبية لا ترسل معاملات رسمية إلى الجهات الحكومية.', style: AppTypography.bodySmall),
            const SizedBox(height: 16),
          ]),
        )),
      ),
    );
  }

  Widget _section(String title, IconData icon) {
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [
      Icon(icon, color: AppColors.forestPrimary, size: 22),
      const SizedBox(width: 10),
      Expanded(child: Text(title, style: AppTypography.titleLarge)),
    ]));
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: AppColors.forestPrimary),
        ),
        title: Text(title, style: AppTypography.titleMedium),
        subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(subtitle, style: AppTypography.bodyMedium)),
        trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
        onTap: onTap,
      ),
    ));
  }
}
