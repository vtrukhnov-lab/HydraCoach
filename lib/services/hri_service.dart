// lib/services/hri_service.dart
// 
// HRI (Hydration Risk Index) Service - Complete Rewrite
// Manages hydration risk calculation with all factors
// UPDATED: Added sugar component

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'remote_config_service.dart';

// ============================================================================
// DATA MODELS
// ============================================================================

class Workout {
  final String id;
  final DateTime timestamp;
  final String type;
  final int intensity; // 1-5
  final int durationMinutes;
  
  Workout({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.intensity,
    required this.durationMinutes,
  });
  
  // Calculate HRI impact based on intensity, duration and time elapsed
  double getHRIImpact() {
    // Base impact: intensity * duration factor
    double base = intensity * (durationMinutes / 30.0);
    
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
  };
  
  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
    intensity: json['intensity'],
    durationMinutes: json['durationMinutes'],
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

// ============================================================================
// HRI SERVICE
// ============================================================================

class HRIService extends ChangeNotifier {
  // Storage keys
  static const String _hriKey = 'current_hri';
  static const String _componentsKey = 'hri_components';
  static const String _lastUpdateKey = 'hri_last_update';
  static const String _workoutsKey = 'today_workouts';
  static const String _caffeineKey = 'today_caffeine';
  static const String _alcoholKey = 'today_alcohol_sd';
  
  // Current HRI value and components
  double _currentHRI = 25.0; // Start at low risk
  DateTime _lastUpdate = DateTime.now();
  
  // Today's data
  final List<Workout> _todayWorkouts = [];
  final List<CaffeineIntake> _todayCaffeineIntakes = [];
  double _todayAlcoholSD = 0.0;
  
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
    'sugar': 0.0,  // NEW: Sugar component
    'timeSinceIntake': 0.0,
    'morning': 0.0,
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
      // Sum up original caffeine amounts (not decayed)
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
    
