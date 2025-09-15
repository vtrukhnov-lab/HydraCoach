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

  /// Получить алкоголь по типу
  List<CatalogItem> getAlcoholItems({String? type}) {
    if (type == null) {
      return AlcoholItems.getAllItems();
    }
    return AlcoholItems.getByType(type);
  }

  /// Получить быстрые объемы для горячих напитков
  List<int> getHotDrinkQuickVolumes(String drinkType, String units) {
    return HotDrinkItems.getQuickVolumes(drinkType, units);
  }

  /// Получить быстрые дозировки для добавок
  List<int> getSupplementQuickDosages(String supplementType, String units) {
    return SupplementItems.getQuickDosages(supplementType, units);
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
}