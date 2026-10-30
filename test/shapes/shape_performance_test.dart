import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7: Performance Engine & LRU Cache Tests', () {
    late ShapePathCache cache;

    setUp(() {
      cache = ShapePathCache(maxCapacity: 4);
    });

    test(
      'Caches path on initial lookup and returns cached instance on repeat',
      () {
        const testSize = Size(150, 80);
        const config = DynamicShapeConfig(type: DynamicShapeType.squircle);

        expect(cache.currentSize, 0);

        final path1 = cache.getOrCreate(
          size: testSize,
          config: config,
          computePath: () => DynamicShapePathBuilder.buildPath(
            testSize,
            config,
            useCache: false,
          ),
        );

        expect(cache.currentSize, 1);
        expect(cache.misses, 1);
        expect(cache.hits, 0);

        final path2 = cache.getOrCreate(
          size: testSize,
          config: config,
          computePath: () => DynamicShapePathBuilder.buildPath(
            testSize,
            config,
            useCache: false,
          ),
        );

        expect(cache.currentSize, 1);
        expect(cache.misses, 1);
        expect(cache.hits, 1);
        expect(identical(path1, path2), isTrue);
        expect(cache.hitRate, 0.5);
      },
    );

    test(
      'Evicts oldest entry when maxCapacity is exceeded (strict LRU order)',
      () {
        const configA = DynamicShapeConfig(type: DynamicShapeType.folderTab);
        const configB = DynamicShapeConfig(type: DynamicShapeType.capsule);
        const configC = DynamicShapeConfig(type: DynamicShapeType.shield);
        const configD = DynamicShapeConfig(type: DynamicShapeType.diamond);
        const configE = DynamicShapeConfig(type: DynamicShapeType.octagon);

        const size = Size(100, 100);

        // Insert 4 items (at capacity)
        cache.getOrCreate(size: size, config: configA, computePath: Path.new);
        cache.getOrCreate(size: size, config: configB, computePath: Path.new);
        cache.getOrCreate(size: size, config: configC, computePath: Path.new);
        cache.getOrCreate(size: size, config: configD, computePath: Path.new);

        expect(cache.currentSize, 4);

        // Access A again to make it recently used: order is now B, C, D, A
        cache.getOrCreate(size: size, config: configA, computePath: Path.new);

        // Insert 5th item E: B should be evicted!
        cache.getOrCreate(size: size, config: configE, computePath: Path.new);
        expect(cache.currentSize, 4);

        // Query B: should be a miss because it was evicted
        final initialMisses = cache.misses;
        cache.getOrCreate(size: size, config: configB, computePath: Path.new);
        expect(cache.misses, initialMisses + 1);
      },
    );

    test(
      'clear() resets size and hit counters safely for low-memory events',
      () {
        const size = Size(120, 60);
        const config = DynamicShapeConfig(type: DynamicShapeType.cloud);

        cache.getOrCreate(size: size, config: config, computePath: Path.new);
        expect(cache.currentSize, 1);

        cache.clear();
        expect(cache.currentSize, 0);
        expect(cache.hits, 0);
        expect(cache.misses, 0);
        expect(cache.hitRate, 0.0);
      },
    );

    test('DynamicShapePathBuilder defaultCache operates seamlessly', () {
      DynamicShapePathBuilder.defaultCache.clear();

      const size = Size(200, 100);
      const config = DynamicShapeConfig(type: DynamicShapeType.waveEdge);

      final p1 = DynamicShapePathBuilder.buildPath(size, config);
      final p2 = DynamicShapePathBuilder.buildPath(size, config);

      expect(identical(p1, p2), isTrue);
      expect(
        DynamicShapePathBuilder.defaultCache.hits,
        greaterThanOrEqualTo(1),
      );
    });
  });
}
