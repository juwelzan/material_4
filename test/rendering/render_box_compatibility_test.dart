import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('RenderBox Preset Compatibility Tests', () {
    testWidgets('All 28 Material4Type presets render inside RenderMaterial4',
        (tester) async {
      for (final shapeType in Material4Type.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: Material4Container(
                width: 160,
                height: 100,
                config: Material4Config(type: shapeType),
                child: Text('Preset: ${shapeType.name}'),
              ),
            ),
          ),
        );

        final renderBox = tester.renderObject<RenderMaterial4>(
          find.byType(Material4RenderWidget),
        );
        expect(renderBox.size.width, equals(160.0));
        expect(renderBox.size.height, equals(100.0));
        expect(tester.takeException(), isNull);
      }
    });


    testWidgets(
        'Universal Material4Container renders every shape, factory, custom shape and border',
        (tester) async {
      // The single universal container renders every built-in shape preset
      // through `shape:`, plus the kept convenience factories, custom
      // developer geometry, and the advanced border engine.
      final factories = <Widget>[
        // Every built-in shape preset via the unified `shape:` parameter.
        for (final type in Material4Type.values)
          Material4Container(shape: type, child: Text(type.name)),
        // Kept convenience factories.
        Material4Container.glass(child: const Text('glass')),
        Material4Container.neon(child: const Text('neon')),
        Material4Container.fromPreset(
          preset: Material4ContainerPreset.carbonTech,
          child: const Text('preset'),
        ),
        // Developer-supplied custom geometry.
        Material4Container(
          customShape: Material4CustomShape.polygon(sides: 5, cornerRadius: 10),
          child: const Text('polygon'),
        ),
        Material4Container(
          customShape: Material4CustomShape.bezier(
            (size) => Path()
              ..moveTo(0, 0)
              ..lineTo(size.width, 0)
              ..lineTo(size.width, size.height)
              ..close(),
          ),
          child: const Text('bezier'),
        ),
        // Advanced border engine via the rich `border:` object.
        const Material4Container(
          border: Material4Border.segmentedGlow(),
          child: Text('segmentedGlow'),
        ),
        const Material4Container(
          border: Material4Border.ropeTwist(),
          child: Text('ropeTwist'),
        ),
      ];

      expect(factories.length, equals(Material4Type.values.length + 7));

      for (int i = 0; i < factories.length; i++) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 80,
                child: factories[i],
              ),
            ),
          ),
        );

        expect(find.byType(Material4RenderWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('RenderBox Transformations & Animation Integration', () {
    testWidgets('Custom Bezier shape renders and sizes correctly',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Material4Container(
              width: 200,
              height: 150,
              config: Material4Config.customBezier(
                builder: (size) {
                  return Path()
                    ..moveTo(0, size.height / 2)
                    ..quadraticBezierTo(
                        size.width / 2, 0, size.width, size.height / 2)
                    ..quadraticBezierTo(
                        size.width / 2, size.height, 0, size.height / 2)
                    ..close();
                },
              ),
              child: const Text('Bezier Lens'),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );
      expect(renderBox.size, equals(const Size(200, 150)));
      expect(renderBox.currentPath, isNotNull);
    });

    testWidgets(
        'ShapeTransform (rotation, scale, skew) integrates with RenderMaterial4 hit testing',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Material4Container(
              width: 100,
              height: 100,
              config: const Material4Config(
                type: Material4Type.smoothRounded,
                transform: ShapeTransform(
                  scaleX: 1.2,
                  scaleY: 1.2,
                  rotation: 0.1,
                ),
              ),
              onTap: () {
                tapped = true;
              },
              child: const Text('Transformed'),
            ),
          ),
        ),
      );

      final shapeFinder = find.byType(Material4RenderWidget);
      await tester.tap(shapeFinder);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
        'AnimatedMaterial4Container drives RenderMaterial4 during animation transitions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Container(
                duration: const Duration(milliseconds: 300),
                config: const Material4Config(type: Material4Type.squircle),
                width: 150,
                height: 80,
                color: Colors.blue,
                child: const Text('Animated Shape'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Material4RenderWidget), findsOneWidget);

      // Rebuild with different shape configuration to trigger animation
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Container(
                duration: const Duration(milliseconds: 300),
                config: const Material4Config(type: Material4Type.capsule),
                width: 200,
                height: 100,
                color: Colors.purple,
                child: const Text('Animated Shape'),
              ),
            ),
          ),
        ),
      );

      // Advance animation halfway
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(Material4RenderWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Settle animation
      await tester.pumpAndSettle();
      expect(find.byType(Material4RenderWidget), findsOneWidget);
    });
  });
}
