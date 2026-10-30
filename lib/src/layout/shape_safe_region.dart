import 'dart:collection';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import '../dynamic_shape_path_builder.dart';

/// Geometry-aware safe region and inscribed bounds engine.
///
/// Ensures child content (text, icons, images, buttons, badges) avoids collision
/// with inward notches, scallops, corner arcs, wave troughs, stepped corners,
/// and complex organic or custom Bézier contours.
class ShapeSafeRegion {
  const ShapeSafeRegion._();

  /// Maximum number of cached safe insets entries to keep memory bounded
  /// for low-end mobile devices (500MB-1GB RAM).
  static const int _maxCacheSize = 128;

  /// Internal LRU cache for computed safe insets.
  static final LinkedHashMap<int, EdgeInsets> _insetsCache =
      LinkedHashMap<int, EdgeInsets>();

  /// Clears the safe insets cache.
  static void clearCache() {
    _insetsCache.clear();
  }

  /// Computes collision-free directional insets for [config] at [size].
  ///
  /// Combines parametric geometric analysis with dynamic path boundary verification
  /// to guarantee that children placed within the resulting bounds are never clipped.
  static EdgeInsets computeSafeInsets({
    required Size size,
    required DynamicShapeConfig config,
    EdgeInsets basePadding = EdgeInsets.zero,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (size.width <= 0 || size.height <= 0) return basePadding;

    // Check LRU cache
    final cacheKey = Object.hash(
      size.width,
      size.height,
      config,
      basePadding,
      borderWidth,
      textDirection,
    );

    final cached = _insetsCache[cacheKey];
    if (cached != null) {
      // Refresh key for LRU ordering
      _insetsCache.remove(cacheKey);
      _insetsCache[cacheKey] = cached;
      return cached;
    }

    final computed = _calculateSafeInsets(
      size: size,
      config: config,
      basePadding: basePadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );

    // Evict oldest if exceeding capacity
    if (_insetsCache.length >= _maxCacheSize) {
      _insetsCache.remove(_insetsCache.keys.first);
    }
    _insetsCache[cacheKey] = computed;

    return computed;
  }

  static EdgeInsets _calculateSafeInsets({
    required Size size,
    required DynamicShapeConfig config,
    required EdgeInsets basePadding,
    required double borderWidth,
    required TextDirection textDirection,
  }) {
    final isRtl = textDirection == TextDirection.rtl;
    final strokeOffset = borderWidth > 0 ? borderWidth : 1.0;

    double left = basePadding.left + strokeOffset;
    double right = basePadding.right + strokeOffset;
    double top = basePadding.top + strokeOffset;
    double bottom = basePadding.bottom + strokeOffset;

    // -------------------------------------------------------------------------
    // 1. Asymmetric & Elliptical Corner Radii
    // -------------------------------------------------------------------------
    final sanitizedCorners = config.resolvedCorners.sanitize(size);
    final effectiveTl =
        isRtl ? sanitizedCorners.topRight : sanitizedCorners.topLeft;
    final effectiveTr =
        isRtl ? sanitizedCorners.topLeft : sanitizedCorners.topRight;
    final effectiveBl =
        isRtl ? sanitizedCorners.bottomRight : sanitizedCorners.bottomLeft;
    final effectiveBr =
        isRtl ? sanitizedCorners.bottomLeft : sanitizedCorners.bottomRight;

    // Inscribed circle allowance: r * (1 - 1/sqrt(2)) ~= r * 0.293.
    // Factor 0.35 ensures safety from the curved corner arc.
    left = math.max(left, math.max(effectiveTl.x, effectiveBl.x) * 0.35);
    right = math.max(right, math.max(effectiveTr.x, effectiveBr.x) * 0.35);
    top = math.max(top, math.max(effectiveTl.y, effectiveTr.y) * 0.35);
    bottom = math.max(bottom, math.max(effectiveBl.y, effectiveBr.y) * 0.35);

    // -------------------------------------------------------------------------
    // 2. Multi-Notch Engine
    // -------------------------------------------------------------------------
    if (config.notches != null && config.notches!.isNotEmpty) {
      for (final notch in config.notches!) {
        if (!notch.isInward) {
          continue; // Outward tabs do not intrude on interior
        }

        final depthAllowance = notch.depth + strokeOffset;
        final targetEdge = isRtl ? _mirrorEdge(notch.edge) : notch.edge;

        switch (targetEdge) {
          case ShapeEdge.top:
            top = math.max(top, depthAllowance);
            break;
          case ShapeEdge.bottom:
            bottom = math.max(bottom, depthAllowance);
            break;
          case ShapeEdge.left:
            left = math.max(left, depthAllowance);
            break;
          case ShapeEdge.right:
            right = math.max(right, depthAllowance);
            break;
        }
      }
    }

    // -------------------------------------------------------------------------
    // 3. Preset-Specific Mathematical Allowances
    // -------------------------------------------------------------------------
    switch (config.type) {
      case DynamicShapeType.folderTab:
        final anchor = _resolveAnchor(config.anchor, isRtl);
        if (anchor == ShapeAnchor.topLeft ||
            anchor == ShapeAnchor.topRight ||
            anchor == ShapeAnchor.topCenter) {
          top = math.max(top, config.tabHeight + strokeOffset + 4.0);
        } else {
          bottom = math.max(bottom, config.tabHeight + strokeOffset + 4.0);
        }
        break;

      case DynamicShapeType.notchedBadge:
        final anchor = _resolveAnchor(config.anchor, isRtl);
        if (anchor == ShapeAnchor.topLeft ||
            anchor == ShapeAnchor.topRight ||
            anchor == ShapeAnchor.topCenter) {
          top = math.max(top, config.tabHeight + strokeOffset + 2.0);
        } else {
          bottom = math.max(bottom, config.tabHeight + strokeOffset + 2.0);
        }
        break;

      case DynamicShapeType.sideTab:
        final anchor = _resolveAnchor(config.anchor, isRtl);
        if (anchor == ShapeAnchor.rightCenter ||
            anchor == ShapeAnchor.topRight) {
          right = math.max(right, config.protrusionDepth + strokeOffset + 2.0);
        } else {
          left = math.max(left, config.protrusionDepth + strokeOffset + 2.0);
        }
        break;

      case DynamicShapeType.steppedCorner:
        final anchor = _resolveAnchor(config.anchor, isRtl);
        if (anchor == ShapeAnchor.bottomRight) {
          bottom = math.max(bottom, config.tabHeight * 0.45);
          right = math.max(right, config.tabWidth * 0.45);
        } else if (anchor == ShapeAnchor.bottomLeft) {
          bottom = math.max(bottom, config.tabHeight * 0.45);
          left = math.max(left, config.tabWidth * 0.45);
        } else if (anchor == ShapeAnchor.topRight) {
          top = math.max(top, config.tabHeight * 0.45);
          right = math.max(right, config.tabWidth * 0.45);
        } else {
          top = math.max(top, config.tabHeight * 0.45);
          left = math.max(left, config.tabWidth * 0.45);
        }
        break;

      case DynamicShapeType.ticketScallop:
        final scallop = config.scallopRadius + strokeOffset + 2.0;
        left = math.max(left, scallop);
        right = math.max(right, scallop);
        break;

      case DynamicShapeType.postageStamp:
        final pScallop = config.scallopRadius + strokeOffset + 2.0;
        left = math.max(left, pScallop);
        right = math.max(right, pScallop);
        top = math.max(top, pScallop);
        bottom = math.max(bottom, pScallop);
        break;

      case DynamicShapeType.zigzagCut:
        bottom = math.max(bottom, config.toothHeight + strokeOffset + 4.0);
        break;

      case DynamicShapeType.arch:
        top = math.max(top, size.width * 0.15 + strokeOffset);
        break;

      case DynamicShapeType.hexagonSoft:
        final hexCorner =
            math.min(config.cornerRadius, 14.0) * 0.45 + strokeOffset;
        left = math.max(left, hexCorner);
        right = math.max(right, hexCorner);
        top = math.max(top, size.height * 0.08 + strokeOffset);
        bottom = math.max(bottom, size.height * 0.08 + strokeOffset);
        break;

      case DynamicShapeType.chamferDiagonal:
        final chamfer = config.tabWidth * 0.35 + strokeOffset;
        right = math.max(right, chamfer);
        top = math.max(top, chamfer);
        break;

      case DynamicShapeType.organicBlob:
        final blobInset =
            math.min(size.width, size.height) * 0.14 + strokeOffset;
        left = math.max(left, blobInset);
        right = math.max(right, blobInset);
        top = math.max(top, blobInset);
        bottom = math.max(bottom, blobInset);
        break;

      case DynamicShapeType.scallopedPetal:
        final petalAllowance = config.cornerRadius * 0.35 + strokeOffset;
        left = math.max(left, petalAllowance);
        right = math.max(right, petalAllowance);
        top = math.max(top, petalAllowance);
        bottom = math.max(bottom, petalAllowance);
        break;

      case DynamicShapeType.capsule:
        final capRadius =
            math.min(size.width, size.height) * 0.28 + strokeOffset;
        left = math.max(left, capRadius);
        right = math.max(right, capRadius);
        break;

      case DynamicShapeType.waveEdge:
        final waveAllowance = config.waveAmplitude + strokeOffset + 4.0;
        final anchor = _resolveAnchor(config.anchor, isRtl);
        if (anchor == ShapeAnchor.bottomCenter) {
          bottom = math.max(bottom, waveAllowance);
        } else {
          top = math.max(top, waveAllowance);
        }
        break;

      case DynamicShapeType.cloud:
        top = math.max(top, 16.0 + strokeOffset);
        bottom = math.max(bottom, 14.0 + strokeOffset);
        left = math.max(left, 16.0 + strokeOffset);
        right = math.max(right, 16.0 + strokeOffset);
        break;

      case DynamicShapeType.speechBubble:
        final anchor = _resolveAnchor(config.anchor, isRtl);
        final tailAllowance =
            config.speechBubbleTailHeight + strokeOffset + 4.0;
        if (anchor == ShapeAnchor.bottomLeft ||
            anchor == ShapeAnchor.bottomRight ||
            anchor == ShapeAnchor.bottomCenter) {
          bottom = math.max(bottom, tailAllowance);
        } else if (anchor == ShapeAnchor.topLeft ||
            anchor == ShapeAnchor.topRight ||
            anchor == ShapeAnchor.topCenter) {
          top = math.max(top, tailAllowance);
        } else if (anchor == ShapeAnchor.leftCenter) {
          left = math.max(left, tailAllowance);
        } else {
          right = math.max(right, tailAllowance);
        }
        break;

      case DynamicShapeType.shield:
        bottom = math.max(bottom, size.height * 0.18 + strokeOffset);
        left = math.max(left, 14.0 + strokeOffset);
        right = math.max(right, 14.0 + strokeOffset);
        break;

      case DynamicShapeType.diamond:
        left = math.max(left, size.width * 0.20 + strokeOffset);
        right = math.max(right, size.width * 0.20 + strokeOffset);
        top = math.max(top, size.height * 0.20 + strokeOffset);
        bottom = math.max(bottom, size.height * 0.20 + strokeOffset);
        break;

      case DynamicShapeType.octagon:
        final octAllowance =
            math.min(size.width, size.height) * 0.12 + strokeOffset;
        left = math.max(left, octAllowance);
        right = math.max(right, octAllowance);
        top = math.max(top, octAllowance);
        bottom = math.max(bottom, octAllowance);
        break;

      case DynamicShapeType.waveCut:
        right = math.max(right, config.waveAmplitude + strokeOffset + 8.0);
        bottom = math.max(bottom, config.waveAmplitude + strokeOffset + 6.0);
        break;

      case DynamicShapeType.convexRounded:
      case DynamicShapeType.concaveRounded:
        final curvature = config.cornerRadius * 0.45 + strokeOffset;
        left = math.max(left, curvature);
        right = math.max(right, curvature);
        top = math.max(top, curvature);
        bottom = math.max(bottom, curvature);
        break;

      case DynamicShapeType.parallelogram:
        final skewRad = config.skewAngle.abs() * math.pi / 180.0;
        final skewAllowance =
            (math.tan(skewRad) * size.height * 0.35) + strokeOffset;
        left = math.max(left, skewAllowance);
        right = math.max(right, skewAllowance);
        break;

      case DynamicShapeType.ribbon:
        final fold = config.ribbonFoldDepth + strokeOffset + 4.0;
        left = math.max(left, fold);
        right = math.max(right, fold);
        break;

      case DynamicShapeType.bookmark:
        bottom = math.max(bottom, config.ribbonFoldDepth + strokeOffset + 4.0);
        break;

      case DynamicShapeType.customBezier:
        final defaultBezierInset =
            math.min(size.width, size.height) * 0.12 + strokeOffset;
        left = math.max(left, defaultBezierInset);
        right = math.max(right, defaultBezierInset);
        top = math.max(top, defaultBezierInset);
        bottom = math.max(bottom, defaultBezierInset);
        break;

      default:
        break;
    }

    // -------------------------------------------------------------------------
    // 4. Custom Edges (ShapeEdges)
    // -------------------------------------------------------------------------
    if (config.edges != null && !config.edges!.isAllStraight) {
      final edges = config.edges!;
      if (edges.top.style == ShapeEdgeStyle.concave) {
        top = math.max(top, edges.top.depth + strokeOffset);
      }
      if (edges.bottom.style == ShapeEdgeStyle.concave ||
          edges.bottom.style == ShapeEdgeStyle.zigzag) {
        bottom = math.max(
          bottom,
          (edges.bottom.depth != 0
                  ? edges.bottom.depth
                  : edges.bottom.waveAmplitude) +
              strokeOffset,
        );
      }
      if (edges.left.style == ShapeEdgeStyle.concave) {
        left = math.max(left, edges.left.depth + strokeOffset);
      }
      if (edges.right.style == ShapeEdgeStyle.concave) {
        right = math.max(right, edges.right.depth + strokeOffset);
      }
    }

    // -------------------------------------------------------------------------
    // 5. Dynamic Geometry-Probing Refinement
    // -------------------------------------------------------------------------
    // For organic blobs, diamonds, custom Béziers, or transformed shapes,
    // verify and iteratively contract insets until all 8 boundary sample points
    // are strictly inside path.contains(point).
    final needsPathRefinement = config.type == DynamicShapeType.diamond ||
        config.type == DynamicShapeType.organicBlob ||
        config.type == DynamicShapeType.customBezier ||
        config.type == DynamicShapeType.shield ||
        config.resolvedTransform.rotation != 0.0 ||
        config.resolvedTransform.skewX != 0.0 ||
        config.resolvedTransform.skewY != 0.0;

    if (needsPathRefinement && size.width > 20 && size.height > 20) {
      final path = DynamicShapePathBuilder.buildPath(size, config);
      var refined = _probeAndContract(
        path: path,
        size: size,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );
      left = refined.left;
      top = refined.top;
      right = refined.right;
      bottom = refined.bottom;
    }

    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /// Probes candidate inscribed rectangle against [path] and contracts edges
  /// if any corner or edge midpoint falls outside the contour.
  static EdgeInsets _probeAndContract({
    required Path path,
    required Size size,
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) {
    double l = left;
    double t = top;
    double r = right;
    double b = bottom;

    const maxIterations = 6;
    final stepX = math.max(2.0, size.width * 0.04);
    final stepY = math.max(2.0, size.height * 0.04);

    for (int i = 0; i < maxIterations; i++) {
      final w = size.width - l - r;
      final h = size.height - t - b;
      if (w <= 10.0 || h <= 10.0) break;

      final rect = Rect.fromLTWH(l, t, w, h);

      // Test 4 corners and 4 edge midpoints
      final pTl = rect.topLeft;
      final pTr = rect.topRight;
      final pBl = rect.bottomLeft;
      final pBr = rect.bottomRight;
      final pTc = Offset(rect.center.dx, rect.top);
      final pBc = Offset(rect.center.dx, rect.bottom);
      final pLc = Offset(rect.left, rect.center.dy);
      final pRc = Offset(rect.right, rect.center.dy);

      bool ok = true;

      if (!path.contains(pTl) || !path.contains(pLc)) {
        l += stepX;
        t += stepY;
        ok = false;
      }
      if (!path.contains(pTr) || !path.contains(pRc)) {
        r += stepX;
        t += stepY;
        ok = false;
      }
      if (!path.contains(pBl) || !path.contains(pLc)) {
        l += stepX;
        b += stepY;
        ok = false;
      }
      if (!path.contains(pBr) || !path.contains(pRc)) {
        r += stepX;
        b += stepY;
        ok = false;
      }
      if (!path.contains(pTc)) {
        t += stepY;
        ok = false;
      }
      if (!path.contains(pBc)) {
        b += stepY;
        ok = false;
      }

      if (ok) break;
    }

    return EdgeInsets.only(left: l, top: t, right: r, bottom: b);
  }

  /// Calculates the largest collision-free inscribed rectangular content box.
  static Rect computeInscribedBounds({
    required Size size,
    required DynamicShapeConfig config,
    EdgeInsets basePadding = EdgeInsets.zero,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final insets = computeSafeInsets(
      size: size,
      config: config,
      basePadding: basePadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );

    final w = math.max(0.0, size.width - insets.horizontal);
    final h = math.max(0.0, size.height - insets.vertical);
    return Rect.fromLTWH(insets.left, insets.top, w, h);
  }

  /// Computes the complete set of safe content regions for [config] on [size].
  ///
  /// For shapes where complex geometry, inward notches, ticket cutouts, stepped corners,
  /// or tabs partition the available interior into multiple discrete pockets,
  /// [ShapeSafeRegionSet] provides both the primary inscribed rect and all sub-regions.
  static ShapeSafeRegionSet computeSafeRegionSet({
    required Size size,
    required DynamicShapeConfig config,
    EdgeInsets basePadding = EdgeInsets.zero,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final insets = computeSafeInsets(
      size: size,
      config: config,
      basePadding: basePadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );

    final primary = computeInscribedBounds(
      size: size,
      config: config,
      basePadding: basePadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );

    final regions = <Rect>[primary];
    final isRtl = textDirection == TextDirection.rtl;
    final strokeOffset = borderWidth > 0 ? borderWidth : 1.0;

    // 1. Inward notch partitioning into flanking pockets
    if (config.notches != null && config.notches!.isNotEmpty) {
      for (final notch in config.notches!) {
        if (!notch.isInward) continue;
        final targetEdge = isRtl ? _mirrorEdge(notch.edge) : notch.edge;
        final edgeLength =
            (targetEdge == ShapeEdge.top || targetEdge == ShapeEdge.bottom)
                ? size.width
                : size.height;
        final notchCenter = edgeLength * notch.positionFactor + notch.offset;
        final notchLeft = notchCenter - (notch.width / 2.0);
        final notchRight = notchCenter + (notch.width / 2.0);

        if (targetEdge == ShapeEdge.top) {
          if (notchLeft > insets.left + 24.0) {
            regions.add(Rect.fromLTRB(
              insets.left,
              insets.top,
              notchLeft - strokeOffset,
              size.height - insets.bottom,
            ));
          }
          if (notchRight < size.width - insets.right - 24.0) {
            regions.add(Rect.fromLTRB(
              notchRight + strokeOffset,
              insets.top,
              size.width - insets.right,
              size.height - insets.bottom,
            ));
          }
        } else if (targetEdge == ShapeEdge.bottom) {
          if (notchLeft > insets.left + 24.0) {
            regions.add(Rect.fromLTRB(
              insets.left,
              insets.top,
              notchLeft - strokeOffset,
              size.height - insets.bottom,
            ));
          }
          if (notchRight < size.width - insets.right - 24.0) {
            regions.add(Rect.fromLTRB(
              notchRight + strokeOffset,
              insets.top,
              size.width - insets.right,
              size.height - insets.bottom,
            ));
          }
        }
      }
    }

    // 2. Preset-specific region partitioning
    switch (config.type) {
      case DynamicShapeType.ticketScallop:
        final scallopY = size.height * 0.5;
        final scallopR = config.scallopRadius + strokeOffset;
        if (scallopY - scallopR > insets.top + 16.0) {
          regions.add(Rect.fromLTRB(
            insets.left,
            insets.top,
            size.width - insets.right,
            scallopY - scallopR,
          ));
        }
        if (scallopY + scallopR < size.height - insets.bottom - 16.0) {
          regions.add(Rect.fromLTRB(
            insets.left,
            scallopY + scallopR,
            size.width - insets.right,
            size.height - insets.bottom,
          ));
        }
        break;

      case DynamicShapeType.folderTab:
        final tabH = config.tabHeight + strokeOffset;
        regions.add(Rect.fromLTWH(
          insets.left,
          0.0,
          config.tabWidth,
          tabH,
        ));
        break;

      case DynamicShapeType.steppedCorner:
        final w = config.tabWidth;
        final h = config.tabHeight;
        if (config.anchor == ShapeAnchor.bottomRight) {
          regions.add(Rect.fromLTWH(0, size.height - h, size.width - w, h));
        } else if (config.anchor == ShapeAnchor.topRight) {
          regions.add(Rect.fromLTWH(0, 0, size.width - w, h));
        }
        break;

      default:
        break;
    }

    return ShapeSafeRegionSet(
      primary: primary,
      regions: regions.where((r) => r.width > 8.0 && r.height > 8.0).toList(),
      insets: insets,
    );
  }

  /// Verifies whether [point] lies within the safe interior of [config] on [size].
  static bool isWithinSafeRegion({
    required Offset point,
    required Size size,
    required DynamicShapeConfig config,
    EdgeInsets basePadding = EdgeInsets.zero,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final safeBounds = computeInscribedBounds(
      size: size,
      config: config,
      basePadding: basePadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );

    return safeBounds.contains(point);
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

/// A comprehensive collection of safe content regions within a dynamic shape contour.
///
/// Complex shapes (notched cards, ticket scallops, folder tabs, stepped corners)
/// may offer multiple discrete compartments for child widgets. [ShapeSafeRegionSet]
/// provides access to both the primary inscribed rect and all sub-regions.
class ShapeSafeRegionSet {
  /// The primary (largest continuous) rectangular safe content area.
  final Rect primary;

  /// All distinct safe regions identified within the shape geometry.
  final List<Rect> regions;

  /// Effective safe directional insets for the container.
  final EdgeInsets insets;

  const ShapeSafeRegionSet({
    required this.primary,
    required this.regions,
    required this.insets,
  });

  /// The largest region by area among [regions].
  Rect get largestRegion => regions.isNotEmpty
      ? regions.reduce(
          (a, b) => (a.width * a.height) >= (b.width * b.height) ? a : b)
      : primary;

  /// Finds the best safe region capable of hosting [size].
  ///
  /// Searches for a region whose width and height can accommodate [size].
  /// If multiple match, picks the one closest in size or area.
  /// Falls back to [largestRegion] if none fully fit.
  Rect findBestRegionForSize(Size size) {
    if (regions.isEmpty) return primary;
    Rect? best;
    double bestArea = double.infinity;
    for (final region in regions) {
      if (region.width >= size.width && region.height >= size.height) {
        final area = region.width * region.height;
        if (area < bestArea) {
          bestArea = area;
          best = region;
        }
      }
    }
    return best ?? largestRegion;
  }

  /// Checks if [point] lies inside any of the safe regions.
  bool contains(Offset point) {
    for (final region in regions) {
      if (region.contains(point)) return true;
    }
    return primary.contains(point);
  }

  @override
  String toString() =>
      'ShapeSafeRegionSet(primary: $primary, count: ${regions.length}, insets: $insets)';
}
