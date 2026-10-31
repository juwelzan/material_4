import 'package:flutter/material.dart';

import '../container/container_animation.dart';
import '../material_4_config.dart';

/// Available press animation behaviors for [Material4Button].
enum ButtonPressAnimation {
  /// Button smoothly scales down (e.g., 0.95x).
  scaleDown,

  /// Button smoothly scales up (e.g., 1.05x).
  scaleUp,

  /// Dynamic elastic overshoot with dampening.
  elastic,

  /// Harmonic spring bounce response.
  spring,

  /// Physical bouncing settling at pressed boundary.
  bounce,

  /// Shifts down along Y-axis simulating physical button key compression.
  threeD,

  /// Physical depth indentation compressing shadows and surface relief.
  depthPress,

  /// Fluid hydrodynamic wave compression (scaleX slightly expands as scaleY shrinks).
  liquidPress,

  /// Smoothly morphs contour to a target shape on press.
  shapeMorphPress,

  /// Disables press motion.
  none,
}

/// Available hover animation behaviors for [Material4Button].
enum ButtonHoverAnimation {
  /// Translates slightly upward along Y-axis with elevated shadow.
  liftUp,

  /// Intensifies ambient luminosity and perimeter glow.
  glow,

  /// Accelerates border rotation or moving dash frequency.
  borderFlow,

  /// Shifts background gradient angle or alignment.
  gradientMovement,

  /// Gently scales up (e.g. 1.03x).
  scale,

  /// Continuous floating sinusoidal vertical oscillation.
  floating,

  /// Expands shadow blur radius and spread.
  shadowExpansion,

  /// Subtly morphs towards an organic alternative shape on hover.
  shapeMorph,

  /// Disables hover animation.
  none,
}

/// Available transient tap / release animation effects for [Material4Button].
enum ButtonTapAnimation {
  /// Fluid shape-bounded ink ripple radiating from touch origin.
  ripple,

  /// Expanding circular wave radiating from touch origin.
  expandingCircle,

  /// Fluid hydrodynamic liquid ripple.
  liquidRipple,

  /// Harmonic undulating sinusoidal wave ripple.
  waveRipple,

  /// High-energy particle sparks bursting from tap coordinate.
  particleBurst,

  /// Quick luminous flash across the surface.
  glowPulse,

  /// Temporary micro-morph flash.
  shapeTransformation,

  /// Disables tap effects.
  none,
}

/// Available focus animation behaviors when button receives keyboard or accessibility focus.
enum ButtonFocusAnimation {
  /// Distinct animated high-contrast dashed or moving focus contour.
  animatedFocusBorder,

  /// Pulsating outer glow ring.
  pulsatingOutline,

  /// Chromatic sweep gradient along the perimeter.
  gradientFocus,

  /// Diffused neon bloom outline.
  glowFocus,

  /// Disables focus animation.
  none,
}

/// Declarative multi-tier interaction animation configuration for [Material4Button].
@immutable
class Material4ButtonAnimation {
  /// Animation applied while the button is pressed.
  final ButtonPressAnimation press;

  /// Animation applied while pointer hovers over the button.
  final ButtonHoverAnimation hover;

  /// Transient visual effect triggered upon tap / click.
  final ButtonTapAnimation tap;

  /// Animation applied while the button holds keyboard focus.
  final ButtonFocusAnimation focus;

  /// Transition duration for press and release state changes.
  final Duration pressDuration;

  /// Transition duration for hover enter and exit state changes.
  final Duration hoverDuration;

  /// Transition duration for focus state changes.
  final Duration focusDuration;

  /// Easing curve for press transitions.
  final Curve pressCurve;

  /// Easing curve for hover transitions.
  final Curve hoverCurve;

  /// Scale factor applied during [ButtonPressAnimation.scaleDown] or [ButtonPressAnimation.scaleUp].
  final double pressScale;

  /// Vertical pixel displacement applied during [ButtonPressAnimation.threeD].
  final double depthOffset;

  /// Scale factor applied during [ButtonHoverAnimation.scale].
  final double hoverScale;

  /// Vertical pixel lift applied during [ButtonHoverAnimation.liftUp].
  final double hoverLift;

  /// Target shape type used when [ButtonPressAnimation.shapeMorphPress] is active.
  final Material4Type? morphPressTarget;

  /// Target shape type used when [ButtonHoverAnimation.shapeMorph] is active.
  final Material4Type? morphHoverTarget;

  /// Morph physics profile.
  final Material4MorphType morphType;

  /// Color override for tap ripples or particle bursts.
  final Color? rippleColor;

  ButtonPressAnimation get pressAnimation => press;
  ButtonHoverAnimation get hoverAnimation => hover;
  ButtonTapAnimation get tapAnimation => tap;
  ButtonFocusAnimation get focusAnimation => focus;

  const Material4ButtonAnimation({
    ButtonPressAnimation? press,
    ButtonPressAnimation? pressAnimation,
    ButtonHoverAnimation? hover,
    ButtonHoverAnimation? hoverAnimation,
    ButtonTapAnimation? tap,
    ButtonTapAnimation? tapAnimation,
    ButtonFocusAnimation? focus,
    ButtonFocusAnimation? focusAnimation,
    this.pressDuration = const Duration(milliseconds: 120),
    this.hoverDuration = const Duration(milliseconds: 200),
    this.focusDuration = const Duration(milliseconds: 250),
    this.pressCurve = Curves.easeOutCubic,
    this.hoverCurve = Curves.easeOutCubic,
    this.pressScale = 0.95,
    this.depthOffset = 3.0,
    this.hoverScale = 1.03,
    this.hoverLift = -2.5,
    this.morphPressTarget,
    this.morphHoverTarget,
    this.morphType = Material4MorphType.smooth,
    this.rippleColor,
  })  : press = pressAnimation ?? press ?? ButtonPressAnimation.scaleDown,
        hover = hoverAnimation ?? hover ?? ButtonHoverAnimation.liftUp,
        tap = tapAnimation ?? tap ?? ButtonTapAnimation.ripple,
        focus = focusAnimation ?? focus ?? ButtonFocusAnimation.animatedFocusBorder;

