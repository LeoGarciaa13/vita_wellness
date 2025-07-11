import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WellnessGoalsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final List<String> selectedGoals;
  final Function(List<String>) onGoalsChanged;

  const WellnessGoalsWidget({
    super.key,
    required this.goals,
    required this.selectedGoals,
    required this.onGoalsChanged,
  });

  void _toggleGoal(String goalName) {
    List<String> updatedGoals = List.from(selectedGoals);

    if (updatedGoals.contains(goalName)) {
      updatedGoals.remove(goalName);
    } else {
      if (updatedGoals.length < 5) {
        updatedGoals.add(goalName);
      }
    }

    onGoalsChanged(updatedGoals);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Wellness Goals',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Select 3-5 goals that matter most to you',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Goals Grid
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          children: goals.map((goal) {
            final isSelected = selectedGoals.contains(goal['name']);
            final goalColor = goal['color'] as Color;

            return GestureDetector(
              onTap: () => _toggleGoal(goal['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? goalColor.withValues(alpha: 0.15)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? goalColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? goalColor
                            : goalColor.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: goal['icon'],
                        color: isSelected ? Colors.white : goalColor,
                        size: 4.w,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      goal['name'],
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? goalColor
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: goalColor,
                        size: 4.w,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 2.h),

        // Selection counter
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: selectedGoals.length >= 3 && selectedGoals.length <= 5
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: selectedGoals.length >= 3 && selectedGoals.length <= 5
                    ? 'check_circle'
                    : 'info',
                color: selectedGoals.length >= 3 && selectedGoals.length <= 5
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                '${selectedGoals.length}/5 goals selected',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: selectedGoals.length >= 3 && selectedGoals.length <= 5
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
