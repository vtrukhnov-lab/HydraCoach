// lib/widgets/home/weather_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/weather_service.dart';
import '../../services/units_service.dart';
import '../../l10n/app_localizations.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherService>(context);
    final units = Provider.of<UnitsService>(context);
    final l10n = AppLocalizations.of(context);

    final weatherData = weather.currentWeather;
    final heatIndex = weather.heatIndex;

    final displayTemp = weatherData != null 
        ? units.formatTemperature(weatherData.temperature)
        : '--°';
    final displayHeatIndex = heatIndex != null
        ? units.toDisplayTemperature(heatIndex).round()
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getWeatherGradient(heatIndex),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(_getWeatherIcon(heatIndex), color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTemp,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                weatherData?.city ?? l10n.loading,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          if (displayHeatIndex != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.heatIndex,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    '$displayHeatIndex${units.temperatureUnit.substring(1)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  List<Color> _getWeatherGradient(double? heatIndex) {
    if (heatIndex == null) return [Colors.blue.shade400, Colors.blue.shade600];
    if (heatIndex < 20) return [Colors.blue.shade400, Colors.blue.shade600];
    if (heatIndex < 30) return [Colors.green.shade400, Colors.green.shade600];
    if (heatIndex < 40) return [Colors.orange.shade400, Colors.orange.shade600];
    return [Colors.red.shade400, Colors.red.shade600];
  }

  IconData _getWeatherIcon(double? heatIndex) {
    if (heatIndex == null) return Icons.thermostat;
    if (heatIndex < 20) return Icons.ac_unit;
    if (heatIndex < 30) return Icons.thermostat;
    if (heatIndex < 40) return Icons.wb_sunny;
    return Icons.local_fire_department;
  }
}