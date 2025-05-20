import 'dart:ui';
import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    final thirdWidth = size.width / 3;
    final thirdHeight = size.height / 3;

    // Garis vertikal
    canvas.drawLine(
        Offset(thirdWidth, 0), Offset(thirdWidth, size.height), paint);
    canvas.drawLine(
        Offset(2 * thirdWidth, 0), Offset(2 * thirdWidth, size.height), paint);

    // Garis horizontal
    canvas.drawLine(
        Offset(0, thirdHeight), Offset(size.width, thirdHeight), paint);
    canvas.drawLine(
        Offset(0, 2 * thirdHeight), Offset(size.width, 2 * thirdHeight), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
