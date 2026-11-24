import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ألوان التصميم المرجعي
class FalahColors {
  static const cream       = Color(0xFFF7F5EE);
  static const darkGreen   = Color(0xFF0E4D2F);
  static const midGreen    = Color(0xFF2E7D52); // للروابط والأيقونات الثانوية
  static const splashGreen = Color(0xFF0B4A2C);
  static const blobLight   = Color(0xFFDCE9D3);
  static const blobLighter = Color(0xFFEAF2E3);
  static const hillGreen   = Color(0xFF8DBB7A);
  static const hillLight   = Color(0xFFC9DFB9);
  static const fieldBorder = Color(0xFFD3D6CC);
  static const hint        = Color(0xFF6B7A70);
  static const errorSoft   = Color(0xFFB3261E);
  static const errorBorder = Color(0xFFE5A4A0);
}

/// اللوقو: موجود في app_logo.dart (لا تعيدي تعريفه هنا)

/// الشكل الأخضر في أعلى اليسار (طبقتان)
class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p1 = Path()
      ..moveTo(0, 0)
      ..lineTo(s.width * 0.62, 0)
      ..cubicTo(s.width * 0.50, s.height * 0.30, s.width * 0.28,
          s.height * 0.62, 0, s.height * 0.78)
      ..close();
    canvas.drawPath(
        p1, Paint()..color = FalahColors.blobLight.withValues(alpha: 0.75));
    final p2 = Path()
      ..moveTo(0, 0)
      ..lineTo(s.width * 0.42, 0)
      ..cubicTo(s.width * 0.34, s.height * 0.22, s.width * 0.16,
          s.height * 0.45, 0, s.height * 0.55)
      ..close();
    canvas.drawPath(p2, Paint()..color = FalahColors.blobLighter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class TopLeftBlob extends StatelessWidget {
  const TopLeftBlob({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0,
      left: 0,
      child: IgnorePointer(
        child: CustomPaint(
            size: Size(w * 0.62, w * 0.5), painter: _BlobPainter()),
      ),
    );
  }
}

/// تلال المزرعة (Welcome) أو نخيل + بيت محمي (Login)
class FarmScene extends StatelessWidget {
  final bool withPalms;
  const FarmScene({super.key, this.withPalms = false});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: CustomPaint(
          size: Size(w, withPalms ? 150 : 120),
          painter: _FarmPainter(withPalms),
        ),
      ),
    );
  }
}

class _FarmPainter extends CustomPainter {
  final bool palms;
  _FarmPainter(this.palms);

  void _palm(Canvas c, Offset base, double h) {
    final trunk = Paint()
      ..color = const Color(0xFF7A5A3A)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final top = base.translate(0, -h);
    c.drawLine(base, top, trunk);
    final leaf = Paint()
      ..color = const Color(0xFF5E9B55)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 7; i++) {
      final a = -math.pi + (math.pi * i / 6);
      final end = top +
          Offset(math.cos(a) * h * 0.45, math.sin(a) * h * 0.25 + h * 0.12);
      c.drawLine(top, end, leaf);
    }
  }

  @override
  void paint(Canvas c, Size s) {
    // تلال خلفية
    final back = Path()
      ..moveTo(0, s.height * 0.55)
      ..quadraticBezierTo(
          s.width * 0.3, s.height * 0.25, s.width * 0.6, s.height * 0.5)
      ..quadraticBezierTo(
          s.width * 0.85, s.height * 0.65, s.width, s.height * 0.4)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(back, Paint()..color = FalahColors.hillLight);

    // تلال أمامية بخطوط حقول
    final front = Path()
      ..moveTo(0, s.height * 0.75)
      ..quadraticBezierTo(
          s.width * 0.4, s.height * 0.5, s.width, s.height * 0.72)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(
        front, Paint()..color = FalahColors.hillGreen.withValues(alpha: 0.75));
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    for (var i = 1; i <= 3; i++) {
      final y = s.height * (0.74 + i * 0.07);
      c.drawLine(Offset(0, y), Offset(s.width, y - 8), line);
    }

    if (palms) {
      _palm(c, Offset(s.width * 0.12, s.height * 0.9), 62);
      _palm(c, Offset(s.width * 0.24, s.height * 0.92), 46);
      // بيت محمي
      final gh = Rect.fromLTWH(s.width * 0.66, s.height * 0.5,
          s.width * 0.28, s.height * 0.42);
      c.drawArc(gh, math.pi, math.pi, true,
          Paint()..color = Colors.white.withValues(alpha: 0.55));
      c.drawArc(
          gh,
          math.pi,
          math.pi,
          false,
          Paint()
            ..color = FalahColors.hillGreen
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
      for (var i = 1; i < 5; i++) {
        final x = gh.left + gh.width * i / 5;
        c.drawLine(
            Offset(x, gh.top + gh.height * 0.5),
            Offset(x, gh.bottom),
            Paint()
              ..color = FalahColors.hillGreen
              ..strokeWidth = 1);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// حقل نص: خلفية بيضاء + إطار رفيع + أيقونة
class FalahField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? hint;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const FalahField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.hint,
    this.maxLength,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: 1),
        );
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        counterText: '',
        hintText: hint ?? label,
        hintStyle: const TextStyle(color: FalahColors.hint, fontSize: 14),
        prefixIcon: Icon(icon, color: FalahColors.hint, size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        errorStyle: const TextStyle(
            fontSize: 12, height: 1.2, color: FalahColors.errorSoft),
        errorMaxLines: 1,
        border: b(FalahColors.fieldBorder),
        enabledBorder: b(FalahColors.fieldBorder),
        focusedBorder: b(FalahColors.darkGreen),
        errorBorder: b(const Color(0xFFE5A4A0)),
        focusedErrorBorder: b(FalahColors.errorSoft),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  const PrimaryButton(
      {super.key, required this.text, required this.onPressed, this.isLoading = false});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: FalahColors.darkGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Text(text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      );
}

class OutlineGreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const OutlineGreenButton(
      {super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: FalahColors.darkGreen,
            backgroundColor: Colors.white.withValues(alpha: 0.4),
            side: const BorderSide(color: Color(0xFF5E9B55), width: 1.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(text,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      );
}

/// تحقق رقم الهاتف الليبي: 10 أرقام تبدأ بـ 091/092/093/094
String? validateLibyanPhone(String? v) {
  final s = (v ?? '').trim();
  return RegExp(r'^09[1-4]\d{7}$').hasMatch(s)
      ? null
      : 'أدخل رقماً صحيحاً مثل 0912345678';
}

String? validatePassword(String? v) =>
    (v ?? '').length >= 8 ? null : 'كلمة المرور 8 خانات على الأقل';
