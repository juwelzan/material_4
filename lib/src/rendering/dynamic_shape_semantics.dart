import 'package:flutter/rendering.dart';

/// Accessibility and semantics coordinator for [RenderDynamicShape].
class DynamicShapeSemantics {
  const DynamicShapeSemantics._();

  /// Configures semantics on [config] for an interactive or labeled dynamic shape.
  static void applySemantics({
    required SemanticsConfiguration config,
    VoidCallback? onTap,
    String? semanticLabel,
    String? semanticHint,
    bool enabled = true,
  }) {
    if (semanticLabel != null && semanticLabel.isNotEmpty) {
      config.label = semanticLabel;
    }

    if (semanticHint != null && semanticHint.isNotEmpty) {
      config.hint = semanticHint;
    }

    if (onTap != null) {
      config.isButton = true;
      config.isEnabled = enabled;
      if (enabled) {
        config.onTap = onTap;
      }
    }
  }
}

