// lib/services/notifications/notification_initializer.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:hydracoach/utils/app_logger.dart';

import 'notification_config.dart';
import '../notification_texts.dart';
import 'helpers/timezone_helper.dart';

/// Класс для инициализации всех компонентов системы уведомлений
class NotificationInitializer {
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirebaseMessaging _messaging;
  final FirebaseRemoteConfig _remoteConfig;

  NotificationInitializer(
    this._localNotifications,
    this._messaging,
    this._remoteConfig,
  );

  /// Полная инициализация системы уведомлений БЕЗ запроса разрешений
  Future<void> initialize() async {
    logger.i('🚀 Initializing notification system...');

    try {
      // 1. Инициализация временных зон
      await _initializeTimezone();

      // 2. Загрузка текстов уведомлений
      await _initializeTexts();

      // 3. Настройка локальных уведомлений БЕЗ запроса разрешений
      await _initializeLocalNotifications();

      // 4. Настройка Firebase Messaging БЕЗ запроса разрешений
      await _initializeFirebaseMessaging();

      // 5. Загрузка Remote Config
      await _initializeRemoteConfig();

      // 6. НЕ ЗАПРАШИВАЕМ разрешения автоматически!
      // Разрешения будут запрошены только когда пользователь нажмёт кнопку
      logger.i('✅ Notification system initialized (permissions not requested)');
    } catch (e) {
      logger.i('❌ Critical error during initialization: $e');
      rethrow;
    }
  }

  /// Инициализация временных зон
  Future<void> _initializeTimezone() async {
    logger.i('🌍 Initializing timezone...');
    await TimezoneHelper.initialize();
  }

  /// Инициализация текстов уведомлений
  Future<void> _initializeTexts() async {
    logger.i('📝 Initializing notification texts...');
    await NotificationTexts.initialize();
    await NotificationTexts.loadLocale();
  }

  /// Инициализация локальных уведомлений БЕЗ запроса разрешений
  Future<void> _initializeLocalNotifications() async {
    logger.i(
      '📱 Initializing local notifications (without permission request)...',
    );

    const androidSettings = AndroidInitializationSettings('notification_icon');

    // КРИТИЧНО: Отключаем автоматический запрос разрешений на iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // НЕ запрашиваем автоматически
      requestBadgePermission: false, // НЕ запрашиваем автоматически
      requestSoundPermission: false, // НЕ запрашиваем автоматически
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
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationTapped,
    );

