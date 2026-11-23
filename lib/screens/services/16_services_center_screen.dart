import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_nav_scaffold.dart';
import '../add_land/screen_21_add_land_owner_details.dart';
import '../crops/screen_28_crops_list.dart';
import '../crops/screen_29_add_crop.dart';
import '../lands/18_my_lands_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../review/38_track_review_status_screen.dart';
import '../review/39_returned_record_explanation_screen.dart';
import '../supplies/screen_46_agricultural_supplies_catalog.dart';
import '../supplies/screen_47_seeds_catalog.dart';
import '../supplies/screen_48_fertilizers_catalog.dart';
import '../surveyor/screen_43_search_for_farmer.dart';

class Screen16ServicesCenter extends StatefulWidget {
  const Screen16ServicesCenter({super.key});

  @override
  State<Screen16ServicesCenter> createState() => _Screen16ServicesCenterState();
}

class _Screen16ServicesCenterState extends State<Screen16ServicesCenter> {
  final AppState _appState = AppState();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isSurveyor = _appState.currentRole == UserRole.fieldSurveyor;

    return FalahNavScaffold(
      activeTabIndex: 2,
      title: 'مركز الخدمات الزراعية',
      subtitle: 'جميع الخدمات والمعاملات في مكان واحد',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar labeled "شن الخدمة اللي تبيها؟"
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfacePure,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: const InputDecoration(
                  hintText: 'شن الخدمة اللي تبيها؟ (ابحث هنا)',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.forestPrimary,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // If Surveyor, show Surveyor Specific Category first!
            if (isSurveyor) ...[
              _buildCategoryGroup(
                title: 'مهام موظف الحصر الميداني',
                icon: Icons.assignment_ind_rounded,
                color: AppColors.forestPrimary,
                services: [
                  _ServiceItem(
                    title: 'البحث عن مزارع',
                    subtitle:
                        'الاستعلام بالرقم الوطني أو الهاتف للتثبت من الحيازة',
                    icon: Icons.person_search_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Screen43SearchForFarmer(),
                        ),
                      );
                    },
                  ),
                  _ServiceItem(
                    title: 'تسجيل أرض لمزارع (بالإنابة)',
                    subtitle: 'توثيق الحيازة بموجب التفويض الميداني المعتمد',
                    icon: Icons.post_add_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Screen43SearchForFarmer(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],

            // 1. الأراضي (Lands)
            _buildCategoryGroup(
              title: 'الأراضي والحيازات',
              icon: Icons.landscape_rounded,
              color: AppColors.forestPrimary,
              services: [
                _ServiceItem(
                  title: 'إضافة أرض جديدة',
                  subtitle: 'بدء توثيق أرض ورفع بيانات المالك والمساحة',
                  icon: Icons.add_location_alt_rounded,
                  onTap: () {
                    _appState.resetDraft();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen21AddLandOwnerDetails(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'أراضيّ المسجلة',
                  subtitle: 'عرض ومتابعة كافة الحيازات والمسودات المحفوظة',
                  icon: Icons.map_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen18MyLands(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'الموقع والحدود الجغرافية',
                  subtitle: 'استعراض ورسم مضلعات الأراضي ونقاط GPS',
                  icon: Icons.polyline_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen28CropsList(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 2. المحاصيل (Crops)
            _buildCategoryGroup(
              title: 'المحاصيل الزراعية',
              icon: Icons.eco_rounded,
              color: AppColors.limeDark,
              services: [
                _ServiceItem(
                  title: 'محاصيلي القائمة',
                  subtitle:
                      'قائمة المحاصيل الموثقة بكل حيازة ومساحتها المزروعة',
                  icon: Icons.grass_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen28CropsList(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'إضافة محصول جديد',
                  subtitle: 'تسجيل نوع المحصول وموسم الزراعة والمساحة بالهكتار',
                  icon: Icons.nature_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen29AddCrop(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 3. المستلزمات الزراعية (Supplies)
            _buildCategoryGroup(
              title: 'المستلزمات الزراعية (كتالوج استرشادي)',
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFFD97706),
              services: [
                _ServiceItem(
                  title: 'كتالوج المستلزمات الزراعية',
                  subtitle: 'استعراض أصناف البذور والأسمدة (بيانات تجريبية)',
                  icon: Icons.storefront_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Screen46AgriculturalSuppliesCatalog(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'أصناف البذور المعتمدة',
                  subtitle: 'بذور القمح والشعير والشتلات المحلية',
                  icon: Icons.grain_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen47SeedsCatalog(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'أصناف الأسمدة والمغذيات',
                  subtitle: 'أسمدة اليوريا والداب والبوتاسيوم الإرشادية',
                  icon: Icons.science_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Screen48FertilizersCatalog(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 4. الطلبات والمراجعات (Requests & Juthoor)
            _buildCategoryGroup(
              title: 'الطلبات والمراجعات في منصة جُذور',
              icon: Icons.fact_check_rounded,
              color: const Color(0xFF0284C7),
              services: [
                _ServiceItem(
                  title: 'متابعة حالة الطلبات',
                  subtitle: 'المخطط الزمني لمراجعة الحيازات في منصة جُذور',
                  icon: Icons.timeline_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Screen38TrackReviewStatus(
                          record: _appState.lands.first,
                        ),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'التعديلات المطلوبة (السجلات المرتجعة)',
                  subtitle: 'ملاحظات المراجعين وتصحيح التداخلات أو المستندات',
                  icon: Icons.warning_amber_rounded,
                  onTap: () {
                    final returned = _appState.lands.firstWhere(
                      (l) => l.status == LandReviewStatus.requiresModification,
                      orElse: () => _appState.lands.first,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            Screen39ReturnedRecordExplanation(record: returned),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 5. المساعدة (Help & AI Assistant)
            _buildCategoryGroup(
              title: 'المساعدة والدعم',
              icon: Icons.help_outline_rounded,
              color: AppColors.forestPrimary,
              services: [
                _ServiceItem(
                  title: 'مساعد فلاح الذكي',
                  subtitle: 'استشارات إجرائية فورية وشرح خطوات التوثيق',
                  icon: Icons.psychology_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AIAssistantScreen(),
                      ),
                    );
                  },
                ),
                _ServiceItem(
                  title: 'دليل الاستخدام والإرشادات',
                  subtitle: 'شرح كامل لمعايير قبول السجلات والمخططات المساحية',
                  icon: Icons.menu_book_rounded,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('دليل استخدام فلاح'),
                        content: const Text(
                          'تطبيق فلاح يتيح توثيق الملكيات الزراعية في ليبيا. يتم تدقيق الملفات عبر منصة جُذور المخصصة للجان الزراعية. للمساعدة المباشرة يرجى استخدام مساعد فلاح الذكي.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('حسناً'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGroup({
    required String title,
    required IconData icon,
    required Color color,
    required List<_ServiceItem> services,
  }) {
    final filtered = services.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.title.contains(_searchQuery) ||
          s.subtitle.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

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
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.forestDarkest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...filtered.map((item) {
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.surfaceBorder),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: color, size: 20),
              ),
              title: Text(
                item.title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item.subtitle,
                style: AppTypography.bodySmall.copyWith(fontSize: 10),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textLight,
              ),
              onTap: item.onTap,
            ),
          );
        }),
      ],
    );
  }
}

class _ServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
