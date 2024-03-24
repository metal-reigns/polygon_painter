import 'package:flutter/material.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/painter_background.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_model.dart';
import 'package:polygon_painter/ui/widgets/polygon_providers/polygon_provider_model.dart';
import 'package:provider/provider.dart';

class PolygonDrawingWidget extends StatefulWidget {
  const PolygonDrawingWidget({super.key});

  @override
  _PolygonDrawingWidgetState createState() => _PolygonDrawingWidgetState();
}

class _PolygonDrawingWidgetState extends State<PolygonDrawingWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PolygonProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onPanStart: (details) {
            provider.startDrawing(details.localPosition);
          },
          onPanUpdate: (details) {
            provider.updateDrawing(details.localPosition);
          },
          onPanEnd: (details) {
            provider.endDrawing();
          },
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: PolygonPainter(
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
