import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

enum LevelUpBadgeTone {
  sage,
  peach,
  gold,
  blue,
  neutral,
  success,
  destructive,
}

class LevelUpBadge extends StatelessWidget {
  const LevelUpBadge({
    super.key,
    required this.label,
    this.tone = LevelUpBadgeTone.neutral,
    this.padding,
  });

  final String label;
  final LevelUpBadgeTone tone;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _foregroundColor(),
        ),
      ),
    );
  }

  Color _backgroundColor() {
    switch (tone) {
      case LevelUpBadgeTone.sage:
        return LevelUpTheme.sage.withOpacity(0.12);
      case LevelUpBadgeTone.peach:
        return LevelUpTheme.peach.withOpacity(0.18);
      case LevelUpBadgeTone.gold:
        return LevelUpTheme.gold.withOpacity(0.18);
      case LevelUpBadgeTone.blue:
        return LevelUpTheme.dustyBlue.withOpacity(0.18);
      case LevelUpBadgeTone.success:
        return LevelUpTheme.success.withOpacity(0.14);
      case LevelUpBadgeTone.destructive:
        return LevelUpTheme.destructive.withOpacity(0.12);
      case LevelUpBadgeTone.neutral:
        return LevelUpTheme.muted;
    }
  }

  Color _foregroundColor() {
    switch (tone) {
      case LevelUpBadgeTone.sage:
        return LevelUpTheme.sage;
      case LevelUpBadgeTone.peach:
        return const Color(0xFFB8745A);
      case LevelUpBadgeTone.gold:
        return const Color(0xFF9E6A30);
      case LevelUpBadgeTone.blue:
        return LevelUpTheme.dustyBlue;
      case LevelUpBadgeTone.success:
        return const Color(0xFF4F7A52);
      case LevelUpBadgeTone.destructive:
        return LevelUpTheme.destructive;
      case LevelUpBadgeTone.neutral:
        return LevelUpTheme.mutedForeground;
    }
  }
}
