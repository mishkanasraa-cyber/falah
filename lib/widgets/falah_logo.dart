import 'package:flutter/material.dart';

/// Reusable Falah logo widget using the official PNG asset.
/// Falls back to an icon if the asset fails to load (e.g. first web run).
class FalahLogo extends StatelessWidget {
  /// Overall size of the logo area.
  final double size;

  /// Whether to show a circular white background with shadow.
  final bool showCircleBackground;

  /// Circle background color.
  final Color circleColor;

  const FalahLogo({
    super.key,
    this.size = 90,
    this.showCircleBackground = true,
    this.circleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final logoImage = Image.asset(
      'assets/images/logo.png',
      width: size * (showCircleBackground ? 0.75 : 1.0),
      height: size * (showCircleBackground ? 0.75 : 1.0),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback: draw a simple plant icon if asset not found
        return Icon(
          Icons.eco_rounded,
          size: size * 0.55,
          color: const Color(0xFF2D6A4F),
        );
      },
    );

    if (!showCircleBackground) return logoImage;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Center(child: logoImage),
    );
  }
}
