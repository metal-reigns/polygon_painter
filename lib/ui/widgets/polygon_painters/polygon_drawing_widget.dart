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
    final paint = _getPaint();
    var path = _getPath();

    _drawPath(canvas, path, paint);
    _drawLinesAndText(canvas, paint);

    // Рисование точек поверх всего
    for (var point in points) {
      canvas.drawCircle(point, 5, paint);
      // canvas.drawCircle(point, 5, Paint()..color = Colors.black);
    }
  }

  Paint _getPaint() {
    return Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
  }

  Path _getPath() {
    var path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      points.skip(1).forEach((point) => path.lineTo(point.dx, point.dy));
      if (isClosed) path.close();
    }
    return path;
  }

  void _drawPath(Canvas canvas, Path path, Paint paint) {
    if (isClosed) {
      // Заливка фигуры, если она замкнута
      canvas.drawPath(
          path,
          paint
            ..color = Colors.white
            ..style = PaintingStyle.fill);
    }
    // Отрисовка контура
    canvas.drawPath(
        path,
        paint
          ..color = Colors.black
          ..style = PaintingStyle.stroke);
  }

  void _drawLinesAndText(Canvas canvas, Paint paint) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Отрисовка линий и их длины
    for (int i = 0; i < points.length; i++) {
      if (i < points.length - 1) {
        _drawTextForLine(canvas, textPainter, points[i], points[i + 1], paint);
      }
      if (temporaryPoint != null && i == points.length - 1) {
        _drawTextForLine(
            canvas, textPainter, points[i], temporaryPoint!, paint);
      }
    }
  }

  void _drawTextForLine(Canvas canvas, TextPainter textPainter, Offset start,
      Offset end, Paint paint) {
    final distance = (start - end).distance;
    final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    textPainter.text = TextSpan(
      text: distance.toStringAsFixed(2),
      style: const TextStyle(
          color: Colors.black, fontSize: 14, backgroundColor: Colors.white),
    );
    textPainter.layout();
    canvas.drawLine(start, end, paint);
    textPainter.paint(canvas,
        midPoint - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
