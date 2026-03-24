import 'package:flutter/material.dart';

import '../models/reward_model.dart';
import '../presenters/rewards_presenter.dart';

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
        return Scaffold(
          backgroundColor: const Color(0xFFFAF8F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAF8F5),
            elevation: 0,
            title: const Text(
              'Rewards \u2B50',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF3D3060),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE8F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'You have ${presenter.totalXp} XP • ${presenter.levelName}',
                    style: const TextStyle(
                      color: Color(0xFF5A4880),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    presenter.encouragement,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: presenter.rewards.length,
                    itemBuilder: (context, index) {
                      final reward = presenter.rewards[index];
                      return _RewardCard(
                        reward: reward,
                        isUnlocked: presenter.isUnlocked(reward),
                        isNew: presenter.isNewlyUnlocked(reward),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    final label = isNew
        ? 'New'
        : isUnlocked
            ? 'Unlocked'
            : 'Locked';

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xFFF3F0F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isNew
              ? const Color(0xFF9FC5A0)
              : isUnlocked
                  ? const Color(0xFFD9CFEA)
                  : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(
              color: (isNew
                      ? const Color(0xFF9FC5A0)
                      : const Color(0xFF7C6EAF))
                  .withOpacity(0.1),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? const Color(0xFFEDE8F5)
                        : const Color(0xFFEAE6EF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ColorFiltered(
                    colorFilter: isUnlocked
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.srcOver,
                          )
                        : const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                    child: Text(
                      reward.emoji,
                      style: TextStyle(
                        fontSize: 34,
                        color: isUnlocked ? null : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  reward.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? const Color(0xFF3D3060)
                        : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  isUnlocked ? reward.flavorText : reward.unlockHint,
                  style: TextStyle(
                    fontSize: 11,
                    color: isUnlocked
                        ? Colors.grey.shade600
                        : Colors.grey.shade500,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isNew
                    ? const Color(0xFF9FC5A0)
                    : isUnlocked
                        ? const Color(0xFFEDE8F5)
                        : Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isNew
                      ? Colors.white
                      : isUnlocked
                          ? const Color(0xFF5A4880)
                          : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
