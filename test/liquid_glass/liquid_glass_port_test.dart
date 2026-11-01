import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';
// LiquidStretch is internal to the glass engine; imported only to assert on it.
import 'package:material_4/src/liquid_glass/src/engine/stretch.dart'
    show LiquidStretch;

Widget _host(Widget child, {bool disableAnimations = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(color: const Color(0xFF3B82F6)),
              ),
              Center(child: child),
            ],
          ),
        ),
      ),
    );

Widget _preset({Material4LiquidGlass glass = const Material4LiquidGlass()}) =>
    Material4Container(
      shape: Material4Type.squircle,
      width: 200,
      height: 120,
      liquidGlass: glass,
      onTap: () {},
      child: const Text('preset'),
    );

Widget _custom({Material4LiquidGlass glass = const Material4LiquidGlass()}) =>
    Material4Container(
      customShape: Material4CustomShape.star(points: 6),
      width: 160,
      height: 160,
      liquidGlass: glass,
      border: const Material4Border.gradientGlow(),
      child: const Text('custom'),
    );

Future<void> _pressAndRelease(WidgetTester tester, Finder target) async {
  final gesture = await tester.startGesture(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.moveBy(const Offset(18, 6));
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Ported GlassContainer renders', (tester) async {
    await tester.pumpWidget(_host(
      const GlassContainer(width: 200, height: 100, child: Text('glass')),
    ));
    await tester.pump();
    expect(find.text('glass'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('Material4Container liquidGlass', () {
    testWidgets('native rounded preset uses the shader shape, no clip',
        (tester) async {
      await tester.pumpWidget(_host(_preset()));
      await tester.pump();
      expect(find.byType(Material4LiquidGlassSurface), findsOneWidget);
      expect(find.byType(AdaptiveGlass), findsOneWidget);
      // The engine may clip internally (ShapeBorderClipper); what matters is
      // that the container's own path clipper is not applied to native shapes.
      final clippers = tester
          .widgetList<ClipPath>(find.descendant(
            of: find.byType(Material4LiquidGlassSurface),
            matching: find.byType(ClipPath),
          ))
          .map((c) => c.clipper.runtimeType.toString());
      expect(clippers.where((t) => t == '_Material4PathClipper'), isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('custom shape is clipped to its own path', (tester) async {
      await tester.pumpWidget(_host(_custom()));
      await tester.pump();
      final clippers = tester
          .widgetList<ClipPath>(find.descendant(
            of: find.byType(Material4LiquidGlassSurface),
            matching: find.byType(ClipPath),
          ))
          .map((c) => c.clipper.runtimeType.toString());
      expect(clippers, contains('_Material4PathClipper'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('tappable container gets iOS stretch + glow; panel does not',
        (tester) async {
      await tester.pumpWidget(_host(_preset()));
      expect(find.byType(LiquidStretch), findsOneWidget);
      expect(find.byType(GlassGlow), findsOneWidget);

      await tester.pumpWidget(_host(_custom()));
      expect(find.byType(LiquidStretch), findsNothing);

      await tester.pumpWidget(
        _host(_custom(glass: const Material4LiquidGlass.control())),
      );
      expect(find.byType(LiquidStretch), findsOneWidget);
    });

    testWidgets('reduce-motion disables the stretch', (tester) async {
      await tester.pumpWidget(_host(_preset(), disableAnimations: true));
      expect(find.byType(LiquidStretch), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('press, drag and release cleanly', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_host(Material4Container(
        shape: Material4Type.capsule,
        width: 180,
        height: 56,
        liquidGlass: const Material4LiquidGlass(),
        onTap: () => taps++,
        child: const Text('tap'),
      )));
      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();
      expect(taps, 1);
      await _pressAndRelease(tester, find.text('tap'));
      expect(tester.takeException(), isNull);
    });

    for (final quality in GlassQuality.values) {
      testWidgets('renders and animates at ${quality.name} quality',
          (tester) async {
        final glass = Material4LiquidGlass(
          quality: quality,
          interactive: true,
          settings: const LiquidGlassSettings(thickness: 24, blur: 6),
        );
        for (final w in [_preset(glass: glass), _custom(glass: glass)]) {
          await tester.pumpWidget(_host(w));
          await tester.pump();
          await _pressAndRelease(
              tester, find.byType(Material4LiquidGlassSurface));
          expect(tester.takeException(), isNull);
        }
      });
    }

    for (final platform in TargetPlatform.values) {
      testWidgets('works on ${platform.name}', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        try {
          for (final w in [_preset(), _custom()]) {
            await tester.pumpWidget(_host(w));
            await tester.pump();
            await _pressAndRelease(
                tester, find.byType(Material4LiquidGlassSurface));
            expect(tester.takeException(), isNull);
          }
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });
    }
  });
}
