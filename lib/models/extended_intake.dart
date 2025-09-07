import 'package:flutter/material.dart';
import '../constants/drink_database.dart';
import '../constants/supplements_database.dart';
import '../l10n/app_localizations.dart';

/// Расширенная модель приема жидкости с поддержкой 50+ типов напитков и добавок
class ExtendedIntake {
  final String id;
  final DateTime timestamp;
  final String drinkId; // ID из DrinkDatabase
  final double volumeMl;
  final List<String> supplementIds; // IDs из SupplementDatabase
  final double? customServingMultiplier; // Для добавок (если не стандартная порция)
  final bool hasIce;
  final String? notes;
  
  // Вычисляемые значения
  late final double totalSodiumMg;
  late final double totalPotassiumMg;
  late final double totalMagnesiumMg;
  late final double effectiveHydrationMl;
  late final double? totalCaffeineMg;
  late final double? alcoholGrams;
  
  ExtendedIntake({
    String? id,
    required this.timestamp,
    required this.drinkId,
    required this.volumeMl,
    this.supplementIds = const [],
    this.customServingMultiplier,
    this.hasIce = false,
    this.notes,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString() {
    _calculateNutrients();
  }
  
  /// Вычисляет все питательные вещества на основе напитка и добавок
  void _calculateNutrients() {
    final drink = DrinkDatabase.findById(drinkId);
    if (drink == null) {
      // Fallback для неизвестного напитка
      totalSodiumMg = 0;
      totalPotassiumMg = 0;
      totalMagnesiumMg = 0;
      effectiveHydrationMl = volumeMl;
      totalCaffeineMg = null;
      alcoholGrams = null;
      return;
    }
    
    // Базовые значения от напитка (пересчет на фактический объем)
    final volumeRatio = volumeMl / 100;
    totalSodiumMg = drink.sodiumPer100ml * volumeRatio;
    totalPotassiumMg = drink.potassiumPer100ml * volumeRatio;
    totalMagnesiumMg = drink.magnesiumPer100ml * volumeRatio;
    
    // Эффективная гидратация с учетом коэффициента
    effectiveHydrationMl = volumeMl * drink.hydrationCoefficient;
    
    // Кофеин
    totalCaffeineMg = drink.caffeineMgPer100ml != null 
        ? drink.caffeineMgPer100ml! * volumeRatio 
        : null;
    
    // Алкоголь
    if (drink.alcoholPercentage != null) {
      const double alcoholDensity = 0.789; // г/мл
      double pureAlcoholMl = volumeMl * (drink.alcoholPercentage! / 100);
      alcoholGrams = pureAlcoholMl * alcoholDensity;
    } else {
      alcoholGrams = null;
    }
    
    // Добавляем нутриенты от добавок
    for (String supplementId in supplementIds) {
      final supplement = SupplementDatabase.findById(supplementId);
      if (supplement != null) {
        final servingMultiplier = customServingMultiplier ?? 1.0;
        
        if (supplement.sodiumMg != null) {
          totalSodiumMg += supplement.sodiumMg! * servingMultiplier;
        }
        if (supplement.potassiumMg != null) {
          totalPotassiumMg += supplement.potassiumMg! * servingMultiplier;
        }
        if (supplement.magnesiumMg != null) {
          totalMagnesiumMg += supplement.magnesiumMg! * servingMultiplier;
        }
      }
    }
    
    // Корректировка на лед (уменьшает объем напитка на ~15%)
    if (hasIce) {
      effectiveHydrationMl *= 0.85;
    }
  }
  
  /// Получить стандартные дринки (для алкоголя)
  double get standardDrinks {
    if (alcoholGrams == null) return 0;
    const double standardDrinkGrams = 10.0; // Из ТЗ
    return alcoholGrams! / standardDrinkGrams;
  }
  
  /// Получить корректировку воды для алкоголя
  double getAlcoholWaterCorrection() {
    if (alcoholGrams == null) return 0;
    const double waterBonusPerSD = 150.0; // Из Remote Config
    return standardDrinks * waterBonusPerSD;
  }
  
  /// Получить корректировку натрия для алкоголя
  double getAlcoholSodiumCorrection() {
    if (alcoholGrams == null) return 0;
    const double sodiumPerSD = 200.0; // Из Remote Config
    return standardDrinks * sodiumPerSD;
  }
  
  /// Получить модификатор HRI
  double getHRIModifier() {
    double modifier = 0;
    
    // Алкоголь
    if (alcoholGrams != null) {
      const double hriPerSD = 3.0;
      const double hriCap = 15.0;
      modifier += (standardDrinks * hriPerSD).clamp(0, hriCap);
    }
    
    // Кофеин
    if (totalCaffeineMg != null && totalCaffeineMg! > 0) {
      // Каждые 100мг кофеина добавляют 2 к HRI
      modifier += (totalCaffeineMg! / 100) * 2;
    }
    
    return modifier;
  }
  
  /// Получить название напитка (локализованное)
  String getDrinkName(BuildContext context) {
    final drink = DrinkDatabase.findById(drinkId);
    if (drink == null) return drinkId;
    
    // TODO: Получить из локализации по ключу drink.nameKey
    // Пока возвращаем ID
    return drinkId.replaceAll('_', ' ').toUpperCase();
  }
  
  /// Получить список названий добавок
  List<String> getSupplementNames(BuildContext context) {
    List<String> names = [];
    for (String supplementId in supplementIds) {
      final supplement = SupplementDatabase.findById(supplementId);
      if (supplement != null) {
        // TODO: Получить из локализации по ключу supplement.nameKey
        names.add(supplementId.replaceAll('_', ' '));
      }
    }
    return names;
  }
  
  /// Получить иконку напитка
  String get drinkEmoji {
    final drink = DrinkDatabase.findById(drinkId);
    return drink?.emoji ?? '🥤';
  }
  
  /// Проверить является ли напиток премиальным
  bool get isPremium {
    final drink = DrinkDatabase.findById(drinkId);
    if (drink?.isPremium == true) return true;
    
    // Проверяем добавки
    for (String supplementId in supplementIds) {
      final supplement = SupplementDatabase.findById(supplementId);
      if (supplement?.isPremium == true) return true;
    }
    
    return false;
  }
  
  /// Конвертация в JSON для сохранения
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'drinkId': drinkId,
    'volumeMl': volumeMl,
    'supplementIds': supplementIds,
    'customServingMultiplier': customServingMultiplier,
    'hasIce': hasIce,
    'notes': notes,
  };
  
  /// Создание из JSON
  factory ExtendedIntake.fromJson(Map<String, dynamic> json) {
    return ExtendedIntake(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      drinkId: json['drinkId'],
      volumeMl: json['volumeMl'].toDouble(),
      supplementIds: List<String>.from(json['supplementIds'] ?? []),
      customServingMultiplier: json['customServingMultiplier']?.toDouble(),
      hasIce: json['hasIce'] ?? false,
      notes: json['notes'],
    );
  }
  
  /// Конвертация в старый формат Intake (для обратной совместимости)
  Map<String, dynamic> toLegacyIntake() {
    // Определяем тип для старой системы
    String legacyType = 'water';
    if (drinkId.contains('coffee')) {
      legacyType = 'coffee';
    } else if (drinkId.contains('electrolyte')) {
      legacyType = 'electrolyte';
    } else if (drinkId.contains('broth')) {
      legacyType = 'broth';
    } else if (alcoholGrams != null && alcoholGrams! > 0) {
      legacyType = 'alcohol';
    }
    
    return {
      'id': id,
      'timestamp': timestamp,
      'type': legacyType,
      'volume': effectiveHydrationMl.round(),
      'sodium': totalSodiumMg.round(),
      'potassium': totalPotassiumMg.round(),
      'magnesium': totalMagnesiumMg.round(),
    };
  }
  
  /// Форматированное время
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  /// Форматированный объем
  String get formattedVolume {
    if (volumeMl >= 1000) {
      return '${(volumeMl / 1000).toStringAsFixed(1)}L';
    }
    return '${volumeMl.round()}ml';
  }
  
  /// Получить сводку по электролитам
  String getElectrolytesSummary() {
    List<String> parts = [];
    
    if (totalSodiumMg > 0) {
      parts.add('Na: ${totalSodiumMg.round()}mg');
    }
    if (totalPotassiumMg > 0) {
      parts.add('K: ${totalPotassiumMg.round()}mg');
    }
    if (totalMagnesiumMg > 0) {
      parts.add('Mg: ${totalMagnesiumMg.round()}mg');
    }
    
    return parts.isEmpty ? '' : parts.join(' • ');
  }
}