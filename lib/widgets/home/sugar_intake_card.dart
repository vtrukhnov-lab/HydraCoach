// lib/widgets/home/sugar_intake_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/hydration_provider.dart';
import '../../services/remote_config_service.dart';
import '../../l10n/app_localizations.dart';

class SugarIntakeCard extends StatelessWidget {
  const SugarIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final l10n = AppLocalizations.of(context);
    final sugarData = provider.getSugarIntakeData();
    
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
            // Верхняя секция с основной информацией
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cake,
                          color: Colors.white,
                          size: 36,
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
                // HRI Impact блок
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

            // Детальная информация - 3 колонки
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.local_drink,
                  label: l10n.sugarFromDrinks,
                  value: '${sugarData.drinksGrams.toStringAsFixed(1)}g',
                ),
                _buildDetailItem(
                  icon: Icons.restaurant,
                  label: l10n.sugarFromFood,
                  value: '${sugarData.foodGrams.toStringAsFixed(1)}g',
                ),
                _buildDetailItem(
                  icon: Icons.cookie,
                  label: l10n.sugarFromSnacks,
                  value: '${sugarData.snacksGrams.toStringAsFixed(1)}g',
                ),
              ],
            ),

            // Визуализация - круговая диаграмма
            if (sugarData.totalGrams > 0) ...[
              const SizedBox(height: 24),
              Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Круговая диаграмма
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: _getPieChartSections(sugarData),
                        ),
                      ),
                    ),
                    // Легенда
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            color: Colors.green.withOpacity(0.8),
                            label: l10n.naturalSugar,
                            value: sugarData.naturalSugarGrams,
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem(
                            color: Colors.orange.withOpacity(0.8),
                            label: l10n.addedSugar,
                            value: sugarData.addedSugarGrams,
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem(
                            color: Colors.red.withOpacity(0.8),
                            label: l10n.hiddenSugar,
                            value: sugarData.hiddenSugarGrams,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Рекомендации
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
                    // Процент от дневной нормы
                    _buildAdjustmentRow(
                      icon: Icons.pie_chart_outline,
                      label: l10n.dailyLimit,
                      value: _getDailyLimitText(sugarData.totalGrams),
                    ),
                    const SizedBox(height: 6),
                    // Рекомендация по воде
                    if (sugarData.totalGrams > 25)
                      _buildAdjustmentRow(
                        icon: Icons.local_drink,
                        label: l10n.water,
                        value: _getWaterRecommendation(sugarData.totalGrams),
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

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required double value,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSections(SugarIntakeData data) {
    final sections = <PieChartSectionData>[];
    
    if (data.naturalSugarGrams > 0) {
      sections.add(
        PieChartSectionData(
          value: data.naturalSugarGrams,
          title: '',
          color: Colors.green.withOpacity(0.8),
          radius: 40,
        ),
      );
    }
    
    if (data.addedSugarGrams > 0) {
      sections.add(
        PieChartSectionData(
          value: data.addedSugarGrams,
          title: '',
          color: Colors.orange.withOpacity(0.8),
          radius: 40,
        ),
      );
    }
    
    if (data.hiddenSugarGrams > 0) {
      sections.add(
        PieChartSectionData(
          value: data.hiddenSugarGrams,
          title: '',
          color: Colors.red.withOpacity(0.8),
          radius: 40,
        ),
      );
    }
    
    return sections;
  }

  int _getHRIImpact(double grams) {
    if (grams <= 50) return 0;
    if (grams <= 75) return ((grams - 50) * 0.2).round();
    return (5 + (grams - 75) * 0.2).clamp(0, 10).round();
  }

  String _getDailyLimitText(double grams) {
    final percentage = (grams / 25 * 100).clamp(0, 999);
    return '${percentage.toStringAsFixed(0)}%';
  }

  String _getWaterRecommendation(double grams) {
    if (grams <= 25) return '✓';
    if (grams <= 50) return '+250ml';
    if (grams <= 75) return '+500ml';
    return '+750ml';
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
      // Зеленый - норма
      return [const Color(0xFF66BB6A), const Color(0xFF43A047)];
    } else if (grams <= 50) {
      // Желтый - умеренно
      return [const Color(0xFFFFCA28), const Color(0xFFFFB300)];
    } else if (grams <= 75) {
      // Оранжевый - высокое
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else {
      // Красный - критическое
      return [const Color(0xFFEF5350), const Color(0xFFE53935)];
    }
  }

  Color _getShadowColor(double grams) {
    if (grams <= 25) return Colors.green;
    if (grams <= 50) return Colors.amber;
    if (grams <= 75) return Colors.orange;
    return Colors.red;
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