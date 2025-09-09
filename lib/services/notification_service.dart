// lib/services/notification_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import '../l10n/app_localizations.dart';
import 'locale_service.dart';
import 'subscription_service.dart';
import 'analytics_service.dart';
import 'notification_texts.dart';
import 'water_progress_cache.dart';

// ==================== ТИПЫ УВЕДОМЛЕНИЙ ====================

enum NotificationType {
  // FREE
  waterReminder,        // Базовое напоминание о воде
  postCoffee,           // После кофе (1 раз)
  dailyReport,          // Вечерний отчет
  alcoholCounter,       // Контр-пинг после алкоголя

  // PRO
  smartReminder,        // Умное контекстное
  heatWarning,          // Предупреждение о жаре
  workoutReminder,      // Напоминание при тренировке (только POST-workout)
  fastingElectrolyte,   // Электролиты в пост
  alcoholRecovery,      // План восстановления
  morningCheckIn,       // Утренний чек-ин

  // SYSTEM
  custom,               // Кастомные уведомления (FCM, тесты и т.д.)
}

// ==================== ОСНОВНОЙ СЕРВИС ====================

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

  bool _isInitialized = false;

  // Кэш для быстрых проверок
  bool? _cachedProStatus;
  DateTime? _cacheExpiry;

  // Защита от дублей
  final Map<NotificationType, DateTime> _lastNotificationTime = {};
  final Map<NotificationType, int> _lastNotificationIds = {};
  final Set<int> _pendingNotificationIds = {};

  // Типы, которые должны быть единственными (заменяться)
  static const singletonTypes = {
    NotificationType.dailyReport,
    NotificationType.morningCheckIn,
    NotificationType.heatWarning,
    NotificationType.postCoffee,
  };

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

    // 1. Настройка timezone
    await _initializeTimezone();
    
    // 2. Инициализация текстов уведомлений
    await NotificationTexts.initialize();

    // 3. Загрузка локали для текстов
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
    
    // 9. НОВОЕ: Автоматически планируем базовые уведомления при старте
    try {
      print('🔄 Auto-scheduling baseline reminders at startup...');
      await scheduleSmartReminders();
    } catch (e) {
      print('⚠️ Failed to schedule smart reminders at init: $e');
    }
  }

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();

    String timeZoneName;

    try {
      // Определяем тайм-зону по смещению
      final now = DateTime.now();
      final offset = now.timeZoneOffset;

      // Мапим популярные смещения на тайм-зоны
      if (offset.inHours == 1) {
        timeZoneName = 'Europe/Madrid'; // CET (зимой)
      } else if (offset.inHours == 0) {
        timeZoneName = 'Europe/London'; // GMT
      } else if (offset.inHours == 3) {
        timeZoneName = 'Europe/Moscow'; // MSK
      } else if (offset.inHours == -5) {
        timeZoneName = 'America/New_York'; // EST
      } else if (offset.inHours == -8) {
        timeZoneName = 'America/Los_Angeles'; // PST
      } else {
        // Для других смещений используем сохраненную или дефолтную
        final prefs = await SharedPreferences.getInstance();
        timeZoneName = prefs.getString('user_timezone') ?? 'Europe/Madrid';
      }

      print('🌍 Detected timezone offset: ${offset.inHours}h, using: $timeZoneName');
    } catch (e) {
      print('⚠️ Failed to detect timezone: $e');
      // Fallback на сохраненную или дефолтную
      final prefs = await SharedPreferences.getInstance();
      timeZoneName = prefs.getString('user_timezone') ?? 'Europe/Madrid';
    }

    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print('🌍 Timezone set to: $timeZoneName');

      // Сохраняем для будущего использования
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_timezone', timeZoneName);
    } catch (e) {
      print('⚠️ Failed to set timezone $timeZoneName, using UTC');
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    // Android настройки
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS настройки
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

    // Инициализация с обработчиками
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Создание Android каналов
    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Получаем текущий язык для создания языкозависимых ID каналов
    final currentLocale = NotificationTexts.currentLocale;
    
    // ID каналов с суффиксом языка
    final defaultChannelId = 'hydracoach_default_$currentLocale';
    final urgentChannelId = 'hydracoach_urgent_$currentLocale';
    final reportChannelId = 'hydracoach_report_$currentLocale';
    final silentChannelId = 'hydracoach_silent_$currentLocale';

    // Основной канал
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

    // Срочный канал
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

    // Канал отчетов
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

    // Тихий канал (для ночных recovery-пингов без звука)
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
    // Получение FCM токена
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
    }

    // Подписка на обновление токена
    _messaging.onTokenRefresh.listen(_saveFCMToken);

    // Обработка сообщений
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    // Проверка начального сообщения
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
        // Android 13+ требует разрешение на уведомления
        await androidPlugin.requestNotificationsPermission();

        // Android 12+ может требовать разрешение на точные будильники
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  Future<void> _cleanupAndRestoreNotifications() async {
    final pending = await getPendingNotifications();
    print('📅 Found ${pending.length} pending notifications');

    // Сохраняем ID запланированных уведомлений
    _pendingNotificationIds.clear();
    for (final notification in pending) {
      _pendingNotificationIds.add(notification.id);
    }

    // Загружаем историю последних уведомлений из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final lastCoffeeTime = prefs.getInt('last_coffee_notification_time');
    if (lastCoffeeTime != null) {
      _lastNotificationTime[NotificationType.postCoffee] =
          DateTime.fromMillisecondsSinceEpoch(lastCoffeeTime);
    }
  }

  // ==================== ПРОВЕРКИ И ОГРАНИЧЕНИЯ ====================

  Future<bool> _isProUser() async {
    // Кэшируем статус PRO на 5 минут
    if (_cachedProStatus != null &&
        _cacheExpiry != null &&
        DateTime.now().isBefore(_cacheExpiry!)) {
      return _cachedProStatus!;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedProStatus = prefs.getBool('is_pro') ?? false;
    _cacheExpiry = DateTime.now().add(const Duration(minutes: 5));

    return _cachedProStatus!;
  }

  Future<bool> _isDuplicateNotification(NotificationType type, {Duration? minInterval}) async {
    final lastTime = _lastNotificationTime[type];
    if (lastTime == null) return false;

    // Минимальные интервалы для разных типов
    final intervals = {
      NotificationType.postCoffee: const Duration(hours: 2),
      NotificationType.waterReminder: const Duration(hours: 1),
      NotificationType.dailyReport: const Duration(hours: 23),
      NotificationType.alcoholCounter: const Duration(hours: 1),
      NotificationType.smartReminder: const Duration(minutes: 30),
      NotificationType.workoutReminder: const Duration(hours: 2),
    };

    final requiredInterval = minInterval ?? intervals[type] ?? const Duration(minutes: 30);
    final timeSinceLastpassed = DateTime.now().difference(lastTime);

    if (timeSinceLastpassed < requiredInterval) {
      print('⚠️ Duplicate prevention: $type was sent ${timeSinceLastpassed.inMinutes} min ago');

      await _analytics.logNotificationDuplicate(
        type: type.toString(),
        count: 1,
      );

      return true;
    }

    return false;
  }

  Future<void> _cancelOldNotificationOfType(NotificationType type) async {
    final oldId = _lastNotificationIds[type];
    if (oldId != null && _pendingNotificationIds.contains(oldId)) {
      await cancelNotification(oldId);
      print('🚫 Cancelled old notification of type $type (ID: $oldId)');
    }
  }

  Future<bool> _canSendNotification() async {
    final isPro = await _isProUser();

    // Проверяем антиспам для всех (FREE: 90 мин, PRO: 60 мин)
    final okInterval = await _checkAntiSpam(overrideMinutes: isPro ? 60 : 90);
    if (!okInterval) return false;

    // FREE пользователи - дополнительно проверяем дневной лимит
    if (!isPro) {
      return await _checkDailyLimit();
    }

    return true;
  }

  Future<bool> _checkDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем дату последнего сброса
    final lastReset = prefs.getString('notification_limit_reset') ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      // Новый день - сбрасываем счетчик
      await prefs.setInt('notification_count_today', 0);
      await prefs.setString('notification_limit_reset', today);
      return true;
    }

    // Проверяем текущий счетчик
    final count = prefs.getInt('notification_count_today') ?? 0;
    final maxFree = _remoteConfig.getInt('max_free_notifications_daily');
    final limit = maxFree > 0 ? maxFree : 4; // По умолчанию 4

    return count < limit;
  }

  Future<void> _incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('notification_count_today') ?? 0;
    await prefs.setInt('notification_count_today', count + 1);
  }

  Future<bool> _checkAntiSpam({int? overrideMinutes}) async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем включен ли анти-спам
    final antiSpamEnabled = prefs.getBool('anti_spam_enabled') ?? true;
    if (!antiSpamEnabled) return true;

    // Проверяем время последнего уведомления
    final lastTime = prefs.getInt('last_notification_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Минимальный интервал
    final rc = _remoteConfig.getInt('anti_spam_interval_minutes');
    final minMin = overrideMinutes ?? (rc > 0 ? rc : 60);
    final intervalMs = minMin * 60 * 1000;

    if (now - lastTime < intervalMs) {
      print('⏰ Anti-spam: too soon since last notification (need ${minMin} min)');
      return false;
    }

    return true;
  }

  Future<void> _saveLastNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_notification_time', DateTime.now().millisecondsSinceEpoch);
  }

  // PRO суточный кап (мягк. 6 / жёстк. 8) — считаем по немедленным пушам
  Future<bool> _checkProDailyCap() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('pro_cap_reset') ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (lastReset != today) {
      await prefs.setInt('pro_sent_today', 0);
      await prefs.setString('pro_cap_reset', today);
    }
    final sent = prefs.getInt('pro_sent_today') ?? 0;

    final soft = _remoteConfig.getInt('push_pro_daily_cap');
    final hard = _remoteConfig.getInt('push_pro_hard_cap');
    final softCap = soft > 0 ? soft : 6;
    final hardCap = hard > 0 ? hard : 8;

    if (sent >= hardCap) return false; // жесткий стоп
    if (sent >= softCap) {
      // Мягкий кап достигнут — не стопорим, но можно логировать
      await _analytics.logNotificationError(
        type: 'PRO_CAP',
        error: 'Soft cap reached ($softCap)',
      );
    }
    return true;
  }

  Future<void> _incrementProCountIfNeeded() async {
    if (!await _isProUser()) return;
    final prefs = await SharedPreferences.getInstance();
    final sent = prefs.getInt('pro_sent_today') ?? 0;
    await prefs.setInt('pro_sent_today', sent + 1);
  }

  Future<bool> _isInQuietHours() async {
    // Тихие часы только для PRO
    final isPro = await _isProUser();
    if (!isPro) return false;

    final prefs = await SharedPreferences.getInstance();

    // Проверяем включены ли тихие часы (для PRO включены по умолчанию)
    final quietEnabled = prefs.getBool('quiet_hours_enabled') ?? true;
    if (!quietEnabled) return false;

    // Получаем время начала и конца
    final startStr = prefs.getString('quiet_hours_start') ?? '22:00';
    final endStr   = prefs.getString('quiet_hours_end')   ?? '07:00';

    return _isInQuietHoursAt(DateTime.now(), startStr, endStr);
  }

  bool _isInQuietHoursAt(DateTime dt, String startStr, String endStr) {
    final currentMinutes = dt.hour * 60 + dt.minute;

    final startParts = startStr.split(':');
    final endParts   = endStr.split(':');

    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes   = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    if (startMinutes > endMinutes) {
      // Интервал через полночь
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      // Обычный интервал
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  Future<DateTime> _adjustForQuietHours(DateTime scheduledTime) async {
    if (!await _isInQuietHours()) {
      return scheduledTime;
    }

    final prefs = await SharedPreferences.getInstance();
    final endStr = prefs.getString('quiet_hours_end') ?? '07:00';
    final endParts = endStr.split(':');

    // Переносим на конец тихих часов
    DateTime adjusted = DateTime(
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    // Если это время уже прошло, переносим на завтра
    if (adjusted.isBefore(DateTime.now())) {
      adjusted = adjusted.add(const Duration(days: 1));
    }

    print('🔇 Notification rescheduled from $scheduledTime to $adjusted (quiet hours)');
    return adjusted;
  }

  // ==================== РЕЖИМ ПОСТА ====================

  Future<bool> _isInFastingWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('diet_mode') ?? 'normal';

    if (dietMode != 'fasting') return false;

    // Получаем расписание поста
    final schedule = prefs.getString('fasting_schedule') ?? '16:8';
    final windowStart = prefs.getInt('fasting_window_start') ?? 20; // 20:00
    final windowEnd   = prefs.getInt('fasting_window_end')   ?? 12; // 12:00

    final now = DateTime.now();
    final currentHour = now.hour;

    if (windowStart > windowEnd) {
      // Окно через полночь (например 20:00 - 12:00)
      return currentHour >= windowStart || currentHour < windowEnd;
    } else {
      // Обычное окно
      return currentHour >= windowStart && currentHour < windowEnd;
    }
  }

  Future<bool> _shouldSendQuietFastingReminder() async {
    // В режиме поста отправляем только электролитные напоминания
    final isFasting = await _isInFastingWindow();
    if (!isFasting) return true;

    final prefs = await SharedPreferences.getInstance();
    final quietFasting = prefs.getBool('quiet_fasting_mode') ?? false;

    return !quietFasting; // Если тихий режим - не отправляем
  }

  // ==================== ВСПОМОГАТЕЛЬНЫЙ МЕТОД ДЛЯ ЗАГРУЗКИ ЛОКАЛИ ====================
  
  Future<void> _ensureTextsLoaded() async {
    // Инициализируем тексты и загружаем актуальную локаль
    // Метод initialize() внутри проверяет, были ли тексты уже загружены
    await NotificationTexts.initialize();
    // Дополнительно проверяем актуальность локали на случай смены языка
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
    bool silentIfQuiet = false, // NEW: делать уведомление «тихим» в тихие часы
  }) async {
    // 1. Проверка инициализации
    if (!_isInitialized) {
      await _initializeService();
    }

    // ВАЖНО: Загружаем актуальную локаль перед отправкой
    await _ensureTextsLoaded();

    // Проверка на дубли
    if (!skipChecks && await _isDuplicateNotification(type)) {
      print('🚫 Duplicate notification blocked: $type');
      return;
    }

    // 2. ИСПРАВЛЕНИЕ 1: Проверки только для немедленных уведомлений
    if (scheduledTime == null && !skipChecks) {
      // Проверка лимитов/антиспама
      if (!await _canSendNotification()) {
        print('❌ Cannot send: daily limit or anti-spam');

        await _analytics.logNotificationError(
          type: type.toString(),
          error: 'Daily limit or anti-spam',
        );

        return;
      }

      // PRO жёсткий кап - тоже только для немедленных
      if (await _isProUser()) {
        if (!await _checkProDailyCap()) {
          print('❌ PRO hard cap reached');
          await _analytics.logNotificationError(
            type: type.toString(),
            error: 'PRO hard cap',
          );
          return;
        }
      }

      // Тихие часы/пост - блокируем только немедленную отправку
      if (await _isInQuietHours() && !silentIfQuiet) {
        print('🔇 Cannot send: quiet hours active');
        return;
      }
      if (!await _shouldSendQuietFastingReminder()) {
        print('🥗 Cannot send: quiet fasting mode');
        return;
      }
    }

    // Отменяем старое уведомление только для singleton типов
    if (singletonTypes.contains(type)) {
      await _cancelOldNotificationOfType(type);
    }

    // 3. Корректировка времени для запланированных
    if (scheduledTime != null) {
      // Проверка на прошедшее время
      if (scheduledTime.isBefore(DateTime.now())) {
        print('⚠️ Scheduled time in the past, sending immediately');
        scheduledTime = null;
      } else if (!skipChecks) {
        // Корректировка для тихих часов (если не просили «тихо»)
        if (!silentIfQuiet) {
          scheduledTime = await _adjustForQuietHours(scheduledTime);
        }
      }
    }

    // 4. Выбор канала и приоритета (и «тихости» при нужде)
    // Получаем текущий язык для языкозависимых ID каналов
    final currentLocale = NotificationTexts.currentLocale;
    String channelId = 'hydracoach_default_$currentLocale';
    Importance importance = Importance.high;
    Priority priority = Priority.high;

    switch (type) {
      case NotificationType.heatWarning:
      case NotificationType.workoutReminder:
        channelId = 'hydracoach_urgent_$currentLocale';
        importance = Importance.max;
        priority = Priority.max;
        break;
      case NotificationType.dailyReport:
        channelId = 'hydracoach_report_$currentLocale';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;
      default:
        break;
    }

    // Определим, будет ли уведомление «тихим» (для iOS/Android)
    bool quietForThis = false;
    if (silentIfQuiet) {
      if (scheduledTime != null) {
        final prefs = await SharedPreferences.getInstance();
        final startStr = prefs.getString('quiet_hours_start') ?? '22:00';
        final endStr   = prefs.getString('quiet_hours_end')   ?? '07:00';
        quietForThis = _isInQuietHoursAt(scheduledTime, startStr, endStr) && await _isProUser();
      } else {
        quietForThis = await _isInQuietHours();
      }
    }
    if (quietForThis) {
      channelId = 'hydracoach_silent_$currentLocale'; // Android: переводим на тихий канал
      importance = Importance.low;
      priority = Priority.low;
    }

    // 5. Создание уведомления
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
      presentSound: !quietForThis, // iOS: «тихо» = без звука
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 6. Генерация уникального ID
    final notificationId = _generateNotificationId(type, when: scheduledTime);

    // Сохраняем ID для отмены в будущем (для singleton типов)
    if (singletonTypes.contains(type)) {
      _lastNotificationIds[type] = notificationId;
    }

    // Добавляем тип в payload для аналитики
    final mergedPayload = {'type': type.name, ...?payload};
    final payloadStr = jsonEncode(mergedPayload);

    // 7. Отправка или планирование
    try {
      if (scheduledTime == null) {
        // Немедленная отправка
        await _localNotifications.show(
          notificationId,
          title,
          body,
          details,
          payload: payloadStr,
        );

        // Обновляем счетчики и время
        await _incrementNotificationCount();
        await _saveLastNotificationTime();
        await _incrementProCountIfNeeded();

        // Сохраняем время последнего уведомления этого типа
        _lastNotificationTime[type] = DateTime.now();
        if (type == NotificationType.postCoffee) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(
            'last_coffee_notification_time',
            DateTime.now().millisecondsSinceEpoch,
          );
        }

        print('📬 Notification sent: $title');

        await _analytics.logNotificationSent(
          type: type.toString(),
          isScheduled: false,
        );
      } else {
        // Запланированная отправка
        final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

        await _localNotifications.zonedSchedule(
          notificationId,
          title,
          body,
          tzScheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payloadStr,
        );

        // Добавляем в список запланированных
        _pendingNotificationIds.add(notificationId);

        print('📅 Notification scheduled for $scheduledTime: $title');

        await _analytics.logNotificationScheduled(
          type: type.toString(),
          scheduledTime: scheduledTime,
          delayMinutes: scheduledTime.difference(DateTime.now()).inMinutes,
        );
      }

      // 8. Сохраняем в историю
      await _saveNotificationToHistory(type, title, body, scheduledTime);
    } catch (e) {
      print('❌ Error sending notification: $e');

      await _analytics.logNotificationError(
        type: type.toString(),
        error: e.toString(),
      );
    }
  }

  int _dayOfYear(DateTime d) {
    final start = DateTime(d.year, 1, 1);
    return d.difference(start).inDays + 1;
  }

  int _generateNotificationId(NotificationType type, {DateTime? when}) {
    // Уникален в рамках типа + минуты в дне + день года
    final t = when ?? DateTime.now();
    final day = _dayOfYear(t);           // 1..366
    final mod = (day * 1440 + t.hour * 60 + t.minute) % 1000; // 0..999
    return type.index * 1000 + mod;
  }

  // ==================== СПЕЦИФИЧНЫЕ УВЕДОМЛЕНИЯ ====================

  // Напоминание после кофе (FREE)
  Future<void> schedulePostCoffeeReminder() async {
    // ВАЖНО: Загружаем актуальную локаль
    await _ensureTextsLoaded();
    
    // Проверка на дубль
    if (await _isDuplicateNotification(NotificationType.postCoffee)) {
      print('☕ Coffee reminder already scheduled recently');
      return;
    }

    final delay = _remoteConfig.getInt('post_coffee_delay_minutes');
    final delayMinutes = delay > 0 ? delay : 45; // 45 минут по умолчанию

    final scheduledTime = DateTime.now().add(Duration(minutes: delayMinutes));

    await sendNotification(
      type: NotificationType.postCoffee,
      title: NotificationTexts.postCoffeeTitle,
      body: NotificationTexts.postCoffeeBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'add_water', 'amount': 250},
    );
  }

  // Контр-напоминание после алкоголя (FREE)
  Future<void> scheduleAlcoholCounterReminder(int standardDrinks) async {
    // Загружаем актуальную локаль
    await _ensureTextsLoaded();
    
    // Базовое напоминание через 30 минут
    final scheduledTime = DateTime.now().add(const Duration(minutes: 30));

    final waterAmount = standardDrinks * 150; // 150 мл на стандартный дринк

    await sendNotification(
      type: NotificationType.alcoholCounter,
      title: NotificationTexts.alcoholCounterTitle,
      body: NotificationTexts.alcoholCounterBody(waterAmount),
      scheduledTime: scheduledTime,
      payload: {'action': 'alcohol_recovery', 'water': waterAmount},
    );

    // Если PRO - добавляем расширенный план
    if (await _isProUser()) {
      await _scheduleAlcoholRecoveryPlan(standardDrinks);
    }
  }

  // План восстановления после алкоголя (PRO)
  Future<void> _scheduleAlcoholRecoveryPlan(int standardDrinks) async {
    // Загружаем актуальную локаль
    await _ensureTextsLoaded();
    
    final recoveryHours = standardDrinks <= 2 ? 6 : 12;
    final now = DateTime.now();

    // Напоминания каждые 2 часа
    for (int hour = 2; hour <= recoveryHours; hour += 2) {
      final scheduledTime = now.add(Duration(hours: hour));
      final waterAmount = 300 + (standardDrinks * 50);

      final withElectrolytes = hour == recoveryHours ~/ 2;

      await sendNotification(
        type: NotificationType.alcoholRecovery,
        title: NotificationTexts.alcoholRecoveryStepTitle(hour),
        body: NotificationTexts.alcoholRecoveryStepBody(waterAmount, withElectrolytes),
        scheduledTime: scheduledTime,
        payload: {'action': 'recovery_step', 'hour': hour},
        skipChecks: true,       // важные шаги не блокируем антиспамом
        silentIfQuiet: true,    // НО ночью — без звука
      );
    }

    // Утренний чек-ин
    await scheduleMorningCheckIn();
  }

  // Утренний чек-ин (PRO) - в 07:05
  Future<void> scheduleMorningCheckIn() async {
    // Загружаем актуальную локаль
    await _ensureTextsLoaded();
    
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day + 1, 7, 5); // 07:05

    await sendNotification(
      type: NotificationType.morningCheckIn,
      title: NotificationTexts.morningCheckInTitle,
      body: NotificationTexts.morningCheckInBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'morning_checkin'},
    );
  }

  // Предупреждение о жаре (PRO)
  Future<void> sendHeatWarning(double heatIndex) async {
    if (!await _isProUser()) {
      print('⚠️ Heat warnings - PRO feature');
      return;
    }

    // Загружаем актуальную локаль
    await _ensureTextsLoaded();

    await sendNotification(
      type: NotificationType.heatWarning,
      title: NotificationTexts.heatWarningTitle,
      body: NotificationTexts.heatWarningBody(heatIndex),
      payload: {'action': 'heat_warning', 'heat_index': heatIndex},
      skipChecks: true, // Важное предупреждение
    );
  }

  // Напоминание после тренировки (PRO) - только POST-workout
  Future<void> sendWorkoutReminder({DateTime? workoutEndTime}) async {
    if (!await _isProUser()) {
      print('⚠️ Workout reminders - PRO feature');
      return;
    }

    if (workoutEndTime == null) {
      print('⚠️ No workout end time provided');
      return;
    }

    // Загружаем актуальную локаль
    await _ensureTextsLoaded();

    // Напоминание через 30 минут после окончания тренировки
    final postWorkout = workoutEndTime.add(const Duration(minutes: 30));

    // Если время уже прошло - не планируем
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
      // По умолчанию уважает тихие часы (переносит), тут «тихо» не требуется
    );
  }

  // Вечерний отчет (FREE)
  Future<void> scheduleEveningReport() async {
    // Загружаем актуальную локаль
    await _ensureTextsLoaded();
    
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    // Время отчета из настроек или 21:00 по умолчанию
    final reportTime = prefs.getString('evening_report_time') ?? '21:00';
    final timeParts = reportTime.split(':');

    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    // Если время уже прошло, планируем на завтра
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

  // ==================== УМНЫЕ НАПОМИНАНИЯ (PRO) ====================

  Future<void> scheduleSmartReminders() async {
    print('🧠 Scheduling smart reminders...');

    // Загружаем актуальную локаль
    await _ensureTextsLoaded();

    // Отменяем только базовые напоминания (не трогаем recovery и отчеты)
    await cancelByTypes({
      NotificationType.waterReminder,
      NotificationType.fastingElectrolyte,
      NotificationType.smartReminder,
    });

    final isPro = await _isProUser();

    // Базовые напоминания для всех (вода — если НЕ пост)
    await _scheduleBasicReminders();

    // PRO функции
    if (isPro) {
      await _scheduleContextualReminders();
      await _scheduleFastingReminders();
    }

    // Вечерний отчет для всех
    await scheduleEveningReport();

    print('✅ Smart reminders scheduled');
  }

  Future<void> _scheduleBasicReminders() async {
    final now = DateTime.now();

    // В окне поста воду НЕ планируем (только электролиты отдельной функцией)
    if (await _isInFastingWindow()) {
      return;
    }

    // ИСПРАВЛЕНИЕ 3: Получаем проценты напрямую, без деления
    final waterProgressPercent = await WaterProgressCache.readPercent();

    // ИСПРАВЛЕНИЕ 4: Базовые времена с переносом прошедших на завтра
    final List<List<int>> hmList = [
      [9, 30],
      [12, 30],
      [15, 30],
      [18, 30],
    ];
    
    final reminderTimes = <DateTime>[];
    for (final hm in hmList) {
      DateTime time = DateTime(now.year, now.month, now.day, hm[0], hm[1]);
      
      if (time.isBefore(now.subtract(const Duration(hours: 1)))) {
        // Прошло больше часа назад - переносим на завтра
        time = time.add(const Duration(days: 1));
      } else if (time.isBefore(now)) {
        // Прошло меньше часа назад - откладываем на час от текущего
        time = now.add(const Duration(hours: 1));
      }
      
      reminderTimes.add(time);
    }

    for (final time in reminderTimes) {
      final title = NotificationTexts.waterReminderTitle;
      // Передаем проценты напрямую, без деления на 100
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

    // Контекст
    final hasWorkoutToday = prefs.getBool('has_workout_today') ?? false;
    final heatIndex = prefs.getDouble('heat_index') ?? 20;

    // Напоминание при жаре
    if (heatIndex > 27) {
      await sendHeatWarning(heatIndex);
    }

    // ТРЕНИРОВКА: только пост-тренировочный пуш (если знаем время окончания)
    if (hasWorkoutToday) {
      final workoutTimeStr = prefs.getString('workout_time'); // 'HH:mm'
      final durationMin = prefs.getInt('workout_duration_minutes') ?? 60;

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
    if (!await _isInFastingWindow()) return;

    final now = DateTime.now();

    // В окно поста - только электролиты
    final electrolyteTimes = [
      DateTime(now.year, now.month, now.day, 10, 0),
      DateTime(now.year, now.month, now.day, 14, 0),
      DateTime(now.year, now.month, now.day, 18, 0),
    ];

    for (final time in electrolyteTimes) {
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

  // Отмена по типам (для селективной очистки)
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
    final todayCount = prefs.getInt('notification_count_today') ?? 0;
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

    // Логируем открытие в аналитику
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

      // Здесь можно добавить навигацию или другие действия
      switch (action) {
        case 'add_water':
          // Открыть экран добавления воды
          break;
        case 'show_report':
          // Открыть отчет
          break;
        case 'morning_checkin':
          // Открыть чек-ин
          break;
        default:
          // Открыть главный экран
          break;
      }
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
        skipChecks: true, // FCM сообщения важные
      );
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    print('📱 FCM notification opened');
    _processNotificationAction(jsonEncode(message.data));
  }

  Future<void> _saveFCMToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);

    // Сохраняем в Firestore если пользователь авторизован
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fcm_token': token,
        'platform': Platform.operatingSystem,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    // Подписка на топики
    await _messaging.subscribeToTopic('all_users');

    final dietMode = prefs.getString('diet_mode') ?? 'normal';
    await _messaging.subscribeToTopic('${dietMode}_users');
  }

  Future<void> _saveNotificationToHistory(
    NotificationType type,
    String title,
    String body,
    DateTime? scheduledTime,
  ) async {
    // Сохраняем историю для аналитики
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
    // Загружаем актуальную локаль
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
    // Загружаем актуальную локаль
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
      
      // 5. ВАЖНО: Сохраняем данные событийных уведомлений для перепланирования
      final List<Map<String, dynamic>> eventNotificationsToReschedule = [];
      
      // Правильные индексы типов уведомлений
      final eventTypes = {
        1,  // postCoffee - после кофе
        3,  // alcoholCounter - после алкоголя
        6,  // workoutReminder - после тренировки
        8,  // alcoholRecovery - план восстановления
        9,  // morningCheckIn - утренний чек-ин
      };
      
      // Извлекаем данные событийных уведомлений для перепланирования
      for (final notification in pendingBefore) {
        // Определяем тип уведомления и время
        int typeIdx;
        int hour;
        int minute;
        
        // Специальная логика для разных схем ID
        if (notification.id >= 60000 && notification.id < 70000) {
          // Workout notification с новой схемой: 6HHMM
          typeIdx = 6;
          hour = ((notification.id - 60000) ~/ 100) % 100;
          minute = (notification.id - 60000) % 100;
        } else if (notification.id >= 10000) {
          // Новая схема для всех типов: THHMM (например, 31955 = тип 3, 19:55)
          typeIdx = notification.id ~/ 10000;
          hour = ((notification.id % 10000) ~/ 100);
          minute = notification.id % 100;
        } else {
          // Старая схема: TXXX где T - тип, XXX - минуты от начала дня % 1000
          typeIdx = notification.id ~/ 1000;
          final minutesFromMidnight = notification.id % 1000;
          
          // Проверяем, нужна ли коррекция для времени после 16:40
          final now = DateTime.now();
          
          // Для событийных уведомлений (кофе, алкоголь, тренировка)
          if (eventTypes.contains(typeIdx)) {
            // Если ID < 440 (7:20) но сейчас вечер, вероятно это время после 16:40
            if (minutesFromMidnight < 440 && now.hour >= 16) {
              // Добавляем 1000 минут для получения вечернего времени
              final adjustedMinutes = minutesFromMidnight + 1000;
              hour = adjustedMinutes ~/ 60;
              minute = adjustedMinutes % 60;
            } else {
              hour = minutesFromMidnight ~/ 60;
              minute = minutesFromMidnight % 60;
            }
          } else {
            // Для базовых уведомлений стандартная логика
            hour = minutesFromMidnight ~/ 60;
            minute = minutesFromMidnight % 60;
          }
        }
        
        if (eventTypes.contains(typeIdx)) {
          // Определяем время срабатывания
          final now = DateTime.now();
          DateTime scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );
          
          // Если время уже прошло сегодня, планируем на завтра
          if (scheduledTime.isBefore(now)) {
            scheduledTime = scheduledTime.add(const Duration(days: 1));
          }
          
          // Для утреннего чек-ина (тип 9) - особая логика
          if (typeIdx == 9) {
            final checkInHour = (notification.id ~/ 100) % 100;
            final checkInMinute = notification.id % 100;
            // Утренний чек-ин всегда на завтра
            final tomorrow = now.add(const Duration(days: 1));
            scheduledTime = DateTime(
              tomorrow.year,
              tomorrow.month,
              tomorrow.day,
              checkInHour,
              checkInMinute,
            );
          }
          
          eventNotificationsToReschedule.add({
            'type': NotificationType.values[typeIdx],
            'typeIdx': typeIdx,
            'id': notification.id,
            'scheduledTime': scheduledTime,
            'payload': notification.payload,
            'originalTitle': notification.title, // Сохраняем для извлечения часа recovery
            'originalBody': notification.body,
          });
          
          print('💾 Will reschedule event notification: Type=${NotificationType.values[typeIdx]} (ID: ${notification.id}) at ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
        }
      }
      
      // 6. Отменяем ВСЕ уведомления для полного обновления
      print('🗑️ Cancelling all notifications for complete refresh...');
      
      // Отменяем все типы уведомлений
      final allTypes = {
        NotificationType.waterReminder,
        NotificationType.dailyReport,
        NotificationType.smartReminder,
        NotificationType.heatWarning,
        NotificationType.fastingElectrolyte,
        NotificationType.postCoffee,
        NotificationType.alcoholCounter,
        NotificationType.alcoholRecovery,
        NotificationType.workoutReminder,
        NotificationType.morningCheckIn,
      };
      
      await cancelByTypes(allTypes);
      
      // 7. Проверяем настройки пользователя
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      
      if (!notificationsEnabled) {
        print('⚠️ Notifications are disabled, skipping rescheduling');
        return;
      }
      
      // 8. Перепланируем базовые уведомления с новыми текстами
      print('📅 Rescheduling baseline notifications with new locale...');
      
      // Загружаем актуальные тексты
      await NotificationTexts.ensureLoaded();
      
      // Планируем базовые напоминания (вода, электролиты, отчет)
      await scheduleSmartReminders();
      
      // 9. Перепланируем событийные уведомления с новыми текстами
      print('📅 Rescheduling event notifications with new locale...');
      
      for (final eventData in eventNotificationsToReschedule) {
        final type = eventData['type'] as NotificationType;
        final scheduledTime = eventData['scheduledTime'] as DateTime;
        
        // Перепланируем каждое событийное уведомление с новыми текстами
        switch (type) {
          case NotificationType.postCoffee:
            await sendNotification(
              type: NotificationType.postCoffee,
              title: NotificationTexts.postCoffeeTitle,
              body: NotificationTexts.postCoffeeBody,
              scheduledTime: scheduledTime,
              payload: {'action': 'add_water', 'amount': 250},
            );
            break;
            
          case NotificationType.alcoholCounter:
            // Восстанавливаем с базовым количеством
            await sendNotification(
              type: NotificationType.alcoholCounter,
              title: NotificationTexts.alcoholCounterTitle,
              body: NotificationTexts.alcoholCounterBody(150), // Базовое значение
              scheduledTime: scheduledTime,
              payload: {'action': 'alcohol_recovery', 'water': 150},
            );
            break;
            
          case NotificationType.alcoholRecovery:
            // ИСПРАВЛЕНО: Извлекаем час из оригинального заголовка
            int recoveryHour = 2; // Значение по умолчанию
            
            // Ищем час в оригинальном заголовке (например "💧 Recovery 2h" или "💧 Восстановление 2ч")
            final originalTitle = eventData['originalTitle'] as String?;
            if (originalTitle != null) {
              final hourMatch = RegExp(r'(\d+)[hч]').firstMatch(originalTitle);
              if (hourMatch != null) {
                recoveryHour = int.tryParse(hourMatch.group(1) ?? '') ?? 2;
              }
            }
            
            // Стандартные параметры восстановления
            final waterAmount = 350;
            final withElectrolytes = recoveryHour % 3 == 0; // Электролиты каждые 3 часа
            
            await sendNotification(
              type: NotificationType.alcoholRecovery,
              title: NotificationTexts.alcoholRecoveryStepTitle(recoveryHour),
              body: NotificationTexts.alcoholRecoveryStepBody(waterAmount, withElectrolytes),
              scheduledTime: scheduledTime,
              payload: {'action': 'recovery_step', 'hour': recoveryHour},
              skipChecks: true,
              silentIfQuiet: true,
            );
            break;
            
          case NotificationType.workoutReminder:
            await sendNotification(
              type: NotificationType.workoutReminder,
              title: NotificationTexts.postWorkoutTitle,
              body: NotificationTexts.postWorkoutBody,
              scheduledTime: scheduledTime,
              payload: {'action': 'post_workout'},
            );
            break;
            
          case NotificationType.morningCheckIn:
            await sendNotification(
              type: NotificationType.morningCheckIn,
              title: NotificationTexts.morningCheckInTitle,
              body: NotificationTexts.morningCheckInBody,
              scheduledTime: scheduledTime,
              payload: {'action': 'morning_checkin'},
            );
            break;
            
          default:
            break;
        }
      }
      
      // 10. Проверяем результат
      final pendingAfter = await getPendingNotifications();
      print('✅ Locale change complete:');
      print('   - Event notifications rescheduled: ${eventNotificationsToReschedule.length}');
      print('   - Total notifications after: ${pendingAfter.length}');
      
      // Выводим примеры для проверки
      if (pendingAfter.isNotEmpty) {
        print('📬 Sample notifications after locale change:');
        for (var i = 0; i < (pendingAfter.length > 3 ? 3 : pendingAfter.length); i++) {
          final notification = pendingAfter[i];
          final typeIdx = notification.id ~/ 1000;
          print('   ${i+1}. Type: ${typeIdx < NotificationType.values.length ? NotificationType.values[typeIdx].name : "unknown"}');
          print('      Title: ${notification.title}');
        }
      }
      
      // 11. Логируем в аналитику
      await _analytics.logSettingsChanged(
        setting: 'notification_locale',
        value: localeCode,
      );
      
      print('📊 Analytics: locale changed to $localeCode');
      print('   - All notifications rescheduled with new texts');
      print('   - Event notifications: ${eventNotificationsToReschedule.length}');
      
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