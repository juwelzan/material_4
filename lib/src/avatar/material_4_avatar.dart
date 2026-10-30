import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'avatar_badge.dart';
import 'avatar_border.dart';
import 'avatar_shape.dart';
import 'avatar_status.dart';

/// A modern, fully customizable, and shape-aware Profile Avatar for Flutter.
///
/// Supports 24+ basic, organic, and creative shapes, arbitrary vector path borders,
/// online status indicators, notification/verified badges, graceful image fallbacks,
/// interactive tap/hover feedback, and group avatar compositions.
class Material4Avatar extends StatefulWidget {
  /// Diameter or bounding dimension of the avatar in logical pixels.
  final double size;

  /// Primary image provider (e.g. [NetworkImage], [AssetImage], [MemoryImage], [FileImage]).
  final ImageProvider? image;

  /// User initials displayed when image is unavailable or loading (e.g. "JR", "MD").
  final String? initials;

  /// Fallback icon displayed when neither image nor initials are provided.
  final IconData? icon;

  /// Custom child widget rendered inside the avatar shape.
  final Widget? child;

  /// Shape geometry defining the silhouette of the avatar.
  final Material4AvatarShape shape;

  /// Border engine configuration following the avatar's exact shape contour.
  final Material4AvatarBorder border;

  /// Optional online status indicator (e.g. online, offline, busy, away, DND).
  final Material4AvatarStatus? status;

  /// Optional overlay badge (e.g. notification counter, verified seal, VIP crown).
  final Material4AvatarBadge? badge;

  /// Fill background color of the avatar interior.
  final Color? backgroundColor;

  /// Foreground text/icon color.
  final Color? foregroundColor;

  /// Text style for initials.
  final TextStyle? initialsTextStyle;

  /// Image fit strategy (default [BoxFit.cover]).
  final BoxFit fit;

  /// Image alignment within the avatar bounds.
  final Alignment imageAlignment;

  /// Scale multiplier applied to the rendered image.
  final double imageScale;

  /// Optional widget displayed while the network image is downloading.
  final Widget? loadingPlaceholder;

  /// Optional widget displayed if image loading encounters an error.
  final Widget? errorPlaceholder;

  /// Optional decorative foreground overlay widget.
  final Widget? overlay;

  /// Optional gradient overlay applied over the image (e.g. for scrim/contrast).
  final Gradient? gradientOverlay;

  /// Callback triggered when the avatar is tapped.
  final VoidCallback? onTap;

  /// Callback triggered when the avatar is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to slightly depress/scale down on pointer tap.
  final bool enablePressScale;

  /// Whether to slightly elevate/highlight on mouse pointer hover.
  final bool enableHoverEffect;

  /// Accessible semantics description for screen readers.
  final String? semanticLabel;

  const Material4Avatar({
    super.key,
    this.size = 56.0,
    this.image,
    this.initials,
    this.icon,
    this.child,
    this.shape = const _DefaultCircleShape(),
    this.border = const Material4AvatarBorder.none(),
    this.status,
    this.badge,
    this.backgroundColor,
    this.foregroundColor,
    this.initialsTextStyle,
    this.fit = BoxFit.cover,
    this.imageAlignment = Alignment.center,
    this.imageScale = 1.0,
    this.loadingPlaceholder,
    this.errorPlaceholder,
    this.overlay,
    this.gradientOverlay,
    this.onTap,
    this.onLongPress,
    this.enablePressScale = true,
    this.enableHoverEffect = true,
    this.semanticLabel,
  });

