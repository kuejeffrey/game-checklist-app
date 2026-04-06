import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../presenters/home_presenter.dart';
import '../theme/level_up_theme.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/growth_stage_card.dart';
import '../widgets/level_bar.dart';
import '../widgets/level_up_badge.dart';
import '../widgets/level_up_card.dart';
import '../widgets/level_up_progress_bar.dart';
import '../widgets/level_up_section_label.dart';
import '../widgets/mood_check_in_dialog.dart';
import '../widgets/streak_badge.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.presenter,
    this.userName,
  });

  final HomePresenter presenter;
  final String? userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMoodDialogOpen = false;
  String? _moodPromptShownForDate;

  HomePresenter get presenter => widget.presenter;

  @override
  void initState() {
    super.initState();
    presenter.addListener(_handlePresenterChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybePromptForMoodCheckIn();
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.presenter == widget.presenter) {
      return;
    }

    oldWidget.presenter.removeListener(_handlePresenterChanged);
    presenter.addListener(_handlePresenterChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybePromptForMoodCheckIn();
    });
  }

  @override
  void dispose() {
    presenter.removeListener(_handlePresenterChanged);
    super.dispose();
  }

  void _handlePresenterChanged() {
    _maybePromptForMoodCheckIn();
  }

  void _maybePromptForMoodCheckIn() {
    if (!mounted || presenter.isLoading || presenter.hasMoodCheckInToday) {
      return;
    }

    final today = _todayKey();
    if (_isMoodDialogOpen || _moodPromptShownForDate == today) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openMoodCheckInDialog(markAsShown: true);
    });
  }

  Future<void> _openMoodCheckInDialog({
    bool markAsShown = false,
  }) async {
    if (!mounted || presenter.isLoading || presenter.hasMoodCheckInToday) {
      return;
    }

    if (_isMoodDialogOpen) {
      return;
    }

    final today = _todayKey();
    if (markAsShown) {
      _moodPromptShownForDate = today;
    }

    _isMoodDialogOpen = true;
    final selectedLevel = await MoodCheckInDialog.show(
      context,
      promptText: presenter.moodPromptText,
      helperText: presenter.moodHelperText,
    );
    _isMoodDialogOpen = false;

    if (selectedLevel == null || presenter.hasMoodCheckInToday) {
      return;
    }

    await presenter.saveMoodLevel(selectedLevel);
  }

  String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: presenter,
      builder: (context, _) {
        if (presenter.isLoading) {
          return const ColoredBox(
            color: LevelUpTheme.cream,
            child: Center(
              child: CircularProgressIndicator(color: LevelUpTheme.sage),
            ),
          );
        }

        return ColoredBox(
          color: LevelUpTheme.cream,
          child: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: LevelUpTheme.sage,
              onRefresh: presenter.loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildProgressCard(),
                    if (presenter.progressMessage != null) ...[
                      const SizedBox(height: 14),
                      _buildFeedbackCard(),
                    ],
                    const SizedBox(height: 14),
                    _buildAffirmationCard(),
                    const SizedBox(height: 14),
                    LevelBar(
                      level: presenter.level,
                      levelName: presenter.levelName,
                      progress: presenter.progress,
                      totalXP: presenter.totalXp,
                    ),
                    const SizedBox(height: 14),
                    GrowthStageCard(
                      stage: presenter.growthStage,
                      totalXp: presenter.totalXp,
                      nextStage: presenter.nextGrowthStage,
                      xpToNextStage: presenter.xpToNextGrowthStage,
                    ),
                    const SizedBox(height: 14),
                    _buildCategoryBonusCard(),
                    const SizedBox(height: 28),
                    _buildTaskHeader(),
                    const SizedBox(height: 14),
                    ...presenter.categories
                        .map((category) => _buildCategorySection(category))
                        .toList(),
                    const SizedBox(height: 16),
                    _buildDailySummary(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _headlineGreeting(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: LevelUpTheme.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                presenter.hasMoodCheckInToday && presenter.todayMoodOption != null
                    ? 'You checked in as ${presenter.todayMoodOption!.label.toLowerCase()}. Let\'s keep the day gentle and steady.'
                    : 'Let\'s make today count in a way that feels manageable.',
                style: const TextStyle(
                  fontSize: 14,
                  color: LevelUpTheme.mutedForeground,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        StreakBadge(streak: presenter.streak),
      ],
    );
  }

  Widget _buildProgressCard() {
    final totalTasks = presenter.tasks.length;
    final taskProgress = totalTasks == 0
        ? 0.0
        : presenter.completedCount / totalTasks;

    return LevelUpCard(
      gradient: LevelUpTheme.progressGradient,
      borderColor: LevelUpTheme.sage.withOpacity(0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
              ),
              LevelUpBadge(
                label: '${presenter.completedCount}/$totalTasks',
                tone: LevelUpBadgeTone.sage,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            presenter.dailyMessage,
            style: const TextStyle(
              fontSize: 14,
              color: LevelUpTheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          LevelUpProgressBar(
            value: taskProgress,
            gradient: LevelUpTheme.progressBarGradient,
            height: 10,
            backgroundColor: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '\u{1F525} ${presenter.streak} day streak',
                style: const TextStyle(
                  fontSize: 13,
                  color: LevelUpTheme.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '\u2728 +${presenter.totalXpToday} XP',
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

  Widget _buildFeedbackCard() {
    return LevelUpCard(
      color: LevelUpTheme.sage.withOpacity(0.1),
      borderColor: LevelUpTheme.sage.withOpacity(0.2),
      boxShadow: const [],
      child: Text(
        presenter.progressMessage!,
        style: const TextStyle(
          fontSize: 14,
          color: LevelUpTheme.charcoal,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAffirmationCard() {
    final mood = presenter.todayMoodOption;

    return LevelUpCard(
      gradient: LinearGradient(
        colors: [
          LevelUpTheme.gold.withOpacity(0.12),
          LevelUpTheme.peach.withOpacity(0.12),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: LevelUpTheme.gold.withOpacity(0.18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [LevelUpTheme.gold, LevelUpTheme.peach],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LevelUpSectionLabel('A gentle note'),
                const SizedBox(height: 8),
                Text(
                  presenter.inAppAffirmation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LevelUpTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 10),
                if (mood != null)
                  Text(
                    '${mood.emoji} Today you checked in as ${mood.label.toLowerCase()}.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: LevelUpTheme.mutedForeground,
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _openMoodCheckInDialog(markAsShown: true);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: const Text('How are you feeling today?'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBonusCard() {
    return LevelUpCard(
      color: presenter.dailyCategoryBonusEarned
          ? LevelUpTheme.sage.withOpacity(0.08)
          : Colors.white,
      borderColor: presenter.dailyCategoryBonusEarned
          ? LevelUpTheme.sage.withOpacity(0.22)
          : LevelUpTheme.border,
      boxShadow: const [],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LevelUpTheme.muted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '\u{1F338}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              presenter.categoryBonusMessage,
              style: TextStyle(
                fontSize: 13,
                color: presenter.dailyCategoryBonusEarned
                    ? const Color(0xFF4F7A52)
                    : LevelUpTheme.charcoal,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Today\'s Tasks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: LevelUpTheme.charcoal,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _openAddTaskSheet(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: LevelUpTheme.mutedForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: LevelUpTheme.border),
            ),
          ),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }

  Widget _buildCategorySection(TaskCategory category) {
    final tasks = presenter.tasksForCategory(category);
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = _categoryColor(category);
    final completed = presenter.completedCountForCategory(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: LevelUpCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${category.emoji} ${category.label}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: LevelUpTheme.charcoal,
                    ),
                  ),
                ),
                LevelUpBadge(
                  label: '$completed/${tasks.length}',
                  tone: _categoryTone(category),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              category.helperText,
              style: const TextStyle(
                fontSize: 13,
                color: LevelUpTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 12),
            ...tasks.map(
              (task) => TaskTile(
                key: ValueKey<String>(task.id),
                task: task,
                categoryLabel: task.category.label,
                categoryColor: color,
                showCelebration: presenter.shouldCelebrateTask(task.id),
                xpGain: presenter.celebrationXp,
                onToggle: () => presenter.toggleTask(task.id),
                onDelete:
                    task.isDefault ? null : () => presenter.deleteTask(task.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Reflection',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: LevelUpTheme.charcoal,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _summaryCard('Tasks', '${presenter.completedCount}'),
            const SizedBox(width: 10),
            _summaryCard('XP Today', '+${presenter.totalXpToday}'),
            const SizedBox(width: 10),
            _summaryCard('Streak', '${presenter.streak}'),
          ],
        ),
        const SizedBox(height: 14),
        LevelUpCard(
          gradient: LinearGradient(
            colors: [
              LevelUpTheme.sage.withOpacity(0.08),
              LevelUpTheme.dustyBlue.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderColor: LevelUpTheme.sage.withOpacity(0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                presenter.dailyTaskSummary,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: LevelUpTheme.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                presenter.dailyXpSummary,
                style: const TextStyle(
                  fontSize: 13,
                  color: LevelUpTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                presenter.dailySupportSummary,
                style: const TextStyle(
                  fontSize: 13,
                  color: LevelUpTheme.mutedForeground,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, String value) {
    return Expanded(
      child: LevelUpCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        boxShadow: const [],
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: LevelUpTheme.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: LevelUpTheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.survival:
        return LevelUpTheme.peach;
      case TaskCategory.wellness:
        return LevelUpTheme.sage;
      case TaskCategory.growth:
        return LevelUpTheme.dustyBlue;
    }
  }

  LevelUpBadgeTone _categoryTone(TaskCategory category) {
    switch (category) {
      case TaskCategory.survival:
        return LevelUpBadgeTone.peach;
      case TaskCategory.wellness:
        return LevelUpBadgeTone.sage;
      case TaskCategory.growth:
        return LevelUpBadgeTone.blue;
    }
  }

  String _headlineGreeting() {
    final hour = DateTime.now().hour;
    late final String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final rawName = widget.userName?.trim();
    final firstName = rawName == null || rawName.isEmpty
        ? 'friend'
        : rawName.split(' ').first;
    return '$greeting, $firstName';
  }

  void _openAddTaskSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(
        onAdd: (label, emoji, category) {
          presenter.addCustomTask(label, emoji, category);
        },
      ),
    );
  }
}
