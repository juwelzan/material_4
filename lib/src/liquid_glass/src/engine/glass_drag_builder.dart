// Copyright 2024-2025 Tim Lehmann for whynotmake.it
//
// SPDX-License-Identifier: MIT
//
// Originally from liquid_glass_renderer (whynotmake.it).
// Maintained and evolved in-tree for liquid_glass_widgets.
// See lib/src/engine/ATTRIBUTION.md for provenance and modification history.

// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'dart:async';

import '../../types/interaction_notification.dart';
import 'touch_scroll_guard.dart';

class GlassDragBuilder extends StatefulWidget {
  const GlassDragBuilder({
    required this.builder,
    this.behavior = HitTestBehavior.opaque,
    this.suppressInteractionOnChildren = true,
    this.releaseOnScroll = false,
    this.scrollPressDelay,
    this.touchExitDistance,
    this.onPressedChanged,
    this.child,
    super.key,
  });

  /// Release the press (as if the finger lifted) once the finger starts
  /// scrolling an enclosing scrollable, like a UIKit control does. The rest
  /// of that touch is ignored.
  final bool releaseOnScroll;

  /// Inside a scrollable, wait this long before showing the press, so a
  /// touch that turns into a scroll never flashes the element
  /// (`UIScrollView.delaysContentTouches`). A quick tap still shows a short
  /// press. `null` presses immediately.
  final Duration? scrollPressDelay;

  /// While the finger is further than this outside the element's bounds the
  /// press is released, and it returns when the finger comes back — UIKit's
  /// touch-drag exit / enter (about 70 pt). `null` never releases.
  final double? touchExitDistance;

  /// Called when the visible pressed state changes.
  final ValueChanged<bool>? onPressedChanged;

  final HitTestBehavior behavior;
  final bool suppressInteractionOnChildren;
  final ValueWidgetBuilder<Offset?> builder;
  final Widget? child;

  @override
  State<GlassDragBuilder> createState() => _GlassDragBuilderState();
}

class _GlassDragBuilderState extends State<GlassDragBuilder> {
  // ─── Touch-noise & drag architecture ──────────────────────────────────────
  //
  // 1. LATCHED DEADBAND (_kTouchSlopPx)
  //    Capacitive digitizers emit small sub-pixel deltas (~0.3–1.5 px) even
  //    when a finger is held stationary. While within the 3.0 px threshold,
  //    we accumulate deltas silently without calling setState. This guarantees
  //    ZERO rebuilds and ZERO matrix recalibration during a hold press,
  //    eliminating all raster crawl on crisp hairline borders (_VibrancyFill).
  //
  // 2. CONTINUOUS SLOP SUBTRACTION (C⁰ Position Continuity)
  //    Once |_rawOffset| >= _kTouchSlopPx, the drag state is latched
  //    (_dragEngaged = true). Rather than jumping by 3.0 px (which would impart
  //    an impulse kick into the spring simulation), the exposed offset is
  //    slop-subtracted along the drag vector:
  //
  //      exposed = raw * (1.0 - slop / dist)
  //
  //    At the engagement threshold (dist == slop), exposed == Offset.zero.
  //    The drag begins with zero jump and zero velocity discontinuity.
  //
  // 3. ZERO QUANTIZATION (No Stairstep Stutter)
  //    We do NOT drop or quantize movement updates to coarse steps (e.g. 0.5px).
  //    Discrete quantization injects high-frequency noise that excites the
  //    spring's resonance frequency. Instead, continuous deltas are fed
  //    directly to the spring controller, allowing Flutter's physics engine to
  //    act as a natural 2nd-order analog low-pass filter at full display refresh.

  static const double _kTouchSlopPx = 3.0;

  // Cumulative raw offset since pointer down. Null when no pointer is down.
  Offset? _rawOffset;

  // Latched flag indicating whether the deadband has been broken.
  bool _dragEngaged = false;

  // Last offset exposed to widget.builder via setState.
  Offset? _lastExposedOffset;

  bool _shouldIgnoreCurrentPointer = false;

  final TouchScrollGuard _scrollGuard = TouchScrollGuard();
  Timer? _pressDelay;
  Timer? _flashRelease;
  // The press is hidden while delayed in a scroll view, after the touch
  // became a scroll, or while the finger is outside the exit distance.
  bool _pressShown = true;
  bool _cancelled = false;
  bool _outside = false;
  bool _reportedPressed = false;

  void _report() {
    final pressed =
        _rawOffset != null && _pressShown && !_cancelled && !_outside;
    if (pressed == _reportedPressed) return;
    _reportedPressed = pressed;
    widget.onPressedChanged?.call(pressed);
  }

