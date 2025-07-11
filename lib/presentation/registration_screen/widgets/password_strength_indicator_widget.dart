import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final String password;
  final String strength;

  const PasswordStrengthIndicatorWidget({
    super.key,
    required this.password,
    required this.strength,
  });

  Color _getStrengthColor() {
    switch (strength) {
      case 'weak':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'strong':
        return AppTheme.successLight;
      default:
        return AppTheme.errorLight;
    }
  }

  String _getStrengthText() {
    switch (strength) {
      case 'weak':
        return 'Like a seedling - needs more nutrients to grow strong';
      case 'medium':
        return 'Growing well - add some variety for full bloom';
      case 'strong':
        return 'Flourishing! Your security garden is thriving';
      default:
        return 'Like a seedling - needs more nutrients to grow strong';
    }
  }

  double _getStrengthValue() {
    switch (strength) {
      case 'weak':
        return 0.33;
      case 'medium':
        return 0.66;
      case 'strong':
        return 1.0;
      default:
        return 0.33;
    }
  }

  List<String> _getPasswordRequirements() {
    final requirements = <String>[];
    if (password.length < 8) {
      requirements.add('At least 8 characters');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      requirements.add('One uppercase letter');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      requirements.add('One lowercase letter');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      requirements.add('One number');
    }
    if (!password.contains(RegExp(r'[!@#\$&*~]'))) {
      requirements.add('One special character');
    }
    return requirements;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final requirements = _getPasswordRequirements();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getStrengthColor().withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStrengthColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: strength == 'strong' ? 'eco' : 'local_florist',
                color: _getStrengthColor(),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  _getStrengthText(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getStrengthColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: _getStrengthValue(),
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
            minHeight: 4,
          ),
          if (requirements.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              'Still needed:',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            ...requirements.map((requirement) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'radio_button_unchecked',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 12,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        requirement,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
