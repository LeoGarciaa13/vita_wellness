import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WellnessQuoteWidget extends StatefulWidget {
  const WellnessQuoteWidget({super.key});

  @override
  State<WellnessQuoteWidget> createState() => _WellnessQuoteWidgetState();
}

class _WellnessQuoteWidgetState extends State<WellnessQuoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _quotes = [
    {
      "quote": "Small daily improvements lead to staggering long-term results.",
      "author": "Robin Sharma"
    },
    {
      "quote": "The groundwork for all happiness is good health.",
      "author": "Leigh Hunt"
    },
    {
      "quote":
          "Wellness is not a destination, it's a journey of daily choices.",
      "author": "Vita Wellness"
    },
    {
      "quote":
          "Your body can stand almost anything. It's your mind you have to convince.",
      "author": "Unknown"
    },
    {
      "quote": "Progress, not perfection, is the goal of wellness.",
      "author": "Vita Wellness"
    },
    {
      "quote":
          "Healthy habits are learned in the same way as unhealthy ones - through practice.",
      "author": "Wayne Dyer"
    },
    {
      "quote": "Take care of your body. It's the only place you have to live.",
      "author": "Jim Rohn"
    },
  ];

  Map<String, String> _currentQuote = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _selectDailyQuote();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  void _selectDailyQuote() {
    // Use current day to select quote for consistency
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quoteIndex = dayOfYear % _quotes.length;
    _currentQuote = _quotes[quoteIndex];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryLight.withValues(alpha: 0.05),
              AppTheme.secondaryLight.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Quote Icon
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: 'format_quote',
                color: AppTheme.primaryLight,
                size: 6.w,
              ),
            ),

            SizedBox(height: 2.h),

            // Quote Text
            Text(
              _currentQuote["quote"] ?? "",
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimaryLight,
                fontStyle: FontStyle.italic,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 2.h),

            // Author
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Text(
                "— ${_currentQuote["author"] ?? ""}",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.accentLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Daily Motivation Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'wb_sunny',
                  color: AppTheme.accentLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Daily Wellness Motivation',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
