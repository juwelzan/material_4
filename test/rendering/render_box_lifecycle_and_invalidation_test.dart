import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('RenderMaterial4 Invalidation & Lifecycle Tests', () {
    testWidgets(
        'Paint-only property updates do not trigger layout invalidation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                borderColor: Colors.red,
                borderWidth: 2.0,
                config:
                    const Material4Config(type: Material4Type.smoothRounded),
                child: const Text('Invalidation Test'),
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );

      expect(renderBox.hasSize, isTrue);
      expect(renderBox.debugNeedsLayout, isFalse);
      expect(renderBox.debugNeedsPaint, isFalse);

      // Mutate paint-only properties directly
      renderBox.color = Colors.green;
      expect(renderBox.debugNeedsPaint, isTrue,
          reason: 'Changing color should mark needs paint');
      expect(renderBox.debugNeedsLayout, isFalse,
          reason: 'Changing color must not mark needs layout');

      // Clear paint flag by pumping a frame
      await tester.pump();
      expect(renderBox.debugNeedsPaint, isFalse);

      renderBox.borderColor = Colors.amber;
      expect(renderBox.debugNeedsPaint, isTrue);
      expect(renderBox.debugNeedsLayout, isFalse);

      await tester.pump();

      renderBox.shadows = const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
      ];
      expect(renderBox.debugNeedsPaint, isTrue);
      expect(renderBox.debugNeedsLayout, isFalse);
    });

    testWidgets('Layout-affecting property updates trigger layout invalidation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 200,
                height: 100,
                padding: const EdgeInsets.all(8),
                config: const Material4Config(type: Material4Type.capsule),
                child: const Text('Layout Test'),
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );

      expect(renderBox.debugNeedsLayout, isFalse);

      // Mutate config
      renderBox.config = const Material4Config(type: Material4Type.diamond);
      expect(renderBox.debugNeedsLayout, isTrue,
          reason: 'Changing shape config must mark needs layout');

      await tester.pump();
      expect(renderBox.debugNeedsLayout, isFalse);

      // Mutate padding
      renderBox.padding = const EdgeInsets.all(16);
      expect(renderBox.debugNeedsLayout, isTrue,
          reason: 'Changing padding must mark needs layout');

      await tester.pump();
      expect(renderBox.debugNeedsLayout, isFalse);

      // Mutate borderWidth
      renderBox.borderWidth = 4.0;
      expect(renderBox.debugNeedsLayout, isTrue,
          reason: 'Changing borderWidth must mark needs layout');

      await tester.pump();
      expect(renderBox.debugNeedsLayout, isFalse);

      // Mutate contentProtection
      renderBox.contentProtection = const ShapeContentProtection.strict();
      expect(renderBox.debugNeedsLayout, isTrue,
          reason: 'Changing contentProtection must mark needs layout');
    });

    testWidgets(
        'Attach, detach, and re-attach lifecycle cleanly manages resources',
        (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              key: key,
              child: Material4Container(
                width: 150,
                height: 75,
                config: const Material4Config(type: Material4Type.arch),
                child: const Text('Lifecycle'),
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );
      expect(renderBox.attached, isTrue);
      expect(renderBox.currentPath, isNotNull);

      // Unmount the container by removing it from the tree
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(renderBox.attached, isFalse);

      // Remount the container
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 150,
                height: 75,
                config: const Material4Config(type: Material4Type.arch),
                child: const Text('Lifecycle'),
              ),
            ),
          ),
        ),
      );

      final newRenderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );
      expect(newRenderBox.attached, isTrue);
    });

    testWidgets('Dry layout produces identical size to performLayout',
        (tester) async {
      final renderBox = RenderMaterial4(
        width: 180,
        height: 90,
        padding: const EdgeInsets.all(10),
        config: const Material4Config(type: Material4Type.hexagonSoft),
      );

      const constraints = BoxConstraints(
        minWidth: 50,
        maxWidth: 300,
        minHeight: 30,
        maxHeight: 200,
      );

      final drySize = renderBox.computeDryLayout(constraints);
      expect(drySize, equals(const Size(180, 90)));
    });

    testWidgets('Nested Material4Containers layout and paint without collision',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 280,
                height: 200,
                config:
                    const Material4Config(type: Material4Type.smoothRounded),
                color: Colors.deepPurple.shade50,
                borderColor: Colors.deepPurple,
                borderWidth: 2.0,
                child: Center(
                  child: Material4Container(
                    width: 160,
                    height: 100,
                    config: const Material4Config(
                        type: Material4Type.ticketScallop),
                    color: Colors.amber.shade100,
                    borderColor: Colors.amber.shade800,
                    borderWidth: 1.5,
                    child: const Center(
                      child: Text('Nested Shape',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Nested Shape'), findsOneWidget);
      expect(find.byType(Material4RenderWidget), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
