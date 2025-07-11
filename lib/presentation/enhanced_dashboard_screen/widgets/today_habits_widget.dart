import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';

class TodayHabitsWidget extends StatelessWidget {
  final List<HabitModel> habits;
  final Function(HabitModel) onHabitToggle;

  const TodayHabitsWidget({
    super.key,
    required this.habits,
    required this.onHabitToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCount = habits.where((h) => h.isCompletedToday).length;
    final completionRate =
        habits.isEmpty ? 0.0 : completedCount / habits.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Habits',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$completedCount/${habits.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress ring
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: completionRate,
                      strokeWidth: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(completionRate * 100).toInt()}%',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Complete',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Habits list
            if (habits.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_task_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No habits for today',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: habits.map((habit) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: habit.isCompletedToday
                          ? theme.colorScheme.secondaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: habit.isCompletedToday
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.outline,
                        width: habit.isCompletedToday ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Habit icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                    habit.color.replaceAll('#', '0xFF')))
                                .withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            habit.categoryIcon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Habit details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: habit.isCompletedToday
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              Text(
                                '${habit.currentStreak} day streak',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Completion checkbox
                        GestureDetector(
                          onTap: () => onHabitToggle(habit),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: habit.isCompletedToday
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: habit.isCompletedToday
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.outline,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              habit.isCompletedToday
                                  ? Icons.check
                                  : Icons.check_box_outline_blank,
                              color: habit.isCompletedToday
                                  ? theme.colorScheme.onSecondary
                                  : theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
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
}
