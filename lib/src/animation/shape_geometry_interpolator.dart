import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../dynamic_shape_config.dart';

/// Comprehensive geometry and parameter interpolation engine for dynamic shapes.
///
/// Provides robust, finite-guaranteed mathematical interpolation across
/// corners, elliptical radii, edges, notches, affine transformations,
/// borders, gradients, and custom Bézier profiles.
class ShapeGeometryInterpolator {
  const ShapeGeometryInterpolator._();

  /// Interpolates linearly between two numbers, ensuring non-NaN finite output.
  static double lerpDouble(double a, double b, double t) {
    if (a.isNaN || b.isNaN) return 0.0;
    if (a == b) return a;
    final result = a + (b - a) * t;
    if (result.isNaN || result.isInfinite) return b;
    return result;
  }

  /// Interpolates an angular rotation smoothly, handling shortest-arc wrapping.
  static double lerpAngle(double a, double b, double t) {
    var diff = (b - a) % (2 * math.pi);
    if (diff > math.pi) diff -= 2 * math.pi;
    if (diff < -math.pi) diff += 2 * math.pi;
    return a + diff * t;
  }

  /// Interpolates a single [Radius] (supporting circular and elliptical radii).
  static Radius lerpRadius(Radius a, Radius b, double t) {
    final rx = lerpDouble(a.x, b.x, t);
    final ry = lerpDouble(a.y, b.y, t);
    return Radius.elliptical(
      rx.clamp(0.0, double.infinity),
      ry.clamp(0.0, double.infinity),
    );
  }

  /// Interpolates between two [ShapeCorners] specifications.
  static ShapeCorners lerpCorners(ShapeCorners a, ShapeCorners b, double t) {
    return ShapeCorners(
      topLeft: lerpRadius(a.topLeft, b.topLeft, t),
      topRight: lerpRadius(a.topRight, b.topRight, t),
      bottomRight: lerpRadius(a.bottomRight, b.bottomRight, t),
      bottomLeft: lerpRadius(a.bottomLeft, b.bottomLeft, t),
    );
  }

  /// Interpolates between two [ShapeTransform] specifications.
  static ShapeTransform lerpTransform(
      ShapeTransform a, ShapeTransform b, double t) {
    return ShapeTransform(
      rotation: lerpAngle(a.rotation, b.rotation, t),
      scaleX: lerpDouble(a.scaleX, b.scaleX, t),
      scaleY: lerpDouble(a.scaleY, b.scaleY, t),
      skewX: lerpDouble(a.skewX, b.skewX, t),
      skewY: lerpDouble(a.skewY, b.skewY, t),
      origin: Alignment.lerp(a.origin, b.origin, t) ??
          (t < 0.5 ? a.origin : b.origin),
      stretchOffset:
          Offset.lerp(a.stretchOffset, b.stretchOffset, t) ?? Offset.zero,
    );
  }

  /// Interpolates an individual [ShapeNotch] with seamless inward/outward polarity transition.
  static ShapeNotch lerpNotch(ShapeNotch a, ShapeNotch b, double t) {
    final edge = t < 0.5 ? a.edge : b.edge;
    final width = lerpDouble(a.width, b.width, t).clamp(0.0, double.infinity);
    final posFactor = lerpDouble(a.positionFactor, b.positionFactor, t);
    final cornerRadius = lerpDouble(a.cornerRadius, b.cornerRadius, t)
        .clamp(0.0, double.infinity);
    final offset = lerpDouble(a.offset, b.offset, t);

    // If inward polarity matches, interpolate depth directly
    if (a.isInward == b.isInward) {
      final depth = lerpDouble(a.depth, b.depth, t).clamp(0.0, double.infinity);
      return ShapeNotch(
        edge: edge,
        positionFactor: posFactor,
        width: width,
        depth: depth,
        cornerRadius: cornerRadius,
        offset: offset,
        isInward: a.isInward,
        id: t < 0.5 ? a.id : b.id,
      );
    }

    // Polarity differs: smoothly shrink depth to 0 at midpoint, then expand with new polarity
    final bool currentInward = t < 0.5 ? a.isInward : b.isInward;
    final double depth;
    if (t < 0.5) {
      // First half: shrink from a.depth to 0
      final subT = t * 2.0;
      depth = lerpDouble(a.depth, 0.0, subT).clamp(0.0, double.infinity);
    } else {
      // Second half: expand from 0 to b.depth
      final subT = (t - 0.5) * 2.0;
      depth = lerpDouble(0.0, b.depth, subT).clamp(0.0, double.infinity);
    }

    return ShapeNotch(
      edge: edge,
      positionFactor: posFactor,
      width: width,
      depth: depth,
      cornerRadius: cornerRadius,
      offset: offset,
      isInward: currentInward,
      id: t < 0.5 ? a.id : b.id,
    );
  }

