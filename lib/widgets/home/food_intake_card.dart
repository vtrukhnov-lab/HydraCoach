// lib/widgets/home/food_intake_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/hydration_provider.dart';
import '../../services/subscription_service.dart';
import '../../screens/paywall_screen.dart';
import '../../l10n/app_localizations.dart';

class FoodIntakeCard extends StatelessWidget {
  const FoodIntakeCard({super.key});

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
    final foodData = _getFoodIntakeData(provider);

    final hriImpact = _calculateHRIImpact(foodData);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(foodData),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(foodData).withOpacity(0.3),
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
                            _getFoodIcon(foodData),
                            color: Colors.white,
                            size: 36
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${foodData['calories']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l10n.kcal,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.foodIntake,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getStatusText(foodData, l10n),
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

            // Детальная информация - состав еды
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.water_drop,
                  label: l10n.waterContent,
                  value: '${foodData['waterContent'].round()}',
                  unit: 'ml',
                ),
                _buildDetailItem(
                  icon: Icons.cake,
                  label: l10n.sugar,
                  value: '${foodData['sugar'].round()}',
                  unit: 'g',
                ),
                _buildDetailItem(
                  icon: Icons.restaurant,
                  label: l10n.meals,
                  value: '${foodData['foodCount']}',
                  unit: '',
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
                        _getWarningIcon(foodData),
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getAdviceText(foodData, l10n),
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
                    value: _getWaterAdjustment(foodData),
                  ),
                  const SizedBox(height: 6),
                  // Гидратационный баланс
                  _buildAdjustmentRow(
                    icon: Icons.balance,
                    label: l10n.hydrationBalance,
                    value: _getHydrationBalance(foodData),
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
    return Container(
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
                Icons.restaurant_menu,
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
              l10n.foodTracking,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Описание
            Text(
              l10n.foodTrackingPro,
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
    ).animate().fadeIn(delay: 200.ms);
  }

  // Детальный элемент с адаптивной версткой
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
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
          if (unit.isNotEmpty)
            Text(
              unit,
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

  Map<String, dynamic> _getFoodIntakeData(HydrationProvider provider) {
    final foodCount = provider.todayFoodIntakes.length;
    final waterContent = provider.totalWaterFromFoodToday;
    final sodium = provider.todayFoodIntakes.fold(0.0, (sum, food) => sum + food.sodium);
    final potassium = provider.todayFoodIntakes.fold(0.0, (sum, food) => sum + food.potassium);
    final magnesium = provider.todayFoodIntakes.fold(0.0, (sum, food) => sum + food.magnesium);
    final sugar = provider.todayFoodIntakes.fold(0.0, (sum, food) => sum + food.sugar);
    final calories = provider.totalCaloriesToday;

    return {
      'foodCount': foodCount,
      'waterContent': waterContent,
      'sodium': sodium,
      'potassium': potassium,
      'magnesium': magnesium,
      'sugar': sugar,
      'calories': calories,
    };
  }

  int _calculateHRIImpact(Map<String, dynamic> foodData) {
    int impact = 0;

    // Высокое содержание натрия увеличивает риск
    final sodium = foodData['sodium'] as double;
    if (sodium > 1500) impact += 10;
    else if (sodium > 1000) impact += 5;

    // Низкое содержание воды увеличивает риск
    final waterContent = foodData['waterContent'] as double;
    final foodCount = foodData['foodCount'] as int;
    if (foodCount > 2 && waterContent < 100) impact += 8;
    else if (foodCount > 0 && waterContent < 200) impact += 3;

    // Высокое содержание сахара увеличивает риск
    final sugar = foodData['sugar'] as double;
    if (sugar > 50) impact += 5;
    else if (sugar > 25) impact += 2;

    // Положительный эффект от калия и магния
    final potassium = foodData['potassium'] as double;
    final magnesium = foodData['magnesium'] as double;

    if (potassium > 1000) impact -= 2;
    if (magnesium > 200) impact -= 2;

    // Положительный эффект от водосодержащей пищи
    if (waterContent > 300 && foodCount > 0) impact -= 3;

    return impact.clamp(-5, 20);
  }

  String _getStatusText(Map<String, dynamic> foodData, AppLocalizations l10n) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;
    final potassium = foodData['potassium'] as double;
    final magnesium = foodData['magnesium'] as double;

    if (foodCount == 0) return l10n.noFoodToday;
    if (sodium > 1500) return l10n.highSodiumFood;
    if (potassium > 1000 && magnesium > 200) return l10n.richInElectrolytes;
    if (waterContent > 300) return l10n.hydratingFood;
    if (waterContent < 100 && foodCount > 2) return l10n.dryFood;
    return l10n.balancedFood;
  }

  String _getAdviceText(Map<String, dynamic> foodData, AppLocalizations l10n) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (foodCount == 0) {
      return l10n.foodAdviceEmpty;
    } else if (sodium > 1500) {
      return l10n.foodAdviceHighSodium;
    } else if (waterContent < 100 && foodCount > 2) {
      return l10n.foodAdviceLowWater;
    } else if (waterContent > 300) {
      return l10n.foodAdviceGoodHydration;
    } else {
      return l10n.foodAdviceBalanced;
    }
  }

  String _getWaterAdjustment(Map<String, dynamic> foodData) {
    final sodium = foodData['sodium'] as double;
    final waterContent = foodData['waterContent'] as double;
    final foodCount = foodData['foodCount'] as int;

    if (sodium > 1500) return '+300 ml';
    if (foodCount > 2 && waterContent < 100) return '+400 ml';
    if (waterContent > 300) return 'Normal';
    return '+200 ml';
  }

  String _getHydrationBalance(Map<String, dynamic> foodData) {
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (waterContent > 300 && sodium < 1000) return 'Excellent ✓';
    if (waterContent > 200) return 'Good ✓';
    if (sodium > 1500) return 'Poor ⚠️';
    return 'Fair';
  }

  List<Color> _getGradientColors(Map<String, dynamic> foodData) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (foodCount == 0) {
      // Нет еды - серый
      return [Colors.grey.shade400, Colors.grey.shade500];
    } else if (sodium > 1500) {
      // Высокий натрий - красный
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    } else if (waterContent < 100 && foodCount > 2) {
      // Сухая еда - оранжевый
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else if (waterContent > 300) {
      // Хорошая гидратация - зеленый
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    } else {
      // Сбалансированная еда - синий
      return [const Color(0xFF42A5F5), const Color(0xFF1E88E5)];
    }
  }

  Color _getShadowColor(Map<String, dynamic> foodData) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (foodCount == 0) return Colors.grey;
    if (sodium > 1500) return Colors.red;
    if (waterContent < 100 && foodCount > 2) return Colors.orange;
    if (waterContent > 300) return Colors.green;
    return Colors.blue;
  }

  IconData _getFoodIcon(Map<String, dynamic> foodData) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (foodCount == 0) return Icons.restaurant_outlined;
    if (sodium > 1500) return Icons.warning_amber;
    if (waterContent > 300) return Icons.eco;
    if (waterContent < 100 && foodCount > 2) return Icons.dry_cleaning;
    return Icons.restaurant_menu;
  }

  IconData _getWarningIcon(Map<String, dynamic> foodData) {
    final foodCount = foodData['foodCount'] as int;
    final waterContent = foodData['waterContent'] as double;
    final sodium = foodData['sodium'] as double;

    if (foodCount == 0) return Icons.info_outline;
    if (sodium > 1500) return Icons.warning;
    if (waterContent > 300) return Icons.check_circle_outline;
    return Icons.lightbulb_outline;
  }
}