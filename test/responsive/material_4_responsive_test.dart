import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

Future<void> _setScreen(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Widget _app(Widget home, {Material4ResponsiveScale? scale}) => MaterialApp(
      builder: (context, child) => Material4Responsive(
        scale: scale ?? const Material4ResponsiveScale(),
        child: child!,
      ),
      home: home,
    );

void main() {
  test('breakpoints classify widths', () {
    const b = Material4Breakpoints();
    expect(b.classify(390), Material4SizeClass.compact);
    expect(b.classify(700), Material4SizeClass.medium);
    expect(b.classify(1000), Material4SizeClass.expanded);
    expect(b.classify(1300), Material4SizeClass.large);
    expect(b.classify(1600), Material4SizeClass.extraLarge);
  });

  test('value() falls back to the nearest smaller class', () {
    const s = Material4Screen(
      sizeClass: Material4SizeClass.expanded,
      scale: 1,
      size: Size(1000, 800),
    );
    expect(s.value(compact: 1, medium: 2), 2);
    expect(s.value(compact: 1), 1);
    expect(s.value(compact: 1, expanded: 3, large: 4), 3);
  });

  testWidgets('a fixed-size box keeps its proportion of the screen',
      (tester) async {
    // 390 is the compact design width: a 195-wide box is half the screen.
    for (final width in [360.0, 390.0, 430.0]) {
      await _setScreen(tester, Size(width, 800));
      await tester.pumpWidget(_app(const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(key: Key('box'), width: 195, height: 50),
      )));
      final size = tester.getRect(find.byKey(const Key('box'))).size;
      expect(size.width, closeTo(width / 2, 0.01), reason: 'at $width');
    }
  });

  testWidgets('taps land on scaled content', (tester) async {
    await _setScreen(tester, const Size(430, 800));
    var taps = 0;
    await tester.pumpWidget(_app(Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => taps++,
        child: const SizedBox(key: Key('t'), width: 60, height: 60),
      ),
    )));
    await tester.tap(find.byKey(const Key('t')));
    expect(taps, 1);
  });

  testWidgets('MediaQuery inside reports the scaled size', (tester) async {
    await _setScreen(tester, const Size(468, 900)); // 1.2× of 390
    late Size inner;
    late Material4Screen screen;
    await tester.pumpWidget(_app(Builder(builder: (context) {
      inner = MediaQuery.sizeOf(context);
      screen = context.responsive;
      return const SizedBox();
    })));
    expect(screen.scale, closeTo(1.2, 1e-9));
    expect(inner.width, closeTo(390, 0.01));
    expect(screen.isCompact, isTrue);
  });

  testWidgets('tablets reflow into their own size class', (tester) async {
    await _setScreen(tester, const Size(1024, 768));
    late Material4Screen screen;
    await tester.pumpWidget(_app(Builder(builder: (context) {
      screen = context.responsive;
      return const SizedBox();
    })));
    expect(screen.sizeClass, Material4SizeClass.expanded);
    expect(screen.scale, closeTo(1.0, 1e-9));
    expect(screen.columns, 12);
  });

  testWidgets('noScale only classifies', (tester) async {
    await _setScreen(tester, const Size(430, 800));
    late Material4Screen screen;
    await tester.pumpWidget(MaterialApp(
      home: Material4Responsive.noScale(
        child: Builder(builder: (context) {
          screen = context.responsive;
          return const SizedBox();
        }),
      ),
    ));
    expect(screen.scale, 1.0);
    expect(screen.isCompact, isTrue);
  });

  testWidgets('works inside a scroll view (unbounded height)', (tester) async {
    await _setScreen(tester, const Size(430, 800));
    await tester.pumpWidget(MaterialApp(
      home: ListView(children: const [
        Material4Responsive(
          child: SizedBox(key: Key('row'), height: 100),
        ),
      ]),
    ));
    expect(tester.takeException(), isNull);
    final h = tester.getRect(find.byKey(const Key('row'))).height;
    expect(h, closeTo(100 * 430 / 390, 0.01));
  });
}
