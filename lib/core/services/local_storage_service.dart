import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/habit_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _habitsKey = 'habits_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  static LocalStorageService? _instance;
  static LocalStorageService get instance =>
      _instance ??= LocalStorageService._();
  LocalStorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // User Management
  Future<void> saveUser(UserModel user) async {
    await init();
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    await init();
    final userString = _prefs!.getString(_userKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future<void> clearUser() async {
    await init();
    await _prefs!.remove(_userKey);
  }

  // Authentication State
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await init();
    await _prefs!.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
  }

  // Onboarding State
  Future<void> setOnboardingCompleted(bool completed) async {
    await init();
    await _prefs!.setBool(_onboardingCompletedKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    await init();
    return _prefs!.getBool(_onboardingCompletedKey) ?? false;
  }

  // Habits Management
  Future<void> saveHabits(List<HabitModel> habits) async {
    await init();
    final habitsJson = habits.map((habit) => habit.toJson()).toList();
    await _prefs!.setString(_habitsKey, jsonEncode(habitsJson));
  }

  Future<List<HabitModel>> getHabits() async {
    await init();
    final habitsString = _prefs!.getString(_habitsKey);
    if (habitsString != null) {
      final List<dynamic> habitsJson = jsonDecode(habitsString);
      return habitsJson.map((json) => HabitModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveHabit(HabitModel habit) async {
    final habits = await getHabits();
    final existingIndex = habits.indexWhere((h) => h.id == habit.id);

    if (existingIndex >= 0) {
      habits[existingIndex] = habit;
    } else {
      habits.add(habit);
    }

    await saveHabits(habits);
  }

  Future<void> deleteHabit(String habitId) async {
    final habits = await getHabits();
    habits.removeWhere((habit) => habit.id == habitId);
    await saveHabits(habits);
  }

  // General Settings
  Future<void> saveSetting(String key, dynamic value) async {
    await init();
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(key, value);
    }
  }

  Future<T?> getSetting<T>(String key) async {
    await init();
    final value = _prefs!.get(key);
    return value as T?;
  }

  Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}
