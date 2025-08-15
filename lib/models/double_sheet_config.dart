import 'package:flutter/material.dart';

class DoubleSheetConfig {
  final String title;
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

  const DoubleSheetConfig({
    required this.title,
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
  });

  DoubleSheetConfig copyWith({
    String? title,
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
  }) {
    return DoubleSheetConfig(
      title: title ?? this.title,
      initialChildSize: initialChildSize ?? this.initialChildSize,
      minChildSize: minChildSize ?? this.minChildSize,
      maxChildSize: maxChildSize ?? this.maxChildSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      enableDrag: enableDrag ?? this.enableDrag,
      isDismissible: isDismissible ?? this.isDismissible,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      allowFullScreen: allowFullScreen ?? this.allowFullScreen,
    );
  }

  double get effectiveMaxChildSize => allowFullScreen ? 1.0 : maxChildSize;
}