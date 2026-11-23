import 'package:flutter/material.dart';

import '../screens/lands/18_my_lands_screen.dart';
import '../screens/ai_assistant/ai_assistant_screen.dart';
import '../screens/supplies/screen_46_agricultural_supplies_catalog.dart';

class ScreenDirectorySheet extends StatelessWidget {
  const ScreenDirectorySheet({super.key});

  void _openPage(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);

    // إغلاق الدليل ثم فتح الصفحة المختارة.
    navigator.pop();
    navigator.push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'دليل الصفحات',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.landscape_outlined),
              title: const Text('أراضيّ المسجلة'),
              subtitle: const Text('عرض سجلات الأراضي وحالات المراجعة'),
              onTap: () => _openPage(context, const Screen18MyLands()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('مساعد فلاح'),
              subtitle: const Text('إرشادات تسجيل الأراضي واستخدام التطبيق'),
              onTap: () => _openPage(context, const AIAssistantScreen()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.grass_outlined),
              title: const Text('دليل المستلزمات الزراعية'),
              subtitle: const Text('تصفح المستلزمات والمفضلة'),
              onTap: () => _openPage(
                context,
                const Screen46AgriculturalSuppliesCatalog(),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }
}
