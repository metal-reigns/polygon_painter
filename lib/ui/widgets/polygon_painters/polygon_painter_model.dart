import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  final Offset? temporaryPoint;
  final bool isClosed;
  final Function(Offset, Offset) getLineLength;

  PolygonPainter({
    required this.points,
    required this.getLineLength,
    this.temporaryPoint,
    this.isClosed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
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

        // Расчет и отображение длины каждого отрезка
        final textSpan = TextSpan(
          text: '${(points[i] - points[i - 1]).distance.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.black, fontSize: 12),
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

    // Замыкание и заливка фигуры, если она замкнута
    if (isClosed && points.isNotEmpty) {
      path.close();
      paint.color = Colors.white;
      paint.style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      paint.color = Colors.black;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(path, paint);
    }

    // Рисование временной линии и отображение её длины
    if (temporaryPoint != null && points.isNotEmpty) {
      paint.color = Colors.black;
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(points.last, temporaryPoint!, paint);

      final textSpan = TextSpan(
        text: (points.last - temporaryPoint!).distance.toStringAsFixed(2),
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );
      textPainter.text = textSpan;
      textPainter.layout();
      final midPoint = Offset(
        (points.last.dx + temporaryPoint!.dx) / 2,
        (points.last.dy + temporaryPoint!.dy) / 2,
      );
      textPainter.paint(canvas,
          midPoint - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    // Рисуем точки поверх всего
    for (var point in points) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.black);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
