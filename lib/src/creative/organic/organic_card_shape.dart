import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Corner geometry profile for an organic card vertex.
enum OrganicCornerStyle {
  /// Smooth continuous circular or squircle arc.
  rounded,

  /// 45-degree corner beveled chamfer with smooth entry/exit fillets.
  chamfer,

  /// Inward circular scooped corner cut (architectural concave corner).
  concave,

  /// Sculpted asymmetric Bézier corner with elongated tangent tension.
  sculpted,
}

/// Geometry definition for an individual corner of [Material4CardShape].
@immutable
class OrganicCorner {
  /// Corner radius in logical pixels.
  final double radius;

  /// Corner style profile.
  final OrganicCornerStyle style;

  /// Tangent smoothness factor (0.0 = sharp, 1.0 = ultra-smooth C2 continuous).
  final double smoothness;

  const OrganicCorner({
    required this.radius,
    this.style = OrganicCornerStyle.rounded,
    this.smoothness = 0.55,
  }) : assert(radius >= 0, 'Corner radius must be non-negative');

  const OrganicCorner.rounded(double radius, {double smoothness = 0.55})
      : this(
            radius: radius,
            style: OrganicCornerStyle.rounded,
            smoothness: smoothness);

  const OrganicCorner.chamfer(double radius, {double smoothness = 0.5})
      : this(
            radius: radius,
            style: OrganicCornerStyle.chamfer,
            smoothness: smoothness);

  const OrganicCorner.concave(double radius, {double smoothness = 0.55})
      : this(
            radius: radius,
            style: OrganicCornerStyle.concave,
            smoothness: smoothness);

  const OrganicCorner.sculpted(double radius, {double smoothness = 0.7})
      : this(
            radius: radius,
            style: OrganicCornerStyle.sculpted,
            smoothness: smoothness);

  OrganicCorner copyWith({
    double? radius,
    OrganicCornerStyle? style,
    double? smoothness,
  }) {
    return OrganicCorner(
      radius: radius ?? this.radius,
      style: style ?? this.style,
      smoothness: smoothness ?? this.smoothness,
    );
  }

