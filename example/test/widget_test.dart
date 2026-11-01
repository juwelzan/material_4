import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/main.dart';

void main() {
  testWidgets('Universal container app launches without exceptions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const Material4ContainerApp());
    await tester.pump();

    expect(find.byType(Material4ContainerApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
