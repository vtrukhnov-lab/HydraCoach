// lib/models/achievement.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/units_service.dart';

/// Категории достижений
enum AchievementCategory {
  hydration('💧', 'Hydration', Colors.blue),
  electrolytes('⚡', 'Electrolytes', Colors.orange),
  alcohol('🍺', 'Alcohol Control', Colors.amber),
  sugar('🍬', 'Sugar Control', Colors.pink),
  workout('💪', 'Fitness', Colors.green),
  hri('🎯', 'HRI Master', Colors.purple),
  streaks('🔥', 'Streaks', Colors.red),
  special('⭐', 'Special', Color.fromARGB(255, 239, 170, 21));

  final String emoji;
  final String title;
  final Color color;

  const AchievementCategory(this.emoji, this.title, this.color);
}

/// Редкость достижения
enum AchievementRarity {
  common(1, 'Common', Colors.grey),
  uncommon(2, 'Uncommon', Colors.green),
  rare(3, 'Rare', Colors.blue),
  epic(4, 'Epic', Colors.purple),
  legendary(5, 'Legendary', Colors.orange);

  final int tier;
  final String label;
  final Color color;

  const AchievementRarity(this.tier, this.label, this.color);
}

/// Модель достижения
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementCategory category;
  final AchievementRarity rarity;
  int maxProgress;
  int currentProgress;
  final String?
  descriptionTemplate; // Шаблон с плейсхолдерами {volume}, {weight}
  final Map<String, dynamic>? unitValues; // Значения для разных единиц
  bool isUnlocked;
  DateTime? unlockedAt;
  final int rewardPoints;
  final Map<String, dynamic>? metadata;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
    required this.maxProgress,
    this.currentProgress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rewardPoints = 10,
    this.descriptionTemplate,
    this.unitValues,
    this.metadata,
  });

  /// Прогресс в процентах
  double get progressPercent {
    if (maxProgress <= 0) return 100.0;
    return (currentProgress / maxProgress * 100).clamp(0.0, 100.0);
  }

  /// Проверка готовности к разблокировке
  bool get isReadyToUnlock => currentProgress >= maxProgress && !isUnlocked;

  /// Создание из JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🏆',
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => AchievementCategory.special,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (r) => r.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      maxProgress: json['maxProgress'] ?? 1,
      currentProgress: json['currentProgress'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      rewardPoints: json['rewardPoints'] ?? 10,
      descriptionTemplate: json['descriptionTemplate'],
      unitValues: json['unitValues'] != null
          ? Map<String, dynamic>.from(json['unitValues'])
          : null,
      metadata: json['metadata'],
    );
  }

  /// Создание из Firestore документа
  factory Achievement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Achievement(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '🏆',
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == data['category'],
        orElse: () => AchievementCategory.special,
      ),
      rarity: AchievementRarity.values.firstWhere(
        (r) => r.name == data['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      maxProgress: data['maxProgress'] ?? 1,
      currentProgress: data['currentProgress'] ?? 0,
      isUnlocked: data['isUnlocked'] ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
      rewardPoints: data['rewardPoints'] ?? 10,
      descriptionTemplate: data['descriptionTemplate'],
      unitValues: data['unitValues'] != null
          ? Map<String, dynamic>.from(data['unitValues'])
          : null,
      metadata: data['metadata'],
    );
  }

  /// Конвертация в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category.name,
      'rarity': rarity.name,
      'maxProgress': maxProgress,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'rewardPoints': rewardPoints,
      'descriptionTemplate': descriptionTemplate,
      'unitValues': unitValues,
      'metadata': metadata,
    };
  }

  /// Конвертация в Map для Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'category': category.name,
      'rarity': rarity.name,
      'maxProgress': maxProgress,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
      'rewardPoints': rewardPoints,
      'descriptionTemplate': descriptionTemplate,
      'unitValues': unitValues,
      'metadata': metadata,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  /// Получить локализованное описание с правильными единицами
  String getLocalizedDescription() {
    if (descriptionTemplate == null || unitValues == null) {
      return description; // Возвращаем оригинальное описание
    }

    String localizedDesc = descriptionTemplate!;
    final units = UnitsService.instance.units;

    // Заменяем плейсхолдеры на значения для текущей системы единиц
    unitValues!.forEach((key, value) {
      if (value is Map && value.containsKey(units)) {
        localizedDesc = localizedDesc.replaceAll(
          '{$key}',
          value[units].toString(),
        );
      }
    });

    return localizedDesc;
  }

  /// Получить максимальный прогресс с учетом единиц измерения
  int getLocalizedMaxProgress() {
    if (unitValues == null) return maxProgress;

    final units = UnitsService.instance.units;
    if (unitValues!.containsKey('maxProgress_$units')) {
      return unitValues!['maxProgress_$units'] as int;
    }

    return maxProgress;
  }

  /// Получить прогресс в процентах с учетом локализации
  double get localizedProgressPercent {
    final localizedMax = getLocalizedMaxProgress();
    if (localizedMax <= 0) return 100.0;
    return (currentProgress / localizedMax * 100).clamp(0.0, 100.0);
  }

  /// Копирование с изменениями
  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    AchievementCategory? category,
    AchievementRarity? rarity,
    int? maxProgress,
    int? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? rewardPoints,
    String? descriptionTemplate,
    Map<String, dynamic>? unitValues,
    Map<String, dynamic>? metadata,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      maxProgress: maxProgress ?? this.maxProgress,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      descriptionTemplate: descriptionTemplate ?? this.descriptionTemplate,
      unitValues: unitValues ?? this.unitValues,
      metadata: metadata ?? this.metadata,
    );
  }
}
