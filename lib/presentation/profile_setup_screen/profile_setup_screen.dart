import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/avatar_selection_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/wellness_goals_widget.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedAvatar;
  String _selectedAgeRange = '18-25';
  List<String> _selectedGoals = [];
  TimeOfDay? _reminderTime;
  bool _dailyReminders = true;
  bool _streakCelebrations = true;
  bool _weeklyReports = false;

  final List<String> _ageRanges = [
    '18-25',
    '26-35',
    '36-45',
    '46-55',
    '56-65',
    '65+'
  ];

  final List<Map<String, dynamic>> _wellnessGoals = [
    {
      'name': 'Fitness',
      'color': const Color(0xFF7FB069),
      'icon': 'fitness_center'
    },
    {
      'name': 'Nutrition',
      'color': const Color(0xFFF4A261),
      'icon': 'restaurant'
    },
    {'name': 'Sleep', 'color': const Color(0xFF2D5A87), 'icon': 'bedtime'},
    {
      'name': 'Mindfulness',
      'color': const Color(0xFF9C27B0),
      'icon': 'self_improvement'
    },
    {
      'name': 'Productivity',
      'color': const Color(0xFF4CAF50),
      'icon': 'trending_up'
    },
    {'name': 'Social', 'color': const Color(0xFFFF9800), 'icon': 'people'},
    {'name': 'Learning', 'color': const Color(0xFF3F51B5), 'icon': 'school'},
  ];

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _selectedGoals.length >= 3 &&
        _selectedGoals.length <= 5;
  }

  void _showAvatarSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarSelectionWidget(
        onAvatarSelected: (avatar) {
          setState(() {
            _selectedAvatar = avatar;
          });
        },
      ),
    );
  }

  void _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              hourMinuteTextColor: AppTheme.lightTheme.colorScheme.primary,
              dialHandColor: AppTheme.lightTheme.colorScheme.primary,
              dialBackgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _completeSetup() {
    if (_isFormValid) {
      // Show success animation
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Welcome to your wellness journey!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'You\'ve earned 50 welcome points and unlocked your first achievement badge!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/habit-dashboard');
                },
                child: const Text('Start My Journey'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSkipConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Skip Profile Setup?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You can always complete your profile later in settings. Some features may be limited without a complete profile.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Setup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/habit-dashboard');
            },
            child: const Text('Skip for Now'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                  Text(
                    'Profile Setup',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: _showSkipConfirmation,
                    child: Text(
                      'Skip for Now',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // Avatar Selection
                      Center(
                        child: GestureDetector(
                          onTap: _showAvatarSelectionBottomSheet,
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: _selectedAvatar != null
                                ? ClipOval(
                                    child: CustomImageWidget(
                                      imageUrl: _selectedAvatar!,
                                      width: 30.w,
                                      height: 30.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CustomIconWidget(
                                    iconName: 'camera_alt',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 8.w,
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),
                      Center(
                        child: Text(
                          'Tap to add photo',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Display Name
                      Text(
                        'Display Name',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your display name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your display name';
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() {}),
                      ),

                      SizedBox(height: 3.h),

                      // Age Range
                      Text(
                        'Age Range',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      DropdownButtonFormField<String>(
                        value: _selectedAgeRange,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        items: _ageRanges.map((range) {
                          return DropdownMenuItem(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedAgeRange = value;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Wellness Goals
                      WellnessGoalsWidget(
                        goals: _wellnessGoals,
                        selectedGoals: _selectedGoals,
                        onGoalsChanged: (goals) {
                          setState(() {
                            _selectedGoals = goals;
                          });
                        },
                      ),

                      SizedBox(height: 3.h),

                      // Reminder Time
                      Text(
                        'Preferred Reminder Time',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: _selectReminderTime,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                _reminderTime != null
                                    ? _reminderTime!.format(context)
                                    : 'Select time',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: _reminderTime != null
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Notification Preferences
                      NotificationPreferencesWidget(
                        dailyReminders: _dailyReminders,
                        streakCelebrations: _streakCelebrations,
                        weeklyReports: _weeklyReports,
                        onDailyRemindersChanged: (value) {
                          setState(() {
                            _dailyReminders = value;
                          });
                        },
                        onStreakCelebrationsChanged: (value) {
                          setState(() {
                            _streakCelebrations = value;
                          });
                        },
                        onWeeklyReportsChanged: (value) {
                          setState(() {
                            _weeklyReports = value;
                          });
                        },
                      ),

                      SizedBox(height: 4.h),

                      // Complete Setup Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _completeSetup : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            backgroundColor: _isFormValid
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.12),
                          ),
                          child: Text(
                            'Complete Setup',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: _isFormValid
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.38),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Helper text
                      if (!_isFormValid)
                        Center(
                          child: Text(
                            'Please select 3-5 wellness goals to continue',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
