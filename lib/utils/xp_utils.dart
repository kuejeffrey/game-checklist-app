class XpUtils {
  static const List<int> _levelThresholds = [
    0,
    50,
    120,
    220,
    350,
    520,
    740,
    1020,
    1380,
    1850,
  ];

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

  static int getLevel(int xp) {
    for (int i = _levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= _levelThresholds[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  static String getLevelName(int xp) {
    final level = getLevel(xp);
    return levelNames[(level - 1).clamp(0, levelNames.length - 1)];
  }

  static double getLevelProgress(int xp) {
    final level = getLevel(xp);
    if (level >= _levelThresholds.length) {
      return 1.0;
    }

    final currentFloor = _levelThresholds[level - 1];
    final nextFloor = _levelThresholds[level];
    final progress = (xp - currentFloor) / (nextFloor - currentFloor);
    return progress.clamp(0.0, 1.0);
  }

  static int xpToNextLevel(int xp) {
    final level = getLevel(xp);
    if (level >= _levelThresholds.length) {
      return 0;
    }

    return _levelThresholds[level] - xp;
  }

  static String getDailyMessage(int completedCount, int totalCount) {
    if (completedCount == 0) {
      return "Today's a new day. You've got this. \u{1F331}";
    }

    if (completedCount == totalCount) {
      return "You did it all today. That's huge! \u{1F31F}";
    }

    if (completedCount >= totalCount * 0.75) {
      return "Almost there - you're doing amazing! \u2728";
    }

    if (completedCount >= totalCount * 0.5) {
      return "Halfway through. You're making real progress. \u{1F4AA}";
    }

    return "Every step counts. You showed up today. \u{1F499}";
  }
}
