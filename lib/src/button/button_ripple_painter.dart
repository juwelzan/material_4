import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'button_animation.dart';

/// GPU canvas painter rendering shape-clipped transient tap and click feedback.
class Material4ButtonRipplePainter extends CustomPainter {
  final double progress;
  final Offset touchPoint;
  final Path clipPath;
  final ButtonTapAnimation tapAnimation;
  final Color rippleColor;

  const Material4ButtonRipplePainter({
    required this.progress,
    required this.touchPoint,
    required this.clipPath,
    required this.tapAnimation,
    required this.rippleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0 || tapAnimation == ButtonTapAnimation.none) {
      return;
    }

    canvas.save();
    canvas.clipPath(clipPath);

    final bounds = clipPath.getBounds();
    final maxRadius = math.sqrt(
          math.pow(math.max(touchPoint.dx - bounds.left, bounds.right - touchPoint.dx), 2) +
          math.pow(math.max(touchPoint.dy - bounds.top, bounds.bottom - touchPoint.dy), 2),
        ) *
        1.2;

    switch (tapAnimation) {
      case ButtonTapAnimation.none:
        break;

      case ButtonTapAnimation.ripple:
      case ButtonTapAnimation.expandingCircle:
        final currentRadius = maxRadius * progress;
        final alpha = ((1.0 - progress) * rippleColor.a).clamp(0.0, 1.0);
        final paint = Paint()
          ..color = rippleColor.withValues(alpha: alpha)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        canvas.drawCircle(touchPoint, currentRadius, paint);
        break;

      case ButtonTapAnimation.liquidRipple:
      case ButtonTapAnimation.waveRipple:
        // Multi-ring concentric expanding wave ripples
        final alpha = ((1.0 - progress) * rippleColor.a).clamp(0.0, 1.0);
        final baseRadius = maxRadius * progress;

        for (int i = 0; i < 3; i++) {
          final ringRadius = baseRadius - (i * 24.0 * (1.0 - progress));
          if (ringRadius > 0) {
            final ringAlpha = (alpha * (1.0 - i * 0.25)).clamp(0.0, 1.0);
            final wavePaint = Paint()
              ..color = rippleColor.withValues(alpha: ringAlpha)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0 * (1.0 - progress)
              ..isAntiAlias = true;
            canvas.drawCircle(touchPoint, ringRadius, wavePaint);
          }
        }
        break;

      case ButtonTapAnimation.particleBurst:
        // Circular ring of particle sparks bursting outwards
        final alpha = ((1.0 - progress) * rippleColor.a).clamp(0.0, 1.0);
        final sparkPaint = Paint()
          ..color = rippleColor.withValues(alpha: alpha)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

        const particleCount = 12;
        final burstRadius = maxRadius * 0.7 * progress;
        final particleSize = 3.5 * (1.0 - progress);

        for (int i = 0; i < particleCount; i++) {
          final angle = (i / particleCount) * 2 * math.pi;
          final px = touchPoint.dx + burstRadius * math.cos(angle);
          final py = touchPoint.dy + burstRadius * math.sin(angle);
          canvas.drawCircle(Offset(px, py), particleSize, sparkPaint);
        }
        break;

      case ButtonTapAnimation.glowPulse:
        // Full surface luminous glow wash
        final alpha = (math.sin(progress * math.pi) * rippleColor.a * 0.6).clamp(0.0, 1.0);
        final glowPaint = Paint()
          ..color = rippleColor.withValues(alpha: alpha)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        canvas.drawPath(clipPath, glowPaint);
        break;

      case ButtonTapAnimation.shapeTransformation:
        // Highlight overlay
        final alpha = ((1.0 - progress) * rippleColor.a * 0.4).clamp(0.0, 1.0);
        final fillPaint = Paint()
          ..color = rippleColor.withValues(alpha: alpha)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        canvas.drawPath(clipPath, fillPaint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant Material4ButtonRipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.touchPoint != touchPoint ||
        oldDelegate.clipPath != clipPath ||
        oldDelegate.tapAnimation != tapAnimation ||
        oldDelegate.rippleColor != rippleColor;
  }
}

