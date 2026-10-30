import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'app_bar_behavior.dart';

/// Intelligent coordinator managing scroll direction, velocity, threshold hysteresis,
/// and smooth transitions between expanded, collapsed, floating, and hidden states.
class Material4AppBarCoordinator extends ChangeNotifier {
  final Material4AppBarBehavior behavior;
  final double expandedHeight;
  final double collapsedHeight;

  double _currentOffset = 0.0;
  double _accumulatedReverseDelta = 0.0;
  double _accumulatedForwardDelta = 0.0;
  int _lastMicroseconds = 0;
  bool _isFloatingRevealed = false;
  AppBarScrollState _state = AppBarScrollState.expanded;

  Material4AppBarCoordinator({
    required this.behavior,
    required this.expandedHeight,
    required this.collapsedHeight,
  });

  /// Current scroll offset in logical pixels.
  double get currentOffset => _currentOffset;

  /// Current high-level scroll state.
  AppBarScrollState get state => _state;

  /// Whether the floating compact header is revealed in response to reverse scrolling.
  bool get isFloatingRevealed => _isFloatingRevealed;

  /// Progress of collapse from 0.0 (fully expanded) to 1.0 (fully collapsed).
  double get collapseProgress {
    if (!behavior.collapseOnScroll) return 0.0;
    final maxDistance = expandedHeight - collapsedHeight;
    if (maxDistance <= 0) return 0.0;
    return (_currentOffset / maxDistance).clamp(0.0, 1.0);
  }

  /// Whether the header is currently fully collapsed.
  bool get isCollapsed => collapseProgress >= 1.0;

  /// Whether the header is currently near the top (expanded).
  bool get isAtTop => _currentOffset <= 8.0;

  /// Handles incoming [ScrollNotification] events from the enclosing scrollable.
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final double delta = notification.scrollDelta ?? 0.0;
      final now = DateTime.now().microsecondsSinceEpoch;
      final dt =
          _lastMicroseconds > 0 ? (now - _lastMicroseconds) / 1000000.0 : 0.016;
      _lastMicroseconds = now;
      final double velocity = dt > 0.0 ? (delta / dt) : 0.0;

      _updateScroll(
        offset: notification.metrics.pixels,
        delta: delta,
        velocity: velocity,
      );
    } else if (notification is ScrollEndNotification) {
      _lastMicroseconds = 0;
      _handleScrollEnd();
    }
    return false; // Allow notification to bubble up to parent listeners
  }

  /// Updates scroll state based on raw offset, delta, and velocity.
  void _updateScroll({
    required double offset,
    required double delta,
    required double velocity,
  }) {
    _currentOffset = math.max(0.0, offset);

    final bool isScrollingDown = delta > 0.0;
    final bool isScrollingUp = delta < 0.0;

    if (isAtTop) {
      if (_state != AppBarScrollState.expanded) {
        _state = AppBarScrollState.expanded;
        _isFloatingRevealed = false;
        _accumulatedReverseDelta = 0.0;
        _accumulatedForwardDelta = 0.0;
        notifyListeners();
      }
      return;
    }

    if (isScrollingDown) {
      _accumulatedReverseDelta = 0.0;
      _accumulatedForwardDelta += delta;

      if (_isFloatingRevealed) {
        // Hide floating bar if user scrolls forward past threshold
        if (_accumulatedForwardDelta > behavior.reverseScrollThreshold) {
          _isFloatingRevealed = false;
          _state = isCollapsed
              ? (behavior.hideOnScrollDown
                  ? AppBarScrollState.hidden
                  : AppBarScrollState.collapsed)
              : AppBarScrollState.collapsing;
          notifyListeners();
        }
      } else {
        final newState = isCollapsed
            ? (behavior.hideOnScrollDown
                ? AppBarScrollState.hidden
                : AppBarScrollState.collapsed)
            : AppBarScrollState.collapsing;

        if (newState != _state) {
          _state = newState;
          notifyListeners();
        } else {
          // Progress changed, notify to update continuous interpolation
          notifyListeners();
        }
      }
    } else if (isScrollingUp) {
      _accumulatedForwardDelta = 0.0;
      _accumulatedReverseDelta += -delta;

      final bool velocityTrigger =
          velocity.abs() >= behavior.fastScrollVelocityThreshold;
      final bool distanceTrigger =
          _accumulatedReverseDelta >= behavior.reverseScrollThreshold;

      if (behavior.floatingOnReverseScroll &&
          isCollapsed &&
          (distanceTrigger || velocityTrigger)) {
        if (!_isFloatingRevealed) {
          _isFloatingRevealed = true;
          _state = AppBarScrollState.floating;
          notifyListeners();
        }
      } else if (!isCollapsed) {
        _state = AppBarScrollState.collapsing;
        notifyListeners();
      }
    }
  }

  void _handleScrollEnd() {
    if (isAtTop && _state != AppBarScrollState.expanded) {
      _state = AppBarScrollState.expanded;
      _isFloatingRevealed = false;
      notifyListeners();
    }
  }

  /// Manually force state for testing or external triggers.
  void forceState({
    required double offset,
    required bool isFloatingRevealed,
  }) {
    _currentOffset = offset;
    _isFloatingRevealed = isFloatingRevealed;
    _state = isAtTop
        ? AppBarScrollState.expanded
        : (_isFloatingRevealed
            ? AppBarScrollState.floating
            : (isCollapsed
                ? AppBarScrollState.collapsed
                : AppBarScrollState.collapsing));
    notifyListeners();
  }
}
