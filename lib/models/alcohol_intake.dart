import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Типы алкогольных напитков
enum AlcoholType {
  beer('beer', Icons.sports_bar, 5.0),
  wine('wine', Icons.wine_bar, 12.0),
  spirits('spirits', Icons.local_bar, 40.0),
  cocktail('cocktail', Icons.local_drink, 15.0);

  final String key; // Ключ для локализации
  final IconData icon;
  final double defaultAbv;

  const AlcoholType(this.key, this.icon, this.defaultAbv);

  // Метод для получения локализованного названия
  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case AlcoholType.beer:
        return l10n.beer;
      case AlcoholType.wine:
        return l10n.wine;
      case AlcoholType.spirits:
        return l10n.spirits;
      case AlcoholType.cocktail:
        return l10n.cocktail;
    }
  }
}

/// Модель записи употребления алкоголя
class AlcoholIntake {
  final String id;
  final DateTime timestamp;
  final AlcoholType type;
  final double volumeMl;
  final double abv; // Alcohol by Volume (%)
  final double standardDrinks;
  final double? sugar; // Добавлено: содержание сахара в граммах
  final String? name; // Конкретное название напитка
  final String? emoji; // Эмодзи напитка

  AlcoholIntake({
    String? id,
    required this.timestamp,
    required this.type,
    required this.volumeMl,
    required this.abv,
    this.sugar, // Добавлено: опциональный параметр сахара
    this.name,
    this.emoji,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       standardDrinks = _calculateStandardDrinks(volumeMl, abv);

  static double _calculateStandardDrinks(double volumeMl, double abv) {
    const double standardDrinkGrams = 10.0;
    const double alcoholDensity = 0.789;

    double pureAlcoholMl = volumeMl * (abv / 100);
    double pureAlcoholGrams = pureAlcoholMl * alcoholDensity;
    return pureAlcoholGrams / standardDrinkGrams;
  }

  // Метод для получения содержания сахара (с дефолтными значениями если не указано)
  double getSugarContent() {
    if (sugar != null) return sugar!;

    // Дефолтные значения сахара по типам напитков (г на 100 мл)
    switch (type) {
      case AlcoholType.beer:
        return (volumeMl / 100) * 3.0; // ~3г на 100мл
      case AlcoholType.wine:
        return (volumeMl / 100) * 2.0; // ~2г на 100мл
      case AlcoholType.spirits:
        return 0; // Крепкий алкоголь обычно без сахара
      case AlcoholType.cocktail:
        return (volumeMl / 100) *
            12.0; // ~12г на 100мл (много сахара в коктейлях)
    }
  }

  double getWaterCorrection() {
    const double waterBonusPerSD = 150.0;
    return standardDrinks * waterBonusPerSD;
  }

  double getSodiumCorrection() {
    const double sodiumPerSD = 200.0;
    return standardDrinks * sodiumPerSD;
  }

  double getHRIModifier() {
    const double hriPerSD = 3.0;
    const double hriCap = 15.0;
    return (standardDrinks * hriPerSD).clamp(0, hriCap);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type.index,
    'volumeMl': volumeMl,
    'abv': abv,
    'standardDrinks': standardDrinks,
    'sugar': sugar, // Добавлено: сохранение сахара
    if (name != null) 'name': name,
    if (emoji != null) 'emoji': emoji,
  };

  factory AlcoholIntake.fromJson(Map<String, dynamic> json) {
    return AlcoholIntake(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: AlcoholType.values[json['type']],
      volumeMl: json['volumeMl'].toDouble(),
      abv: json['abv'].toDouble(),
      sugar: json['sugar']?.toDouble(), // Добавлено: чтение сахара
      name: json['name'] as String?,
      emoji: json['emoji'] as String?,
    );
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedSD {
    if (standardDrinks < 1) {
      return '${standardDrinks.toStringAsFixed(1)} SD';
    }
    return '${standardDrinks.toStringAsFixed(1)} SD';
  }
}

/// Утренний чек-ин
class AlcoholCheckin {
  final DateTime date;
  final int feelingScore; // 1-5
  final bool hadWater;
  final bool hadElectrolytes;

  AlcoholCheckin({
    required this.date,
    required this.feelingScore,
    this.hadWater = false,
    this.hadElectrolytes = false,
  });

  List<String> getRecommendations(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    List<String> recommendations = [];

    if (feelingScore <= 2) {
      recommendations.add('💧 ${l10n.drinkMoreWaterToday}');
      recommendations.add('🧂 ${l10n.addElectrolytesToWater}');
      recommendations.add('☕ ${l10n.limitCoffeeOneCup}');
    } else if (feelingScore <= 3) {
      recommendations.add('💧 ${l10n.increaseWater10}');
      recommendations.add('🧂 ${l10n.dontForgetElectrolytes}');
    }

    if (!hadWater) {
      recommendations.add('💧 ${l10n.startDayWithWater}');
    }

    if (!hadElectrolytes) {
      recommendations.add('🧂 ${l10n.takeElectrolytesMorning}');
    }

    return recommendations;
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'feelingScore': feelingScore,
    'hadWater': hadWater,
    'hadElectrolytes': hadElectrolytes,
  };

  factory AlcoholCheckin.fromJson(Map<String, dynamic> json) {
    return AlcoholCheckin(
      date: DateTime.parse(json['date']),
      feelingScore: json['feelingScore'],
      hadWater: json['hadWater'] ?? false,
      hadElectrolytes: json['hadElectrolytes'] ?? false,
    );
  }
}
