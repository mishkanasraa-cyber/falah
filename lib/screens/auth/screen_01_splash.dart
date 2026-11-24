import 'package:flutter/material.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/falah_ui.dart';
import 'screen_05_welcome.dart';

class Screen01Splash extends StatefulWidget {
  const Screen01Splash({super.key});

  @override
  State<Screen01Splash> createState() => _Screen01SplashState();
}

class _Screen01SplashState extends State<Screen01Splash>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _scale = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.0, 0.6, curve: Curves.easeIn));
    _slide = CurvedAnimation(
        parent: _ctrl, curve: const Interval(0.4, 1.0, curve: Curves.easeOut));

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const Screen05Welcome(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FalahColors.splashGreen,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle circle decorations
          Positioned(
            top: -70,
            left: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            right: -90,
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                ScaleTransition(
                  scale: _scale,
                  child: FadeTransition(
                    opacity: _fade,
                    child: const AppLogo(size: 150),
                  ),
                ),
                const SizedBox(height: 24),

                // App name
                FadeTransition(
                  opacity: _fade,
                  child: const Text(
                    'فلاح',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                AnimatedBuilder(
                  animation: _slide,
                  builder: (_, child) => Opacity(
                    opacity: _slide.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 18 * (1 - _slide.value)),
                      child: child,
                    ),
                  ),
                  child: Text(
                    'نحو مستقبل زراعي أكثر ذكاءً',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Bottom pill
          Positioned(
            bottom: 44,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
