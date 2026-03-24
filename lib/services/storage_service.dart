import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class StorageService {
  static const String _tasksKey = 'level_up_tasks';
  static const String _xpKey = 'level_up_total_xp';
  static const String _streakKey = 'level_up_streak';
  static const String _lastDateKey = 'level_up_last_date';
  static const String _unlockedKey = 'level_up_unlocked_rewards';
  static const String _categoryBonusDateKey = 'level_up_category_bonus_date';
  static const String _moodLevelKey = 'level_up_mood_level';
  static const String _moodDateKey = 'level_up_mood_date';
  static const String _affirmationsEnabledKey =
      'level_up_affirmations_enabled';
  static const String _affirmationsHourKey = 'level_up_affirmations_hour';
  static const String _affirmationsMinuteKey = 'level_up_affirmations_minute';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_tasksKey, jsonList);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_tasksKey);

    if (jsonList == null || jsonList.isEmpty) {
      return buildDefaultTasks();
    }

    return jsonList
        .map((item) => Task.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, xp);
  }

  static Future<int> loadXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  static Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }

  static Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> saveLastDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDateKey, date);
  }

  static Future<String?> loadLastDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDateKey);
  }

  static Future<void> saveUnlockedRewards(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unlockedKey, ids);
  }

  static Future<List<String>> loadUnlockedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedKey) ?? [];
  }

  static Future<void> saveCategoryBonusDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoryBonusDateKey, date);
  }

  static Future<String?> loadCategoryBonusDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_categoryBonusDateKey);
  }

  static Future<void> clearCategoryBonusDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_categoryBonusDateKey);
  }

  static Future<void> saveMoodCheckIn({
    required int level,
    required String date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_moodLevelKey, level);
    await prefs.setString(_moodDateKey, date);
  }

  static Future<int?> loadMoodLevelForDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_moodDateKey);
    if (savedDate != date) {
      return null;
    }

    return prefs.getInt(_moodLevelKey);
  }

  static Future<void> saveAffirmationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_affirmationsEnabledKey, enabled);
  }

  static Future<bool> loadAffirmationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_affirmationsEnabledKey) ?? false;
  }

  static Future<void> saveAffirmationTime({
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_affirmationsHourKey, hour);
    await prefs.setInt(_affirmationsMinuteKey, minute);
  }

  static Future<Map<String, int>> loadAffirmationTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt(_affirmationsHourKey) ?? 9,
      'minute': prefs.getInt(_affirmationsMinuteKey) ?? 0,
    };
  }

  static Future<List<Task>> resetDailyTasks(List<Task> tasks) async {
    final reset = tasks.map((t) => t.copyWith(isCompleted: false)).toList();
    await saveTasks(reset);
    return reset;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
