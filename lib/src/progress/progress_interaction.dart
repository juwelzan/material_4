import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Interaction, seeking, and gesture controls for [Material4ProgressBar].
@immutable
class Material4ProgressInteraction {
  /// Whether user gesture interaction (drag and tap to seek) is enabled.
  final bool enabled;

  /// Minimum value represented by the progress bar (default 0.0).
  final double min;

  /// Maximum value represented by the progress bar (default 1.0).
  final double max;

  /// Optional discrete step increment value (e.g. 0.1 or 5.0).
  final double? step;

  /// Whether an explicit visible draggable thumb knob is rendered.
  final bool thumb;

  /// Radius of the draggable thumb knob in pixels.
  final double thumbRadius;

  /// Fill color of the draggable thumb knob.
  final Color? thumbColor;

  /// Outline border color of the draggable thumb knob.
  final Color thumbBorderColor;

  /// Outline border stroke width of the draggable thumb knob.
  final double thumbBorderWidth;

  /// Elevated drop shadow elevation under the thumb knob.
  final double thumbElevation;

  /// Whether a floating value tooltip displays during hover or active dragging.
  final bool showTooltip;

  /// Custom tooltip widget builder.
  final Widget Function(BuildContext context, double value)? tooltipBuilder;

  /// Triggered continuously as the user drags or seeks progress.
  final ValueChanged<double>? onChanged;

  /// Triggered when the user initiates a drag gesture on the progress bar.
  final ValueChanged<double>? onChangeStart;

  /// Triggered when the user releases a drag gesture.
  final ValueChanged<double>? onChangeEnd;

  /// Whether subtle haptic feedback triggers when snapping to discrete steps.
  final bool enableHapticFeedback;

  /// Creates a [Material4ProgressInteraction] configuration.
  const Material4ProgressInteraction({
    this.enabled = false,
    this.min = 0.0,
    this.max = 1.0,
    this.step,
    this.thumb = true,
    this.thumbRadius = 8.0,
    this.thumbColor,
    this.thumbBorderColor = Colors.white,
    this.thumbBorderWidth = 2.0,
    this.thumbElevation = 3.0,
    this.showTooltip = true,
    this.tooltipBuilder,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.enableHapticFeedback = true,
  }) : assert(max > min, 'max must be strictly greater than min');

  /// Quantizes [rawValue] to the nearest [step] within [min] and [max].
  double quantize(double rawValue) {
    final clamped = rawValue.clamp(min, max);
    if (step == null || step! <= 0) return clamped;
    final steps = ((clamped - min) / step!).round();
    final quantized = min + (steps * step!);
    return quantized.clamp(min, max);
  }

  /// Normalizes a logical value [val] into a 0.0 to 1.0 ratio.
  double normalize(double val) {
    if (max == min) return 0.0;
    return ((val - min) / (max - min)).clamp(0.0, 1.0);
  }

  /// Denormalizes a 0.0 to 1.0 ratio into logical range [min] to [max].
  double denormalize(double ratio) {
    return min + (ratio.clamp(0.0, 1.0) * (max - min));
  }

  /// Triggers a subtle tactile haptic vibration if enabled.
  void triggerHaptic() {
    if (enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
  }

  /// Creates a copy of this interaction configuration with modified parameters.
  Material4ProgressInteraction copyWith({
    bool? enabled,
    double? min,
    double? max,
    double? step,
    bool? thumb,
    double? thumbRadius,
    Color? thumbColor,
    Color? thumbBorderColor,
    double? thumbBorderWidth,
    double? thumbElevation,
    bool? showTooltip,
    Widget Function(BuildContext context, double value)? tooltipBuilder,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    bool? enableHapticFeedback,
  }) {
    return Material4ProgressInteraction(
      enabled: enabled ?? this.enabled,
      min: min ?? this.min,
      max: max ?? this.max,
      step: step ?? this.step,
      thumb: thumb ?? this.thumb,
      thumbRadius: thumbRadius ?? this.thumbRadius,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbBorderColor: thumbBorderColor ?? this.thumbBorderColor,
      thumbBorderWidth: thumbBorderWidth ?? this.thumbBorderWidth,
      thumbElevation: thumbElevation ?? this.thumbElevation,
      showTooltip: showTooltip ?? this.showTooltip,
      tooltipBuilder: tooltipBuilder ?? this.tooltipBuilder,
      onChanged: onChanged ?? this.onChanged,
      onChangeStart: onChangeStart ?? this.onChangeStart,
      onChangeEnd: onChangeEnd ?? this.onChangeEnd,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }
}
