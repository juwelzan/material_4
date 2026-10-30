import 'dart:collection';
import 'package:flutter/widgets.dart';

/// Cache key identifying a unique sampled path contour at a specific size.
class ShapeSampleKey {
  final int shapeTypeIndex;
  final double width;
  final double height;
  final int configHash;

  const ShapeSampleKey({
    required this.shapeTypeIndex,
    required this.width,
    required this.height,
    required this.configHash,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapeSampleKey &&
        other.shapeTypeIndex == shapeTypeIndex &&
        other.width == width &&
        other.height == height &&
        other.configHash == configHash;
  }

  @override
  int get hashCode => Object.hash(shapeTypeIndex, width, height, configHash);
}

/// High-performance LRU cache storing sampled contour vertices and normalized morph representations.
///
/// Prevents repetitive metric calculations and point extractions during 60/120 FPS animations.
class ShapeAnimationCache {
  final int capacity;
  final LinkedHashMap<ShapeSampleKey, List<Offset>> _cache =
      LinkedHashMap<ShapeSampleKey, List<Offset>>();

  ShapeAnimationCache({this.capacity = 64});

  /// Global shared instance for application-wide animation efficiency.
  static final ShapeAnimationCache instance = ShapeAnimationCache();

  /// Retrieves sampled points for [key], updating LRU recency.
  List<Offset>? get(ShapeSampleKey key) {
    if (!_cache.containsKey(key)) return null;
    final value = _cache.remove(key)!;
    _cache[key] = value;
    return value;
  }

  /// Inserts [points] for [key], evicting oldest entry if over capacity.
  void put(ShapeSampleKey key, List<Offset> points) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = points;
  }

  /// Clears all cached contour samples.
  void clear() {
    _cache.clear();
  }

  /// Current number of entries stored in the cache.
  int get length => _cache.length;
}

