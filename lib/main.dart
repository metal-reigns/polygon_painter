import 'package:flutter/material.dart';
import 'package:polygon_painter/ui/widgets/app/my_app.dart';
import 'package:polygon_painter/ui/widgets/polygon_providers/polygon_provider_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => PolygonProvider(),
        child: MyApp(),
      ),
    );
