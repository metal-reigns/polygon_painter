import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_drawing_widget.dart';
import 'package:polygon_painter/ui/widgets/polygon_background/painter_background.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_model.dart';

class PolygonPainterWidget extends StatefulWidget {
  const PolygonPainterWidget({super.key});

  @override
  _PolygonPainterWidgetState createState() => _PolygonPainterWidgetState();
}

class _PolygonPainterWidgetState extends State<PolygonPainterWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PolygonProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onPanStart: (details) {
            provider.startDrawing(details.localPosition);
            provider.selectPoint(details.localPosition);
          },
          onPanUpdate: (details) {
            provider.updateDrawing(details.localPosition);
            provider.moveSelectedPoint(details.localPosition);
          },
          onPanEnd: (details) {
            provider.endDrawing();
            provider.releaseSelectedPoint();
          },
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: PolygonDrawingWidget(
                    points: provider.points,
                    getLineLength: provider.getLineLength,
                    temporaryPoint: provider.temporaryPoint,
                    isClosed: provider.isPolygonClosed(),
                  ),
                  child: const PainterBackgroundWidget(),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: provider.undo,
                      icon: const Icon(Icons.undo),
                    ),
                    IconButton(
                      onPressed: provider.clearDrawing,
                      icon: const Icon(Icons.clear),
                    ),
                    IconButton(
                        onPressed: provider.redo, icon: const Icon(Icons.redo)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
