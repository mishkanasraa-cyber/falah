import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum NotificationType {
  landStatus(
    title: 'السجل العقاري والأراضي',
    color: AppColors.forestPrimary,
    icon: Icons.domain_verification_rounded,
  ),
  weatherAlert(
    title: 'تنبيه مناخي وزراعي',
    color: AppColors.statusReview,
    icon: Icons.wb_sunny_rounded,
  ),
  geminiAdvisory(
    title: 'مساعد فلاح الذكي',
    color: AppColors.limePrimary,
    icon: Icons.psychology_rounded,
  ),
  cooperativeAnnouncement(
    title: 'الجمعية الزراعية',
    color: AppColors.forestAccent,
    icon: Icons.storefront_rounded,
  );

  final String title;
  final Color color;
  final IconData icon;

  const NotificationType({
    required this.title,
    required this.color,
    required this.icon,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final String? actionRoute;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
  });
}
