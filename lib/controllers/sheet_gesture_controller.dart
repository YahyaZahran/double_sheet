import 'package:flutter/material.dart';
import '../models/double_sheet_config.dart';

class SheetGestureController extends ChangeNotifier {
  final DoubleSheetConfig config;
  final VoidCallback? onClose;

  double _sheetPosition;
  double _headerPosition = 0.0;
  double _headerOpacity = 1.0;
  bool _isDragging = false;
  double _dragStartY = 0.0;
  double _dragStartPosition = 0.0;

  static const double _headerRange = 120.0;
  static const double _headerMovementMultiplier = 0.8;

  SheetGestureController({required this.config, this.onClose})
    : _sheetPosition = config.initialChildSize;

  double get sheetPosition => _sheetPosition;
  double get headerPosition => _headerPosition;
  double get headerOpacity => _headerOpacity;
  bool get isDragging => _isDragging;

  void onPanStart(DragStartDetails details) {
    if (!config.enableDrag) return;

    _isDragging = true;
    _dragStartY = details.globalPosition.dy;
    _dragStartPosition = _sheetPosition;
  }

  void onPanUpdate(DragUpdateDetails details, BuildContext context) {
    if (!config.enableDrag || !_isDragging) return;

    final deltaY = details.globalPosition.dy - _dragStartY;
    _updatePositions(deltaY, context);
  }

  void onPanEnd(DragEndDetails details) {
    if (!config.enableDrag) return;

    _isDragging = false;
    _snapToClosestPosition();
  }

  void _updatePositions(double deltaY, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetDelta = -deltaY / screenHeight;

    final newSheetPosition = (_dragStartPosition + sheetDelta).clamp(
      0.0,
      config.effectiveMaxChildSize,
    );
    final headerDelta = -deltaY * _headerMovementMultiplier;
    final newHeaderPosition = (0.0 + headerDelta).clamp(-_headerRange, 0.0);
    final newHeaderOpacity = (1.0 + newHeaderPosition / _headerRange).clamp(
      0.0,
      1.0,
    );

    if (newSheetPosition < config.minChildSize * 0.5) {
      dismiss();
      return;
    }

    final hasChanged =
        (_sheetPosition - newSheetPosition).abs() > 0.001 ||
        (_headerPosition - newHeaderPosition).abs() > 0.001 ||
        (_headerOpacity - newHeaderOpacity).abs() > 0.001;

    if (hasChanged) {
      _sheetPosition = newSheetPosition;
      _headerPosition = newHeaderPosition;
      _headerOpacity = newHeaderOpacity;
      notifyListeners();
    }
  }

  void _snapToClosestPosition() {
    if (_sheetPosition < config.minChildSize + 0.1) {
      dismiss();
    } else if (_sheetPosition <
        (config.minChildSize + config.initialChildSize) / 2) {
      _animateToPosition(config.minChildSize);
    } else if (_sheetPosition <
        (config.initialChildSize + config.effectiveMaxChildSize) / 2) {
      _animateToPosition(config.initialChildSize);
    } else {
      _animateToPosition(config.effectiveMaxChildSize);
    }
  }

  void _animateToPosition(double targetPosition) {
    _sheetPosition = targetPosition;
    _headerPosition = 0.0;
    _headerOpacity = 1.0;
    notifyListeners();
  }

  void setPosition(double position) {
    final newPosition = position.clamp(
      config.minChildSize,
      config.effectiveMaxChildSize,
    );
    if ((_sheetPosition - newPosition).abs() > 0.001) {
      _sheetPosition = newPosition;
      _headerPosition = 0.0;
      _headerOpacity = 1.0;
      notifyListeners();
    }
  }

  void animateToPosition(double targetPosition, {Duration? duration}) {
    final newPosition = targetPosition.clamp(
      config.minChildSize,
      config.effectiveMaxChildSize,
    );
    _animateToPosition(newPosition);
  }

  bool canHandleGesture() {
    return config.enableDrag && !isDragging;
  }

  void dismiss() {
    onClose?.call();
  }
}
