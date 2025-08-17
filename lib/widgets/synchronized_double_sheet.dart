import 'package:flutter/material.dart';

import '../controllers/sheet_gesture_controller.dart';
import '../controllers/synchronized_scroll_controller.dart';
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
  SynchronizedScrollController? _synchronizedController;

  @override
  void initState() {
    super.initState();
    _controller = SheetGestureController(
      config: widget.config,
      onClose: widget.onClose,
    );

    if (widget.config.enableSynchronizedScrolling) {
      _synchronizedController = SynchronizedScrollController(
        config: widget.config,
        sheetController: _controller,
        onClose: widget.onClose,
        enableSynchronization: true,
      );
    }
  }

  @override
  void dispose() {
    _synchronizedController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(materialTapTargetSize: MaterialTapTargetSize.padded),
      child: ListenableBuilder(
        listenable:
            _synchronizedController != null
                ? Listenable.merge([_controller, _synchronizedController!])
                : _controller,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Stack(
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
                  synchronizedController: _synchronizedController,
                  screenHeight: screenHeight - keyboardHeight,
                  animation: widget.animation,
                  child: widget.child,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
