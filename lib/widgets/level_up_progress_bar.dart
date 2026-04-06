import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpProgressBar extends StatelessWidget {
  const LevelUpProgressBar({
    super.key,
    required this.value,
    this.fillColor,
    this.gradient,
    this.height = 10,
    this.backgroundColor,
  }) : assert(
          fillColor != null || gradient != null,
          'Provide either fillColor or gradient',
        );

  final double value;
  final Color? fillColor;
  final Gradient? gradient;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: height,
            color: backgroundColor ?? LevelUpTheme.muted,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * clampedValue,
                decoration: BoxDecoration(
                  color: gradient == null ? fillColor : null,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
