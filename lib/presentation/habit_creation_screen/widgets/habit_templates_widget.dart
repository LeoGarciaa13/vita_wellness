import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitTemplatesWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onTemplateSelected;

  const HabitTemplatesWidget({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<HabitTemplatesWidget> createState() => _HabitTemplatesWidgetState();
}

class _HabitTemplatesWidgetState extends State<HabitTemplatesWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _habitTemplates = [
    {
      'name': 'Morning Walk',
      'category': 'Fitness',
      'difficulty': 'Easy',
      'frequency': 'Daily',
      'description': 'Start your day with a refreshing 20-minute walk',
      'icon': 'directions_walk',
      'color': Color(0xFF7FB069),
    },
    {
      'name': 'Drink 8 Glasses of Water',
      'category': 'Nutrition',
      'difficulty': 'Easy',
      'frequency': 'Daily',
      'description': 'Stay hydrated throughout the day',
      'icon': 'local_drink',
      'color': Color(0xFF2196F3),
    },
    {
      'name': '10 Minutes Meditation',
      'category': 'Mindfulness',
      'difficulty': 'Medium',
      'frequency': 'Daily',
      'description': 'Practice mindfulness and reduce stress',
      'icon': 'self_improvement',
      'color': Color(0xFF9C27B0),
    },
    {
      'name': 'Read for 30 Minutes',
      'category': 'Learning',
      'difficulty': 'Medium',
      'frequency': 'Daily',
      'description': 'Expand your knowledge and vocabulary',
      'icon': 'menu_book',
      'color': Color(0xFF388E3C),
    },
    {
      'name': 'Sleep 8 Hours',
      'category': 'Sleep',
      'difficulty': 'Medium',
      'frequency': 'Daily',
      'description': 'Maintain a healthy sleep schedule',
      'icon': 'bedtime',
      'color': Color(0xFF2D5A87),
    },
    {
      'name': 'Workout Session',
      'category': 'Fitness',
      'difficulty': 'Hard',
      'frequency': 'Weekdays',
      'description': 'Complete a full body workout routine',
      'icon': 'fitness_center',
      'color': Color(0xFFE76F51),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Habit Templates',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: _isExpanded ? 'expand_less' : 'expand_more',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Quick setup with popular wellness habits',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (_isExpanded) ...[
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.85,
            ),
            itemCount: _habitTemplates.length,
            itemBuilder: (context, index) {
              final template = _habitTemplates[index];
              return GestureDetector(
                onTap: () => widget.onTemplateSelected(template),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: template['color'].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: template['icon'],
                              color: template['color'],
                              size: 20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(template['difficulty'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              template['difficulty'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color:
                                    _getDifficultyColor(template['difficulty']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        template['name'],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        template['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            template['frequency'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'add_circle_outline',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color(0xFF7FB069);
      case 'Hard':
        return const Color(0xFFE76F51);
      default:
        return const Color(0xFFF4A261);
    }
  }
}
