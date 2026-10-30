import 'package:flutter/material.dart';

/// Alignment placement position for progress labels and content.
enum ProgressLabelPosition {
  /// Centered inside the progress track container.
  insideCenter,

  /// Anchored to the trailing end of the filled region inside the track.
  insideTrailing,

  /// Placed immediately to the left (leading) of the progress bar in a row.
  outsideLeading,

  /// Placed immediately to the right (trailing) of the progress bar in a row.
  outsideTrailing,

  /// Placed above the progress bar aligned to the start/left.
  aboveStart,

  /// Placed above the progress bar aligned to the center.
  aboveCenter,

  /// Placed above the progress bar aligned to the end/right.
  aboveEnd,

  /// Placed below the progress bar aligned to the start/left.
  belowStart,

  /// Placed below the progress bar aligned to the center.
  belowCenter,

  /// Placed below the progress bar aligned to the end/right.
  belowEnd,

  /// Placed directly in the center of circular or organic progress rings.
  center,

  /// Floats right above or follows the moving thumb/fill threshold.
  followThumb,
}

/// Comprehensive content, label, and typography configuration for [Material4ProgressBar].
@immutable
class Material4ProgressLabel {
  /// Whether to format and display the progress percentage automatically.
  final bool showPercentage;

  /// Number of decimal places when rendering percentage (default 0, e.g. "75%").
  final int percentageDecimals;

  /// String prefix before percentage (default empty).
  final String percentagePrefix;

  /// String suffix after percentage (default "%").
  final String percentageSuffix;

  /// Explicit current value counter (e.g. 650).
  final double? currentValue;

  /// Explicit total maximum value counter (e.g. 1000).
  final double? totalValue;

  /// Unit description string (e.g. "MB", "GB", "files", "items").
  final String? valueUnit;

  /// Static or custom status text description (e.g. "Downloading...", "Synchronizing").
  final String? customText;

  /// Estimated or remaining time formatted description (e.g. "2m 14s remaining").
  final String? remainingTime;

  /// [TextStyle] applied to the label text.
  final TextStyle? style;

  /// Placement anchor of the label relative to the progress bar.
  final ProgressLabelPosition position;

  /// Optional custom leading widget displayed alongside the progress bar.
  final Widget? leading;

  /// Optional custom trailing widget displayed alongside the progress bar.
  final Widget? trailing;

  /// Optional center widget rendered inside circular or ring indicators.
  final Widget? center;

  /// Custom dynamic label builder returning a widget given the current [value].
  final Widget Function(BuildContext context, double value)? builder;

  /// Creates a [Material4ProgressLabel] configuration.
  const Material4ProgressLabel({
    this.showPercentage = false,
    this.percentageDecimals = 0,
    this.percentagePrefix = '',
    this.percentageSuffix = '%',
    this.currentValue,
    this.totalValue,
    this.valueUnit,
    this.customText,
    this.remainingTime,
    this.style,
    this.position = ProgressLabelPosition.outsideTrailing,
    this.leading,
    this.trailing,
    this.center,
    this.builder,
  });

  /// Standard percentage display placed on the trailing edge.
  static const Material4ProgressLabel percentage = Material4ProgressLabel(
    showPercentage: true,
    position: ProgressLabelPosition.outsideTrailing,
  );

  /// Standard percentage display placed in the center of circular rings.
  static const Material4ProgressLabel circularCenter = Material4ProgressLabel(
    showPercentage: true,
    position: ProgressLabelPosition.center,
    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
  );

  /// Status description placed above the progress bar with percentage trailing.
  factory Material4ProgressLabel.header({
    required String title,
    bool showPercentage = true,
    TextStyle? style,
  }) {
    return Material4ProgressLabel(
      customText: title,
      showPercentage: showPercentage,
      position: ProgressLabelPosition.aboveStart,
      style: style ?? const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    );
  }

  /// Formats the formatted percentage string for a normalized value (0.0 to 1.0).
  String formatPercentage(double value) {
    final pct = (value * 100.0).clamp(0.0, 100.0);
    final formatted = pct.toStringAsFixed(percentageDecimals);
    return '$percentagePrefix$formatted$percentageSuffix';
  }

  /// Formats the current and total values (e.g. "650 MB / 1000 MB" or "24 of 100 files").
  String? formatValues() {
    if (currentValue == null || totalValue == null) return null;
    final unitStr = valueUnit != null ? ' $valueUnit' : '';
    final currStr = currentValue! % 1 == 0
        ? currentValue!.toInt().toString()
        : currentValue!.toStringAsFixed(1);
    final totStr = totalValue! % 1 == 0
        ? totalValue!.toInt().toString()
        : totalValue!.toStringAsFixed(1);
    return '$currStr$unitStr / $totStr$unitStr';
  }

  /// Creates a copy of this label configuration with modified parameters.
  Material4ProgressLabel copyWith({
    bool? showPercentage,
    int? percentageDecimals,
    String? percentagePrefix,
    String? percentageSuffix,
    double? currentValue,
    double? totalValue,
    String? valueUnit,
    String? customText,
    String? remainingTime,
    TextStyle? style,
    ProgressLabelPosition? position,
    Widget? leading,
    Widget? trailing,
    Widget? center,
    Widget Function(BuildContext context, double value)? builder,
  }) {
    return Material4ProgressLabel(
      showPercentage: showPercentage ?? this.showPercentage,
      percentageDecimals: percentageDecimals ?? this.percentageDecimals,
      percentagePrefix: percentagePrefix ?? this.percentagePrefix,
      percentageSuffix: percentageSuffix ?? this.percentageSuffix,
      currentValue: currentValue ?? this.currentValue,
      totalValue: totalValue ?? this.totalValue,
      valueUnit: valueUnit ?? this.valueUnit,
      customText: customText ?? this.customText,
      remainingTime: remainingTime ?? this.remainingTime,
      style: style ?? this.style,
      position: position ?? this.position,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      center: center ?? this.center,
      builder: builder ?? this.builder,
    );
  }
}
