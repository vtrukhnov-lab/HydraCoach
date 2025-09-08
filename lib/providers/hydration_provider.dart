// ============================================================================
// FILE: lib/providers/hydration_provider.dart
// 
// PURPOSE: Provider for hydration tracking and goals management
// FIXED: Extracted from main.dart for better architecture
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' as math;

import '../l10n/app_localizations.dart';
import '../services/notification_service.dart' as notif;
import '../services/remote_config_service.dart';
import '../services/hri_service.dart';
import '../services/alcohol_service.dart';
import '../services/weather_service.dart';
import '../models/daily_goals.dart';
import '../models/intake.dart';

// Internal status enum for logic (not exposed to UI)
enum _HydrationStatusInternal {
  normal,
  diluted,
  dehydrated,
  lowSalt,
}

class HydrationProvider extends ChangeNotifier {
  double weight = 70;
  String dietMode = 'normal';
  String activityLevel = 'medium'; // Kept for compatibility
  List<Intake> todayIntakes = [];
  
  double weatherWaterAdjustment = 0;
  int weatherSodiumAdjustment = 0;
  
  // Alcohol adjustments
  double alcoholWaterAdjustment = 0;
  int alcoholSodiumAdjustment = 0;
  
  late DailyGoals goals;
  
  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;
  
  HydrationProvider() {
    _calculateGoals();
    _loadData();
    _checkAndResetDaily();
    _subscribeFCMTopics();
  }
  
  // ============ HRI SERVICE INTEGRATION ============
  
  // Log workout
  Future<void> logWorkout({
    required String type,
    required int intensity, // 1-5
    required int durationMinutes,
  }) async {
    final hriService = HRIService();
    await hriService.addWorkout(
      type: type,
      intensity: intensity,
      durationMinutes: durationMinutes,
    );
    notifyListeners();
  }
  
  // Log caffeine
  Future<void> logCoffeeIntake(int caffeineMg) async {
    final hriService = HRIService();
    await hriService.addCoffeeIntake(caffeineMg);
    notifyListeners();
  }
  
  // Log alcohol through HRI
  Future<void> logAlcoholIntake(double standardDrinks) async {
    final hriService = HRIService();
    await hriService.addAlcoholIntake(standardDrinks);
    notifyListeners();
  }
  
  // Update HRI with full data
  Future<void> updateHRI({
    required HRIService hriService,
    AlcoholService? alcoholService,
    WeatherService? weatherService,
  }) async {
    // Calculate current electrolytes
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    
    for (var intake in todayIntakes) {
      totalSodium += intake.sodium;
      totalPotassium += intake.potassium;
      totalMagnesium += intake.magnesium;
    }
    
    // Call full HRI calculation
    await hriService.calculateHRI(
      waterIntake: totalWaterToday,
      waterGoal: goals.waterOpt.toDouble(),
      sodiumIntake: totalSodium.toDouble(),
      sodiumGoal: goals.sodium.toDouble(),
      potassiumIntake: totalPotassium.toDouble(),
      potassiumGoal: goals.potassium.toDouble(),
      magnesiumIntake: totalMagnesium.toDouble(),
      magnesiumGoal: goals.magnesium.toDouble(),
      heatIndex: weatherService?.heatIndex,
      lastIntakeTime: lastIntakeTime,
      userWeightKg: weight,
    );
  }
  
  // ============ GETTERS ============
  
  double get totalWaterToday {
    double total = 0;
    for (var intake in todayIntakes) {
      if (intake.type == 'water' || 
          intake.type == 'electrolyte' || 
          intake.type == 'broth') {
        total += intake.volume;
      }
    }
    return total;
  }
  
  int get totalSodiumToday {
    int total = 0;
    for (var intake in todayIntakes) {
      total += intake.sodium;
    }
    return total;
  }
  
  int get totalPotassiumToday {
    int total = 0;
    for (var intake in todayIntakes) {
      total += intake.potassium;
    }
    return total;
  }
  
  int get totalMagnesiumToday {
    int total = 0;
    for (var intake in todayIntakes) {
      total += intake.magnesium;
    }
    return total;
  }
  
  int get coffeeCupsToday {
    return todayIntakes.where((intake) => intake.type == 'coffee').length;
  }
  
  DateTime? get lastIntakeTime {
    if (todayIntakes.isEmpty) return null;
    return todayIntakes.last.timestamp;
  }
  
  // ============ CORE METHODS ============
  
  void _subscribeFCMTopics() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic('all_users');
    
    if (dietMode == 'keto') {
      await messaging.subscribeToTopic('keto_users');
    } else if (dietMode == 'fasting') {
      await messaging.subscribeToTopic('fasting_users');
    }
    
