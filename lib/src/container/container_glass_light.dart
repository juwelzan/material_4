import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A shared light source for every liquid-glass [Material4Container] below
/// it, so all glass on screen is lit consistently, as on iOS 26 where the
/// specular highlights move together when the device tilts.
///
/// Three ways to drive it (combine freely; a pointer wins while present):
///
/// * [angle] — a fixed or animated light direction in radians
///   (`0` = from the right, `pi / 2` = from the top).
/// * [angleStream] — e.g. device motion from `sensors_plus`:
///   `gyroscopeEventStream().map((e) => math.pi / 2 + e.y * 0.6)`.
/// * [followPointer] — one light sitting at the mouse / trackpad pointer;
///   every glass turns its highlight toward it from its own position, so
///   glass left of the cursor is lit from the right and vice versa.
///
/// ```dart
/// Material4GlassLight(
///   followPointer: true,
///   child: Scaffold(...),
/// )
/// ```
class Material4GlassLight extends StatefulWidget {
  /// Fixed or animated light direction in radians.
  final ValueListenable<double>? angle;

  /// Stream of light directions in radians (device motion, animation…).
  final Stream<double>? angleStream;

  /// Place the light at the hovering pointer.
  final bool followPointer;

  /// How far glass turns toward this light, 0–1. Lower keeps more of each
  /// material's own light angle.
  final double strength;

  final Widget child;

  const Material4GlassLight({
    super.key,
    this.angle,
    this.angleStream,
    this.followPointer = false,
    this.strength = 1.0,
    required this.child,
  });

  /// The nearest light source, or null when there is none.
  static Material4GlassLightSource? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_Material4GlassLightScope>()
      ?.source;

  @override
  State<Material4GlassLight> createState() => _Material4GlassLightState();
}

/// The live state of a [Material4GlassLight]; listen to it for changes.
class Material4GlassLightSource extends ChangeNotifier {
  double? _angle;
  Offset? _position;
  double _strength = 1.0;

  /// Current light direction in radians, when driven by an angle.
  double? get angle => _angle;

  /// Global position of a point light (the pointer), when present.
  Offset? get position => _position;

  /// How far glass turns toward this light, 0–1.
  double get strength => _strength;

  void _set({double? angle, Offset? position, bool clearPosition = false}) {
    var changed = false;
    if (angle != null && angle != _angle) {
      _angle = angle;
      changed = true;
    }
    if (clearPosition && _position != null) {
      _position = null;
      changed = true;
    } else if (position != null && position != _position) {
      _position = position;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  /// The light direction for glass centred at [globalCenter], or null when
  /// this source currently emits no light.
  double? angleFor(Offset? globalCenter) {
    final p = _position;
    if (p != null && globalCenter != null) {
      final d = p - globalCenter;
      if (d.distance >= 1) return math.atan2(-d.dy, d.dx);
    }
    return _angle;
  }
}

class _Material4GlassLightState extends State<Material4GlassLight> {
  final Material4GlassLightSource _source = Material4GlassLightSource();
  StreamSubscription<double>? _sub;

  @override
  void initState() {
    super.initState();
    _source._strength = widget.strength.clamp(0.0, 1.0);
    _attach();
  }

  @override
  void didUpdateWidget(Material4GlassLight old) {
    super.didUpdateWidget(old);
    _source._strength = widget.strength.clamp(0.0, 1.0);
    if (old.angle != widget.angle || old.angleStream != widget.angleStream) {
      old.angle?.removeListener(_onAngle);
      _sub?.cancel();
      _sub = null;
      _attach();
    }
    if (!widget.followPointer) _source._set(clearPosition: true);
  }

  void _attach() {
    widget.angle?.addListener(_onAngle);
    if (widget.angle != null) _onAngle();
    _sub = widget.angleStream?.listen((a) => _source._set(angle: a));
  }

  void _onAngle() => _source._set(angle: widget.angle!.value);

  @override
  void dispose() {
    widget.angle?.removeListener(_onAngle);
    _sub?.cancel();
    _source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _Material4GlassLightScope(
      source: _source,
      child: widget.child,
    );
    if (widget.followPointer) {
      child = MouseRegion(
        opaque: false,
        hitTestBehavior: HitTestBehavior.translucent,
        onHover: (e) => _source._set(position: e.position),
        onExit: (_) => _source._set(clearPosition: true),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: (e) {
            if (e.kind == PointerDeviceKind.mouse) {
              _source._set(position: e.position);
            }
          },
          child: child,
        ),
      );
    }
    return child;
  }
}

class _Material4GlassLightScope extends InheritedWidget {
  final Material4GlassLightSource source;

  const _Material4GlassLightScope({required this.source, required super.child});

  @override
  bool updateShouldNotify(_Material4GlassLightScope old) =>
      old.source != source;
}
