import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';

/// Builds a customized, mathematically precise [Path] for any [DynamicShapeConfig]
/// across arbitrary container dimensions with extreme dimension guards and transform support.
class DynamicShapePathBuilder {
  static Path buildPath(Size size, DynamicShapeConfig config) {
    // 1. Guard against non-positive, zero, infinite, or NaN dimensions
    if (size.width <= 0 ||
        size.height <= 0 ||
        size.width.isNaN ||
        size.height.isNaN ||
        size.width.isInfinite ||
        size.height.isInfinite) {
      return Path();
    }

    Path path;

    // 2. Build Base Geometry
    switch (config.type) {
      // --- Original 13 Shapes ---
      case DynamicShapeType.folderTab:
        path = _buildFolderTabPath(size, config);
        break;
      case DynamicShapeType.notchedBadge:
        path = _buildNotchedBadgePath(size, config);
        break;
      case DynamicShapeType.sideTab:
        path = _buildSideTabPath(size, config);
        break;
      case DynamicShapeType.steppedCorner:
        path = _buildSteppedCornerPath(size, config);
        break;
      case DynamicShapeType.ticketScallop:
        path = _buildTicketScallopPath(size, config);
        break;
      case DynamicShapeType.postageStamp:
        path = _buildPostageStampPath(size, config);
        break;
      case DynamicShapeType.zigzagCut:
        path = _buildZigzagCutPath(size, config);
        break;
      case DynamicShapeType.arch:
        path = _buildArchPath(size, config);
        break;
      case DynamicShapeType.hexagonSoft:
        path = _buildHexagonSoftPath(size, config);
        break;
      case DynamicShapeType.chamferDiagonal:
        path = _buildChamferDiagonalPath(size, config);
        break;
      case DynamicShapeType.organicBlob:
        path = _buildOrganicBlobPath(size, config);
        break;
      case DynamicShapeType.scallopedPetal:
        path = _buildScallopedPetalPath(size, config);
        break;
      case DynamicShapeType.smoothRounded:
        path = _buildSmoothRoundedPath(size, config);
        break;

      // --- Next-Gen Geometry Additions ---
      case DynamicShapeType.asymmetricCard:
        path = _buildAsymmetricCardPath(size, config);
        break;
      case DynamicShapeType.capsule:
        path = _buildCapsulePath(size, config);
        break;
      case DynamicShapeType.waveEdge:
        path = _buildWaveEdgePath(size, config);
        break;
      case DynamicShapeType.cloud:
        path = _buildCloudPath(size, config);
        break;
      case DynamicShapeType.speechBubble:
        path = _buildSpeechBubblePath(size, config);
        break;
      case DynamicShapeType.shield:
        path = _buildShieldPath(size, config);
        break;
      case DynamicShapeType.diamond:
        path = _buildDiamondPath(size, config);
        break;
      case DynamicShapeType.octagon:
        path = _buildOctagonPath(size, config);
        break;
      case DynamicShapeType.waveCut:
        path = _buildWaveCutPath(size, config);
        break;
      case DynamicShapeType.concaveRounded:
        path = _buildConcaveRoundedPath(size, config);
        break;
      case DynamicShapeType.convexRounded:
        path = _buildConvexRoundedPath(size, config);
        break;
      case DynamicShapeType.squircle:
        path = _buildSquirclePath(size, config);
        break;
      case DynamicShapeType.parallelogram:
        path = _buildParallelogramPath(size, config);
        break;
      case DynamicShapeType.ribbon:
        path = _buildRibbonPath(size, config);
        break;
      case DynamicShapeType.bookmark:
        path = _buildBookmarkPath(size, config);
        break;
      case DynamicShapeType.customBezier:
        path = _buildCustomBezierPath(size, config);
        break;
    }

    // 3. Multi-Notch Processing
    if (config.notches != null && config.notches!.isNotEmpty) {
      path = _applyMultiNotches(path, size, config.notches!);
    }

    // 4. Transform Post-Processing (Rotation, Scale, Stretch Offset around Shape Center)
    if (config.rotation != 0.0 ||
        config.scaleX != 1.0 ||
        config.scaleY != 1.0 ||
        config.stretchOffset != Offset.zero) {
      final cx = size.width / 2;
      final cy = size.height / 2;
      final matrix = Matrix4.identity()
        ..translateByDouble(
          cx + config.stretchOffset.dx,
          cy + config.stretchOffset.dy,
          0.0,
          1.0,
        )
        ..rotateZ(config.rotation)
        ..scaleByDouble(config.scaleX, config.scaleY, 1.0, 1.0)
        ..translateByDouble(-cx, -cy, 0.0, 1.0);
      path = path.transform(matrix.storage);
    }

    return path;
  }

  // =========================================================================
  // --- ORIGINAL 13 SHAPES (100% Backwards Compatible) ---
  // =========================================================================

