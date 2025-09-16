// lib/data/items_catalog.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'catalog_item.dart';
import 'items/water_items.dart';
import 'items/electrolyte_items.dart';
import 'items/hot_drink_items.dart';
import 'items/alcohol_items.dart';
import 'items/sport_items.dart';
import 'items/supplement_items.dart';

/// Enum для категорий элементов
enum ItemCategory {
  water,
  electrolyte,
  hotDrink,
  alcohol,
  sport,
  supplement,
}

/// Централизованный каталог всех элементов
class ItemsCatalog {
  static final ItemsCatalog _instance = ItemsCatalog._internal();
  factory ItemsCatalog() => _instance;
  ItemsCatalog._internal();

  /// Получить элементы для категории
  List<CatalogItem> getItemsForCategory(ItemCategory category) {
    switch (category) {
      case ItemCategory.water:
        return WaterItems.getAllItems();
      case ItemCategory.electrolyte:
        return ElectrolyteItems.getAllItems();
      case ItemCategory.hotDrink:
        return HotDrinkItems.getAllItems();
      case ItemCategory.alcohol:
        return AlcoholItems.getAllItems();
      case ItemCategory.sport:
        return SportItems.getAllItems();
      case ItemCategory.supplement:
        return SupplementItems.getAllItems();
    }
  }

  /// Получить элемент по ID из всех категорий
  CatalogItem? getItemById(String id) {
    final allItems = [
      ...WaterItems.getAllItems(),
      ...ElectrolyteItems.getAllItems(),
      ...HotDrinkItems.getAllItems(),
      ...AlcoholItems.getAllItems(),
      ...SportItems.getAllItems(),
      ...SupplementItems.getAllItems(),
    ];
    
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Получить воду по подтипу
  List<CatalogItem> getWaterItems({String? subtype}) {
    if (subtype == null) {
      return WaterItems.getAllItems();
    }
    
    switch (subtype) {
      case 'plain':
        return WaterItems.getPlainWater();
      case 'enhanced':
        return WaterItems.getEnhancedWater();
      case 'beverages':
        return WaterItems.getBeverages();
      case 'sodas':
        return WaterItems.getSodas();
      default:
        return WaterItems.getAllItems();
    }
  }

  /// Получить электролиты по подтипу
  List<CatalogItem> getElectrolyteItems({String? subtype}) {
    if (subtype == null) {
      return ElectrolyteItems.getAllItems();
    }
    
    switch (subtype) {
      case 'basic':
        return ElectrolyteItems.getBasicElectrolytes();
      case 'mixes':
        return ElectrolyteItems.getElectrolyteMixes();
      default:
        return ElectrolyteItems.getAllItems();
    }
  }

  /// Получить горячие напитки по подтипу
  List<CatalogItem> getHotDrinkItems({String? subtype}) {
    if (subtype == null) {
      return HotDrinkItems.getAllItems();
    }
    
    // Фильтруем все items по типу
    final allItems = HotDrinkItems.getAllItems();
    
    switch (subtype) {
      case 'coffee':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('coffee') || 
            type.contains('espresso') || 
            type.contains('cappuccino') || 
            type.contains('latte') ||
            type.contains('americano') ||
            type.contains('macchiato') ||
            type.contains('mocha') ||
            type.contains('flat_white') ||
            type.contains('decaf') ||
            type.contains('turkish')
          );
        }).toList();
        
