import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../dynamic_shape_path_builder.dart';
import 'sculpted_card_config.dart';

/// CustomPainter rendering the tactile, physically sculpted icon plate.
class SculptedSurfacePainter extends CustomPainter {
  final SculptedPlateConfig config;
  final bool isPressed;
  final bool isHovered;
  final Color cardBackgroundColor;

  const SculptedSurfacePainter({
    required this.config,
    this.isPressed = false,
    this.isHovered = false,
    this.cardBackgroundColor = const Color(0xFFF7F5F2),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final path = _buildPlatePath(size);
    final effectiveStyle = isPressed
        ? (config.style == SculptedSurfaceStyle.embossed ||
                config.style == SculptedSurfaceStyle.neumorphic ||
                config.style == SculptedSurfaceStyle.softRaised ||
                config.style == SculptedSurfaceStyle.hardRaised
            ? SculptedSurfaceStyle.debossed
            : config.style)
        : config.style;

    final baseColor = config.surfaceColor ??
        (cardBackgroundColor.computeLuminance() > 0.5
            ? Color.alphaBlend(
                Colors.white.withValues(alpha: 0.25), cardBackgroundColor)
            : Color.alphaBlend(
                Colors.white.withValues(alpha: 0.12), cardBackgroundColor));

    final depth = isPressed
        ? config.depth * 0.4
        : (isHovered ? config.depth * 1.3 : config.depth);
    final lightAngle = config.lightAngle;
    final lightDx = math.cos(lightAngle);
    final lightDy = math.sin(lightAngle);

    // 1. External Shadows (for raised, embossed, neumorphic, floating, clay)
    _paintOuterShadows(
      canvas: canvas,
      path: path,
      size: size,
      style: effectiveStyle,
      depth: depth,
      lightDx: lightDx,
      lightDy: lightDy,
    );

    // 2. Base Plate Fill
    final fillPaint = Paint()..style = PaintingStyle.fill;
    if (effectiveStyle == SculptedSurfaceStyle.glass) {
      fillPaint.color =
          config.surfaceColor ?? Colors.white.withValues(alpha: 0.22);
    } else if (effectiveStyle == SculptedSurfaceStyle.metalPlate) {
      final metalShader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [
          Color(0xFFE0E0E0),
          Color(0xFFF5F5F5),
          Color(0xFFBDBDBD),
          Color(0xFFEEEEEE),
        ],
      ).createShader(Offset.zero & size);
      fillPaint.shader = metalShader;
    } else {
      fillPaint.color = baseColor;
    }
    canvas.drawPath(path, fillPaint);

    // 3. Tactile Relief & Inner Light Passes
    _paintSurfaceRelief(
      canvas: canvas,
      path: path,
      size: size,
      style: effectiveStyle,
      depth: depth,
      lightDx: lightDx,
      lightDy: lightDy,
    );

    // 4. Custom Border
    if (config.borderWidth > 0 && config.borderColor != null) {
      final borderPaint = Paint()
        ..color = config.borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.borderWidth;
      canvas.drawPath(path, borderPaint);
    }
  }

  Path _buildPlatePath(Size size) {
    switch (config.shape) {
      case SculptedPlateShape.circle:
        return Path()..addOval(Offset.zero & size);

      case SculptedPlateShape.roundedSquare:
        final r = Radius.circular(config.cornerRadius);
        return Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, r));

      case SculptedPlateShape.squircle:
        final cfg = DynamicShapeConfig(
          type: DynamicShapeType.squircle,
          cornerRadius: config.cornerRadius,
        );
        return DynamicShapePathBuilder.buildPath(size, cfg);

      case SculptedPlateShape.organic:
        final cfg = DynamicShapeConfig(
          type: DynamicShapeType.organicBlob,
          cornerRadius: config.cornerRadius,
        );
        return DynamicShapePathBuilder.buildPath(size, cfg);

