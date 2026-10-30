import 'package:flutter/material.dart';

/// Advanced visual effects and secondary micro-interactions for [Material4ProgressBar].
@immutable
class Material4ProgressEffects {
  /// Whether an ambient colored luminous glow is cast around the active progress fill.
  final bool glow;

  /// Hue tint of the ambient glow plume.
  final Color? glowColor;

  /// Spread blur radius of the ambient glow.
  final double glowRadius;

  /// Whether high-intensity neon laser tube illumination is active.
  final bool neon;

  /// Neon luminescence intensity multiplier (default 1.5).
  final double neonIntensity;

  /// Whether frosted glass backdrop filtering is active.
  final bool glass;

  /// Blur intensity of frosted glass backdrop.
  final double glassBlur;

  /// Color tint applied to frosted glass container.
  final Color? glassTint;

  /// Elevated drop shadows cast behind the progress indicator.
  final List<BoxShadow>? shadows;

  /// Whether rhythmic breathing scale oscillation is active.
  final bool breathing;

  /// Period duration for one complete breathing expansion/contraction cycle.
  final Duration breathingPeriod;

  /// Maximum scale expansion factor during breathing (e.g. 1.04 = 4% scale).
  final double breathingScale;

  /// Whether rhythmic brightness/glow pulsing is active.
  final bool pulse;

  /// Period duration for one complete pulse cycle.
  final Duration pulsePeriod;

  /// Whether a moving specular reflective sheen highlights the progress bar.
  final bool shimmer;

  /// Color tint of the moving specular shimmer sheen.
  final Color shimmerColor;

  /// Duration of one complete shimmer sweep cycle.
  final Duration shimmerDuration;

  /// Whether luminous floating micro-particles drift around the progress threshold.
  final bool particles;

  /// Number of active floating micro-particles.
  final int particleCount;

  /// Movement speed multiplier for micro-particles.
  final double particleSpeed;

  /// Creates a [Material4ProgressEffects] configuration.
  const Material4ProgressEffects({
    this.glow = false,
    this.glowColor,
    this.glowRadius = 12.0,
    this.neon = false,
    this.neonIntensity = 1.5,
    this.glass = false,
    this.glassBlur = 10.0,
    this.glassTint,
    this.shadows,
    this.breathing = false,
    this.breathingPeriod = const Duration(milliseconds: 2400),
    this.breathingScale = 1.03,
    this.pulse = false,
    this.pulsePeriod = const Duration(milliseconds: 1800),
    this.shimmer = false,
    this.shimmerColor = const Color(0x66FFFFFF),
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.particles = false,
    this.particleCount = 12,
    this.particleSpeed = 1.0,
  });

  /// Preset for soft ambient glow.
  static const Material4ProgressEffects glowPreset = Material4ProgressEffects(
    glow: true,
    glowRadius: 14.0,
  );

  /// Preset for high-voltage neon plasma tube.
  static const Material4ProgressEffects neonPreset = Material4ProgressEffects(
    neon: true,
    neonIntensity: 2.0,
    glow: true,
    glowRadius: 16.0,
  );

  /// Preset for frosted glassmorphism container.
  static const Material4ProgressEffects glassPreset = Material4ProgressEffects(
    glass: true,
    glassBlur: 12.0,
    glassTint: Color(0x1AFFFFFF),
  );

  /// Preset for specular shimmer sweep across progress.
  static const Material4ProgressEffects shimmerPreset = Material4ProgressEffects(
    shimmer: true,
    shimmerDuration: Duration(milliseconds: 1400),
  );

  /// Preset for breathing and pulsing vitality.
  static const Material4ProgressEffects livingPreset = Material4ProgressEffects(
    breathing: true,
    pulse: true,
    glow: true,
    glowRadius: 10.0,
  );

  /// Creates a copy of this effects configuration with modified parameters.
  Material4ProgressEffects copyWith({
    bool? glow,
    Color? glowColor,
    double? glowRadius,
    bool? neon,
    double? neonIntensity,
    bool? glass,
    double? glassBlur,
    Color? glassTint,
    List<BoxShadow>? shadows,
    bool? breathing,
    Duration? breathingPeriod,
    double? breathingScale,
    bool? pulse,
    Duration? pulsePeriod,
    bool? shimmer,
    Color? shimmerColor,
    Duration? shimmerDuration,
    bool? particles,
    int? particleCount,
    double? particleSpeed,
  }) {
    return Material4ProgressEffects(
      glow: glow ?? this.glow,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      neon: neon ?? this.neon,
      neonIntensity: neonIntensity ?? this.neonIntensity,
      glass: glass ?? this.glass,
      glassBlur: glassBlur ?? this.glassBlur,
      glassTint: glassTint ?? this.glassTint,
      shadows: shadows ?? this.shadows,
      breathing: breathing ?? this.breathing,
      breathingPeriod: breathingPeriod ?? this.breathingPeriod,
      breathingScale: breathingScale ?? this.breathingScale,
      pulse: pulse ?? this.pulse,
      pulsePeriod: pulsePeriod ?? this.pulsePeriod,
      shimmer: shimmer ?? this.shimmer,
      shimmerColor: shimmerColor ?? this.shimmerColor,
      shimmerDuration: shimmerDuration ?? this.shimmerDuration,
      particles: particles ?? this.particles,
      particleCount: particleCount ?? this.particleCount,
      particleSpeed: particleSpeed ?? this.particleSpeed,
    );
  }
}

