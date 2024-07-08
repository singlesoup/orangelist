import 'package:flutter/material.dart';

class StrikeThroughPainter extends CustomPainter {
  final String text;
  final double progress;
  final TextStyle textStyle;
  final Color strikeColor;
  final double strokeThickness;

  StrikeThroughPainter({
    required this.text,
    required this.progress,
    required this.textStyle,
    required this.strikeColor,
    this.strokeThickness = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // Center the text within the available space
    const offsetX = 0.0;
    final offsetY = (size.height - textHeight) / 2;

    textPainter.paint(canvas, Offset(offsetX, offsetY));

    final double strikeThroughY = offsetY + textHeight / 2;
    const double strikeThroughStartX = offsetX;
    final double strikeThroughEndX = offsetX + textWidth * progress;

    final paint = Paint()
      ..color = strikeColor
      ..strokeWidth = strokeThickness;

    canvas.drawLine(
      Offset(strikeThroughStartX, strikeThroughY),
      Offset(strikeThroughEndX, strikeThroughY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
