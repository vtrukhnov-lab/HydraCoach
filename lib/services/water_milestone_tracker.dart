import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'analytics_service.dart';
import 'package:hydracoach/utils/app_logger.dart';

/// Сервис для отслеживания milestone событий достижения 100% воды
/// Отправляет уникальные события в AppsFlyer для когортного анализа
class WaterMilestoneTracker {
  static const String _keyPrefix = 'water_milestone_';
  static const String _onboardingCompleteKey = 'onboarding_completed';
  static const String _installDateKey = 'app_install_date';
  static const String _daysWithGoalKey = 'days_with_100_goal';
  static const String _consecutiveDaysKey = 'consecutive_100_days';
  static const String _lastGoalDateKey = 'last_100_goal_date';

  final AnalyticsService _analytics = AnalyticsService();

  /// Проверка и логирование достижения 100% дневной цели по воде
  Future<void> checkAndLogWaterGoalAchieved() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Проверяем, не логировали ли мы уже сегодня
    final lastGoalDateStr = prefs.getString(_lastGoalDateKey);
    if (lastGoalDateStr != null) {
      final lastGoalDate = DateTime.parse(lastGoalDateStr);
      if (_isSameDay(lastGoalDate, today)) {
        // Уже логировали сегодня
        return;
      }
    }

    // Получаем дату установки
    String? installDateStr = prefs.getString(_installDateKey);
    if (installDateStr == null) {
      // Первый запуск - сохраняем дату установки
      await prefs.setString(_installDateKey, today.toIso8601String());
      installDateStr = today.toIso8601String();
    }
    final installDate = DateTime.parse(installDateStr);

    // Вычисляем день с момента установки
    final daysSinceInstall = today.difference(installDate).inDays + 1;

    // Обновляем счетчики
    int totalDaysWithGoal = prefs.getInt(_daysWithGoalKey) ?? 0;
    totalDaysWithGoal++;
    await prefs.setInt(_daysWithGoalKey, totalDaysWithGoal);

    // Проверяем consecutive days
    int consecutiveDays = prefs.getInt(_consecutiveDaysKey) ?? 0;
    if (lastGoalDateStr != null) {
      final lastGoalDate = DateTime.parse(lastGoalDateStr);
      final daysDiff = today.difference(lastGoalDate).inDays;
      if (daysDiff == 1) {
        // Продолжаем streak
        consecutiveDays++;
      } else {
        // Streak прерван
        consecutiveDays = 1;
      }
    } else {
      consecutiveDays = 1;
    }
    await prefs.setInt(_consecutiveDaysKey, consecutiveDays);

    // Сохраняем дату последнего достижения
    await prefs.setString(_lastGoalDateKey, today.toIso8601String());

    // Проверяем и отправляем milestone события
    await _checkAndSendMilestones(
      daysSinceInstall: daysSinceInstall,
      totalDaysWithGoal: totalDaysWithGoal,
      consecutiveDays: consecutiveDays,
      prefs: prefs,
    );
  }

  /// Проверка и отправка milestone событий
  Future<void> _checkAndSendMilestones({
    required int daysSinceInstall,
    required int totalDaysWithGoal,
    required int consecutiveDays,
    required SharedPreferences prefs,
  }) async {
    // Проверяем milestone события по количеству дней с достижением 100%
    // Не важно в какие дни это произошло - важно только общее количество

    // Список milestone для проверки
    final milestones = [1, 2, 3, 5, 7, 10, 14];

    for (final milestone in milestones) {
      if (totalDaysWithGoal >= milestone) {
        final key = '${_keyPrefix}${milestone}days';
        if (!prefs.containsKey(key)) {
          // Отправляем событие
          await _analytics.logWaterGoalMilestone(totalDays: milestone);
          await prefs.setBool(key, true);

          if (kDebugMode) {
            final eventName = milestone == 1
                ? 'water_goal_100_first'
                : 'water_goal_100_${milestone}days';
            logger.i(
              '🎯 Milestone: $eventName (reached 100% in $milestone total days)',
            );
          }
        }
      }
    }
  }

  /// Логирование завершения онбординга (один раз)
  Future<void> logOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем, не отправляли ли уже это событие
    if (prefs.containsKey(_onboardingCompleteKey)) {
      return;
    }

    // Отправляем событие
    await _analytics.logOnboardingComplete();

    // Сохраняем флаг, что событие отправлено
    await prefs.setBool(_onboardingCompleteKey, true);

    if (kDebugMode) {
      logger.i('🎯 Milestone: onboarding_complete (one-time event)');
    }
  }

  /// Сброс всех milestone для тестирования (только debug)
  Future<void> resetMilestones() async {
    if (!kDebugMode) return;

    final prefs = await SharedPreferences.getInstance();

    // Удаляем все milestone флаги
    final milestones = [1, 2, 3, 5, 7, 10, 14];
    for (final milestone in milestones) {
      await prefs.remove('${_keyPrefix}${milestone}days');
    }
    await prefs.remove(_onboardingCompleteKey);

    // Сбрасываем счетчики
    await prefs.remove(_daysWithGoalKey);
    await prefs.remove(_consecutiveDaysKey);
    await prefs.remove(_lastGoalDateKey);
    await prefs.remove(_installDateKey);

    logger.i('🔄 All milestones reset for testing');
  }

  /// Проверка одинаковый ли день
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
