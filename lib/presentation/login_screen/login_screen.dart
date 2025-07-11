import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/wellness_quote_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _errorMessage;

  late AnimationController _logoAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _formSlideAnimation;

  // Mock credentials for demonstration
  final String _mockEmail = "wellness@vitaapp.com";
  final String _mockPassword = "VitaWellness2024";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFormListeners();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _formAnimationController.forward();
    });
  }

  void _setupFormListeners() {
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isEmailValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email);
    final isPasswordValid = password.length >= 6;

    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
      if (_errorMessage != null && _isFormValid) {
        _errorMessage = null;
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Mock authentication
      if (email == _mockEmail && password == _mockPassword) {
        // Success haptic feedback
        HapticFeedback.heavyImpact();

        // Show biometric prompt for future logins
        if (mounted) {
          _showBiometricSetup();
        }

        // Navigate to dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/habit-dashboard');
        }
      } else {
        // Error haptic feedback
        HapticFeedback.vibrate();

        setState(() {
          _errorMessage = email != _mockEmail
              ? "Account not found - let's get you started on your wellness journey!"
              : "Password doesn't match - your wellness goals are waiting!";
        });
      }
    } catch (e) {
      HapticFeedback.vibrate();
      setState(() {
        _errorMessage =
            "Connection issue - your wellness journey awaits. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showBiometricSetup() {
    showDialog(
      context: context,
      builder: (context) => BiometricPromptWidget(
        onSetupComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password reset link sent! Check your email to continue your wellness journey.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _navigateToSignUp() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, '/registration-screen');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _formAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),

                    // Animated Logo Section
                    AnimatedBuilder(
                      animation: _logoAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoAnimation.value,
                          child: Column(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.progressGradient,
                                  borderRadius: BorderRadius.circular(4.w),
                                  boxShadow: AppTheme.cardShadow,
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'favorite',
                                    color: Colors.white,
                                    size: 10.w,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Vita Wellness',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Your Journey to Better Habits',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 6.h),

                    // Animated Form Section
                    SlideTransition(
                      position: _formSlideAnimation,
                      child: FadeTransition(
                        opacity: _formAnimationController,
                        child: LoginFormWidget(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailFocusNode: _emailFocusNode,
                          passwordFocusNode: _passwordFocusNode,
                          isPasswordVisible: _isPasswordVisible,
                          isLoading: _isLoading,
                          isFormValid: _isFormValid,
                          errorMessage: _errorMessage,
                          onPasswordVisibilityToggle: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          onLogin: _handleLogin,
                          onForgotPassword: _handleForgotPassword,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Wellness Quote Widget
                    const WellnessQuoteWidget(),

                    SizedBox(height: 6.h),

                    // Sign Up Link
                    GestureDetector(
                      onTap: _navigateToSignUp,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 4.w),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'New to wellness tracking? ',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
