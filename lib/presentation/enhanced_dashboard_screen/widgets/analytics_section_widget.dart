import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsSectionWidget extends StatelessWidget {
  final List<HabitModel> habits;
  final Map<String, dynamic> stats;

  const AnalyticsSectionWidget({
    super.key,
    required this.habits,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Analytics',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            // Weekly completion chart
            _buildWeeklyChart(context),

            const SizedBox(height: 20),

            // Category performance
            _buildCategoryPerformance(context),

            const SizedBox(height: 20),

            // Streak trends
            _buildStreakTrends(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Completion',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[value.toInt() % 7],
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getWeeklyData(),
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withAlpha(26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWeeklyData() {
    // Generate mock weekly data
    return List.generate(7, (index) {
      final completionRate = 0.4 + (index * 0.1) + (index % 2 == 0 ? 0.2 : 0.0);
      return FlSpot(index.toDouble(), completionRate.clamp(0.0, 1.0));
    });
  }

  Widget _buildCategoryPerformance(BuildContext context) {
    final theme = Theme.of(context);
    final categoryData = _getCategoryData();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Performance',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...categoryData.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: category['color'].withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category['icon'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: category['progress'],
                          backgroundColor:
                              theme.colorScheme.outline.withAlpha(51),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(category['color']),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(category['progress'] * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getCategoryData() {
    final Map<String, List<HabitModel>> categoryGroups = {};

    for (final habit in habits) {
      if (!categoryGroups.containsKey(habit.category)) {
        categoryGroups[habit.category] = [];
      }
      categoryGroups[habit.category]!.add(habit);
    }

    return categoryGroups.entries.map((entry) {
      final categoryHabits = entry.value;
      final completedCount =
          categoryHabits.where((h) => h.isCompletedToday).length;
      final progress =
          categoryHabits.isEmpty ? 0.0 : completedCount / categoryHabits.length;

      return {
        'name': entry.key,
        'icon': categoryHabits.first.categoryIcon,
        'progress': progress,
        'color': _getCategoryColor(entry.key),
      };
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Health':
        return Colors.green;
      case 'Fitness':
        return Colors.orange;
      case 'Mindfulness':
        return Colors.purple;
      case 'Productivity':
        return Colors.blue;
      case 'Learning':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStreakTrends(BuildContext context) {
    final theme = Theme.of(context);
    final longestStreak = habits.isEmpty
        ? 0
        : habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
    final averageStreak = habits.isEmpty
        ? 0.0
        : habits.map((h) => h.currentStreak).reduce((a, b) => a + b) /
            habits.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Streak Trends',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTrendItem(
                  context,
                  'Longest Streak',
                  '$longestStreak days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTrendItem(
                  context,
                  'Average Streak',
                  '${averageStreak.toInt()} days',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
