import 'package:flutter/material.dart';

import '../controllers/sheet_gesture_controller.dart';
import '../models/double_sheet_config.dart';
import 'sheet_content.dart';
import 'sheet_header.dart';

class SynchronizedDoubleSheet extends StatefulWidget {
  final DoubleSheetConfig config;
  final Widget child;
  final VoidCallback? onClose;
  final Animation<double>? animation;

  const SynchronizedDoubleSheet({
    super.key,
    required this.config,
    required this.child,
    this.onClose,
    this.animation,
  });

  @override
  State<SynchronizedDoubleSheet> createState() =>
      _SynchronizedDoubleSheetState();
}

class _SynchronizedDoubleSheetState extends State<SynchronizedDoubleSheet> {
  late SheetGestureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SheetGestureController(
      config: widget.config,
      onClose: widget.onClose,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            SheetHeader(
              config: widget.config,
              position: _controller.headerPosition,
              opacity: _controller.headerOpacity,
              onClose: _controller.dismiss,
              animation: widget.animation,
            ),
            SheetContent(
              config: widget.config,
              controller: _controller,
              screenHeight: screenHeight,
              animation: widget.animation,
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}
