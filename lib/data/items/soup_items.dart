// lib/data/items/soup_items.dart
import '../catalog_item.dart';

class SoupItems {
  /// Получить все супы
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _chickenBroth(),
      _vegetableSoup(),
      _tomatoSoup(),

      // 💎 PRO - 6 items
      _borscht(),
      _ramen(),
      _mushroomSoup(),
      _misoSoup(),
      _peaSoup(),
      _solyanka(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _chickenBroth() {
    return CatalogItem(
      id: 'soup_chicken_broth',
      getName: (l10n) => l10n.foodChickenSoup,
      icon: '🍲',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.94, // 94% water
        'caloriesPer100g': 38,
        'sugarPer100g': 0.9,
        'sodium': 343, // Высокое содержание натрия!
        'potassium': 252,
        'magnesium': 7,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _vegetableSoup() {
    return CatalogItem(
      id: 'soup_vegetable',
      getName: (l10n) => l10n.foodVegetableSoup,
      icon: '🥕',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.91, // 91% water
        'caloriesPer100g': 48,
        'sugarPer100g': 2.1,
        'sodium': 396, // Высокое содержание натрия
        'potassium': 210,
        'magnesium': 7,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _tomatoSoup() {
    return CatalogItem(
      id: 'soup_tomato',
      getName: (l10n) => l10n.foodTomatoSoup,
      icon: '🍅',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.85, // 85% water
        'caloriesPer100g': 66,
        'sugarPer100g': 6.0,
        'sodium': 471, // Очень высокое содержание натрия
        'potassium': 263,
        'magnesium': 7,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _borscht() {
    return CatalogItem(
      id: 'soup_borscht',
      getName: (l10n) => l10n.foodBorscht,
      icon: '🥬',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.89, // 89% water
        'caloriesPer100g': 34,
        'sugarPer100g': 3.5,
        'sodium': 304,
        'potassium': 176,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _ramen() {
    return CatalogItem(
      id: 'soup_ramen',
      getName: (l10n) => l10n.foodRamen,
      icon: '🍜',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.82, // 82% water
        'caloriesPer100g': 436, // Очень калорийный!
        'sugarPer100g': 2.2,
        'sodium': 1731, // ЭКСТРЕМАЛЬНО высокое содержание натрия!
        'potassium': 188,
        'magnesium': 40,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _mushroomSoup() {
    return CatalogItem(
      id: 'soup_mushroom',
      getName: (l10n) => l10n.foodMushroomSoup,
      icon: '🍄',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.88, // 88% water
        'caloriesPer100g': 85,
        'sugarPer100g': 1.3,
        'sodium': 358,
        'potassium': 100,
        'magnesium': 5,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _misoSoup() {
    return CatalogItem(
      id: 'soup_miso',
      getName: (l10n) => l10n.foodMisoSoup,
      icon: '🍜',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.93, // 93% water
        'caloriesPer100g': 40,
        'sugarPer100g': 1.4,
        'sodium': 630, // Очень высокое содержание натрия
        'potassium': 210,
        'magnesium': 9,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _peaSoup() {
    return CatalogItem(
      id: 'soup_pea',
      getName: (l10n) => l10n.foodPeaSoup,
      icon: '🫛',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.84, // 84% water
        'caloriesPer100g': 118,
        'sugarPer100g': 3.0,
        'sodium': 395,
        'potassium': 190,
        'magnesium': 23,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _solyanka() {
    return CatalogItem(
      id: 'soup_solyanka',
      getName: (l10n) => l10n.foodSolyanka,
      icon: '🧅',
      properties: {
        'type': 'soup',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.87, // 87% water
        'caloriesPer100g': 52,
        'sugarPer100g': 2.8,
        'sodium': 890, // Очень высокое содержание натрия (соленые огурцы!)
        'potassium': 230,
        'magnesium': 15,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить супы с очень высоким содержанием натрия (>500mg per 100g)
  static List<CatalogItem> getVeryHighSodium() {
    return getAllItems().where((item) {
      final sodium = item.properties['sodium'] as int;
      return sodium > 500;
    }).toList();
  }

  /// Получить диетические супы (<50 kcal per 100g)
  static List<CatalogItem> getLowCalorie() {
    return getAllItems().where((item) {
      final calories = item.properties['caloriesPer100g'] as int;
      return calories < 50;
    }).toList();
  }

  /// Получить супы с высоким содержанием воды (>90%)
  static List<CatalogItem> getHighWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage >= 0.90;
    }).toList();
  }

  /// Получить супы с высоким содержанием калия (>200mg per 100g)
  static List<CatalogItem> getHighPotassium() {
    return getAllItems().where((item) {
      final potassium = item.properties['potassium'] as int;
      return potassium > 200;
    }).toList();
  }

  /// Получить быстрые объемы для супов
  static List<int> getQuickVolumes(String units) {
    if (units == 'imperial') {
      return [6, 8, 12]; // fl oz (3/4 cup, 1 cup, 1.5 cup)
    } else {
      return [180, 240, 360]; // ml
    }
  }
}