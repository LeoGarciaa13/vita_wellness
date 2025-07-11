import 'package:flutter/material.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onBulkDelete;
  final VoidCallback onBulkEdit;

  const BulkActionsWidget({
    super.key,
    required this.selectedCount,
    required this.onBulkDelete,
    required this.onBulkEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Selection count
          Expanded(
            child: Text(
              '$selectedCount habit${selectedCount == 1 ? '' : 's'} selected',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),

          // Bulk actions
          Row(
            children: [
              // Edit button
              IconButton(
                onPressed: onBulkEdit,
                icon: const Icon(Icons.edit),
                tooltip: 'Edit selected habits',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(width: 8),

              // Delete button
              IconButton(
                onPressed: onBulkDelete,
                icon: const Icon(Icons.delete),
                tooltip: 'Delete selected habits',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
