// lib/services/notifications/specific_notifications.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_types.dart';
import 'notification_config.dart';
import 'notification_sender.dart';
import '../notification_texts.dart';
import 'helpers/notification_limits_helper.dart';

/// Класс для специфичных типов уведомлений: кофе, алкоголь, тренировки, жара
class SpecificNotifications {
  final NotificationSender _notificationSender;
  final NotificationLimitsHelper _limitsHelper;
  final FirebaseRemoteConfig _remoteConfig;

  SpecificNotifications(
    this._notificationSender,
    this._limitsHelper,
    this._remoteConfig,
  );

  // ==================== КОФЕ ====================

  /// Планирование напоминания после кофе
  Future<void> schedulePostCoffeeReminder() async {
    await NotificationTexts.ensureLoaded();
    
    // Проверка на дублирование
    if (await _limitsHelper.isDuplicateNotification(
      NotificationType.postCoffee,
      null,
      minInterval: const Duration(hours: 2),
    )) {
      print('Post-coffee reminder already scheduled recently');
      return;
    }

    // Получение задержки из Remote Config
    final delay = _remoteConfig.getInt(NotificationConfig.rcPostCoffeeDelay);
    final delayMinutes = delay > 0 ? delay : NotificationConfig.postCoffeeDelayMinutes;

    final scheduledTime = DateTime.now().add(Duration(minutes: delayMinutes));

    await _notificationSender.sendNotification(
      type: NotificationType.postCoffee,
      title: NotificationTexts.postCoffeeTitle,
      body: NotificationTexts.postCoffeeBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'add_water', 'amount': 250, 'reason': 'post_coffee'},
    );

