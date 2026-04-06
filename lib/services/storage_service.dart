import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import 'supabase_service.dart';

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
  static const String _migrationFlagKey = 'level_up_scoped_storage_migrated';
  static const String _legacyDataClaimedByUserKey =
      'level_up_legacy_data_claimed_by_user';

  static const List<String> _scopedBaseKeys = [
    _tasksKey,
    _xpKey,
    _streakKey,
    _lastDateKey,
    _unlockedKey,
    _categoryBonusDateKey,
    _moodLevelKey,
    _moodDateKey,
    _affirmationsEnabledKey,
    _affirmationsHourKey,
    _affirmationsMinuteKey,
  ];

  static String _scopedKey(String baseKey) {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return baseKey;
    }

    return '${baseKey}_$userId';
  }

  static String _migrationKeyForCurrentUser() {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return _migrationFlagKey;
    }

    return '${_migrationFlagKey}_$userId';
  }

  static Future<SharedPreferences> _prefs() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyDataIfNeeded(prefs);
    return prefs;
  }

  static Future<void> _migrateLegacyDataIfNeeded(SharedPreferences prefs) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final migrationKey = _migrationKeyForCurrentUser();
    if (prefs.getBool(migrationKey) ?? false) {
      return;
    }

    final claimedByUserId = prefs.getString(_legacyDataClaimedByUserKey);
    if (claimedByUserId != null && claimedByUserId != userId) {
      await prefs.setBool(migrationKey, true);
      return;
    }

    var copiedAnyLegacyValues = false;

    for (final baseKey in _scopedBaseKeys) {
      final scopedKey = _scopedKey(baseKey);
      if (prefs.containsKey(scopedKey) || !prefs.containsKey(baseKey)) {
        continue;
      }

      final value = prefs.get(baseKey);
      if (value is int) {
        await prefs.setInt(scopedKey, value);
        copiedAnyLegacyValues = true;
      } else if (value is bool) {
        await prefs.setBool(scopedKey, value);
        copiedAnyLegacyValues = true;
      } else if (value is String) {
        await prefs.setString(scopedKey, value);
        copiedAnyLegacyValues = true;
      } else if (value is List<String>) {
        await prefs.setStringList(scopedKey, value);
        copiedAnyLegacyValues = true;
      }
    }

    if (copiedAnyLegacyValues && claimedByUserId == null) {
      await prefs.setString(_legacyDataClaimedByUserKey, userId);
    }

    await prefs.setBool(migrationKey, true);
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await _prefs();
    final jsonList = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_scopedKey(_tasksKey), jsonList);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await _prefs();
    final jsonList = prefs.getStringList(_scopedKey(_tasksKey));

    if (jsonList == null || jsonList.isEmpty) {
      return buildDefaultTasks();
    }

    return jsonList
        .map((item) => Task.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveXP(int xp) async {
    final prefs = await _prefs();
    await prefs.setInt(_scopedKey(_xpKey), xp);
  }

  static Future<int> loadXP() async {
    final prefs = await _prefs();
    return prefs.getInt(_scopedKey(_xpKey)) ?? 0;
  }

  static Future<void> saveStreak(int streak) async {
    final prefs = await _prefs();
    await prefs.setInt(_scopedKey(_streakKey), streak);
  }

  static Future<int> loadStreak() async {
    final prefs = await _prefs();
    return prefs.getInt(_scopedKey(_streakKey)) ?? 0;
  }

  static Future<void> saveLastDate(String date) async {
    final prefs = await _prefs();
    await prefs.setString(_scopedKey(_lastDateKey), date);
  }

  static Future<String?> loadLastDate() async {
    final prefs = await _prefs();
    return prefs.getString(_scopedKey(_lastDateKey));
  }

  static Future<void> saveUnlockedRewards(List<String> ids) async {
    final prefs = await _prefs();
    await prefs.setStringList(_scopedKey(_unlockedKey), ids);
  }

  static Future<List<String>> loadUnlockedRewards() async {
    final prefs = await _prefs();
    return prefs.getStringList(_scopedKey(_unlockedKey)) ?? [];
  }

  static Future<void> saveCategoryBonusDate(String date) async {
    final prefs = await _prefs();
    await prefs.setString(_scopedKey(_categoryBonusDateKey), date);
  }

  static Future<String?> loadCategoryBonusDate() async {
    final prefs = await _prefs();
    return prefs.getString(_scopedKey(_categoryBonusDateKey));
  }

  static Future<void> clearCategoryBonusDate() async {
    final prefs = await _prefs();
    await prefs.remove(_scopedKey(_categoryBonusDateKey));
  }

  static Future<void> saveMoodCheckIn({
    required int level,
    required String date,
  }) async {
    final prefs = await _prefs();
    await prefs.setInt(_scopedKey(_moodLevelKey), level);
    await prefs.setString(_scopedKey(_moodDateKey), date);
  }

  static Future<int?> loadMoodLevelForDate(String date) async {
    final prefs = await _prefs();
    final savedDate = prefs.getString(_scopedKey(_moodDateKey));
    if (savedDate != date) {
      return null;
    }

    return prefs.getInt(_scopedKey(_moodLevelKey));
  }

  static Future<void> saveAffirmationsEnabled(bool enabled) async {
    final prefs = await _prefs();
    await prefs.setBool(_scopedKey(_affirmationsEnabledKey), enabled);
  }

  static Future<bool> loadAffirmationsEnabled() async {
    final prefs = await _prefs();
    return prefs.getBool(_scopedKey(_affirmationsEnabledKey)) ?? false;
  }

  static Future<void> saveAffirmationTime({
    required int hour,
    required int minute,
  }) async {
    final prefs = await _prefs();
    await prefs.setInt(_scopedKey(_affirmationsHourKey), hour);
    await prefs.setInt(_scopedKey(_affirmationsMinuteKey), minute);
  }

  static Future<Map<String, int>> loadAffirmationTime() async {
    final prefs = await _prefs();
    return {
      'hour': prefs.getInt(_scopedKey(_affirmationsHourKey)) ?? 9,
      'minute': prefs.getInt(_scopedKey(_affirmationsMinuteKey)) ?? 0,
    };
  }

  static Future<List<Task>> resetDailyTasks(List<Task> tasks) async {
    final reset = tasks.map((t) => t.copyWith(isCompleted: false)).toList();
    await saveTasks(reset);
    return reset;
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs();

    for (final baseKey in _scopedBaseKeys) {
      await prefs.remove(_scopedKey(baseKey));
    }

    await prefs.remove(_migrationKeyForCurrentUser());
  }
}
