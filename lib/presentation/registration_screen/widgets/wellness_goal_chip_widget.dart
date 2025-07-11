import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WellnessGoalChipWidget extends StatelessWidget {
  final Map<String, dynamic> goal;
  final bool isSelected;
  final VoidCallback onTap;

  const WellnessGoalChipWidget({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (goal['color'] as Color).withValues(alpha: 0.15)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? (goal['color'] as Color)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (goal['color'] as Color).withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: goal['icon'] as String,
              color: isSelected
                  ? (goal['color'] as Color)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              goal['name'] as String,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? (goal['color'] as Color)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'check',
                color: goal['color'] as Color,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
