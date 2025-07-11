import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/models/user_model.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/user_service.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService.instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;

  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateNotificationSettings({
    bool? dailyReminders,
    bool? streakCelebrations,
    bool? weeklyReports,
  }) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(
        dailyReminders: dailyReminders ?? _currentUser!.dailyReminders,
        streakCelebrations:
            streakCelebrations ?? _currentUser!.streakCelebrations,
        weeklyReports: weeklyReports ?? _currentUser!.weeklyReports,
      );

      await _userService.updateUser(updatedUser);
      setState(() {
        _currentUser = updatedUser;
      });

      HapticFeedback.lightImpact();
    } catch (e) {
      _showErrorSnackbar('Failed to update notification settings');
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await _showLogoutDialog();
    if (shouldLogout) {
      try {
        await _userService.logoutUser();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login-screen',
            (route) => false,
          );
        }
      } catch (e) {
        _showErrorSnackbar('Failed to logout');
      }
    }
  }

  Future<bool> _showLogoutDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Logout',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to logout? Your progress will be saved.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleDataExport() async {
    try {
      // Mock data export functionality
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'file_download',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              const Text('Data export completed successfully!'),
            ],
          ),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    } catch (e) {
      _showErrorSnackbar('Failed to export data');
    }
  }

  Future<void> _handleDataClear() async {
    final shouldClear = await _showDataClearDialog();
    if (shouldClear) {
      try {
        await _localStorage.clearAll();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/onboarding-flow',
            (route) => false,
          );
        }
      } catch (e) {
        _showErrorSnackbar('Failed to clear data');
      }
    }
  }

  Future<bool> _showDataClearDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Clear All Data',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.errorLight,
              ),
            ),
            content: Text(
              'This action will permanently delete all your habits, progress, and settings. This cannot be undone.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                ),
                child: const Text(
                  'Clear Data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  // Profile Header
                  if (_currentUser != null)
                    ProfileHeaderWidget(user: _currentUser!),

                  SizedBox(height: 3.h),

                  // Account Settings
                  SettingsSectionWidget(
                    title: 'Account',
                    children: [
                      SettingsItemWidget(
                        icon: 'person',
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',
                        onTap: () => Navigator.pushNamed(
                            context, '/profile-setup-screen'),
                      ),
                      SettingsItemWidget(
                        icon: 'security',
                        title: 'Privacy & Security',
                        subtitle: 'Manage your account security',
                        onTap: () {
                          // Navigate to privacy settings
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Notification Settings
                  SettingsSectionWidget(
                    title: 'Notifications',
                    children: [
                      SettingsItemWidget(
                        icon: 'notifications',
                        title: 'Daily Reminders',
                        subtitle: 'Get reminded about your habits',
                        trailing: Switch(
                          value: _currentUser?.dailyReminders ?? false,
                          onChanged: (value) => _updateNotificationSettings(
                            dailyReminders: value,
                          ),
                        ),
                      ),
                      SettingsItemWidget(
                        icon: 'celebration',
                        title: 'Streak Celebrations',
                        subtitle: 'Celebrate your achievements',
                        trailing: Switch(
                          value: _currentUser?.streakCelebrations ?? false,
                          onChanged: (value) => _updateNotificationSettings(
                            streakCelebrations: value,
                          ),
                        ),
                      ),
                      SettingsItemWidget(
                        icon: 'assessment',
                        title: 'Weekly Reports',
                        subtitle: 'Receive progress summaries',
                        trailing: Switch(
                          value: _currentUser?.weeklyReports ?? false,
                          onChanged: (value) => _updateNotificationSettings(
                            weeklyReports: value,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Data & Storage
                  SettingsSectionWidget(
                    title: 'Data & Storage',
                    children: [
                      SettingsItemWidget(
                        icon: 'file_download',
                        title: 'Export Data',
                        subtitle: 'Download your habit data',
                        onTap: _handleDataExport,
                      ),
                      SettingsItemWidget(
                        icon: 'backup',
                        title: 'Backup & Sync',
                        subtitle: 'Sync your data across devices',
                        onTap: () {
                          // Navigate to backup settings
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Support
                  SettingsSectionWidget(
                    title: 'Support',
                    children: [
                      SettingsItemWidget(
                        icon: 'help',
                        title: 'Help & FAQ',
                        subtitle: 'Get help with using the app',
                        onTap: () {
                          // Navigate to help screen
                        },
                      ),
                      SettingsItemWidget(
                        icon: 'feedback',
                        title: 'Send Feedback',
                        subtitle: 'Share your thoughts with us',
                        onTap: () {
                          // Navigate to feedback screen
                        },
                      ),
                      SettingsItemWidget(
                        icon: 'info',
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () {
                          // Show about dialog
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Danger Zone
                  SettingsSectionWidget(
                    title: 'Danger Zone',
                    children: [
                      SettingsItemWidget(
                        icon: 'delete_forever',
                        title: 'Clear All Data',
                        subtitle: 'Permanently delete all your data',
                        onTap: _handleDataClear,
                        iconColor: AppTheme.errorLight,
                        titleColor: AppTheme.errorLight,
                      ),
                      SettingsItemWidget(
                        icon: 'logout',
                        title: 'Logout',
                        subtitle: 'Sign out of your account',
                        onTap: _handleLogout,
                        iconColor: AppTheme.errorLight,
                        titleColor: AppTheme.errorLight,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }
}
