import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4Button Factory Constructors & Rendering Tests', () {
    testWidgets('renders all factory constructors without crashing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Material4Button.filled(
                    onPressed: () {},
                    child: const Text('Filled'),
                  ),
                  Material4Button.outlined(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  Material4Button.text(
                    onPressed: () {},
                    child: const Text('Text'),
                  ),
                  Material4Button.elevated(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                  Material4Button.gradient(
                    onPressed: () {},
                    colors: const [Colors.purple, Colors.blue],
                    child: const Text('Gradient'),
                  ),
                  Material4Button.glass(
                    onPressed: () {},
                    child: const Text('Glass'),
                  ),
                  Material4Button.liquid(
                    onPressed: () {},
                    child: const Text('Liquid'),
                  ),
                  Material4Button.organic(
                    onPressed: () {},
                    child: const Text('Organic'),
                  ),
                  Material4Button.neon(
                    onPressed: () {},
                    neonColor: Colors.cyanAccent,
                    child: const Text('Neon'),
                  ),
                  Material4Button.threeD(
                    onPressed: () {},
                    faceColor: Colors.deepPurple,
                    child: const Text('3D'),
                  ),
                  Material4Button.floating(
                    onPressed: () {},
                    icon: Icons.add,
                  ),
                  Material4Button.icon(
                    onPressed: () {},
                    icon: Icons.star,
                    label: const Text('Icon Button'),
                  ),
                  Material4Button.fromPreset(
                    preset: Material4ButtonPreset.premium,
                    onPressed: () {},
                    child: const Text('Preset Premium'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Filled'), findsOneWidget);
      expect(find.text('Outlined'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
      expect(find.text('Elevated'), findsOneWidget);
      expect(find.text('Gradient'), findsOneWidget);
      expect(find.text('Glass'), findsOneWidget);
      expect(find.text('Liquid'), findsOneWidget);
      expect(find.text('Organic'), findsOneWidget);
      expect(find.text('Neon'), findsOneWidget);
      expect(find.text('3D'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Icon Button'), findsOneWidget);
      expect(find.text('Preset Premium'), findsOneWidget);
    });

    testWidgets('renders all 18 Material4ButtonPreset presets', (tester) async {
      const presets = [
        Material4ButtonPreset.primary,
        Material4ButtonPreset.secondary,
        Material4ButtonPreset.tertiary,
        Material4ButtonPreset.outlined,
        Material4ButtonPreset.text,
        Material4ButtonPreset.elevated,
        Material4ButtonPreset.gradient,
        Material4ButtonPreset.glass,
        Material4ButtonPreset.neon,
        Material4ButtonPreset.organic,
        Material4ButtonPreset.liquid,
        Material4ButtonPreset.floating,
        Material4ButtonPreset.threeD,
        Material4ButtonPreset.success,
        Material4ButtonPreset.danger,
        Material4ButtonPreset.warning,
        Material4ButtonPreset.info,
        Material4ButtonPreset.minimal,
        Material4ButtonPreset.premium,
      ];

      for (final preset in presets) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material4Button.fromPreset(
                preset: preset,
                onPressed: () {},
                child: Text('Preset ${preset.name}'),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Preset ${preset.name}'), findsOneWidget);
      }
    });

    testWidgets('supports custom shapes and geometries', (tester) async {
      final customShape = Material4CustomShape.polygon(sides: 6);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Material4Button(
                  shape: Material4Type.squircle,
                  onPressed: () {},
                  child: const Text('Squircle Button'),
                ),
                Material4Button(
                  customShape: customShape,
                  onPressed: () {},
                  child: const Text('Custom Shape Button'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Squircle Button'), findsOneWidget);
      expect(find.text('Custom Shape Button'), findsOneWidget);
    });
  });

  group('Material4Button Content Layout & Badge Tests', () {
    testWidgets('renders leading, trailing, top, and bottom icons with badges', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Material4Button(
                    onPressed: () {},
                    content: const Material4ButtonContent(
                      icon: Icon(Icons.bookmark),
                      iconPosition: ButtonIconPosition.leading,
                      label: Text('Bookmark Leading'),
                      badge: Text('NEW'),
                      hasDropdown: true,
                    ),
                  ),
                  Material4Button(
                    onPressed: () {},
                    content: const Material4ButtonContent(
                      icon: Icon(Icons.send),
                      iconPosition: ButtonIconPosition.trailing,
                      label: Text('Send Trailing'),
                      badge: Text('5'),
                    ),
                  ),
                  Material4Button(
                    onPressed: () {},
                    content: const Material4ButtonContent(
                      icon: Icon(Icons.cloud_upload),
                      iconPosition: ButtonIconPosition.top,
                      label: Text('Upload Top'),
                    ),
                  ),
                  Material4Button(
                    onPressed: () {},
                    content: const Material4ButtonContent(
                      icon: Icon(Icons.download),
                      iconPosition: ButtonIconPosition.bottom,
                      label: Text('Download Bottom'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Bookmark Leading'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      expect(find.text('Send Trailing'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Upload Top'), findsOneWidget);
      expect(find.text('Download Bottom'), findsOneWidget);
    });
  });

  group('Material4Button Interaction, Gestures & State Machine', () {
    testWidgets('tap triggers onPressed callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              onPressed: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(Material4Button), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));

      expect(tapped, isTrue);
    });

    testWidgets('disabled button does not trigger onPressed', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              enabled: false,
              onPressed: () => tapped = true,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(Material4Button), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 50));

      expect(tapped, isFalse);
    });

    testWidgets('loading state prevents tap callback and displays spinner', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              state: Material4ButtonState.loading,
              onPressed: () => tapped = true,
              child: const Text('Loading Button'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(Material4Button));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tapped, isFalse);
    });

    testWidgets('success and error states show respective icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Material4Button(
                  state: Material4ButtonState.success,
                  onPressed: () {},
                  child: const Text('Success'),
                ),
                Material4Button(
                  state: Material4ButtonState.error,
                  onPressed: () {},
                  child: const Text('Error'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });
  });

  group('Material4ButtonController Programmatic Controls', () {
    testWidgets('controller updates button states dynamically', (tester) async {
      final controller = Material4ButtonController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              controller: controller,
              onPressed: () {},
              child: const Text('Controller Target'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.state, Material4ButtonState.idle);

      // Programmatic loading
      controller.startLoading();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isLoading, isTrue);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      controller.stopLoading();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isLoading, isFalse);

      // Programmatic success feedback
      controller.showSuccess(message: 'Saved!', duration: const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isSuccess, isTrue);
      expect(find.text('Saved!'), findsOneWidget);

      // Wait for success duration to expire and revert to idle
      await tester.pump(const Duration(milliseconds: 250));
      expect(controller.state, Material4ButtonState.idle);

      // Programmatic error feedback
      controller.showError(message: 'Failed!', duration: const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isError, isTrue);
      expect(find.text('Failed!'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 250));
      expect(controller.state, Material4ButtonState.idle);

      // Enable and disable
      controller.disable();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isEnabled, isFalse);

      controller.enable();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.isEnabled, isTrue);

      controller.dispose();
    });
  });

  group('Material4Button Accessibility & WCAG Compliance', () {
    testWidgets('satisfies minimum touch target dimension (>= 48x48 dp)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              width: 32, // Request visual size smaller than 48dp
              height: 32,
              onPressed: () {},
              child: const Text('Compact'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));

      final buttonSize = tester.getSize(find.byType(Material4Button));
      expect(buttonSize.width, greaterThanOrEqualTo(48.0));
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('provides accessible Semantics node with button trait and label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              semanticLabel: 'Submit Registration Form',
              semanticHint: 'Double tap to send data',
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));

      expect(
        tester.getSemantics(find.byType(Material4Button)),
        matchesSemantics(
          label: 'Submit Registration Form',
          hint: 'Double tap to send data',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          isFocusable: true,
        ),
      );
    });

    testWidgets('triggers onPressed via Enter and Space keyboard events', (tester) async {
      int pressCount = 0;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Button(
              focusNode: focusNode,
              autofocus: true,
              onPressed: () => pressCount++,
              child: const Text('Keyboard Accessible'),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      expect(focusNode.hasFocus, isTrue);

      // Simulate Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump(const Duration(milliseconds: 50));
      expect(pressCount, 1);

      // Simulate Space key
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump(const Duration(milliseconds: 50));
      expect(pressCount, 2);

      focusNode.dispose();
    });

    testWidgets('respects Reduced Motion (MediaQuery.disableAnimations)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Material4Button(
                animation: const Material4ButtonAnimation(
                  pressAnimation: ButtonPressAnimation.scaleDown,
                  tapAnimation: ButtonTapAnimation.ripple,
                ),
                onPressed: () {},
                child: const Text('Reduced Motion'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Reduced Motion'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Reduced Motion'), findsOneWidget);
    });
  });

  group('Material4Button Performance Benchmark', () {
    testWidgets('renders 1, 10, 50, and 100 buttons smoothly without performance degradation', (tester) async {
      final buttonCounts = [1, 10, 50, 100];

      for (final count in buttonCounts) {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Material4Button.fromPreset(
                      preset: Material4ButtonPreset.values[index % Material4ButtonPreset.values.length],
                      onPressed: () {},
                      child: Text('Button #$index'),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 16));
        stopwatch.stop();

        // 100 buttons rendered within reasonable layout & pump threshold
        expect(stopwatch.elapsedMilliseconds, lessThan(1500),
            reason: 'Rendering $count buttons took ${stopwatch.elapsedMilliseconds}ms');
      }
    });
  });
}
