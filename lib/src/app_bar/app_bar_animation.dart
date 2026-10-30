import 'package:flutter/material.dart';

/// Animation parameters and tuning configuration for [Material4AppBar].
///
/// Configures transition timing, motion curves, shape morphing toggles,
/// and accessibility-friendly reduced motion synchronization.
@immutable
class Material4AppBarAnimation {
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

  /// Whether to automatically disable transitions when user enables Reduced Motion.
  final bool reducedMotionAware;

  /// Creates a [Material4AppBarAnimation] instance.
  const Material4AppBarAnimation({
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeInCubic,
    this.enableShapeMorphing = true,
    this.enableAvatarScaling = true,
    this.enableCrossFade = true,
    this.reducedMotionAware = true,
  });

  /// Smooth spring-like animation configuration for responsive tactile feel.
  static const Material4AppBarAnimation snappy = Material4AppBarAnimation(
    duration: Duration(milliseconds: 220),
    curve: Curves.easeOutQuad,
    reverseCurve: Curves.easeInQuad,
  );

  /// Gentle, cinematic animation configuration.
  static const Material4AppBarAnimation gentle = Material4AppBarAnimation(
    duration: Duration(milliseconds: 360),
    curve: Curves.easeInOutCubic,
    reverseCurve: Curves.easeInOutCubic,
  );

  /// Instantly switches states without transitions (ideal for tests or high-contrast modes).
  static const Material4AppBarAnimation instantaneous =
      Material4AppBarAnimation(
    duration: Duration.zero,
    enableShapeMorphing: false,
    enableAvatarScaling: false,
    enableCrossFade: false,
  );
}

