// lib/data/items/water_items.dart
import '../catalog_item.dart';

class WaterItems {
  // Plain water
  static List<CatalogItem> getPlainWater() {
    return [
      CatalogItem(
        id: 'water_plain',
        getName: (l10n) => l10n.water,
        icon: '💧',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_warm',
        getName: (l10n) => l10n.warmWater,
        icon: '♨️',
        properties: {
          'defaultVolume': {'metric': 300, 'imperial': 10},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_ice',
        getName: (l10n) => l10n.iceWater,
        icon: '🧊',
        properties: {
          'defaultVolume': {'metric': 350, 'imperial': 12},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_filtered',
        getName: (l10n) => l10n.filteredWater,
        icon: '💧',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_alkaline',
        getName: (l10n) => l10n.alkalineWater,
        icon: '💙',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 1.05,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_distilled',
        getName: (l10n) => l10n.distilledWater,
        icon: '💦',
        properties: {
          'defaultVolume': {'metric': 350, 'imperial': 12},
          'hydration': 0.95,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_spring',
        getName: (l10n) => l10n.springWater,
        icon: '🏔️',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_hydrogen',
        getName: (l10n) => l10n.hydrogenWater,
        icon: '⚛️',
        properties: {
          'defaultVolume': {'metric': 300, 'imperial': 10},
          'hydration': 1.1,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_oxygenated',
        getName: (l10n) => l10n.oxygenatedWater,
        icon: '🫧',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
    ];
  }

  // Enhanced water
  static List<CatalogItem> getEnhancedWater() {
    return [
      CatalogItem(
        id: 'water_lemon',
        getName: (l10n) => l10n.lemonWater,
        icon: '🍋',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 1.0,
          'sugar': 0.5,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_sparkling',
        getName: (l10n) => l10n.sparklingWater,
        icon: '✨',
        properties: {
          'defaultVolume': {'metric': 330, 'imperial': 12},
          'hydration': 0.95,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_mineral',
        getName: (l10n) => l10n.mineralWater,
        icon: '🪨',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_coconut',
        getName: (l10n) => l10n.coconutWater,
        icon: '🥥',
        properties: {
          'defaultVolume': {'metric': 330, 'imperial': 11},
          'hydration': 1.2,
          'sugar': 9.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'water_cucumber',
        getName: (l10n) => l10n.cucumberWater,
        icon: '🥒',
        properties: {
          'defaultVolume': {'metric': 300, 'imperial': 10},
          'hydration': 1.0,
          'sugar': 0.3,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_lime',
        getName: (l10n) => l10n.limeWater,
        icon: '🟢',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 1.0,
          'sugar': 0.5,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_berry',
        getName: (l10n) => l10n.berryWater,
        icon: '🫐',
        properties: {
          'defaultVolume': {'metric': 350, 'imperial': 12},
          'hydration': 1.0,
          'sugar': 2.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_mint',
        getName: (l10n) => l10n.mintWater,
        icon: '🌿',
        properties: {
          'defaultVolume': {'metric': 300, 'imperial': 10},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'water_ginger',
        getName: (l10n) => l10n.gingerWater,
        icon: '🫚',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 0.95,
          'sugar': 0.5,
        },
        isPro: true,
      ),
    ];
  }

  // Beverages
  static List<CatalogItem> getBeverages() {
    return [
      CatalogItem(
        id: 'beverage_green_tea',
        getName: (l10n) => l10n.greenTea,
        icon: '🍵',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 0.98,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'beverage_black_tea',
        getName: (l10n) => l10n.blackTea,
        icon: '☕',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 0.96,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'beverage_herbal_tea',
        getName: (l10n) => l10n.herbalTea,
        icon: '🌺',
        properties: {
          'defaultVolume': {'metric': 300, 'imperial': 10},
          'hydration': 1.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'beverage_sports_drink',
        getName: (l10n) => l10n.sportsDrink,
        icon: '🏃',
        properties: {
          'defaultVolume': {'metric': 590, 'imperial': 20},
          'hydration': 1.15,
          'sugar': 34.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'beverage_orange_juice',
        getName: (l10n) => l10n.drink_orange_juice,
        icon: '🍊',
        properties: {
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'hydration': 0.85,
          'sugar': 21.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'beverage_apple_juice',
        getName: (l10n) => l10n.drink_apple_juice,
        icon: '🍎',
        properties: {
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'hydration': 0.85,
          'sugar': 24.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'beverage_milk',
        getName: (l10n) => l10n.drink_milk,
        icon: '🥛',
        properties: {
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'hydration': 0.9,
          'sugar': 12.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'beverage_almond_milk',
        getName: (l10n) => l10n.drink_almond_milk,
        icon: '🥜',
        properties: {
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'hydration': 0.95,
          'sugar': 1.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'beverage_kombucha',
        getName: (l10n) => l10n.drink_kombucha,
        icon: '🫖',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'hydration': 0.9,
          'sugar': 4.0,
        },
        isPro: true,
      ),
    ];
  }

  // Sodas
  static List<CatalogItem> getSodas() {
    return [
      CatalogItem(
        id: 'soda_coca_cola',
        getName: (l10n) => 'Coca-Cola',
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.6,
          'sugar': 39.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'soda_pepsi',
        getName: (l10n) => 'Pepsi',
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.6,
          'sugar': 41.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'soda_mountain_dew',
        getName: (l10n) => 'Mountain Dew',
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.5,
          'sugar': 46.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'soda_dr_pepper',
        getName: (l10n) => 'Dr Pepper',
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.6,
          'sugar': 40.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'soda_sprite',
        getName: (l10n) => 'Sprite',
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.65,
          'sugar': 38.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'soda_fanta',
        getName: (l10n) => 'Fanta Orange',
        icon: '🍊',
        properties: {
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'hydration': 0.6,
          'sugar': 44.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'soda_red_bull',
        getName: (l10n) => 'Red Bull',
        icon: '⚡',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8.4},
          'hydration': 0.75,
          'sugar': 27.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'soda_monster',
        getName: (l10n) => 'Monster Energy',
        icon: '👹',
        properties: {
          'defaultVolume': {'metric': 473, 'imperial': 16},
          'hydration': 0.7,
          'sugar': 54.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'soda_gatorade',
        getName: (l10n) => 'Gatorade',
        icon: '⚡',
        properties: {
          'defaultVolume': {'metric': 590, 'imperial': 20},
          'hydration': 1.1,
          'sugar': 34.0,
        },
        isPro: true,
      ),
    ];
  }

  // Получить все элементы
  static List<CatalogItem> getAllItems() {
    return [
      ...getPlainWater(),
      ...getEnhancedWater(),
      ...getBeverages(),
      ...getSodas(),
    ];
  }
}
