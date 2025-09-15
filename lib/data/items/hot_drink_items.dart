// lib/data/items/hot_drink_items.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../catalog_item.dart';

class HotDrinkItems {
  static List<CatalogItem> getAllItems() {
    return [
      // ========== COFFEE DRINKS (12 items) ==========
      // FREE coffee drinks (3)
      CatalogItem(
        id: 'hot_coffee',
        getName: (l10n) => l10n.coffee,
        icon: '☕',
        properties: {
          'type': 'coffee',
          'defaultVolume': {'metric': 200, 'imperial': 8},
          'caffeineMgPer100ml': 40,
        },
        isPro: false,
        color: Colors.brown,
      ),
      CatalogItem(
        id: 'hot_americano',
        getName: (l10n) => l10n.drink_americano ?? 'Americano',
        icon: '☕',
        properties: {
          'type': 'coffee',
          'defaultVolume': {'metric': 250, 'imperial': 10},
          'caffeineMgPer100ml': 50,
        },
        isPro: false,
        color: const Color(0xFF795548),
      ),
      CatalogItem(
        id: 'hot_instant_coffee',
        getName: (l10n) => 'Instant Coffee',
        icon: '☕',
        properties: {
          'type': 'coffee',
          'defaultVolume': {'metric': 200, 'imperial': 8},
          'caffeineMgPer100ml': 30,
        },
        isPro: false,
        color: const Color(0xFF8D6E63),
      ),
      
      // PRO coffee drinks (9)
      CatalogItem(
        id: 'hot_espresso',
        getName: (l10n) => l10n.espresso,
        icon: '☕',
        properties: {
          'type': 'coffee',
          'defaultVolume': {'metric': 30, 'imperial': 1},
          'caffeineMgPer100ml': 212,
        },
        isPro: true,
        color: const Color(0xFF3E2723),
      ),
      CatalogItem(
        id: 'hot_double_espresso',
        getName: (l10n) => 'Double Espresso',
        icon: '☕',
        properties: {
          'type': 'coffee',
          'defaultVolume': {'metric': 60, 'imperial': 2},
          'caffeineMgPer100ml': 212,
        },
        isPro: true,
        color: const Color(0xFF3E2723),
      ),
      CatalogItem(
        id: 'hot_cappuccino',
        getName: (l10n) => l10n.cappuccino,
        icon: '☕',
        properties: {
          'type': 'cappuccino',
          'defaultVolume': {'metric': 180, 'imperial': 6},
          'caffeineMgPer100ml': 42,
          'sugar': 10.0,  // ~10g from milk (180ml drink, ~120ml milk)
        },
        isPro: true,
        color: const Color(0xFF6D4C41),
      ),
      CatalogItem(
        id: 'hot_latte',
        getName: (l10n) => l10n.latte,
        icon: '☕',
        properties: {
          'type': 'latte',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 30,
          'sugar': 17.0,  // ~17g from milk (250ml drink, ~200ml milk)
        },
        isPro: true,
        color: const Color(0xFF8D6E63),
      ),
      CatalogItem(
        id: 'hot_flat_white',
        getName: (l10n) => 'Flat White',
        icon: '☕',
        properties: {
          'type': 'flat_white',
          'defaultVolume': {'metric': 160, 'imperial': 5},
          'caffeineMgPer100ml': 50,
          'sugar': 9.0,  // ~9g from milk (160ml drink, ~110ml milk)
        },
        isPro: true,
        color: const Color(0xFF795548),
      ),
      CatalogItem(
        id: 'hot_macchiato',
        getName: (l10n) => 'Macchiato',
        icon: '☕',
        properties: {
          'type': 'macchiato',
          'defaultVolume': {'metric': 60, 'imperial': 2},
          'caffeineMgPer100ml': 150,
          'sugar': 2.0,  // ~2g from small amount of milk foam
        },
        isPro: true,
        color: const Color(0xFF5D4037),
      ),
      CatalogItem(
        id: 'hot_mocha',
        getName: (l10n) => 'Mocha',
        icon: '☕',
        properties: {
          'type': 'mocha',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 35,
          'sugar': 20.0,  // Mocha contains chocolate/sugar + milk
        },
        isPro: true,
        color: const Color(0xFF4E342E),
      ),
      CatalogItem(
        id: 'hot_turkish_coffee',
        getName: (l10n) => 'Turkish Coffee',
        icon: '☕',
        properties: {
          'type': 'turkish_coffee',
          'defaultVolume': {'metric': 60, 'imperial': 2},
          'caffeineMgPer100ml': 80,
        },
        isPro: true,
        color: const Color(0xFF3E2723),
      ),
      CatalogItem(
        id: 'hot_decaf_coffee',
        getName: (l10n) => 'Decaf Coffee',
        icon: '☕',
        properties: {
          'type': 'decaf_coffee',
          'defaultVolume': {'metric': 200, 'imperial': 8},
          'caffeineMgPer100ml': 2,
        },
        isPro: true,
        color: const Color(0xFFA1887F),
      ),
      
      // ========== TEA DRINKS (11 items) ==========
      // FREE tea drinks (3)
      CatalogItem(
        id: 'hot_black_tea',
        getName: (l10n) => l10n.blackTea,
        icon: '🍵',
        properties: {
          'type': 'black_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 20,
        },
        isPro: false,
        color: const Color(0xFF5D4037),
      ),
      CatalogItem(
        id: 'hot_green_tea',
        getName: (l10n) => l10n.greenTea,
        icon: '🍵',
        properties: {
          'type': 'green_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 12,
        },
        isPro: false,
        color: const Color(0xFF2E7D32),
      ),
      CatalogItem(
        id: 'hot_herbal_tea',
        getName: (l10n) => l10n.herbalTea,
        icon: '🌿',
        properties: {
          'type': 'herbal_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: false,
        color: const Color(0xFF388E3C),
      ),
      
      // PRO tea drinks (8)
      CatalogItem(
        id: 'hot_matcha',
        getName: (l10n) => l10n.matcha,
        icon: '🍵',
        properties: {
          'type': 'matcha',
          'defaultVolume': {'metric': 200, 'imperial': 6},
          'caffeineMgPer100ml': 35,
          'sugar': 12.0,  // Often served as matcha latte with milk
        },
        isPro: true,
        color: const Color(0xFF1B5E20),
      ),
      CatalogItem(
        id: 'hot_oolong_tea',
        getName: (l10n) => 'Oolong Tea',
        icon: '🍵',
        properties: {
          'type': 'oolong_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 15,
        },
        isPro: true,
        color: const Color(0xFF6D4C41),
      ),
      CatalogItem(
        id: 'hot_white_tea',
        getName: (l10n) => 'White Tea',
        icon: '🍵',
        properties: {
          'type': 'white_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 8,
        },
        isPro: true,
        color: const Color(0xFFBCAAA4),
      ),
      CatalogItem(
        id: 'hot_chai_tea',
        getName: (l10n) => 'Chai Tea',
        icon: '🍵',
        properties: {
          'type': 'chai_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 20,
          'sugar': 15.0,  // Chai latte with milk and sweeteners
        },
        isPro: true,
        color: const Color(0xFF8D6E63),
      ),
      CatalogItem(
        id: 'hot_earl_grey',
        getName: (l10n) => 'Earl Grey',
        icon: '🍵',
        properties: {
          'type': 'earl_grey',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 22,
        },
        isPro: true,
        color: const Color(0xFF455A64),
      ),
      CatalogItem(
        id: 'hot_chamomile_tea',
        getName: (l10n) => 'Chamomile Tea',
        icon: '🌼',
        properties: {
          'type': 'chamomile_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: true,
        color: const Color(0xFFFFC107),
      ),
      CatalogItem(
        id: 'hot_peppermint_tea',
        getName: (l10n) => 'Peppermint Tea',
        icon: '🌱',
        properties: {
          'type': 'peppermint_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: true,
        color: const Color(0xFF66BB6A),
      ),
      CatalogItem(
        id: 'hot_rooibos_tea',
        getName: (l10n) => 'Rooibos Tea',
        icon: '🍵',
        properties: {
          'type': 'rooibos_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: true,
        color: const Color(0xFFD84315),
      ),
      
      // ========== OTHER HOT DRINKS (8 items) ==========
      // FREE other drinks (2)
      CatalogItem(
        id: 'hot_chocolate',
        getName: (l10n) => l10n.hotChocolate,
        icon: '🍫',
        properties: {
          'type': 'hot_chocolate',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 2,
          'sugar': 25.0,  // 25g sugar per serving
        },
        isPro: false,
        color: const Color(0xFFA1887F),
      ),
      CatalogItem(
        id: 'hot_water',
        getName: (l10n) => 'Hot Water',
        icon: '💧',
        properties: {
          'type': 'hot_water',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: false,
        color: const Color(0xFF90CAF9),
      ),
      
      // PRO other drinks (6 - without bone broth)
      CatalogItem(
        id: 'hot_cocoa',
        getName: (l10n) => 'Hot Cocoa',
        icon: '🍫',
        properties: {
          'type': 'hot_cocoa',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 3,
          'sugar': 28.0,  // High sugar content
        },
        isPro: true,
        color: const Color(0xFF8D6E63),
      ),
      CatalogItem(
        id: 'hot_white_chocolate',
        getName: (l10n) => 'White Chocolate',
        icon: '🤍',
        properties: {
          'type': 'white_chocolate',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
          'sugar': 30.0,  // Very high sugar
        },
        isPro: true,
        color: const Color(0xFFE0E0E0),
      ),
      CatalogItem(
        id: 'hot_turmeric_latte',
        getName: (l10n) => 'Turmeric Latte',
        icon: '🟡',
        properties: {
          'type': 'turmeric_latte',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
          'sugar': 8.0,  // Some sugar from milk
        },
        isPro: true,
        color: const Color(0xFFFFB300),
      ),
      CatalogItem(
        id: 'hot_apple_cider',
        getName: (l10n) => 'Hot Apple Cider',
        icon: '🍎',
        properties: {
          'type': 'apple_cider',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
          'sugar': 24.0,  // Natural sugars from apples
        },
        isPro: true,
        color: const Color(0xFFFF6F00),
      ),
      CatalogItem(
        id: 'hot_ginger_tea',
        getName: (l10n) => 'Ginger Tea',
        icon: '🫚',
        properties: {
          'type': 'ginger_tea',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: true,
        color: const Color(0xFFFFA726),
      ),
      CatalogItem(
        id: 'hot_lemon_water',
        getName: (l10n) => 'Hot Lemon Water',
        icon: '🍋',
        properties: {
          'type': 'lemon_water',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'caffeineMgPer100ml': 0,
        },
        isPro: true,
        color: const Color(0xFFFFEB3B),
      ),
    ];
  }

  // Получить быстрые объемы для типа напитка
  static List<int> getQuickVolumes(String type, String units) {
    final isImperial = units == 'imperial';
    
    switch (type) {
      case 'espresso':
      case 'double_espresso':
      case 'macchiato':
      case 'turkish_coffee':
        return isImperial ? [1, 2, 3] : [30, 60, 90];
      case 'coffee':
      case 'americano':
      case 'cappuccino':
      case 'flat_white':
        return isImperial ? [6, 8, 10] : [150, 200, 250];
      case 'latte':
      case 'mocha':
        return isImperial ? [8, 10, 12] : [200, 250, 350];
      case 'black_tea':
      case 'green_tea':
      case 'herbal_tea':
      case 'matcha':
      case 'oolong_tea':
      case 'white_tea':
      case 'chai_tea':
      case 'earl_grey':
      case 'chamomile_tea':
      case 'peppermint_tea':
      case 'rooibos_tea':
        return isImperial ? [8, 10, 12] : [200, 250, 350];
      case 'hot_chocolate':
      case 'hot_cocoa':
      case 'white_chocolate':
      case 'turmeric_latte':
      case 'apple_cider':
      case 'ginger_tea':
      case 'lemon_water':
      case 'hot_water':
        return isImperial ? [8, 10, 12] : [200, 250, 300];
      default:
        return isImperial ? [6, 8, 10] : [150, 200, 250];
    }
  }
}