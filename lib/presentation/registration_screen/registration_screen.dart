import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/password_strength_indicator_widget.dart';
import './widgets/registration_form_field_widget.dart';
import './widgets/wellness_goal_chip_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _isEmailAvailable = true;
  bool _isCheckingEmail = false;

  String _passwordStrength = 'weak';
  final List<String> _selectedGoals = [];

  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  final List<Map<String, dynamic>> _wellnessGoals = [
    {
      'id': 'fitness',
      'name': 'Fitness',
      'icon': 'fitness_center',
      'color': AppTheme.secondaryLight,
    },
    {
      'id': 'nutrition',
      'name': 'Nutrition',
      'icon': 'restaurant',
      'color': AppTheme.accentLight,
    },
    {
      'id': 'mindfulness',
      'name': 'Mindfulness',
      'icon': 'self_improvement',
      'color': AppTheme.primaryLight,
    },
    {
      'id': 'sleep',
      'name': 'Sleep',
      'icon': 'bedtime',
      'color': AppTheme.successLight,
    },
    {
      'id': 'productivity',
      'name': 'Productivity',
      'icon': 'trending_up',
      'color': AppTheme.warningLight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _emailController.addListener(_checkEmailAvailability);
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  void _checkEmailAvailability() {
    if (_emailController.text.isNotEmpty &&
        _isValidEmail(_emailController.text)) {
      setState(() {
        _isCheckingEmail = true;
      });

      // Simulate email availability check
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isCheckingEmail = false;
            _isEmailAvailable =
                !_emailController.text.toLowerCase().contains('taken');
          });
        }
      });
    }
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 'weak';
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) score++;

    setState(() {
      if (score <= 2) {
        _passwordStrength = 'weak';
      } else if (score <= 3) {
        _passwordStrength = 'medium';
      } else {
        _passwordStrength = 'strong';
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(email);
  }

  bool _isFormValid() {
    return _fullNameController.text.trim().isNotEmpty &&
        _isValidEmail(_emailController.text) &&
        _isEmailAvailable &&
        _passwordController.text.length >= 8 &&
        _passwordController.text == _confirmPasswordController.text &&
        _acceptTerms;
  }

  void _toggleGoalSelection(String goalId) {
    setState(() {
      if (_selectedGoals.contains(goalId)) {
        _selectedGoals.remove(goalId);
      } else {
        _selectedGoals.add(goalId);
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  Future<void> _createAccount() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate account creation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Trigger celebration animation
      _celebrationController.forward();

      // Haptic feedback for success
      HapticFeedback.mediumImpact();

      // Navigate to profile setup after animation
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/profile-setup-screen');
        }
      });
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms & Privacy',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terms of Service',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                'By using Vita Wellness, you agree to track your wellness journey responsibly and maintain accurate habit data.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                'Privacy Policy',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your wellness data is encrypted and stored securely. We never share personal information with third parties.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_fullNameController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Discard Changes?',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Text(
                'You have unsaved changes. Are you sure you want to go back?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress indicator
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppTheme
                                  .lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '1 of 2',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Header
                      Text(
                        'Start Your Wellness Journey',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Create your account to begin tracking habits and achieving your wellness goals.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Form fields
                      RegistrationFormFieldWidget(
                        controller: _fullNameController,
                        focusNode: _fullNameFocusNode,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        prefixIcon: 'person',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),
                      SizedBox(height: 3.h),

                      RegistrationFormFieldWidget(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'Email Address',
                        hint: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: 'email',
                        suffixWidget: _isCheckingEmail
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : _emailController.text.isNotEmpty &&
                                    _isValidEmail(_emailController.text)
                                ? CustomIconWidget(
                                    iconName: _isEmailAvailable
                                        ? 'check_circle'
                                        : 'error',
                                    color: _isEmailAvailable
                                        ? AppTheme.successLight
                                        : AppTheme.errorLight,
                                    size: 20,
                                  )
                                : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          if (!_isEmailAvailable) {
                            return 'This email is already taken';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),
                      SizedBox(height: 3.h),

                      RegistrationFormFieldWidget(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: 'Password',
                        hint: 'Create a strong password',
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        prefixIcon: 'lock',
                        suffixWidget: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: CustomIconWidget(
                            iconName: _isPasswordVisible
                                ? 'visibility_off'
                                : 'visibility',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                      ),
                      SizedBox(height: 1.h),

                      // Password strength indicator
                      PasswordStrengthIndicatorWidget(
                        password: _passwordController.text,
                        strength: _passwordStrength,
                      ),
                      SizedBox(height: 3.h),

                      RegistrationFormFieldWidget(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        prefixIcon: 'lock',
                        suffixWidget: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          child: CustomIconWidget(
                            iconName: _isConfirmPasswordVisible
                                ? 'visibility_off'
                                : 'visibility',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      SizedBox(height: 4.h),

                      // Terms and Privacy checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                              HapticFeedback.lightImpact();
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _acceptTerms = !_acceptTerms;
                                });
                                HapticFeedback.lightImpact();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: _showTermsDialog,
                                          child: Text(
                                            'Terms & Privacy Policy',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.primary,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Wellness goals section
                      Text(
                        'What are your wellness goals?',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Select your primary interests to get personalized habit suggestions.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Wellness goal chips
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: _wellnessGoals.map((goal) {
                          final isSelected =
                              _selectedGoals.contains(goal['id']);
                          return WellnessGoalChipWidget(
                            goal: goal,
                            isSelected: isSelected,
                            onTap: () => _toggleGoalSelection(goal['id']),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 6.h),

                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _isFormValid() && !_isLoading
                              ? _createAccount
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid()
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            foregroundColor: Colors.white,
                            elevation: _isFormValid() ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Login link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/login-screen');
                          },
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              children: [
                                const TextSpan(
                                    text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Login',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Celebration animation overlay
              AnimatedBuilder(
                animation: _celebrationAnimation,
                builder: (context, child) {
                  if (_celebrationAnimation.value == 0) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    color: Colors.black
                        .withValues(alpha: 0.3 * _celebrationAnimation.value),
                    child: Center(
                      child: Transform.scale(
                        scale: _celebrationAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                                'Welcome to Vita Wellness!',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Your wellness journey begins now',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
