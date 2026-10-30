import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'progress_style.dart';
import 'progress_shape.dart';
import 'progress_track.dart';
import 'progress_fill.dart';
import 'progress_effects.dart';
import 'progress_interaction.dart';
import 'wave_line/wave_line.dart';

/// Master canvas painter rendering all 48+ Material 4 progress bar styles.
class Material4ProgressPainter extends CustomPainter {
  /// Normalized progress value (0.0 to 1.0) or null if running in indeterminate mode.
  final double? value;

  /// Secondary buffer value (0.0 to 1.0) for double-layer and streaming bars.
  final double? secondaryValue;

  /// Active progress style.
  final Material4ProgressStyle style;

  /// Advanced animated wave line configuration when style is a wave line.
  final Material4WaveLineConfig? waveLine;

  /// Vector shape geometry definition.
  final Material4ProgressShape shape;

  /// Background track configuration.
  final Material4ProgressTrack track;

  /// Active progressing fill configuration.
  final Material4ProgressFill fill;

  /// Visual effects configuration.
  final Material4ProgressEffects effects;

  /// Optional interaction configuration (for thumb and tooltips).
  final Material4ProgressInteraction? interaction;

  /// Continuous phase animation value for waves, stripes, and liquid (0.0 to 1.0).
  final double animationProgress;

  /// Continuous indeterminate sweep progress (0.0 to 1.0).
  final double indeterminateProgress;

  /// Theme fallback colors.
  final Color primaryColor;
  final Color trackFallbackColor;

