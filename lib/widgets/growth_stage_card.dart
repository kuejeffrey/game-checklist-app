import 'package:flutter/material.dart';

import '../models/growth_stage_model.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7DFF0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C6EAF).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8F5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: _buildGrowthArt(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Growth',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3060),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
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
                    color: Color(0xFF7C6EAF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Total growth: $totalXp XP',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
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
