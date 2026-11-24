import 'package:flutter/material.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/falah_ui.dart';
import 'screen_07_login.dart';
import 'screen_08_create_account.dart';

class Screen05Welcome extends StatelessWidget {
  const Screen05Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Top-left green blob ──
          const TopLeftBlob(),

          SafeArea(
            child: Column(
              children: [
                // ── Upper: logo + text + buttons ──
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLogo(size: 130),
                        const SizedBox(height: 18),

                        const Text(
                          'مرحباً بك في فلاح',
                          style: TextStyle(
                            color: FalahColors.darkGreen,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'منصتك الذكية لتسجيل الأراضي\nالزراعية وإدارة بيانات محاصيلك\nبكل سهولة.',
                          style: TextStyle(
                            color: Color(0xFF5A7A65),
                            fontSize: 14,
                            height: 1.65,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // Solid green button
                        PrimaryButton(
                          text: 'تسجيل الدخول',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Screen07Login()),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Outlined button
                        OutlineGreenButton(
                          text: 'إنشاء حساب جديد',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const Screen08CreateAccount()),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Bottom tagline with leaf icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.eco_rounded,
                                color: FalahColors.midGreen, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'معاً نحو زراعة رقمية مستدامة',
                              style: TextStyle(
                                color: FalahColors.midGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Bottom illustration ──
                const SizedBox(height: 120, child: Stack(children: [FarmScene()])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
