import 'package:flutter/material.dart';

class HabitSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<String> recentSearches;
  final Function(String) onSearchSubmitted;

  const HabitSearchWidget({
    super.key,
    required this.controller,
    required this.recentSearches,
    required this.onSearchSubmitted,
  });

  @override
  State<HabitSearchWidget> createState() => _HabitSearchWidgetState();
}

class _HabitSearchWidgetState extends State<HabitSearchWidget> {
  bool _showRecentSearches = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showRecentSearches =
            _focusNode.hasFocus && widget.recentSearches.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search habits...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (value) {
            widget.onSearchSubmitted(value);
            _focusNode.unfocus();
          },
        ),

        // Recent searches
        if (_showRecentSearches)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Recent Searches',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ...widget.recentSearches.take(5).map((search) {
                  return InkWell(
                    onTap: () {
                      widget.controller.text = search;
                      widget.onSearchSubmitted(search);
                      _focusNode.unfocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              search,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            Icons.north_west,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
