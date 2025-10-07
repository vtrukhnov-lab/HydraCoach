// lib/data/items/fruit_items.dart
import '../catalog_item.dart';

class FruitItems {
  /// Получить все фрукты
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _apple(),
      _banana(),
      _orange(),

      // 💎 PRO - 6 items
      _watermelon(),
      _strawberry(),
      _grapes(),
      _pineapple(),
      _mango(),
      _pear(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _apple() {
    return CatalogItem(
      id: 'fruit_apple',
      getName: (l10n) => l10n.foodApple,
      icon: '🍎',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 182,
          'imperial': 6.4,
        }, // g/oz (medium apple)
        'waterPercentage': 0.86, // 86% water
        'caloriesPer100g': 52,
        'sugarPer100g': 10.4,
        'sodium': 1, // mg per 100g
        'potassium': 107,
        'magnesium': 5,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _banana() {
    return CatalogItem(
      id: 'fruit_banana',
      getName: (l10n) => l10n.foodBanana,
      icon: '🍌',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 118,
          'imperial': 4.2,
        }, // g/oz (medium banana)
        'waterPercentage': 0.74, // 74% water
        'caloriesPer100g': 89,
        'sugarPer100g': 12.2,
        'sodium': 1,
        'potassium': 358,
        'magnesium': 27,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _orange() {
    return CatalogItem(
      id: 'fruit_orange',
      getName: (l10n) => l10n.foodOrange,
      icon: '🍊',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 154,
          'imperial': 5.4,
        }, // g/oz (medium orange)
        'waterPercentage': 0.87, // 87% water
        'caloriesPer100g': 47,
        'sugarPer100g': 9.4,
        'sodium': 0,
        'potassium': 181,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _watermelon() {
    return CatalogItem(
      id: 'fruit_watermelon',
      getName: (l10n) => l10n.foodWatermelon,
      icon: '🍉',
      properties: {
        'type': 'fruit',
        'defaultWeight': {'metric': 152, 'imperial': 5.4}, // g/oz (1 cup diced)
        'waterPercentage': 0.92, // 92% water - очень высокое содержание!
        'caloriesPer100g': 30,
        'sugarPer100g': 6.2,
        'sodium': 1,
        'potassium': 112,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _strawberry() {
    return CatalogItem(
      id: 'fruit_strawberry',
      getName: (l10n) => l10n.foodStrawberry,
      icon: '🍓',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 144,
          'imperial': 5.1,
        }, // g/oz (1 cup sliced)
        'waterPercentage': 0.91, // 91% water
        'caloriesPer100g': 32,
        'sugarPer100g': 4.9,
        'sodium': 1,
        'potassium': 153,
        'magnesium': 13,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _grapes() {
    return CatalogItem(
      id: 'fruit_grapes',
      getName: (l10n) => l10n.foodGrapes,
      icon: '🍇',
      properties: {
        'type': 'fruit',
        'defaultWeight': {'metric': 92, 'imperial': 3.2}, // g/oz (1 cup)
        'waterPercentage': 0.81, // 81% water
        'caloriesPer100g': 67,
        'sugarPer100g': 16.3,
        'sodium': 2,
        'potassium': 191,
        'magnesium': 7,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _pineapple() {
    return CatalogItem(
      id: 'fruit_pineapple',
      getName: (l10n) => l10n.foodPineapple,
      icon: '🍍',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 165,
          'imperial': 5.8,
        }, // g/oz (1 cup chunks)
        'waterPercentage': 0.86, // 86% water
        'caloriesPer100g': 50,
        'sugarPer100g': 9.9,
        'sodium': 1,
        'potassium': 109,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _mango() {
    return CatalogItem(
      id: 'fruit_mango',
      getName: (l10n) => l10n.foodMango,
      icon: '🥭',
      properties: {
        'type': 'fruit',
        'defaultWeight': {
          'metric': 165,
          'imperial': 5.8,
        }, // g/oz (1 cup sliced)
        'waterPercentage': 0.84, // 84% water
        'caloriesPer100g': 60,
        'sugarPer100g': 13.7,
        'sodium': 1,
        'potassium': 168,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _pear() {
    return CatalogItem(
      id: 'fruit_pear',
      getName: (l10n) => l10n.foodPear,
      icon: '🍐',
      properties: {
        'type': 'fruit',
        'defaultWeight': {'metric': 178, 'imperial': 6.3}, // g/oz (medium pear)
        'waterPercentage': 0.84, // 84% water
        'caloriesPer100g': 57,
        'sugarPer100g': 9.8,
        'sodium': 1,
        'potassium': 116,
        'magnesium': 7,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить фрукты с высоким содержанием воды (>85%)
  static List<CatalogItem> getHighWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage >= 0.85;
    }).toList();
  }

  /// Получить фрукты с низким содержанием сахара (<10g per 100g)
  static List<CatalogItem> getLowSugar() {
    return getAllItems().where((item) {
      final sugar = item.properties['sugarPer100g'] as double;
      return sugar < 10.0;
    }).toList();
  }

  /// Получить фрукты богатые калием (>150mg per 100g)
  static List<CatalogItem> getHighPotassium() {
    return getAllItems().where((item) {
      final potassium = item.properties['potassium'] as int;
      return potassium > 150;
    }).toList();
  }
}
