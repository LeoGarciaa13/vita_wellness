import 'package:flutter/material.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    // Mock weather data - in real app, call weather API
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _weatherData = {
        'temperature': 22,
        'condition': 'sunny',
        'icon': '☀️',
        'description': 'Perfect day for outdoor activities!',
        'location': 'Your Location',
        'recommendations': [
          'Great weather for morning jog',
          'Perfect time for outdoor meditation',
          'Ideal for walking meetings',
        ],
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Weather & Recommendations',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Weather content
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_weatherData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current weather
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withAlpha(26),
                          Colors.yellow.withAlpha(26),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Weather icon
                        Text(
                          _weatherData!['icon'],
                          style: const TextStyle(fontSize: 48),
                        ),

                        const SizedBox(width: 16),

                        // Weather details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_weatherData!['temperature']}°C',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                _weatherData!['location'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _weatherData!['description'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Weather-based recommendations
                  Text(
                    'Weather-Based Habit Suggestions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...(_weatherData!['recommendations'] as List<String>)
                      .map((recommendation) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getRecommendationIcon(recommendation),
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              recommendation,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              )
            else
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 36,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unable to load weather data',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getRecommendationIcon(String recommendation) {
    if (recommendation.contains('jog') || recommendation.contains('walk')) {
      return Icons.directions_run;
    } else if (recommendation.contains('meditation')) {
      return Icons.self_improvement;
    } else if (recommendation.contains('meeting')) {
      return Icons.business_center;
    } else {
      return Icons.wb_sunny;
    }
  }
}
