import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';
import '../screens/home/14_farmer_home_screen.dart';
import '../screens/home/15_field_surveyor_home_screen.dart';
import '../screens/lands/18_my_lands_screen.dart';
import '../screens/services/16_services_center_screen.dart';
import '../screens/notifications/17_notifications_screen.dart';
import '../screens/profile/screen_50_profile_settings_help.dart';
import '../screens/auth/screen_07_login.dart';
import 'screen_directory_sheet.dart';

class FalahNavScaffold extends StatelessWidget {
  final Widget body;
  final int
  activeTabIndex; // 0: الرئيسية, 1: الأراضي, 2: الخدمات, 3: الإشعارات, 4: حسابي
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const FalahNavScaffold({
    super.key,
    required this.body,
    required this.activeTabIndex,
    required this.title,
    this.subtitle,
    this.actions,
    this.floatingActionButton,
  });

  void _openTopRightDropdown(BuildContext context, GlobalKey buttonKey) {
    final appState = AppState();
    final renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // RTL Start is on the right side
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height + 6,
      screenSize.width - (offset.dx + size.width),
      screenSize.height - (offset.dy + size.height),
    );

    showMenu<void>(
      context: context,
      position: position,
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      color: AppColors.surfacePure,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      items: [
        // User Profile Summary Header
        PopupMenuItem<void>(
          enabled: false,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.surfaceDivider),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.forestPrimary,
                  child: Text(
                    appState.userName.isNotEmpty ? appState.userName[0] : 'ف',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appState.userName,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.limeLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          appState.currentRole.nameAr,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.limeDark,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick Role Switcher
        PopupMenuItem<void>(
          onTap: () {
            final newRole = appState.currentRole == UserRole.farmer
                ? UserRole.fieldSurveyor
                : UserRole.farmer;
            appState.switchRole(newRole);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => newRole == UserRole.fieldSurveyor
                    ? const Screen15FieldSurveyorHome()
                    : const Screen14FarmerHome(),
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                appState.currentRole == UserRole.farmer
                    ? Icons.assignment_ind_rounded
                    : Icons.agriculture_rounded,
                size: 18,
                color: AppColors.forestPrimary,
              ),
              const SizedBox(width: 10),
              Text(
                appState.currentRole == UserRole.farmer
                    ? 'التحويل لدور: موظف حصر زراعي'
                    : 'التحويل لدور: مزارع',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // 50 Screens Directory Quick Jump
        PopupMenuItem<void>(
          onTap: () {
            Future.delayed(Duration.zero, () {
              if (!context.mounted) {
                return;
              }
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ScreenDirectorySheet(),
              );
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.apps_rounded,
                size: 18,
                color: AppColors.limeDark,
              ),
              const SizedBox(width: 10),
              Text(
                'فهرس الشاشات الـ 50 (دليل التنقل)',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestDarkest,
                ),
              ),
            ],
          ),
        ),

        // Settings & Profile
        PopupMenuItem<void>(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Screen50ProfileSettingsHelp(),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Text('الإعدادات والملف الشخصي', style: AppTypography.bodySmall),
            ],
          ),
        ),

        const PopupMenuDivider(),

        // Logout
        PopupMenuItem<void>(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Screen07Login()),
              (route) => false,
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.statusAlert,
              ),
              const SizedBox(width: 10),
              Text(
                'تسجيل الخروج',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.statusAlert,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onBottomNavTapped(BuildContext context, int index) {
    if (index == activeTabIndex) return;

    final appState = AppState();
    appState.setTabIndex(index);

    Widget target;
    switch (index) {
      case 0:
        target = appState.currentRole == UserRole.fieldSurveyor
            ? const Screen15FieldSurveyorHome()
            : const Screen14FarmerHome();
        break;
      case 1:
        target = const Screen18MyLands();
        break;
      case 2:
        target = const Screen16ServicesCenter();
        break;
      case 3:
        target = const Screen17Notifications();
        break;
      case 4:
        target = const Screen50ProfileSettingsHelp();
        break;
      default:
        target = const Screen14FarmerHome();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => target,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final GlobalKey menuKey = GlobalKey();

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 6),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.forestHeroGradient,
            boxShadow: [
              BoxShadow(
                color: Color(0x20071F15),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                children: [
                  // Top-Right Refined RTL Dropdown Trigger
                  InkWell(
                    key: menuKey,
                    onTap: () => _openTopRightDropdown(context, menuKey),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.limeBright,
                            child: Text(
                              appState.userName.isNotEmpty
                                  ? appState.userName[0]
                                  : 'ف',
                              style: const TextStyle(
                                color: AppColors.forestDarkest,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.limeLight.withValues(alpha: 0.9),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Actions
                  ...?actions,

                  // 50 Screens Quick Access Icon
                  IconButton(
                    icon: const Icon(
                      Icons.apps_rounded,
                      color: AppColors.limeBright,
                      size: 22,
                    ),
                    tooltip: 'فهرس الشاشات الـ 50',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ScreenDirectorySheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          border: const Border(
            top: BorderSide(color: AppColors.surfaceBorder, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: activeTabIndex,
          onDestinationSelected: (idx) => _onBottomNavTapped(context, idx),
          backgroundColor: AppColors.surfacePure,
          indicatorColor: AppColors.limeLight,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: AppColors.forestDark,
              ),
              label: 'الرئيسية',
            ),
            const NavigationDestination(
              icon: Icon(Icons.landscape_outlined),
              selectedIcon: Icon(
                Icons.landscape_rounded,
                color: AppColors.forestDark,
              ),
              label: 'الأراضي',
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(
                Icons.grid_view_rounded,
                color: AppColors.forestDark,
              ),
              label: 'الخدمات',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: appState.notifications.any((n) => !n.isRead),
                label: Text(
                  '${appState.notifications.where((n) => !n.isRead).length}',
                ),
                backgroundColor: AppColors.limeDark,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              selectedIcon: Badge(
                isLabelVisible: appState.notifications.any((n) => !n.isRead),
                label: Text(
                  '${appState.notifications.where((n) => !n.isRead).length}',
                ),
                backgroundColor: AppColors.limeDark,
                child: const Icon(
                  Icons.notifications_rounded,
                  color: AppColors.forestDark,
                ),
              ),
              label: 'الإشعارات',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(
                Icons.person_rounded,
                color: AppColors.forestDark,
              ),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
