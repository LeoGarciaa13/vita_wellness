import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/models/habit_model.dart';
import '../../../routes/app_routes.dart';

class HabitSuggestionsWidget extends StatelessWidget {
  final List<HabitModel> existingHabits;
  final Map<String, dynamic> stats;

  const HabitSuggestionsWidget({
    super.key,
    required this.existingHabits,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _generateSuggestions();

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
                  Icons.recommend,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Habit Suggestions',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Suggestions list
            if (suggestions.isEmpty)
              _buildEmptyState(context)
            else
              Column(
                children: suggestions.map((suggestion) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(77),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Suggestion icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: suggestion['color'].withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            suggestion['icon'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Suggestion details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion['title'],
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                suggestion['description'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                suggestion['reason'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: suggestion['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Add button
                        IconButton(
                          onPressed: () =>
                              _addSuggestedHabit(context, suggestion),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: theme.colorScheme.primary,
                          ),
                          tooltip: 'Add this habit',
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'All set for now!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You have a great habit collection. Keep up the good work!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateSuggestions() {
    final suggestions = <Map<String, dynamic>>[];
    final existingCategories = existingHabits.map((h) => h.category).toSet();

    // Suggest habits based on missing categories
    if (!existingCategories.contains('Health')) {
      suggestions.add({
        'title': 'Drink Water',
        'description': 'Stay hydrated with 8 glasses daily',
        'reason': 'Essential for overall health',
        'icon': '💧',
        'color': Colors.blue,
        'category': 'Health',
      });
    }

    if (!existingCategories.contains('Fitness')) {
      suggestions.add({
        'title': 'Daily Walk',
        'description': '30 minutes of walking daily',
        'reason': 'Great for cardiovascular health',
        'icon': '🚶',
        'color': Colors.green,
        'category': 'Fitness',
      });
    }

    if (!existingCategories.contains('Mindfulness')) {
      suggestions.add({
        'title': 'Meditation',
        'description': '10 minutes of daily meditation',
        'reason': 'Reduces stress and improves focus',
        'icon': '🧘',
        'color': Colors.purple,
        'category': 'Mindfulness',
      });
    }

    if (!existingCategories.contains('Learning')) {
      suggestions.add({
        'title': 'Read Books',
        'description': '20 minutes of reading daily',
        'reason': 'Expands knowledge and vocabulary',
        'icon': '📚',
        'color': Colors.orange,
        'category': 'Learning',
      });
    }

    if (!existingCategories.contains('Productivity')) {
      suggestions.add({
        'title': 'Plan Tomorrow',
        'description': '5 minutes planning next day',
        'reason': 'Improves organization and reduces stress',
        'icon': '📝',
        'color': Colors.red,
        'category': 'Productivity',
      });
    }

    // Suggest complementary habits based on existing ones
    if (existingCategories.contains('Fitness')) {
      suggestions.add({
        'title': 'Protein Shake',
        'description': 'Post-workout protein intake',
        'reason': 'Complements your fitness routine',
        'icon': '🥤',
        'color': Colors.brown,
        'category': 'Health',
      });
    }

    if (existingCategories.contains('Learning')) {
      suggestions.add({
        'title': 'Practice Skills',
        'description': 'Apply what you learn daily',
        'reason': 'Reinforces your learning habits',
        'icon': '⚡',
        'color': Colors.yellow,
        'category': 'Learning',
      });
    }

    return suggestions.take(3).toList();
  }

  void _addSuggestedHabit(
      BuildContext context, Map<String, dynamic> suggestion) {
    Navigator.pushNamed(
      context,
      AppRoutes.habitCreationScreen,
      arguments: {
        'prefilled': {
          'name': suggestion['title'],
          'description': suggestion['description'],
          'category': suggestion['category'],
          'categoryIcon': suggestion['icon'],
          'color':
              '#${suggestion['color'].value.toRadixString(16).substring(2)}',
        }
      },
    );
  }
}
