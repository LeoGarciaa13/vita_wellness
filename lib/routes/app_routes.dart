import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/profile_setup_screen/profile_setup_screen.dart';
import '../presentation/habit_creation_screen/habit_creation_screen.dart';
import '../presentation/habit_dashboard/habit_dashboard.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/habits_management_screen/habits_management_screen.dart';
import '../presentation/enhanced_dashboard_screen/enhanced_dashboard_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String registrationScreen = '/registration-screen';
  static const String profileSetupScreen = '/profile-setup-screen';
  static const String habitCreationScreen = '/habit-creation-screen';
  static const String habitDashboard = '/habit-dashboard';
  static const String settingsScreen = '/settings-screen';
  static const String habitsManagementScreen = '/habits-management-screen';
  static const String enhancedDashboardScreen = '/enhanced-dashboard-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    loginScreen: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    registrationScreen: (context) => const RegistrationScreen(),
    profileSetupScreen: (context) => const ProfileSetupScreen(),
    habitCreationScreen: (context) => const HabitCreationScreen(),
    habitDashboard: (context) => const HabitDashboard(),
    settingsScreen: (context) => const SettingsScreen(),
    habitsManagementScreen: (context) => const HabitsManagementScreen(),
    enhancedDashboardScreen: (context) => const EnhancedDashboardScreen(),
    // TODO: Add your other routes here
  };
}
