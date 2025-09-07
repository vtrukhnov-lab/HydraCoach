import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/drink_database.dart';
import '../constants/supplements_database.dart';

/// Модель избранного напитка с сохраненными настройками
class FavoriteDrink {
  final String id;
  final String drinkId; // ID из DrinkDatabase
  final String? customName; // Пользовательское название
  final double defaultVolumeMl; // Предпочитаемый объем
  final List<String> defaultSupplementIds; // Предпочитаемые добавки
  final bool hasIce; // Со льдом по умолчанию
  final int sortOrder; // Порядок в списке
  final DateTime addedAt; // Когда добавлен в избранное
  
  FavoriteDrink({
    String? id,
    required this.drinkId,
    this.customName,
    required this.defaultVolumeMl,
    this.defaultSupplementIds = const [],
    this.hasIce = false,
    int? sortOrder,
    DateTime? addedAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       sortOrder = sortOrder ?? 999,
       addedAt = addedAt ?? DateTime.now();
  
  /// Получить название (пользовательское или из базы)
  String getDisplayName() {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    
    final drink = DrinkDatabase.findById(drinkId);
    if (drink != null) {
      // TODO: Локализовать через nameKey
      return drinkId.replaceAll('_', ' ').toUpperCase();
    }
    
    return drinkId;
  }
  
  /// Получить эмодзи напитка
  String get emoji {
    final drink = DrinkDatabase.findById(drinkId);
    return drink?.emoji ?? '🥤';
  }
  
  /// Проверить премиум статус
  bool get isPremium {
    final drink = DrinkDatabase.findById(drinkId);
    if (drink?.isPremium == true) return true;
    
    // Проверяем добавки
    for (String supplementId in defaultSupplementIds) {
      final supplement = SupplementDatabase.findById(supplementId);
      if (supplement?.isPremium == true) return true;
    }
    
    return false;
  }
  
  /// Конвертация в JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'drinkId': drinkId,
    'customName': customName,
    'defaultVolumeMl': defaultVolumeMl,
    'defaultSupplementIds': defaultSupplementIds,
    'hasIce': hasIce,
    'sortOrder': sortOrder,
    'addedAt': addedAt.toIso8601String(),
  };
  
  /// Создание из JSON
  factory FavoriteDrink.fromJson(Map<String, dynamic> json) {
    return FavoriteDrink(
      id: json['id'],
      drinkId: json['drinkId'],
      customName: json['customName'],
      defaultVolumeMl: json['defaultVolumeMl'].toDouble(),
      defaultSupplementIds: List<String>.from(json['defaultSupplementIds'] ?? []),
      hasIce: json['hasIce'] ?? false,
      sortOrder: json['sortOrder'] ?? 999,
      addedAt: json['addedAt'] != null 
          ? DateTime.parse(json['addedAt']) 
          : DateTime.now(),
    );
  }
  
  /// Копирование с изменениями
  FavoriteDrink copyWith({
    String? customName,
    double? defaultVolumeMl,
    List<String>? defaultSupplementIds,
    bool? hasIce,
    int? sortOrder,
  }) {
    return FavoriteDrink(
      id: id,
      drinkId: drinkId,
      customName: customName ?? this.customName,
      defaultVolumeMl: defaultVolumeMl ?? this.defaultVolumeMl,
      defaultSupplementIds: defaultSupplementIds ?? this.defaultSupplementIds,
      hasIce: hasIce ?? this.hasIce,
      sortOrder: sortOrder ?? this.sortOrder,
      addedAt: addedAt,
    );
  }
}

/// Менеджер избранных напитков
class FavoriteDrinksManager {
  static const String _storageKey = 'favorite_drinks';
  static const int _maxFreeFavorites = 3;
  static const int _maxProFavorites = 20;
  
  List<FavoriteDrink> _favorites = [];
  bool _isProUser = false;
  
  List<FavoriteDrink> get favorites => List.unmodifiable(_favorites);
  
  /// Инициализация - загрузка из SharedPreferences
  Future<void> init(bool isProUser) async {
    _isProUser = isProUser;
    await loadFavorites();
  }
  
  /// Загрузка избранного из хранилища
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _favorites = jsonList
            .map((json) => FavoriteDrink.fromJson(json))
            .toList();
        
        // Сортируем по sortOrder
        _favorites.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      } catch (e) {
        print('Error loading favorites: $e');
        _favorites = [];
      }
    }
  }
  
  /// Сохранение избранного
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favorites.map((f) => f.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
  
  /// Добавить в избранное
  Future<bool> addFavorite(FavoriteDrink favorite) async {
    // Проверка лимита
    final maxFavorites = _isProUser ? _maxProFavorites : _maxFreeFavorites;
    if (_favorites.length >= maxFavorites) {
      return false; // Достигнут лимит
    }
    
    // Проверка на дубликат
    if (_favorites.any((f) => f.drinkId == favorite.drinkId && 
                              f.customName == favorite.customName)) {
      return false; // Уже существует
    }
    
    // Устанавливаем sortOrder
    final newFavorite = favorite.copyWith(
      sortOrder: _favorites.isEmpty ? 0 : _favorites.last.sortOrder + 1,
    );
    
    _favorites.add(newFavorite);
    await saveFavorites();
    return true;
  }
  
  /// Удалить из избранного
  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    await saveFavorites();
  }
  
  /// Обновить избранное
  Future<void> updateFavorite(String id, FavoriteDrink updated) async {
    final index = _favorites.indexWhere((f) => f.id == id);
    if (index != -1) {
      _favorites[index] = updated;
      await saveFavorites();
    }
  }
  
  /// Переупорядочить избранное
  Future<void> reorderFavorites(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = _favorites.removeAt(oldIndex);
    _favorites.insert(newIndex, item);
    
    // Обновляем sortOrder
    for (int i = 0; i < _favorites.length; i++) {
      _favorites[i] = _favorites[i].copyWith(sortOrder: i);
    }
    
    await saveFavorites();
  }
  
  /// Проверить, является ли напиток избранным
  bool isFavorite(String drinkId) {
    return _favorites.any((f) => f.drinkId == drinkId);
  }
  
  /// Получить избранное для напитка
  FavoriteDrink? getFavoriteByDrinkId(String drinkId) {
    try {
      return _favorites.firstWhere((f) => f.drinkId == drinkId);
    } catch (_) {
      return null;
    }
  }
  
  /// Получить популярные предустановки (для быстрого старта)
  static List<FavoriteDrink> getPresets() {
    return [
      FavoriteDrink(
        drinkId: 'water',
        customName: 'Morning Water',
        defaultVolumeMl: 500,
        defaultSupplementIds: ['salt_regular'],
      ),
      FavoriteDrink(
        drinkId: 'coffee',
        customName: 'My Coffee',
        defaultVolumeMl: 200,
        defaultSupplementIds: [],
      ),
      FavoriteDrink(
        drinkId: 'electrolyte_drink',
        customName: 'Workout Mix',
        defaultVolumeMl: 500,
        defaultSupplementIds: ['lmnt'],
      ),
    ];
  }
  
  /// Получить количество доступных слотов
  int getAvailableSlots() {
    final maxFavorites = _isProUser ? _maxProFavorites : _maxFreeFavorites;
    return maxFavorites - _favorites.length;
  }
  
  /// Проверить достигнут ли лимит
  bool isLimitReached() {
    final maxFavorites = _isProUser ? _maxProFavorites : _maxFreeFavorites;
    return _favorites.length >= maxFavorites;
  }
}