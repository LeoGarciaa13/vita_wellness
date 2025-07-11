import 'package:flutter/material.dart';

class HabitFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final String selectedSort;
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;

  const HabitFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedSort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  static const List<String> filters = [
    'All',
    'Active',
    'Paused',
    'Completed',
  ];

  static const List<String> sortOptions = [
    'Alphabetical',
    'Streak Length',
    'Creation Date',
    'Completion Rate',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected = selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => onFilterChanged(filter),
                  selectedColor: theme.colorScheme.primary.withAlpha(51),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Sort dropdown
        Row(
          children: [
            Icon(
              Icons.sort,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Sort by:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedSort,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                ),
                items: sortOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
