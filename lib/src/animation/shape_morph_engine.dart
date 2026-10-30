import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../material_4_config.dart';
import '../material_4_path_builder.dart';
import 'shape_animation_cache.dart';
import 'shape_animation_config.dart';
import 'shape_geometry_interpolator.dart';

/// Advanced shape-to-shape morphing engine.
///
/// Intelligently transitions between distinct shape topologies:
/// - Compatible shapes morph smoothly via parameterized geometric interpolation.
/// - Incompatible topologies transition via normalized contour point sampling
///   or configurable fallback strategies (crossfade, midpoint switch).
class ShapeMorphEngine {
  const ShapeMorphEngine._();

  /// Default number of contour vertices sampled during normalized path morphing.
  static const int defaultSampleCount = 64;

  /// Determines whether two [Material4Type] variants are topologically compatible
  /// for parameter-driven geometric morphing without vertex re-sampling.
  static bool canMorphGeometrically(Material4Type from, Material4Type to) {
    if (from == to) return true;

    // Corner & Radius Family (Continuous Rectangular & Quad-Arc Geometries)
    const roundedFamily = {
      Material4Type.smoothRounded,
      Material4Type.squircle,
      Material4Type.capsule,
      Material4Type.asymmetricCard,
      Material4Type.convexRounded,
      Material4Type.concaveRounded,
    };

    if (roundedFamily.contains(from) && roundedFamily.contains(to)) {
      return true;
    }

    // Notched & Tabbed Rectangles Family
    const notchedFamily = {
      Material4Type.folderTab,
      Material4Type.notchedBadge,
      Material4Type.sideTab,
      Material4Type.steppedCorner,
      Material4Type.ticketScallop,
      Material4Type.postageStamp,
      Material4Type.bookmark,
      Material4Type.smoothRounded,
    };

    if (notchedFamily.contains(from) && notchedFamily.contains(to)) {
      return true;
    }

    // Regular Polygons Family
    const polygonFamily = {
      Material4Type.diamond,
      Material4Type.octagon,
      Material4Type.shield,
      Material4Type.hexagonSoft,
    };

    if (polygonFamily.contains(from) && polygonFamily.contains(to)) {
      return true;
    }

    // Organic & Fluid Blobs Family
    const organicFamily = {
      Material4Type.organicBlob,
      Material4Type.cloud,
      Material4Type.waveEdge,
      Material4Type.waveCut,
      Material4Type.scallopedPetal,
    };

    if (organicFamily.contains(from) && organicFamily.contains(to)) {
      return true;
    }

    return false;
  }

  /// Evaluates the morphed vector [Path] between [fromConfig] and [toConfig] at [progress] (0.0 to 1.0).
  static Path computeMorphedPath({
    required Material4Config fromConfig,
    required Material4Config toConfig,
    required Size size,
    required double progress,
    ShapeMorphFallback fallback = ShapeMorphFallback.compatibleNormalized,
  }) {
    if (progress <= 0.0) {
      return Material4PathBuilder.buildPath(size, fromConfig);
    }
    if (progress >= 1.0) {
      return Material4PathBuilder.buildPath(size, toConfig);
    }

    // 1. Direct parameter-driven morphing for compatible topologies
    if (canMorphGeometrically(fromConfig.type, toConfig.type)) {
      final interpolatedConfig =
          ShapeGeometryInterpolator.lerpConfig(fromConfig, toConfig, progress);
      return Material4PathBuilder.buildPath(size, interpolatedConfig);
    }

    // 2. Handle incompatible topologies according to fallback strategy
    switch (fallback) {
      case ShapeMorphFallback.switchAtMidpoint:
        final activeConfig = progress < 0.5 ? fromConfig : toConfig;
        return Material4PathBuilder.buildPath(size, activeConfig);

      case ShapeMorphFallback.crossfade:
        // Returns dominant path based on progress; caller handles opacity crossfade
        final activeConfig = progress < 0.5 ? fromConfig : toConfig;
        return Material4PathBuilder.buildPath(size, activeConfig);

      case ShapeMorphFallback.compatibleNormalized:
        return morphViaNormalizedSampling(
          fromConfig: fromConfig,
          toConfig: toConfig,
          size: size,
          progress: progress,
        );
    }
  }

