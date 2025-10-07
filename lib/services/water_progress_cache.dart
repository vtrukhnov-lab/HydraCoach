// lib/services/water_progress_cache.dart
import 'package:shared_preferences/shared_preferences.dart';

class WaterProgressCache {
  // Ключи совместимы назад
  static const _kProgress01 = 'water_progress'; // 0..1 (старый задуманный ключ)
  static const _kProgressPct =
      'water_progress_percent'; // 0..100 (удобно для UI)
  static const _kConsumed = 'water_today_ml';
  static const _kGoal = 'daily_water_goal_ml';

  /// Сохраняем исходные значения + кэшим прогресс
  static Future<void> set({
    required int consumedMl,
    required int goalMl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final clampedGoal = goalMl < 0 ? 0 : goalMl;
    final clampedConsumed = consumedMl < 0 ? 0 : consumedMl;

    double progress01 = 0.0;
    if (clampedGoal > 0) {
      progress01 = (clampedConsumed / clampedGoal).clamp(0.0, 1.0);
    }
    final progressPct = (progress01 * 100).round();

    await prefs.setInt(_kConsumed, clampedConsumed);
    await prefs.setInt(_kGoal, clampedGoal);
    await prefs.setDouble(_kProgress01, progress01);
    await prefs.setInt(_kProgressPct, progressPct);
  }

  /// Пытаемся прочитать процент прогресса 0..100.
  /// Возвращаем null если данных нет.
  static Future<int?> readPercent() async {
    final prefs = await SharedPreferences.getInstance();

    // 1) пробуем «процент»
    if (prefs.containsKey(_kProgressPct)) {
      return prefs.getInt(_kProgressPct);
    }

    // 2) пробуем «0..1»
    if (prefs.containsKey(_kProgress01)) {
      final p01 = prefs.getDouble(_kProgress01);
      if (p01 != null) return (p01.clamp(0.0, 1.0) * 100).round();
    }

    // 3) пробуем вычислить из сырых чисел
    final consumed = prefs.getInt(_kConsumed);
    final goal = prefs.getInt(_kGoal);
    if (consumed != null && goal != null && goal > 0) {
      final p01 = (consumed / goal).clamp(0.0, 1.0);
      return (p01 * 100).round();
    }

    return null;
  }
}
