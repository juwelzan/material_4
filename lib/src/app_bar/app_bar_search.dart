import 'package:flutter/material.dart';

/// Search bar configuration and renderer for [Material4AppBar] and [Material4SliverAppBar].
///
/// Features expandable/collapsible search field, live query callbacks,
/// suggestions/history overlays, auto clear button, and focus management.
@immutable
class Material4AppBarSearch {
  /// Whether search integration is enabled.
  final bool enabled;

  /// Text editing controller for the search query.
  final TextEditingController? controller;

  /// Focus node for keyboard and focus control.
  final FocusNode? focusNode;

  /// Placeholder text displayed when the search query is empty.
  final String hintText;

  /// Callback executed whenever the search text changes.
  final ValueChanged<String>? onChanged;

  /// Callback executed when the user submits their search query.
  final ValueChanged<String>? onSubmitted;

  /// Callback executed when the search clear button is pressed.
  final VoidCallback? onClear;

  /// List of query suggestions to display.
  final List<String> suggestions;

  /// List of recent search history queries.
  final List<String> history;

  /// Whether a clear (X) icon button appears when text is entered.
  final bool clearable;

  /// Whether the input requests focus automatically when displayed.
  final bool autofocus;

  /// Whether the search bar is expandable from an icon button or permanently open.
  final bool isExpandable;

  /// Explicit height of the search input field (default 44.0).
  final double height;

  /// Custom fill background color of the search box.
  final Color? backgroundColor;

  /// Custom border radius of the search box.
  final BorderRadiusGeometry? borderRadius;

  /// Optional leading icon or widget inside the search box.
  final Widget? leading;

  /// Optional trailing widget inside the search box.
  final Widget? trailing;

  /// Custom builder for full search UI override.
  final Widget Function(BuildContext context, Material4AppBarSearch search)?
      builder;

  /// Creates a [Material4AppBarSearch] configuration.
  const Material4AppBarSearch({
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.suggestions = const [],
    this.history = const [],
    this.clearable = true,
    this.autofocus = false,
    this.isExpandable = false,
    this.height = 44.0,
    this.backgroundColor,
    this.borderRadius,
    this.leading,
    this.trailing,
    this.builder,
  });

  /// Factory configuration for an integrated expandable search bar.
  factory Material4AppBarSearch.expandable({
    TextEditingController? controller,
    String hintText = 'Search...',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return Material4AppBarSearch(
      enabled: true,
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      isExpandable: true,
    );
  }

  /// Builds the concrete search field widget.
  Widget buildSearchField(BuildContext context, {required bool isCompact}) {
    if (builder != null) {
      return builder!(context, this);
    }

    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ??
        (theme.brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.06));

    final effectiveRadius = borderRadius ?? BorderRadius.circular(height / 2.0);

    return Material4SearchFieldWidget(
      search: this,
      backgroundColor: effectiveBgColor,
      borderRadius: effectiveRadius,
      isCompact: isCompact,
    );
  }
}

/// Internal stateful search widget handling clear button and keyboard focus.
class Material4SearchFieldWidget extends StatefulWidget {
  final Material4AppBarSearch search;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final bool isCompact;

  const Material4SearchFieldWidget({
    super.key,
    required this.search,
    required this.backgroundColor,
    required this.borderRadius,
    required this.isCompact,
  });

  @override
  State<Material4SearchFieldWidget> createState() =>
      _Material4SearchFieldWidgetState();
}

class _Material4SearchFieldWidgetState
    extends State<Material4SearchFieldWidget> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.search.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant Material4SearchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.search.controller != widget.search.controller) {
      oldWidget.search.controller?.removeListener(_handleTextChange);
      _controller = widget.search.controller ?? TextEditingController();
      _hasText = _controller.text.isNotEmpty;
      _controller.addListener(_handleTextChange);
    }
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      if (mounted) {
        setState(() {
          _hasText = hasText;
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.search.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: widget.search.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: Row(
        children: [
          widget.search.leading ??
              Icon(
                Icons.search_rounded,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.search.focusNode,
              autofocus: widget.search.autofocus,
              onChanged: widget.search.onChanged,
              onSubmitted: widget.search.onSubmitted,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.search.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: (widget.search.clearable && _hasText)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: GestureDetector(
              onTap: () {
                _controller.clear();
                widget.search.onChanged?.call('');
                widget.search.onClear?.call();
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            secondChild: widget.search.trailing ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
