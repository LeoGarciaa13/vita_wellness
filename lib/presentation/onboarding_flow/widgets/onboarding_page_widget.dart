import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final AnimationController animationController;
  final AnimationController celebrationController;
  final bool isCurrentPage;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    required this.animationController,
    required this.celebrationController,
    required this.isCurrentPage,
  });

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutBack,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    ));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration with animation
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: _buildIllustration(),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 6.h),

          // Title with animation
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                  )),
                  child: Text(
                    data["title"] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: data["primaryColor"] as Color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Description with animation
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  )),
                  child: Text(
                    data["description"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 70.w,
      height: 35.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (data["primaryColor"] as Color).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomImageWidget(
              imageUrl: data["illustration"] as String,
              width: 70.w,
              height: 35.h,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  (data["primaryColor"] as Color).withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Icon with celebration animation
          Center(
            child: AnimatedBuilder(
              animation: celebrationController,
              builder: (context, child) {
                final bounceAnimation = Tween<double>(
                  begin: 1.0,
                  end: 1.3,
                ).animate(CurvedAnimation(
                  parent: celebrationController,
                  curve: Curves.elasticOut,
                ));

                final rotationAnimation = Tween<double>(
                  begin: 0.0,
                  end: 0.1,
                ).animate(CurvedAnimation(
                  parent: celebrationController,
                  curve: Curves.easeInOut,
                ));

                return Transform.scale(
                  scale: bounceAnimation.value,
                  child: Transform.rotate(
                    angle: rotationAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: data["iconName"] as String,
                        color: data["primaryColor"] as Color,
                        size: 8.w,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Special effects for specific pages
          if (data["title"] == "Track Daily Habits")
            _buildCheckmarkCelebration(),
          if (data["title"] == "Earn Rewards Points") _buildPointsAnimation(),
          if (data["title"] == "Build Streaks") _buildStreakVisualization(),
        ],
      ),
    );
  }

  Widget _buildCheckmarkCelebration() {
    return AnimatedBuilder(
      animation: celebrationController,
      builder: (context, child) {
        final checkAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: celebrationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ));

        return Positioned(
          top: 15.h,
          right: 8.w,
          child: Transform.scale(
            scale: checkAnimation.value,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: AppTheme.successLight,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 4.w,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointsAnimation() {
    return AnimatedBuilder(
      animation: celebrationController,
      builder: (context, child) {
        final pointsAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: celebrationController,
          curve: Curves.easeOut,
        ));

        return Positioned(
          top: 8.h,
          left: 8.w,
          child: Transform.scale(
            scale: pointsAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+10 pts',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakVisualization() {
    return AnimatedBuilder(
      animation: celebrationController,
      builder: (context, child) {
        final streakAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: celebrationController,
          curve: Curves.easeOut,
        ));

        return Positioned(
          bottom: 8.h,
          right: 6.w,
          child: Transform.scale(
            scale: streakAnimation.value,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(left: index > 0 ? 1.w : 0),
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: index < 2
                        ? AppTheme.errorLight
                        : AppTheme.errorLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
