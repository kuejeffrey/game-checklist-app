class RewardItem {
  const RewardItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.xpNeeded,
    required this.unlockHint,
    required this.flavorText,
  });

  final String id;
  final String name;
  final String emoji;
  final int xpNeeded;
  final String unlockHint;
  final String flavorText;
}

const List<RewardItem> defaultRewards = [
  RewardItem(
    id: 'sprout',
    name: 'Little Sprout',
    emoji: '\u{1F331}',
    xpNeeded: 0,
    unlockHint: 'Unlocked for showing up.',
    flavorText: 'A quiet reminder that beginning counts too.',
  ),
  RewardItem(
    id: 'flame',
    name: 'First Flame',
    emoji: '\u{1F56F}\uFE0F',
    xpNeeded: 30,
    unlockHint: 'Reach 30 XP to light this flame.',
    flavorText: 'A little warmth for the days you kept going.',
  ),
  RewardItem(
    id: 'star',
    name: 'Shining Star',
    emoji: '\u2B50',
    xpNeeded: 80,
    unlockHint: 'Reach 80 XP to unlock.',
    flavorText: 'A small sparkle for steady effort.',
  ),
  RewardItem(
    id: 'shield',
    name: 'Daily Shield',
    emoji: '\u{1F6E1}\uFE0F',
    xpNeeded: 150,
    unlockHint: 'Reach 150 XP to unlock.',
    flavorText: 'A gentle badge for the care you gave yourself.',
  ),
  RewardItem(
    id: 'moon',
    name: 'Night Owl',
    emoji: '\u{1F319}',
    xpNeeded: 220,
    unlockHint: 'Reach 220 XP to unlock.',
    flavorText: 'A soft glow for the evenings you made it through.',
  ),
  RewardItem(
    id: 'crown',
    name: 'Crown of Habit',
    emoji: '\u{1F451}',
    xpNeeded: 350,
    unlockHint: 'Reach 350 XP to unlock.',
    flavorText: 'A cozy crown for building a rhythm that fits you.',
  ),
  RewardItem(
    id: 'gem',
    name: 'Glowing Gem',
    emoji: '\u{1F48E}',
    xpNeeded: 520,
    unlockHint: 'Reach 520 XP to unlock.',
    flavorText: 'A bright little treasure shaped by consistency.',
  ),
  RewardItem(
    id: 'dragon',
    name: 'Pixel Dragon',
    emoji: '\u{1F409}',
    xpNeeded: 740,
    unlockHint: 'Reach 740 XP to unlock.',
    flavorText: 'A playful guardian for the progress you protected.',
  ),
  RewardItem(
    id: 'galaxy',
    name: 'Galaxy Brain',
    emoji: '\u{1F30C}',
    xpNeeded: 1020,
    unlockHint: 'Reach 1020 XP to unlock.',
    flavorText: 'A little universe built one day at a time.',
  ),
  RewardItem(
    id: 'legend',
    name: 'Life Level Legend',
    emoji: '\u2728',
    xpNeeded: 1850,
    unlockHint: 'Reach 1850 XP to unlock.',
    flavorText: 'A soft celebration of how far you have come.',
  ),
];
