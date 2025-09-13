// lib/widgets/home/sugar_intake_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/hydration_provider.dart';
import '../../l10n/app_localizations.dart';

class SugarIntakeCard extends StatelessWidget {
  const SugarIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final l10n = AppLocalizations.of(context);
    final sugarData = provider.getSugarIntakeData(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getSugarGradient(sugarData.totalGrams),
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
            // Header section with total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                          '${sugarData.totalGrams.toStringAsFixed(1)}g',
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
                      l10n.sugarIntake,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getSugarLevelText(sugarData.totalGrams, l10n),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // HRI Impact block
                if (sugarData.totalGrams > 50)
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
                          '+${_getHRIImpact(sugarData.totalGrams)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.points,
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

            // Divider
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

            // Detail section - sugar types
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.eco,
                  label: l10n.naturalSugar,
                  value: '${sugarData.naturalSugarGrams.toStringAsFixed(1)}g',
                ),
                _buildDetailItem(
                  icon: Icons.add_circle,
                  label: l10n.addedSugar,
                  value: '${sugarData.addedSugarGrams.toStringAsFixed(1)}g',
                ),
                _buildDetailItem(
                  icon: Icons.visibility_off,
                  label: l10n.hiddenSugar,
                  value: '${sugarData.hiddenSugarGrams.toStringAsFixed(1)}g',
                ),
              ],
            ),

            // Recommendations section
            if (sugarData.totalGrams > 0) ...[
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
                          _getWarningIcon(sugarData.totalGrams),
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _getSugarAdvice(sugarData.totalGrams, l10n),
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
                    // Daily limit percentage
                    _buildInfoRow(
                      icon: Icons.pie_chart_outline,
                      label: l10n.dailyLimit,
                      value: _getDailyLimitText(sugarData.totalGrams),
                    ),
                    const SizedBox(height: 6),
                    // Main sugar source
                    _buildInfoRow(
                      icon: Icons.local_drink,
                      label: l10n.sugarSources,
                      value: _getMainSource(sugarData, l10n),
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

  Widget _buildInfoRow({
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

  int _getHRIImpact(double grams) {
    if (grams <= 50) return 0;
    if (grams <= 75) return ((grams - 50) * 0.2).round();
    return (5 + (grams - 75) * 0.2).clamp(0, 10).round();
  }

  String _getDailyLimitText(double grams) {
    final percentage = (grams / 25 * 100).clamp(0, 999);
    if (percentage <= 100) return '${percentage.toStringAsFixed(0)}% (25g)';
    return '${percentage.toStringAsFixed(0)}% ⚠️';
  }

  String _getMainSource(SugarIntakeData data, AppLocalizations l10n) {
    if (data.drinksGrams > data.foodGrams && data.drinksGrams > data.snacksGrams) {
      return '${data.drinksGrams.toStringAsFixed(1)}g ${l10n.drinks}';
    } else if (data.foodGrams > data.snacksGrams) {
      return '${data.foodGrams.toStringAsFixed(1)}g ${l10n.food}';
    } else if (data.snacksGrams > 0) {
      return '${data.snacksGrams.toStringAsFixed(1)}g ${l10n.snacks}';
    }
    return '✓';
  }

  String _getSugarLevelText(double grams, AppLocalizations l10n) {
    if (grams <= 25) return l10n.sugarNormal;
    if (grams <= 50) return l10n.sugarModerate;
    if (grams <= 75) return l10n.sugarHigh;
    return l10n.sugarCritical;
  }

  String _getSugarAdvice(double grams, AppLocalizations l10n) {
    if (grams <= 25) return l10n.sugarRecommendationNormal;
    if (grams <= 50) return l10n.sugarRecommendationModerate;
    if (grams <= 75) return l10n.sugarRecommendationHigh;
    return l10n.sugarRecommendationCritical;
  }

  List<Color> _getSugarGradient(double grams) {
    if (grams <= 25) {
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    } else if (grams <= 50) {
      return [const Color(0xFFFFCA28), const Color(0xFFFFB300)];
    } else if (grams <= 75) {
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else {
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
    if (grams <= 25) return Icons.cake;
    if (grams <= 50) return Icons.cookie;
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