// lib/services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
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

  // ==================== ИНИЦИАЛИЗАЦИЯ ====================
  
  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeLocalNotifications();
    await service._initializeFirebaseMessaging();
    await service._initializeTimezone();
    
    print('✅ NotificationService инициализирован');
  }

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    // Устанавливаем локальную временную зону
    tz.setLocalLocation(tz.getLocation('Europe/Moscow')); // Измените на вашу зону
  }

  Future<void> _initializeLocalNotifications() async {
    // Настройки для Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Настройки для iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );
    
    // Создаем Android канал для уведомлений
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }
    
    print('✅ Локальные уведомления инициализированы');
  }

  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
    
    print('📱 Разрешения уведомлений: ${settings.authorizationStatus}');
    
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
        // Логика для напоминания о воде
        print('Action: Выпить воду');
        break;
      case 'add_electrolytes':
        // Логика для электролитов
        print('Action: Добавить электролиты');
        break;
      case 'daily_report':
        // Открыть дневной отчет
        print('Action: Показать отчет');
        break;
      default:
        print('Action: ${action ?? "неизвестно"}');
    }
  }

  // ==================== ЛОКАЛЬНЫЕ УВЕДОМЛЕНИЯ ====================
  
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    DateTime? scheduledTime,
  }) async {
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
      sound: 'default',
      badgeNumber: 1,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    if (scheduledTime != null) {
      // Планируем уведомление
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      print('⏰ Уведомление запланировано на $scheduledTime');
    } else {
      // Показываем сразу
      await _localNotifications.show(id, title, body, details, payload: payload);
      print('📬 Уведомление показано: $title');
    }
  }

  // ==================== УМНЫЕ НАПОМИНАНИЯ ====================
  
  Future<void> scheduleSmartReminders() async {
    print('🧠 Планирование умных напоминаний...');
    
    // Отменяем старые напоминания
    await cancelAllNotifications();
    
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('dietMode') ?? 'normal';
    // Убираем неиспользуемую переменную activityLevel
    
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

  // ==================== СПЕЦИАЛЬНЫЕ НАПОМИНАНИЯ ====================
  
  Future<void> schedulePostCoffeeReminder() async {
    final reminderTime = DateTime.now().add(const Duration(minutes: 20));
    
    await showNotification(
      id: Random().nextInt(1000),
      title: '☕ После кофе',
      body: 'Выпейте 250-300 мл воды для восстановления баланса',
      scheduledTime: reminderTime,
      payload: 'post_coffee',
    );
    
    print('☕ Напоминание после кофе запланировано');
  }

  Future<void> schedulePostWorkoutReminder() async {
    final reminderTime = DateTime.now().add(const Duration(minutes: 30));
    
    await showNotification(
      id: Random().nextInt(1000),
      title: '💪 После тренировки',
      body: 'Восстановите электролиты: 500 мл воды + щепотка соли',
      scheduledTime: reminderTime,
      payload: 'post_workout',
    );
    
    print('💪 Напоминание после тренировки запланировано');
  }

  Future<void> sendHeatWarning(double heatIndex) async {
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
      title: '🌡️ Погодное предупреждение',
      body: message,
      payload: 'heat_warning',
    );
  }

  // ==================== УПРАВЛЕНИЕ УВЕДОМЛЕНИЯМИ ====================
  
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
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
    
    // Перезапускаем напоминания если включены
    if (settings.enabled) {
      await NotificationService().scheduleSmartReminders();
    } else {
      await NotificationService().cancelAllNotifications();
    }
    
    print('✅ Настройки напоминаний сохранены');
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
        // Открыть главный экран
        print('Открыть главный экран');
        break;
      case 'post_coffee':
        // Добавить воду
        print('Добавить воду после кофе');
        break;
      case 'post_workout':
        // Добавить электролиты
        print('Добавить электролиты после тренировки');
        break;
      case 'daily_report':
        // Показать отчет
        print('Показать дневной отчет');
        break;
      case 'heat_warning':
        // Показать рекомендации
        print('Показать рекомендации для жары');
        break;
    }
  }

  // ==================== ТЕСТИРОВАНИЕ ====================
  
  Future<void> sendTestNotification() async {
    await showNotification(
      id: 999,
      title: '🧪 Тест уведомления',
      body: 'Если вы видите это - уведомления работают правильно!',
      payload: 'test',
    );
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
  
  ReminderSettings({
    required this.enabled,
    required this.frequency,
    required this.morningTime,
    required this.eveningTime,
    required this.postCoffee,
    required this.heatWarnings,
  });
}