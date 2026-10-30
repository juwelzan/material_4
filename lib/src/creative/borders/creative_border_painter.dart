import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../material_4_config.dart';
import 'creative_border_config.dart';
import 'torn_paper_border.dart';

/// Central painting coordinator for the 38 Advanced Creative Border styles.
class CreativeBorderPainter {
  const CreativeBorderPainter._();

  /// Paint the creative border along [path] or boundary [size] according to [config].
  static void paintCreativeBorder({
    required Canvas canvas,
    required Size size,
    required Path path,
    required CreativeBorderConfig config,
  }) {
    if (config.width <= 0 || config.color.a <= 0 || config.opacity <= 0) return;
    if (size.width <= 0 || size.height <= 0) return;

    // Optional outer shadow
    if (config.shadow != null) {
      final s = config.shadow!;
      final shadowPaint = Paint()
        ..color = s.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s.blurRadius);
      canvas.save();
      canvas.translate(s.offset.dx, s.offset.dy);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();
    }

    // Apply stroke alignment clipping if needed
    if (config.strokeAlign == ShapeStrokeAlign.inside) {
      canvas.save();
      canvas.clipPath(path);
      _dispatchBorderPaint(canvas, size, path, config);
      canvas.restore();
      return;
    } else if (config.strokeAlign == ShapeStrokeAlign.outside) {
      canvas.save();
      final outerRect = (Offset.zero & size).inflate(config.width * 2.0);
      final inversePath = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(outerRect)
        ..addPath(path, Offset.zero);
      canvas.clipPath(inversePath);
      _dispatchBorderPaint(canvas, size, path, config);
      canvas.restore();
      return;
    }

