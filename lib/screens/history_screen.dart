import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'all';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'История',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'День'),
            Tab(text: 'Неделя'),
            Tab(text: 'Месяц'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDayView(),
          _buildWeekView(),
          _buildMonthView(),
        ],
      ),
    );
  }
  
  Widget _buildDayView() {
    return Consumer<HydrationProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Селектор даты
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _selectedDate.isBefore(
                        DateTime.now().subtract(const Duration(days: 1))
                      ) ? () {
                        setState(() {
                          _selectedDate = _selectedDate.add(const Duration(days: 1));
                        });
                      } : null,
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              
              // Статистика дня
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayStat('💧', 'Вода', '2100 мл', Colors.white),
                        _buildDayStat('🧂', 'Натрий', '2500 мг', Colors.yellow.shade300),
                        _buildDayStat('🥑', 'Калий', '3000 мг', Colors.purple.shade300),
                        _buildDayStat('💊', 'Магний', '350 мг', Colors.pink.shade300),
                      ],
                    ),
                  ],
                ),
              ).animate().slideX(delay: 100.ms),
              
              // Фильтр типов
              Container(
                margin: const EdgeInsets.all(20),
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip('Все', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Вода', 'water'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Электролиты', 'electrolyte'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Бульон', 'broth'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Кофе', 'coffee'),
                  ],
                ),
              ),
              
              // Список приемов
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: _getFilteredIntakes(provider)
                      .map((intake) => _buildIntakeDetailItem(intake))
                      .toList(),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildWeekView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // График за неделю
          Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildWeekChart(),
          ).animate().fadeIn(),
          
          const SizedBox(height: 20),
          
          // Статистика недели
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Недельная статистика',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildWeekStatRow('Средняя гидратация', '87%', Colors.blue),
                _buildWeekStatRow('Дней с нормой', '5 из 7', Colors.green),
                _buildWeekStatRow('Общий объем воды', '14.7 л', Colors.cyan),
                _buildWeekStatRow('Лучший день', 'Среда (98%)', Colors.orange),
              ],
            ),
          ).animate().slideY(delay: 200.ms),
          
          const SizedBox(height: 20),
          
          // Достижения недели
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
                  '🏆 Достижения недели',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAchievement('Стабильность', '5 дней подряд с нормой'),
                _buildAchievement('Ранняя пташка', 'Начинали до 8:00 каждый день'),
                _buildAchievement('Электролитный баланс', 'Идеальный Na/K баланс'),
              ],
            ),
          ).animate().scale(delay: 300.ms),
        ],
      ),
    );
  }
  
  Widget _buildMonthView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Календарь с тепловой картой
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildHeatmapCalendar(),
          ).animate().fadeIn(),
          
          const SizedBox(height: 20),
          
          // Месячные тренды
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Тренды месяца',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTrendItem(
                  'Вода',
                  '+12%',
                  true,
                  'В среднем 2.3л в день',
                  Colors.blue,
                ),
                _buildTrendItem(
                  'Натрий',
                  '+5%',
                  true,
                  'Хороший баланс',
                  Colors.orange,
                ),
                _buildTrendItem(
                  'Калий',
                  '-3%',
                  false,
                  'Добавьте больше овощей',
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDayStat(String icon, String label, String value, Color color) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildIntakeDetailItem(Intake intake) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIntakeColor(intake.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getIntakeIcon(intake.type),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getIntakeName(intake.type),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${intake.volume} мл',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(intake.timestamp),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (intake.sodium > 0 || intake.potassium > 0)
                Text(
                  'Na: ${intake.sodium} K: ${intake.potassium}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade400,
            onPressed: () {
              // TODO: Удалить запись
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekChart() {
    final spots = [
      const FlSpot(0, 85),
      const FlSpot(1, 92),
      const FlSpot(2, 78),
      const FlSpot(3, 98),
      const FlSpot(4, 88),
      const FlSpot(5, 95),
      const FlSpot(6, 87),
    ];
    
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
                const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                return Text(
                  days[value.toInt()],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                );
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
        maxX: 6,
        minY: 0,
        maxY: 100,
        lineBarsData: [
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
      ),
    );
  }
  
  Widget _buildWeekStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAchievement(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('✅', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeatmapCalendar() {
    // Упрощенная тепловая карта календаря
    return Column(
      children: [
        const Text(
          'Ноябрь 2024',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final day = index + 1;
            final progress = 50 + (index * 7 % 50); // Симуляция данных
            
            return Container(
              decoration: BoxDecoration(
                color: _getHeatmapColor(progress.toDouble()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: progress > 70 ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('0-50%', Colors.red.shade100),
            _buildLegendItem('50-70%', Colors.orange.shade200),
            _buildLegendItem('70-90%', Colors.blue.shade300),
            _buildLegendItem('90-100%', Colors.green.shade400),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
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
  
  Widget _buildTrendItem(String title, String change, bool isPositive, 
      String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getHeatmapColor(double progress) {
    if (progress < 50) return Colors.red.shade100;
    if (progress < 70) return Colors.orange.shade200;
    if (progress < 90) return Colors.blue.shade300;
    return Colors.green.shade400;
  }
  
  List<Intake> _getFilteredIntakes(HydrationProvider provider) {
    if (_selectedFilter == 'all') {
      return provider.todayIntakes;
    }
    return provider.todayIntakes
        .where((intake) => intake.type == _selectedFilter)
        .toList();
  }
  
  String _formatDate(DateTime date) {
    if (date.day == DateTime.now().day) {
      return 'Сегодня';
    } else if (date.day == DateTime.now().subtract(const Duration(days: 1)).day) {
      return 'Вчера';
    }
    return DateFormat('d MMMM', 'ru').format(date);
  }
  
  Color _getIntakeColor(String type) {
    switch (type) {
      case 'water': return Colors.blue;
      case 'electrolyte': return Colors.orange;
      case 'broth': return Colors.amber;
      case 'coffee': return Colors.brown;
      default: return Colors.grey;
    }
  }
  
  String _getIntakeIcon(String type) {
    switch (type) {
      case 'water': return '💧';
      case 'electrolyte': return '⚡';
      case 'broth': return '🍲';
      case 'coffee': return '☕';
      default: return '🥤';
    }
  }
  
  String _getIntakeName(String type) {
    switch (type) {
      case 'water': return 'Вода';
      case 'electrolyte': return 'Электролит';
      case 'broth': return 'Бульон';
      case 'coffee': return 'Кофе';
      default: return 'Напиток';
    }
  }
}