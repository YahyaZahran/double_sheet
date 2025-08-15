import 'package:flutter/material.dart';

import '../models/double_sheet_config.dart';

class SheetHeader extends StatelessWidget {
  final DoubleSheetConfig config;
  final double position;
  final double opacity;
  final VoidCallback onClose;
  final Animation<double>? animation;

  const SheetHeader({
    super.key,
    required this.config,
    required this.position,
    required this.opacity,
    required this.onClose,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      left: 0,
      right: 0,
      top: position,
      child: SlideTransition(
        position:
            animation != null
                ? Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation!,
                    curve: Curves.easeOutCubic,
                  ),
                )
                : AlwaysStoppedAnimation(Offset.zero),
        child: Container(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            left: 16,
            right: 16,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: config.headerBackgroundColor ?? theme.colorScheme.surface,
            borderRadius: config.headerRadius,
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
                  child:
                      config.titleWidget ??
                      Text(
                        config.title,
                        style:
                            config.titleStyle ??
                            theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                const SizedBox(width: 8),
                _CloseButton(onClose: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onClose;

  const _CloseButton({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onClose,
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
    );
  }
}
