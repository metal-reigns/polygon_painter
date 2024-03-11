import 'package:flutter/material.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polygon Drawer',
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Draw a Polygon'),
        ),
        body: PolygonDrawingWidget(),
      ),
    );
  }
}
