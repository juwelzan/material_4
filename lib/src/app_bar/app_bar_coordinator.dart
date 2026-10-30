import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'app_bar_behavior.dart';

/// Intelligent coordinator managing scroll physics, momentum smoothing, velocity
/// hysteresis, and the 8-state scroll lifecycle for Material 4 AppBars.
///
/// States: `expanded`, `expanding`, `collapsing`, `collapsed`, `floating`,
/// `revealing`, `hiding`, and `hidden`.
class Material4AppBarCoordinator extends ChangeNotifier {
  /// Scroll behavioral parameters and physics tuning.
  final Material4AppBarBehavior behavior;

  /// Expanded height of the app bar in logical pixels.
  final double expandedHeight;

  /// Collapsed / compact height in logical pixels.
  final double collapsedHeight;

  double _currentOffset = 0.0;
  double _accumulatedReverseDelta = 0.0;
  double _accumulatedForwardDelta = 0.0;
  int _lastMicroseconds = 0;
  double _smoothedVelocity = 0.0;
  bool _isFloatingRevealed = false;
  AppBarScrollState _state = AppBarScrollState.expanded;

  /// Creates a [Material4AppBarCoordinator] instance.
  Material4AppBarCoordinator({
    required this.behavior,
    required this.expandedHeight,
    required this.collapsedHeight,
  });

  /// Current scroll offset in logical pixels.
  double get currentOffset => _currentOffset;

  /// Current smoothed scroll velocity in logical pixels per second.
  double get smoothedVelocity => _smoothedVelocity;

  /// Current high-level scroll state in the 8-state machine.
  AppBarScrollState get state => _state;

  /// Whether the floating compact header is revealed in response to reverse scrolling.
  bool get isFloatingRevealed => _isFloatingRevealed;

  /// Total collapsible distance in logical pixels.
  double get maxCollapsibleDistance =>
      math.max(0.0, expandedHeight - collapsedHeight);

  /// Progress of collapse from 0.0 (fully expanded) to 1.0 (fully collapsed).
  double get collapseProgress {
    if (!behavior.collapseOnScroll) return 0.0;
    final maxDistance = maxCollapsibleDistance;
    if (maxDistance <= 0) return 0.0;

    final double effectiveOffset = behavior.collapseResistance != 1.0
        ? _currentOffset / math.max(0.1, behavior.collapseResistance)
        : _currentOffset;

    return (effectiveOffset / maxDistance).clamp(0.0, 1.0);
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

      final double rawVelocity = dt > 0.0 ? (delta / dt) : 0.0;

      // Exponential moving average for velocity smoothing & momentum
      final double damping = behavior.momentumDamping.clamp(0.0, 0.99);
      _smoothedVelocity =
          (_smoothedVelocity * damping) + (rawVelocity * (1.0 - damping));

      _updateScroll(
        offset: notification.metrics.pixels,
        delta: delta,
        velocity: _smoothedVelocity,
      );
    } else if (notification is ScrollEndNotification) {
      _lastMicroseconds = 0;
      _smoothedVelocity = 0.0;
      _handleScrollEnd();
    }
    return false; // Allow notification to bubble up
  }

  /// Updates scroll state based on raw offset, delta, and smoothed velocity.
  void _updateScroll({
    required double offset,
    required double delta,
    required double velocity,
  }) {
    _currentOffset = math.max(0.0, offset);

    // Apply velocity hysteresis to reject micro-jitter
    final bool hasSignificantDelta = delta.abs() > 0.2;
    final bool isScrollingDown = delta > 0.0 &&
        (delta.abs() >= 0.5 || velocity.abs() >= behavior.velocityHysteresis);
    final bool isScrollingUp = delta < 0.0 &&
        (delta.abs() >= 0.5 || velocity.abs() >= behavior.velocityHysteresis);

    // 1. Boundary check: Near top of scroll view
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

    // 2. Downward scroll (scrolling content upwards)
    if (isScrollingDown) {
      _accumulatedReverseDelta = 0.0;
      _accumulatedForwardDelta += delta;

      if (_isFloatingRevealed) {
        // Hide floating bar if user scrolls forward past threshold
        if (_accumulatedForwardDelta > behavior.reverseScrollThreshold) {
          _isFloatingRevealed = false;
          _state = AppBarScrollState.hiding;
          notifyListeners();
        }
      } else {
        if (!isCollapsed) {
          _state = AppBarScrollState.collapsing;
          notifyListeners();
        } else {
          final newState = behavior.hideOnScrollDown
              ? AppBarScrollState.hidden
              : AppBarScrollState.collapsed;
          if (newState != _state) {
            _state = newState;
            notifyListeners();
          } else {
            notifyListeners();
          }
        }
      }
    }
    // 3. Upward scroll (reverse scrolling towards top)
    else if (isScrollingUp) {
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
          _state = AppBarScrollState.revealing;
          notifyListeners();
        } else {
          if (_state != AppBarScrollState.floating) {
            _state = AppBarScrollState.floating;
            notifyListeners();
          }
        }
      } else if (!isCollapsed) {
        _state = AppBarScrollState.expanding;
        notifyListeners();
      }
    } else if (hasSignificantDelta) {
      notifyListeners();
    }
  }

  void _handleScrollEnd() {
    if (isAtTop) {
      if (_state != AppBarScrollState.expanded) {
        _state = AppBarScrollState.expanded;
        _isFloatingRevealed = false;
        notifyListeners();
      }
    } else if (_state == AppBarScrollState.revealing) {
      _state = AppBarScrollState.floating;
      notifyListeners();
    } else if (_state == AppBarScrollState.hiding) {
      _state = behavior.hideOnScrollDown
          ? AppBarScrollState.hidden
          : AppBarScrollState.collapsed;
      notifyListeners();
    }
  }

  /// Manually force state for testing or external programmatic control.
  void forceState({
    required double offset,
    required bool isFloatingRevealed,
    AppBarScrollState? explicitState,
  }) {
    _currentOffset = math.max(0.0, offset);
    _isFloatingRevealed = isFloatingRevealed;

    if (explicitState != null) {
      _state = explicitState;
    } else if (isAtTop) {
      _state = AppBarScrollState.expanded;
    } else if (_isFloatingRevealed) {
      _state = AppBarScrollState.floating;
    } else if (isCollapsed) {
      _state = behavior.hideOnScrollDown
          ? AppBarScrollState.hidden
          : AppBarScrollState.collapsed;
    } else {
      _state = AppBarScrollState.collapsing;
    }
    notifyListeners();
  }
}
