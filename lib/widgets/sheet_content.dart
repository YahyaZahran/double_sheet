import 'package:flutter/material.dart';

import '../controllers/sheet_gesture_controller.dart';
import '../models/double_sheet_config.dart';
import 'drag_handle.dart';

class SheetContent extends StatelessWidget {
  final DoubleSheetConfig config;
  final SheetGestureController controller;
  final double screenHeight;
  final Widget child;
  final Animation<double>? animation;

  const SheetContent({
    super.key,
    required this.config,
    required this.controller,
    required this.screenHeight,
    required this.child,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = config.backgroundColor ?? theme.colorScheme.surface;
    final borderRadius = config.borderRadius ?? _defaultBorderRadius;
    
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: screenHeight * controller.sheetPosition,
      child: RepaintBoundary(
        child: SlideTransition(
          position: animation != null
              ? _createSlideAnimation(animation!)
              : _staticOffset,
          child: GestureDetector(
            onPanStart: controller.onPanStart,
            onPanUpdate: (details) => controller.onPanUpdate(details, context),
            onPanEnd: controller.onPanEnd,
            child: Material(
              color: backgroundColor,
              type: MaterialType.card,
              elevation: 4,
              borderRadius: borderRadius,
              child: Column(
                children: [
                  if (config.showDragHandle) const DragHandle(),
                  Expanded(
                    child: RepaintBoundary(
                      child: ClipRRect(child: child),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  static const BorderRadius _defaultBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );
  
  static const AlwaysStoppedAnimation<Offset> _staticOffset = 
      AlwaysStoppedAnimation(Offset.zero);
  
  Animation<Offset> _createSlideAnimation(Animation<double> parent) {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );
  }
}
