import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/weather_service.dart';
import '../l10n/app_localizations.dart';

class WeatherCard extends StatefulWidget {
  final Function(double waterAdjustment, int sodiumAdjustment) onWeatherUpdate;
  
  const WeatherCard({
    super.key,
    required this.onWeatherUpdate,
  });
  
  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  WeatherData? _weather;
  bool _loading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadWeather();
  }
  
  Future<void> _loadWeather() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    
    try {
      final weather = await WeatherService.getCurrentWeather();
      
      if (weather != null && mounted) {
        setState(() {
          _weather = weather;
          _loading = false;
        });
        
        // Передаем корректировки в родительский виджет
        final waterAdjustment = WeatherService.getWaterAdjustment(weather.heatIndex);
        final sodiumAdjustment = WeatherService.getSodiumAdjustment(
          weather.heatIndex, 
          'medium', // TODO: получать из провайдера
        );
        
        widget.onWeatherUpdate(waterAdjustment, sodiumAdjustment);
      } else {
        setState(() {
          _loading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = null;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_loading) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(l10n.loadingWeather),
          ],
        ),
      );
    }
    
    // Показываем карточку с ошибкой вместо пустоты
    if (_weather == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_off, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.weatherUnavailable,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.checkLocationPermissions,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _loadWeather,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.retry),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  backgroundColor: Colors.orange.shade100,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    }
    
    // Если данные загружены успешно - показываем полную карточку
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _weather!.getHeatColor().withOpacity(0.8),
            _weather!.getHeatColor(),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _weather!.getHeatColor().withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Фоновый паттерн
          Positioned(
            right: -30,
            top: -30,
            child: Icon(
              _weather!.heatIndex > 32 ? Icons.wb_sunny : Icons.cloud,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          
          // Контент
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _weather!.city.isEmpty ? l10n.currentLocation : _weather!.city,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${_weather!.temperature.toInt()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              '°C',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _weather!.getLocalizedDescription(context),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                color: Colors.white.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.humidity(_weather!.humidity.toInt()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                l10n.heatIndex,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '${_weather!.heatIndex.toInt()}°',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Предупреждение о жаре
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _weather!.heatIndex > 32 
                          ? Icons.warning_amber_rounded 
                          : Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _weather!.getLocalizedHeatWarning(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Корректировки
                if (_weather!.heatIndex >= 27) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildAdjustmentChip(
                        Icons.water_drop,
                        l10n.adjustmentWater((WeatherService.getWaterAdjustment(_weather!.heatIndex) * 100).toInt()),
                      ),
                      const SizedBox(width: 8),
                      _buildAdjustmentChip(
                        Icons.grain,
                        l10n.adjustmentSodium(WeatherService.getSodiumAdjustment(_weather!.heatIndex, 'medium')),
                      ),
                    ],
                  ),
                ],
                
                // Кнопка обновления (маленькая)
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: _loadWeather,
                    icon: const Icon(Icons.refresh, size: 20),
                    color: Colors.white.withOpacity(0.6),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildAdjustmentChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: _weather!.getHeatColor(),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _weather!.getHeatColor(),
            ),
          ),
        ],
      ),
    );
  }
}