  /// Interpolates a collection of notches, supporting differing notch counts gracefully.
  static List<ShapeNotch> lerpNotches(
    List<ShapeNotch>? a,
    List<ShapeNotch>? b,
    double t,
  ) {
    final listA = a ?? const [];
    final listB = b ?? const [];

    if (listA.isEmpty && listB.isEmpty) return const [];

    final maxCount = math.max(listA.length, listB.length);
    final result = <ShapeNotch>[];

    for (int i = 0; i < maxCount; i++) {
      if (i < listA.length && i < listB.length) {
        result.add(lerpNotch(listA[i], listB[i], t));
      } else if (i < listA.length) {
        // Disappearing notch: shrink depth and width to 0
        final notchA = listA[i];
        final zeroNotch = notchA.copyWith(depth: 0.0, width: 0.0);
        result.add(lerpNotch(notchA, zeroNotch, t));
      } else {
        // Appearing notch: expand from 0 to target
        final notchB = listB[i];
        final zeroNotch = notchB.copyWith(depth: 0.0, width: 0.0);
        result.add(lerpNotch(zeroNotch, notchB, t));
      }
    }

    return result;
  }

  /// Interpolates between two [ShapeEdgeConfig] instances.
  static ShapeEdgeConfig lerpEdgeConfig(
    ShapeEdgeConfig a,
    ShapeEdgeConfig b,
    double t,
  ) {
    return ShapeEdgeConfig(
      style: t < 0.5 ? a.style : b.style,
      depth: lerpDouble(a.depth, b.depth, t),
      waveCount: lerpDouble(a.waveCount, b.waveCount, t),
      waveAmplitude: lerpDouble(a.waveAmplitude, b.waveAmplitude, t),
      wavePhase: lerpDouble(a.wavePhase, b.wavePhase, t),
      toothWidth: lerpDouble(a.toothWidth, b.toothWidth, t),
      isMirrored: t < 0.5 ? a.isMirrored : b.isMirrored,
      customBezier: lerpBezierSegment(a.customBezier, b.customBezier, t),
    );
  }

  /// Interpolates between two [ShapeEdges] configurations.
  static ShapeEdges lerpEdges(ShapeEdges a, ShapeEdges b, double t) {
    return ShapeEdges(
      top: lerpEdgeConfig(a.top, b.top, t),
      right: lerpEdgeConfig(a.right, b.right, t),
      bottom: lerpEdgeConfig(a.bottom, b.bottom, t),
      left: lerpEdgeConfig(a.left, b.left, t),
    );
  }

  /// Interpolates between two [BezierSegmentConfig] specifications.
  static BezierSegmentConfig? lerpBezierSegment(
    BezierSegmentConfig? a,
    BezierSegmentConfig? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    return BezierSegmentConfig(
      start: Offset.lerp(a.start, b.start, t) ?? a.start,
      end: Offset.lerp(a.end, b.end, t) ?? b.end,
      controlPoint1:
          Offset.lerp(a.controlPoint1, b.controlPoint1, t) ?? a.controlPoint1,
      controlPoint2: a.controlPoint2 != null && b.controlPoint2 != null
          ? Offset.lerp(a.controlPoint2, b.controlPoint2, t)
          : (t < 0.5 ? a.controlPoint2 : b.controlPoint2),
      isNormalized: t < 0.5 ? a.isNormalized : b.isNormalized,
    );
  }

  /// Interpolates between two [DynamicShapeConfig] instances completely.
  static DynamicShapeConfig lerpConfig(
    DynamicShapeConfig a,
    DynamicShapeConfig b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    final dominant = t < 0.5 ? a : b;

    final corners = lerpCorners(a.resolvedCorners, b.resolvedCorners, t);
    final transform =
        lerpTransform(a.resolvedTransform, b.resolvedTransform, t);
    final notches = lerpNotches(a.notches, b.notches, t);
    final edges = (a.edges != null || b.edges != null)
        ? lerpEdges(
            a.edges ?? const ShapeEdges(),
            b.edges ?? const ShapeEdges(),
            t,
          )
        : null;

    return dominant.copyWith(
      cornerRadius: lerpDouble(a.cornerRadius, b.cornerRadius, t),
      tabWidth: lerpDouble(a.tabWidth, b.tabWidth, t),
      tabHeight: lerpDouble(a.tabHeight, b.tabHeight, t),
      filletRadius: lerpDouble(a.filletRadius, b.filletRadius, t),
      scallopRadius: lerpDouble(a.scallopRadius, b.scallopRadius, t),
      waveAmplitude: lerpDouble(a.waveAmplitude, b.waveAmplitude, t),
      waveCount: lerpDouble(a.waveCount, b.waveCount, t),
      skewAngle: lerpDouble(a.skewAngle, b.skewAngle, t),
      ribbonFoldDepth: lerpDouble(a.ribbonFoldDepth, b.ribbonFoldDepth, t),
      borderProgress: lerpDouble(a.borderProgress, b.borderProgress, t),
      dashPhase: lerpDouble(a.dashPhase, b.dashPhase, t),
      neonPulseIntensity:
          lerpDouble(a.neonPulseIntensity, b.neonPulseIntensity, t),
      stretchOffset:
          Offset.lerp(a.stretchOffset, b.stretchOffset, t) ?? a.stretchOffset,
      corners: corners,
      transform: transform,
      notches: notches,
      edges: edges,
    );
  }

  /// Interpolates between two [Gradient] shaders safely.
  static Gradient? lerpGradient(Gradient? a, Gradient? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return Gradient.lerp(a, b, t);
  }
}
