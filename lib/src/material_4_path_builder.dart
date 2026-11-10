import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'container/custom_shape.dart';
import 'material_4_config.dart';
import 'shape_path_cache.dart';

/// Builds a customized, mathematically precise [Path] for any [Material4Config]
/// across arbitrary container dimensions with extreme dimension guards, LRU caching, and transform support.

/// Type alias for [Material4PathBuilder].
typedef Material4ShapePathBuilder = Material4PathBuilder;

/// Deprecated alias for [Material4PathBuilder].
@Deprecated(
    'Use Material4PathBuilder instead. This alias will be removed in a future release.')
typedef DynamicShapePathBuilder = Material4PathBuilder;

class Material4PathBuilder {
  /// Global LRU path cache limiting memory usage and avoiding recomputation.
  static final ShapePathCache defaultCache = ShapePathCache();

  /// Deprecated alias for [buildPath].
  @Deprecated('Use buildPath instead.')
  static Path build(
    Size size,
    Material4Config config, {
    bool useCache = true,
  }) =>
      buildPath(size, config, useCache: useCache);

  static Path buildPath(
    Size size,
    Material4Config config, {
    bool useCache = true,
  }) {
    if (!useCache ||
        (config.type == Material4Type.customBezier &&
            config.customBezierBuilder != null)) {
      return _buildPathDirect(size, config);
    }
    return defaultCache.getOrCreate(
      size: size,
      config: config,
      computePath: () => _buildPathDirect(size, config),
    );
  }

  static Path _buildPathDirect(Size size, Material4Config config) {
    // 1. Guard against non-positive, zero, infinite, or NaN dimensions
    if (size.width <= 0 ||
        size.height <= 0 ||
        size.width.isNaN ||
        size.height.isNaN ||
        size.width.isInfinite ||
        size.height.isInfinite) {
      return Path();
    }

    final effectiveSize = config.constraints.clampSize(size);
    if (effectiveSize.width <= 0 || effectiveSize.height <= 0) {
      return Path();
    }

    Path path;

    // 2. Build Base Geometry
    if (config.customShape != null) {
      path = config.customShape!.buildPath(effectiveSize);
    } else if (config.edges != null && !config.edges!.isAllStraight) {
      path = _buildCustomEdgesPath(effectiveSize, config);
    } else {
      switch (config.type) {
        // --- Original 13 Shapes ---
        case Material4Type.folderTab:
          path = _buildFolderTabPath(effectiveSize, config);
          break;
        case Material4Type.notchedBadge:
          path = _buildNotchedBadgePath(effectiveSize, config);
          break;
        case Material4Type.sideTab:
          path = _buildSideTabPath(effectiveSize, config);
          break;
        case Material4Type.steppedCorner:
          path = _buildSteppedCornerPath(effectiveSize, config);
          break;
        case Material4Type.ticketScallop:
          path = _buildTicketScallopPath(effectiveSize, config);
          break;
        case Material4Type.postageStamp:
          path = _buildPostageStampPath(effectiveSize, config);
          break;
        case Material4Type.zigzagCut:
          path = _buildZigzagCutPath(effectiveSize, config);
          break;
        case Material4Type.arch:
          path = _buildArchPath(effectiveSize, config);
          break;
        case Material4Type.hexagonSoft:
          path = _buildHexagonSoftPath(effectiveSize, config);
          break;
        case Material4Type.chamferDiagonal:
          path = _buildChamferDiagonalPath(effectiveSize, config);
          break;
        case Material4Type.organicBlob:
          path = _buildOrganicBlobPath(effectiveSize, config);
          break;
        case Material4Type.scallopedPetal:
          path = _buildScallopedPetalPath(effectiveSize, config);
          break;
        case Material4Type.smoothRounded:
          path = _buildSmoothRoundedPath(effectiveSize, config);
          break;

        // --- Next-Gen Geometry Additions ---
        case Material4Type.asymmetricCard:
          path = _buildAsymmetricCardPath(effectiveSize, config);
          break;
        case Material4Type.capsule:
          path = _buildCapsulePath(effectiveSize, config);
          break;
        case Material4Type.waveEdge:
          path = _buildWaveEdgePath(effectiveSize, config);
          break;
        case Material4Type.cloud:
          path = _buildCloudPath(effectiveSize, config);
          break;
        case Material4Type.speechBubble:
          path = _buildSpeechBubblePath(effectiveSize, config);
          break;
        case Material4Type.shield:
          path = _buildShieldPath(effectiveSize, config);
          break;
        case Material4Type.diamond:
          path = _buildDiamondPath(effectiveSize, config);
          break;
        case Material4Type.octagon:
          path = _buildOctagonPath(effectiveSize, config);
          break;
        case Material4Type.waveCut:
          path = _buildWaveCutPath(effectiveSize, config);
          break;
        case Material4Type.concaveRounded:
          path = _buildConcaveRoundedPath(effectiveSize, config);
          break;
        case Material4Type.convexRounded:
          path = _buildConvexRoundedPath(effectiveSize, config);
          break;
        case Material4Type.squircle:
          path = _buildSquirclePath(effectiveSize, config);
          break;
        case Material4Type.parallelogram:
          path = _buildParallelogramPath(effectiveSize, config);
          break;
        case Material4Type.ribbon:
          path = _buildRibbonPath(effectiveSize, config);
          break;
        case Material4Type.bookmark:
          path = _buildBookmarkPath(effectiveSize, config);
          break;
        case Material4Type.customBezier:
          path = _buildCustomBezierPath(effectiveSize, config);
          break;

        // --- Universal Next-Gen Shapes ---
        case Material4Type.superellipse:
          path = _buildSuperellipsePath(effectiveSize, config);
          break;
        case Material4Type.continuousSquircle:
          path = _buildContinuousSquirclePath(effectiveSize, config);
          break;
        case Material4Type.asymmetricBlob:
          path = _buildAsymmetricBlobPath(effectiveSize, config);
          break;
        case Material4Type.softDiamond:
          path = _buildSoftDiamondPath(effectiveSize, config);
          break;
        case Material4Type.roundedHexagon:
          path = _buildRoundedHexagonPath(effectiveSize, config);
          break;
        case Material4Type.roundedPentagon:
          path = _buildRoundedPentagonPath(effectiveSize, config);
          break;
        case Material4Type.ticket:
          path = _buildTicketPath(effectiveSize, config);
          break;
        case Material4Type.flower:
          path = _buildFlowerPath(effectiveSize, config);
          break;
        case Material4Type.starburst:
          path = _buildStarburstPath(effectiveSize, config);
          break;
        case Material4Type.leaf:
          path = _buildLeafPath(effectiveSize, config);
          break;
        case Material4Type.droplet:
          path = _buildDropletPath(effectiveSize, config);
          break;
        case Material4Type.liquid:
          path = _buildLiquidPath(effectiveSize, config);
          break;

        // --- Everyday UI shapes ---
        case Material4Type.ellipse:
          path = _buildEllipsePath(effectiveSize, config);
          break;
        case Material4Type.circle:
          path = _buildCirclePath(effectiveSize, config);
          break;
        case Material4Type.triangle:
          path = _buildTrianglePath(effectiveSize, config);
          break;
        case Material4Type.trapezoid:
          path = _buildTrapezoidPath(effectiveSize, config);
          break;
        case Material4Type.heart:
          path = _buildHeartPath(effectiveSize, config);
          break;
        case Material4Type.star:
          path = _buildStarPath(effectiveSize, config);
          break;
        case Material4Type.cross:
          path = _buildCrossPath(effectiveSize, config);
          break;
        case Material4Type.arrow:
          path = _buildArrowPath(effectiveSize, config);
          break;
        case Material4Type.chevron:
          path = _buildChevronPath(effectiveSize, config);
          break;
        case Material4Type.tag:
          path = _buildTagPath(effectiveSize, config);
          break;
        case Material4Type.crescent:
          path = _buildCrescentPath(effectiveSize, config);
          break;
        case Material4Type.gear:
          path = _buildGearPath(effectiveSize, config);
          break;
        case Material4Type.cutCorners:
          path = _buildCutCornersPath(effectiveSize, config);
          break;
      }
    }

    // 3. Multi-Notch Processing
    if (config.notches != null && config.notches!.isNotEmpty) {
      path = _applyMultiNotches(
          path, effectiveSize, config.notches!, config.resolvedCorners);
    }

    // 4. Transform Post-Processing
    final transform = config.resolvedTransform;
    if (transform.hasTransform) {
      path = transform.apply(path, effectiveSize);
    }

    return path;
  }