  void _release() {
    _pressDelay?.cancel();
    _pressDelay = null;
    _shouldIgnoreCurrentPointer = false;
    _scrollGuard.end();
    if (!mounted) return;
    setState(() {
      _dragEngaged = false;
      _rawOffset = null;
      _lastExposedOffset = null;
      _cancelled = false;
      _outside = false;
      _pressShown = true;
    });
    _report();
  }

  @override
  void dispose() {
    _pressDelay?.cancel();
    _flashRelease?.cancel();
    super.dispose();
  }

  bool get isDragging => _rawOffset != null;

  /// Computes the exposed offset with continuous slop subtraction.
  ///
  /// Returns:
  /// - `null`: Pointer is up/cancelled (spring settles to rest).
  /// - `Offset.zero`: Pointer is down but deadband has not been broken.
  /// - `raw * (1 - slop / dist)`: Continuous tracking once engaged.
  Offset? get _exposedOffset {
    final raw = _rawOffset;
    if (raw == null || !_pressShown || _cancelled || _outside) return null;
    if (!_dragEngaged) return Offset.zero;

    final dist = raw.distance;
    if (dist <= _kTouchSlopPx) {
      return Offset.zero;
    }
    final factor = 1.0 - (_kTouchSlopPx / dist);
    return raw * factor;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<InteractionNotification>(
      onNotification: (notification) {
        if (widget.suppressInteractionOnChildren) {
          _shouldIgnoreCurrentPointer = true;
        }
        return false; // Let it bubble
      },
      child: Listener(
        behavior: widget.behavior,
        onPointerDown: (event) {
          if (widget.suppressInteractionOnChildren &&
              _shouldIgnoreCurrentPointer) {
            _shouldIgnoreCurrentPointer = false;
            return;
          }
          if (!mounted) return;
          _flashRelease?.cancel();
          _pressDelay?.cancel();
          if (widget.releaseOnScroll || widget.scrollPressDelay != null) {
            _scrollGuard.begin(context);
          }
          final delay =
              _scrollGuard.insideScrollable ? widget.scrollPressDelay : null;
          setState(() {
            _dragEngaged = false;
            _rawOffset = Offset.zero;
            _lastExposedOffset = Offset.zero;
            _cancelled = false;
            _outside = false;
            _pressShown = delay == null;
          });
          if (delay != null) {
            _pressDelay = Timer(delay, () {
              _pressDelay = null;
              if (!mounted || _rawOffset == null || _cancelled) return;
              setState(() => _pressShown = true);
              _report();
            });
          }
          _report();
        },
        onPointerMove: (event) {
          if (_rawOffset == null || _cancelled) return;
          if (!mounted) return;
          if (widget.releaseOnScroll && _scrollGuard.scrolled) {
            // The touch became a scroll: let go, like a UIKit control.
            _pressDelay?.cancel();
            _pressDelay = null;
            setState(() {
              _cancelled = true;
              _lastExposedOffset = null;
            });
            _report();
            return;
          }
          final exit = widget.touchExitDistance;
          final box = context.findRenderObject();
          if (exit != null && box is RenderBox && box.hasSize) {
            final outside = !(Offset.zero & box.size)
                .inflate(exit)
                .contains(event.localPosition);
            if (outside != _outside) {
              setState(() {
                _outside = outside;
                _lastExposedOffset = _exposedOffset;
              });
              _report();
            }
          }
          final newRaw = _rawOffset! + event.delta;
          _rawOffset = newRaw;

          if (!_dragEngaged) {
            if (newRaw.distanceSquared >= _kTouchSlopPx * _kTouchSlopPx) {
              _dragEngaged = true;
            } else {
              // Within deadband: exposed value remains Offset.zero.
              // Bypass setState to avoid any redundant rebuilds or raster crawl.
              return;
            }
          }

          final exposed = _exposedOffset;
          if (exposed == _lastExposedOffset) return;

          setState(() {
            _lastExposedOffset = exposed;
          });
        },
        onPointerUp: (event) {
          if (_pressDelay != null && !_cancelled && _rawOffset != null) {
            // A quick tap inside a scroll view, lifted before the delayed
            // press appeared: still show a short press, then release.
            _pressDelay!.cancel();
            _pressDelay = null;
            setState(() => _pressShown = true);
            _report();
            _flashRelease = Timer(const Duration(milliseconds: 90), _release);
            return;
          }
          _release();
        },
        onPointerCancel: (event) => _release(),
        child: widget.builder(context, _exposedOffset, widget.child),
      ),
    );
  }
}
