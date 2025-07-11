import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DifficultyLevelWidget extends StatelessWidget {
  final String selectedDifficulty;
  final Function(String) onDifficultyChanged;

  const DifficultyLevelWidget({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
  });

  final List<Map<String, dynamic>> _difficultyLevels = const [
    {
      'name': 'Easy',
      'points': 1,
      'color': Color(0xFF7FB069),
      'icon': 'sentiment_satisfied',
      'description': 'Simple habits you can do easily'
    },
    {
      'name': 'Medium',
      'points': 2,
      'color': Color(0xFFF4A261),
      'icon': 'sentiment_neutral',
      'description': 'Moderate effort required'
    },
    {
      'name': 'Hard',
      'points': 3,
      'color': Color(0xFFE76F51),
      'icon': 'sentiment_very_satisfied',
      'description': 'Challenging habits with high impact'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Level',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Difficulty affects point values and achievement rewards',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: _difficultyLevels.map((level) {
            final isSelected = selectedDifficulty == level['name'];
            return GestureDetector(
              onTap: () => onDifficultyChanged(level['name']),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? level['color'].withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? level['color']
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: level['color'].withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: level['icon'],
                        color: level['color'],
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                level['name'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? level['color']
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: level['color'].withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'stars',
                                      color: level['color'],
                                      size: 12,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${level['points']} pt${level['points'] > 1 ? 's' : ''}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: level['color'],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            level['description'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: level['color'],
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
