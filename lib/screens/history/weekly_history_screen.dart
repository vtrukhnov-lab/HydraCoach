import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

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
  
  DailyData({
    required this.date,
    required this.water,
    required this.sodium,
    required this.potassium,
    required this.magnesium,
    required this.waterPercent,
    required this.coffeeCount,
    required this.intakeCount,
  });
}

class WeeklyHistoryScreen extends StatefulWidget {
  const WeeklyHistoryScreen({super.key});

  @override
  State<WeeklyHistoryScreen> createState() => _WeeklyHistoryScreenState();
}

class _WeeklyHistoryScreenState extends State<WeeklyHistoryScreen> {
  // Данные для недельной статистики
  Map<String, DailyData> weeklyData = {};
  bool isLoadingWeekData = false;
  
  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }
  
  // Загрузка данных за последние 7 дней
  Future<void> _loadWeeklyData() async {
    if (isLoadingWeekData) return;
    
    setState(() {
      isLoadingWeekData = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final Map<String, DailyData> tempData = {};
    
    // Загружаем данные за последние 7 дней
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
      
      for (String json in intakesJson) {
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
          if (type == 'coffee') {
            coffeeCount++;
          }
          totalSodium += sodium;
          totalPotassium += potassium;
          totalMagnesium += magnesium;
        }
      }
      
      // Рассчитываем процент достижения цели
      final waterPercent = provider.goals.waterOpt > 0 
          ? (totalWater / provider.goals.waterOpt * 100).clamp(0, 100).toDouble()
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
      );
    }
    
    setState(() {
      weeklyData = tempData;
      isLoadingWeekData = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoadingWeekData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    final provider = Provider.of<HydrationProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // График потребления воды за неделю
          Container(
            height: 250,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💧 Потребление воды',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildWaterChart(),
                ),
              ],
            ),
          ).animate().fadeIn(),
          
          const SizedBox(height: 20),
          
          // График электролитов
          Container(
            height: 250,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚡ Электролиты',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildElectrolytesChart(),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),
          
          const SizedBox(height: 20),
          
          // Средние показатели
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Средние показатели за неделю',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAverageStats(),
              ],
            ),
          ).animate().slideY(delay: 200.ms),
          
          const SizedBox(height: 20),
          
          // Инсайты и рекомендации
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
                const Text(
                  '💡 Инсайты недели',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildWeeklyInsights(),
              ],
            ),
          ).animate().scale(delay: 300.ms),
        ],
      ),
    );
  }
  
  // График потребления воды с реальными данными
  Widget _buildWaterChart() {
    final provider = Provider.of<HydrationProvider>(context);
    final List<FlSpot> spots = [];
    final List<String> bottomTitles = [];
    
    // Сортируем данные по дате (от старых к новым)
    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.value.date.compareTo(b.value.date));
    
    for (int i = 0; i < sortedEntries.length; i++) {
      final data = sortedEntries[i].value;
      spots.add(FlSpot(i.toDouble(), data.waterPercent));
      bottomTitles.add(_getWeekdayShort(data.date));
    }
    
    if (spots.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: value == 100 ? [5, 5] : null,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                );
              },
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
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 25,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length - 1,
        minY: 0,
        maxY: 125,
        lineBarsData: [
          // Линия цели (100%)
          LineChartBarData(
            spots: List.generate(spots.length, (i) => FlSpot(i.toDouble(), 100)),
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
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                );
              },
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
            getTooltipColor: (touchedSpot) => Colors.blueGrey.shade800,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final sortedData = weeklyData.values.toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
                
                if (barSpot.barIndex == 1 && barSpot.x.toInt() < sortedData.length) {
                  final data = sortedData[barSpot.x.toInt()];
                  return LineTooltipItem(
                    '${data.water} мл\n${barSpot.y.toStringAsFixed(0)}%',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }
  
  // График электролитов с реальными данными
  Widget _buildElectrolytesChart() {
    final List<BarChartGroupData> barGroups = [];
    
    // Сортируем данные по дате
    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.value.date.compareTo(b.value.date));
    
    for (int i = 0; i < sortedEntries.length; i++) {
      final data = sortedEntries[i].value;
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (data.sodium / provider.goals.sodium * 100).clamp(0, 100),
              color: Colors.orange,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
            BarChartRodData(
              toY: (data.potassium / provider.goals.potassium * 100).clamp(0, 100),
              color: Colors.purple,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
            BarChartRodData(
              toY: (data.magnesium / provider.goals.magnesium * 100).clamp(0, 100),
              color: Colors.pink,
              width: 8,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      );
    }
    
    if (barGroups.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final sortedData = weeklyData.values.toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              
              if (groupIndex < sortedData.length) {
                final data = sortedData[groupIndex];
                String label;
                int value;
                
                switch (rodIndex) {
                  case 0:
                    label = 'Na';
                    value = data.sodium;
                    break;
                  case 1:
                    label = 'K';
                    value = data.potassium;
                    break;
                  case 2:
                    label = 'Mg';
                    value = data.magnesium;
                    break;
                  default:
                    return null;
                }
                
                return BarTooltipItem(
                  '$label: $value мг\n${rod.toY.toStringAsFixed(0)}%',
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
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 35,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final sortedData = weeklyData.values.toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
                
                if (value.toInt() < sortedData.length) {
                  return Text(
                    _getWeekdayShort(sortedData[value.toInt()].date),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 25,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }
  
  // Средние показатели за неделю
  Widget _buildAverageStats() {
    if (weeklyData.isEmpty) {
      return const Text('Загрузка данных...');
    }
    
    final provider = Provider.of<HydrationProvider>(context);
    
    // Вычисляем средние значения
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    int daysWithGoal = 0;
    int totalIntakes = 0;
    
    weeklyData.values.forEach((data) {
      totalWater += data.water;
      totalSodium += data.sodium;
      totalPotassium += data.potassium;
      totalMagnesium += data.magnesium;
      totalIntakes += data.intakeCount;
      
      if (data.waterPercent >= 90) {
        daysWithGoal++;
      }
    });
    
    final daysCount = weeklyData.length > 0 ? weeklyData.length : 1;
    
    return Column(
      children: [
        _buildStatRow(
          icon: '💧',
          label: 'Вода в день',
          value: '${(totalWater / daysCount).round()} мл',
          target: '${provider.goals.waterOpt} мл',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '⚡',
          label: 'Натрий в день',
          value: '${(totalSodium / daysCount).round()} мг',
          target: '${provider.goals.sodium} мг',
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '💜',
          label: 'Калий в день',
          value: '${(totalPotassium / daysCount).round()} мг',
          target: '${provider.goals.potassium} мг',
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          icon: '💗',
          label: 'Магний в день',
          value: '${(totalMagnesium / daysCount).round()} мг',
          target: '${provider.goals.magnesium} мг',
          color: Colors.pink,
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '✅ Дней с достижением цели',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: daysWithGoal >= 5 ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$daysWithGoal из 7',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: daysWithGoal >= 5 ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📝 Записей в день',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
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
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Цель',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
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
  
  // Умные инсайты на основе данных
  List<Widget> _buildWeeklyInsights() {
    final insights = <Widget>[];
    
    if (weeklyData.isEmpty) {
      return [const Text('Недостаточно данных для анализа', style: TextStyle(color: Colors.white70))];
    }
    
    // Анализируем паттерны
    final sortedData = weeklyData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    // 1. Лучший и худший день
    DailyData? bestDay;
    DailyData? worstDay;
    
    for (var data in sortedData) {
      if (bestDay == null || data.waterPercent > bestDay.waterPercent) {
        bestDay = data;
      }
      if (worstDay == null || data.waterPercent < worstDay.waterPercent) {
        worstDay = data;
      }
    }
    
    if (bestDay != null) {
      insights.add(_buildInsight(
        '🏆 Лучший день',
        '${_getWeekdayFull(bestDay.date)} - ${bestDay.waterPercent.toInt()}% от цели',
      ));
    }
    
    // 2. Паттерн выходных
    final weekend = sortedData.where((d) => d.date.weekday == 6 || d.date.weekday == 7);
    final weekdays = sortedData.where((d) => d.date.weekday < 6);
    
    if (weekend.isNotEmpty && weekdays.isNotEmpty) {
      final avgWeekend = weekend.map((d) => d.waterPercent).reduce((a, b) => a + b) / weekend.length;
      final avgWeekdays = weekdays.map((d) => d.waterPercent).reduce((a, b) => a + b) / weekdays.length;
      
      if ((avgWeekdays - avgWeekend).abs() > 15) {
        if (avgWeekdays > avgWeekend) {
          insights.add(_buildInsight(
            '📅 Выходные',
            'В выходные вы пьете на ${(avgWeekdays - avgWeekend).toInt()}% меньше',
          ));
        } else {
          insights.add(_buildInsight(
            '📅 Будни',
            'В будни вы пьете на ${(avgWeekend - avgWeekdays).toInt()}% меньше',
          ));
        }
      }
    }
    
    // 3. Тренд недели
    if (sortedData.length >= 3) {
      final firstHalf = sortedData.take(3).map((d) => d.waterPercent).reduce((a, b) => a + b) / 3;
      final secondHalf = sortedData.skip(sortedData.length - 3).map((d) => d.waterPercent).reduce((a, b) => a + b) / 3;
      
      if (secondHalf > firstHalf + 10) {
        insights.add(_buildInsight(
          '📈 Положительный тренд',
          'Ваша гидратация улучшается к концу недели',
        ));
      } else if (firstHalf > secondHalf + 10) {
        insights.add(_buildInsight(
          '📉 Снижение активности',
          'К концу недели потребление воды снижается',
        ));
      }
    }
    
    // 4. Электролитный баланс
    int daysWithGoodSodium = 0;
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    for (var data in sortedData) {
      if (data.sodium >= provider.goals.sodium * 0.7) {
        daysWithGoodSodium++;
      }
    }
    
    if (daysWithGoodSodium < 3) {
      insights.add(_buildInsight(
        '⚠️ Мало соли',
        'Только $daysWithGoodSodium дней с нормальным уровнем натрия',
      ));
    }
    
    return insights.isNotEmpty ? insights : [
      _buildInsight('✅ Отличная неделя', 'Продолжайте в том же духе!'),
    ];
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
                title.split(' ')[0],
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
  
  String _getWeekdayShort(DateTime date) {
    const days = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
    return days[date.weekday % 7];
  }
  
  String _getWeekdayFull(DateTime date) {
    const days = ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'];
    return days[date.weekday % 7];
  }
}