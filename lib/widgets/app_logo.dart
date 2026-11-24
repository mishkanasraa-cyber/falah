import 'package:flutter/material.dart';

/// Reusable app logo widget – loads [assets/images/logo.png].
/// Falls back to a green eco icon if the asset is not found.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.eco_rounded,
        size: size * 0.65,
        color: const Color(0xFF2D6A4F),
      ),
    );
  }
}
