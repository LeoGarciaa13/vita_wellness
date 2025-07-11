import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';

class AchievementsCarouselWidget extends StatelessWidget {
  final List<HabitModel> habits;
  final Map<String, dynamic> stats;

  const AchievementsCarouselWidget({
    super.key,
    required this.habits,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = _getAchievements();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Achievements',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Achievements carousel
            if (achievements.isEmpty)
              _buildEmptyAchievements(context)
            else
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = achievements[index];
                    return Container(
                      width: 120,
                      margin: EdgeInsets.only(
                          right: index < achievements.length - 1 ? 12 : 0),
                      child: GestureDetector(
                        onTap: () =>
                            _showAchievementDetails(context, achievement),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                achievement['color'].withAlpha(51),
                                achievement['color'].withAlpha(26),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: achievement['color'].withAlpha(77),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                achievement['icon'],
                                size: 36,
                                color: achievement['color'],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                achievement['title'],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: achievement['color'],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                achievement['date'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAchievements(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'No achievements yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete habits to unlock badges!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAchievements() {
    final achievements = <Map<String, dynamic>>[];
    final totalPoints = stats['totalPoints'] ?? 0;

    // Check for various achievements
    if (totalPoints >= 100) {
      achievements.add({
        'id': 'first_100',
        'title': 'First 100 Points',
        'description': 'Earned your first 100 points!',
        'icon': Icons.looks_one,
        'color': Colors.green,
        'date': 'Today',
      });
    }

    if (habits.isNotEmpty) {
      final longestStreak =
          habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);

      if (longestStreak >= 7) {
        achievements.add({
          'id': 'week_streak',
          'title': 'Week Warrior',
          'description': 'Maintained a 7-day streak!',
          'icon': Icons.local_fire_department,
          'color': Colors.orange,
          'date': 'Yesterday',
        });
      }

      if (longestStreak >= 30) {
        achievements.add({
          'id': 'month_streak',
          'title': 'Month Master',
          'description': 'Achieved a 30-day streak!',
          'icon': Icons.star,
          'color': Colors.purple,
          'date': '2 days ago',
        });
      }

      // Category-specific achievements
      final categoryCount = _getCategoryCount();
      if (categoryCount >= 3) {
        achievements.add({
          'id': 'multi_category',
          'title': 'Well-Rounded',
          'description': 'Active in 3+ categories!',
          'icon': Icons.category,
          'color': Colors.blue,
          'date': '3 days ago',
        });
      }
    }

    // Perfect day achievement
    final todayHabits = habits.where((h) => h.isCompletedToday).length;
    if (todayHabits >= 3) {
      achievements.add({
        'id': 'perfect_day',
        'title': 'Perfect Day',
        'description': 'Completed all habits today!',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'date': 'Today',
      });
    }

    return achievements.take(5).toList();
  }

  int _getCategoryCount() {
    final categories = <String>{};
    for (final habit in habits) {
      categories.add(habit.category);
    }
    return categories.length;
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              achievement['icon'],
              color: achievement['color'],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(achievement['title']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement['description']),
            const SizedBox(height: 8),
            Text(
              'Earned: ${achievement['date']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
