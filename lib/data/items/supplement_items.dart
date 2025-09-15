// lib/data/items/supplement_items.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../catalog_item.dart';

class SupplementItems {
  static List<CatalogItem> getAllItems() {
    return [
      // FREE supplements
      CatalogItem(
        id: 'supplement_mg_glycinate',
        getName: (l10n) => l10n.magnesiumGlycinate,
        icon: Icons.medication_liquid,
        properties: {
          'type': 'magnesium_glycinate',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 200, // per capsule
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'supplement_k_citrate',
        getName: (l10n) => l10n.potassiumCitrate,
        icon: Icons.medication,
        properties: {
          'type': 'potassium_citrate',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 99, // per capsule (standard US dose)
          'magnesium': 0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'supplement_multivitamin',
        getName: (l10n) => l10n.multivitamin,
        icon: Icons.vaccines,
        properties: {
          'type': 'multivitamin',
          'dosageUnit': {'metric': 'tabs', 'imperial': 'tabs'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 50,
          'magnesium': 50,
        },
        isPro: false,
      ),
      // PRO supplements
      CatalogItem(
        id: 'supplement_mg_citrate',
        getName: (l10n) => l10n.magnesiumCitrate,
        icon: Icons.water_drop,
        properties: {
          'type': 'magnesium_citrate',
          'dosageUnit': {'metric': 'ml', 'imperial': 'tsp'},
          'defaultDosage': 10,
          'defaultDosageImperial': 2,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 3, // per ml
          'magnesiumImperial': 15, // per tsp
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_mg_threonate',
        getName: (l10n) => l10n.magnesiumThreonate,
        icon: Icons.psychology,
        properties: {
          'type': 'magnesium_threonate',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 144, // per capsule
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_calcium_citrate',
        getName: (l10n) => l10n.calciumCitrate,
        icon: Icons.healing,
        properties: {
          'type': 'calcium_citrate',
          'dosageUnit': {'metric': 'tabs', 'imperial': 'tabs'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_zinc',
        getName: (l10n) => l10n.zincGlycinate,
        icon: Icons.shield,
        properties: {
          'type': 'zinc_glycinate',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_vitamin_d3',
        getName: (l10n) => l10n.vitaminD3,
        icon: Icons.wb_sunny,
        properties: {
          'type': 'vitamin_d3',
          'dosageUnit': {'metric': 'IU', 'imperial': 'IU'},
          'defaultDosage': 2000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_vitamin_c',
        getName: (l10n) => l10n.vitaminC,
        icon: Icons.star,
        properties: {
          'type': 'vitamin_c',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 1000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_b_complex',
        getName: (l10n) => l10n.bComplex,
        icon: Icons.battery_full,
        properties: {
          'type': 'b_complex',
          'dosageUnit': {'metric': 'tabs', 'imperial': 'tabs'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_omega3',
        getName: (l10n) => l10n.omega3,
        icon: Icons.favorite,
        properties: {
          'type': 'omega3',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_iron',
        getName: (l10n) => l10n.ironBisglycinate,
        icon: Icons.fitness_center,
        properties: {
          'type': 'iron_bisglycinate',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
    ];
  }

  // Получить быстрые дозировки для типа добавки
  static List<int> getQuickDosages(String type, String units) {
    final quickDosages = {
      'metric': {
        'default': [1, 2, 3],
        'magnesium_citrate': [10, 20, 30], // ml
        'vitamin_d3': [1000, 2000, 5000], // IU
        'vitamin_c': [500, 1000, 2000], // mg
      },
      'imperial': {
        'default': [1, 2, 3],
        'magnesium_citrate': [1, 2, 4], // tsp
        'vitamin_d3': [1000, 2000, 5000], // IU (одинаково)
        'vitamin_c': [500, 1000, 2000], // mg (одинаково)
      }
    };

    final unitSystem = units == 'imperial' ? 'imperial' : 'metric';
    return quickDosages[unitSystem]?[type] ?? quickDosages[unitSystem]!['default']!;
  }
}