import 'package:flutter/widgets.dart';

/// Watches the scrollables enclosing a touched glass element so the element
/// can behave like a UIKit control inside a scroll view: its press is
/// delayed briefly (`delaysContentTouches`), and once the finger starts
/// scrolling the content the press is released instead of following the
/// scroll.
class TouchScrollGuard {
  final List<ScrollPosition> _positions = [];
  final List<double> _start = [];

  /// Whether the element sits inside at least one scrollable.
  bool get insideScrollable => _positions.isNotEmpty;

  /// Records every enclosing scroll position at pointer-down.
  void begin(BuildContext context) {
    end();
    BuildContext? current = context;
    while (current != null) {
      final scrollable = Scrollable.maybeOf(current);
      if (scrollable == null) break;
      final position = scrollable.position;
      _positions.add(position);
      _start.add(position.hasPixels ? position.pixels : 0.0);
      current = scrollable.context;
    }
  }

  /// True once any enclosing scrollable has moved since [begin].
  bool get scrolled {
    for (int i = 0; i < _positions.length; i++) {
      final p = _positions[i];
      if (!p.hasPixels) continue;
      if ((p.pixels - _start[i]).abs() > 0.5 || p.isScrollingNotifier.value) {
        return true;
      }
    }
    return false;
  }

  /// Forgets the recorded positions.
  void end() {
    _positions.clear();
    _start.clear();
  }
}
