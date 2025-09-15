// lib/widgets/home/electrolytes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/hydration_provider.dart';

/// Карточка отображения электролитов на главном экране
/// Унифицированный дизайн с WeatherCard
class ElectrolytesCard extends StatelessWidget {
  const ElectrolytesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HydrationProvider>();
    final l10n = AppLocalizations.of(context);
    final progress = provider.getProgress();
    
    final sodiumCurrent = (progress['sodium'] ?? 0).toInt();
    final sodiumGoal = provider.goals.sodium;
    final potassiumCurrent = (progress['potassium'] ?? 0).toInt();
    final potassiumGoal = provider.goals.potassium;
    final magnesiumCurrent = (progress['magnesium'] ?? 0).toInt();
    final magnesiumGoal = provider.goals.magnesium;
    
    // Расчёт общего процента и HRI Impact
    final totalPercent = _calculateTotalPercent(
      sodiumCurrent, sodiumGoal,
      potassiumCurrent, potassiumGoal,
      magnesiumCurrent, magnesiumGoal,
    );
    
    final hriImpact = _calculateHRIImpact(totalPercent);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(totalPercent),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(totalPercent).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Верхняя секция с основной информацией и HRI Impact
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_getElectrolyteIcon(totalPercent), 
                            color: Colors.white, 
                            size: 36
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${totalPercent.round()}%',
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
                        l10n.electrolytes,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getShortStatus(totalPercent),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9), 
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // HRI Impact блок - ВСЕГДА показываем
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
                        hriImpact > 0 ? '+$hriImpact' : '$hriImpact',
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
            
            // Разделитель (как в WeatherCard)
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
            
            // Детальная информация - три круглых индикатора (как в WeatherCard)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.grain,
                  label: l10n.sodium,
                  value: '$sodiumCurrent',
                ),
                _buildDetailItem(
                  icon: Icons.eco,
                  label: l10n.potassium,
                  value: '$potassiumCurrent',
                ),
                _buildDetailItem(
                  icon: Icons.favorite,
                  label: l10n.magnesium,
                  value: '$magnesiumCurrent',
                ),
              ],
            ),
            
            // Блок рекомендаций - ВСЕГДА показываем
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
                        _getWarningIcon(totalPercent),
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getAdviceText(totalPercent, l10n),
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
                  // Корректировки натрия
                  _buildAdjustmentRow(
                    icon: Icons.grain,
                    label: l10n.sodium,
                    value: _getSodiumAdjustment(sodiumCurrent, sodiumGoal),
                  ),
                  const SizedBox(height: 6),
                  // Корректировки воды
                  _buildAdjustmentRow(
                    icon: Icons.local_drink,
                    label: l10n.water,
                    value: _getWaterAdjustment(totalPercent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  // Простой виджет детали как в WeatherCard
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
        Text(
          'mg',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
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

  int _calculateHRIImpact(double totalPercent) {
    // Негативное влияние при низком уровне электролитов
    if (totalPercent < 20) return 15;  // Критически низкий
    if (totalPercent < 40) return 10;  // Очень низкий
    if (totalPercent < 60) return 5;   // Низкий
    if (totalPercent > 120) return 5;  // Переизбыток
    return 0;  // Норма
  }

  double _calculateTotalPercent(
    int sodiumCurrent, int sodiumGoal,
    int potassiumCurrent, int potassiumGoal,
    int magnesiumCurrent, int magnesiumGoal,
  ) {
    final sodiumPercent = sodiumGoal > 0 ? sodiumCurrent / sodiumGoal : 0.0;
    final potassiumPercent = potassiumGoal > 0 ? potassiumCurrent / potassiumGoal : 0.0;
    final magnesiumPercent = magnesiumGoal > 0 ? magnesiumCurrent / magnesiumGoal : 0.0;
    
    return ((sodiumPercent + potassiumPercent + magnesiumPercent) / 3 * 100)
        .clamp(0.0, 150.0);
  }

  List<Color> _getGradientColors(double percent) {
    if (percent < 30) {
      // Критически низкий - красный
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    } else if (percent < 60) {
      // Низкий - оранжевый
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else if (percent < 90) {
      // Хороший - зелёно-голубой
      return [const Color(0xFF26A69A), const Color(0xFF00897B)];
    } else {
      // Отличный - зелёный
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    }
  }

  Color _getShadowColor(double percent) {
    if (percent < 30) return Colors.red;
    if (percent < 60) return Colors.orange;
    if (percent < 90) return Colors.teal;
    return Colors.green;
  }

  IconData _getElectrolyteIcon(double percent) {
    if (percent < 30) return Icons.battery_alert;
    if (percent < 60) return Icons.battery_3_bar;
    if (percent < 90) return Icons.battery_5_bar;
    return Icons.battery_full;
  }

  IconData _getWarningIcon(double percent) {
    if (percent < 30) return Icons.warning;
    if (percent < 60) return Icons.priority_high;
    if (percent < 90) return Icons.info_outline;
    return Icons.check_circle_outline;
  }

  // Упрощенные короткие статусы
  String _getShortStatus(double percent) {
    if (percent < 30) return 'Low';
    if (percent < 60) return 'Below target';
    if (percent < 90) return 'Good';
    return 'Excellent';
  }

  // Текст совета
  String _getAdviceText(double percent, AppLocalizations l10n) {
    if (percent < 30) {
      return l10n.takeElectrolytesMorning;
    } else if (percent < 60) {
      return l10n.dontForgetElectrolytes;
    } else if (percent < 90) {
      return l10n.maintainWaterBalance;
    } else {
      return l10n.greatBalance;
    }
  }

  // Корректировка натрия
  String _getSodiumAdjustment(int current, int goal) {
    if (current >= goal * 0.8) return 'Normal';
    final needed = goal - current;
    if (needed < 500) return '+$needed mg';
    if (needed < 1000) return '+500 mg';
    return '+1000 mg';
  }

  // Корректировка воды
  String _getWaterAdjustment(double percent) {
    if (percent < 30) return '+500 ml';
    if (percent < 60) return '+250 ml';
    return 'Normal';
  }
}