import 'package:flutter/material.dart';

class PolygonProvider with ChangeNotifier {
  List<Offset> _points = [];
  List<Offset> get points => _points;
  List<Offset> _redoStack = [];

  Offset? _temporaryPoint; // Для рисования временной линии

  Offset? get temporaryPoint => _temporaryPoint;

  // Начинаем рисование новой линии
  void startDrawing(Offset point) {
    if (!isPolygonClosed()) {
      _temporaryPoint = point;
      _redoStack.clear();
      notifyListeners();
    }
  }

  void undo() {
    if (_points.isNotEmpty) {
      _redoStack.add(_points.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _points.add(_redoStack.removeLast());
      notifyListeners();
    }
  }

  void clearDrawing() {
    _points.clear();
    _redoStack.clear();
    notifyListeners();
  }

  // Обновляем текущую рисуемую линию
  void updateDrawing(Offset point) {
    _temporaryPoint = point;
    notifyListeners();
  }

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
    return (point - _points.first).distance < 30.0;
  }

  // Проверяем, создаст ли новая линия пересечение с уже существующими линиями
  bool _isLineCrossWithOthers(Offset newPoint, int ignoreIndex) {
    if (_points.length < 2) {
      return false;
    }

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
  double getLineLength(Offset p1, Offset p2) {
    return (p1 - p2).distance;
  }
}