    // Load today's workouts
    final workoutsJson = prefs.getStringList(_workoutsKey) ?? [];
    _todayWorkouts.clear();
    for (final json in workoutsJson) {
      try {
        final parts = json.split('|');
        if (parts.length >= 5) {
          _todayWorkouts.add(Workout(
            id: parts[0],
            timestamp: DateTime.parse(parts[1]),
            type: parts[2],
            intensity: int.parse(parts[3]),
            durationMinutes: int.parse(parts[4]),
          ));
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
    
    // Save workouts
    final workoutsJson = _todayWorkouts.map((w) =>
      '${w.id}|${w.timestamp.toIso8601String()}|${w.type}|${w.intensity}|${w.durationMinutes}'
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
  
  void _checkAndResetDaily() {
    final now = DateTime.now();
    if (_lastUpdate.day != now.day || 
        _lastUpdate.month != now.month || 
        _lastUpdate.year != now.year) {
      // New day - reset daily data
      _todayWorkouts.clear();
      _todayCaffeineIntakes.clear();
      _todayAlcoholSD = 0.0;
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
    // Could adjust HRI calculation if needed during fasting
  }
  
  // ============================================================================
  // DATA INPUT METHODS
  // ============================================================================
  
  Future<void> addWorkout({
    required String type,
    required int intensity,
    required int durationMinutes,
  }) async {
    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
      intensity: intensity.clamp(1, 5),
      durationMinutes: durationMinutes,
    );
    
    _todayWorkouts.add(workout);
    await _recalculateHRI();
  }
  
  Future<void> addCaffeineIntake(double caffeineMg, {String source = 'coffee'}) async {
    if (caffeineMg <= 0) return;
    
    final intake = CaffeineIntake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      caffeineMg: caffeineMg,
      source: source,
    );
    
    _todayCaffeineIntakes.add(intake);
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
    double? sugarIntake,  // NEW: Sugar intake parameter
    DateTime? lastIntakeTime,
    double? morningWeightChange,
    int? urineColorValue,
    double? sleepQualityValue,
    double? userWeightKg,
  }) async {
    _checkAndResetDaily();
    
    // Update alcohol SD if provided (FIXED: always update when provided)
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
    
    // ========== WATER COMPONENT ==========
    final waterRatio = waterGoal > 0 ? (waterIntake / waterGoal) : 0.0;
    _components['water'] = _calculateWaterComponent(waterRatio);
    
    // ========== ELECTROLYTE COMPONENTS ==========
    final sodiumRatio = sodiumGoal > 0 ? (sodiumIntake / sodiumGoal) : 0.0;
    _components['sodium'] = _calculateElectrolyteComponent(sodiumRatio, maxPoints: 15);
    
    final potassiumRatio = potassiumGoal > 0 ? (potassiumIntake / potassiumGoal) : 0.0;
    _components['potassium'] = _calculateElectrolyteComponent(potassiumRatio, maxPoints: 10);
    
    final magnesiumRatio = magnesiumGoal > 0 ? (magnesiumIntake / magnesiumGoal) : 0.0;
    _components['magnesium'] = _calculateElectrolyteComponent(magnesiumRatio, maxPoints: 10);
    
    // ========== HEAT COMPONENT ==========
    _components['heat'] = 0.0;
    if (heatIndex != null) {
      // DEBUG: Log heat index calculation
      print('=== HEAT COMPONENT DEBUG ===');
      print('Heat Index received: $heatIndex°C');
      
      if (heatIndex >= 39) {
        _components['heat'] = 15;
        print('Heat component set to 15 (extreme heat)');
      } else if (heatIndex >= 32) {
        _components['heat'] = 10;
        print('Heat component set to 10 (high heat)');
      } else if (heatIndex >= 27) {
        _components['heat'] = 5;
        print('Heat component set to 5 (moderate heat)');
      } else {
        print('Heat component set to 0 (comfortable)');
      }
      print('Final heat component: ${_components['heat']}');
      print('===========================');
    } else {
      print('WARNING: Heat Index is null');
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
      totalActiveCaffeine += coffeeCups * 95.0; // Average caffeine per cup
    }
    _components['caffeine'] = min(15.0, (totalActiveCaffeine / 100) * 2);
    
    // ========== ALCOHOL COMPONENT ==========
    final rc = RemoteConfigService.instance;
    final alcPerSD = rc.getDouble('alc_hri_risk_per_sd');
    final alcCap = rc.getDouble('alc_hri_risk_cap');
    
    // Use the current total SD (FIXED: now properly updated)
    _components['alcohol'] = min(alcCap, _todayAlcoholSD * alcPerSD);
    
    // ========== SUGAR COMPONENT (NEW) ==========
    _components['sugar'] = 0.0;
    if (sugarIntake != null) {
      final sugarThreshold = rc.getDouble('sugar_hri_threshold_grams') ?? 50.0;
      final sugarMultiplier = rc.getDouble('sugar_hri_multiplier') ?? 0.2;
      final sugarMaxImpact = rc.getDouble('sugar_hri_max_impact') ?? 10.0;
      
      if (sugarIntake > sugarThreshold) {
        final excess = sugarIntake - sugarThreshold;
        _components['sugar'] = (excess * sugarMultiplier).clamp(0, sugarMaxImpact);
        
        // Debug logging
        if (kDebugMode) {
          print('=== SUGAR COMPONENT DEBUG ===');
          print('Sugar intake: ${sugarIntake}g');
          print('Threshold: ${sugarThreshold}g');
          print('Excess: ${excess}g');
          print('Multiplier: $sugarMultiplier');
          print('Sugar HRI impact: ${_components['sugar']}');
          print('=============================');
        }
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
      print('Heat: ${_components['heat']?.toStringAsFixed(1)} (index: ${heatIndex?.toStringAsFixed(1)})');
      print('Workouts: ${_components['workouts']?.toStringAsFixed(1)} (${_todayWorkouts.length} workouts)');
      print('Caffeine: ${_components['caffeine']?.toStringAsFixed(1)} (${totalActiveCaffeine.toStringAsFixed(0)}mg active)');
      print('Alcohol: ${_components['alcohol']?.toStringAsFixed(1)} (${_todayAlcoholSD.toStringAsFixed(1)} SD)');
      print('Sugar: ${_components['sugar']?.toStringAsFixed(1)} (${sugarIntake?.toStringAsFixed(1)}g intake)');  // NEW
      print('Time: ${_components['timeSinceIntake']?.toStringAsFixed(1)}');
      print('Morning: ${_components['morning']?.toStringAsFixed(1)}');
      print('TOTAL HRI: ${_currentHRI.toStringAsFixed(1)}');
      print('==============================');
    }
    
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
  // HELPER METHODS
  // ============================================================================
  
  Future<void> _recalculateHRI() async {
    // This method is called when we add workouts, caffeine, or alcohol
    // but don't have full hydration data. We just update those components.
    
    // Recalculate workout component
    _components['workouts'] = 0.0;
    for (final workout in _todayWorkouts) {
      _components['workouts'] = (_components['workouts']! + workout.getHRIImpact());
    }
    _components['workouts'] = min(20.0, _components['workouts']!);
    
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
    
    // Note: Sugar component requires full data from HydrationProvider,
    // so it's only updated in the main calculateHRI method
    
    // Recalculate total
    double total = 0.0;
    _components.forEach((key, value) {
      total += value;
    });
    
    _currentHRI = total.clamp(0, 100);
    _lastUpdate = DateTime.now();
    
    await _saveData();
    notifyListeners();
  }
  
  Future<void> resetDaily() async {
    _currentHRI = 25.0;
    _todayWorkouts.clear();
    _todayCaffeineIntakes.clear();
    _todayAlcoholSD = 0.0;
    _lastIntakeTime = null;
    _components.updateAll((key, value) => 0.0);
    _lastUpdate = DateTime.now();
    
    await _saveData();
    notifyListeners();
  }
}