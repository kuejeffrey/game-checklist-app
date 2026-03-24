// ============================================================
// utils/xp_utils.dart — XP, Level & Progress Calculations
//
// All the math for turning XP points into levels lives here.
// Keeping it separate makes it easy to adjust the leveling
// curve without touching any UI code.
// ============================================================

class XpUtils {
  // ── Level Thresholds ──────────────────────────────────────
  // Each level requires progressively more XP.
  // The list index = level number (level 1 = index 0).
  // You can add more levels or adjust XP required easily.
  static const List<int> _levelThresholds = [
    0,    // Level 1 starts at 0 XP
    50,   // Level 2 starts at 50 XP
    120,  // Level 3
    220,  // Level 4
    350,  // Level 5
    520,  // Level 6
    740,  // Level 7
    1020, // Level 8
    1380, // Level 9
    1850, // Level 10 — max level for MVP
  ];

  // ── Level Names ───────────────────────────────────────────
  // Fun, encouraging titles for each level.
  // These appear on the home screen below the level number.
  static const List<String> levelNames = [
    'Just Getting Started',
    'Finding Your Footing',
    'Building Habits',
    'Gaining Momentum',
    'On a Roll',
    'Level Headed',
    'Daily Champion',
    'Consistency King',
    'Habit Master',
    'Life Level Legend',
  ];

  // ── Get Current Level ─────────────────────────────────────
  // Returns which level (1–10) the user is at given their XP.
  static int getLevel(int xp) {
    for (int i = _levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= _levelThresholds[i]) return i + 1;
    }
    return 1;
  }

  // ── Get Level Name ────────────────────────────────────────
  static String getLevelName(int xp) {
    final level = getLevel(xp);
    return levelNames[(level - 1).clamp(0, levelNames.length - 1)];
  }

  // ── Progress Within Current Level ─────────────────────────
  // Returns a value from 0.0 to 1.0 showing how far through
  // the current level the user is. Used for the progress bar.
  static double getLevelProgress(int xp) {
    final level = getLevel(xp);

    // If at max level, show full bar
    if (level >= _levelThresholds.length) return 1.0;

    final currentFloor = _levelThresholds[level - 1]; // XP needed for this level
    final nextFloor    = _levelThresholds[level];      // XP needed for next level

    final progress = (xp - currentFloor) / (nextFloor - currentFloor);
    return progress.clamp(0.0, 1.0);
  }

  // ── XP Needed for Next Level ──────────────────────────────
  static int xpToNextLevel(int xp) {
    final level = getLevel(xp);
    if (level >= _levelThresholds.length) return 0;
    return _levelThresholds[level] - xp;
  }

  // ── Encouraging Message Based on Progress ─────────────────
  // Returns a soft, supportive message based on today's
  // completed tasks. Never shaming, always kind.
  static String getDailyMessage(int completedCount, int totalCount) {
    if (completedCount == 0) {
      return "Today's a new day. You've got this. 🌱";
    } else if (completedCount == totalCount) {
      return "You did it all today. That's huge! 🌟";
    } else if (completedCount >= totalCount * 0.75) {
      return "Almost there — you're doing amazing! ✨";
    } else if (completedCount >= totalCount * 0.5) {
      return "Halfway through. You're making real progress. 💪";
    } else {
      return "Every step counts. You showed up today. 💙";
    }
  }
}
