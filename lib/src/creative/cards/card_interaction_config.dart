import 'package:flutter/material.dart';

import '../../material_4_config.dart';

/// Interaction state of a dynamic card.
enum CardInteractionState {
  /// Default resting state.
  normal,

  /// Pointer cursor is hovering over the card.
  hovered,

  /// Keyboard or accessibility focus active.
  focused,

  /// Pointer down / pressed state.
  pressed,

  /// Card is in a toggled selected state.
  selected,

  /// Card is disabled and non-interactive.
  disabled,

  /// Card is in an expanded accordion layout.
  expanded,
}

/// Configuration governing responsive interaction states, spring motion,
/// hover elevations, and shape morphing transitions.
class CardInteractionConfig {
  /// Whether tapping/pressing smoothly scales the card down slightly.
  final bool enablePressScale;

  /// Scale multiplier when pressed (e.g. 0.98).
  final double pressedScale;

  /// Whether hovering subtly raises card elevation and shadows.
  final bool enableHoverElevation;

  /// Depth elevation multiplier when hovered (e.g. 1.3).
  final double hoverElevationMultiplier;

  /// Whether to display a high-contrast focus ring when focused.
  final bool enableFocusRing;

  /// Accent color when focused.
  final Color? focusColor;

  /// Surface tint overlay when hovered.
  final Color? hoverColor;

  /// Surface tint overlay when selected.
  final Color? selectedColor;

  /// Border color when selected.
  final Color? selectedBorderColor;

  /// Duration for accordion expansion / collapse animations.
  final Duration expandDuration;

  /// Duration for standard state transitions (hover, press, selection).
  final Duration transitionDuration;

  /// Animation curve.
  final Curve curve;

  /// Material 4 shape morph target when hovered.
  final Material4Type? morphShapeOnHover;

  /// Material 4 shape morph target when selected.
  final Material4Type? morphShapeOnSelect;

  /// Whether to trigger subtle haptic click on supported devices.
  final bool hapticFeedback;

  const CardInteractionConfig({
    this.enablePressScale = true,
    this.pressedScale = 0.985,
    this.enableHoverElevation = true,
    this.hoverElevationMultiplier = 1.25,
    this.enableFocusRing = true,
    this.focusColor,
    this.hoverColor,
    this.selectedColor,
    this.selectedBorderColor,
    this.expandDuration = const Duration(milliseconds: 280),
    this.transitionDuration = const Duration(milliseconds: 140),
    this.curve = Curves.easeOutCubic,
    this.morphShapeOnHover,
    this.morphShapeOnSelect,
    this.hapticFeedback = true,
  });

  /// Factory: Subtle Minimal Interaction.
  factory CardInteractionConfig.subtle() {
    return const CardInteractionConfig(
      enablePressScale: true,
      pressedScale: 0.99,
      enableHoverElevation: true,
      hoverElevationMultiplier: 1.15,
    );
  }

  /// Factory: Expressive Spring Interaction.
  factory CardInteractionConfig.expressive({
    Material4Type? morphShapeOnHover,
    Material4Type? morphShapeOnSelect,
  }) {
    return CardInteractionConfig(
      enablePressScale: true,
      pressedScale: 0.975,
      enableHoverElevation: true,
      hoverElevationMultiplier: 1.4,
      curve: Curves.elasticOut,
      transitionDuration: const Duration(milliseconds: 200),
      morphShapeOnHover: morphShapeOnHover,
      morphShapeOnSelect: morphShapeOnSelect,
    );
  }

  CardInteractionConfig copyWith({
    bool? enablePressScale,
    double? pressedScale,
    bool? enableHoverElevation,
    double? hoverElevationMultiplier,
    bool? enableFocusRing,
    Color? focusColor,
    Color? hoverColor,
    Color? selectedColor,
    Color? selectedBorderColor,
    Duration? expandDuration,
    Duration? transitionDuration,
    Curve? curve,
    Material4Type? morphShapeOnHover,
    Material4Type? morphShapeOnSelect,
    bool? hapticFeedback,
  }) {
    return CardInteractionConfig(
      enablePressScale: enablePressScale ?? this.enablePressScale,
      pressedScale: pressedScale ?? this.pressedScale,
      enableHoverElevation: enableHoverElevation ?? this.enableHoverElevation,
      hoverElevationMultiplier:
          hoverElevationMultiplier ?? this.hoverElevationMultiplier,
      enableFocusRing: enableFocusRing ?? this.enableFocusRing,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      expandDuration: expandDuration ?? this.expandDuration,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      curve: curve ?? this.curve,
      morphShapeOnHover: morphShapeOnHover ?? this.morphShapeOnHover,
      morphShapeOnSelect: morphShapeOnSelect ?? this.morphShapeOnSelect,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardInteractionConfig &&
          runtimeType == other.runtimeType &&
          enablePressScale == other.enablePressScale &&
          pressedScale == other.pressedScale &&
          enableHoverElevation == other.enableHoverElevation &&
          hoverElevationMultiplier == other.hoverElevationMultiplier &&
          enableFocusRing == other.enableFocusRing &&
          focusColor == other.focusColor &&
          hoverColor == other.hoverColor &&
          selectedColor == other.selectedColor &&
          selectedBorderColor == other.selectedBorderColor &&
          expandDuration == other.expandDuration &&
          transitionDuration == other.transitionDuration &&
          curve == other.curve &&
          morphShapeOnHover == other.morphShapeOnHover &&
          morphShapeOnSelect == other.morphShapeOnSelect &&
          hapticFeedback == other.hapticFeedback;

  @override
  int get hashCode => Object.hash(
        enablePressScale,
        pressedScale,
        enableHoverElevation,
        hoverElevationMultiplier,
        enableFocusRing,
        focusColor,
        hoverColor,
        selectedColor,
        selectedBorderColor,
        expandDuration,
        transitionDuration,
        curve,
        morphShapeOnHover,
        morphShapeOnSelect,
        hapticFeedback,
      );
}
