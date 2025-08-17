import 'package:flutter/material.dart';

class DoubleSheetConfig {
  final String title;
  final Widget? titleWidget;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final TextStyle? titleStyle;
  final bool enableDrag;
  final bool isDismissible;
  final bool showDragHandle;
  final bool allowFullScreen;
  final BorderRadius? borderRadius;
  final BorderRadius? headerRadius;
  final bool enableSynchronizedScrolling;

  const DoubleSheetConfig({
    required this.title,
    this.titleWidget,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.titleStyle,
    this.enableDrag = true,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.allowFullScreen = false,
    this.borderRadius,
    this.headerRadius,
    this.enableSynchronizedScrolling = false,
  });

  DoubleSheetConfig copyWith({
    String? title,
    Widget? titleWidget,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
    Color? backgroundColor,
    Color? headerBackgroundColor,
    TextStyle? titleStyle,
    bool? enableDrag,
    bool? isDismissible,
    bool? showDragHandle,
    bool? allowFullScreen,
    BorderRadius? borderRadius,
    BorderRadius? headerRadius,
    bool? enableSynchronizedScrolling,
  }) {
    return DoubleSheetConfig(
      title: title ?? this.title,
      titleWidget: titleWidget ?? this.titleWidget,
      initialChildSize: initialChildSize ?? this.initialChildSize,
      minChildSize: minChildSize ?? this.minChildSize,
      maxChildSize: maxChildSize ?? this.maxChildSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      enableDrag: enableDrag ?? this.enableDrag,
      isDismissible: isDismissible ?? this.isDismissible,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      allowFullScreen: allowFullScreen ?? this.allowFullScreen,
      borderRadius: borderRadius ?? this.borderRadius,
      headerRadius: headerRadius ?? this.headerRadius,
      enableSynchronizedScrolling:
          enableSynchronizedScrolling ?? this.enableSynchronizedScrolling,
    );
  }

  double get effectiveMaxChildSize => allowFullScreen ? 1.0 : maxChildSize;
}
