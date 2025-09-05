import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

import '../../main.dart';
import '../../services/alcohol_service.dart';

// Класс для хранения данных за день
class DailyData {
  final DateTime date;
  final int water;
  final int sodium;
  final int potassium;
  final int magnesium;
  final double waterPercent;
  final int coffeeCount;
  final int intakeCount;
  final double alcoholSD; // SD алкоголя

  DailyData({
    required this.date,
    required this.water,
    required this.sodium,
    required this.potassium,
    required this.magnesium,
    required this.waterPercent,
    required this.coffeeCount,
    required this.intakeCount,
    this.alcoholSD = 0,
  });
}

class WeeklyHistoryScreen extends StatefulWidget {
  const WeeklyHistoryScreen({super.key});

  @override
  State<WeeklyHistoryScreen> createState() => _WeeklyHistoryScreenState();
}

class _WeeklyHistoryScreenState extends State<WeeklyHistoryScreen> {
  Map<String, DailyData> weeklyData = {};
  bool isLoadingWeekData = false;

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {
    if (isLoadingWeekData) return;

    setState(() => isLoadingWeekData = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      final alcoholService =
          Provider.of<AlcoholService>(context, listen: false);

      final Map<String, DailyData> tempData = {};

      // За 7 дней
      for (int i = 0; i < 7; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateKey = date.toIso8601String().split('T')[0];
        final intakesKey = 'intakes_$dateKey';
        final intakesJson = prefs.getStringList(intakesKey) ?? [];

        int totalWater = 0;
        int totalSodium = 0;
        int totalPotassium = 0;
        int totalMagnesium = 0;
        int coffeeCount = 0;

        for (final json in intakesJson) {
          final parts = json.split('|');
          if (parts.length >= 7) {
            final type = parts[2];
            final volume = int.tryParse(parts[3]) ?? 0;
            final sodium = int.tryParse(parts[4]) ?? 0;
            final potassium = int.tryParse(parts[5]) ?? 0;
            final magnesium = int.tryParse(parts[6]) ?? 0;

            if (type == 'water' || type == 'electrolyte' || type == 'broth') {
              totalWater += volume;
            }
            if (type == 'coffee') coffeeCount++;

            totalSodium += sodium;
            totalPotassium += potassium;
            totalMagnesium += magnesium;
          }
        }

        // Алкоголь
        final alcoholIntakes = await alcoholService.getIntakesForDate(date);
        double totalSD = 0;
        for (final intake in alcoholIntakes) {
          totalSD += intake.standardDrinks;
        }

        // % цели по воде
        final waterPercent = provider.goals.waterOpt > 0
            ? ((totalWater / provider.goals.waterOpt) * 100)
                .clamp(0.0, 150.0)
                .toDouble()
            : 0.0;

        tempData[dateKey] = DailyData(
          date: date,
          water: totalWater,
          sodium: totalSodium,
          potassium: totalPotassium,
          magnesium: totalMagnesium,
          waterPercent: waterPercent,
          coffeeCount: coffeeCount,
          intakeCount: intakesJson.length,
          alcoholSD: totalSD,
        );
      }

      setState(() {
        weeklyData = tempData;
        isLoadingWeekData = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading weekly data: $e');
      setState(() => isLoadingWeekData = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoadingWeekData) {
      return const Center(child: CircularProgressIndicator());
    }

    final alcoholService = Provider.of<AlcoholService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Вода
          Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.waterConsumption,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildWaterChart(l10n)),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 20),

          // Алкоголь
          if (!alcoholService.soberModeEnabled && _hasAlcoholData())
            Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.alcoholWeek,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildAlcoholChart(l10n)),
                ],
              ),
            ).animate().fadeIn(delay: 50.ms),

          if (!alcoholService.soberModeEnabled && _hasAlcoholData())
            const SizedBox(height: 20),

          // Электролиты
          Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.electrolytes,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildElectrolytesChart(l10n)),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          // Средние показатели
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weeklyAverages,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildAverageStats(l10n),
              ],
            ),
          ).animate().slideY(delay: 200.ms),

          const SizedBox(height: 20),

          // Статистика алкоголя
          if (!alcoholService.soberModeEnabled && _hasAlcoholData())
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: _buildAlcoholStats(l10n),
            ).animate().fadeIn(delay: 250.ms),

          if (!alcoholService.soberModeEnabled && _hasAlcoholData())
            const SizedBox(height: 20),

          // Инсайты
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weeklyInsights,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildWeeklyInsights(l10n),
              ],
            ),
          ).animate().scale(delay: 300.ms),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // ===== Инсайты =====
  List<Widget> _buildWeeklyInsights(AppLocalizations l10n) {
    final insights = <Widget>[];

    if (weeklyData.isEmpty) {
      return [
        Text(l10n.insufficientDataForAnalysis,
            style: const TextStyle(color: Colors.white70))
      ];
    }

    final sorted = weeklyData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    DailyData? bestDay;
    DailyData? worstDay;
    for (var d in sorted) {
      if (bestDay == null || d.waterPercent > bestDay.waterPercent) {
        bestDay = d;
      }
      if (worstDay == null || d.waterPercent < worstDay.waterPercent) {
        worstDay = d;
      }
    }
    if (bestDay != null) {
      insights.add(_buildInsight(
        l10n.bestDay,
        l10n.bestDayMessage(_getWeekdayFull(bestDay.date, l10n), bestDay.waterPercent.toInt()),
      ));
    }

    final weekend = sorted.where(
        (d) => d.date.weekday == 6 || d.date.weekday == 7);
    final weekdays = sorted.where((d) => d.date.weekday < 6);

    if (weekend.isNotEmpty && weekdays.isNotEmpty) {
      final avgWeekend =
          weekend.map((d) => d.waterPercent).reduce((a, b) => a + b) /
              weekend.length;
      final avgWeekdays =
          weekdays.map((d) => d.waterPercent).reduce((a, b) => a + b) /
              weekdays.length;

      if ((avgWeekdays - avgWeekend).abs() > 15) {
        if (avgWeekdays > avgWeekend) {
          insights.add(_buildInsight(
            l10n.weekends,
            l10n.drinkLessOnWeekends((avgWeekdays - avgWeekend).toInt()),
          ));
        } else {
          insights.add(_buildInsight(
            l10n.weekdays,
            l10n.drinkLessOnWeekdays((avgWeekend - avgWeekdays).toInt()),
          ));
        }
      }
    }

    if (sorted.length >= 3) {
      final firstHalf =
          sorted.take(3).map((d) => d.waterPercent).reduce((a, b) => a + b) /
              3;
      final secondHalf = sorted
              .skip(sorted.length - 3)
              .map((d) => d.waterPercent)
              .reduce((a, b) => a + b) /
          3;

      if (secondHalf > firstHalf + 10) {
        insights.add(_buildInsight(
          l10n.positiveTrend,
          l10n.positiveTrendMessage,
        ));
      } else if (firstHalf > secondHalf + 10) {
        insights.add(_buildInsight(
          l10n.decliningActivity,
          l10n.decliningActivityMessage,
        ));
      }
    }

    int daysWithGoodSodium = 0;
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    for (var d in sorted) {
      if (d.sodium >= provider.goals.sodium * 0.7) {
        daysWithGoodSodium++;
      }
    }
    if (daysWithGoodSodium < 3) {
      insights.add(_buildInsight(
        l10n.lowSalt,
        l10n.lowSaltMessage(daysWithGoodSodium),
      ));
    }

    if (_hasAlcoholData()) {
      int daysWithAlcohol = 0;
      for (var d in sorted) {
        if (d.alcoholSD > 0) daysWithAlcohol++;
      }
      if (daysWithAlcohol > 3) {
        insights.add(_buildInsight(
          l10n.frequentAlcohol,
          l10n.frequentAlcoholMessage(daysWithAlcohol),
        ));
      }
    }

    return insights.isNotEmpty
        ? insights
        : [_buildInsight(l10n.excellentWeek, l10n.continueMessage)];
  }

  Widget _buildInsight(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                title.split(' ').first,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(title.indexOf(' ') + 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekdayShort(DateTime date, AppLocalizations l10n) {
    switch (date.weekday) {
      case 1: return l10n.monday.substring(0, 2);
      case 2: return l10n.tuesday.substring(0, 2);
      case 3: return l10n.wednesday.substring(0, 2);
      case 4: return l10n.thursday.substring(0, 2);
      case 5: return l10n.friday.substring(0, 2);
      case 6: return l10n.saturday.substring(0, 2);
      case 7: return l10n.sunday.substring(0, 2);
      default: return '';
    }
  }

  String _getWeekdayFull(DateTime date, AppLocalizations l10n) {
    switch (date.weekday) {
      case 1: return l10n.monday;
      case 2: return l10n.tuesday;
      case 3: return l10n.wednesday;
      case 4: return l10n.thursday;
      case 5: return l10n.friday;
      case 6: return l10n.saturday;
      case 7: return l10n.sunday;
      default: return '';
    }
  }

  // ===== Алкоголь: график =====
  Widget _buildAlcoholChart(AppLocalizations l10n) {
    final List<BarChartGroupData> barGroups = [];
    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.value.date.compareTo(b.value.date));

    for (int i = 0; i < sortedEntries.length; i++) {
      final data = sortedEntries[i].value;
      if (data.alcoholSD > 0) {
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data.alcoholSD,
                color: data.alcoholSD > 2 ? Colors.red : Colors.orange,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }
    }

    if (barGroups.isEmpty) {
      return Center(child: Text(l10n.noData));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (_getMaxAlcoholValue() * 1.2),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final sortedData = weeklyData.values.toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              if (groupIndex < sortedData.length) {
                final d = sortedData[groupIndex];
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)} SD\n${_getWeekdayShort(d.date, l10n)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(1),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              ),
              reservedSize: 35,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final list = weeklyData.values.toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
                final idx = value.toInt();
                if (idx >= 0 && idx < list.length) {
                  return Text(
                    _getWeekdayShort(list[idx].date, l10n),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 25,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1.0,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
      ),
    );
  }

  // ===== Алкоголь: статблок =====
  Widget _buildAlcoholStats(AppLocalizations l10n) {
    double totalSD = 0;
    int daysWithAlcohol = 0;
    int soberDays = 0;

    for (var d in weeklyData.values) {
      if (d.alcoholSD > 0) {
        totalSD += d.alcoholSD;
        daysWithAlcohol++;
      } else {
        soberDays++;
      }
    }

    final avgSD = daysWithAlcohol > 0 ? totalSD / daysWithAlcohol : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_bar, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              l10n.alcoholStatisticsTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child:
                  _buildAlcoholStatCard(l10n.totalSD, totalSD.toStringAsFixed(1),
                      Icons.assessment),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAlcoholStatCard(
                  l10n.daysWithAlcohol, '$daysWithAlcohol', Icons.calendar_today),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAlcoholStatCard(
                  l10n.soberDays, '$soberDays', Icons.check_circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAlcoholStatCard(
                  l10n.averageSD, avgSD.toStringAsFixed(1),
                  Icons.trending_flat),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlcoholStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Expanded(
              child: Text(label,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  bool _hasAlcoholData() =>
      weeklyData.values.any((d) => d.alcoholSD > 0);

  double _getMaxAlcoholValue() {
    double maxV = 0;
    for (var d in weeklyData.values) {
      if (d.alcoholSD > maxV) maxV = d.alcoholSD;
    }
    return maxV > 0 ? maxV : 5.0;
  }

  // ===== Вода: график =====
  Widget _buildWaterChart(AppLocalizations l10n) {
    final List<FlSpot> spots = [];
    final List<String> bottomTitles = [];

    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.value.date.compareTo(b.value.date));

    for (int i = 0; i < sortedEntries.length; i++) {
      final d = sortedEntries[i].value;
      spots.add(FlSpot(i.toDouble(), d.waterPercent));
      bottomTitles.add(_getWeekdayShort(d.date, l10n));
    }

    if (spots.isEmpty) {
      return Center(child: Text(l10n.noData));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25.0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
            dashArray: value == 100.0 ? [5, 5] : null,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25.0,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              ),
              reservedSize: 35,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < bottomTitles.length) {
                  return Text(
                    bottomTitles[index],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 25,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0.0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0.0,
        maxY: 125.0,
        lineBarsData: [
          // Линия цели 100%
          LineChartBarData(
            spots: List.generate(
              spots.length,
              (i) => FlSpot(i.toDouble(), 100.0),
            ),
            isCurved: false,
            color: Colors.green.withOpacity(0.3),
            barWidth: 1,
            isStrokeCapRound: false,
            dotData: const FlDotData(show: false),
            dashArray: [5, 5],
          ),
          // Основная линия
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.blue,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey.shade800,
            getTooltipItems: (touchedBarSpots) {
              final sortedData = weeklyData.values.toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              return touchedBarSpots
                  .map<LineTooltipItem?>((barSpot) {
                    if (barSpot.barIndex == 1 &&
                        barSpot.x.toInt() < sortedData.length) {
                      final d = sortedData[barSpot.x.toInt()];
                      return LineTooltipItem(
                        '${d.water} ${l10n.ml}\n${barSpot.y.toStringAsFixed(0)}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return null;
                  })
                  .whereType<LineTooltipItem>()
                  .toList();
            },
          ),
        ),
      ),
    );
  }

  // ===== Электролиты: график =====
  Widget _buildElectrolytesChart(AppLocalizations l10n) {
    final List<BarChartGroupData> barGroups = [];
    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.value.date.compareTo(b.value.date));

    final provider = Provider.of<HydrationProvider>(context, listen: false);

    for (int i = 0; i < sortedEntries.length; i++) {
      final d = sortedEntries[i].value;

      final naPct = ((d.sodium / (provider.goals.sodium == 0
                      ? 1
                      : provider.goals.sodium)) *
              100)
          .clamp(0.0, 150.0)
          .toDouble();

      final kPct = ((d.potassium / (provider.goals.potassium == 0
                      ? 1
                      : provider.goals.potassium)) *
              100)
          .clamp(0.0, 150.0)
          .toDouble();

      final mgPct = ((d.magnesium / (provider.goals.magnesium == 0
                      ? 1
                      : provider.goals.magnesium)) *
              100)
          .clamp(0.0, 150.0)
          .toDouble();

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: naPct,
              color: Colors.orange,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
            BarChartRodData(
              toY: kPct,
              color: Colors.purple,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
            BarChartRodData(
              toY: mgPct,
              color: Colors.pink,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      );
    }

    if (barGroups.isEmpty) {
      return Center(child: Text(l10n.noData));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 150.0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final list = weeklyData.values.toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              if (groupIndex < list.length) {
                final d = list[groupIndex];
                String label;
                int raw;
                switch (rodIndex) {
                  case 0:
                    label = 'Na';
                    raw = d.sodium;
                    break;
                  case 1:
                    label = 'K';
                    raw = d.potassium;
                    break;
                  case 2:
                    label = 'Mg';
                    raw = d.magnesium;
                    break;
                  default:
                    return null;
                }
                return BarTooltipItem(
                  '$label: $raw ${l10n.mg}\n${rod.toY.toStringAsFixed(0)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            }
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25.0,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
              ),
              reservedSize: 35,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final list = weeklyData.values.toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
                final idx = value.toInt();
                if (idx >= 0 && idx < list.length) {
                  return Text(
                    _getWeekdayShort(list[idx].date, l10n),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 25,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25.0,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
      ),
    );
  }

  // ===== Средние показатели =====
  Widget _buildAverageStats(AppLocalizations l10n) {
    if (weeklyData.isEmpty) {
      return Text(l10n.loadingData);
    }

    final provider = Provider.of<HydrationProvider>(context);

    double totalWater = 0;
    double totalSodium = 0;
    double totalPotassium = 0;
    double totalMagnesium = 0;
    int daysWithGoal = 0;
    double totalIntakes = 0;

    for (var d in weeklyData.values) {
      totalWater += d.water;
      totalSodium += d.sodium;
      totalPotassium += d.potassium;
      totalMagnesium += d.magnesium;
      totalIntakes += d.intakeCount;
      if (d.waterPercent >= 90) daysWithGoal++;
    }

    final daysCount = weeklyData.length;

    return Column(
      children: [
        _buildStatRow(
          icon: '💧',
          label: l10n.waterPerDay,
          value: '${(totalWater / daysCount).round()} ${l10n.ml}',
          target: '${provider.goals.waterOpt} ${l10n.ml}',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '⚡',
          label: l10n.sodiumPerDay,
          value: '${(totalSodium / daysCount).round()} ${l10n.mg}',
          target: '${provider.goals.sodium} ${l10n.mg}',
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '💜',
          label: l10n.potassiumPerDay,
          value: '${(totalPotassium / daysCount).round()} ${l10n.mg}',
          target: '${provider.goals.potassium} ${l10n.mg}',
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '💗',
          label: l10n.magnesiumPerDay,
          value: '${(totalMagnesium / daysCount).round()} ${l10n.mg}',
          target: '${provider.goals.magnesium} ${l10n.mg}',
          color: Colors.pink,
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.daysWithGoalAchieved,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: daysWithGoal >= 5
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$daysWithGoal ${l10n.fromDays(7)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: daysWithGoal >= 5
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.recordsPerDay,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '≈ ${(totalIntakes / daysCount).round()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required String icon,
    required String label,
    required String value,
    required String target,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Goal',
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            Text(
              target,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}