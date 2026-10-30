import 'dart:collection';

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';

/// Immutable composite cache key uniquely identifying a geometric path layout.
@immutable
class ShapeCacheKey {
  final DynamicShapeType type;
  final double width;
  final double height;
  final double cornerRadius;
  final ShapeCorners corners;
  final ShapeEdges? edges;
  final ShapeAnchor anchor;
  final double tabWidth;
  final double tabHeight;
  final double filletRadius;
  final double scallopRadius;
  final int petalCount;
  final double protrusionDepth;
  final double toothWidth;
  final double toothHeight;
  final double speechBubbleTailWidth;
  final double speechBubbleTailHeight;
  final double waveCount;
  final double waveAmplitude;
  final double skewAngle;
  final double ribbonFoldDepth;
  final ShapeTransform transform;
  final ShapeConstraints constraints;
  final CustomBezierConfig? bezierConfig;
  final int notchesHash;

  ShapeCacheKey({required Size size, required DynamicShapeConfig config})
      : type = config.type,
        width = size.width,
        height = size.height,
        cornerRadius = config.cornerRadius,
        corners = config.resolvedCorners,
        edges = config.edges,
        anchor = config.anchor,
        tabWidth = config.tabWidth,
        tabHeight = config.tabHeight,
        filletRadius = config.filletRadius,
        scallopRadius = config.scallopRadius,
        petalCount = config.petalCount,
        protrusionDepth = config.protrusionDepth,
        toothWidth = config.toothWidth,
        toothHeight = config.toothHeight,
        speechBubbleTailWidth = config.speechBubbleTailWidth,
        speechBubbleTailHeight = config.speechBubbleTailHeight,
        waveCount = config.waveCount,
        waveAmplitude = config.waveAmplitude,
        skewAngle = config.skewAngle,
        ribbonFoldDepth = config.ribbonFoldDepth,
        transform = config.resolvedTransform,
        constraints = config.constraints,
        bezierConfig = config.bezierConfig,
        notchesHash =
            config.notches != null ? Object.hashAll(config.notches!) : 0;

  /// Backward compatibility getters for legacy properties.
  CornerRadii get cornerRadii => corners.toCornerRadii();
  double get rotation => transform.rotation;
  double get scaleX => transform.scaleX;
  double get scaleY => transform.scaleY;
  Offset get stretchOffset => transform.stretchOffset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeCacheKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          width == other.width &&
          height == other.height &&
          cornerRadius == other.cornerRadius &&
          corners == other.corners &&
          edges == other.edges &&
          anchor == other.anchor &&
          tabWidth == other.tabWidth &&
          tabHeight == other.tabHeight &&
          filletRadius == other.filletRadius &&
          scallopRadius == other.scallopRadius &&
          petalCount == other.petalCount &&
          protrusionDepth == other.protrusionDepth &&
          toothWidth == other.toothWidth &&
          toothHeight == other.toothHeight &&
          speechBubbleTailWidth == other.speechBubbleTailWidth &&
          speechBubbleTailHeight == other.speechBubbleTailHeight &&
          waveCount == other.waveCount &&
          waveAmplitude == other.waveAmplitude &&
          skewAngle == other.skewAngle &&
          ribbonFoldDepth == other.ribbonFoldDepth &&
          transform == other.transform &&
          constraints == other.constraints &&
          bezierConfig == other.bezierConfig &&
          notchesHash == other.notchesHash;

  @override
  int get hashCode => Object.hashAll([
        type,
        width,
        height,
        cornerRadius,
        corners,
        edges,
        anchor,
        tabWidth,
        tabHeight,
        filletRadius,
        scallopRadius,
        petalCount,
        protrusionDepth,
        toothWidth,
        toothHeight,
        speechBubbleTailWidth,
        speechBubbleTailHeight,
        waveCount,
        waveAmplitude,
        skewAngle,
        ribbonFoldDepth,
        transform,
        constraints,
        bezierConfig,
        notchesHash,
      ]);
}

/// High-performance Least-Recently-Used (LRU) cache for reusable vector Paths.
///
/// Limits peak memory usage on low-end hardware (500MB–1GB RAM) by maintaining
/// a bounded set of evaluated Path objects. Evicts the oldest entry when capacity is reached.
class ShapePathCache {
  static const int defaultMaxCapacity = 64;

  final int maxCapacity;
  final LinkedHashMap<ShapeCacheKey, Path> _cache =
      LinkedHashMap<ShapeCacheKey, Path>();

  int _hits = 0;
  int _misses = 0;

  ShapePathCache({this.maxCapacity = defaultMaxCapacity});

  /// Total number of cached paths currently retained.
  int get currentSize => _cache.length;

  /// Cache hit count since last clear.
  int get hits => _hits;

  /// Cache miss count since last clear.
  int get misses => _misses;

  /// Cache hit ratio (0.0 to 1.0).
  double get hitRate {
    final total = _hits + _misses;
    return total == 0 ? 0.0 : _hits / total;
  }

  /// Retrieve a cached path or compute, store, and return a new one.
  Path getOrCreate({
    required Size size,
    required DynamicShapeConfig config,
    required Path Function() computePath,
  }) {
    // Custom Bezier paths with callback closures are not cached to prevent caching stale closures
    if (config.type == DynamicShapeType.customBezier &&
        config.customBezierBuilder != null) {
      return computePath();
    }

    final key = ShapeCacheKey(size: size, config: config);

    if (_cache.containsKey(key)) {
      _hits++;
      // Move to most-recently used position in LinkedHashMap
      final path = _cache.remove(key)!;
      _cache[key] = path;
      return path;
    }

    _misses++;
    final path = computePath();

    if (_cache.length >= maxCapacity) {
      // Evict oldest (first inserted in LinkedHashMap)
      _cache.remove(_cache.keys.first);
    }

    _cache[key] = path;
    return path;
  }

  /// Clear all cached paths and reset metrics.
  void clear() {
    _cache.clear();
    _hits = 0;
    _misses = 0;
  }
}
