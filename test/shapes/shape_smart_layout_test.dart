import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 5: Smart Layout Engine Tests', () {
    test('Calculates geometry-aware safe padding dynamically based on shape parameters', () {
      const containerSize = Size(300, 150);

      // FolderTab with 24dp tabHeight
      final folderConfig = DynamicShapeConfig(
        type: DynamicShapeType.folderTab,
        tabHeight: 24.0,
      );
      final folderPadding = ShapeSmartLayout.computeSafePadding(
        size: containerSize,
        config: folderConfig,
      );
      expect(folderPadding.top, greaterThanOrEqualTo(32.0));

      // ZigzagCut with 14dp toothHeight
      final zigzagConfig = DynamicShapeConfig(
        type: DynamicShapeType.zigzagCut,
        toothHeight: 14.0,
      );
      final zigzagPadding = ShapeSmartLayout.computeSafePadding(
        size: containerSize,
        config: zigzagConfig,
      );
      expect(zigzagPadding.bottom, greaterThanOrEqualTo(26.0));

      // SpeechBubble with 18dp tailHeight
      final bubbleConfig = DynamicShapeConfig(
        type: DynamicShapeType.speechBubble,
        anchor: ShapeAnchor.bottomRight,
        speechBubbleTailHeight: 18.0,
      );
      final bubblePadding = ShapeSmartLayout.computeSafePadding(
        size: containerSize,
        config: bubbleConfig,
      );
      expect(bubblePadding.bottom, greaterThanOrEqualTo(28.0));

      // Ribbon with 22dp fold depth
      final ribbonConfig = DynamicShapeConfig(
        type: DynamicShapeType.ribbon,
        ribbonFoldDepth: 22.0,
      );
      final ribbonPadding = ShapeSmartLayout.computeSafePadding(
        size: containerSize,
        config: ribbonConfig,
      );
      expect(ribbonPadding.left, greaterThanOrEqualTo(30.0));
      expect(ribbonPadding.right, greaterThanOrEqualTo(30.0));
    });

    test(
      'RTL dynamically mirrors safe insets for sideTabs and asymmetric notches',
      () {
        const containerSize = Size(250, 120);

        final sideTabConfig = DynamicShapeConfig(
          type: DynamicShapeType.sideTab,
          anchor: ShapeAnchor.rightCenter,
          protrusionDepth: 20.0,
        );

        // LTR: right side tab protrusion requires right inset
        final ltrPadding = ShapeSmartLayout.computeSafePadding(
          size: containerSize,
          config: sideTabConfig,
          textDirection: TextDirection.ltr,
        );
        expect(ltrPadding.right, greaterThan(ltrPadding.left));

        // RTL: right side tab anchor flips to left, requiring left inset
        final rtlPadding = ShapeSmartLayout.computeSafePadding(
          size: containerSize,
          config: sideTabConfig,
          textDirection: TextDirection.rtl,
        );
        expect(rtlPadding.left, greaterThan(rtlPadding.right));
      },
    );

    test('Inscribed rect calculates collision-free inner bounds', () {
      const size = Size(200, 100);
      const config = DynamicShapeConfig(type: DynamicShapeType.shield);

      final rect = ShapeSmartLayout.computeInscribedRect(size, config);
      expect(rect.width, greaterThan(0.0));
      expect(rect.height, greaterThan(0.0));
      expect(rect.left, greaterThanOrEqualTo(0.0));
      expect(rect.right, lessThanOrEqualTo(size.width));
      expect(rect.bottom, lessThanOrEqualTo(size.height));
    });

    test('Validates accessible touch target dimensions (min 48x48 dp)', () {
      const tinySize = Size(24, 18);
      final validSize = ShapeSmartLayout.validateTouchTarget(tinySize);

      expect(validSize.width, greaterThanOrEqualTo(48.0));
      expect(validSize.height, greaterThanOrEqualTo(48.0));

      const largeSize = Size(80, 60);
      final intactSize = ShapeSmartLayout.validateTouchTarget(largeSize);
      expect(intactSize.width, 80.0);
      expect(intactSize.height, 60.0);
    });

    testWidgets('ShapeSafeArea dynamically cushions text inside container', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: ShapeSafeArea(
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.folderTab,
                  tabHeight: 20.0,
                ),
                child: const Text('Guaranteed Safe Text'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Guaranteed Safe Text'), findsOneWidget);
    });
  });
}
