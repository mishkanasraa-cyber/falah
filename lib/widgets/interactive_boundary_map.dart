import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/app_models.dart';

class InteractiveBoundaryMap extends StatefulWidget {
  final List<GeoPoint> initialPoints;
  final bool isEditable;
  final Function(List<GeoPoint>, double areaHectares, double areaDunams)? onPointsChanged;
  final double height;
  final bool showSatelliteToggle;
  final bool showControls;
  final GeoPoint? centerLocation;
  final String? highlightedErrorNote;

  const InteractiveBoundaryMap({
    super.key,
    this.initialPoints = const [],
    this.isEditable = false,
    this.onPointsChanged,
    this.height = 280,
    this.showSatelliteToggle = true,
    this.showControls = true,
    this.centerLocation,
    this.highlightedErrorNote,
  });

  @override
  State<InteractiveBoundaryMap> createState() => _InteractiveBoundaryMapState();
}

class _InteractiveBoundaryMapState extends State<InteractiveBoundaryMap> {
  late List<GeoPoint> _points;
  bool _isSatellite = true;
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _points = List.from(widget.initialPoints);
  }

  @override
  void didUpdateWidget(covariant InteractiveBoundaryMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPoints != widget.initialPoints) {
      _points = List.from(widget.initialPoints);
    }
  }

  // Calculate estimated area using Shoelace formula on local coordinate space
  double _calculateEstimatedAreaHectares() {
    if (_points.length < 3) return 0.0;
    double area = 0.0;
    int j = _points.length - 1;

    for (int i = 0; i < _points.length; i++) {
      area += (_points[j].latitude + _points[i].latitude) *
          (_points[j].longitude - _points[i].longitude);
      j = i;
    }
    // Approximate scaling factor for Libya lat/lng to hectares
    double raw = (area.abs() / 2.0) * 111.0 * 111.0 * 0.85;
    return double.parse(raw.clamp(0.5, 999.0).toStringAsFixed(2));
  }

  void _notifyChange() {
    final hectares = _calculateEstimatedAreaHectares();
    final dunams = double.parse((hectares * 4.0).toStringAsFixed(1));
    widget.onPointsChanged?.call(_points, hectares, dunams);
  }

  void _addPoint(Offset localPosition, Size size) {
    if (!widget.isEditable) return;

    // Convert local screen coordinates relative to canvas center
    final normalizedX = (localPosition.dx - size.width / 2 - _panOffset.dx) / (40.0 * _zoom);
    final normalizedY = -(localPosition.dy - size.height / 2 - _panOffset.dy) / (40.0 * _zoom);

    final baseLat = widget.centerLocation?.latitude ?? 32.4350;
    final baseLng = widget.centerLocation?.longitude ?? 13.6330;

    final newPoint = GeoPoint(
      baseLat + (normalizedY * 0.002),
      baseLng + (normalizedX * 0.002),
      'نقطة ${_points.length + 1}',
    );

    setState(() {
      _points.add(newPoint);
    });
    _notifyChange();
  }

  void undoLastPoint() {
    if (_points.isNotEmpty) {
      setState(() {
        _points.removeLast();
      });
      _notifyChange();
    }
  }

  void clearAllPoints() {
    setState(() {
      _points.clear();
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final hectares = _calculateEstimatedAreaHectares();
    final dunams = (hectares * 4.0).toStringAsFixed(1);

    return Container(
      height: widget.height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _isSatellite ? const Color(0xFF1E2E24) : const Color(0xFFE8EDE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.highlightedErrorNote != null ? AppColors.statusAlert : AppColors.surfaceBorder,
          width: widget.highlightedErrorNote != null ? 2.0 : 1.2,
        ),
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
          // Map Canvas Gesture Detector
          LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);

              return GestureDetector(
                onTapDown: (details) => _addPoint(details.localPosition, size),
                onPanUpdate: (details) {
                  setState(() {
                    _panOffset += details.delta;
                  });
                },
                child: CustomPaint(
                  size: size,
                  painter: _CadastralCanvasPainter(
                    points: _points,
                    centerLocation: widget.centerLocation,
                    isSatellite: _isSatellite,
                    zoom: _zoom,
                    pan: _panOffset,
                    hasError: widget.highlightedErrorNote != null,
                  ),
                ),
              );
            },
          ),

          // Top Info Pill: Area & Status
          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.square_foot_rounded, size: 14, color: AppColors.limeBright),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _points.length >= 3
                                ? 'مساحة تقديرية: $dunams دونم ($hectares هكتار)'
                                : 'حدد 3 نقاط على الأقل لحساب مساحة المضلع',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.showSatelliteToggle) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _isSatellite = !_isSatellite),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _isSatellite ? Icons.layers_rounded : Icons.map_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // If there is a return error / notice note
          if (widget.highlightedErrorNote != null)
            Positioned(
              top: 50,
              right: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.statusAlertBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.statusAlert),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.statusAlert),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.highlightedErrorNote!,
                        style: const TextStyle(
                          color: AppColors.statusAlert,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Controls Bar (Zoom, Undo, Clear)
          if (widget.showControls)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.forestPrimary),
                      onPressed: () => setState(() => _zoom = (_zoom * 1.2).clamp(0.8, 3.0)),
                      tooltip: 'تكبير',
                      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18, color: AppColors.forestPrimary),
                      onPressed: () => setState(() => _zoom = (_zoom / 1.2).clamp(0.8, 3.0)),
                      tooltip: 'تصغير',
                      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                      padding: EdgeInsets.zero,
                    ),
                    if (widget.isEditable) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.undo_rounded, size: 18, color: AppColors.forestDarkest),
                        onPressed: undoLastPoint,
                        tooltip: 'تراجع عن آخر نقطة',
                        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: AppColors.statusAlert),
                        onPressed: clearAllPoints,
                        tooltip: 'مسح النقاط',
                        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Bottom Disclaimer (Survey grade disclaimer)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'تقدير استرشادي تقريبي • غير مساحي نهائي',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CadastralCanvasPainter extends CustomPainter {
  final List<GeoPoint> points;
  final GeoPoint? centerLocation;
  final bool isSatellite;
  final double zoom;
  final Offset pan;
  final bool hasError;

  _CadastralCanvasPainter({
    required this.points,
    this.centerLocation,
    required this.isSatellite,
    required this.zoom,
    required this.pan,
    this.hasError = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2 + pan.dx, size.height / 2 + pan.dy);
    canvas.scale(zoom);

    // 1. Draw Field Background Grid
    final bgPaint = Paint()
      ..color = isSatellite ? const Color(0xFF1B2E22) : const Color(0xFFEFF3EB)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: size.width * 4, height: size.height * 4), bgPaint);

    final gridPaint = Paint()
      ..color = isSatellite ? const Color(0x18FFFFFF) : const Color(0x3514532D)
      ..strokeWidth = 1.0;

    for (double i = -400; i <= 400; i += 40) {
      canvas.drawLine(Offset(i, -400), Offset(i, 400), gridPaint);
      canvas.drawLine(Offset(-400, i), Offset(400, i), gridPaint);
    }

    // 2. Draw Simulated Farm Road / Canal
    final roadPaint = Paint()
      ..color = const Color(0x50C2A676)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-300, 120), const Offset(300, 100), roadPaint);

    // 3. Draw Points & Boundary Polygon
    if (points.isNotEmpty) {
      final baseLat = centerLocation?.latitude ?? points.first.latitude;
      final baseLng = centerLocation?.longitude ?? points.first.longitude;

      final List<Offset> canvasOffsets = points.map((p) {
        final dx = (p.longitude - baseLng) / 0.002 * 40.0;
        final dy = -(p.latitude - baseLat) / 0.002 * 40.0;
        return Offset(dx, dy);
      }).toList();

      if (canvasOffsets.length >= 3) {
        final path = Path();
        path.moveTo(canvasOffsets[0].dx, canvasOffsets[0].dy);
        for (int i = 1; i < canvasOffsets.length; i++) {
          path.lineTo(canvasOffsets[i].dx, canvasOffsets[i].dy);
        }
        path.close();

        // Polygon Fill
        final fillPaint = Paint()
          ..color = (hasError ? AppColors.statusAlert : AppColors.limeBright).withValues(alpha: 0.28)
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, fillPaint);

        // Polygon Stroke
        final strokePaint = Paint()
          ..color = hasError ? AppColors.statusAlert : AppColors.limePrimary
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
        canvas.drawPath(path, strokePaint);
      } else if (canvasOffsets.length == 2) {
        final linePaint = Paint()
          ..color = AppColors.limePrimary
          ..strokeWidth = 2.0;
        canvas.drawLine(canvasOffsets[0], canvasOffsets[1], linePaint);
      }

      // Draw Pins / Node Markers
      for (int i = 0; i < canvasOffsets.length; i++) {
        final pt = canvasOffsets[i];
        final isErrorNode = hasError && i == 2;

        final pinBg = Paint()
          ..color = isErrorNode ? AppColors.statusAlert : AppColors.forestDarkest
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 7.0, pinBg);

        final pinInner = Paint()
          ..color = isErrorNode ? Colors.white : AppColors.limeBright
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pt, 4.0, pinInner);

        // Node Label
        final tp = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.rtl,
        );
        tp.layout();
        tp.paint(canvas, Offset(pt.dx + 8, pt.dy - 6));
      }
    } else {
      // Draw Central crosshair if no points
      final crossPaint = Paint()
        ..color = AppColors.limeBright
        ..strokeWidth = 2.0;
      canvas.drawLine(const Offset(-12, 0), const Offset(12, 0), crossPaint);
      canvas.drawLine(const Offset(0, -12), const Offset(0, 12), crossPaint);
      canvas.drawCircle(Offset.zero, 4.0, crossPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CadastralCanvasPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.isSatellite != isSatellite ||
        oldDelegate.zoom != zoom ||
        oldDelegate.pan != pan ||
        oldDelegate.hasError != hasError;
  }
}
