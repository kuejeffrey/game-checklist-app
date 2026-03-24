class MoodOption {
  const MoodOption({
    required this.level,
    required this.emoji,
    required this.label,
  });

  final int level;
  final String emoji;
  final String label;
}

const List<MoodOption> moodOptions = [
  MoodOption(level: 1, emoji: '\u{1F61E}', label: 'Very low'),
  MoodOption(level: 2, emoji: '\u{1F641}', label: 'Low'),
  MoodOption(level: 3, emoji: '\u{1F610}', label: 'Okay'),
  MoodOption(level: 4, emoji: '\u{1F642}', label: 'Good'),
  MoodOption(level: 5, emoji: '\u{1F604}', label: 'Great'),
];

MoodOption moodOptionForLevel(int level) {
  return moodOptions.firstWhere(
    (option) => option.level == level,
    orElse: () => moodOptions[2],
  );
}
