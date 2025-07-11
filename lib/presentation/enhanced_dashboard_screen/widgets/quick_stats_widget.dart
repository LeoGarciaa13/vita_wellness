import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';

class QuickStatsWidget extends StatelessWidget {
  final Map<String, dynamic> stats;
  final List<HabitModel> habits;

  const QuickStatsWidget({
    super.key,
    required this.stats,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPoints = stats['totalPoints'] ?? 0;
    final longestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
    final nextRewardMilestone = _getNextRewardMilestone(totalPoints);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Quick Stats',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Points',
                    totalPoints.toString(),
                    Icons.star,
                    Colors.amber,
                    'Keep earning!',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Longest Streak',
                    '$longestStreak days',
                    Icons.local_fire_department,
                    Colors.orange,
                    'Personal best!',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Reward progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withAlpha(26),
                    theme.colorScheme.secondary.withAlpha(26),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Next Reward',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextRewardMilestone['title'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: nextRewardMilestone['progress'],
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalPoints/${nextRewardMilestone['target']} points',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color, String subtitle) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getNextRewardMilestone(int currentPoints) {
    final milestones = [
      {'points': 100, 'title': 'Bronze Badge'},
      {'points': 500, 'title': 'Silver Badge'},
      {'points': 1000, 'title': 'Gold Badge'},
      {'points': 2500, 'title': 'Platinum Badge'},
      {'points': 5000, 'title': 'Diamond Badge'},
    ];

    for (final milestone in milestones) {
      if (currentPoints < (milestone['points'] as int)) {
        return {
          'title': milestone['title'],
          'target': milestone['points'],
          'progress': currentPoints / (milestone['points'] as int),
        };
      }
    }

    // If all milestones are achieved
    return {
      'title': 'Master Level Achieved!',
      'target': currentPoints,
      'progress': 1.0,
    };
  }
}
