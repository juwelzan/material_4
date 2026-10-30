import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'paper_background_config.dart';

/// Renderer for Notebook and Stationery patterns.
class StationeryPatternRenderer {
  const StationeryPatternRenderer._();

  /// Renders stationery pattern onto [canvas] clipped to [clipPath].
  static void renderStationeryPattern({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required CreativePatternConfig config,
  }) {
    if (config.stationeryType == null || config.opacity <= 0) return;
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();
    canvas.clipPath(clipPath);

    if (config.rotation != 0.0 ||
        config.offset != Offset.zero ||
        config.scale != 1.0) {
      canvas.translate(size.width / 2 + config.offset.dx,
          size.height / 2 + config.offset.dy);
      canvas.rotate(config.rotation);
      canvas.scale(config.scale, config.scale);
      canvas.translate(-size.width / 2, -size.height / 2);
    }

    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    switch (config.stationeryType!) {
      case StationeryPatternType.horizontalRuled:
        _drawHorizontalRuled(canvas, size, config, paint);
        break;

      case StationeryPatternType.verticalRuled:
        _drawVerticalRuled(canvas, size, config, paint);
        break;

      case StationeryPatternType.gridLines:
        _drawGridLines(canvas, size, config, paint);
        break;

      case StationeryPatternType.dotGrid:
        _drawDotGrid(canvas, size, config);
        break;

      case StationeryPatternType.engineeringGraph:
        _drawEngineeringGraph(canvas, size, config, paint);
        break;

      case StationeryPatternType.isometricGrid:
        _drawIsometricGrid(canvas, size, config, paint);
        break;

      case StationeryPatternType.musicManuscript:
        _drawMusicManuscript(canvas, size, config, paint);
        break;

      case StationeryPatternType.handwritingGuide:
        _drawHandwritingGuide(canvas, size, config, paint);
        break;

      case StationeryPatternType.marginLine:
        _drawMarginLine(canvas, size, config, paint);
        break;

      case StationeryPatternType.notebookSpiralHoles:
        _drawNotebookSpiralHoles(canvas, size, config);
        break;

      case StationeryPatternType.notebookBindingEdge:
        _drawNotebookBindingEdge(canvas, size, config);
        break;

      case StationeryPatternType.tornNotebookEdge:
        _drawTornNotebookEdge(canvas, size, config);
        break;

      case StationeryPatternType.decorativeStationery:
        _drawDecorativeStationery(canvas, size, config);
        break;
    }

    canvas.restore();
  }

