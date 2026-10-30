import 'package:flutter/material.dart';

/// Action item configuration for [Material4AppBar] and [Material4SliverAppBar].
///
/// Supports interactive button actions, badging (unread notifications/counters),
/// tooltips, accessibility semantic descriptions, and state-aware visibility
/// rules (expanded, collapsed, floating).
@immutable
class Material4AppBarAction {
  /// The icon widget displayed for this action.
  final Widget? icon;

  /// Custom widget replacing the standard [IconButton].
  final Widget? child;

  /// Callback executed when the action is tapped.
  final VoidCallback? onPressed;

  /// Accessible tooltip description.
  final String? tooltip;

  /// Optional badge widget (e.g. notification dot, tag).
  final Widget? badge;

  /// Numeric badge count displayed over the action icon (e.g. 3, 99+).
  final int? badgeCount;

  /// Badge background color.
  final Color? badgeColor;

  /// Badge text color.
  final Color? badgeTextColor;

  /// Whether this action should be visible in the expanded header.
  final bool showWhenExpanded;

  /// Whether this action should be visible in the collapsed header.
  final bool showWhenCollapsed;

  /// Whether this action should be visible in the floating compact header.
  final bool showWhenFloating;

  /// Semantic label for screen readers.
  final String? semanticLabel;

  /// Creates a [Material4AppBarAction].
  const Material4AppBarAction({
    this.icon,
    this.child,
    this.onPressed,
    this.tooltip,
    this.badge,
    this.badgeCount,
    this.badgeColor,
    this.badgeTextColor,
    this.showWhenExpanded = true,
    this.showWhenCollapsed = true,
    this.showWhenFloating = true,
    this.semanticLabel,
  });

  /// Factory constructor for a notification bell action with unread counter.
  factory Material4AppBarAction.notification({
    required VoidCallback onPressed,
    int? unreadCount,
    Color? badgeColor,
    String? tooltip,
    bool showWhenExpanded = true,
    bool showWhenCollapsed = true,
    bool showWhenFloating = true,
  }) {
    return Material4AppBarAction(
      icon: const Icon(Icons.notifications_none_rounded),
      onPressed: onPressed,
      badgeCount: unreadCount,
      badgeColor: badgeColor ?? const Color(0xFFFF486A),
      tooltip: tooltip ?? 'Notifications',
      showWhenExpanded: showWhenExpanded,
      showWhenCollapsed: showWhenCollapsed,
      showWhenFloating: showWhenFloating,
    );
  }

  /// Builds the concrete action widget based on current visibility rules.
  Widget? buildAction(
    BuildContext context, {
    required bool isExpanded,
    required bool isFloating,
  }) {
    final isVisible = isFloating
        ? showWhenFloating
        : (isExpanded ? showWhenExpanded : showWhenCollapsed);

    if (!isVisible) return null;

    if (child != null) return child;

    Widget iconWidget = icon ?? const Icon(Icons.more_vert_rounded);

    if (badge != null || (badgeCount != null && badgeCount! > 0)) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -2,
            right: -2,
            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: badge ??
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        badgeCount! > 99 ? '99+' : badgeCount.toString(),
                        style: TextStyle(
                          color: badgeTextColor ?? Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      );
    }

    return IconButton(
      icon: iconWidget,
      tooltip: tooltip ?? semanticLabel,
      onPressed: onPressed,
    );
  }
}
