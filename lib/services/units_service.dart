// lib/services/units_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Сервис для управления единицами измерения и конвертации между системами
class UnitsService extends ChangeNotifier {
  static UnitsService? _instance;
  static UnitsService get instance => _instance ??= UnitsService._();

  UnitsService._();

  // Текущая система единиц
  String _units = 'metric';

  // Константы для конвертации
  static const double ML_TO_OZ = 29.5735;
  static const double KG_TO_LB = 2.20462;
  static const double CM_TO_INCH = 2.54;

  /// Инициализация при запуске приложения
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _units = prefs.getString('units') ?? 'metric';
  }

  /// Сохранение выбранной системы единиц
  Future<void> setUnits(String units) async {
    if (_units != units) {
      _units = units;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('units', units);
      notifyListeners();
    }
  }

  // Геттеры для проверки текущей системы
  String get units => _units;
  bool get isImperial => _units == 'imperial';
  bool get isMetric => _units == 'metric';

  // ============= ОБЪЁМ (Volume) =============

  /// Конвертация мл в единицы для отображения
  double toDisplayVolume(int ml) {
    if (isImperial) {
      return ml / ML_TO_OZ; // мл в унции
    }
    return ml.toDouble();
  }

  /// Конвертация введённого значения в мл для хранения
  int toMilliliters(num value) {
    if (isImperial) {
      return (value * ML_TO_OZ).round(); // унции в мл
    }
    return value.round();
  }

  /// Форматирование объёма для отображения
  String formatVolume(int ml, {bool shortUnit = false, bool hideUnit = false}) {
    if (isImperial) {
      final oz = ml / ML_TO_OZ;
      final formatted = oz >= 10
          ? oz.round().toString()
          : oz.toStringAsFixed(1);
      if (hideUnit) return formatted;
      final unit = shortUnit ? 'oz' : 'fl oz';
      return '$formatted $unit';
    } else {
      if (hideUnit) return ml.toString();
      return '$ml ml';
    }
  }

  /// Получить единицу измерения объёма
  String get volumeUnit => isImperial ? 'oz' : 'ml';
  String get volumeUnitShort => isImperial ? 'oz' : 'ml';

  // ============= ВЕС (Weight) =============

  /// Конвертация кг в единицы для отображения
  double toDisplayWeight(double kg) {
    if (isImperial) {
      return kg * KG_TO_LB; // кг в фунты
    }
    return kg;
  }

  /// Конвертация введённого значения в кг для хранения
  double toKilograms(num value) {
    if (isImperial) {
      return value / KG_TO_LB; // фунты в кг
    }
    return value.toDouble();
  }

  /// Форматирование веса для отображения
  String formatWeight(double kg, {bool hideUnit = false}) {
    if (isImperial) {
      final lb = kg * KG_TO_LB;
      final formatted = lb.toStringAsFixed(1);
      if (hideUnit) return formatted;
      return '$formatted lb';
    } else {
      final formatted = kg.toStringAsFixed(1);
      if (hideUnit) return formatted;
      return '$formatted kg';
    }
  }

  /// Получить единицу измерения веса
  String get weightUnit => isImperial ? 'lb' : 'kg';

  // ============= ТЕМПЕРАТУРА (Temperature) =============

  /// Конвертация Цельсия в единицы для отображения
  double toDisplayTemperature(double celsius) {
    if (isImperial) {
      return celsius * 9 / 5 + 32; // Цельсий в Фаренгейт
    }
    return celsius;
  }

  /// Конвертация введённого значения в Цельсий для хранения
  double toCelsius(num value) {
    if (isImperial) {
      return (value - 32) * 5 / 9; // Фаренгейт в Цельсий
    }
    return value.toDouble();
  }

  /// Форматирование температуры для отображения
  String formatTemperature(double celsius, {bool hideUnit = false}) {
    if (isImperial) {
      final fahrenheit = celsius * 9 / 5 + 32;
      final formatted = fahrenheit.round().toString();
      if (hideUnit) return formatted;
      return '$formatted°F';
    } else {
      final formatted = celsius.round().toString();
      if (hideUnit) return formatted;
      return '$formatted°C';
    }
  }

  /// Получить единицу измерения температуры
  String get temperatureUnit => isImperial ? '°F' : '°C';

  // ============= РОСТ (Height) =============

  /// Конвертация см в единицы для отображения
  String toDisplayHeight(int cm) {
    if (isImperial) {
      final totalInches = cm / CM_TO_INCH;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return "$feet'$inches\"";
    }
    return '$cm cm';
  }

  /// Конвертация введённого значения в см для хранения
  int toCentimeters({int? feet, int? inches, int? cm}) {
    if (isImperial && feet != null) {
      final totalInches = (feet * 12) + (inches ?? 0);
      return (totalInches * CM_TO_INCH).round();
    }
    return cm ?? 0;
  }

  // ============= БЫСТРЫЕ ЗНАЧЕНИЯ =============

  /// Предустановленные объёмы для быстрых кнопок
  List<int> get quickVolumes {
    if (isImperial) {
      return [4, 8, 12, 16, 20, 24]; // oz
    }
    return [100, 250, 350, 500, 750, 1000]; // ml
  }

  /// Получить объём в мл для быстрой кнопки по индексу
  int getQuickVolumeMl(int index) {
    final volumes = quickVolumes;
    if (index < 0 || index >= volumes.length) {
      return isImperial ? toMilliliters(8) : 250; // дефолтное значение
    }

    if (isImperial) {
      return toMilliliters(volumes[index]);
    }
    return volumes[index];
  }

  /// Получить метку для быстрой кнопки
  String getQuickVolumeLabel(int index) {
    final volumes = quickVolumes;
    if (index < 0 || index >= volumes.length) return '';

    final value = volumes[index];
    if (isImperial) {
      return '$value oz';
    }
    return '$value ml';
  }

  // ============= ЭЛЕКТРОЛИТЫ =============

  /// Форматирование электролитов (всегда в мг)
  String formatElectrolyte(int mg, {bool hideUnit = false}) {
    if (hideUnit) return mg.toString();
    return '$mg mg';
  }

  // ============= АЛКОГОЛЬ =============

  /// Конвертация стандартных дринков в мл чистого спирта
  int standardDrinksToMl(double drinks, {double stdDrinkGrams = 10.0}) {
    // 1 SD = stdDrinkGrams г чистого спирта
    // Плотность спирта ≈ 0.789 г/мл
    return (drinks * stdDrinkGrams / 0.789).round();
  }

  /// Расчёт стандартных дринков из объёма и крепости
  double calculateStandardDrinks(
    int volumeMl,
    double abv, {
    double stdDrinkGrams = 10.0,
  }) {
    // Объём чистого спирта в мл
    final pureAlcoholMl = volumeMl * (abv / 100);
    // Масса чистого спирта в граммах (плотность ≈ 0.789 г/мл)
    final pureAlcoholGrams = pureAlcoholMl * 0.789;
    // Количество стандартных дринков
    return pureAlcoholGrams / stdDrinkGrams;
  }

  // ============= УТИЛИТЫ =============

  /// Парсинг числа из строки с учётом локали
  double? parseNumber(String value) {
    if (value.isEmpty) return null;

    // Заменяем запятую на точку для парсинга
    final normalized = value.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  /// Форматирование числа с учётом локали
  String formatNumber(double value, {int decimals = 1}) {
    if (decimals == 0) {
      return value.round().toString();
    }
    return value.toStringAsFixed(decimals);
  }

  /// Валидация введённого значения
  bool isValidNumber(String value) {
    if (value.isEmpty) return false;
    final normalized = value.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    return parsed != null && parsed > 0;
  }
}
