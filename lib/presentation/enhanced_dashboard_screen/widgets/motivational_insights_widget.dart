import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';

class MotivationalInsightsWidget extends StatelessWidget {
  final List<HabitModel> habits;
  final Map<String, dynamic> stats;

  const MotivationalInsightsWidget({
    super.key,
    required this.habits,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insights = _generateInsights();

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
                  Icons.lightbulb,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Motivational Insights',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Insights
            ...insights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;

              return Container(
                margin: EdgeInsets.only(
                    bottom: index < insights.length - 1 ? 12 : 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      insight['color'].withAlpha(26),
                      insight['color'].withAlpha(13),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: insight['color'].withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      insight['icon'],
                      color: insight['color'],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight['title'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: insight['color'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insight['message'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateInsights() {
    final insights = <Map<String, dynamic>>[];

    // Analyze patterns and generate insights
    if (habits.isNotEmpty) {
      // Best performing day
      final bestDay = _getBestPerformingDay();
      if (bestDay != null) {
        insights.add({
          'title': 'Peak Performance Day',
          'message':
              'You\'re strongest on ${bestDay}s! Your completion rate is highest on this day.',
          'icon': Icons.star,
          'color': Colors.amber,
        });
      }

      // Category insight
      final strongestCategory = _getStrongestCategory();
      if (strongestCategory != null) {
        insights.add({
          'title': 'Category Champion',
          'message':
              'Your $strongestCategory habits are thriving! They boost your overall consistency.',
          'icon': Icons.category,
          'color': Colors.green,
        });
      }

      // Streak insight
      final longestStreak =
          habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
      if (longestStreak > 7) {
        insights.add({
          'title': 'Streak Master',
          'message':
              'Your longest streak is $longestStreak days! That\'s the power of consistency.',
          'icon': Icons.local_fire_department,
          'color': Colors.orange,
        });
      }

      // Improvement suggestion
      final improvementArea = _getImprovementArea();
      if (improvementArea != null) {
        insights.add({
          'title': 'Growth Opportunity',
          'message':
              'Focus on your $improvementArea habits. Small improvements here will have big impact!',
          'icon': Icons.trending_up,
          'color': Colors.blue,
        });
      }
    }

    // Add motivational message if no specific insights
    if (insights.isEmpty) {
      insights.add({
        'title': 'Fresh Start',
        'message':
            'Every day is a new opportunity to build better habits. Start with just one!',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
      });
    }

    return insights;
  }

  String? _getBestPerformingDay() {
    // Mock implementation - in real app, analyze completion data by day
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final completionRates = [0.8, 0.7, 0.9, 0.6, 0.8, 0.5, 0.4];

    var bestDay = '';
    var bestRate = 0.0;

    for (var i = 0; i < days.length; i++) {
      if (completionRates[i] > bestRate) {
        bestRate = completionRates[i];
        bestDay = days[i];
      }
    }

    return bestRate > 0.7 ? bestDay : null;
  }

  String? _getStrongestCategory() {
    if (habits.isEmpty) return null;

    final Map<String, List<HabitModel>> categoryGroups = {};

    for (final habit in habits) {
      if (!categoryGroups.containsKey(habit.category)) {
        categoryGroups[habit.category] = [];
      }
      categoryGroups[habit.category]!.add(habit);
    }

    var bestCategory = '';
    var bestRate = 0.0;

    for (final entry in categoryGroups.entries) {
      final categoryHabits = entry.value;
      final completedCount =
          categoryHabits.where((h) => h.isCompletedToday).length;
      final rate =
          categoryHabits.isEmpty ? 0.0 : completedCount / categoryHabits.length;

      if (rate > bestRate) {
        bestRate = rate;
        bestCategory = entry.key;
      }
    }

    return bestRate > 0.6 ? bestCategory : null;
  }

  String? _getImprovementArea() {
    if (habits.isEmpty) return null;

    final Map<String, List<HabitModel>> categoryGroups = {};

    for (final habit in habits) {
      if (!categoryGroups.containsKey(habit.category)) {
        categoryGroups[habit.category] = [];
      }
      categoryGroups[habit.category]!.add(habit);
    }

    var worstCategory = '';
    var worstRate = 1.0;

    for (final entry in categoryGroups.entries) {
      final categoryHabits = entry.value;
      final completedCount =
          categoryHabits.where((h) => h.isCompletedToday).length;
      final rate =
          categoryHabits.isEmpty ? 0.0 : completedCount / categoryHabits.length;

      if (rate < worstRate) {
        worstRate = rate;
        worstCategory = entry.key;
      }
    }

    return worstRate < 0.5 ? worstCategory : null;
  }
}
