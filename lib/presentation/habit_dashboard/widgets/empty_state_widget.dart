import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 60.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'Start Your Wellness Journey',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Create your first habit and begin building a healthier, more productive lifestyle. Small steps lead to big changes!',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/habit-creation-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'add_circle',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Create Your First Habit',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary Action
            TextButton.icon(
              onPressed: () {
                // Show habit templates or suggestions
                _showHabitSuggestions(context);
              },
              icon: CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              label: Text(
                'Browse Habit Ideas',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            // Benefits List
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why start with habits?',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildBenefitItem(
                    icon: 'trending_up',
                    title: 'Track Progress',
                    description: 'Visualize your improvement over time',
                  ),
                  SizedBox(height: 1.h),
                  _buildBenefitItem(
                    icon: 'stars',
                    title: 'Earn Rewards',
                    description: 'Get points and unlock achievements',
                  ),
                  SizedBox(height: 1.h),
                  _buildBenefitItem(
                    icon: 'psychology',
                    title: 'Build Consistency',
                    description: 'Develop lasting positive routines',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showHabitSuggestions(BuildContext context) {
    final habitSuggestions = [
      {
        "name": "Drink 8 glasses of water",
        "category": "Nutrition",
        "icon": "local_drink",
        "points": 10,
      },
      {
        "name": "10-minute morning meditation",
        "category": "Mindfulness",
        "icon": "self_improvement",
        "points": 15,
      },
      {
        "name": "30-minute daily walk",
        "category": "Fitness",
        "icon": "directions_walk",
        "points": 20,
      },
      {
        "name": "Read for 20 minutes",
        "category": "Learning",
        "icon": "menu_book",
        "points": 12,
      },
      {
        "name": "Sleep 8 hours",
        "category": "Sleep",
        "icon": "bedtime",
        "points": 18,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Popular Habit Ideas',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Suggestions List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: habitSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = habitSuggestions[index];
                  return ListTile(
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: suggestion["icon"] as String,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),
                    ),
                    title: Text(
                      suggestion["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      '${suggestion["category"]} • ${suggestion["points"]} points',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/habit-creation-screen');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
