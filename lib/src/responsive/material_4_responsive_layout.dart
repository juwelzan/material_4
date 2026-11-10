import 'package:flutter/widgets.dart';

import 'material_4_responsive.dart';

/// Shows a different layout per size class (or per device).
///
/// Only the layouts that differ need to be given; a missing one falls back
/// to the next smaller size, so `compact` alone is a valid layout and
/// `compact` + `expanded` gives one layout for phones and small tablets and
/// another from tablets in landscape upward.
///
/// ```dart
/// Material4ResponsiveLayout(
///   compact: (_) => const InboxList(),
///   expanded: (_) => const Row(children: [InboxList(), Expanded(child: Reader())]),
/// )
/// ```
class Material4ResponsiveLayout extends StatelessWidget {
  /// A layout per size class.
  const Material4ResponsiveLayout({
    super.key,
    required WidgetBuilder this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
    this.duration = const Duration(milliseconds: 250),
  })  : phone = null,
        tablet = null,
        desktop = null;

  /// A layout per device type (phone / tablet / desktop), whatever the
  /// window width. Missing ones fall back toward the phone layout.
  const Material4ResponsiveLayout.device({
    super.key,
    required WidgetBuilder this.phone,
    this.tablet,
    this.desktop,
    this.duration = const Duration(milliseconds: 250),
  })  : compact = null,
        medium = null,
        expanded = null,
        large = null,
        extraLarge = null;

  /// Phone-width layout (always required for size-class layouts).
  final WidgetBuilder? compact;

  /// Layout from the medium breakpoint.
  final WidgetBuilder? medium;

  /// Layout from the expanded breakpoint.
  final WidgetBuilder? expanded;

  /// Layout from the large breakpoint.
  final WidgetBuilder? large;

  /// Layout from the extra-large breakpoint.
  final WidgetBuilder? extraLarge;

  /// Layout on phones.
  final WidgetBuilder? phone;

  /// Layout on tablets.
  final WidgetBuilder? tablet;

  /// Layout on desktops.
  final WidgetBuilder? desktop;

  /// Cross-fade between layouts when the size class changes (rotation,
  /// window resize). [Duration.zero] switches instantly.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final screen = context.responsive;
    final WidgetBuilder builder;
    final Object key;
    if (phone != null) {
      builder = screen.byDevice(
        phone: phone!,
        tablet: tablet,
        desktop: desktop,
      );
      key = screen.byDevice<Object>(
        phone: 'phone',
        tablet: tablet == null ? null : 'tablet',
        desktop: desktop == null ? null : 'desktop',
      );
    } else {
      builder = screen.value(
        compact: compact!,
        medium: medium,
        expanded: expanded,
        large: large,
        extraLarge: extraLarge,
      );
      // Key on the builder actually chosen, so moving between two classes
      // that share a layout keeps its state.
      key = builder;
    }
    final child = KeyedSubtree(key: ValueKey(key), child: builder(context));
    if (duration == Duration.zero) return child;
    return AnimatedSwitcher(duration: duration, child: child);
  }
}

/// Shows [child] only within a range of size classes.
///
/// ```dart
/// Material4ResponsiveVisibility(from: Material4SizeClass.expanded, child: SidePanel())
/// Material4ResponsiveVisibility(until: Material4SizeClass.medium, child: MenuButton())
/// ```
class Material4ResponsiveVisibility extends StatelessWidget {
  /// Visible from [from] (inclusive) until [until] (exclusive).
  const Material4ResponsiveVisibility({
    super.key,
    this.from,
    this.until,
    this.replacement = const SizedBox.shrink(),
    required this.child,
  });

  /// Smallest size class that shows [child]; null: from the smallest.
  final Material4SizeClass? from;

  /// First size class that hides [child] again; null: no upper limit.
  final Material4SizeClass? until;

  /// Shown instead when hidden.
  final Widget replacement;

  /// The content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = context.responsive;
    final visible = (from == null || screen.isAtLeast(from!)) &&
        (until == null || screen.isBelow(until!));
    return visible ? child : replacement;
  }
}

/// How many of the 12 grid columns an item spans, per size class. Missing
/// values fall back to the next smaller size.
@immutable
class Material4Span {
  /// A span per size class (each 1 – 12).
  const Material4Span({
    this.compact = 12,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  /// The same span everywhere.
  const Material4Span.all(int span)
      : compact = span,
        medium = null,
        expanded = null,
        large = null,
        extraLarge = null;

  /// Full width on phones, halves on medium, thirds on expanded, quarters
  /// from large: a sensible card grid.
  static const Material4Span cards =
      Material4Span(compact: 12, medium: 6, expanded: 4, large: 3);

  /// Span on compact screens.
  final int compact;

  /// Span from medium.
  final int? medium;

  /// Span from expanded.
  final int? expanded;

  /// Span from large.
  final int? large;

  /// Span from extra-large.
  final int? extraLarge;

  /// The span for [screen], between 1 and 12.
  int resolve(Material4Screen screen) => screen
      .value(
        compact: compact,
        medium: medium,
        expanded: expanded,
        large: large,
        extraLarge: extraLarge,
      )
      .clamp(1, 12);
}

/// One cell of a [Material4ResponsiveGrid] with its own [span].
class Material4GridItem extends StatelessWidget {
  /// Creates a grid item.
  const Material4GridItem({super.key, required this.span, required this.child});

  /// Columns spanned per size class.
  final Material4Span span;

  /// The content.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// A 12-column grid that reflows by size class: the same cards stack on a
/// phone, pair up on a small tablet and line up in threes or fours on wide
/// screens. Wrap a child in [Material4GridItem] to give it its own span.
///
/// ```dart
/// Material4ResponsiveGrid(
///   children: [
///     Material4GridItem(span: Material4Span(compact: 12, expanded: 8), child: Chart()),
///     Material4GridItem(span: Material4Span(compact: 12, expanded: 4), child: Stats()),
///     for (final p in products) ProductCard(p), // uses [span]
///   ],
/// )
/// ```
class Material4ResponsiveGrid extends StatelessWidget {
  /// Creates a responsive grid.
  const Material4ResponsiveGrid({
    super.key,
    this.span = Material4Span.cards,
    this.spacing,
    this.runSpacing,
    this.maxWidth,
    required this.children,
  });

  /// Span of children that are not a [Material4GridItem].
  final Material4Span span;

  /// Gap between columns; null uses the screen's margin.
  final double? spacing;

  /// Gap between rows; null uses [spacing].
  final double? runSpacing;

  /// Centre the grid at most this wide; null uses the screen's readable
  /// width on large screens.
  final double? maxWidth;

  /// The cells.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final screen = context.responsive;
    final gap = spacing ?? screen.margin;
    final limit = maxWidth ?? screen.readableWidth;
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.maxWidth;
      if (limit != null && width > limit) width = limit;
      // A hair under the exact share, so rounding never pushes the last
      // cell of a full row onto the next line.
      double cellWidth(int columns) =>
          ((width + gap) * columns / 12 - gap - 0.01).clamp(0.0, width);
      final grid = Wrap(
        spacing: gap,
        runSpacing: runSpacing ?? gap,
        children: [
          for (final child in children)
            SizedBox(
              width: cellWidth(
                child is Material4GridItem
                    ? child.span.resolve(screen)
                    : span.resolve(screen),
              ),
              child: child,
            ),
        ],
      );
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(width: width, child: grid),
      );
    });
  }
}
