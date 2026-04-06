import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpCard extends StatelessWidget {
  const LevelUpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
    this.radius = 24,
    this.onTap,
    this.onLongPress,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: gradient == null ? (color ?? Colors.white) : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? LevelUpTheme.border,
        width: borderWidth,
      ),
      boxShadow: boxShadow ?? LevelUpTheme.cardShadow,
    );

    final content = Padding(
      padding: padding,
      child: child,
    );

    if (onTap == null && onLongPress == null) {
      return DecoratedBox(
        decoration: decoration,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          onLongPress: onLongPress,
          child: content,
        ),
      ),
    );
  }
}