  /// Factory constructor for displaying initials with automatic deterministic background colors.
  factory Material4Avatar.initials({
    Key? key,
    required String initials,
    double size = 56.0,
    Material4AvatarShape? shape,
    Material4AvatarBorder border = const Material4AvatarBorder.none(),
    Material4AvatarStatus? status,
    Material4AvatarBadge? badge,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Material4Avatar(
      key: key,
      size: size,
      initials: initials,
      shape: shape ?? Material4AvatarShape.circle(),
      border: border,
      status: status,
      badge: badge,
      backgroundColor: backgroundColor,
      foregroundColor: textColor ?? Colors.white,
      initialsTextStyle: textStyle,
      onTap: onTap,
      semanticLabel: semanticLabel ?? 'Avatar for $initials',
    );
  }

  /// Factory constructor for displaying a central emblem icon.
  factory Material4Avatar.icon({
    Key? key,
    required IconData icon,
    double size = 56.0,
    Material4AvatarShape? shape,
    Material4AvatarBorder border = const Material4AvatarBorder.none(),
    Material4AvatarStatus? status,
    Material4AvatarBadge? badge,
    Color? backgroundColor,
    Color? iconColor,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Material4Avatar(
      key: key,
      size: size,
      icon: icon,
      shape: shape ?? Material4AvatarShape.circle(),
      border: border,
      status: status,
      badge: badge,
      backgroundColor: backgroundColor,
      foregroundColor: iconColor ?? Colors.white,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory constructor emphasizing online presence status.
  factory Material4Avatar.status({
    Key? key,
    required ImageProvider image,
    required Material4AvatarStatus status,
    double size = 56.0,
    Material4AvatarShape? shape,
    Material4AvatarBorder border = const Material4AvatarBorder.none(),
    Material4AvatarBadge? badge,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Material4Avatar(
      key: key,
      size: size,
      image: image,
      status: status,
      badge: badge,
      shape: shape ?? Material4AvatarShape.circle(),
      border: border,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory constructor emphasizing verified/notification badges.
  factory Material4Avatar.badge({
    Key? key,
    required ImageProvider image,
    required Material4AvatarBadge badge,
    double size = 56.0,
    Material4AvatarShape? shape,
    Material4AvatarBorder border = const Material4AvatarBorder.none(),
    Material4AvatarStatus? status,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Material4Avatar(
      key: key,
      size: size,
      image: image,
      badge: badge,
      status: status,
      shape: shape ?? Material4AvatarShape.circle(),
      border: border,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }

  @override
  State<Material4Avatar> createState() => _Material4AvatarState();
}

class _DefaultCircleShape extends Material4AvatarShape {
  const _DefaultCircleShape()
      : super.raw(
          id: 'circle',
          pathBuilder: _buildCircle,
        );

  static Path _buildCircle(Size size) {
    final path = Path();
    final radius = math.min(size.width, size.height) / 2.0;
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2.0, size.height / 2.0),
      radius: radius,
    ));
    return path;
  }
}

class _Material4AvatarState extends State<Material4Avatar> {
  bool _isPressed = false;
  bool _isHovered = false;

  static const List<Color> _deterministicPalette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF43F5E), // Rose
    Color(0xFF3B82F6), // Blue
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFF0EA5E9), // Sky
    Color(0xFF14B8A6), // Teal
  ];

  Color _resolveBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    if (widget.initials != null && widget.initials!.isNotEmpty) {
      final hash = widget.initials!.codeUnits.fold<int>(0, (a, b) => a + b);
      return _deterministicPalette[hash % _deterministicPalette.length];
    }
    return const Color(0xFF64748B); // Slate
  }

  Widget _buildContent(BuildContext context, Size size) {
    if (widget.child != null) {
      return widget.child!;
    }

    if (widget.image != null) {
      return Image(
        image: widget.image!,
        fit: widget.fit,
        alignment: widget.imageAlignment,
        width: size.width * widget.imageScale,
        height: size.height * widget.imageScale,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return widget.loadingPlaceholder ??
              Center(
                child: SizedBox(
                  width: size.width * 0.35,
                  height: size.height * 0.35,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorPlaceholder ??
              _buildFallbackContent(context, size);
        },
      );
    }

    return _buildFallbackContent(context, size);
  }

  Widget _buildFallbackContent(BuildContext context, Size size) {
    if (widget.initials != null && widget.initials!.trim().isNotEmpty) {
      final cleanInitials = widget.initials!.trim();
      final displayInitials = cleanInitials.length > 3
          ? cleanInitials.substring(0, 3).toUpperCase()
          : cleanInitials.toUpperCase();

      return Center(
        child: Text(
          displayInitials,
          style: widget.initialsTextStyle ??
              TextStyle(
                color: widget.foregroundColor ?? Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size.width * 0.40,
                letterSpacing: -0.5,
                height: 1.0,
              ),
        ),
      );
    }

    return Center(
      child: Icon(
        widget.icon ?? Icons.person_rounded,
        size: size.width * 0.55,
        color: widget.foregroundColor ?? Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double avatarSize = widget.size;
    final totalMargin = widget.border.totalMargin;
    final outerSize = avatarSize + (totalMargin * 2);

    final resolvedBg = _resolveBackgroundColor();

    // Visual scale factor on tap/hover
    double scaleFactor = 1.0;
    if (_isPressed && widget.enablePressScale) {
      scaleFactor = 0.95;
    } else if (_isHovered && widget.enableHoverEffect) {
      scaleFactor = 1.03;
    }

    final avatarBody = AnimatedScale(
      scale: scaleFactor,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: outerSize,
        height: outerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Clipped Avatar Surface with Background Color & Content
            SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: ClipPath(
                clipper: _AvatarClipper(shape: widget.shape),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  color: resolvedBg,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildContent(context, Size(avatarSize, avatarSize)),
                      if (widget.gradientOverlay != null)
                        DecoratedBox(
                          decoration:
                              BoxDecoration(gradient: widget.gradientOverlay),
                        ),
                      if (widget.overlay != null) widget.overlay!,
                    ],
                  ),
                ),
              ),
            ),

            // 2. Custom Border Follower
            if (widget.border.style != AvatarBorderStyle.none &&
                widget.border.width > 0)
              Positioned.fill(
                child: CustomPaint(
                  painter: _AvatarBorderPainter(
                    shape: widget.shape,
                    border: widget.border,
                    avatarSize: Size(avatarSize, avatarSize),
                  ),
                ),
              ),

            // 3. Online Status Indicator
            if (widget.status != null)
              Align(
                alignment: widget.status!.resolvedAlignment,
                child: Transform.translate(
                  offset: widget.status!.offset,
                  child: widget.status!.buildWidget(context, avatarSize),
                ),
              ),

            // 4. Overlay Badge
            if (widget.badge != null)
              Align(
                alignment: widget.badge!.alignment,
                child: Transform.translate(
                  offset: widget.badge!.offset,
                  child: widget.badge!.buildWidget(context, avatarSize),
                ),
              ),
          ],
        ),
      ),
    );

    final interactiveWrapper = MouseRegion(
      onEnter: widget.onTap != null && widget.enableHoverEffect
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.onTap != null && widget.enableHoverEffect
          ? (_) => setState(() => _isHovered = false)
          : null,
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onTapDown: widget.onTap != null && widget.enablePressScale
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: widget.onTap != null && widget.enablePressScale
            ? (_) => setState(() => _isPressed = false)
            : null,
        onTapCancel: widget.onTap != null && widget.enablePressScale
            ? () => setState(() => _isPressed = false)
            : null,
        child: avatarBody,
      ),
    );

    return Semantics(
      image: true,
      button: widget.onTap != null,
      label: widget.semanticLabel ??
          (widget.initials != null
              ? 'Avatar for ${widget.initials}'
              : 'Profile avatar'),
      child: interactiveWrapper,
    );
  }
}

class _AvatarClipper extends CustomClipper<Path> {
  final Material4AvatarShape shape;

  _AvatarClipper({required this.shape});

  @override
  Path getClip(Size size) => shape.buildPath(size);

  @override
  bool shouldReclip(covariant _AvatarClipper oldClipper) =>
      oldClipper.shape != shape;
}

class _AvatarBorderPainter extends CustomPainter {
  final Material4AvatarShape shape;
  final Material4AvatarBorder border;
  final Size avatarSize;

  _AvatarBorderPainter({
    required this.shape,
    required this.border,
    required this.avatarSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = (size.width - avatarSize.width) / 2.0;
    final dy = (size.height - avatarSize.height) / 2.0;

    canvas.save();
    canvas.translate(dx, dy);

    final path = shape.buildPath(avatarSize);
    border.paintBorder(canvas, avatarSize, path);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AvatarBorderPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.border != border ||
        oldDelegate.avatarSize != avatarSize;
  }
}
