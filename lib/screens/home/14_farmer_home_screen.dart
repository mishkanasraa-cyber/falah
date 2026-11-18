import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_nav_scaffold.dart';
import '../add_land/screen_21_add_land_owner_details.dart';
import '../lands/18_my_lands_screen.dart';
import '../lands/screen_20_land_record_details.dart';
import '../review/39_returned_record_explanation_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';

class Screen14FarmerHome extends StatefulWidget {
  const Screen14FarmerHome({super.key});

  @override
  State<Screen14FarmerHome> createState() => _Screen14FarmerHomeState();
}

class _Screen14FarmerHomeState extends State<Screen14FarmerHome> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _appState.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final approvedCount = _appState.lands
        .where((l) => l.status == LandReviewStatus.approved)
        .length;
    final reviewCount = _appState.lands
        .where((l) => l.status == LandReviewStatus.underReview)
        .length;
    final returnedCount = _appState.lands
        .where((l) => l.status == LandReviewStatus.requiresModification)
        .length;
    final draftCount = _appState.lands
        .where((l) => l.status == LandReviewStatus.draft)
        .length;

    return FalahNavScaffold(
      activeTabIndex: 0,
      title: 'فلاح',
      subtitle: 'توثيق الأراضي والمحاصيل الزراعية',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Greeting & Add Land Header
            _buildHeroHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 2. Prominent AI Assistant Card (Visible without scrolling)
                  _buildProminentAiAssistantCard(context),

                  const SizedBox(height: 16),

                  // 3. Simple Weather Card (Honest placeholder unless connected)
                  _buildWeatherCard(context),

                  const SizedBox(height: 20),

                  // 4. Status Summary Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ملخص حالات الحيازات',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.forestDarkest,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Screen18MyLands(),
                            ),
                          );
                        },
                        child: Text(
                          'عرض الكل (${_appState.lands.length})',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.forestPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildStatusCardsGrid(
                    approvedCount,
                    reviewCount,
                    returnedCount,
                    draftCount,
                  ),

                  const SizedBox(height: 20),

                  // 5. Service Shortcuts
                  Text(
                    'الخدمات السريعة',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildServiceShortcuts(context),

                  const SizedBox(height: 20),

                  // 6. Recent Activity & Records
                  Text(
                    'النشاط والتحديثات الأخيرة',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRecentActivityList(context),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F3827), Color(0xFF14532D)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بك،',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.limeLight,
                  ),
                ),
                Text(
                  _appState.userName,
                  style: AppTypography.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'بلدية ${_appState.userMunicipality} • حساب مزارع',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Primary "إضافة أرض" CTA with Fresh Lime Accent
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.limeBright,
              foregroundColor: AppColors.forestDarkest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
            ),
            onPressed: () {
              _appState.resetDraft();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Screen21AddLandOwnerDetails(),
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
    );
  }

  Widget _buildProminentAiAssistantCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F3827), Color(0xFF1B4D3E)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.limeBorder.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3827).withValues(alpha: 0.2),
            offset: const Offset(0, 6),
            blurRadius: 14,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.limeLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: AppColors.forestDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مساعد فلاح الذكي 🌿',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'مرشدك الإجرائي لتوثيق الأراضي ورسم الحدود',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.limeLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'دليل فوري',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'اسأل المساعد الذكي عن خطوات تسجيل الأرض، معنى الحالات في جُذور، أو كيفية حل تداخلات الحدود.',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildPromptChip(context, 'كيف نضيف أرض؟'),
              _buildPromptChip(context, 'كيف نحدد الحدود؟'),
              _buildPromptChip(context, 'شن معنى قيد المراجعة؟'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeBright,
                foregroundColor: AppColors.forestDarkest,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
              label: const Text(
                'محادثة مع مساعد فلاح',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        _appState.sendAiMessage(text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    if (!_appState.isWeatherConnected) {
      // Honest placeholder when disconnected
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الطقس غير متاح حاليًا',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'لا توجد محطة رصد متصلة ببلدية ${_appState.userMunicipality}. لا تُعرض بيانات افتراضية.',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _appState.toggleWeatherConnection(),
              child: const Text('ربط تجريبي'),
            ),
          ],
        ),
      );
    }

    // Connected state
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.limeBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.limeLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: Color(0xFFD97706),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طقس بلدية ${_appState.userMunicipality}: 24°C • مشمس معتدل',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'محطة الأرصاد الزراعية متصلة • رطوبة 48% • رياح 12 كم/س',
                  style: AppTypography.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () => _appState.toggleWeatherConnection(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCardsGrid(
    int approved,
    int review,
    int returned,
    int draft,
  ) {
    return Row(
      children: [
        _buildMiniStatus(
          title: 'معتمد',
          count: approved,
          color: AppColors.statusApproved,
          bg: AppColors.statusApprovedBg,
        ),
        const SizedBox(width: 8),
        _buildMiniStatus(
          title: 'قيد المراجعة',
          count: review,
          color: AppColors.statusReview,
          bg: AppColors.statusReviewBg,
        ),
        const SizedBox(width: 8),
        _buildMiniStatus(
          title: 'يتطلب تعديلًا',
          count: returned,
          color: AppColors.statusAlert,
          bg: AppColors.statusAlertBg,
        ),
        const SizedBox(width: 8),
        _buildMiniStatus(
          title: 'مسودة',
          count: draft,
          color: AppColors.statusDraft,
          bg: AppColors.statusDraftBg,
        ),
      ],
    );
  }

  Widget _buildMiniStatus({
    required String title,
    required int count,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: AppTypography.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceShortcuts(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildShortcutTile(
            title: 'أراضيّ المسجلة',
            icon: Icons.landscape_rounded,
            color: AppColors.forestPrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Screen18MyLands()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildShortcutTile(
            title: 'إضافة أرض جديدة',
            icon: Icons.add_location_alt_rounded,
            color: AppColors.limeDark,
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
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildShortcutTile(
            title: 'مركز الخدمات',
            icon: Icons.grid_view_rounded,
            color: const Color(0xFF0284C7),
            onTap: () => _appState.setTabIndex(2),
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    final lands = _appState.lands.take(3).toList();

    return Column(
      children: lands.map((land) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
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
              backgroundColor: land.status.bgColor,
              child: Icon(land.status.icon, color: land.status.color, size: 20),
            ),
            title: Text(
              land.landName,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${land.municipality} • ${land.recordNumber} • حالة: ${land.status.label}',
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textLight,
            ),
            onTap: () {
              _appState.setSelectedRecord(land);
              if (land.status == LandReviewStatus.requiresModification) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        Screen39ReturnedRecordExplanation(record: land),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Screen20LandRecordDetails(record: land),
                  ),
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
