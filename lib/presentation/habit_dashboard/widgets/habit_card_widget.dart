import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitCardWidget extends StatefulWidget {
  final Map<String, dynamic> habit;
  final VoidCallback onToggleCompletion;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeRight;

  const HabitCardWidget({
    super.key,
    required this.habit,
    required this.onToggleCompletion,
    required this.onLongPress,
    required this.onSwipeRight,
  });

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onToggleCompletion();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.habit["isCompleted"] as bool;
    final habitColor = Color(int.parse(widget.habit["color"] as String));

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onLongPress: widget.onLongPress,
            child: Dismissible(
              key: Key('habit_${widget.habit["id"]}'),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (direction) async {
                widget.onSwipeRight();
                return false; // Don't actually dismiss
              },
              background: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 4.w),
                child: CustomIconWidget(
                  iconName: 'more_horiz',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted
                        ? habitColor.withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          // Category Icon
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: habitColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName:
                                    widget.habit["categoryIcon"] as String,
                                color: habitColor,
                                size: 6.w,
                              ),
                            ),
                          ),

                          SizedBox(width: 3.w),

                          // Habit Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.habit["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isCompleted
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color:
                                            habitColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.habit["category"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: habitColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    CustomIconWidget(
                                      iconName: 'local_fire_department',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${widget.habit["currentStreak"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Points and Completion
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.tertiary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'stars',
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      size: 14,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '${widget.habit["pointValue"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.tertiary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              AnimatedBuilder(
                                animation: _checkAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: isCompleted
                                        ? _checkAnimation.value
                                        : 1.0,
                                    child: GestureDetector(
                                      onTap: _handleTap,
                                      child: Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? AppTheme.lightTheme.colorScheme
                                                  .secondary
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isCompleted
                                                ? AppTheme.lightTheme
                                                    .colorScheme.secondary
                                                : AppTheme.lightTheme
                                                    .colorScheme.outline,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: isCompleted
                                            ? Center(
                                                child: CustomIconWidget(
                                                  iconName: 'check',
                                                  color: Colors.white,
                                                  size: 5.w,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
