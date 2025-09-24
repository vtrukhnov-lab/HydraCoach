// lib/data/items/meat_items.dart
import '../catalog_item.dart';

class MeatItems {
  /// Получить все мясные продукты
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _chicken(),
      _beef(),
      _eggs(),

      // 💎 PRO - 6 items
      _pork(),
      _fish(),
      _sausage(),
      _bacon(),
      _turkey(),
      _shrimp(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _chicken() {
    return CatalogItem(
      id: 'meat_chicken',
      getName: (l10n) => l10n.foodChickenBreast,
      icon: '🐔',
      properties: {
        'type': 'meat',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.75, // 75% water
        'caloriesPer100g': 165,
        'sugarPer100g': 0.0,
        'sodium': 74,
        'potassium': 256,
        'magnesium': 25,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _beef() {
    return CatalogItem(
      id: 'meat_beef',
      getName: (l10n) => l10n.foodBeef,
      icon: '🥩',
      properties: {
        'type': 'meat',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.64, // 64% water
        'caloriesPer100g': 215,
        'sugarPer100g': 0.0,
        'sodium': 66,
        'potassium': 270,
        'magnesium': 18,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _eggs() {
    return CatalogItem(
      id: 'meat_eggs',
      getName: (l10n) => l10n.foodEggs,
      icon: '🥚',
      properties: {
        'type': 'protein',
        'defaultWeight': {'metric': 50, 'imperial': 1.8}, // g/oz (1 large egg)
        'waterPercentage': 0.76, // 76% water
        'caloriesPer100g': 155,
        'sugarPer100g': 1.1,
        'sodium': 124,
        'potassium': 126,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _pork() {
    return CatalogItem(
      id: 'meat_pork',
      getName: (l10n) => l10n.foodPork,
      icon: '🐷',
      properties: {
        'type': 'meat',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.70, // 70% water
        'caloriesPer100g': 143,
        'sugarPer100g': 0.0,
        'sodium': 57,
        'potassium': 423,
        'magnesium': 24,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _fish() {
    return CatalogItem(
      id: 'meat_fish',
      getName: (l10n) => l10n.foodSalmon,
      icon: '🐟',
      properties: {
        'type': 'seafood',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.69, // 69% water
        'caloriesPer100g': 208,
        'sugarPer100g': 0.0,
        'sodium': 82,
        'potassium': 628,
        'magnesium': 30,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _sausage() {
    return CatalogItem(
      id: 'meat_sausage',
      getName: (l10n) => l10n.foodSausage,
      icon: '🌭',
      properties: {
        'type': 'processed_meat',
        'defaultWeight': {'metric': 45, 'imperial': 1.6}, // g/oz (1 link)
        'waterPercentage': 0.57, // 57% water
        'caloriesPer100g': 301,
        'sugarPer100g': 0.9,
        'sodium': 1202, // ОЧЕНЬ высокое содержание натрия!
        'potassium': 204,
        'magnesium': 11,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _bacon() {
    return CatalogItem(
      id: 'meat_bacon',
      getName: (l10n) => l10n.foodBacon,
      icon: '🥓',
      properties: {
        'type': 'processed_meat',
        'defaultWeight': {'metric': 19, 'imperial': 0.7}, // g/oz (2 slices)
        'waterPercentage': 0.43, // 43% water - низкое содержание
        'caloriesPer100g': 541, // Очень калорийный!
        'sugarPer100g': 1.4,
        'sodium': 1717, // ЭКСТРЕМАЛЬНО высокое содержание натрия!
        'potassium': 565,
        'magnesium': 20,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _turkey() {
    return CatalogItem(
      id: 'meat_turkey',
      getName: (l10n) => l10n.foodTurkey,
      icon: '🦃',
      properties: {
        'type': 'meat',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.74, // 74% water
        'caloriesPer100g': 104,
        'sugarPer100g': 0.0,
        'sodium': 63,
        'potassium': 249,
        'magnesium': 24,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _shrimp() {
    return CatalogItem(
      id: 'meat_shrimp',
      getName: (l10n) => l10n.foodShrimp,
      icon: '🍤',
      properties: {
        'type': 'seafood',
        'defaultWeight': {'metric': 85, 'imperial': 3.0}, // g/oz (3 oz serving)
        'waterPercentage': 0.76, // 76% water
        'caloriesPer100g': 99,
        'sugarPer100g': 0.0,
        'sodium': 566, // Высокое содержание натрия
        'potassium': 259,
        'magnesium': 43,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить мясо с высоким содержанием воды (>70%)
  static List<CatalogItem> getHighWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage >= 0.70;
    }).toList();
  }

  /// Получить постное мясо (<150 kcal per 100g)
  static List<CatalogItem> getLeanMeat() {
    return getAllItems().where((item) {
      final calories = item.properties['caloriesPer100g'] as int;
      return calories < 150;
    }).toList();
  }

  /// Получить обработанное мясо (колбасы, бекон)
  static List<CatalogItem> getProcessedMeat() {
    return getAllItems().where((item) {
      final type = item.properties['type'] as String;
      return type == 'processed_meat';
    }).toList();
  }

  /// Получить морепродукты
  static List<CatalogItem> getSeafood() {
    return getAllItems().where((item) {
      final type = item.properties['type'] as String;
      return type == 'seafood';
    }).toList();
  }

  /// Получить мясо с очень высоким содержанием натрия (>500mg per 100g)
  static List<CatalogItem> getVeryHighSodium() {
    return getAllItems().where((item) {
      final sodium = item.properties['sodium'] as int;
      return sodium > 500;
    }).toList();
  }

  /// Получить мясо с высоким содержанием калия (>300mg per 100g)
  static List<CatalogItem> getHighPotassium() {
    return getAllItems().where((item) {
      final potassium = item.properties['potassium'] as int;
      return potassium > 300;
    }).toList();
  }

  /// Получить быстрые порции для мяса
  static List<int> getQuickPortions(String meatType, String units) {
    if (units == 'imperial') {
      switch (meatType) {
        case 'whole': // chicken, beef, pork, turkey, fish
          return [3, 4, 6]; // oz
        case 'processed': // sausage, bacon
          return [1, 2, 3]; // oz
        case 'small': // eggs, shrimp
          return [2, 3, 4]; // oz
        default:
          return [2, 3, 4]; // oz
      }
    } else {
      switch (meatType) {
        case 'whole': // chicken, beef, pork, turkey, fish
          return [85, 115, 170]; // g
        case 'processed': // sausage, bacon
          return [30, 60, 85]; // g
        case 'small': // eggs, shrimp
          return [50, 85, 115]; // g
        default:
          return [60, 85, 115]; // g
      }
    }
  }
}