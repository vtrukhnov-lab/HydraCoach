import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../main.dart';
import 'weekly_history_screen.dart'; // Импортируем DailyData

class MonthlyHistoryScreen extends StatefulWidget {
  const MonthlyHistoryScreen({super.key});

  @override
  State<MonthlyHistoryScreen> createState() => _MonthlyHistoryScreenState();
}

class _MonthlyHistoryScreenState extends State<MonthlyHistoryScreen> {
  // Данные для месячной статистики
  Map<String, DailyData> monthlyData = {};
  bool isLoadingMonthData = false;
  
  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }
  
  // Загрузка данных за месяц
  Future<void> _loadMonthlyData() async {
    if (isLoadingMonthData) return;
    
    setState(() {
      isLoadingMonthData = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final Map<String, DailyData> tempData = {};
    
    // Загружаем данные за последние 30 дней
    for (int i = 0; i < 30; i++) {
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
      
      final waterPercent = provider.goals.waterOpt > 0 
          ? (totalWater / provider.goals.waterOpt * 100).clamp(0, 150).toDouble()
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
      monthlyData = tempData;
      isLoadingMonthData = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoadingMonthData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Календарь с реальной тепловой картой
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
            child: _buildRealHeatmapCalendar(),
          ).animate().fadeIn(),
          
          const SizedBox(height: 20),
          
          // Панель достижений (ИСПРАВЛЕННАЯ ВЕРСИЯ)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🏆',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Достижения месяца',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_calculateAchievements()} / 10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Список достижений без дополнительного контейнера
                ..._buildAchievementsList(),
              ],
            ),
          ).animate().scale(delay: 200.ms),
          
          const SizedBox(height: 20),
          
          // Месячная статистика
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
                  '📊 Статистика месяца',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildMonthlyStats(),
              ],
            ),
          ).animate().slideY(delay: 300.ms),
        ],
      ),
    );
  }
  
  // Построение реального календаря с тепловой картой
  Widget _buildRealHeatmapCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    // Определяем день недели первого числа (1=Пн, 7=Вс)
    final firstWeekday = firstDayOfMonth.weekday;
    
    // Добавляем заголовки дней недели
    const weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    
    return Column(
      children: [
        Text(
          _getMonthName(now.month) + ' ${now.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Заголовки дней недели
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDays.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        
        // Календарная сетка
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: (firstWeekday - 1) + lastDayOfMonth.day,
          itemBuilder: (context, index) {
            // Пустые ячейки до первого числа
            if (index < firstWeekday - 1) {
              return Container();
            }
            
            final day = index - (firstWeekday - 2);
            final date = DateTime(now.year, now.month, day);
            final dateKey = date.toIso8601String().split('T')[0];
            
            // Получаем данные за этот день
            final dayData = monthlyData[dateKey];
            final progress = dayData?.waterPercent ?? 0;
            
            // Будущие даты
            if (date.isAfter(now)) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }
            
            return GestureDetector(
              onTap: () {
                // Показываем детали дня
                _showDayDetails(date, dayData);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _getHeatmapColor(progress),
                  borderRadius: BorderRadius.circular(8),
                  border: date.day == now.day 
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: progress > 70 ? Colors.white : Colors.black87,
                          fontSize: 12,
                          fontWeight: date.day == now.day ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      if (progress > 0)
                        Text(
                          '${progress.toInt()}%',
                          style: TextStyle(
                            color: progress > 70 ? Colors.white70 : Colors.black54,
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Легенда
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('0%', Colors.grey.shade200),
            _buildLegendItem('1-50%', Colors.red.shade200),
            _buildLegendItem('51-80%', Colors.orange.shade300),
            _buildLegendItem('81-99%', Colors.blue.shade400),
            _buildLegendItem('100%+', Colors.green.shade500),
          ],
        ),
      ],
    );
  }
  
  // Показать детали дня при нажатии
  void _showDayDetails(DateTime date, DailyData? data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day} ${_getMonthName(date.month)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (data != null) ...[
                Row(
                  children: [
                    Icon(Icons.water_drop, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Text('Вода: ${data.water} мл (${data.waterPercent.toInt()}%)'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    Text('Na: ${data.sodium} мг, K: ${data.potassium} мг'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.coffee, color: Colors.brown.shade600),
                    const SizedBox(width: 8),
                    Text('Кофе: ${data.coffeeCount} чашек'),
                  ],
                ),
              ] else ...[
                const Text('Нет данных за этот день'),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  // ИСПРАВЛЕННЫЙ список достижений (убрали лишний контейнер)
  List<Widget> _buildAchievementsList() {
    final achievements = _getAchievementsData();
    
    return achievements.map((achievement) {
      final isUnlocked = achievement['unlocked'] as bool;
      final progress = achievement['progress'] as double;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isUnlocked ? 0.25 : 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(isUnlocked ? 0.4 : 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Иконка достижения
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isUnlocked ? 0.3 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.6,
                    child: Text(
                      achievement['icon'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Информация о достижении
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['title'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: isUnlocked ? TextDecoration.none : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement['description'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                    
                    // Прогресс бар для не разблокированных достижений
                    if (!isUnlocked && progress > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withOpacity(0.7),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toInt()}% выполнено',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Статус достижения
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white.withOpacity(0.6),
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }
  
  // Получение данных о достижениях
  List<Map<String, dynamic>> _getAchievementsData() {
    if (monthlyData.isEmpty) {
      return List.generate(10, (index) => {
        'icon': '🔒',
        'title': 'Загрузка...',
        'description': 'Подождите',
        'unlocked': false,
        'progress': 0.0,
      });
    }
    
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Анализируем данные для достижений
    int perfectDays = 0;
    int goodDays = 0;
    int streakDays = 0;
    int currentStreak = 0;
    int earlyBirdDays = 0;
    int totalWater = 0;
    int daysWithElectrolytes = 0;
    int consistentDays = 0;
    int weekendWarriorDays = 0;
    double avgPercent = 0;
    
    final sortedData = monthlyData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    for (var data in sortedData) {
      // Подсчеты для достижений
      if (data.waterPercent >= 100) perfectDays++;
      if (data.waterPercent >= 80) goodDays++;
      if (data.water > 0) {
        currentStreak++;
        if (currentStreak > streakDays) streakDays = currentStreak;
      } else {
        currentStreak = 0;
      }
      
      totalWater += data.water;
      avgPercent += data.waterPercent;
      
      if (data.sodium >= provider.goals.sodium * 0.7) {
        daysWithElectrolytes++;
      }
      
      if (data.intakeCount >= 5 && data.intakeCount <= 8) {
        consistentDays++;
      }
      
      if ((data.date.weekday == 6 || data.date.weekday == 7) && data.waterPercent >= 90) {
        weekendWarriorDays++;
      }
    }
    
    avgPercent = sortedData.isNotEmpty ? avgPercent / sortedData.length : 0;
    
    return [
      {
        'icon': '💎',
        'title': 'Идеальная неделя',
        'description': '7 дней подряд с 100% целью',
        'unlocked': streakDays >= 7 && perfectDays >= 7,
        'progress': streakDays >= 7 ? 1.0 : streakDays / 7.0,
      },
      {
        'icon': '🔥',
        'title': 'Огонь!',
        'description': '14 дней подряд без пропусков',
        'unlocked': streakDays >= 14,
        'progress': math.min(streakDays / 14.0, 1.0),
      },
      {
        'icon': '⭐',
        'title': 'Звезда гидратации',
        'description': '20+ дней с целью ≥80%',
        'unlocked': goodDays >= 20,
        'progress': math.min(goodDays / 20.0, 1.0),
      },
      {
        'icon': '💧',
        'title': 'Водяной',
        'description': 'Выпить 100+ литров за месяц',
        'unlocked': totalWater >= 100000,
        'progress': math.min(totalWater / 100000.0, 1.0),
      },
      {
        'icon': '⚡',
        'title': 'Электролитный баланс',
        'description': '15+ дней с нормой электролитов',
        'unlocked': daysWithElectrolytes >= 15,
        'progress': math.min(daysWithElectrolytes / 15.0, 1.0),
      },
      {
        'icon': '🎯',
        'title': 'Снайпер',
        'description': '10 дней с точным попаданием в цель (95-105%)',
        'unlocked': perfectDays >= 10,
        'progress': math.min(perfectDays / 10.0, 1.0),
      },
      {
        'icon': '📈',
        'title': 'Стабильность',
        'description': 'Средний результат месяца >85%',
        'unlocked': avgPercent >= 85,
        'progress': math.min(avgPercent / 85.0, 1.0),
      },
      {
        'icon': '🌅',
        'title': 'Ранняя пташка',
        'description': '15 дней начинать до 8:00',
        'unlocked': earlyBirdDays >= 15,
        'progress': math.min(earlyBirdDays / 15.0, 1.0),
      },
      {
        'icon': '🎮',
        'title': 'Выходной воин',
        'description': 'Все выходные месяца с целью ≥90%',
        'unlocked': weekendWarriorDays >= 8,
        'progress': math.min(weekendWarriorDays / 8.0, 1.0),
      },
      {
        'icon': '👑',
        'title': 'Король гидратации',
        'description': 'Разблокировать 9 других достижений',
        'unlocked': _calculateAchievements() >= 9,
        'progress': _calculateAchievements() / 9.0,
      },
    ];
  }
  
  // Подсчет разблокированных достижений
  int _calculateAchievements() {
    if (monthlyData.isEmpty) return 0;
    
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Анализируем данные для достижений
    int perfectDays = 0;
    int goodDays = 0;
    int streakDays = 0;
    int currentStreak = 0;
    int earlyBirdDays = 0;
    int totalWater = 0;
    int daysWithElectrolytes = 0;
    int weekendWarriorDays = 0;
    double avgPercent = 0;
    
    final sortedData = monthlyData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    for (var data in sortedData) {
      if (data.waterPercent >= 100) perfectDays++;
      if (data.waterPercent >= 80) goodDays++;
      if (data.water > 0) {
        currentStreak++;
        if (currentStreak > streakDays) streakDays = currentStreak;
      } else {
        currentStreak = 0;
      }
      
      totalWater += data.water;
      avgPercent += data.waterPercent;
      
      if (data.sodium >= provider.goals.sodium * 0.7) {
        daysWithElectrolytes++;
      }
      
      if ((data.date.weekday == 6 || data.date.weekday == 7) && data.waterPercent >= 90) {
        weekendWarriorDays++;
      }
    }
    
    avgPercent = sortedData.isNotEmpty ? avgPercent / sortedData.length : 0;
    
    // Подсчитываем достижения без рекурсии
    int unlockedCount = 0;
    if (streakDays >= 7 && perfectDays >= 7) unlockedCount++;
    if (streakDays >= 14) unlockedCount++;
    if (goodDays >= 20) unlockedCount++;
    if (totalWater >= 100000) unlockedCount++;
    if (daysWithElectrolytes >= 15) unlockedCount++;
    if (perfectDays >= 10) unlockedCount++;
    if (avgPercent >= 85) unlockedCount++;
    if (earlyBirdDays >= 15) unlockedCount++;
    if (weekendWarriorDays >= 8) unlockedCount++;
    
    return unlockedCount;
  }
  
  // Месячная статистика
  Widget _buildMonthlyStats() {
    if (monthlyData.isEmpty) {
      return const Text('Загрузка данных...');
    }
    
    final provider = Provider.of<HydrationProvider>(context);
    
    // Вычисляем статистику
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    int activeDays = 0;
    int perfectDays = 0;
    
    monthlyData.values.forEach((data) {
      if (data.water > 0) activeDays++;
      if (data.waterPercent >= 100) perfectDays++;
      totalWater += data.water;
      totalSodium += data.sodium;
      totalPotassium += data.potassium;
      totalMagnesium += data.magnesium;
    });
    
    final avgWater = activeDays > 0 ? totalWater ~/ activeDays : 0;
    final avgSodium = activeDays > 0 ? totalSodium ~/ activeDays : 0;
    final avgPotassium = activeDays > 0 ? totalPotassium ~/ activeDays : 0;
    final avgMagnesium = activeDays > 0 ? totalMagnesium ~/ activeDays : 0;
    
    // Сравнение с целями
    final waterTrend = avgWater > provider.goals.waterOpt * 0.9;
    final sodiumTrend = avgSodium > provider.goals.sodium * 0.8;
    
    return Column(
      children: [
        _buildMonthStatRow(
          icon: '💧',
          label: 'Общий объем воды',
          value: '${(totalWater / 1000).toStringAsFixed(1)} л',
          subValue: 'В среднем $avgWater мл/день',
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildMonthStatRow(
          icon: '📅',
          label: 'Активные дни',
          value: '$activeDays из 30',
          subValue: 'Дней с идеальной целью: $perfectDays',
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildMonthStatRow(
          icon: '⚡',
          label: 'Электролиты (среднее)',
          value: 'Na: $avgSodium мг',
          subValue: 'K: $avgPotassium мг, Mg: $avgMagnesium мг',
          color: Colors.orange,
        ),
        const Divider(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildTrendCard(
                'Вода',
                waterTrend ? '+' : '-',
                waterTrend,
                waterTrend ? 'Отличный результат!' : 'Нужно больше воды',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTrendCard(
                'Соль',
                sodiumTrend ? '✓' : '↓',
                sodiumTrend,
                sodiumTrend ? 'В норме' : 'Маловато',
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Все недостающие методы
  Widget _buildMonthStatRow({
    required String icon,
    required String label,
    required String value,
    required String subValue,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(width: 16),
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
                  fontSize: 18,
                ),
              ),
              Text(
                subValue,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTrendCard(String title, String indicator, bool isPositive, 
      String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPositive ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: isPositive ? Colors.green.shade600 : Colors.orange.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
  
  Color _getHeatmapColor(double progress) {
    if (progress == 0) return Colors.grey.shade200;
    if (progress < 50) return Colors.red.shade200;
    if (progress < 80) return Colors.orange.shade300;
    if (progress < 100) return Colors.blue.shade400;
    return Colors.green.shade500;
  }
}