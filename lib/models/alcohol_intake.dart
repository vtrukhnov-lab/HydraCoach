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
    final l10n = AppLocalizations.of(context)!;
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

  AlcoholIntake({
    String? id,
    required this.timestamp,
    required this.type,
    required this.volumeMl,
    required this.abv,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        standardDrinks = _calculateStandardDrinks(volumeMl, abv);

  static double _calculateStandardDrinks(double volumeMl, double abv) {
    const double standardDrinkGrams = 10.0;
    const double alcoholDensity = 0.789;
    
    double pureAlcoholMl = volumeMl * (abv / 100);
    double pureAlcoholGrams = pureAlcoholMl * alcoholDensity;
    return pureAlcoholGrams / standardDrinkGrams;
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
      };

  factory AlcoholIntake.fromJson(Map<String, dynamic> json) {
    return AlcoholIntake(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: AlcoholType.values[json['type']],
      volumeMl: json['volumeMl'].toDouble(),
      abv: json['abv'].toDouble(),
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
    final l10n = AppLocalizations.of(context)!;
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