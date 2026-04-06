import 'package:flutter/material.dart';

import '../models/reward_model.dart';
import '../presenters/rewards_presenter.dart';
import '../theme/level_up_theme.dart';
import '../widgets/level_up_badge.dart';
import '../widgets/level_up_card.dart';
import '../widgets/level_up_progress_bar.dart';
import '../widgets/level_up_section_label.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({
    super.key,
    required this.presenter,
  });

  final RewardsPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: presenter,
      builder: (context, _) {
        return ColoredBox(
          color: LevelUpTheme.cream,
          child: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
              children: [
                const Text(
                  'Rewards',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  presenter.encouragement,
                  style: const TextStyle(
                    fontSize: 14,
                    color: LevelUpTheme.mutedForeground,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                _buildHeroCard(),
                const SizedBox(height: 28),
                const Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 14),
                ...presenter.rewards.map(
                  (reward) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RewardCard(
                      reward: reward,
                      isUnlocked: presenter.isUnlocked(reward),
                      isNew: presenter.isNewlyUnlocked(reward),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCard() {
    return LevelUpCard(
      gradient: LevelUpTheme.rewardsGradient,
      borderColor: LevelUpTheme.gold.withOpacity(0.16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [LevelUpTheme.gold, LevelUpTheme.peach],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LevelUpSectionLabel('Current level'),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${presenter.level}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: LevelUpTheme.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        LevelUpBadge(
                          label: presenter.levelName,
                          tone: LevelUpBadgeTone.gold,
                        ),
                        LevelUpBadge(
                          label: '${presenter.totalXp} XP',
                          tone: LevelUpBadgeTone.sage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LevelUpProgressBar(
            value: presenter.levelProgress,
            fillColor: LevelUpTheme.gold,
            backgroundColor: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${presenter.unlockedCount}/${presenter.rewards.length} unlocked',
                style: const TextStyle(
                  fontSize: 13,
                  color: LevelUpTheme.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                presenter.xpToNextLevel == 0
                    ? 'Max level reached'
                    : '${presenter.xpToNextLevel} XP to next level',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E6A30),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.reward,
    required this.isUnlocked,
    required this.isNew,
  });

  final RewardItem reward;
  final bool isUnlocked;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final statusLabel = isNew
        ? 'New'
        : isUnlocked
            ? 'Unlocked'
            : 'Locked';

    return LevelUpCard(
      color: isUnlocked ? Colors.white : const Color(0xFFF7F5F0),
      borderColor: isNew
          ? LevelUpTheme.success.withOpacity(0.28)
          : isUnlocked
              ? LevelUpTheme.border
              : LevelUpTheme.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? LevelUpTheme.gold.withOpacity(0.14)
                  : LevelUpTheme.muted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              isUnlocked ? reward.emoji : '\u{1F512}',
              style: TextStyle(
                fontSize: 28,
                color: isUnlocked ? null : LevelUpTheme.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reward.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isUnlocked
                              ? LevelUpTheme.charcoal
                              : LevelUpTheme.mutedForeground,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    LevelUpBadge(
                      label: statusLabel,
                      tone: isNew
                          ? LevelUpBadgeTone.success
                          : isUnlocked
                              ? LevelUpBadgeTone.gold
                              : LevelUpBadgeTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isUnlocked ? reward.flavorText : reward.unlockHint,
                  style: const TextStyle(
                    fontSize: 13,
                    color: LevelUpTheme.mutedForeground,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                LevelUpBadge(
                  label: '${reward.xpNeeded} XP',
                  tone: LevelUpBadgeTone.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
