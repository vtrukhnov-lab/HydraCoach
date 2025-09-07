import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Быстрый фаворит для главного экрана
class QuickFavorite {
  final String id;
  final String type; // water, electrolyte, alcohol, supplement, hot
  final String label;
  final String emoji;
  final int? volumeMl;
  final int? sodiumMg;
  final int? potassiumMg;
  final int? magnesiumMg;
  final Map<String, dynamic>? metadata; // Переименовано с customData для совместимости с quick_add_widget

QuickFavorite({
  required this.id,
  required this.type,
  required this.label,
  required this.emoji,
  this.volumeMl,
  this.sodiumMg,
  this.potassiumMg,
  this.magnesiumMg,
  Map<String, dynamic>? metadata,  // Убрали this.
  Map<String, dynamic>? customData, // Для обратной совместимости
}) : metadata = metadata ?? customData;  // Теперь инициализация только здесь

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'label': label,
    'emoji': emoji,
    if (volumeMl != null) 'volumeMl': volumeMl,
    if (sodiumMg != null) 'sodiumMg': sodiumMg,
    if (potassiumMg != null) 'potassiumMg': potassiumMg,
    if (magnesiumMg != null) 'magnesiumMg': magnesiumMg,
    if (metadata != null) 'metadata': metadata,
    // Сохраняем и customData для обратной совместимости
    if (metadata != null) 'customData': metadata,
  };

  factory QuickFavorite.fromJson(Map<String, dynamic> json) => QuickFavorite(
    id: json['id'] as String,
    type: json['type'] as String,
    label: json['label'] as String,
    emoji: json['emoji'] as String,
    volumeMl: json['volumeMl'] as int?,
    sodiumMg: json['sodiumMg'] as int?,
    potassiumMg: json['potassiumMg'] as int?,
    magnesiumMg: json['magnesiumMg'] as int?,
    // Читаем metadata или customData для обратной совместимости
    metadata: (json['metadata'] ?? json['customData']) as Map<String, dynamic>?,
  );
}

/// Менеджер быстрых фаворитов для главного экрана
class QuickFavoritesManager {
  static const String _storageKey = 'quick_favorites_v2';
  static const int maxFreeFavorites = 1;
  static const int maxProFavorites = 3;
  
  List<QuickFavorite?> _favorites = [null, null, null];
  bool _isPro = false;
  
  List<QuickFavorite?> get favorites => _favorites;
  
  Future<void> init(bool isPro) async {
    _isPro = isPro;
    await _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString(_storageKey);
      
      if (data != null) {
        final List<dynamic> jsonList = json.decode(data);
        _favorites = List.generate(3, (index) {
          if (index < jsonList.length && jsonList[index] != null) {
            try {
              return QuickFavorite.fromJson(jsonList[index] as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing favorite at index $index: $e');
              return null;
            }
          }
          return null;
        });
        
        // Очищаем недоступные слоты для FREE пользователей
        if (!_isPro) {
          for (int i = 1; i < 3; i++) {
            _favorites[i] = null;
          }
        }
      }
    } catch (e) {
      print('Error loading quick favorites: $e');
      _favorites = [null, null, null];
    }
  }
  
  Future<bool> saveFavorite(int slot, QuickFavorite favorite) async {
    // Проверка доступности слота
    if (slot < 0 || slot >= 3) {
      print('Invalid slot number: $slot');
      return false;
    }
    
    if (!_isPro && slot > 0) {
      print('Slot $slot is not available for FREE users');
      return false;
    }
    
    // Проверяем, не существует ли уже этот фаворит в другом слоте
    for (int i = 0; i < 3; i++) {
      if (i != slot && _favorites[i]?.id == favorite.id) {
        // Перемещаем в новый слот
        _favorites[i] = null;
      }
    }
    
    _favorites[slot] = favorite;
    return await _saveFavorites();
  }
  
  Future<bool> removeFavorite(int slot) async {
    if (slot < 0 || slot >= 3) {
      print('Invalid slot number: $slot');
      return false;
    }
    
    _favorites[slot] = null;
    return await _saveFavorites();
  }
  
  Future<bool> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _favorites.map((f) => f?.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
      return true;
    } catch (e) {
      print('Error saving quick favorites: $e');
      return false;
    }
  }
  
  bool isSlotAvailable(int slot) {
    if (slot < 0 || slot >= 3) return false;
    if (!_isPro && slot > 0) return false;
    return true;
  }
  
  bool isSlotEmpty(int slot) {
    if (slot < 0 || slot >= 3) return true;
    return _favorites[slot] == null;
  }
  
  /// Обновление статуса PRO
  Future<void> updateProStatus(bool isPro) async {
    _isPro = isPro;
    
    // Если пользователь потерял PRO статус, очищаем недоступные слоты
    if (!_isPro) {
      bool needsSave = false;
      for (int i = 1; i < 3; i++) {
        if (_favorites[i] != null) {
          _favorites[i] = null;
          needsSave = true;
        }
      }
      if (needsSave) {
        await _saveFavorites();
      }
    }
  }
  
  /// Получение фаворита по ID
  QuickFavorite? getFavoriteById(String id) {
    for (var favorite in _favorites) {
      if (favorite?.id == id) return favorite;
    }
    return null;
  }
  
  /// Поиск слота по ID фаворита
  int? findSlotByFavoriteId(String id) {
    for (int i = 0; i < 3; i++) {
      if (_favorites[i]?.id == id) return i;
    }
    return null;
  }
}