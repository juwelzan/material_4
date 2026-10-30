import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_shape/dynamic_shape.dart';

void main() {
  group('Advanced Shape Hit Testing & Contour Accuracy', () {
    testWidgets('Diamond shape: center point hits, corner outside contour misses', (tester) async {
      bool tappedShape = false;
      bool tappedBackground = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                // Background widget to detect pass-through clicks
                Positioned.fill(
                  child: GestureDetector(
                    key: const ValueKey('background_receiver'),
                    onTap: () {
                      tappedBackground = true;
                    },
                    child: Container(color: Colors.grey),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 200,
                    height: 200,
                    config: const DynamicShapeConfig(
                      type: DynamicShapeType.diamond,
                    ),
                    onTap: () {
                      tappedShape = true;
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerRect = tester.getRect(find.byType(DynamicShapeRenderWidget));

      // 1. Center of diamond is inside the shape contour
      await tester.tapAt(containerRect.center);
      await tester.pump();
      expect(tappedShape, isTrue);
      expect(tappedBackground, isFalse);

      // Reset
      tappedShape = false;
      tappedBackground = false;

      // 2. Top-Left corner of bounding box (0,0) is transparent in a diamond shape
      // Click at (left + 5, top + 5)
      await tester.tapAt(containerRect.topLeft + const Offset(5, 5));
      await tester.pump();
      expect(tappedShape, isFalse);
      expect(tappedBackground, isTrue);
    });

    testWidgets('Arch shape: bottom-center hits, top-left/top-right corners miss', (tester) async {
      bool tappedShape = false;
      bool tappedBackground = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    key: const ValueKey('background_receiver'),
                    onTap: () {
                      tappedBackground = true;
                    },
                    child: Container(color: Colors.grey),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 200,
                    height: 200,
                    config: const DynamicShapeConfig(
                      type: DynamicShapeType.arch,
                    ),
                    onTap: () {
                      tappedShape = true;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerRect = tester.getRect(find.byType(DynamicShapeRenderWidget));

      // Center is inside arch
      await tester.tapAt(containerRect.center);
      await tester.pump();
      expect(tappedShape, isTrue);
      expect(tappedBackground, isFalse);

      // Reset
      tappedShape = false;
      tappedBackground = false;

      // Top-Left corner (5, 5) of 200x200 arch is outside the circular dome top
      await tester.tapAt(containerRect.topLeft + const Offset(5, 5));
      await tester.pump();
      expect(tappedShape, isFalse);
      expect(tappedBackground, isTrue);
    });
  });

  group('ShapeHitTestBehavior 5 Modes', () {
    testWidgets('Shape mode: hit only inside vector path', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 100,
                height: 100,
                config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
                hitTestBehavior: ShapeHitTestBehavior.shape,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(DynamicShapeRenderWidget));
      // Top left corner is outside diamond
      await tester.tapAt(rect.topLeft + const Offset(5, 5));
      await tester.pump();
      expect(tapped, isFalse);

      // Center is inside
      await tester.tapAt(rect.center);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('Rectangular mode: complete bounding box is interactive', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 100,
                height: 100,
                config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
                hitTestBehavior: ShapeHitTestBehavior.rectangular,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(DynamicShapeRenderWidget));
      // Top left corner is inside rectangular bounding box
      await tester.tapAt(rect.topLeft + const Offset(5, 5));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('Opaque mode: consumes pointer hits throughout bounds even without onTap', (tester) async {
      bool backgroundTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      backgroundTapped = true;
                    },
                    child: Container(color: Colors.green),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 100,
                    height: 100,
                    config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
                    hitTestBehavior: ShapeHitTestBehavior.opaque,
                    // No onTap callback, but opaque consumes the hit!
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(DynamicShapeRenderWidget));
      await tester.tapAt(rect.topLeft + const Offset(5, 5));
      await tester.pump();
      // Opaque blocks underlying background
      expect(backgroundTapped, isFalse);
    });

    testWidgets('DeferToChild mode: empty shape does not claim hits; child receives taps', (tester) async {
      bool childTapped = false;
      bool containerTapped = false;
      bool backgroundTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      backgroundTapped = true;
                    },
                    child: Container(color: Colors.red),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 200,
                    height: 200,
                    config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
                    hitTestBehavior: ShapeHitTestBehavior.deferToChild,
                    onTap: () {
                      containerTapped = true;
                    },
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          childTapped = true;
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerRect = tester.getRect(find.byType(DynamicShapeRenderWidget));

      // Click on child
      await tester.tapAt(containerRect.center);
      await tester.pump();
      expect(childTapped, isTrue);

      childTapped = false;

      // Click on empty shape space (not on child)
      await tester.tapAt(containerRect.topLeft + const Offset(20, 20));
      await tester.pump();
      // In deferToChild, shape itself doesn't claim empty space, so background receives it
      expect(containerTapped, isFalse);
      expect(backgroundTapped, isTrue);
    });
  });

  group('Notch and Transparent Region Interaction', () {
    testWidgets('Inward notch passes clicks through when enableNotchInteraction is false', (tester) async {
      bool shapeTapped = false;
      bool backgroundTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      backgroundTapped = true;
                    },
                    child: Container(color: Colors.amber),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 200,
                    height: 200,
                    config: const DynamicShapeConfig(
                      type: DynamicShapeType.smoothRounded,
                      notches: [
                        ShapeNotch(
                          edge: ShapeEdge.top,
                          positionFactor: 0.5,
                          width: 60.0,
                          depth: 40.0,
                          isInward: true,
                        ),
                      ],
                    ),
                    interaction: const DynamicShapeInteraction(
                      enableNotchInteraction: false,
                    ),
                    onTap: () {
                      shapeTapped = true;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerRect = tester.getRect(find.byType(DynamicShapeRenderWidget));

      // Click inside top center notch (x = 100, y = 20)
      final notchPoint = Offset(containerRect.left + 100, containerRect.top + 20);
      await tester.tapAt(notchPoint);
      await tester.pump();

      expect(shapeTapped, isFalse);
      expect(backgroundTapped, isTrue);
    });

    testWidgets('Inward notch claims clicks when enableNotchInteraction is true', (tester) async {
      bool shapeTapped = false;
      bool backgroundTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      backgroundTapped = true;
                    },
                    child: Container(color: Colors.amber),
                  ),
                ),
                Center(
                  child: DynamicShapeContainer(
                    width: 200,
                    height: 200,
                    config: const DynamicShapeConfig(
                      type: DynamicShapeType.smoothRounded,
                      notches: [
                        ShapeNotch(
                          edge: ShapeEdge.top,
                          positionFactor: 0.5,
                          width: 60.0,
                          depth: 40.0,
                          isInward: true,
                        ),
                      ],
                    ),
                    interaction: const DynamicShapeInteraction(
                      enableNotchInteraction: true,
                    ),
                    onTap: () {
                      shapeTapped = true;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerRect = tester.getRect(find.byType(DynamicShapeRenderWidget));

      // Click inside top center notch (x = 100, y = 20)
      final notchPoint = Offset(containerRect.left + 100, containerRect.top + 20);
      await tester.tapAt(notchPoint);
      await tester.pump();

      expect(shapeTapped, isTrue);
      expect(backgroundTapped, isFalse);
    });

    testWidgets('Transparent corners claim clicks when enableTransparentRegionInteraction is true', (tester) async {
      bool shapeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 150,
                height: 150,
                config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
                interaction: const DynamicShapeInteraction(
                  enableTransparentRegionInteraction: true,
                ),
                onTap: () {
                  shapeTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(DynamicShapeRenderWidget));
      // Top left corner is outside diamond path, but inside rectangular box
      await tester.tapAt(rect.topLeft + const Offset(5, 5));
      await tester.pump();

      expect(shapeTapped, isTrue);
    });
  });

  group('Coordinate Transformations & Matrix Inversion', () {
    testWidgets('Rotated shape hit testing accurately tests transformed contour', (tester) async {
      bool shapeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 100,
                height: 100,
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.smoothRounded,
                  transform: ShapeTransform(
                    rotation: 0.5, // ~28.6 degrees
                    scaleX: 1.1,
                    scaleY: 1.1,
                  ),
                ),
                onTap: () {
                  shapeTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(DynamicShapeRenderWidget));
      await tester.tapAt(rect.center);
      await tester.pump();
      expect(shapeTapped, isTrue);
    });

    test('Non-invertible singular matrix handles gracefully without throwing', () {
      const transform = ShapeTransform(scaleX: 0.0, scaleY: 0.0);
      const size = Size(100, 100);

      // Singular matrix tryInvert returns null
      final inverted = transform.tryInvert(size);
      expect(inverted, isNull);

      // transformPointForHitTest falls back gracefully without crashing
      final point = transform.transformPointForHitTest(const Offset(50, 50), size);
      expect(point, equals(const Offset(50, 50)));
    });

    test('NaN and Infinite coordinates are rejected safely', () {
      final path = Path()..addRect(const Rect.fromLTWH(0, 0, 100, 100));
      const size = Size(100, 100);

      expect(
        DynamicShapeHitTester.containsPoint(
          path: path,
          size: size,
          position: const Offset(double.nan, 50),
        ),
        isFalse,
      );

      expect(
        DynamicShapeHitTester.containsPoint(
          path: path,
          size: size,
          position: const Offset(50, double.infinity),
        ),
        isFalse,
      );
    });
  });

  group('Multi-Child Hit Testing & Z-Index Ordering', () {
    testWidgets('Multi-child hits topmost child according to zIndex', (tester) async {
      bool lowerChildTapped = false;
      bool upperChildTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeStack(
              config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
              width: 200,
              height: 200,
              layoutStrategy: ShapeLayoutStrategy.stack,
              children: [
                ShapeChild(
                  alignment: Alignment.center,
                  zIndex: 1, // lower z-index
                  child: GestureDetector(
                    onTap: () {
                      lowerChildTapped = true;
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                    ),
                  ),
                ),
                ShapeChild(
                  alignment: Alignment.center,
                  zIndex: 10, // higher z-index (topmost)
                  child: GestureDetector(
                    onTap: () {
                      upperChildTapped = true;
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final stackRect = tester.getRect(find.byType(DynamicShapeMultiChildRenderWidget));
      await tester.tapAt(stackRect.center);
      await tester.pump();

      // Topmost child with zIndex 10 should win the tap
      expect(upperChildTapped, isTrue);
      expect(lowerChildTapped, isFalse);
    });
  });

  group('Flutter Gesture Arena & Widgets Compatibility', () {
    testWidgets('ElevatedButton child receives tap while shape container preserves callback', (tester) async {
      bool buttonPressed = false;
      bool containerTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 250,
                height: 150,
                config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
                onTap: () {
                  containerTapped = true;
                },
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      buttonPressed = true;
                    },
                    child: const Text('Action Button'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap on button
      await tester.tap(find.text('Action Button'));
      await tester.pumpAndSettle();

      expect(buttonPressed, isTrue);
    });

    testWidgets('onLongPress and onDoubleTap callbacks trigger accurately', (tester) async {
      bool longPressed = false;
      bool doubleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 150,
                height: 150,
                config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
                onLongPress: () {
                  longPressed = true;
                },
                onDoubleTap: () {
                  doubleTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      final target = find.byType(DynamicShapeRenderWidget);

      // Long press
      await tester.longPress(target);
      await tester.pumpAndSettle();
      expect(longPressed, isTrue);

      // Double tap (using 2 taps within 200ms)
      await tester.tap(target);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(doubleTapped, isTrue);
    });
  });

  group('Shape-Aware Clipping Control', () {
    test('ShapeClipConfig presets and properties', () {
      const standard = ShapeClipConfig.standard;
      expect(standard.clipBackground, isTrue);
      expect(standard.clipChildren, isFalse);
      expect(standard.clipBorder, isFalse);
      expect(standard.clipShadows, isFalse);
      expect(standard.clipOverflow, isFalse);

      const allClipped = ShapeClipConfig.clipAllChildren;
      expect(allClipped.clipChildren, isTrue);
      expect(allClipped.clipOverflow, isTrue);

      final modified = standard.copyWith(clipChildren: true);
      expect(modified.clipChildren, isTrue);
      expect(modified.clipBackground, isTrue);
    });

    test('DynamicShapeClipManager determines clipping accurately', () {
      const config = DynamicShapeConfig();
      const protection = ShapeContentProtection(mode: ShapeContentMode.adaptive);

      expect(
        DynamicShapeClipManager.shouldClipChild(
          protection: protection,
          config: config,
          clipBehavior: Clip.antiAlias,
          clipConfig: const ShapeClipConfig(clipChildren: true),
        ),
        isTrue,
      );

      expect(
        DynamicShapeClipManager.shouldClipChild(
          protection: protection,
          config: config,
          clipBehavior: Clip.none,
          clipConfig: const ShapeClipConfig(clipChildren: true),
        ),
        isFalse,
      );
    });
  });

  group('Accessibility & Semantics', () {
    testWidgets('DynamicShapeContainer publishes semantic button and label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 150,
                height: 80,
                semanticLabel: 'Submit Order Shape',
                semanticHint: 'Double tap to place order',
                onTap: () {},
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(DynamicShapeRenderWidget)),
        matchesSemantics(
          label: 'Submit Order Shape',
          hint: 'Double tap to place order',
          isButton: true,
          hasTapAction: true,
          hasEnabledState: true,
          isEnabled: true,
        ),
      );
    });
  });
}
