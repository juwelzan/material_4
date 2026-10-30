import 'package:flutter/material.dart';

import 'wave_direction.dart';

/// Configuration for the Advanced Animated Wave Line System in [Material4ProgressBar].
///
/// Controls amplitude, frequency, wavelength, speed, direction, layers,
/// corner smoothness, line stroke parameters, and real-time playback states.
@immutable
class Material4WaveLineConfig {
  /// Peak amplitude of wave crests and troughs in logical pixels.
  final double amplitude;

  /// Frequency count of wave cycles across the indicator length.
  final double frequency;

  /// Explicit wavelength in logical pixels. If null, frequency is computed over width.
  final double? wavelength;

  /// Wave phase velocity speed multiplier in cycles per second.
  final double speed;

  /// Propagation trajectory direction of wave oscillation.
  final WaveDirection direction;

  /// Static initial phase offset in radians.
  final double phase;

  /// Number of parallel or intertwined wave strands/layers (1 to 5).
  final int layers;

  /// Stroke thickness of the wave line in logical pixels.
  final double thickness;

  /// Stroke thickness of the unfilled background wave track.
  final double? trackThickness;

  /// Spacing gap between adjacent beads/dots for discrete dot/dash wave styles.
  final double segmentSpacing;

  /// Rounding fillet factor for zigzags and sharp vertices (0.0 = sharp, 1.0 = circular fillets).
  final double cornerSmoothness;

  /// Loop cycle duration for a complete phase revolution.
  final Duration duration;

  /// Easing curve applied to wave phase progression.
  final Curve curve;

  /// Whether wave animation cycles indefinitely.
  final bool repeat;

  /// Whether wave oscillation rebounds back and forth (ping-pong mode).
  final bool pingPong;

  /// Whether the wave animation is currently paused.
  final bool paused;

  /// Whether wave phase propagation advances synchronously with value updates.
  final bool syncWithProgress;

  /// Stroke cap styling applied to wave terminal vertices.
  final StrokeCap strokeCap;

  /// Stroke join styling applied to wave peak and trough corners.
  final StrokeJoin strokeJoin;

  /// Background wave track color for the unfilled path portion.
  final Color? trackColor;

  /// Luminous halo color for neon and glowing wave styles.
  final Color? glowColor;

  /// Blur spread radius of the luminous halo.
  final double glowRadius;

  /// Secondary opacity multiplier for multi-layer trailing strands.
  final double layerOpacityStep;

  /// Creates a [Material4WaveLineConfig].
  const Material4WaveLineConfig({
    this.amplitude = 6.0,
    this.frequency = 4.0,
    this.wavelength,
    this.speed = 1.0,
    this.direction = WaveDirection.forward,
    this.phase = 0.0,
    this.layers = 1,
    this.thickness = 3.5,
    this.trackThickness,
    this.segmentSpacing = 6.0,
    this.cornerSmoothness = 0.5,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.linear,
    this.repeat = true,
    this.pingPong = false,
    this.paused = false,
    this.syncWithProgress = true,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
    this.trackColor,
    this.glowColor,
    this.glowRadius = 10.0,
    this.layerOpacityStep = 0.35,
  })  : assert(amplitude >= 0, 'amplitude must be non-negative'),
        assert(frequency > 0, 'frequency must be greater than zero'),
        assert(layers >= 1 && layers <= 6, 'layers must be between 1 and 6'),
        assert(thickness > 0, 'thickness must be greater than zero'),
        assert(
          cornerSmoothness >= 0.0 && cornerSmoothness <= 1.0,
          'cornerSmoothness must be within 0.0 to 1.0',
        );

  /// Preset configuration optimized for sharp, crisp zigzag lines.
  static const Material4WaveLineConfig sharpZigzag = Material4WaveLineConfig(
    amplitude: 8.0,
    frequency: 6.0,
    thickness: 3.0,
    cornerSmoothness: 0.0,
    strokeCap: StrokeCap.square,
    strokeJoin: StrokeJoin.miter,
  );

  /// Preset configuration optimized for smooth rounded zigzags.
  static const Material4WaveLineConfig roundedZigzag = Material4WaveLineConfig(
    amplitude: 7.0,
    frequency: 5.0,
    thickness: 3.5,
    cornerSmoothness: 0.75,
  );

