// lib/data/items/vegetable_items.dart
import '../catalog_item.dart';

class VegetableItems {
  /// Получить все овощи
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _cucumber(),
      _tomato(),
      _carrot(),

      // 💎 PRO - 6 items
      _cabbage(),
      _broccoli(),
      _lettuce(),
      _bellPepper(),
      _onion(),
      _potato(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _cucumber() {
    return CatalogItem(
      id: 'vegetable_cucumber',
      getName: (l10n) => l10n.foodCucumber,
      icon: '🥒',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 119, 'imperial': 4.2}, // g/oz (1 cup sliced)
        'waterPercentage': 0.95, // 95% water - самое высокое!
        'caloriesPer100g': 16,
        'sugarPer100g': 1.7,
        'sodium': 2,
        'potassium': 147,
        'magnesium': 13,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _tomato() {
    return CatalogItem(
      id: 'vegetable_tomato',
      getName: (l10n) => l10n.foodTomato,
      icon: '🍅',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 149, 'imperial': 5.3}, // g/oz (1 cup chopped)
        'waterPercentage': 0.94, // 94% water
        'caloriesPer100g': 18,
        'sugarPer100g': 2.6,
        'sodium': 5,
        'potassium': 237,
        'magnesium': 11,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _carrot() {
    return CatalogItem(
      id: 'vegetable_carrot',
      getName: (l10n) => l10n.foodCarrot,
      icon: '🥕',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 122, 'imperial': 4.3}, // g/oz (1 cup chopped)
        'waterPercentage': 0.88, // 88% water
        'caloriesPer100g': 41,
        'sugarPer100g': 4.7,
        'sodium': 69,
        'potassium': 320,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _cabbage() {
    return CatalogItem(
      id: 'vegetable_cabbage',
      getName: (l10n) => l10n.foodCabbage,
      icon: '🥬',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 89, 'imperial': 3.1}, // g/oz (1 cup chopped)
        'waterPercentage': 0.93, // 93% water
        'caloriesPer100g': 25,
        'sugarPer100g': 3.2,
        'sodium': 18,
        'potassium': 170,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _broccoli() {
    return CatalogItem(
      id: 'vegetable_broccoli',
      getName: (l10n) => l10n.foodBroccoli,
      icon: '🥦',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 91, 'imperial': 3.2}, // g/oz (1 cup chopped)
        'waterPercentage': 0.89, // 89% water
        'caloriesPer100g': 34,
        'sugarPer100g': 1.5,
        'sodium': 33,
        'potassium': 316,
        'magnesium': 21,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _lettuce() {
    return CatalogItem(
      id: 'vegetable_lettuce',
      getName: (l10n) => l10n.foodLettuce,
      icon: '🥬',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 36, 'imperial': 1.3}, // g/oz (1 cup shredded)
        'waterPercentage': 0.95, // 95% water
        'caloriesPer100g': 15,
        'sugarPer100g': 0.8,
        'sodium': 28,
        'potassium': 194,
        'magnesium': 13,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _bellPepper() {
    return CatalogItem(
      id: 'vegetable_bell_pepper',
      getName: (l10n) => l10n.foodBellPepper,
      icon: '🫑',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 149, 'imperial': 5.3}, // g/oz (1 cup chopped)
        'waterPercentage': 0.92, // 92% water
        'caloriesPer100g': 31,
        'sugarPer100g': 4.2,
        'sodium': 4,
        'potassium': 211,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _onion() {
    return CatalogItem(
      id: 'vegetable_onion',
      getName: (l10n) => l10n.foodOnion,
      icon: '🧅',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 160, 'imperial': 5.6}, // g/oz (1 cup chopped)
        'waterPercentage': 0.89, // 89% water
        'caloriesPer100g': 40,
        'sugarPer100g': 4.2,
        'sodium': 4,
        'potassium': 146,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _potato() {
    return CatalogItem(
      id: 'vegetable_potato',
      getName: (l10n) => l10n.foodPotato,
      icon: '🥔',
      properties: {
        'type': 'vegetable',
        'defaultWeight': {'metric': 213, 'imperial': 7.5}, // g/oz (1 medium potato)
        'waterPercentage': 0.79, // 79% water
        'caloriesPer100g': 77,
        'sugarPer100g': 0.8,
        'sodium': 6,
        'potassium': 425,
        'magnesium': 23,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить овощи с очень высоким содержанием воды (>90%)
  static List<CatalogItem> getVeryHighWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage >= 0.90;
    }).toList();
  }

  /// Получить овощи с высоким содержанием калия (>200mg per 100g)
  static List<CatalogItem> getHighPotassium() {
    return getAllItems().where((item) {
      final potassium = item.properties['potassium'] as int;
      return potassium > 200;
    }).toList();
  }

  /// Получить низкокалорийные овощи (<30 kcal per 100g)
  static List<CatalogItem> getLowCalorie() {
    return getAllItems().where((item) {
      final calories = item.properties['caloriesPer100g'] as int;
      return calories < 30;
    }).toList();
  }

  /// Получить овощи с высоким содержанием натрия (>20mg per 100g)
  static List<CatalogItem> getHighSodium() {
    return getAllItems().where((item) {
      final sodium = item.properties['sodium'] as int;
      return sodium > 20;
    }).toList();
  }
}