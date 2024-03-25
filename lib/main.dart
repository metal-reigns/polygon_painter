import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:polygon_painter/ui/widgets/app/my_app.dart';
import 'package:polygon_painter/ui/widgets/polygon_painters/polygon_painter_model.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => PolygonProvider(),
        child: const MyApp(),
      ),
    );
