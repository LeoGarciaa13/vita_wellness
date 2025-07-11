import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String prefixIcon;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const RegistrationFormFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    required this.prefixIcon,
    this.suffixWidget,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<RegistrationFormFieldWidget> createState() =>
      _RegistrationFormFieldWidgetState();
}

class _RegistrationFormFieldWidgetState
    extends State<RegistrationFormFieldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _labelColorAnimation;

  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.outline,
      end: AppTheme.lightTheme.colorScheme.primary,
    ).animate(_animationController);

    _labelColorAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      end: AppTheme.lightTheme.colorScheme.primary,
    ).animate(_animationController);

    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      _validateField();
    }
  }

  void _onTextChange() {
    if (_hasError) {
      _validateField();
    }
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _hasError = error != null;
        _errorMessage = error;
      });

      // Haptic feedback for successful field completion
      if (!_hasError && widget.controller.text.isNotEmpty) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: _hasError
                    ? AppTheme.errorLight
                    : _labelColorAnimation.value,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.focusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                obscureText: widget.obscureText,
                onFieldSubmitted: widget.onFieldSubmitted,
                style: AppTheme.lightTheme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: widget.prefixIcon,
                      color: _hasError
                          ? AppTheme.errorLight
                          : widget.focusNode.hasFocus
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: widget.suffixWidget != null
                      ? Padding(
                          padding: EdgeInsets.all(3.w),
                          child: widget.suffixWidget,
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.lightTheme.colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _hasError
                          ? AppTheme.errorLight
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _hasError
                          ? AppTheme.errorLight
                          : _borderColorAnimation.value ??
                              AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.errorLight,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.errorLight,
                      width: 2,
                    ),
                  ),
                ),
                validator: widget.validator,
              ),
            ),
            if (_hasError && _errorMessage != null) ...[
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error_outline',
                    color: AppTheme.errorLight,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (!_hasError && widget.controller.text.isNotEmpty) ...[
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle_outline',
                    color: AppTheme.successLight,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Looking great! Keep building your wellness foundation.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successLight,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
