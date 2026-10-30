import 'dart:math' as math;

import 'package:flutter/material.dart';

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
    if (config.edges != null && !config.edges!.isAllStraight) {
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
    final r = math.min(config.cornerRadius, math.min(w, h) / 3);
    final f = math.min(config.filletRadius, 14.0);
    final tabW = math.min(config.tabWidth, w * 0.65);
    final tabH = math.min(config.tabHeight, h * 0.35);

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
    final r = math.min(config.cornerRadius, 26.0);
    final f = math.min(config.filletRadius, 14.0);
    final nW = math.min(config.tabWidth, w * 0.55);
    final nH = math.min(config.tabHeight, h * 0.45);

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
    final r = math.min(config.cornerRadius, 22.0);
    final f = math.min(config.filletRadius, 10.0);
    final pDepth = math.min(config.protrusionDepth, 18.0);
    final baseW = w - pDepth;

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(baseW - r, 0);
    path.arcToPoint(Offset(baseW, r), radius: Radius.circular(r));

    final tabCenterY = h * 0.52;
    final halfTabH = config.tabHeight * 0.5;
    final tabStartY = tabCenterY - halfTabH;
    final tabEndY = tabCenterY + halfTabH;

    path.lineTo(baseW, tabStartY - f);
    path.quadraticBezierTo(baseW, tabStartY, baseW + f, tabStartY);
    path.lineTo(w - r, tabStartY);
    path.arcToPoint(
      Offset(w, tabStartY + r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(w, tabEndY - r);
    path.arcToPoint(
      Offset(w - r, tabEndY),
      radius: Radius.circular(r),
      clockwise: true,
    );
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
    final r = math.min(config.cornerRadius, 22.0);
    final f = math.min(config.filletRadius, 14.0);
    final sW = math.min(config.tabWidth, w * 0.42);
    final sH = math.min(config.tabHeight, h * 0.42);

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
    final r = math.min(config.cornerRadius, 20.0);
    final scR = math.min(config.scallopRadius, 12.0);

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
    final r = math.min(config.cornerRadius, 16.0);
    final scR = math.min(config.scallopRadius, 6.0);
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
    final r = math.min(config.cornerRadius, 22.0);
    final tW = math.max(config.toothWidth, 8.0);
    final tH = math.min(config.toothHeight, 14.0);

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
    final bottomR = math.min(config.cornerRadius, 22.0);
    final domeRadius = w / 2;

    path.moveTo(0, domeRadius);
    path.arcToPoint(
      Offset(w, domeRadius),
      radius: Radius.circular(domeRadius),
      clockwise: true,
    );
    path.lineTo(w, h - bottomR);
    path.arcToPoint(Offset(w - bottomR, h), radius: Radius.circular(bottomR));
    path.lineTo(bottomR, h);
    path.arcToPoint(Offset(0, h - bottomR), radius: Radius.circular(bottomR));
    path.lineTo(0, domeRadius);
    path.close();
    return path;
  }

  static Path _buildHexagonSoftPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 14.0);

    final points = <Offset>[
      Offset(w * 0.5, 0),
      Offset(w, h * 0.25),
      Offset(w, h * 0.75),
      Offset(w * 0.5, h),
      Offset(0, h * 0.75),
      Offset(0, h * 0.25),
    ];

    for (int i = 0; i < 6; i++) {
      final pPrev = points[(i - 1 + 6) % 6];
      final pCurr = points[i];
      final pNext = points[(i + 1) % 6];

      final v1 = Offset(pCurr.dx - pPrev.dx, pCurr.dy - pPrev.dy);
      final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
      final u1 = len1 > 0 ? Offset(v1.dx / len1, v1.dy / len1) : Offset.zero;

      final v2 = Offset(pNext.dx - pCurr.dx, pNext.dy - pCurr.dy);
      final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
      final u2 = len2 > 0 ? Offset(v2.dx / len2, v2.dy / len2) : Offset.zero;

      final startCurve = Offset(pCurr.dx - u1.dx * r, pCurr.dy - u1.dy * r);
      final endCurve = Offset(pCurr.dx + u2.dx * r, pCurr.dy + u2.dy * r);

      if (i == 0) {
        path.moveTo(startCurve.dx, startCurve.dy);
      } else {
        path.lineTo(startCurve.dx, startCurve.dy);
      }
      path.quadraticBezierTo(pCurr.dx, pCurr.dy, endCurve.dx, endCurve.dy);
    }
    path.close();
    return path;
  }

  static Path _buildChamferDiagonalPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 20.0);
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
    final r = math.min(config.cornerRadius, 22.0);
    final waves = math.max(config.waveCount, 1.0);
    final amp = math.min(config.waveAmplitude, h * 0.25);

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // Right edge down to wave start
    path.lineTo(w, h - amp - r);
    path.arcToPoint(Offset(w - r, h - amp), radius: Radius.circular(r));

    // Wavy bottom edge from right to left
    final waveSpan = (w - r * 2);
    final step = waveSpan / (waves * 2);
    for (int i = 0; i < (waves * 2); i++) {
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
    final path = Path();
    final w = size.width;
    final h = size.height;
    final rBottom = h * 0.22;

    // Flat or softly curved base
    path.moveTo(rBottom, h);
    path.lineTo(w - rBottom, h);
    path.arcToPoint(Offset(w, h - rBottom), radius: Radius.circular(rBottom));

    // Right puff lobe
    path.arcToPoint(
      Offset(w * 0.85, h * 0.38),
      radius: Radius.circular(h * 0.38),
    );

    // Top large cloud puffs
    path.arcToPoint(
      Offset(w * 0.52, h * 0.12),
      radius: Radius.circular(w * 0.26),
    );
    path.arcToPoint(
      Offset(w * 0.22, h * 0.32),
      radius: Radius.circular(w * 0.22),
    );

    // Left puff lobe
    path.arcToPoint(Offset(0, h - rBottom), radius: Radius.circular(h * 0.35));
    path.arcToPoint(Offset(rBottom, h), radius: Radius.circular(rBottom));

    path.close();
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
    final r = math.min(config.cornerRadius, bodyH / 3);

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
    final r = math.min(config.cornerRadius, 20.0);

    // Top edge with subtle crest dip
    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.quadraticBezierTo(w * 0.5, 4.0, w - r, 0);
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
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 14.0);

    final points = <Offset>[
      Offset(w * 0.5, 0),
      Offset(w, h * 0.5),
      Offset(w * 0.5, h),
      Offset(0, h * 0.5),
    ];

    for (int i = 0; i < 4; i++) {
      final pPrev = points[(i - 1 + 4) % 4];
      final pCurr = points[i];
      final pNext = points[(i + 1) % 4];

      final v1 = Offset(pCurr.dx - pPrev.dx, pCurr.dy - pPrev.dy);
      final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
      final u1 = len1 > 0 ? Offset(v1.dx / len1, v1.dy / len1) : Offset.zero;

      final v2 = Offset(pNext.dx - pCurr.dx, pNext.dy - pCurr.dy);
      final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
      final u2 = len2 > 0 ? Offset(v2.dx / len2, v2.dy / len2) : Offset.zero;

      final pStart = Offset(pCurr.dx - u1.dx * r, pCurr.dy - u1.dy * r);
      final pEnd = Offset(pCurr.dx + u2.dx * r, pCurr.dy + u2.dy * r);

      if (i == 0) {
        path.moveTo(pStart.dx, pStart.dy);
      } else {
        path.lineTo(pStart.dx, pStart.dy);
      }
      path.quadraticBezierTo(pCurr.dx, pCurr.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
  }

  /// 8. Regular 8-sided Octagon with rounded vertex transitions.
  static Path _buildOctagonPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 12.0);
    final cW = w * 0.28;
    final cH = h * 0.28;

    final points = <Offset>[
      Offset(cW, 0),
      Offset(w - cW, 0),
      Offset(w, cH),
      Offset(w, h - cH),
      Offset(w - cW, h),
      Offset(cW, h),
      Offset(0, h - cH),
      Offset(0, cH),
    ];

    for (int i = 0; i < 8; i++) {
      final pPrev = points[(i - 1 + 8) % 8];
      final pCurr = points[i];
      final pNext = points[(i + 1) % 8];

      final v1 = Offset(pCurr.dx - pPrev.dx, pCurr.dy - pPrev.dy);
      final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
      final u1 = len1 > 0 ? Offset(v1.dx / len1, v1.dy / len1) : Offset.zero;

      final v2 = Offset(pNext.dx - pCurr.dx, pNext.dy - pCurr.dy);
      final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
      final u2 = len2 > 0 ? Offset(v2.dx / len2, v2.dy / len2) : Offset.zero;

      final pStart = Offset(pCurr.dx - u1.dx * r, pCurr.dy - u1.dy * r);
      final pEnd = Offset(pCurr.dx + u2.dx * r, pCurr.dy + u2.dy * r);

      if (i == 0) {
        path.moveTo(pStart.dx, pStart.dy);
      } else {
        path.lineTo(pStart.dx, pStart.dy);
      }
      path.quadraticBezierTo(pCurr.dx, pCurr.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
  }

  /// 9. Wave Cut sliced container.
  static Path _buildWaveCutPath(Size size, Material4Config config) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 22.0);
    final amp = math.min(config.waveAmplitude, 20.0);

    path.moveTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r));

    // Right edge down to cut
    path.lineTo(w, h * 0.65);

    // Diagonal organic S-wave cut across to bottom-left
    path.cubicTo(w * 0.75, h * 0.65 - amp, w * 0.35, h + amp, r, h);
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
    final cur = math.min(config.waveAmplitude, 14.0);
    final r = 10.0;

    path.moveTo(r, -cur);
    path.quadraticBezierTo(w * 0.5, -cur * 1.6, w - r, -cur);
    path.arcToPoint(Offset(w + cur, r), radius: Radius.circular(r));
    path.quadraticBezierTo(w + cur * 1.6, h * 0.5, w + cur, h - r);
    path.arcToPoint(Offset(w - r, h + cur), radius: Radius.circular(r));
    path.quadraticBezierTo(w * 0.5, h + cur * 1.6, r, h + cur);
    path.arcToPoint(Offset(-cur, h - r), radius: Radius.circular(r));
    path.quadraticBezierTo(-cur * 1.6, h * 0.5, -cur, r);
    path.arcToPoint(Offset(r, -cur), radius: Radius.circular(r));
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
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = math.min(config.cornerRadius, 14.0);
    final rad = config.skewAngle * (math.pi / 180.0);
    final dx = (math.tan(rad) * h).clamp(-w * 0.35, w * 0.35);

    final p0 = Offset(dx > 0 ? dx : 0, 0);
    final p1 = Offset(dx > 0 ? w : w + dx, 0);
    final p2 = Offset(dx > 0 ? w - dx : w, h);
    final p3 = Offset(dx > 0 ? 0 : -dx, h);

    final points = [p0, p1, p2, p3];

    for (int i = 0; i < 4; i++) {
      final pPrev = points[(i - 1 + 4) % 4];
      final pCurr = points[i];
      final pNext = points[(i + 1) % 4];

      final v1 = Offset(pCurr.dx - pPrev.dx, pCurr.dy - pPrev.dy);
      final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
      final u1 = len1 > 0 ? Offset(v1.dx / len1, v1.dy / len1) : Offset.zero;

      final v2 = Offset(pNext.dx - pCurr.dx, pNext.dy - pCurr.dy);
      final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
      final u2 = len2 > 0 ? Offset(v2.dx / len2, v2.dy / len2) : Offset.zero;

      final pStart = Offset(pCurr.dx - u1.dx * r, pCurr.dy - u1.dy * r);
      final pEnd = Offset(pCurr.dx + u2.dx * r, pCurr.dy + u2.dy * r);

      if (i == 0) {
        path.moveTo(pStart.dx, pStart.dy);
      } else {
        path.lineTo(pStart.dx, pStart.dy);
      }
      path.quadraticBezierTo(pCurr.dx, pCurr.dy, pEnd.dx, pEnd.dy);
    }
    path.close();
    return path;
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
    final r = math.min(config.cornerRadius, 16.0);
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
}
