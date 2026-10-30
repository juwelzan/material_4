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
      expect(coordinator.state, equals(AppBarScrollState.collapsed));
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
  });
}
