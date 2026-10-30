import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../progress_style.dart';
import '../progress_track.dart';
import '../progress_fill.dart';
import '../progress_effects.dart';
import 'wave_line_config.dart';
import 'wave_line_geometry.dart';

/// Canvas painter specialized in rendering all 35 Animated Wave Line Styles.
class WaveLinePainter {
  /// Master entrypoint called by [Material4ProgressPainter] when style is a wave line.
  static void paintWaveLine({
    required Canvas canvas,
    required Size size,
    required double? value,
    required Material4ProgressStyle style,
    required Material4WaveLineConfig config,
    required Material4ProgressTrack track,
    required Material4ProgressFill fill,
    required Material4ProgressEffects effects,
    required double animationProgress,
    required double indeterminateProgress,
    required Color primaryColor,
    required Color trackFallbackColor,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    final centerY = size.height / 2.0;
    final width = size.width;
    final progress = (value ?? 1.0).clamp(0.0, 1.0);
    final isIndeterminate = value == null;

    final phase = WaveLineGeometry.computePhase(config, animationProgress);

    final resolvedFillColor = fill.color ?? primaryColor;
    final resolvedTrackColor = config.trackColor ??
        (track.color ?? resolvedFillColor.withValues(alpha: 0.18));

    // Determinate fill width
    final fillX = width * progress;

    // -------------------------------------------------------------------------
    // 1. Paint Unfilled Background Track Wave
    // -------------------------------------------------------------------------
    if (!isIndeterminate && progress < 1.0) {
      _paintWaveTrack(
        canvas: canvas,
        startX: fillX,
        endX: width,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        trackColor: resolvedTrackColor,
      );
    }

    // -------------------------------------------------------------------------
    // 2. Paint Active Progressing Wave Lines (Determinate or Indeterminate)
    // -------------------------------------------------------------------------
    double activeStartX = 0.0;
    double activeEndX = fillX;

    if (isIndeterminate) {
      // In indeterminate mode, wave traverses as a sweeping segment or flowing entity
      final cycle = indeterminateProgress;
      const segmentSpanRatio = 0.45;
      final span = width * segmentSpanRatio;
      activeStartX = (cycle * (width + span) - span).clamp(0.0, width);
      activeEndX = (activeStartX + span).clamp(0.0, width);

      // If style is continuous, we animate full-width wave with traveling phase
      if (style == Material4ProgressStyle.continuousZigzag ||
          style == Material4ProgressStyle.flowingZigzag ||
          style == Material4ProgressStyle.smoothSineWave ||
          style == Material4ProgressStyle.oceanWave ||
          style == Material4ProgressStyle.liquidWave ||
          style == Material4ProgressStyle.dnaDoubleHelixLine ||
          style == Material4ProgressStyle.neonWave ||
          style == Material4ProgressStyle.particleFlowLine) {
        activeStartX = 0.0;
        activeEndX = width;
      }
    }

    if (activeEndX > activeStartX) {
      _paintActiveWaveContent(
        canvas: canvas,
        startX: activeStartX,
        endX: activeEndX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        fill: fill,
        effects: effects,
        fillColor: resolvedFillColor,
        isIndeterminate: isIndeterminate,
        animationProgress: animationProgress,
      );
    }
  }

  /// Paints the subtle unfilled background track path.
  static void _paintWaveTrack({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    required Color trackColor,
  }) {
    final trackThickness = config.trackThickness ?? (config.thickness * 0.85);
    final trackPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackThickness
      ..strokeCap = config.strokeCap
      ..strokeJoin = config.strokeJoin
      ..color = trackColor;

    final layerCount = _effectiveLayerCount(style, config.layers);
    for (var l = 0; l < layerCount; l++) {
      final trackPath = WaveLineGeometry.buildWavePath(
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        layerIndex: l,
      );
      canvas.drawPath(trackPath, trackPaint);
    }
  }

  /// Paints the active progressing wave line layers and special elements.
  static void _paintActiveWaveContent({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    required Material4ProgressFill fill,
    required Material4ProgressEffects effects,
    required Color fillColor,
    required bool isIndeterminate,
    required double animationProgress,
  }) {
    // 1. Special Handling: Ribbon Flow
    if (style == Material4ProgressStyle.ribbonFlow) {
      _paintRibbonFlow(
        canvas: canvas,
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        fillColor: fillColor,
        fill: fill,
      );
      return;
    }

    // 2. Special Handling: Moving Dots
    if (style == Material4ProgressStyle.movingDotsLine) {
      _paintMovingDots(
        canvas: canvas,
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        fillColor: fillColor,
      );
      return;
    }

    // 3. Multi-layer wave lines
    final layers = _effectiveLayerCount(style, config.layers);
    for (var l = layers - 1; l >= 0; l--) {
      final layerOpacity = math.pow(1.0 - config.layerOpacityStep, l).toDouble();
      final currentLayerColor = (l == 0)
          ? fillColor
          : fillColor.withValues(alpha: layerOpacity.clamp(0.15, 1.0));

      final wavePath = WaveLineGeometry.buildWavePath(
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        layerIndex: l,
      );

      // Neon / Ambient Glow pass
      if (style == Material4ProgressStyle.neonWave ||
          effects.neon ||
          effects.glow ||
          config.glowColor != null) {
        final glowColor = config.glowColor ?? effects.glowColor ?? fillColor;
        final glowRadius = config.glowRadius;

        final glowPaint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = config.thickness + 4.0
          ..strokeCap = config.strokeCap
          ..strokeJoin = config.strokeJoin
          ..color = glowColor.withValues(alpha: 0.45)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
        canvas.drawPath(wavePath, glowPaint);
      }

      // Base stroke paint
      final strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.thickness
        ..strokeCap = config.strokeCap
        ..strokeJoin = config.strokeJoin
        ..color = currentLayerColor;

      // Gradient Flow Shader
      if (style == Material4ProgressStyle.gradientFlowLine || fill.gradient != null) {
        final grad = fill.gradient ??
            LinearGradient(
              colors: [
                fillColor,
                const Color(0xFF00E5FF),
                const Color(0xFF7C3AED),
                fillColor,
              ],
            );
        final gradRect = Rect.fromLTWH(
          startX - (animationProgress * width),
          centerY - config.amplitude * 2,
          width * 2,
          config.amplitude * 4,
        );
        strokePaint.shader = grad.createShader(gradRect);
      }

      canvas.drawPath(wavePath, strokePaint);

      // Shimmer glare sweep pass
      if (style == Material4ProgressStyle.shimmerWave || effects.shimmer) {
        _paintShimmerSweep(
          canvas: canvas,
          wavePath: wavePath,
          width: width,
          animationProgress: animationProgress,
          strokeWidth: config.thickness,
          shimmerColor: effects.shimmerColor,
        );
      }
    }

    // 4. DNA Double Helix Base-Pair Rungs
    if (style == Material4ProgressStyle.dnaDoubleHelixLine) {
      _paintDnaRungs(
        canvas: canvas,
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        fillColor: fillColor,
      );
    }

    // 5. Particle Flow Plume & Orbiting Beads
    if (style == Material4ProgressStyle.particleFlowLine ||
        style == Material4ProgressStyle.orbitingDotLine) {
      _paintParticles(
        canvas: canvas,
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        fillColor: fillColor,
      );
    }

    // 6. Equalizer frequency vertical pins
    if (style == Material4ProgressStyle.equalizerLine) {
      _paintEqualizerPins(
        canvas: canvas,
        startX: startX,
        endX: endX,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        fillColor: fillColor,
      );
    }
  }

  /// Renders undulating ribbon with enclosed shaded surface between dual contours.
  static void _paintRibbonFlow({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Color fillColor,
    required Material4ProgressFill fill,
  }) {
    final topPath = WaveLineGeometry.buildWavePath(
      startX: startX,
      endX: endX,
      width: width,
      centerY: centerY,
      phase: phase,
      config: config,
      style: Material4ProgressStyle.ribbonFlow,
      layerIndex: 0,
    );
    final bottomPath = WaveLineGeometry.buildWavePath(
      startX: endX,
      endX: startX,
      width: width,
      centerY: centerY,
      phase: phase,
      config: config,
      style: Material4ProgressStyle.ribbonFlow,
      layerIndex: 1,
    );

    // Enclosed filled ribbon mesh
    final ribbonMesh = Path()
      ..addPath(topPath, Offset.zero)
      ..addPath(bottomPath, Offset.zero)
      ..close();

    final meshPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = fillColor.withValues(alpha: 0.35);

    if (fill.gradient != null) {
      meshPaint.shader = fill.gradient!.createShader(
        Rect.fromLTWH(startX, centerY - config.amplitude, endX - startX, config.amplitude * 2),
      );
    }
    canvas.drawPath(ribbonMesh, meshPaint);

    // Border contours
    final strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.thickness
      ..color = fillColor;
    canvas.drawPath(topPath, strokePaint);
    canvas.drawPath(bottomPath, strokePaint);
  }

  /// Renders discrete circular beads along wave path.
  static void _paintMovingDots({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    required Color fillColor,
  }) {
    final dots = WaveLineGeometry.buildWaveDots(
      startX: startX,
      endX: endX,
      width: width,
      centerY: centerY,
      phase: phase,
      config: config,
      style: style,
    );

    final dotPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = fillColor;

    for (final dot in dots) {
      canvas.drawCircle(Offset(dot.x, dot.y), dot.radius, dotPaint);
    }
  }

  /// Renders DNA base-pair crossbars between strands.
  static void _paintDnaRungs({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Color fillColor,
  }) {
    final rungs = WaveLineGeometry.buildDnaRungs(
      startX: startX,
      endX: endX,
      width: width,
      centerY: centerY,
      phase: phase,
      config: config,
      style: Material4ProgressStyle.dnaDoubleHelixLine,
    );

    final rungPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, config.thickness * 0.65)
      ..color = fillColor.withValues(alpha: 0.7);

    for (final rung in rungs) {
      canvas.drawLine(rung.top, rung.bottom, rungPaint);
      // Small connector base node at top and bottom
      canvas.drawCircle(rung.top, 2.0, Paint()..color = fillColor);
      canvas.drawCircle(rung.bottom, 2.0, Paint()..color = fillColor);
    }
  }