  // =========================================================================
  // --- ORIGINAL 13 SHAPES (100% Backwards Compatible) ---
  // =========================================================================

  static Path _buildFolderTabPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final tabW = math.min(config.tabWidth, w * 0.65);
    final tabH = math.min(config.tabHeight, h * 0.35);
    final r = math.max(
      0.0,
      math.min(
          config.cornerRadius, math.min(math.min(w, h) / 3, (h - tabH) / 2)),
    );
    // The tab's fillets must fit inside the tab and beside the body corners.
    final f = math.max(
      0.0,
      math.min(
        math.min(config.filletRadius, 14.0),
        math.min(tabH / 2, math.min((tabW - r) / 2, (w - tabW - r) / 2)),
      ),
    );
    if (config.anchor == ShapeAnchor.topRight) {
      path.moveTo(0, tabH + r);
      path.arcToPoint(
        Offset(r, tabH),
        radius: Radius.circular(r),
        clockwise: true,
      );
      final riseStart = w - tabW - f * 2;
      path.lineTo(riseStart, tabH);
      path.quadraticBezierTo(riseStart + f, tabH, riseStart + f, tabH - f);
      path.lineTo(riseStart + f, f);
      path.quadraticBezierTo(riseStart + f, 0, riseStart + f * 2, 0);
      path.lineTo(w - r, 0);
      path.arcToPoint(
        Offset(w, r),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(w, h - r);
      path.arcToPoint(
        Offset(w - r, h),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(r, h);
      path.arcToPoint(
        Offset(0, h - r),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.close();
    } else {
      path.moveTo(0, r);
      path.arcToPoint(
        Offset(r, 0),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(tabW - f * 2, 0);
      path.quadraticBezierTo(tabW - f, 0, tabW - f, f);
      path.lineTo(tabW - f, tabH - f);
      path.quadraticBezierTo(tabW - f, tabH, tabW, tabH);
      path.lineTo(w - r, tabH);
      path.arcToPoint(
        Offset(w, tabH + r),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(w, h - r);
      path.arcToPoint(
        Offset(w - r, h),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(r, h);
      path.arcToPoint(
        Offset(0, h - r),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.close();
    }
    return path;
  }

  static Path _buildNotchedBadgePath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final nW = math.min(config.tabWidth, w * 0.55);
    final nH = math.min(config.tabHeight, h * 0.45);
    final f = math.max(
      0.0,
      math.min(
          math.min(config.filletRadius, 14.0), math.min(nH / 2, (w - nW) / 4)),
    );
    final r = math.max(
      0.0,
      math.min(
        math.min(config.cornerRadius, 26.0),
        math.min(math.min((h - nH) / 2, nW / 2), (w - nW - 2 * f) / 2),
      ),
    );
    if (config.anchor == ShapeAnchor.topRight) {
      path.moveTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      final notchStart = w - nW - f * 2;
      path.lineTo(notchStart, 0);
      path.quadraticBezierTo(notchStart + f, 0, notchStart + f, f);
      path.lineTo(notchStart + f, nH - f);
      path.quadraticBezierTo(notchStart + f, nH, notchStart + f * 2, nH);
      path.lineTo(w - r, nH);
      path.arcToPoint(
        Offset(w, nH + r),
        radius: Radius.circular(r),
        clockwise: true,
      );
      path.lineTo(w, h - r);
      path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
      path.close();
    } else if (config.anchor == ShapeAnchor.bottomRight) {
      path.moveTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      path.lineTo(w - r, 0);
      path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
      path.lineTo(w, h - nH - r);
      path.arcToPoint(
        Offset(w - r, h - nH),
        radius: Radius.circular(r),
        clockwise: true,
      );
      final notchEnd = w - nW - f;
      path.lineTo(notchEnd + f, h - nH);
      path.quadraticBezierTo(notchEnd, h - nH, notchEnd, h - nH + f);
      path.lineTo(notchEnd, h - f);
      path.quadraticBezierTo(notchEnd, h, notchEnd - f, h);
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
      path.close();
    } else {
      path.moveTo(0, nH + r);
      path.arcToPoint(Offset(r, nH), radius: Radius.circular(r));
      path.lineTo(nW, nH);
      path.quadraticBezierTo(nW + f, nH, nW + f, nH - f);
      path.lineTo(nW + f, f);
      path.quadraticBezierTo(nW + f, 0, nW + f * 2, 0);
      path.lineTo(w - r, 0);
      path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
      path.lineTo(w, h - r);
      path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
      path.close();
    }
    return path;
  }

  static Path _buildSideTabPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final pDepth = math.min(math.min(config.protrusionDepth, 18.0), w * 0.25);
    final baseW = w - pDepth;
    final tabH = config.tabHeight.clamp(0.0, h * 0.6);
    final tabCenterY = h * 0.52;
    final tabStartY = tabCenterY - tabH / 2;
    final tabEndY = tabCenterY + tabH / 2;
    final f = math.max(
      0.0,
      math.min(
          math.min(config.filletRadius, 10.0), math.min(pDepth / 2, tabH / 4)),
    );
    // Tab corners can never be larger than the tab itself.
    final tabR = math.max(
      0.0,
      math.min(
          math.min(config.cornerRadius, 22.0), math.min(tabH / 2, pDepth - f)),
    );
    // Body corners must end before the tab's fillets begin.
    final r = math.max(
      0.0,
      math.min(
        math.min(config.cornerRadius, 22.0),
        math.min(
          baseW / 2,
          math.min(tabStartY - f, h - tabEndY - f),
        ),
      ),
    );

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(baseW - r, 0);
    path.arcToPoint(Offset(baseW, r), radius: Radius.circular(r));
    path.lineTo(baseW, tabStartY - f);
    path.quadraticBezierTo(baseW, tabStartY, baseW + f, tabStartY);
    path.lineTo(w - tabR, tabStartY);
    path.arcToPoint(Offset(w, tabStartY + tabR), radius: Radius.circular(tabR));
    path.lineTo(w, tabEndY - tabR);
    path.arcToPoint(Offset(w - tabR, tabEndY), radius: Radius.circular(tabR));
    path.lineTo(baseW + f, tabEndY);
    path.quadraticBezierTo(baseW, tabEndY, baseW, tabEndY + f);
    path.lineTo(baseW, h - r);
    path.arcToPoint(Offset(baseW - r, h), radius: Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.close();
    return path;
  }

  static Path _buildSteppedCornerPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final sW = math.min(config.tabWidth, w * 0.42);
    final sH = math.min(config.tabHeight, h * 0.42);
    final f =
        math.min(math.min(config.filletRadius, 14.0), math.min(sW, sH) / 2);
    final r = math.max(
      0.0,
      math.min(
        math.min(config.cornerRadius, 22.0),
        math.min(math.min(w, h) / 2, math.min(w - sW - f, h - sH - f)),
      ),
    );

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, h - sH - f);
    path.quadraticBezierTo(w, h - sH, w - f, h - sH);
    path.lineTo(w - sW + f, h - sH);
    path.quadraticBezierTo(w - sW, h - sH, w - sW, h - sH + f);
    path.lineTo(w - sW, h - f);
    path.quadraticBezierTo(w - sW, h, w - sW - f, h);
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.close();
    return path;
  }

  static Path _buildTicketScallopPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 20.0), math.min(w, h) / 4);
    final scR = math.max(
        0.0, math.min(math.min(config.scallopRadius, 12.0), h / 2 - r));

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    final midY = h * 0.5;
    path.lineTo(w, midY - scR);
    path.arcToPoint(
      Offset(w, midY + scR),
      radius: Radius.circular(scR),
      clockwise: false,
    );
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.lineTo(0, midY + scR);
    path.arcToPoint(
      Offset(0, midY - scR),
      radius: Radius.circular(scR),
      clockwise: false,
    );
    path.close();
    return path;
  }

