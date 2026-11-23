import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_app_bar.dart';
import '../add_land/screen_21_add_land_owner_details.dart';
import '../lands/screen_20_land_record_details.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../services/fertilizer_calculator_screen.dart';
import '../services/seeds_catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // الاستماع للحالة يجعل العدادات والسجلات تتحدث بعد الرجوع من النماذج.
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final state = AppState();
        final lands = state.lands;
        final recent = [...lands]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        final area = lands.fold<double>(0, (sum, land) => sum + land.estimatedAreaHectares);
        return Scaffold(
          appBar: FalahAppBar(
            title: 'فلاح', subtitle: 'أرضك، ونموّك، في مكان واحد',
            customActions: [IconButton(
              tooltip: 'الإشعارات',
              onPressed: () => state.setTabIndex(3),
              icon: Badge(
                isLabelVisible: state.unreadNotificationsCount > 0,
                label: Text('${state.unreadNotificationsCount}'),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
              ),
            )],
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Center(child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحبًا، ${state.currentUser.fullName.split(' ').first} 🌿', style: AppTypography.headlineLarge),
                  const SizedBox(height: 6),
                  Text('تابع أراضيك وخطوتك القادمة بكل وضوح.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 22),
                  _hero(context, state, lands.length, area),
                  const SizedBox(height: 24),
                  _heading('نظرة على سجلاتك', 'كل الأراضي', () => state.setTabIndex(1)),
                  const SizedBox(height: 12),
                  // Wrap يحافظ على وضوح البطاقات مع تكبير خط الجهاز.
                  LayoutBuilder(builder: (context, box) {
                    final columns = box.maxWidth >= 560 ? 4 : 2;
                    final width = (box.maxWidth - (columns - 1) * 12) / columns;
                    return Wrap(spacing: 12, runSpacing: 12, children: LandReviewStatus.values.map((status) {
                      final count = lands.where((land) => land.status == status).length;
                      return SizedBox(width: width, child: Card(child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [Icon(status.icon, color: status.color, size: 22), const Spacer(), Text('$count', style: AppTypography.headlineLarge)]),
                          const SizedBox(height: 12), Text(status.label, style: AppTypography.titleMedium),
                        ]),
                      )));
                    }).toList());
                  }),
                  const SizedBox(height: 26),
                  _heading('أحدث الأراضي', 'عرض الكل', () => state.setTabIndex(1)),
                  const SizedBox(height: 12),
                  if (recent.isEmpty) Card(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(children: [
                      const Icon(Icons.landscape_outlined, size: 42, color: AppColors.forestPrimary),
                      const SizedBox(height: 12),
                      Text('ابدأ بأرضك الأولى', style: AppTypography.titleLarge),
                      const SizedBox(height: 6),
                      const Text('سجّل بيانات الأرض وحدودها ثم أرسلها للمراجعة.'),
                    ]),
                  )),
                  ...recent.take(3).map((land) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.landscape_rounded, color: AppColors.forestPrimary)),
                      title: Text(land.landName, style: AppTypography.titleMedium),
                      subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${land.municipality} · ${land.estimatedAreaHectares.toStringAsFixed(1)} هكتار', style: AppTypography.bodyMedium),
                        const SizedBox(height: 6), Text(land.status.label, style: AppTypography.labelMedium.copyWith(color: land.status.color)),
                      ])),
                      trailing: const Icon(Icons.chevron_left_rounded),
                      onTap: () => _open(context, Screen20LandRecordDetails(record: land)),
                    )),
                  )),
                  const SizedBox(height: 16),
                  _assistant(context),
                  const SizedBox(height: 26),
                  _heading('خدمات تساعدك تنمو', 'كل الخدمات', () => state.setTabIndex(2)),
                  const SizedBox(height: 12),
                  _service(context, Icons.grass_rounded, 'دليل البذور', 'تعرّف على الأصناف والمواسم الزراعية', const SeedsCatalogScreen()),
                  const SizedBox(height: 10),
                  _service(context, Icons.calculate_outlined, 'حاسبة التسميد', 'خطّط لاحتياجات محاصيلك', const FertilizerCalculatorScreen()),
                  const SizedBox(height: 20),
                  Text('نسخة عرض جامعية · بعض الخدمات والبيانات تجريبية', style: AppTypography.bodySmall),
                ]),
              )),
            );
          }),
        );
      },
    );
  }

  Widget _hero(BuildContext context, AppState state, int count, double area) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: AppColors.forestHeroGradient, borderRadius: BorderRadius.circular(26)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.spa_outlined, color: Color(0xFFD9E7B8), size: 34),
        const SizedBox(height: 16),
        Text('كل أرض، بداية خير.', style: AppTypography.displayMedium.copyWith(color: Colors.white)),
        const SizedBox(height: 10),
        Text('$count سجلات أراضٍ · ${area.toStringAsFixed(1)} هكتار مسجّل', style: AppTypography.bodyLarge.copyWith(color: const Color(0xFFE0E9D9))),
        const SizedBox(height: 22),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE0EABF), foregroundColor: AppColors.forestDarkest),
          onPressed: () {
            state.resetDraft();
            _open(context, const Screen21AddLandOwnerDetails());
          },
          icon: const Icon(Icons.add_rounded), label: const Text('تسجيل أرض جديدة'),
        ),
      ]),
    );
  }

  Widget _heading(String title, String action, VoidCallback onTap) {
    return Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: 16, children: [
      Text(title, style: AppTypography.titleLarge),
      TextButton(onPressed: onTap, child: Text(action)),
    ]);
  }

  Widget _assistant(BuildContext context) {
    return Card(color: AppColors.surfaceElevated, child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _open(context, const AIAssistantScreen()),
      child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        const Icon(Icons.auto_awesome_outlined, color: AppColors.forestPrimary, size: 30),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('اسأل مساعد فلاح', style: AppTypography.titleLarge),
          const SizedBox(height: 5),
          Text('إرشاد زراعي، بخطوة بسيطة', style: AppTypography.bodyMedium),
        ])),
        const Icon(Icons.chevron_left_rounded, color: AppColors.forestPrimary),
      ])),
    ));
  }

  Widget _service(BuildContext context, IconData icon, String title, String subtitle, Widget page) {
    return Card(child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: Icon(icon, color: AppColors.forestPrimary, size: 28),
      title: Text(title, style: AppTypography.titleMedium),
      subtitle: Text(subtitle, style: AppTypography.bodyMedium),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: () => _open(context, page),
    ));
  }
}
