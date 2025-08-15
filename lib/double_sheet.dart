import 'package:flutter/material.dart';

export 'models/double_sheet_config.dart';
export 'widgets/synchronized_double_sheet.dart';

import 'models/double_sheet_config.dart';
import 'widgets/synchronized_double_sheet.dart';

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
  final config = DoubleSheetConfig(
    title: title,
    initialChildSize: initialChildSize,
    minChildSize: minChildSize,
    maxChildSize: maxChildSize,
    backgroundColor: backgroundColor,
    headerBackgroundColor: headerBackgroundColor,
    titleStyle: titleStyle,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    showDragHandle: showDragHandle,
    allowFullScreen: allowFullScreen,
  );

  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) {
      return SynchronizedDoubleSheet(
        config: config,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      );
    },
  );
}

class DoubleSheet extends StatelessWidget {
  final String title;
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
  final Widget child;

  const DoubleSheet({
    super.key,
    required this.title,
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
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final config = DoubleSheetConfig(
      title: title,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      backgroundColor: backgroundColor,
      headerBackgroundColor: headerBackgroundColor,
      titleStyle: titleStyle,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      allowFullScreen: allowFullScreen,
    );

    return SynchronizedDoubleSheet(
      config: config,
      onClose: onClose,
      child: child,
    );
  }
}