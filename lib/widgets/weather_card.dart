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

    // Вся карточка с градиентом
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getWeatherGradient(heatIndex),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(heatIndex).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Верхняя секция с основной информацией
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getWeatherIcon(heatIndex), color: Colors.white, size: 36),
                        const SizedBox(width: 12),
                        Text(
                          displayTemp,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 42, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weatherData?.city ?? l10n.loading,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (weatherData != null)
                      Text(
                        weatherData.getLocalizedDescription(context),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9), 
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                // HRI Impact блок - используем hriRisk (уже есть в EN файле)
                if (heatIndex != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.hriRisk,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9), 
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '+${_getHRIImpact(heatIndex)}',
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 28, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          'pts',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8), 
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Разделитель
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Детальная информация - используем существующие ключи
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.water_drop,
                  label: l10n.humidityLabel,
                  value: '${weatherData?.humidity.round() ?? '--'}%',
                ),
                _buildDetailItem(
                  icon: Icons.thermostat,
                  label: l10n.heatIndex,
                  value: displayHeatIndex != null 
                    ? '$displayHeatIndex${units.temperatureUnit.substring(1)}'
                    : '--',
                ),
                _buildDetailItem(
                  icon: Icons.wb_sunny,
                  label: l10n.feelsLike,
                  value: displayHeatIndex != null 
                    ? '$displayHeatIndex${units.temperatureUnit.substring(1)}'
                    : '--',
                ),
              ],
            ),
            
            // Предупреждение или рекомендации
            if (heatIndex != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getWarningIcon(heatIndex),
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _getHydrationAdvice(heatIndex, l10n),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Рекомендации по корректировкам - используем water и sodium (уже есть)
                    _buildAdjustmentRow(
                      icon: Icons.local_drink,
                      label: l10n.water,
                      value: _getWaterAdjustmentText(heatIndex),
                    ),
                    const SizedBox(height: 6),
                    _buildAdjustmentRow(
                      icon: Icons.grain,
                      label: l10n.sodium,
                      value: _getSodiumAdjustmentText(heatIndex),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAdjustmentRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  int _getHRIImpact(double? heatIndex) {
    if (heatIndex == null) return 0;
    
    // Точная формула из HRIService
    if (heatIndex >= 39) return 15;  // Экстремальная жара
    if (heatIndex >= 32) return 10;  // Высокая температура  
    if (heatIndex >= 27) return 5;   // Умеренная температура
    return 0;  // Комфортная температура
  }

  String _getWaterAdjustmentText(double heatIndex) {
    // Упрощенный текст - только проценты или "Normal"
    if (heatIndex < 27) return 'Normal';
    if (heatIndex < 32) return '+5%';
    if (heatIndex < 39) return '+8%';
    if (heatIndex < 45) return '+12%';
    return '+15%';
  }

  String _getSodiumAdjustmentText(double heatIndex) {
    // Упрощенный текст - только значения
    if (heatIndex < 27) return 'Standard';
    if (heatIndex < 32) return '+300 mg';
    if (heatIndex < 39) return '+500 mg';
    return '+1000 mg';
  }

  String _getHydrationAdvice(double heatIndex, AppLocalizations l10n) {
    // Используем существующие ключи heatWarning*
    if (heatIndex >= 39) {
      return l10n.heatWarningExtreme;
    }
    if (heatIndex >= 32) {
      return l10n.heatWarningHot;
    }
    if (heatIndex >= 27) {
      return l10n.heatWarningElevated;
    }
    if (heatIndex < 10) {
      return l10n.heatWarningCold;
    }
    return l10n.heatWarningComfortable;
  }

  List<Color> _getWeatherGradient(double? heatIndex) {
    if (heatIndex == null) {
      // Серый градиент для загрузки
      return [Colors.grey.shade500, Colors.grey.shade700];
    }
    
    if (heatIndex < 10) {
      // Очень холодно - синий
      return [const Color(0xFF1E88E5), const Color(0xFF1565C0)];
    } else if (heatIndex < 20) {
      // Холодно - голубой
      return [const Color(0xFF42A5F5), const Color(0xFF1E88E5)];
    } else if (heatIndex < 27) {
      // Комфортно - зеленый
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    } else if (heatIndex < 32) {
      // Тепло - желто-зеленый
      return [const Color(0xFF9CCC65), const Color(0xFF7CB342)];
    } else if (heatIndex < 39) {
      // Жарко - оранжевый
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else {
      // Очень жарко - красный
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    }
  }

  Color _getShadowColor(double? heatIndex) {
    if (heatIndex == null) return Colors.grey;
    if (heatIndex < 20) return Colors.blue;
    if (heatIndex < 27) return Colors.green;
    if (heatIndex < 32) return Colors.amber;
    if (heatIndex < 39) return Colors.orange;
    return Colors.red;
  }

  IconData _getWeatherIcon(double? heatIndex) {
    if (heatIndex == null) return Icons.cloud;
    if (heatIndex < 10) return Icons.ac_unit;
    if (heatIndex < 20) return Icons.cloud_queue;
    if (heatIndex < 27) return Icons.wb_sunny;
    if (heatIndex < 39) return Icons.wb_sunny;
    return Icons.local_fire_department;
  }

  IconData _getWarningIcon(double heatIndex) {
    if (heatIndex >= 39) return Icons.warning;
    if (heatIndex >= 32) return Icons.priority_high;
    if (heatIndex >= 27) return Icons.info_outline;
    return Icons.check_circle_outline;
  }
}