import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/habit_card_widget.dart';
import './widgets/progress_ring_widget.dart';
import './widgets/quick_stats_widget.dart';

class HabitDashboard extends StatefulWidget {
  const HabitDashboard({super.key});

  @override
  State<HabitDashboard> createState() => _HabitDashboardState();
}

class _HabitDashboardState extends State<HabitDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  late AnimationController _celebrationController;
  late AnimationController _progressController;

  // Mock data for habits
  final List<Map<String, dynamic>> todaysHabits = [
    {
      "id": 1,
      "name": "Morning Meditation",
      "category": "Mindfulness",
      "categoryIcon": "self_improvement",
      "isCompleted": false,
      "currentStreak": 7,
      "pointValue": 15,
      "color": "0xFF7FB069",
      "completedAt": null,
    },
    {
      "id": 2,
      "name": "Drink 8 Glasses of Water",
      "category": "Nutrition",
      "categoryIcon": "local_drink",
      "isCompleted": true,
      "currentStreak": 12,
      "pointValue": 10,
      "color": "0xFF2D5A87",
      "completedAt": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 3,
      "name": "30 Min Walk",
      "category": "Fitness",
      "categoryIcon": "directions_walk",
      "isCompleted": false,
      "currentStreak": 5,
      "pointValue": 20,
      "color": "0xFFF4A261",
      "completedAt": null,
    },
    {
      "id": 4,
      "name": "Read for 20 Minutes",
      "category": "Learning",
      "categoryIcon": "menu_book",
      "isCompleted": false,
      "currentStreak": 3,
      "pointValue": 12,
      "color": "0xFFE76F51",
      "completedAt": null,
    },
    {
      "id": 5,
      "name": "Sleep 8 Hours",
      "category": "Sleep",
      "categoryIcon": "bedtime",
      "isCompleted": true,
      "currentStreak": 9,
      "pointValue": 18,
      "color": "0xFF264653",
      "completedAt": DateTime.now().subtract(Duration(hours: 8)),
    },
  ];

  final Map<String, dynamic> userStats = {
    "weeklyStreak": 4,
    "totalPoints": 1247,
    "nextRewardMilestone": 1500,
    "dailyCompletionPercentage": 0.4,
    "userName": "Alex",
  };

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _calculateProgress();
    _progressController.forward();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _calculateProgress() {
    final completedHabits =
        todaysHabits.where((habit) => habit["isCompleted"] as bool).length;
    final totalHabits = todaysHabits.length;
    userStats["dailyCompletionPercentage"] =
        totalHabits > 0 ? completedHabits / totalHabits : 0.0;
  }

  Future<void> _refreshHabits() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Trigger celebration animation
    _celebrationController.forward().then((_) {
      _celebrationController.reset();
    });

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleHabitCompletion(int habitId) {
    setState(() {
      final habitIndex =
          todaysHabits.indexWhere((habit) => habit["id"] == habitId);
      if (habitIndex != -1) {
        final habit = todaysHabits[habitIndex];
        final wasCompleted = habit["isCompleted"] as bool;

        habit["isCompleted"] = !wasCompleted;

        if (!wasCompleted) {
          // Habit completed
          habit["completedAt"] = DateTime.now();
          habit["currentStreak"] = (habit["currentStreak"] as int) + 1;
          userStats["totalPoints"] =
              (userStats["totalPoints"] as int) + (habit["pointValue"] as int);

          // Trigger haptic feedback
          HapticFeedback.lightImpact();

          // Trigger celebration animation
          _celebrationController.forward().then((_) {
            _celebrationController.reset();
          });
        } else {
          // Habit uncompleted
          habit["completedAt"] = null;
          habit["currentStreak"] = (habit["currentStreak"] as int) - 1;
          userStats["totalPoints"] =
              (userStats["totalPoints"] as int) - (habit["pointValue"] as int);
        }

        _calculateProgress();
        _progressController.reset();
        _progressController.forward();
      }
    });
  }

  void _showHabitActions(Map<String, dynamic> habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Edit Habit',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit habit screen
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'skip_next',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: Text(
                'Skip Today',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle skip today
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              title: Text(
                'View History',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to habit history
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning, ${userStats["userName"]}!',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'local_fire_department',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 20,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${userStats["weeklyStreak"]} day streak',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Progress Ring
                      ProgressRingWidget(
                        progress:
                            userStats["dailyCompletionPercentage"] as double,
                        controller: _progressController,
                      ),
                    ],
                  ),
                ),

                // Quick Stats
                QuickStatsWidget(
                  weeklyStreak: userStats["weeklyStreak"] as int,
                  totalPoints: userStats["totalPoints"] as int,
                  nextRewardMilestone: userStats["nextRewardMilestone"] as int,
                ),

                // Main Content
                Expanded(
                  child: todaysHabits.isEmpty
                      ? const EmptyStateWidget()
                      : RefreshIndicator(
                          onRefresh: _refreshHabits,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            itemCount: todaysHabits.length,
                            itemBuilder: (context, index) {
                              final habit = todaysHabits[index];
                              return HabitCardWidget(
                                habit: habit,
                                onToggleCompletion: () =>
                                    _toggleHabitCompletion(habit["id"] as int),
                                onLongPress: () => _showHabitActions(habit),
                                onSwipeRight: () => _showHabitActions(habit),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),

            // Celebration Animation Overlay
            AnimatedBuilder(
              animation: _celebrationController,
              builder: (context, child) {
                if (_celebrationController.value == 0) {
                  return const SizedBox.shrink();
                }

                return Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Transform.scale(
                          scale: _celebrationController.value,
                          child: Opacity(
                            opacity: 1 - _celebrationController.value,
                            child: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 8.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading Overlay
            if (_isRefreshing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/habit-creation-screen');
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Add Habit',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on Dashboard
              break;
            case 1:
              // Navigate to Habits
              break;
            case 2:
              // Navigate to Rewards
              break;
            case 3:
              Navigator.pushNamed(context, '/profile-setup-screen');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'checklist',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'card_giftcard',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