  /// Morphs between arbitrary shapes by sampling equidistant contour points along
  /// both vector paths and synthesizing a smooth closed Bézier spline.
  static Path morphViaNormalizedSampling({
    required Material4Config fromConfig,
    required Material4Config toConfig,
    required Size size,
    required double progress,
    int sampleCount = defaultSampleCount,
  }) {
    final keyA = ShapeSampleKey(
      shapeTypeIndex: fromConfig.type.index,
      width: size.width,
      height: size.height,
      configHash: fromConfig.hashCode,
    );
    final keyB = ShapeSampleKey(
      shapeTypeIndex: toConfig.type.index,
      width: size.width,
      height: size.height,
      configHash: toConfig.hashCode,
    );

    var pointsA = ShapeAnimationCache.instance.get(keyA);
    if (pointsA == null) {
      final pathA = Material4PathBuilder.buildPath(size, fromConfig);
      pointsA = samplePathContour(pathA, sampleCount);
      ShapeAnimationCache.instance.put(keyA, pointsA);
    }

    var pointsB = ShapeAnimationCache.instance.get(keyB);
    if (pointsB == null) {
      final pathB = Material4PathBuilder.buildPath(size, toConfig);
      pointsB = samplePathContour(pathB, sampleCount);
      ShapeAnimationCache.instance.put(keyB, pointsB);
    }

    // Interpolate pairwise vertices
    final count = math.min(pointsA.length, pointsB.length);
    final interpolatedPoints = <Offset>[];
    for (int i = 0; i < count; i++) {
      interpolatedPoints.add(
        Offset.lerp(pointsA[i], pointsB[i], progress) ?? pointsA[i],
      );
    }

    return buildSmoothSplinePath(interpolatedPoints);
  }

  /// Samples [sampleCount] equidistant perimeter coordinates along [path].
  static List<Offset> samplePathContour(Path path, int sampleCount) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return List.filled(sampleCount, Offset.zero);
    }

    // Find the primary/longest contour metric
    var primaryMetric = metrics.first;
    for (final m in metrics) {
      if (m.length > primaryMetric.length) {
        primaryMetric = m;
      }
    }

    final totalLength = primaryMetric.length;
    if (totalLength <= 0.0) {
      return List.filled(sampleCount, Offset.zero);
    }

    final points = <Offset>[];
    for (int i = 0; i < sampleCount; i++) {
      final distance = (i / sampleCount) * totalLength;
      final tangent = primaryMetric.getTangentForOffset(distance);
      points.add(tangent?.position ?? Offset.zero);
    }

    return points;
  }

  /// Synthesizes a closed vector [Path] from an ordered ring of [points] using Catmull-Rom cubic Béziers.
  static Path buildSmoothSplinePath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    if (points.length < 3) {
      path.addPolygon(points, true);
      return path;
    }

    final n = points.length;
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < n; i++) {
      final p0 = points[(i - 1 + n) % n];
      final p1 = points[i];
      final p2 = points[(i + 1) % n];
      final p3 = points[(i + 2) % n];

      // Catmull-Rom to Cubic Bézier conversion
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6.0,
        p1.dy + (p2.dy - p0.dy) / 6.0,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6.0,
        p2.dy - (p3.dy - p1.dy) / 6.0,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    path.close();
    return path;
  }

  /// Pairwise normalized contour morph between any two vector [Path] instances.
  static Path morphPaths(
    Path pathA,
    Path pathB,
    double progress, {
    int sampleCount = defaultSampleCount,
  }) {
    if (progress <= 0.0) return pathA;
    if (progress >= 1.0) return pathB;
    final pointsA = samplePathContour(pathA, sampleCount);
    final pointsB = samplePathContour(pathB, sampleCount);
    final count = math.min(pointsA.length, pointsB.length);
    final interpolated = <Offset>[];
    for (int i = 0; i < count; i++) {
      interpolated.add(
        Offset.lerp(pointsA[i], pointsB[i], progress) ?? pointsA[i],
      );
    }
    return buildSmoothSplinePath(interpolated);
  }
}
