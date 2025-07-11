import '../models/user_model.dart';
import './habit_service.dart';
import './local_storage_service.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();
  UserService._();

  final LocalStorageService _localStorage = LocalStorageService.instance;
  final HabitService _habitService = HabitService.instance;

  Future<UserModel?> getCurrentUser() async {
    return await _localStorage.getUser();
  }

  Future<UserModel> createUser({
    required String fullName,
    required String email,
    String? avatarUrl,
    required String ageRange,
    required List<String> wellnessGoals,
    bool dailyReminders = true,
    bool streakCelebrations = true,
    bool weeklyReports = false,
    DateTime? reminderTime,
  }) async {
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      ageRange: ageRange,
      wellnessGoals: wellnessGoals,
      dailyReminders: dailyReminders,
      streakCelebrations: streakCelebrations,
      weeklyReports: weeklyReports,
      reminderTime: reminderTime,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _localStorage.saveUser(user);
    await _localStorage.setLoggedIn(true);
    return user;
  }

  Future<UserModel> updateUser(UserModel user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    await _localStorage.saveUser(updatedUser);
    return updatedUser;
  }

  Future<UserModel> updateUserPoints(int pointsToAdd) async {
    final user = await getCurrentUser();
    if (user == null) throw Exception('User not found');

    final updatedUser = user.copyWith(
      totalPoints: user.totalPoints + pointsToAdd,
      updatedAt: DateTime.now(),
    );

    await _localStorage.saveUser(updatedUser);
    return updatedUser;
  }

  Future<UserModel> updateUserStreak(int newStreak) async {
    final user = await getCurrentUser();
    if (user == null) throw Exception('User not found');

    final updatedUser = user.copyWith(
      weeklyStreak: newStreak,
      updatedAt: DateTime.now(),
    );

    await _localStorage.saveUser(updatedUser);
    return updatedUser;
  }

  Future<Map<String, dynamic>> getUserDashboardData() async {
    final user = await getCurrentUser();
    if (user == null) throw Exception('User not found');

    final habitStats = await _habitService.getHabitStats();
    final todaysHabits = await _habitService.getTodaysHabits();

    final completedToday = todaysHabits.where((h) => h.isCompletedToday).length;
    final totalToday = todaysHabits.length;

    return {
      'user': user,
      'completedToday': completedToday,
      'totalToday': totalToday,
      'completionRate': totalToday > 0 ? completedToday / totalToday : 0.0,
      'weeklyStreak': user.weeklyStreak,
      'totalPoints': user.totalPoints,
      'habitStats': habitStats,
    };
  }

  Future<bool> authenticateUser(String email, String password) async {
    // Mock authentication - in production, this would validate against a real backend
    if (email == 'wellness@vitaapp.com' && password == 'VitaWellness2024') {
      await _localStorage.setLoggedIn(true);

      // Create a mock user if none exists
      final existingUser = await getCurrentUser();
      if (existingUser == null) {
        await createUser(
          fullName: 'Wellness User',
          email: email,
          ageRange: '25-35',
          wellnessGoals: ['Fitness', 'Nutrition', 'Mindfulness'],
        );
      }

      return true;
    }
    return false;
  }

  Future<void> logoutUser() async {
    await _localStorage.setLoggedIn(false);
    await _localStorage.clearUser();
  }

  Future<bool> isUserLoggedIn() async {
    final isLoggedIn = await _localStorage.isLoggedIn();
    final user = await getCurrentUser();
    return isLoggedIn && user != null;
  }
}
