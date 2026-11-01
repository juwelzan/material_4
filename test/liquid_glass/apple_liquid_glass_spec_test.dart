// Behaviour required by Apple's Liquid Glass documentation (SwiftUI
// `glassEffect`, HIG Materials, WWDC25 "Meet Liquid Glass").
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

Widget _host(Widget child, {bool highContrast = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(highContrast: highContrast),
        child: Scaffold(
          body: Stack(children: [
            Positioned.fill(child: Container(color: const Color(0xFF3B82F6))),
            Center(child: child),
          ]),
        ),
      ),
    );

Material4Container _glass(
  Material4LiquidGlass glass, {
  double w = 200,
  double h = 60,
  Widget child = const Text('label'),
}) =>
    Material4Container(
      shape: Material4Type.capsule,
      width: w,
      height: h,
      liquidGlass: glass,
      child: child,
    );

LiquidGlassSettings _settingsOf(WidgetTester t) =>
    t.widget<AdaptiveGlass>(find.byType(AdaptiveGlass)).settings;

void main() {
  group('variants', () {
    testWidgets('regular uses the Apple-calibrated material', (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass())));
      await t.pump();
      // Same calibrated optics (a control-sized capsule is only lightly
      // size-adapted).
      expect(_settingsOf(t).glassColor,
          Material4GlassMaterials.regularLight.glassColor);
      expect(_settingsOf(t).frost,
          closeTo(Material4GlassMaterials.regularLight.frost, 0.5));
      expect(_settingsOf(t).lensModel, GlassLensModel.paraxial);
    });

    testWidgets('clear is more transparent: no frost, no luminosity tint',
        (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass.clear())));
      await t.pump();
      final s = _settingsOf(t);
      expect(s.frost, 0);
      expect(s.glassColor.a,
          lessThan(Material4GlassMaterials.regularLight.glassColor.a));
    });

    testWidgets('clear dimming layer sits behind the glass', (t) async {
      await t.pumpWidget(
          _host(_glass(const Material4LiquidGlass.clear(dimming: .35))));
      await t.pump();
      final stack = t.widget<Stack>(find
          .ancestor(of: find.byType(AdaptiveGlass), matching: find.byType(Stack))
          .first);
      final dim = find.descendant(
          of: find.byWidget(stack.children.first),
          matching: find.byType(ColoredBox));
      expect(t.widget<ColoredBox>(dim).color.a, closeTo(.35, .01));
    });

    testWidgets('identity renders the content unaffected', (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass.identity())));
      expect(find.byType(AdaptiveGlass), findsNothing);
      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('tint colours the glass translucently', (t) async {
      await t.pumpWidget(_host(_glass(
          const Material4LiquidGlass.regular(tint: Color(0xFFFF9500)))));
      await t.pump();
      final c = _settingsOf(t).glassColor;
      expect(c.r, closeTo(1.0, .01));
      expect(c.a, closeTo(.30, .01)); // stained glass, not a solid fill
    });
  });

  group('adaptivity', () {
    testWidgets('labels on light glass are dark, on clear glass light',
        (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass())));
      expect(DefaultTextStyle.of(t.element(find.text('label'))).style.color,
          const Color(0xFF000000));
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass.clear())));
      expect(DefaultTextStyle.of(t.element(find.text('label'))).style.color,
          const Color(0xFFFFFFFF));
    });

    testWidgets('larger glass is thicker, more opaque and more lensed',
        (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass(),
          w: 120, h: 50)));
      await t.pump();
      await t.pump();
      final small = _settingsOf(t);
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass(),
          w: 360, h: 320)));
      await t.pump();
      await t.pump();
      final large = _settingsOf(t);
      expect(large.thickness, greaterThan(small.thickness));
      expect(large.frostOpacity, greaterThan(small.frostOpacity));
      expect(large.refractiveIndex, greaterThan(small.refractiveIndex));
    });

    testWidgets('Increase Contrast adds a contrasting border', (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass()),
          highContrast: true));
      await t.pump();
      final painters = t
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.foregroundPainter.runtimeType.toString());
      expect(painters, contains('_ContrastBorderPainter'));
    });
  });

  group('transitions & grouping', () {
    testWidgets('visible toggles a materialize transition', (t) async {
      await t.pumpWidget(_host(_glass(const Material4LiquidGlass())));
      expect(t.widget<GlassMaterialize>(find.byType(GlassMaterialize)).visible,
          isTrue);
      await t.pumpWidget(
          _host(_glass(const Material4LiquidGlass(visible: false))));
      expect(t.widget<GlassMaterialize>(find.byType(GlassMaterialize)).visible,
          isFalse);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });

    testWidgets('glass in a group shares one layer so it can merge',
        (t) async {
      await t.pumpWidget(_host(Material4GlassGroup(
        spacing: 24,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _glass(const Material4LiquidGlass(), w: 80),
          _glass(const Material4LiquidGlass(), w: 80),
        ]),
      )));
      await t.pump();
      final glasses = t.widgetList<AdaptiveGlass>(find.byType(AdaptiveGlass));
      expect(glasses, hasLength(2));
      expect(glasses.every((g) => !g.useOwnLayer), isTrue);
      expect(find.byType(AdaptiveLiquidGlassLayer), findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets('a tinted glass in a group keeps its tint on its own layer',
        (t) async {
      await t.pumpWidget(_host(Material4GlassGroup(
        child: _glass(
            const Material4LiquidGlass.regular(tint: Color(0xFF34C759))),
      )));
      await t.pump();
      final g = t.widget<AdaptiveGlass>(find.byType(AdaptiveGlass));
      expect(g.useOwnLayer, isTrue);
      expect(g.settings.glassColor.g, closeTo(0xC7 / 255, .01));
    });
  });
}
