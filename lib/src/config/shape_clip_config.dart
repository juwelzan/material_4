import 'package:flutter/foundation.dart';

/// Independent, granular clipping configuration for dynamic shapes.
///
/// Allows fine-grained control over which visual layers of the dynamic shape
/// container are clipped to the shape path contour versus allowed to overflow naturally.
@immutable
class ShapeClipConfig {
  /// Whether to clip the shape background/fill to the shape path contour.
  final bool clipBackground;

  /// Whether to clip child widget(s) to the shape path contour.
  final bool clipChildren;

  /// Whether to clip shape borders to the shape path contour.
  final bool clipBorder;

  /// Whether to clip drop shadows to the shape path contour.
  ///
  /// Defaults to `false` so outer drop shadows remain fully visible.
  final bool clipShadows;

  /// Whether to clip foreground decorations (such as shimmer sweeps) to the shape contour.
  final bool clipForeground;

  /// Whether to clip visual overflow that extends beyond the RenderBox rectangular bounds.
  final bool clipOverflow;

  const ShapeClipConfig({
    this.clipBackground = true,
    this.clipChildren = false,
    this.clipBorder = false,
    this.clipShadows = false,
    this.clipForeground = false,
    this.clipOverflow = false,
  });

  /// Standard default clipping configuration:
  /// Background is clipped to shape contour; children and shadows can overflow safely.
  static const ShapeClipConfig standard = ShapeClipConfig();

  /// Preset where children and overflow are strictly clipped to the shape contour.
  static const ShapeClipConfig clipAllChildren = ShapeClipConfig(
    clipBackground: true,
    clipChildren: true,
    clipBorder: false,
    clipShadows: false,
    clipForeground: false,
    clipOverflow: true,
  );

  /// Preset where no clipping is applied, allowing complete natural visual overflow.
  static const ShapeClipConfig unclipped = ShapeClipConfig(
    clipBackground: false,
    clipChildren: false,
    clipBorder: false,
    clipShadows: false,
    clipForeground: false,
    clipOverflow: false,
  );

  /// Creates a copy of this [ShapeClipConfig] with the given fields replaced.
  ShapeClipConfig copyWith({
    bool? clipBackground,
    bool? clipChildren,
    bool? clipBorder,
    bool? clipShadows,
    bool? clipForeground,
    bool? clipOverflow,
  }) {
    return ShapeClipConfig(
      clipBackground: clipBackground ?? this.clipBackground,
      clipChildren: clipChildren ?? this.clipChildren,
      clipBorder: clipBorder ?? this.clipBorder,
      clipShadows: clipShadows ?? this.clipShadows,
      clipForeground: clipForeground ?? this.clipForeground,
      clipOverflow: clipOverflow ?? this.clipOverflow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapeClipConfig &&
        other.clipBackground == clipBackground &&
        other.clipChildren == clipChildren &&
        other.clipBorder == clipBorder &&
        other.clipShadows == clipShadows &&
        other.clipForeground == clipForeground &&
        other.clipOverflow == clipOverflow;
  }

  @override
  int get hashCode => Object.hash(
        clipBackground,
        clipChildren,
        clipBorder,
        clipShadows,
        clipForeground,
        clipOverflow,
      );

  @override
  String toString() => 'ShapeClipConfig('
      'clipBackground: $clipBackground, '
      'clipChildren: $clipChildren, '
      'clipBorder: $clipBorder, '
      'clipShadows: $clipShadows, '
      'clipForeground: $clipForeground, '
      'clipOverflow: $clipOverflow)';
}

