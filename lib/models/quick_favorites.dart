// lib/models/quick_favorites.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Быстрый фаворит для главного экрана
class QuickFavorite {
  final String id;
  final String
  type; // water, electrolyte, alcohol, coffee, tea, broth, juice, milk, soda, hot, supplement
  final String label;
  final String emoji;
  final int? volumeMl;
  final int? sodiumMg;
  final int? potassiumMg;
  final int? magnesiumMg;
  final Map<String, dynamic>? metadata;

  QuickFavorite({
    required this.id,
    required this.type,
    required this.label,
    required this.emoji,
    this.volumeMl,
    this.sodiumMg,
    this.potassiumMg,
    this.magnesiumMg,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? customData, // обратная совместимость
  }) : metadata = metadata ?? customData;

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
    if (metadata != null) 'customData': metadata, // обратная совместимость
  };

  factory QuickFavorite.fromJson(Map<String, dynamic> json) => QuickFavorite(
    id: json['id'] as String,
    type: json['type'] as String,
    label: json['label'] as String,
    emoji: json['emoji'] as String,
    volumeMl: json['volumeMl'] as int?,
    sodiumMg: json['sodiumMg'] as int? ?? 0,
    potassiumMg: json['potassiumMg'] as int? ?? 0,
    magnesiumMg: json['magnesiumMg'] as int? ?? 0,
    metadata: (json['metadata'] ?? json['customData']) as Map<String, dynamic>?,
  );

  /// Дефолтный фаворит — вода 500 мл
  static QuickFavorite get defaultWater => QuickFavorite(
    id: 'default_water_500',
    type: 'water',
    label: 'Water',
    emoji: '💧',
    volumeMl: 500,
    sodiumMg: 0,
    potassiumMg: 0,
    magnesiumMg: 0,
  );
}

/// Менеджер быстрых фаворитов (Singleton + ChangeNotifier)
class QuickFavoritesManager extends ChangeNotifier {
  static const String _storageKey = 'quick_favorites_v2';
  static const String _firstRunKey = 'quick_favorites_first_run';
  static const int maxFreeFavorites = 1;
  static const int maxProFavorites = 3;

  static final QuickFavoritesManager _instance =
      QuickFavoritesManager._internal();
  factory QuickFavoritesManager() => _instance;
  QuickFavoritesManager._internal();

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  List<QuickFavorite?> _favorites = [null, null, null];
  bool _isPro = false;
  bool _initialized = false;

  List<QuickFavorite?> get favorites => _favorites;
  bool get isPro => _isPro;
  bool get isInitialized => _initialized;

  Future<void> init(bool isPro) async {
    _isPro = isPro;

    // Чтобы не гонять диск лишний раз — если уже инициализированы, просто
    // синхронизируем доступность слотов и всё.
    if (_initialized) {
      await _enforceProLimits();
      return;
    }

    await _loadFavoritesFromDisk();
    await _ensureFirstRunDefault();
    await _enforceProLimits();

    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadFavoritesFromDisk() async {
    try {
      final prefs = await _prefsFuture;
      final String? data = prefs.getString(_storageKey);
      if (data == null) return;

      final List<dynamic> jsonList = json.decode(data);
      _favorites = List.generate(3, (index) {
        if (index < jsonList.length && jsonList[index] != null) {
          try {
            return QuickFavorite.fromJson(
              jsonList[index] as Map<String, dynamic>,
            );
          } catch (e) {
            debugPrint('Error parsing favorite at index $index: $e');
            return null;
          }
        }
        return null;
      });
    } catch (e) {
      debugPrint('Error loading quick favorites: $e');
      _favorites = [null, null, null];
    }
  }

  Future<void> _ensureFirstRunDefault() async {
    final prefs = await _prefsFuture;
    final isFirstRun = prefs.getBool(_firstRunKey) ?? true;
    if (isFirstRun && _favorites[0] == null) {
      _favorites[0] = QuickFavorite.defaultWater;
      await _saveFavoritesToDisk();
      await prefs.setBool(_firstRunKey, false);
    }
  }

  Future<void> _enforceProLimits() async {
    if (!_isPro) {
      bool changed = false;
      for (int i = 1; i < 3; i++) {
        if (_favorites[i] != null) {
          _favorites[i] = null;
          changed = true;
        }
      }
      if (changed) {
        await _saveFavoritesToDisk();
      }
    }
  }

  Future<bool> saveFavorite(int slot, QuickFavorite favorite) async {
    if (slot < 0 || slot >= 3) return false;
    if (!_isPro && slot > 0) return false;

    // Убираем дубли в других слотах
    for (int i = 0; i < 3; i++) {
      if (i != slot && _favorites[i]?.id == favorite.id) {
        _favorites[i] = null;
      }
    }

    _favorites[slot] = favorite;
    final ok = await _saveFavoritesToDisk();
    if (ok) notifyListeners();
    return ok;
  }

  Future<bool> removeFavorite(int slot) async {
    if (slot < 0 || slot >= 3) return false;
    _favorites[slot] = null;
    final ok = await _saveFavoritesToDisk();
    if (ok) notifyListeners();
    return ok;
  }

  Future<void> updateProStatus(bool isPro) async {
    _isPro = isPro;
    await _enforceProLimits();
    notifyListeners();
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

  QuickFavorite? getFavoriteById(String id) {
    for (final f in _favorites) {
      if (f?.id == id) return f;
    }
    return null;
  }

  int? findSlotByFavoriteId(String id) {
    for (int i = 0; i < 3; i++) {
      if (_favorites[i]?.id == id) return i;
    }
    return null;
  }

  Future<bool> _saveFavoritesToDisk() async {
    try {
      final prefs = await _prefsFuture;
      final jsonList = _favorites.map((f) => f?.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
      return true;
    } catch (e) {
      debugPrint('Error saving quick favorites: $e');
      return false;
    }
  }
}