  static Path _buildFolderTabPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildNotchedBadgePath(Size size, DynamicShapeConfig config) {
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

  static Path _buildSideTabPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildSteppedCornerPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildTicketScallopPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildPostageStampPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildZigzagCutPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildArchPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildHexagonSoftPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildChamferDiagonalPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildOrganicBlobPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildScallopedPetalPath(Size size, DynamicShapeConfig config) {
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

  static Path _buildSmoothRoundedPath(Size size, DynamicShapeConfig config) {
    // If independent cornerRadii provided, use them
    if (config.cornerRadii != null) {
      return _buildAsymmetricCardPath(size, config);
    }
    final r = math.min(
      config.cornerRadius,
      math.min(size.width, size.height) / 2,
    );
    return Path()..addRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(r)),
    );
  }

  // =========================================================================
  // --- NEXT-GEN SHAPE GEOMETRY BUILDERS (15 New Additions) ---
  // =========================================================================

  /// 1. Asymmetric Card with 4 independent corner radii.
  static Path _buildAsymmetricCardPath(Size size, DynamicShapeConfig config) {
    final w = size.width;
    final h = size.height;
    final cr = config.cornerRadii ?? const CornerRadii.asymmetric();

    // Clamp radii so opposing corners do not overlap
    final maxR = math.min(w, h) / 2;
    final tl = math.min(cr.topLeft, maxR);
    final tr = math.min(cr.topRight, maxR);
    final br = math.min(cr.bottomRight, maxR);
    final bl = math.min(cr.bottomLeft, maxR);

    final path = Path();
    path.moveTo(0, tl);
    if (tl > 0) {
      path.arcToPoint(Offset(tl, 0), radius: Radius.circular(tl));
    } else {
      path.lineTo(0, 0);
    }

    path.lineTo(w - tr, 0);
    if (tr > 0) {
      path.arcToPoint(Offset(w, tr), radius: Radius.circular(tr));
    } else {
      path.lineTo(w, 0);
    }

    path.lineTo(w, h - br);
    if (br > 0) {
      path.arcToPoint(Offset(w - br, h), radius: Radius.circular(br));
    } else {
      path.lineTo(w, h);
    }

    path.lineTo(bl, h);
    if (bl > 0) {
      path.arcToPoint(Offset(0, h - bl), radius: Radius.circular(bl));
    } else {
      path.lineTo(0, h);
    }

    path.close();
    return path;
  }

  /// 2. Capsule / Pill shape with semicircular rounded ends.
  static Path _buildCapsulePath(Size size, DynamicShapeConfig config) {
    final radius = math.min(size.width, size.height) / 2;
    return Path()..addRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
    );
  }

  /// 3. Wave Edge container with a flowing sine wave along the anchor edge.
  static Path _buildWaveEdgePath(Size size, DynamicShapeConfig config) {
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
  static Path _buildCloudPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildSpeechBubblePath(Size size, DynamicShapeConfig config) {
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
  static Path _buildShieldPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildDiamondPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildOctagonPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildWaveCutPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildConcaveRoundedPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildConvexRoundedPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildSquirclePath(Size size, DynamicShapeConfig config) {
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
  static Path _buildParallelogramPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildRibbonPath(Size size, DynamicShapeConfig config) {
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
  static Path _buildBookmarkPath(Size size, DynamicShapeConfig config) {
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

  /// 16. Custom Bézier path builder callback.
  static Path _buildCustomBezierPath(Size size, DynamicShapeConfig config) {
    if (config.customBezierBuilder != null) {
      return config.customBezierBuilder!(size);
    }
    return _buildSmoothRoundedPath(size, config);
  }

  // =========================================================================
  // --- MULTI-NOTCH POST PROCESSING ---
  // =========================================================================

  static Path _applyMultiNotches(
    Path basePath,
    Size size,
    List<ShapeNotch> notches,
  ) {
    Path result = basePath;
    for (final notch in notches) {
      final nW = notch.width;
      final nH = notch.height;
      final fillet = math.min(notch.filletRadius, math.min(nW, nH) / 2);

      Rect notchRect;
      switch (notch.position) {
        case ShapeAnchor.topRight:
          notchRect = Rect.fromLTWH(size.width - nW - notch.offset, 0, nW, nH);
          break;
        case ShapeAnchor.topLeft:
          notchRect = Rect.fromLTWH(notch.offset, 0, nW, nH);
          break;
        case ShapeAnchor.bottomRight:
          notchRect = Rect.fromLTWH(
            size.width - nW - notch.offset,
            size.height - nH,
            nW,
            nH,
          );
          break;
        case ShapeAnchor.bottomLeft:
          notchRect = Rect.fromLTWH(notch.offset, size.height - nH, nW, nH);
          break;
        default:
          notchRect = Rect.zero;
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
