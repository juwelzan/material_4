import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Immutable geometric transformation configuration for dynamic shapes.
///
/// ### Transformation Composition Order:
/// 1. **Pivot Translation**: Moves shape coordinate space to the designated [origin]
///    plus any directional [stretchOffset].
/// 2. **Scaling**: Scales along X and Y axes ([scaleX], [scaleY]).
/// 3. **Skewing (Shear)**: Applies planar shear deformation ([skewX], [skewY]).
/// 4. **Rotation**: Rotates by [rotation] radians around the designated origin.
/// 5. **Inverse Pivot Translation**: Returns origin back to container coordinate frame.
///
/// Both rendering (painting custom shapes) and hit-testing (clipping and touch evaluation)
/// share this exact transformation matrix to guarantee 100% geometric consistency.
@immutable
class ShapeTransform {
  /// Rotation angle in radians.
  final double rotation;

  /// Horizontal scale multiplier (1.0 = 100%).
  final double scaleX;

  /// Vertical scale multiplier (1.0 = 100%).
  final double scaleY;

  /// Shear angle in X axis in radians.
  final double skewX;

  /// Shear angle in Y axis in radians.
  final double skewY;

  /// Directional stretch distortion offset in pixels.
  final Offset stretchOffset;

  /// Normalized transformation pivot point relative to container dimensions.
  /// Default is `Alignment.center` (middle of container).
  final Alignment origin;

  /// Optional target aspect ratio constraint (width / height).
  /// Kept separate from geometric transform matrix calculations.
  final double? targetAspectRatio;

  /// Default identity transformation (no change).
  const ShapeTransform({
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.skewX = 0.0,
    this.skewY = 0.0,
    this.stretchOffset = Offset.zero,
    this.origin = Alignment.center,
    this.targetAspectRatio,
  });

  /// Constructs a [ShapeTransform] with rotation specified in [degrees].
  // ignore: prefer_const_constructors_in_immutables
  ShapeTransform.degrees({
    double degrees = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double skewX = 0.0,
    double skewY = 0.0,
    Offset stretchOffset = Offset.zero,
    Alignment origin = Alignment.center,
    double? targetAspectRatio,
  }) : this(
          rotation: degrees * math.pi / 180.0,
          scaleX: scaleX,
          scaleY: scaleY,
          skewX: skewX,
          skewY: skewY,
          stretchOffset: stretchOffset,
          origin: origin,
          targetAspectRatio: targetAspectRatio,
        );

  /// Identity transform constant.
  static const ShapeTransform identity = ShapeTransform();

  /// Rotation expressed in degrees.
  double get rotationDegrees => rotation * 180.0 / math.pi;

  /// Whether this transformation differs from the default identity matrix.
  bool get hasTransform =>
      rotation != 0.0 ||
      scaleX != 1.0 ||
      scaleY != 1.0 ||
      skewX != 0.0 ||
      skewY != 0.0 ||
      stretchOffset != Offset.zero;

  /// Validates whether all transform properties are finite numbers.
  bool get isFinite =>
      rotation.isFinite &&
      scaleX.isFinite &&
      scaleY.isFinite &&
      skewX.isFinite &&
      skewY.isFinite &&
      stretchOffset.dx.isFinite &&
      stretchOffset.dy.isFinite &&
      (targetAspectRatio == null || targetAspectRatio!.isFinite);

  /// Validates whether scale factors are non-zero.
  bool get hasNonZeroScale => scaleX.abs() > 1e-9 && scaleY.abs() > 1e-9;

  /// Applies target aspect ratio constraints (if defined) to [size] without altering transforms.
  Size applyAspectRatio(Size size) {
    if (targetAspectRatio == null || targetAspectRatio! <= 0) return size;
    final currentRatio = size.width / size.height;
    if (currentRatio > targetAspectRatio!) {
      return Size(size.height * targetAspectRatio!, size.height);
    } else {
      return Size(size.width, size.width / targetAspectRatio!);
    }
  }

  /// Calculates the 4x4 matrix representing this geometric transformation.
  vm.Matrix4 toMatrix4(Size size) {
    if (!hasTransform) return vm.Matrix4.identity();

    final pivotX = size.width * (origin.x + 1.0) / 2.0;
    final pivotY = size.height * (origin.y + 1.0) / 2.0;

    // Composition order: Translate to Origin -> Scale -> Skew -> Rotate -> Translate back
    final matrix = vm.Matrix4.identity()
      ..translateByDouble(
          pivotX + stretchOffset.dx, pivotY + stretchOffset.dy, 0.0, 1.0)
      ..rotateZ(rotation)
      ..setEntry(0, 1, math.tan(skewX)) // Skew X
      ..setEntry(1, 0, math.tan(skewY)) // Skew Y
      ..scaleByDouble(scaleX, scaleY, 1.0, 1.0)
      ..translateByDouble(-pivotX, -pivotY, 0.0, 1.0);

    return matrix;
  }