  /// Preset configuration optimized for harmonic flowing sine waves.
  static const Material4WaveLineConfig smoothSine = Material4WaveLineConfig(
    amplitude: 7.0,
    frequency: 3.5,
    thickness: 3.5,
    speed: 1.2,
  );

  /// Preset configuration for multi-layer fluid ocean waves.
  static const Material4WaveLineConfig oceanWave = Material4WaveLineConfig(
    amplitude: 9.0,
    frequency: 3.0,
    thickness: 4.0,
    layers: 2,
    speed: 1.4,
  );

  /// Preset configuration for high-voltage neon plasma waves.
  static const Material4WaveLineConfig neonWave = Material4WaveLineConfig(
    amplitude: 7.0,
    frequency: 4.0,
    thickness: 4.0,
    glowRadius: 14.0,
    speed: 1.5,
  );

  /// Preset configuration for medical ECG / heart pulse lines.
  static const Material4WaveLineConfig pulseLine = Material4WaveLineConfig(
    amplitude: 12.0,
    frequency: 3.0,
    thickness: 3.0,
    speed: 1.8,
  );

  /// Preset configuration for double-helix DNA strand lines.
  static const Material4WaveLineConfig dnaHelix = Material4WaveLineConfig(
    amplitude: 8.0,
    frequency: 3.5,
    thickness: 3.0,
    layers: 2,
    speed: 1.2,
  );

  /// Creates a copy of this configuration with given fields replaced.
  Material4WaveLineConfig copyWith({
    double? amplitude,
    double? frequency,
    double? wavelength,
    double? speed,
    WaveDirection? direction,
    double? phase,
    int? layers,
    double? thickness,
    double? trackThickness,
    double? segmentSpacing,
    double? cornerSmoothness,
    Duration? duration,
    Curve? curve,
    bool? repeat,
    bool? pingPong,
    bool? paused,
    bool? syncWithProgress,
    StrokeCap? strokeCap,
    StrokeJoin? strokeJoin,
    Color? trackColor,
    Color? glowColor,
    double? glowRadius,
    double? layerOpacityStep,
  }) {
    return Material4WaveLineConfig(
      amplitude: amplitude ?? this.amplitude,
      frequency: frequency ?? this.frequency,
      wavelength: wavelength ?? this.wavelength,
      speed: speed ?? this.speed,
      direction: direction ?? this.direction,
      phase: phase ?? this.phase,
      layers: layers ?? this.layers,
      thickness: thickness ?? this.thickness,
      trackThickness: trackThickness ?? this.trackThickness,
      segmentSpacing: segmentSpacing ?? this.segmentSpacing,
      cornerSmoothness: cornerSmoothness ?? this.cornerSmoothness,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      repeat: repeat ?? this.repeat,
      pingPong: pingPong ?? this.pingPong,
      paused: paused ?? this.paused,
      syncWithProgress: syncWithProgress ?? this.syncWithProgress,
      strokeCap: strokeCap ?? this.strokeCap,
      strokeJoin: strokeJoin ?? this.strokeJoin,
      trackColor: trackColor ?? this.trackColor,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      layerOpacityStep: layerOpacityStep ?? this.layerOpacityStep,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4WaveLineConfig &&
          runtimeType == other.runtimeType &&
          amplitude == other.amplitude &&
          frequency == other.frequency &&
          wavelength == other.wavelength &&
          speed == other.speed &&
          direction == other.direction &&
          phase == other.phase &&
          layers == other.layers &&
          thickness == other.thickness &&
          trackThickness == other.trackThickness &&
          segmentSpacing == other.segmentSpacing &&
          cornerSmoothness == other.cornerSmoothness &&
          duration == other.duration &&
          curve == other.curve &&
          repeat == other.repeat &&
          pingPong == other.pingPong &&
          paused == other.paused &&
          syncWithProgress == other.syncWithProgress &&
          strokeCap == other.strokeCap &&
          strokeJoin == other.strokeJoin &&
          trackColor == other.trackColor &&
          glowColor == other.glowColor &&
          glowRadius == other.glowRadius &&
          layerOpacityStep == other.layerOpacityStep;

  @override
  int get hashCode => Object.hashAll([
        amplitude,
        frequency,
        wavelength,
        speed,
        direction,
        phase,
        layers,
        thickness,
        trackThickness,
        segmentSpacing,
        cornerSmoothness,
        duration,
        curve,
        repeat,
        pingPong,
        paused,
        syncWithProgress,
        strokeCap,
        strokeJoin,
        trackColor,
      ]);
}
