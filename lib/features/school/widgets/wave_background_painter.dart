import 'package:flutter/material.dart';

/// Paints delicate, translucent fluid wave lines in the background
/// of hero cards (like the UP NEXT physics card).
class WaveBackgroundPainter extends CustomPainter {
  final Color waveColor;

  const WaveBackgroundPainter({this.waveColor = const Color(0x22FFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // First fluid organic wave
    final path1 = Path();
    path1.moveTo(size.width * 0.55, 0);
    path1.cubicTo(
      size.width * 0.65,
      size.height * 0.4,
      size.width * 0.85,
      size.height * 0.3,
      size.width * 1.05,
      size.height * 0.7,
    );
    canvas.drawPath(path1, paint);

    // Second fluid organic wave
    final paint2 = Paint()
      ..color = waveColor.withValues(alpha: waveColor.a * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path2 = Path();
    path2.moveTo(size.width * 0.70, 0);
    path2.cubicTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width * 0.90,
      size.height * 0.5,
      size.width * 1.15,
      size.height * 0.9,
    );
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
