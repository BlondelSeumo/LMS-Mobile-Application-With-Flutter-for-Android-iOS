import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget placeholder(height, width) {
  return Container(
    height: height,
    width: width,
    child: CustomPaint(
      painter: CircleBorder(
          strokeColor: Color(0xFF3F4654).withOpacity(0.6), strokeWidth: 3),
      child: Center(
        child: Icon(
          FontAwesomeIcons.question,
          color: Color(0xFF3F4654).withOpacity(0.6),
          size: 19,
        ),
      ),
    ),
  );
}

class CircleBorder extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  CircleBorder(
      {this.strokeColor = Colors.black,
        this.strokeWidth = 3,
        this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(35, 35), paint);
  }

  num degToRad(num deg) => deg * ((3.14) / 180.0);

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(x / 2 + 3, y / 2 - 18)
      ..arcToPoint(Offset(x / 2 + 22, y / 2 + 1), radius: Radius.circular(20))
      ..moveTo(x / 2 + 22, y / 2 + 4)
      ..arcToPoint(Offset(x / 2 - 18, y / 2 + 4), radius: Radius.circular(20))
      ..moveTo(x / 2 - 18, y / 2)
      ..arcToPoint(Offset(x / 2, y / 2 - 18), radius: Radius.circular(20));
  }

  @override
  bool shouldRepaint(CircleBorder oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}