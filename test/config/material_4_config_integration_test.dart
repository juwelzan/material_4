import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testSize = Size(200.0, 100.0);

  group('Material4Config Phase 2 Integration Tests', () {
    test(
        'Constructs with modern ShapeCorners and backward compatible CornerRadii',
        () {
      final corners = ShapeCorners.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.elliptical(24, 12),
        bottomLeft: const Radius.circular(8),
        bottomRight: const Radius.circular(4),
      );

      final config = Material4Config(corners: corners);

      expect(config.corners, equals(corners));
      expect(config.resolvedCorners, equals(corners));
      expect(config.cornerRadii, isNotNull);
      expect(config.cornerRadii!.topLeft, 16.0);
      expect(config.cornerRadii!.topRight, 24.0);
      expect(config.cornerRadii!.bottomLeft, 8.0);
      expect(config.cornerRadii!.bottomRight, 4.0);
    });

    test('Constructs with legacy CornerRadii and resolves to ShapeCorners', () {
      const radii = CornerRadii.only(
        topLeft: 10,
        topRight: 20,
        bottomLeft: 30,
        bottomRight: 40,
      );

      const config = Material4Config(cornerRadii: radii);

      expect(config.cornerRadii, equals(radii));
      final resolved = config.resolvedCorners;
      expect(resolved.topLeft.x, 10.0);
      expect(resolved.topRight.x, 20.0);
      expect(resolved.bottomLeft.x, 30.0);
      expect(resolved.bottomRight.x, 40.0);
    });

    test(
        'Constructs with modern ShapeTransform and backward compatible primitives',
        () {
      const transform = ShapeTransform(
        rotation: 0.25,
        scaleX: 1.5,
        scaleY: 0.8,
        skewX: 0.1,
        stretchOffset: Offset(5, -5),
      );

      const config = Material4Config(transform: transform);

      expect(config.transform, equals(transform));
      expect(config.resolvedTransform, equals(transform));
      expect(config.rotation, 0.25);
      expect(config.scaleX, 1.5);
      expect(config.scaleY, 0.8);
      expect(config.stretchOffset, const Offset(5, -5));
    });

    test('Legacy rotation, scale, stretch construct valid resolvedTransform',
        () {
      const config = Material4Config(
        rotation: 0.5,
        scaleX: 1.2,
        scaleY: 0.9,
        stretchOffset: Offset(10, 20),
      );

      final resolved = config.resolvedTransform;
      expect(resolved.rotation, 0.5);
      expect(resolved.scaleX, 1.2);
      expect(resolved.scaleY, 0.9);
      expect(resolved.stretchOffset, const Offset(10, 20));
      expect(resolved.hasTransform, isTrue);
    });

    test('Deep equality and hashCode on Material4Config', () {
      const config1 = Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16.0,
        edges: ShapeEdges(
          top: ShapeEdgeConfig.convex(depth: 12.0),
          bottom: ShapeEdgeConfig.wave(waveCount: 2.0, waveAmplitude: 6.0),
        ),
        constraints: ShapeConstraints(minWidth: 10.0, maxWidth: 300.0),
      );

      const config2 = Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16.0,
        edges: ShapeEdges(
          top: ShapeEdgeConfig.convex(depth: 12.0),
          bottom: ShapeEdgeConfig.wave(waveCount: 2.0, waveAmplitude: 6.0),
        ),
        constraints: ShapeConstraints(minWidth: 10.0, maxWidth: 300.0),
      );

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));

      final config3 = config1.copyWith(cornerRadius: 20.0);
      expect(config1 == config3, isFalse);
    });

    test('Material4Config full serialization and deserialization round-trip',
        () {
      const original = Material4Config(
        type: Material4Type.speechBubble,
        cornerRadius: 18.0,
        transform: ShapeTransform(rotation: 0.1, scaleX: 1.1),
        constraints: ShapeConstraints(minWidth: 20, minHeight: 20),
        edges: ShapeEdges(
          top: ShapeEdgeConfig.wave(waveCount: 3.0, waveAmplitude: 4.0),
        ),
        bezierConfig: CustomBezierConfig(
          segments: [
            BezierSegmentConfig(
              start: Offset(0, 0),
              control1: Offset(0.5, 0.2),
              control2: Offset(0.8, 0.5),
              end: Offset(1, 1),
            ),
          ],
        ),
      );

      final json = original.toJson();
      final restored = Material4Config.fromJson(json);

      expect(restored.type, original.type);
      expect(restored.cornerRadius, original.cornerRadius);
      expect(restored.transform?.rotation, original.transform?.rotation);
      expect(restored.constraints.minWidth, original.constraints.minWidth);
      expect(restored.edges?.top.waveCount, original.edges?.top.waveCount);
      expect(restored.bezierConfig?.segments.length,
          original.bezierConfig?.segments.length);
    });
  });

  group('Material4PathBuilder Phase 2 Geometry Tests', () {
    test(
        'Builds custom 4-edge shape with straight, convex, concave, wave, zigzag',
        () {
      const config = Material4Config(
        edges: ShapeEdges(
          top: ShapeEdgeConfig.convex(depth: 15.0),
          right: ShapeEdgeConfig.zigzag(toothWidth: 12.0, depth: 6.0),
          bottom: ShapeEdgeConfig.concave(depth: 10.0),
          left: ShapeEdgeConfig.wave(waveCount: 2.0, waveAmplitude: 5.0),
        ),
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path, isNotNull);
      final bounds = path.getBounds();
      expect(bounds.isEmpty, isFalse);
      expect(bounds.width, greaterThan(150.0));
      expect(bounds.height, greaterThan(80.0));
    });

    test('Builds shape with edge CustomBezier segment', () {
      const config = Material4Config(
        edges: ShapeEdges(
          top: ShapeEdgeConfig.customBezier(
            BezierSegmentConfig(
              start: Offset.zero,
              control1: Offset(0.3, 0.4),
              control2: Offset(0.7, -0.2),
              end: Offset(1.0, 0.0),
            ),
          ),
        ),
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('Builds shape using declarative CustomBezierConfig', () {
      const config = Material4Config(
        type: Material4Type.customBezier,
        bezierConfig: CustomBezierConfig(
          segments: [
            BezierSegmentConfig(
              start: Offset(0.0, 0.0),
              control1: Offset(0.5, 0.0),
              control2: Offset(1.0, 0.5),
              end: Offset(1.0, 1.0),
            ),
            BezierSegmentConfig(
              start: Offset(1.0, 1.0),
              control1: Offset(0.5, 1.0),
              control2: Offset(0.0, 0.5),
              end: Offset(0.0, 0.0),
            ),
          ],
        ),
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test(
        'Multi-notch placement across all four edges with collision evaluation',
        () {
      const config = Material4Config(
        cornerRadius: 12.0,
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 40.0,
            depth: 16.0,
            id: 'top_notch',
          ),
          ShapeNotch(
            edge: ShapeEdge.bottom,
            positionFactor: 0.5,
            width: 40.0,
            depth: 16.0,
            id: 'bottom_notch',
          ),
          ShapeNotch(
            edge: ShapeEdge.left,
            positionFactor: 0.5,
            width: 30.0,
            depth: 12.0,
            id: 'left_notch',
          ),
          ShapeNotch(
            edge: ShapeEdge.right,
            positionFactor: 0.5,
            width: 30.0,
            depth: 12.0,
            id: 'right_notch',
          ),
        ],
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('Respects ShapeConstraints clampSize during path generation', () {
      const config = Material4Config(
        constraints: ShapeConstraints(
          minWidth: 100.0,
          maxWidth: 150.0,
          minHeight: 50.0,
          maxHeight: 80.0,
        ),
      );

      // Pass size larger than max constraints
      final pathLarge = Material4PathBuilder.buildPath(
        const Size(500.0, 400.0),
        config,
      );
      final boundsLarge = pathLarge.getBounds();
      expect(boundsLarge.width, closeTo(150.0, 1.0));
      expect(boundsLarge.height, closeTo(80.0, 1.0));

      // Pass size smaller than min constraints
      final pathSmall = Material4PathBuilder.buildPath(
        const Size(20.0, 20.0),
        config,
      );
      final boundsSmall = pathSmall.getBounds();
      expect(boundsSmall.width, closeTo(100.0, 1.0));
      expect(boundsSmall.height, closeTo(50.0, 1.0));
    });

    test(
        'ShapePathCacheKey includes all Phase 2 properties and manages LRU cache',
        () {
      final cache = ShapePathCache(maxCapacity: 3);

      const configA = Material4Config(
        edges: ShapeEdges(top: ShapeEdgeConfig.convex(depth: 10)),
      );
      const configB = Material4Config(
        edges: ShapeEdges(top: ShapeEdgeConfig.convex(depth: 20)),
      );

      final keyA = ShapeCacheKey(size: testSize, config: configA);
      final keyB = ShapeCacheKey(size: testSize, config: configB);

      expect(keyA == keyB, isFalse);
      expect(keyA.hashCode == keyB.hashCode, isFalse);

      // Populate cache
      cache.getOrCreate(
          size: testSize,
          config: configA,
          computePath: () => Path()..addRect(Offset.zero & testSize));
      expect(cache.currentSize, 1);
      expect(cache.hits, 0);
      expect(cache.misses, 1);

      // Hit cache
      cache.getOrCreate(
          size: testSize, config: configA, computePath: () => Path());
      expect(cache.hits, 1);
      expect(cache.misses, 1);
    });

    test(
        'All SchoolShapePresets presets continue to build valid non-empty paths',
        () {
      final presets = [
        SchoolShapePresets.attendanceConfig(),
        SchoolShapePresets.academicConfig(),
        SchoolShapePresets.studentIdConfig(),
        SchoolShapePresets.achievementConfig(),
        SchoolShapePresets.feeReceiptConfig(),
        SchoolShapePresets.noticeBoardConfig(),
        SchoolShapePresets.examScheduleConfig(),
        SchoolShapePresets.resultConfig(),
        SchoolShapePresets.timetableConfig(),
        SchoolShapePresets.teacherProfileConfig(),
      ];

      for (final preset in presets) {
        final path = Material4PathBuilder.buildPath(testSize, preset);
        expect(path.getBounds().isEmpty, isFalse,
            reason: 'Failed for ${preset.type}');
      }
    });
  });
}
