import 'package:flutter/material.dart';

class EmptyHabitsWidget extends StatelessWidget {
  final String filter;
  final VoidCallback onCreateHabit;

  const EmptyHabitsWidget({
    super.key,
    required this.filter,
    required this.onCreateHabit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getEmptyStateIcon(),
                size: 60,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              _getEmptyStateTitle(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              _getEmptyStateDescription(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            ElevatedButton(
              onPressed: onCreateHabit,
              child: Text(_getActionText()),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (filter) {
      case 'Active':
        return Icons.local_fire_department_outlined;
      case 'Paused':
        return Icons.pause_circle_outline;
      case 'Completed':
        return Icons.check_circle_outline;
      default:
        return Icons.add_task_outlined;
    }
  }

  String _getEmptyStateTitle() {
    switch (filter) {
      case 'Active':
        return 'No Active Habits';
      case 'Paused':
        return 'No Paused Habits';
      case 'Completed':
        return 'No Completed Habits';
      default:
        return 'No Habits Yet';
    }
  }

  String _getEmptyStateDescription() {
    switch (filter) {
      case 'Active':
        return 'You don\'t have any active habits with current streaks. Start building some consistency!';
      case 'Paused':
        return 'You don\'t have any paused habits. Keep your momentum going!';
      case 'Completed':
        return 'You haven\'t completed any habit goals yet. Keep working towards your targets!';
      default:
        return 'Start your wellness journey by creating your first habit. Small steps lead to big changes!';
    }
  }

  String _getActionText() {
    switch (filter) {
      case 'Active':
        return 'Create Active Habit';
      case 'Paused':
        return 'Create New Habit';
      case 'Completed':
        return 'Set New Goal';
      default:
        return 'Create First Habit';
    }
  }
}
