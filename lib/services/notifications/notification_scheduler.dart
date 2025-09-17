// lib/services/notifications/notification_scheduler.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:math';

import 'notification_types.dart';
import 'notification_config.dart';
import 'notification_sender.dart';
import '../notification_texts.dart';
import '../water_progress_cache.dart';
import 'helpers/timezone_helper.dart';
import 'helpers/notification_limits_helper.dart';
import 'helpers/schedule_window_helper.dart';

/// Класс для планирования всех типов уведомлений
class NotificationScheduler {
  final NotificationSender _notificationSender;
  final NotificationLimitsHelper _limitsHelper;
  final FirebaseRemoteConfig _remoteConfig;

  NotificationScheduler(
    this._notificationSender,
    this._limitsHelper,
    this._remoteConfig,
  );

  // ==================== ОСНОВНЫЕ МЕТОДЫ ПЛАНИРОВАНИЯ ====================

  /// Главный метод: планирование уведомлений при запуске
  Future<void> scheduleInitialNotifications() async {
    print('Scheduling initial notifications...');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true;
      
      if (!notificationsEnabled) {
        print('Notifications disabled by user');
        return;
      }

      // Всегда планируем на сегодня при запуске
      await _ensureTodayNotifications();
      
      // Затем планируем будущие дни
      await _scheduleFutureDays();
      
      print('Initial notifications scheduled successfully');
      
    } catch (e) {
      print('Failed to schedule initial notifications: $e');
      rethrow;
    }
  }

  /// Гарантированное планирование на сегодня
  Future<void> _ensureTodayNotifications() async {
    print('Ensuring today\'s notifications...');
    
    final now = DateTime.now();
    
    // Отменяем существующие уведомления на сегодня чтобы избежать дублей
    await _cancelTodayNotifications();
    
    // Проверяем режим поста
    final isInFasting = await _limitsHelper.isInFastingWindow();
    
    if (!isInFasting) {
      // Планируем напоминания о воде
      await _scheduleWaterRemindersToday();
    } else {
      print('Fasting mode - scheduling electrolyte reminders');
      if (await _limitsHelper.isProUser()) {
        await _scheduleFastingRemindersToday();
      }
    }
    
    // Всегда планируем вечерний отчет
    await _scheduleEveningReportToday();
    
    print('Today\'s notifications scheduled');
  }

  /// ИСПРАВЛЕННЫЙ МЕТОД: Планирование напоминаний о воде на сегодня
  Future<void> _scheduleWaterRemindersToday() async {
    print('Scheduling water reminders for today...');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Получаем текущий прогресс воды
    final waterPercent = (await WaterProgressCache.readPercent() ?? 0).toDouble();
    
    int scheduledCount = 0;
    List<DateTime> futureReminders = [];
    
    // Получаем времена напоминаний
    final reminderTimes = await _getReminderTimes();
    
    // Собираем все будущие времена с учётом jitter
    for (final hm in reminderTimes) {
      final scheduledTime = DateTime(today.year, today.month, today.day, hm[0], hm[1]);
      
      // Добавляем небольшой рандомный сдвиг (±3 минуты)
      final jitterTime = _addJitter(scheduledTime);
      
      // Сохраняем только будущие времена
      if (jitterTime.isAfter(now)) {
        futureReminders.add(jitterTime);
        print('Found future time: ${jitterTime.hour}:${jitterTime.minute.toString().padLeft(2, '0')}');
      } else {
        print('Skipping past time: ${hm[0]}:${hm[1].toString().padLeft(2, '0')}');
      }
    }
    
    // ИСПРАВЛЕНИЕ: Если нет будущих времён из базового списка, 
    // создаём динамические напоминания на оставшееся время дня
    if (futureReminders.isEmpty && now.hour < 21) { // Не планируем после 21:00
      print('No future base times found, creating dynamic reminders...');
      
      // Рассчитываем сколько часов осталось до вечера (21:00)
      final eveningTime = DateTime(today.year, today.month, today.day, 21, 0);
      final hoursUntilEvening = eveningTime.difference(now).inHours;
      
      if (hoursUntilEvening > 0) {
        // Создаём до 3 равномерно распределённых напоминаний
        final remindersToCreate = hoursUntilEvening >= 3 ? 3 : hoursUntilEvening;
        final intervalHours = hoursUntilEvening / remindersToCreate;
        
        for (int i = 1; i <= remindersToCreate; i++) {
          final nextTime = now.add(Duration(
            hours: (intervalHours * i).floor(),
            minutes: ((intervalHours * i - (intervalHours * i).floor()) * 60).round()
          ));
          
          // Проверяем что не вышли за границы дня и не слишком поздно
          if (nextTime.isBefore(eveningTime) && nextTime.isAfter(now)) {
            futureReminders.add(nextTime);
            print('Added dynamic reminder at ${nextTime.hour}:${nextTime.minute.toString().padLeft(2, '0')}');
          }
        }
      } else if (hoursUntilEvening == 0 && now.minute < 45) {
        // Если остался последний час до 21:00, добавим одно напоминание через 15-30 минут
        final lastReminder = now.add(Duration(minutes: 15 + Random().nextInt(15)));
        if (lastReminder.hour < 21) {
          futureReminders.add(lastReminder);
          print('Added last-hour reminder at ${lastReminder.hour}:${lastReminder.minute.toString().padLeft(2, '0')}');
        }
      }
    }
    
    // Планируем все собранные напоминания
    for (final reminderTime in futureReminders) {
      print('Scheduling water reminder at ${reminderTime.hour}:${reminderTime.minute.toString().padLeft(2, '0')}');
      
      await _notificationSender.sendNotification(
        type: NotificationType.waterReminder,
        title: NotificationTexts.waterReminderTitle,
        body: _getWaterReminderBody(reminderTime.hour, waterPercent),
        scheduledTime: reminderTime,
        payload: {'action': 'drink_water'},
      );
      
      scheduledCount++;
    }
    
    if (scheduledCount == 0) {
      print('⚠️ WARNING: No water reminders scheduled for today (too late in the day)');
    } else {
      print('✅ Scheduled $scheduledCount water reminders for today');
    }
  }

  /// Планирование электролитных напоминаний на сегодня (PRO)
  Future<void> _scheduleFastingRemindersToday() async {
    print('Scheduling fasting electrolyte reminders...');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int scheduledCount = 0;
    
    for (final hm in NotificationConfig.fastingElectrolyteTimes) {
      final scheduledTime = DateTime(today.year, today.month, today.day, hm[0], hm[1]);
      
      if (scheduledTime.isBefore(now)) {
        continue;
      }
      
      await _notificationSender.sendNotification(
        type: NotificationType.fastingElectrolyte,
        title: NotificationTexts.fastingElectrolyteTitle,
        body: NotificationTexts.fastingElectrolyteBody,
        scheduledTime: scheduledTime,
        payload: {'action': 'add_electrolytes'},
      );
      
      scheduledCount++;
    }
    
    // Если все базовые времена прошли, добавляем одно напоминание через час
    if (scheduledCount == 0 && now.hour < 20) {
      final dynamicTime = now.add(Duration(hours: 1));
      
      await _notificationSender.sendNotification(
        type: NotificationType.fastingElectrolyte,
        title: NotificationTexts.fastingElectrolyteTitle,
        body: NotificationTexts.fastingElectrolyteBody,
        scheduledTime: dynamicTime,
        payload: {'action': 'add_electrolytes'},
      );
      
      print('Added dynamic fasting reminder at ${dynamicTime.hour}:${dynamicTime.minute.toString().padLeft(2, '0')}');
    }
  }

  /// Планирование вечернего отчета на сегодня
  Future<void> _scheduleEveningReportToday() async {
    final prefs = await SharedPreferences.getInstance();
    final reportTime = prefs.getString(NotificationConfig.prefEveningReportTime) 
        ?? NotificationConfig.defaultEveningReportTime;
    
    final timeParts = reportTime.split(':');
    final now = DateTime.now();
    
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    
    if (scheduledTime.isAfter(now)) {
      print('Scheduling evening report at $reportTime');
      
      await _notificationSender.sendNotification(
        type: NotificationType.dailyReport,
        title: NotificationTexts.dailyReportTitle,
        body: NotificationTexts.dailyReportBody,
        scheduledTime: scheduledTime,
        payload: {'action': 'show_report'},
      );
    }
  }

  /// Планирование на будущие дни
  Future<void> _scheduleFutureDays() async {
    print('Scheduling future days...');
    
    if (!await ScheduleWindowHelper.shouldRefreshWindow()) {
      print('Window is fresh, skipping');
      return;
    }
    
    await ScheduleWindowHelper.cleanupOldMetadata();
    
    final (windowStart, windowEnd) = ScheduleWindowHelper.getWindowDates();
    
    // Начинаем с завтра
    var currentDate = windowStart.add(const Duration(days: 1));
    
    while (currentDate.isBefore(windowEnd)) {
      if (!await ScheduleWindowHelper.canScheduleMore()) {
        print('iOS limit reached');
        break;
      }
      
      await _scheduleForDate(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    await ScheduleWindowHelper.markWindowRefreshed();
  }

  /// Планирование уведомлений на конкретную дату
  Future<void> _scheduleForDate(DateTime date) async {
    print('Scheduling for ${date.day}/${date.month}');
    
    final isPro = await _limitsHelper.isProUser();
    
    // Базовые напоминания о воде
    if (!await _limitsHelper.isInFastingWindow()) {
      await _scheduleWaterRemindersForDate(date);
    }
    
    // Вечерний отчет
    await _scheduleEveningReportForDate(date);
    
    // PRO функции
    if (isPro) {
      if (await _limitsHelper.isInFastingWindow()) {
        await _scheduleFastingRemindersForDate(date);
      }
    }
  }

  Future<void> _scheduleWaterRemindersForDate(DateTime date) async {
    // Получаем времена напоминаний
    final reminderTimes = await _getReminderTimes();
    
    for (final hm in reminderTimes) {
      DateTime time = DateTime(date.year, date.month, date.day, hm[0], hm[1]);
      
      // Добавляем jitter
      time = _addJitter(time);
      
      final notificationId = _notificationSender.generateNotificationId(NotificationType.waterReminder, when: time);
      
      await ScheduleWindowHelper.saveScheduledMetadata(
        notificationId,
        time,
        NotificationType.waterReminder.name,
      );
      
      await _notificationSender.sendNotification(
        type: NotificationType.waterReminder,
        title: NotificationTexts.waterReminderTitle,
        body: _getWaterReminderBody(time.hour, 0),
        scheduledTime: time,
        payload: {'action': 'drink_water'},
      );
    }
  }

  Future<void> _scheduleEveningReportForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final reportTime = prefs.getString(NotificationConfig.prefEveningReportTime) 
        ?? NotificationConfig.defaultEveningReportTime;
    final timeParts = reportTime.split(':');
    
    final scheduledTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    
    final notificationId = _notificationSender.generateNotificationId(NotificationType.dailyReport, when: scheduledTime);
    
    await ScheduleWindowHelper.saveScheduledMetadata(
      notificationId,
      scheduledTime,
      NotificationType.dailyReport.name,
    );
    
    await _notificationSender.sendNotification(
      type: NotificationType.dailyReport,
      title: NotificationTexts.notificationDailyReportTitle,
      body: NotificationTexts.notificationDailyReportBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'show_report'},
    );
  }

  Future<void> _scheduleFastingRemindersForDate(DateTime date) async {
    for (final hm in NotificationConfig.fastingElectrolyteTimes) {
      final time = DateTime(date.year, date.month, date.day, hm[0], hm[1]);
      
      final notificationId = _notificationSender.generateNotificationId(NotificationType.fastingElectrolyte, when: time);
      
      await ScheduleWindowHelper.saveScheduledMetadata(
        notificationId,
        time,
        NotificationType.fastingElectrolyte.name,
      );
      
      await _notificationSender.sendNotification(
        type: NotificationType.fastingElectrolyte,
        title: NotificationTexts.fastingElectrolyteTitle,
        body: NotificationTexts.fastingElectrolyteBody,
        scheduledTime: time,
        payload: {'action': 'add_electrolytes'},
      );
    }
  }

  // ==================== ОБРАБОТКА СМЕНЫ ЛОКАЛИ ====================

  /// Перепланирование при смене языка
  Future<void> onLocaleChanged(String localeCode) async {
    print('Notification scheduler: handling locale change to $localeCode');
    
    try {
      // Получаем список текущих запланированных уведомлений
      final pendingBefore = await _notificationSender.localNotifications.pendingNotificationRequests();
      print('Found ${pendingBefore.length} pending notifications before locale change');
      
      // Сохраняем событийные уведомления перед отменой
      final Map<int, Map<String, dynamic>> eventNotifications = {};
      final eventTypes = {
        NotificationType.postCoffee.index,      
        NotificationType.alcoholCounter.index,   
        NotificationType.alcoholRecovery.index,  
        NotificationType.workoutReminder.index,  
        NotificationType.morningCheckIn.index,   
      };
      
      // Извлекаем данные событийных уведомлений
      for (final notification in pendingBefore) {
        final decoded = NotificationSender.decodeNotificationId(notification.id);
        if (eventTypes.contains(decoded.typeIdx)) {
          eventNotifications[notification.id] = {
            'id': notification.id,
            'typeIdx': decoded.typeIdx,
            'title': notification.title,
            'body': notification.body,
            'payload': notification.payload,
            'hour': decoded.hour,
            'minute': decoded.minute,
            'day': decoded.dayFromId,
          };
          
          print('Preserving event notification: Type=${NotificationType.values[decoded.typeIdx]} (ID: ${notification.id})');
        }
      }
      
      // Отменяем ТОЛЬКО базовые уведомления (не событийные)
      print('Cancelling only baseline (non-event) notifications...');
      
      final baselineTypes = {
        NotificationType.waterReminder,     
        NotificationType.dailyReport,        
        NotificationType.smartReminder,      
        NotificationType.heatWarning,        
        NotificationType.fastingElectrolyte, 
      };
      
      await _cancelByTypes(baselineTypes);
      
      // Проверяем настройки пользователя
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      
      if (!notificationsEnabled) {
        print('Notifications are disabled, skipping rescheduling');
        return;
      }
      
      // Перепланируем ТОЛЬКО базовые уведомления с новыми текстами
      print('Rescheduling baseline notifications with new locale...');
      
      // Загружаем актуальные тексты
      await NotificationTexts.ensureLoaded();
      
      // Сбрасываем метку обновления окна, чтобы форсировать перепланирование
      await prefs.remove('schedule_window_last_refresh');
      
      // Планируем базовые напоминания на сегодня
      await _ensureTodayNotifications();
      
      // Планируем на будущие дни
      await _scheduleFutureDays();
      
      // Проверяем результат
      final pendingAfter = await _notificationSender.localNotifications.pendingNotificationRequests();
      
      // Проверяем что событийные уведомления остались
      int preservedCount = 0;
      final Map<NotificationType, int> preservedByType = {};
      
      for (final notification in pendingAfter) {
        if (eventNotifications.containsKey(notification.id)) {
          preservedCount++;
          final decoded = NotificationSender.decodeNotificationId(notification.id);
          final type = NotificationType.values[decoded.typeIdx];
          preservedByType[type] = (preservedByType[type] ?? 0) + 1;
        }
      }
      
      print('Locale change complete:');
      print('  - Event notifications found before: ${eventNotifications.length}');
      print('  - Event notifications preserved: $preservedCount');
      print('  - Total notifications after: ${pendingAfter.length}');
      
      if (preservedByType.isNotEmpty) {
        print('  - Preserved by type:');
        preservedByType.forEach((type, count) {
          print('    • ${type.name}: $count');
        });
      }
      
    } catch (e, stackTrace) {
      print('Error changing notification locale: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // ==================== УТИЛИТЫ И ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ====================

  /// Получение времен напоминаний (пользовательских или по умолчанию)
  Future<List<List<int>>> _getReminderTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final timesString = prefs.getString('water_reminder_times');

    if (timesString != null && timesString.isNotEmpty) {
      // Парсим сохранённые времена формата "8:00,11:15,14:30,17:45"
      return timesString.split(',').map((t) {
        final parts = t.split(':');
        return [int.parse(parts[0]), int.parse(parts[1])];
      }).toList();
    } else {
      // Используем базовые времена
      return NotificationConfig.baseReminderTimes;
    }
  }

  /// Добавление jitter к времени (±3 минуты)
  DateTime _addJitter(DateTime time) {
    final random = Random();
    final jitter = random.nextInt(7) - 3;
    return time.add(Duration(minutes: jitter));
  }

  /// Получение тела напоминания о воде в зависимости от времени и прогресса
  String _getWaterReminderBody(int hour, double progressPercent) {
    // Утреннее напоминание (6-10)
    if (hour >= 6 && hour <= 10) {
      return NotificationTexts.notificationMorningWaterBody;
    }
    
    // В зависимости от прогресса
    if (progressPercent < 30) {
      return NotificationTexts.notificationLowProgressBody(progressPercent.round());
    } else if (progressPercent < 70) {
      return NotificationTexts.notificationGoodProgressBody;
    } else {
      return NotificationTexts.notificationMaintainBalanceBody;
    }
  }

  /// Отмена уведомлений на сегодня
  Future<void> _cancelTodayNotifications() async {
    final pending = await _notificationSender.localNotifications.pendingNotificationRequests();
    final now = DateTime.now();
    final todayDay = TimezoneHelper.dayOfYear(now);
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      if (decoded.dayFromId == todayDay) {
        await _notificationSender.localNotifications.cancel(notification.id);
        _notificationSender.pendingNotificationIds.remove(notification.id);
      }
    }
  }

  /// Отмена уведомлений по типам
  Future<void> _cancelByTypes(Set<NotificationType> types) async {
    final pending = await _notificationSender.localNotifications.pendingNotificationRequests();
    final typeIdxSet = types.map((t) => t.index).toSet();
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      if (typeIdxSet.contains(decoded.typeIdx)) {
        await _notificationSender.localNotifications.cancel(notification.id);
        _notificationSender.pendingNotificationIds.remove(notification.id);
      }
    }
    
    print('Cancelled notifications for types: $types');
  }

  // ==================== УМНЫЕ НАПОМИНАНИЯ (PRO) ====================

  /// Планирование умных напоминаний на основе контекста
  Future<void> scheduleSmartReminders() async {
    print('Scheduling smart reminders...');

    await NotificationTexts.ensureLoaded();

    // Сначала гарантируем сегодняшние
    await _ensureTodayNotifications();
    
    // Затем будущие
    await _scheduleFutureDays();
    
    print('Smart reminders scheduled');
  }

  /// Адаптивное планирование на основе поведения пользователя
  Future<void> scheduleAdaptiveReminders() async {
    if (!await _limitsHelper.isProUser()) {
      print('Adaptive reminders require PRO subscription');
      return;
    }

    print('Scheduling adaptive reminders based on user behavior...');
    
    // Здесь можно добавить логику анализа поведения пользователя
    // и адаптацию времен напоминаний на основе статистики
    
    // Например, анализировать когда пользователь чаще всего пьет воду
    // и корректировать времена напоминаний
  }

  // ==================== ОТЛАДКА ====================

  /// Экспорт статуса планировщика
  Future<Map<String, dynamic>> getSchedulerStatus() async {
    final pending = await _notificationSender.localNotifications.pendingNotificationRequests();
    
    final Map<String, int> typeCount = {};
    final Map<int, int> dayCount = {};
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      final typeName = decoded.typeIdx < NotificationType.values.length 
          ? NotificationType.values[decoded.typeIdx].name 
          : 'unknown';
      
      typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
      dayCount[decoded.dayFromId] = (dayCount[decoded.dayFromId] ?? 0) + 1;
    }

    return {
      'total_scheduled': pending.length,
      'by_type': typeCount,
      'by_day': dayCount,
      'window_days': ScheduleWindowHelper.getWindowDays(),
      'is_pro': await _limitsHelper.isProUser(),
      'last_refresh': await ScheduleWindowHelper.shouldRefreshWindow(),
    };
  }

  // ==================== ПУБЛИЧНЫЕ МЕТОДЫ ДЛЯ NOTIFICATION SERVICE ====================

  /// Планирование только будущих дней (без сегодня)
  Future<void> scheduleFutureDaysOnly() async {
    print('Scheduling only future days (skipping today)...');
    await _scheduleFutureDays();
  }

  /// Принудительное планирование на сегодня
  Future<void> forceTodayNotifications() async {
    print('🔴 FORCE: Scheduling today\'s notifications...');
    
    final now = DateTime.now();
    
    // Отменяем существующие на сегодня
    await _cancelTodayNotifications();
    
    // Принудительно планируем
    await _ensureTodayNotifications();
    
    // Проверяем результат
    final pending = await _notificationSender.localNotifications.pendingNotificationRequests();
    final todayDay = TimezoneHelper.dayOfYear(now);
    int todayCount = 0;
    
    for (final n in pending) {
      final decoded = NotificationSender.decodeNotificationId(n.id);
      if (decoded.dayFromId == todayDay) {
        todayCount++;
      }
    }
    
    print('🔴 FORCE RESULT: $todayCount notifications scheduled for today');
  }
}