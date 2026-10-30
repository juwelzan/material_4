import 'dart:collection';
import 'package:flutter/material.dart';

/// Bounded LRU cache for procedural creative border geometries.
class CreativeBorderCache {
  static const int maxEntries = 50;
  static final LinkedHashMap<String, Path> _pathCache =
      LinkedHashMap<String, Path>();

  CreativeBorderCache._();

  /// Retrieve cached border path or compute and store it.
  static Path getOrCreatePath(String key, Path Function() builder) {
    if (_pathCache.containsKey(key)) {
      final cached = _pathCache.remove(key)!;
      _pathCache[key] = cached; // Move to end (most recently used)
      return cached;
    }

    final newPath = builder();
    if (_pathCache.length >= maxEntries) {
      _pathCache.remove(_pathCache.keys.first); // Evict oldest
    }
    _pathCache[key] = newPath;
    return newPath;
  }

  /// Current number of cached paths.
  static int get entryCount => _pathCache.length;

  /// Clear the cache.
  static void clear() {
    _pathCache.clear();
  }
}
