import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../progress_style.dart';
import 'wave_direction.dart';
import 'wave_line_config.dart';

/// Point representation for discrete particle and bead calculations.
@immutable
class WavePoint {
  final double x;
  final double y;
  final double radius;
  final double opacity;

  const WavePoint({
    required this.x,
    required this.y,
    this.radius = 2.5,
    this.opacity = 1.0,
  });
}

/// DNA Base Pair crossbar representation.
@immutable
class DnaRung {
  final Offset top;
  final Offset bottom;
  final Color? color;

  const DnaRung({required this.top, required this.bottom, this.color});
}

/// Mathematical path and point calculation engine for all 35 Animated Wave Line Styles.
class WaveLineGeometry {
  /// Computes the effective phase in radians accounting for direction and speed.
  static double computePhase(Material4WaveLineConfig config, double animationProgress) {
    final base = animationProgress * 2 * math.pi * config.speed;
    return switch (config.direction) {
      WaveDirection.forward => base + config.phase,
      WaveDirection.reverse => -base + config.phase,
      WaveDirection.pingPong =>
        math.sin(animationProgress * 2 * math.pi) * math.pi * config.speed + config.phase,
      WaveDirection.alternating => base + config.phase,
    };
  }

  /// Evaluates the y-coordinate for a given x-position for the specified style.
  static double evaluateY({
    required double x,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    int layerIndex = 0,
  }) {
    if (width <= 0) return centerY;

    final normX = x / width;
    final wavelength = config.wavelength ?? (width / config.frequency);
    final k = (2 * math.pi) / math.max(1.0, wavelength);

    // Layer-specific phase shift
    final layerPhase = phase + (layerIndex * (2 * math.pi / math.max(1, config.layers)));
    final amp = config.amplitude;

    return switch (style) {
      // -----------------------------------------------------------------------
      // A. Zigzag Styles
      // -----------------------------------------------------------------------
      Material4ProgressStyle.smoothZigzagWave => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = (frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1));
          final sine = math.sin(x * k - layerPhase);
          final s = config.cornerSmoothness;
          return centerY + amp * (tri * (1 - s) + sine * s);
        }(),

