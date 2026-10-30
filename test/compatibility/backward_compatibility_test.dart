// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Backward Compatibility Deprecated Aliases Test', () {
    test('DynamicShapeType maps directly to Material4Type', () {
      expect(DynamicShapeType.values.length, Material4Type.values.length);
      expect(DynamicShapeType.squircle, Material4Type.squircle);
      expect(DynamicShapeType.capsule, Material4Type.capsule);
      expect(DynamicShapeType.smoothRounded, Material4Type.smoothRounded);
    });

    test(
        'DynamicShapeConfig instantiates and behaves identically to Material4Config',
        () {
      const config = DynamicShapeConfig(
        type: DynamicShapeType.squircle,
        cornerRadius: 24.0,
      );
      expect(config.type, Material4Type.squircle);
      expect(config.cornerRadius, 24.0);
      const Material4Config aliased = config;
      expect(aliased.cornerRadius, 24.0);
    });

    test('DynamicShapePathBuilder generates paths correctly', () {
      final path = DynamicShapePathBuilder.build(
        const Size(100, 100),
        const DynamicShapeConfig(type: DynamicShapeType.squircle),
      );
      expect(path, isNotNull);
      expect(path.getBounds().isEmpty, isFalse);
    });

    testWidgets('DynamicShapeContainer renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 120,
                height: 80,
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.capsule),
                color: Colors.blue,
                child: const Text('Legacy Container'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Legacy Container'), findsOneWidget);
      expect(find.byType(Material4RenderWidget), findsOneWidget);
      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.size.width, 120.0);
      expect(renderBox.size.height, 80.0);
    });

    testWidgets('DynamicShapeStack renders layered shapes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeStack(
                width: 150,
                height: 150,
                config: const DynamicShapeConfig(
                    type: DynamicShapeType.hexagonSoft),
                children: const [
                  Text('Layer 1'),
                  Text('Layer 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Layer 1'), findsOneWidget);
      expect(find.text('Layer 2'), findsOneWidget);
    });

    testWidgets('AnimatedDynamicShapeContainer executes shape transitions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedDynamicShapeContainer(
                duration: const Duration(milliseconds: 200),
                width: 100,
                height: 100,
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.squircle),
                color: Colors.teal,
                child: const Text('Legacy Animated'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Legacy Animated'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedDynamicShapeContainer(
                duration: const Duration(milliseconds: 200),
                width: 150,
                height: 150,
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.capsule),
                color: Colors.orange,
                child: const Text('Legacy Animated'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Legacy Animated'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    test('RenderDynamicShape and RenderDynamicShapeMultiChild typedefs work',
        () {
      final renderObject = RenderDynamicShape(
        config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
      );
      final RenderMaterial4 aliasedRender = renderObject;
      expect(aliasedRender, isNotNull);

      final multiChild = RenderDynamicShapeMultiChild(
        config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
      );
      final RenderMultiChildMaterial4 aliasedMultiChild = multiChild;
      expect(aliasedMultiChild, isNotNull);
    });
  });
}
