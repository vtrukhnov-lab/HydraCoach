import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  static Timer? _reminderTimer;
  
  // Инициализация
  static Future<void> initialize() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    
    _initialized = true;
    
    // Запускаем периодические напоминания
    _startPeriodicReminders();
  }
  
  // Обработка нажатия на уведомление
  static void _onNotificationTap(NotificationResponse response) {
    // TODO: Навигация к нужному экрану
    print('Notification tapped: ${response.payload}');
  }
  
  // Показать уведомление
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'hydration_channel',
      'Напоминания о воде',
      channelDescription: 'Напоминания о необходимости пить воду',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      enableLights: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  // Планировать уведомление
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Для Flutter Local Notifications нужно использовать
    // timezone пакет для планирования, пока используем простой таймер
    final delay = scheduledDate.difference(DateTime.now());
    
    if (delay.isNegative) return;
    
    Timer(delay, () {
      showNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
    });
  }
  
  // Периодические напоминания
  static void _startPeriodicReminders() {
    _reminderTimer?.cancel();
    
    // Проверяем каждый час
    _reminderTimer = Timer.periodic(const Duration(hours: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
      
      if (!remindersEnabled) return;
      
      final now = DateTime.now();
      final hour = now.hour;
      
      // Не беспокоим ночью (с 22:00 до 7:00)
      if (hour < 7 || hour >= 22) return;
      
      // Проверяем прогресс
      final waterProgress = prefs.getDouble('waterProgress') ?? 0;
      final expectedProgress = (hour - 7) / 15 * 100; // От 7:00 до 22:00
      
      if (waterProgress < expectedProgress - 20) {
        await showNotification(
          id: hour,
          title: '💧 Пора пить воду!',
          body: 'Вы выпили только ${waterProgress.toInt()}% от дневной нормы',
          payload: 'water_reminder',
        );
      }
    });
  }
  
  // Напоминание после кофе
  static Future<void> schedulePostCoffeeReminder() async {
    await Future.delayed(const Duration(minutes: 20));
    
    await showNotification(
      id: 100,
      title: '☕ После кофе',
      body: 'Выпейте 250-300 мл воды для баланса',
      payload: 'post_coffee',
    );
  }
  
  // Напоминание о жаре
  static Future<void> showHeatWarning(double heatIndex) async {
    if (heatIndex < 32) return;
    
    String message = '';
    if (heatIndex < 39) {
      message = 'Повышенная температура. Увеличьте потребление воды на 8%';
    } else {
      message = 'Экстремальная жара! Пейте воду каждые 30 минут';
    }
    
    await showNotification(
      id: 200,
      title: '🌡️ Предупреждение о жаре',
      body: message,
      payload: 'heat_warning',
    );
  }
  
  // Вечерний отчет
  static Future<void> scheduleEveningReport() async {
    final now = DateTime.now();
    final evening = DateTime(now.year, now.month, now.day, 21, 0);
    
    if (now.isAfter(evening)) return;
    
    await scheduleNotification(
      id: 300,
      title: '📊 Дневной отчет готов',
      body: 'Посмотрите, как прошел ваш день гидратации',
      scheduledDate: evening,
      payload: 'evening_report',
    );
  }
  
  // Отменить все уведомления
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
    _reminderTimer?.cancel();
  }
  
  // Отменить конкретное уведомление
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
  
  // Получить настройки напоминаний
  static Future<ReminderSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return ReminderSettings(
      enabled: prefs.getBool('remindersEnabled') ?? true,
      frequency: prefs.getInt('reminderFrequency') ?? 4, // раз в день
      morningTime: prefs.getString('morningTime') ?? '07:00',
      eveningTime: prefs.getString('eveningTime') ?? '22:00',
      postCoffee: prefs.getBool('postCoffeeReminder') ?? true,
      heatWarnings: prefs.getBool('heatWarnings') ?? true,
    );
  }
  
  // Сохранить настройки
  static Future<void> saveSettings(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('remindersEnabled', settings.enabled);
    await prefs.setInt('reminderFrequency', settings.frequency);
    await prefs.setString('morningTime', settings.morningTime);
    await prefs.setString('eveningTime', settings.eveningTime);
    await prefs.setBool('postCoffeeReminder', settings.postCoffee);
    await prefs.setBool('heatWarnings', settings.heatWarnings);
    
    // Перезапускаем таймеры с новыми настройками
    if (settings.enabled) {
      _startPeriodicReminders();
    } else {
      _reminderTimer?.cancel();
    }
  }
}

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