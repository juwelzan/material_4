import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

Future<void> _screen(WidgetTester tester, double w, double h) async {
  tester.view.physicalSize = Size(w, h);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Widget _app(Widget home) => MaterialApp(
      builder: (context, child) => Material4Responsive(child: child!),
      home: home,
    );

const _dest = [
  Material4Destination(icon: Icons.home, label: 'Home'),
  Material4Destination(icon: Icons.search, label: 'Search'),
  Material4Destination(icon: Icons.person, label: 'Profile'),
];

Widget _shell({Widget? detail}) => Material4AdaptiveScaffold(
      destinations: _dest,
      body: const Text('list'),
      secondaryBody: detail,
    );

void main() {
  group('device type', () {
    test('phone / tablet by shortest side, desktop by platform', () {
      expect(
          Material4Responsive.deviceFor(const Size(390, 844),
              platform: TargetPlatform.iOS),
          Material4DeviceType.phone);
      // A phone in landscape is still a phone.
      expect(
          Material4Responsive.deviceFor(const Size(844, 390),
              platform: TargetPlatform.iOS),
          Material4DeviceType.phone);
      expect(
          Material4Responsive.deviceFor(const Size(1024, 768),
              platform: TargetPlatform.iOS),
          Material4DeviceType.tablet);
      expect(
          Material4Responsive.deviceFor(const Size(500, 700),
              platform: TargetPlatform.macOS),
          Material4DeviceType.desktop);
    });
  });

  group('adaptive scaffold changes structure per size', () {
    testWidgets('phone: bottom bar, no detail pane', (tester) async {
      await _screen(tester, 390, 844);
      await tester.pumpWidget(_app(_shell(detail: const Text('detail'))));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('detail'), findsNothing);
    });

    testWidgets('small tablet: rail with labels', (tester) async {
      await _screen(tester, 744, 1133);
      await tester.pumpWidget(_app(_shell(detail: const Text('detail'))));
      expect(find.byType(NavigationBar), findsNothing);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(find.text('detail'), findsNothing);
    });

    testWidgets('tablet landscape: rail + list-detail panes', (tester) async {
      await _screen(tester, 1180, 820);
      await tester.pumpWidget(_app(_shell(detail: const Text('detail'))));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('list'), findsOneWidget);
      expect(find.text('detail'), findsOneWidget);
    });

    testWidgets('desktop: extended rail', (tester) async {
      await _screen(tester, 1440, 900);
      await tester.pumpWidget(_app(_shell()));
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });
  });

  testWidgets('layout switcher picks the nearest smaller layout',
      (tester) async {
    Widget layout() => Material4ResponsiveLayout(
          duration: Duration.zero,
          compact: (_) => const Text('compact'),
          expanded: (_) => const Text('expanded'),
        );
    await _screen(tester, 700, 900); // medium → falls back to compact
    await tester.pumpWidget(_app(layout()));
    expect(find.text('compact'), findsOneWidget);
    await _screen(tester, 1300, 900); // large → falls back to expanded
    await tester.pumpWidget(_app(layout()));
    expect(find.text('expanded'), findsOneWidget);
  });

  testWidgets('visibility follows from / until', (tester) async {
    await _screen(tester, 390, 844);
    await tester.pumpWidget(_app(const Column(children: [
      Material4ResponsiveVisibility(
          from: Material4SizeClass.expanded, child: Text('side')),
      Material4ResponsiveVisibility(
          until: Material4SizeClass.medium, child: Text('menu')),
    ])));
    expect(find.text('side'), findsNothing);
    expect(find.text('menu'), findsOneWidget);
  });

  testWidgets('grid reflows 1 → 2 → 3 cards per row', (tester) async {
    Future<int> perRow(double w) async {
      await _screen(tester, w, 1000);
      await tester.pumpWidget(_app(Material4ResponsiveGrid(
        children: [
          for (int i = 0; i < 6; i++) SizedBox(key: Key('c$i'), height: 40),
        ],
      )));
      final y0 = tester.getRect(find.byKey(const Key('c0'))).top;
      var n = 0;
      for (int i = 0; i < 6; i++) {
        if (tester.getRect(find.byKey(Key('c$i'))).top == y0) n++;
      }
      return n;
    }

    expect(await perRow(390), 1);
    expect(await perRow(700), 2);
    expect(await perRow(1000), 3);
  });

  testWidgets('extreme sizes render without overflow', (tester) async {
    for (final s in const [Size(240, 400), Size(2560, 1440)]) {
      await _screen(tester, s.width, s.height);
      await tester.pumpWidget(_app(_shell(detail: const Text('detail'))));
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });
}
