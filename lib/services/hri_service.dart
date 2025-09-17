// lib/services/hri_service.dart
// 
// HRI (Hydration Risk Index) Service - Complete Rewrite
// Manages hydration risk calculation with all factors
// UPDATED: Added workout loss calculations and proper tracking + HistoryService integration

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'remote_config_service.dart';
import 'history_service.dart';
import '../data/catalog_item.dart';
import 'achievement_tracker.dart';

// ============================================================================
// DATA MODELS
// ============================================================================

class Workout {
  final String id;
  final DateTime timestamp;
  final String type;
  final int intensity; // 1-5
  final int durationMinutes;
  final int waterLossMl; // NEW: Track water loss
  final int sodiumLossMg; // NEW: Track sodium loss
  final int potassiumLossMg; // NEW: Track potassium loss
  final int magnesiumLossMg; // NEW: Track magnesium loss
  final int caloriesBurned; // NEW: Track calories
  
  Workout({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.intensity,
    required this.durationMinutes,
    this.waterLossMl = 0,
    this.sodiumLossMg = 0,
    this.potassiumLossMg = 0,
    this.magnesiumLossMg = 0,
    this.caloriesBurned = 0,
  });
  
  // Calculate HRI impact based on intensity, duration and time elapsed
  double getHRIImpact() {
    // Base impact: intensity * duration factor * water loss factor
    double base = intensity * (durationMinutes / 30.0);
    
    // Add impact based on water loss
    if (waterLossMl > 0) {
      base += (waterLossMl / 500.0); // Every 500ml lost adds 1 point
    }
    
    // Decay over time
    final hoursSince = DateTime.now().difference(timestamp).inHours;
    if (hoursSince > 24) return 0;
    if (hoursSince > 12) return base * 0.3;
    if (hoursSince > 6) return base * 0.6;
    if (hoursSince > 3) return base * 0.8;
    return base;
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'intensity': intensity,
    'durationMinutes': durationMinutes,
    'waterLossMl': waterLossMl,
    'sodiumLossMg': sodiumLossMg,
    'potassiumLossMg': potassiumLossMg,
    'magnesiumLossMg': magnesiumLossMg,
    'caloriesBurned': caloriesBurned,
  };
  
  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'] ?? 'unknown',
    intensity: json['intensity'] ?? 3,
    durationMinutes: json['durationMinutes'] ?? 0,
    waterLossMl: json['waterLossMl'] ?? 0,
    sodiumLossMg: json['sodiumLossMg'] ?? 0,
    potassiumLossMg: json['potassiumLossMg'] ?? 0,
    magnesiumLossMg: json['magnesiumLossMg'] ?? 0,
    caloriesBurned: json['caloriesBurned'] ?? 0,
  );
}

class CaffeineIntake {
  final String id;
  final DateTime timestamp;
  final double caffeineMg;
  final String source;
  
  CaffeineIntake({
    required this.id,
    required this.timestamp,
    required this.caffeineMg,
    required this.source,
  });
  
  // Calculate active caffeine with half-life of 6 hours
  double getActiveCaffeine() {
    final hoursSince = DateTime.now().difference(timestamp).inHours;
    if (hoursSince >= 24) return 0;
    // Half-life decay formula
    return caffeineMg * pow(0.5, hoursSince / 6.0);
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'caffeineMg': caffeineMg,
    'source': source,
  };
  
  factory CaffeineIntake.fromJson(Map<String, dynamic> json) => CaffeineIntake(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    caffeineMg: json['caffeineMg'].toDouble(),
    source: json['source'],
  );
}

// NEW: Workout loss calculations result
class WorkoutLossResult {
  final int waterLossMl;
  final int sodiumLossMg;
  final int potassiumLossMg;
  final int magnesiumLossMg;
  final int caloriesBurned;
  
  WorkoutLossResult({
    required this.waterLossMl,
    required this.sodiumLossMg,
    required this.potassiumLossMg,
    required this.magnesiumLossMg,
    required this.caloriesBurned,
  });
}

// ============================================================================
// HRI SERVICE
// ============================================================================

class HRIService extends ChangeNotifier {
  // Achievement tracker
  final AchievementTracker _achievementTracker = AchievementTracker();
  
