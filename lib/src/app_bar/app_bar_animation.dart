import 'package:flutter/material.dart';

/// Available animation presets for [Material4AppBar] and [Material4SliverAppBar].
enum Material4AnimationPreset {
  /// Balanced smooth cubic transition.
  smooth,

  /// Responsive spring-like bounce with subtle overshoot.
  spring,

  /// Gentle, cinematic easing.
  gentle,

  /// Crisp, rapid transition with minimal duration.
  snappy,

  /// High-energy elastic motion with playful spring settle.
  elastic,

  /// Minimal linear motion with suppressed scale and slide offsets.
  minimal,

  /// Pure cross-fade transition without dimensional translation.
  fadeThrough,

  /// Combined directional slide with progressive alpha fade.
  slideFade,

  /// Coordinated scale expansion and collapse with alpha fade.
  scaleFade,
}

/// Animation parameters and tuning configuration for [Material4AppBar].
///
/// Configures transition timing, motion curves, shape morphing toggles,
/// interruption support, and accessibility-friendly reduced motion synchronization.
@immutable
class Material4AppBarAnimation {
  /// Preset mode defining standard timing and curve profiles.
  final Material4AnimationPreset preset;

  /// Transition duration for state transitions (e.g. floating bar reveal, search expand).
  final Duration duration;

  /// Primary forward animation curve.
  final Curve curve;

  /// Curve applied when reversing or collapsing.
  final Curve reverseCurve;

  /// Whether shape geometry dynamically morphs between expanded and collapsed states.
  final bool enableShapeMorphing;

  /// Whether the profile avatar smoothly scales and morphs between states.
  final bool enableAvatarScaling;

  /// Whether expanded and compact text elements cross-fade smoothly.
  final bool enableCrossFade;

  /// Whether alpha opacity fading is enabled for transitions.
  final bool fadeEnabled;

  /// Whether positional slide translations are enabled.
  final bool slideEnabled;

  /// Whether dimensional scaling transformations are enabled.
  final bool scaleEnabled;

  /// Whether active animations can be seamlessly interrupted and reversed without jumping.
  final bool interruptible;

  /// Whether to automatically disable transitions when user enables Reduced Motion.
  final bool reducedMotionAware;

  /// Creates a [Material4AppBarAnimation] instance.
  const Material4AppBarAnimation({
    this.preset = Material4AnimationPreset.smooth,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.enableShapeMorphing = true,
    this.enableAvatarScaling = true,
    this.enableCrossFade = true,
    this.fadeEnabled = true,
    this.slideEnabled = true,
    this.scaleEnabled = true,
    this.interruptible = true,
    this.reducedMotionAware = true,
  });

