import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/growth_stage_model.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../utils/xp_utils.dart';

class HomePresenter extends ChangeNotifier {
  static const int categoryBonusXp = 15;

  List<Task> _tasks = <Task>[];
  int _totalXp = 0;
  int _streak = 0;
  bool _isLoading = true;
  bool _dailyCategoryBonusEarned = false;
  String? _celebrationTaskId;
  int _celebrationXp = 0;
  String? _progressMessage;
  int _feedbackToken = 0;

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  int get totalXp => _totalXp;
  int get streak => _streak;
  bool get isLoading => _isLoading;
  bool get dailyCategoryBonusEarned => _dailyCategoryBonusEarned;
  String? get progressMessage => _progressMessage;
  int get celebrationXp => _celebrationXp;
  GrowthStage get growthStage => _growthStageForXp(_totalXp);
  GrowthStage? get nextGrowthStage => _nextGrowthStageForXp(_totalXp);

  int get completedCount => _tasks.where((task) => task.isCompleted).length;
  int get totalXpToday => _tasks
      .where((task) => task.isCompleted)
      .fold(
        _dailyCategoryBonusEarned ? categoryBonusXp : 0,
        (sum, task) => sum + task.xpValue,
      );
  int get level => XpUtils.getLevel(_totalXp);
  String get levelName => XpUtils.getLevelName(_totalXp);
  double get progress => XpUtils.getLevelProgress(_totalXp);
  String get dailyMessage =>
      XpUtils.getDailyMessage(completedCount, _tasks.length);
  String get dailyTaskSummary => 'You completed $completedCount tasks today.';
  String get dailyXpSummary => 'You gained $totalXpToday XP today.';

  String get dailySupportSummary {
    if (dailyCategoryBonusEarned) {
      return 'You cared for each part of your day. That counts.';
    }

    if (completedCount >= 3) {
      return 'You took care of yourself today.';
    }

    if (completedCount > 0) {
      return 'You showed up today. That counts.';
    }

    return 'Small progress still counts.';
  }

  String get growthLoopMessage =>
      'Tasks build XP. XP helps your plant grow and unlock rewards.';

  String get categoryBonusMessage {
    if (_dailyCategoryBonusEarned) {
      return 'Daily balance bonus earned: +$categoryBonusXp XP';
    }

    final remaining = TaskCategory.values
        .where((category) => !hasCompletedCategory(category))
        .map((category) => category.label)
        .toList();

    if (remaining.length == 1) {
      return '${remaining.first} is the last category for today\'s +$categoryBonusXp XP.';
    }

    return 'Complete one task in each category for +$categoryBonusXp XP.';
  }

  int get xpToNextGrowthStage {
    final nextStage = this.nextGrowthStage;
    if (nextStage == null) {
      return 0;
    }

    return (nextStage.minXp - _totalXp).clamp(0, nextStage.minXp) as int;
  }

  Iterable<TaskCategory> get categories => TaskCategory.values;