  /// Renders floating micro-particles and orbiting satellite beads.
  static void _paintParticles({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    required Color fillColor,
  }) {
    final particles = WaveLineGeometry.buildParticles(
      startX: startX,
      endX: endX,
      width: width,
      centerY: centerY,
      phase: phase,
      config: config,
      style: style,
    );

    for (final p in particles) {
      final pPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = fillColor.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, pPaint);
    }
  }

  /// Renders audio equalizer vertical pins underneath wave line.
  static void _paintEqualizerPins({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Color fillColor,
  }) {
    const pinSpacing = 8.0;
    final count = ((endX - startX) / pinSpacing).floor();
    final pinPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = fillColor.withValues(alpha: 0.35);

    for (var i = 0; i <= count; i++) {
      final x = startX + i * pinSpacing;
      if (x > endX) break;

      final waveY = WaveLineGeometry.evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: Material4ProgressStyle.equalizerLine,
      );
      canvas.drawLine(Offset(x, centerY), Offset(x, waveY), pinPaint);
    }
  }

  /// Renders specular glare traveling across wave crests.
  static void _paintShimmerSweep({
    required Canvas canvas,
    required Path wavePath,
    required double width,
    required double animationProgress,
    required double strokeWidth,
    required Color shimmerColor,
  }) {
    canvas.save();
    final sweepX = (animationProgress * (width * 1.6)) - (width * 0.3);
    final shimmerGradient = LinearGradient(
      colors: [
        Colors.transparent,
        shimmerColor,
        Colors.white,
        shimmerColor,
        Colors.transparent,
      ],
      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
    );

    final sweepRect = Rect.fromLTWH(sweepX, 0, width * 0.35, 100);
    final shimmerPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.5
      ..shader = shimmerGradient.createShader(sweepRect);

    canvas.drawPath(wavePath, shimmerPaint);
    canvas.restore();
  }

  /// Determines how many active visual layers a given style requires.
  static int _effectiveLayerCount(Material4ProgressStyle style, int requestedLayers) {
    return switch (style) {
      Material4ProgressStyle.doubleZigzag ||
      Material4ProgressStyle.doubleWave ||
      Material4ProgressStyle.dnaDoubleHelixLine ||
      Material4ProgressStyle.infinityFlowLine ||
      Material4ProgressStyle.ribbonFlow =>
        math.max(2, requestedLayers),
      Material4ProgressStyle.tripleWave => math.max(3, requestedLayers),
      Material4ProgressStyle.multiLayerZigzag => math.max(3, requestedLayers),
      _ => requestedLayers,
    };
  }
}
