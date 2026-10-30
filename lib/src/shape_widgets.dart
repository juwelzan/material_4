import 'package:flutter/material.dart';

import 'material_4_config.dart';
import 'material_4_container.dart';
import 'shape_smart_layout.dart';

// =========================================================================
// 1. AnimatedShapeCard
// =========================================================================

/// Production-ready morphable card with title, subtitle, icon, and accessory slots.
class AnimatedShapeCard extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Material4Config config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AnimatedShapeCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.config = const Material4Config(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material4Container(
      config: config,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      width: width,
      height: height,
      child: ShapeSafeArea(
        config: config,
        basePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14.0)],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  if (subtitle != null) ...[
                    const SizedBox(height: 4.0),
                    subtitle!,
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12.0), trailing!],
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 2. ShapeButton
// =========================================================================

/// Accessible touch-compliant button wrapped in any Material 4 shape contour.
class ShapeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Material4Config config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final bool isLoading;

  const ShapeButton({
    super.key,
    required this.child,
    this.onPressed,
    this.config = const Material4Config(type: Material4Type.capsule),
    this.color = const Color(0xFF6C5CE7),
    this.gradient,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: ShapeSmartLayout.minAccessibleTouchTarget,
        minHeight: ShapeSmartLayout.minAccessibleTouchTarget,
      ),
      child: Material4Container(
        config: config,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        onTap: isLoading ? null : onPressed,
        child: Padding(
          padding: padding,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 3. ShapeAvatar
// =========================================================================

/// Profile avatar clipped to a distinctive shape with status indicator.
class ShapeAvatar extends StatelessWidget {
  final ImageProvider? image;
  final Widget? fallback;
  final double size;
  final Material4Config config;
  final Color borderColor;
  final double borderWidth;
  final bool isOnline;

  const ShapeAvatar({
    super.key,
    this.image,
    this.fallback,
    this.size = 56.0,
    this.config = const Material4Config(
      type: Material4Type.squircle,
      cornerRadius: 16.0,
    ),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarContent = SizedBox(
      width: size,
      height: size,
      child: Material4Container(
        config: config,
        width: size,
        height: size,
        borderColor: borderColor,
        borderWidth: borderWidth,
        clipBehavior: Clip.antiAlias,
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover)
            : Center(child: fallback ?? const Icon(Icons.person, size: 28)),
      ),
    );

    if (isOnline) {
      avatarContent = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF00E676),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    return avatarContent;
  }
}

// =========================================================================
// 4. ShapeBadge
// =========================================================================

/// High-visibility status or count badge clipped into a Material 4 shape.
class ShapeBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Material4Config config;
  final double fontSize;

  const ShapeBadge({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xFFFF4757),
    this.textColor = Colors.white,
    this.config = const Material4Config(type: Material4Type.capsule),
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material4Container(
      config: config,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// =========================================================================
// 5. ShapeProgress
// =========================================================================

/// Material 4 shape progress bar with animated fluid fill.
class ShapeProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color trackColor;
  final Color progressColor;
  final Gradient? progressGradient;
  final Material4Config config;

  const ShapeProgress({
    super.key,
    required this.value,
    this.height = 16.0,
    this.trackColor = const Color(0x1F000000),
    this.progressColor = const Color(0xFF6C5CE7),
    this.progressGradient,
    this.config = const Material4Config(type: Material4Type.capsule),
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clamped;

        return ClipPath(
          clipper: Material4Clipper(config: config),
          child: Container(
            width: totalWidth,
            height: height,
            color: trackColor,
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: fillWidth,
              height: height,
              decoration: BoxDecoration(
                color: progressGradient == null ? progressColor : null,
                gradient: progressGradient,
              ),
            ),
          ),
        );
      },
    );
  }
}

// =========================================================================
// 6. ShapeDivider
// =========================================================================

/// Decorative section divider featuring an ornamental center crest.
class ShapeDivider extends StatelessWidget {
  final double height;
  final Color color;
  final Material4Type crestShape;
  final double crestSize;

  const ShapeDivider({
    super.key,
    this.height = 1.5,
    this.color = const Color(0x221E1E24),
    this.crestShape = Material4Type.diamond,
    this.crestSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: height, color: color),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material4Container(
            config: Material4Config(type: crestShape),
            width: crestSize,
            height: crestSize,
            color: color,
          ),
        ),
        Expanded(
          child: Container(height: height, color: color),
        ),
      ],
    );
  }
}