    // Сохранение времени для защиты от дублей
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      NotificationConfig.prefLastCoffeeNotificationTime,
      DateTime.now().millisecondsSinceEpoch,
    );

    print('Post-coffee reminder scheduled for ${delayMinutes}min');
  }

  // ==================== АЛКОГОЛЬ ====================

  /// Планирование контр-напоминания после алкоголя
  Future<void> scheduleAlcoholCounterReminder(int standardDrinks) async {
    await NotificationTexts.ensureLoaded();
    
    final scheduledTime = DateTime.now().add(
      Duration(minutes: NotificationConfig.alcoholCounterDelayMinutes)
    );

    // Расчет количества воды из Remote Config
    final waterPerDrink = _remoteConfig.getInt(NotificationConfig.rcAlcoholDrinkBonus);
    final waterAmount = standardDrinks * (waterPerDrink > 0 ? waterPerDrink : NotificationConfig.waterPerStandardDrink);

    await _notificationSender.sendNotification(
      type: NotificationType.alcoholCounter,
      title: NotificationTexts.alcoholCounterTitle,
      body: NotificationTexts.alcoholCounterBody(waterAmount),
      scheduledTime: scheduledTime,
      payload: {
        'action': 'alcohol_recovery', 
        'water': waterAmount,
        'standard_drinks': standardDrinks,
      },
    );

    // Если PRO - планируем полный план восстановления
    if (await _limitsHelper.isProUser()) {
      await scheduleAlcoholRecoveryPlan(standardDrinks);
    }

    print('Alcohol counter reminder scheduled for ${NotificationConfig.alcoholCounterDelayMinutes}min');
  }

  /// Планирование плана восстановления после алкоголя (PRO)
  Future<void> scheduleAlcoholRecoveryPlan(int standardDrinks) async {
    if (!await _limitsHelper.isProUser()) {
      print('Recovery plan requires PRO subscription');
      return;
    }

    await NotificationTexts.ensureLoaded();
    
    // Определение продолжительности восстановления
    final recoveryHours = standardDrinks <= 2 
        ? NotificationConfig.lightRecoveryHours 
        : NotificationConfig.heavyRecoveryHours;
    
    final now = DateTime.now();

    // Планирование шагов восстановления каждые 2 часа
    for (int hour = NotificationConfig.recoveryStepInterval; 
         hour <= recoveryHours; 
         hour += NotificationConfig.recoveryStepInterval) {
      
      final scheduledTime = now.add(Duration(hours: hour));
      final waterAmount = 300 + (standardDrinks * 50);

      // В середине плана добавляем электролиты
      final withElectrolytes = hour == recoveryHours ~/ 2;

      await _notificationSender.sendNotification(
        type: NotificationType.alcoholRecovery,
        title: NotificationTexts.alcoholRecoveryStepTitle(hour),
        body: NotificationTexts.alcoholRecoveryStepBody(waterAmount, withElectrolytes),
        scheduledTime: scheduledTime,
        payload: {
          'action': 'recovery_step', 
          'hour': hour,
          'water': waterAmount,
          'electrolytes': withElectrolytes,
        },
        skipChecks: true,
        silentIfQuiet: true,
      );
    }

    // Планирование утреннего чек-ина
    await scheduleMorningCheckIn();

    print('Alcohol recovery plan scheduled for ${recoveryHours}h');
  }

  /// Планирование утреннего чек-ина после алкоголя
  Future<void> scheduleMorningCheckIn() async {
    await NotificationTexts.ensureLoaded();
    
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year, 
      now.month, 
      now.day + 1, 
      NotificationConfig.morningCheckInHour, 
      NotificationConfig.morningCheckInMinute
    );

    await _notificationSender.sendNotification(
      type: NotificationType.morningCheckIn,
      title: NotificationTexts.morningCheckInTitle,
      body: NotificationTexts.morningCheckInBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'morning_checkin'},
    );

    print('Morning check-in scheduled for ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
  }

  // ==================== ЖАРА И ТРЕНИРОВКИ ====================

  /// Отправка предупреждения о жаре (PRO)
  Future<void> sendHeatWarning(double heatIndex) async {
    if (!await _limitsHelper.isProUser()) {
      print('Heat warnings require PRO subscription');
      return;
    }

    await NotificationTexts.ensureLoaded();

    await _notificationSender.sendNotification(
      type: NotificationType.heatWarning,
      title: NotificationTexts.heatWarningTitle,
      body: NotificationTexts.heatWarningBody(heatIndex),
      payload: {
        'action': 'heat_warning', 
        'heat_index': heatIndex,
        'priority': 'high',
      },
      skipChecks: true, // Жара - критично, отправляем сразу
    );

    print('Heat warning sent for HI: $heatIndex');
  }

  /// Планирование напоминания после тренировки (PRO)
  Future<void> sendWorkoutReminder({DateTime? workoutEndTime}) async {
    if (!await _limitsHelper.isProUser()) {
      print('Workout reminders require PRO subscription');
      return;
    }

    if (workoutEndTime == null) {
      print('No workout end time provided');
      return;
    }

    await NotificationTexts.ensureLoaded();

    final postWorkout = workoutEndTime.add(
      Duration(minutes: NotificationConfig.postWorkoutDelayMinutes)
    );

    if (postWorkout.isBefore(DateTime.now())) {
      print('Post-workout time already passed');
      return;
    }

    await _notificationSender.sendNotification(
      type: NotificationType.workoutReminder,
      title: NotificationTexts.postWorkoutTitle,
      body: NotificationTexts.postWorkoutBody,
      scheduledTime: postWorkout,
      payload: {
        'action': 'post_workout',
        'water_suggested': 500,
        'electrolytes': true,
      },
    );

    // Сохраняем информацию о тренировке
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationConfig.prefHasWorkoutToday, true);
    await prefs.setString(NotificationConfig.prefWorkoutTime, workoutEndTime.toIso8601String());

    print('Post-workout reminder scheduled for ${postWorkout.hour}:${postWorkout.minute.toString().padLeft(2, '0')}');
  }

  // ==================== ВЕЧЕРНИЙ ОТЧЕТ ====================

  /// Планирование вечернего отчета
  Future<void> scheduleEveningReport() async {
    await NotificationTexts.ensureLoaded();
    
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    final reportTime = prefs.getString(NotificationConfig.prefEveningReportTime) 
        ?? NotificationConfig.defaultEveningReportTime;
    final timeParts = reportTime.split(':');

    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    // Если время уже прошло - планируем на завтра
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notificationSender.sendNotification(
      type: NotificationType.dailyReport,
      title: NotificationTexts.dailyReportTitle,
      body: NotificationTexts.dailyReportBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'show_report', 'report_type': 'evening'},
    );

    print('Evening report scheduled for $reportTime');
  }

  // ==================== ПОСТ И ЭЛЕКТРОЛИТЫ ====================

  /// Планирование напоминания об электролитах в пост (PRO)
  Future<void> scheduleFastingElectrolyteReminder(DateTime scheduledTime) async {
    if (!await _limitsHelper.isProUser()) {
      print('Fasting reminders require PRO subscription');
      return;
    }

    await NotificationTexts.ensureLoaded();

    await _notificationSender.sendNotification(
      type: NotificationType.fastingElectrolyte,
      title: NotificationTexts.fastingElectrolyteTitle,
      body: NotificationTexts.fastingElectrolyteBody,
      scheduledTime: scheduledTime,
      payload: {
        'action': 'add_electrolytes',
        'fasting_mode': true,
        'sodium': true,
        'potassium': true,
        'magnesium': true,
      },
    );

    print('Fasting electrolyte reminder scheduled for ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
  }

  // ==================== УМНЫЕ НАПОМИНАНИЯ ====================

  /// Отправка умного контекстного напоминания (PRO)
  Future<void> sendSmartReminder({
    required String context,
    required String title,
    required String body,
    Map<String, dynamic>? additionalPayload,
  }) async {
    if (!await _limitsHelper.isProUser()) {
      print('Smart reminders require PRO subscription');
      return;
    }

    await NotificationTexts.ensureLoaded();

    final payload = {
      'action': 'smart_reminder',
      'context': context,
      ...?additionalPayload,
    };

    await _notificationSender.sendNotification(
      type: NotificationType.smartReminder,
      title: title,
      body: body,
      payload: payload,
    );

    print('Smart reminder sent: $context');
  }

  // ==================== УТИЛИТЫ ====================

  /// Проверка, есть ли уже запланированные уведомления определенного типа
  Future<bool> hasScheduledNotificationType(NotificationType type) async {
    // Логика будет делегирована в NotificationManager
    return false; // Заглушка
  }

  /// Отмена всех алкогольных уведомлений
  Future<void> cancelAllAlcoholNotifications() async {
    // Логика будет делегирована в NotificationManager
    final alcoholTypes = {
      NotificationType.alcoholCounter,
      NotificationType.alcoholRecovery,
      NotificationType.morningCheckIn,
    };
    
    print('Cancelled alcohol-related notifications');
  }

  /// Получение параметров алкоголя из Remote Config
  Map<String, dynamic> getAlcoholSettings() {
    return {
      'standardDrinkGrams': _remoteConfig.getInt(NotificationConfig.rcStandardDrinkGrams),
      'waterPerDrink': _remoteConfig.getInt(NotificationConfig.rcAlcoholDrinkBonus),
      'sodiumPerDrink': _remoteConfig.getInt(NotificationConfig.rcSodiumPerDrink),
      'magnesiumAfterAlc': _remoteConfig.getInt(NotificationConfig.rcMagnesiumAfterAlc),
      'hriRiskPerDrink': _remoteConfig.getInt(NotificationConfig.rcAlcoholHriRisk),
      'hriRiskCap': _remoteConfig.getInt(NotificationConfig.rcAlcoholHriCap),
      'eveningCutoff': _remoteConfig.getString(NotificationConfig.rcAlcoholEveningCutoff),
    };
  }
}