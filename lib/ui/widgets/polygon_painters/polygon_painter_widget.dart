import 'package:flutter/material.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_model.dart';
import 'package:polygon_painter/ui/widgets/polygon_providers/polygon_provider_model.dart';
import 'package:provider/provider.dart';

class PolygonDrawingWidget extends StatefulWidget {
  @override
  _PolygonDrawingWidgetState createState() => _PolygonDrawingWidgetState();
}

class _PolygonDrawingWidgetState extends State<PolygonDrawingWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PolygonProvider>(context);
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
          child: CustomPaint(
            painter: PolygonPainter(
              points: provider.points,
              getLineLength: provider.getLineLength,
              temporaryPoint: provider.temporaryPoint,
              isClosed: provider.isPolygonClosed(),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        );
      },
    );
  }
}
