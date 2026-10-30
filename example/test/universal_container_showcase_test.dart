import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/container/universal_container_showcase_screen.dart';

void main() {
  testWidgets('UniversalContainerShowcaseScreen renders all 6 tabs and switches cleanly', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: UniversalContainerShowcaseScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Universal Container System'), findsOneWidget);
    expect(find.text('1. Shapes Gallery'), findsOneWidget);
    expect(find.text('2. Morphing Studio'), findsOneWidget);
    expect(find.text('3. Procedural Textures'), findsOneWidget);
    expect(find.text('4. Patterns Engine'), findsOneWidget);
    expect(find.text('5. Animated Borders'), findsOneWidget);
    expect(find.text('6. Presets & Playground'), findsOneWidget);

    // Switch to Morphing Studio
    await tester.tap(find.text('2. Morphing Studio'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Topological Vector Shape Morphing'), findsOneWidget);

    // Switch to Procedural Textures
    await tester.tap(find.text('3. Procedural Textures'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Procedural GPU Textures'), findsOneWidget);

    // Switch to Patterns Engine
    await tester.tap(find.text('4. Patterns Engine'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Procedural Background Patterns'), findsOneWidget);

    // Switch to Animated Borders
    await tester.tap(find.text('5. Animated Borders'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Animated Vector Borders'), findsOneWidget);

    // Switch to Presets & Playground
    await tester.tap(find.text('6. Presets & Playground'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Presets & Interactive Studio'), findsOneWidget);
  });
}
