import 'package:flutter/material.dart';

import 'avatar_shape.dart';

/// Available animation presets for [Material4Avatar].
enum Material4AvatarAnimationPreset {
  /// Smooth, balanced cubic morphing between shapes.
  smoothMorph,

  /// Gentle, slower cinematic shape morphing.
  gentleMorph,

  /// Organic fluid continuous transformation.
  organicFlow,

  /// Playful soft bounce on shape settlement.
  softBounce,

  /// High-energy elastic morphing.
  elasticMorph,

  /// Seamless liquid-like fluid transition.
  fluidMorph,

  /// Subtle minimal linear transition.
  minimalMorph,

  /// Luxurious, slow-eased premium transition.
  premiumMorph,

  /// Periodic subtle shape breathing without full morph.
  breathingShape,

  /// Continuous floating hover effect with soft shape shift.
  floatingAvatar,

  /// Rhythmic pulsing shape expansion.
  pulseMorph,
}

/// Loop playback strategies for avatar shape sequences.
enum AvatarLoopMode {
  /// Cycles forward continuously: 0 -> 1 -> 2 -> 0 -> 1 -> ...
  loop,

  /// Cycles in reverse: 2 -> 1 -> 0 -> 2 -> 1 -> ...
  reverse,

  /// Cycles back and forth: 0 -> 1 -> 2 -> 1 -> 0 -> ...
  pingPong,

  /// Randomly selects the next shape in the sequence.
  random,
}

/// Performance configuration tuning rendering fidelity and battery consumption.
enum AvatarPerformanceMode {
  /// High precision contour sampling with all secondary visual effects enabled.
  highQuality,

  /// Standard balanced 60fps morphing with efficient path caching.
  balanced,

  /// Optimized lower point sampling count for high-density avatar lists.
  performance,

  /// Disables continuous breathing and floating, throttles morph duration.
  batterySaver,

  /// Strictly obeys accessibility rules by eliminating non-essential motion.
  reducedMotion,
}

/// Visual effects and secondary motion configuration for [Material4Avatar].
@immutable
class Material4AvatarEffects {
  /// Whether to enable subtle periodic breathing scale (0.97 to 1.03).
  final bool breathing;

  /// Breathing oscillation duration.
  final Duration breathingDuration;

  /// Whether to enable gentle vertical floating motion (-3.0 to +3.0 px).
  final bool floating;

  /// Floating oscillation duration.
  final Duration floatingDuration;

  /// Floating vertical amplitude in logical pixels.
  final double floatingAmplitude;

  /// Whether to enable radiant outer glow halo.
  final bool glow;

  /// Outer halo glow color.
  final Color? glowColor;

  /// Blur radius of the outer glow.
  final double glowRadius;

  /// Whether to continuously rotate the gradient on gradient borders.
  final bool animatedBorder;

  /// Speed of border rotation in revolutions per second.
  final double borderRotationSpeed;

  /// Whether to apply frosted glass blur on the avatar surface.
  final bool glass;

  /// Glass blur intensity.
  final double glassBlur;

  /// Whether to apply grayscale filter to the profile image.
  final bool grayscale;

  /// Creates a [Material4AvatarEffects] instance.
  const Material4AvatarEffects({
    this.breathing = false,
    this.breathingDuration = const Duration(milliseconds: 2400),
    this.floating = false,
    this.floatingDuration = const Duration(milliseconds: 3000),
    this.floatingAmplitude = 3.5,
    this.glow = false,
    this.glowColor,
    this.glowRadius = 8.0,
    this.animatedBorder = false,
    this.borderRotationSpeed = 0.5,
    this.glass = false,
    this.glassBlur = 10.0,
    this.grayscale = false,
  });

  /// Preset for a floating avatar with subtle vertical hover.
  static const Material4AvatarEffects floatingPreset = Material4AvatarEffects(
    floating: true,
    floatingAmplitude: 4.0,
  );

  /// Preset for a breathing avatar with rhythmic scale expansion.
  static const Material4AvatarEffects breathingPreset = Material4AvatarEffects(
    breathing: true,
  );

  /// Preset for an energetic avatar combining floating, breathing, and rotating border.
  static const Material4AvatarEffects dynamicPreset = Material4AvatarEffects(
    floating: true,
    breathing: true,
    animatedBorder: true,
    glow: true,
  );