  Material4ProgressPainter({
    required this.value,
    this.secondaryValue,
    required this.style,
    this.waveLine,
    required this.shape,
    required this.track,
    required this.fill,
    required this.effects,
    this.interaction,
    required this.animationProgress,
    required this.indeterminateProgress,
    required this.primaryColor,
    required this.trackFallbackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Apply breathing effect if enabled
    if (effects.breathing) {
      final breathingScale = 1.0 +
          (effects.breathingScale - 1.0) *
              math.sin(animationProgress * 2 * math.pi).abs();
      canvas.save();
      final center = Offset(size.width / 2, size.height / 2);
      canvas.translate(center.dx, center.dy);
      canvas.scale(breathingScale, breathingScale);
      canvas.translate(-center.dx, -center.dy);
    }

    // 1. Paint shadows if present
    _paintTrackShadows(canvas, size);

    // 2. Dispatch to specific style renderer
    if (style.isWaveLine) {
      WaveLinePainter.paintWaveLine(
        canvas: canvas,
        size: size,
        value: value,
        style: style,
        config: waveLine ?? const Material4WaveLineConfig(),
        track: track,
        fill: fill,
        effects: effects,
        animationProgress: animationProgress,
        indeterminateProgress: indeterminateProgress,
        primaryColor: primaryColor,
        trackFallbackColor: trackFallbackColor,
      );
    } else if (style.isCircular) {
      _paintCircularProgress(canvas, size);
    } else if (style == Material4ProgressStyle.step ||
        style == Material4ProgressStyle.timeline) {
      _paintStepProgress(canvas, size);
    } else if (style == Material4ProgressStyle.equalizer) {
      _paintEqualizerProgress(canvas, size);
    } else if (style == Material4ProgressStyle.dotMatrix) {
      _paintDotMatrixProgress(canvas, size);
    } else {
      _paintLinearProgress(canvas, size);
    }

    // 3. Paint interactive draggable thumb knob if enabled
    _paintInteractionThumb(canvas, size);

    if (effects.breathing) {
      canvas.restore();
    }
  }

  // =========================================================================
  // Track Shadows & Ambient Depth
  // =========================================================================

  void _paintTrackShadows(Canvas canvas, Size size) {
    final effectiveShadows = track.shadows ?? effects.shadows;
    if (effectiveShadows == null || effectiveShadows.isEmpty) return;

    final trackPath = (track.shape ?? shape).buildPath(size);
    for (final shadow in effectiveShadows) {
      final paint = shadow.toPaint();
      canvas.save();
      canvas.translate(shadow.offset.dx, shadow.offset.dy);
      canvas.drawPath(trackPath, paint);
      canvas.restore();
    }
  }

  // =========================================================================
  // Linear Progress Rendering Engine
  // =========================================================================

  void _paintLinearProgress(Canvas canvas, Size size) {
    final trackPath = (track.shape ?? shape).buildPath(size);

    // 1. Paint track background
    final trackPaint = Paint()..isAntiAlias = true;
    final baseTrackColor = track.color ??
        (style == Material4ProgressStyle.neonLinear
            ? const Color(0xFF0F172A)
            : trackFallbackColor);

    if (track.gradient != null) {
      trackPaint.shader = track.gradient!.createShader(Offset.zero & size);
    } else {
      trackPaint.color = baseTrackColor.withValues(alpha: track.opacity);
    }
    canvas.drawPath(trackPath, trackPaint);

    // 2. Paint track outline border if specified
    if (track.borderWidth > 0 && track.borderColor != null) {
      final borderPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = track.borderWidth
        ..color = track.borderColor!;
      canvas.drawPath(trackPath, borderPaint);
    }

    // Clip to track boundary to prevent fill bleeding
    canvas.save();
    canvas.clipPath(trackPath);

    // Inset fill if track padding specified
    final contentRect = track.padding.deflateRect(Offset.zero & size);

    // 3. Paint secondary buffer progression if present (double-layer style)
    if (secondaryValue != null && secondaryValue! > 0) {
      _paintSecondaryBuffer(canvas, contentRect);
    }

    // 4. Paint primary active fill
    if (value == null) {
      _paintLinearIndeterminate(canvas, contentRect);
    } else {
      _paintLinearDeterminate(canvas, contentRect);
    }

    // 5. Paint specular shimmer sheen if active
    if (effects.shimmer) {
      _paintShimmerSheen(canvas, contentRect);
    }

    canvas.restore();

    // 6. Paint ambient glow plume outside clip boundary
    if (effects.glow || effects.neon) {
      _paintLinearGlow(canvas, contentRect);
    }
  }

  void _paintSecondaryBuffer(Canvas canvas, Rect rect) {
    final bufferRatio = (secondaryValue ?? 0.0).clamp(0.0, 1.0);
    final bufferWidth = rect.width * bufferRatio;
    final bufferRect = Rect.fromLTWH(rect.left, rect.top, bufferWidth, rect.height);

    final bufferPaint = Paint()
      ..isAntiAlias = true
      ..color = fill.secondaryColor ?? primaryColor.withValues(alpha: 0.3);
    canvas.drawRect(bufferRect, bufferPaint);
  }

  void _paintLinearDeterminate(Canvas canvas, Rect rect) {
    final effectiveProgress = (value ?? 0.0).clamp(0.0, 1.0);
    if (effectiveProgress <= 0.0) return;

    final resolvedColor = fill.resolveColor(effectiveProgress, primaryColor);

    if (style == Material4ProgressStyle.segmentedLinear) {
      _paintSegmentedLinear(canvas, rect, effectiveProgress, resolvedColor);
      return;
    }

    final fillWidth = rect.width * effectiveProgress;
    final fillRect = Rect.fromLTWH(rect.left, rect.top, fillWidth, rect.height);

    // Wave & Liquid Styles
    if (style.isWaveOrLiquid) {
      _paintLinearWaveOrLiquid(canvas, rect, effectiveProgress, resolvedColor);
      return;
    }

    // Fill paint
    final fillPaint = Paint()..isAntiAlias = true;
    if (fill.gradient != null) {
      fillPaint.shader = fill.gradient!.createShader(fillRect);
    } else if (style == Material4ProgressStyle.neonLinear) {
      fillPaint.shader = LinearGradient(
        colors: [resolvedColor, Colors.white, resolvedColor],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(fillRect);
    } else {
      fillPaint.color = resolvedColor;
    }

    // Draw active fill rect/path
    canvas.drawRect(fillRect, fillPaint);

    // Striped Barber-Pole Texture
    if (fill.striped ||
        style == Material4ProgressStyle.stripedLinear ||
        style == Material4ProgressStyle.animatedStripedLinear) {
      _paintDiagonalStripes(canvas, fillRect);
    }

    // Sculpted surface highlights
    if (style == Material4ProgressStyle.sculptedLinear) {
      _paintSculptedLinearHighlight(canvas, fillRect);
    }
  }

  void _paintLinearWaveOrLiquid(
    Canvas canvas,
    Rect rect,
    double progress,
    Color color,
  ) {
    final wavePath = Path();
    final fillWidth = rect.width * progress;
    final amp = fill.waveAmplitude;
    final freq = fill.waveFrequency;
    final phase = animationProgress * 2 * math.pi;

    wavePath.moveTo(rect.left, rect.bottom);
    wavePath.lineTo(rect.left, rect.top);

    const steps = 30;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final y = rect.top + t * rect.height;
      // Sinusoidal crest along leading edge
      final waveOffset = amp * math.sin(t * freq * 2 * math.pi + phase);
      final x = rect.left + fillWidth + waveOffset;
      if (i == 0) {
        wavePath.lineTo(x, y);
      } else {
        wavePath.lineTo(x, y);
      }
    }

    wavePath.lineTo(rect.left, rect.bottom);
    wavePath.close();

    final wavePaint = Paint()
      ..isAntiAlias = true
      ..color = color;
    if (fill.gradient != null) {
      wavePaint.shader = fill.gradient!.createShader(
        Rect.fromLTWH(rect.left, rect.top, fillWidth, rect.height),
      );
    }
    canvas.drawPath(wavePath, wavePaint);

    // Liquid Effervescent Micro-Bubbles
    if (fill.liquidBubbles) {
      _paintLiquidBubbles(canvas, rect, fillWidth, color);
    }
  }

  void _paintLiquidBubbles(Canvas canvas, Rect rect, double fillWidth, Color color) {
    final bubblePaint = Paint()
      ..isAntiAlias = true
      ..color = Colors.white.withValues(alpha: 0.6);

    final count = fill.bubbleCount;
    for (var i = 0; i < count; i++) {
      final seed = (i * 0.17 + 0.1) % 1.0;
      final bx = rect.left + fillWidth * (0.2 + seed * 0.7);
      final bubbleProgress = (animationProgress + seed) % 1.0;
      final by = rect.bottom - bubbleProgress * rect.height;
      final radius = 1.2 + seed * 1.8;
      canvas.drawCircle(Offset(bx, by), radius, bubblePaint);
    }
  }

  void _paintSegmentedLinear(
    Canvas canvas,
    Rect rect,
    double progress,
    Color color,
  ) {
    final segments = fill.segments;
    final gap = fill.segmentGap;
    final totalGaps = (segments - 1) * gap;
    final segmentWidth = (rect.width - totalGaps) / segments;

    final filledUnits = progress * segments;

    for (var i = 0; i < segments; i++) {
      final segLeft = rect.left + i * (segmentWidth + gap);
      final segRect = Rect.fromLTWH(segLeft, rect.top, segmentWidth, rect.height);
      final segRRect = RRect.fromRectAndRadius(segRect, const Radius.circular(3));

      final segPaint = Paint()..isAntiAlias = true;
      if (i < filledUnits.floor()) {
        segPaint.color = color;
      } else if (i < filledUnits) {
        final frac = filledUnits - i;
        segPaint.color = color.withValues(alpha: frac);
      } else {
        segPaint.color = color.withValues(alpha: 0.15);
      }
      canvas.drawRRect(segRRect, segPaint);
    }
  }

  void _paintDiagonalStripes(Canvas canvas, Rect rect) {
    canvas.save();
    canvas.clipRect(rect);

    final stripePaint = Paint()
      ..isAntiAlias = true
      ..color = fill.stripeColor
      ..style = PaintingStyle.fill;

    final width = fill.stripeWidth;
    final gap = fill.stripeGap;
    final period = width + gap;

    final offset = (style == Material4ProgressStyle.animatedStripedLinear)
        ? (animationProgress * period)
        : 0.0;

    final diagonalLength = rect.width + rect.height * 2;
    var x = -rect.height + offset;

    while (x < diagonalLength) {
      final path = Path()
        ..moveTo(x, rect.bottom)
        ..lineTo(x + width, rect.bottom)
        ..lineTo(x + width + rect.height, rect.top)
        ..lineTo(x + rect.height, rect.top)
        ..close();
      canvas.drawPath(path, stripePaint);
      x += period;
    }

    canvas.restore();
  }

  void _paintSculptedLinearHighlight(Canvas canvas, Rect rect) {
    final highlightPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawLine(rect.topLeft, rect.topRight, highlightPaint);

    final shadowPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.black.withValues(alpha: 0.2);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, shadowPaint);
  }

