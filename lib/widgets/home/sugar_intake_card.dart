// lib/widgets/home/sugar_intake_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/hydration_provider.dart';
import '../../services/subscription_service.dart';
import '../../screens/paywall_screen.dart';
import '../../l10n/app_localizations.dart';

class SugarIntakeCard extends StatelessWidget {
  const SugarIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();
    final l10n = AppLocalizations.of(context);
    
    // Проверяем PRO статус
    if (!subscription.isPro) {
      return _buildProLockedCard(context, l10n);
    }
    
    // Остальной код для PRO пользователей
    final provider = Provider.of<HydrationProvider>(context);
    final sugarData = provider.getSugarIntakeData(context);
    
    final hriImpact = _calculateHRIImpact(sugarData.totalGrams);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(sugarData.totalGrams),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(sugarData.totalGrams).withOpacity(0.3),
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
                          Icon(
                            _getSugarIcon(sugarData.totalGrams), 
                            color: Colors.white, 
                            size: 36
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${sugarData.totalGrams.round()}g',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.totalSugar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getStatusText(sugarData.totalGrams),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // HRI Impact блок - с уменьшенными отступами
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hriImpact > 0 ? '+$hriImpact' : '$hriImpact',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
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

            // Детальная информация - типы сахара
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.eco,
                  label: l10n.naturalSugar,
                  value: '${sugarData.naturalSugarGrams.round()}',
                ),
                _buildDetailItem(
                  icon: Icons.add_circle,
                  label: l10n.addedSugar,
                  value: '${sugarData.addedSugarGrams.round()}',
                ),
                _buildDetailItem(
                  icon: Icons.visibility_off,
                  label: l10n.hiddenSugar,
                  value: '${sugarData.hiddenSugarGrams.round()}',
                ),
              ],
            ),

            // Блок рекомендаций
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getWarningIcon(sugarData.totalGrams),
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getAdviceText(sugarData.totalGrams, l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Корректировки воды
                  _buildAdjustmentRow(
                    icon: Icons.local_drink,
                    label: l10n.water,
                    value: _getWaterAdjustment(sugarData.totalGrams, l10n),
                  ),
                  const SizedBox(height: 6),
                  // Статус дневного лимита
                  _buildAdjustmentRow(
                    icon: Icons.speed,
                    label: l10n.dailyLimit,
                    value: _getDailyLimitStatus(sugarData.totalGrams),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  // PRO-заблокированная карточка
  Widget _buildProLockedCard(BuildContext context, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaywallScreen(source: 'home_sugar_card'),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade700,
              Colors.grey.shade800,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PRO иконка
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.cake,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Заголовок PRO
              Text(
                'PRO',
                style: TextStyle(
                  color: Colors.amber.shade600,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Название функции
              Text(
                l10n.sugarTracking,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Описание
              Text(
                l10n.sugarTrackingPro,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 20),
              
              // Кнопка разблокировки
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade600, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_open,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.unlock,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  // Детальный элемент с адаптивной версткой
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Flexible(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
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
            'g',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
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
        Expanded(
          child: Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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

  int _calculateHRIImpact(double grams) {
    if (grams <= 25) return 0;  // Норма
    if (grams <= 50) return 5;  // Умеренно
    if (grams <= 75) return 10; // Высоко
    return 15; // Очень высоко
  }

  String _getStatusText(double grams) {
    if (grams <= 25) return 'Normal';
    if (grams <= 50) return 'Moderate';
    if (grams <= 75) return 'High';
    return 'Very high';
  }

  String _getAdviceText(double grams, AppLocalizations l10n) {
    if (grams <= 25) {
      return l10n.sugarRecommendationNormal;
    } else if (grams <= 50) {
      return l10n.sugarRecommendationModerate;
    } else if (grams <= 75) {
      return l10n.sugarRecommendationHigh;
    } else {
      return l10n.sugarRecommendationCritical;
    }
  }

  String _getWaterAdjustment(double grams, AppLocalizations l10n) {
    if (grams <= 25) return l10n.waterAdjustmentNormal;
    if (grams <= 50) return l10n.waterAdjustment250;
    if (grams <= 75) return l10n.waterAdjustment500;
    return l10n.waterAdjustment750;
  }

  String _getDailyLimitStatus(double grams) {
    final percentage = (grams / 25 * 100).round();
    if (percentage <= 100) return '$percentage% ✓';
    if (percentage <= 200) return '$percentage% ⚠️';
    return '$percentage% ❌';
  }

  List<Color> _getGradientColors(double grams) {
    if (grams <= 25) {
      // Норма - зеленый
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    } else if (grams <= 50) {
      // Умеренно - желтый
      return [const Color(0xFFFFCA28), const Color(0xFFFFB300)];
    } else if (grams <= 75) {
      // Высоко - оранжевый
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else {
      // Очень высоко - красный
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    }
  }

  Color _getShadowColor(double grams) {
    if (grams <= 25) return Colors.green;
    if (grams <= 50) return Colors.amber;
    if (grams <= 75) return Colors.orange;
    return Colors.red;
  }

  IconData _getSugarIcon(double grams) {
    if (grams <= 25) return Icons.check_circle;
    if (grams <= 50) return Icons.cake;
    if (grams <= 75) return Icons.warning_amber;
    return Icons.error_outline;
  }

  IconData _getWarningIcon(double grams) {
    if (grams <= 25) return Icons.check_circle_outline;
    if (grams <= 50) return Icons.info_outline;
    if (grams <= 75) return Icons.priority_high;
    return Icons.warning;
  }
}

// Data model for sugar intake
class SugarIntakeData {
  final double totalGrams;
  final double naturalSugarGrams;
  final double addedSugarGrams;
  final double hiddenSugarGrams;
  final double drinksGrams;
  final double foodGrams;
  final double snacksGrams;
  final Map<String, double> bySource;

  SugarIntakeData({
    required this.totalGrams,
    required this.naturalSugarGrams,
    required this.addedSugarGrams,
    required this.hiddenSugarGrams,
    required this.drinksGrams,
    required this.foodGrams,
    required this.snacksGrams,
    required this.bySource,
  });

  factory SugarIntakeData.empty() {
    return SugarIntakeData(
      totalGrams: 0,
      naturalSugarGrams: 0,
      addedSugarGrams: 0,
      hiddenSugarGrams: 0,
      drinksGrams: 0,
      foodGrams: 0,
      snacksGrams: 0,
      bySource: {},
    );
  }
}