  // Storage keys
  static const String _hriKey = 'current_hri';
  static const String _componentsKey = 'hri_components';
  static const String _lastUpdateKey = 'hri_last_update';
  static const String _workoutsKey = 'today_workouts';
  static const String _caffeineKey = 'today_caffeine';
  static const String _alcoholKey = 'today_alcohol_sd';
  static const String _workoutLossesKey = 'today_workout_losses';
  
  // Current HRI value and components
  double _currentHRI = 25.0; // Start at low risk
  DateTime _lastUpdate = DateTime.now();
  
  // Today's data
  final List<Workout> _todayWorkouts = [];
  final List<CaffeineIntake> _todayCaffeineIntakes = [];
  double _todayAlcoholSD = 0.0;
  
  // NEW: Track total workout losses for the day
  int _totalWaterLossMl = 0;
  int _totalSodiumLossMg = 0;
  int _totalPotassiumLossMg = 0;
  int _totalMagnesiumLossMg = 0;
  
  // Component breakdown (for display)
  final Map<String, double> _components = {
    'water': 0.0,
    'sodium': 0.0,
    'potassium': 0.0,
    'magnesium': 0.0,
    'heat': 0.0,
    'workouts': 0.0,
    'caffeine': 0.0,
    'alcohol': 0.0,
    'sugar': 0.0,
    'timeSinceIntake': 0.0,
    'morning': 0.0,
    'dehydration': 0.0, // NEW: Track dehydration from workouts
  };
  
  // State tracking for smart clamping
  double _lastWaterRatio = 0.0;
  double _lastWaterComponent = 0.0;
  DateTime? _lastIntakeTime;
  
  // Morning check-in data
  double _morningWeight = 0.0;
  int _urineColor = 3;
  double _sleepQuality = 1.0;
  
  // Fasting mode
  bool _isFasting = false;
  
  // ============================================================================
  // GETTERS
  // ============================================================================
  
  // Get today's total caffeine (sum of all intakes today)
  int getTodaysCaffeine() {
    double totalCaffeine = 0.0;
    for (final intake in _todayCaffeineIntakes) {
      totalCaffeine += intake.caffeineMg;
    }
    return totalCaffeine.round();
  }
  
  // Get today's active caffeine (with decay)
  int getTodaysActiveCaffeine() {
    double totalActiveCaffeine = 0.0;
    for (final intake in _todayCaffeineIntakes) {
      totalActiveCaffeine += intake.getActiveCaffeine();
    }
    return totalActiveCaffeine.round();
  }
  
  // NEW: Get today's workout losses
  Map<String, int> getTodaysWorkoutLosses() {
    return {
      'water': _totalWaterLossMl,
      'sodium': _totalSodiumLossMg,
      'potassium': _totalPotassiumLossMg,
      'magnesium': _totalMagnesiumLossMg,
    };
  }
  
  double get currentHRI => _currentHRI;
  DateTime get lastUpdate => _lastUpdate;
  List<Workout> get todayWorkouts => List.unmodifiable(_todayWorkouts);
  List<CaffeineIntake> get todayCaffeineIntakes => List.unmodifiable(_todayCaffeineIntakes);
  double get todayAlcoholSD => _todayAlcoholSD;
  Map<String, double> get components => Map.unmodifiable(_components);
  
  // Get total standard drinks (for compatibility)
  double getTotalStandardDrinks() => _todayAlcoholSD;
  
  // Get HRI zone color
  String get hriZone {
    if (_currentHRI <= 30) return 'green';
    if (_currentHRI <= 60) return 'yellow';
    return 'red';
  }
  
  // Get HRI status text
  String get hriStatus {
    if (_currentHRI <= 20) return 'Excellent';
    if (_currentHRI <= 40) return 'Good';
    if (_currentHRI <= 60) return 'Moderate';
    if (_currentHRI <= 80) return 'High Risk';
    return 'Critical';
  }
  
  // Get components breakdown (for UI)
  Map<String, double> getComponentsBreakdown() => Map.from(_components);
  
  // ============================================================================
  // WORKOUT LOSS CALCULATIONS (NEW)
  // ============================================================================
  
