// ============================================================
// services/storage_service.dart — Local Data Persistence
//
// This file handles saving and loading all app data using
// the shared_preferences package, which stores simple
// key-value data directly on the user's device.
//
// No internet connection or account needed — everything
// is stored locally and privately.
// ============================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class StorageService {
  // ── Storage Keys ─────────────────────────────────────────
  // These are the "labels" for each piece of stored data.
  // Think of them like folder names in a filing cabinet.
  static const String _tasksKey      = 'level_up_tasks';
  static const String _xpKey         = 'level_up_total_xp';
  static const String _streakKey     = 'level_up_streak';
  static const String _lastDateKey   = 'level_up_last_date';
  static const String _unlockedKey   = 'level_up_unlocked_rewards';

  // ── Save Tasks ───────────────────────────────────────────
  // Converts the task list to JSON and stores it.
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_tasksKey, jsonList);
  }

  // ── Load Tasks ───────────────────────────────────────────
  // Reads stored tasks. If none exist yet, returns defaults.
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_tasksKey);

    if (jsonList == null || jsonList.isEmpty) {
      // First launch — return the default task list
      return buildDefaultTasks();
    }

    return jsonList
        .map((s) => Task.fromJson(jsonDecode(s)))
        .toList();
  }

  // ── XP Points ────────────────────────────────────────────
  static Future<void> saveXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, xp);
  }

  static Future<int> loadXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  // ── Streak Counter ────────────────────────────────────────
  // Streak = how many consecutive days the user completed
  // at least one task.
  static Future<void> saveStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }

  static Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // ── Last Active Date ─────────────────────────────────────
  // We store the last date so we can check if it's a new day
  // and reset/update the daily checklist and streak.
  static Future<void> saveLastDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDateKey, date);
  }

  static Future<String?> loadLastDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDateKey);
  }

  // ── Unlocked Rewards ─────────────────────────────────────
  // A list of reward IDs the user has unlocked so far.
  static Future<void> saveUnlockedRewards(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unlockedKey, ids);
  }

  static Future<List<String>> loadUnlockedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedKey) ?? [];
  }

  // ── Reset Daily Tasks ─────────────────────────────────────
  // Called each new day — marks all tasks as incomplete again
  // but keeps custom tasks and XP totals intact.
  static Future<List<Task>> resetDailyTasks(List<Task> tasks) async {
    final reset = tasks.map((t) => t.copyWith(isCompleted: false)).toList();
    await saveTasks(reset);
    return reset;
  }

  // ── Clear All Data ────────────────────────────────────────
  // Used in Settings to give the user a fresh start.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
