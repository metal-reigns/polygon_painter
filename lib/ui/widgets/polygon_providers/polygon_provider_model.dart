import 'package:flutter/material.dart';

class PolygonProvider with ChangeNotifier {
  List<Offset> _points = [];
  Offset? _temporaryPoint; // Для рисования временной линии

  List<Offset> get points => _points;
  Offset? get temporaryPoint => _temporaryPoint;

  // Начинаем рисование новой линии
  void startDrawing(Offset point) {
    if (!isPolygonClosed()) {
      _temporaryPoint = point;
      notifyListeners();
    }
  }

  // Обновляем текущую рисуемую линию
  void updateDrawing(Offset point) {
    _temporaryPoint = point;
    notifyListeners();
  }

  // Завершаем рисование линии и добавляем новую точку
  // void endDrawing() {
  //   if (_temporaryPoint != null) {
  //     // Проверяем, достаточно ли точек для создания линии и не вызовет ли добавление новой точки пересечение
  //     if (_points.length > 1 &&
  //         _isLineCrossWithOthers(_temporaryPoint!, _points.length - 2)) {
  //       // Если новая линия пересекается, не добавляем точку
  //       _temporaryPoint = null;
  //     } else {
  //       // Если все хорошо, добавляем точку
  //       _points.add(_temporaryPoint!);
  //       _temporaryPoint = null;
  //     }
  //     notifyListeners();
  //   }
  // }

  void endDrawing() {
    if (_temporaryPoint != null) {
      if (_isClosingFigure(_temporaryPoint!)) {
        _points.add(_points.first);
        notifyListeners();
      } else if (!_isLineCrossWithOthers(
          _temporaryPoint!, _points.length - 1)) {
        _points.add(_temporaryPoint!);
        notifyListeners();
      }
      _temporaryPoint = null;
    }
  }

  bool _isClosingFigure(Offset point) {
    if (_points.isEmpty) return false;
    return (point - _points.first).distance <
        30.0; // Пороговое значение для замыкания фигуры
  }

  // Добавляем точку
  void addPoint(Offset point) {
    _points.add(point);
    notifyListeners();
  }

  // Удаляем последнюю точку
  void removeLastPoint() {
    if (_points.isNotEmpty) {
      _points.removeLast();
      notifyListeners();
    }
  }

  // Проверяем, создаст ли новая линия пересечение с уже существующими линиями
  bool _isLineCrossWithOthers(Offset newPoint, int ignoreIndex) {
    if (_points.length < 2)
      return false; // Нужно минимум две точки для сравнения

    for (int i = 0; i < _points.length - 1; i++) {
      if (i != ignoreIndex && i + 1 != ignoreIndex) {
        if (_isLineCross(
            _points[i], _points[i + 1], _points[ignoreIndex], newPoint)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isLineCross(Offset p1, Offset p2, Offset p3, Offset p4) {
    double denominator =
        (p4.dy - p3.dy) * (p2.dx - p1.dx) - (p4.dx - p3.dx) * (p2.dy - p1.dy);

    // Если знаменатель равен нулю, линии параллельны или совпадают
    if (denominator == 0) return false;

    double ua = ((p4.dx - p3.dx) * (p1.dy - p3.dy) -
            (p4.dy - p3.dy) * (p1.dx - p3.dx)) /
        denominator;
    double ub = ((p2.dx - p1.dx) * (p1.dy - p3.dy) -
            (p2.dy - p1.dy) * (p1.dx - p3.dx)) /
        denominator;

    return (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1);
  }

  // Проверяем, замкнут ли многоугольник
  bool isPolygonClosed() {
    return _points.isNotEmpty && _points.first == _points.last;
  }

  // Получаем длину линии между двумя точками
  double getLineLength(int index) {
    if (index < 0 || index >= _points.length - 1) return 0.0;
    return (_points[index] - _points[index + 1]).distance;
  }
}
