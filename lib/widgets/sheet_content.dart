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

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: screenHeight * controller.sheetPosition,
      child: SlideTransition(
        position: animation != null 
          ? Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation!,
              curve: Curves.easeOutCubic,
            ))
          : AlwaysStoppedAnimation(Offset.zero),
        child: GestureDetector(
          onPanStart: controller.onPanStart,
          onPanUpdate: (details) => controller.onPanUpdate(details, context),
          onPanEnd: controller.onPanEnd,
          child: Container(
          decoration: BoxDecoration(
            color: config.backgroundColor ?? theme.colorScheme.surface,
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
              if (config.showDragHandle) const DragHandle(),
              Expanded(child: child),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
