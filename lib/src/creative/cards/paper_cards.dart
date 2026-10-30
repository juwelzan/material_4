import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../dynamic_shape_container.dart';
import '../borders/creative_border_config.dart';
import '../paper/paper_background_config.dart';

// =============================================================================
// 1. LayeredPaperCard
// =============================================================================

/// Card featuring visually stacked paper sheets with subtle angle and shadow differences.
class LayeredPaperCard extends StatelessWidget {
  final Widget child;
  final int stackCount;
  final Color backgroundColor;
  final Color underlayColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const LayeredPaperCard({
    super.key,
    required this.child,
    this.stackCount = 2,
    this.backgroundColor = const Color(0xFFFAF8F5),
    this.underlayColor = const Color(0xFFEDE8E1),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Stack(
      clipBehavior: Clip.none,
      children: [
        if (stackCount >= 3)
          Positioned.fill(
            child: Transform.rotate(
              angle: -0.035,
              child: Container(
                decoration: BoxDecoration(
                  color: underlayColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (stackCount >= 2)
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.025,
              child: Container(
                decoration: BoxDecoration(
                  color: underlayColor,
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        DynamicShapeContainer(
          width: width,
          height: height,
          padding: padding,
          color: backgroundColor,
          borderColor: const Color(0x14000000),
          borderWidth: 1.0,
          config: const DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 6.0,
            paperBackground: PaperBackgroundConfig(
              style: PaperBackgroundStyle.plainWhite,
              grainOpacity: 0.06,
            ),
          ),
          child: child,
        ),
      ],
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 2. TornPaperCard
// =============================================================================

/// Card featuring realistic torn paper edges, authentic stationery grain, and drop shadows.
class TornPaperCard extends StatelessWidget {
  final Widget child;
  final BorderEdges edges;
  final double tearIntensity;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const TornPaperCard({
    super.key,
    required this.child,
    this.edges = BorderEdges.all,
    this.tearIntensity = 0.6,
    this.backgroundColor = const Color(0xFFF9F6F0),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 4.0,
        creativeBorder: CreativeBorderConfig.tornPaper(
          edges: edges,
          tearIntensity: tearIntensity,
          color: const Color(0xFFE5DFD3),
        ),
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.handmade,
          grainOpacity: 0.08,
          fiberDensity: 0.35,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 3. FoldedPaperCard
// =============================================================================

/// Card featuring a folded corner crease or brochure fold styling.
class FoldedPaperCard extends StatelessWidget {
  final Widget child;
  final double foldSize;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const FoldedPaperCard({
    super.key,
    required this.child,
    this.foldSize = 28.0,
    this.backgroundColor = const Color(0xFFFAF7F2),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: DynamicShapeConfig(
        type: DynamicShapeType.chamferDiagonal,
        tabWidth: foldSize,
        tabHeight: foldSize,
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.folded,
          hasFolds: true,
        ),
        creativeBorder: CreativeBorderConfig.foldedPaper(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

/// Backward-compatibility alias for [FoldedPaperCard].
typedef FoldedCornerCard = FoldedPaperCard;

// =============================================================================
// 4. StickyNoteCard
// =============================================================================

/// Post-It style sticky note card with translucent top adhesive tape and warm stationery yellow tint.
class StickyNoteCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color tapeColor;
  final bool hasTape;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const StickyNoteCard({
    super.key,
    required this.child,
    this.color = const Color(0xFFFFF9A6),
    this.tapeColor = const Color(0x66FFDE59),
    this.hasTape = true,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget note = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      color: color,
      shadows: const [
        BoxShadow(
          color: Color(0x22000000),
          offset: Offset(2, 6),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 4.0,
        paperBackground: PaperBackgroundConfig.stickyNote(baseColor: color),
      ),
      child: child,
    );

    if (hasTape) {
      note = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          note,
          Positioned(
            top: -8.0,
            child: Container(
              width: 54.0,
              height: 18.0,
              decoration: BoxDecoration(
                color: tapeColor,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (margin != null) {
      note = Padding(padding: margin!, child: note);
    }
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: note);
    }
    return note;
  }
}

// =============================================================================
// 5. VintagePaperCard
// =============================================================================

/// Antique aged parchment paper card with charred scorched edges and rich fiber texture.
class VintagePaperCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool burnEdges;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const VintagePaperCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFF4ECD8),
    this.burnEdges = true,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 8.0,
        creativeBorder: burnEdges ? CreativeBorderConfig.burntEdge() : null,
        paperBackground: PaperBackgroundConfig.vintage(),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 6. NotebookCard
// =============================================================================

/// Ruled notebook stationery card with red vertical margin line and horizontal rules.
class NotebookCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const NotebookCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFFCFAF2),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x18000000),
      borderWidth: 1.0,
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 12.0,
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.notebook,
        ),
        creativePattern: CreativePatternConfig.notebookRuling(),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 7. KraftPaperCard
// =============================================================================

/// Heavy unbleached brown kraft paper card with organic fiber flecks and tactile cardboard warmth.
class KraftPaperCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const KraftPaperCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFD2B48C),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x1F5D4037),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x24000000),
          offset: Offset(0, 3),
          blurRadius: 8,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 8.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.kraft,
          grainOpacity: 0.12,
          fiberDensity: 0.55,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 8. RecycledPaperCard
// =============================================================================

/// Eco-friendly recycled paper card with visible botanical and fiber inclusions.
class RecycledPaperCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const RecycledPaperCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFEFECE6),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x1F795548),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x18000000),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 6.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.recycled,
          grainOpacity: 0.14,
          fiberDensity: 0.70,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 9. ParchmentCard
// =============================================================================

/// Historic manuscript parchment card featuring traditional deckled feathered edges.
class ParchmentCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ParchmentCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFF7F2E7),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      shadows: const [
        BoxShadow(
          color: Color(0x22000000),
          offset: Offset(1, 4),
          blurRadius: 10,
        ),
      ],
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 4.0,
        creativeBorder: CreativeBorderConfig.deckledEdge(
          color: const Color(0xFFD7CCC8),
          tearIntensity: 0.6,
        ),
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.parchment,
          grainOpacity: 0.10,
          fiberDensity: 0.40,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 10. PaperStackCard
// =============================================================================

/// Multi-sheet paper stack with cascading physical depth and subtle page skew.
class PaperStackCard extends StatelessWidget {
  final Widget child;
  final int sheetCount;
  final Color topColor;
  final Color underColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const PaperStackCard({
    super.key,
    required this.child,
    this.sheetCount = 3,
    this.topColor = const Color(0xFFFFFFFF),
    this.underColor = const Color(0xFFF3F1EC),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      clipBehavior: Clip.none,
      children: [
        for (int i = sheetCount - 1; i >= 1; i--)
          Positioned.fill(
            child: Transform.rotate(
              angle: (i.isOdd ? 1 : -1) * (i * 0.02),
              child: Container(
                decoration: BoxDecoration(
                  color: underColor,
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x12000000),
                      offset: Offset(0, 2.0 * i),
                      blurRadius: 4.0 * i,
                    ),
                  ],
                ),
              ),
            ),
          ),
        DynamicShapeContainer(
          width: width,
          height: height,
          padding: padding,
          color: topColor,
          borderColor: const Color(0x14000000),
          borderWidth: 1.0,
          shadows: const [
            BoxShadow(
              color: Color(0x1C000000),
              offset: Offset(0, 3),
              blurRadius: 8,
            ),
          ],
          config: const DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 6.0,
            paperBackground: PaperBackgroundConfig(
              style: PaperBackgroundStyle.plainWhite,
              grainOpacity: 0.04,
            ),
          ),
          child: child,
        ),
      ],
    );

    if (margin != null) {
      stack = Padding(padding: margin!, child: stack);
    }
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: stack);
    }
    return stack;
  }
}

// =============================================================================
// 11. PaperCutoutCard
// =============================================================================

/// Paper craft card with a recessed silhouette window or stamped cut-out depth.
class PaperCutoutCard extends StatelessWidget {
  final Widget child;
  final Widget? cutoutChild;
  final Color backgroundColor;
  final Color cutoutColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const PaperCutoutCard({
    super.key,
    required this.child,
    this.cutoutChild,
    this.backgroundColor = const Color(0xFFFBF9F5),
    this.cutoutColor = const Color(0xFFEBE6DD),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (cutoutChild != null) ...[
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: cutoutColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E000000),
                  offset: Offset(1, 2),
                  blurRadius: 4,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: cutoutChild!,
          ),
          const SizedBox(height: 12.0),
        ],
        child,
      ],
    );

    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x16000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x1F000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 10.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.handmade,
          grainOpacity: 0.06,
        ),
      ),
      child: content,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 12. PaperTicketCard
