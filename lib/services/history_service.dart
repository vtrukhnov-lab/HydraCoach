// lib/services/history_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/utils/app_logger.dart';

import '../models/intake.dart';
import '../models/alcohol_intake.dart';
import '../models/food_intake.dart';
import 'hri_service.dart';
import 'alcohol_service.dart';

/// Complete history service with Firestore integration
/// Handles migration from SharedPreferences and provides unified data access
class HistoryService {
  static const String _migrationKey = 'firestore_migration_v2';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;
  bool get _isAuthenticated => _userId != null;

  // ============================================================================
  // HRI DAILY SNAPSHOT METHODS (NEW)
  // ============================================================================

  /// Save daily HRI snapshot at end of day
  Future<void> saveDailyHRI({
    required DateTime date,
    required double hri,
    required String status,
    required Map<String, double> components,
  }) async {
    if (!_isAuthenticated) {
      logger.i('Cannot save HRI: user not authenticated');
      return;
    }

    try {
      final dateKey = _formatDateKey(date);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('daily_hri')
          .doc(dateKey)
          .set({
            'date': dateKey,
            'hri': hri,
            'status': status,
            'components': components,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          });

      logger.i('Daily HRI saved: $dateKey - HRI: $hri, Status: $status');
    } catch (e) {
      logger.i('Error saving daily HRI: $e');
    }
  }

  /// Get HRI data for specific date
  Future<Map<String, dynamic>?> getHRIForDate(DateTime date) async {
    // For today, don't use Firestore - use live HRI service
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return null; // Signal to use live HRI service
    }

    if (!_isAuthenticated) {
      return _getHRIFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('daily_hri')
          .doc(dateKey)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        return {
          'hri': data['hri']?.toDouble() ?? 0.0,
          'status': data['status'] ?? 'Unknown',
          'components': Map<String, double>.from(data['components'] ?? {}),
          'timestamp': data['timestamp'],
        };
      }

