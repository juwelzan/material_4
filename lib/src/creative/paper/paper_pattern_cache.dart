import 'dart:collection';
import 'package:flutter/material.dart';

/// Memory-bounded LRU cache for pattern paths and pre-calculated geometry tiles.
class PaperPatternCache {
  static const int maxEntries = 40;
  static final LinkedHashMap<String, Path> _cache =
      LinkedHashMap<String, Path>();

  PaperPatternCache._();

  /// Retrieve cached pattern path or compute and cache it.
  static Path getOrCreate(String key, Path Function() builder) {
    if (_cache.containsKey(key)) {
      final cached = _cache.remove(key)!;
      _cache[key] = cached;
      return cached;
    }

    final newPath = builder();
    if (_cache.length >= maxEntries) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = newPath;
    return newPath;
  }

  /// Current number of cached pattern entries.
  static int get entryCount => _cache.length;

  /// Clear the cache.
  static void clear() {
    _cache.clear();
  }
}
