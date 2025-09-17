// lib/repositories/achievements_repository.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/achievement.dart';
import '../services/units_service.dart';

/// Репозиторий для управления достижениями
class AchievementsRepository {
  static final AchievementsRepository _instance = AchievementsRepository._internal();
  factory AchievementsRepository() => _instance;
  AchievementsRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;
  
  // Кеш достижений в памяти  
  final Map<String, Achievement> _achievementsCache = {};
  bool _isInitialized = false;

  // Определения всех достижений с поддержкой локализации единиц
  final Map<String, Map<String, dynamic>> _achievementDefinitions = {
    // HYDRATION ACHIEVEMENTS
    'first_glass': {
      'nameKey': 'achievementFirstGlass',
      'descriptionKey': 'achievementFirstGlassDesc',
      'icon': '💧',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 10,
    },
    'hydration_goal_1': {
      'nameKey': 'achievementHydrationGoal1',
      'descriptionKey': 'achievementHydrationGoal1Desc',
      'icon': '🏆',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 20,
    },
    'hydration_goal_7': {
      'nameKey': 'achievementHydrationGoal7',
      'descriptionKey': 'achievementHydrationGoal7Desc',
      'icon': '💪',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 100,
    },
    'hydration_goal_30': {
      'nameKey': 'achievementHydrationGoal30',
      'descriptionKey': 'achievementHydrationGoal30Desc',
      'icon': '🌊',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 30,
      'rewardPoints': 500,
    },
    'perfect_hydration': {
      'nameKey': 'achievementPerfectHydration',
      'descriptionKey': 'achievementPerfectHydrationDesc',
      'icon': '⚖️',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 30,
    },
    'early_bird': {
      'nameKey': 'achievementEarlyBird',
      'descriptionKey': 'achievementEarlyBirdDesc', // "Drink 500ml before 9 AM"
      'descriptionTemplate': 'achievementEarlyBirdTemplate', // будущий ключ: "Drink {volume} before 9 AM"
      'icon': '🌅',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 500, // В мл для внутренней логики
      'rewardPoints': 25,
      'unitValues': {
        'volume': {
          'metric': '500ml',
          'imperial': '17 fl oz',
        },
      },
    },
    'night_owl': {
      'nameKey': 'achievementNightOwl',
      'descriptionKey': 'achievementNightOwlDesc',
      'icon': '🦉',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.rare,
      'maxProgress': 1,
      'rewardPoints': 50,
    },
    'liter_legend': {
      'nameKey': 'achievementLiterLegend',
      'descriptionKey': 'achievementLiterLegendDesc', // "Drink 100 liters total"
      'descriptionTemplate': 'achievementLiterLegendTemplate', // будущий ключ: "Drink {volume} total"
      'icon': '🏅',
      'category': AchievementCategory.hydration,
      'rarity': AchievementRarity.epic,
      'maxProgress': 100000, // 100L в мл
      'rewardPoints': 250,
      'unitValues': {
        'volume': {
          'metric': '100L',
          'imperial': '26 gallons',
        },
      },
    },
    
    // ELECTROLYTE ACHIEVEMENTS
    'salt_starter': {
      'nameKey': 'achievementSaltStarter',
      'descriptionKey': 'achievementSaltStarterDesc',
      'icon': '🧂',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 15,
    },
    'electrolyte_balance': {
      'nameKey': 'achievementElectrolyteBalance',
      'descriptionKey': 'achievementElectrolyteBalanceDesc',
      'icon': '⚡',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 40,
    },
    'sodium_master': {
      'nameKey': 'achievementSodiumMaster',
      'descriptionKey': 'achievementSodiumMasterDesc',
      'icon': '🧪',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 75,
    },
    'potassium_pro': {
      'nameKey': 'achievementPotassiumPro',
      'descriptionKey': 'achievementPotassiumProDesc',
      'icon': '🍌',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 75,
    },
    'magnesium_maven': {
      'nameKey': 'achievementMagnesiumMaven',
      'descriptionKey': 'achievementMagnesiumMavenDesc',
      'icon': '💊',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 75,
    },
    'electrolyte_expert': {
      'nameKey': 'achievementElectrolyteExpert',
      'descriptionKey': 'achievementElectrolyteExpertDesc',
      'icon': '🔬',
      'category': AchievementCategory.electrolytes,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 30,
      'rewardPoints': 400,
    },
    
    // SUGAR ACHIEVEMENTS
    'sugar_awareness': {
      'nameKey': 'achievementSugarAwareness',
      'descriptionKey': 'achievementSugarAwarenessDesc',
      'icon': '🍬',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 10,
    },
    'sugar_under_25': {
      'nameKey': 'achievementSugarUnder25',
      'descriptionKey': 'achievementSugarUnder25Desc', // "Keep sugar under 25g for a day"
      'descriptionTemplate': 'achievementSugarUnder25Template', // будущий ключ: "Keep sugar under {weight} for a day"
      'icon': '🎯',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 30,
      'unitValues': {
        'weight': {
          'metric': '25g',
          'imperial': '0.9 oz',
        }
      },
    },
    'sugar_week_control': {
      'nameKey': 'achievementSugarWeekControl',
      'descriptionKey': 'achievementSugarWeekControlDesc', // "Keep sugar under 25g for 7 days"
      'descriptionTemplate': 'achievementSugarWeekControlTemplate', // будущий ключ: "Keep sugar under {weight} for 7 days"
      'icon': '📉',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 100,
      'unitValues': {
        'weight': {
          'metric': '25g',
          'imperial': '0.9 oz',
        }
      },
    },
    'sugar_free_day': {
      'nameKey': 'achievementSugarFreeDay',
      'descriptionKey': 'achievementSugarFreeDayDesc',
      'icon': '🚫',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.rare,
      'maxProgress': 1,
      'rewardPoints': 50,
    },
    'sugar_detective': {
      'nameKey': 'achievementSugarDetective',
      'descriptionKey': 'achievementSugarDetectiveDesc',
      'icon': '🔍',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 10,
      'rewardPoints': 40,
    },
    'sugar_master': {
      'nameKey': 'achievementSugarMaster',
      'descriptionKey': 'achievementSugarMasterDesc', // "Keep sugar under 25g for 30 days"
      'icon': '👑',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 30,
      'rewardPoints': 500,
    },
    'no_soda_week': {
      'nameKey': 'achievementNoSodaWeek',
      'descriptionKey': 'achievementNoSodaWeekDesc',
      'icon': '🥤',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 75,
    },
    'no_soda_month': {
      'nameKey': 'achievementNoSodaMonth',
      'descriptionKey': 'achievementNoSodaMonthDesc',
      'icon': '💪',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.epic,
      'maxProgress': 30,
      'rewardPoints': 300,
    },
    'sweet_tooth_tamed': {
      'nameKey': 'achievementSweetToothTamed',
      'descriptionKey': 'achievementSweetToothTamedDesc',
      'icon': '🦷',
      'category': AchievementCategory.sugar,
      'rarity': AchievementRarity.epic,
      'maxProgress': 1,
      'rewardPoints': 200,
    },
    
    // ALCOHOL ACHIEVEMENTS
    'alcohol_tracker': {
      'nameKey': 'achievementAlcoholTracker',
      'descriptionKey': 'achievementAlcoholTrackerDesc',
      'icon': '🍺',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 10,
    },
    'moderate_day': {
      'nameKey': 'achievementModerateDay',
      'descriptionKey': 'achievementModerateDayDesc',
      'icon': '⚖️',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 25,
    },
    'sober_day': {
      'nameKey': 'achievementSoberDay',
      'descriptionKey': 'achievementSoberDayDesc',
      'icon': '🌟',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 20,
    },
    'sober_week': {
      'nameKey': 'achievementSoberWeek',
      'descriptionKey': 'achievementSoberWeekDesc',
      'icon': '🏆',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 100,
    },
    'sober_month': {
      'nameKey': 'achievementSoberMonth',
      'descriptionKey': 'achievementSoberMonthDesc',
      'icon': '🎖️',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 30,
      'rewardPoints': 500,
    },
    'recovery_protocol': {
      'nameKey': 'achievementRecoveryProtocol',
      'descriptionKey': 'achievementRecoveryProtocolDesc',
      'icon': '🛡️',
      'category': AchievementCategory.alcohol,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 35,
    },
    
    // WORKOUT ACHIEVEMENTS
    'first_workout': {
      'nameKey': 'achievementFirstWorkout',
      'descriptionKey': 'achievementFirstWorkoutDesc',
      'icon': '🏃',
      'category': AchievementCategory.workout,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 15,
    },
    'workout_week': {
      'nameKey': 'achievementWorkoutWeek',
      'descriptionKey': 'achievementWorkoutWeekDesc', // "Work out 3 times in a week"
      'icon': '💪',
      'category': AchievementCategory.workout,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 3, // Исправлено с 5 на 3 согласно описанию
      'rewardPoints': 50,
    },
    'century_sweat': {
      'nameKey': 'achievementCenturySweat',
      'descriptionKey': 'achievementCenturySweatDesc', // "Lose 100 liters through workouts"
      'descriptionTemplate': 'achievementCenturySweatTemplate', // будущий ключ: "Lose {volume} through workouts"
      'icon': '💦',
      'category': AchievementCategory.workout,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 100000, // 100L в мл
      'rewardPoints': 600,
      'unitValues': {
        'volume': {
          'metric': '100L',
          'imperial': '26 gallons',
        },
      },
    },
    'cardio_king': {
      'nameKey': 'achievementCardioKing',
      'descriptionKey': 'achievementCardioKingDesc',
      'icon': '❤️',
      'category': AchievementCategory.workout,
      'rarity': AchievementRarity.rare,
      'maxProgress': 10,
      'rewardPoints': 80,
    },
    'strength_warrior': {
      'nameKey': 'achievementStrengthWarrior',
      'descriptionKey': 'achievementStrengthWarriorDesc',
      'icon': '🏋️',
      'category': AchievementCategory.workout,
      'rarity': AchievementRarity.rare,
      'maxProgress': 10,
      'rewardPoints': 80,
    },
    
    // HRI ACHIEVEMENTS
    'hri_green': {
      'nameKey': 'achievementHRIGreen',
      'descriptionKey': 'achievementHRIGreenDesc',
      'icon': '🟢',
      'category': AchievementCategory.hri,
      'rarity': AchievementRarity.common,
      'maxProgress': 1,
      'rewardPoints': 20,
    },
    'hri_week_green': {
      'nameKey': 'achievementHRIWeekGreen',
      'descriptionKey': 'achievementHRIWeekGreenDesc',
      'icon': '✅',
      'category': AchievementCategory.hri,
      'rarity': AchievementRarity.rare,
      'maxProgress': 7,
      'rewardPoints': 100,
    },
    'hri_perfect': {
      'nameKey': 'achievementHRIPerfect',
      'descriptionKey': 'achievementHRIPerfectDesc',
      'icon': '💯',
      'category': AchievementCategory.hri,
      'rarity': AchievementRarity.epic,
      'maxProgress': 1,
      'rewardPoints': 150,
    },
    'hri_recovery': {
      'nameKey': 'achievementHRIRecovery',
      'descriptionKey': 'achievementHRIRecoveryDesc',
      'icon': '🚀',
      'category': AchievementCategory.hri,
      'rarity': AchievementRarity.rare,
      'maxProgress': 1,
      'rewardPoints': 75,
    },
    'hri_master': {
      'nameKey': 'achievementHRIMaster',
      'descriptionKey': 'achievementHRIMasterDesc',
      'icon': '🏅',
      'category': AchievementCategory.hri,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 30,
      'rewardPoints': 500,
    },
    
    // STREAK ACHIEVEMENTS
    'streak_3': {
      'nameKey': 'achievementStreak3',
      'descriptionKey': 'achievementStreak3Desc',
      'icon': '🔥',
      'category': AchievementCategory.streaks,
      'rarity': AchievementRarity.common,
      'maxProgress': 3,
      'rewardPoints': 15,
    },
    'streak_7': {
      'nameKey': 'achievementStreak7',
      'descriptionKey': 'achievementStreak7Desc',
      'icon': '🔥',
      'category': AchievementCategory.streaks,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 7,
      'rewardPoints': 50,
    },
    'streak_30': {
      'nameKey': 'achievementStreak30',
      'descriptionKey': 'achievementStreak30Desc',
      'icon': '🔥',
      'category': AchievementCategory.streaks,
      'rarity': AchievementRarity.epic,
      'maxProgress': 30,
      'rewardPoints': 200,
    },
    'streak_100': {
      'nameKey': 'achievementStreak100',
      'descriptionKey': 'achievementStreak100Desc',
      'icon': '💎',
      'category': AchievementCategory.streaks,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 100,
      'rewardPoints': 1000,
    },
    
    // SPECIAL ACHIEVEMENTS
    'first_week': {
      'nameKey': 'achievementFirstWeek',
      'descriptionKey': 'achievementFirstWeekDesc',
      'icon': '🎉',
      'category': AchievementCategory.special,
      'rarity': AchievementRarity.common,
      'maxProgress': 7,
      'rewardPoints': 25,
    },
    'pro_member': {
      'nameKey': 'achievementProMember',
      'descriptionKey': 'achievementProMemberDesc',
      'icon': '⭐',
      'category': AchievementCategory.special,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 50,
    },
    'data_export': {
      'nameKey': 'achievementDataExport',
      'descriptionKey': 'achievementDataExportDesc',
      'icon': '📊',
      'category': AchievementCategory.special,
      'rarity': AchievementRarity.uncommon,
      'maxProgress': 1,
      'rewardPoints': 25,
    },
    'all_categories': {
      'nameKey': 'achievementAllCategories',
      'descriptionKey': 'achievementAllCategoriesDesc',
      'icon': '🌟',
      'category': AchievementCategory.special,
      'rarity': AchievementRarity.epic,
      'maxProgress': 8, // Количество не-специальных категорий
      'rewardPoints': 300,
    },
    'achievement_hunter': {
      'nameKey': 'achievementHunter',
      'descriptionKey': 'achievementHunterDesc',
      'icon': '🏆',
      'category': AchievementCategory.special,
      'rarity': AchievementRarity.legendary,
      'maxProgress': 25, // Будет вычислено динамически
      'rewardPoints': 500,
    },
  };

