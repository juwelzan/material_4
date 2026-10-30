import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/avatar/avatar_showcase_screen.dart';

void main() {
  testWidgets('AvatarShowcaseScreen renders all 13 avatar presets cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AvatarShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify title and hero banner
    expect(find.text('Dynamic Avatar Gallery'), findsOneWidget);
    expect(find.text('Material 4 Avatar System'), findsOneWidget);

    // Verify presence of category filter chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Basic Shapes'), findsOneWidget);
    expect(find.text('Organic Shapes'), findsOneWidget);
    expect(find.text('Creative Shapes'), findsOneWidget);
    expect(find.text('Status & Badges'), findsOneWidget);
    expect(find.text('Morphing & Groups'), findsOneWidget);

    // Verify showcase items
    expect(find.text('01. Basic Circle Avatar'), findsOneWidget);
    expect(find.text('02. Squircle Avatar'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('03. Organic Avatar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('03. Organic Avatar'), findsOneWidget);

    // Scroll to view remaining items
    await tester.scrollUntilVisible(
      find.text('10. Animated Avatar (Shape Morphing)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('10. Animated Avatar (Shape Morphing)'), findsOneWidget);

    // Tap to morph shape
    final morphButtonFinder = find.text('Shape: Circle (Tap to Morph)');
    expect(morphButtonFinder, findsOneWidget);
    await tester.tap(morphButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('Shape: Squircle (Tap to Morph)'), findsOneWidget);

    // Scroll down to group avatar and custom shapes
    await tester.scrollUntilVisible(
      find.text('12. Group Avatar (Overlapping Stack)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('12. Group Avatar (Overlapping Stack)'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('13. Custom Shape Avatar Collection'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('13. Custom Shape Avatar Collection'), findsOneWidget);
    expect(find.text('Flower'), findsOneWidget);
    expect(find.text('Shield'), findsOneWidget);
    expect(find.text('Ticket'), findsOneWidget);
    expect(find.text('Star'), findsOneWidget);

    // Scroll to the visible Copy Code button and tap it
    final copyButton = find.text('Copy Code').last;
    await tester.scrollUntilVisible(
      copyButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(copyButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('AvatarShowcaseScreen category filters update visible cards',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AvatarShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap "Organic Shapes" filter
    await tester.tap(find.text('Organic Shapes'));
    await tester.pumpAndSettle();

    // Basic circle should not be in the list
    expect(find.text('01. Basic Circle Avatar'), findsNothing);
    // Organic items should be visible
    expect(find.text('03. Organic Avatar'), findsOneWidget);
    expect(find.text('04. Asymmetric Avatar'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('05. Blob Avatar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('05. Blob Avatar'), findsOneWidget);
  });
}
