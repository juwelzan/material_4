import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/internal.dart';

Widget _button({required VoidCallback onTap}) => Material4Container(
      width: 120,
      height: 56,
      shape: Material4Type.capsule,
      onTap: onTap,
      liquidGlass: const Material4LiquidGlass(),
      child: const Center(child: Text('Glass')),
    );

double _growth(WidgetTester tester) => tester
    .renderObject<RenderRawLiquidStretch>(find.byType(RawLiquidStretch).first)
    .pressGrowthPixels;

void main() {
  testWidgets('a plain tap activates exactly once', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
        home: Center(child: _button(onTap: () => taps++))));
    await tester.tap(find.text('Glass'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('dragging the finger a little still activates (touch-up-inside)',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
        home: Center(child: _button(onTap: () => taps++))));
    final g = await tester.startGesture(tester.getCenter(find.text('Glass')));
    await tester.pump(const Duration(milliseconds: 50));
    await g.moveBy(const Offset(20, 10));
    await g.moveBy(const Offset(20, 10));
    await tester.pump(const Duration(milliseconds: 50));
    expect(_growth(tester), greaterThan(0), reason: 'still pressed');
    await g.up();
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('leaving the touch slop releases the press and cancels the tap',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
        home: Center(child: _button(onTap: () => taps++))));
    final g = await tester.startGesture(tester.getCenter(find.text('Glass')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(_growth(tester), greaterThan(0));
    for (int i = 0; i < 8; i++) {
      await g.moveBy(const Offset(0, 25));
    }
    await tester.pumpAndSettle();
    expect(_growth(tester), closeTo(0, 0.01), reason: 'press let go outside');
    await g.up();
    await tester.pumpAndSettle();
    expect(taps, 0);
  });

  testWidgets('in a scroll view the press waits, and scrolling releases it',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: ListView(children: [
        for (int i = 0; i < 20; i++)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: _button(onTap: () => taps++)),
          ),
      ]),
    ));
    final g =
        await tester.startGesture(tester.getCenter(find.text('Glass').first));
    await tester.pump(const Duration(milliseconds: 40));
    expect(_growth(tester), 0, reason: 'press delayed in a scroll view');
    for (int i = 0; i < 6; i++) {
      await g.moveBy(const Offset(0, -15));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pump(const Duration(milliseconds: 200));
    expect(_growth(tester), closeTo(0, 0.01), reason: 'scroll released it');
    await g.up();
    await tester.pumpAndSettle();
    expect(taps, 0);

    // A quick tap in the list still activates.
    await tester.tap(find.text('Glass').at(3));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('opening a context menu on glass with a tooltip does not throw',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: Material4Container(
          width: 120,
          height: 56,
          shape: Material4Type.capsule,
          onTap: () {},
          liquidGlass: Material4LiquidGlass(
            tooltip: 'Photo',
            contextMenu: [
              GlassContextMenuAction(
                onPressed: () {},
                child: const Text('Share'),
              ),
            ],
          ),
          child: const Center(child: Text('Glass')),
        ),
      ),
    ));
    await tester.longPress(find.text('Glass'));
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(tester.takeException(), isNull);
    expect(find.text('Share'), findsWidgets);
  });
}
