import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final AppState _appState = AppState();
  bool _unreadOnly = false;

  void _openNotification(AppNotificationItem notification) {
    _appState.markNotificationAsRead(notification.id);

    if (notification.relatedRecordId != null) {
      _appState.setTabIndex(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, child) {
        final notifications =
            _appState.notifications
                .where((item) => !_unreadOnly || !item.isRead)
                .toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('الإشعارات'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: 'تحديد الكل كمقروء',
                onPressed: _appState.unreadNotificationsCount == 0
                    ? null
                    : _appState.markAllNotificationsAsRead,
                icon: const Icon(Icons.done_all_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'غير المقروءة: '
                          '${_appState.unreadNotificationsCount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      FilterChip(
                        label: const Text('غير المقروءة فقط'),
                        selected: _unreadOnly,
                        onSelected: (selected) {
                          setState(() {
                            _unreadOnly = selected;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: notifications.isEmpty
                      ? const Center(child: Text('لا توجد إشعارات لعرضها.'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          itemCount: notifications.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];

                            final color =
                                notification.statusType?.color ??
                                AppColors.forestPrimary;

                            final icon =
                                notification.statusType?.icon ??
                                Icons.notifications_outlined;

                            return Card(
                              color: notification.isRead
                                  ? AppColors.surfacePure
                                  : AppColors.surfaceElevated,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: color.withValues(
                                    alpha: 0.12,
                                  ),
                                  child: Icon(icon, color: color),
                                ),
                                title: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(notification.body),
                                      const SizedBox(height: 8),
                                      Text(
                                        notification.dateCategory,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: notification.isRead
                                    ? null
                                    : const Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: AppColors.forestPrimary,
                                      ),
                                onTap: () => _openNotification(notification),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
