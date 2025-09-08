// lib/services/notification_service_v2.dart

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

// ==================== ТИПЫ УВЕДОМЛЕНИЙ ====================

enum NotificationType {
  // FREE
  waterReminder,        // Базовое напоминание о воде
  postCoffee,          // После кофе (1 раз)
  dailyReport,         // Вечерний отчет
  alcoholCounter,      // Контр-пинг после алкоголя
  
  // PRO
  smartReminder,       // Умное контекстное
  heatWarning,        // Предупреждение о жаре
  workoutReminder,    // Напоминание при тренировке
  fastingElectrolyte, // Электролиты в пост
  alcoholRecovery,    // План восстановления
  morningCheckIn,     // Утренний чек-ин
  
  // SYSTEM
  custom,             // Кастомные уведомления (FCM, тесты и т.д.)
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
  
  // Каналы для Android
  static const String channelIdDefault = 'hydracoach_default';
  static const String channelIdUrgent = 'hydracoach_urgent';
  static const String channelIdReport = 'hydracoach_report';
  
  bool _isInitialized = false;
  
  // Кэш для быстрых проверок
  bool? _cachedProStatus;
  DateTime? _cacheExpiry;
  
  // ==================== ИНИЦИАЛИЗАЦИЯ ====================
  
  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeService();
  }
  
  Future<void> _initializeService() async {
    if (_isInitialized) return;
    
    print('🚀 Initializing NotificationService...');
    
    // 1. Настройка timezone
    await _initializeTimezone();
    
    // 2. Инициализация локальных уведомлений
    await _initializeLocalNotifications();
    
    // 3. Firebase Messaging
    await _initializeFirebaseMessaging();
    
    // 4. Загрузка Remote Config
    await _loadRemoteConfig();
    
    // 5. Запрос разрешений
    await _requestPermissions();
    
    // 6. Восстановление запланированных уведомлений
    await _restoreScheduledNotifications();
    
    _isInitialized = true;
    print('✅ NotificationService initialized successfully');
  }
  
  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    
    // Определяем локальную timezone
    String timeZoneName = 'Europe/Moscow'; // По умолчанию для России
    
    try {
      // Можно определить автоматически через платформенные API
      // Или использовать настройку пользователя
      final prefs = await SharedPreferences.getInstance();
      timeZoneName = prefs.getString('user_timezone') ?? 'Europe/Moscow';
    } catch (e) {
      print('⚠️ Using default timezone');
    }
    
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print('🌍 Timezone set to: $timeZoneName');
    } catch (e) {
      print('⚠️ Failed to set timezone, using Moscow');
      tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
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
    
    // Основной канал
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelIdDefault,
        'Напоминания о гидратации',
        description: 'Напоминания о воде и электролитах',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );
    
    // Срочный канал
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelIdUrgent,
        'Важные уведомления',
        description: 'Предупреждения о жаре и критических состояниях',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      ),
    );
    
    // Канал отчетов
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelIdReport,
        'Отчеты',
        description: 'Дневные и недельные отчеты',
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: true,
      ),
    );
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
        
        // Android 12+ требует разрешение на точные будильники
        await androidPlugin.requestExactAlarmsPermission();
      }
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
  
  Future<bool> _canSendNotification() async {
    final isPro = await _isProUser();
    
    // PRO пользователи - проверяем только анти-спам
    if (isPro) {
      return await _checkAntiSpam();
    }
    
    // FREE пользователи - проверяем дневной лимит
    return await _checkDailyLimit();
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
  
  Future<bool> _checkAntiSpam() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Проверяем включен ли анти-спам
    final antiSpamEnabled = prefs.getBool('anti_spam_enabled') ?? true;
    if (!antiSpamEnabled) return true;
    
    // Проверяем время последнего уведомления
    final lastTime = prefs.getInt('last_notification_time') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Минимальный интервал из Remote Config или 60 минут по умолчанию
    final minInterval = _remoteConfig.getInt('anti_spam_interval_minutes');
    final intervalMs = (minInterval > 0 ? minInterval : 60) * 60 * 1000;
    
    if (now - lastTime < intervalMs) {
      print('⏰ Anti-spam: too soon since last notification');
      return false;
    }
    
    return true;
  }
  
  Future<void> _saveLastNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_notification_time', DateTime.now().millisecondsSinceEpoch);
  }
  
  Future<bool> _isInQuietHours() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Проверяем включены ли тихие часы
    final quietEnabled = prefs.getBool('quiet_hours_enabled') ?? false;
    if (!quietEnabled) return false;
    
    // Получаем время начала и конца
    final startStr = prefs.getString('quiet_hours_start') ?? '22:00';
    final endStr = prefs.getString('quiet_hours_end') ?? '07:00';
    
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    // Парсим время
    final startParts = startStr.split(':');
    final endParts = endStr.split(':');
    
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    
    // Проверяем попадание в интервал
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
    final windowEnd = prefs.getInt('fasting_window_end') ?? 12; // 12:00
    
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
  
  // ==================== ОСНОВНОЙ МЕТОД ОТПРАВКИ ====================
  
  Future<void> sendNotification({
    required NotificationType type,
    required String title,
    required String body,
    DateTime? scheduledTime,
    Map<String, dynamic>? payload,
    bool skipChecks = false,
  }) async {
    // 1. Проверка инициализации
    if (!_isInitialized) {
      await _initializeService();
    }
    
    // 2. Проверки для немедленных уведомлений
    if (scheduledTime == null && !skipChecks) {
      // Проверка лимитов
      if (!await _canSendNotification()) {
        print('❌ Cannot send: daily limit or anti-spam');
        return;
      }
      
      // Проверка тихих часов
      if (await _isInQuietHours()) {
        print('🔇 Cannot send: quiet hours active');
        return;
      }
      
      // Проверка режима поста
      if (!await _shouldSendQuietFastingReminder()) {
        print('🥗 Cannot send: quiet fasting mode');
        return;
      }
    }
    
    // 3. Корректировка времени для запланированных
    if (scheduledTime != null) {
      // Проверка на прошедшее время
      if (scheduledTime.isBefore(DateTime.now())) {
        print('⚠️ Scheduled time in the past, sending immediately');
        scheduledTime = null;
      } else if (!skipChecks) {
        // Корректировка для тихих часов
        scheduledTime = await _adjustForQuietHours(scheduledTime);
      }
    }
    
    // 4. Выбор канала и приоритета
    String channelId = channelIdDefault;
    Importance importance = Importance.high;
    Priority priority = Priority.high;
    
    switch (type) {
      case NotificationType.heatWarning:
      case NotificationType.workoutReminder:
        channelId = channelIdUrgent;
        importance = Importance.max;
        priority = Priority.max;
        break;
      case NotificationType.dailyReport:
        channelId = channelIdReport;
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;
      default:
        // Используем дефолтные значения
        break;
    }
    
    // 5. Создание уведомления
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == channelIdUrgent ? 'Важные уведомления' : 
      channelId == channelIdReport ? 'Отчеты' : 'Напоминания',
      importance: importance,
      priority: priority,
      ticker: 'HydraCoach',
      icon: '@mipmap/ic_launcher',
      color: const Color.fromARGB(255, 33, 150, 243),
      enableVibration: channelId != channelIdReport,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'HydraCoach',
      ),
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // 6. Генерация ID
    final notificationId = _generateNotificationId(type);
    
    // 7. Отправка или планирование
    try {
      if (scheduledTime == null) {
        // Немедленная отправка
        await _localNotifications.show(
          notificationId,
          title,
          body,
          details,
          payload: payload != null ? jsonEncode(payload) : null,
        );
        
        // Обновляем счетчики
        await _incrementNotificationCount();
        await _saveLastNotificationTime();
        
        print('📬 Notification sent: $title');
        
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
          // УБРАЛИ uiLocalNotificationDateInterpretation - он больше не нужен
          payload: payload != null ? jsonEncode(payload) : null,
        );
        
        print('📅 Notification scheduled for $scheduledTime: $title');
      }
      
      // 8. Сохраняем в историю
      await _saveNotificationToHistory(type, title, body, scheduledTime);
      
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }
  
  int _generateNotificationId(NotificationType type) {
    // Генерируем уникальный ID на основе типа и времени
    final baseId = type.index * 1000;
    final random = Random().nextInt(999);
    return baseId + random;
  }
  
  // ==================== СПЕЦИФИЧНЫЕ УВЕДОМЛЕНИЯ ====================
  
  // Напоминание после кофе (FREE)
  Future<void> schedulePostCoffeeReminder() async {
    final delay = _remoteConfig.getInt('post_coffee_delay_minutes');
    final delayMinutes = delay > 0 ? delay : 20;
    
    final scheduledTime = DateTime.now().add(Duration(minutes: delayMinutes));
    
    await sendNotification(
      type: NotificationType.postCoffee,
      title: '☕ После кофе',
      body: 'Выпейте 250-300 мл воды для восстановления баланса',
      scheduledTime: scheduledTime,
      payload: {'action': 'add_water', 'amount': 250},
    );
  }
  
  // Контр-напоминание после алкоголя (FREE)
  Future<void> scheduleAlcoholCounterReminder(int standardDrinks) async {
    // Базовое напоминание через 30 минут
    final scheduledTime = DateTime.now().add(const Duration(minutes: 30));
    
    final waterAmount = standardDrinks * 150; // 150 мл на стандартный дринк
    
    await sendNotification(
      type: NotificationType.alcoholCounter,
      title: '🍺 Время восстановления',
      body: 'Выпейте $waterAmount мл воды с щепоткой соли',
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
    final recoveryHours = standardDrinks <= 2 ? 6 : 12;
    final now = DateTime.now();
    
    // Напоминания каждые 2 часа
    for (int hour = 2; hour <= recoveryHours; hour += 2) {
      final scheduledTime = now.add(Duration(hours: hour));
      final waterAmount = 300 + (standardDrinks * 50);
      
      String title = '💧 Восстановление ${hour}ч';
      String body = 'Выпейте $waterAmount мл воды';
      
      if (hour == recoveryHours ~/ 2) {
        body += ' + электролиты (Na/K/Mg)';
      }
      
      await sendNotification(
        type: NotificationType.alcoholRecovery,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        payload: {'action': 'recovery_step', 'hour': hour},
        skipChecks: true, // Важные уведомления для восстановления
      );
    }
    
    // Утренний чек-ин
    await scheduleMorningCheckIn();
  }
  
  // Утренний чек-ин (PRO)
  Future<void> scheduleMorningCheckIn() async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day + 1, 8, 0);
    
    await sendNotification(
      type: NotificationType.morningCheckIn,
      title: '☀️ Утренний чек-ин',
      body: 'Как самочувствие? Оцените состояние и получите план на день',
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
    
    String body;
    if (heatIndex > 40) {
      body = 'Экстремальная жара! +15% воды и +1г соли';
    } else if (heatIndex > 32) {
      body = 'Жарко! +10% воды и электролиты';
    } else {
      body = 'Тепло. Следите за гидратацией';
    }
    
    await sendNotification(
      type: NotificationType.heatWarning,
      title: '🌡️ Предупреждение о жаре',
      body: body,
      payload: {'action': 'heat_warning', 'heat_index': heatIndex},
      skipChecks: true, // Важное предупреждение
    );
  }
  
  // Напоминание при тренировке (PRO)
  Future<void> sendWorkoutReminder() async {
    if (!await _isProUser()) {
      print('⚠️ Workout reminders - PRO feature');
      return;
    }
    
    await sendNotification(
      type: NotificationType.workoutReminder,
      title: '💪 Тренировка',
      body: 'Не забудьте пить воду и восполнять электролиты',
      payload: {'action': 'workout_hydration'},
    );
    
    // Напоминание после тренировки через 30 минут
    final postWorkout = DateTime.now().add(const Duration(minutes: 30));
    
    await sendNotification(
      type: NotificationType.workoutReminder,
      title: '💪 После тренировки',
      body: '500 мл воды + электролиты для восстановления',
      scheduledTime: postWorkout,
      payload: {'action': 'post_workout'},
    );
  }
  
  // Вечерний отчет (FREE)
  Future<void> scheduleEveningReport() async {
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
      title: '📊 Дневной отчет готов',
      body: 'Посмотрите, как прошел ваш день гидратации',
      scheduledTime: scheduledTime,
      payload: {'action': 'show_report'},
    );
  }
  
  // ==================== УМНЫЕ НАПОМИНАНИЯ (PRO) ====================
  
  Future<void> scheduleSmartReminders() async {
    print('🧠 Scheduling smart reminders...');
    
    // Отменяем старые напоминания
    await cancelAllNotifications();
    
    final prefs = await SharedPreferences.getInstance();
    final isPro = await _isProUser();
    
    // Базовые напоминания для всех
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
    final prefs = await SharedPreferences.getInstance();
    
    // Получаем прогресс
    final waterProgress = prefs.getDouble('water_progress') ?? 0;
    
    // Базовые времена напоминаний
    final reminderTimes = [
      DateTime(now.year, now.month, now.day, 8, 0),   // Утро
      DateTime(now.year, now.month, now.day, 12, 0),  // Обед
      DateTime(now.year, now.month, now.day, 15, 0),  // После обеда
      DateTime(now.year, now.month, now.day, 18, 0),  // Вечер
    ];
    
    for (final time in reminderTimes) {
      if (time.isAfter(now)) {
        String title = '💧 Время гидратации';
        String body = _getSmartReminderBody(time.hour, waterProgress);
        
        await sendNotification(
          type: NotificationType.waterReminder,
          title: title,
          body: body,
          scheduledTime: time,
          payload: {'action': 'drink_water'},
        );
      }
    }
  }
  
  Future<void> _scheduleContextualReminders() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Проверяем контекст
    final hasWorkoutToday = prefs.getBool('has_workout_today') ?? false;
    final currentTemp = prefs.getDouble('current_temperature') ?? 20;
    final heatIndex = prefs.getDouble('heat_index') ?? 20;
    
    // Напоминание при жаре
    if (heatIndex > 27) {
      await sendHeatWarning(heatIndex);
    }
    
    // Напоминание о тренировке
    if (hasWorkoutToday) {
      final workoutTime = prefs.getString('workout_time');
      if (workoutTime != null) {
        // Планируем напоминание перед тренировкой
        await sendWorkoutReminder();
      }
    }
  }
  
  Future<void> _scheduleFastingReminders() async {
    if (!await _isInFastingWindow()) return;
    
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    
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
          title: '⚡ Время электролитов',
          body: 'Добавьте щепотку соли в воду или выпейте бульон',
          scheduledTime: time,
          payload: {'action': 'add_electrolytes'},
        );
      }
    }
  }
  
  String _getSmartReminderBody(int hour, double progress) {
    if (hour == 8) {
      return 'Начните день со стакана воды';
    }
    
    if (progress < 30) {
      return 'Вы выпили только ${progress.toInt()}% нормы. Время наверстать!';
    }
    
    if (progress < 60) {
      return 'Отличный прогресс! Продолжайте';
    }
    
    return 'Поддерживайте водный баланс';
  }
  
  // ==================== УПРАВЛЕНИЕ УВЕДОМЛЕНИЯМИ ====================
  
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    print('🚫 Notification cancelled: $id');
  }
  
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    print('🗑️ All notifications cancelled');
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
    
    print('📋 User status: ${isPro ? "PRO" : "FREE"}');
    print('📋 Today sent: $todayCount${isPro ? "" : "/4"}');
    print('📋 =================================\n');
  }
  
  // ==================== ОБРАБОТЧИКИ ====================
  
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Notification tapped');
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
  
  Future<void> _restoreScheduledNotifications() async {
    // При перезапуске приложения восстанавливаем запланированные уведомления
    final pending = await getPendingNotifications();
    print('📅 Restored ${pending.length} scheduled notifications');
  }
  
  // ==================== ТЕСТИРОВАНИЕ ====================
  
  Future<void> sendTestNotification() async {
    await sendNotification(
      type: NotificationType.custom,
      title: '🧪 Тест уведомления',
      body: 'Если вы видите это - уведомления работают!',
      payload: {'action': 'test'},
      skipChecks: true,
    );
  }
  
  Future<void> scheduleTestIn1Minute() async {
    final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
    
    await sendNotification(
      type: NotificationType.custom,
      title: '⏰ Запланированный тест',
      body: 'Это уведомление было запланировано минуту назад',
      scheduledTime: scheduledTime,
      payload: {'action': 'test_scheduled'},
      skipChecks: true,
    );
  }
}