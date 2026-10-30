import 'package:flutter/material.dart';

/// Drawer integration configuration for [Material4AppBar] and [Material4SliverAppBar].
///
/// Seamlessly synchronizes with Flutter's [Scaffold] drawer state, automatically
/// displaying an animated or custom drawer trigger in the compact/floating header
/// while offering graceful fallbacks to back buttons or custom leading widgets.
@immutable
class Material4AppBarDrawer {
  /// Whether drawer awareness and automatic drawer leading button are enabled.
  final bool enabled;

  /// Custom icon or widget for opening the drawer. If null, a modern rounded
  /// menu icon is rendered.
  final Widget? icon;

  /// Whether to display the drawer button in the expanded header state.
  final bool showWhenExpanded;

  /// Whether to display the drawer button in the compact and floating header states.
  final bool showWhenCompact;

  /// Custom callback executed when the drawer button is tapped. If null,
  /// automatically calls `Scaffold.of(context).openDrawer()`.
  final VoidCallback? onOpenDrawer;

  /// Custom leading widget to display if the enclosing [Scaffold] does not have a drawer.
  final Widget? fallbackLeading;

  /// Whether to automatically show a [BackButton] if [Navigator.canPop] is true
  /// and no drawer is active or in fallback mode.
  final bool autoLeading;

  /// Tooltip description for screen readers and accessibility.
  final String? tooltip;

  /// Creates a [Material4AppBarDrawer] configuration.
  const Material4AppBarDrawer({
    this.enabled = true,
    this.icon,
    this.showWhenExpanded = false,
    this.showWhenCompact = true,
    this.onOpenDrawer,
    this.fallbackLeading,
    this.autoLeading = true,
    this.tooltip,
  });

  /// Factory configuration where the drawer button is visible in all states.
  static const Material4AppBarDrawer alwaysVisible = Material4AppBarDrawer(
    enabled: true,
    showWhenExpanded: true,
    showWhenCompact: true,
  );

  /// Factory configuration where the drawer button is hidden in the expanded state
  /// and floats in smoothly during reverse-scroll compact state.
  static const Material4AppBarDrawer compactOnly = Material4AppBarDrawer(
    enabled: true,
    showWhenExpanded: false,
    showWhenCompact: true,
  );

  /// Factory configuration disabling drawer integration.
  static const Material4AppBarDrawer disabled = Material4AppBarDrawer(
    enabled: false,
    showWhenExpanded: false,
    showWhenCompact: false,
  );

  /// Builds the leading button for the given layout context.
  Widget? buildLeading(
    BuildContext context, {
    required bool isCompact,
    VoidCallback? onCustomAction,
  }) {
    if (!enabled) {
      if (fallbackLeading != null) return fallbackLeading;
      if (autoLeading && Navigator.of(context).canPop()) {
        return const BackButton();
      }
      return null;
    }

    final hasDrawer = Scaffold.maybeOf(context)?.hasDrawer ?? false;

    if (hasDrawer) {
      if (isCompact && !showWhenCompact) return null;
      if (!isCompact && !showWhenExpanded) return null;

      final tip =
          tooltip ?? MaterialLocalizations.of(context).openAppDrawerTooltip;

      return IconButton(
        icon: icon ?? const Icon(Icons.menu_rounded),
        tooltip: tip,
        onPressed: onOpenDrawer ??
            () {
              Scaffold.of(context).openDrawer();
            },
      );
    }

    // No drawer in scaffold
    if (fallbackLeading != null) return fallbackLeading;
    if (autoLeading && Navigator.of(context).canPop()) {
      return const BackButton();
    }
    return null;
  }
}