    await messaging.subscribeToTopic('weather_alerts');
  }
  
  void _calculateGoals() {
    // Always start with BASE values
    int baseWaterMin = (_remoteConfig.waterMinPerKg * weight).round();
    int baseWaterOpt = (_remoteConfig.waterOptPerKg * weight).round();
    int baseWaterMax = (_remoteConfig.waterMaxPerKg * weight).round();
    
    // Start with base values
    int waterMin = baseWaterMin;
    int waterOpt = baseWaterOpt;
    int waterMax = baseWaterMax;
    
    // Apply weather correction (percentage increase from BASE)
    if (weatherWaterAdjustment > 0) {
      waterMin = (baseWaterMin * (1 + weatherWaterAdjustment)).round();
      waterOpt = (baseWaterOpt * (1 + weatherWaterAdjustment)).round();
      waterMax = (baseWaterMax * (1 + weatherWaterAdjustment)).round();
    }
    
    // Apply alcohol correction (addition to already corrected values)
    if (alcoholWaterAdjustment > 0) {
      waterMin += alcoholWaterAdjustment.round();
      waterOpt += alcoholWaterAdjustment.round();
      waterMax += alcoholWaterAdjustment.round();
    }
    
    // BASE electrolyte values
    int baseSodium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.sodiumKeto 
        : _remoteConfig.sodiumNormal;
    int basePotassium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.potassiumKeto 
        : _remoteConfig.potassiumNormal;
    int baseMagnesium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.magnesiumKeto 
        : _remoteConfig.magnesiumNormal;
    
    // Start with base values
    int sodium = baseSodium;
    int potassium = basePotassium;
    int magnesium = baseMagnesium;
    
    // Add weather salt correction
    sodium += weatherSodiumAdjustment;
    
    // Add alcohol salt correction
    sodium += alcoholSodiumAdjustment;
    
    // Create final goals
    goals = DailyGoals(
      waterMin: waterMin,
      waterOpt: waterOpt,
      waterMax: waterMax,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    );
  }
  
  void updateAlcoholAdjustments(double waterAdjustment, int sodiumAdjustment) {
    alcoholWaterAdjustment = waterAdjustment;
    alcoholSodiumAdjustment = sodiumAdjustment;
    _calculateGoals();
    notifyListeners();
  }
  
  void updateWeatherAdjustments(double waterAdjustment, int sodiumAdjustment) {
    weatherWaterAdjustment = waterAdjustment;
    weatherSodiumAdjustment = sodiumAdjustment;
    _calculateGoals();
    notifyListeners();
  }
  
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    weight = prefs.getDouble('weight') ?? 70;
    dietMode = prefs.getString('dietMode') ?? 'normal';
    activityLevel = prefs.getString('activityLevel') ?? 'medium';
    
    final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
    final intakesJson = prefs.getStringList(todayKey) ?? [];
    
    todayIntakes = intakesJson.map((json) {
      final parts = json.split('|');
      return Intake(
        id: parts[0],
        timestamp: DateTime.parse(parts[1]),
        type: parts[2],
        volume: int.parse(parts[3]),
        sodium: int.parse(parts[4]),
        potassium: int.parse(parts[5]),
        magnesium: int.parse(parts[6]),
      );
    }).toList();
    
    _calculateGoals();
    notifyListeners();
  }
  
  // Save method
  Future<void> _saveIntakes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
      
      final intakesJson = todayIntakes.map((intake) {
        return '${intake.id}|${intake.timestamp.toIso8601String()}|${intake.type}|'
               '${intake.volume}|${intake.sodium}|${intake.potassium}|${intake.magnesium}';
      }).toList();
      
      await prefs.setStringList(todayKey, intakesJson);
      
      final progress = getProgress();
      await prefs.setDouble('waterProgress', progress['waterPercent']!);
    } catch (e) {
      print('Error saving intakes: $e');
    }
  }
  
  void _checkAndResetDaily() {
    final now = DateTime.now();
    const lastResetKey = 'lastReset';
    
    SharedPreferences.getInstance().then((prefs) {
      final lastResetStr = prefs.getString(lastResetKey);
      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);
        if (lastReset.day != now.day) {
          todayIntakes.clear();
          prefs.setString(lastResetKey, now.toIso8601String());
          notifyListeners();
          
          notif.NotificationService().scheduleEveningReport();
        }
      } else {
        prefs.setString(lastResetKey, now.toIso8601String());
      }
    });
  }
  
  void updateProfile({
    required double weight,
    required String dietMode,
    required String activityLevel,
    String? fastingSchedule,
  }) {
    this.weight = weight;
    this.dietMode = dietMode;
    this.activityLevel = activityLevel;
    _calculateGoals();
    _saveProfile();
    _subscribeFCMTopics();
    notifyListeners();
  }
  
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight);
    await prefs.setString('dietMode', dietMode);
    await prefs.setString('activityLevel', activityLevel);
  }
  
  // Updated addIntake with HRI integration for coffee
  void addIntake(String type, int volume, {int sodium = 0, int potassium = 0, int magnesium = 0}) {
    // Add to list
    todayIntakes.add(Intake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
      volume: volume,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    ));
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // First notify UI about changes
    notifyListeners();
    
    // Then save asynchronously
    _saveIntakes().then((_) {
      print('Intake saved successfully');
    }).catchError((error) {
      print('Error saving intake: $error');
    });
    
    // Schedule post-coffee reminder if it's coffee
    if (type == 'coffee') {
    // Просто вызываем без обработки результата
    notif.NotificationService().schedulePostCoffeeReminder();
  
    // Log coffee to HRI (approximately 80mg caffeine per cup)
    logCoffeeIntake(80);
  }
}
  
  void removeIntake(String id) {
    todayIntakes.removeWhere((intake) => intake.id == id);
    
    // First update UI
    notifyListeners();
    
    // Then save
    _saveIntakes().then((_) {
      print('Intake removed successfully');
    });
  }
  
  Map<String, double> getProgress() {
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    
    for (var intake in todayIntakes) {
      if (intake.type == 'water' || intake.type == 'electrolyte' || intake.type == 'broth') {
        totalWater += intake.volume;
      }
      totalSodium += intake.sodium;
      totalPotassium += intake.potassium;
      totalMagnesium += intake.magnesium;
    }
    
    return {
      'water': totalWater.toDouble(),
      'waterPercent': math.min((totalWater / goals.waterOpt) * 100, 100),
      'sodium': totalSodium.toDouble(),
      'sodiumPercent': math.min((totalSodium / goals.sodium) * 100, 100),
      'potassium': totalPotassium.toDouble(),
      'potassiumPercent': math.min((totalPotassium / goals.potassium) * 100, 100),
      'magnesium': totalMagnesium.toDouble(),
      'magnesiumPercent': math.min((totalMagnesium / goals.magnesium) * 100, 100),
    };
  }
  
  // Private method to get internal status enum (for logic)
  _HydrationStatusInternal _getInternalHydrationStatus() {
    final progress = getProgress();
    final waterRatio = progress['water']! / goals.waterOpt;
    final sodiumRatio = progress['sodium']! / goals.sodium;
    
    if (waterRatio > _remoteConfig.dilutionWaterThreshold && 
        sodiumRatio < _remoteConfig.dilutionSodiumThreshold) {
      return _HydrationStatusInternal.diluted;
    } else if (waterRatio < _remoteConfig.dehydrationThreshold) {
      return _HydrationStatusInternal.dehydrated;
    } else if (sodiumRatio < _remoteConfig.lowSaltThreshold) {
      return _HydrationStatusInternal.lowSalt;
    } else {
      return _HydrationStatusInternal.normal;
    }
  }
  
  // Public method to get localized status string
  String getHydrationStatus(AppLocalizations l10n) {
    final status = _getInternalHydrationStatus();
    
    switch (status) {
      case _HydrationStatusInternal.normal:
        return l10n.hydrationStatusNormal;
      case _HydrationStatusInternal.diluted:
        return l10n.hydrationStatusDiluted;
      case _HydrationStatusInternal.dehydrated:
        return l10n.hydrationStatusDehydrated;
      case _HydrationStatusInternal.lowSalt:
        return l10n.hydrationStatusLowSalt;
    }
  }
  
  // DEPRECATED: Old getHRI method - kept for compatibility
  // Use HRIService directly
  @deprecated
  int getHRI(AlcoholService? alcoholService) {
    final status = _getInternalHydrationStatus();
    int baseHRI = 0;
    
    // Use internal enum for logic
    switch (status) {
      case _HydrationStatusInternal.normal:
        baseHRI = 15;
        break;
      case _HydrationStatusInternal.lowSalt:
        baseHRI = 45;
        break;
      case _HydrationStatusInternal.dehydrated:
        baseHRI = 55;
        break;
      case _HydrationStatusInternal.diluted:
        baseHRI = 65;
        break;
    }
    
    // Add weather risk
    if (weatherWaterAdjustment > 0.1) {
      baseHRI += 10;
    }
    
    // Add alcohol risk
    if (alcoholService != null) {
      baseHRI += alcoholService.totalHRIModifier.round();
    }
    
    return math.min(baseHRI, 100);
  }
}