class GrowthStage {
  const GrowthStage({
    required this.title,
    required this.emoji,
    required this.minXp,
    required this.message,
    this.assetPath,
  });

  final String title;
  final String emoji;
  final int minXp;
  final String message;

  // Replace this with your sprite path later when you add pixel art.
  final String? assetPath;
}

const List<GrowthStage> growthStages = [
  GrowthStage(
    title: 'Seed',
    emoji: '\u{1F331}',
    minXp: 0,
    message: 'Every little step is helping something grow.',
  ),
  GrowthStage(
    title: 'Sprout',
    emoji: '\u{1F33F}',
    minXp: 30,
    message: 'You are building a little momentum.',
  ),
  GrowthStage(
    title: 'Small Plant',
    emoji: '\u{1FAB4}',
    minXp: 80,
    message: 'Your care is starting to show.',
  ),
  GrowthStage(
    title: 'Blooming Plant',
    emoji: '\u{1F338}',
    minXp: 150,
    message: 'You are growing through steady effort.',
  ),
  GrowthStage(
    title: 'Full Tree',
    emoji: '\u{1F333}',
    minXp: 300,
    message: 'Look how much you have nurtured already.',
  ),
];
