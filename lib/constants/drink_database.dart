import 'drink_categories.dart';

/// Модель напитка с полной информацией
class DrinkType {
  final String id;
  final String nameKey; // Ключ для локализации
  final DrinkCategory category;
  final AlcoholSubCategory? alcoholSubCategory;
  final String emoji;
  final double defaultVolumeMl;
  final double? alcoholPercentage; // ABV для алкоголя
  final bool isPremium;
  final bool canAddIce;
  final bool canCustomizeStrength;
  
  // Электролиты на 100мл (mg)
  final double sodiumPer100ml;
  final double potassiumPer100ml;
  final double magnesiumPer100ml;
  
  // Дополнительные свойства
  final double? caffeineMgPer100ml;
  final double? sugarGramsPer100ml;
  final double hydrationCoefficient; // 1.0 = чистая вода, <1 = хуже, >1 = лучше
  
  const DrinkType({
    required this.id,
    required this.nameKey,
    required this.category,
    this.alcoholSubCategory,
    required this.emoji,
    required this.defaultVolumeMl,
    this.alcoholPercentage,
    this.isPremium = false,
    this.canAddIce = false,
    this.canCustomizeStrength = false,
    this.sodiumPer100ml = 0,
    this.potassiumPer100ml = 0,
    this.magnesiumPer100ml = 0,
    this.caffeineMgPer100ml,
    this.sugarGramsPer100ml,
    this.hydrationCoefficient = 1.0,
  });
  
  /// Получить локализованное название напитка
  /// В arb файлах должны быть ключи типа: drink_water, drink_coffee и т.д.
  String getLocalizedName(dynamic l10n) {
    // Используем рефлексию для получения локализованного значения
    // В реальном коде нужно будет добавить все ключи в AppLocalizations
    try {
      // Пытаемся получить свойство по имени ключа
      return l10n.toJson()[nameKey] ?? nameKey.replaceAll('_', ' ');
    } catch (e) {
      // Если не удалось, возвращаем форматированный ID
      return nameKey.replaceAll('drink_', '').replaceAll('_', ' ');
    }
  }
}

