class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String ageRange;
  final List<String> wellnessGoals;
  final int totalPoints;
  final int weeklyStreak;
  final bool dailyReminders;
  final bool streakCelebrations;
  final bool weeklyReports;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.ageRange,
    required this.wellnessGoals,
    this.totalPoints = 0,
    this.weeklyStreak = 0,
    this.dailyReminders = true,
    this.streakCelebrations = true,
    this.weeklyReports = false,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'avatarUrl': avatarUrl,
      'ageRange': ageRange,
      'wellnessGoals': wellnessGoals,
      'totalPoints': totalPoints,
      'weeklyStreak': weeklyStreak,
      'dailyReminders': dailyReminders,
      'streakCelebrations': streakCelebrations,
      'weeklyReports': weeklyReports,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      ageRange: json['ageRange'],
      wellnessGoals: List<String>.from(json['wellnessGoals']),
      totalPoints: json['totalPoints'] ?? 0,
      weeklyStreak: json['weeklyStreak'] ?? 0,
      dailyReminders: json['dailyReminders'] ?? true,
      streakCelebrations: json['streakCelebrations'] ?? true,
      weeklyReports: json['weeklyReports'] ?? false,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? ageRange,
    List<String>? wellnessGoals,
    int? totalPoints,
    int? weeklyStreak,
    bool? dailyReminders,
    bool? streakCelebrations,
    bool? weeklyReports,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ageRange: ageRange ?? this.ageRange,
      wellnessGoals: wellnessGoals ?? this.wellnessGoals,
      totalPoints: totalPoints ?? this.totalPoints,
      weeklyStreak: weeklyStreak ?? this.weeklyStreak,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      streakCelebrations: streakCelebrations ?? this.streakCelebrations,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
