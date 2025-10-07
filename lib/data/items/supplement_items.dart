// lib/data/items/supplement_items.dart
import '../catalog_item.dart';

class SupplementItems {
  // MINERALS category (9 items: 3 FREE + 6 PRO)
  static List<CatalogItem> getMinerals() {
    return [
      // FREE minerals (3)
      CatalogItem(
        id: 'supplement_mg_glycinate',
        getName: (l10n) => l10n.magnesiumGlycinate,
        icon: '💊',
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
        icon: '🟢',
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
        id: 'supplement_calcium_carbonate',
        getName: (l10n) => l10n.calciumCarbonate,
        icon: '⚪',
        properties: {
          'type': 'calcium_carbonate',
          'dosageUnit': {'metric': 'tabs', 'imperial': 'tabs'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),

      // PRO minerals (6)
      CatalogItem(
        id: 'supplement_mg_citrate',
        getName: (l10n) => l10n.magnesiumCitrate,
        icon: '💧',
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
        icon: '🧠',
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
        icon: '🦴',
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
        icon: '🛡️',
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
        id: 'supplement_iron',
        getName: (l10n) => l10n.ironBisglycinate,
        icon: '💪',
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
      CatalogItem(
        id: 'supplement_trace_minerals',
        getName: (l10n) => l10n.traceMinerals,
        icon: '⚡',
        properties: {
          'type': 'trace_minerals',
          'dosageUnit': {'metric': 'ml', 'imperial': 'drops'},
          'defaultDosage': 5,
          'defaultDosageImperial': 10,
          'sodium': 5,
          'potassium': 3,
          'magnesium': 10,
        },
        isPro: true,
      ),
    ];
  }

  // VITAMINS category (9 items: 3 FREE + 6 PRO)
  static List<CatalogItem> getVitamins() {
    return [
      // FREE vitamins (3)
      CatalogItem(
        id: 'supplement_multivitamin',
        getName: (l10n) => l10n.multivitamin,
        icon: '🌈',
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
      CatalogItem(
        id: 'supplement_vitamin_c',
        getName: (l10n) => l10n.vitaminC,
        icon: '🍊',
        properties: {
          'type': 'vitamin_c',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 1000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'supplement_vitamin_d3',
        getName: (l10n) => l10n.vitaminD3,
        icon: '☀️',
        properties: {
          'type': 'vitamin_d3',
          'dosageUnit': {'metric': 'IU', 'imperial': 'IU'},
          'defaultDosage': 2000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),

      // PRO vitamins (6)
      CatalogItem(
        id: 'supplement_b_complex',
        getName: (l10n) => l10n.bComplex,
        icon: '🔋',
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
        id: 'supplement_vitamin_a',
        getName: (l10n) => l10n.vitaminA,
        icon: '👁️',
        properties: {
          'type': 'vitamin_a',
          'dosageUnit': {'metric': 'IU', 'imperial': 'IU'},
          'defaultDosage': 5000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_vitamin_e',
        getName: (l10n) => l10n.vitaminE,
        icon: '🌟',
        properties: {
          'type': 'vitamin_e',
          'dosageUnit': {'metric': 'IU', 'imperial': 'IU'},
          'defaultDosage': 400,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_vitamin_k2',
        getName: (l10n) => l10n.vitaminK2,
        icon: '🦷',
        properties: {
          'type': 'vitamin_k2',
          'dosageUnit': {'metric': 'mcg', 'imperial': 'mcg'},
          'defaultDosage': 100,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_folate',
        getName: (l10n) => l10n.folate,
        icon: '🌱',
        properties: {
          'type': 'folate',
          'dosageUnit': {'metric': 'mcg', 'imperial': 'mcg'},
          'defaultDosage': 400,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_biotin',
        getName: (l10n) => l10n.biotin,
        icon: '💇',
        properties: {
          'type': 'biotin',
          'dosageUnit': {'metric': 'mcg', 'imperial': 'mcg'},
          'defaultDosage': 5000,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
    ];
  }

  // OTHER category (9 items: 3 FREE + 6 PRO)
  static List<CatalogItem> getOther() {
    return [
      // FREE other (3)
      CatalogItem(
        id: 'supplement_omega3',
        getName: (l10n) => l10n.omega3,
        icon: '🐟',
        properties: {
          'type': 'omega3',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'supplement_probiotics',
        getName: (l10n) => l10n.probiotics,
        icon: '🦠',
        properties: {
          'type': 'probiotics',
          'dosageUnit': {'metric': 'caps', 'imperial': 'caps'},
          'defaultDosage': 1,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'supplement_melatonin',
        getName: (l10n) => l10n.melatonin,
        icon: '🌙',
        properties: {
          'type': 'melatonin',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 3,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: false,
      ),

      // PRO other (6)
      CatalogItem(
        id: 'supplement_collagen',
        getName: (l10n) => l10n.collagen,
        icon: '💎',
        properties: {
          'type': 'collagen',
          'dosageUnit': {'metric': 'g', 'imperial': 'g'},
          'defaultDosage': 10,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_glucosamine',
        getName: (l10n) => l10n.glucosamine,
        icon: '🦵',
        properties: {
          'type': 'glucosamine',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 1500,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_turmeric',
        getName: (l10n) => l10n.turmeric,
        icon: '🟡',
        properties: {
          'type': 'turmeric',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 500,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_coq10',
        getName: (l10n) => l10n.coq10,
        icon: '❤️',
        properties: {
          'type': 'coq10',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 100,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_creatine',
        getName: (l10n) => l10n.creatine,
        icon: '💪',
        properties: {
          'type': 'creatine',
          'dosageUnit': {'metric': 'g', 'imperial': 'g'},
          'defaultDosage': 5,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'supplement_ashwagandha',
        getName: (l10n) => l10n.ashwagandha,
        icon: '🌿',
        properties: {
          'type': 'ashwagandha',
          'dosageUnit': {'metric': 'mg', 'imperial': 'mg'},
          'defaultDosage': 600,
          'sodium': 0,
          'potassium': 0,
          'magnesium': 0,
        },
        isPro: true,
      ),
    ];
  }

  // Получить все элементы
  static List<CatalogItem> getAllItems() {
    return [...getMinerals(), ...getVitamins(), ...getOther()];
  }

  // Получить быстрые дозировки для типа добавки
  static List<int> getQuickDosages(String type, String units) {
    final quickDosages = {
      'metric': {
        'default': [1, 2, 3],
        'magnesium_citrate': [10, 20, 30], // ml
        'vitamin_d3': [1000, 2000, 5000], // IU
        'vitamin_c': [500, 1000, 2000], // mg
        'vitamin_a': [2500, 5000, 10000], // IU
        'vitamin_e': [200, 400, 800], // IU
        'vitamin_k2': [50, 100, 200], // mcg
        'folate': [200, 400, 800], // mcg
        'biotin': [2500, 5000, 10000], // mcg
        'melatonin': [1, 3, 5], // mg
        'collagen': [5, 10, 20], // g
        'glucosamine': [500, 1000, 1500], // mg
        'turmeric': [250, 500, 1000], // mg
        'coq10': [50, 100, 200], // mg
        'creatine': [3, 5, 10], // g
        'ashwagandha': [300, 600, 900], // mg
        'trace_minerals': [5, 10, 15], // ml
      },
      'imperial': {
        'default': [1, 2, 3],
        'magnesium_citrate': [1, 2, 4], // tsp
        'vitamin_d3': [1000, 2000, 5000], // IU (одинаково)
        'vitamin_c': [500, 1000, 2000], // mg (одинаково)
        'vitamin_a': [2500, 5000, 10000], // IU
        'vitamin_e': [200, 400, 800], // IU
        'vitamin_k2': [50, 100, 200], // mcg
        'folate': [200, 400, 800], // mcg
        'biotin': [2500, 5000, 10000], // mcg
        'melatonin': [1, 3, 5], // mg
        'collagen': [5, 10, 20], // g
        'glucosamine': [500, 1000, 1500], // mg
        'turmeric': [250, 500, 1000], // mg
        'coq10': [50, 100, 200], // mg
        'creatine': [3, 5, 10], // g
        'ashwagandha': [300, 600, 900], // mg
        'trace_minerals': [5, 10, 15], // drops
      },
    };

    final unitSystem = units == 'imperial' ? 'imperial' : 'metric';
    return quickDosages[unitSystem]?[type] ??
        quickDosages[unitSystem]!['default']!;
  }
}
