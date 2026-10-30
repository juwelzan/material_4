import 'package:flutter/material.dart';

/// Paints the organic S-curved timetable progress track with start/end nodes.
class TimelineTrackPainter extends CustomPainter {
  final Color trackColor;
  final Color nodeColor;

  const TimelineTrackPainter({
    this.trackColor = const Color(0xFFD7A779),
    this.nodeColor = const Color(0xFF8B5E3C),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Organic double-line or thick stroke path
    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(w * 0.35, 4);
    path.cubicTo(w * 0.95, h * 0.32, w * 0.05, h * 0.68, w * 0.65, h - 4);

    // Draw track glow / casing
    canvas.drawPath(path, trackPaint);
    // Draw inner crisp line
    canvas.drawPath(path, innerPaint);

    // Start node dot
    final dotPaint = Paint()..color = nodeColor;
    canvas.drawCircle(Offset(w * 0.35, 4), 3.0, dotPaint);

    // End node dot
    canvas.drawCircle(Offset(w * 0.65, h - 4), 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
