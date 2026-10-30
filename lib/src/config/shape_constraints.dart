import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'shape_corners.dart';
import 'shape_edge_config.dart';
import 'shape_notch.dart';

/// Diagnostics for shape constraint boundary and accessibility violations.
@immutable
class ShapeConstraintViolation {
  /// Category identifier for this violation.
  final String category;

  /// Specific diagnostic message explaining the constraint breach.
  final String message;

  /// Constructs a [ShapeConstraintViolation].
  const ShapeConstraintViolation({
    required this.category,
    required this.message,
  });

  @override
  String toString() => 'ShapeConstraintViolation($category: $message)';
}

/// Evaluation report detailing constraint checks and safe geometry dimensions.
@immutable
class ShapeConstraintReport {
  /// Requested size input to the evaluation.
  final Size requestedSize;

  /// Safe clamped size that fulfills all dimension constraints without silent distortion.
  final Size safeSize;

  /// Whether all geometric and accessibility constraints are fully satisfied.
  final bool isSatisfied;

  /// List of constraint or accessibility violations detected during evaluation.
  final List<ShapeConstraintViolation> violations;

  /// Constructs a [ShapeConstraintReport].
  const ShapeConstraintReport({
    required this.requestedSize,
    required this.safeSize,
    required this.isSatisfied,
    required this.violations,
  });

  /// Whether any constraint violations were identified.
  bool get hasViolations => violations.isNotEmpty;
}

/// Immutable geometric and accessibility boundary constraints for Material 4 shapes.
///
/// Separates layout constraints from visual painting constraints. Touch-target
/// enforcement (WCAG 48×48 dp) is surfaced as a non-destructive diagnostic report
/// rather than silently mutating visual dimensions.
@immutable
class ShapeConstraints {
  /// Minimum allowable width in logical pixels.
  final double minWidth;

  /// Minimum allowable height in logical pixels.
  final double minHeight;

  /// Maximum allowable width in logical pixels.
  final double maxWidth;

  /// Maximum allowable height in logical pixels.
  final double maxHeight;

  /// Minimum allowable corner radius.
  final double minCornerRadius;

  /// Maximum allowable corner radius (or null for unbounded).
  final double? maxCornerRadius;

  /// Maximum notch depth expressed as a ratio of the perpendicular container dimension.
  /// (Default is 0.5, meaning notches cannot exceed 50% of perpendicular depth).
  final double maxNotchDepthRatio;

  /// Whether to validate touch-target accessibility according to WCAG 2.1 (min 48×48 dp).
  final bool enforceTouchTarget;

  /// Standard default shape constraints.
  const ShapeConstraints({
    this.minWidth = 4.0,
    this.minHeight = 4.0,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    this.minCornerRadius = 0.0,
    this.maxCornerRadius,
    this.maxNotchDepthRatio = 0.5,
    this.enforceTouchTarget = false,
  });

  /// Unconstrained configuration.
  static const ShapeConstraints none = ShapeConstraints(
    minWidth: 0.0,
    minHeight: 0.0,
    maxWidth: double.infinity,
    maxHeight: double.infinity,
    maxNotchDepthRatio: 1.0,
  );

  /// Strict WCAG 2.1 accessible touch-target constraint (min 48x48 dp).
  static const ShapeConstraints accessible = ShapeConstraints(
    minWidth: 48.0,
    minHeight: 48.0,
    enforceTouchTarget: true,
  );

  /// Evaluates whether [size] satisfies touch-target guidelines (min 48x48 dp).
  bool isTouchTargetSatisfied(Size size) {
    return size.width >= 48.0 && size.height >= 48.0;
  }

  /// Clamps [size] within [minWidth], [minHeight], [maxWidth], [maxHeight].
  ///
  /// Visual painting calculations can use this clamped size while layout diagnostics
  /// report the modification through [evaluate].
  Size clampSize(Size size) {
    final w = size.width.clamp(minWidth, maxWidth);
    final h = size.height.clamp(minHeight, maxHeight);
    return Size(w, h);
  }

