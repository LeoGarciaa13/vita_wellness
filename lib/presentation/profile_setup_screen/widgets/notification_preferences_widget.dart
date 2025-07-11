import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final bool dailyReminders;
  final bool streakCelebrations;
  final bool weeklyReports;
  final Function(bool) onDailyRemindersChanged;
  final Function(bool) onStreakCelebrationsChanged;
  final Function(bool) onWeeklyReportsChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.dailyReminders,
    required this.streakCelebrations,
    required this.weeklyReports,
    required this.onDailyRemindersChanged,
    required this.onStreakCelebrationsChanged,
    required this.onWeeklyReportsChanged,
  });

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required String iconName,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose how you\'d like to stay motivated',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        _buildNotificationTile(
          title: 'Daily Reminders',
          subtitle: 'Get gentle nudges to complete your habits',
          iconName: 'notifications',
          value: dailyReminders,
          onChanged: onDailyRemindersChanged,
        ),

        _buildNotificationTile(
          title: 'Streak Celebrations',
          subtitle: 'Celebrate when you reach habit milestones',
          iconName: 'celebration',
          value: streakCelebrations,
          onChanged: onStreakCelebrationsChanged,
        ),

        _buildNotificationTile(
          title: 'Weekly Reports',
          subtitle: 'Get insights on your weekly progress',
          iconName: 'assessment',
          value: weeklyReports,
          onChanged: onWeeklyReportsChanged,
        ),

        // Privacy note
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'You can change these preferences anytime in your settings. We respect your privacy and won\'t send unnecessary notifications.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
