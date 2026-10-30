import 'package:flutter/material.dart';

/// Available status types for [Material4AvatarStatus].
enum AvatarStatusType {
  /// User is active and online (vibrant green).
  online,

  /// User is offline or invisible (muted slate).
  offline,

  /// User is busy / in a meeting (vivid red).
  busy,

  /// User is away / idle (warm amber).
  away,

  /// User has enabled Do Not Disturb (crimson with minus indicator).
  doNotDisturb,

  /// Custom status with user-specified color, icon, or widget.
  custom,
}

/// Placement position for the status indicator on [Material4Avatar].
enum AvatarStatusPosition {
  /// Lower-right corner of avatar (standard default).
  bottomRight,

  /// Lower-left corner of avatar.
  bottomLeft,

  /// Upper-right corner of avatar.
  topRight,

  /// Upper-left corner of avatar.
  topLeft,

  /// Fully custom alignment offset.
  custom,
}

/// Online status indicator engine for [Material4Avatar].
@immutable
class Material4AvatarStatus {
  /// Status category.
  final AvatarStatusType type;

  /// Corner or custom position of the indicator.
  final AvatarStatusPosition position;

  /// Custom alignment if [position] is [AvatarStatusPosition.custom].
  final Alignment alignment;

  /// Primary fill color of the status indicator.
  final Color color;

  /// Border outline color separating indicator from avatar (default [Colors.white]).
  final Color borderColor;

  /// Stroke width of the separating border outline.
  final double borderWidth;

  /// Diameter of the indicator dot. If null, automatically scales to 24% of avatar size.
  final double? size;

  /// Optional custom icon displayed inside the indicator (e.g. check, minus, clock).
  final IconData? icon;

  /// Optional custom widget rendered inside the indicator.
  final Widget? customWidget;

  /// Whether to enable subtle breathing pulse animation when status is active.
  final bool pulseAnimation;

  /// Offset adjustment fine-tuning indicator placement.
  final Offset offset;

  const Material4AvatarStatus({
    this.type = AvatarStatusType.online,
    this.position = AvatarStatusPosition.bottomRight,
    this.alignment = Alignment.bottomRight,
    this.color = const Color(0xFF22C55E),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.size,
    this.icon,
    this.customWidget,
    this.pulseAnimation = false,
    this.offset = Offset.zero,
  });

  /// Active online status indicator with vibrant emerald green.
  const Material4AvatarStatus.online({
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Color color = const Color(0xFF22C55E),
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    bool pulse = false,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.online,
          position: position,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          pulseAnimation: pulse,
          offset: offset,
        );

  /// Offline status indicator with muted slate tone.
  const Material4AvatarStatus.offline({
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Color color = const Color(0xFF94A3B8),
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.offline,
          position: position,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          offset: offset,
        );

  /// Busy / in-a-call status indicator with vivid red.
  const Material4AvatarStatus.busy({
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Color color = const Color(0xFFEF4444),
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.busy,
          position: position,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          offset: offset,
        );

  /// Away / idle status indicator with warm amber yellow.
  const Material4AvatarStatus.away({
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Color color = const Color(0xFFF59E0B),
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.away,
          position: position,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          offset: offset,
        );

  /// Do Not Disturb status indicator with a crisp horizontal bar.
  const Material4AvatarStatus.doNotDisturb({
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Color color = const Color(0xFFE11D48),
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.doNotDisturb,
          position: position,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          offset: offset,
        );

  /// Custom status indicator with arbitrary widget, icon, or color.
  const Material4AvatarStatus.custom({
    required Color color,
    AvatarStatusPosition position = AvatarStatusPosition.bottomRight,
    Alignment alignment = Alignment.bottomRight,
    Color borderColor = Colors.white,
    double borderWidth = 2.0,
    double? size,
    IconData? icon,
    Widget? customWidget,
    bool pulse = false,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarStatusType.custom,
          position: position,
          alignment: alignment,
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
          icon: icon,
          customWidget: customWidget,
          pulseAnimation: pulse,
          offset: offset,
        );

  /// Resolves the effective alignment for this status indicator.
  Alignment get resolvedAlignment {
    switch (position) {
      case AvatarStatusPosition.bottomRight:
        return Alignment.bottomRight;
      case AvatarStatusPosition.bottomLeft:
        return Alignment.bottomLeft;
      case AvatarStatusPosition.topRight:
        return Alignment.topRight;
      case AvatarStatusPosition.topLeft:
        return Alignment.topLeft;
      case AvatarStatusPosition.custom:
        return alignment;
    }
  }

  /// Builds the visual indicator widget scaled relative to [avatarSize].
  Widget buildWidget(BuildContext context, double avatarSize) {
    final effectiveSize = (size ?? (avatarSize * 0.25)).clamp(10.0, 32.0);

    Widget innerContent;
    if (customWidget != null) {
      innerContent = customWidget!;
    } else if (icon != null) {
      innerContent = Icon(
        icon,
        size: effectiveSize * 0.65,
        color: Colors.white,
      );
    } else if (type == AvatarStatusType.doNotDisturb) {
      innerContent = Container(
        width: effectiveSize * 0.55,
        height: effectiveSize * 0.16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(effectiveSize * 0.08),
        ),
      );
    } else {
      innerContent = const SizedBox.shrink();
    }

    final indicator = Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(child: innerContent),
    );

    if (!pulseAnimation) return indicator;

    return _PulsingStatusIndicator(
      color: color,
      size: effectiveSize,
      child: indicator,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AvatarStatus &&
        other.type == type &&
        other.position == position &&
        other.alignment == alignment &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.size == size &&
        other.icon == icon &&
        other.pulseAnimation == pulseAnimation &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        type,
        position,
        alignment,
        color,
        borderColor,
        borderWidth,
        size,
        icon,
        pulseAnimation,
        offset,
      );
}

class _PulsingStatusIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final Widget child;

  const _PulsingStatusIndicator({
    required this.color,
    required this.size,
    required this.child,
  });

  @override
  State<_PulsingStatusIndicator> createState() =>
      _PulsingStatusIndicatorState();
}

class _PulsingStatusIndicatorState extends State<_PulsingStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _fadeAnimation = Tween<double>(begin: 0.65, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}