      // Fallback to SharedPreferences for older data
      return _getHRIFromPrefs(date);
    } catch (e) {
      logger.i('Error loading HRI from Firestore: $e');
      return _getHRIFromPrefs(date);
    }
  }

  /// Get HRI from SharedPreferences (fallback)
  Future<Map<String, dynamic>?> _getHRIFromPrefs(DateTime date) async {
    // For now, return null - historical HRI will be built up over time
    // In future, could try to calculate from historical data
    return null;
  }

  /// Save end-of-day snapshot from HRI service (call this at day transition)
  Future<void> saveEndOfDaySnapshot(
    HRIService hriService,
    DateTime date,
  ) async {
    await saveDailyHRI(
      date: date,
      hri: hriService.currentHRI,
      status: hriService.hriStatus,
      components: hriService.components,
    );
  }

  // ============================================================================
  // DAILY DATA METHODS
  // ============================================================================

  /// Get all intakes for a specific date
  Future<List<Intake>> getIntakesForDate(DateTime date) async {
    if (!_isAuthenticated) {
      return _getIntakesFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      // Try Firestore first
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('intakes')
          .where('date', isEqualTo: dateKey)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _intakeFromFirestore(doc)).toList();
      }

      // Fallback to SharedPreferences
      return _getIntakesFromPrefs(date);
    } catch (e) {
      logger.i('Error loading intakes from Firestore: $e');
      return _getIntakesFromPrefs(date);
    }
  }

  /// Get alcohol intakes for a specific date
  Future<List<AlcoholIntake>> getAlcoholForDate(DateTime date) async {
    if (!_isAuthenticated) {
      return _getAlcoholFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('alcohol_intakes')
          .where('date', isEqualTo: dateKey)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _alcoholFromFirestore(doc)).toList();
      }

      return _getAlcoholFromPrefs(date);
    } catch (e) {
      logger.i('Error loading alcohol from Firestore: $e');
      return _getAlcoholFromPrefs(date);
    }
  }

  /// Get food intakes for a specific date
  Future<List<FoodIntake>> getFoodForDate(DateTime date) async {
    if (!_isAuthenticated) {
      return _getFoodFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('food_intakes')
          .where('date', isEqualTo: dateKey)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _foodFromFirestore(doc)).toList();
      }

      return _getFoodFromPrefs(date);
    } catch (e) {
      logger.i('Error loading food from Firestore: $e');
      return _getFoodFromPrefs(date);
    }
  }

  /// Get caffeine intakes for a specific date
  Future<List<Map<String, dynamic>>> getCaffeineForDate(DateTime date) async {
    if (!_isAuthenticated) {
      return _getCaffeineFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('caffeine_intakes')
          .where('date', isEqualTo: dateKey)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map(
              (doc) => {
                'id': doc.id,
                'timestamp':
                    (doc['timestamp'] as Timestamp).millisecondsSinceEpoch,
                'amount': doc['amount'],
                'source': doc['source'],
              },
            )
            .toList();
      }

      return _getCaffeineFromPrefs(date);
    } catch (e) {
      logger.i('Error loading caffeine from Firestore: $e');
      return _getCaffeineFromPrefs(date);
    }
  }

  /// Get workouts for a specific date
  Future<List<Workout>> getWorkoutsForDate(DateTime date) async {
    if (!_isAuthenticated) {
      return _getWorkoutsFromPrefs(date);
    }

    try {
      final dateKey = _formatDateKey(date);

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .where('date', isEqualTo: dateKey)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => _workoutFromFirestore(doc)).toList();
      }

      return _getWorkoutsFromPrefs(date);
    } catch (e) {
      logger.i('Error loading workouts from Firestore: $e');
      return _getWorkoutsFromPrefs(date);
    }
  }

  // ============================================================================
  // DAY SUMMARY METHOD (NEW - for new summary card)
  // ============================================================================

  /// Get complete day summary with all metrics
  Future<Map<String, dynamic>> getDaySummary(DateTime date) async {
    final intakes = await getIntakesForDate(date);
    final alcohol = await getAlcoholForDate(date);
    final food = await getFoodForDate(date);
    final caffeine = await getCaffeineForDate(date);
    final workouts = await getWorkoutsForDate(date);
    final hriData = await getHRIForDate(date);

    // Calculate totals
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    int coffeeCount = 0;
    int intakeEvents = intakes.length;

    for (final intake in intakes) {
      if (intake.isWaterIntake) {
        totalWater += intake.volume;
      }
      if (intake.type == 'coffee') coffeeCount++;
      totalSodium += intake.sodium;
      totalPotassium += intake.potassium;
      totalMagnesium += intake.magnesium;
    }

    double totalAlcoholSD = 0;
    for (final alc in alcohol) {
      totalAlcoholSD += alc.standardDrinks;
    }

    int totalCaffeineMg = 0;
    for (final caff in caffeine) {
      totalCaffeineMg += (caff['amount'] as num).round();
    }

    int totalWorkoutMinutes = 0;
    for (final workout in workouts) {
      totalWorkoutMinutes += workout.durationMinutes;
    }

    // Calculate food totals
    int totalCalories = 0;
    double totalFoodSugar = 0;
    double totalFoodWater = 0;
    int foodCount = food.length;
    for (final foodIntake in food) {
      totalCalories += foodIntake.calories;
      totalFoodSugar += foodIntake.sugar;
      totalFoodWater += foodIntake.waterContent;
      totalSodium += foodIntake.sodium;
      totalPotassium += foodIntake.potassium;
      totalMagnesium += foodIntake.magnesium;
    }

    // Получаем сохраненные цели дня из Firestore или рассчитываем базовые
    Map<String, dynamic>? dayGoals;
    if (_isAuthenticated) {
      try {
        final dateKey = _formatDateKey(date);
        final goalsDoc = await _firestore
            .collection('users')
            .doc(_userId)
            .collection('daily_goals')
            .doc(dateKey)
            .get();

        if (goalsDoc.exists) {
          dayGoals = goalsDoc.data();
        }
      } catch (e) {
        logger.i('Error loading goals for $date: $e');
      }
    }

    return {
      'date': date,
      'water': totalWater,
      'waterGoal': dayGoals?['waterOpt'], // Добавлено: цель воды того дня
      'sodium': totalSodium,
      'potassium': totalPotassium,
      'magnesium': totalMagnesium,
      'intakeEvents': intakeEvents,
      'coffeeCount': coffeeCount,
      'alcoholSD': totalAlcoholSD,
      'caffeineTotal': totalCaffeineMg,
      'workoutCount': workouts.length,
      'workoutMinutes': totalWorkoutMinutes,
      'hri': hriData?['hri'],
      'hriStatus': hriData?['status'],
      'hasAlcohol': alcohol.isNotEmpty,
      'hasWorkouts': workouts.isNotEmpty,
      'hasFood': food.isNotEmpty,
      'foodCount': foodCount,
      'totalCalories': totalCalories,
      'totalFoodSugar': totalFoodSugar,
      'totalFoodWater': totalFoodWater,
      'goals': dayGoals, // Добавлено: все цели дня
    };
  }

  // ============================================================================
  // SAVE METHODS (для интеграции с другими сервисами)
  // ============================================================================

  /// Save intake to Firestore (called from HydrationProvider)
  Future<void> saveIntake(Intake intake) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(intake.timestamp);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('intakes')
          .doc(intake.id)
          .set({
            'date': dateKey,
            'timestamp': Timestamp.fromDate(intake.timestamp),
            'type': intake.type,
            'volume': intake.volume,
            'sodium': intake.sodium,
            'potassium': intake.potassium,
            'magnesium': intake.magnesium,
          });
    } catch (e) {
      logger.i('Error saving intake to Firestore: $e');
    }
  }

  /// Save alcohol intake to Firestore (called from AlcoholService)
  Future<void> saveAlcoholIntake(AlcoholIntake intake) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(intake.timestamp);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('alcohol_intakes')
          .doc(intake.id)
          .set({
            'date': dateKey,
            'timestamp': Timestamp.fromDate(intake.timestamp),
            'typeIndex': intake.type.index,
            'volumeMl': intake.volumeMl,
            'abv': intake.abv,
            'sugar': intake.sugar,
          });
    } catch (e) {
      logger.i('Error saving alcohol to Firestore: $e');
    }
  }

  /// Save food intake to Firestore (called from HydrationProvider)
  Future<void> saveFoodIntake(FoodIntake intake) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(intake.timestamp);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('food_intakes')
          .doc(intake.id)
          .set({
            'date': dateKey,
            'timestamp': Timestamp.fromDate(intake.timestamp),
            'foodId': intake.foodId,
            'foodName': intake.foodName,
            'weight': intake.weight,
            'calories': intake.calories,
            'sugar': intake.sugar,
            'waterContent': intake.waterContent,
            'potassium': intake.potassium,
            'sodium': intake.sodium,
            'magnesium': intake.magnesium,
          });
    } catch (e) {
      logger.i('Error saving food intake to Firestore: $e');
    }
  }

  /// Save caffeine intake to Firestore (called from HRIService)
  Future<void> saveCaffeineIntake(
    String id,
    DateTime timestamp,
    double caffeineMg,
    String source,
  ) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(timestamp);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('caffeine_intakes')
          .doc(id)
          .set({
            'date': dateKey,
            'timestamp': Timestamp.fromDate(timestamp),
            'amount': caffeineMg,
            'source': source,
          });
    } catch (e) {
      logger.i('Error saving caffeine to Firestore: $e');
    }
  }

  /// Save workout to Firestore (called from HRIService)
  Future<void> saveWorkout(Workout workout) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(workout.timestamp);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .doc(workout.id)
          .set({
            'date': dateKey,
            'timestamp': Timestamp.fromDate(workout.timestamp),
            'type': workout.type,
            'intensity': workout.intensity,
            'durationMinutes': workout.durationMinutes,
            'waterLossMl': workout.waterLossMl,
            'sodiumLossMg': workout.sodiumLossMg,
            'potassiumLossMg': workout.potassiumLossMg,
            'magnesiumLossMg': workout.magnesiumLossMg,
            'caloriesBurned': workout.caloriesBurned,
          });
    } catch (e) {
      logger.i('Error saving workout to Firestore: $e');
    }
  }

  /// Save daily goals snapshot (call when goals are calculated)
  Future<void> saveDailyGoals({
    required DateTime date,
    required int waterMin,
    required int waterOpt,
    required int waterMax,
    required int sodium,
    required int potassium,
    required int magnesium,
  }) async {
    if (!_isAuthenticated) return;

    try {
      final dateKey = _formatDateKey(date);

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('daily_goals')
          .doc(dateKey)
          .set({
            'date': dateKey,
            'waterMin': waterMin,
            'waterOpt': waterOpt,
            'waterMax': waterMax,
            'sodium': sodium,
            'potassium': potassium,
            'magnesium': magnesium,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          });

      logger.i('Daily goals saved for $dateKey');
    } catch (e) {
      logger.i('Error saving daily goals: $e');
    }
  }

  // ============================================================================
  // DELETE METHODS
  // ============================================================================

  /// Delete intake from Firestore
  Future<void> deleteIntake(String intakeId) async {
    if (!_isAuthenticated) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('intakes')
          .doc(intakeId)
          .delete();
    } catch (e) {
      logger.i('Error deleting intake from Firestore: $e');
    }
  }

  /// Delete alcohol intake from Firestore
  Future<void> deleteAlcoholIntake(String intakeId) async {
    if (!_isAuthenticated) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('alcohol_intakes')
          .doc(intakeId)
          .delete();
    } catch (e) {
      logger.i('Error deleting alcohol from Firestore: $e');
    }
  }

  // ============================================================================
  // WEEKLY/MONTHLY AGGREGATIONS
  // ============================================================================

  /// Get aggregated data for a week range
  Future<Map<String, Map<String, dynamic>>> getWeeklyData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final Map<String, Map<String, dynamic>> weekData = {};

    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = _formatDateKey(date);
      final daySummary = await getDaySummary(date);
      weekData[dateKey] = daySummary;
    }

    return weekData;
  }

  /// Get monthly data
  Future<Map<String, Map<String, dynamic>>> getMonthlyData(
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    return getWeeklyData(startDate, endDate);
  }

  // ============================================================================
  // MIGRATION FROM SHAREDPREFERENCES
  // ============================================================================

  /// Migrate historical data from SharedPreferences to Firestore
  Future<void> migrateToFirestore() async {
    if (!_isAuthenticated) {
      logger.i('Cannot migrate: user not authenticated');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final migrated = prefs.getBool(_migrationKey) ?? false;
    if (migrated) {
      logger.i('Migration already completed');
      return;
    }

    logger.i('Starting migration to Firestore...');

    try {
      // Migrate last 30 days of data
      final now = DateTime.now();
      for (var i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        await _migrateDayData(date);
      }

      await prefs.setBool(_migrationKey, true);
      logger.i('Migration completed successfully');
    } catch (e) {
      logger.i('Migration failed: $e');
    }
  }

  Future<void> _migrateDayData(DateTime date) async {
    if (!_isAuthenticated) return;

    final dateKey = _formatDateKey(date);
    final batch = _firestore.batch();

    // Migrate regular intakes
    final intakes = await _getIntakesFromPrefs(date);
    for (final intake in intakes) {
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection('intakes')
          .doc(intake.id);

      batch.set(docRef, {
        'date': dateKey,
        'timestamp': Timestamp.fromDate(intake.timestamp),
        'type': intake.type,
        'volume': intake.volume,
        'sodium': intake.sodium,
        'potassium': intake.potassium,
        'magnesium': intake.magnesium,
      });
    }

    await batch.commit();
  }

  // ============================================================================
  // FIRESTORE CONVERTERS
  // ============================================================================

  Intake _intakeFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Intake(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: data['type'],
      volume: data['volume'],
      sodium: data['sodium'] ?? 0,
      potassium: data['potassium'] ?? 0,
      magnesium: data['magnesium'] ?? 0,
      name: data['name'] as String?,
      emoji: data['emoji'] as String?,
    );
  }

  AlcoholIntake _alcoholFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlcoholIntake(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: AlcoholType.values[data['typeIndex']],
      volumeMl: data['volumeMl'].toDouble(),
      abv: data['abv'].toDouble(),
      sugar: data['sugar']?.toDouble(),
      name: data['name'] as String?,
      emoji: data['emoji'] as String?,
    );
  }

  FoodIntake _foodFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodIntake(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      foodId: data['foodId'] ?? '',
      foodName: data['foodName'],
      weight: data['weight'].toDouble(),
      calories: data['calories'],
      sugar: data['sugar'].toDouble(),
      waterContent: data['waterContent'].toDouble(),
      potassium: data['potassium'],
      sodium: data['sodium'],
      magnesium: data['magnesium'],
      emoji: data['emoji'] as String?,
    );
  }

  Workout _workoutFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: data['type'],
      intensity: data['intensity'],
      durationMinutes: data['durationMinutes'],
      waterLossMl: data['waterLossMl'] ?? 0,
      sodiumLossMg: data['sodiumLossMg'] ?? 0,
      potassiumLossMg: data['potassiumLossMg'] ?? 0,
      magnesiumLossMg: data['magnesiumLossMg'] ?? 0,
      caloriesBurned: data['caloriesBurned'] ?? 0,
    );
  }

  // ============================================================================
  // SHAREDPREFERENCES FALLBACKS
  // ============================================================================

  Future<List<Intake>> _getIntakesFromPrefs(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDateKey(date);
      final intakesKey = 'intakes_$dateKey';
      final intakesJson = prefs.getStringList(intakesKey) ?? [];

      return intakesJson
          .map((json) {
            try {
              final parts = json.split('|');
              if (parts.length >= 7) {
                return Intake(
                  id: parts[0],
                  timestamp: DateTime.parse(parts[1]),
                  type: parts[2],
                  volume: int.tryParse(parts[3]) ?? 0,
                  sodium: int.tryParse(parts[4]) ?? 0,
                  potassium: int.tryParse(parts[5]) ?? 0,
                  magnesium: int.tryParse(parts[6]) ?? 0,
                  name: parts.length > 7 && parts[7].isNotEmpty
                      ? parts[7]
                      : null,
                  emoji: parts.length > 8 && parts[8].isNotEmpty
                      ? parts[8]
                      : null,
                );
              }
            } catch (e) {
              logger.i('Error parsing intake: $e');
            }
            return null;
          })
          .where((intake) => intake != null)
          .cast<Intake>()
          .toList();
    } catch (e) {
      logger.i('Error loading intakes from prefs: $e');
      return [];
    }
  }

  Future<List<AlcoholIntake>> _getAlcoholFromPrefs(DateTime date) async {
    // For now, delegate to AlcoholService
    // In future, this would load from stored alcohol data
    try {
      final alcoholService = AlcoholService();
      return await alcoholService.getIntakesForDate(date);
    } catch (e) {
      logger.i('Error loading alcohol from AlcoholService: $e');
      return [];
    }
  }

  Future<List<FoodIntake>> _getFoodFromPrefs(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _formatDateKey(date);
      final foodKey = 'food_intakes_$dateKey';
      final foodIntakesJson = prefs.getStringList(foodKey) ?? [];

      return foodIntakesJson
          .map((json) {
            try {
              final parts = json.split('|');
              if (parts.length >= 12) {
                return FoodIntake(
                  id: parts[0],
                  timestamp: DateTime.parse(parts[1]),
                  foodId: parts[2] ?? '',
                  foodName: parts[3],
                  weight: double.tryParse(parts[4]) ?? 0.0,
                  calories: int.tryParse(parts[5]) ?? 0,
                  sugar: double.tryParse(parts[10]) ?? 0.0,
                  waterContent: double.tryParse(parts[6]) ?? 0.0,
                  potassium: int.tryParse(parts[8]) ?? 0,
                  sodium: int.tryParse(parts[7]) ?? 0,
                  magnesium: int.tryParse(parts[9]) ?? 0,
                );
              }
            } catch (e) {
              logger.i('Error parsing food intake: $e');
            }
            return null;
          })
          .where((food) => food != null)
          .cast<FoodIntake>()
          .toList();
    } catch (e) {
      logger.i('Error loading food from prefs: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getCaffeineFromPrefs(
    DateTime date,
  ) async {
    // Only return today's caffeine from HRIService
    final now = DateTime.now();
    if (!_isSameDay(date, now)) {
      return [];
    }

    try {
      final hriService = HRIService();
      return hriService.todayCaffeineIntakes
          .map(
            (intake) => {
              'timestamp': intake.timestamp.millisecondsSinceEpoch,
              'amount': intake.caffeineMg,
              'source': intake.source,
            },
          )
          .toList();
    } catch (e) {
      logger.i('Error getting caffeine from HRIService: $e');
      return [];
    }
  }

  Future<List<Workout>> _getWorkoutsFromPrefs(DateTime date) async {
    // Only return today's workouts from HRIService
    final now = DateTime.now();
    if (!_isSameDay(date, now)) {
      return [];
    }

    try {
      final hriService = HRIService();
      return hriService.todayWorkouts;
    } catch (e) {
      logger.i('Error getting workouts from HRIService: $e');
      return [];
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  String _formatDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