      case SculptedPlateShape.matchCard:
      case SculptedPlateShape.custom:
        if (config.customShapeConfig != null) {
          return DynamicShapePathBuilder.buildPath(
              size, config.customShapeConfig!);
        }
        final r = Radius.circular(config.cornerRadius);
        return Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, r));
    }
  }

  void _paintOuterShadows({
    required Canvas canvas,
    required Path path,
    required Size size,
    required SculptedSurfaceStyle style,
    required double depth,
    required double lightDx,
    required double lightDy,
  }) {
    if (style == SculptedSurfaceStyle.debossed ||
        style == SculptedSurfaceStyle.recessed) {
      return; // Sunken styles do not cast outer drop shadows
    }

    final darkShadowOffset = Offset(-lightDx * depth, -lightDy * depth);
    final lightShadowOffset = Offset(lightDx * depth, lightDy * depth);

    switch (style) {
      case SculptedSurfaceStyle.neumorphic:
        // Top-left specular bloom
        final lightPaint = Paint()
          ..color = config.highlightColor.withValues(alpha: 0.8)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth * 1.5);
        canvas.save();
        canvas.translate(lightShadowOffset.dx, lightShadowOffset.dy);
        canvas.drawPath(path, lightPaint);
        canvas.restore();

        // Bottom-right soft shadow
        final darkPaint = Paint()
          ..color = config.shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth * 1.8);
        canvas.save();
        canvas.translate(darkShadowOffset.dx, darkShadowOffset.dy);
        canvas.drawPath(path, darkPaint);
        canvas.restore();
        break;

      case SculptedSurfaceStyle.hardRaised:
        // Hard-edge offset block (no blur)
        final hardPaint = Paint()
          ..color = config.shadowColor.withValues(alpha: 0.6)
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(darkShadowOffset.dx, darkShadowOffset.dy);
        canvas.drawPath(path, hardPaint);
        canvas.restore();
        break;

      case SculptedSurfaceStyle.floating:
        // High ambient blur
        final floatPaint = Paint()
          ..color = config.shadowColor.withValues(alpha: 0.35)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth * 2.8);
        canvas.save();
        canvas.translate(0, depth * 1.4);
        canvas.drawPath(path, floatPaint);
        canvas.restore();
        break;

      case SculptedSurfaceStyle.paperCutout:
        // Sharp cardstock cast shadow
        final paperPaint = Paint()
          ..color = config.shadowColor.withValues(alpha: 0.28)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0);
        canvas.save();
        canvas.translate(darkShadowOffset.dx * 0.7, darkShadowOffset.dy * 0.7);
        canvas.drawPath(path, paperPaint);
        canvas.restore();
        break;

      default:
        // Standard embossed / softRaised / clay / ceramic / metal
        final shadowPaint = Paint()
          ..color = config.shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth * 1.2);
        canvas.save();
        canvas.translate(darkShadowOffset.dx, darkShadowOffset.dy);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
        break;
    }
  }

  void _paintSurfaceRelief({
    required Canvas canvas,
    required Path path,
    required Size size,
    required SculptedSurfaceStyle style,
    required double depth,
    required double lightDx,
    required double lightDy,
  }) {
    canvas.save();
    canvas.clipPath(path);

    if (style == SculptedSurfaceStyle.debossed ||
        style == SculptedSurfaceStyle.recessed) {
      // Inward carved shadow on top-left
      final innerShadowOffset = Offset(lightDx * depth, lightDy * depth);
      final innerPaint = Paint()
        ..color = config.shadowColor.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = depth * 1.8
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth);
      canvas.save();
      canvas.translate(innerShadowOffset.dx, innerShadowOffset.dy);
      canvas.drawPath(path, innerPaint);
      canvas.restore();

      // Bottom-right rim specular highlight
      final rimOffset = Offset(-lightDx * depth * 0.5, -lightDy * depth * 0.5);
      final rimPaint = Paint()
        ..color = config.highlightColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.save();
      canvas.translate(rimOffset.dx, rimOffset.dy);
      canvas.drawPath(path, rimPaint);
      canvas.restore();
    } else if (style == SculptedSurfaceStyle.ceramic) {
      // Glossy reflection specular streak
      final glossPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.65),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.45],
        ).createShader(Offset.zero & size);
      canvas.drawPath(path, glossPaint);
    } else if (style == SculptedSurfaceStyle.clay) {
      // Volumetric soft inner rim
      final clayRim = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawPath(path, clayRim);
    } else {
      // Beveled top rim highlight
      final topLightPaint = Paint()
        ..color = config.highlightColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.save();
      canvas.translate(lightDx * 1.0, lightDy * 1.0);
      canvas.drawPath(path, topLightPaint);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SculptedSurfacePainter oldDelegate) {
    return oldDelegate.config != config ||
        oldDelegate.isPressed != isPressed ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.cardBackgroundColor != cardBackgroundColor;
  }
}
