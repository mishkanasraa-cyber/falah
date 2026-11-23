import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/falah_logo.dart';
import 'screen_05_welcome.dart';

class Screen01Splash extends StatefulWidget {
  const Screen01Splash({super.key});

  @override
  State<Screen01Splash> createState() => _Screen01SplashState();
}

class _Screen01SplashState extends State<Screen01Splash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );
    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, secAnim) => const Screen05Welcome(),
          transitionsBuilder: (ctx, anim, secAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2E1C),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A2E1C),
              Color(0xFF14532D),
              Color(0xFF1A6B38),
              Color(0xFF0F3D22),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Decorative top-left circle
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            // Decorative bottom-right circle
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
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
                  // Logo with scale + fade animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const FalahLogo(
                        size: 120,
                        showCircleBackground: true,
                        circleColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Brand name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'فلاح',
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontFamilyFallback:
                            AppTypography.arabicFontFamilyFallback,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Opacity(
                      opacity: _slideAnimation.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset:
                            Offset(0, 20 * (1 - _slideAnimation.value)),
                        child: child,
                      ),
                    ),
                    child: Text(
                      'نحو مستقبل زراعي أكثر ذكاءً',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 15,
                        letterSpacing: 0.3,
                        fontFamilyFallback:
                            AppTypography.arabicFontFamilyFallback,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom pill indicator
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
