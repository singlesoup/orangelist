import 'dart:math';

import 'package:flutter/material.dart';
import 'package:orangelist/src/theme/colors.dart';

class OnBoardProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final int onBoardsNum;
  final double completePercent;
  OnBoardProgressPainter({
    this.strokeWidth = 1.0,
    this.color = themeColorLight,
    required this.onBoardsNum,
    required this.completePercent,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color
      ..style = PaintingStyle.stroke;

    final Paint complete = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.amber
      ..style = PaintingStyle.stroke;

    double arcAngle = (360 / onBoardsNum) * (completePercent / 100);

    drawArc(
      canvas: canvas,
      size: size,
      paint: paint,
      color: Colors.grey,
    );
    drawArc(
      canvas: canvas,
      size: size,
      paint: complete,
      color: Colors.amber,
      arcAngle: arcAngle,
    );
  }

  void drawArc(
      {required Canvas canvas,
      required Size size,
      required Paint paint,
      required Color color,
      double? arcAngle}) {
    double degree = 90;
    double arc = 360 / onBoardsNum;
    int gapBetnArc = 6;
    for (var i = 0; i < onBoardsNum; i++) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height - 40),
          width: size.width,
          height: size.height,
        ),
        degreeToRadianAngle(degree + gapBetnArc),
        degreeToRadianAngle(arcAngle ?? arc - (2 * gapBetnArc)),
        false,
        paint,
      );
      degree += arc;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

degreeToRadianAngle(double degree) {
  return degree * (pi / 180);
}
