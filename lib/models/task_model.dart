enum TaskCategory {
  survival,
  wellness,
  growth,
}

extension TaskCategoryX on TaskCategory {
  String get storageValue {
    switch (this) {
      case TaskCategory.survival:
        return 'survival';
      case TaskCategory.wellness:
        return 'wellness';
      case TaskCategory.growth:
        return 'growth';
    }
  }

  String get label {
    switch (this) {
      case TaskCategory.survival:
        return 'Survival';
      case TaskCategory.wellness:
        return 'Wellness';
      case TaskCategory.growth:
        return 'Growth';
    }
  }

  String get emoji {
    switch (this) {
      case TaskCategory.survival:
        return '\u{1F9E1}';
      case TaskCategory.wellness:
        return '\u{1F33F}';
      case TaskCategory.growth:
        return '\u2728';
    }
  }

  String get helperText {
    switch (this) {
      case TaskCategory.survival:
        return 'The basics that help you feel steady.';
      case TaskCategory.wellness:
        return 'Gentle care for your body and mind.';
      case TaskCategory.growth:
        return 'Small steps that build toward tomorrow.';
    }
  }
}

TaskCategory taskCategoryFromValue(String? value) {
  for (final category in TaskCategory.values) {
    if (category.storageValue == value) {
      return category;
    }
  }

  return TaskCategory.wellness;
}

class Task {
  const Task({
    required this.id,
    required this.label,
    required this.emoji,
    required this.xpValue,
    required this.category,
    this.isCompleted = false,
    this.isDefault = true,
  });

  final String id;
  final String label;
  final String emoji;
  final int xpValue;
  final TaskCategory category;
  final bool isCompleted;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'emoji': emoji,
        'xpValue': xpValue,
        'category': category.storageValue,
        'isCompleted': isCompleted,
        'isDefault': isDefault,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        label: json['label'] as String,
        emoji: json['emoji'] as String,
        xpValue: json['xpValue'] as int? ?? 10,
        category: taskCategoryFromValue(
          json['category'] as String? ?? _legacyCategoryForTask(json['id'] as String?),
        ),
        isCompleted: json['isCompleted'] as bool? ?? false,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  Task copyWith({
    bool? isCompleted,
    TaskCategory? category,
  }) =>
      Task(
        id: id,
        label: label,
        emoji: emoji,
        xpValue: xpValue,
        category: category ?? this.category,
        isCompleted: isCompleted ?? this.isCompleted,
        isDefault: isDefault,
      );
}

String? _legacyCategoryForTask(String? taskId) {
  switch (taskId) {
    case 'eat_meal':
    case 'drink_water':
    case 'sleep_time':
      return TaskCategory.survival.storageValue;
    case 'shower':
    case 'go_outside':
      return TaskCategory.wellness.storageValue;
    case 'apply_job':
      return TaskCategory.growth.storageValue;
    default:
      return TaskCategory.wellness.storageValue;
  }
}

const List<Map<String, dynamic>> defaultTasksData = [
  {
    'id': 'eat_meal',
    'label': 'Eat a meal',
    'emoji': '\u{1F37D}\uFE0F',
    'xpValue': 10,
    'category': 'survival',
  },
  {
    'id': 'drink_water',
    'label': 'Drink water',
    'emoji': '\u{1F4A7}',
    'xpValue': 10,
    'category': 'survival',
  },
  {
    'id': 'sleep_time',
    'label': 'Sleep on time',
    'emoji': '\u{1F319}',
    'xpValue': 15,
    'category': 'survival',
  },
  {
    'id': 'shower',
    'label': 'Take a shower',
    'emoji': '\u{1F6BF}',
    'xpValue': 10,
    'category': 'wellness',
  },
  {
    'id': 'go_outside',
    'label': 'Go outside',
    'emoji': '\u2600\uFE0F',
    'xpValue': 15,
    'category': 'wellness',
  },
  {
    'id': 'apply_job',
    'label': 'Apply to a job',
    'emoji': '\u{1F4C4}',
    'xpValue': 20,
    'category': 'growth',
  },
];

List<Task> buildDefaultTasks() {
  return defaultTasksData
      .map(
        (data) => Task.fromJson(
          {...data, 'isCompleted': false, 'isDefault': true},
        ),
      )
      .toList();
}
