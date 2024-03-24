import 'package:flutter/material.dart';

class PainterBackgroundWidget extends StatelessWidget {
  const PainterBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: PainterBackground(context),
        );
      },
    );
  }
}

class PainterBackground extends CustomPainter {
  final BuildContext context;
  PainterBackground(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blueGrey
      ..strokeCap = StrokeCap.round;

    double dotSize = 1.5; // Размер точки
    // Расстояние между точками адаптируется к ширине и высоте экрана
    double stepX = size.width / MediaQuery.of(context).size.width * 15;
    double stepY = size.height / MediaQuery.of(context).size.height * 20;

    for (double x = 0; x <= size.width; x += stepX) {
      for (double y = 0; y <= size.height; y += stepY) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
