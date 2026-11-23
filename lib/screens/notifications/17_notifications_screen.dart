import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_nav_scaffold.dart';
import '../lands/screen_20_land_record_details.dart';
import '../review/39_returned_record_explanation_screen.dart';

class Screen17Notifications extends StatefulWidget {
  const Screen17Notifications({super.key});

  @override
  State<Screen17Notifications> createState() => _Screen17NotificationsState();
}

class _Screen17NotificationsState extends State<Screen17Notifications> {
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

  void _handleNotificationTap(AppNotificationItem item) {
    _appState.markNotificationAsRead(item.id);

    if (item.relatedRecordId != null) {
      final record = _appState.lands.firstWhere(
        (l) => l.id == item.relatedRecordId,
        orElse: () => _appState.lands.first,
      );

      _appState.setSelectedRecord(record);

      if (record.status == LandReviewStatus.requiresModification) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Screen39ReturnedRecordExplanation(record: record)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Screen20LandRecordDetails(record: record)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _appState.notifications;
    final today = notifications.where((n) => n.dateCategory == 'اليوم').toList();
    final yesterday = notifications.where((n) => n.dateCategory == 'أمس').toList();
    final pastWeek = notifications.where((n) => n.dateCategory == 'الأسبوع الماضي').toList();

    return FalahNavScaffold(
      activeTabIndex: 3,
      title: 'الإشعارات والتنبيهات',
      subtitle: 'متابعة مراجعات السجل الزراعي وحالات الاعتماد',
      actions: [
        if (notifications.any((n) => !n.isRead))
          TextButton(
            onPressed: () => _appState.markAllNotificationsAsRead(),
            child: Text(
              'قراءة الكل',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.limeBright,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  Text('لا توجد إشعارات جديدة حالياً', style: AppTypography.titleMedium),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (today.isNotEmpty) ...[
                  _buildSectionHeader('اليوم'),
                  ...today.map((n) => _buildNotificationTile(n)),
                  const SizedBox(height: 16),
                ],
                if (yesterday.isNotEmpty) ...[
                  _buildSectionHeader('أمس'),
                  ...yesterday.map((n) => _buildNotificationTile(n)),
                  const SizedBox(height: 16),
                ],
                if (pastWeek.isNotEmpty) ...[
                  _buildSectionHeader('الأسبوع الماضي'),
                  ...pastWeek.map((n) => _buildNotificationTile(n)),
                ],
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.forestDarkest,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(AppNotificationItem item) {
    Color iconColor = AppColors.forestPrimary;
    Color iconBg = AppColors.surfaceElevated;
    IconData iconData = Icons.notifications_rounded;

    if (item.statusType == LandReviewStatus.approved) {
      iconColor = AppColors.statusApproved;
      iconBg = AppColors.statusApprovedBg;
      iconData = Icons.verified_rounded;
    } else if (item.statusType == LandReviewStatus.requiresModification) {
      iconColor = AppColors.statusAlert;
      iconBg = AppColors.statusAlertBg;
      iconData = Icons.warning_amber_rounded;
    } else if (item.statusType == LandReviewStatus.underReview) {
      iconColor = AppColors.statusReview;
      iconBg = AppColors.statusReviewBg;
      iconData = Icons.hourglass_top_rounded;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: item.isRead ? AppColors.surfacePure : const Color(0xFFF2FBF5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: item.isRead ? AppColors.surfaceBorder : AppColors.limeBorder,
          width: item.isRead ? 1.0 : 1.5,
        ),
      ),
      child: ListTile(
        onTap: () => _handleNotificationTap(item),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: iconBg,
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                  color: AppColors.forestDarkest,
                ),
              ),
            ),
            if (!item.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.limeDark,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.body,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textLight),
      ),
    );
  }
}