  /// Initialize repository
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _loadLocalAchievements();
    _isInitialized = true;
  }

  /// Set user ID for Firestore sync
  void setUserId(String? userId) {
    _userId = userId;
    if (userId != null) {
      syncWithFirestore();
    }
  }

  /// Load achievements from local storage
  Future<void> _loadLocalAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Initialize all achievements
    _achievementDefinitions.forEach((id, definition) {
      final savedData = prefs.getString('achievement_$id');
      
      Achievement achievement;
      
      if (savedData != null) {
        // Load from saved data
        final json = jsonDecode(savedData);
        achievement = Achievement.fromJson({
          'id': id,
          'name': definition['nameKey'], // Ключи локализации будут резолвиться в UI
          'description': definition['descriptionKey'],
          'descriptionTemplate': definition['descriptionTemplate'],
          'unitValues': definition['unitValues'] != null 
              ? Map<String, dynamic>.from(definition['unitValues'])
              : null,
          ...json,
        });
      } else {
        // Create new achievement with localized keys
        achievement = Achievement(
          id: id,
          name: definition['nameKey'], // Это ключ локализации, не текст
          description: definition['descriptionKey'], // Это ключ локализации, не текст
          descriptionTemplate: definition['descriptionTemplate'],
          unitValues: definition['unitValues'] != null 
              ? Map<String, dynamic>.from(definition['unitValues'])
              : null,
          icon: definition['icon'],
          category: definition['category'],
          rarity: definition['rarity'],
          currentProgress: 0,
          maxProgress: definition['maxProgress'],
          isUnlocked: false,
          rewardPoints: definition['rewardPoints'],
        );
      }
      
      // Apply units-specific maxProgress if available
      if (definition['unitValues'] != null) {
        final units = UnitsService.instance.units;
        final unitValues = definition['unitValues'] as Map<String, dynamic>;
        
        if (unitValues.containsKey('maxProgress_$units')) {
          achievement.maxProgress = unitValues['maxProgress_$units'] as int;
        }
      }
      
      _achievementsCache[id] = achievement;
    });
  }

  /// Save achievement to local storage
  Future<void> _saveAchievement(Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'achievement_${achievement.id}',
      jsonEncode(achievement.toJson()),
    );
  }

  /// Get specific achievement
  Achievement? getAchievement(String id) {
    return _achievementsCache[id];
  }

  /// Get all achievements
  List<Achievement> getAllAchievements() {
    return _achievementsCache.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get achievements by category
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return _achievementsCache.values
        .where((a) => a.category == category)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get unlocked achievements
  List<Achievement> getUnlockedAchievements() {
    return _achievementsCache.values
        .where((a) => a.isUnlocked)
        .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
  }

  /// Get nearly unlocked achievements (80%+ progress)
  List<Achievement> getNearlyUnlockedAchievements() {
    return _achievementsCache.values
        .where((a) => !a.isUnlocked && a.localizedProgressPercent >= 80)
        .toList()
      ..sort((a, b) => b.localizedProgressPercent.compareTo(a.localizedProgressPercent));
  }

  /// Update achievement progress
  Future<Achievement?> updateProgress(String achievementId, int progress) async {
    final achievement = _achievementsCache[achievementId];
    if (achievement == null) return null;
    
    // Get localized max progress for proper comparison
    final maxProgress = achievement.getLocalizedMaxProgress();
    
    // Update progress
    achievement.currentProgress = progress.clamp(0, maxProgress);
    
    // Check if unlocked
    Achievement? unlocked;
    if (!achievement.isUnlocked && achievement.currentProgress >= maxProgress) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();
      unlocked = achievement;
    }
    
    // Save locally
    await _saveAchievement(achievement);
    
    // Sync with Firestore
    if (_userId != null) {
      _syncAchievementToFirestore(achievement);
    }
    
    return unlocked;
  }

  /// Increment achievement progress by 1
  Future<Achievement?> incrementProgress(String achievementId) async {
    final achievement = _achievementsCache[achievementId];
    if (achievement == null) return null;
    
    return updateProgress(achievementId, achievement.currentProgress + 1);
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    final all = getAllAchievements();
    final unlocked = all.where((a) => a.isUnlocked);
    final byCategory = <AchievementCategory, int>{};
    final totalPoints = unlocked.fold(0, (sum, a) => sum + a.rewardPoints);
    
    for (final achievement in unlocked) {
      byCategory[achievement.category] = (byCategory[achievement.category] ?? 0) + 1;
    }
    
    return {
      'totalAchievements': all.length,
      'unlockedCount': unlocked.length,
      'unlockedPercent': (unlocked.length / all.length * 100).round(),
      'totalPoints': totalPoints,
      'byCategory': byCategory,
      'recentUnlocks': unlocked.take(5).toList(),
    };
  }

  /// Sync with Firestore
  Future<void> syncWithFirestore() async {
    if (_userId == null) return;
    
    try {
      // Load from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('achievements')
          .doc('data')
          .get();
      
      if (doc.exists) {
        final data = doc.data() ?? {};
        
        // Merge with local data
        data.forEach((id, achievementData) {
          if (_achievementsCache.containsKey(id)) {
            final local = _achievementsCache[id]!;
            final remote = Achievement.fromJson(achievementData);
            
            // Take the one with more progress
            if (remote.currentProgress > local.currentProgress ||
                (remote.isUnlocked && !local.isUnlocked)) {
              _achievementsCache[id] = remote;
              _saveAchievement(remote);
            }
          }
        });
      }
      
      // Save all to Firestore
      final batch = _firestore.batch();
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('achievements')
          .doc('data');
      
      final allData = <String, dynamic>{};
      _achievementsCache.forEach((id, achievement) {
        allData[id] = achievement.toJson();
      });
      
      batch.set(docRef, allData, SetOptions(merge: true));
      await batch.commit();
    } catch (e) {
      print('Error syncing achievements: $e');
    }
  }

  /// Sync single achievement to Firestore
  Future<void> _syncAchievementToFirestore(Achievement achievement) async {
    if (_userId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('achievements')
          .doc('data')
          .set({
            achievement.id: achievement.toJson(),
          }, SetOptions(merge: true));
    } catch (e) {
      print('Error syncing achievement ${achievement.id}: $e');
    }
  }

  /// Clear all progress (for testing)
  Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final id in _achievementsCache.keys) {
      await prefs.remove('achievement_$id');
    }
    
    await _loadLocalAchievements();
  }
}