import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/screen_01_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation lock only works on mobile, not web
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(const FalahApp());
}

class FalahApp extends StatelessWidget {
  const FalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فلاح - المنظومة الزراعية الذكية',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const Screen01Splash(),
    );
  }
}
