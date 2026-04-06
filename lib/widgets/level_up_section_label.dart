import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class LevelUpSectionLabel extends StatelessWidget {
  const LevelUpSectionLabel(
    this.label, {
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: LevelUpTheme.mutedForeground,
        letterSpacing: 0.5,
      ),
    );
  }
}
