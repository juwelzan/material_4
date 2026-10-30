import 'package:flutter/material.dart';

/// Available physical material finishes for [Material4Card].
enum CardMaterialType {
  /// Soft pastel hue with subtle warm ambient diffusion and crisp outline (Reference Style).
  softPastel,

  /// Tactile paper surface with subtle fibrous matte warmth.
  paper,

  /// Stiff, uniform cardstock finish with soft muted reflectance.
  cardstock,

  /// Neumorphic soft clay finish with directional dual-angle shadows and highlights.
  clay,

  /// Ultra-smooth gloss ceramic surface with subtle specular shine.
  ceramic,

  /// Frosted glass appearance with delicate translucent tint and rim shine.
  glass,

  /// Clean modern satin plastic with smooth linear gradient.
  plastic,

  /// Polished metallic sheen with directional specular reflection.
  metallic,

  /// Non-reflective, modern editorial ultra-flat matte.
  matte,

  /// Physically elevated organic sculpted 3D relief surface.
  softSculpted,
}

/// Helper utility for painting physical material effects inside a card path boundary.
class CardMaterialRenderer {
  static void paintSurface({
    required Canvas canvas,
    required Path path,
    required Rect bounds,
    required Color baseColor,
    required CardMaterialType material,
  }) {
    switch (material) {
      case CardMaterialType.softPastel:
        // Reference Notice Board style: pure soft pastel with subtle ambient top-left warmth
        final gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.98),
            baseColor,
            Color.lerp(baseColor, Colors.black, 0.04) ?? baseColor,
          ],
        );
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..shader = gradient.createShader(bounds);
        canvas.drawPath(path, paint);
        break;

      case CardMaterialType.clay:
        // Soft clay base with directional top-left diffuse light
        final clayPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor;
        canvas.drawPath(path, clayPaint);

        canvas.save();
        canvas.clipPath(path);
        final highlightPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.22),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.08),
            ],
          ).createShader(bounds);
        canvas.drawRect(bounds, highlightPaint);
        canvas.restore();
        break;

      case CardMaterialType.ceramic:
        // Glossy ceramic with subtle curved specular sheen
        final basePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor;
        canvas.drawPath(path, basePaint);

        canvas.save();
        canvas.clipPath(path);
        final specular = Paint()
          ..style = PaintingStyle.fill
          ..shader = RadialGradient(
            center: const Alignment(-0.6, -0.7),
            radius: 0.9,
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ).createShader(bounds);
        canvas.drawRect(bounds, specular);
        canvas.restore();
        break;

      case CardMaterialType.glass:
        // Translucent frosted glass tint
        final glassPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor.withValues(alpha: 0.65);
        canvas.drawPath(path, glassPaint);

        canvas.save();
        canvas.clipPath(path);
        final rimPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.4),
              Colors.transparent,
              Colors.white.withValues(alpha: 0.15),
            ],
          ).createShader(bounds);
        canvas.drawRect(bounds, rimPaint);
        canvas.restore();
        break;

      case CardMaterialType.metallic:
        // Dynamic metallic reflection sweep
        final metalPaint = Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(baseColor, Colors.white, 0.25)!,
              baseColor,
              Color.lerp(baseColor, Colors.black, 0.15)!,
              Color.lerp(baseColor, Colors.white, 0.3)!,
              baseColor,
            ],
            stops: const [0.0, 0.35, 0.6, 0.75, 1.0],
          ).createShader(bounds);
        canvas.drawPath(path, metalPaint);
        break;

      case CardMaterialType.softSculpted:
        // 3D sculpted relief with embossed rim
        final basePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor;
        canvas.drawPath(path, basePaint);

        canvas.save();
        canvas.clipPath(path);
        final reliefPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.45),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.18),
            ],
          ).createShader(bounds);
        canvas.drawPath(path, reliefPaint);
        canvas.restore();
        break;

      case CardMaterialType.paper:
      case CardMaterialType.cardstock:
      case CardMaterialType.plastic:
      case CardMaterialType.matte:
        final paint = Paint()
          ..style = PaintingStyle.fill
          ..color = baseColor;
        canvas.drawPath(path, paint);
        break;
    }
  }
}
