import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReminderSectionWidget extends StatelessWidget {
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final List<TimeOfDay> additionalReminders;
  final Function(bool) onReminderToggle;
  final VoidCallback onTimeSelected;
  final VoidCallback onAddReminder;
  final Function(int) onRemoveReminder;

  const ReminderSectionWidget({
    super.key,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.additionalReminders,
    required this.onReminderToggle,
    required this.onTimeSelected,
    required this.onAddReminder,
    required this.onRemoveReminder,
  });

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reminders',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Switch(
              value: reminderEnabled,
              onChanged: onReminderToggle,
            ),
          ],
        ),
        if (reminderEnabled) ...[
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: onTimeSelected,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Primary Reminder',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Text(
                    _formatTime(reminderTime),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (additionalReminders.isNotEmpty) ...[
            SizedBox(height: 1.h),
            ...additionalReminders.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'notifications',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _formatTime(time),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => onRemoveReminder(index),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          SizedBox(height: 1.h),
          if (additionalReminders.length < 3)
            TextButton.icon(
              onPressed: onAddReminder,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text(
                'Add Another Reminder',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