  /// Transforms a given [path] according to this configuration.
  Path apply(Path path, Size size) {
    if (!hasTransform || size.width <= 0 || size.height <= 0) return path;
    final matrix = toMatrix4(size);
    return path.transform(matrix.storage);
  }

  /// Attempts to calculate the inverted 4x4 matrix for [size].
  ///
  /// Returns `null` if the matrix is singular (e.g. zero scale) or non-invertible.
  vm.Matrix4? tryInvert(Size size) {
    if (!hasTransform) return vm.Matrix4.identity();
    if (size.width <= 0 || size.height <= 0 || !isFinite) return null;
    final matrix = toMatrix4(size);
    final det = matrix.determinant();
    if (det.abs() < 1e-9 || det.isNaN || det.isInfinite) return null;
    try {
      return vm.Matrix4.inverted(matrix);
    } catch (_) {
      return null;
    }
  }

  /// Transforms a point between container coordinate space and local shape space.
  ///
  /// When [inverse] is true, maps a container touch point into local shape space.
  /// When [inverse] is false, maps a local shape coordinate into container space.
  Offset? tryTransformPoint(Offset point, Size size, {bool inverse = true}) {
    if (!hasTransform) return point;
    if (point.dx.isNaN ||
        point.dy.isNaN ||
        point.dx.isInfinite ||
        point.dy.isInfinite) {
      return null;
    }

    final matrix = inverse ? tryInvert(size) : toMatrix4(size);
    if (matrix == null) return null;

    final vec = matrix.transform3(vm.Vector3(point.dx, point.dy, 0.0));
    if (vec.x.isNaN ||
        vec.y.isNaN ||
        vec.x.isInfinite ||
        vec.y.isInfinite) {
      return null;
    }
    return Offset(vec.x, vec.y);
  }

  /// Transforms a touch point [point] from container space into local shape space
  /// for exact hit-testing consistency with rendering.
  Offset transformPointForHitTest(Offset point, Size size) {
    if (!hasTransform) return point;
    final transformed = tryTransformPoint(point, size, inverse: true);
    return transformed ?? point;
  }

  /// Creates a copy with the given fields replaced.
  ShapeTransform copyWith({
    double? rotation,
    double? scaleX,
    double? scaleY,
    double? skewX,
    double? skewY,
    Offset? stretchOffset,
    Alignment? origin,
    double? targetAspectRatio,
  }) {
    return ShapeTransform(
      rotation: rotation ?? this.rotation,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      skewX: skewX ?? this.skewX,
      skewY: skewY ?? this.skewY,
      stretchOffset: stretchOffset ?? this.stretchOffset,
      origin: origin ?? this.origin,
      targetAspectRatio: targetAspectRatio ?? this.targetAspectRatio,
    );
  }

  /// Converts this [ShapeTransform] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'rotation': rotation,
        'scaleX': scaleX,
        'scaleY': scaleY,
        'skewX': skewX,
        'skewY': skewY,
        'stretchOffsetX': stretchOffset.dx,
        'stretchOffsetY': stretchOffset.dy,
        'originX': origin.x,
        'originY': origin.y,
        if (targetAspectRatio != null) 'targetAspectRatio': targetAspectRatio,
      };

  /// Constructs a [ShapeTransform] from serialized JSON data.
  factory ShapeTransform.fromJson(Map<String, dynamic> json) {
    return ShapeTransform(
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1.0,
      scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1.0,
      skewX: (json['skewX'] as num?)?.toDouble() ?? 0.0,
      skewY: (json['skewY'] as num?)?.toDouble() ?? 0.0,
      stretchOffset: Offset(
        (json['stretchOffsetX'] as num?)?.toDouble() ?? 0.0,
        (json['stretchOffsetY'] as num?)?.toDouble() ?? 0.0,
      ),
      origin: json['originX'] != null && json['originY'] != null
          ? Alignment(
              (json['originX'] as num).toDouble(),
              (json['originY'] as num).toDouble(),
            )
          : Alignment.center,
      targetAspectRatio: (json['targetAspectRatio'] as num?)?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeTransform &&
          runtimeType == other.runtimeType &&
          rotation == other.rotation &&
          scaleX == other.scaleX &&
          scaleY == other.scaleY &&
          skewX == other.skewX &&
          skewY == other.skewY &&
          stretchOffset == other.stretchOffset &&
          origin == other.origin &&
          targetAspectRatio == other.targetAspectRatio;

  @override
  int get hashCode => Object.hash(
        rotation,
        scaleX,
        scaleY,
        skewX,
        skewY,
        stretchOffset,
        origin,
        targetAspectRatio,
      );
}
