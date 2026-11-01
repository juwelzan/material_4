import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';
// LiquidStretch is internal to the glass engine; imported only to assert on it.
import 'package:material_4/src/liquid_glass/src/engine/stretch.dart'
    show LiquidStretch;
import 'package:material_4/src/liquid_glass/utils/glass_quality_adapter.dart';

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

  // Regression: missing shader *image filters* (web, Skia desktop, many
  // Android GPUs; also the headless test runner) used to force minimal,
  // stripping the lens shader and the blur from interactive glass.
  test('static probe caps at standard without shader image filters', () {
    final adapter = GlassQualityAdapter(
      minQuality: GlassQuality.minimal,
      maxQuality: GlassQuality.premium,
      targetFrameMs: 16,
      allowStepUp: false,
      onQualityChanged: (_, __) {},
    );
    adapter.start();
    addTearDown(adapter.stop);
    expect(adapter.currentQuality, GlassQuality.standard);
  });

  group('Material4Container liquidGlass', () {
    testWidgets('minimal tier keeps the blur on interactive glass',
        (tester) async {
      await tester.pumpWidget(_host(_preset(
        glass: const Material4LiquidGlass(quality: GlassQuality.minimal),
      )));
      final glass = tester.widget<AdaptiveGlass>(find.byType(AdaptiveGlass));
      expect(glass.isInteractive, isFalse); // engine keeps BackdropFilter
      expect(find.byType(LiquidStretch), findsNothing);
      expect(find.byType(GlassGlow), findsOneWidget); // still responsive
    });

    // Regression: without an explicit fill the renderer paints opaque white
    // over the glass (and a drop shadow), hiding the effect entirely.
    testWidgets('glass container paints no opaque fill or default shadow',
        (tester) async {
      await tester.pumpWidget(_host(const Material4Container(
        shape: Material4Type.squircle,
        width: 200,
        height: 100,
        liquidGlass: Material4LiquidGlass(),
        background: Material4Background(
          pattern: Material4Pattern.dots(color: Color(0x33FFFFFF)),
        ),
      )));
      final rw = tester
          .widget<Material4RenderWidget>(find.byType(Material4RenderWidget));
      expect(rw.color, isNotNull);
      expect(rw.color!.a, 0.0);
      expect(rw.shadows, isEmpty);
      expect(rw.background!.color!.a, 0.0);
    });

    testWidgets('explicit fill and shadows on a glass container are kept',
        (tester) async {
      await tester.pumpWidget(_host(const Material4Container(
        width: 200,
        height: 100,
        color: Color(0x40FFFFFF),
        shadows: [BoxShadow(blurRadius: 4)],
        liquidGlass: Material4LiquidGlass(),
      )));
      final rw = tester
          .widget<Material4RenderWidget>(find.byType(Material4RenderWidget));
      expect(rw.color, const Color(0x40FFFFFF));
      expect(rw.shadows, hasLength(1));
    });

    testWidgets('containers without glass keep the default white fill',
        (tester) async {
      await tester.pumpWidget(_host(const Material4Container(
        width: 200,
        height: 100,
      )));
      final rw = tester
          .widget<Material4RenderWidget>(find.byType(Material4RenderWidget));
      expect(rw.color, isNull);
      expect(rw.shadows, same(kMaterial4DefaultShadows));
    });

    // Regression: the shape used to be sized from unbounded ListView
    // constraints, giving radius 0 and a rectangular slab of glass.
    testWidgets('capsule glass stays a capsule inside a ListView',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ListView(children: [
          Center(
            child: Material4Container(
              shape: Material4Type.capsule,
              width: 220,
              height: 60,
              liquidGlass: const Material4LiquidGlass(),
              onTap: () {},
            ),
          ),
          const Material4Container(
            shape: Material4Type.squircle,
            height: 120,
            config:
                Material4Config(type: Material4Type.squircle, cornerRadius: 28),
            liquidGlass: Material4LiquidGlass(),
          ),
        ]),
      ));
      final shapes = tester
          .widgetList<AdaptiveGlass>(find.byType(AdaptiveGlass))
          .map((g) => g.shape)
          .toList();
      expect(shapes, hasLength(2));
      expect(shapes[0], isA<LiquidRoundedSuperellipse>());
      expect((shapes[0] as LiquidRoundedSuperellipse).borderRadius,
          greaterThan(1000));
      expect((shapes[1] as LiquidRoundedSuperellipse).borderRadius, 28);
    });

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
