// lib/services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static const String channelId = 'hydracoach_notifications';
  static const String channelName = 'HydraCoach Напоминания';
  static const String channelDescription = 'Напоминания о воде и электролитах';
  
  // Флаг для проверки инициализации
  bool _isInitialized = false;

  // ==================== ИНИЦИАЛИЗАЦИЯ ====================
  
  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeLocalNotifications();
    await service._initializeFirebaseMessaging();
    await service._initializeTimezone();
    
    // Запрашиваем разрешения для Android 12+
    await service._requestExactAlarmPermission();
    
    print('✅ NotificationService инициализирован');
  }

  Future<void> _initializeTimezone() async {
    // ВАЖНО: Используем latest_all для полной поддержки timezone
    tz.initializeTimeZones();
    
    // Определяем локальную timezone
    final String timeZoneName = await _getTimeZoneName();
    print('📍 Используем timezone: $timeZoneName');
    
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('⚠️ Не удалось установить timezone $timeZoneName, используем Moscow');
      tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
    }
  }
  
  Future<String> _getTimeZoneName() async {
    // Можно определить автоматически или использовать фиксированную
    // Для России обычно Europe/Moscow
    return 'Europe/Moscow';
  }

  Future<void> _initializeLocalNotifications() async {
    // Настройки для Android с правильной иконкой
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Настройки для iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    
    // Общие настройки
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // Инициализация с callback для обработки нажатий
    final bool? initialized = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );
    
    if (initialized == true) {
      _isInitialized = true;
      print('✅ Локальные уведомления инициализированы');
      
      // Создаем Android каналы для уведомлений
      if (Platform.isAndroid) {
        await _createAndroidNotificationChannels();
      }
      
      // Проверяем pending уведомления
      await checkNotificationStatus();
    } else {
      print('❌ Ошибка инициализации локальных уведомлений');
    }
  }

  Future<void> _createAndroidNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) return;
    
    // Основной канал
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: false,  // Отключаем LED
    );
    
    await androidPlugin.createNotificationChannel(channel);
    
    // Канал для срочных уведомлений
    const urgentChannel = AndroidNotificationChannel(
      'hydracoach_urgent',
      'Срочные напоминания',
      description: 'Важные уведомления о гидратации',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );
    
    await androidPlugin.createNotificationChannel(urgentChannel);
    
    print('📢 Android каналы уведомлений созданы');
  }
  
  // Запрашиваем разрешение на точные алармы для Android 12+
  Future<void> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        // Запрашиваем разрешение на уведомления (Android 13+)
        final notificationGranted = await androidPlugin.requestNotificationsPermission();
        print('🔐 Разрешение на уведомления: $notificationGranted');
        
        // Запрашиваем разрешение на точные алармы (Android 12+)
        final exactAlarmGranted = await androidPlugin.requestExactAlarmsPermission();
        print('🔐 Разрешение на точные алармы: $exactAlarmGranted');
      }
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Запрашиваем разрешения
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('📱 Разрешения FCM: ${settings.authorizationStatus}');
    
    // Получаем и сохраняем FCM токен
    await _saveFCMToken();
    
    // Слушаем обновления токена
    _messaging.onTokenRefresh.listen(_updateFCMToken);
    
    // Обрабатываем foreground сообщения
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Обрабатываем нажатия на уведомления
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
    
    // Проверяем, было ли приложение открыто через уведомление
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }
  }

  // ==================== FCM ТОКЕН ====================
  
  Future<void> _saveFCMToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      
      print('🔑 FCM Token получен: ${token.substring(0, 20)}...');
      
      // Сохраняем локально
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      
      // Сохраняем в Firestore если есть пользователь
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
          'notificationsEnabled': true,
        }, SetOptions(merge: true));
        
        print('✅ FCM Token сохранен в Firestore для пользователя ${user.uid}');
      }
      
      // Подписываемся на топики
      await _subscribeToTopics();
      
    } catch (e) {
      print('❌ Ошибка сохранения FCM токена: $e');
    }
  }

  Future<void> _updateFCMToken(String token) async {
    print('🔄 FCM Token обновлен');
    await _saveFCMToken();
  }

  Future<void> _subscribeToTopics() async {
    // Подписываемся на общие топики
    await _messaging.subscribeToTopic('all_users');
    await _messaging.subscribeToTopic('daily_reminders');
    
    // Подписываемся на топики по настройкам
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('dietMode') ?? 'normal';
    
    if (dietMode == 'keto') {
      await _messaging.subscribeToTopic('keto_users');
    } else if (dietMode == 'fasting') {
      await _messaging.subscribeToTopic('fasting_users');
    }
    
    print('✅ Подписка на топики завершена');
  }

  // ==================== ОБРАБОТКА СООБЩЕНИЙ ====================
  
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground сообщение: ${message.notification?.title}');
    
    // Показываем локальное уведомление
    if (message.notification != null) {
      await showNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'HydraCoach',
        body: message.notification!.body ?? '',
        payload: message.data['action'] ?? 'open_app',
      );
    }
    
    // Обрабатываем данные
    _processMessageData(message.data);
  }

  void _handleNotificationOpen(RemoteMessage message) {
    print('🔔 Уведомление открыто: ${message.messageId}');
    _processMessageData(message.data);
  }

  void _processMessageData(Map<String, dynamic> data) {
    final action = data['action'];
    
    switch (action) {
      case 'drink_water':
        print('Action: Выпить воду');
        break;
      case 'add_electrolytes':
        print('Action: Добавить электролиты');
        break;
      case 'daily_report':
        print('Action: Показать отчет');
        break;
      default:
        print('Action: ${action ?? "unknown"}');
    }
  }
  
  // ==================== PRO ПРОВЕРКИ ====================
  
  // Счетчик уведомлений для FREE пользователей
  Future<int> _getTodayNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDate = prefs.getString('notification_count_reset_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastResetDate != today) {
      // Новый день - сбрасываем счетчик
      await prefs.setInt('daily_notification_count', 0);
      await prefs.setString('notification_count_reset_date', today);
      return 0;
    }
    
    return prefs.getInt('daily_notification_count') ?? 0;
  }
  
  Future<void> _incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await _getTodayNotificationCount();
    await prefs.setInt('daily_notification_count', count + 1);
  }
  
  // Проверка лимита для FREE пользователей
  Future<bool> canSendNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    
    if (isPro) {
      return true; // PRO пользователи без лимитов
    }
    
    final count = await _getTodayNotificationCount();
    return count < 4; // FREE пользователи - максимум 4 уведомления в день
  }
  
  // Проверка доступности PRO функций уведомлений
  Future<bool> hasProFeature(String feature) async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    
    // FREE функции - всегда доступны
    const freeFeatures = ['basic_reminder', 'daily_report'];
    if (freeFeatures.contains(feature)) {
      return true;
    }
    
    // PRO функции - требуют подписку
    return isPro;
  }

  // ==================== ЛОКАЛЬНЫЕ УВЕДОМЛЕНИЯ ====================
  
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    DateTime? scheduledTime,
  }) async {
    // Проверяем лимит для FREE пользователей
    if (!await canSendNotification()) {
      print('⚠️ Достигнут лимит уведомлений (4/день для FREE)');
      return;
    }
    
    // Убеждаемся что сервис инициализирован
    if (!_isInitialized) {
      print('⚠️ NotificationService не инициализирован, инициализируем...');
      await initialize();
    }
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'HydraCoach',
      icon: '@mipmap/ic_launcher',
      color: const Color.fromARGB(255, 33, 150, 243),
      enableVibration: true,
      playSound: true,
      enableLights: false,
      showWhen: true,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'HydraCoach',
      ),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
      autoCancel: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    if (scheduledTime != null) {
      // Проверяем что время в будущем
      if (scheduledTime.isBefore(DateTime.now())) {
        print('⚠️ Время уже прошло, показываем уведомление сразу');
        await _localNotifications.show(id, title, body, details, payload: payload);
        await _incrementNotificationCount();
        return;
      }
      
      try {
        // Конвертируем в TZDateTime правильно
        final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
          scheduledTime,
          tz.local,
        );
        
        print('📅 Планируем уведомление:');
        print('   ID: $id');
        print('   Заголовок: $title');
        print('   Запланировано на: $scheduledTime');
        
        // Планируем уведомление с правильными параметрами
        await _localNotifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
        
        await _incrementNotificationCount();
        print('✅ Уведомление успешно запланировано с ID: $id');
        
      } catch (e, stackTrace) {
        print('❌ Ошибка планирования уведомления: $e');
        print('Stack trace: $stackTrace');
        
        // Если не удалось запланировать, показываем сразу
        print('Показываем уведомление немедленно как fallback');
        await _localNotifications.show(id, title, body, details, payload: payload);
        await _incrementNotificationCount();
      }
    } else {
      // Показываем сразу
      await _localNotifications.show(id, title, body, details, payload: payload);
      await _incrementNotificationCount();
      print('📬 Мгновенное уведомление показано: $title');
    }
  }

  // ==================== УМНЫЕ НАПОМИНАНИЯ ====================
  
  Future<void> scheduleSmartReminders() async {
    print('🧠 Планирование умных напоминаний...');
    
    // Отменяем старые напоминания
    await cancelAllNotifications();
    
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('dietMode') ?? 'normal';
    
    // Получаем текущий прогресс
    final waterProgress = prefs.getDouble('waterProgress') ?? 0;
    
    // Базовые напоминания в течение дня
    final now = DateTime.now();
    final reminders = <DateTime>[];
    
    // Утреннее напоминание (8:00)
    reminders.add(DateTime(now.year, now.month, now.day, 8, 0));
    
    // Дневные напоминания в зависимости от режима
    if (dietMode == 'fasting') {
      // Для голодания - акцент на электролиты
      reminders.add(DateTime(now.year, now.month, now.day, 10, 0)); // Электролиты
      reminders.add(DateTime(now.year, now.month, now.day, 14, 0)); // Вода
      reminders.add(DateTime(now.year, now.month, now.day, 18, 0)); // Электролиты
    } else {
      // Обычный режим - равномерные напоминания
      reminders.add(DateTime(now.year, now.month, now.day, 10, 0));
      reminders.add(DateTime(now.year, now.month, now.day, 12, 30));
      reminders.add(DateTime(now.year, now.month, now.day, 15, 0));
      reminders.add(DateTime(now.year, now.month, now.day, 17, 30));
      reminders.add(DateTime(now.year, now.month, now.day, 20, 0));
    }
    
    // Вечерний отчет (21:00)
    reminders.add(DateTime(now.year, now.month, now.day, 21, 0));
    
    // Планируем напоминания
    int notificationId = 1000;
    for (final reminderTime in reminders) {
      if (reminderTime.isAfter(now)) {
        final title = _getReminderTitle(reminderTime.hour, dietMode);
        final body = _getReminderBody(reminderTime.hour, dietMode, waterProgress);
        
        await showNotification(
          id: notificationId++,
          title: title,
          body: body,
          scheduledTime: reminderTime,
          payload: 'smart_reminder',
        );
      }
    }
    
    print('✅ Запланировано ${notificationId - 1000} напоминаний');
  }

  String _getReminderTitle(int hour, String dietMode) {
    if (hour == 8) return '☀️ Доброе утро!';
    if (hour == 21) return '📊 Дневной отчет';
    if (hour < 12) return '💧 Время пить воду';
    if (hour < 17) return '⚡ Не забудьте про электролиты';
    return '💧 Вечерняя гидратация';
  }

  String _getReminderBody(int hour, String dietMode, double progress) {
    if (hour == 8) {
      return 'Начните день со стакана воды для хорошего самочувствия';
    }
    
    if (hour == 21) {
      return 'Посмотрите, как прошел ваш день гидратации';
    }
    
    if (dietMode == 'fasting' && (hour == 10 || hour == 18)) {
      return 'Время для электролитов: добавьте щепотку соли в воду';
    }
    
    if (progress < 30) {
      return 'Вы выпили только ${progress.toInt()}% от дневной нормы. Время наверстать!';
    }
    
    if (progress < 60) {
      return 'Отличный прогресс! Еще немного для достижения цели';
    }
    
    return 'Поддерживайте водный баланс в течение дня';
  }

  // ==================== PRO НАПОМИНАНИЯ ====================
  
  // Напоминание после кофе (PRO)
  Future<bool> schedulePostCoffeeReminder() async {
    // Проверяем PRO статус
    if (!await hasProFeature('post_coffee_reminder')) {
      print('⚠️ Напоминания после кофе - PRO функция');
      return false;
    }
    
    // Планируем напоминание через 20 минут
    final reminderTime = DateTime.now().add(const Duration(minutes: 20));
    
    await showNotification(
      id: 2000 + Random().nextInt(1000),
      title: '☕ После кофе',
      body: 'Выпейте 250-300 мл воды для восстановления баланса',
      scheduledTime: reminderTime,
      payload: 'post_coffee',
    );
    
    print('☕ PRO: Напоминание после кофе запланировано');
    return true;
  }
  
  // Напоминание после тренировки (базовое)
  Future<void> schedulePostWorkoutReminder() async {
    final reminderTime = DateTime.now().add(const Duration(minutes: 30));
    
    await showNotification(
      id: 3000 + Random().nextInt(1000),
      title: '💪 После тренировки',
      body: 'Восстановите электролиты: 500 мл воды + щепотка соли',
      scheduledTime: reminderTime,
      payload: 'post_workout',
    );
    
    print('💪 Напоминание после тренировки запланировано');
  }
  
  // Напоминание при жаре (PRO)
  Future<bool> sendHeatWarning(double heatIndex) async {
    // Проверяем PRO статус
    if (!await hasProFeature('heat_warnings')) {
      print('⚠️ Предупреждения о жаре - PRO функция');
      return false;
    }
    
    String message;
    if (heatIndex > 40) {
      message = 'Экстремальная жара! Увеличьте потребление воды на 15% и добавьте 1г соли';
    } else if (heatIndex > 32) {
      message = 'Жарко! Пейте на 10% больше воды и не забывайте про электролиты';
    } else {
      message = 'Теплая погода. Следите за гидратацией';
    }
    
    await showNotification(
      id: Random().nextInt(1000),
      title: '🌡️ Погодное предупреждение PRO',
      body: message,
      payload: 'heat_warning',
    );
    
    print('🌡️ PRO: Предупреждение о жаре отправлено');
    return true;
  }
  
  // Напоминание после алкоголя (PRO)
  Future<bool> schedulePostAlcoholReminder() async {
    // Проверяем PRO статус
    if (!await hasProFeature('post_alcohol_reminder')) {
      print('⚠️ Напоминания после алкоголя - PRO функция');
      return false;
    }
    
    // Планируем серию напоминаний для восстановления
    final now = DateTime.now();
    
    // Через 30 минут - первое напоминание
    await showNotification(
      id: 4000 + Random().nextInt(100),
      title: '🍺 Время восстановления',
      body: 'Выпейте 300 мл воды с щепоткой соли для баланса',
      scheduledTime: now.add(const Duration(minutes: 30)),
      payload: 'post_alcohol_1',
    );
    
    // Через 2 часа - второе напоминание
    await showNotification(
      id: 4100 + Random().nextInt(100),
      title: '💧 Продолжайте гидратацию',
      body: 'Еще 500 мл воды помогут восстановиться быстрее',
      scheduledTime: now.add(const Duration(hours: 2)),
      payload: 'post_alcohol_2',
    );
    
    // Утром следующего дня
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 8, 0);
    await showNotification(
      id: 4200 + Random().nextInt(100),
      title: '☀️ Утреннее восстановление',
      body: 'Начните день с 500 мл воды и электролитов',
      scheduledTime: tomorrow,
      payload: 'post_alcohol_morning',
    );
    
    print('🍺 PRO: План восстановления после алкоголя запланирован');
    return true;
  }
  
  // Вечерний отчет (базовый)
  Future<void> scheduleEveningReport() async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 21, 0);
    
    // Если уже после 21:00, планируем на завтра
    if (now.hour >= 21) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    await showNotification(
      id: 999999, // Фиксированный ID для вечернего отчета
      title: '📊 Дневной отчет готов',
      body: 'Посмотрите, как прошел ваш день гидратации',
      scheduledTime: scheduledTime,
      payload: 'evening_report',
    );
    
    print('📊 Вечерний отчет запланирован на ${scheduledTime.day}.${scheduledTime.month} в 21:00');
  }

  // ==================== УПРАВЛЕНИЕ УВЕДОМЛЕНИЯМИ ====================
  
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    print('🚫 Уведомление $id отменено');
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    print('🗑️ Все уведомления отменены');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }
  
  // Статический метод для сохранения настроек
  Future<void> saveSettings(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('remindersEnabled', settings.enabled);
    await prefs.setInt('reminderFrequency', settings.frequency);
    await prefs.setString('morningTime', settings.morningTime);
    await prefs.setString('eveningTime', settings.eveningTime);
    await prefs.setBool('postCoffeeReminder', settings.postCoffee);
    await prefs.setBool('heatWarnings', settings.heatWarnings);
    await prefs.setBool('postAlcoholReminder', settings.postAlcohol);
    
    // Перезапускаем напоминания если включены
    if (settings.enabled) {
      await scheduleSmartReminders();
    } else {
      await cancelAllNotifications();
    }
    
    print('✅ Настройки напоминаний сохранены');
  }
  
  // Получение статистики уведомлений
  Future<Map<String, dynamic>> getNotificationStats() async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    final todayCount = await _getTodayNotificationCount();
    final pending = await getPendingNotifications();
    
    return {
      'is_pro': isPro,
      'today_count': todayCount,
      'daily_limit': isPro ? -1 : 4, // -1 = unlimited
      'remaining_today': isPro ? -1 : (4 - todayCount),
      'pending_notifications': pending.length,
      'features': {
        'basic_reminders': true,
        'post_coffee': isPro,
        'heat_warnings': isPro,
        'post_alcohol': isPro,
        'smart_contextual': isPro,
      }
    };
  }

  // ==================== ОБРАБОТЧИКИ НАЖАТИЙ ====================
  
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Уведомление нажато: ${response.payload}');
    _handleNotificationAction(response.payload);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    print('📱 Background уведомление нажато: ${response.payload}');
    _handleNotificationAction(response.payload);
  }

  static void _handleNotificationAction(String? payload) {
    if (payload == null) return;
    
    switch (payload) {
      case 'smart_reminder':
        print('Открыть главный экран');
        break;
      case 'post_coffee':
        print('Добавить воду после кофе');
        break;
      case 'post_workout':
        print('Добавить электролиты после тренировки');
        break;
      case 'post_alcohol_1':
      case 'post_alcohol_2':
      case 'post_alcohol_morning':
        print('Показать план восстановления после алкоголя');
        break;
      case 'daily_report':
      case 'evening_report':
        print('Показать дневной отчет');
        break;
      case 'heat_warning':
        print('Показать рекомендации для жары');
        break;
      case 'test':
      case 'test_scheduled':
        print('Тестовое уведомление обработано');
        break;
    }
  }

  // ==================== ТЕСТИРОВАНИЕ ====================
  
  // Мгновенное тестовое уведомление
  Future<void> sendTestNotification() async {
    await showNotification(
      id: 999,
      title: '🧪 Тест уведомления',
      body: 'Если вы видите это - мгновенные уведомления работают!',
      payload: 'test',
    );
  }
  
  // Тестовое уведомление через 1 минуту
  Future<void> scheduleTestNotificationIn1Minute() async {
    final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
    
    await showNotification(
      id: 998,
      title: '⏰ Тест планирования (1 мин)',
      body: 'Это уведомление было запланировано 1 минуту назад. Планирование работает!',
      scheduledTime: scheduledTime,
      payload: 'test_scheduled',
    );
    
    print('⏰ Тестовое уведомление запланировано на ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
  }
  
  // Проверка статуса уведомлений
  Future<void> checkNotificationStatus() async {
    final pending = await getPendingNotifications();
    print('');
    print('📋 ===== СТАТУС УВЕДОМЛЕНИЙ =====');
    print('📋 Запланировано уведомлений: ${pending.length}');
    if (pending.isNotEmpty) {
      print('📋 Список:');
      for (var notification in pending) {
        print('   - ID: ${notification.id}');
        print('     Title: ${notification.title}');
        print('     Body: ${notification.body}');
        print('     Payload: ${notification.payload}');
      }
    }
    print('📋 =============================');
    print('');
  }
}

// ==================== КЛАСС ДЛЯ НАСТРОЕК ====================

class ReminderSettings {
  final bool enabled;
  final int frequency;
  final String morningTime;
  final String eveningTime;
  final bool postCoffee;
  final bool heatWarnings;
  final bool postAlcohol;
  
  ReminderSettings({
    required this.enabled,
    required this.frequency,
    required this.morningTime,
    required this.eveningTime,
    required this.postCoffee,
    required this.heatWarnings,
    required this.postAlcohol,
  });
}