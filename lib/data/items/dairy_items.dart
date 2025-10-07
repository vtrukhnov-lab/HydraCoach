// lib/data/items/dairy_items.dart
import '../catalog_item.dart';

class DairyItems {
  /// Получить все молочные продукты
  static List<CatalogItem> getAllItems() {
    return [
      // 🆓 FREE - 3 items
      _milk(),
      _yogurt(),
      _cheese(),

      // 💎 PRO - 6 items
      _kefir(),
      _cottage(),
      _sourCream(),
      _iceCream(),
      _butter(),
      _ryazhenka(),
    ];
  }

  // 🆓 FREE ITEMS

  static CatalogItem _milk() {
    return CatalogItem(
      id: 'dairy_milk',
      getName: (l10n) => l10n.foodMilk,
      icon: '🥛',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.87, // 87% water
        'caloriesPer100g': 42,
        'sugarPer100g': 5.0, // Лактоза
        'sodium': 40,
        'potassium': 150,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _yogurt() {
    return CatalogItem(
      id: 'dairy_yogurt',
      getName: (l10n) => l10n.foodYogurt,
      icon: '🥣',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 170, 'imperial': 6.0}, // g/oz (3/4 cup)
        'waterPercentage': 0.85, // 85% water
        'caloriesPer100g': 59,
        'sugarPer100g': 3.6,
        'sodium': 36,
        'potassium': 141,
        'magnesium': 11,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  static CatalogItem _cheese() {
    return CatalogItem(
      id: 'dairy_cheese',
      getName: (l10n) => l10n.foodCheese,
      icon: '🧀',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 28, 'imperial': 1.0}, // g/oz (1 slice)
        'waterPercentage': 0.37, // 37% water - низкое содержание
        'caloriesPer100g': 403, // Очень калорийный!
        'sugarPer100g': 1.3,
        'sodium': 621, // Высокое содержание натрия
        'potassium': 99,
        'magnesium': 28,
        'hasCaffeine': false,
      },
      isPro: false,
    );
  }

  // 💎 PRO ITEMS

  static CatalogItem _kefir() {
    return CatalogItem(
      id: 'dairy_kefir',
      getName: (l10n) => l10n.foodKefir,
      icon: '🥛',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.90, // 90% water
        'caloriesPer100g': 41,
        'sugarPer100g': 4.5,
        'sodium': 40,
        'potassium': 152,
        'magnesium': 12,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _cottage() {
    return CatalogItem(
      id: 'dairy_cottage_cheese',
      getName: (l10n) => l10n.foodCottageCheese,
      icon: '🧀',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 113, 'imperial': 4.0}, // g/oz (1/2 cup)
        'waterPercentage': 0.79, // 79% water
        'caloriesPer100g': 98,
        'sugarPer100g': 2.6,
        'sodium': 364, // Высокое содержание натрия
        'potassium': 104,
        'magnesium': 8,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _sourCream() {
    return CatalogItem(
      id: 'dairy_sour_cream',
      getName: (l10n) => l10n.foodCream,
      icon: '🍶',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 30, 'imperial': 1.1}, // g/oz (2 tbsp)
        'waterPercentage': 0.71, // 71% water
        'caloriesPer100g': 198,
        'sugarPer100g': 2.9,
        'sodium': 46,
        'potassium': 141,
        'magnesium': 10,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _iceCream() {
    return CatalogItem(
      id: 'dairy_ice_cream',
      getName: (l10n) => l10n.foodIceCream,
      icon: '🍨',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 66, 'imperial': 2.3}, // g/oz (1/2 cup)
        'waterPercentage': 0.61, // 61% water
        'caloriesPer100g': 207,
        'sugarPer100g': 20.6, // Очень высокое содержание сахара!
        'sodium': 80,
        'potassium': 131,
        'magnesium': 14,
        'hasCaffeine': false, // Но может содержать кофеин в шоколадных вкусах
      },
      isPro: true,
    );
  }

  static CatalogItem _butter() {
    return CatalogItem(
      id: 'dairy_butter',
      getName: (l10n) => l10n.foodButter,
      icon: '🧈',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 14, 'imperial': 0.5}, // g/oz (1 tbsp)
        'waterPercentage': 0.16, // 16% water - очень низкое содержание
        'caloriesPer100g': 717, // ЭКСТРЕМАЛЬНО калорийный!
        'sugarPer100g': 0.1,
        'sodium': 643, // Высокое содержание натрия
        'potassium': 24,
        'magnesium': 2,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  static CatalogItem _ryazhenka() {
    return CatalogItem(
      id: 'dairy_ryazhenka',
      getName: (l10n) => l10n.foodRyazhenka,
      icon: '🥛',
      properties: {
        'type': 'dairy',
        'defaultWeight': {'metric': 240, 'imperial': 8.5}, // g/oz (1 cup)
        'waterPercentage': 0.88, // 88% water
        'caloriesPer100g': 85,
        'sugarPer100g': 4.2,
        'sodium': 50,
        'potassium': 146,
        'magnesium': 14,
        'hasCaffeine': false,
      },
      isPro: true,
    );
  }

  /// Получить молочные продукты с высоким содержанием воды (>80%)
  static List<CatalogItem> getHighWaterContent() {
    return getAllItems().where((item) {
      final waterPercentage = item.properties['waterPercentage'] as double;
      return waterPercentage >= 0.80;
    }).toList();
  }

  /// Получить низкокалорийные молочные продукты (<100 kcal per 100g)
  static List<CatalogItem> getLowCalorie() {
    return getAllItems().where((item) {
      final calories = item.properties['caloriesPer100g'] as int;
      return calories < 100;
    }).toList();
  }

  /// Получить молочные продукты с высоким содержанием натрия (>300mg per 100g)
  static List<CatalogItem> getHighSodium() {
    return getAllItems().where((item) {
      final sodium = item.properties['sodium'] as int;
      return sodium > 300;
    }).toList();
  }

  /// Получить молочные продукты с высоким содержанием сахара (>10g per 100g)
  static List<CatalogItem> getHighSugar() {
    return getAllItems().where((item) {
      final sugar = item.properties['sugarPer100g'] as double;
      return sugar > 10.0;
    }).toList();
  }

  /// Получить ферментированные молочные продукты (пробиотики)
  static List<CatalogItem> getFermented() {
    return getAllItems().where((item) {
      final id = item.id;
      return id.contains('yogurt') ||
          id.contains('kefir') ||
          id.contains('ryazhenka') ||
          id.contains('cottage');
    }).toList();
  }

  /// Получить быстрые объемы для молочных продуктов
  static List<int> getQuickVolumes(String dairyType, String units) {
    if (units == 'imperial') {
      switch (dairyType) {
        case 'liquid': // milk, kefir, ryazhenka
          return [4, 8, 12]; // fl oz
        case 'thick': // yogurt, sour cream
          return [2, 4, 6]; // fl oz
        case 'solid': // cheese, butter
          return [1, 2, 3]; // oz
        default:
          return [2, 4, 8]; // fl oz
      }
    } else {
      switch (dairyType) {
        case 'liquid': // milk, kefir, ryazhenka
          return [120, 240, 360]; // ml
        case 'thick': // yogurt, sour cream
          return [60, 120, 180]; // ml
        case 'solid': // cheese, butter
          return [15, 30, 60]; // g
        default:
          return [60, 120, 240]; // ml/g
      }
    }
  }
}
