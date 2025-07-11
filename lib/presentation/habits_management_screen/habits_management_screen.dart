import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../core/models/habit_model.dart';
import '../../core/services/habit_service.dart';
import '../../routes/app_routes.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/empty_habits_widget.dart';
import './widgets/habit_filter_widget.dart';
import './widgets/habit_management_card_widget.dart';
import './widgets/habit_search_widget.dart';

class HabitsManagementScreen extends StatefulWidget {
  const HabitsManagementScreen({super.key});

  @override
  State<HabitsManagementScreen> createState() => _HabitsManagementScreenState();
}

class _HabitsManagementScreenState extends State<HabitsManagementScreen> {
  final HabitService _habitService = HabitService.instance;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<HabitModel> _allHabits = [];
  List<HabitModel> _filteredHabits = [];
  final List<HabitModel> _selectedHabits = [];
  String _selectedFilter = 'All';
  String _selectedSort = 'Alphabetical';
  bool _isListView = true;
  bool _isLoading = true;
  bool _isBulkMode = false;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    try {
      final habits = await _habitService.getAllHabits();
      setState(() {
        _allHabits = habits;
        _filteredHabits = habits;
        _isLoading = false;
      });
      _applyFiltersAndSort();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorMessage('Failed to load habits: $e');
    }
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];
    setState(() => _recentSearches = searches);
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recent_searches', _recentSearches);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredHabits = _allHabits);
    } else {
      setState(() {
        _filteredHabits = _allHabits.where((habit) {
          return habit.name.toLowerCase().contains(query) ||
              habit.category.toLowerCase().contains(query) ||
              habit.description.toLowerCase().contains(query);
        }).toList();
      });
    }
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<HabitModel> filtered = _filteredHabits;

    // Apply filters
    switch (_selectedFilter) {
      case 'Active':
        filtered = filtered.where((h) => h.currentStreak > 0).toList();
        break;
      case 'Paused':
        filtered = filtered
            .where(
                (h) => h.endDate != null && h.endDate!.isAfter(DateTime.now()))
            .toList();
        break;
      case 'Completed':
        filtered =
            filtered.where((h) => h.currentStreak >= h.streakGoal).toList();
        break;
      default:
        break;
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Alphabetical':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Streak Length':
        filtered.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
        break;
      case 'Creation Date':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Completion Rate':
        filtered.sort((a, b) =>
            _calculateCompletionRate(b).compareTo(_calculateCompletionRate(a)));
        break;
    }

    setState(() => _filteredHabits = filtered);
  }

  double _calculateCompletionRate(HabitModel habit) {
    if (habit.completions.isEmpty) return 0.0;
    final daysSinceCreation =
        DateTime.now().difference(habit.createdAt).inDays + 1;
    return habit.completions.length / daysSinceCreation;
  }

  void _toggleBulkMode() {
    setState(() {
      _isBulkMode = !_isBulkMode;
      _selectedHabits.clear();
    });
  }

  void _toggleHabitSelection(HabitModel habit) {
    setState(() {
      if (_selectedHabits.contains(habit)) {
        _selectedHabits.remove(habit);
      } else {
        _selectedHabits.add(habit);
      }
    });
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

  Future<void> _deleteHabit(HabitModel habit) async {
    final confirm = await _showDeleteConfirmation(habit.name);
    if (confirm) {
      try {
        await _habitService.deleteHabit(habit.id);
        _showSuccessMessage('Habit deleted successfully');
        _loadHabits();
      } catch (e) {
        _showErrorMessage('Failed to delete habit: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmation(String habitName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: Text(
                'Are you sure you want to delete "$habitName"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits Management'),
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.list),
            onPressed: () => setState(() => _isListView = !_isListView),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: _toggleBulkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                HabitSearchWidget(
                  controller: _searchController,
                  recentSearches: _recentSearches,
                  onSearchSubmitted: _saveRecentSearch,
                ),
                const SizedBox(height: 12),
                HabitFilterWidget(
                  selectedFilter: _selectedFilter,
                  selectedSort: _selectedSort,
                  onFilterChanged: (filter) {
                    setState(() => _selectedFilter = filter);
                    _applyFiltersAndSort();
                  },
                  onSortChanged: (sort) {
                    setState(() => _selectedSort = sort);
                    _applyFiltersAndSort();
                  },
                ),
              ],
            ),
          ),

          // Bulk actions bar
          if (_isBulkMode && _selectedHabits.isNotEmpty)
            BulkActionsWidget(
              selectedCount: _selectedHabits.length,
              onBulkDelete: () async {
                final confirm = await _showDeleteConfirmation(
                    '${_selectedHabits.length} habits');
                if (confirm) {
                  for (final habit in _selectedHabits) {
                    await _habitService.deleteHabit(habit.id);
                  }
                  _showSuccessMessage(
                      '${_selectedHabits.length} habits deleted');
                  _loadHabits();
                  _toggleBulkMode();
                }
              },
              onBulkEdit: () {
                // TODO: Implement bulk edit functionality
                _showErrorMessage('Bulk edit coming soon');
              },
            ),

          // Habits list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHabits.isEmpty
                    ? EmptyHabitsWidget(
                        filter: _selectedFilter,
                        onCreateHabit: () {
                          Navigator.pushNamed(
                              context, AppRoutes.habitCreationScreen);
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHabits,
                        child:
                            _isListView ? _buildListView() : _buildGridView(),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.habitCreationScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredHabits.length,
      itemBuilder: (context, index) {
        final habit = _filteredHabits[index];
        return HabitManagementCardWidget(
          habit: habit,
          isSelected: _selectedHabits.contains(habit),
          isBulkMode: _isBulkMode,
          onTap: () => _isBulkMode
              ? _toggleHabitSelection(habit)
              : _showHabitDetails(habit),
          onEdit: () => _editHabit(habit),
          onDelete: () => _deleteHabit(habit),
          onToggleCompletion: () => _toggleHabitCompletion(habit),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredHabits.length,
      itemBuilder: (context, index) {
        final habit = _filteredHabits[index];
        return HabitManagementCardWidget(
          habit: habit,
          isSelected: _selectedHabits.contains(habit),
          isBulkMode: _isBulkMode,
          isGridView: true,
          onTap: () => _isBulkMode
              ? _toggleHabitSelection(habit)
              : _showHabitDetails(habit),
          onEdit: () => _editHabit(habit),
          onDelete: () => _deleteHabit(habit),
          onToggleCompletion: () => _toggleHabitCompletion(habit),
        );
      },
    );
  }

  void _showHabitDetails(HabitModel habit) {
    // TODO: Navigate to habit details screen
    _showErrorMessage('Habit details coming soon');
  }

  void _editHabit(HabitModel habit) {
    Navigator.pushNamed(
      context,
      AppRoutes.habitCreationScreen,
      arguments: habit,
    );
  }

  Future<void> _toggleHabitCompletion(HabitModel habit) async {
    try {
      await _habitService.toggleHabitCompletion(habit.id);
      _loadHabits();
      _showSuccessMessage(
        habit.isCompletedToday ? 'Habit unmarked' : 'Habit completed! 🎉',
      );
    } catch (e) {
      _showErrorMessage('Failed to update habit: $e');
    }
  }
}