// =============================================================================

/// Paper coupon/ticket voucher with detachable perforated stub cutouts and tear line.
class PaperTicketCard extends StatelessWidget {
  final Widget child;
  final Widget? stub;
  final Color backgroundColor;
  final double cutoutRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const PaperTicketCard({
    super.key,
    required this.child,
    this.stub,
    this.backgroundColor = const Color(0xFFFFFDF7),
    this.cutoutRadius = 16.0,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      shadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(0, 3),
          blurRadius: 8,
        ),
      ],
      config: DynamicShapeConfig(
        type: DynamicShapeType.ticketScallop,
        cornerRadius: 8.0,
        scallopRadius: cutoutRadius,
        creativeBorder: CreativeBorderConfig.perforated(
          color: const Color(0x33000000),
          spacing: 8.0,
        ),
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.cardstock,
          grainOpacity: 0.05,
        ),
      ),
      child: stub != null
          ? Row(
              children: [
                Expanded(child: child),
                Container(
                  width: 1.0,
                  height: 48.0,
                  color: const Color(0x33000000),
                  margin: const EdgeInsets.symmetric(horizontal: 14.0),
                ),
                stub!,
              ],
            )
          : child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// Backward-Compatibility Preset: CouponCard
// =============================================================================

/// Coupon voucher card with dashed perforations and corner notch cutouts.
class CouponCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CouponCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: Colors.white,
      config: const DynamicShapeConfig(
        type: DynamicShapeType.ticketScallop,
        scallopRadius: 14.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.couponEdge,
          width: 1.5,
          color: Color(0xFFB0BEC5),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