  /// Evaluates the given [requestedSize], [corners], and [notches] against these constraints,
  /// reporting all violations deterministically without silent modifications.
  ShapeConstraintReport evaluate({
    required Size requestedSize,
    ShapeCorners corners = ShapeCorners.zero,
    List<ShapeNotch> notches = const [],
  }) {
    final violations = <ShapeConstraintViolation>[];
    final safeSize = clampSize(requestedSize);

    // Dimension bounds checks
    if (requestedSize.width < minWidth) {
      violations.add(
        ShapeConstraintViolation(
          category: 'minWidth',
          message:
              'Width (${requestedSize.width}) is below minWidth ($minWidth).',
        ),
      );
    }
    if (requestedSize.width > maxWidth) {
      violations.add(
        ShapeConstraintViolation(
          category: 'maxWidth',
          message:
              'Width (${requestedSize.width}) exceeds maxWidth ($maxWidth).',
        ),
      );
    }
    if (requestedSize.height < minHeight) {
      violations.add(
        ShapeConstraintViolation(
          category: 'minHeight',
          message:
              'Height (${requestedSize.height}) is below minHeight ($minHeight).',
        ),
      );
    }
    if (requestedSize.height > maxHeight) {
      violations.add(
        ShapeConstraintViolation(
          category: 'maxHeight',
          message:
              'Height (${requestedSize.height}) exceeds maxHeight ($maxHeight).',
        ),
      );
    }

    // Touch target accessibility check
    if (enforceTouchTarget && !isTouchTargetSatisfied(requestedSize)) {
      violations.add(
        ShapeConstraintViolation(
          category: 'touchTarget',
          message:
              'Dimensions (${requestedSize.width}x${requestedSize.height}) are below the 48x48 dp WCAG minimum.',
        ),
      );
    }

    // Corner radius constraint checks
    if (maxCornerRadius != null) {
      final radii = [
        corners.topLeft.x,
        corners.topLeft.y,
        corners.topRight.x,
        corners.topRight.y,
        corners.bottomLeft.x,
        corners.bottomLeft.y,
        corners.bottomRight.x,
        corners.bottomRight.y,
      ];
      if (radii.any((r) => r > maxCornerRadius!)) {
        violations.add(
          ShapeConstraintViolation(
            category: 'maxCornerRadius',
            message:
                'Corner radius exceeds maxCornerRadius ($maxCornerRadius).',
          ),
        );
      }
    }

    // Notch depth constraint checks (relative to perpendicular container dimension)
    for (final notch in notches) {
      final isHorizontal =
          notch.edge == ShapeEdge.top || notch.edge == ShapeEdge.bottom;
      final perpDim = isHorizontal ? safeSize.height : safeSize.width;
      final maxAllowedDepth = perpDim * maxNotchDepthRatio;

      if (notch.depth > maxAllowedDepth) {
        violations.add(
          ShapeConstraintViolation(
            category: 'maxNotchDepthRatio',
            message:
                'Notch depth (${notch.depth}) exceeds ${maxNotchDepthRatio * 100}% of perpendicular dimension ($maxAllowedDepth).',
          ),
        );
      }
    }

    return ShapeConstraintReport(
      requestedSize: requestedSize,
      safeSize: safeSize,
      isSatisfied: violations.isEmpty,
      violations: violations,
    );
  }

  /// Creates a copy with the given fields replaced.
  ShapeConstraints copyWith({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    double? minCornerRadius,
    double? maxCornerRadius,
    double? maxNotchDepthRatio,
    bool? enforceTouchTarget,
  }) {
    return ShapeConstraints(
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      minCornerRadius: minCornerRadius ?? this.minCornerRadius,
      maxCornerRadius: maxCornerRadius ?? this.maxCornerRadius,
      maxNotchDepthRatio: maxNotchDepthRatio ?? this.maxNotchDepthRatio,
      enforceTouchTarget: enforceTouchTarget ?? this.enforceTouchTarget,
    );
  }

  /// Converts this [ShapeConstraints] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'minWidth': minWidth,
        'minHeight': minHeight,
        'maxWidth': maxWidth.isFinite ? maxWidth : null,
        'maxHeight': maxHeight.isFinite ? maxHeight : null,
        'minCornerRadius': minCornerRadius,
        'maxCornerRadius': maxCornerRadius,
        'maxNotchDepthRatio': maxNotchDepthRatio,
        'enforceTouchTarget': enforceTouchTarget,
      };

  /// Constructs a [ShapeConstraints] from serialized JSON data.
  factory ShapeConstraints.fromJson(Map<String, dynamic> json) {
    return ShapeConstraints(
      minWidth: (json['minWidth'] as num?)?.toDouble() ?? 4.0,
      minHeight: (json['minHeight'] as num?)?.toDouble() ?? 4.0,
      maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? double.infinity,
      maxHeight: (json['maxHeight'] as num?)?.toDouble() ?? double.infinity,
      minCornerRadius: (json['minCornerRadius'] as num?)?.toDouble() ?? 0.0,
      maxCornerRadius: (json['maxCornerRadius'] as num?)?.toDouble(),
      maxNotchDepthRatio:
          (json['maxNotchDepthRatio'] as num?)?.toDouble() ?? 0.5,
      enforceTouchTarget: json['enforceTouchTarget'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeConstraints &&
          runtimeType == other.runtimeType &&
          minWidth == other.minWidth &&
          minHeight == other.minHeight &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          minCornerRadius == other.minCornerRadius &&
          maxCornerRadius == other.maxCornerRadius &&
          maxNotchDepthRatio == other.maxNotchDepthRatio &&
          enforceTouchTarget == other.enforceTouchTarget;

  @override
  int get hashCode => Object.hash(
        minWidth,
        minHeight,
        maxWidth,
        maxHeight,
        minCornerRadius,
        maxCornerRadius,
        maxNotchDepthRatio,
        enforceTouchTarget,
      );
}
