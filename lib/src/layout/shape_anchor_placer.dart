import 'package:flutter/rendering.dart';

import '../material_4_config.dart';

/// Pixel coordinate resolver for semantic anchors on dynamic vector shapes.
///
/// Used for docking accessories, badges, notification pips, and pointer arrows
/// at geometric landmarks (e.g. notch pocket, folder tab, speech bubble tail).
class ShapeAnchorPlacer {
  const ShapeAnchorPlacer._();

  /// Resolves pixel position of [anchor] on a shape of [size].
  static Offset resolveAnchorPoint({
    required Size size,
    required ShapeAnchor anchor,
    Material4Config config = const Material4Config(),
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (size.width <= 0 || size.height <= 0) return Offset.zero;

    final isRtl = textDirection == TextDirection.rtl;

    switch (anchor) {
      case ShapeAnchor.topLeft:
        return isRtl ? Offset(size.width, 0.0) : Offset.zero;

      case ShapeAnchor.topRight:
        return isRtl ? Offset.zero : Offset(size.width, 0.0);

      case ShapeAnchor.bottomLeft:
        return isRtl
            ? Offset(size.width, size.height)
            : Offset(0.0, size.height);

      case ShapeAnchor.bottomRight:
        return isRtl
            ? Offset(0.0, size.height)
            : Offset(size.width, size.height);

      case ShapeAnchor.topCenter:
        return Offset(size.width / 2.0, 0.0);

      case ShapeAnchor.bottomCenter:
        return Offset(size.width / 2.0, size.height);

      case ShapeAnchor.leftCenter:
        return isRtl
            ? Offset(size.width, size.height / 2.0)
            : Offset(0.0, size.height / 2.0);

      case ShapeAnchor.rightCenter:
        return isRtl
            ? Offset(0.0, size.height / 2.0)
            : Offset(size.width, size.height / 2.0);

      case ShapeAnchor.center:
        return Offset(size.width / 2.0, size.height / 2.0);
    }
  }

  /// Calculates the dock center for a notch pocket on [edge].
  static Offset resolveNotchCenter({
    required Size size,
    required ShapeNotch notch,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final isRtl = textDirection == TextDirection.rtl;
    final edge = isRtl ? _mirrorEdge(notch.edge) : notch.edge;

    final edgeLength = (edge == ShapeEdge.top || edge == ShapeEdge.bottom)
        ? size.width
        : size.height;
    final pos = edgeLength * notch.positionFactor + notch.offset;

    switch (edge) {
      case ShapeEdge.top:
        return Offset(pos, notch.depth / 2.0);
      case ShapeEdge.bottom:
        return Offset(pos, size.height - (notch.depth / 2.0));
      case ShapeEdge.left:
        return Offset(notch.depth / 2.0, pos);
      case ShapeEdge.right:
        return Offset(size.width - (notch.depth / 2.0), pos);
    }
  }

  /// Calculates the dock center for a shape tab (folder tab, side tab).
  static Offset resolveTabCenter({
    required Size size,
    required Material4Config config,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final isRtl = textDirection == TextDirection.rtl;
    final anchor = _resolveAnchor(config.anchor, isRtl);

    switch (anchor) {
      case ShapeAnchor.topLeft:
        return Offset(config.tabWidth / 2.0, config.tabHeight / 2.0);
      case ShapeAnchor.topRight:
        return Offset(
            size.width - (config.tabWidth / 2.0), config.tabHeight / 2.0);
      case ShapeAnchor.topCenter:
        return Offset(size.width / 2.0, config.tabHeight / 2.0);
      case ShapeAnchor.bottomLeft:
        return Offset(
            config.tabWidth / 2.0, size.height - (config.tabHeight / 2.0));
      case ShapeAnchor.bottomRight:
        return Offset(size.width - (config.tabWidth / 2.0),
            size.height - (config.tabHeight / 2.0));
      case ShapeAnchor.bottomCenter:
        return Offset(size.width / 2.0, size.height - (config.tabHeight / 2.0));
      case ShapeAnchor.leftCenter:
        return Offset(config.protrusionDepth / 2.0, size.height / 2.0);
      case ShapeAnchor.rightCenter:
        return Offset(
            size.width - (config.protrusionDepth / 2.0), size.height / 2.0);
      case ShapeAnchor.center:
        return Offset(size.width / 2.0, size.height / 2.0);
    }
  }

  /// Calculates the target [Rect] for docking a child of [childSize] at [anchor].
  static Rect computeDockedRect({
    required Size shapeSize,
    required Size childSize,
    required ShapeAnchor anchor,
    EdgeInsets margin = EdgeInsets.zero,
    Material4Config config = const Material4Config(),
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final point = resolveAnchorPoint(
      size: shapeSize,
      anchor: anchor,
      config: config,
      textDirection: textDirection,
    );

    double x = point.dx - (childSize.width / 2.0);
    double y = point.dy - (childSize.height / 2.0);

    final isRtl = textDirection == TextDirection.rtl;
    final effectiveMarginLeft = isRtl ? margin.right : margin.left;
    final effectiveMarginRight = isRtl ? margin.left : margin.right;

    x += effectiveMarginLeft - effectiveMarginRight;
    y += margin.top - margin.bottom;

    return Rect.fromLTWH(x, y, childSize.width, childSize.height);
  }

  static ShapeEdge _mirrorEdge(ShapeEdge edge) {
    switch (edge) {
      case ShapeEdge.left:
        return ShapeEdge.right;
      case ShapeEdge.right:
        return ShapeEdge.left;
      default:
        return edge;
    }
  }

  static ShapeAnchor _resolveAnchor(ShapeAnchor anchor, bool isRtl) {
    if (!isRtl) return anchor;
    switch (anchor) {
      case ShapeAnchor.topLeft:
        return ShapeAnchor.topRight;
      case ShapeAnchor.topRight:
        return ShapeAnchor.topLeft;
      case ShapeAnchor.bottomLeft:
        return ShapeAnchor.bottomRight;
      case ShapeAnchor.bottomRight:
        return ShapeAnchor.bottomLeft;
      case ShapeAnchor.leftCenter:
        return ShapeAnchor.rightCenter;
      case ShapeAnchor.rightCenter:
        return ShapeAnchor.leftCenter;
      default:
        return anchor;
    }
  }
}
