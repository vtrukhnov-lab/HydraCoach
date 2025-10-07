// lib/data/items/fast_food_items.dart
import '../catalog_item.dart';

class FastFoodItems {
  /// Получить все продукты фастфуда
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _burger(),
      _pizza(),
      _frenchFries(),

      // 💎 PRO - 6 items
      _hotDog(),
      _nuggets(),
      _taco(),
      _sandwich(),
      _doner(),
      _shawarma(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _burger() {
    return CatalogItem(
      id: 'fastfood_burger',
      getName: (l10n) => l10n.foodBigMac,
      icon: '🍔',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {
          'metric': 150,
          'imperial': 5.3,
        }, // g/oz (medium burger)
        'waterPercentage':
            0.15, // 15% water - фастфуд обезвоживает, не увлажняет
        'caloriesPer100g': 295,
        'sugarPer100g': 8.5, // Больше сахара из булочки и соуса Big Mac
        'sodium': 396, // Высокое содержание натрия
        'potassium': 267,
        'magnesium': 21,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _pizza() {
    return CatalogItem(
      id: 'fastfood_pizza',
      getName: (l10n) => l10n.foodPizza,
      icon: '🍕',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 107, 'imperial': 3.8}, // g/oz (1 slice)
        'waterPercentage': 0.48, // 48% water
        'caloriesPer100g': 266,
        'sugarPer100g': 3.6,
        'sodium': 598, // Очень высокое содержание натрия
        'potassium': 172,
        'magnesium': 20,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _frenchFries() {
    return CatalogItem(
      id: 'fastfood_french_fries',
      getName: (l10n) => l10n.foodFrenchFries,
      icon: '🍟',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {
          'metric': 85,
          'imperial': 3.0,
        }, // g/oz (medium serving)
        'waterPercentage': 0.35, // 35% water - низкое содержание
        'caloriesPer100g': 365, // Очень калорийные!
        'sugarPer100g': 0.3,
        'sodium': 246,
        'potassium': 579,
        'magnesium': 25,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _hotDog() {
    return CatalogItem(
      id: 'fastfood_hot_dog',
      getName: (l10n) => l10n.foodHotDog,
      icon: '🌭',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {
          'metric': 98,
          'imperial': 3.5,
        }, // g/oz (1 hot dog with bun)
        'waterPercentage': 0.53, // 53% water
        'caloriesPer100g': 290,
        'sugarPer100g': 4.0,
        'sodium': 810, // Очень высокое содержание натрия!
        'potassium': 166,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _nuggets() {
    return CatalogItem(
      id: 'fastfood_nuggets',
      getName: (l10n) => l10n.foodChickenNuggets,
      icon: '🍗',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 64, 'imperial': 2.3}, // g/oz (4 pieces)
        'waterPercentage': 0.52, // 52% water
        'caloriesPer100g': 296,
        'sugarPer100g': 0.9,
        'sodium': 540, // Очень высокое содержание натрия
        'potassium': 202,
        'magnesium': 15,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _taco() {
    return CatalogItem(
      id: 'fastfood_taco',
      getName: (l10n) => l10n.foodTacos,
      icon: '🌮',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 78, 'imperial': 2.8}, // g/oz (1 taco)
        'waterPercentage': 0.59, // 59% water
        'caloriesPer100g': 226,
        'sugarPer100g': 1.8,
        'sodium': 401,
        'potassium': 235,
        'magnesium': 32,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _sandwich() {
    return CatalogItem(
      id: 'fastfood_sandwich',
      getName: (l10n) => l10n.foodSubway,
      icon: '🥪',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 230, 'imperial': 8.1}, // g/oz (6-inch sub)
        'waterPercentage': 0.55, // 55% water
        'caloriesPer100g': 250,
        'sugarPer100g': 3.9,
        'sodium': 644, // Очень высокое содержание натрия
        'potassium': 204,
        'magnesium': 22,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _doner() {
    return CatalogItem(
      id: 'fastfood_doner',
      getName: (l10n) => l10n.foodDoner,
      icon: '🥙',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 200, 'imperial': 7.1}, // g/oz (1 serving)
        'waterPercentage': 0.58, // 58% water
        'caloriesPer100g': 215,
        'sugarPer100g': 2.5,
        'sodium': 492,
        'potassium': 291,
        'magnesium': 24,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _shawarma() {
    return CatalogItem(
      id: 'fastfood_shawarma',
      getName: (l10n) => l10n.foodShawarma,
      icon: '🌯',
      properties: {
        'type': 'fast_food',
        'defaultWeight': {'metric': 180, 'imperial': 6.3}, // g/oz (1 serving)
        'waterPercentage': 0.56, // 56% water
        'caloriesPer100g': 230,
        'sugarPer100g': 2.8,
        'sodium': 520,
        'potassium': 275,
        'magnesium': 26,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить фастфуд с очень высоким содержанием натрия (>500mg per 100g)
  static List<CatalogItem> getVeryHighSodium() {
    return getAllItems().where((item) {
      final sodium = item.properties['sodium'] as int;
      return sodium > 500;
    }).toList();
  }

  /// Получить очень калорийный фастфуд (>300 kcal per 100g)
  static List<CatalogItem> getVeryHighCalorie() {
    return getAllItems().where((item) {
      final calories = item.properties['caloriesPer100g'] as int;
      return calories > 300;
    }).toList();
  }

  /// Получить фастфуд с низким содержанием воды (<50%)
  static List<CatalogItem> getLowWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage < 0.50;
    }).toList();
  }

  /// Получить фастфуд с высоким содержанием калия (>250mg per 100g)
  static List<CatalogItem> getHighPotassium() {
    return getAllItems().where((item) {
      final potassium = item.properties['potassium'] as int;
      return potassium > 250;
    }).toList();
  }

  /// Получить порционный фастфуд (бургеры, пицца по кускам)
  static List<CatalogItem> getPortionBased() {
    return getAllItems().where((item) {
      final id = item.id;
      return id.contains('burger') ||
          id.contains('pizza') ||
          id.contains('hot_dog') ||
          id.contains('taco') ||
          id.contains('sandwich') ||
          id.contains('doner') ||
          id.contains('shawarma');
    }).toList();
  }

  /// Получить фастфуд с наименьшим ущербом для гидратации
  static List<CatalogItem> getLeastDehydrating() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      final sodium = item.properties['sodium'] as int;
      // Больше воды И меньше натрия = лучше для гидратации
      return waterPercentage > 0.55 && sodium < 500;
    }).toList();
  }

  /// Получить быстрые порции для фастфуда
  static List<int> getQuickPortions(String foodType, String units) {
    if (units == 'imperial') {
      switch (foodType) {
        case 'single': // burger, hot dog, sandwich
          return [1, 1, 2]; // pieces
        case 'slice': // pizza
          return [1, 2, 3]; // slices
        case 'serving': // fries, nuggets
          return [3, 5, 8]; // oz
        case 'wrap': // taco, doner, shawarma
          return [1, 1, 2]; // pieces
        default:
          return [3, 5, 8]; // oz
      }
    } else {
      switch (foodType) {
        case 'single': // burger, hot dog, sandwich
          return [150, 200, 300]; // g
        case 'slice': // pizza (per slice)
          return [107, 214, 321]; // g (1, 2, 3 slices)
        case 'serving': // fries, nuggets
          return [85, 140, 225]; // g
        case 'wrap': // taco, doner, shawarma
          return [150, 200, 300]; // g
        default:
          return [100, 150, 200]; // g
      }
    }
  }

  /// Получить рекомендации по дополнительной воде для фастфуда
  static int getRecommendedExtraWater(String foodId, double portionWeight) {
    final item = getAllItems().where((item) => item.id == foodId).firstOrNull;
    if (item == null) return 0;

    final sodium = item.properties['sodium'] as int;
    final waterPercentage = item.properties['waterPercentage'] as double;

    // Расчет дополнительной воды на основе натрия и низкого содержания воды
    final sodiumFactor = (sodium / 100).round(); // мл на каждые 100мг натрия
    final dehydrationFactor = waterPercentage < 0.5
        ? 100
        : 50; // мл за низкую гидратацию

    return (sodiumFactor + dehydrationFactor).round();
  }
}