    _dispatchBorderPaint(canvas, size, path, config);
  }

  static void _dispatchBorderPaint(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    switch (config.style) {
      // 1. Paper and Physical Material Borders
      case CreativeBorderStyle.tornPaper:
        TornPaperBorder.paintTornPaper(
          canvas: canvas,
          size: size,
          config: config,
        );
        break;

      case CreativeBorderStyle.roughPaper:
        _drawRoughPaper(canvas, size, path, config);
        break;

      case CreativeBorderStyle.perforated:
        _drawPerforated(canvas, size, path, config);
        break;

      case CreativeBorderStyle.zigzagCut:
        _drawZigzagCut(canvas, size, path, config);
        break;

      case CreativeBorderStyle.scissorCut:
        _drawScissorCut(canvas, size, path, config);
        break;

      case CreativeBorderStyle.deckledEdge:
        _drawDeckledEdge(canvas, size, path, config);
        break;

      case CreativeBorderStyle.burntEdge:
        _drawBurntEdge(canvas, size, path, config);
        break;

      case CreativeBorderStyle.foldedPaper:
        _drawFoldedPaper(canvas, size, path, config);
        break;

      case CreativeBorderStyle.crumpledEdge:
        _drawCrumpledEdge(canvas, size, path, config);
        break;

      case CreativeBorderStyle.notebookEdge:
        _drawNotebookEdge(canvas, size, path, config);
        break;

      case CreativeBorderStyle.stampEdge:
        _drawStampEdge(canvas, size, path, config);
        break;

      case CreativeBorderStyle.couponEdge:
        _drawCouponEdge(canvas, size, path, config);
        break;

      // 2. Decorative and Geometric Borders
      case CreativeBorderStyle.doubleLine:
        _drawDoubleLine(canvas, size, path, config);
        break;

      case CreativeBorderStyle.tripleLine:
        _drawTripleLine(canvas, size, path, config);
        break;

      case CreativeBorderStyle.gradient:
        _drawGradient(canvas, size, path, config);
        break;

      case CreativeBorderStyle.rainbow:
        _drawRainbow(canvas, size, path, config);
        break;

      case CreativeBorderStyle.glow:
        _drawGlow(canvas, size, path, config);
        break;

      case CreativeBorderStyle.neon:
        _drawNeon(canvas, size, path, config);
        break;

      case CreativeBorderStyle.dashedRounded:
        _drawDashedRounded(canvas, size, path, config);
        break;

      case CreativeBorderStyle.dottedRounded:
        _drawDottedRounded(canvas, size, path, config);
        break;

      case CreativeBorderStyle.stitch:
        _drawStitch(canvas, size, path, config);
        break;

      case CreativeBorderStyle.rope:
        _drawRope(canvas, size, path, config);
        break;

      case CreativeBorderStyle.chain:
        _drawChain(canvas, size, path, config);
        break;

      case CreativeBorderStyle.beaded:
        _drawBeaded(canvas, size, path, config);
        break;

      case CreativeBorderStyle.wave:
        _drawWave(canvas, size, path, config);
        break;

      case CreativeBorderStyle.scalloped:
        _drawScalloped(canvas, size, path, config);
        break;

      case CreativeBorderStyle.wavyHandDrawn:
        _drawWavyHandDrawn(canvas, size, path, config);
        break;

      case CreativeBorderStyle.organicBlob:
        _drawOrganicBlob(canvas, size, path, config);
        break;

      case CreativeBorderStyle.geometricPolygon:
        _drawGeometricPolygon(canvas, size, path, config);
        break;

      case CreativeBorderStyle.artDeco:
        _drawArtDeco(canvas, size, path, config);
        break;

      case CreativeBorderStyle.vintageDecorative:
        _drawVintageDecorative(canvas, size, path, config);
        break;

      case CreativeBorderStyle.floralDecorative:
        _drawFloralDecorative(canvas, size, path, config);
        break;

      case CreativeBorderStyle.cornerOnly:
        _drawCornerOnly(canvas, size, path, config);
        break;

      case CreativeBorderStyle.bracket:
        _drawBracket(canvas, size, path, config);
        break;

      case CreativeBorderStyle.inset:
        _drawInset(canvas, size, path, config);
        break;

      case CreativeBorderStyle.outset:
        _drawOutset(canvas, size, path, config);
        break;

      case CreativeBorderStyle.layered:
        _drawLayered(canvas, size, path, config);
        break;

      case CreativeBorderStyle.animated:
        _drawAnimated(canvas, size, path, config);
        break;
    }
  }

  // =========================================================================
  // Paper & Physical Material Border Implementations
  // =========================================================================

  static void _drawRoughPaper(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Subtle harmonic wobble around path metrics
    final roughPath = Path();
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final step = math.max(4.0, 16.0 / (config.frequency * 0.1));
      for (double d = 0; d < metric.length; d += step) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final wobble =
            math.sin((d + config.seed) * 0.3) * (config.width * 0.25);
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) * wobble;
        final pt = tangent.position + normal;
        if (d == 0) {
          roughPath.moveTo(pt.dx, pt.dy);
        } else {
          roughPath.lineTo(pt.dx, pt.dy);
        }
      }
      roughPath.close();
    }
    canvas.drawPath(roughPath, paint);
  }

  static void _drawPerforated(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.square;

    final dashLen = config.patternSize.clamp(3.0, 16.0);
    final gapLen = config.spacing.clamp(3.0, 16.0);

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLen, metric.length);
        final subPath = metric.extractPath(distance, end);
        canvas.drawPath(subPath, paint);
        distance += dashLen + gapLen;
      }
    }
  }

  static void _drawZigzagCut(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeJoin = StrokeJoin.miter;

    final toothSpan = config.spacing.clamp(4.0, 24.0);
    final toothDepth = config.patternSize.clamp(3.0, 20.0);
    final zigzag = Path();

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      bool toggle = false;
      for (double d = 0; d < metric.length; d += toothSpan) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) *
            (toggle ? toothDepth : -toothDepth);
        final pt = tangent.position + normal;
        if (d == 0) {
          zigzag.moveTo(pt.dx, pt.dy);
        } else {
          zigzag.lineTo(pt.dx, pt.dy);
        }
        toggle = !toggle;
      }
    }
    canvas.drawPath(zigzag, paint);
  }

  static void _drawScissorCut(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.butt;

    final facetLen = config.spacing.clamp(8.0, 32.0);
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += facetLen) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final seed = (d * 10).toInt() + config.seed;
        final jitterAngle = (seed % 7 - 3) * 0.05;
        final sub = metric.extractPath(
          d,
          math.min(d + facetLen * 0.85, metric.length),
        );
        canvas.save();
        canvas.translate(tangent.position.dx, tangent.position.dy);
        canvas.rotate(jitterAngle);
        canvas.translate(-tangent.position.dx, -tangent.position.dy);
        canvas.drawPath(sub, paint);
        canvas.restore();
      }
    }
  }

  static void _drawDeckledEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final basePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final featherPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 0.4,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawPath(path, basePaint);

    // Microscopic fibrous deckle fringe
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 3.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final fringeLen =
            1.0 + (math.sin(d * 1.5 + config.seed).abs() * config.width * 1.2);
        final normal =
            Offset(-tangent.vector.dy, tangent.vector.dx) * fringeLen;
        canvas.drawLine(
            tangent.position, tangent.position + normal, featherPaint);
      }
    }
  }

  static void _drawBurntEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // 1. Outer charred scorch gradient halo
    final charColor = config.charColor ?? const Color(0xFF1A110B);
    final glowColor = config.secondaryColor ?? const Color(0xFFE65100);

    final scorchPaint = Paint()
      ..color = charColor.withValues(alpha: 0.6 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(path, scorchPaint);

    // 2. Ember glow hairline
    final emberPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.8 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, config.width * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(path, emberPaint);

    // 3. Crisp black carbonized rim
    final carbonPaint = Paint()
      ..color = Colors.black.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, carbonPaint);
  }

  static void _drawFoldedPaper(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final borderPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, borderPaint);

    // Fold crease diagonals at corners
    final creasePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final foldSize = config.patternSize.clamp(12.0, 36.0);
    // Top-left corner fold line
    canvas.drawLine(Offset(0, foldSize), Offset(foldSize, 0), shadowPaint);
    canvas.drawLine(
        Offset(1, foldSize - 1), Offset(foldSize - 1, 1), creasePaint);
  }

  static void _drawCrumpledEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.square;

    final crumpled = Path();
    for (final metric in path.computeMetrics()) {
      final step = math.max(8.0, config.spacing);
      for (double d = 0; d < metric.length; d += step) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final angle = (math.sin(d * 0.7 + config.seed) * 0.25);
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) *
            (angle * config.width);
        final pt = tangent.position + normal;
        if (d == 0) {
          crumpled.moveTo(pt.dx, pt.dy);
        } else {
          crumpled.lineTo(pt.dx, pt.dy);
        }
      }
      crumpled.close();
    }
    canvas.drawPath(crumpled, paint);
  }

  static void _drawNotebookEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // Solid base boundary line
    final borderPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, borderPaint);

    // Punch holes along left edge
    final holePaint = Paint()
      ..color = config.secondaryColor ?? Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final holeRadius = config.patternSize * 0.4;
    final spacing = config.spacing.clamp(16.0, 48.0);
    for (double y = spacing; y < size.height - spacing * 0.5; y += spacing) {
      canvas.drawCircle(Offset(holeRadius * 2.0, y), holeRadius, holePaint);
    }
  }

  static void _drawStampEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final borderPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, borderPaint);

    final holePaint = Paint()
      ..color = config.secondaryColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final radius = config.patternSize * 0.4;
    final spacing = config.spacing.clamp(8.0, 32.0);

    for (final metric in path.computeMetrics()) {
      for (double d = spacing * 0.5; d < metric.length; d += spacing) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        canvas.drawCircle(tangent.position, radius, holePaint);
      }
    }
  }

  static void _drawCouponEdge(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // Perforated tear line
    _drawPerforated(canvas, size, path, config);

    // Scissor indicator marks along boundary
    final scissorPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final metric in path.computeMetrics()) {
      if (metric.length > 60.0) {
        final tangent = metric.getTangentForOffset(30.0);
        if (tangent != null) {
          final pt = tangent.position;
          canvas.drawCircle(pt + const Offset(-4, -3), 2.5, scissorPaint);
          canvas.drawCircle(pt + const Offset(-4, 3), 2.5, scissorPaint);
          canvas.drawLine(
              pt + const Offset(-2, -2), pt + const Offset(5, 3), scissorPaint);
          canvas.drawLine(
              pt + const Offset(-2, 2), pt + const Offset(5, -3), scissorPaint);
        }
      }
    }
  }

  // =========================================================================
  // Decorative and Geometric Border Implementations
  // =========================================================================

  static void _drawDoubleLine(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final outerPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, outerPaint);

    final gap = config.spacing.clamp(2.0, 10.0);
    final innerPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.75, config.width * 0.6);

    for (final metric in path.computeMetrics()) {
      final innerPath = Path();
      for (double d = 0; d < metric.length; d += 4.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final normal = Offset(tangent.vector.dy, -tangent.vector.dx) * gap;
        final pt = tangent.position + normal;
        if (d == 0) {
          innerPath.moveTo(pt.dx, pt.dy);
        } else {
          innerPath.lineTo(pt.dx, pt.dy);
        }
      }
      innerPath.close();
      canvas.drawPath(innerPath, innerPaint);
    }
  }

  static void _drawTripleLine(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final centerPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 1.2;
    canvas.drawPath(path, centerPaint);

    final gap = config.spacing.clamp(2.0, 8.0);
    final guardPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 0.75,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, config.width * 0.4);

    for (final metric in path.computeMetrics()) {
      final inPath = Path();
      final outPath = Path();
      for (double d = 0; d < metric.length; d += 4.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final normIn = Offset(tangent.vector.dy, -tangent.vector.dx) * gap;
        final normOut = Offset(-tangent.vector.dy, tangent.vector.dx) * gap;
        if (d == 0) {
          inPath.moveTo(
              tangent.position.dx + normIn.dx, tangent.position.dy + normIn.dy);
          outPath.moveTo(tangent.position.dx + normOut.dx,
              tangent.position.dy + normOut.dy);
        } else {
          inPath.lineTo(
              tangent.position.dx + normIn.dx, tangent.position.dy + normIn.dy);
          outPath.lineTo(tangent.position.dx + normOut.dx,
              tangent.position.dy + normOut.dy);
        }
      }
      inPath.close();
      outPath.close();
      canvas.drawPath(inPath, guardPaint);
      canvas.drawPath(outPath, guardPaint);
    }
  }

  static void _drawGradient(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final gradient = config.gradient ??
        LinearGradient(
          colors: [config.color, config.secondaryColor ?? Colors.teal],
        );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..shader = gradient.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  static void _drawRainbow(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    const rainbowColors = [
      Color(0xFFFF0055),
      Color(0xFFFF9900),
      Color(0xFFFFEE00),
      Color(0xFF00FF66),
      Color(0xFF00CCFF),
      Color(0xFF9900FF),
      Color(0xFFFF0055),
    ];
    final sweep = SweepGradient(
      colors: rainbowColors,
      transform: GradientRotation(config.animationProgress * math.pi * 2),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..shader = sweep.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  static void _drawGlow(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final glowPaint = Paint()
      ..color = config.color.withValues(alpha: 0.5 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    canvas.drawPath(path, glowPaint);

    final corePaint = Paint()
      ..color = (config.secondaryColor ?? Colors.white).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, corePaint);
  }

  static void _drawNeon(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // 3-stage gas bloom emission
    final bloom1 = Paint()
      ..color = config.color.withValues(alpha: 0.25 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
    canvas.drawPath(path, bloom1);

    final bloom2 = Paint()
      ..color = config.color.withValues(alpha: 0.6 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(path, bloom2);

    final core = Paint()
      ..color = Colors.white.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, config.width * 0.6);
    canvas.drawPath(path, core);
  }

  static void _drawDashedRounded(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final dashLen = config.patternSize.clamp(4.0, 24.0);
    final gapLen = config.spacing.clamp(4.0, 24.0);

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLen, metric.length);
        final subPath = metric.extractPath(distance, end);
        canvas.drawPath(subPath, paint);
        distance += dashLen + gapLen;
      }
    }
  }

  static void _drawDottedRounded(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;

    final radius = config.width * 0.5;
    final spacing = config.spacing.clamp(6.0, 32.0);

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += spacing) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        canvas.drawCircle(tangent.position, radius, paint);
      }
    }
  }

  static void _drawStitch(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final stitchPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final holePaint = Paint()
      ..color = (config.secondaryColor ?? Colors.black).withValues(
        alpha: 0.35 * config.opacity,
      )
      ..style = PaintingStyle.fill;

    final stitchLen = config.patternSize.clamp(4.0, 16.0);
    final spacing = config.spacing.clamp(6.0, 24.0);

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += spacing) {
        final end = math.min(d + stitchLen, metric.length);
        final subPath = metric.extractPath(d, end);
        canvas.drawPath(subPath, stitchPaint);

        // Needle puncture hole at start and end
        final startTan = metric.getTangentForOffset(d);
        if (startTan != null) {
          canvas.drawCircle(startTan.position, config.width * 0.45, holePaint);
        }
      }
    }
  }

  static void _drawRope(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final strand1 = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final strand2 = Paint()
      ..color = (config.secondaryColor ?? const Color(0xFFC4A47C)).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 0.7
      ..strokeCap = StrokeCap.round;

    final step = config.spacing.clamp(4.0, 16.0);
    for (final metric in path.computeMetrics()) {
      bool toggle = false;
      for (double d = 0; d < metric.length; d += step) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) *
            (config.width * 0.5);
        final p1 = tangent.position - normal;
        final p2 = tangent.position + normal;
        canvas.drawLine(p1, p2, toggle ? strand1 : strand2);
        toggle = !toggle;
      }
    }
  }

  static void _drawChain(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final linkPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, config.width * 0.5);

    final linkLen = config.patternSize.clamp(8.0, 24.0);
    final linkWidth = linkLen * 0.5;

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += linkLen * 0.8) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final angle = math.atan2(tangent.vector.dy, tangent.vector.dx);
        canvas.save();
        canvas.translate(tangent.position.dx, tangent.position.dy);
        canvas.rotate(angle);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: linkLen,
              height: linkWidth,
            ),
            Radius.circular(linkWidth * 0.5),
          ),
          linkPaint,
        );
        canvas.restore();
      }
    }
  }

  static void _drawBeaded(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final beadPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65 * config.opacity)
      ..style = PaintingStyle.fill;

    final radius = config.patternSize * 0.45;
    final spacing = config.spacing.clamp(radius * 2.0, 32.0);

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += spacing) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        canvas.drawCircle(tangent.position, radius, beadPaint);
        // Specular highlight spot
        canvas.drawCircle(
          tangent.position + Offset(-radius * 0.35, -radius * 0.35),
          radius * 0.3,
          highlightPaint,
        );
      }
    }
  }

  static void _drawWave(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final wavePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final wavePath = Path();
    final amp = config.patternSize * 0.5;
    final freq = config.frequency.clamp(4.0, 32.0);

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 2.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final waveVal = math.sin((d / freq) * math.pi * 2) * amp;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) * waveVal;
        final pt = tangent.position + normal;
        if (d == 0) {
          wavePath.moveTo(pt.dx, pt.dy);
        } else {
          wavePath.lineTo(pt.dx, pt.dy);
        }
      }
    }
    canvas.drawPath(wavePath, wavePaint);
  }

  static void _drawScalloped(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final scallopPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;

    final scallopSpan = config.patternSize.clamp(8.0, 32.0);
    final scallopRadius = scallopSpan * 0.5;

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += scallopSpan) {
        final tangent = metric.getTangentForOffset(d + scallopRadius);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) *
            (scallopRadius * 0.5);
        canvas.drawCircle(
            tangent.position + normal, scallopRadius, scallopPaint);
      }
    }
  }

  static void _drawWavyHandDrawn(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.round;

    final handDrawn = Path();
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 3.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final jitter = (math.sin(d * 0.4 + config.seed) +
                math.cos(d * 1.2 + config.seed * 2)) *
            (config.width * 0.3);
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) * jitter;
        final pt = tangent.position + normal;
        if (d == 0) {
          handDrawn.moveTo(pt.dx, pt.dy);
        } else {
          handDrawn.lineTo(pt.dx, pt.dy);
        }
      }
    }
    canvas.drawPath(handDrawn, paint);
  }

  static void _drawOrganicBlob(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 6.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final dynamicWidth =
            config.width * (0.6 + math.sin(d * 0.15 + config.seed).abs() * 1.2);
        final paint = Paint()
          ..color = config.color.withValues(alpha: config.opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = dynamicWidth
          ..strokeCap = StrokeCap.round;
        final end = math.min(d + 6.0, metric.length);
        final sub = metric.extractPath(d, end);
        canvas.drawPath(sub, paint);
      }
    }
  }

  static void _drawGeometricPolygon(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeJoin = StrokeJoin.bevel;

    final polyPath = Path();
    final segLen = config.spacing.clamp(12.0, 48.0);
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += segLen) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        if (d == 0) {
          polyPath.moveTo(tangent.position.dx, tangent.position.dy);
        } else {
          polyPath.lineTo(tangent.position.dx, tangent.position.dy);
        }
      }
      polyPath.close();
    }
    canvas.drawPath(polyPath, paint);
  }

  static void _drawArtDeco(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // 1920s architectural stepped corner chevrons
    final goldPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, goldPaint);

    final stepPaint = Paint()
      ..color = (config.secondaryColor ?? const Color(0xFFD4AF37)).withValues(
        alpha: config.opacity,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const cornerSize = 20.0;
    // Step accents at corners
    canvas.drawRect(
        const Rect.fromLTWH(4, 4, cornerSize, cornerSize), stepPaint);
    canvas.drawRect(
      Rect.fromLTWH(size.width - cornerSize - 4, 4, cornerSize, cornerSize),
      stepPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(4, size.height - cornerSize - 4, cornerSize, cornerSize),
      stepPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - cornerSize - 4,
        size.height - cornerSize - 4,
        cornerSize,
        cornerSize,
      ),
      stepPaint,
    );
  }

  static void _drawVintageDecorative(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final framePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, framePaint);

    // Baroque filigree corner flourishes
    final filigreePaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 0.8,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final corner in [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ]) {
      canvas.drawCircle(corner, 8.0, filigreePaint);
    }
  }

  static void _drawFloralDecorative(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final vinePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, vinePaint);

    final leafPaint = Paint()
      ..color = (config.secondaryColor ?? Colors.green).withValues(
        alpha: config.opacity * 0.75,
      )
      ..style = PaintingStyle.fill;

    for (final metric in path.computeMetrics()) {
      for (double d = 16.0; d < metric.length; d += 32.0) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx) * 4.0;
        canvas.drawOval(
          Rect.fromCenter(
            center: tangent.position + normal,
            width: 8.0,
            height: 4.0,
          ),
          leafPaint,
        );
      }
    }
  }

  static void _drawCornerOnly(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final paint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..strokeCap = StrokeCap.square;

    final armLen = config.patternSize.clamp(12.0, 36.0);

    // Top-Left bracket
    canvas.drawLine(Offset.zero, Offset(armLen, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, armLen), paint);

    // Top-Right bracket
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - armLen, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, armLen), paint);

    // Bottom-Left bracket
    canvas.drawLine(Offset(0, size.height), Offset(armLen, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - armLen), paint);

    // Bottom-Right bracket
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - armLen, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - armLen),
      paint,
    );
  }

  static void _drawBracket(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    _drawCornerOnly(canvas, size, path, config);

    // Crosshairs at corners
    final crossPaint = Paint()
      ..color = (config.secondaryColor ?? config.color).withValues(
        alpha: config.opacity * 0.6,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const crossSize = 6.0;
    canvas.drawLine(
        const Offset(-crossSize, 0), const Offset(crossSize, 0), crossPaint);
    canvas.drawLine(
        const Offset(0, -crossSize), const Offset(0, crossSize), crossPaint);
  }

  static void _drawInset(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    // Chiseled inner bevel with top shadow and bottom highlight
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.save();
    canvas.translate(0, 1.0);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    final lightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.save();
    canvas.translate(0, -1.0);
    canvas.drawPath(path, lightPaint);
    canvas.restore();
  }

  static void _drawOutset(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final lightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.save();
    canvas.translate(0, -1.0);
    canvas.drawPath(path, lightPaint);
    canvas.restore();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25 * config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.save();
    canvas.translate(0, 1.0);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();
  }

  static void _drawLayered(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final p1 = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width;
    canvas.drawPath(path, p1);

    final p2 = Paint()
      ..color = (config.secondaryColor ?? Colors.blueGrey).withValues(
        alpha: config.opacity * 0.7,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width * 0.5;
    canvas.save();
    canvas.translate(2.0, 2.0);
    canvas.drawPath(path, p2);
    canvas.restore();
  }

  static void _drawAnimated(
    Canvas canvas,
    Size size,
    Path path,
    CreativeBorderConfig config,
  ) {
    final sweep = SweepGradient(
      colors: [
        config.color.withValues(alpha: 0.2),
        config.color,
        config.secondaryColor ?? Colors.cyan,
        config.color.withValues(alpha: 0.2),
      ],
      transform: GradientRotation(config.animationProgress * math.pi * 2),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.width
      ..shader = sweep.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }
}
