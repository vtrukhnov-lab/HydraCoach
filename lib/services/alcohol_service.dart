import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alcohol_intake.dart';

class AlcoholService extends ChangeNotifier {
  static const String _intakesKey = 'alcohol_intakes';
  static const String _checkinsKey = 'alcohol_checkins';
  static const String _soberModeKey = 'sober_mode_enabled';

  List<AlcoholIntake> _todayIntakes = [];
  AlcoholCheckin? _todayCheckin;
  bool _soberModeEnabled = false;

  // Геттеры
  List<AlcoholIntake> get todayIntakes => _todayIntakes;
  AlcoholCheckin? get todayCheckin => _todayCheckin;
  bool get soberModeEnabled => _soberModeEnabled;
  
  // Получить общее количество SD за день
  double get totalStandardDrinks {
    return _todayIntakes.fold(0.0, (sum, intake) => sum + intake.standardDrinks);
  }
  
  // Получить общую коррекцию воды
  double get totalWaterCorrection {
    return _todayIntakes.fold(0.0, (sum, intake) => sum + intake.getWaterCorrection());
  }
  
  // Получить общую коррекцию натрия
  double get totalSodiumCorrection {
    return _todayIntakes.fold(0.0, (sum, intake) => sum + intake.getSodiumCorrection());
  }
  
  // Получить влияние на HRI
  double get totalHRIModifier {
    const double hriPerSD = 3.0;
    const double hriCap = 15.0;
    return (totalStandardDrinks * hriPerSD).clamp(0, hriCap);
  }
  
  // Проверка, был ли алкоголь вчера
  Future<bool> hadAlcoholYesterday() async {
    final prefs = await SharedPreferences.getInstance();
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson == null) return false;
    
