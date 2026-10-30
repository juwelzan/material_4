import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Immutable specification for the four corner radii of a dynamic shape contour.
///
/// Supports independent circular and elliptical radii for all four corners,
/// along with standard CSS-style proportional radius down-scaling to prevent
/// overlapping or self-intersecting corner arcs.
@immutable
class ShapeCorners {
  /// The radius of the top-left corner.
  final Radius topLeft;

  /// The radius of the top-right corner.
  final Radius topRight;

  /// The radius of the bottom-left corner.
  final Radius bottomLeft;

  /// The radius of the bottom-right corner.
  final Radius bottomRight;

  /// Constructs a [ShapeCorners] with explicit radii for each corner.
  const ShapeCorners({
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
  });

  /// Constructs a [ShapeCorners] where all corners have identical [radius].
  const ShapeCorners.all(Radius radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  /// Constructs a [ShapeCorners] where all corners have identical circular [radius].
  ShapeCorners.circular(double radius)
      : topLeft = Radius.circular(radius),
        topRight = Radius.circular(radius),
        bottomLeft = Radius.circular(radius),
        bottomRight = Radius.circular(radius);

  /// Constructs a [ShapeCorners] where all corners have identical elliptical radii ([x], [y]).
  ShapeCorners.elliptical(double x, double y)
      : topLeft = Radius.elliptical(x, y),
        topRight = Radius.elliptical(x, y),
        bottomLeft = Radius.elliptical(x, y),
        bottomRight = Radius.elliptical(x, y);

  /// Constructs a [ShapeCorners] with only specified non-zero corners.
  const ShapeCorners.only({
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
  });

  /// Constructs a [ShapeCorners] by converting a legacy [CornerRadii] object.
  ShapeCorners.fromCornerRadii(CornerRadii radii)
      : topLeft = Radius.circular(radii.topLeft),
        topRight = Radius.circular(radii.topRight),
        bottomLeft = Radius.circular(radii.bottomLeft),
        bottomRight = Radius.circular(radii.bottomRight);

  /// Converts this [ShapeCorners] to a legacy [CornerRadii] object.
  CornerRadii toCornerRadii() => CornerRadii(
        topLeft: topLeft.x,
        topRight: topRight.x,
        bottomLeft: bottomLeft.x,
        bottomRight: bottomRight.x,
      );

  /// Asymmetric default aesthetic preset.
  const ShapeCorners.asymmetric({
    this.topLeft = const Radius.circular(32.0),
    this.topRight = const Radius.circular(8.0),
    this.bottomRight = const Radius.circular(24.0),
    this.bottomLeft = const Radius.circular(4.0),
  });

  /// Zero radius on all four corners.
  static const ShapeCorners zero = ShapeCorners();

  /// Whether all corner radii are zero.
  bool get isZero =>
      topLeft == Radius.zero &&
      topRight == Radius.zero &&
      bottomLeft == Radius.zero &&
      bottomRight == Radius.zero;

  /// Whether any corner radius contains negative or non-finite values.
  bool get hasInvalidValues =>
      _isInvalidRadius(topLeft) ||
      _isInvalidRadius(topRight) ||
      _isInvalidRadius(bottomLeft) ||
      _isInvalidRadius(bottomRight);

  static bool _isInvalidRadius(Radius r) {
    return r.x.isNaN ||
        r.x.isInfinite ||
        r.x < 0 ||
        r.y.isNaN ||
        r.y.isInfinite ||
        r.y < 0;
  }

  /// Validates whether the corner radii comfortably fit within [size]
  /// without requiring proportional scaling.
  bool isSatisfiedBy(Size size) {
    if (size.width <= 0 || size.height <= 0 || hasInvalidValues) return false;
    final topSum = topLeft.x + topRight.x;
    final bottomSum = bottomLeft.x + bottomRight.x;
    final leftSum = topLeft.y + bottomLeft.y;
    final rightSum = topRight.y + bottomRight.y;

    return topSum <= size.width &&
        bottomSum <= size.width &&
        leftSum <= size.height &&
        rightSum <= size.height;
  }

  /// Sanitizes geometry for [size] using standard CSS-style proportional radius scaling.
  ///
  /// Preserves the original configuration values on this instance; geometry sanitization
  /// is calculated as a clean, non-mutating transformation:
  /// 1. Clamps any negative, NaN, or infinite radii to 0.0.
  /// 2. If the sum of adjacent radii exceeds container dimensions along any axis,
  ///    calculates scaling factor `f = min(1.0, W / (r_tl.x + r_tr.x), ...)`
  ///    and scales all radii proportionally.
  ShapeCorners sanitize(Size size) {
    if (size.width <= 0 ||
        size.height <= 0 ||
        size.width.isNaN ||
        size.height.isNaN ||
        size.width.isInfinite ||
        size.height.isInfinite) {
      return ShapeCorners.zero;
    }

    Radius clean(Radius r) {
      final x = (r.x.isNaN || r.x.isInfinite || r.x < 0) ? 0.0 : r.x;
      final y = (r.y.isNaN || r.y.isInfinite || r.y < 0) ? 0.0 : r.y;
      return Radius.elliptical(x, y);
    }

    final tl = clean(topLeft);
    final tr = clean(topRight);
    final bl = clean(bottomLeft);
    final br = clean(bottomRight);

    double factor = 1.0;

    // Horizontal top constraint
    final topSum = tl.x + tr.x;
    if (topSum > size.width && topSum > 0) {
      factor = math.min(factor, size.width / topSum);
    }

    // Horizontal bottom constraint
    final bottomSum = bl.x + br.x;
    if (bottomSum > size.width && bottomSum > 0) {
      factor = math.min(factor, size.width / bottomSum);
    }

    // Vertical left constraint
    final leftSum = tl.y + bl.y;
    if (leftSum > size.height && leftSum > 0) {
      factor = math.min(factor, size.height / leftSum);
    }

    // Vertical right constraint
    final rightSum = tr.y + br.y;
    if (rightSum > size.height && rightSum > 0) {
      factor = math.min(factor, size.height / rightSum);
    }

    if (factor < 1.0) {
      return ShapeCorners(
        topLeft: Radius.elliptical(tl.x * factor, tl.y * factor),
        topRight: Radius.elliptical(tr.x * factor, tr.y * factor),
        bottomLeft: Radius.elliptical(bl.x * factor, bl.y * factor),
        bottomRight: Radius.elliptical(br.x * factor, br.y * factor),
      );
    }

    return ShapeCorners(
      topLeft: tl,
      topRight: tr,
      bottomLeft: bl,
      bottomRight: br,
    );
  }

  /// Converts these corners to a Flutter [RRect] bounding the given [rect].
  RRect toRRect(Rect rect) {
    return RRect.fromRectAndCorners(
      rect,
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  /// Creates a copy with the given fields replaced by the new values.
  ShapeCorners copyWith({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return ShapeCorners(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }

  /// Converts this [ShapeCorners] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'topLeft': {'x': topLeft.x, 'y': topLeft.y},
        'topRight': {'x': topRight.x, 'y': topRight.y},
        'bottomLeft': {'x': bottomLeft.x, 'y': bottomLeft.y},
        'bottomRight': {'x': bottomRight.x, 'y': bottomRight.y},
      };

  /// Constructs a [ShapeCorners] from serialized JSON data.
  factory ShapeCorners.fromJson(Map<String, dynamic> json) {
    Radius parseRadius(dynamic v) {
      if (v is Map) {
        final x = (v['x'] as num?)?.toDouble() ?? 0.0;
        final y = (v['y'] as num?)?.toDouble() ?? 0.0;
        return Radius.elliptical(x, y);
      } else if (v is num) {
        return Radius.circular(v.toDouble());
      }
      return Radius.zero;
    }

    return ShapeCorners(
      topLeft: parseRadius(json['topLeft']),
      topRight: parseRadius(json['topRight']),
      bottomLeft: parseRadius(json['bottomLeft']),
      bottomRight: parseRadius(json['bottomRight']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeCorners &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);

  @override
  String toString() =>
      'ShapeCorners(tl: $topLeft, tr: $topRight, bl: $bottomLeft, br: $bottomRight)';

  /// Linearly interpolates between two [ShapeCorners] specifications.
  static ShapeCorners lerp(ShapeCorners? a, ShapeCorners? b, double t) {
    if (a == null && b == null) return ShapeCorners.zero;
    if (a == null) return b!;
    if (b == null) return a;
    if (identical(a, b)) return a;

    Radius lerpRad(Radius r1, Radius r2) {
      final x = r1.x + (r2.x - r1.x) * t;
      final y = r1.y + (r2.y - r1.y) * t;
      return Radius.elliptical(
        x.clamp(0.0, double.infinity),
        y.clamp(0.0, double.infinity),
      );
    }

    return ShapeCorners(
      topLeft: lerpRad(a.topLeft, b.topLeft),
      topRight: lerpRad(a.topRight, b.topRight),
      bottomRight: lerpRad(a.bottomRight, b.bottomRight),
      bottomLeft: lerpRad(a.bottomLeft, b.bottomLeft),
    );
  }
}

/// Legacy independent corner radii specification for four distinct corners.
///
/// Preserved for 100% backward compatibility with existing tests and presets.
@immutable
class CornerRadii {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const CornerRadii({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
  });

  const CornerRadii.all(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  const CornerRadii.only({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
  });

  const CornerRadii.asymmetric({
    this.topLeft = 32.0,
    this.topRight = 8.0,
    this.bottomRight = 24.0,
    this.bottomLeft = 4.0,
  });

  /// Converts this [CornerRadii] to modern [ShapeCorners].
  ShapeCorners toShapeCorners() => ShapeCorners(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );

  CornerRadii copyWith({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return CornerRadii(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CornerRadii &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);

  Map<String, dynamic> toJson() => {
        'topLeft': topLeft,
        'topRight': topRight,
        'bottomLeft': bottomLeft,
        'bottomRight': bottomRight,
      };

  factory CornerRadii.fromJson(Map<String, dynamic> json) => CornerRadii(
        topLeft: (json['topLeft'] as num?)?.toDouble() ?? 0.0,
        topRight: (json['topRight'] as num?)?.toDouble() ?? 0.0,
        bottomLeft: (json['bottomLeft'] as num?)?.toDouble() ?? 0.0,
        bottomRight: (json['bottomRight'] as num?)?.toDouble() ?? 0.0,
      );
}