  static WorkoutLossResult calculateWorkoutLosses({
    required CatalogItem item,
    required int durationMinutes,
    required double userWeight,
  }) {
    // Get parameters from item properties with defaults
    final naPerL = (item.properties['naPerL'] as int? ?? 800);
    final kPerL = (item.properties['kPerL'] as int? ?? 200);
    final mgPerL = (item.properties['mgPerL'] as int? ?? 40);
    final baseSweatRate = (item.properties['sweatRate'] as int? ?? 600); // ml/hour
    final met = (item.properties['met'] as num? ?? 5.0);
    final intensityValue = (item.properties['intensityValue'] as int? ?? 3);
    
    // Calculate sweat loss based on duration and body weight
    final hours = durationMinutes / 60.0;
    final adjustedSweatRate = baseSweatRate * (userWeight / 70) * (intensityValue / 3.0);
    final waterLossMl = (adjustedSweatRate * hours).round();
    
    // Calculate electrolyte losses based on sweat volume
    final liters = waterLossMl / 1000.0;
    final sodiumMg = (naPerL * liters).round();
    final potassiumMg = (kPerL * liters).round();
    final magnesiumMg = (mgPerL * liters).round();
    
    // Calculate calories burned
    final caloriesBurned = (met * userWeight * hours).round();
    
    return WorkoutLossResult(
      waterLossMl: waterLossMl,
      sodiumLossMg: sodiumMg,
      potassiumLossMg: potassiumMg,
      magnesiumLossMg: magnesiumMg,
      caloriesBurned: caloriesBurned,
    );
  }
  
  // ============================================================================
  // INITIALIZATION
  // ============================================================================
  