  /// Factory resolving any [Material4AnimationPreset] with customizable overrides.
  factory Material4AppBarAnimation.fromPreset(
    Material4AnimationPreset preset, {
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    bool? enableShapeMorphing,
    bool? enableAvatarScaling,
    bool? enableCrossFade,
    bool? fadeEnabled,
    bool? slideEnabled,
    bool? scaleEnabled,
    bool? interruptible,
    bool? reducedMotionAware,
  }) {
    switch (preset) {
      case Material4AnimationPreset.smooth:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve ?? Curves.easeInOutCubic,
          reverseCurve: reverseCurve ?? Curves.easeInOutCubic,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.spring:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 380),
          curve: curve ?? Curves.easeOutBack,
          reverseCurve: reverseCurve ?? Curves.easeInOutCubic,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.gentle:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 360),
          curve: curve ?? Curves.easeInOutCubic,
          reverseCurve: reverseCurve ?? Curves.easeInOutCubic,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.snappy:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 200),
          curve: curve ?? Curves.easeOutQuad,
          reverseCurve: reverseCurve ?? Curves.easeInQuad,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.elastic:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 500),
          curve: curve ?? Curves.elasticOut,
          reverseCurve: reverseCurve ?? Curves.easeOutQuad,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.minimal:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 160),
          curve: curve ?? Curves.linear,
          reverseCurve: reverseCurve ?? Curves.linear,
          enableShapeMorphing: enableShapeMorphing ?? false,
          enableAvatarScaling: enableAvatarScaling ?? false,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? false,
          scaleEnabled: scaleEnabled ?? false,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.fadeThrough:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 240),
          curve: curve ?? Curves.easeOut,
          reverseCurve: reverseCurve ?? Curves.easeIn,
          enableShapeMorphing: enableShapeMorphing ?? false,
          enableAvatarScaling: enableAvatarScaling ?? false,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? false,
          scaleEnabled: scaleEnabled ?? false,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.slideFade:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 280),
          curve: curve ?? Curves.easeOutCubic,
          reverseCurve: reverseCurve ?? Curves.easeInCubic,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? true,
          scaleEnabled: scaleEnabled ?? false,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
      case Material4AnimationPreset.scaleFade:
        return Material4AppBarAnimation(
          preset: preset,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve ?? Curves.easeOutBack,
          reverseCurve: reverseCurve ?? Curves.easeInCubic,
          enableShapeMorphing: enableShapeMorphing ?? true,
          enableAvatarScaling: enableAvatarScaling ?? true,
          enableCrossFade: enableCrossFade ?? true,
          fadeEnabled: fadeEnabled ?? true,
          slideEnabled: slideEnabled ?? false,
          scaleEnabled: scaleEnabled ?? true,
          interruptible: interruptible ?? true,
          reducedMotionAware: reducedMotionAware ?? true,
        );
    }
  }

  /// Preset: Smooth animation with balanced cubic easing.
  static const Material4AppBarAnimation smooth = Material4AppBarAnimation(
    preset: Material4AnimationPreset.smooth,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOutCubic,
    reverseCurve: Curves.easeInOutCubic,
  );

  /// Preset: Spring animation with responsive rebound.
  static const Material4AppBarAnimation spring = Material4AppBarAnimation(
    preset: Material4AnimationPreset.spring,
    duration: Duration(milliseconds: 380),
    curve: Curves.easeOutBack,
    reverseCurve: Curves.easeInOutCubic,
  );

  /// Smooth spring-like animation configuration for responsive tactile feel.
  static const Material4AppBarAnimation snappy = Material4AppBarAnimation(
    preset: Material4AnimationPreset.snappy,
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOutQuad,
    reverseCurve: Curves.easeInQuad,
  );

  /// Gentle, cinematic animation configuration.
  static const Material4AppBarAnimation gentle = Material4AppBarAnimation(
    preset: Material4AnimationPreset.gentle,
    duration: Duration(milliseconds: 360),
    curve: Curves.easeInOutCubic,
    reverseCurve: Curves.easeInOutCubic,
  );

  /// Preset: Elastic animation with playful overshoot.
  static const Material4AppBarAnimation elastic = Material4AppBarAnimation(
    preset: Material4AnimationPreset.elastic,
    duration: Duration(milliseconds: 500),
    curve: Curves.elasticOut,
    reverseCurve: Curves.easeOutQuad,
  );

  /// Preset: Minimal subtle linear animation.
  static const Material4AppBarAnimation minimal = Material4AppBarAnimation(
    preset: Material4AnimationPreset.minimal,
    duration: Duration(milliseconds: 160),
    curve: Curves.linear,
    reverseCurve: Curves.linear,
    enableShapeMorphing: false,
    enableAvatarScaling: false,
    slideEnabled: false,
    scaleEnabled: false,
  );

  /// Preset: Fade-only transition without translation.
  static const Material4AppBarAnimation fadeThrough = Material4AppBarAnimation(
    preset: Material4AnimationPreset.fadeThrough,
    duration: Duration(milliseconds: 240),
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
    enableShapeMorphing: false,
    enableAvatarScaling: false,
    slideEnabled: false,
    scaleEnabled: false,
  );

  /// Preset: Coordinated slide and fade animation.
  static const Material4AppBarAnimation slideFade = Material4AppBarAnimation(
    preset: Material4AnimationPreset.slideFade,
    duration: Duration(milliseconds: 280),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
    scaleEnabled: false,
  );

  /// Preset: Coordinated scale and fade animation.
  static const Material4AppBarAnimation scaleFade = Material4AppBarAnimation(
    preset: Material4AnimationPreset.scaleFade,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOutBack,
    reverseCurve: Curves.easeInCubic,
    slideEnabled: false,
  );

  /// Instantly switches states without transitions (ideal for tests or high-contrast modes).
  static const Material4AppBarAnimation instantaneous =
      Material4AppBarAnimation(
    duration: Duration.zero,
    enableShapeMorphing: false,
    enableAvatarScaling: false,
    enableCrossFade: false,
    fadeEnabled: false,
    slideEnabled: false,
    scaleEnabled: false,
    interruptible: false,
  );

  /// Creates a copy of this animation configuration with the given fields replaced.
  Material4AppBarAnimation copyWith({
    Material4AnimationPreset? preset,
    Duration? duration,
    Curve? curve,
    Curve? reverseCurve,
    bool? enableShapeMorphing,
    bool? enableAvatarScaling,
    bool? enableCrossFade,
    bool? fadeEnabled,
    bool? slideEnabled,
    bool? scaleEnabled,
    bool? interruptible,
    bool? reducedMotionAware,
  }) {
    return Material4AppBarAnimation(
      preset: preset ?? this.preset,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      enableShapeMorphing: enableShapeMorphing ?? this.enableShapeMorphing,
      enableAvatarScaling: enableAvatarScaling ?? this.enableAvatarScaling,
      enableCrossFade: enableCrossFade ?? this.enableCrossFade,
      fadeEnabled: fadeEnabled ?? this.fadeEnabled,
      slideEnabled: slideEnabled ?? this.slideEnabled,
      scaleEnabled: scaleEnabled ?? this.scaleEnabled,
      interruptible: interruptible ?? this.interruptible,
      reducedMotionAware: reducedMotionAware ?? this.reducedMotionAware,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AppBarAnimation &&
        other.preset == preset &&
        other.duration == duration &&
        other.curve == curve &&
        other.reverseCurve == reverseCurve &&
        other.enableShapeMorphing == enableShapeMorphing &&
        other.enableAvatarScaling == enableAvatarScaling &&
        other.enableCrossFade == enableCrossFade &&
        other.fadeEnabled == fadeEnabled &&
        other.slideEnabled == slideEnabled &&
        other.scaleEnabled == scaleEnabled &&
        other.interruptible == interruptible &&
        other.reducedMotionAware == reducedMotionAware;
  }

  @override
  int get hashCode => Object.hash(
        preset,
        duration,
        curve,
        reverseCurve,
        enableShapeMorphing,
        enableAvatarScaling,
        enableCrossFade,
        fadeEnabled,
        slideEnabled,
        scaleEnabled,
        interruptible,
        reducedMotionAware,
      );
}
