import 'package:flutter/material.dart';

import 'material_4_responsive.dart';

/// One navigation destination of a [Material4AdaptiveScaffold].
@immutable
class Material4Destination {
  /// Creates a destination.
  const Material4Destination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// Icon when not selected.
  final IconData icon;

  /// Icon when selected; null uses [icon].
  final IconData? selectedIcon;

  /// Label (also the tooltip and semantics label).
  final String label;
}

/// An app shell whose structure follows the screen, like the platform apps
/// on each device:
///
/// | Size class          | Navigation                    | Panes                     |
/// | ------------------- | ----------------------------- | ------------------------- |
/// | compact (phone)     | bottom navigation bar         | [body] only               |
/// | medium (small tab.) | navigation rail               | [body] only               |
/// | expanded (tablet)   | navigation rail               | [body] + [secondaryBody]  |
/// | large / extra-large | extended rail (icons + labels)| [body] + [secondaryBody]  |
///
/// On wide screens the body is kept to a readable width instead of
/// stretching edge to edge.
///
/// ```dart
/// Material4AdaptiveScaffold(
///   destinations: const [
///     Material4Destination(icon: Icons.inbox, label: 'Inbox'),
///     Material4Destination(icon: Icons.send, label: 'Sent'),
///   ],
///   selectedIndex: index,
///   onDestinationSelected: (i) => setState(() => index = i),
///   body: const MailList(),
///   secondaryBody: selected == null ? null : MailView(selected),
/// )
/// ```
class Material4AdaptiveScaffold extends StatelessWidget {
  /// Creates an adaptive shell.
  const Material4AdaptiveScaffold({
    super.key,
    this.destinations = const [],
    this.selectedIndex = 0,
    this.onDestinationSelected,
    required this.body,
    this.secondaryBody,
    this.secondaryBodyFlex = 0.4,
    this.appBar,
    this.floatingActionButton,
    this.railLeading,
    this.railTrailing,
    this.limitBodyWidth = true,
    this.backgroundColor,
  });

  /// Top-level destinations (at least two to show navigation).
  final List<Material4Destination> destinations;

  /// The selected destination.
  final int selectedIndex;

  /// Called when a destination is chosen.
  final ValueChanged<int>? onDestinationSelected;

  /// Main content.
  final Widget body;

  /// Detail content shown beside [body] from the expanded size class
  /// (list–detail). On narrower screens push it as a page instead.
  final Widget? secondaryBody;

  /// Share of the width given to [secondaryBody] (0 – 1).
  final double secondaryBodyFlex;

  /// App bar (shown on every size).
  final PreferredSizeWidget? appBar;

  /// Floating action button. On rail layouts it moves to the top of the
  /// rail, like Material's large-screen guidance.
  final Widget? floatingActionButton;

  /// Extra widget above the rail destinations (e.g. a logo).
  final Widget? railLeading;

  /// Extra widget below the rail destinations.
  final Widget? railTrailing;

  /// Keep [body] to the screen's readable width on large screens.
  final bool limitBodyWidth;

  /// Scaffold background.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screen = context.responsive;
    final hasNav = destinations.length >= 2;
    final useBar = screen.isCompact;
    final showSecondary =
        secondaryBody != null && screen.isAtLeast(Material4SizeClass.expanded);

    Widget main = body;
    final readable = screen.readableWidth;
    if (limitBodyWidth && readable != null && !showSecondary) {
      main = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: readable),
          child: main,
        ),
      );
    }

    Widget content = main;
    if (showSecondary) {
      final flex = (secondaryBodyFlex.clamp(0.1, 0.9) * 100).round();
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 100 - flex, child: main),
          const VerticalDivider(width: 1),
          Expanded(flex: flex, child: secondaryBody!),
        ],
      );
    }

    if (hasNav && !useBar) {
      final extended = screen.isAtLeast(Material4SizeClass.large);
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            right: false,
            child: NavigationRail(
              extended: extended,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              leading: _railLeading(),
              trailing: railTrailing,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon ?? d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: content,
      floatingActionButton: (hasNav && !useBar) ? null : floatingActionButton,
      bottomNavigationBar: hasNav && useBar
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                for (final d in destinations)
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon ?? d.icon),
                    label: d.label,
                  ),
              ],
            )
          : null,
    );
  }

  Widget? _railLeading() {
    final fab = floatingActionButton;
    if (fab == null) return railLeading;
    if (railLeading == null) return fab;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [railLeading!, const SizedBox(height: 12), fab],
    );
  }
}
