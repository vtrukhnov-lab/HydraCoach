// lib/services/notification_service.dart
// ИСПРАВЛЕНО: Гарантированное планирование уведомлений при запуске

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

// Старые импорты
import '../l10n/app_localizations.dart';
import 'locale_service.dart';
import 'subscription_service.dart';
import 'analytics_service.dart';
import 'notification_texts.dart';
import 'water_progress_cache.dart';

// НОВЫЕ импорты модулей
import 'notifications/notification_types.dart';
import 'notifications/notification_config.dart';
import 'notifications/helpers/timezone_helper.dart';
import 'notifications/helpers/notification_limits_helper.dart';
import 'notifications/helpers/schedule_window_helper.dart';

/// Основной сервис уведомлений HydraCoach
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final AnalyticsService _analytics = AnalyticsService();
  
  // Helper для лимитов
  late final NotificationLimitsHelper _limitsHelper;

  bool _isInitialized = false;

  // Кеш для быстрых проверок
  bool? _cachedProStatus;
  DateTime? _cacheExpiry;

  // Защита от дублей
  final Map<NotificationType, DateTime> _lastNotificationTime = {};
  final Map<NotificationType, int> _lastNotificationIds = {};
  final Set<int> _pendingNotificationIds = {};

  // ==================== ИНИЦИАЛИЗАЦИЯ ====================

  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeService();
  }

  Future<void> _initializeService() async {
    if (_isInitialized) {
      print('⚠️ NotificationService already initialized, skipping');
      return;
    }

    print('🚀 Initializing NotificationService...');

    try {
      // 1. Инициализация helper'ов
      _limitsHelper = NotificationLimitsHelper(_remoteConfig);

      // 2. Настройка timezone через новый helper
      await TimezoneHelper.initialize();
      
      // 3. Инициализация текстов уведомлений
      await NotificationTexts.initialize();
      await NotificationTexts.loadLocale();

      // 4. Инициализация локальных уведомлений
      await _initializeLocalNotifications();

      // 5. Firebase Messaging
      await _initializeFirebaseMessaging();

      // 6. Загрузка Remote Config
      await _loadRemoteConfig();

      // 7. Запрос разрешений
      await _requestPermissions();

      // 8. Очистка старых уведомлений
      await _cleanupAndRestoreNotifications();

      _isInitialized = true;
      print('✅ NotificationService initialized successfully');

      // 9. КРИТИЧНО: Планируем уведомления на сегодня
      await _scheduleInitialNotifications();
      
    } catch (e) {
      print('❌ Critical error during initialization: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// НОВЫЙ МЕТОД: Гарантированное планирование при запуске
  Future<void> _scheduleInitialNotifications() async {
    print('📱 Scheduling initial notifications...');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true;
      
      if (!notificationsEnabled) {
        print('⚠️ Notifications disabled by user');
        return;
      }

      // ВСЕГДА планируем на сегодня при запуске
      await _ensureTodayNotifications();
      
      // Затем планируем будущие дни
      await _scheduleFutureDays();
      
      // Выводим статус
      await printNotificationStatus();
      
    } catch (e) {
      print('❌ Failed to schedule initial notifications: $e');
      // Не прерываем инициализацию, но логируем ошибку
      await _analytics.logNotificationError(
        type: 'initialization',
        error: e.toString(),
      );
    }
  }

  /// Гарантированное планирование на сегодня
  Future<void> _ensureTodayNotifications() async {
    print('💧 Ensuring today\'s notifications...');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Отменяем существующие уведомления на сегодня чтобы избежать дублей
    await _cancelTodayNotifications();
    
    // Проверяем режим поста
    final isInFasting = await _limitsHelper.isInFastingWindow();
    
    if (!isInFasting) {
      // Планируем напоминания о воде
      await _scheduleWaterRemindersToday();
    } else {
      print('🥗 Fasting mode - scheduling electrolyte reminders');
      if (await _isProUser()) {
        await _scheduleFastingRemindersToday();
      }
    }
    
    // Всегда планируем вечерний отчет
    await _scheduleEveningReportToday();
    
    print('✅ Today\'s notifications scheduled');
  }

  /// Планирование напоминаний о воде на сегодня
  Future<void> _scheduleWaterRemindersToday() async {
    print('💧 Scheduling water reminders for today...');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Получаем текущий прогресс
    final waterPercent = (await WaterProgressCache.readPercent() ?? 0).toDouble();
    
    int scheduledCount = 0;
    
    // Получаем пользовательские времена напоминаний из SharedPreferences
final prefs = await SharedPreferences.getInstance();
final timesString = prefs.getString('water_reminder_times');
List<List<int>> reminderTimes;

if (timesString != null && timesString.isNotEmpty) {
  // Парсим сохранённые времена формата "8:00,11:15,14:30,17:45"
  reminderTimes = timesString.split(',').map((t) {
    final parts = t.split(':');
    return [int.parse(parts[0]), int.parse(parts[1])];
  }).toList();
  
  print('  📱 Using custom reminder times from user settings: $reminderTimes');
} else {
  // Если пользовательских настроек нет, используем базовые
  reminderTimes = NotificationConfig.baseReminderTimes;
  
  print('  📱 Using default reminder times: $reminderTimes');
}

for (final hm in reminderTimes) {
  final scheduledTime = DateTime(today.year, today.month, today.day, hm[0], hm[1]);

      // Пропускаем прошедшее время
      if (scheduledTime.isBefore(now)) {
        print('  ⏭️ Skipping ${hm[0]}:${hm[1].toString().padLeft(2, '0')} - already passed');
        continue;
      }
      
      // Добавляем небольшой рандомный сдвиг (±3 минуты)
      final random = Random();
      final jitter = random.nextInt(7) - 3;
      final adjustedTime = scheduledTime.add(Duration(minutes: jitter));
      
      print('  📅 Scheduling at ${adjustedTime.hour}:${adjustedTime.minute.toString().padLeft(2, '0')}');
      
      await sendNotification(
        type: NotificationType.waterReminder,
        title: NotificationTexts.waterReminderTitle,
        body: NotificationTexts.waterReminderBody(adjustedTime.hour, waterPercent),
        scheduledTime: adjustedTime,
        payload: {'action': 'drink_water'},
      );
      
      scheduledCount++;
    }
    
    print('  ✅ Scheduled $scheduledCount water reminders');
  }

  /// Планирование электролитных напоминаний на сегодня (PRO)
  Future<void> _scheduleFastingRemindersToday() async {
    print('🧂 Scheduling fasting electrolyte reminders...');
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (final hm in NotificationConfig.fastingElectrolyteTimes) {
      final scheduledTime = DateTime(today.year, today.month, today.day, hm[0], hm[1]);
      
      if (scheduledTime.isBefore(now)) {
        continue;
      }
      
      await sendNotification(
        type: NotificationType.fastingElectrolyte,
        title: NotificationTexts.fastingElectrolyteTitle,
        body: NotificationTexts.fastingElectrolyteBody,
        scheduledTime: scheduledTime,
        payload: {'action': 'add_electrolytes'},
      );
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
      print('📊 Scheduling evening report at $reportTime');
      
      await sendNotification(
        type: NotificationType.dailyReport,
        title: NotificationTexts.dailyReportTitle,
        body: NotificationTexts.dailyReportBody,
        scheduledTime: scheduledTime,
        payload: {'action': 'show_report'},
      );
    }
  }

  /// Отмена уведомлений на сегодня
  Future<void> _cancelTodayNotifications() async {
    final pending = await getPendingNotifications();
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59);
    
    for (final notification in pending) {
      // Проверяем по ID (день года в ID)
      final dayFromId = (notification.id % 1000) ~/ 1440;
      final todayDay = TimezoneHelper.dayOfYear(now);
      
      if (dayFromId == todayDay) {
        await cancelNotification(notification.id);
      }
    }
  }

  /// Планирование на будущие дни
  Future<void> _scheduleFutureDays() async {
    print('📅 Scheduling future days...');
    
    if (!await ScheduleWindowHelper.shouldRefreshWindow()) {
      print('  Window is fresh, skipping');
      return;
    }
    
    await ScheduleWindowHelper.cleanupOldMetadata();
    
    final (windowStart, windowEnd) = ScheduleWindowHelper.getWindowDates();
    
    // Начинаем с завтра
    var currentDate = windowStart.add(const Duration(days: 1));
    
    while (currentDate.isBefore(windowEnd)) {
      if (!await ScheduleWindowHelper.canScheduleMore()) {
        print('  iOS limit reached');
        break;
      }
      
      await _scheduleForDate(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    await ScheduleWindowHelper.markWindowRefreshed();
  }

  /// Планирование уведомлений на конкретную дату
  Future<void> _scheduleForDate(DateTime date) async {
    print('  📆 Scheduling for ${date.day}/${date.month}');
    
    final isPro = await _isProUser();
    
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
    final random = Random();
    
    // Получаем пользовательские времена напоминаний из SharedPreferences
final prefs = await SharedPreferences.getInstance();
final timesString = prefs.getString('water_reminder_times');
List<List<int>> reminderTimes;

if (timesString != null && timesString.isNotEmpty) {
  // Парсим сохранённые времена формата "8:00,11:15,14:30,17:45"
  reminderTimes = timesString.split(',').map((t) {
    final parts = t.split(':');
    return [int.parse(parts[0]), int.parse(parts[1])];
  }).toList();
} else {
  // Если пользовательских настроек нет, используем базовые
  reminderTimes = NotificationConfig.baseReminderTimes;
}

// Планируем напоминания на основе полученных времён
for (final hm in reminderTimes) {
  DateTime time = DateTime(date.year, date.month, date.day, hm[0], hm[1]);
      
      // Добавляем jitter
      final jitterMinutes = random.nextInt(7) - 3;
      time = time.add(Duration(minutes: jitterMinutes));
      
      final notificationId = _generateNotificationId(NotificationType.waterReminder, when: time);
      
      await ScheduleWindowHelper.saveScheduledMetadata(
        notificationId,
        time,
        NotificationType.waterReminder.name,
      );
      
      await sendNotification(
        type: NotificationType.waterReminder,
        title: NotificationTexts.waterReminderTitle,
        body: NotificationTexts.waterReminderBody(time.hour, 0),
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
    
    final notificationId = _generateNotificationId(NotificationType.dailyReport, when: scheduledTime);
    
    await ScheduleWindowHelper.saveScheduledMetadata(
      notificationId,
      scheduledTime,
      NotificationType.dailyReport.name,
    );
    
    await sendNotification(
      type: NotificationType.dailyReport,
      title: NotificationTexts.dailyReportTitle,
      body: NotificationTexts.dailyReportBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'show_report'},
    );
  }

  Future<void> _scheduleFastingRemindersForDate(DateTime date) async {
    for (final hm in NotificationConfig.fastingElectrolyteTimes) {
      final time = DateTime(date.year, date.month, date.day, hm[0], hm[1]);
      
      final notificationId = _generateNotificationId(NotificationType.fastingElectrolyte, when: time);
      
      await ScheduleWindowHelper.saveScheduledMetadata(
        notificationId,
        time,
        NotificationType.fastingElectrolyte.name,
      );
      
      await sendNotification(
        type: NotificationType.fastingElectrolyte,
        title: NotificationTexts.fastingElectrolyteTitle,
        body: NotificationTexts.fastingElectrolyteBody,
        scheduledTime: time,
        payload: {'action': 'add_electrolytes'},
      );
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final currentLocale = NotificationTexts.currentLocale;
    
    final defaultChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.defaultChannelSuffix}_$currentLocale';
    final urgentChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.urgentChannelSuffix}_$currentLocale';
    final reportChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.reportChannelSuffix}_$currentLocale';
    final silentChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.silentChannelSuffix}_$currentLocale';

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        defaultChannelId,
        NotificationTexts.channelNameDefault,
        description: NotificationTexts.channelDescDefault,
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        urgentChannelId,
        NotificationTexts.channelNameUrgent,
        description: NotificationTexts.channelDescUrgent,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        reportChannelId,
        NotificationTexts.channelNameReport,
        description: NotificationTexts.channelDescReport,
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        silentChannelId,
        NotificationTexts.channelNameSilent,
        description: NotificationTexts.channelDescSilent,
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
      ),
    );
    
    print('✅ Created Android channels for locale: $currentLocale');
  }

  Future<void> _initializeFirebaseMessaging() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
    }

    _messaging.onTokenRefresh.listen(_saveFCMToken);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }
  }

  Future<void> _loadRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await _remoteConfig.fetchAndActivate();
      print('📡 Remote Config loaded');
    } catch (e) {
      print('⚠️ Remote Config error: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  Future<void> _cleanupAndRestoreNotifications() async {
    final pending = await getPendingNotifications();
    print('📅 Found ${pending.length} pending notifications');

    _pendingNotificationIds.clear();
    for (final notification in pending) {
      _pendingNotificationIds.add(notification.id);
    }

    final prefs = await SharedPreferences.getInstance();
    final lastCoffeeTime = prefs.getInt(NotificationConfig.prefLastCoffeeNotificationTime);
    if (lastCoffeeTime != null) {
      _lastNotificationTime[NotificationType.postCoffee] =
          DateTime.fromMillisecondsSinceEpoch(lastCoffeeTime);
    }
  }

  // ==================== ПРОВЕРКИ И ОГРАНИЧЕНИЯ ====================

  Future<bool> _isProUser() async {
    if (_cachedProStatus != null &&
        _cacheExpiry != null &&
        DateTime.now().isBefore(_cacheExpiry!)) {
      return _cachedProStatus!;
    }

    _cachedProStatus = await _limitsHelper.isProUser();
    _cacheExpiry = DateTime.now().add(NotificationConfig.proStatusCacheDuration);

    return _cachedProStatus!;
  }

  Future<bool> _isDuplicateNotification(NotificationType type, {Duration? minInterval}) async {
    return await _limitsHelper.isDuplicateNotification(
      type, 
      _lastNotificationTime[type],
      minInterval: minInterval,
    );
  }

  Future<void> _cancelOldNotificationOfType(NotificationType type) async {
    final oldId = _lastNotificationIds[type];
    if (oldId != null && _pendingNotificationIds.contains(oldId)) {
      await cancelNotification(oldId);
      print('🚫 Cancelled old notification of type $type (ID: $oldId)');
    }
  }

  Future<bool> _canSendNotification() async {
    return await _limitsHelper.canSendNotification();
  }

  Future<void> _ensureTextsLoaded() async {
    await NotificationTexts.initialize();
    await NotificationTexts.loadLocale();
  }

  // ==================== ОСНОВНОЙ МЕТОД ОТПРАВКИ ====================

  Future<void> sendNotification({
    required NotificationType type,
    required String title,
    required String body,
    DateTime? scheduledTime,
    Map<String, dynamic>? payload,
    bool skipChecks = false,
    bool silentIfQuiet = false,
  }) async {
    if (!_isInitialized) {
      await _initializeService();
    }

    await _ensureTextsLoaded();

    if (!skipChecks && await _isDuplicateNotification(type)) {
      print('🚫 Duplicate notification blocked: $type');
      return;
    }

    if (scheduledTime == null && !skipChecks) {
      if (!await _canSendNotification()) {
        print('⌛ Cannot send: daily limit or anti-spam');
        await _analytics.logNotificationError(
          type: type.toString(),
          error: 'Daily limit or anti-spam',
        );
        return;
      }

      if (await _isProUser()) {
        if (!await _limitsHelper.checkProDailyCap()) {
          print('⌛ PRO hard cap reached');
          await _analytics.logNotificationError(
            type: type.toString(),
            error: 'PRO hard cap',
          );
          return;
        }
      }

      if (await _limitsHelper.isInQuietHours() && !silentIfQuiet) {
        print('🔇 Cannot send: quiet hours active');
        return;
      }
      if (!await _limitsHelper.shouldSendQuietFastingReminder()) {
        print('🥗 Cannot send: quiet fasting mode');
        return;
      }
    }

    if (type.isSingleton) {
      await _cancelOldNotificationOfType(type);
    }

    if (scheduledTime != null) {
      if (scheduledTime.isBefore(DateTime.now())) {
        print('⚠️ Scheduled time in the past, sending immediately');
        scheduledTime = null;
      } else if (!skipChecks && !silentIfQuiet) {
        scheduledTime = await _limitsHelper.adjustForQuietHours(scheduledTime);
      }
    }

    final currentLocale = NotificationTexts.currentLocale;
    String channelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.defaultChannelSuffix}_$currentLocale';
    Importance importance = Importance.high;
    Priority priority = Priority.high;

    switch (type.priority) {
      case NotificationPriority.urgent:
        channelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.urgentChannelSuffix}_$currentLocale';
        importance = Importance.max;
        priority = Priority.max;
        break;
      case NotificationPriority.normal:
        channelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.reportChannelSuffix}_$currentLocale';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;
      case NotificationPriority.low:
        channelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.silentChannelSuffix}_$currentLocale';
        importance = Importance.low;
        priority = Priority.low;
        break;
      default:
        break;
    }

    bool quietForThis = false;
    if (silentIfQuiet) {
      if (scheduledTime != null) {
        final prefs = await SharedPreferences.getInstance();
        final startStr = prefs.getString(NotificationConfig.prefQuietHoursStart) ?? NotificationConfig.defaultQuietHoursStart;
        final endStr = prefs.getString(NotificationConfig.prefQuietHoursEnd) ?? NotificationConfig.defaultQuietHoursEnd;
        quietForThis = _limitsHelper.isInQuietHoursAt(scheduledTime, startStr, endStr) && await _isProUser();
      } else {
        quietForThis = await _limitsHelper.isInQuietHours();
      }
    }
    if (quietForThis) {
      channelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.silentChannelSuffix}_$currentLocale';
      importance = Importance.low;
      priority = Priority.low;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId.contains('urgent') ? NotificationTexts.channelNameUrgent
          : channelId.contains('report') ? NotificationTexts.channelNameReport
          : channelId.contains('silent') ? NotificationTexts.channelNameSilent
          : NotificationTexts.channelNameDefault,
      importance: importance,
      priority: priority,
      ticker: 'HydraCoach',
      icon: '@mipmap/ic_launcher',
      color: const Color.fromARGB(255, 33, 150, 243),
      enableVibration: !channelId.contains('report') && !channelId.contains('silent'),
      playSound: !channelId.contains('silent'),
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'HydraCoach',
      ),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: !quietForThis,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = _generateNotificationId(type, when: scheduledTime);

    if (type.isSingleton) {
      _lastNotificationIds[type] = notificationId;
    }

    final mergedPayload = {'type': type.name, ...?payload};
    final payloadStr = jsonEncode(mergedPayload);

    try {
      if (scheduledTime == null) {
        await _localNotifications.show(
          notificationId,
          title,
          body,
          details,
          payload: payloadStr,
        );

        await _limitsHelper.incrementNotificationCount();
        await _limitsHelper.saveLastNotificationTime();
        await _limitsHelper.incrementProCount();

        _lastNotificationTime[type] = DateTime.now();
        if (type == NotificationType.postCoffee) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(
            NotificationConfig.prefLastCoffeeNotificationTime,
            DateTime.now().millisecondsSinceEpoch,
          );
        }

        print('📬 Notification sent: $title');

        await _analytics.logNotificationSent(
          type: type.toString(),
          isScheduled: false,
        );
      } else {
        final tzScheduledTime = TimezoneHelper.toTZDateTime(scheduledTime);

        await _localNotifications.zonedSchedule(
          notificationId,
          title,
          body,
          tzScheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payloadStr,
        );

        _pendingNotificationIds.add(notificationId);

        print('📅 Notification scheduled for ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}: $title');

        await _analytics.logNotificationScheduled(
          type: type.toString(),
          scheduledTime: scheduledTime,
          delayMinutes: scheduledTime.difference(DateTime.now()).inMinutes,
        );
      }

      await _saveNotificationToHistory(type, title, body, scheduledTime);
    } catch (e) {
      print('❌ Error sending notification: $e');

      await _analytics.logNotificationError(
        type: type.toString(),
        error: e.toString(),
      );
    }
  }

  int _generateNotificationId(NotificationType type, {DateTime? when}) {
    final t = when ?? DateTime.now();
    final day = TimezoneHelper.dayOfYear(t);
    final mod = (day * 1440 + t.hour * 60 + t.minute) % 1000;
    return type.index * 1000 + mod;
  }

  // ==================== СПЕЦИФИЧНЫЕ УВЕДОМЛЕНИЯ ====================

  Future<void> schedulePostCoffeeReminder() async {
    await _ensureTextsLoaded();
    
    if (await _isDuplicateNotification(NotificationType.postCoffee)) {
      print('☕ Coffee reminder already scheduled recently');
      return;
    }

    final delay = _remoteConfig.getInt(NotificationConfig.rcPostCoffeeDelay);
    final delayMinutes = delay > 0 ? delay : NotificationConfig.postCoffeeDelayMinutes;

    final scheduledTime = DateTime.now().add(Duration(minutes: delayMinutes));

    await sendNotification(
      type: NotificationType.postCoffee,
      title: NotificationTexts.postCoffeeTitle,
      body: NotificationTexts.postCoffeeBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'add_water', 'amount': 250},
    );
  }

  Future<void> scheduleAlcoholCounterReminder(int standardDrinks) async {
    await _ensureTextsLoaded();
    
    final scheduledTime = DateTime.now().add(Duration(minutes: NotificationConfig.alcoholCounterDelayMinutes));

    final waterAmount = standardDrinks * NotificationConfig.waterPerStandardDrink;

    await sendNotification(
      type: NotificationType.alcoholCounter,
      title: NotificationTexts.alcoholCounterTitle,
      body: NotificationTexts.alcoholCounterBody(waterAmount),
      scheduledTime: scheduledTime,
      payload: {'action': 'alcohol_recovery', 'water': waterAmount},
    );

    if (await _isProUser()) {
      await _scheduleAlcoholRecoveryPlan(standardDrinks);
    }
  }

  Future<void> _scheduleAlcoholRecoveryPlan(int standardDrinks) async {
    await _ensureTextsLoaded();
    
    final recoveryHours = standardDrinks <= 2 
        ? NotificationConfig.lightRecoveryHours 
        : NotificationConfig.heavyRecoveryHours;
    final now = DateTime.now();

    for (int hour = NotificationConfig.recoveryStepInterval; 
         hour <= recoveryHours; 
         hour += NotificationConfig.recoveryStepInterval) {
      final scheduledTime = now.add(Duration(hours: hour));
      final waterAmount = 300 + (standardDrinks * 50);

      final withElectrolytes = hour == recoveryHours ~/ 2;

      await sendNotification(
        type: NotificationType.alcoholRecovery,
        title: NotificationTexts.alcoholRecoveryStepTitle(hour),
        body: NotificationTexts.alcoholRecoveryStepBody(waterAmount, withElectrolytes),
        scheduledTime: scheduledTime,
        payload: {'action': 'recovery_step', 'hour': hour},
        skipChecks: true,
        silentIfQuiet: true,
      );
    }

    await scheduleMorningCheckIn();
  }

  Future<void> scheduleMorningCheckIn() async {
    await _ensureTextsLoaded();
    
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year, 
      now.month, 
      now.day + 1, 
      NotificationConfig.morningCheckInHour, 
      NotificationConfig.morningCheckInMinute
    );

    await sendNotification(
      type: NotificationType.morningCheckIn,
      title: NotificationTexts.morningCheckInTitle,
      body: NotificationTexts.morningCheckInBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'morning_checkin'},
    );
  }

  Future<void> sendHeatWarning(double heatIndex) async {
    if (!await _isProUser()) {
      print('⚠️ Heat warnings - PRO feature');
      return;
    }

    await _ensureTextsLoaded();

    await sendNotification(
      type: NotificationType.heatWarning,
      title: NotificationTexts.heatWarningTitle,
      body: NotificationTexts.heatWarningBody(heatIndex),
      payload: {'action': 'heat_warning', 'heat_index': heatIndex},
      skipChecks: true,
    );
  }

  Future<void> sendWorkoutReminder({DateTime? workoutEndTime}) async {
    if (!await _isProUser()) {
      print('⚠️ Workout reminders - PRO feature');
      return;
    }

    if (workoutEndTime == null) {
      print('⚠️ No workout end time provided');
      return;
    }

    await _ensureTextsLoaded();

    final postWorkout = workoutEndTime.add(Duration(minutes: NotificationConfig.postWorkoutDelayMinutes));

    if (postWorkout.isBefore(DateTime.now())) {
      print('⚠️ Post-workout time already passed');
      return;
    }

    await sendNotification(
      type: NotificationType.workoutReminder,
      title: NotificationTexts.postWorkoutTitle,
      body: NotificationTexts.postWorkoutBody,
      scheduledTime: postWorkout,
      payload: {'action': 'post_workout'},
    );
  }

  Future<void> scheduleEveningReport() async {
    await _ensureTextsLoaded();
    
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

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await sendNotification(
      type: NotificationType.dailyReport,
      title: NotificationTexts.dailyReportTitle,
      body: NotificationTexts.dailyReportBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'show_report'},
    );
  }

  // ==================== УМНЫЕ НАПОМИНАНИЯ ====================

  Future<void> scheduleSmartReminders() async {
    print('🧠 Scheduling smart reminders...');

    await _ensureTextsLoaded();

    // Сначала гарантируем сегодняшние
    await _ensureTodayNotifications();
    
    // Затем будущие
    await _scheduleFutureDays();
    
    print('✅ Smart reminders scheduled');
  }

  // ==================== УПРАВЛЕНИЕ УВЕДОМЛЕНИЯМИ ====================

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    _pendingNotificationIds.remove(id);
    print('🚫 Notification cancelled: $id');
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    _pendingNotificationIds.clear();
    _lastNotificationIds.clear();
    print('🗑️ All notifications cancelled');
  }

  Future<void> cancelByTypes(Set<NotificationType> types) async {
    final pending = await getPendingNotifications();
    final typeIdxSet = types.map((t) => t.index).toSet();
    for (final p in pending) {
      final id = p.id;
      final typeIdx = id ~/ 1000;
      if (typeIdxSet.contains(typeIdx)) {
        await cancelNotification(id);
      }
    }
    print('🚫 Cancelled notifications for types: $types');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  Future<void> printNotificationStatus() async {
    final pending = await getPendingNotifications();
    print('\n📋 ===== NOTIFICATION STATUS =====');
    print('📋 Pending notifications: ${pending.length}');

    if (pending.isNotEmpty) {
      // Группируем по типам
      final Map<String, int> typeCount = {};
      
      for (final notification in pending) {
        final typeIdx = notification.id ~/ 1000;
        final typeName = NotificationType.values[typeIdx].name;
        typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
      }
      
      typeCount.forEach((type, count) {
        print('  - $type: $count notifications');
      });
      
      // Показываем ближайшие 3
      print('\n📋 Next 3 notifications:');
      for (int i = 0; i < pending.length && i < 3; i++) {
        print('  ${i + 1}. ${pending[i].title}');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final isPro = await _isProUser();
    final todayCount = prefs.getInt(NotificationConfig.prefNotificationCountToday) ?? 0;
    final currentLocale = NotificationTexts.currentLocale;

    print('\n📋 User status: ${isPro ? "PRO" : "FREE"}');
    print('📋 Today sent (FREE): $todayCount${isPro ? "" : "/4"}');
    print('📋 Notifications enabled: ${prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true}');
    print('📋 Current locale: $currentLocale');
    print('📋 Timezone: ${tz.local.name}');
    print('📋 =================================\n');
  }

  // ==================== ОБРАБОТЧИКИ ====================

  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Notification tapped');

    try {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        final type = data['type'] as String?;
        AnalyticsService().logNotificationOpened(
          type: type ?? 'unknown',
          action: data['action'],
        );
      }
    } catch (e) {
      print('Error logging notification tap: $e');
    }

    _processNotificationAction(response.payload);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    print('📱 Background notification tapped');
    _processNotificationAction(response.payload);
  }

  static void _processNotificationAction(String? payload) {
    if (payload == null) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final action = data['action'] as String?;

      print('🎯 Processing action: $action');

    } catch (e) {
      print('⚠️ Error processing notification action: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground FCM message received');

    if (message.notification != null) {
      await sendNotification(
        type: NotificationType.custom,
        title: message.notification!.title ?? 'HydraCoach',
        body: message.notification!.body ?? '',
        payload: message.data,
        skipChecks: true,
      );
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    print('📱 FCM notification opened');
    _processNotificationAction(jsonEncode(message.data));
  }

  Future<void> _saveFCMToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(NotificationConfig.prefFcmToken, token);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fcm_token': token,
        'platform': Platform.operatingSystem,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await _messaging.subscribeToTopic('all_users');

    final dietMode = prefs.getString(NotificationConfig.prefDietMode) ?? 'normal';
    await _messaging.subscribeToTopic('${dietMode}_users');
  }

  Future<void> _saveNotificationToHistory(
    NotificationType type,
    String title,
    String body,
    DateTime? scheduledTime,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notification_history')
          .add({
        'type': type.toString(),
        'title': title,
        'body': body,
        'scheduled_time': scheduledTime?.toIso8601String(),
        'sent_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('⚠️ Error saving notification history: $e');
    }
  }

  // ==================== ТЕСТИРОВАНИЕ ====================

  Future<void> sendTestNotification() async {
    await _ensureTextsLoaded();
    
    await sendNotification(
      type: NotificationType.custom,
      title: NotificationTexts.testTitle,
      body: NotificationTexts.testBody,
      payload: {'action': 'test'},
      skipChecks: true,
    );

    await _analytics.logTestEvent();
  }

  Future<void> scheduleTestIn1Minute() async {
    await _ensureTextsLoaded();
    
    final scheduledTime = DateTime.now().add(const Duration(minutes: 1));

    await sendNotification(
      type: NotificationType.custom,
      title: NotificationTexts.testScheduledTitle,
      body: NotificationTexts.testScheduledBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'test_scheduled'},
      skipChecks: true,
    );
  }

  // ==================== ОБРАБОТКА СМЕНЫ ЯЗЫКА ====================
  
  /// Вызывается при смене языка приложения
  /// Пересоздает Android каналы и перепланирует уведомления с новыми текстами
  Future<void> onLocaleChanged(String localeCode) async {
    print('🌍 [NotificationService] Language change initiated: $localeCode');
    
    try {
      // 1. Убеждаемся что сервис инициализирован
      if (!_isInitialized) {
        print('⚠️ NotificationService not initialized, initializing first...');
        await _initializeService();
      }
      
      // 2. Обновляем тексты уведомлений на новый язык
      print('📝 Updating notification texts to: $localeCode');
      await NotificationTexts.setLocale(localeCode);
      
      // 3. Для Android пересоздаем каналы с новыми локализованными названиями
      if (Platform.isAndroid) {
        print('🔧 Recreating Android notification channels...');
        await _createAndroidChannels();
      }
      
      // 4. Получаем список текущих запланированных уведомлений
      final pendingBefore = await getPendingNotifications();
      print('📋 Found ${pendingBefore.length} pending notifications before locale change');
      
      // 5. ВАЖНО: Сохраняем событийные уведомления перед отменой
      final Map<int, Map<String, dynamic>> eventNotifications = {};
      final eventTypes = {
        NotificationType.postCoffee.index,      // После кофе - событийное
        NotificationType.alcoholCounter.index,   // После алкоголя - событийное
        NotificationType.alcoholRecovery.index,  // План восстановления - событийное
        NotificationType.workoutReminder.index,  // После тренировки - событийное
        NotificationType.morningCheckIn.index,   // Утренний чек-ин после алкоголя - событийное
      };
      
      // Извлекаем данные событийных уведомлений
      for (final notification in pendingBefore) {
        final typeIdx = notification.id ~/ 1000;
        if (eventTypes.contains(typeIdx)) {
          // Пытаемся извлечь время из ID уведомления
          final day = (notification.id % 1000) ~/ 1440 + 1;
          final minutesInDay = (notification.id % 1000) % 1440;
          final hour = minutesInDay ~/ 60;
          final minute = minutesInDay % 60;
          
          eventNotifications[notification.id] = {
            'id': notification.id,
            'typeIdx': typeIdx,
            'title': notification.title,
            'body': notification.body,
            'payload': notification.payload,
            'hour': hour,
            'minute': minute,
            'day': day,
          };
          
          print('💾 Preserving event notification: Type=${NotificationType.values[typeIdx]} (ID: ${notification.id})');
        }
      }
      
      // 6. Отменяем ТОЛЬКО базовые уведомления (не событийные)
      print('🗑️ Cancelling only baseline (non-event) notifications...');
      
      // Типы базовых уведомлений, которые нужно перепланировать
      final baselineTypes = {
        NotificationType.waterReminder,     // Регулярные напоминания о воде
        NotificationType.dailyReport,        // Вечерний отчет
        NotificationType.smartReminder,      // Умные напоминания
        NotificationType.heatWarning,        // Предупреждения о жаре (перепланируются)
        NotificationType.fastingElectrolyte, // Электролиты в пост
      };
      
      // НЕ включаем в отмену:
      // - postCoffee (событийное после добавления кофе)
      // - alcoholCounter (событийное после добавления алкоголя)  
      // - alcoholRecovery (план восстановления)
      // - workoutReminder (после тренировки)
      // - morningCheckIn (утренний чек-ин после алкоголя)
      
      await cancelByTypes(baselineTypes);
      
      // 7. Проверяем настройки пользователя
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      
      if (!notificationsEnabled) {
        print('⚠️ Notifications are disabled, skipping rescheduling');
        return;
      }
      
      // 8. Перепланируем ТОЛЬКО базовые уведомления с новыми текстами
      print('📅 Rescheduling baseline notifications with new locale...');
      
      // Загружаем актуальные тексты
      await NotificationTexts.ensureLoaded();
      
      // Сбрасываем метку обновления окна, чтобы форсировать перепланирование
      await prefs.remove('schedule_window_last_refresh');
      
      // Планируем базовые напоминания на сегодня
      await _ensureTodayNotifications();
      
      // Планируем на будущие дни (теперь окно не будет считаться свежим)
      await _scheduleFutureDays();
      
      // 9. Проверяем результат
      final pendingAfter = await getPendingNotifications();
      
      // Проверяем что событийные уведомления остались
      int preservedCount = 0;
      final Map<NotificationType, int> preservedByType = {};
      
      for (final notification in pendingAfter) {
        final typeIdx = notification.id ~/ 1000;
        if (eventNotifications.containsKey(notification.id)) {
          preservedCount++;
          final type = NotificationType.values[typeIdx];
          preservedByType[type] = (preservedByType[type] ?? 0) + 1;
        }
      }
      
      print('✅ Locale change complete:');
      print('   - Event notifications found before: ${eventNotifications.length}');
      print('   - Event notifications preserved: $preservedCount');
      print('   - Total notifications after: ${pendingAfter.length}');
      
      // Детальный вывод по типам событийных уведомлений
      if (preservedByType.isNotEmpty) {
        print('   - Preserved by type:');
        preservedByType.forEach((type, count) {
          print('     • ${type.name}: $count');
        });
      }
      
      // Если не все событийные уведомления сохранились, выводим предупреждение
      if (preservedCount < eventNotifications.length) {
        print('⚠️ WARNING: Not all event notifications were preserved!');
        print('   Expected: ${eventNotifications.length}, Got: $preservedCount');
        
        // Проверяем какие именно потерялись
        for (final entry in eventNotifications.entries) {
          bool found = false;
          for (final notification in pendingAfter) {
            if (notification.id == entry.key) {
              found = true;
              break;
            }
          }
          if (!found) {
            final typeIdx = entry.value['typeIdx'] as int;
            print('   ❌ Lost: ${NotificationType.values[typeIdx].name} (ID: ${entry.key})');
          }
        }
      }
      
      // Выводим примеры для проверки
      if (pendingAfter.isNotEmpty) {
        print('📬 Sample notifications after locale change:');
        for (var i = 0; i < (pendingAfter.length > 3 ? 3 : pendingAfter.length); i++) {
          final notification = pendingAfter[i];
          final typeIdx = notification.id ~/ 1000;
          print('   ${i+1}. Type: ${NotificationType.values[typeIdx].name}');
          print('      Title: ${notification.title}');
        }
      }
      
      // 10. Логируем в аналитику
      await _analytics.logSettingsChanged(
        setting: 'notification_locale',
        value: localeCode,
      );
      
      print('📊 Analytics: locale changed to $localeCode');
      print('   - Baseline notifications rescheduled');
      print('   - Event notifications preserved: ${eventNotifications.length}');
      
    } catch (e, stackTrace) {
      print('❌ Error changing notification locale: $e');
      print('Stack trace: $stackTrace');
      
      // Логируем ошибку но не прерываем работу приложения
      await _analytics.logNotificationError(
        type: 'locale_change',
        error: e.toString(),
      );
    }
  }
}