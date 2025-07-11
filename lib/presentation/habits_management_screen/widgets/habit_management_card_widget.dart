import 'package:flutter/material.dart';
import '../../../core/models/habit_model.dart';

class HabitManagementCardWidget extends StatelessWidget {
  final HabitModel habit;
  final bool isSelected;
  final bool isBulkMode;
  final bool isGridView;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompletion;

  const HabitManagementCardWidget({
    super.key,
    required this.habit,
    required this.isSelected,
    required this.isBulkMode,
    this.isGridView = false,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = _calculateCompletionRate();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8 : 2,
        margin: isGridView
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? BorderSide(color: theme.colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Color(int.parse(habit.color.replaceAll('#', '0xFF'))),
                Color(int.parse(habit.color.replaceAll('#', '0xFF')))
                    .withAlpha(179),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surface.withAlpha(230),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Category icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(
                                int.parse(habit.color.replaceAll('#', '0xFF')))
                            .withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        habit.categoryIcon,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Habit name and category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            habit.category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bulk mode checkbox or actions
                    if (isBulkMode)
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => onTap(),
                      )
                    else
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit();
                              break;
                            case 'delete':
                              onDelete();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                if (!isGridView) const SizedBox(height: 16),

                // Stats row
                if (!isGridView)
                  Row(
                    children: [
                      // Current streak
                      _buildStatChip(
                        context,
                        Icons.local_fire_department,
                        '${habit.currentStreak} days',
                        'Current Streak',
                      ),
                      const SizedBox(width: 12),

                      // Completion rate
                      _buildStatChip(
                        context,
                        Icons.analytics,
                        '${(completionRate * 100).toInt()}%',
                        'Completion Rate',
                      ),
                    ],
                  ),

                if (isGridView) ...[
                  const SizedBox(height: 8),

                  // Streak info for grid view
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak} days',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Progress bar
                  LinearProgressIndicator(
                    value: completionRate,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(int.parse(habit.color.replaceAll('#', '0xFF'))),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Bottom row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Difficulty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            _getDifficultyColor(habit.difficulty).withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        habit.difficulty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getDifficultyColor(habit.difficulty),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Completion button
                    if (!isBulkMode)
                      GestureDetector(
                        onTap: onToggleCompletion,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: habit.isCompletedToday
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            habit.isCompletedToday
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: habit.isCompletedToday
                                ? theme.colorScheme.onSecondary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateCompletionRate() {
    if (habit.completions.isEmpty) return 0.0;
    final daysSinceCreation =
        DateTime.now().difference(habit.createdAt).inDays + 1;
    return (habit.completions.length / daysSinceCreation).clamp(0.0, 1.0);
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
