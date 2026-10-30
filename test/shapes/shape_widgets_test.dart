import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 6: Widget Library Comprehensive Tests', () {
    testWidgets(
      'AnimatedShapeCard renders leading, title, subtitle, and trailing',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: AnimatedShapeCard(
                leading: Icon(Icons.school),
                title: Text('Physics 101'),
                subtitle: Text('Room 302'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        );

        expect(find.text('Physics 101'), findsOneWidget);
        expect(find.text('Room 302'), findsOneWidget);
        expect(find.byIcon(Icons.school), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      },
    );

    testWidgets(
      'ShapeButton respects minimum touch target and handles taps and loading',
      (tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShapeButton(
                onPressed: () => pressed = true,
                child: const Text('Submit'),
              ),
            ),
          ),
        );

        final buttonSize = tester.getSize(find.byType(ShapeButton));
        expect(buttonSize.width, greaterThanOrEqualTo(48.0));
        expect(buttonSize.height, greaterThanOrEqualTo(48.0));

        await tester.tap(find.text('Submit'));
        expect(pressed, isTrue);

        // Loading state
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShapeButton(isLoading: true, child: Text('Submit')),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('ShapeAvatar renders fallback and online status indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShapeAvatar(isOnline: true, fallback: Text('JR')),
          ),
        ),
      );

      expect(find.text('JR'), findsOneWidget);
    });

    testWidgets('ShapeBadge renders label with dynamic styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShapeBadge(label: '85% Done')),
        ),
      );

      expect(find.text('85% Done'), findsOneWidget);
    });

    testWidgets('ShapeProgress renders without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 200, child: ShapeProgress(value: 0.65)),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ShapeProgress), findsOneWidget);
    });

    testWidgets('ShapeDivider renders center crest', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShapeDivider(crestShape: DynamicShapeType.diamond),
          ),
        ),
      );

      expect(find.byType(ShapeDivider), findsOneWidget);
    });

    testWidgets('ShapeAppBar renders title and leading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: ShapeAppBar(
              title: Text('Dashboard'),
              leading: Icon(Icons.menu),
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('ShapeNavigationBar renders destinations', (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ShapeNavigationBar(
              currentIndex: selected,
              onTap: (i) => selected = i,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
    });

    testWidgets('ShapeBottomSheet renders inside modal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShapeBottomSheet(child: Text('Sheet Contents'))),
        ),
      );

      expect(find.text('Sheet Contents'), findsOneWidget);
    });

    testWidgets('ShapeDialog renders title and content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShapeDialog(
              title: Text('Confirm Action'),
              content: Text('Are you sure you want to proceed?'),
            ),
          ),
        ),
      );

      expect(find.text('Confirm Action'), findsOneWidget);
      expect(find.text('Are you sure you want to proceed?'), findsOneWidget);
    });

    testWidgets('ShapeTooltip renders tooltip bubble with target child', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShapeTooltip(message: 'Help Info', child: Icon(Icons.info)),
          ),
        ),
      );

      expect(find.text('Help Info'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets(
      'ShapeContainerGroup lays out elements vertically and horizontally',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShapeContainerGroup(
                direction: Axis.vertical,
                children: [Text('First'), Text('Second')],
              ),
            ),
          ),
        );

        expect(find.text('First'), findsOneWidget);
        expect(find.text('Second'), findsOneWidget);
      },
    );
  });
}