  /// Creates a copy of this effects configuration with modified parameters.
  Material4AvatarEffects copyWith({
    bool? breathing,
    Duration? breathingDuration,
    bool? floating,
    Duration? floatingDuration,
    double? floatingAmplitude,
    bool? glow,
    Color? glowColor,
    double? glowRadius,
    bool? animatedBorder,
    double? borderRotationSpeed,
    bool? glass,
    double? glassBlur,
    bool? grayscale,
  }) {
    return Material4AvatarEffects(
      breathing: breathing ?? this.breathing,
      breathingDuration: breathingDuration ?? this.breathingDuration,
      floating: floating ?? this.floating,
      floatingDuration: floatingDuration ?? this.floatingDuration,
      floatingAmplitude: floatingAmplitude ?? this.floatingAmplitude,
      glow: glow ?? this.glow,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      animatedBorder: animatedBorder ?? this.animatedBorder,
      borderRotationSpeed: borderRotationSpeed ?? this.borderRotationSpeed,
      glass: glass ?? this.glass,
      glassBlur: glassBlur ?? this.glassBlur,
      grayscale: grayscale ?? this.grayscale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AvatarEffects &&
        other.breathing == breathing &&
        other.breathingDuration == breathingDuration &&
        other.floating == floating &&
        other.floatingDuration == floatingDuration &&
        other.floatingAmplitude == floatingAmplitude &&
        other.glow == glow &&
        other.glowColor == glowColor &&
        other.glowRadius == glowRadius &&
        other.animatedBorder == animatedBorder &&
        other.borderRotationSpeed == borderRotationSpeed &&
        other.glass == glass &&
        other.glassBlur == glassBlur &&
        other.grayscale == grayscale;
  }

  @override
  int get hashCode => Object.hash(
        breathing,
        breathingDuration,
        floating,
        floatingDuration,
        floatingAmplitude,
        glow,
        glowColor,
        glowRadius,
        animatedBorder,
        borderRotationSpeed,
        glass,
        glassBlur,
        grayscale,
      );
}

/// Comprehensive animation configuration for [Material4Avatar].
///
/// Drives infinite shape sequences, morphing timing, curves, loop modes,
/// and performance profiles.
@immutable
class Material4AvatarAnimation {
  /// Preset mode defining standard curves and timing.
  final Material4AvatarAnimationPreset preset;

  /// Ordered sequence of shapes to cycle through.
  final List<Material4AvatarShape> shapeSequence;

  /// Transition duration for each individual shape morph step.
  final Duration duration;

  /// Pause delay before beginning the next shape morph.
  final Duration delay;

  /// Animation curve applied during forward morphing.
  final Curve curve;

  /// Whether the animation starts playing immediately when mounted.
  final bool autoPlay;

  /// Whether to continuously repeat playback.
  final bool repeat;

  /// Loop sequencing strategy (e.g. forward loop, reverse, ping-pong, random).
  final AvatarLoopMode loopMode;

  /// Playback speed multiplier (default 1.0).
  final double speed;

  /// Whether shape morphing is active.
  final bool shapeMorph;

  /// Target performance and battery optimization mode.
  final AvatarPerformanceMode performanceMode;

  /// Creates a [Material4AvatarAnimation] configuration.
  const Material4AvatarAnimation({
    this.preset = Material4AvatarAnimationPreset.smoothMorph,
    this.shapeSequence = const [],
    this.duration = const Duration(milliseconds: 1800),
    this.delay = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubic,
    this.autoPlay = true,
    this.repeat = true,
    this.loopMode = AvatarLoopMode.loop,
    this.speed = 1.0,
    this.shapeMorph = true,
    this.performanceMode = AvatarPerformanceMode.balanced,
  });