    // Создание каналов для Android
    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }

    logger.i('✅ Local notifications initialized without permission request');
  }

  /// Создание каналов Android с локализованными названиями
  Future<void> _createAndroidChannels() async {
    logger.i('🔧 Creating Android notification channels...');

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      logger.i('⚠️ Android plugin not available');
      return;
    }

    final currentLocale = NotificationTexts.currentLocale;

    // Генерация ID каналов с учетом локали
    final defaultChannelId =
        '${NotificationConfig.channelPrefix}_${NotificationConfig.defaultChannelSuffix}_$currentLocale';
    final urgentChannelId =
        '${NotificationConfig.channelPrefix}_${NotificationConfig.urgentChannelSuffix}_$currentLocale';
    final reportChannelId =
        '${NotificationConfig.channelPrefix}_${NotificationConfig.reportChannelSuffix}_$currentLocale';
    final silentChannelId =
        '${NotificationConfig.channelPrefix}_${NotificationConfig.silentChannelSuffix}_$currentLocale';

    // Канал по умолчанию - гидратация
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        defaultChannelId,
        NotificationTexts.channelNameDefault,
        description: NotificationTexts.channelDescDefault,
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      ),
    );

    // Срочный канал - жара, критичные предупреждения
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        urgentChannelId,
        NotificationTexts.channelNameUrgent,
        description: NotificationTexts.channelDescUrgent,
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      ),
    );

    // Канал отчетов - вечерние отчеты
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        reportChannelId,
        NotificationTexts.channelNameReport,
        description: NotificationTexts.channelDescReport,
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: true,
        showBadge: true,
      ),
    );

    // Тихий канал - тихие часы PRO
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        silentChannelId,
        NotificationTexts.channelNameSilent,
        description: NotificationTexts.channelDescSilent,
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
        showBadge: false,
      ),
    );

    logger.i('✅ Created Android channels for locale: $currentLocale');
  }

  /// Инициализация Firebase Messaging БЕЗ запроса разрешений
  Future<void> _initializeFirebaseMessaging() async {
    logger.i(
      '🔥 Initializing Firebase Messaging (without permission request)...',
    );

    // Получение и сохранение FCM токена (работает без разрешений)
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMTokenToPrefs(token);
      logger.i('📱 FCM token obtained: ${token.substring(0, 20)}...');
    }

    // Подписка на обновления токена
    _messaging.onTokenRefresh.listen((newToken) {
      logger.i('🔄 FCM token refreshed');
      _saveFCMTokenToPrefs(newToken);
    });

    // ВАЖНО: НЕ запрашиваем разрешения здесь!
    // Только проверяем текущий статус без показа диалога
    if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      logger.i(
        '📱 iOS current permission status: ${settings.authorizationStatus}',
      );
    }

    logger.i('✅ Firebase Messaging initialized without permission request');
  }

  /// Сохранение FCM токена в SharedPreferences
  Future<void> _saveFCMTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(NotificationConfig.prefFcmToken, token);
  }

  /// Инициализация Remote Config
  Future<void> _initializeRemoteConfig() async {
    logger.i('📡 Initializing Remote Config...');

    try {
      // Настройки Remote Config
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Установка значений по умолчанию
      await _remoteConfig.setDefaults({
        // Задержки уведомлений
        NotificationConfig.rcPostCoffeeDelay:
            NotificationConfig.postCoffeeDelayMinutes,

        // Лимиты FREE пользователей
        NotificationConfig.rcMaxFreeNotifications:
            NotificationConfig.maxFreeNotificationsDaily,
        NotificationConfig.rcAntiSpamInterval:
            NotificationConfig.freeAntiSpamMinutes,

        // Лимиты PRO пользователей
        NotificationConfig.rcProDailyCap: NotificationConfig.proDailySoftCap,
        NotificationConfig.rcProHardCap: NotificationConfig.proDailyHardCap,

        // Алкоголь
        NotificationConfig.rcStandardDrinkGrams:
            NotificationConfig.standardDrinkGrams,
        NotificationConfig.rcAlcoholDrinkBonus:
            NotificationConfig.waterPerStandardDrink,
        NotificationConfig.rcSodiumPerDrink:
            NotificationConfig.sodiumPerStandardDrink,
        NotificationConfig.rcMagnesiumAfterAlc: 200,
        NotificationConfig.rcAlcoholHriRisk: 5,
        NotificationConfig.rcAlcoholHriCap: 30,
        NotificationConfig.rcAlcoholEveningCutoff: '20:00',
      });

      // Попытка загрузить актуальные значения
      await _remoteConfig.fetchAndActivate();
      logger.i('📡 Remote Config loaded and activated');
    } catch (e) {
      logger.i('⚠️ Remote Config error (using defaults): $e');
    }
  }

  /// НОВЫЙ МЕТОД: Явный запрос разрешений на уведомления
  /// Вызывается ТОЛЬКО когда пользователь нажимает кнопку
  /// Запрашивает базовые разрешения на уведомления
  /// НЕ запрашивает SCHEDULE_EXACT_ALARM для Google Play Store compliance
  Future<void> requestSystemNotificationPermissions({
    bool requestExactAlarms = false,
  }) async {
    logger.i('🔐 Explicitly requesting notification permissions...');

    // iOS разрешения
    if (Platform.isIOS) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      logger.i(
        '📱 iOS permissions (prompted): ${settings.authorizationStatus}',
      );
    }

    // Android разрешения
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        // Базовые уведомления (Android 13+)
        final granted = await androidPlugin.requestNotificationsPermission();
        logger.i(
          '🤖 Android notifications permission: ${granted == true ? "granted" : "denied"}',
        );

        // УДАЛЕНО: Точные будильники (Android 12+)
        // НЕ запрашиваем SCHEDULE_EXACT_ALARM для Google Play Store compliance
        // Используем только AndroidScheduleMode.inexactAllowWhileIdle
        if (requestExactAlarms) {
          logger.i(
            '🤖 Exact alarms не запрашиваются - используем inexact scheduling',
          );
        }

        logger.i('🤖 Android permissions requested (prompted)');
      }
    }
  }

  /// Очистка и восстановление состояния уведомлений
  Future<Map<String, dynamic>> restoreNotificationState() async {
    logger.i('🔄 Restoring notification state...');

    final pending = await _localNotifications.pendingNotificationRequests();
    final Set<int> pendingIds = pending.map((n) => n.id).toSet();

    // Восстановление времени последнего кофе для защиты от дублей
    final prefs = await SharedPreferences.getInstance();
    DateTime? lastCoffeeTime;
    final lastCoffeeTimeMs = prefs.getInt(
      NotificationConfig.prefLastCoffeeNotificationTime,
    );
    if (lastCoffeeTimeMs != null) {
      lastCoffeeTime = DateTime.fromMillisecondsSinceEpoch(lastCoffeeTimeMs);
    }

    logger.i('📅 Found ${pending.length} pending notifications');
    if (lastCoffeeTime != null) {
      logger.i('☕ Last coffee notification: $lastCoffeeTime');
    }

    return {
      'pendingIds': pendingIds,
      'lastCoffeeTime': lastCoffeeTime,
      'pendingCount': pending.length,
    };
  }

  /// Получение настроек пользователя для уведомлений
  Future<Map<String, dynamic>> getUserNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'notificationsEnabled':
          prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true,
      'isPro': prefs.getBool(NotificationConfig.prefIsPro) ?? false,
      'quietHoursEnabled':
          prefs.getBool(NotificationConfig.prefQuietHoursEnabled) ?? true,
      'quietHoursStart':
          prefs.getString(NotificationConfig.prefQuietHoursStart) ??
          NotificationConfig.defaultQuietHoursStart,
      'quietHoursEnd':
          prefs.getString(NotificationConfig.prefQuietHoursEnd) ??
          NotificationConfig.defaultQuietHoursEnd,
      'eveningReportTime':
          prefs.getString(NotificationConfig.prefEveningReportTime) ??
          NotificationConfig.defaultEveningReportTime,
      'dietMode': prefs.getString(NotificationConfig.prefDietMode) ?? 'normal',
      'fastingWindowStart':
          prefs.getInt(NotificationConfig.prefFastingWindowStart) ?? 20,
      'fastingWindowEnd':
          prefs.getInt(NotificationConfig.prefFastingWindowEnd) ?? 12,
      'quietFastingMode':
          prefs.getBool(NotificationConfig.prefQuietFastingMode) ?? false,
      'waterReminderTimes': prefs.getString('water_reminder_times'),
    };
  }

  /// Обновление каналов при смене языка
  Future<void> recreateChannelsForLocale(String localeCode) async {
    if (!Platform.isAndroid) return;

    logger.i('🔧 Recreating Android channels for locale: $localeCode');

    // Обновляем тексты
    await NotificationTexts.setLocale(localeCode);

    // Пересоздаем каналы
    await _createAndroidChannels();
  }

  /// Проверка доступности разрешений БЕЗ запроса
  Future<Map<String, bool>> checkPermissionStatus() async {
    final result = <String, bool>{};

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        result['notifications'] =
            await androidPlugin.areNotificationsEnabled() ?? false;
        // УДАЛЕНО: Проверка exact alarms для Google Play Store compliance
        // Используем только inexact scheduling, поэтому проверка не нужна
        result['exactAlarms'] = false; // Всегда false, так как не используем
      }
    }

    if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      result['notifications'] =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      result['badges'] = settings.badge == AppleNotificationSetting.enabled;
      result['sounds'] = settings.sound == AppleNotificationSetting.enabled;
    }

    return result;
  }

  // ==================== ОБРАБОТЧИКИ СОБЫТИЙ ====================

  /// Обработка тапа по уведомлению
  static void _onNotificationTapped(NotificationResponse response) {
    logger.i('📱 Notification tapped: ${response.payload}');
    // Логику обработки переносим в FCMHandler
  }

  /// Обработка тапа по уведомлению в фоне
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    logger.i('📱 Background notification tapped: ${response.payload}');
    // Логику обработки переносим в FCMHandler
  }
}
