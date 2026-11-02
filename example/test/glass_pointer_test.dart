import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  testWidgets('glass hover lifts and right-click opens the context menu',
      (tester) async {
    var hovered = false;
    var copied = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: Material4Container(
            shape: Material4Type.capsule,
            width: 64,
            height: 64,
            liquidGlass: Material4LiquidGlass(
              onHover: (v) => hovered = v,
              contextMenu: [
                GlassContextMenuAction(
                  onPressed: () => copied = true,
                  child: const Text('Copy'),
                ),
              ],
            ),
            onTap: () {},
            child: const Icon(Icons.photo),
          ),
        ),
      ),
    ));
    await tester.pump();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byIcon(Icons.photo)) +
        const Offset(10, -10));
    await tester.pump(const Duration(milliseconds: 300));
    expect(hovered, isTrue);
    expect(find.byType(Transform), findsWidgets);

    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 400));
    expect(hovered, isFalse);

    await tester.tapAt(tester.getCenter(find.byIcon(Icons.photo)),
        buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(copied, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('help tag, keyboard focus and shared light', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Material4GlassLight(
        followPointer: true,
        child: Scaffold(
          backgroundColor: Colors.indigo,
          body: Center(
            child: Material4Container(
              shape: Material4Type.capsule,
              width: 64,
              height: 64,
              liquidGlass: const Material4LiquidGlass(tooltip: 'Share'),
              onTap: () => taps++,
              child: const Icon(Icons.ios_share),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byIcon(Icons.ios_share)));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Share'), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Share'), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Share'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(milliseconds: 300));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });
}
