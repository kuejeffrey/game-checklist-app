import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.streak,
  });

  final int streak;

  @override
  Widget build(BuildContext context) {
    final isHot = streak >= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHot
            ? LevelUpTheme.gold.withOpacity(0.16)
            : LevelUpTheme.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHot ? '\u{1F525}' : '\u2B50',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          Text(
            '$streak day streak',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isHot
                  ? const Color(0xFF9E6A30)
                  : LevelUpTheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
