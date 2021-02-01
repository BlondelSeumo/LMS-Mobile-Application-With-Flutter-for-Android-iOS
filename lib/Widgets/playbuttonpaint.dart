import 'package:flutter/material.dart';

class PlayButtonBorder extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  PlayButtonBorder(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(x / 2 - 6, y - 33)
      ..lineTo(x / 2 + 11, y - 22)
      ..lineTo(x / 2 - 6, y - 12)
      ..lineTo(x / 2 - 6, y - 33);
  }

  @override
  bool shouldRepaint(PlayButtonBorder oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
