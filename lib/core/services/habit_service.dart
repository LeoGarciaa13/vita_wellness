import 'dart:math';

import '../models/habit_model.dart';
import './local_storage_service.dart';

class HabitService {
  static HabitService? _instance;
  static HabitService get instance => _instance ??= HabitService._();
  HabitService._();

  final LocalStorageService _localStorage = LocalStorageService.instance;

  Future<List<HabitModel>> getAllHabits() async {
    return await _localStorage.getHabits();
  }

  Future<List<HabitModel>> getTodaysHabits() async {
    final habits = await getAllHabits();
    final today = DateTime.now();
    final todayWeekday = today.weekday;

    return habits.where((habit) {
      switch (habit.frequency) {
        case 'Daily':
          return true;
        case 'Weekdays':
          return todayWeekday >= 1 && todayWeekday <= 5;
        case 'Weekends':
          return todayWeekday == 6 || todayWeekday == 7;
        case 'Custom Days':
          final dayName = _getWeekdayName(todayWeekday);
          return habit.customDays.contains(dayName);
        default:
          return true;
      }
    }).toList();
  }

  Future<HabitModel> createHabit({
    required String name,
    String description = '',
    required String category,
    required String categoryIcon,
    required String frequency,
    List<String> customDays = const [],
    required String difficulty,
    bool reminderEnabled = false,
    DateTime? reminderTime,
    List<DateTime> additionalReminders = const [],
    int streakGoal = 30,
    DateTime? endDate,
    bool isPrivate = false,
    required String color,
  }) async {
    final habit = HabitModel(
      id: _generateId(),
      name: name,
      description: description,
      category: category,
      categoryIcon: categoryIcon,
      frequency: frequency,
      customDays: customDays,
      difficulty: difficulty,
      pointValue: _calculatePointValue(difficulty),
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      additionalReminders: additionalReminders,
      streakGoal: streakGoal,
      endDate: endDate,
      isPrivate: isPrivate,
      color: color,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _localStorage.saveHabit(habit);
    return habit;
  }

  Future<HabitModel> updateHabit(HabitModel habit) async {
    final updatedHabit = habit.copyWith(updatedAt: DateTime.now());
    await _localStorage.saveHabit(updatedHabit);
    return updatedHabit;
  }

  Future<void> deleteHabit(String habitId) async {
    await _localStorage.deleteHabit(habitId);
  }

  Future<HabitModel> toggleHabitCompletion(String habitId) async {
    final habits = await getAllHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);

    if (habitIndex == -1) {
      throw Exception('Habit not found');
    }

    final habit = habits[habitIndex];
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final existingCompletion = habit.completions.firstWhere(
      (completion) =>
          completion.date.year == today.year &&
          completion.date.month == today.month &&
          completion.date.day == today.day,
      orElse: () => HabitCompletion(
        id: '',
        habitId: '',
        date: DateTime(1970),
        pointsEarned: 0,
      ),
    );

    HabitModel updatedHabit;

    if (existingCompletion.id.isEmpty) {
      // Add completion
      final completion = HabitCompletion(
        id: _generateId(),
        habitId: habitId,
        date: todayStart,
        pointsEarned: habit.pointValue,
      );

      final updatedCompletions = [...habit.completions, completion];
      final newStreak = _calculateStreak(updatedCompletions);

      updatedHabit = habit.copyWith(
        completions: updatedCompletions,
        currentStreak: newStreak,
        bestStreak: max(habit.bestStreak, newStreak),
        updatedAt: DateTime.now(),
      );
    } else {
      // Remove completion
      final updatedCompletions = habit.completions
          .where((c) => c.id != existingCompletion.id)
          .toList();

      final newStreak = _calculateStreak(updatedCompletions);

      updatedHabit = habit.copyWith(
        completions: updatedCompletions,
        currentStreak: newStreak,
        updatedAt: DateTime.now(),
      );
    }

    await _localStorage.saveHabit(updatedHabit);
    return updatedHabit;
  }

  Future<Map<String, dynamic>> getHabitStats() async {
    final habits = await getAllHabits();
    final today = DateTime.now();
    final todayHabits = await getTodaysHabits();

    final completedToday = todayHabits.where((h) => h.isCompletedToday).length;
    final completionRate =
        todayHabits.isEmpty ? 0.0 : completedToday / todayHabits.length;

    int totalPoints = 0;
    int totalCompletions = 0;

    for (final habit in habits) {
      for (final completion in habit.completions) {
        totalPoints += completion.pointsEarned;
        totalCompletions++;
      }
    }

    return {
      'totalHabits': habits.length,
      'todayHabits': todayHabits.length,
      'completedToday': completedToday,
      'completionRate': completionRate,
      'totalPoints': totalPoints,
      'totalCompletions': totalCompletions,
      'averageStreak': habits.isEmpty
          ? 0
          : habits.map((h) => h.currentStreak).reduce((a, b) => a + b) /
              habits.length,
    };
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  int _calculatePointValue(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 1;
      case 'Hard':
        return 3;
      default:
        return 2;
    }
  }

  int _calculateStreak(List<HabitCompletion> completions) {
    if (completions.isEmpty) return 0;

    final sortedCompletions = completions.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (final completion in sortedCompletions) {
      final completionDate = DateTime(
        completion.date.year,
        completion.date.month,
        completion.date.day,
      );

      final expectedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      if (completionDate == expectedDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
