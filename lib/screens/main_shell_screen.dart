import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/app_state.dart';
import 'home/home_screen.dart';
import 'lands/lands_screen.dart';
import 'services/services_center_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    LandsScreen(),
    ServicesCenterScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _appState.currentTabIndex,
        children: _screens,
      ),
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
              blurRadius: 10,
            ),
          ],
        ),
        child: NavigationBar(
          height: 76,
          animationDuration: const Duration(milliseconds: 250),
          selectedIndex: _appState.currentTabIndex,
          onDestinationSelected: (index) => _appState.setTabIndex(index),
          backgroundColor: AppColors.surfacePure,
          indicatorColor: AppColors.limeLight,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.forestDark),
              label: 'الرئيسية',
            ),
            const NavigationDestination(
              icon: Icon(Icons.landscape_outlined),
              selectedIcon: Icon(Icons.landscape_rounded, color: AppColors.forestDark),
              label: 'الأراضي',
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.forestDark),
              label: 'الخدمات',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _appState.unreadNotificationsCount > 0,
                label: Text('${_appState.unreadNotificationsCount}'),
                backgroundColor: AppColors.limeDark,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              selectedIcon: Badge(
                isLabelVisible: _appState.unreadNotificationsCount > 0,
                label: Text('${_appState.unreadNotificationsCount}'),
                backgroundColor: AppColors.limeDark,
                child: const Icon(Icons.notifications_rounded, color: AppColors.forestDark),
              ),
              label: 'الإشعارات',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.forestDark),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
