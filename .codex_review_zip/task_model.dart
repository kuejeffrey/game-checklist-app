// ============================================================
// models/task_model.dart — Data Model for Tasks
//
// This file defines what a "task" looks like as data.
// It also handles converting tasks to/from JSON so they
// can be saved and loaded from local storage.
// ============================================================

class Task {
  // ── Fields ──────────────────────────────────────────────
  final String id;          // Unique ID like "eat_meal" or "custom_1"
  final String label;       // Display text: "Eat a meal"
  final String emoji;       // Emoji icon: "🍽️"
  final int xpValue;        // How many XP points completing this gives
  bool isCompleted;         // Did the user check this off today?
  final bool isDefault;     // Is this a built-in task (vs custom)?

  Task({
    required this.id,
    required this.label,
    required this.emoji,
    required this.xpValue,
    this.isCompleted = false,
    this.isDefault = true,
  });

  // ── JSON Conversion ─────────────────────────────────────
  // toJson() converts a Task object into a Map so it can
  // be stored as a string in shared_preferences.

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'emoji': emoji,
    'xpValue': xpValue,
    'isCompleted': isCompleted,
    'isDefault': isDefault,
  };

  // fromJson() does the reverse — reads a stored Map and
  // creates a Task object from it.

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    label: json['label'],
    emoji: json['emoji'],
    xpValue: json['xpValue'] ?? 10,
    isCompleted: json['isCompleted'] ?? false,
    isDefault: json['isDefault'] ?? false,
  );

  // copyWith() lets us create a modified copy of a task
  // without changing the original (good Flutter practice).

  Task copyWith({bool? isCompleted}) => Task(
    id: id,
    label: label,
    emoji: emoji,
    xpValue: xpValue,
    isCompleted: isCompleted ?? this.isCompleted,
    isDefault: isDefault,
  );
}

// ── Default Task List ──────────────────────────────────────
// These are the tasks that appear for every new user.
// XP values are intentionally low and equal — no task
// is "more important" than another. Every step counts.

const List<Map<String, dynamic>> defaultTasksData = [
  {'id': 'eat_meal',      'label': 'Eat a meal',       'emoji': '🍽️',  'xpValue': 10},
  {'id': 'drink_water',   'label': 'Drink water',      'emoji': '💧',  'xpValue': 10},
  {'id': 'apply_job',     'label': 'Apply to a job',   'emoji': '📄',  'xpValue': 20},
  {'id': 'shower',        'label': 'Take a shower',    'emoji': '🚿',  'xpValue': 10},
  {'id': 'go_outside',    'label': 'Go outside',       'emoji': '☀️',  'xpValue': 15},
  {'id': 'sleep_time',    'label': 'Sleep on time',    'emoji': '🌙',  'xpValue': 15},
];

// Helper: build a fresh list of default Task objects
List<Task> buildDefaultTasks() {
  return defaultTasksData
      .map((data) => Task.fromJson({...data, 'isCompleted': false, 'isDefault': true}))
      .toList();
}
