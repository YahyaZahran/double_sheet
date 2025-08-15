import 'package:flutter/material.dart';

import 'models/double_sheet_config.dart';
import 'widgets/synchronized_double_sheet.dart';

export 'models/double_sheet_config.dart';
export 'widgets/synchronized_double_sheet.dart';

Future<T?> showDoubleSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  Widget? titleWidget,
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
  BorderRadius? borderRadius,
  BorderRadius? headerRadius,
}) {
  final config = DoubleSheetConfig(
    title: title,
    titleWidget: titleWidget,
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
    borderRadius: borderRadius,
    headerRadius: headerRadius,
  );

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel:
        isDismissible
            ? MaterialLocalizations.of(context).modalBarrierDismissLabel
            : null,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return PopScope(
        canPop: true,
        child: SynchronizedDoubleSheet(
          config: config,
          animation: animation,
          onClose: () {
            if (Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext, rootNavigator: false).pop();
            }
          },
          child: child,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class DoubleSheet extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final TextStyle? titleStyle;
  final bool enableDrag;
  final bool showDragHandle;
  final bool allowFullScreen;
  final BorderRadius? borderRadius;
  final BorderRadius? headerRadius;
  final VoidCallback? onClose;
  final Widget child;

  const DoubleSheet({
    super.key,
    required this.title,
    this.titleWidget,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.titleStyle,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.allowFullScreen = false,
    this.borderRadius,
    this.headerRadius,
    this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final config = DoubleSheetConfig(
      title: title,
      titleWidget: titleWidget,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      backgroundColor: backgroundColor,
      headerBackgroundColor: headerBackgroundColor,
      titleStyle: titleStyle,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      allowFullScreen: allowFullScreen,
      borderRadius: borderRadius,
      headerRadius: headerRadius,
    );

    return SynchronizedDoubleSheet(
      config: config,
      onClose: onClose,
      child: child,
    );
  }
}
