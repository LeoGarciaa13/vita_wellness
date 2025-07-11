import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/difficulty_level_widget.dart';
import './widgets/frequency_picker_widget.dart';
import './widgets/habit_templates_widget.dart';
import './widgets/reminder_section_widget.dart';

class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({super.key});

  @override
  State<HabitCreationScreen> createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _habitNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;

  String _selectedCategory = '';
  String _selectedFrequency = 'Daily';
  List<String> _selectedDays = [];
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = TimeOfDay.now();
  final List<TimeOfDay> _additionalReminders = [];
  String _difficultyLevel = 'Medium';
  bool _showAdvancedOptions = false;
  int _streakGoal = 30;
  DateTime? _endDate;
  bool _isPrivate = false;
  bool _showConfetti = false;

  final List<Map<String, dynamic>> _habitSuggestions = [
    {'name': 'Drink Water', 'category': 'Health'},
    {'name': 'Morning Walk', 'category': 'Fitness'},
    {'name': 'Read Book', 'category': 'Learning'},
    {'name': 'Meditate', 'category': 'Mindfulness'},
    {'name': 'Exercise', 'category': 'Fitness'},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fitness', 'icon': 'fitness_center', 'color': Color(0xFF7FB069)},
    {'name': 'Nutrition', 'icon': 'restaurant', 'color': Color(0xFFF4A261)},
    {'name': 'Sleep', 'icon': 'bedtime', 'color': Color(0xFF2D5A87)},
    {
      'name': 'Mindfulness',
      'icon': 'self_improvement',
      'color': Color(0xFF9C27B0)
    },
    {'name': 'Productivity', 'icon': 'work', 'color': Color(0xFF1976D2)},
    {'name': 'Social', 'icon': 'people', 'color': Color(0xFFE91E63)},
    {'name': 'Learning', 'icon': 'school', 'color': Color(0xFF388E3C)},
    {'name': 'Custom', 'icon': 'add_circle', 'color': Color(0xFF6B7280)},
  ];

  final List<String> _frequencyOptions = [
    'Daily',
    'Weekdays',
    'Weekends',
    'Custom Days'
  ];

  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _confettiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _habitNameController.text.trim().isNotEmpty &&
        _selectedCategory.isNotEmpty;
  }

  int get _pointsPerCompletion {
    switch (_difficultyLevel) {
      case 'Easy':
        return 1;
      case 'Hard':
        return 3;
      default:
        return 2;
    }
  }

  int get _weeklyPoints {
    int dailyPoints = _pointsPerCompletion;
    switch (_selectedFrequency) {
      case 'Daily':
        return dailyPoints * 7;
      case 'Weekdays':
        return dailyPoints * 5;
      case 'Weekends':
        return dailyPoints * 2;
      case 'Custom Days':
        return dailyPoints * _selectedDays.length;
      default:
        return dailyPoints * 7;
    }
  }

  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _addAdditionalReminder() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _additionalReminders.add(picked);
      });
    }
  }

  void _removeReminder(int index) {
    setState(() {
      _additionalReminders.removeAt(index);
    });
  }

  void _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyHabitTemplate(Map<String, dynamic> template) {
    setState(() {
      _habitNameController.text = template['name'];
      _selectedCategory = template['category'];
      _difficultyLevel = template['difficulty'] ?? 'Medium';
      _selectedFrequency = template['frequency'] ?? 'Daily';
      _descriptionController.text = template['description'] ?? '';
    });
  }

  void _saveHabit() {
    if (!_isFormValid) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _showConfetti = true;
    });

    _confettiController.forward();

    // Simulate saving habit
    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'celebration',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              const Text('Great choice! Habit created successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/habit-dashboard');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          _buildHabitNameSection(),
                          SizedBox(height: 3.h),
                          CategorySelectionWidget(
                            categories: _categories,
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                          SizedBox(height: 3.h),
                          FrequencyPickerWidget(
                            frequencyOptions: _frequencyOptions,
                            selectedFrequency: _selectedFrequency,
                            weekDays: _weekDays,
                            selectedDays: _selectedDays,
                            onFrequencyChanged: (frequency) {
                              setState(() {
                                _selectedFrequency = frequency;
                                if (frequency != 'Custom Days') {
                                  _selectedDays.clear();
                                }
                              });
                            },
                            onDaysChanged: (days) {
                              setState(() {
                                _selectedDays = days;
                              });
                            },
                          ),
                          SizedBox(height: 3.h),
                          ReminderSectionWidget(
                            reminderEnabled: _reminderEnabled,
                            reminderTime: _reminderTime,
                            additionalReminders: _additionalReminders,
                            onReminderToggle: (enabled) {
                              setState(() {
                                _reminderEnabled = enabled;
                              });
                            },
                            onTimeSelected: _showTimePicker,
                            onAddReminder: _addAdditionalReminder,
                            onRemoveReminder: _removeReminder,
                          ),
                          SizedBox(height: 3.h),
                          DifficultyLevelWidget(
                            selectedDifficulty: _difficultyLevel,
                            onDifficultyChanged: (difficulty) {
                              setState(() {
                                _difficultyLevel = difficulty;
                              });
                            },
                          ),
                          SizedBox(height: 3.h),
                          _buildDescriptionSection(),
                          SizedBox(height: 3.h),
                          HabitTemplatesWidget(
                            onTemplateSelected: _applyHabitTemplate,
                          ),
                          SizedBox(height: 3.h),
                          AdvancedOptionsWidget(
                            showAdvancedOptions: _showAdvancedOptions,
                            streakGoal: _streakGoal,
                            endDate: _endDate,
                            isPrivate: _isPrivate,
                            onToggleAdvanced: () {
                              setState(() {
                                _showAdvancedOptions = !_showAdvancedOptions;
                              });
                            },
                            onStreakGoalChanged: (goal) {
                              setState(() {
                                _streakGoal = goal;
                              });
                            },
                            onEndDateSelected: _selectEndDate,
                            onPrivacyToggle: (isPrivate) {
                              setState(() {
                                _isPrivate = isPrivate;
                              });
                            },
                          ),
                          SizedBox(height: 3.h),
                          _buildPointsCalculation(),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showConfetti) _buildConfettiOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          Text(
            'Create Habit',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          ElevatedButton(
            onPressed: _isFormValid ? _saveHabit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Name',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _habitNameController,
          decoration: InputDecoration(
            hintText: 'Enter your habit name',
            counterText: '${_habitNameController.text.length}/50',
            suffixIcon: _habitNameController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _habitNameController.clear();
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.outline,
                      size: 20,
                    ),
                  )
                : null,
          ),
          maxLength: 50,
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a habit name';
            }
            return null;
          },
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _habitSuggestions.map((suggestion) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _habitNameController.text = suggestion['name'];
                });
              },
              child: Chip(
                label: Text(
                  suggestion['name'],
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                backgroundColor: AppTheme
                    .lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                side: BorderSide.none,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Add motivation notes or details...',
          ),
          maxLines: 3,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget _buildPointsCalculation() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'stars',
                color: AppTheme.accentLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Points Calculation',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Points',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '$_pointsPerCompletion pts',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.accentLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Weekly Potential',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '$_weeklyPoints pts',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.secondaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return _confettiAnimation.value > 0
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black
                    .withValues(alpha: 0.3 * _confettiAnimation.value),
                child: Center(
                  child: Transform.scale(
                    scale: _confettiAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.elevatedShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'celebration',
                            color: AppTheme.accentLight,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Great Choice!',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Your habit has been created successfully!',
                            style: AppTheme.lightTheme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
