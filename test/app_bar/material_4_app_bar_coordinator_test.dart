import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4AppBarCoordinator Unit Tests', () {
    test('Initializes in expanded state at offset 0', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.floatingOnReverse,
        expandedHeight: 220.0,
        collapsedHeight: 64.0,
      );

      expect(coordinator.state, equals(AppBarScrollState.expanded));
      expect(coordinator.currentOffset, equals(0.0));
      expect(coordinator.collapseProgress, equals(0.0));
      expect(coordinator.isCollapsed, isFalse);
      expect(coordinator.isFloatingRevealed, isFalse);
    });

    test('Computes proportional collapse progress during scroll', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.floatingOnReverse,
        expandedHeight: 200.0,
        collapsedHeight: 50.0,
      );

      // Total collapsible distance = 200 - 50 = 150
      coordinator.forceState(offset: 75.0, isFloatingRevealed: false);
      expect(coordinator.collapseProgress, closeTo(0.5, 0.001));
      expect(coordinator.isCollapsed, isFalse);
      expect(coordinator.state, equals(AppBarScrollState.collapsing));

      coordinator.forceState(offset: 150.0, isFloatingRevealed: false);
      expect(coordinator.collapseProgress, equals(1.0));
      expect(coordinator.isCollapsed, isTrue);
      expect(coordinator.state, equals(AppBarScrollState.collapsed));

      // Clamps past 150
      coordinator.forceState(offset: 300.0, isFloatingRevealed: false);
      expect(coordinator.collapseProgress, equals(1.0));
    });

    test('Floating state activates on reverse scroll when collapsed', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.floatingOnReverse,
        expandedHeight: 200.0,
        collapsedHeight: 60.0,
      );

      coordinator.forceState(offset: 300.0, isFloatingRevealed: true);
      expect(coordinator.isFloatingRevealed, isTrue);
      expect(coordinator.state, equals(AppBarScrollState.floating));
    });

    test('Returns to expanded state at top', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.floatingOnReverse,
        expandedHeight: 200.0,
        collapsedHeight: 60.0,
      );

      coordinator.forceState(offset: 300.0, isFloatingRevealed: true);
      expect(coordinator.state, equals(AppBarScrollState.floating));

      coordinator.forceState(offset: 0.0, isFloatingRevealed: false);
      expect(coordinator.isAtTop, isTrue);
      expect(coordinator.state, equals(AppBarScrollState.expanded));
      expect(coordinator.collapseProgress, equals(0.0));
    });

    test('Hiding behavior sets state to hidden when hideOnScrollDown is true',
        () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.hideAndFloat,
        expandedHeight: 180.0,
        collapsedHeight: 60.0,
      );

      coordinator.forceState(offset: 250.0, isFloatingRevealed: false);
      expect(coordinator.state, equals(AppBarScrollState.hidden));
    });

    test('Notifies listeners when state updates', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.floatingOnReverse,
        expandedHeight: 200.0,
        collapsedHeight: 60.0,
      );

      int notifyCount = 0;
      coordinator.addListener(() {
        notifyCount++;
      });

      coordinator.forceState(offset: 50.0, isFloatingRevealed: false);
      coordinator.forceState(offset: 140.0, isFloatingRevealed: false);
      coordinator.forceState(offset: 140.0, isFloatingRevealed: true);

      expect(notifyCount, equals(3));
    });

    test('Verifies all 8 states in the scroll lifecycle machine', () {
      final coordinator = Material4AppBarCoordinator(
        behavior: Material4AppBarBehavior.hideAndFloat,
        expandedHeight: 200.0,
        collapsedHeight: 60.0,
      );

      final allStates = <AppBarScrollState>[
        AppBarScrollState.expanded,
        AppBarScrollState.expanding,
        AppBarScrollState.collapsing,
        AppBarScrollState.collapsed,
        AppBarScrollState.floating,
        AppBarScrollState.revealing,
        AppBarScrollState.hiding,
        AppBarScrollState.hidden,
      ];

      for (final state in allStates) {
        coordinator.forceState(
          offset: 100.0,
          isFloatingRevealed: false,
          explicitState: state,
        );
        expect(coordinator.state, equals(state));
      }
    });

    test('Respects collapseResistance factor', () {
      final coordinatorNormal = Material4AppBarCoordinator(
        behavior: const Material4AppBarBehavior(collapseResistance: 1.0),
        expandedHeight: 200.0,
        collapsedHeight: 100.0,
      );

      final coordinatorResistant = Material4AppBarCoordinator(
        behavior: const Material4AppBarBehavior(collapseResistance: 2.0),
        expandedHeight: 200.0,
        collapsedHeight: 100.0,
      );

      coordinatorNormal.forceState(offset: 50.0, isFloatingRevealed: false);
      coordinatorResistant.forceState(offset: 50.0, isFloatingRevealed: false);

      expect(coordinatorNormal.collapseProgress, equals(0.5));
      expect(coordinatorResistant.collapseProgress, equals(0.25));
    });

    testWidgets('Rejects micro-jitter within velocityHysteresis threshold',
        (tester) async {
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox.shrink(),
      ));
      final context = tester.element(find.byType(SizedBox));

      final coordinator = Material4AppBarCoordinator(
        behavior: const Material4AppBarBehavior(
          velocityHysteresis: 20.0,
          reverseScrollThreshold: 15.0,
        ),
        expandedHeight: 200.0,
        collapsedHeight: 60.0,
      );

      final metrics = FixedScrollMetrics(
        minScrollExtent: 0.0,
        maxScrollExtent: 1000.0,
        pixels: 200.0,
        viewportDimension: 600.0,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1.0,
      );

      // Micro-jitter scroll of 0.1 px
      final notification = ScrollUpdateNotification(
        metrics: metrics,
        scrollDelta: -0.1,
        context: context,
      );

      coordinator.handleScrollNotification(notification);
      // State should not prematurely flip to revealing or floating
      expect(coordinator.isFloatingRevealed, isFalse);
    });

    test(
        'Verifies all 9 animation presets and flags in Material4AppBarAnimation',
        () {
      for (final preset in Material4AnimationPreset.values) {
        final anim = Material4AppBarAnimation.fromPreset(preset);
        expect(anim.preset, equals(preset));
        expect(anim.duration, isNotNull);
        expect(anim.curve, isNotNull);
        expect(anim.reverseCurve, isNotNull);
        expect(anim.interruptible, isTrue);
      }

      expect(Material4AppBarAnimation.snappy.preset,
          equals(Material4AnimationPreset.snappy));
      expect(Material4AppBarAnimation.gentle.preset,
          equals(Material4AnimationPreset.gentle));
      expect(Material4AppBarAnimation.instantaneous.duration,
          equals(Duration.zero));
    });

    test('Material4AppBarTimeline orchestrates collision-free progress', () {
      const anim = Material4AppBarAnimation();

      final timelineExpanded = Material4AppBarTimeline(
        collapseRatio: 0.0,
        floatingProgress: 0.0,
        animation: anim,
      );
      expect(timelineExpanded.expandedOpacity, equals(1.0));
      expect(timelineExpanded.subtitleOpacity, equals(1.0));
      expect(timelineExpanded.compactBarOpacity, equals(0.0));

      final timelineMid = Material4AppBarTimeline(
        collapseRatio: 0.5,
        floatingProgress: 0.0,
        animation: anim,
      );
      // Subtitle disappears early (by 0.38)
      expect(timelineMid.subtitleOpacity, equals(0.0));
      expect(timelineMid.expandedOpacity, inInclusiveRange(0.0, 0.5));

      final timelineCollapsed = Material4AppBarTimeline(
        collapseRatio: 1.0,
        floatingProgress: 0.0,
        animation: anim,
      );
      expect(timelineCollapsed.expandedOpacity, equals(0.0));
      expect(timelineCollapsed.compactBarOpacity, equals(1.0));

      // Floating reveal
      final timelineFloating = Material4AppBarTimeline(
        collapseRatio: 1.0,
        floatingProgress: 0.8,
        animation: anim,
      );
      expect(timelineFloating.compactBarOpacity, equals(0.8));
      expect(timelineFloating.compactProfileScale, greaterThan(0.85));
    });
  });
}
