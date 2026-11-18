import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../models/ministry_order_model.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_app_bar.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/smart_assistant_banner.dart';
import '../lands/add_land_screen.dart';
import '../ai_assistant/crop_disease_scanner_screen.dart';
import '../services/fertilizer_calculator_screen.dart';
import '../services/seeds_catalog_screen.dart';
import '../ministry/ministry_orders_screen.dart';
import '../ministry/create_supply_request_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final user = appState.currentUser;
    final lands = appState.lands;

    final approvedCount = lands
        .where((l) => l.status == LandReviewStatus.approved)
        .length;
    final reviewCount = lands
        .where((l) => l.status == LandReviewStatus.underReview)
        .length;
    final draftCount = lands
        .where((l) => l.status == LandReviewStatus.draft)
        .length;

    final readyOrders = appState.ministryOrders
        .where((o) => o.status == OrderStatus.approvedReadyForPickup)
        .toList();

    return Scaffold(
      appBar: FalahAppBar(
        title: 'منظومة فلاح الزراعية',
        subtitle: 'المساعد الذكي والربط السيادي مع وزارة الزراعة',
        customActions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () => appState.setTabIndex(3),
            tooltip: 'الإشعارات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Greeting & Add Land CTA Banner
            _buildHeroGreeting(context, user, appState),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),

                  // 2. Prominent "مساعد فلاح الذكي" Entry
                  const SmartAssistantBanner(),

                  const SizedBox(height: 18),

                  // 3. Ministry & Cooperatives Distribution Hub Banner (Linking Farmer to Ministry)
                  _buildMinistryLinkBanner(context, readyOrders),

                  const SizedBox(height: 20),

                  // 4. Simple Weather Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الأرصاد والمناخ الزراعي',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.forestDarkest,
                        ),
                      ),
                      Text(
                        'بيانات محطات الرصد',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const WeatherCard(),

                  const SizedBox(height: 22),

                  // 5. Land Record Statuses Overview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سجلات الأراضي والحيازات',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.forestDarkest,
                        ),
                      ),
                      TextButton(
                        onPressed: () => appState.setTabIndex(1),
                        child: Text(
                          'عرض الكل (${lands.length})',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.forestPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildRecordStatusesRow(
                    context,
                    appState,
                    approvedCount,
                    reviewCount,
                    draftCount,
                  ),

                  const SizedBox(height: 22),

                  // 6. Quick Services Grid
                  Text(
                    'الخدمات السريعة',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickServicesGrid(context, appState),

                  const SizedBox(height: 22),

                  // 7. Recent Activity Feed
                  Text(
                    'النشاط والتحديثات الأخيرة',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRecentActivity(context, appState),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGreeting(
    BuildContext context,
    dynamic user,
    AppState appState,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F3827), Color(0xFF14532D), Color(0xFF1B4D3E)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.limeBright.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً بك،',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.limeLight.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                          Text(
                            user.fullName,
                            style: AppTypography.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: AppColors.limeBright,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${user.city} • بطاقة فلاح: ${user.agriculturalCardNumber}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeBright,
                        foregroundColor: AppColors.forestDarkest,
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddLandScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_location_alt_rounded,
                        size: 18,
                        color: AppColors.forestDarkest,
                      ),
                      label: Text(
                        'إضافة أرض',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinistryLinkBanner(
    BuildContext context,
    List<MinistrySupplyOrder> readyOrders,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.forestPrimary.withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.forestPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'بوابة الربط مع وزارة الزراعة والجمعيات',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'توفير الأسمدة والبذور الأصلية وأدوية المحاصيل المدعومة',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (readyOrders.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusApprovedBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${readyOrders.length} إذن صرف جاهز',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.statusApproved,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.forestPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MinistryOrdersScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.qr_code_2_rounded,
                    size: 18,
                    color: AppColors.forestPrimary,
                  ),
                  label: const Text('متابعة أذونات الصرف'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CreateSupplyRequestDialog(),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: const Text('طلب حصة مدعومة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordStatusesRow(
    BuildContext context,
    AppState appState,
    int approved,
    int review,
    int draft,
  ) {
    return Row(
      children: [
        _buildStatusCard(
          context: context,
          title: 'معتمدة وموثقة',
          count: approved,
          statusColor: AppColors.statusApproved,
          bgColor: AppColors.statusApprovedBg,
          icon: Icons.verified_rounded,
          onTap: () => appState.setTabIndex(1),
        ),
        const SizedBox(width: 10),
        _buildStatusCard(
          context: context,
          title: 'قيد المراجعة',
          count: review,
          statusColor: AppColors.statusReview,
          bgColor: AppColors.statusReviewBg,
          icon: Icons.hourglass_top_rounded,
          onTap: () => appState.setTabIndex(1),
        ),
        const SizedBox(width: 10),
        _buildStatusCard(
          context: context,
          title: 'مسودات',
          count: draft,
          statusColor: AppColors.statusDraft,
          bgColor: AppColors.statusDraftBg,
          icon: Icons.edit_note_rounded,
          onTap: () => appState.setTabIndex(1),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required int count,
    required Color statusColor,
    required Color bgColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surfacePure,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: statusColor, size: 16),
                  ),
                  Text(
                    '$count',
                    style: AppTypography.headlineMedium.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServicesGrid(BuildContext context, AppState appState) {
    final services = [
      _QuickServiceItem(
        title: 'صرف الأدوية والأسمدة',
        subtitle: 'منظومة حصص الوزارة والجمعيات',
        icon: Icons.account_balance_rounded,
        color: AppColors.forestPrimary,
        bgColor: const Color(0xFFE8F5E9),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MinistryOrdersScreen()),
          );
        },
      ),
      _QuickServiceItem(
        title: 'تشخيص النبات الذكي',
        subtitle: 'فحص فوري عبر كاميرا Gemini',
        icon: Icons.camera_alt_rounded,
        color: AppColors.limeDark,
        bgColor: AppColors.limeLight,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CropDiseaseScannerScreen()),
          );
        },
      ),
      _QuickServiceItem(
        title: 'حاسبة التسميد والري',
        subtitle: 'حساب جرعات NPK بالذكاء',
        icon: Icons.calculate_rounded,
        color: const Color(0xFF0284C7),
        bgColor: const Color(0xFFE0F2FE),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FertilizerCalculatorScreen(),
            ),
          );
        },
      ),
      _QuickServiceItem(
        title: 'البذور الأصلية والروزنامة',
        subtitle: 'أصناف معتمدة ومواعيد البذر',
        icon: Icons.grass_rounded,
        color: const Color(0xFFD97706),
        bgColor: const Color(0xFFFEF3C7),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SeedsCatalogScreen()),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = services[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfacePure,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context, AppState appState) {
    final notifications = appState.notifications.take(3).toList();

    if (notifications.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('لا توجد إشعارات حديثة.'),
      );
    }

    return Column(
      children: notifications.map((notification) {
        final color = notification.statusType?.color ?? AppColors.forestPrimary;

        final icon =
            notification.statusType?.icon ?? Icons.notifications_outlined;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            title: Text(
              notification.title,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 13,
                fontWeight: notification.isRead
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              notification.body,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textLight,
            ),
            onTap: () {
              appState.markNotificationAsRead(notification.id);

              if (notification.relatedRecordId != null) {
                appState.setTabIndex(1);
              } else {
                appState.setTabIndex(3);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _QuickServiceItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  _QuickServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
}
