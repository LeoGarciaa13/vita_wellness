import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatefulWidget {
  final VoidCallback onSetupComplete;

  const BiometricPromptWidget({
    super.key,
    required this.onSetupComplete,
  });

  @override
  State<BiometricPromptWidget> createState() => _BiometricPromptWidgetState();
}

class _BiometricPromptWidgetState extends State<BiometricPromptWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isSetupComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  void _handleBiometricSetup() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isSetupComplete = true;
    });

    // Simulate biometric setup process
    await Future.delayed(const Duration(seconds: 1));

    HapticFeedback.heavyImpact();

    // Auto close after success
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onSetupComplete();
  }

  void _handleSkip() {
    HapticFeedback.selectionClick();
    widget.onSetupComplete();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(5.w),
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Biometric Icon
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    gradient: _isSetupComplete
                        ? LinearGradient(
                            colors: [
                              AppTheme.successLight,
                              AppTheme.secondaryLight
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : AppTheme.progressGradient,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Center(
                    child: _isSetupComplete
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 10.w,
                          )
                        : CustomIconWidget(
                            iconName: 'fingerprint',
                            color: Colors.white,
                            size: 10.w,
                          ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Title
                Text(
                  _isSetupComplete
                      ? 'Setup Complete!'
                      : 'Enable Biometric Login',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Description
                Text(
                  _isSetupComplete
                      ? 'You can now use Face ID or Touch ID to quickly access your wellness dashboard.'
                      : 'Use Face ID or Touch ID for quick and secure access to your wellness journey.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                // Action Buttons
                if (!_isSetupComplete) ...[
                  // Enable Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _handleBiometricSetup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: Colors.white,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Enable Biometric Login',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Skip Button
                  SizedBox(
                    width: double.infinity,
                    height: 5.h,
                    child: TextButton(
                      onPressed: _handleSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textSecondaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Text(
                        'Skip for Now',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Done Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: widget.onSetupComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Text(
                        'Continue to Dashboard',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 2.h),

                // Security Note
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'shield',
                        color: AppTheme.primaryLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Your biometric data stays secure on your device',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
