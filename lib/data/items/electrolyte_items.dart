// lib/data/items/electrolyte_items.dart
import '../catalog_item.dart';

class ElectrolyteItems {
  // Basic electrolytes
  static List<CatalogItem> getBasicElectrolytes() {
    return [
      CatalogItem(
        id: 'electrolyte_salt_water',
        getName: (l10n) => l10n.electrolyteSaltWater,
        icon: '🧂',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 600,
          'potassium': 0,
          'magnesium': 0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_pink_salt',
        getName: (l10n) => l10n.electrolytePinkSalt,
        icon: '🩷',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 500,
          'potassium': 20,
          'magnesium': 10,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_sea_salt',
        getName: (l10n) => l10n.electrolyteSeaSalt,
        icon: '🌊',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 550,
          'potassium': 10,
          'magnesium': 5,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_bone_broth',
        getName: (l10n) => l10n.boneBroth,
        icon: '🍲',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 800,
          'potassium': 100,
          'magnesium': 0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_celtic_salt',
        getName: (l10n) => l10n.celticSalt,
        icon: '🧂',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 480,
          'potassium': 40,
          'magnesium': 120,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_sole_water',
        getName: (l10n) => l10n.soleWater,
        icon: '💧',
        properties: {
          'defaultVolume': {'metric': 280, 'imperial': 10},
          'sodium': 2000,
          'potassium': 0,
          'magnesium': 0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_baking_soda',
        getName: (l10n) => l10n.bakingSoda,
        icon: '⚪',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 630,
          'potassium': 0,
          'magnesium': 0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_pickle_juice',
        getName: (l10n) => l10n.pickleJuice,
        icon: '🥒',
        properties: {
          'defaultVolume': {'metric': 100, 'imperial': 3},
          'sodium': 900,
          'potassium': 70,
          'magnesium': 0,
          'sugar': 1.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_tomato_salt',
        getName: (l10n) => l10n.tomatoSalt,
        icon: '🍅',
        properties: {
          'defaultVolume': {'metric': 200, 'imperial': 7},
          'sodium': 650,
          'potassium': 400,
          'magnesium': 0,
          'sugar': 6.0,
        },
        isPro: true,
      ),
    ];
  }

  // Electrolyte mixes
  static List<CatalogItem> getElectrolyteMixes() {
    return [
      CatalogItem(
        id: 'electrolyte_mix',
        getName: (l10n) => l10n.electrolyteMix,
        icon: '⚡',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 500,
          'potassium': 200,
          'magnesium': 50,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_lmnt',
        getName: (l10n) => l10n.electrolyteLMNT,
        icon: '🔬',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 1000,
          'potassium': 200,
          'magnesium': 60,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_ketorade',
        getName: (l10n) => l10n.ketorade,
        icon: '🥤',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'sodium': 750,
          'potassium': 300,
          'magnesium': 100,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_nuun',
        getName: (l10n) => l10n.electrolyteNuun,
        icon: '💊',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'sodium': 300,
          'potassium': 150,
          'magnesium': 25,
          'sugar': 1.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'electrolyte_liquid_iv',
        getName: (l10n) => l10n.electrolyteLiquidIV,
        icon: '💉',
        properties: {
          'defaultVolume': {'metric': 500, 'imperial': 16},
          'sodium': 500,
          'potassium': 370,
          'magnesium': 0,
          'sugar': 11.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_ultima',
        getName: (l10n) => l10n.electrolyteUltima,
        icon: '🌟',
        properties: {
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'sodium': 55,
          'potassium': 250,
          'magnesium': 100,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_propel',
        getName: (l10n) => l10n.electrolytePropel,
        icon: '🏃',
        properties: {
          'defaultVolume': {'metric': 590, 'imperial': 20},
          'sodium': 230,
          'potassium': 70,
          'magnesium': 0,
          'sugar': 2.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_pedialyte',
        getName: (l10n) => l10n.electrolytePedialyte,
        icon: '👶',
        properties: {
          'defaultVolume': {'metric': 360, 'imperial': 12},
          'sodium': 370,
          'potassium': 280,
          'magnesium': 0,
          'sugar': 9.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'electrolyte_gatorade_zero',
        getName: (l10n) => l10n.electrolyteGatoradeZero,
        icon: '🏈',
        properties: {
          'defaultVolume': {'metric': 590, 'imperial': 20},
          'sodium': 270,
          'potassium': 75,
          'magnesium': 0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
    ];
  }

  // Получить все элементы
  static List<CatalogItem> getAllItems() {
    return [...getBasicElectrolytes(), ...getElectrolyteMixes()];
  }
}
