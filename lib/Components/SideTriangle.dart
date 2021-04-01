import 'package:flutter/material.dart';

class SideTrianglePainter extends CustomPainter {
  final Color color;
  SideTrianglePainter({this.color});

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
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      // ..cubicTo(width, height - 6, width, height, width - 6, height - 6)
      ..lineTo(size.width / 2, size.height / 2)
      ..cubicTo(halfwidth + 6, halfheight + 6, halfwidth, halfheight,
          halfwidth + 6, halfheight - 6)
      ..lineTo(size.width, 0);
    // ..cubicTo(width - 6, 6, width, 0, width, 6);

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

// class SideTrianglePainter extends CustomPainter {
//   Color color;
//   SideTrianglePainter({@required this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = new Paint()
//       ..color = color
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//     var path = Path();
//     final double startPoint = size.width * 0.2;
//     final double rheight = 30;
//     path.moveTo(startPoint, rheight);
//     path.lineTo(startPoint + 20, 5);
//     path.cubicTo(startPoint + 23, 0, startPoint + 26, 0, startPoint + 29, 0);
//     path.lineTo(startPoint + 50, rheight);
//     path.moveTo(10, rheight);
//     path.lineTo(startPoint, rheight);
//     path.moveTo(startPoint + 50, rheight);
//     path.lineTo(size.width - 10, rheight);
//     path.cubicTo(size.width, rheight + 5, size.width, rheight + 10, size.width,
//         rheight + 15);
//     path.lineTo(size.width, size.height - 15);
//     path.moveTo(10, rheight);
//     path.cubicTo(0, rheight + 5, 0, rheight + 10, 0, rheight + 15);
//     path.lineTo(0, size.height - 10);
//     path.cubicTo(5, size.height, 10, size.height, 15, size.height);
//     path.moveTo(15, size.height);
//     path.lineTo(size.width - 10, size.height);
//     path.cubicTo(size.width, size.height - 5, size.width, size.height - 10,
//         size.width, size.height - 15);
//     path.moveTo(size.width - 5, size.height);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