  /// Factory constructor applying the designated [preset] with optional overrides.
  factory Material4AvatarAnimation.fromPreset(
    Material4AvatarAnimationPreset preset, {
    List<Material4AvatarShape>? shapeSequence,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    bool? autoPlay,
    bool? repeat,
    AvatarLoopMode? loopMode,
    double? speed,
    bool? shapeMorph,
    AvatarPerformanceMode? performanceMode,
  }) {
    final effectiveSequence = shapeSequence ??
        [
          Material4AvatarShape.circle(),
          Material4AvatarShape.squircle(),
          Material4AvatarShape.organicBlob(),
          Material4AvatarShape.hexagon(),
        ];

    switch (preset) {
      case Material4AvatarAnimationPreset.smoothMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 1800),
          delay: delay ?? const Duration(milliseconds: 400),
          curve: curve ?? Curves.easeInOutCubic,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.gentleMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 2400),
          delay: delay ?? const Duration(milliseconds: 600),
          curve: curve ?? Curves.easeInOutSine,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.organicFlow:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 2200),
          delay: delay ?? Duration.zero,
          curve: curve ?? Curves.easeInOutCubicEmphasized,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.pingPong,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.softBounce:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 1600),
          delay: delay ?? const Duration(milliseconds: 300),
          curve: curve ?? Curves.easeOutBack,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.elasticMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 2000),
          delay: delay ?? const Duration(milliseconds: 400),
          curve: curve ?? Curves.elasticOut,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.fluidMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 1900),
          delay: delay ?? const Duration(milliseconds: 100),
          curve: curve ?? Curves.fastOutSlowIn,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.pingPong,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.minimalMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 1000),
          delay: delay ?? const Duration(milliseconds: 500),
          curve: curve ?? Curves.linear,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.premiumMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 2800),
          delay: delay ?? const Duration(milliseconds: 500),
          curve: curve ?? Curves.easeInOutQuint,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.loop,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.highQuality,
        );
      case Material4AvatarAnimationPreset.breathingShape:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 2400),
          delay: delay ?? Duration.zero,
          curve: curve ?? Curves.easeInOutSine,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.pingPong,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? false,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.floatingAvatar:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 3000),
          delay: delay ?? Duration.zero,
          curve: curve ?? Curves.easeInOut,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.pingPong,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? false,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
      case Material4AvatarAnimationPreset.pulseMorph:
        return Material4AvatarAnimation(
          preset: preset,
          shapeSequence: effectiveSequence,
          duration: duration ?? const Duration(milliseconds: 1400),
          delay: delay ?? const Duration(milliseconds: 200),
          curve: curve ?? Curves.easeInOutBack,
          autoPlay: autoPlay ?? true,
          repeat: repeat ?? true,
          loopMode: loopMode ?? AvatarLoopMode.pingPong,
          speed: speed ?? 1.0,
          shapeMorph: shapeMorph ?? true,
          performanceMode: performanceMode ?? AvatarPerformanceMode.balanced,
        );
    }
  }

  /// Preset: Smooth infinite morphing.
  static const Material4AvatarAnimation smooth = Material4AvatarAnimation(
    preset: Material4AvatarAnimationPreset.smoothMorph,
  );

  /// Preset: Gentle slow-paced morphing.
  static const Material4AvatarAnimation gentle = Material4AvatarAnimation(
    preset: Material4AvatarAnimationPreset.gentleMorph,
    duration: Duration(milliseconds: 2400),
    curve: Curves.easeInOutSine,
  );

  /// Preset: Organic continuous fluid morphing.
  static const Material4AvatarAnimation organicFlow = Material4AvatarAnimation(
    preset: Material4AvatarAnimationPreset.organicFlow,
    duration: Duration(milliseconds: 2200),
    delay: Duration.zero,
    loopMode: AvatarLoopMode.pingPong,
  );

  /// Preset: Playful soft bouncing morph.
  static const Material4AvatarAnimation softBounce = Material4AvatarAnimation(
    preset: Material4AvatarAnimationPreset.softBounce,
    duration: Duration(milliseconds: 1600),
    curve: Curves.easeOutBack,
  );

  /// Preset: Elastic rebound morphing.
  static const Material4AvatarAnimation elastic = Material4AvatarAnimation(
    preset: Material4AvatarAnimationPreset.elasticMorph,
    duration: Duration(milliseconds: 2000),
    curve: Curves.elasticOut,
  );

  /// Creates a copy of this animation configuration with modified values.
  Material4AvatarAnimation copyWith({
    Material4AvatarAnimationPreset? preset,
    List<Material4AvatarShape>? shapeSequence,
    Duration? duration,
    Duration? delay,
    Curve? curve,
    bool? autoPlay,
    bool? repeat,
    AvatarLoopMode? loopMode,
    double? speed,
    bool? shapeMorph,
    AvatarPerformanceMode? performanceMode,
  }) {
    return Material4AvatarAnimation(
      preset: preset ?? this.preset,
      shapeSequence: shapeSequence ?? this.shapeSequence,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      autoPlay: autoPlay ?? this.autoPlay,
      repeat: repeat ?? this.repeat,
      loopMode: loopMode ?? this.loopMode,
      speed: speed ?? this.speed,
      shapeMorph: shapeMorph ?? this.shapeMorph,
      performanceMode: performanceMode ?? this.performanceMode,
    );
  }
}