  static Path _buildPostageStampPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 16.0), math.min(w, h) / 4);
    final scR =
        math.min(math.min(config.scallopRadius, 6.0), math.min(w, h) / 8);
    final diameter = scR * 2;

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

    final topSpan = (w - r * 2);
    final topCount = (topSpan / (diameter * 1.5)).floor();
    final topSpacing = topSpan / math.max(topCount, 1);
    for (int i = 0; i < topCount; i++) {
      final startX = r + i * topSpacing + (topSpacing - diameter) / 2;
      path.lineTo(startX, 0);
      path.arcToPoint(
        Offset(startX + diameter, 0),
        radius: Radius.circular(scR),
        clockwise: false,
      );
    }
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    final rightSpan = (h - r * 2);
    final rightCount = (rightSpan / (diameter * 1.5)).floor();
    final rightSpacing = rightSpan / math.max(rightCount, 1);
    for (int i = 0; i < rightCount; i++) {
      final startY = r + i * rightSpacing + (rightSpacing - diameter) / 2;
      path.lineTo(w, startY);
      path.arcToPoint(
        Offset(w, startY + diameter),
        radius: Radius.circular(scR),
        clockwise: false,
      );
    }
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));

    for (int i = topCount - 1; i >= 0; i--) {
      final startX = r + i * topSpacing + (topSpacing - diameter) / 2;
      path.lineTo(startX + diameter, h);
      path.arcToPoint(
        Offset(startX, h),
        radius: Radius.circular(scR),
        clockwise: false,
      );
    }
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));

    for (int i = rightCount - 1; i >= 0; i--) {
      final startY = r + i * rightSpacing + (rightSpacing - diameter) / 2;
      path.lineTo(0, startY + diameter);
      path.arcToPoint(
        Offset(0, startY),
        radius: Radius.circular(scR),
        clockwise: false,
      );
    }
    path.close();
    return path;
  }

  static Path _buildZigzagCutPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final tW = math.max(config.toothWidth, 8.0);
    final tH = math.min(math.min(config.toothHeight, 14.0), h * 0.3);
    final r = math.min(
        math.min(config.cornerRadius, 22.0), math.min(w / 2, (h - tH) / 2));

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, h - tH);

    final teethCount = (w / tW).floor();
    final actualToothW = w / math.max(teethCount, 1);
    for (int i = teethCount; i > 0; i--) {
      final toothStartX = i * actualToothW;
      final toothMidX = toothStartX - actualToothW * 0.5;
      final toothEndX = (i - 1) * actualToothW;
      path.lineTo(toothMidX, h);
      path.lineTo(toothEndX, h - tH);
    }
    path.lineTo(0, r);
    path.close();
    return path;
  }

  static Path _buildArchPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final bottomR =
        math.min(math.min(config.cornerRadius, 22.0), math.min(w, h) / 4);
    // A semicircular dome when there is room; an elliptical dome on wide,
    // short containers so the arch never grows past the bottom edge.
    final rx = w / 2;
    final ry = math.min(w / 2, h - bottomR);

    path.moveTo(0, ry);
    path.arcToPoint(Offset(w, ry), radius: Radius.elliptical(rx, ry));
    path.lineTo(w, h - bottomR);
    path.arcToPoint(Offset(w - bottomR, h), radius: Radius.circular(bottomR));
    path.lineTo(bottomR, h);
    path.arcToPoint(Offset(0, h - bottomR), radius: Radius.circular(bottomR));
    path.close();
    return path;
  }

  static Path _buildHexagonSoftPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    return _roundedPolygon(<Offset>[
      Offset(w * 0.5, 0),
      Offset(w, h * 0.25),
      Offset(w, h * 0.75),
      Offset(w * 0.5, h),
      Offset(0, h * 0.75),
      Offset(0, h * 0.25),
    ], math.min(config.cornerRadius, 14.0));
  }

  static Path _buildChamferDiagonalPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 20.0), math.min(w, h) / 4);
    final cSize = math.min(config.tabWidth, math.min(w, h) * 0.4);

    if (config.anchor == ShapeAnchor.topRight) {
      path.moveTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
      path.lineTo(w - cSize, 0);
      path.lineTo(w, cSize);
      path.lineTo(w, h - r);
      path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
      path.close();
    } else {
      path.moveTo(cSize, 0);
      path.lineTo(w - r, 0);
      path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
      path.lineTo(w, h - r);
      path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
      path.lineTo(0, cSize);
      path.close();
    }
    return path;
  }

  static Path _buildOrganicBlobPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(0, h * 0.4);
    path.cubicTo(0, h * 0.12, w * 0.12, 0, w * 0.45, 0);
    path.cubicTo(w * 0.78, 0, w, h * 0.15, w, h * 0.38);
    path.cubicTo(w, h * 0.72, w * 0.82, h, w * 0.55, h);
    path.cubicTo(w * 0.22, h, 0, h * 0.88, 0, h * 0.4);
    path.close();
    return path;
  }

  static Path _buildScallopedPetalPath(Size size, Material4Config config) {
    final path = Path();
    final count = math.max(config.petalCount, 4);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rBase = math.min(cx, cy);
    final rInner = rBase * 0.84;
    final rOuter = rBase;

    for (int i = 0; i < count; i++) {
      final theta1 = (i * 2 * math.pi) / count;
      final theta2 = ((i + 0.5) * 2 * math.pi) / count;
      final theta3 = ((i + 1) * 2 * math.pi) / count;

      final p1 = Offset(
        cx + rInner * math.cos(theta1),
        cy + rInner * math.sin(theta1),
      );
      final pCtrl = Offset(
        cx + rOuter * 1.08 * math.cos(theta2),
        cy + rOuter * 1.08 * math.sin(theta2),
      );
      final p3 = Offset(
        cx + rInner * math.cos(theta3),
        cy + rInner * math.sin(theta3),
      );

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      }
      path.quadraticBezierTo(pCtrl.dx, pCtrl.dy, p3.dx, p3.dy);
    }
    path.close();
    return path;
  }

  static Path _buildSmoothRoundedPath(Size size, Material4Config config) {
    // If independent cornerRadii provided, use them
    if (config.cornerRadii != null) {
      return _buildAsymmetricCardPath(size, config);
    }
    final r = math.min(
      config.cornerRadius,
      math.min(size.width, size.height) / 2,
    );
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(r)),
      );
  }

  // =========================================================================
  // --- NEXT-GEN SHAPE GEOMETRY BUILDERS (15 New Additions) ---
  // =========================================================================

  /// 1. Asymmetric Card with 4 independent corner radii and CSS proportional downscaling.
  static Path _buildAsymmetricCardPath(Size size, Material4Config config) {
    final sanitizedCorners = config.resolvedCorners.sanitize(size);
    final rrect = sanitizedCorners.toRRect(Offset.zero & size);
    return Path()..addRRect(rrect);
  }

  /// 2. Capsule / Pill shape with semicircular rounded ends.
  static Path _buildCapsulePath(Size size, Material4Config config) {
    final radius = math.min(size.width, size.height) / 2;
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
  }

  /// 3. Wave Edge container with a flowing sine wave along the anchor edge.
  static Path _buildWaveEdgePath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final waves = math.max(config.waveCount, 1.0);
    final amp = math.min(config.waveAmplitude, h * 0.25);
    final r = math.max(
      0.0,
      math.min(
          math.min(config.cornerRadius, 22.0), math.min(w / 4, (h - amp) / 2)),
    );

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // Right edge down to wave start
    path.lineTo(w, h - amp - r);
    path.arcToPoint(Offset(w - r, h - amp), radius: Radius.circular(r));

    // Wavy bottom edge from right to left
    final waveSpan = (w - r * 2);
    // A whole number of half-waves so the crest ends exactly at the corner.
    final halfWaves = math.max(1, (waves * 2).round());
    final step = waveSpan / halfWaves;
    for (int i = 0; i < halfWaves; i++) {
      final nextX = (w - r) - (i + 1) * step;
      final ctrlX = (w - r) - (i + 0.5) * step;
      final ctrlY = (i % 2 == 0) ? h : h - amp * 2;
      path.quadraticBezierTo(ctrlX, ctrlY, nextX, h - amp);
    }

    // Bottom left corner
    path.arcToPoint(Offset(0, h - amp - r), radius: Radius.circular(r));
    path.close();
    return path;
  }

  /// 4. Cloud shape with overlapping rounded lobes.

  static Path _buildCloudPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    // A rounded base plus three overlapping puffs, all kept inside the bounds.
    final baseR = math.min(h * 0.25, w * 0.15);
    Path circle(double cx, double cy, double r) =>
        Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    var path = Path()
      ..addRRect(RRect.fromLTRBR(0, h * 0.5, w, h, Radius.circular(baseR)));
    for (final puff in [
      circle(w * 0.25, h * 0.62, math.min(w * 0.2, h * 0.38)),
      circle(w * 0.5, h * 0.45, math.min(w * 0.26, h * 0.45)),
      circle(w * 0.74, h * 0.58, math.min(w * 0.2, h * 0.42)),
    ]) {
      path = Path.combine(PathOperation.union, path, puff);
    }
    return path;
  }

  /// 5. Speech Bubble with an integrated pointer tail.
  static Path _buildSpeechBubblePath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final tailW = math.min(config.speechBubbleTailWidth, w * 0.3);
    final tailH = math.min(config.speechBubbleTailHeight, h * 0.3);
    final bodyH = h - tailH;
    final r = math.min(config.cornerRadius, math.min(bodyH / 3, w / 4));

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, bodyH - r);
    path.arcToPoint(Offset(w - r, bodyH), radius: Radius.circular(r));

    // Bottom edge with tail pointing down
    if (config.anchor == ShapeAnchor.bottomRight) {
      path.lineTo(w - r - tailW, bodyH);
      path.lineTo(w - r - tailW * 0.5, h);
      path.lineTo(w - r, bodyH);
      path.lineTo(r, bodyH);
    } else {
      // Default: bottom-left tail
      path.lineTo(r + tailW * 1.5, bodyH);
      path.lineTo(r + tailW * 0.5, h);
      path.lineTo(r + tailW * 0.2, bodyH);
      path.lineTo(r, bodyH);
    }

    path.arcToPoint(Offset(0, bodyH - r), radius: Radius.circular(r));
    path.close();
    return path;
  }

  /// 6. Shield / Heraldic academic crest shape.
  static Path _buildShieldPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 20.0), math.min(w, h) / 4);
    final dip = math.min(4.0, h * 0.03);

    // Top edge with subtle crest dip
    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.quadraticBezierTo(w * 0.5, dip, w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // Vertical upper sides
    path.lineTo(w, h * 0.52);

    // Flow down to shield apex
    path.cubicTo(w, h * 0.82, w * 0.65, h * 0.95, w * 0.5, h);
    path.cubicTo(w * 0.35, h * 0.95, 0, h * 0.82, 0, h * 0.52);
    path.close();
    return path;
  }

  /// 7. Diamond / Rhombus with rounded vertices.

  static Path _buildDiamondPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    return _roundedPolygon(<Offset>[
      Offset(w * 0.5, 0),
      Offset(w, h * 0.5),
      Offset(w * 0.5, h),
      Offset(0, h * 0.5),
    ], math.min(config.cornerRadius, 14.0));
  }

  /// 8. Regular 8-sided Octagon with rounded vertex transitions.

  static Path _buildOctagonPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final cW = w * 0.28;
    final cH = h * 0.28;
    return _roundedPolygon(<Offset>[
      Offset(cW, 0),
      Offset(w - cW, 0),
      Offset(w, cH),
      Offset(w, h - cH),
      Offset(w - cW, h),
      Offset(cW, h),
      Offset(0, h - cH),
      Offset(0, cH),
    ], math.min(config.cornerRadius, 12.0));
  }

  /// 9. Wave Cut sliced container.

  static Path _buildWaveCutPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 22.0), math.min(w, h) / 4);
    final cutY = h * 0.65;
    final amp = math.min(math.min(config.waveAmplitude, 20.0), cutY * 0.5);

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, cutY);

    // Diagonal S-wave cut to the bottom-left. The last control point sits on
    // the bottom edge so the curve never dips below the container.
    path.cubicTo(w * 0.75, cutY - amp, w * 0.35, h, r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.close();
    return path;
  }

  /// 10. Concave Rounded corners (inward curved corners for ornate frames).
  static Path _buildConcaveRoundedPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, math.min(w, h) * 0.25);

    // Start at top edge after top-left concave corner
    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: false);
    path.lineTo(w, h - r);
    path.arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(r, h);
    path.arcToPoint(
      Offset(0, h - r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: false);
    path.close();
    return path;
  }

  /// 11. Convex Rounded (barrel curved expanding edges).

  static Path _buildConvexRoundedPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    // Edges bulge outward by `b`, so the straight frame is inset by `b` and
    // every bulge just touches the container edge instead of overflowing it.
    final b =
        math.min(math.min(config.waveAmplitude, 14.0), math.min(w, h) * 0.12);
    final l = b, t = b, rt = w - b, bt = h - b;
    final r = math.min(10.0, (math.min(w, h) - 2 * b) / 4);

    path.moveTo(l + r, t);
    path.quadraticBezierTo(w / 2, t - 2 * b, rt - r, t);
    path.arcToPoint(Offset(rt, t + r), radius: Radius.circular(r));
    path.quadraticBezierTo(rt + 2 * b, h / 2, rt, bt - r);
    path.arcToPoint(Offset(rt - r, bt), radius: Radius.circular(r));
    path.quadraticBezierTo(w / 2, bt + 2 * b, l + r, bt);
    path.arcToPoint(Offset(l, bt - r), radius: Radius.circular(r));
    path.quadraticBezierTo(l - 2 * b, h / 2, l, t + r);
    path.arcToPoint(Offset(l + r, t), radius: Radius.circular(r));
    path.close();
    return path;
  }

  /// 12. True mathematical Squircle (iOS super-ellipse approximation).
  static Path _buildSquirclePath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, math.min(w, h) * 0.5);
    final c = r * 0.68; // Super-ellipse control weight

    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.cubicTo(w - r + c, 0, w, r - c, w, r);
    path.lineTo(w, h - r);
    path.cubicTo(w, h - r + c, w - r + c, h, w - r, h);
    path.lineTo(r, h);
    path.cubicTo(r - c, h, 0, h - r + c, 0, h - r);
    path.lineTo(0, r);
    path.cubicTo(0, r - c, r - c, 0, r, 0);
    path.close();
    return path;
  }

  /// 13. Slanted Parallelogram with customizable skew angle.

  static Path _buildParallelogramPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final rad = config.skewAngle * (math.pi / 180.0);
    final dx = (math.tan(rad) * h).clamp(-w * 0.35, w * 0.35);
    return _roundedPolygon(<Offset>[
      Offset(dx > 0 ? dx : 0, 0),
      Offset(dx > 0 ? w : w + dx, 0),
      Offset(dx > 0 ? w - dx : w, h),
      Offset(dx > 0 ? 0 : -dx, h),
    ], math.min(config.cornerRadius, 14.0));
  }

  /// 14. Banner Ribbon with triangular swallowtail cutouts.
  static Path _buildRibbonPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final fold = math.min(config.ribbonFoldDepth, w * 0.2);

    path.moveTo(0, 0);
    path.lineTo(w, 0);
    path.lineTo(w - fold, h * 0.5);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.lineTo(fold, h * 0.5);
    path.close();
    return path;
  }

  /// 15. Hanging Bookmark with an inverted bottom V-tail.
  static Path _buildBookmarkPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 16.0), math.min(w, h) / 4);
    final tailCut = math.min(config.ribbonFoldDepth, h * 0.35);

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // Right edge down to bottom cut
    path.lineTo(w, h);

    // Inverted V-cut up to center apex, then down to left
    path.lineTo(w * 0.5, h - tailCut);
    path.lineTo(0, h);

    path.close();
    return path;
  }

  /// 16. Custom Bézier path builder (supporting declarative CustomBezierConfig and legacy callback).
  static Path _buildCustomBezierPath(Size size, Material4Config config) {
    if (config.bezierConfig != null) {
      return config.bezierConfig!.toPath(size);
    }
    if (config.customBezierBuilder != null) {
      return config.customBezierBuilder!(size);
    }
    return _buildSmoothRoundedPath(size, config);
  }

  // =========================================================================
  // --- INDEPENDENT 4-EDGE GEOMETRY BUILDER ---
  // =========================================================================

  static Path _buildCustomEdgesPath(Size size, Material4Config config) {
    final corners = config.resolvedCorners.sanitize(size);
    final edges = config.edges!;
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Start at top-left corner end: (tl.x, 0)
    path.moveTo(corners.topLeft.x, 0.0);

    // 1. Top Edge: (tl.x, 0) -> (w - tr.x, 0)
    final topStart = Offset(corners.topLeft.x, 0.0);
    final topEnd = Offset(w - corners.topRight.x, 0.0);
    _traceEdge(path, topStart, topEnd, edges.top, ShapeEdge.top);

    // Top-right corner arc
    if (corners.topRight.x > 0 && corners.topRight.y > 0) {
      path.arcToPoint(
        Offset(w, corners.topRight.y),
        radius: corners.topRight,
      );
    } else {
      path.lineTo(w, 0.0);
    }

    // 2. Right Edge: (w, tr.y) -> (w, h - br.y)
    final rightStart = Offset(w, corners.topRight.y);
    final rightEnd = Offset(w, h - corners.bottomRight.y);
    _traceEdge(path, rightStart, rightEnd, edges.right, ShapeEdge.right);

    // Bottom-right corner arc
    if (corners.bottomRight.x > 0 && corners.bottomRight.y > 0) {
      path.arcToPoint(
        Offset(w - corners.bottomRight.x, h),
        radius: corners.bottomRight,
      );
    } else {
      path.lineTo(w, h);
    }

    // 3. Bottom Edge: (w - br.x, h) -> (bl.x, h)
    final bottomStart = Offset(w - corners.bottomRight.x, h);
    final bottomEnd = Offset(corners.bottomLeft.x, h);
    _traceEdge(path, bottomStart, bottomEnd, edges.bottom, ShapeEdge.bottom);

    // Bottom-left corner arc
    if (corners.bottomLeft.x > 0 && corners.bottomLeft.y > 0) {
      path.arcToPoint(
        Offset(0.0, h - corners.bottomLeft.y),
        radius: corners.bottomLeft,
      );
    } else {
      path.lineTo(0.0, h);
    }

    // 4. Left Edge: (0, h - bl.y) -> (0, tl.y)
    final leftStart = Offset(0.0, h - corners.bottomLeft.y);
    final leftEnd = Offset(0.0, corners.topLeft.y);
    _traceEdge(path, leftStart, leftEnd, edges.left, ShapeEdge.left);

    // Top-left corner arc
    if (corners.topLeft.x > 0 && corners.topLeft.y > 0) {
      path.arcToPoint(
        Offset(corners.topLeft.x, 0.0),
        radius: corners.topLeft,
      );
    } else {
      path.lineTo(0.0, 0.0);
    }

    path.close();
    return path;
  }

  static void _traceEdge(
    Path path,
    Offset p1,
    Offset p2,
    ShapeEdgeConfig edge,
    ShapeEdge shapeEdge,
  ) {
    final diff = p2 - p1;
    final length = diff.distance;
    if (length < 1e-4 || edge.isStraight) {
      path.lineTo(p2.dx, p2.dy);
      return;
    }

    final tangent = diff / length;
    // Outward clockwise normal: for tangent (tx, ty), normal is (ty, -tx)
    final normal = Offset(tangent.dy, -tangent.dx);

    switch (edge.style) {
      case ShapeEdgeStyle.straight:
        path.lineTo(p2.dx, p2.dy);
        break;

      case ShapeEdgeStyle.convex:
      case ShapeEdgeStyle.concave:
        final isConvex = edge.style == ShapeEdgeStyle.convex;
        final dir = (isConvex ? 1.0 : -1.0) * (edge.isMirrored ? -1.0 : 1.0);
        final depth = edge.depth;
        final mid = (p1 + p2) * 0.5;
        final ctrl = mid + normal * (depth * dir * 2.0);
        path.quadraticBezierTo(ctrl.dx, ctrl.dy, p2.dx, p2.dy);
        break;

      case ShapeEdgeStyle.wave:
        final waves = math.max(1.0, edge.waveCount);
        final halfWaves = (waves * 2).round();
        final step = length / halfWaves;
        final amp = edge.waveAmplitude;
        final mirrorSign = edge.isMirrored ? -1.0 : 1.0;

        for (int i = 0; i < halfWaves; i++) {
          final segEnd = p1 + tangent * ((i + 1) * step);
          final segMid = (p1 + tangent * (i * step) + segEnd) * 0.5;
          final waveDir = ((i % 2 == 0) ? 1.0 : -1.0) * mirrorSign;
          final ctrl = segMid + normal * (amp * waveDir * 2.0);
          path.quadraticBezierTo(ctrl.dx, ctrl.dy, segEnd.dx, segEnd.dy);
        }
        break;

      case ShapeEdgeStyle.zigzag:
        final tW = math.max(4.0, edge.toothWidth);
        final count = math.max(1, (length / tW).floor());
        final actualTW = length / count;
        final depth = edge.depth;
        final mirrorSign = edge.isMirrored ? -1.0 : 1.0;

        for (int i = 0; i < count; i++) {
          final peakOffset = p1 +
              tangent * ((i + 0.5) * actualTW) +
              normal * (depth * mirrorSign);
          final valleyOffset = p1 + tangent * ((i + 1) * actualTW);
          path.lineTo(peakOffset.dx, peakOffset.dy);
          path.lineTo(valleyOffset.dx, valleyOffset.dy);
        }
        break;

      case ShapeEdgeStyle.customBezier:
        if (edge.customBezier != null) {
          final bz = edge.customBezier!;
          final bzDepth = edge.depth != 0.0 ? edge.depth : length;
          final mirrorSign = edge.isMirrored ? -1.0 : 1.0;

          Offset mapLocal(Offset pt) {
            final u = bz.isNormalized ? pt.dx * length : pt.dx;
            final v = (bz.isNormalized ? pt.dy * bzDepth : pt.dy) * mirrorSign;
            return p1 + tangent * u + normal * v;
          }

          final cp1 = mapLocal(bz.controlPoint1);
          if (bz.isCubic) {
            final cp2 = mapLocal(bz.controlPoint2!);
            final targetEnd = mapLocal(bz.end);
            path.cubicTo(
                cp1.dx, cp1.dy, cp2.dx, cp2.dy, targetEnd.dx, targetEnd.dy);
          } else {
            final targetEnd = mapLocal(bz.end);
            path.quadraticBezierTo(cp1.dx, cp1.dy, targetEnd.dx, targetEnd.dy);
          }
        } else {
          path.lineTo(p2.dx, p2.dy);
        }
        break;
    }
  }

  // =========================================================================
  // --- MULTI-NOTCH POST PROCESSING ---
  // =========================================================================

  static Path _applyMultiNotches(
    Path basePath,
    Size size,
    List<ShapeNotch> notches,
    ShapeCorners corners,
  ) {
    final report = ShapeNotch.evaluateNotches(
      notches: notches,
      size: size,
      corners: corners,
    );

    Path result = basePath;
    for (final notch in report.sanitizedNotches) {
      final nW = notch.width;
      final nD = notch.depth;
      final fillet = math.min(notch.cornerRadius, math.min(nW, nD) / 2);

      Rect notchRect;
      switch (notch.edge) {
        case ShapeEdge.top:
          final start = notch.resolveEdgeOffset(size.width);
          notchRect = Rect.fromLTWH(start, 0, nW, nD);
          break;
        case ShapeEdge.bottom:
          final start = notch.resolveEdgeOffset(size.width);
          notchRect = Rect.fromLTWH(start, size.height - nD, nW, nD);
          break;
        case ShapeEdge.left:
          final start = notch.resolveEdgeOffset(size.height);
          notchRect = Rect.fromLTWH(0, start, nD, nW);
          break;
        case ShapeEdge.right:
          final start = notch.resolveEdgeOffset(size.height);
          notchRect = Rect.fromLTWH(size.width - nD, start, nD, nW);
          break;
      }

      if (!notchRect.isEmpty) {
        final notchPath = Path()
          ..addRRect(
            RRect.fromRectAndRadius(notchRect, Radius.circular(fillet)),
          );
        if (notch.isInward) {
          result = Path.combine(PathOperation.difference, result, notchPath);
        } else {
          result = Path.combine(PathOperation.union, result, notchPath);
        }
      }
    }
    return result;
  }

  // =========================================================================
  // UNIVERSAL NEXT-GEN SHAPE BUILDERS
  // =========================================================================

  /// 1. Mathematical Lamé curve super-ellipse with configurable exponent.

  static Path _buildSuperellipsePath(Size size, Material4Config config) {
    return Material4CustomShape.superellipse(n: config.superellipseExponent)
        .buildPath(size);
  }

  /// 2. Curvature-continuous C2 squircle arc.
  static Path _buildContinuousSquirclePath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius * 1.25, math.min(w, h) * 0.48);

    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.cubicTo(w - r * 0.4, 0, w, r * 0.4, w, r);
    path.lineTo(w, h - r);
    path.cubicTo(w, h - r * 0.4, w - r * 0.4, h, w - r, h);
    path.lineTo(r, h);
    path.cubicTo(r * 0.4, h, 0, h - r * 0.4, 0, h - r);
    path.lineTo(0, r);
    path.cubicTo(0, r * 0.4, r * 0.4, 0, r, 0);
    path.close();
    return path;
  }

  /// 3. Asymmetric procedural multi-control point organic blob.

  static Path _buildAsymmetricBlobPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Every joint has collinear control handles, so the outline has no kinks.
    path.moveTo(0, h * 0.45);
    path.cubicTo(0, h * 0.15, w * 0.28, 0, w * 0.58, 0);
    path.cubicTo(w * 0.88, 0, w, h * 0.22, w * 0.96, h * 0.54);
    path.cubicTo(w * 0.92, h * 0.82, w * 0.72, h, w * 0.42, h);
    path.cubicTo(w * 0.18, h, 0, h * 0.8, 0, h * 0.45);
    path.close();
    return path;
  }

  /// 4. Symmetrical diamond with outward curved convex facets.
  static Path _buildSoftDiamondPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, 0);
    path.quadraticBezierTo(w * 0.82, h * 0.18, w, h * 0.5);
    path.quadraticBezierTo(w * 0.82, h * 0.82, w * 0.5, h);
    path.quadraticBezierTo(w * 0.18, h * 0.82, 0, h * 0.5);
    path.quadraticBezierTo(w * 0.18, h * 0.18, w * 0.5, 0);
    path.close();
    return path;
  }

  /// 5. Regular 6-sided polygon with smooth corner fillets.
  static Path _buildRoundedHexagonPath(Size size, Material4Config config) {
    return Material4CustomShape.polygon(
      sides: 6,
      cornerRadius: config.cornerRadius > 0 ? config.cornerRadius : 16.0,
    ).buildPath(size);
  }

  /// 6. Regular 5-sided polygon with smooth corner fillets.
  static Path _buildRoundedPentagonPath(Size size, Material4Config config) {
    return Material4CustomShape.polygon(
      sides: 5,
      cornerRadius: config.cornerRadius > 0 ? config.cornerRadius : 16.0,
    ).buildPath(size);
  }

  /// 7. Event voucher ticket with opposing circular notch bites.
  static Path _buildTicketPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(math.min(config.cornerRadius, 18.0), math.min(w, h) / 4);
    final notchR = math.min(
        config.scallopRadius > 0 ? config.scallopRadius : 16.0, h * 0.25);

    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    path.lineTo(w, h * 0.5 - notchR);
    path.arcToPoint(
      Offset(w, h * 0.5 + notchR),
      radius: Radius.circular(notchR),
      clockwise: false,
    );
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    path.lineTo(0, h * 0.5 + notchR);
    path.arcToPoint(
      Offset(0, h * 0.5 - notchR),
      radius: Radius.circular(notchR),
      clockwise: false,
    );
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.close();
    return path;
  }

  /// 8. Multi-petal circular botanical blossom silhouette.
  static Path _buildFlowerPath(Size size, Material4Config config) {
    final path = Path();
    final petals = math.max(config.petalCount > 0 ? config.petalCount : 8, 4);
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;
    final maxR = math.min(cx, cy);
    final innerR = maxR * 0.65;

    for (int i = 0; i < petals; i++) {
      final aStart = (i * 2 * math.pi) / petals;
      final aMid = ((i + 0.5) * 2 * math.pi) / petals;
      final aEnd = ((i + 1) * 2 * math.pi) / petals;

      final pStart = Offset(
          cx + innerR * math.cos(aStart), cy + innerR * math.sin(aStart));
      final pTip =
          Offset(cx + maxR * math.cos(aMid), cy + maxR * math.sin(aMid));
      final pEnd =
          Offset(cx + innerR * math.cos(aEnd), cy + innerR * math.sin(aEnd));

      if (i == 0) path.moveTo(pStart.dx, pStart.dy);
      path.quadraticBezierTo(pTip.dx, pTip.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
  }

  /// 9. Multi-pointed starburst badge emblem.
  static Path _buildStarburstPath(Size size, Material4Config config) {
    return Material4CustomShape.star(
      points: math.max(config.petalCount > 0 ? config.petalCount : 12, 6),
      innerRadiusRatio: 0.72,
      cornerRadius:
          config.cornerRadius > 0 ? math.min(config.cornerRadius, 6.0) : 4.0,
    ).buildPath(size);
  }

  /// 10. Natural pointed botanical leaf silhouette.
  static Path _buildLeafPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(0, h);
    path.cubicTo(0, h * 0.28, w * 0.28, 0, w, 0);
    path.cubicTo(w, h * 0.72, w * 0.72, h, 0, h);
    path.close();
    return path;
  }

  /// 11. Teardrop water droplet with pointed apex and rounded base.
  static Path _buildDropletPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, 0);
    path.cubicTo(w * 0.88, h * 0.45, w, h * 0.65, w * 0.85, h * 0.88);
    path.cubicTo(w * 0.7, h, w * 0.3, h, w * 0.15, h * 0.88);
    path.cubicTo(0, h * 0.65, w * 0.12, h * 0.45, w * 0.5, 0);
    path.close();
    return path;
  }

  /// 12. Fluid organic metaball liquid droplet shape.
  static Path _buildLiquidPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.2, h * 0.15);
    path.cubicTo(w * 0.45, 0, w * 0.8, h * 0.05, w * 0.9, h * 0.35);
    path.cubicTo(w, h * 0.65, w * 0.85, h * 0.92, w * 0.55, h * 0.98);
    path.cubicTo(w * 0.25, h * 1.04, 0, h * 0.85, 0, h * 0.55);
    path.cubicTo(0, h * 0.25, w * 0.05, h * 0.22, w * 0.2, h * 0.15);
    path.close();
    return path;
  }

  // =========================================================================
  // SHARED GEOMETRY HELPERS
  // =========================================================================

  /// Builds a closed polygon whose every vertex is rounded by a quadratic
  /// fillet. Each fillet is clamped to half of its shorter neighbouring edge,
  /// so fillets never overlap and the outline never leaves the polygon's hull.
  static Path _roundedPolygon(List<Offset> points, double radius) {
    final n = points.length;
    final path = Path();
    for (int i = 0; i < n; i++) {
      final prev = points[(i - 1 + n) % n];
      final curr = points[i];
      final next = points[(i + 1) % n];
      final d1 = curr - prev;
      final d2 = next - curr;
      final l1 = d1.distance;
      final l2 = d2.distance;
      final r = (l1 == 0 || l2 == 0)
          ? 0.0
          : math.max(0.0, math.min(radius, math.min(l1, l2) / 2));
      final start = l1 == 0 ? curr : curr - d1 / l1 * r;
      final end = l2 == 0 ? curr : curr + d2 / l2 * r;
      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        path.lineTo(start.dx, start.dy);
      }
      path.quadraticBezierTo(curr.dx, curr.dy, end.dx, end.dy);
    }
    return path..close();
  }

  // =========================================================================
  // EVERYDAY UI SHAPES
  // =========================================================================

  /// Ellipse filling the whole container.
  static Path _buildEllipsePath(Size size, Material4Config config) =>
      Path()..addOval(Offset.zero & size);

  /// Perfect circle centred in the container (diameter = shorter side).
  static Path _buildCirclePath(Size size, Material4Config config) => Path()
    ..addOval(Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: math.min(size.width, size.height) / 2,
    ));

  /// Upward-pointing triangle with rounded vertices.
  static Path _buildTrianglePath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    return _roundedPolygon(
      [Offset(w / 2, 0), Offset(w, h), Offset(0, h)],
      math.min(config.cornerRadius, math.min(w, h) * 0.12),
    );
  }

  /// Trapezoid narrower at the top; the slant follows [Material4Config.skewAngle].
  static Path _buildTrapezoidPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final inset = (math.tan(config.skewAngle.abs() * math.pi / 180) * h)
        .clamp(w * 0.05, w * 0.35);
    return _roundedPolygon(
      [Offset(inset, 0), Offset(w - inset, 0), Offset(w, h), Offset(0, h)],
      math.min(config.cornerRadius, math.min(w, h) * 0.15),
    );
  }

  /// Symmetric heart; the lobes touch the top edge and the tip the bottom.
  static Path _buildHeartPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.5, h)
      ..cubicTo(w * 0.5, h, 0, h * 0.68, 0, h * 0.3)
      ..cubicTo(0, h * 0.12, w * 0.14, 0, w * 0.29, 0)
      ..cubicTo(w * 0.4, 0, w * 0.47, h * 0.07, w * 0.5, h * 0.16)
      ..cubicTo(w * 0.53, h * 0.07, w * 0.6, 0, w * 0.71, 0)
      ..cubicTo(w * 0.86, 0, w, h * 0.12, w, h * 0.3)
      ..cubicTo(w, h * 0.68, w * 0.5, h, w * 0.5, h)
      ..close();
  }

  /// Classic five-point star with softened tips.
  static Path _buildStarPath(Size size, Material4Config config) {
    return Material4CustomShape.star(
      points: 5,
      innerRadiusRatio: 0.48,
      cornerRadius: math.min(config.cornerRadius, 4.0),
    ).buildPath(size);
  }

  /// Plus / cross with equal arms (arm thickness = 36% of the shorter side).
  static Path _buildCrossPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final t = math.min(w, h) * 0.36;
    final cx = w / 2, cy = h / 2, a = t / 2;
    return _roundedPolygon([
      Offset(cx - a, 0),
      Offset(cx + a, 0),
      Offset(cx + a, cy - a),
      Offset(w, cy - a),
      Offset(w, cy + a),
      Offset(cx + a, cy + a),
      Offset(cx + a, h),
      Offset(cx - a, h),
      Offset(cx - a, cy + a),
      Offset(0, cy + a),
      Offset(0, cy - a),
      Offset(cx - a, cy - a),
    ], math.min(config.cornerRadius, t * 0.25));
  }

  /// Right-pointing arrow (rotate with [Material4Config] transforms for other
  /// directions).
  static Path _buildArrowPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final head = math.min(w * 0.4, h);
    final shaft = h * 0.45;
    final cy = h / 2;
    return _roundedPolygon([
      Offset(0, cy - shaft / 2),
      Offset(w - head, cy - shaft / 2),
      Offset(w - head, 0),
      Offset(w, cy),
      Offset(w - head, h),
      Offset(w - head, cy + shaft / 2),
      Offset(0, cy + shaft / 2),
    ], math.min(config.cornerRadius, h * 0.08));
  }

  /// Chevron / breadcrumb step pointing right.
  static Path _buildChevronPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final d = math.min(w * 0.3, h * 0.5);
    return _roundedPolygon([
      Offset.zero,
      Offset(w - d, 0),
      Offset(w, h / 2),
      Offset(w - d, h),
      Offset(0, h),
      Offset(d, h / 2),
    ], math.min(config.cornerRadius, h * 0.08));
  }

  /// Price / label tag pointing left, with a punched string hole.
  static Path _buildTagPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final d = math.min(h * 0.5, w * 0.3);
    final body = _roundedPolygon([
      Offset(d, 0),
      Offset(w, 0),
      Offset(w, h),
      Offset(d, h),
      Offset(0, h / 2),
    ], math.min(config.cornerRadius, h * 0.15));
    final holeR = math.min(h * 0.08, d * 0.25);
    final hole = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(d * 0.75, h / 2), radius: holeR));
    return Path.combine(PathOperation.difference, body, hole);
  }

  /// Crescent moon opening toward the top-right.
  static Path _buildCrescentPath(Size size, Material4Config config) {
    final c = size.center(Offset.zero);
    final r = math.min(size.width, size.height) / 2;
    final outer = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    final bite = Path()
      ..addOval(Rect.fromCircle(
        center: c + Offset(r * 0.45, -r * 0.25),
        radius: r * 0.82,
      ));
    return Path.combine(PathOperation.difference, outer, bite);
  }

  /// Cog wheel; the tooth count follows [Material4Config.petalCount].
  static Path _buildGearPath(Size size, Material4Config config) {
    final c = size.center(Offset.zero);
    final outer = math.min(size.width, size.height) / 2;
    final root = outer * 0.8;
    final teeth = config.petalCount.clamp(6, 24);
    final step = 2 * math.pi / teeth;
    Offset at(double radius, double a) =>
        c + Offset(radius * math.cos(a), radius * math.sin(a));
    final pts = <Offset>[];
    for (int i = 0; i < teeth; i++) {
      final a = -math.pi / 2 + i * step;
      pts
        ..add(at(root, a))
        ..add(at(outer, a + step * 0.15))
        ..add(at(outer, a + step * 0.45))
        ..add(at(root, a + step * 0.6));
    }
    return _roundedPolygon(pts, math.min(config.cornerRadius, outer * 0.05));
  }

  /// Rectangle with all four corners cut at 45° (sci-fi / HUD panels);
  /// the cut size follows [Material4Config.cornerRadius].
  static Path _buildCutCornersPath(Size size, Material4Config config) {
    final w = size.width;
    final h = size.height;
    final c = math.min(config.cornerRadius, math.min(w, h) * 0.3);
    return _roundedPolygon([
      Offset(c, 0),
      Offset(w - c, 0),
      Offset(w, c),
      Offset(w, h - c),
      Offset(w - c, h),
      Offset(c, h),
      Offset(0, h - c),
      Offset(0, c),
    ], 0);
  }
}
