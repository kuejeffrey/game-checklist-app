import 'package:flutter/material.dart';

import '../theme/level_up_theme.dart';
import 'level_up_badge.dart';
import 'level_up_card.dart';
import 'level_up_progress_bar.dart';

class LevelBar extends StatelessWidget {
  const LevelBar({
    super.key,
    required this.level,
    required this.levelName,
    required this.progress,
    required this.totalXP,
  });

  final int level;
  final String levelName;
  final double progress;
  final int totalXP;

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progress * 100).toInt();

    return LevelUpCard(
      padding: const EdgeInsets.all(20),
      gradient: LevelUpTheme.progressGradient,
      borderColor: LevelUpTheme.sage.withOpacity(0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LevelUpTheme.authHeroGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Growth Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: LevelUpTheme.mutedForeground,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: LevelUpTheme.charcoal,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      levelName,
                      style: const TextStyle(
                        color: LevelUpTheme.mutedForeground,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              LevelUpBadge(
                label: '$totalXP XP',
                tone: LevelUpBadgeTone.gold,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Steady effort adds up.',
            style: TextStyle(
              color: LevelUpTheme.charcoal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          LevelUpProgressBar(
            value: progress,
            gradient: LevelUpTheme.progressBarGradient,
            backgroundColor: Colors.white.withOpacity(0.6),
            height: 10,
          ),
          const SizedBox(height: 10),
          Text(
            '$progressPercent% to your next level',
            style: const TextStyle(
              color: LevelUpTheme.mutedForeground,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
