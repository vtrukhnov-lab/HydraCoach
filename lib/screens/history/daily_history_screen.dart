import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../models/alcohol_intake.dart';
import '../../services/alcohol_service.dart';

class DailyHistoryScreen extends StatefulWidget {
  const DailyHistoryScreen({super.key});

  @override
  State<DailyHistoryScreen> createState() => _DailyHistoryScreenState();
}

class _DailyHistoryScreenState extends State<DailyHistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'all';
  
  // Данные для выбранного дня
  List<Intake> selectedDayIntakes = [];
  List<AlcoholIntake> selectedDayAlcoholIntakes = [];
  bool isLoadingDayData = false;
  String _loadedDateKey = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDayDataSafe();
    });
  }
  
  Future<void> _loadDayDataSafe() async {
    if (!mounted) return;
    
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    await _loadDayData(provider);
  }
  
  Future<void> _loadDayData(HydrationProvider provider) async {
    final dateKey = _selectedDate.toIso8601String().split('T')[0];
    
    if (_loadedDateKey == dateKey) {
      return;
    }
    
    // Если выбран сегодня, используем данные из провайдера
    if (_isToday()) {
      setState(() {
        selectedDayIntakes = provider.todayIntakes;
        _loadedDateKey = dateKey;
      });
      // Загружаем алкоголь для сегодня
      await _loadAlcoholData();
      return;
    }
    
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
          continue;
        }
      }
      
      // Загружаем алкоголь
      await _loadAlcoholData();
      
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
  
  Future<void> _loadAlcoholData() async {
    if (!mounted) return;
    
    final alcoholService = Provider.of<AlcoholService>(context, listen: false);
    final alcoholIntakes = await alcoholService.getIntakesForDate(_selectedDate);
    
    if (mounted) {
      setState(() {
        selectedDayAlcoholIntakes = alcoholIntakes;
      });
    }
  }
  
  void _changeDate(DateTime newDate) {
    // Защита от будущих дат
    if (newDate.isAfter(DateTime.now())) {
      return;
    }
    
    // Защита от слишком старых дат (больше года назад)
    final yearAgo = DateTime.now().subtract(const Duration(days: 365));
    if (newDate.isBefore(yearAgo)) {
      return;
    }
    
    if (newDate.year == _selectedDate.year && 
        newDate.month == _selectedDate.month && 
        newDate.day == _selectedDate.day) {
      return;
    }
    
    setState(() {
      _selectedDate = newDate;
      _loadedDateKey = ''; // Сбрасываем кэш
      selectedDayAlcoholIntakes = []; // Очищаем алкоголь
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDayDataSafe();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<HydrationProvider, AlcoholService>(
      builder: (context, provider, alcoholService, child) {
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
                        final yearAgo = DateTime.now().subtract(const Duration(days: 365));
                        if (newDate.isAfter(yearAgo)) {
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
                      onPressed: _canGoForward() ? () {
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
              
              // Статистика алкоголя (если есть данные и не включен трезвый режим)
              if (!isLoadingDayData && 
                  selectedDayAlcoholIntakes.isNotEmpty && 
                  !alcoholService.soberModeEnabled)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_bar, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Алкоголь: ${_getTotalAlcoholSD().toStringAsFixed(1)} SD',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...selectedDayAlcoholIntakes.map((intake) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(intake.type.icon, size: 20, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${intake.type.label}: ${intake.volumeMl.toInt()} мл, ${intake.abv}%',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                intake.formattedTime,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),
              
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
                    if (!alcoholService.soberModeEnabled && selectedDayAlcoholIntakes.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _buildFilterChip('Алкоголь', 'alcohol'),
                    ],
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
                child: _buildIntakesList(provider, alcoholService),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildIntakesList(HydrationProvider provider, AlcoholService alcoholService) {
    if (isLoadingDayData) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final filteredIntakes = _getFilteredIntakesForDay();
    final filteredAlcohol = _selectedFilter == 'alcohol' ? selectedDayAlcoholIntakes : 
                            _selectedFilter == 'all' ? selectedDayAlcoholIntakes : [];
    
    if (filteredIntakes.isEmpty && filteredAlcohol.isEmpty) {
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
    
    // Объединяем обычные приемы и алкоголь, сортируем по времени
    final List<Widget> allItems = [];
    
    // Добавляем обычные приемы
    for (var intake in filteredIntakes) {
      allItems.add(_IntakeItemWrapper(
        timestamp: intake.timestamp,
        child: _buildIntakeDetailItem(intake, provider),
      ));
    }
    
    // Добавляем алкогольные приемы
    if (!alcoholService.soberModeEnabled) {
      for (var alcohol in filteredAlcohol) {
        allItems.add(_IntakeItemWrapper(
          timestamp: alcohol.timestamp,
          child: _buildAlcoholItem(alcohol, alcoholService),
        ));
      }
    }
    
    // Сортируем по времени (новые сверху)
    allItems.sort((a, b) => (b as _IntakeItemWrapper).timestamp
        .compareTo((a as _IntakeItemWrapper).timestamp));
    
    return Column(
      children: allItems.map((item) => 
        (item as _IntakeItemWrapper).child).toList(),
    );
  }
  
  Widget _buildAlcoholItem(AlcoholIntake intake, AlcoholService alcoholService) {
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(intake.type.icon, color: Colors.orange, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intake.type.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${intake.volumeMl.toInt()} мл, ${intake.abv}%, ${intake.standardDrinks.toStringAsFixed(1)} SD',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            intake.formattedTime,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
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
                      content: Text('Удалить ${intake.type.label} ${intake.volumeMl.toInt()} мл?'),
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
                  await alcoholService.removeIntake(intake.id);
                  await _loadAlcoholData(); // Перезагружаем данные
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Запись удалена'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
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
  
  double _getTotalAlcoholSD() {
    double total = 0;
    for (var intake in selectedDayAlcoholIntakes) {
      total += intake.standardDrinks;
    }
    return total;
  }
  
  bool _canGoForward() {
    final now = DateTime.now();
    return _selectedDate.year < now.year ||
           (_selectedDate.year == now.year && _selectedDate.month < now.month) ||
           (_selectedDate.year == now.year && _selectedDate.month == now.month && _selectedDate.day < now.day);
  }
  
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
  
  bool _isToday() {
    final now = DateTime.now();
    return _selectedDate.day == now.day && 
           _selectedDate.month == now.month &&
           _selectedDate.year == now.year;
  }
  
  List<Intake> _getIntakesForSelectedDay() {
    if (_isToday()) {
      return Provider.of<HydrationProvider>(context, listen: false).todayIntakes;
    }
    return selectedDayIntakes;
  }
  
  List<Intake> _getFilteredIntakesForDay() {
    if (_selectedFilter == 'alcohol') {
      return [];
    }
    
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
    
    try {
      return DateFormat('d MMMM', 'ru').format(date);
    } catch (e) {
      // Fallback если локаль не загружена
      const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 
                      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
      return '${date.day} ${months[date.month - 1]}';
    }
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

// Вспомогательный класс для сортировки
class _IntakeItemWrapper extends StatelessWidget {
  final DateTime timestamp;
  final Widget child;

  const _IntakeItemWrapper({
    required this.timestamp,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child;
}