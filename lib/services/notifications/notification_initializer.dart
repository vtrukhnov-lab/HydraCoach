// lib/services/notifications/notification_initializer.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'notification_config.dart';
import '../notification_texts.dart';
import 'helpers/timezone_helper.dart';
import 'helpers/notification_limits_helper.dart';

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

  /// Полная инициализация системы уведомлений
  Future<void> initialize() async {
    print('🚀 Initializing notification system...');

    try {
      // 1. Инициализация временных зон
      await _initializeTimezone();

      // 2. Загрузка текстов уведомлений
      await _initializeTexts();

      // 3. Настройка локальных уведомлений
      await _initializeLocalNotifications();

      // 4. Настройка Firebase Messaging
      await _initializeFirebaseMessaging();

      // 5. Загрузка Remote Config
      await _initializeRemoteConfig();

      // 6. Запрос разрешений
      await _requestPermissions();

      print('✅ Notification system initialized successfully');

    } catch (e) {
      print('❌ Critical error during initialization: $e');
      rethrow;
    }
  }

  /// Инициализация временных зон
  Future<void> _initializeTimezone() async {
    print('🌍 Initializing timezone...');
    await TimezoneHelper.initialize();
  }

  /// Инициализация текстов уведомлений
  Future<void> _initializeTexts() async {
    print('📝 Initializing notification texts...');
    await NotificationTexts.initialize();
    await NotificationTexts.loadLocale();
  }

  /// Инициализация локальных уведомлений
  Future<void> _initializeLocalNotifications() async {
    print('📱 Initializing local notifications...');

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

    // Создание каналов для Android
    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }
  }

  /// Создание каналов Android с локализованными названиями
  Future<void> _createAndroidChannels() async {
    print('🔧 Creating Android notification channels...');

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      print('⚠️ Android plugin not available');
      return;
    }

    final currentLocale = NotificationTexts.currentLocale;
    
    // Генерация ID каналов с учетом локали
    final defaultChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.defaultChannelSuffix}_$currentLocale';
    final urgentChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.urgentChannelSuffix}_$currentLocale';
    final reportChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.reportChannelSuffix}_$currentLocale';
    final silentChannelId = '${NotificationConfig.channelPrefix}_${NotificationConfig.silentChannelSuffix}_$currentLocale';

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

    print('✅ Created Android channels for locale: $currentLocale');
  }

  /// Инициализация Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    print('🔥 Initializing Firebase Messaging...');

    // Получение и сохранение FCM токена
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMTokenToPrefs(token);
      print('📱 FCM token obtained: ${token.substring(0, 20)}...');
    }

    // Подписка на обновления токена
    _messaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM token refreshed');
      _saveFCMTokenToPrefs(newToken);
    });

    print('✅ Firebase Messaging initialized');
  }

  /// Сохранение FCM токена в SharedPreferences
  Future<void> _saveFCMTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(NotificationConfig.prefFcmToken, token);
  }

  /// Инициализация Remote Config
  Future<void> _initializeRemoteConfig() async {
    print('📡 Initializing Remote Config...');

    try {
      // Настройки Remote Config
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Установка значений по умолчанию
      await _remoteConfig.setDefaults({
        // Задержки уведомлений
        NotificationConfig.rcPostCoffeeDelay: NotificationConfig.postCoffeeDelayMinutes,
        
        // Лимиты FREE пользователей
        NotificationConfig.rcMaxFreeNotifications: NotificationConfig.maxFreeNotificationsDaily,
        NotificationConfig.rcAntiSpamInterval: NotificationConfig.freeAntiSpamMinutes,
        
        // Лимиты PRO пользователей
        NotificationConfig.rcProDailyCap: NotificationConfig.proDailySoftCap,
        NotificationConfig.rcProHardCap: NotificationConfig.proDailyHardCap,

        // Алкоголь
        NotificationConfig.rcStandardDrinkGrams: NotificationConfig.standardDrinkGrams,
        NotificationConfig.rcAlcoholDrinkBonus: NotificationConfig.waterPerStandardDrink,
        NotificationConfig.rcSodiumPerDrink: NotificationConfig.sodiumPerStandardDrink,
        NotificationConfig.rcMagnesiumAfterAlc: 200,
        NotificationConfig.rcAlcoholHriRisk: 5,
        NotificationConfig.rcAlcoholHriCap: 30,
        NotificationConfig.rcAlcoholEveningCutoff: '20:00',
      });

      // Попытка загрузить актуальные значения
      await _remoteConfig.fetchAndActivate();
      print('📡 Remote Config loaded and activated');

    } catch (e) {
      print('⚠️ Remote Config error (using defaults): $e');
    }
  }

  /// Запрос разрешений на уведомления
  Future<void> _requestPermissions() async {
    print('🔐 Requesting notification permissions...');

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

      print('📱 iOS permissions: ${settings.authorizationStatus}');
    }

    // Android разрешения
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Базовые уведомления
        await androidPlugin.requestNotificationsPermission();
        
        // Точные будильники (Android 12+)
        await androidPlugin.requestExactAlarmsPermission();
        
        print('🤖 Android permissions requested');
      }
    }
  }

  /// Очистка и восстановление состояния уведомлений
  Future<Map<String, dynamic>> restoreNotificationState() async {
    print('🔄 Restoring notification state...');

    final pending = await _localNotifications.pendingNotificationRequests();
    final Set<int> pendingIds = pending.map((n) => n.id).toSet();

    // Восстановление времени последнего кофе для защиты от дублей
    final prefs = await SharedPreferences.getInstance();
    DateTime? lastCoffeeTime;
    final lastCoffeeTimeMs = prefs.getInt(NotificationConfig.prefLastCoffeeNotificationTime);
    if (lastCoffeeTimeMs != null) {
      lastCoffeeTime = DateTime.fromMillisecondsSinceEpoch(lastCoffeeTimeMs);
    }

    print('📅 Found ${pending.length} pending notifications');
    if (lastCoffeeTime != null) {
      print('☕ Last coffee notification: $lastCoffeeTime');
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
      'notificationsEnabled': prefs.getBool(NotificationConfig.prefNotificationsEnabled) ?? true,
      'isPro': prefs.getBool(NotificationConfig.prefIsPro) ?? false,
      'quietHoursEnabled': prefs.getBool(NotificationConfig.prefQuietHoursEnabled) ?? true,
      'quietHoursStart': prefs.getString(NotificationConfig.prefQuietHoursStart) ?? NotificationConfig.defaultQuietHoursStart,
      'quietHoursEnd': prefs.getString(NotificationConfig.prefQuietHoursEnd) ?? NotificationConfig.defaultQuietHoursEnd,
      'eveningReportTime': prefs.getString(NotificationConfig.prefEveningReportTime) ?? NotificationConfig.defaultEveningReportTime,
      'dietMode': prefs.getString(NotificationConfig.prefDietMode) ?? 'normal',
      'fastingWindowStart': prefs.getInt(NotificationConfig.prefFastingWindowStart) ?? 20,
      'fastingWindowEnd': prefs.getInt(NotificationConfig.prefFastingWindowEnd) ?? 12,
      'quietFastingMode': prefs.getBool(NotificationConfig.prefQuietFastingMode) ?? false,
      'waterReminderTimes': prefs.getString('water_reminder_times'),
    };
  }

  /// Обновление каналов при смене языка
  Future<void> recreateChannelsForLocale(String localeCode) async {
    if (!Platform.isAndroid) return;

    print('🔧 Recreating Android channels for locale: $localeCode');
    
    // Обновляем тексты
    await NotificationTexts.setLocale(localeCode);
    
    // Пересоздаем каналы
    await _createAndroidChannels();
  }

  /// Проверка доступности разрешений
  Future<Map<String, bool>> checkPermissionStatus() async {
    final result = <String, bool>{};

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        result['notifications'] = await androidPlugin.areNotificationsEnabled() ?? false;
      }
    }

    if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      result['notifications'] = settings.authorizationStatus == AuthorizationStatus.authorized;
      result['badges'] = settings.badge == AppleNotificationSetting.enabled;
      result['sounds'] = settings.sound == AppleNotificationSetting.enabled;
    }

    return result;
  }

  // ==================== ОБРАБОТЧИКИ СОБЫТИЙ ====================

  /// Обработка тапа по уведомлению
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Notification tapped: ${response.payload}');
    // Логику обработки переносим в FCMHandler
  }

  /// Обработка тапа по уведомлению в фоне
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    print('📱 Background notification tapped: ${response.payload}');
    // Логику обработки переносим в FCMHandler
  }
}