  static void _drawHorizontalRuled(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(8.0, 80.0);
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  static void _drawVerticalRuled(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(8.0, 80.0);
    for (double x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  static void _drawGridLines(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(6.0, 60.0);
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  static void _drawDotGrid(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
  ) {
    final dotPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;
    final spacing = config.spacing.clamp(8.0, 48.0);
    final radius = (config.strokeWidth * 0.8).clamp(0.5, 4.0);

    for (double y = spacing; y < size.height; y += spacing) {
      for (double x = spacing; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  static void _drawEngineeringGraph(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint minorPaint,
  ) {
    final majorPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 1.5.clamp(0.0, 1.0),
      )
      ..strokeWidth = config.strokeWidth * 1.5;

    final minorStep = config.spacing.clamp(4.0, 20.0);
    int count = 0;

    for (double y = minorStep; y < size.height; y += minorStep) {
      count++;
      final isMajor = count % 5 == 0;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isMajor ? majorPaint : minorPaint,
      );
    }

    count = 0;
    for (double x = minorStep; x < size.width; x += minorStep) {
      count++;
      final isMajor = count % 5 == 0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  static void _drawIsometricGrid(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(12.0, 60.0);
    final tan60 = math.sqrt(3.0);
    final h = size.height;
    final w = size.width;

    // Horizontal lines
    for (double y = 0; y <= h; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(w, y), paint);
    }

    // 60-degree lines
    final span = w + h * tan60;
    for (double d = -h * tan60; d <= span; d += spacing * 1.5) {
      canvas.drawLine(Offset(d, 0), Offset(d + h / tan60, h), paint);
      canvas.drawLine(Offset(d, h), Offset(d + h / tan60, 0), paint);
    }
  }

  static void _drawMusicManuscript(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    const staffLines = 5;
    const lineGap = 4.0;
    final staffHeight = (staffLines - 1) * lineGap;
    final staveSpacing = config.spacing.clamp(staffHeight + 16.0, 80.0);

    for (double top = 20.0;
        top + staffHeight < size.height;
        top += staveSpacing) {
      for (int i = 0; i < staffLines; i++) {
        final y = top + i * lineGap;
        canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), paint);
      }
    }
  }

  static void _drawHandwritingGuide(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint basePaint,
  ) {
    final midPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 0.6,
      )
      ..strokeWidth = config.strokeWidth * 0.8;

    final unitHeight = config.spacing.clamp(16.0, 64.0);
    final subHeight = unitHeight / 3.0;

    for (double y = unitHeight;
        y < size.height - unitHeight * 0.5;
        y += unitHeight) {
      // Top ascender line
      canvas.drawLine(Offset(0, y), Offset(size.width, y), basePaint);
      // Dashed midline
      for (double x = 0; x < size.width; x += 8.0) {
        canvas.drawLine(
            Offset(x, y + subHeight), Offset(x + 4.0, y + subHeight), midPaint);
      }
      // Baseline
      canvas.drawLine(
        Offset(0, y + subHeight * 2.0),
        Offset(size.width, y + subHeight * 2.0),
        basePaint,
      );
    }
  }

  static void _drawMarginLine(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint rulePaint,
  ) {
    // 1. Horizontal ruling
    _drawHorizontalRuled(canvas, size, config, rulePaint);

    // 2. Vertical margin line (classic pink/red)
    final marginPaint = Paint()
      ..color = (config.secondaryColor ?? const Color(0xFFE91E63)).withValues(
        alpha: config.opacity,
      )
      ..strokeWidth = math.max(1.0, config.strokeWidth * 1.5);

    final marginX = math.min(48.0, size.width * 0.18);
    canvas.drawLine(
        Offset(marginX, 0), Offset(marginX, size.height), marginPaint);
  }

  static void _drawNotebookSpiralHoles(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
  ) {
    final holePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;
    final ringPaint = Paint()
      ..color = (config.secondaryColor ?? const Color(0xFF9E9E9E)).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final spacing = config.spacing.clamp(14.0, 36.0);
    final radius = 3.5;
    final x = 16.0;

    for (double y = spacing; y < size.height - spacing * 0.5; y += spacing) {
      canvas.drawCircle(Offset(x, y), radius, holePaint);
      // Silver spiral coil loop
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x - 2, y), radius: radius + 2),
        -math.pi / 2,
        math.pi,
        false,
        ringPaint,
      );
    }
  }

  static void _drawNotebookBindingEdge(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
  ) {
    // Spine tape band
    final spineWidth = math.min(32.0, size.width * 0.15);
    final tapePaint = Paint()
      ..color = config.color.withValues(alpha: 0.18 * config.opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, spineWidth, size.height), tapePaint);

    // Stitched thread line
    final stitchPaint = Paint()
      ..color = (config.secondaryColor ?? Colors.black).withValues(
        alpha: config.opacity * 0.6,
      )
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final stitchX = spineWidth * 0.5;
    for (double y = 8.0; y < size.height; y += 12.0) {
      canvas.drawLine(
          Offset(stitchX, y), Offset(stitchX, y + 6.0), stitchPaint);
    }
  }

  static void _drawTornNotebookEdge(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;

    // Perforated hole cutouts along left edge with open ragged cuts
    final spacing = config.spacing.clamp(14.0, 32.0);
    final radius = 4.0;

    for (double y = spacing; y < size.height - spacing * 0.5; y += spacing) {
      final path = Path()
        ..moveTo(0, y - radius)
        ..lineTo(10, y - radius)
        ..arcToPoint(Offset(10, y + radius), radius: Radius.circular(radius))
        ..lineTo(0, y + radius)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  static void _drawDecorativeStationery(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: 0.3 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const cornerSize = 24.0;
    // Four corner filigree accents
    for (final corner in [
      const Offset(12, 12),
      Offset(size.width - 12, 12),
      Offset(12, size.height - 12),
      Offset(size.width - 12, size.height - 12),
    ]) {
      canvas.drawCircle(corner, cornerSize * 0.5, paint);
      canvas.drawCircle(corner, cornerSize * 0.25, paint);
    }
  }
}
