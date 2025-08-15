import 'package:flutter/material.dart';

// Custom synchronized double sheet widget
class _SynchronizedDoubleSheet extends StatefulWidget {
  final String title;
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final TextStyle? titleStyle;
  final bool enableDrag;
  final bool isDismissible;
  final bool showDragHandle;
  final VoidCallback? onClose;

  const _SynchronizedDoubleSheet({
    required this.title,
    required this.child,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.titleStyle,
    this.enableDrag = true,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.onClose,
  });

  @override
  State<_SynchronizedDoubleSheet> createState() => _SynchronizedDoubleSheetState();
}

class _SynchronizedDoubleSheetState extends State<_SynchronizedDoubleSheet> {
  late double _sheetPosition;
  late double _headerPosition;
  double _headerOpacity = 1.0;
  bool _isDragging = false;
  double _dragStartY = 0.0;
  double _dragStartPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _sheetPosition = widget.initialChildSize;
    _headerPosition = 0.0;
  }

  void _updatePositions(double deltaY) {
    setState(() {
      // Update sheet position based on drag
      final screenHeight = MediaQuery.of(context).size.height;
      final sheetDelta = -deltaY / screenHeight;
      _sheetPosition = (_dragStartPosition + sheetDelta).clamp(0.0, widget.maxChildSize);
      
      // Update header position directly based on drag distance
      // Header range is 120px, make it move proportionally to drag
      final headerRange = 120.0;
      final headerDelta = -deltaY * 0.8; // Negative to make header move opposite to drag
      _headerPosition = (0.0 + headerDelta).clamp(-headerRange, 0.0);
      
      // Calculate opacity based on header position
      _headerOpacity = (1.0 + _headerPosition / headerRange).clamp(0.0, 1.0);
      
      // Auto-dismiss if dragged too low
      if (_sheetPosition < widget.minChildSize * 0.5) {
        _dismiss();
      }
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.enableDrag) return;
    _isDragging = true;
    _dragStartY = details.globalPosition.dy;
    _dragStartPosition = _sheetPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag || !_isDragging) return;
    
    final deltaY = details.globalPosition.dy - _dragStartY;
    _updatePositions(deltaY);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.enableDrag) return;
    _isDragging = false;
    
    // Snap to closest position
    if (_sheetPosition < widget.minChildSize + 0.1) {
      _dismiss();
    } else if (_sheetPosition < (widget.minChildSize + widget.initialChildSize) / 2) {
      _animateToPosition(widget.minChildSize);
    } else if (_sheetPosition < (widget.initialChildSize + widget.maxChildSize) / 2) {
      _animateToPosition(widget.initialChildSize);
    } else {
      _animateToPosition(widget.maxChildSize);
    }
  }

  void _animateToPosition(double targetPosition) {
    // Simple animation without AnimationController for now
    _updatePositions(targetPosition);
  }

  void _dismiss() {
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Stack(
      children: [
        // Header
        Positioned(
          left: 0,
          right: 0,
          top: _headerPosition,
          child: Opacity(
            opacity: _headerOpacity,
            child: Container(
              padding: EdgeInsets.only(
                top: mediaQuery.padding.top,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: widget.headerBackgroundColor ?? theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: widget.titleStyle ??
                            theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _dismiss,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Bottom Sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: screenHeight * _sheetPosition,
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (widget.showDragHandle)
                    Container(
                      height: 32,
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<T?> showDoubleSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  double initialChildSize = 0.4,
  double minChildSize = 0.25,
  double maxChildSize = 0.9,
  Color? backgroundColor,
  Color? headerBackgroundColor,
  TextStyle? titleStyle,
  bool enableDrag = true,
  bool isDismissible = true,
  bool showDragHandle = true,
  bool allowFullScreen = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) {
      return _SynchronizedDoubleSheet(
        title: title,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: allowFullScreen ? 1.0 : maxChildSize,
        backgroundColor: backgroundColor,
        headerBackgroundColor: headerBackgroundColor,
        titleStyle: titleStyle,
        enableDrag: enableDrag,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      );
    },
  );
}

// Alternative widget-based approach for more control
class DoubleSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final TextStyle? titleStyle;
  final bool enableDrag;
  final bool showDragHandle;
  final bool allowFullScreen;
  final VoidCallback? onClose;

  const DoubleSheet({
    super.key,
    required this.title,
    required this.child,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.titleStyle,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.allowFullScreen = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return _SynchronizedDoubleSheet(
      title: title,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: allowFullScreen ? 1.0 : maxChildSize,
      backgroundColor: backgroundColor,
      headerBackgroundColor: headerBackgroundColor,
      titleStyle: titleStyle,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      onClose: onClose,
      child: child,
    );
  }
}