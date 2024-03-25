import 'package:flutter/material.dart';

class PolygonDrawingWidget extends CustomPainter {
  final List<Offset> points;
  final Offset? temporaryPoint;
  final bool isClosed;
  final Function(Offset, Offset) getLineLength;

  PolygonDrawingWidget({
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

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    var path = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
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

    // Расчет и отображение длины каждого отрезка
    if (temporaryPoint != null && points.isNotEmpty) {
      canvas.drawLine(points.last, temporaryPoint!, paint);
    }
    for (int i = 0; i < points.length - 1; i++) {
      final distance = (points[i] - points[i + 1]).distance;
      final textSpan = TextSpan(
        text: distance.toStringAsFixed(2),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          backgroundColor: Colors.white,
        ),
      );
      textPainter.text = textSpan;
      textPainter.layout();

      final midPoint = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        (points[i].dy + points[i + 1].dy) / 2,
      );
      textPainter.paint(canvas,
          midPoint - Offset(textPainter.width / 2, textPainter.height / 2));
    }
    // Рисование временной линии и отображение её длины
    if (temporaryPoint != null && points.isNotEmpty) {
      final distance = (points.last - temporaryPoint!).distance;
      final textSpan = TextSpan(
        text: distance.toStringAsFixed(2),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          backgroundColor: Colors.white,
        ),
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

    // Рисование точек поверх всего
    for (var point in points) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.black);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
