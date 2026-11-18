import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/land_model.dart';

class CustomCadastralMapWidget extends StatefulWidget {
  final List<LandRecord> lands;
  final LandRecord? selectedLand;
  final Function(LandRecord)? onLandSelected;
  final double height;
  final bool showControls;

  const CustomCadastralMapWidget({
    super.key,
    required this.lands,
    this.selectedLand,
    this.onLandSelected,
    this.height = 240,
    this.showControls = true,
  });

  @override
  State<CustomCadastralMapWidget> createState() => _CustomCadastralMapWidgetState();
}

class _CustomCadastralMapWidgetState extends State<CustomCadastralMapWidget> {
  bool _isSatelliteMode = true;
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _isSatelliteMode ? const Color(0xFF1E2E24) : const Color(0xFFE8EDE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Map Canvas with Pan & Zoom
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _panOffset += details.delta;
              });
            },
            child: ClipRect(
              child: CustomPaint(
                size: Size.infinite,
                painter: _CadastralCanvasPainter(
                  lands: widget.lands,
                  selectedLand: widget.selectedLand,
                  isSatellite: _isSatelliteMode,
                  zoom: _zoomLevel,
                  pan: _panOffset,
                ),
              ),
            ),
          ),

          // Map Top Overlay: Coordinate & Zone Indicator
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.satellite_alt_rounded, size: 14, color: AppColors.limeBright),
                  const SizedBox(width: 6),
                  Text(
                    widget.selectedLand != null
                        ? '${widget.selectedLand!.municipality} • ${widget.selectedLand!.areaDunams} دونم'
                        : 'مخطط الحيازات الزراعية - سهول الجفارة وليبيا',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Controls (Satellite Toggle & Zoom)
          if (widget.showControls)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isSatelliteMode ? Icons.layers_rounded : Icons.map_rounded,
                        size: 18,
                        color: AppColors.forestPrimary,
                      ),
                      onPressed: () => setState(() => _isSatelliteMode = !_isSatelliteMode),
                      tooltip: 'تبديل نمط الخريطة (قمر صناعي / طبوغرافي)',
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.forestPrimary),
                      onPressed: () => setState(() => _zoomLevel = (_zoomLevel * 1.2).clamp(0.8, 2.5)),
                      tooltip: 'تكبير',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18, color: AppColors.forestPrimary),
                      onPressed: () => setState(() => _zoomLevel = (_zoomLevel / 1.2).clamp(0.8, 2.5)),
                      tooltip: 'تصغير',
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location_rounded, size: 18, color: AppColors.forestPrimary),
                      onPressed: () => setState(() {
                        _panOffset = Offset.zero;
                        _zoomLevel = 1.0;
                      }),
                      tooltip: 'إعادة ضبط المركز',
                    ),
                  ],
                ),
              ),
            ),

          // Status Legend
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendItem(AppColors.statusApproved, 'معتمد'),
                  const SizedBox(width: 8),
                  _buildLegendItem(AppColors.statusReview, 'قيد المراجعة'),
                  const SizedBox(width: 8),
                  _buildLegendItem(AppColors.statusDraft, 'مسودة'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
          ),
        ),
      ],
    );
  }
}

class _CadastralCanvasPainter extends CustomPainter {
  final List<LandRecord> lands;
  final LandRecord? selectedLand;
  final bool isSatellite;
  final double zoom;
  final Offset pan;

  _CadastralCanvasPainter({
    required this.lands,
    required this.selectedLand,
    required this.isSatellite,
    required this.zoom,
    required this.pan,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2 + pan.dx, size.height / 2 + pan.dy);
    canvas.scale(zoom);

    // 1. Draw Agricultural Ground Background & Field Textures
    final bgPaint = Paint()
      ..color = isSatellite ? const Color(0xFF1E2E24) : const Color(0xFFE8EDE4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: size.width * 3, height: size.height * 3), bgPaint);

    // 2. Draw Agricultural Grid & Contour Lines
    final gridPaint = Paint()
      ..color = isSatellite ? const Color(0x15FFFFFF) : const Color(0x30155E3D)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = -300; i <= 300; i += 40) {
      canvas.drawLine(Offset(i, -300), Offset(i, 300), gridPaint);
      canvas.drawLine(Offset(-300, i), Offset(300, i), gridPaint);
    }

    // 3. Draw Agricultural River / Irrigation canal (Wadi stream)
    final canalPaint = Paint()
      ..color = const Color(0x600284C7)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final canalPath = Path();
    canalPath.moveTo(-250, -120);
    canalPath.cubicTo(-100, -80, 50, -140, 250, -90);
    canvas.drawPath(canalPath, canalPaint);

    // 4. Draw Land Parcels Polygons
    final List<List<Offset>> parcelGeometries = [
      // Parcel 1 (Wadi Al-Majinin - Approved)
      [
        const Offset(-130, -50),
        const Offset(-40, -80),
        const Offset(-20, 20),
        const Offset(-110, 40),
      ],
      // Parcel 2 (Swani - Under Review)
      [
        const Offset(10, -60),
        const Offset(110, -40),
        const Offset(90, 45),
        const Offset(0, 30),
      ],
      // Parcel 3 (Zliten - Draft)
      [
        const Offset(-80, 70),
        const Offset(30, 60),
        const Offset(10, 130),
        const Offset(-90, 120),
      ],
    ];

    for (int i = 0; i < lands.length && i < parcelGeometries.length; i++) {
      final land = lands[i];
      final points = parcelGeometries[i];
      final isSelected = selectedLand?.id == land.id;

      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int p = 1; p < points.length; p++) {
        path.lineTo(points[p].dx, points[p].dy);
      }
      path.close();

      // Parcel Fill
      final fillPaint = Paint()
        ..color = land.status.color.withValues(alpha: isSelected ? 0.45 : 0.22)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Parcel Border
      final borderPaint = Paint()
        ..color = isSelected ? Colors.white : land.status.color
        ..strokeWidth = isSelected ? 3.0 : 1.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);

      // Boundary Pins / Corner markers
      for (final pt in points) {
        final pinPaint = Paint()
          ..color = isSelected ? AppColors.limeBright : land.status.color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, isSelected ? 4.5 : 3.0, pinPaint);
      }

      // Parcel Center Label
      final center = points.reduce((a, b) => a + b) / points.length.toDouble();
      final textSpan = TextSpan(
        text: '${land.parcelNumber.split('-').first.trim()}\n${land.areaDunams} دونم',
        style: TextStyle(
          color: isSatellite ? Colors.white : AppColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withValues(alpha: 0.4),
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CadastralCanvasPainter oldDelegate) {
    return oldDelegate.lands != lands ||
        oldDelegate.selectedLand != selectedLand ||
        oldDelegate.isSatellite != isSatellite ||
        oldDelegate.zoom != zoom ||
        oldDelegate.pan != pan;
  }
}