      case 'tea':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('tea') || 
            type.contains('matcha') ||
            type.contains('chai') ||
            type.contains('earl') ||
            type.contains('chamomile') ||
            type.contains('peppermint') ||
            type.contains('rooibos') ||
            type.contains('oolong')
          );
        }).toList();
        
      case 'other':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('chocolate') ||
            type.contains('cocoa') ||
            type.contains('turmeric') ||
            type.contains('cider') ||
            type.contains('ginger') ||
            type.contains('lemon') ||
            type.contains('hot_water')
          );
        }).toList();
        
      default:
        return allItems;
    }
  }

  /// Получить алкоголь по типу
  List<CatalogItem> getAlcoholItems({String? type}) {
    if (type == null) {
      return AlcoholItems.getAllItems();
    }
    return AlcoholItems.getByType(type);
  }

  /// Получить спорт по подтипу
  List<CatalogItem> getSportItems({String? subtype}) {
    if (subtype == null) {
      return SportItems.getAllItems();
    }
    
    // Фильтруем по интенсивности
    final allItems = SportItems.getAllItems();
    
    switch (subtype) {
      case 'low':
        return allItems.where((item) {
          final intensity = item.properties['intensity'] as String?;
          return intensity == 'low';
        }).toList();
      case 'medium':
        return allItems.where((item) {
          final intensity = item.properties['intensity'] as String?;
          return intensity == 'medium';
        }).toList();
      case 'high':
        return allItems.where((item) {
          final intensity = item.properties['intensity'] as String?;
          return intensity == 'high' || intensity == 'very_high';
        }).toList();
      default:
        return allItems;
    }
  }

  /// Получить добавки по подтипу
  List<CatalogItem> getSupplementItems({String? subtype}) {
    if (subtype == null) {
      return SupplementItems.getAllItems();
    }
    
    // Фильтруем все items по типу
    final allItems = SupplementItems.getAllItems();
    
    switch (subtype) {
      case 'minerals':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('magnesium') || 
            type.contains('potassium') || 
            type.contains('calcium') ||
            type.contains('zinc') ||
            type.contains('iron')
          );
        }).toList();
        
      case 'vitamins':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('vitamin') || 
            type.contains('multivitamin') ||
            type.contains('b_complex')
          );
        }).toList();
        
      case 'other':
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('omega') || 
            !type.contains('magnesium') && 
            !type.contains('potassium') && 
            !type.contains('calcium') &&
            !type.contains('zinc') &&
            !type.contains('iron') &&
            !type.contains('vitamin') &&
            !type.contains('multivitamin') &&
            !type.contains('b_complex')
          );
        }).toList();
        
      default:
        return allItems;
    }
  }

  /// Получить быстрые объемы для воды
  List<int> getWaterQuickVolumes(String units) {
    if (units == 'imperial') {
      return [8, 12, 16]; // oz
    } else {
      return [200, 250, 500]; // ml
    }
  }

  /// Получить быстрые объемы для горячих напитков
  List<int> getHotDrinkQuickVolumes(String drinkType, String units) {
    return HotDrinkItems.getQuickVolumes(drinkType, units);
  }

  /// Получить быстрые дозировки для добавок
  List<int> getSupplementQuickDosages(String supplementType, String units) {
    return SupplementItems.getQuickDosages(supplementType, units);
  }

  /// Получить быстрые объемы для алкоголя
  List<int> getAlcoholQuickVolumes(String alcoholType, String units) {
    if (units == 'imperial') {
      switch (alcoholType) {
        case 'beer':
          return [12, 16, 20]; // oz
        case 'wine':
          return [4, 5, 6]; // oz
        case 'spirits':
          return [1, 2, 3]; // oz
        case 'cocktail':
          return [6, 8, 10]; // oz
        default:
          return [4, 8, 12]; // oz
      }
    } else {
      switch (alcoholType) {
        case 'beer':
          return [330, 500, 568]; // ml
        case 'wine':
          return [125, 150, 175]; // ml
        case 'spirits':
          return [30, 50, 60]; // ml
        case 'cocktail':
          return [200, 250, 300]; // ml
        default:
          return [100, 200, 300]; // ml
      }
    }
  }

  /// Получить описание интенсивности спорта
  String getSportIntensityLabel(String intensity, AppLocalizations l10n) {
    return SportItems.getIntensityLabel(intensity, l10n);
  }

  /// Получить цвет интенсивности спорта
  Color getSportIntensityColor(String intensity) {
    return SportItems.getIntensityColor(intensity);
  }

  /// Поиск элементов по названию
  List<CatalogItem> searchItems(String query, AppLocalizations l10n) {
    if (query.isEmpty) return [];
    
    final allItems = [
      ...WaterItems.getAllItems(),
      ...ElectrolyteItems.getAllItems(),
      ...HotDrinkItems.getAllItems(),
      ...AlcoholItems.getAllItems(),
      ...SportItems.getAllItems(),
      ...SupplementItems.getAllItems(),
    ];
    
    final lowercaseQuery = query.toLowerCase();
    
    return allItems.where((item) {
      final name = item.getName(l10n).toLowerCase();
      return name.contains(lowercaseQuery);
    }).toList();
  }

  /// Поиск по категории с фильтром
  List<CatalogItem> searchInCategory({
    required ItemCategory category,
    required String query,
    required AppLocalizations l10n,
    bool proOnly = false,
    bool freeOnly = false,
  }) {
    final items = getItemsForCategory(category);
    
    if (query.isEmpty && !proOnly && !freeOnly) {
      return items;
    }
    
    final lowercaseQuery = query.toLowerCase();
    
    return items.where((item) {
      // Проверка PRO/FREE фильтров
      if (proOnly && !item.isPro) return false;
      if (freeOnly && item.isPro) return false;
      
      // Проверка поиска
      if (query.isNotEmpty) {
        final name = item.getName(l10n).toLowerCase();
        if (!name.contains(lowercaseQuery)) return false;
      }
      
      return true;
    }).toList();
  }

  /// Получить количество PRO элементов в категории
  int getProItemsCount(ItemCategory category) {
    final items = getItemsForCategory(category);
    return items.where((item) => item.isPro).length;
  }

  /// Получить количество бесплатных элементов в категории
  int getFreeItemsCount(ItemCategory category) {
    final items = getItemsForCategory(category);
    return items.where((item) => !item.isPro).length;
  }

  /// Получить статистику по категории
  Map<String, int> getCategoryStats(ItemCategory category) {
    final items = getItemsForCategory(category);
    final proCount = items.where((item) => item.isPro).length;
    final freeCount = items.where((item) => !item.isPro).length;
    
    return {
      'total': items.length,
      'pro': proCount,
      'free': freeCount,
    };
  }

  /// Получить все категории с их названиями
  Map<ItemCategory, String> getCategoriesWithNames(AppLocalizations l10n) {
    return {
      ItemCategory.water: l10n.water,
      ItemCategory.electrolyte: l10n.electrolyte,
      ItemCategory.hotDrink: l10n.hotDrinks,
      ItemCategory.alcohol: l10n.alcohol,
      ItemCategory.sport: l10n.sports,
      ItemCategory.supplement: l10n.supplements,
    };
  }

  /// Проверить, есть ли элемент с таким ID
  bool hasItem(String id) {
    return getItemById(id) != null;
  }

  /// Получить случайный элемент из категории
  CatalogItem? getRandomItem({
    ItemCategory? category,
    bool? isPro,
  }) {
    List<CatalogItem> items;
    
    if (category != null) {
      items = getItemsForCategory(category);
    } else {
      items = [
        ...WaterItems.getAllItems(),
        ...ElectrolyteItems.getAllItems(),
        ...HotDrinkItems.getAllItems(),
        ...AlcoholItems.getAllItems(),
        ...SportItems.getAllItems(),
        ...SupplementItems.getAllItems(),
      ];
    }
    
    if (isPro != null) {
      items = items.where((item) => item.isPro == isPro).toList();
    }
    
    if (items.isEmpty) return null;
    
    final random = items..shuffle();
    return random.first;
  }

  /// Получить элементы с электролитами
  List<CatalogItem> getItemsWithElectrolytes() {
    final allItems = <CatalogItem>[];
    
    // Все электролиты содержат электролиты
    allItems.addAll(ElectrolyteItems.getAllItems());
    
    // Добавки-минералы могут содержать электролиты
    final supplements = SupplementItems.getAllItems();
    for (final item in supplements) {
      final sodium = item.properties['sodium'] ?? 0;
      final potassium = item.properties['potassium'] ?? 0;
      final magnesium = item.properties['magnesium'] ?? 0;
      if ((sodium as int) > 0 || (potassium as int) > 0 || (magnesium as int) > 0) {
        allItems.add(item);
      }
    }
    
    // Некоторая вода может содержать электролиты
    final enhancedWater = WaterItems.getEnhancedWater();
    for (final item in enhancedWater) {
      final sodium = item.properties['sodium'] ?? 0;
      final potassium = item.properties['potassium'] ?? 0;
      final magnesium = item.properties['magnesium'] ?? 0;
      if ((sodium as int) > 0 || (potassium as int) > 0 || (magnesium as int) > 0) {
        allItems.add(item);
      }
    }
    
    return allItems;
  }

  /// Получить элементы с кофеином
  List<CatalogItem> getItemsWithCaffeine() {
    final allItems = <CatalogItem>[];
    
    // Горячие напитки с кофеином
    final hotDrinks = HotDrinkItems.getAllItems();
    for (final item in hotDrinks) {
      final caffeine = item.properties['caffeineMgPer100ml'] ?? 0;
      if ((caffeine as int) > 0) {
        allItems.add(item);
      }
    }
    
    // Газировки с кофеином (энергетики)
    final sodas = WaterItems.getSodas();
    for (final item in sodas) {
      final caffeine = item.properties['caffeineMgPer100ml'] ?? 0;
      if ((caffeine as int) > 0) {
        allItems.add(item);
      }
    }
    
    return allItems;
  }

  /// Получить элементы с сахаром
  List<CatalogItem> getItemsWithSugar() {
    final allItems = <CatalogItem>[];
    
    // Алкоголь с сахаром
    final alcohol = AlcoholItems.getAllItems();
    for (final item in alcohol) {
      final sugar = item.properties['sugar'] ?? 0.0;
      if ((sugar as double) > 0) {
        allItems.add(item);
      }
    }
    
    // Газировки
    allItems.addAll(WaterItems.getSodas());
    
    // Напитки с сахаром
    final beverages = WaterItems.getBeverages();
    for (final item in beverages) {
      final sugar = item.properties['sugar'] ?? 0.0;
      if ((sugar as double) > 0) {
        allItems.add(item);
      }
    }
    
    // Горячие напитки с сахаром
    final hotDrinks = HotDrinkItems.getAllItems();
    for (final item in hotDrinks) {
      final sugar = item.properties['sugar'] ?? 0.0;
      if ((sugar as double) > 0) {
        allItems.add(item);
      }
    }
    
    return allItems;
  }
}