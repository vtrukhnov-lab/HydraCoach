import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class DailyHistoryScreen extends StatefulWidget {
  const DailyHistoryScreen({super.key});

  @override
  State<DailyHistoryScreen> createState() => _DailyHistoryScreenState();
}

class _DailyHistoryScreenState extends State<DailyHistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'all';
  
  // Данные для выбранного дня (не сегодня)
  List<Intake> selectedDayIntakes = [];
  bool isLoadingDayData = false;
  String _loadedDateKey = '';  // Отслеживаем загруженную дату
  
  @override
  void initState() {
    super.initState();
    // Загружаем данные для текущей даты при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDayDataSafe();
    });
  }
  
  // Безопасная загрузка данных (не вызывается в build)
  Future<void> _loadDayDataSafe() async {
    if (!mounted) return;
    
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    await _loadDayData(provider);
  }
  
  // Загрузка данных за конкретный день
  Future<void> _loadDayData(HydrationProvider provider) async {
    final dateKey = _selectedDate.toIso8601String().split('T')[0];
    
    // Если данные уже загружены для этой даты, не перезагружаем
    if (_loadedDateKey == dateKey) {
      return;
    }
    
    // Если выбран сегодня, используем данные из провайдера
    if (_isToday()) {
      setState(() {
        selectedDayIntakes = provider.todayIntakes;
        _loadedDateKey = dateKey;
      });
      return;
    }
    
    // Иначе загружаем из SharedPreferences
    if (isLoadingDayData) return;
    
    setState(() {
      isLoadingDayData = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final intakesKey = 'intakes_$dateKey';
      
      final intakesJson = prefs.getStringList(intakesKey) ?? [];
      
      final List<Intake> tempIntakes = [];
      
      for (String json in intakesJson) {
        try {
          final parts = json.split('|');
          if (parts.length >= 7) {
            tempIntakes.add(Intake(
              id: parts[0],
              timestamp: DateTime.parse(parts[1]),
              type: parts[2],
              volume: int.tryParse(parts[3]) ?? 0,
              sodium: int.tryParse(parts[4]) ?? 0,
              potassium: int.tryParse(parts[5]) ?? 0,
              magnesium: int.tryParse(parts[6]) ?? 0,
            ));
          }
        } catch (e) {
          print('Ошибка парсинга записи: $json, ошибка: $e');
          continue; // Пропускаем поврежденную запись
        }
      }
      
      if (mounted) {
        setState(() {
          selectedDayIntakes = tempIntakes;
          isLoadingDayData = false;
          _loadedDateKey = dateKey;
        });
      }
    } catch (e) {
      print('Ошибка загрузки данных дня: $e');
      if (mounted) {
        setState(() {
          selectedDayIntakes = [];
          isLoadingDayData = false;
          _loadedDateKey = dateKey;
        });
      }
    }
  }
  
  // Изменение выбранной даты
  void _changeDate(DateTime newDate) {
    if (newDate == _selectedDate) return;
    
    setState(() {
      _selectedDate = newDate;
      _loadedDateKey = ''; // Сбрасываем кэш
    });
    
    // Загружаем данные для новой даты
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDayDataSafe();
    });
  }
  
  @override
  Widget build(BuildContext context) {
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
                        final newDate = _selectedDate.subtract(const Duration(days: 1));
                        // Ограничиваем максимум годом назад
                        if (newDate.isAfter(DateTime.now().subtract(const Duration(days: 365)))) {
                          _changeDate(newDate);
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                          locale: const Locale('ru'),
                        );
                        if (picked != null) {
                          _changeDate(picked);
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
                        _changeDate(_selectedDate.add(const Duration(days: 1)));
                      } : null,
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              
              // Индикатор загрузки
              if (isLoadingDayData)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              // Статистика дня
              if (!isLoadingDayData)
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
                          _buildDayStat('💧', 'Вода', '${_calculateDayStats()['water']} мл', Colors.white),
                          _buildDayStat('🧂', 'Натрий', '${_calculateDayStats()['sodium']} мг', Colors.yellow.shade300),
                          _buildDayStat('🥑', 'Калий', '${_calculateDayStats()['potassium']} мг', Colors.purple.shade300),
                          _buildDayStat('💊', 'Магний', '${_calculateDayStats()['magnesium']} мг', Colors.pink.shade300),
                        ],
                      ),
                    ],
                  ),
                ).animate().slideX(delay: 100.ms),
              
              const SizedBox(height: 20),
              
              // Фильтр типов
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
              
              const SizedBox(height: 20),
              
              // Список приемов
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildIntakesList(provider),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
  
  // Построение списка приемов с защитой от ошибок
  Widget _buildIntakesList(HydrationProvider provider) {
    if (isLoadingDayData) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final filteredIntakes = _getFilteredIntakesForDay();
    
    if (filteredIntakes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.water_drop_outlined, 
                   size: 48, 
                   color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                _isToday() ? 'Пока нет записей на сегодня' : 'Нет записей за этот день',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: filteredIntakes
          .map((intake) => _buildIntakeDetailItem(intake, provider))
          .toList(),
    );
  }
  
  // Вычисляем статистику для выбранного дня
  Map<String, int> _calculateDayStats() {
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    
    final intakes = _getIntakesForSelectedDay();
    
    for (var intake in intakes) {
      if (intake.type == 'water' || intake.type == 'electrolyte' || intake.type == 'broth') {
        totalWater += intake.volume;
      }
      totalSodium += intake.sodium;
      totalPotassium += intake.potassium;
      totalMagnesium += intake.magnesium;
    }
    
    return {
      'water': totalWater,
      'sodium': totalSodium,
      'potassium': totalPotassium,
      'magnesium': totalMagnesium,
    };
  }
  
  // Проверяем, выбран ли сегодняшний день
  bool _isToday() {
    final now = DateTime.now();
    return _selectedDate.day == now.day && 
           _selectedDate.month == now.month &&
           _selectedDate.year == now.year;
  }
  
  // Получаем приемы для выбранного дня
  List<Intake> _getIntakesForSelectedDay() {
    if (_isToday()) {
      return Provider.of<HydrationProvider>(context, listen: false).todayIntakes;
    }
    return selectedDayIntakes;
  }
  
  // Получаем отфильтрованные приемы для выбранного дня
  List<Intake> _getFilteredIntakesForDay() {
    final intakes = _getIntakesForSelectedDay();
    
    if (_selectedFilter == 'all') {
      return intakes.reversed.toList();
    }
    return intakes
        .where((intake) => intake.type == _selectedFilter)
        .toList()
        .reversed
        .toList();
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
  
  Widget _buildIntakeDetailItem(Intake intake, HydrationProvider provider) {
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
          
          // Показываем кнопку удаления только для текущего дня
          if (_isToday())
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.red.shade400,
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Удалить запись?'),
                      content: Text('Удалить ${_getIntakeName(intake.type)} ${intake.volume} мл?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Удалить'),
                        ),
                      ],
                    );
                  },
                );
                
                if (shouldDelete == true) {
                  final deletedIntake = intake;
                  provider.removeIntake(intake.id);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${_getIntakeName(intake.type)} удален'),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Отменить',
                          textColor: Colors.white,
                          onPressed: () {
                            provider.addIntake(
                              deletedIntake.type,
                              deletedIntake.volume,
                              sodium: deletedIntake.sodium,
                              potassium: deletedIntake.potassium,
                              magnesium: deletedIntake.magnesium,
                            );
                          },
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return 'Сегодня';
    } else if (date.day == yesterday.day && date.month == yesterday.month && date.year == yesterday.year) {
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