    final List<dynamic> intakesList = json.decode(intakesJson);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    return intakesList.any((json) {
      final intake = AlcoholIntake.fromJson(json);
      return _isSameDay(intake.timestamp, yesterday);
    });
  }
  
  /// Инициализация сервиса
  Future<void> init() async {
    await loadData();
    
    // Проверяем, нужен ли утренний чек-ин
    if (await hadAlcoholYesterday() && _todayCheckin == null) {
      // Будем показывать диалог чек-ина
    }
  }

  /// Загрузка данных из хранилища
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загружаем сегодняшние приемы алкоголя
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson != null) {
      final List<dynamic> intakesList = json.decode(intakesJson);
      final today = DateTime.now();
      _todayIntakes = intakesList
          .map((json) => AlcoholIntake.fromJson(json))
          .where((intake) => _isSameDay(intake.timestamp, today))
          .toList();
    }
    
    // Загружаем сегодняшний чек-ин
    final checkinsJson = prefs.getString(_checkinsKey);
    if (checkinsJson != null) {
      final List<dynamic> checkinsList = json.decode(checkinsJson);
      final today = DateTime.now();
      final todayCheckins = checkinsList
          .map((json) => AlcoholCheckin.fromJson(json))
          .where((checkin) => _isSameDay(checkin.date, today))
          .toList();
      
      if (todayCheckins.isNotEmpty) {
        _todayCheckin = todayCheckins.first;
      }
    }
    
    // Загружаем настройку трезвого режима
    _soberModeEnabled = prefs.getBool(_soberModeKey) ?? false;
    
    notifyListeners();
  }

  /// Добавить запись алкоголя
  Future<void> addIntake(AlcoholIntake intake) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загружаем все записи
    final intakesJson = prefs.getString(_intakesKey);
    List<Map<String, dynamic>> allIntakes = [];
    
    if (intakesJson != null) {
      final List<dynamic> intakesList = json.decode(intakesJson);
      allIntakes = intakesList.cast<Map<String, dynamic>>();
    }
    
    // Добавляем новую запись
    allIntakes.add(intake.toJson());
    
    // Сохраняем
    await prefs.setString(_intakesKey, json.encode(allIntakes));
    
    // Обновляем сегодняшние записи
    if (_isSameDay(intake.timestamp, DateTime.now())) {
      _todayIntakes.add(intake);
      notifyListeners();
    }
  }

  /// Удалить запись алкоголя
  Future<void> removeIntake(String intakeId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загружаем все записи
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson == null) return;
    
    final List<dynamic> intakesList = json.decode(intakesJson);
    List<Map<String, dynamic>> allIntakes = intakesList.cast<Map<String, dynamic>>();
    
    // Удаляем запись
    allIntakes.removeWhere((json) => json['id'] == intakeId);
    
    // Сохраняем
    await prefs.setString(_intakesKey, json.encode(allIntakes));
    
    // Обновляем сегодняшние записи
    _todayIntakes.removeWhere((intake) => intake.id == intakeId);
    notifyListeners();
  }

  /// Сохранить утренний чек-ин
  Future<void> saveCheckin(AlcoholCheckin checkin) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загружаем все чек-ины
    final checkinsJson = prefs.getString(_checkinsKey);
    List<Map<String, dynamic>> allCheckins = [];
    
    if (checkinsJson != null) {
      final List<dynamic> checkinsList = json.decode(checkinsJson);
      allCheckins = checkinsList.cast<Map<String, dynamic>>();
    }
    
    // Добавляем новый чек-ин
    allCheckins.add(checkin.toJson());
    
    // Сохраняем
    await prefs.setString(_checkinsKey, json.encode(allCheckins));
    
    // Обновляем сегодняшний чек-ин
    if (_isSameDay(checkin.date, DateTime.now())) {
      _todayCheckin = checkin;
      notifyListeners();
    }
  }

  /// Переключить трезвый режим
  Future<void> toggleSoberMode() async {
    final prefs = await SharedPreferences.getInstance();
    _soberModeEnabled = !_soberModeEnabled;
    await prefs.setBool(_soberModeKey, _soberModeEnabled);
    notifyListeners();
  }

  /// Получить записи за определенный день
  Future<List<AlcoholIntake>> getIntakesForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson == null) return [];
    
    final List<dynamic> intakesList = json.decode(intakesJson);
    return intakesList
        .map((json) => AlcoholIntake.fromJson(json))
        .where((intake) => _isSameDay(intake.timestamp, date))
        .toList();
  }

  /// Получить статистику за неделю
  Future<Map<String, dynamic>> getWeeklyStats() async {
    final prefs = await SharedPreferences.getInstance();
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson == null) {
      return {
        'totalSD': 0.0,
        'daysWithAlcohol': 0,
        'soberDays': 7,
      };
    }
    
    final List<dynamic> intakesList = json.decode(intakesJson);
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    
    final weekIntakes = intakesList
        .map((json) => AlcoholIntake.fromJson(json))
        .where((intake) => intake.timestamp.isAfter(weekAgo))
        .toList();
    
    // Считаем уникальные дни с алкоголем
    final daysWithAlcohol = <String>{};
    double totalSD = 0.0;
    
    for (var intake in weekIntakes) {
      final dayKey = '${intake.timestamp.year}-${intake.timestamp.month}-${intake.timestamp.day}';
      daysWithAlcohol.add(dayKey);
      totalSD += intake.standardDrinks;
    }
    
    return {
      'totalSD': totalSD,
      'daysWithAlcohol': daysWithAlcohol.length,
      'soberDays': 7 - daysWithAlcohol.length,
    };
  }

  /// Проверка, что две даты - один день
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Очистка старых данных (старше 30 дней)
  Future<void> cleanOldData() async {
    final prefs = await SharedPreferences.getInstance();
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    
    // Очищаем старые записи алкоголя
    final intakesJson = prefs.getString(_intakesKey);
    if (intakesJson != null) {
      final List<dynamic> intakesList = json.decode(intakesJson);
      final recentIntakes = intakesList
          .map((json) => AlcoholIntake.fromJson(json))
          .where((intake) => intake.timestamp.isAfter(monthAgo))
          .map((intake) => intake.toJson())
          .toList();
      
      await prefs.setString(_intakesKey, json.encode(recentIntakes));
    }
    
    // Очищаем старые чек-ины
    final checkinsJson = prefs.getString(_checkinsKey);
    if (checkinsJson != null) {
      final List<dynamic> checkinsList = json.decode(checkinsJson);
      final recentCheckins = checkinsList
          .map((json) => AlcoholCheckin.fromJson(json))
          .where((checkin) => checkin.date.isAfter(monthAgo))
          .map((checkin) => checkin.toJson())
          .toList();
      
      await prefs.setString(_checkinsKey, json.encode(recentCheckins));
    }
  }
}