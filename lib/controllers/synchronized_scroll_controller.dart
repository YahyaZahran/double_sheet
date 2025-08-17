import 'package:flutter/material.dart';
import '../models/double_sheet_config.dart';
import 'sheet_gesture_controller.dart';

class SynchronizedScrollController extends ChangeNotifier {
  final DoubleSheetConfig config;
  final SheetGestureController sheetController;
  final VoidCallback? onClose;

  ScrollController? _contentScrollController;
  bool _isContentAtTop = true;
  bool _isHandlingSync = false;
  bool _enableSynchronization = true;
  double _lastScrollOffset = 0.0;

  static const double _scrollThreshold = 5.0;
  static const double _topThreshold = 10.0;

  SynchronizedScrollController({
    required this.config,
    required this.sheetController,
    this.onClose,
    bool enableSynchronization = true,
  }) : _enableSynchronization = enableSynchronization {
    sheetController.addListener(_onSheetPositionChanged);
  }

  bool get enableSynchronization => _enableSynchronization;
  bool get isContentAtTop => _isContentAtTop;
  bool get isSheetAtMax =>
      sheetController.sheetPosition >= config.effectiveMaxChildSize - 0.01;
  bool get isSheetAtMin =>
      sheetController.sheetPosition <= config.minChildSize + 0.01;

  void setContentScrollController(ScrollController controller) {
    _contentScrollController?.removeListener(_onContentScrollChanged);
    _contentScrollController = controller;
    _contentScrollController?.addListener(_onContentScrollChanged);
    _updateContentAtTopState();
  }

  void setSynchronizationEnabled(bool enabled) {
    if (_enableSynchronization != enabled) {
      _enableSynchronization = enabled;
      notifyListeners();
    }
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (!_enableSynchronization || _isHandlingSync) {
      return false;
    }

    if (notification is ScrollStartNotification) {
      _lastScrollOffset = notification.metrics.pixels;
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      return _handleScrollUpdate(notification);
    }

    return false;
  }

  bool _handleScrollUpdate(ScrollUpdateNotification notification) {
    final currentOffset = notification.metrics.pixels;
    final deltaY = currentOffset - _lastScrollOffset;
    final isScrollingDown = deltaY > 0;
    final isScrollingUp = deltaY < 0;

    if (deltaY.abs() < _scrollThreshold) {
      return false;
    }

    _updateContentAtTopState();

    if (isScrollingDown && _isContentAtTop && !isSheetAtMax) {
      return _handleExpandSheetFirst(deltaY);
    }

    if (isScrollingUp && _isContentAtTop && !isSheetAtMin) {
      return _handleCollapseSheetFirst(deltaY);
    }

    _lastScrollOffset = currentOffset;
    return false;
  }

  bool _handleExpandSheetFirst(double deltaY) {
    _isHandlingSync = true;

    final screenHeight = _getScreenHeight();
    if (screenHeight <= 0) {
      _isHandlingSync = false;
      return false;
    }

    final sheetDelta = deltaY / screenHeight;
    final newSheetPosition = (sheetController.sheetPosition + sheetDelta).clamp(
      config.minChildSize,
      config.effectiveMaxChildSize,
    );

    if ((newSheetPosition - sheetController.sheetPosition).abs() > 0.001) {
      sheetController.setPosition(newSheetPosition);

      if (_contentScrollController != null &&
          _contentScrollController!.hasClients) {
        _contentScrollController!.jumpTo(0);
      }

      _isHandlingSync = false;
      return true;
    }

    _isHandlingSync = false;
    return false;
  }

  bool _handleCollapseSheetFirst(double deltaY) {
    _isHandlingSync = true;

    final screenHeight = _getScreenHeight();
    if (screenHeight <= 0) {
      _isHandlingSync = false;
      return false;
    }

    final sheetDelta = deltaY / screenHeight;
    final newSheetPosition = (sheetController.sheetPosition + sheetDelta).clamp(
      config.minChildSize,
      config.effectiveMaxChildSize,
    );

    if ((newSheetPosition - sheetController.sheetPosition).abs() > 0.001) {
      sheetController.setPosition(newSheetPosition);

      if (_contentScrollController != null &&
          _contentScrollController!.hasClients) {
        _contentScrollController!.jumpTo(0);
      }

      _isHandlingSync = false;
      return true;
    }

    _isHandlingSync = false;
    return false;
  }

  void _updateContentAtTopState() {
    if (_contentScrollController?.hasClients == true) {
      final offset = _contentScrollController!.offset;
      final wasAtTop = _isContentAtTop;
      _isContentAtTop = offset <= _topThreshold;

      if (wasAtTop != _isContentAtTop) {
        notifyListeners();
      }
    }
  }

  void _onContentScrollChanged() {
    _updateContentAtTopState();
  }

  void _onSheetPositionChanged() {
    notifyListeners();
  }

  double _getScreenHeight() {
    final context = _getCurrentContext();
    if (context != null) {
      return MediaQuery.of(context).size.height;
    }
    return 800.0;
  }

  BuildContext? _getCurrentContext() {
    return _contentScrollController?.position.context.storageContext;
  }

  @override
  void dispose() {
    _contentScrollController?.removeListener(_onContentScrollChanged);
    sheetController.removeListener(_onSheetPositionChanged);
    super.dispose();
  }
}
