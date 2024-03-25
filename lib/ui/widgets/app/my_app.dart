import 'package:flutter/material.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polygon Drawer',
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Draw a Polygon'),
        ),
        body: const PolygonPainterWidget(),
      ),
    );
  }
}