// =========================================================================
// 7. ShapeAppBar
// =========================================================================

/// Custom shaped App Bar with wave or scalloped bottom edge.
class ShapeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final Material4Config config;
  final double elevation;

  const ShapeAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor = Colors.white,
    this.config = const Material4Config(
      type: Material4Type.waveEdge,
      anchor: ShapeAnchor.bottomCenter,
      waveAmplitude: 6.0,
      waveCount: 3.0,
    ),
    this.elevation = 4.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Material4Container(
      config: config,
      color: backgroundColor,
      shadows: elevation > 0
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              ),
            ]
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: title,
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 8. ShapeNavigationBar
// =========================================================================

/// Bottom Navigation Bar with an organic fluid or notched top contour.
class ShapeNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;
  final Material4Config config;
  final Color backgroundColor;

  const ShapeNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    this.config = const Material4Config(
      type: Material4Type.waveEdge,
      anchor: ShapeAnchor.topCenter,
      waveAmplitude: 6.0,
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material4Container(
      config: config,
      color: backgroundColor,
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding + 6, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(destinations.length, (i) {
            final dest = destinations[i];
            final isSelected = i == currentIndex;

            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isSelected ? dest.selectedIcon ?? dest.icon : dest.icon,
                    const SizedBox(height: 4),
                    Text(
                      dest.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// =========================================================================
// 9. ShapeBottomSheet
// =========================================================================

/// Modal bottom sheet container styled with fluid top contour.
class ShapeBottomSheet extends StatelessWidget {
  final Widget child;
  final Material4Config config;
  final Color backgroundColor;

  const ShapeBottomSheet({
    super.key,
    required this.child,
    this.config = const Material4Config(
      type: Material4Type.folderTab,
      anchor: ShapeAnchor.topCenter,
      tabWidth: 60.0,
      tabHeight: 8.0,
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material4Container(
      config: config,
      color: backgroundColor,
      width: double.infinity,
      child: ShapeSafeArea(
        config: config,
        basePadding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}

// =========================================================================
// 10. ShapeDialog
// =========================================================================

/// Expressive alert dialog framed by a dynamic geometric shape.
class ShapeDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final Material4Config config;
  final Color backgroundColor;

  const ShapeDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.config = const Material4Config(
      type: Material4Type.asymmetricCard,
      cornerRadii: CornerRadii(
        topLeft: 32,
        topRight: 12,
        bottomLeft: 12,
        bottomRight: 32,
      ),
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material4Container(
        config: config,
        color: backgroundColor,
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        child: ShapeSafeArea(
          config: config,
          basePadding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headlineSmall!,
                  child: title!,
                ),
                const SizedBox(height: 14.0),
              ],
              if (content != null) ...[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: content!,
                ),
                const SizedBox(height: 20.0),
              ],
              if (actions != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 11. ShapeTooltip
// =========================================================================

/// Speech bubble tooltip pointer that anchors to any target.
class ShapeTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final ShapeAnchor pointerAnchor;
  final Color backgroundColor;
  final Color textColor;

  const ShapeTooltip({
    super.key,
    required this.message,
    required this.child,
    this.pointerAnchor = ShapeAnchor.bottomCenter,
    this.backgroundColor = const Color(0xFF1E1E24),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material4Container(
          config: Material4Config(
            type: Material4Type.speechBubble,
            anchor: pointerAnchor,
            speechBubbleTailWidth: 12.0,
            speechBubbleTailHeight: 8.0,
            cornerRadius: 10.0,
          ),
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

// =========================================================================
// 12. ShapeImage
// =========================================================================

/// Image widget clipped to any Material 4 shape with aspect ratio and border.
class ShapeImage extends StatelessWidget {
  final ImageProvider image;
  final Material4Config config;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color borderColor;
  final double borderWidth;

  const ShapeImage({
    super.key,
    required this.image,
    this.config = const Material4Config(type: Material4Type.squircle),
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material4Container(
      config: config,
      width: width,
      height: height,
      borderColor: borderColor,
      borderWidth: borderWidth,
      clipBehavior: Clip.antiAlias,
      child: Image(image: image, fit: fit),
    );
  }
}

// =========================================================================
// 13. ShapeContainerGroup
// =========================================================================

/// Groups multiple shape containers into a coordinated interlocking flex layout.
class ShapeContainerGroup extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final double spacing;

  const ShapeContainerGroup({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.spacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(width: spacing),
          ],
        ],
      );
    }
  }
}
