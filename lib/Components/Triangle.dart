import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    var width = size.width;
    var height = size.height;
    var halfwidth = width / 2;
    var halfheight = height / 2;
    path
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      // ..cubicTo(width - 6, 0, width, 0, width - 6, 6)
      ..lineTo(halfwidth, halfheight + 9)
      ..cubicTo(halfwidth + 6, halfheight + 3, halfwidth, halfheight + 9,
          halfwidth - 6, halfheight + 3)
      ..lineTo(0, 0);
    // ..cubicTo(6, 6, 0, 0, 6, 0);
    // path.quadraticBezierTo(size.width * 0.2, size.height * 0.5,
    //     size.width * 0.6, size.height * 0.7);
    // path.quadraticBezierTo(size.width * 0.8, size.height * 0.8,
    //     size.width * 1.0, size.height * 0.51);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate1) {
    return true;
  }
}
