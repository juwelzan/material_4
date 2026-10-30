import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FluidWaveBottomBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const FluidWaveBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<FluidWaveBottomBar> createState() => _FluidWaveBottomBarState();
}

class _FluidWaveBottomBarState extends State<FluidWaveBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _waveAnim;
  double _prevIndex = 0.0;
  double _targetIndex = 0.0;

  final List<_NavItem> _items = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'My Leave'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _targetIndex = widget.selectedIndex.toDouble();
    _prevIndex = _targetIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _waveAnim = Tween<double>(begin: _prevIndex, end: _targetIndex).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant FluidWaveBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _prevIndex = _waveAnim.value;
      _targetIndex = widget.selectedIndex.toDouble();
      _waveAnim = Tween<double>(begin: _prevIndex, end: _targetIndex).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated fluid wave accent painter
          AnimatedBuilder(
            animation: _waveAnim,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(double.infinity, 24),
                painter: _BottomWavePainter(
                  itemCount: _items.length,
                  activeIndexProgress: _waveAnim.value,
                  activeColor: const Color(0xFF5E43EE),
                  inactiveColor: const Color(0x225E43EE),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 2,
              bottom: bottomPadding > 0 ? bottomPadding : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final isSelected = widget.selectedIndex == index;
                final item = _items[index];
                return GestureDetector(
                  onTap: () => widget.onItemSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 22,
                          color: isSelected
                              ? const Color(0xFF5E43EE)
                              : const Color(0xFF9E9EA7),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF222222)
                                : const Color(0xFF9E9EA7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _BottomWavePainter extends CustomPainter {
  final int itemCount;
  final double activeIndexProgress;
  final Color activeColor;
  final Color inactiveColor;

  const _BottomWavePainter({
    required this.itemCount,
    required this.activeIndexProgress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / itemCount;
    final activeCenterX = (activeIndexProgress + 0.5) * itemWidth;

    // Draw base subtle horizontal guide line
    final baseLinePaint = Paint()
      ..color = const Color(0x12000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(16, size.height * 0.5),
      Offset(size.width - 16, size.height * 0.5),
      baseLinePaint,
    );

    // Draw fluid organic wave around the active item
    final wavePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final halfSpan = itemWidth * 0.45;
    final startX = activeCenterX - halfSpan;
    final endX = activeCenterX + halfSpan;
    final baseY = size.height * 0.5;

    path.moveTo(startX, baseY);
    // Smooth dip and rise wave crest
    path.cubicTo(
      activeCenterX - halfSpan * 0.45,
      baseY + 11.0,
      activeCenterX - halfSpan * 0.15,
      baseY - 9.0,
      activeCenterX,
      baseY - 9.0,
    );
    path.cubicTo(
      activeCenterX + halfSpan * 0.15,
      baseY - 9.0,
      activeCenterX + halfSpan * 0.45,
      baseY + 11.0,
      endX,
      baseY,
    );

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) {
    return oldDelegate.activeIndexProgress != activeIndexProgress ||
        oldDelegate.activeColor != activeColor;
  }
}
