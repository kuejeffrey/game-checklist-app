// ============================================================
// screens/rewards_screen.dart — Collectible Rewards Gallery
//
// Shows a grid of pixel-art collectible placeholders.
// Some are unlocked (colored, earned) and some are locked
// (grayed out, with XP required shown).
//
// Rewards are unlocked automatically based on total XP.
// Replace the emoji placeholders with actual pixel-art
// images later using Image.asset().
// ============================================================

import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/xp_utils.dart';

// ── Reward Data ──────────────────────────────────────────────
// Each reward has an id, display name, emoji placeholder,
// the XP needed to unlock it, and an unlock message.
const List<Map<String, dynamic>> allRewards = [
  {'id': 'sprout',   'name': 'Little Sprout',    'emoji': '🌱', 'xpNeeded': 0,    'desc': 'For showing up'},
  {'id': 'flame',    'name': 'First Flame',       'emoji': '🕯️', 'xpNeeded': 30,  'desc': '3-day streak'},
  {'id': 'star',     'name': 'Shining Star',      'emoji': '⭐', 'xpNeeded': 80,   'desc': 'Level 3 reached'},
  {'id': 'shield',   'name': 'Daily Shield',      'emoji': '🛡️', 'xpNeeded': 150, 'desc': 'Complete 10 tasks'},
  {'id': 'moon',     'name': 'Night Owl',          'emoji': '🌙', 'xpNeeded': 220, 'desc': 'Sleep task ×5'},
  {'id': 'crown',    'name': 'Crown of Habit',    'emoji': '👑', 'xpNeeded': 350,  'desc': 'Level 5 reached'},
  {'id': 'gem',      'name': 'Glowing Gem',        'emoji': '💎', 'xpNeeded': 520, 'desc': 'Level 6 reached'},
  {'id': 'dragon',   'name': 'Pixel Dragon',       'emoji': '🐉', 'xpNeeded': 740, 'desc': 'Level 7 reached'},
  {'id': 'galaxy',   'name': 'Galaxy Brain',       'emoji': '🌌', 'xpNeeded': 1020,'desc': 'Level 8 reached'},
  {'id': 'legend',   'name': 'Life Legend',        'emoji': '✨', 'xpNeeded': 1850,'desc': 'Max level!'},
];

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _totalXP = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadXP();
  }

  Future<void> _loadXP() async {
    final xp = await StorageService.loadXP();
    setState(() {
      _totalXP = xp;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        title: const Text(
          'Rewards ⭐',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF3D3060),
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── XP Reminder ───────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE8F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'You have $_totalXP XP  •  ${XpUtils.getLevelName(_totalXP)}',
                      style: const TextStyle(
                        color: Color(0xFF5A4880),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // ── Rewards Grid ──────────────────────────
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: allRewards.length,
                      itemBuilder: (context, index) {
                        final reward = allRewards[index];
                        final isUnlocked = _totalXP >= (reward['xpNeeded'] as int);
                        return _RewardCard(
                          reward: reward,
                          isUnlocked: isUnlocked,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ── Reward Card Widget ────────────────────────────────────────
class _RewardCard extends StatelessWidget {
  final Map<String, dynamic> reward;
  final bool isUnlocked;

  const _RewardCard({
    required this.reward,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xFFF0EEF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? const Color(0xFF7C6EAF).withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1.5,
        ),
        // Subtle glow for unlocked rewards
        boxShadow: isUnlocked
            ? [BoxShadow(
                color: const Color(0xFF7C6EAF).withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )]
            : null,
      ),
      child: Stack(
        children: [
          // ── Card Content ────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ── Emoji / Pixel Art Placeholder ───────────
                // Replace Text(emoji) with Image.asset() when
                // you have actual pixel art sprites ready.
                ColorFiltered(
                  // Grayscale filter for locked rewards
                  colorFilter: isUnlocked
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                      : const ColorFilter.matrix(<double>[
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                  child: Text(
                    reward['emoji'],
                    style: TextStyle(
                      fontSize: 40,
                      color: isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Reward Name ──────────────────────────────
                Text(
                  reward['name'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? const Color(0xFF3D3060)
                        : Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // ── Unlock Condition or Description ──────────
                Text(
                  isUnlocked
                      ? reward['desc']
                      : '${reward['xpNeeded']} XP to unlock',
                  style: TextStyle(
                    fontSize: 11,
                    color: isUnlocked
                        ? Colors.grey.shade500
                        : Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // ── Lock Icon Overlay ──────────────────────────────
          if (!isUnlocked)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.lock_outline,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),

          // ── "New!" Badge for Newly Unlocked ───────────────
          if (isUnlocked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF9FC5A0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✓',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
