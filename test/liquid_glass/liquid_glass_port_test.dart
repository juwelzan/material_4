import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Container(color: const Color(0xFF3B82F6))),
            Center(child: child),
          ],
        ),
      ),
    );

void main() {
  testWidgets('Ported GlassContainer renders', (tester) async {
    await tester.pumpWidget(_host(
      const GlassContainer(
        width: 200,
        height: 100,
        child: Text('glass'),
      ),
    ));
    await tester.pump();
    expect(find.text('glass'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Material4Container liquidGlass works on preset and custom shapes',
      (tester) async {
    final shapes = <Widget>[
      const Material4Container(
        shape: Material4Type.hexagonSoft,
        width: 200,
        height: 120,
        liquidGlass: Material4LiquidGlass(),
        border: Material4Border.gradientGlow(),
        child: Text('preset'),
      ),
      Material4Container(
        customShape: Material4CustomShape.star(points: 6),
        width: 160,
        height: 160,
        liquidGlass: const Material4LiquidGlass(
          settings: LiquidGlassSettings(thickness: 24, blur: 6),
          glowIntensity: 0.4,
          color: Color(0x22FFFFFF),
        ),
        child: const Text('custom'),
      ),
    ];
    for (final w in shapes) {
      await tester.pumpWidget(_host(w));
      await tester.pump();
      expect(find.byType(GlassContainer), findsOneWidget);
      expect(find.byType(ClipPath), findsWidgets);
      expect(tester.takeException(), isNull);
    }
  });
}
