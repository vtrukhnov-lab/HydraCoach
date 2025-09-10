// lib/services/notification_service.dart
// РЕФАКТОРИНГ: Используем новые модули для уменьшения размера файла

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

  // Кэш для быстрых проверок
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

    // 8. Очистка старых уведомлений и восстановление запланированных
    await _cleanupAndRestoreNotifications();

    _isInitialized = true;
    print('✅ NotificationService initialized successfully');

    await printNotificationStatus();
    
    // 9. Автоматически планируем базовые уведомления при старте
    try {
      print('🔄 Auto-scheduling baseline reminders at startup...');
      await scheduleSmartReminders();
    } catch (e) {
      print('⚠️ Failed to schedule smart reminders at init: $e');
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
        print('❌ Cannot send: daily limit or anti-spam');
        await _analytics.logNotificationError(
          type: type.toString(),
          error: 'Daily limit or anti-spam',
        );
        return;
      }

      if (await _isProUser()) {
        if (!await _limitsHelper.checkProDailyCap()) {
          print('❌ PRO hard cap reached');
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

        print('📅 Notification scheduled for $scheduledTime: $title');

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

    await cancelByTypes({
      NotificationType.waterReminder,
      NotificationType.fastingElectrolyte,
      NotificationType.smartReminder,
    });

    final isPro = await _isProUser();

    await _scheduleBasicReminders();

    if (isPro) {
      await _scheduleContextualReminders();
      await _scheduleFastingReminders();
    }

    await scheduleEveningReport();

    print('✅ Smart reminders scheduled');
  }

  Future<void> _scheduleBasicReminders() async {
    final now = DateTime.now();

    if (await _limitsHelper.isInFastingWindow()) {
      return;
    }

    final waterProgressPercent = await WaterProgressCache.readPercent();

    final reminderTimes = <DateTime>[];
    for (final hm in NotificationConfig.baseReminderTimes) {
      DateTime time = DateTime(now.year, now.month, now.day, hm[0], hm[1]);
      
      if (time.isBefore(now.subtract(const Duration(hours: 1)))) {
        time = time.add(const Duration(days: 1));
      } else if (time.isBefore(now)) {
        time = now.add(const Duration(hours: 1));
      }
      
      reminderTimes.add(time);
    }

    for (final time in reminderTimes) {
      final title = NotificationTexts.waterReminderTitle;
      final body = NotificationTexts.waterReminderBody(
        time.hour, 
        (waterProgressPercent ?? 0).toDouble()
      );

      await sendNotification(
        type: NotificationType.waterReminder,
        title: title,
        body: body,
        scheduledTime: time,
        payload: {'action': 'drink_water'},
      );
    }
  }
  
  Future<void> _scheduleContextualReminders() async {
    final prefs = await SharedPreferences.getInstance();

    final hasWorkoutToday = prefs.getBool(NotificationConfig.prefHasWorkoutToday) ?? false;
    final heatIndex = prefs.getDouble(NotificationConfig.prefHeatIndex) ?? 20;

    if (heatIndex > 27) {
      await sendHeatWarning(heatIndex);
    }

    if (hasWorkoutToday) {
      final workoutTimeStr = prefs.getString(NotificationConfig.prefWorkoutTime);
      final durationMin = prefs.getInt(NotificationConfig.prefWorkoutDurationMinutes) ?? 60;

      if (workoutTimeStr != null) {
        final parts = workoutTimeStr.split(':');
        final now = DateTime.now();
        final workoutStart = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
        final workoutEnd = workoutStart.add(Duration(minutes: durationMin));

        await sendWorkoutReminder(workoutEndTime: workoutEnd);
      }
    }
  }

  Future<void> _scheduleFastingReminders() async {
    if (!await _limitsHelper.isInFastingWindow()) return;

    final now = DateTime.now();

    for (final hm in NotificationConfig.fastingElectrolyteTimes) {
      final time = DateTime(now.year, now.month, now.day, hm[0], hm[1]);
      if (time.isAfter(now)) {
        await sendNotification(
          type: NotificationType.fastingElectrolyte,
          title: NotificationTexts.fastingElectrolyteTitle,
          body: NotificationTexts.fastingElectrolyteBody,
          scheduledTime: time,
          payload: {'action': 'add_electrolytes'},
        );
      }
    }
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
      for (final notification in pending) {
        print('  - ID: ${notification.id}');
        print('    Title: ${notification.title}');
        print('    Body: ${notification.body}');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final isPro = await _isProUser();
    final todayCount = prefs.getInt(NotificationConfig.prefNotificationCountToday) ?? 0;
    final currentLocale = NotificationTexts.currentLocale;

    print('📋 User status: ${isPro ? "PRO" : "FREE"}');
    print('📋 Today sent (FREE): $todayCount${isPro ? "" : "/4"}');
    print('📋 Last coffee reminder: ${_lastNotificationTime[NotificationType.postCoffee]}');
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
  
  Future<void> onLocaleChanged(String localeCode) async {
    print('🌍 [NotificationService] Language change initiated: $localeCode');
    
    try {
      if (!_isInitialized) {
        print('⚠️ NotificationService not initialized, initializing first...');
        await _initializeService();
      }
      
      print('📝 Updating notification texts to: $localeCode');
      await NotificationTexts.setLocale(localeCode);
      
      if (Platform.isAndroid) {
        print('🔧 Recreating Android notification channels...');
        await _createAndroidChannels();
      }
      
      final pendingBefore = await getPendingNotifications();
      print('📋 Found ${pendingBefore.length} pending notifications before locale change');
      
      await cancelAllNotifications();
      
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true;
      
      if (!notificationsEnabled) {
        print('⚠️ Notifications are disabled, skipping rescheduling');
        return;
      }
      
      await NotificationTexts.ensureLoaded();
      await scheduleSmartReminders();
      
      await _analytics.logSettingsChanged(
        setting: 'notification_locale',
        value: localeCode,
      );
      
      print('✅ Locale change complete');
      
    } catch (e) {
      print('❌ Error changing notification locale: $e');
      await _analytics.logNotificationError(
        type: 'locale_change',
        error: e.toString(),
      );
    }
  }
}