  static OrganicCorner lerp(OrganicCorner a, OrganicCorner b, double t) {
    return OrganicCorner(
      radius: lerpDouble(a.radius, b.radius, t) ?? b.radius,
      style: t < 0.5 ? a.style : b.style,
      smoothness: lerpDouble(a.smoothness, b.smoothness, t) ?? b.smoothness,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganicCorner &&
          runtimeType == other.runtimeType &&
          radius == other.radius &&
          style == other.style &&
          smoothness == other.smoothness;

  @override
  int get hashCode => Object.hash(radius, style, smoothness);
}

/// Geometric edge profile style along a card boundary.
enum OrganicEdgeStyle {
  /// Flat linear edge between corner arcs.
  straight,

  /// Inward sculpted concave indentation / scoop notch (Reference Notice Board feature).
  concaveNotch,

  /// Outward organic convex bulge / gentle dome swelling.
  convexBulge,

  /// Centered sculpted waist constriction (pinched silhouette).
  sculptedWaist,

  /// Fluid harmonic wave undulation.
  wave,
}

/// Geometry definition for an individual edge of [Material4CardShape].
@immutable
class OrganicEdge {
  /// Edge profile style.
  final OrganicEdgeStyle style;

  /// Depth of concave indentation or height of convex bulge in logical pixels.
  final double depth;

  /// Width / span along the edge of the notch or bulge in logical pixels.
  final double width;

  /// Normalized position of the notch center along the edge (0.0 to 1.0).
  /// E.g. 0.65 represents 65% along the edge from start corner to end corner.
  final double position;

  /// Curvature tension / fillet smoothness factor (0.2 = compact, 0.8 = gradual sweep).
  final double smoothness;

  const OrganicEdge({
    this.style = OrganicEdgeStyle.straight,
    this.depth = 0.0,
    this.width = 0.0,
    this.position = 0.5,
    this.smoothness = 0.55,
  })  : assert(depth >= 0, 'Edge depth must be non-negative'),
        assert(width >= 0, 'Edge width must be non-negative'),
        assert(position >= 0.0 && position <= 1.0,
            'Position must be between 0.0 and 1.0');

  /// Flat straight edge.
  const OrganicEdge.straight()
      : this(
            style: OrganicEdgeStyle.straight,
            depth: 0,
            width: 0,
            position: 0.5);

  /// Smooth inward concave indentation / scooped cutout.
  const OrganicEdge.concaveNotch({
    required double depth,
    required double width,
    double position = 0.5,
    double smoothness = 0.55,
  }) : this(
          style: OrganicEdgeStyle.concaveNotch,
          depth: depth,
          width: width,
          position: position,
          smoothness: smoothness,
        );

  /// Smooth outward organic convex bulge.
  const OrganicEdge.convexBulge({
    required double depth,
    required double width,
    double position = 0.5,
    double smoothness = 0.55,
  }) : this(
          style: OrganicEdgeStyle.convexBulge,
          depth: depth,
          width: width,
          position: position,
          smoothness: smoothness,
        );

  /// Symmetrical inward sculpted waist pinch.
  const OrganicEdge.sculptedWaist({
    required double depth,
    double width = 80.0,
    double smoothness = 0.6,
  }) : this(
          style: OrganicEdgeStyle.sculptedWaist,
          depth: depth,
          width: width,
          position: 0.5,
          smoothness: smoothness,
        );

  /// Sinusoidal fluid edge crest.
  const OrganicEdge.wave({
    required double amplitude,
    double wavelength = 40.0,
  }) : this(
          style: OrganicEdgeStyle.wave,
          depth: amplitude,
          width: wavelength,
          position: 0.5,
          smoothness: 0.5,
        );

  OrganicEdge copyWith({
    OrganicEdgeStyle? style,
    double? depth,
    double? width,
    double? position,
    double? smoothness,
  }) {
    return OrganicEdge(
      style: style ?? this.style,
      depth: depth ?? this.depth,
      width: width ?? this.width,
      position: position ?? this.position,
      smoothness: smoothness ?? this.smoothness,
    );
  }

  static OrganicEdge lerp(OrganicEdge a, OrganicEdge b, double t) {
    return OrganicEdge(
      style: t < 0.5 ? a.style : b.style,
      depth: lerpDouble(a.depth, b.depth, t) ?? b.depth,
      width: lerpDouble(a.width, b.width, t) ?? b.width,
      position: lerpDouble(a.position, b.position, t) ?? b.position,
      smoothness: lerpDouble(a.smoothness, b.smoothness, t) ?? b.smoothness,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganicEdge &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          depth == other.depth &&
          width == other.width &&
          position == other.position &&
          smoothness == other.smoothness;

  @override
  int get hashCode => Object.hash(style, depth, width, position, smoothness);
}

/// An immutable, highly flexible parametric geometry system for organic,
/// asymmetric, and sculpted cards in Material 4.
///
/// Supports independent geometry across all four corners and four edges,
/// enabling authentic organic silhouettes, smooth concave indentations,
/// convex bulges, and asymmetric profiles.
@immutable
class Material4CardShape {
  /// Geometry of the top-left corner.
  final OrganicCorner topLeft;

  /// Geometry of the top-right corner.
  final OrganicCorner topRight;

  /// Geometry of the bottom-right corner.
  final OrganicCorner bottomRight;

  /// Geometry of the bottom-left corner.
  final OrganicCorner bottomLeft;

  /// Geometry of the top edge.
  final OrganicEdge topEdge;

  /// Geometry of the right edge.
  final OrganicEdge rightEdge;

  /// Geometry of the bottom edge.
  final OrganicEdge bottomEdge;

  /// Geometry of the left edge.
  final OrganicEdge leftEdge;

  const Material4CardShape({
    this.topLeft = const OrganicCorner.rounded(20.0),
    this.topRight = const OrganicCorner.rounded(20.0),
    this.bottomRight = const OrganicCorner.rounded(20.0),
    this.bottomLeft = const OrganicCorner.rounded(20.0),
    this.topEdge = const OrganicEdge.straight(),
    this.rightEdge = const OrganicEdge.straight(),
    this.bottomEdge = const OrganicEdge.straight(),
    this.leftEdge = const OrganicEdge.straight(),
  });

  // =========================================================================
  // 10 Distinct Built-in Presets
  // =========================================================================

  /// 1. Primary Reference Design: Notice Board Card.
  ///
  /// Recreates the user's reference design with asymmetric corners and an
  /// exquisite smooth concave indentation scooped on the lower-right edge.
  factory Material4CardShape.noticeBoard({
    double cornerRadius = 24.0,
    double notchDepth = 18.0,
    double notchWidth = 54.0,
    double notchPosition = 0.68,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.rounded(cornerRadius + 4.0),
      topRight: OrganicCorner.rounded(cornerRadius),
      bottomRight: OrganicCorner.rounded(cornerRadius - 6.0),
      bottomLeft: OrganicCorner.rounded(cornerRadius - 2.0),
      rightEdge: OrganicEdge.concaveNotch(
        depth: notchDepth,
        width: notchWidth,
        position: notchPosition,
        smoothness: 0.62,
      ),
    );
  }

  /// 2. Sculpted Information Card.
  ///
  /// Prominent top-left rounded dome with a gentle left-edge inward waist pinch.
  factory Material4CardShape.sculptedInfo({
    double domeRadius = 36.0,
    double waistDepth = 14.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.sculpted(domeRadius),
      topRight: const OrganicCorner.rounded(14.0),
      bottomRight: const OrganicCorner.rounded(28.0),
      bottomLeft: const OrganicCorner.rounded(12.0),
      leftEdge: OrganicEdge.sculptedWaist(
        depth: waistDepth,
        width: 60.0,
        smoothness: 0.58,
      ),
    );
  }

  /// 3. Asymmetric Feature Card.
  ///
  /// High-radius diagonal corners with a subtle organic convex bulge along the bottom edge.
  factory Material4CardShape.asymmetricFeature({
    double majorRadius = 38.0,
    double minorRadius = 12.0,
    double bulgeHeight = 10.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.rounded(majorRadius),
      topRight: OrganicCorner.rounded(minorRadius),
      bottomRight: OrganicCorner.rounded(majorRadius),
      bottomLeft: OrganicCorner.rounded(minorRadius),
      bottomEdge: OrganicEdge.convexBulge(
        depth: bulgeHeight,
        width: 72.0,
        position: 0.5,
        smoothness: 0.55,
      ),
    );
  }

  /// 4. Soft Concave Notch Card.
  ///
  /// Symmetrical card featuring an elegant top-edge parabolic concave notch
  /// ideal for floating badges, notification counters, or avatars.
  factory Material4CardShape.softNotch({
    double cornerRadius = 22.0,
    double notchDepth = 16.0,
    double notchWidth = 64.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.rounded(cornerRadius),
      topRight: OrganicCorner.rounded(cornerRadius),
      bottomRight: OrganicCorner.rounded(cornerRadius),
      bottomLeft: OrganicCorner.rounded(cornerRadius),
      topEdge: OrganicEdge.concaveNotch(
        depth: notchDepth,
        width: notchWidth,
        position: 0.5,
        smoothness: 0.58,
      ),
    );
  }

  /// 5. Floating Organic Card.
  ///
  /// Asymmetric fluid lobes with convex right swell and complementary concave left sweep.
  factory Material4CardShape.floatingOrganic({
    double baseRadius = 22.0,
    double organicDelta = 12.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.sculpted(baseRadius + 10.0),
      topRight: OrganicCorner.rounded(baseRadius - 4.0),
      bottomRight: OrganicCorner.sculpted(baseRadius + 14.0),
      bottomLeft: OrganicCorner.rounded(baseRadius - 6.0),
      rightEdge: OrganicEdge.convexBulge(
        depth: organicDelta,
        width: 64.0,
        position: 0.45,
      ),
      leftEdge: OrganicEdge.concaveNotch(
        depth: organicDelta * 0.8,
        width: 58.0,
        position: 0.55,
      ),
    );
  }

  /// 6. Fluid Pebble Blob Surface Card.
  ///
  /// Continuous soft-radius organic pebble with quad-asymmetric Bézier curvature.
  factory Material4CardShape.blobSurface({
    double seed = 1.0,
  }) {
    return const Material4CardShape(
      topLeft: OrganicCorner.sculpted(44.0, smoothness: 0.75),
      topRight: OrganicCorner.sculpted(26.0, smoothness: 0.65),
      bottomRight: OrganicCorner.sculpted(48.0, smoothness: 0.8),
      bottomLeft: OrganicCorner.sculpted(20.0, smoothness: 0.6),
    );
  }

  /// 7. Curved Dynamic Edge Card.
  ///
  /// Arched outward convex crest on the top edge with an inward concave sweep on bottom.
  factory Material4CardShape.curvedEdge({
    double cornerRadius = 20.0,
    double topArchHeight = 14.0,
    double bottomScoopDepth = 12.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.rounded(cornerRadius),
      topRight: OrganicCorner.rounded(cornerRadius),
      bottomRight: OrganicCorner.rounded(cornerRadius),
      bottomLeft: OrganicCorner.rounded(cornerRadius),
      topEdge: OrganicEdge.convexBulge(
        depth: topArchHeight,
        width: 110.0,
        position: 0.5,
        smoothness: 0.6,
      ),
      bottomEdge: OrganicEdge.concaveNotch(
        depth: bottomScoopDepth,
        width: 90.0,
        position: 0.5,
        smoothness: 0.55,
      ),
    );
  }

  /// 8. Creative Dashboard Card.
  ///
  /// Stepped architectural corner with a subtle top-right tab protrusion.
  factory Material4CardShape.creativeDashboard({
    double baseRadius = 20.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.chamfer(baseRadius + 4.0),
      topRight: OrganicCorner.rounded(baseRadius - 6.0),
      bottomRight: OrganicCorner.rounded(baseRadius + 12.0),
      bottomLeft: OrganicCorner.rounded(baseRadius - 8.0),
      topEdge: const OrganicEdge.convexBulge(
        depth: 14.0,
        width: 68.0,
        position: 0.75,
        smoothness: 0.55,
      ),
    );
  }

  /// 9. Sculpted Action Pocket Card.
  ///
  /// Concave action pocket recessed along the right edge designed for button or icon docking.
  factory Material4CardShape.sculptedAction({
    double cornerRadius = 20.0,
    double actionPocketDepth = 22.0,
    double actionPocketWidth = 52.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.rounded(cornerRadius),
      topRight: OrganicCorner.rounded(cornerRadius - 10.0),
      bottomRight: OrganicCorner.rounded(cornerRadius - 4.0),
      bottomLeft: OrganicCorner.rounded(cornerRadius + 8.0),
      rightEdge: OrganicEdge.concaveNotch(
        depth: actionPocketDepth,
        width: actionPocketWidth,
        position: 0.5,
        smoothness: 0.65,
      ),
    );
  }

  /// 10. Material 4 Signature Card.
  ///
  /// Flagship geometry combining four asymmetric corner radii, a lower-right
  /// concave scoop notch, and a gentle top-edge convex crest.
  factory Material4CardShape.signature({
    double primaryRadius = 30.0,
    double notchDepth = 20.0,
  }) {
    return Material4CardShape(
      topLeft: OrganicCorner.sculpted(primaryRadius),
      topRight: OrganicCorner.rounded(primaryRadius - 10.0),
      bottomRight: OrganicCorner.sculpted(primaryRadius - 4.0),
      bottomLeft: OrganicCorner.rounded(primaryRadius - 14.0),
      topEdge: const OrganicEdge.convexBulge(
        depth: 8.0,
        width: 80.0,
        position: 0.38,
        smoothness: 0.55,
      ),
      rightEdge: OrganicEdge.concaveNotch(
        depth: notchDepth,
        width: 56.0,
        position: 0.66,
        smoothness: 0.65,
      ),
    );
  }

  Material4CardShape copyWith({
    OrganicCorner? topLeft,
    OrganicCorner? topRight,
    OrganicCorner? bottomRight,
    OrganicCorner? bottomLeft,
    OrganicEdge? topEdge,
    OrganicEdge? rightEdge,
    OrganicEdge? bottomEdge,
    OrganicEdge? leftEdge,
  }) {
    return Material4CardShape(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      topEdge: topEdge ?? this.topEdge,
      rightEdge: rightEdge ?? this.rightEdge,
      bottomEdge: bottomEdge ?? this.bottomEdge,
      leftEdge: leftEdge ?? this.leftEdge,
    );
  }

  /// Linearly interpolate between two card shapes for butter-smooth morphing.
  static Material4CardShape lerp(
      Material4CardShape a, Material4CardShape b, double t) {
    return Material4CardShape(
      topLeft: OrganicCorner.lerp(a.topLeft, b.topLeft, t),
      topRight: OrganicCorner.lerp(a.topRight, b.topRight, t),
      bottomRight: OrganicCorner.lerp(a.bottomRight, b.bottomRight, t),
      bottomLeft: OrganicCorner.lerp(a.bottomLeft, b.bottomLeft, t),
      topEdge: OrganicEdge.lerp(a.topEdge, b.topEdge, t),
      rightEdge: OrganicEdge.lerp(a.rightEdge, b.rightEdge, t),
      bottomEdge: OrganicEdge.lerp(a.bottomEdge, b.bottomEdge, t),
      leftEdge: OrganicEdge.lerp(a.leftEdge, b.leftEdge, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4CardShape &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomRight == other.bottomRight &&
          bottomLeft == other.bottomLeft &&
          topEdge == other.topEdge &&
          rightEdge == other.rightEdge &&
          bottomEdge == other.bottomEdge &&
          leftEdge == other.leftEdge;

  @override
  int get hashCode => Object.hash(
        topLeft,
        topRight,
        bottomRight,
        bottomLeft,
        topEdge,
        rightEdge,
        bottomEdge,
        leftEdge,
      );
}