  HRIService() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    await _loadData();
    _checkAndResetDaily();
  }
  
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load HRI value
    _currentHRI = prefs.getDouble(_hriKey) ?? 25.0;
    
    // Load last update time
    final lastUpdateMillis = prefs.getInt(_lastUpdateKey);
    if (lastUpdateMillis != null) {
      _lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    }
    
    // Load today's workouts with new format
    final workoutsJson = prefs.getStringList(_workoutsKey) ?? [];
    _todayWorkouts.clear();
    _totalWaterLossMl = 0;
    _totalSodiumLossMg = 0;
    _totalPotassiumLossMg = 0;
    _totalMagnesiumLossMg = 0;
    
    for (final json in workoutsJson) {
      try {
        final parts = json.split('|');
        if (parts.length >= 5) {
          final workout = Workout(
            id: parts[0],
            timestamp: DateTime.parse(parts[1]),
            type: parts[2],
            intensity: int.parse(parts[3]),
            durationMinutes: int.parse(parts[4]),
            waterLossMl: parts.length > 5 ? int.parse(parts[5]) : 0,
            sodiumLossMg: parts.length > 6 ? int.parse(parts[6]) : 0,
            potassiumLossMg: parts.length > 7 ? int.parse(parts[7]) : 0,
            magnesiumLossMg: parts.length > 8 ? int.parse(parts[8]) : 0,
            caloriesBurned: parts.length > 9 ? int.parse(parts[9]) : 0,
          );
          _todayWorkouts.add(workout);
          
          // Sum up losses
          _totalWaterLossMl += workout.waterLossMl;
          _totalSodiumLossMg += workout.sodiumLossMg;
          _totalPotassiumLossMg += workout.potassiumLossMg;
          _totalMagnesiumLossMg += workout.magnesiumLossMg;
        }
      } catch (e) {
        print('Error loading workout: $e');
      }
    }
    
    // Load today's caffeine
    final caffeineJson = prefs.getStringList(_caffeineKey) ?? [];
    _todayCaffeineIntakes.clear();
    for (final json in caffeineJson) {
      try {
        final parts = json.split('|');
        if (parts.length >= 4) {
          _todayCaffeineIntakes.add(CaffeineIntake(
            id: parts[0],
            timestamp: DateTime.parse(parts[1]),
            caffeineMg: double.parse(parts[2]),
            source: parts[3],
          ));
        }
      } catch (e) {
        print('Error loading caffeine: $e');
      }
    }
    
    // Load today's alcohol
    _todayAlcoholSD = prefs.getDouble(_alcoholKey) ?? 0.0;
    
    // Load components
    final componentsJson = prefs.getString(_componentsKey);
    if (componentsJson != null) {
      try {
        final decoded = Map<String, double>.from(
          (componentsJson.split(',').fold<Map<String, double>>({}, (map, item) {
            final parts = item.split(':');
            if (parts.length == 2) {
              map[parts[0]] = double.parse(parts[1]);
            }
            return map;
          }))
        );
        _components.addAll(decoded);
      } catch (e) {
        print('Error loading components: $e');
      }
    }
    
    notifyListeners();
  }
  
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save HRI value
    await prefs.setDouble(_hriKey, _currentHRI);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
    
    // Save workouts with loss data
    final workoutsJson = _todayWorkouts.map((w) =>
      '${w.id}|${w.timestamp.toIso8601String()}|${w.type}|${w.intensity}|${w.durationMinutes}|'
      '${w.waterLossMl}|${w.sodiumLossMg}|${w.potassiumLossMg}|${w.magnesiumLossMg}|${w.caloriesBurned}'
    ).toList();
    await prefs.setStringList(_workoutsKey, workoutsJson);
    
    // Save caffeine
    final caffeineJson = _todayCaffeineIntakes.map((c) =>
      '${c.id}|${c.timestamp.toIso8601String()}|${c.caffeineMg}|${c.source}'
    ).toList();
    await prefs.setStringList(_caffeineKey, caffeineJson);
    
    // Save alcohol
    await prefs.setDouble(_alcoholKey, _todayAlcoholSD);
    
    // Save components as simple string
    final componentsStr = _components.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    await prefs.setString(_componentsKey, componentsStr);
  }
  
  // ============================================================================
  // DAILY RESET WITH HRI AUTOSAVE
  // ============================================================================
  
  void _checkAndResetDaily() {
    final now = DateTime.now();
    if (_lastUpdate.day != now.day || 
        _lastUpdate.month != now.month || 
        _lastUpdate.year != now.year) {
      
      // NEW: Save yesterday's HRI before reset
      if (_lastUpdate.isBefore(now.subtract(const Duration(hours: 1)))) {
        // Only save if last update was more than 1 hour ago (avoid duplicate saves)
        _saveEndOfDaySnapshot();
      }
      
      // New day - reset daily data
      _todayWorkouts.clear();
      _todayCaffeineIntakes.clear();
      _todayAlcoholSD = 0.0;
      _totalWaterLossMl = 0;
      _totalSodiumLossMg = 0;
      _totalPotassiumLossMg = 0;
      _totalMagnesiumLossMg = 0;
      _lastIntakeTime = null;
      _currentHRI = 25.0; // Reset to baseline
      _components.updateAll((key, value) => 0.0);
      _saveData();
    }
  }
  
  // ============================================================================
  // FASTING MODE
  // ============================================================================
  
  void setFastingStatus(bool value) {
    _isFasting = value;
  }
  
  // ============================================================================
  // FIRESTORE INTEGRATION (NEW)
  // ============================================================================
  
  // NEW: Save workout to Firestore via HistoryService
  Future<void> _saveWorkoutToFirestore(Workout workout) async {
    try {
      final historyService = HistoryService();
      await historyService.saveWorkout(workout);
      print('Workout saved to Firestore: ${workout.type} ${workout.durationMinutes}min');
    } catch (e) {
      print('Error saving workout to Firestore: $e');
      // Не блокируем UI если Firestore недоступен - данные остаются в SharedPreferences
    }
  }
  
  // NEW: Save caffeine intake to Firestore via HistoryService
  Future<void> _saveCaffeineToFirestore(CaffeineIntake intake) async {
    try {
      final historyService = HistoryService();
      await historyService.saveCaffeineIntake(
        intake.id,
        intake.timestamp,
        intake.caffeineMg,
        intake.source,
      );
      print('Caffeine saved to Firestore: ${intake.caffeineMg}mg from ${intake.source}');
    } catch (e) {
      print('Error saving caffeine to Firestore: $e');
      // Не блокируем UI если Firestore недоступен - данные остаются в SharedPreferences
    }
  }
  
  // ============================================================================
  // DATA INPUT METHODS
  // ============================================================================
  
  // Updated method with loss tracking and Firestore integration
  Future<void> addWorkout({
    required String type,
    required int intensity,
    required int durationMinutes,
    CatalogItem? item,
    double? userWeight,
  }) async {
    // Calculate losses if item is provided
    WorkoutLossResult? losses;
    if (item != null && userWeight != null) {
      losses = calculateWorkoutLosses(
        item: item,
        durationMinutes: durationMinutes,
        userWeight: userWeight,
      );
    }
    
    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
      intensity: intensity.clamp(1, 5),
      durationMinutes: durationMinutes,
      waterLossMl: losses?.waterLossMl ?? 0,
      sodiumLossMg: losses?.sodiumLossMg ?? 0,
      potassiumLossMg: losses?.potassiumLossMg ?? 0,
      magnesiumLossMg: losses?.magnesiumLossMg ?? 0,
      caloriesBurned: losses?.caloriesBurned ?? 0,
    );
    
    _todayWorkouts.add(workout);
    
    // Update total losses
    _totalWaterLossMl += workout.waterLossMl;
    _totalSodiumLossMg += workout.sodiumLossMg;
    _totalPotassiumLossMg += workout.potassiumLossMg;
    _totalMagnesiumLossMg += workout.magnesiumLossMg;
    
    // Track workout achievement
    _achievementTracker.trackWorkout(
      type: type,
      durationMinutes: durationMinutes,
      waterLossMl: workout.waterLossMl,
      category: _getWorkoutCategory(type),
    );
    
    // NEW: Save to Firestore via HistoryService
    await _saveWorkoutToFirestore(workout);
    
    await _recalculateHRI();
  }
  
  // Compatibility method for legacy calls
  Future<void> addWorkoutSimple({
    required String type,
    required int intensity,
    required int durationMinutes,
  }) async {
    await addWorkout(
      type: type,
      intensity: intensity,
      durationMinutes: durationMinutes,
    );
  }
  
  // Updated method with Firestore integration
  Future<void> addCaffeineIntake(double caffeineMg, {String source = 'coffee'}) async {
    if (caffeineMg <= 0) return;
    
    final intake = CaffeineIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      caffeineMg: caffeineMg,
      source: source,
    );
    
    _todayCaffeineIntakes.add(intake);
    
    // NEW: Save to Firestore via HistoryService
    await _saveCaffeineToFirestore(intake);
    
    await _recalculateHRI();
  }
  
  // Compatibility method for coffee intake
  Future<void> addCoffeeIntake(int caffeineMg) async {
    await addCaffeineIntake(caffeineMg.toDouble(), source: 'coffee');
  }
  
  Future<void> addAlcoholIntake(double standardDrinks) async {
    _todayAlcoholSD += standardDrinks;
    await _recalculateHRI();
  }
  
  Future<void> updateMorningCheckIn({
    required int feeling,
    double? weightChange,
    int? urineColor,
  }) async {
    _sleepQuality = feeling / 5.0;
    _morningWeight = weightChange ?? 0.0;
    _urineColor = urineColor ?? 3;
    await _recalculateHRI();
  }
  
  // ============================================================================
  // HRI CALCULATION - MAIN METHOD
  // ============================================================================
  
  Future<void> calculateHRI({
    required double waterIntake,
    required double waterGoal,
    required double sodiumIntake,
    required double sodiumGoal,
    double potassiumIntake = 0,
    double potassiumGoal = 0,
    double magnesiumIntake = 0,
    double magnesiumGoal = 0,
    double? heatIndex,
    int activityLevel = 0,
    int coffeeCups = 0,
    double alcoholSD = 0.0,
    double? sugarIntake,
    DateTime? lastIntakeTime,
    double? morningWeightChange,
    int? urineColorValue,
    double? sleepQualityValue,
    double? userWeightKg,
  }) async {
    _checkAndResetDaily();
    
    // Update alcohol SD if provided
    if (alcoholSD >= 0) {
      _todayAlcoholSD = alcoholSD;
    }
    
    // Update last intake time
    if (lastIntakeTime != null) {
      _lastIntakeTime = lastIntakeTime;
    }
    
    // Update morning data if provided
    if (morningWeightChange != null) _morningWeight = morningWeightChange;
    if (urineColorValue != null) _urineColor = urineColorValue;
    if (sleepQualityValue != null) _sleepQuality = sleepQualityValue;
    
    // ========== WATER COMPONENT WITH WORKOUT LOSSES ==========
    // Account for workout water losses
    double effectiveWaterIntake = waterIntake;
    double effectiveWaterGoal = waterGoal;
    
    if (_totalWaterLossMl > 0) {
      // Add losses to the goal (you need to drink more to compensate)
      effectiveWaterGoal += _totalWaterLossMl;
    }
    
    final waterRatio = effectiveWaterGoal > 0 ? (effectiveWaterIntake / effectiveWaterGoal) : 0.0;
    _components['water'] = _calculateWaterComponent(waterRatio);
    
    // ========== ELECTROLYTE COMPONENTS WITH WORKOUT LOSSES ==========
    // Account for electrolyte losses
    double effectiveSodiumGoal = sodiumGoal;
    double effectivePotassiumGoal = potassiumGoal;
    double effectiveMagnesiumGoal = magnesiumGoal;
    
    if (_totalSodiumLossMg > 0) {
      effectiveSodiumGoal += _totalSodiumLossMg;
    }
    if (_totalPotassiumLossMg > 0) {
      effectivePotassiumGoal += _totalPotassiumLossMg;
    }
    if (_totalMagnesiumLossMg > 0) {
      effectiveMagnesiumGoal += _totalMagnesiumLossMg;
    }
    
    final sodiumRatio = effectiveSodiumGoal > 0 ? (sodiumIntake / effectiveSodiumGoal) : 0.0;
    _components['sodium'] = _calculateElectrolyteComponent(sodiumRatio, maxPoints: 15);
    
    final potassiumRatio = effectivePotassiumGoal > 0 ? (potassiumIntake / effectivePotassiumGoal) : 0.0;
    _components['potassium'] = _calculateElectrolyteComponent(potassiumRatio, maxPoints: 10);
    
    final magnesiumRatio = effectiveMagnesiumGoal > 0 ? (magnesiumIntake / effectiveMagnesiumGoal) : 0.0;
    _components['magnesium'] = _calculateElectrolyteComponent(magnesiumRatio, maxPoints: 10);
    
    // ========== DEHYDRATION COMPONENT (NEW) ==========
    // Track uncompensated workout losses
    _components['dehydration'] = 0.0;
    if (_totalWaterLossMl > 0) {
      final compensationRatio = waterIntake / _totalWaterLossMl;
      if (compensationRatio < 0.5) {
        // Severe dehydration from workout
        _components['dehydration'] = 15.0;
      } else if (compensationRatio < 0.8) {
        // Moderate dehydration
        _components['dehydration'] = 10.0 * (1 - (compensationRatio - 0.5) / 0.3);
      } else if (compensationRatio < 1.0) {
        // Mild dehydration
        _components['dehydration'] = 5.0 * (1 - (compensationRatio - 0.8) / 0.2);
      }
    }
    
    // ========== HEAT COMPONENT ==========
    _components['heat'] = 0.0;
    if (heatIndex != null) {
      if (heatIndex >= 39) {
        _components['heat'] = 15;
      } else if (heatIndex >= 32) {
        _components['heat'] = 10;
      } else if (heatIndex >= 27) {
        _components['heat'] = 5;
      }
    }
    
    // ========== WORKOUT COMPONENT ==========
    _components['workouts'] = 0.0;
    for (final workout in _todayWorkouts) {
      _components['workouts'] = (_components['workouts']! + workout.getHRIImpact());
    }
    _components['workouts'] = min(20.0, _components['workouts']!);
    
    // ========== CAFFEINE COMPONENT ==========
    double totalActiveCaffeine = 0.0;
    for (final intake in _todayCaffeineIntakes) {
      totalActiveCaffeine += intake.getActiveCaffeine();
    }
    // Add coffee cups if provided
    if (coffeeCups > 0) {
      totalActiveCaffeine += coffeeCups * 95.0;
    }
    _components['caffeine'] = min(15.0, (totalActiveCaffeine / 100) * 2);
    
    // ========== ALCOHOL COMPONENT ==========
    final rc = RemoteConfigService.instance;
    final alcPerSD = rc.getDouble('alc_hri_risk_per_sd');
    final alcCap = rc.getDouble('alc_hri_risk_cap');
    _components['alcohol'] = min(alcCap, _todayAlcoholSD * alcPerSD);
    
    // ========== SUGAR COMPONENT ==========
    _components['sugar'] = 0.0;
    if (sugarIntake != null) {
      final sugarThreshold = rc.getDouble('sugar_hri_threshold_grams') ?? 50.0;
      final sugarMultiplier = rc.getDouble('sugar_hri_multiplier') ?? 0.2;
      final sugarMaxImpact = rc.getDouble('sugar_hri_max_impact') ?? 10.0;
      
      if (sugarIntake > sugarThreshold) {
        final excess = sugarIntake - sugarThreshold;
        _components['sugar'] = (excess * sugarMultiplier).clamp(0, sugarMaxImpact);
      }
    }
    
    // ========== TIME SINCE INTAKE COMPONENT ==========
    _components['timeSinceIntake'] = 0.0;
    if (_lastIntakeTime != null) {
      final hours = DateTime.now().difference(_lastIntakeTime!).inHours;
      if (hours > 3) {
        _components['timeSinceIntake'] = min(10.0, (hours - 3) * 2.0);
      }
    }
    
    // ========== MORNING CHECK-IN COMPONENT ==========
    _components['morning'] = 0.0;
    if (_morningWeight < -2.0) {
      _components['morning'] = _components['morning']! + 3;
    }
    if (_urineColor >= 6) {
      _components['morning'] = _components['morning']! + 4;
    } else if (_urineColor >= 4) {
      _components['morning'] = _components['morning']! + 2;
    }
    if (_sleepQuality < 0.5) {
      _components['morning'] = _components['morning']! + 3;
    }
    
    // ========== CALCULATE TOTAL HRI ==========
    double total = 0.0;
    _components.forEach((key, value) {
      total += value;
    });
    
    _currentHRI = total.clamp(0, 100);
    _lastUpdate = DateTime.now();
    
    // Update state tracking
    _lastWaterRatio = waterRatio;
    _lastWaterComponent = _components['water']!;
    
    // Debug output
    if (kDebugMode) {
      print('=== HRI Calculation Update ===');
      print('Water: ${_components['water']?.toStringAsFixed(1)} (ratio: ${waterRatio.toStringAsFixed(2)})');
      print('Sodium: ${_components['sodium']?.toStringAsFixed(1)}');
      print('Potassium: ${_components['potassium']?.toStringAsFixed(1)}');
      print('Magnesium: ${_components['magnesium']?.toStringAsFixed(1)}');
      print('Heat: ${_components['heat']?.toStringAsFixed(1)}');
      print('Workouts: ${_components['workouts']?.toStringAsFixed(1)} (${_todayWorkouts.length} workouts)');
      print('Dehydration: ${_components['dehydration']?.toStringAsFixed(1)} (loss: ${_totalWaterLossMl}ml)');
      print('Caffeine: ${_components['caffeine']?.toStringAsFixed(1)} (${totalActiveCaffeine.toStringAsFixed(0)}mg active)');
      print('Alcohol: ${_components['alcohol']?.toStringAsFixed(1)} (${_todayAlcoholSD.toStringAsFixed(1)} SD)');
      print('Sugar: ${_components['sugar']?.toStringAsFixed(1)}');
      print('Time: ${_components['timeSinceIntake']?.toStringAsFixed(1)}');
      print('Morning: ${_components['morning']?.toStringAsFixed(1)}');
      print('TOTAL HRI: ${_currentHRI.toStringAsFixed(1)}');
      print('==============================');
    }
    
    // Track HRI achievements
    _achievementTracker.trackHRI(
      hriValue: _currentHRI,
      status: hriStatus,
    );
    
    await _saveData();
    notifyListeners();
  }
  
  // ============================================================================
  // COMPONENT CALCULATIONS
  // ============================================================================
  
  double _calculateWaterComponent(double ratio) {
    if (ratio < 0.5) {
      // Severely under-hydrated
      return 40 * (1 - ratio * 2);
    } else if (ratio < 0.8) {
      // Mildly under-hydrated
      return 20 * (1 - (ratio - 0.5) / 0.3);
    } else if (ratio <= 1.2) {
      // Normal range
      return 0;
    } else {
      // Over-hydrated
      return min(20, (ratio - 1.2) * 50);
    }
  }
  
  double _calculateElectrolyteComponent(double ratio, {double maxPoints = 15}) {
    if (ratio < 0.3) {
      // Severely low
      return maxPoints;
    } else if (ratio < 0.7) {
      // Mildly low
      return maxPoints * (1 - (ratio - 0.3) / 0.4);
    } else if (ratio <= 1.3) {
      // Normal range
      return 0;
    } else {
      // Excess
      return min(maxPoints * 0.5, (ratio - 1.3) * maxPoints);
    }
  }
  
  // ============================================================================
  // ENHANCED RECALCULATE WITH AUTOSAVE
  // ============================================================================
  
  Future<void> _recalculateHRI() async {
    // Recalculate workout component
    _components['workouts'] = 0.0;
    for (final workout in _todayWorkouts) {
      _components['workouts'] = (_components['workouts']! + workout.getHRIImpact());
    }
    _components['workouts'] = min(20.0, _components['workouts']!);
    
    // Recalculate dehydration component
    _components['dehydration'] = 0.0;
    if (_totalWaterLossMl > 100) {
      _components['dehydration'] = min(15.0, _totalWaterLossMl / 200.0);
    }
    
    // Recalculate caffeine component
    double totalActiveCaffeine = 0.0;
    for (final intake in _todayCaffeineIntakes) {
      totalActiveCaffeine += intake.getActiveCaffeine();
    }
    _components['caffeine'] = min(15.0, (totalActiveCaffeine / 100) * 2);
    
    // Recalculate alcohol component
    final rc = RemoteConfigService.instance;
    final alcPerSD = rc.getDouble('alc_hri_risk_per_sd');
    final alcCap = rc.getDouble('alc_hri_risk_cap');
    _components['alcohol'] = min(alcCap, _todayAlcoholSD * alcPerSD);
    
    // Recalculate total
    double total = 0.0;
    _components.forEach((key, value) {
      total += value;
    });
    
    _currentHRI = total.clamp(0, 100);
    _lastUpdate = DateTime.now();
    
    await _saveData();
    notifyListeners();
    
    // NEW: Auto-save snapshot at specific times (e.g., 23:00)
    final now = DateTime.now();
    if (now.hour == 23 && now.minute == 0) {
      await saveCurrentDaySnapshot();
    }
  }
  
  // ============================================================================
  // AUTOMATIC HRI SAVING
  // ============================================================================
  
  /// Save current HRI snapshot to history when day changes
  Future<void> _saveEndOfDaySnapshot() async {
    try {
      final historyService = HistoryService();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      
      await historyService.saveDailyHRI(
        date: yesterday,
        hri: _currentHRI,
        status: hriStatus,
        components: Map<String, double>.from(_components),
      );
      
      print('End-of-day HRI snapshot saved for ${_formatDate(yesterday)}');
    } catch (e) {
      print('Error saving end-of-day HRI snapshot: $e');
    }
  }
  
  /// Manual save of current day's HRI (for testing or end-of-day triggers)
  Future<void> saveCurrentDaySnapshot() async {
    try {
      final historyService = HistoryService();
      final today = DateTime.now();
      
      await historyService.saveDailyHRI(
        date: today,
        hri: _currentHRI,
        status: hriStatus,
        components: Map<String, double>.from(_components),
      );
      
      print('Current day HRI snapshot saved: HRI ${_currentHRI.toStringAsFixed(1)}, Status: $hriStatus');
    } catch (e) {
      print('Error saving current day HRI snapshot: $e');
    }
  }
  
  /// Utility method for date formatting
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  Future<void> resetDaily() async {
    _currentHRI = 25.0;
    _todayWorkouts.clear();
    _todayCaffeineIntakes.clear();
    _todayAlcoholSD = 0.0;
    _totalWaterLossMl = 0;
    _totalSodiumLossMg = 0;
    _totalPotassiumLossMg = 0;
    _totalMagnesiumLossMg = 0;
    _lastIntakeTime = null;
    _components.updateAll((key, value) => 0.0);
    _lastUpdate = DateTime.now();
    
    await _saveData();
    notifyListeners();
  }

  // Helper method to categorize workouts for achievements
  String _getWorkoutCategory(String type) {
    // Map workout types to categories
    if (type.contains('cardio') || type.contains('run') || type.contains('bike')) {
      return 'cardio';
    } else if (type.contains('strength') || type.contains('weight') || type.contains('gym')) {
      return 'strength';
    }
    return 'general';
  }

}