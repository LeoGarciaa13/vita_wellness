import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/habit_model.dart';
import '../../core/models/user_model.dart';
import '../../core/services/habit_service.dart';
import '../../core/services/user_service.dart';
import './widgets/achievements_carousel_widget.dart';
import './widgets/analytics_section_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/habit_suggestions_widget.dart';
import './widgets/motivational_insights_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/today_habits_widget.dart';
import './widgets/weather_widget.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen> {
  final HabitService _habitService = HabitService.instance;
  final UserService _userService = UserService.instance;
  final ScrollController _scrollController = ScrollController();

  List<HabitModel> _allHabits = [];
  List<HabitModel> _todayHabits = [];
  UserModel? _currentUser;
  Map<String, dynamic> _stats = {};
  List<String> _widgetOrder = [
    'header',
    'today_habits',
    'analytics',
    'quick_stats',
    'insights',
    'achievements',
    'suggestions',
    'weather',
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadWidgetOrder();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      final futures = await Future.wait([
        _habitService.getAllHabits(),
        _habitService.getTodaysHabits(),
        _habitService.getHabitStats(),
        _userService.getCurrentUser(),
      ]);

      setState(() {
        _allHabits = futures[0] as List<HabitModel>;
        _todayHabits = futures[1] as List<HabitModel>;
        _stats = futures[2] as Map<String, dynamic>;
        _currentUser = futures[3] as UserModel?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorMessage('Failed to load dashboard data: $e');
    }
  }

  Future<void> _loadWidgetOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final order = prefs.getStringList('dashboard_widget_order');
    if (order != null && order.isNotEmpty) {
      setState(() => _widgetOrder = order);
    }
  }

  Future<void> _saveWidgetOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dashboard_widget_order', _widgetOrder);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Future<void> _toggleHabitCompletion(HabitModel habit) async {
    try {
      await _habitService.toggleHabitCompletion(habit.id);
      _loadDashboardData();
      _showSuccessMessage(
        habit.isCompletedToday ? 'Habit unmarked' : 'Habit completed! 🎉',
      );
    } catch (e) {
      _showErrorMessage('Failed to update habit: $e');
    }
  }

  void _reorderWidgets() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Customize Dashboard',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ReorderableListView(
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    setModalState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _widgetOrder.removeAt(oldIndex);
                      _widgetOrder.insert(newIndex, item);
                    });
                  },
                  children: _widgetOrder.map((widgetKey) {
                    return ListTile(
                      key: ValueKey(widgetKey),
                      title: Text(_getWidgetTitle(widgetKey)),
                      leading: Icon(_getWidgetIcon(widgetKey)),
                      trailing: const Icon(Icons.drag_handle),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  _saveWidgetOrder();
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWidgetTitle(String widgetKey) {
    switch (widgetKey) {
      case 'header':
        return 'Dashboard Header';
      case 'today_habits':
        return 'Today\'s Habits';
      case 'analytics':
        return 'Analytics';
      case 'quick_stats':
        return 'Quick Stats';
      case 'insights':
        return 'Motivational Insights';
      case 'achievements':
        return 'Achievements';
      case 'suggestions':
        return 'Habit Suggestions';
      case 'weather':
        return 'Weather Widget';
      default:
        return 'Unknown Widget';
    }
  }

  IconData _getWidgetIcon(String widgetKey) {
    switch (widgetKey) {
      case 'header':
        return Icons.dashboard;
      case 'today_habits':
        return Icons.today;
      case 'analytics':
        return Icons.analytics;
      case 'quick_stats':
        return Icons.speed;
      case 'insights':
        return Icons.lightbulb;
      case 'achievements':
        return Icons.emoji_events;
      case 'suggestions':
        return Icons.recommend;
      case 'weather':
        return Icons.wb_sunny;
      default:
        return Icons.widgets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Custom app bar
                  SliverAppBar(
                    title: const Text('Dashboard'),
                    floating: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: _reorderWidgets,
                        tooltip: 'Customize Dashboard',
                      ),
                    ],
                  ),

                  // Dashboard widgets
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final widgetKey = _widgetOrder[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildWidget(widgetKey),
                          );
                        },
                        childCount: _widgetOrder.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWidget(String widgetKey) {
    switch (widgetKey) {
      case 'header':
        return DashboardHeaderWidget(
          user: _currentUser,
          stats: _stats,
        );
      case 'today_habits':
        return TodayHabitsWidget(
          habits: _todayHabits,
          onHabitToggle: _toggleHabitCompletion,
        );
      case 'analytics':
        return AnalyticsSectionWidget(
          habits: _allHabits,
          stats: _stats,
        );
      case 'quick_stats':
        return QuickStatsWidget(
          stats: _stats,
          habits: _allHabits,
        );
      case 'insights':
        return MotivationalInsightsWidget(
          habits: _allHabits,
          stats: _stats,
        );
      case 'achievements':
        return AchievementsCarouselWidget(
          habits: _allHabits,
          stats: _stats,
        );
      case 'suggestions':
        return HabitSuggestionsWidget(
          existingHabits: _allHabits,
          stats: _stats,
        );
      case 'weather':
        return const WeatherWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
