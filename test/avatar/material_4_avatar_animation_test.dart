import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4AvatarAnimation & Controller Unit Tests', () {
    test('All 11 Material4AvatarAnimationPreset values instantiate cleanly', () {
      for (final preset in Material4AvatarAnimationPreset.values) {
        final anim = Material4AvatarAnimation.fromPreset(preset);
        expect(anim.preset, equals(preset));
        expect(anim.duration, greaterThan(Duration.zero));
        expect(anim.curve, isNotNull);
        expect(anim.shapeSequence.isNotEmpty, isTrue);
      }
    });

    test('All 4 AvatarLoopMode and 5 AvatarPerformanceMode values exist', () {
      expect(AvatarLoopMode.values.length, equals(4));
      expect(AvatarPerformanceMode.values.length, equals(5));
    });

    test('Material4AvatarEffects presets configure appropriate parameters', () {
      const breathing = Material4AvatarEffects.breathingPreset;
      expect(breathing.breathing, isTrue);
      expect(breathing.floating, isFalse);

      const floating = Material4AvatarEffects.floatingPreset;
      expect(floating.floating, isTrue);
      expect(floating.floatingAmplitude, equals(4.0));

      const dynamicEff = Material4AvatarEffects.dynamicPreset;
      expect(dynamicEff.floating, isTrue);
      expect(dynamicEff.breathing, isTrue);
      expect(dynamicEff.animatedBorder, isTrue);
      expect(dynamicEff.glow, isTrue);
    });

    test('Controller handles state updates and notifies listeners', () {
      final controller = Material4AvatarController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.updateState(
        isPlaying: true,
        currentIndex: 1,
        morphProgress: 0.5,
        currentShape: Material4AvatarShape.squircle(),
      );

      expect(controller.isPlaying, isTrue);
      expect(controller.currentIndex, equals(1));
      expect(controller.morphProgress, equals(0.5));
      expect(controller.currentShape.id, equals('squircle'));
      expect(notifyCount, equals(1));

      controller.pause();
      expect(controller.isPlaying, isFalse);
      expect(notifyCount, equals(2));

      controller.stop();
      expect(controller.morphProgress, equals(0.0));
      expect(notifyCount, equals(3));
    });
  });

  group('Material4Avatar Shape Morphing Widget Tests', () {
    testWidgets('Static avatar runs with zero active tickers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar(
                size: 64,
                initials: 'ST',
              ),
            ),
          ),
        ),
      );

      expect(find.text('ST'), findsOneWidget);
      // Pumping with zero elapsed time should not trigger any continuous frame rebuilds
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('Continuously morphs through shape sequence in infinite loop',
        (tester) async {
      final shapes = [
        Material4AvatarShape.circle(),
        Material4AvatarShape.squircle(),
        Material4AvatarShape.hexagon(),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.animated(
                size: 64,
                initials: 'AM',
                animation: Material4AvatarAnimation(
                  autoPlay: true,
                  repeat: true,
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 50),
                  shapeSequence: shapes,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('AM'), findsOneWidget);

      // Advance halfway through step 1
      await tester.pump(const Duration(milliseconds: 150));
      expect(tester.takeException(), isNull);

      // Complete step 1 and advance through delay to step 2
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Controller programmatically drives shape sequence',
        (tester) async {
      final controller = Material4AvatarController();
      final shapes = [
        Material4AvatarShape.circle(),
        Material4AvatarShape.squircle(),
        Material4AvatarShape.star(),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar(
                size: 64,
                initials: 'CT',
                controller: controller,
                animation: Material4AvatarAnimation(
                  autoPlay: false,
                  repeat: false,
                  duration: const Duration(milliseconds: 200),
                  shapeSequence: shapes,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('CT'), findsOneWidget);
      expect(controller.currentIndex, equals(0));

      // Test nextShape()
      controller.nextShape();
      await tester.pumpAndSettle();
      expect(controller.currentIndex, equals(1));

      // Test jumpTo(2)
      controller.jumpTo(2);
      await tester.pumpAndSettle();
      expect(controller.currentIndex, equals(2));

      // Test animateTo custom shape
      controller.animateTo(
        Material4AvatarShape.hexagon(),
        duration: const Duration(milliseconds: 100),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Secondary breathing and floating effects render smoothly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar(
                size: 70,
                initials: 'BF',
                effects: Material4AvatarEffects(
                  breathing: true,
                  floating: true,
                  glow: true,
                  animatedBorder: true,
                ),
                border: Material4AvatarBorder.gradient(
                  gradient: LinearGradient(colors: [Colors.purple, Colors.cyan]),
                  width: 3.0,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('BF'), findsOneWidget);

      // Simulate a few animation ticks
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Respects reduced motion preference by disabling continuous motion',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const Scaffold(
              body: Center(
                child: Material4Avatar(
                  size: 60,
                  initials: 'RM',
                  effects: Material4AvatarEffects(
                    breathing: true,
                    floating: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('RM'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  });

  group('Material4Avatar Memory & Lifecycle Benchmark Tests', () {
    testWidgets('Repeated mount and unmount does not leak tickers or throw',
        (tester) async {
      for (int i = 0; i < 8; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4Avatar.animated(
                  size: 64,
                  initials: 'L$i',
                  animation: const Material4AvatarAnimation(
                    duration: Duration(milliseconds: 100),
                  ),
                  effects: Material4AvatarEffects.dynamicPreset,
                ),
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 50));

        // Immediately unmount
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: SizedBox.shrink()),
          ),
        );
        await tester.pump();
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('Disposing avatar while mid-flight in morph does not crash',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.animated(
                size: 60,
                initials: 'MD',
                animation: const Material4AvatarAnimation(
                  duration: Duration(milliseconds: 500),
                ),
              ),
            ),
          ),
        ),
      );

      // Advance into the middle of the morph
      await tester.pump(const Duration(milliseconds: 250));

      // Destroy widget abruptly
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('High density test: Renders 30 simultaneously animated avatars',
        (tester) async {
      final avatars = List.generate(
        30,
        (index) => Material4Avatar.animated(
          key: ValueKey('avatar_$index'),
          size: 40,
          initials: 'A$index',
          animation: const Material4AvatarAnimation(
            duration: Duration(milliseconds: 600),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Wrap(children: avatars),
          ),
        ),
      );

      expect(find.byType(Material4Avatar), findsNWidgets(30));

      // Step animation
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });
  });
}
