import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpProgressBar extends StatelessWidget {
  const LevelUpProgressBar({
    super.key,
    required this.value,
    required this.fillColor,
    this.height = 10,
    this.backgroundColor,
  });

  final double value;
  final Color fillColor;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? LevelUpTheme.muted,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              width: constraints.maxWidth * clampedValue,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}
