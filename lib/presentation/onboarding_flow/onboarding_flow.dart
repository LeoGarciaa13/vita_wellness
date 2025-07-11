import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _celebrationController;
  int _currentPage = 0;
  bool _isAutoAdvancing = true;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Track Daily Habits",
      "description":
          "Build lasting wellness routines by tracking your daily habits with simple, satisfying checkmarks.",
      "illustration":
          "https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "check_circle",
      "primaryColor": AppTheme.primaryLight,
      "secondaryColor": AppTheme.secondaryLight,
    },
    {
      "title": "Earn Rewards Points",
      "description":
          "Every completed habit earns you points. Watch your wellness score grow as you build healthy routines.",
      "illustration":
          "https://images.pexels.com/photos/3760067/pexels-photo-3760067.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "iconName": "stars",
      "primaryColor": AppTheme.accentLight,
      "secondaryColor": AppTheme.warningLight,
    },
    {
      "title": "Build Streaks",
      "description":
          "Consistency is key! Build impressive streaks and watch your progress visualized on your personal calendar.",
      "illustration":
          "https://images.pixabay.com/photos/2016/03/27/19/32/blur-1283865_1280.jpg",
      "iconName": "local_fire_department",
      "primaryColor": AppTheme.errorLight,
      "secondaryColor": AppTheme.accentLight,
    },
    {
      "title": "Stay Motivated",
      "description":
          "Unlock achievement badges, view progress charts, and celebrate every milestone on your wellness journey.",
      "illustration":
          "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "emoji_events",
      "primaryColor": AppTheme.successLight,
      "secondaryColor": AppTheme.secondaryLight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _startAutoAdvance();
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    if (!_isAutoAdvancing) return;

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted &&
          _isAutoAdvancing &&
          _currentPage < _onboardingData.length - 1) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      setState(() {
        _isAutoAdvancing = false;
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (_currentPage == 0) {
        _celebrationController.forward();
      }
    } else {
      _navigateToProfileSetup();
    }
  }

  void _skipOnboarding() {
    _navigateToProfileSetup();
  }

  void _navigateToProfileSetup() {
    _celebrationController.forward().then((_) {
      Navigator.pushReplacementNamed(context, '/profile-setup-screen');
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isAutoAdvancing = false;
    });

    _animationController.reset();
    _animationController.forward();

    if (page == 0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _celebrationController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: _onboardingData[index],
                    animationController: _animationController,
                    celebrationController: _celebrationController,
                    isCurrentPage: index == _currentPage,
                  );
                },
              ),
            ),

            // Page indicator and navigation
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicator
                  PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),

                  SizedBox(height: 4.h),

                  // Navigation buttons
                  Row(
                    children: [
                      // Previous button (invisible on first page)
                      SizedBox(
                        width: 20.w,
                        child: _currentPage > 0
                            ? TextButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  'Back',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Spacer
                      const Spacer(),

                      // Next/Get Started button
                      SizedBox(
                        width: 35.w,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _currentPage == _onboardingData.length - 1
                                    ? AppTheme.successLight
                                    : AppTheme.primaryLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
