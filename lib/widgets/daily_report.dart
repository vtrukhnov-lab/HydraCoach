import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class DailyReportCard extends StatelessWidget {
  const DailyReportCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<HydrationProvider>(
      builder: (context, provider, child) {
        final progress = provider.getProgress();
        final status = provider.getHydrationStatus();
        
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Дневной отчет',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getFormattedDate(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getStatusIcon(status),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              
              // График прогресса за день
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                child: _buildDayProgressChart(provider),
              ),
              
              // Статистика
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildStatRow(
                      'Вода',
                      '${progress['water']!.toInt()} / ${provider.goals.waterOpt} мл',
                      progress['waterPercent']!,
                      Colors.white,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Натрий',
                      '${progress['sodium']!.toInt()} / ${provider.goals.sodium} мг',
                      progress['sodiumPercent']!,
                      Colors.yellow.shade300,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Калий',
                      '${progress['potassium']!.toInt()} / ${provider.goals.potassium} мг',
                      progress['potassiumPercent']!,
                      Colors.purple.shade300,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Магний',
                      '${progress['magnesium']!.toInt()} / ${provider.goals.magnesium} мг',
                      progress['magnesiumPercent']!,
                      Colors.pink.shade300,
                    ),
                  ],
                ),
              ),
              
              // Рекомендации
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.yellow.shade300,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Рекомендации на завтра',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getRecommendation(status, progress),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Кнопка поделиться
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Поделиться отчетом
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Поделиться результатом'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade600,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate()
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.1, end: 0);
      },
    );
  }
  
  Widget _buildDayProgressChart(HydrationProvider provider) {
    // Симуляция данных за день (по часам)
    final spots = <FlSpot>[];
    for (int i = 7; i <= 22; i++) {
      final progress = i <= DateTime.now().hour 
        ? (i - 7) / 15 * provider.getProgress()['waterPercent']!
        : 0.0;
      spots.add(FlSpot(i.toDouble(), progress));
    }
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
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
                    color: Colors.white.withOpacity(0.6),
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
              interval: 3,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 3 == 1) {
                  return Text(
                    '${value.toInt()}:00',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox.shrink();
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
        minX: 7,
        maxX: 22,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.white,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, double percent, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getPercentColor(percent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${percent.toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getPercentColor(double percent) {
    if (percent >= 90) return Colors.green;
    if (percent >= 70) return Colors.yellow.shade700;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Норма':
        return Icons.check_circle;
      case 'Разбавляешь':
        return Icons.water_damage;
      case 'Недобор воды':
        return Icons.warning;
      case 'Мало соли':
        return Icons.grain;
      default:
        return Icons.info;
    }
  }
  
  String _getRecommendation(String status, Map<String, double> progress) {
    if (status == 'Норма' && progress['waterPercent']! >= 90) {
      return 'Отличная работа! Продолжайте в том же духе. '
             'Старайтесь начинать день со стакана воды и '
             'поддерживать равномерное потребление.';
    } else if (status == 'Разбавляешь') {
      return 'Вы пьете много воды, но мало электролитов. '
             'Завтра добавьте больше соли или выпейте электролитный напиток. '
             'Попробуйте начать день с соленого бульона.';
    } else if (status == 'Недобор воды') {
      return 'Недостаточно воды сегодня. '
             'Завтра поставьте напоминания каждые 2 часа. '
             'Держите бутылку воды на видном месте.';
    } else if (status == 'Мало соли') {
      return 'Низкий уровень натрия может вызвать усталость. '
             'Добавьте щепотку соли в воду или выпейте бульон. '
             'Особенно важно на кето или при голодании.';
    } else {
      return 'Стремитесь к балансу воды и электролитов. '
             'Пейте равномерно в течение дня и не забывайте про соль в жару.';
    }
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
                   'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}