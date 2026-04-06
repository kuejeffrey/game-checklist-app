import 'package:flutter/material.dart';

import '../models/growth_stage_model.dart';
import '../theme/level_up_theme.dart';
import 'level_up_badge.dart';
import 'level_up_card.dart';

class GrowthStageCard extends StatelessWidget {
  const GrowthStageCard({
    super.key,
    required this.stage,
    required this.totalXp,
    required this.nextStage,
    required this.xpToNextStage,
  });

  final GrowthStage stage;
  final int totalXp;
  final GrowthStage? nextStage;
  final int xpToNextStage;

  @override
  Widget build(BuildContext context) {
    return LevelUpCard(
      padding: const EdgeInsets.all(18),
      borderColor: LevelUpTheme.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LevelUpTheme.muted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: _buildGrowthArt(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LevelUpBadge(
                  label: 'Growth loop',
                  tone: LevelUpBadgeTone.sage,
                ),
                const SizedBox(height: 10),
                Text(
                  stage.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: LevelUpTheme.mutedForeground,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  nextStage == null
                      ? 'Your tree is thriving. Progress, not perfection.'
                      : '$xpToNextStage XP until ${nextStage!.title}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: LevelUpTheme.sage,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Total growth: $totalXp XP',
                  style: const TextStyle(
                    fontSize: 11,
                    color: LevelUpTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthArt() {
    if (stage.assetPath != null) {
      return Image.asset(stage.assetPath!);
    }

    return Text(
      stage.emoji,
      style: const TextStyle(fontSize: 30),
    );
  }
}
