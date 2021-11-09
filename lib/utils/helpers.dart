import 'package:flutter/material.dart';

class MyPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
  final p1 = Offset(0, 50);
  final p2 = Offset(0, 200);
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;
  canvas.drawLine(p1, p2, paint);
}
  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
class DrawCurveLeft extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
  final p1 = Offset(-20, 180);
  final p2 = Offset(0, 200);
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;
  canvas.drawLine(p1, p2, paint);
}
  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
class DrawCurveRight extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
  final p1 = Offset(20, 180);
  final p2 = Offset(0, 200);
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;
  canvas.drawLine(p1, p2, paint);
}
  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}


