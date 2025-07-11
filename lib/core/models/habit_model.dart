class HabitModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String categoryIcon;
  final String frequency;
  final List<String> customDays;
  final String difficulty;
  final int pointValue;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final List<DateTime> additionalReminders;
  final int currentStreak;
  final int bestStreak;
  final int streakGoal;
  final DateTime? endDate;
  final bool isPrivate;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HabitCompletion> completions;

  HabitModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    required this.categoryIcon,
    required this.frequency,
    this.customDays = const [],
    required this.difficulty,
    required this.pointValue,
    this.reminderEnabled = false,
    this.reminderTime,
    this.additionalReminders = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.streakGoal = 30,
    this.endDate,
    this.isPrivate = false,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.completions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'categoryIcon': categoryIcon,
      'frequency': frequency,
      'customDays': customDays,
      'difficulty': difficulty,
      'pointValue': pointValue,
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime?.toIso8601String(),
      'additionalReminders':
          additionalReminders.map((e) => e.toIso8601String()).toList(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'streakGoal': streakGoal,
      'endDate': endDate?.toIso8601String(),
      'isPrivate': isPrivate,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completions': completions.map((e) => e.toJson()).toList(),
    };
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'],
      categoryIcon: json['categoryIcon'],
      frequency: json['frequency'],
      customDays: List<String>.from(json['customDays'] ?? []),
      difficulty: json['difficulty'],
      pointValue: json['pointValue'],
      reminderEnabled: json['reminderEnabled'] ?? false,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      additionalReminders: (json['additionalReminders'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e))
              .toList() ??
          [],
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      streakGoal: json['streakGoal'] ?? 30,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isPrivate: json['isPrivate'] ?? false,
      color: json['color'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      completions: (json['completions'] as List<dynamic>?)
              ?.map((e) => HabitCompletion.fromJson(e))
              .toList() ??
          [],
    );
  }

  HabitModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? categoryIcon,
    String? frequency,
    List<String>? customDays,
    String? difficulty,
    int? pointValue,
    bool? reminderEnabled,
    DateTime? reminderTime,
    List<DateTime>? additionalReminders,
    int? currentStreak,
    int? bestStreak,
    int? streakGoal,
    DateTime? endDate,
    bool? isPrivate,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<HabitCompletion>? completions,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      difficulty: difficulty ?? this.difficulty,
      pointValue: pointValue ?? this.pointValue,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      additionalReminders: additionalReminders ?? this.additionalReminders,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      streakGoal: streakGoal ?? this.streakGoal,
      endDate: endDate ?? this.endDate,
      isPrivate: isPrivate ?? this.isPrivate,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completions: completions ?? this.completions,
    );
  }

  bool get isCompletedToday {
    final today = DateTime.now();
    return completions.any((completion) =>
        completion.date.year == today.year &&
        completion.date.month == today.month &&
        completion.date.day == today.day);
  }
}

class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime date;
  final String? note;
  final int pointsEarned;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    this.note,
    required this.pointsEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'note': note,
      'pointsEarned': pointsEarned,
    };
  }

  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      id: json['id'],
      habitId: json['habitId'],
      date: DateTime.parse(json['date']),
      note: json['note'],
      pointsEarned: json['pointsEarned'],
    );
  }
}