      Material4ProgressStyle.sharpZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          return centerY + amp * tri;
        }(),

      Material4ProgressStyle.roundedZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          // Apply cubic smoothing around vertices
          final smoothed = math.sin(tri * math.pi / 2);
          final s = config.cornerSmoothness;
          return centerY + amp * (tri * (1 - s) + smoothed * s);
        }(),

      Material4ProgressStyle.doubleZigzag => () {
          final sign = (layerIndex % 2 == 0) ? 1.0 : -1.0;
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          return centerY + sign * amp * tri;
        }(),

      Material4ProgressStyle.continuousZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          return centerY + amp * tri;
        }(),

      Material4ProgressStyle.alternatingZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final periodIndex = t.floor();
          final frac = (t - periodIndex).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          final altScale = (periodIndex % 2 == 0) ? 1.0 : 0.5;
          return centerY + amp * altScale * tri;
        }(),

      Material4ProgressStyle.elasticZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          final elastic = 1.0 + 0.3 * math.sin(layerPhase * 2 + normX * 4 * math.pi);
          return centerY + amp * elastic * tri;
        }(),

      Material4ProgressStyle.flowingZigzag => () {
          final skew = 0.3 * math.sin(layerPhase);
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = ((t + normX * skew) - (t + normX * skew).floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          return centerY + amp * tri;
        }(),

      Material4ProgressStyle.morphingZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          final sine = math.sin(x * k - layerPhase);
          final morph = 0.5 + 0.5 * math.sin(layerPhase * 0.7);
          return centerY + amp * (tri * morph + sine * (1 - morph));
        }(),

      Material4ProgressStyle.multiLayerZigzag => () {
          final t = (x * k - layerPhase) / (2 * math.pi);
          final frac = (t - t.floor()).clamp(0.0, 1.0);
          final tri = frac < 0.5 ? (frac * 4 - 1) : ((1 - frac) * 4 - 1);
          final yOffset = (layerIndex - (config.layers - 1) / 2.0) * 4.0;
          return centerY + amp * tri + yOffset;
        }(),

      // -----------------------------------------------------------------------
      // B. Organic Wave Styles
      // -----------------------------------------------------------------------
      Material4ProgressStyle.smoothSineWave =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.doubleWave => () {
          if (layerIndex == 0) {
            return centerY + amp * math.sin(x * k - layerPhase);
          } else {
            return centerY + amp * math.sin(x * (k * 1.5) + layerPhase * 0.8);
          }
        }(),

      Material4ProgressStyle.tripleWave => () {
          final harmonic = 1.0 + layerIndex * 0.5;
          final sign = (layerIndex % 2 == 0) ? 1.0 : -1.0;
          return centerY + amp * math.sin(x * (k * harmonic) - layerPhase * sign);
        }(),

      Material4ProgressStyle.liquidWave => () {
          final theta = x * k - layerPhase;
          final h1 = math.sin(theta);
          final h2 = 0.35 * math.sin(2 * theta + 0.5);
          final h3 = 0.15 * math.sin(3 * theta);
          return centerY + amp * (h1 + h2 + h3);
        }(),

      Material4ProgressStyle.oceanWave => () {
          // Trochoidal / Gerstner wave: steep crests, wide gentle troughs
          final theta = x * k - layerPhase;
          final s = (math.sin(theta) + 1.0) / 2.0;
          final steep = math.pow(s, 1.75).toDouble() * 2.0 - 1.0;
          return centerY - amp * steep;
        }(),

      Material4ProgressStyle.softRollingWave =>
        centerY + (amp * 0.7) * math.sin(x * (k * 0.65) - layerPhase),

      Material4ProgressStyle.organicFlowWave => () {
          final theta1 = x * k - layerPhase;
          final theta2 = x * (k * 1.618) + layerPhase * 0.6;
          final theta3 = x * (k * 0.618) - layerPhase * 0.4;
          final sum = 0.6 * math.sin(theta1) + 0.3 * math.sin(theta2) + 0.15 * math.cos(theta3);
          return centerY + amp * sum;
        }(),

      Material4ProgressStyle.asymmetricWave => () {
          // Asymmetric sawtooth curve with curved ascent/descent
          final theta = (x * k - layerPhase) % (2 * math.pi);
          final frac = theta / (2 * math.pi);
          final asym = frac < 0.35
              ? math.sin((frac / 0.35) * (math.pi / 2))
              : math.cos(((frac - 0.35) / 0.65) * (math.pi / 2));
          return centerY + amp * asym;
        }(),

      Material4ProgressStyle.randomizedOrganicWave => () {
          final theta = x * k - layerPhase;
          final octave1 = math.sin(theta);
          final octave2 = 0.4 * math.sin(theta * 2.3 + 1.2);
          final octave3 = 0.2 * math.cos(theta * 4.1 + 2.4);
          return centerY + amp * (octave1 + octave2 + octave3) * 0.8;
        }(),

      Material4ProgressStyle.morphingWave => () {
          final morph = 0.5 + 0.5 * math.sin(layerPhase * 0.5);
          final k1 = k;
          final k2 = k * 1.8;
          final wave1 = math.sin(x * k1 - layerPhase);
          final wave2 = math.sin(x * k2 - layerPhase * 1.4);
          return centerY + amp * (wave1 * morph + wave2 * (1 - morph));
        }(),

      // -----------------------------------------------------------------------
      // C. Creative Animated Lines
      // -----------------------------------------------------------------------
      Material4ProgressStyle.snakeLine => () {
          // Serpentine with expanding envelope along x
          final envelope = 0.3 + 0.7 * (1.0 - normX);
          return centerY + amp * envelope * math.sin(x * (k * 1.2) - layerPhase);
        }(),

      Material4ProgressStyle.ribbonFlow => () {
          final offset = (layerIndex == 0) ? -2.5 : 2.5;
          final theta = x * k - layerPhase + (layerIndex * 0.4);
          return centerY + amp * math.sin(theta) + offset;
        }(),

      Material4ProgressStyle.pulseLine => () {
          // Traveling ECG pulse spike complex
          final pulsePos = ((layerPhase / (2 * math.pi)) % 1.0) * width;
          final dist = (x - pulsePos).abs();
          if (dist < 40) {
            final t = (x - pulsePos) / 40.0; // -1.0 to 1.0
            // ECG signature: P wave (-0.6), Q dip (-0.2), R peak (0.0), S dip (0.2), T wave (0.6)
            if (t > -0.7 && t < -0.4) {
              return centerY - amp * 0.25 * math.sin((t + 0.55) / 0.15 * math.pi);
            } else if (t > -0.2 && t <= 0.0) {
              return centerY + amp * 0.3 * (t / 0.2); // Q dip
            } else if (t > 0.0 && t <= 0.15) {
              return centerY - amp * 1.4 * (1.0 - t / 0.15); // R peak
            } else if (t > 0.15 && t <= 0.35) {
              return centerY + amp * 0.4 * math.sin((t - 0.15) / 0.2 * math.pi); // S dip
            } else if (t > 0.45 && t < 0.8) {
              return centerY - amp * 0.35 * math.sin((t - 0.45) / 0.35 * math.pi); // T wave
            }
          }
          return centerY;
        }(),

      Material4ProgressStyle.breathingLine => () {
          final breath = 0.65 + 0.35 * (0.5 + 0.5 * math.sin(layerPhase));
          return centerY + (amp * breath) * math.sin(x * k - layerPhase);
        }(),

      Material4ProgressStyle.movingDotsLine =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.particleFlowLine =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.orbitingDotLine =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.gradientFlowLine =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.shimmerWave =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.neonWave =>
        centerY + amp * math.sin(x * k - layerPhase),

      Material4ProgressStyle.elasticFlowLine => () {
          final inertia = math.exp(-normX * 1.5);
          return centerY + amp * inertia * math.sin(x * (k * 1.5) - layerPhase);
        }(),

      Material4ProgressStyle.infinityFlowLine => () {
          // Dual intersecting looping sinusoids
          final sign = (layerIndex % 2 == 0) ? 1.0 : -1.0;
          final theta = x * k - layerPhase;
          return centerY + sign * amp * math.sin(theta) * math.cos(theta * 0.5);
        }(),

      Material4ProgressStyle.dnaDoubleHelixLine => () {
          final sign = (layerIndex % 2 == 0) ? 1.0 : -1.0;
          return centerY + sign * amp * math.sin(x * k - layerPhase);
        }(),

      Material4ProgressStyle.audioWaveformLine => () {
          final theta = x * k - layerPhase;
          final envelope = 0.4 + 0.6 * math.sin(normX * math.pi);
          final voice = math.sin(theta) * 0.7 +
              math.sin(theta * 2.1) * 0.3 +
              math.sin(theta * 3.8) * 0.15;
          return centerY + amp * envelope * voice;
        }(),

      Material4ProgressStyle.equalizerLine => () {
          final barIndex = (normX * 16).floor();
          final barPhase = layerPhase + barIndex * 0.4;
          final barAmp = (0.3 + 0.7 * (0.5 + 0.5 * math.sin(barPhase)));
          return centerY + amp * barAmp * math.sin(x * k - layerPhase);
        }(),

      _ => centerY + amp * math.sin(x * k - layerPhase),
    };
  }

  /// Builds the vector Path for the continuous wave line from [startX] to [endX].
  static Path buildWavePath({
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    int layerIndex = 0,
    int sampleResolution = 140,
  }) {
    final path = Path();
    if (endX <= startX || width <= 0) return path;

    final distance = endX - startX;
    final steps = math.max(12, (sampleResolution * (distance / width)).round());

    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = startX + t * distance;
      final y = evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        layerIndex: layerIndex,
      );

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  /// Generates DNA base-pair rungs connecting the two helix strands.
  static List<DnaRung> buildDnaRungs({
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    double spacing = 16.0,
  }) {
    final rungs = <DnaRung>[];
    if (endX <= startX || width <= 0) return rungs;

    final rungCount = ((endX - startX) / spacing).floor();
    for (var i = 0; i <= rungCount; i++) {
      final x = startX + i * spacing;
      if (x > endX) break;

      final y1 = evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        layerIndex: 0,
      );
      final y2 = evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
        layerIndex: 1,
      );

      rungs.add(DnaRung(top: Offset(x, y1), bottom: Offset(x, y2)));
    }
    return rungs;
  }

  /// Generates discrete beads / moving dots along the wave contour.
  static List<WavePoint> buildWaveDots({
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
  }) {
    final dots = <WavePoint>[];
    if (endX <= startX || width <= 0) return dots;

    final spacing = math.max(6.0, config.segmentSpacing);
    final count = ((endX - startX) / spacing).floor();

    for (var i = 0; i <= count; i++) {
      final x = startX + i * spacing;
      if (x > endX) break;

      final y = evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
      );

      final r = config.thickness / 2.0;
      dots.add(WavePoint(x: x, y: y, radius: r));
    }
    return dots;
  }

  /// Generates moving floating particles for [particleFlowLine] and [orbitingDotLine].
  static List<WavePoint> buildParticles({
    required double startX,
    required double endX,
    required double width,
    required double centerY,
    required double phase,
    required Material4WaveLineConfig config,
    required Material4ProgressStyle style,
    int particleCount = 14,
  }) {
    final particles = <WavePoint>[];
    if (endX <= startX || width <= 0) return particles;

    final distance = endX - startX;
    for (var i = 0; i < particleCount; i++) {
      final seed = (i * 0.173 + 0.11) % 1.0;
      // Animated translation along x
      final t = ((phase / (2 * math.pi) * 1.5 + seed) % 1.0);
      final x = startX + t * distance;

      final baseY = evaluateY(
        x: x,
        width: width,
        centerY: centerY,
        phase: phase,
        config: config,
        style: style,
      );

      if (style == Material4ProgressStyle.orbitingDotLine) {
        // Orbit around base wave point
        final orbitRadius = 6.0 + seed * 4.0;
        final orbitAngle = phase * 3.0 + i * (2 * math.pi / particleCount);
        final ox = x + orbitRadius * math.cos(orbitAngle) * 0.5;
        final oy = baseY + orbitRadius * math.sin(orbitAngle);
        particles.add(WavePoint(x: ox, y: oy, radius: 2.2, opacity: 0.9));
      } else {
        // Drifting particle plume
        final jitterY = (seed - 0.5) * 6.0;
        final opacity = math.sin(t * math.pi).clamp(0.2, 1.0);
        particles.add(WavePoint(
          x: x,
          y: baseY + jitterY,
          radius: 1.5 + seed * 2.0,
          opacity: opacity,
        ));
      }
    }
    return particles;
  }
}