  /// Preset for a subtle, natural interactive feel.
  static const Material4ButtonAnimation subtle = Material4ButtonAnimation(
    press: ButtonPressAnimation.scaleDown,
    hover: ButtonHoverAnimation.glow,
    tap: ButtonTapAnimation.ripple,
    pressScale: 0.97,
    hoverLift: -1.5,
  );

  /// Preset for dynamic bouncy spring responsiveness.
  static const Material4ButtonAnimation bouncy = Material4ButtonAnimation(
    press: ButtonPressAnimation.elastic,
    hover: ButtonHoverAnimation.scale,
    tap: ButtonTapAnimation.expandingCircle,
    pressCurve: Curves.elasticOut,
    pressScale: 0.92,
    hoverScale: 1.05,
  );

  /// Preset for physical 3D key compression.
  static const Material4ButtonAnimation threeD = Material4ButtonAnimation(
    press: ButtonPressAnimation.threeD,
    hover: ButtonHoverAnimation.liftUp,
    tap: ButtonTapAnimation.ripple,
    depthOffset: 4.0,
    hoverLift: -3.0,
  );

  /// Preset for hydrodynamic fluid wave interactions.
  static const Material4ButtonAnimation fluid = Material4ButtonAnimation(
    press: ButtonPressAnimation.liquidPress,
    hover: ButtonHoverAnimation.floating,
    tap: ButtonTapAnimation.liquidRipple,
    morphType: Material4MorphType.fluid,
  );

  /// Preset for high-tech luminous neon glow interactions.
  static const Material4ButtonAnimation neon = Material4ButtonAnimation(
    press: ButtonPressAnimation.scaleDown,
    hover: ButtonHoverAnimation.glow,
    tap: ButtonTapAnimation.glowPulse,
    focus: ButtonFocusAnimation.glowFocus,
    hoverDuration: Duration(milliseconds: 280),
  );

  /// Preset with all animations completely disabled.
  static const Material4ButtonAnimation none = Material4ButtonAnimation(
    press: ButtonPressAnimation.none,
    hover: ButtonHoverAnimation.none,
    tap: ButtonTapAnimation.none,
    focus: ButtonFocusAnimation.none,
    pressScale: 1.0,
    depthOffset: 0.0,
    hoverScale: 1.0,
    hoverLift: 0.0,
  );

  Material4ButtonAnimation copyWith({
    ButtonPressAnimation? press,
    ButtonHoverAnimation? hover,
    ButtonTapAnimation? tap,
    ButtonFocusAnimation? focus,
    Duration? pressDuration,
    Duration? hoverDuration,
    Duration? focusDuration,
    Curve? pressCurve,
    Curve? hoverCurve,
    double? pressScale,
    double? depthOffset,
    double? hoverScale,
    double? hoverLift,
    Material4Type? morphPressTarget,
    Material4Type? morphHoverTarget,
    Material4MorphType? morphType,
    Color? rippleColor,
  }) {
    return Material4ButtonAnimation(
      press: press ?? this.press,
      hover: hover ?? this.hover,
      tap: tap ?? this.tap,
      focus: focus ?? this.focus,
      pressDuration: pressDuration ?? this.pressDuration,
      hoverDuration: hoverDuration ?? this.hoverDuration,
      focusDuration: focusDuration ?? this.focusDuration,
      pressCurve: pressCurve ?? this.pressCurve,
      hoverCurve: hoverCurve ?? this.hoverCurve,
      pressScale: pressScale ?? this.pressScale,
      depthOffset: depthOffset ?? this.depthOffset,
      hoverScale: hoverScale ?? this.hoverScale,
      hoverLift: hoverLift ?? this.hoverLift,
      morphPressTarget: morphPressTarget ?? this.morphPressTarget,
      morphHoverTarget: morphHoverTarget ?? this.morphHoverTarget,
      morphType: morphType ?? this.morphType,
      rippleColor: rippleColor ?? this.rippleColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4ButtonAnimation &&
          runtimeType == other.runtimeType &&
          press == other.press &&
          hover == other.hover &&
          tap == other.tap &&
          focus == other.focus &&
          pressDuration == other.pressDuration &&
          hoverDuration == other.hoverDuration &&
          focusDuration == other.focusDuration &&
          pressCurve == other.pressCurve &&
          hoverCurve == other.hoverCurve &&
          pressScale == other.pressScale &&
          depthOffset == other.depthOffset &&
          hoverScale == other.hoverScale &&
          hoverLift == other.hoverLift &&
          morphPressTarget == other.morphPressTarget &&
          morphHoverTarget == other.morphHoverTarget &&
          morphType == other.morphType &&
          rippleColor == other.rippleColor;

  @override
  int get hashCode => Object.hash(
        press,
        hover,
        tap,
        focus,
        pressDuration,
        hoverDuration,
        focusDuration,
        pressCurve,
        hoverCurve,
        pressScale,
        depthOffset,
        hoverScale,
        hoverLift,
        morphPressTarget,
        morphHoverTarget,
        morphType,
        rippleColor,
      );
}
