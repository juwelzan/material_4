import 'package:flutter/rendering.dart';

/// Accessibility and semantics coordinator for [RenderDynamicShape] and [RenderMultiChildDynamicShape].
class DynamicShapeSemantics {
  const DynamicShapeSemantics._();

  /// Configures semantics on [config] for an interactive or labeled dynamic shape.
  static void applySemantics({
    required SemanticsConfiguration config,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    String? semanticLabel,
    String? semanticHint,
    TextDirection textDirection = TextDirection.ltr,
    bool enabled = true,
  }) {
    if (semanticLabel != null && semanticLabel.isNotEmpty) {
      config.label = semanticLabel;
      config.textDirection = textDirection;
    }

    if (semanticHint != null && semanticHint.isNotEmpty) {
      config.hint = semanticHint;
      config.textDirection = textDirection;
    }

    if (onTap != null || onLongPress != null) {
      config.isButton = true;
      config.isEnabled = enabled;
      if (enabled) {
        if (onTap != null) {
          config.onTap = onTap;
        }
        if (onLongPress != null) {
          config.onLongPress = onLongPress;
        }
      }
    }
  }
}
