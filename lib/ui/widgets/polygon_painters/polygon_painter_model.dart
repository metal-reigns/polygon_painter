import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  final Offset? temporaryPoint;
  final bool isClosed;
  final Function(int) getLineLength;

  PolygonPainter({
    required this.points,
    required this.getLineLength,
    this.temporaryPoint,
    this.isClosed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isClosed ? Colors.white : Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    var path = Path();
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);

        // Отображение длины линии
        final textSpan = TextSpan(
          text: '${getLineLength(i - 1).toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.black, fontSize: 12),
        );
        textPainter.text = textSpan;
        textPainter.layout();
        final midPoint = Offset(
          (points[i].dx + points[i - 1].dx) / 2,
          (points[i].dy + points[i - 1].dy) / 2,
        );
        textPainter.paint(canvas,
            midPoint - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }

    if (temporaryPoint != null && points.isNotEmpty) {
      path.lineTo(temporaryPoint!.dx, temporaryPoint!.dy);
    }

    canvas.drawPath(path, paint);

    for (var point in points) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.black);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