/// База данных всех напитков (50+ типов)
class DrinkDatabase {
  static const List<DrinkType> allDrinks = [
    // ===== ВОДА И БАЗОВЫЕ НАПИТКИ (FREE) =====
    DrinkType(
      id: 'water',
      nameKey: 'drink_water',
      category: DrinkCategory.water,
      emoji: '💧',
      defaultVolumeMl: 250,
      hydrationCoefficient: 1.0,
    ),
    DrinkType(
      id: 'sparkling_water',
      nameKey: 'drink_sparkling_water',
      category: DrinkCategory.water,
      emoji: '🫧',
      defaultVolumeMl: 250,
      hydrationCoefficient: 1.0,
    ),
    DrinkType(
      id: 'mineral_water',
      nameKey: 'drink_mineral_water',
      category: DrinkCategory.water,
      emoji: '💎',
      defaultVolumeMl: 250,
      sodiumPer100ml: 20,
      potassiumPer100ml: 5,
      magnesiumPer100ml: 10,
      hydrationCoefficient: 1.0,
    ),
    DrinkType(
      id: 'coconut_water',
      nameKey: 'drink_coconut_water',
      category: DrinkCategory.water,
      emoji: '🥥',
      defaultVolumeMl: 250,
      sodiumPer100ml: 105,
      potassiumPer100ml: 250,
      magnesiumPer100ml: 25,
      hydrationCoefficient: 1.1,
      isPremium: true,
    ),
    
    // ===== ГОРЯЧИЕ НАПИТКИ =====
    DrinkType(
      id: 'coffee',
      nameKey: 'drink_coffee',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 200,
      caffeineMgPer100ml: 40,
      hydrationCoefficient: 0.8,
      canCustomizeStrength: true,
    ),
    DrinkType(
      id: 'espresso',
      nameKey: 'drink_espresso',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 30,
      caffeineMgPer100ml: 212,
      hydrationCoefficient: 0.7,
    ),
    DrinkType(
      id: 'americano',
      nameKey: 'drink_americano',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 250,
      caffeineMgPer100ml: 40,
      hydrationCoefficient: 0.85,
      isPremium: true,
    ),
    DrinkType(
      id: 'cappuccino',
      nameKey: 'drink_cappuccino',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 180,
      caffeineMgPer100ml: 40,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'latte',
      nameKey: 'drink_latte',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 300,
      caffeineMgPer100ml: 30,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'black_tea',
      nameKey: 'drink_black_tea',
      category: DrinkCategory.hotDrinks,
      emoji: '🍵',
      defaultVolumeMl: 250,
      caffeineMgPer100ml: 20,
      hydrationCoefficient: 0.95,
    ),
    DrinkType(
      id: 'green_tea',
      nameKey: 'drink_green_tea',
      category: DrinkCategory.hotDrinks,
      emoji: '🍵',
      defaultVolumeMl: 250,
      caffeineMgPer100ml: 12,
      hydrationCoefficient: 0.98,
      isPremium: true,
    ),
    DrinkType(
      id: 'herbal_tea',
      nameKey: 'drink_herbal_tea',
      category: DrinkCategory.hotDrinks,
      emoji: '🌿',
      defaultVolumeMl: 250,
      hydrationCoefficient: 1.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'matcha',
      nameKey: 'drink_matcha',
      category: DrinkCategory.hotDrinks,
      emoji: '🍵',
      defaultVolumeMl: 200,
      caffeineMgPer100ml: 35,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'hot_chocolate',
      nameKey: 'drink_hot_chocolate',
      category: DrinkCategory.hotDrinks,
      emoji: '☕',
      defaultVolumeMl: 250,
      caffeineMgPer100ml: 5,
      sugarGramsPer100ml: 12,
      hydrationCoefficient: 0.85,
      isPremium: true,
    ),
    
    // ===== СОКИ И СМУЗИ (PREMIUM) =====
    DrinkType(
      id: 'orange_juice',
      nameKey: 'drink_orange_juice',
      category: DrinkCategory.juice,
      emoji: '🍊',
      defaultVolumeMl: 250,
      potassiumPer100ml: 200,
      sugarGramsPer100ml: 8.4,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'apple_juice',
      nameKey: 'drink_apple_juice',
      category: DrinkCategory.juice,
      emoji: '🍎',
      defaultVolumeMl: 250,
      potassiumPer100ml: 101,
      sugarGramsPer100ml: 9.6,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'grapefruit_juice',
      nameKey: 'drink_grapefruit_juice',
      category: DrinkCategory.juice,
      emoji: '🍊',
      defaultVolumeMl: 250,
      potassiumPer100ml: 162,
      sugarGramsPer100ml: 7.3,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'tomato_juice',
      nameKey: 'drink_tomato_juice',
      category: DrinkCategory.juice,
      emoji: '🍅',
      defaultVolumeMl: 250,
      sodiumPer100ml: 280,
      potassiumPer100ml: 229,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'vegetable_juice',
      nameKey: 'drink_vegetable_juice',
      category: DrinkCategory.juice,
      emoji: '🥕',
      defaultVolumeMl: 250,
      sodiumPer100ml: 190,
      potassiumPer100ml: 180,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'smoothie',
      nameKey: 'drink_smoothie',
      category: DrinkCategory.juice,
      emoji: '🥤',
      defaultVolumeMl: 300,
      potassiumPer100ml: 150,
      sugarGramsPer100ml: 10,
      hydrationCoefficient: 0.85,
      isPremium: true,
    ),
    DrinkType(
      id: 'lemonade',
      nameKey: 'drink_lemonade',
      category: DrinkCategory.juice,
      emoji: '🍋',
      defaultVolumeMl: 250,
      sugarGramsPer100ml: 10,
      hydrationCoefficient: 0.9,
      isPremium: true,
      canAddIce: true,
    ),
    
    // ===== СПОРТИВНЫЕ НАПИТКИ (PREMIUM) =====
    DrinkType(
      id: 'isotonic',
      nameKey: 'drink_isotonic',
      category: DrinkCategory.sports,
      emoji: '⚡',
      defaultVolumeMl: 500,
      sodiumPer100ml: 45,
      potassiumPer100ml: 12.5,
      sugarGramsPer100ml: 6,
      hydrationCoefficient: 1.2,
      isPremium: true,
    ),
    DrinkType(
      id: 'electrolyte_drink',
      nameKey: 'drink_electrolyte',
      category: DrinkCategory.sports,
      emoji: '💪',
      defaultVolumeMl: 500,
      sodiumPer100ml: 100,
      potassiumPer100ml: 50,
      magnesiumPer100ml: 15,
      hydrationCoefficient: 1.3,
      isPremium: true,
    ),
    DrinkType(
      id: 'protein_shake',
      nameKey: 'drink_protein_shake',
      category: DrinkCategory.sports,
      emoji: '🥤',
      defaultVolumeMl: 400,
      potassiumPer100ml: 100,
      hydrationCoefficient: 0.8,
      isPremium: true,
    ),
    DrinkType(
      id: 'bcaa_drink',
      nameKey: 'drink_bcaa',
      category: DrinkCategory.sports,
      emoji: '💊',
      defaultVolumeMl: 500,
      hydrationCoefficient: 1.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'energy_drink',
      nameKey: 'drink_energy',
      category: DrinkCategory.sports,
      emoji: '⚡',
      defaultVolumeMl: 250,
      caffeineMgPer100ml: 32,
      sodiumPer100ml: 40,
      sugarGramsPer100ml: 11,
      hydrationCoefficient: 0.7,
      isPremium: true,
    ),
    
    // ===== МОЛОЧНЫЕ ПРОДУКТЫ (PREMIUM) =====
    DrinkType(
      id: 'milk',
      nameKey: 'drink_milk',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 250,
      sodiumPer100ml: 44,
      potassiumPer100ml: 150,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'kefir',
      nameKey: 'drink_kefir',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 250,
      sodiumPer100ml: 40,
      potassiumPer100ml: 140,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'yogurt_drink',
      nameKey: 'drink_yogurt',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 200,
      sodiumPer100ml: 45,
      potassiumPer100ml: 141,
      hydrationCoefficient: 0.85,
      isPremium: true,
    ),
    DrinkType(
      id: 'almond_milk',
      nameKey: 'drink_almond_milk',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 250,
      sodiumPer100ml: 70,
      potassiumPer100ml: 35,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'soy_milk',
      nameKey: 'drink_soy_milk',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 250,
      sodiumPer100ml: 51,
      potassiumPer100ml: 118,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'oat_milk',
      nameKey: 'drink_oat_milk',
      category: DrinkCategory.dairy,
      emoji: '🥛',
      defaultVolumeMl: 250,
      sodiumPer100ml: 40,
      potassiumPer100ml: 120,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    
    // ===== АЛКОГОЛЬНЫЕ НАПИТКИ (PREMIUM) =====
    DrinkType(
      id: 'beer_light',
      nameKey: 'drink_beer_light',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.beer,
      emoji: '🍺',
      defaultVolumeMl: 500,
      alcoholPercentage: 4.5,
      sodiumPer100ml: 4,
      potassiumPer100ml: 27,
      hydrationCoefficient: 0.3,
      isPremium: true,
    ),
    DrinkType(
      id: 'beer_regular',
      nameKey: 'drink_beer_regular',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.beer,
      emoji: '🍺',
      defaultVolumeMl: 500,
      alcoholPercentage: 5.0,
      sodiumPer100ml: 4,
      potassiumPer100ml: 27,
      hydrationCoefficient: 0.25,
      isPremium: true,
    ),
    DrinkType(
      id: 'beer_strong',
      nameKey: 'drink_beer_strong',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.beer,
      emoji: '🍺',
      defaultVolumeMl: 330,
      alcoholPercentage: 7.0,
      hydrationCoefficient: 0.2,
      isPremium: true,
    ),
    DrinkType(
      id: 'wine_red',
      nameKey: 'drink_wine_red',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.wine,
      emoji: '🍷',
      defaultVolumeMl: 150,
      alcoholPercentage: 13.0,
      potassiumPer100ml: 127,
      hydrationCoefficient: 0.15,
      isPremium: true,
    ),
    DrinkType(
      id: 'wine_white',
      nameKey: 'drink_wine_white',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.wine,
      emoji: '🥂',
      defaultVolumeMl: 150,
      alcoholPercentage: 12.0,
      potassiumPer100ml: 71,
      hydrationCoefficient: 0.15,
      isPremium: true,
    ),
    DrinkType(
      id: 'champagne',
      nameKey: 'drink_champagne',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.wine,
      emoji: '🍾',
      defaultVolumeMl: 150,
      alcoholPercentage: 12.0,
      hydrationCoefficient: 0.15,
      isPremium: true,
    ),
    DrinkType(
      id: 'vodka',
      nameKey: 'drink_vodka',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.spirits,
      emoji: '🥃',
      defaultVolumeMl: 50,
      alcoholPercentage: 40.0,
      hydrationCoefficient: 0.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'whiskey',
      nameKey: 'drink_whiskey',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.spirits,
      emoji: '🥃',
      defaultVolumeMl: 50,
      alcoholPercentage: 40.0,
      hydrationCoefficient: 0.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'rum',
      nameKey: 'drink_rum',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.spirits,
      emoji: '🥃',
      defaultVolumeMl: 50,
      alcoholPercentage: 40.0,
      hydrationCoefficient: 0.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'gin',
      nameKey: 'drink_gin',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.spirits,
      emoji: '🥃',
      defaultVolumeMl: 50,
      alcoholPercentage: 40.0,
      hydrationCoefficient: 0.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'tequila',
      nameKey: 'drink_tequila',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.spirits,
      emoji: '🥃',
      defaultVolumeMl: 50,
      alcoholPercentage: 40.0,
      hydrationCoefficient: 0.0,
      isPremium: true,
    ),
    DrinkType(
      id: 'cocktail_mojito',
      nameKey: 'drink_mojito',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.cocktails,
      emoji: '🍹',
      defaultVolumeMl: 250,
      alcoholPercentage: 10.0,
      hydrationCoefficient: 0.3,
      isPremium: true,
    ),
    DrinkType(
      id: 'cocktail_margarita',
      nameKey: 'drink_margarita',
      category: DrinkCategory.alcohol,
      alcoholSubCategory: AlcoholSubCategory.cocktails,
      emoji: '🍹',
      defaultVolumeMl: 200,
      alcoholPercentage: 15.0,
      hydrationCoefficient: 0.2,
      isPremium: true,
    ),
    
    // ===== ДРУГИЕ НАПИТКИ (PREMIUM) =====
    DrinkType(
      id: 'kombucha',
      nameKey: 'drink_kombucha',
      category: DrinkCategory.other,
      emoji: '🫖',
      defaultVolumeMl: 250,
      hydrationCoefficient: 0.95,
      isPremium: true,
    ),
    DrinkType(
      id: 'kvass',
      nameKey: 'drink_kvass',
      category: DrinkCategory.other,
      emoji: '🍺',
      defaultVolumeMl: 250,
      alcoholPercentage: 1.2,
      hydrationCoefficient: 0.9,
      isPremium: true,
    ),
    DrinkType(
      id: 'bone_broth',
      nameKey: 'drink_bone_broth',
      category: DrinkCategory.other,
      emoji: '🍲',
      defaultVolumeMl: 250,
      sodiumPer100ml: 200,
      potassiumPer100ml: 100,
      hydrationCoefficient: 1.1,
      isPremium: true,
    ),
    DrinkType(
      id: 'vegetable_broth',
      nameKey: 'drink_vegetable_broth',
      category: DrinkCategory.other,
      emoji: '🍲',
      defaultVolumeMl: 250,
      sodiumPer100ml: 150,
      potassiumPer100ml: 80,
      hydrationCoefficient: 1.1,
      isPremium: true,
    ),
    DrinkType(
      id: 'soda',
      nameKey: 'drink_soda',
      category: DrinkCategory.other,
      emoji: '🥤',
      defaultVolumeMl: 330,
      sodiumPer100ml: 15,
      sugarGramsPer100ml: 10.6,
      hydrationCoefficient: 0.8,
      isPremium: true,
      canAddIce: true,
    ),
    DrinkType(
      id: 'diet_soda',
      nameKey: 'drink_diet_soda',
      category: DrinkCategory.other,
      emoji: '🥤',
      defaultVolumeMl: 330,
      sodiumPer100ml: 15,
      hydrationCoefficient: 0.85,
      isPremium: true,
      canAddIce: true,
    ),
  ];
  
  /// Получить все напитки по категории
  static List<DrinkType> getDrinksByCategory(DrinkCategory category) {
    return allDrinks.where((drink) => drink.category == category).toList();
  }
  
  /// Получить все бесплатные напитки
  static List<DrinkType> getFreeDrinks() {
    return allDrinks.where((drink) => !drink.isPremium).toList();
  }
  
  /// Получить все премиум напитки
  static List<DrinkType> getPremiumDrinks() {
    return allDrinks.where((drink) => drink.isPremium).toList();
  }
  
  /// Найти напиток по ID
  static DrinkType? findById(String id) {
    try {
      return allDrinks.firstWhere((drink) => drink.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Поиск напитков по названию (для поиска)
  static List<DrinkType> searchDrinks(String query, String locale) {
    // Здесь нужно будет искать по локализованным названиям
    // Пока простой поиск по ID
    final lowerQuery = query.toLowerCase();
    return allDrinks.where((drink) => 
      drink.id.toLowerCase().contains(lowerQuery) ||
      drink.nameKey.toLowerCase().contains(lowerQuery)
    ).toList();
  }
  
  /// Получить популярные напитки (для быстрого доступа)
  static List<DrinkType> getPopularDrinks() {
    return [
      findById('water')!,
      findById('coffee')!,
      findById('black_tea')!,
      findById('electrolyte_drink')!,
      findById('coconut_water')!,
    ];
  }
}