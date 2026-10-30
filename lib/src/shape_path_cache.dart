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
  final CornerRadii? cornerRadii;
  final ShapeAnchor anchor;
  final double tabWidth;
  final double tabHeight;
  final double filletRadius;
  final double scallopRadius;
  final double waveCount;
  final double waveAmplitude;
  final double skewAngle;
  final double ribbonFoldDepth;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final Offset stretchOffset;
  final int notchesHash;

  ShapeCacheKey({required Size size, required DynamicShapeConfig config})
    : type = config.type,
      width = size.width,
      height = size.height,
      cornerRadius = config.cornerRadius,
      cornerRadii = config.cornerRadii,
      anchor = config.anchor,
      tabWidth = config.tabWidth,
      tabHeight = config.tabHeight,
      filletRadius = config.filletRadius,
      scallopRadius = config.scallopRadius,
      waveCount = config.waveCount,
      waveAmplitude = config.waveAmplitude,
      skewAngle = config.skewAngle,
      ribbonFoldDepth = config.ribbonFoldDepth,
      rotation = config.rotation,
      scaleX = config.scaleX,
      scaleY = config.scaleY,
      stretchOffset = config.stretchOffset,
      notchesHash = config.notches != null
          ? Object.hashAll(config.notches!)
          : 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeCacheKey &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          width == other.width &&
          height == other.height &&
          cornerRadius == other.cornerRadius &&
          cornerRadii == other.cornerRadii &&
          anchor == other.anchor &&
          tabWidth == other.tabWidth &&
          tabHeight == other.tabHeight &&
          filletRadius == other.filletRadius &&
          scallopRadius == other.scallopRadius &&
          waveCount == other.waveCount &&
          waveAmplitude == other.waveAmplitude &&
          skewAngle == other.skewAngle &&
          ribbonFoldDepth == other.ribbonFoldDepth &&
          rotation == other.rotation &&
          scaleX == other.scaleX &&
          scaleY == other.scaleY &&
          stretchOffset == other.stretchOffset &&
          notchesHash == other.notchesHash;

  @override
  int get hashCode => Object.hash(
    type,
    width,
    height,
    cornerRadius,
    cornerRadii,
    anchor,
    tabWidth,
    tabHeight,
    filletRadius,
    scallopRadius,
    waveCount,
    waveAmplitude,
    skewAngle,
    ribbonFoldDepth,
    rotation,
    scaleX,
    scaleY,
    stretchOffset,
    notchesHash,
  );
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
    // Custom Bezier paths are not cached to prevent caching stale user closures
    if (config.type == DynamicShapeType.customBezier) {
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
