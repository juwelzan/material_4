import 'package:flutter/foundation.dart';

import 'material_4_hit_test.dart';

/// Immutable configuration governing shape-aware interaction, hit-testing,
/// and pointer event routing.
@immutable
class Material4Interaction {
  /// Defines how pointer hits are evaluated against the container and shape geometry.
  final ShapeHitTestBehavior hitTestBehavior;

  /// Whether the shape body itself claims pointer interactions.
  ///
  /// When `false`, the shape background will not capture gestures, though eligible
  /// child widgets may still receive interactions if [enableChildHitTesting] is `true`.
  final bool enableShapeHitTesting;

  /// Whether child widgets receive pointer interactions.
  final bool enableChildHitTesting;

  /// Whether clicks inside cut-out notch regions are captured by the shape
  /// rather than passing through to underlying widgets.
  ///
  /// Defaults to `false` (clicks inside inward notches pass through).
  final bool enableNotchInteraction;

  /// Whether clicks in transparent corners or concave cutouts outside the shape path
  /// are captured by the shape container.
  ///
  /// Defaults to `false` (transparent corner clicks pass through).
  final bool enableTransparentRegionInteraction;

  const Material4Interaction({
    this.hitTestBehavior = ShapeHitTestBehavior.shape,
    this.enableShapeHitTesting = true,
    this.enableChildHitTesting = true,
    this.enableNotchInteraction = false,
    this.enableTransparentRegionInteraction = false,
  });

  /// Standard default interaction:
  /// Evaluates the exact vector shape contour and passes clicks through notches and transparent corners.
  static const Material4Interaction standard = Material4Interaction();

  /// Interaction matching the exact vector contour of the Material 4 shape.
  static const Material4Interaction contour = Material4Interaction(
    hitTestBehavior: ShapeHitTestBehavior.shape,
  );

  /// Interaction evaluating the entire rectangular bounding box.
  static const Material4Interaction rectangular = Material4Interaction(
    hitTestBehavior: ShapeHitTestBehavior.rectangular,
  );

  /// Entire rectangular bounds receive interaction and consume pointer events,
  /// blocking touches from reaching underlying widgets.
  static const Material4Interaction opaque = Material4Interaction(
    hitTestBehavior: ShapeHitTestBehavior.opaque,
  );

  /// Participates in hit testing while allowing underlying eligible targets to receive events.
  static const Material4Interaction translucent = Material4Interaction(
    hitTestBehavior: ShapeHitTestBehavior.translucent,
  );

  /// The shape itself does not claim empty regions; only eligible child widgets receive interaction.
  static const Material4Interaction deferToChild = Material4Interaction(
    hitTestBehavior: ShapeHitTestBehavior.deferToChild,
  );

  /// Creates a copy of this [Material4Interaction] with the given fields replaced.
  Material4Interaction copyWith({
    ShapeHitTestBehavior? hitTestBehavior,
    bool? enableShapeHitTesting,
    bool? enableChildHitTesting,
    bool? enableNotchInteraction,
    bool? enableTransparentRegionInteraction,
  }) {
    return Material4Interaction(
      hitTestBehavior: hitTestBehavior ?? this.hitTestBehavior,
      enableShapeHitTesting:
          enableShapeHitTesting ?? this.enableShapeHitTesting,
      enableChildHitTesting:
          enableChildHitTesting ?? this.enableChildHitTesting,
      enableNotchInteraction:
          enableNotchInteraction ?? this.enableNotchInteraction,
      enableTransparentRegionInteraction: enableTransparentRegionInteraction ??
          this.enableTransparentRegionInteraction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4Interaction &&
        other.hitTestBehavior == hitTestBehavior &&
        other.enableShapeHitTesting == enableShapeHitTesting &&
        other.enableChildHitTesting == enableChildHitTesting &&
        other.enableNotchInteraction == enableNotchInteraction &&
        other.enableTransparentRegionInteraction ==
            enableTransparentRegionInteraction;
  }

  @override
  int get hashCode => Object.hash(
        hitTestBehavior,
        enableShapeHitTesting,
        enableChildHitTesting,
        enableNotchInteraction,
        enableTransparentRegionInteraction,
      );

  @override
  String toString() => 'Material4Interaction('
      'hitTestBehavior: $hitTestBehavior, '
      'enableShapeHitTesting: $enableShapeHitTesting, '
      'enableChildHitTesting: $enableChildHitTesting, '
      'enableNotchInteraction: $enableNotchInteraction, '
      'enableTransparentRegionInteraction: $enableTransparentRegionInteraction)';
}
