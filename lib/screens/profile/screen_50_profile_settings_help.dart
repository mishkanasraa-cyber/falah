import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_state.dart';

class Screen50ProfileSettingsHelp extends StatelessWidget {
  const Screen50ProfileSettingsHelp({super.key});

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('دليل استخدام فلاح'),
          content: const SingleChildScrollView(
            child: Text(
              '1. إضافة أرض: أدخل بيانات الأرض والمالك واحفظ المسودة.\n\n'
              '2. أراضيّ: اعرض سجلات الأراضي وحالاتها.\n\n'
              '3. حالات السجل: مسودة، قيد المراجعة، '
              'يتطلب تعديلًا، أو معتمد.\n\n'
              '4. السجل المُرجع: اقرأ ملاحظات المراجع '
              'وعدّل البيانات المطلوبة.\n\n'
              '5. المساعد: يعرض حاليًا إرشادات تجريبية.\n\n'
              'البيانات والتعديلات الحالية محفوظة في ذاكرة التطبيق؛ '
              'الحفظ الدائم والربط بالخادم يحتاجان استكمالًا.',
              style: TextStyle(height: 1.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final user = appState.currentUser;

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('الحساب والمساعدة'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.limeLight,
                    child: Text(
                      user.avatarInitials,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestDarkest,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.role.nameAr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.forestPrimary),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone_outlined),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text(user.phone),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: const Text('الرقم الوطني'),
                        subtitle: Text(user.nationalId),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.location_city_outlined),
                        title: const Text('البلدية'),
                        subtitle: Text(user.city),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.landscape_outlined),
                        title: const Text('عدد سجلات الأراضي'),
                        trailing: Text('${appState.lands.length}'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('الإشعارات غير المقروءة'),
                        trailing: Text('${appState.unreadNotificationsCount}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: const Text('دليل الاستخدام'),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => _showHelp(context),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'فلاح — مشروع حصر وتوثيق الأراضي والمحاصيل الزراعية',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, height: 1.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
