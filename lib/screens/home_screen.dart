import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../presenters/home_presenter.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/growth_stage_card.dart';
import '../widgets/level_bar.dart';
import '../widgets/mood_check_in_card.dart';
import '../widgets/streak_badge.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.presenter,
  });

  final HomePresenter presenter;

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
              'Level Up \u2694\uFE0F',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF3D3060),
              ),
            ),
            actions: [
              StreakBadge(streak: presenter.streak),
              const SizedBox(width: 12),
            ],
          ),
          body: presenter.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: presenter.loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MoodCheckInCard(
                          promptText: presenter.moodPromptText,
                          helperText: presenter.moodHelperText,
                          selectedMood: presenter.todayMoodOption,
                          isLocked: presenter.hasMoodCheckInToday,
                          onSelected: (level) {
                            presenter.saveMoodLevel(level);
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildAffirmationCard(),
                        const SizedBox(height: 14),
                        LevelBar(
                          level: presenter.level,
                          levelName: presenter.levelName,
                          progress: presenter.progress,
                          totalXP: presenter.totalXp,
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: presenter.progressMessage == null
                              ? const SizedBox.shrink()
                              : Container(
                                  key: ValueKey<String?>(
                                    presenter.progressMessage,
                                  ),
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4EFFA),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFD9CFEA),
                                    ),
                                  ),
                                  child: Text(
                                    presenter.progressMessage!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5A4880),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                        GrowthStageCard(
                          stage: presenter.growthStage,
                          totalXp: presenter.totalXp,
                          nextStage: presenter.nextGrowthStage,
                          xpToNextStage: presenter.xpToNextGrowthStage,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            presenter.growthLoopMessage,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: presenter.dailyCategoryBonusEarned
                                ? const Color(0xFFEFF7EF)
                                : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: presenter.dailyCategoryBonusEarned
                                  ? const Color(0xFFB7DBB8)
                                  : const Color(0xFFE7DFF0),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE8F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '\u{1F338}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  presenter.categoryBonusMessage,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: presenter.dailyCategoryBonusEarned
                                        ? const Color(0xFF4E7B50)
                                        : const Color(0xFF5A4880),
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...presenter.categories
                            .map((category) => _buildCategorySection(category))
                            .toList(),
                        const SizedBox(height: 6),
                        _buildAddTaskButton(context),
                        const SizedBox(height: 28),
                        _buildDailySummary(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAffirmationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A gentle note',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C6EAF),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            presenter.inAppAffirmation,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF5A4880),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${category.emoji} ${category.label}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D3060),
                ),
              ),
              Text(
                '$completed / ${tasks.length}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            category.helperText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
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
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    return InkWell(
      onTap: () => _openAddTaskSheet(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF7C6EAF).withOpacity(0.35),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFF7C6EAF), size: 20),
            SizedBox(width: 8),
            Text(
              'Add your own task',
              style: TextStyle(
                color: Color(0xFF7C6EAF),
                fontWeight: FontWeight.w600,
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
        Text(
          'Daily Reflection',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _summaryCard('Tasks', '${presenter.completedCount}'),
            const SizedBox(width: 12),
            _summaryCard('XP Today', '+${presenter.totalXpToday}'),
            const SizedBox(width: 12),
            _summaryCard('Streak', '${presenter.streak}'),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE8F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                presenter.dailyTaskSummary,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D3060),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                presenter.dailyXpSummary,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A4880),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                presenter.dailySupportSummary,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A4880),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3060),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
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
        return const Color(0xFFDA8D5B);
      case TaskCategory.wellness:
        return const Color(0xFF6B9A72);
      case TaskCategory.growth:
        return const Color(0xFF7C6EAF);
    }
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
