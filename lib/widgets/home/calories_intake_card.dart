// lib/widgets/home/calories_intake_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/hydration_provider.dart';
import '../../services/subscription_service.dart';
import '../../screens/paywall_screen.dart';
import '../../screens/food_catalog_screen.dart';
import '../../l10n/app_localizations.dart';

class CaloriesIntakeCard extends StatelessWidget {
  const CaloriesIntakeCard({super.key});

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
    final totalCalories = provider.totalCaloriesToday;
    final foodProgress = provider.getFoodProgress();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FoodCatalogScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(totalCalories),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(totalCalories).withValues(alpha: 0.3),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getCaloriesIcon(totalCalories),
                              color: Colors.white,
                              size: 36,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$totalCalories',
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
                          l10n.calories,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _getStatusText(totalCalories, l10n),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Водный баланс от еды
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${foodProgress['totalWaterFromFood'].round()}${l10n.ml}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.fromFood,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nutritional breakdown
              if (foodProgress['foodCount'] > 0) ...[
                // Progress bar for calories (2000 kcal goal)
                _buildCalorieProgress(context, totalCalories, l10n),
                const SizedBox(height: 12),

                // Nutritional info row
                Row(
                  children: [
                    Expanded(
                      child: _buildNutrientCard(
                        '${foodProgress['totalSugar']?.toStringAsFixed(1) ?? '0.0'}g',
                        l10n.sugar,
                        Icons.cake,
                        Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildNutrientCard(
                        '${foodProgress['additionalSodium']?.toString() ?? '0'}mg',
                        l10n.sodium,
                        Icons.bolt,
                        Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Food count and last meal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${foodProgress['foodCount']} ${l10n.meals} today',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (provider.todayFoodIntakes.isNotEmpty)
                      Text(
                        'Last: ${provider.todayFoodIntakes.last.formattedTime}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.tapToAddFood,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildCalorieProgress(BuildContext context, int totalCalories, AppLocalizations l10n) {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final goal = provider.calorieGoal; // Dynamic calorie goal based on weight
    final progress = (totalCalories / goal).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.dailyProgress,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).round()}% of $goal',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCard(String value, String label, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(int calories) {
    if (calories == 0) {
      return [Colors.grey[400]!, Colors.grey[300]!];
    } else if (calories < 500) {
      return [Colors.green[400]!, Colors.green[300]!];
    } else if (calories < 1000) {
      return [Colors.blue[400]!, Colors.blue[300]!];
    } else if (calories < 1500) {
      return [Colors.orange[400]!, Colors.orange[300]!];
    } else if (calories < 2000) {
      return [Colors.deepOrange[400]!, Colors.deepOrange[300]!];
    } else {
      return [Colors.red[400]!, Colors.red[300]!];
    }
  }

  Color _getShadowColor(int calories) {
    if (calories == 0) {
      return Colors.grey;
    } else if (calories < 500) {
      return Colors.green;
    } else if (calories < 1000) {
      return Colors.blue;
    } else if (calories < 1500) {
      return Colors.orange;
    } else if (calories < 2000) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  IconData _getCaloriesIcon(int calories) {
    if (calories == 0) {
      return Icons.restaurant_outlined;
    } else if (calories < 500) {
      return Icons.eco;
    } else if (calories < 1000) {
      return Icons.restaurant;
    } else if (calories < 1500) {
      return Icons.local_fire_department;
    } else if (calories < 2000) {
      return Icons.whatshot;
    } else {
      return Icons.local_fire_department;
    }
  }

  String _getStatusText(int calories, [AppLocalizations? l10n]) {
    if (calories == 0) {
      return l10n?.noFoodLoggedToday ?? 'No food logged today';
    } else if (calories < 500) {
      return l10n?.lightEatingDay ?? 'Light eating day';
    } else if (calories < 1000) {
      return l10n?.moderateIntake ?? 'Moderate intake';
    } else if (calories < 1500) {
      return l10n?.goodCalorieIntake ?? 'Good calorie intake';
    } else if (calories < 2000) {
      return l10n?.substantialMeals ?? 'Substantial meals';
    } else if (calories < 2500) {
      return l10n?.highCalorieDay ?? 'High calorie day';
    } else {
      return l10n?.veryHighIntake ?? 'Very high intake';
    }
  }

  Widget _buildProLockedCard(BuildContext context, AppLocalizations? l10n) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaywallScreen(source: 'calories_card'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[400]!, Colors.grey[300]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 36,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'PRO',
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
                          l10n?.caloriesTracker ?? 'Calories Tracker',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          l10n?.trackYourDailyCalorieIntake ?? 'Track your daily calorie intake from food',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'UPGRADE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n?.unlockFoodTrackingFeatures ?? 'Unlock food tracking features',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
    );
  }
}