  void _paintShimmerSheen(Canvas canvas, Rect rect) {
    final shimmerWidth = rect.width * 0.35;
    final sweepProgress = (animationProgress * 1.5) - 0.25;
    final shimmerX = rect.left + sweepProgress * rect.width;

    final shimmerRect = Rect.fromLTWH(shimmerX, rect.top, shimmerWidth, rect.height);
    final shimmerPaint = Paint()
      ..isAntiAlias = true
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          effects.shimmerColor,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(shimmerRect);

    canvas.drawRect(shimmerRect, shimmerPaint);
  }

  void _paintLinearIndeterminate(Canvas canvas, Rect rect) {
    final p = indeterminateProgress;
    // Smooth sinusoidal expanding and translating pill
    final head = math.min(1.0, p * 1.6);
    final tail = math.max(0.0, p * 1.6 - 0.6);

    final left = rect.left + tail * rect.width;
    final right = rect.left + head * rect.width;
    final fillRect = Rect.fromLTRB(left, rect.top, right, rect.bottom);

    final paint = Paint()
      ..isAntiAlias = true
      ..color = primaryColor;

    if (fill.gradient != null) {
      paint.shader = fill.gradient!.createShader(fillRect);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(fillRect, const Radius.circular(4)), paint);
  }

  void _paintLinearGlow(Canvas canvas, Rect rect) {
    final glowRadius = effects.glowRadius;
    final glowColor = effects.glowColor ?? primaryColor;
    final progressRatio = (value ?? indeterminateProgress).clamp(0.0, 1.0);
    if (progressRatio <= 0.0) return;

    final fillWidth = rect.width * progressRatio;
    final glowRect = Rect.fromLTWH(rect.left, rect.top, fillWidth, rect.height);

    final glowPaint = Paint()
      ..isAntiAlias = true
      ..color = glowColor.withValues(alpha: effects.neon ? 0.6 : 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

    canvas.drawRect(glowRect, glowPaint);
  }

  // =========================================================================
  // Circular & Radial Ring Rendering Engine
  // =========================================================================

  void _paintCircularProgress(Canvas canvas, Size size) {
    final strokeWidth = track.thickness ?? 8.0;
    final side = math.min(size.width, size.height);
    final center = Offset(size.width / 2.0, size.height / 2.0);
    final radius = (side - strokeWidth) / 2.0;

    if (radius <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Paint Track
    final trackPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = track.color ?? trackFallbackColor;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Determinate or Indeterminate Fill
    if (value == null) {
      _paintCircularIndeterminate(canvas, rect, strokeWidth);
    } else {
      _paintCircularDeterminate(canvas, rect, strokeWidth, center, radius);
    }

    // 3. Circular Glow
    if (effects.glow || effects.neon) {
      final glowPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = (effects.glowColor ?? primaryColor).withValues(alpha: 0.45)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, effects.glowRadius);
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  void _paintCircularDeterminate(
    Canvas canvas,
    Rect rect,
    double strokeWidth,
    Offset center,
    double radius,
  ) {
    final progress = (value ?? 0.0).clamp(0.0, 1.0);
    if (progress <= 0.0) return;

    final sweepAngle = 2 * math.pi * progress;
    const startAngle = -math.pi / 2.0; // 12 o'clock start

    // Dotted Ring Style
    if (style == Material4ProgressStyle.dottedRing) {
      _paintDottedRing(canvas, center, radius, progress, strokeWidth);
      return;
    }

    // Segmented Ring Style
    if (style == Material4ProgressStyle.segmentedRing) {
      _paintSegmentedRing(canvas, rect, progress, strokeWidth);
      return;
    }

    // Fill Paint
    final fillPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = (style == Material4ProgressStyle.classicCircular)
          ? StrokeCap.butt
          : StrokeCap.round;

    if (fill.gradient != null) {
      fillPaint.shader = SweepGradient(
        colors: [primaryColor.withValues(alpha: 0.3), primaryColor],
        startAngle: 0.0,
        endAngle: sweepAngle,
        transform: const GradientRotation(startAngle),
      ).createShader(rect);
    } else {
      fillPaint.color = fill.resolveColor(progress, primaryColor);
    }

    canvas.drawArc(rect, startAngle, sweepAngle, false, fillPaint);
  }

  void _paintDottedRing(
    Canvas canvas,
    Offset center,
    double radius,
    double progress,
    double dotDiameter,
  ) {
    const totalDots = 24;
    final activeDots = (progress * totalDots).round();
    final dotRadius = dotDiameter / 2.2;

    for (var i = 0; i < totalDots; i++) {
      final angle = -math.pi / 2.0 + (i / totalDots) * (2 * math.pi);
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final paint = Paint()
        ..isAntiAlias = true
        ..color = (i < activeDots)
            ? primaryColor
            : track.color ?? trackFallbackColor.withValues(alpha: 0.3);
      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  void _paintSegmentedRing(
    Canvas canvas,
    Rect rect,
    double progress,
    double strokeWidth,
  ) {
    final segments = fill.segments;
    const totalAngle = 2 * math.pi;
    const gapAngle = 0.08; // in radians
    final segmentAngle = (totalAngle - segments * gapAngle) / segments;
    final activeSegments = progress * segments;

    for (var i = 0; i < segments; i++) {
      final angle = -math.pi / 2.0 + i * (segmentAngle + gapAngle);
      final isFilled = i < activeSegments.floor();
      final paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = isFilled ? primaryColor : primaryColor.withValues(alpha: 0.15);

      canvas.drawArc(rect, angle, segmentAngle, false, paint);
    }
  }

  void _paintCircularIndeterminate(Canvas canvas, Rect rect, double strokeWidth) {
    final p = indeterminateProgress;
    final startAngle = (p * 4 * math.pi) % (2 * math.pi);
    final sweepAngle = (0.2 + 0.6 * math.sin(p * math.pi).abs()) * 2 * math.pi;

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = primaryColor;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  // =========================================================================
  // Creative Progress Indicators: Step, Timeline, Equalizer & Dot Matrix
  // =========================================================================

  void _paintStepProgress(Canvas canvas, Size size) {
    final steps = fill.segments > 1 ? fill.segments : 4;
    final progress = (value ?? 0.0).clamp(0.0, 1.0);
    final activeStep = progress * (steps - 1);

    final cy = size.height / 2.0;
    final stepRadius = size.height * 0.38;
    final startX = stepRadius;
    final endX = size.width - stepRadius;
    final bridgeWidth = (endX - startX) / (steps - 1);

    // 1. Draw Connecting Bridge Lines
    final trackBridgePaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 3.5
      ..color = track.color ?? trackFallbackColor;
    canvas.drawLine(Offset(startX, cy), Offset(endX, cy), trackBridgePaint);

    final filledWidth = startX + activeStep * bridgeWidth;
    final activeBridgePaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 3.5
      ..color = primaryColor;
    canvas.drawLine(Offset(startX, cy), Offset(filledWidth, cy), activeBridgePaint);

    // 2. Draw Milestone Nodes
    for (var i = 0; i < steps; i++) {
      final nx = startX + i * bridgeWidth;
      final nodeCenter = Offset(nx, cy);
      final isCompleted = i <= activeStep;

      final nodePaint = Paint()
        ..isAntiAlias = true
        ..color = isCompleted ? primaryColor : (track.color ?? trackFallbackColor);
      canvas.drawCircle(nodeCenter, stepRadius, nodePaint);

      // White inner pip
      final innerPipPaint = Paint()
        ..isAntiAlias = true
        ..color = isCompleted ? Colors.white : Colors.transparent;
      canvas.drawCircle(nodeCenter, stepRadius * 0.45, innerPipPaint);
    }
  }

  void _paintEqualizerProgress(Canvas canvas, Size size) {
    final bars = fill.segments > 1 ? fill.segments : 12;
    final gap = 3.0;
    final barWidth = (size.width - (bars - 1) * gap) / bars;
    final progress = (value ?? 0.0).clamp(0.0, 1.0);

    for (var i = 0; i < bars; i++) {
      final bx = i * (barWidth + gap);
      final threshold = (i + 1) / bars;
      final isTriggered = progress >= (i / bars);

      final harmonic = math.sin((i / bars) * math.pi + animationProgress * 2 * math.pi).abs();
      final activeHeight = isTriggered ? size.height * (0.3 + 0.7 * harmonic) : size.height * 0.15;
      final by = size.height - activeHeight;

      final barPaint = Paint()
        ..isAntiAlias = true
        ..color = isTriggered
            ? (fill.gradient != null
                ? primaryColor
                : fill.resolveColor(threshold, primaryColor))
            : trackFallbackColor;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(bx, by, barWidth, activeHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(rrect, barPaint);
    }
  }

  void _paintDotMatrixProgress(Canvas canvas, Size size) {
    const cols = 16;
    const rows = 4;
    final dotDiameter = math.min(size.width / cols, size.height / rows) * 0.7;
    final dotRadius = dotDiameter / 2.0;
    final progress = (value ?? 0.0).clamp(0.0, 1.0);
    final activeCols = (progress * cols).round();

    final stepX = size.width / cols;
    final stepY = size.height / rows;

    for (var c = 0; c < cols; c++) {
      final isColActive = c < activeCols;
      for (var r = 0; r < rows; r++) {
        final cx = c * stepX + stepX / 2.0;
        final cy = r * stepY + stepY / 2.0;

        final paint = Paint()
          ..isAntiAlias = true
          ..color = isColActive ? primaryColor : trackFallbackColor.withValues(alpha: 0.35);
        canvas.drawCircle(Offset(cx, cy), dotRadius, paint);
      }
    }
  }

  // =========================================================================
  // Interactive Draggable Thumb Knob
  // =========================================================================

  void _paintInteractionThumb(Canvas canvas, Size size) {
    if (interaction == null || !interaction!.enabled || !interaction!.thumb) {
      return;
    }
    final effectiveProgress = (value ?? 0.0).clamp(0.0, 1.0);
    final thumbRadius = interaction!.thumbRadius;
    final thumbCenter = Offset(size.width * effectiveProgress, size.height / 2.0);

    // Thumb Drop Shadow
    if (interaction!.thumbElevation > 0) {
      final shadowPaint = Paint()
        ..isAntiAlias = true
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, interaction!.thumbElevation);
      canvas.drawCircle(
        thumbCenter + Offset(0, interaction!.thumbElevation * 0.5),
        thumbRadius,
        shadowPaint,
      );
    }

    // Thumb White Outline
    if (interaction!.thumbBorderWidth > 0) {
      final borderPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = interaction!.thumbBorderWidth
        ..color = interaction!.thumbBorderColor;
      canvas.drawCircle(thumbCenter, thumbRadius, borderPaint);
    }

    // Thumb Fill
    final fillPaint = Paint()
      ..isAntiAlias = true
      ..color = interaction!.thumbColor ?? primaryColor;
    canvas.drawCircle(thumbCenter, thumbRadius - interaction!.thumbBorderWidth / 2.0, fillPaint);
  }

  @override
  bool shouldRepaint(covariant Material4ProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.secondaryValue != secondaryValue ||
        oldDelegate.style != style ||
        oldDelegate.waveLine != waveLine ||
        oldDelegate.shape != shape ||
        oldDelegate.track != track ||
        oldDelegate.fill != fill ||
        oldDelegate.effects != effects ||
        oldDelegate.interaction != interaction ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.indeterminateProgress != indeterminateProgress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackFallbackColor != trackFallbackColor;
  }
}