  List<Task> tasksForCategory(TaskCategory category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  int completedCountForCategory(TaskCategory category) {
    return tasksForCategory(category).where((task) => task.isCompleted).length;
  }

  bool hasCompletedCategory(TaskCategory category) {
    return tasksForCategory(category).any((task) => task.isCompleted);
  }

  bool shouldCelebrateTask(String taskId) => _celebrationTaskId == taskId;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final tasks = await StorageService.loadTasks();
    final xp = await StorageService.loadXP();
    var streak = await StorageService.loadStreak();
    final lastDate = await StorageService.loadLastDate();
    final bonusDate = await StorageService.loadCategoryBonusDate();
    final today = _formatDate(DateTime.now());

    List<Task> todayTasks = tasks;

    if (lastDate != today) {
      if (lastDate != null) {
        final yesterday = _formatDate(
          DateTime.now().subtract(const Duration(days: 1)),
        );
        if (lastDate == yesterday && tasks.any((task) => task.isCompleted)) {
          streak = streak > 0 ? streak + 1 : 1;
          await StorageService.saveStreak(streak);
        } else if (lastDate != yesterday) {
          streak = 0;
          await StorageService.saveStreak(streak);
        }
      }

      todayTasks = await StorageService.resetDailyTasks(tasks);
      await StorageService.saveLastDate(today);
    }

    _tasks = todayTasks;
    _totalXp = xp;
    _streak = streak;
    _dailyCategoryBonusEarned = bonusDate == today;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final task = _tasks[index];
    final wasCompleted = task.isCompleted;
    final today = _formatDate(DateTime.now());

    _tasks[index] = task.copyWith(isCompleted: !wasCompleted);

    if (!wasCompleted) {
      var xpGain = task.xpValue;
      var progressMessage = _progressLineForTask(task);

      _totalXp += task.xpValue;

      if (!_dailyCategoryBonusEarned && _completedOneInEachCategory()) {
        _dailyCategoryBonusEarned = true;
        _totalXp += categoryBonusXp;
        xpGain += categoryBonusXp;
        progressMessage = 'You cared for every category today. +$categoryBonusXp XP bonus.';
        await StorageService.saveCategoryBonusDate(today);
      }

      if (_streak == 0) {
        _streak = 1;
        await StorageService.saveStreak(_streak);
      }

      _showFeedback(
        taskId: task.id,
        xpGain: xpGain,
        message: progressMessage,
      );
    } else {
      _totalXp = (_totalXp - task.xpValue).clamp(0, 999999) as int;
    }

    notifyListeners();

    await StorageService.saveTasks(_tasks);
    await StorageService.saveXP(_totalXp);
    await StorageService.saveLastDate(today);
  }

  Future<void> addCustomTask(
    String label,
    String emoji,
    TaskCategory category,
  ) async {
    final newTask = Task(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      label: label,
      emoji: emoji,
      xpValue: 10,
      category: category,
      isDefault: false,
    );

    _tasks = List<Task>.from(_tasks)..add(newTask);
    notifyListeners();
    await StorageService.saveTasks(_tasks);
  }

  Future<void> deleteTask(String taskId) async {
    _tasks = _tasks.where((task) => task.id != taskId).toList();
    notifyListeners();
    await StorageService.saveTasks(_tasks);
  }

  Future<void> resetAllData() async {
    await StorageService.clearAll();
    _dailyCategoryBonusEarned = false;
    await loadData();
  }

  bool _completedOneInEachCategory() {
    return TaskCategory.values.every(hasCompletedCategory);
  }

  void _showFeedback({
    required String taskId,
    required int xpGain,
    required String message,
  }) {
    _celebrationTaskId = taskId;
    _celebrationXp = xpGain;
    _progressMessage = message;
    _feedbackToken += 1;
    final token = _feedbackToken;
    notifyListeners();

    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (token != _feedbackToken) {
        return;
      }

      _celebrationTaskId = null;
      _celebrationXp = 0;
      _progressMessage = null;
      notifyListeners();
    });
  }

  String _progressLineForTask(Task task) {
    if (completedCount <= 1) {
      return 'You showed up today. That counts.';
    }

    switch (task.category) {
      case TaskCategory.survival:
        return 'You took care of the basics. One step at a time.';
      case TaskCategory.wellness:
        return 'That was a kind thing to do for yourself.';
      case TaskCategory.growth:
        return 'Small forward steps still count.';
    }
  }

  GrowthStage _growthStageForXp(int xp) {
    var current = growthStages.first;
    for (final stage in growthStages) {
      if (xp >= stage.minXp) {
        current = stage;
      }
    }
    return current;
  }

  GrowthStage? _nextGrowthStageForXp(int xp) {
    for (final stage in growthStages) {
      if (xp < stage.minXp) {
        return stage;
      }
    }
    return null;
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
