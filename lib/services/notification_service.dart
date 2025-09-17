// lib/services/notification_service.dart
// РЕФАКТОРИНГ: Фасад-координатор для всех компонентов системы уведомлений

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:timezone/timezone.dart' as tz;

// Импорт всех компонентов новой архитектуры
import 'notifications/notification_types.dart';
import 'notifications/notification_initializer.dart';
import 'notifications/notification_scheduler.dart';
import 'notifications/notification_sender.dart';
import 'notifications/specific_notifications.dart';
import 'notifications/fcm_handler.dart';
import 'notifications/notification_manager.dart';
import 'notifications/helpers/notification_limits_helper.dart';
import 'notifications/helpers/timezone_helper.dart';
import 'notification_texts.dart';

// Старые импорты для совместимости
import 'analytics_service.dart';

/// Главный фасад системы уведомлений HydraCoach
/// Координирует все компоненты и предоставляет единый API
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Основные компоненты системы
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final AnalyticsService _analytics = AnalyticsService();

  // Новые компоненты архитектуры
  late final NotificationLimitsHelper _limitsHelper;
  late final NotificationInitializer _initializer;
  late final NotificationSender _sender;
  late final NotificationScheduler _scheduler;
  late final SpecificNotifications _specificNotifications;
  late final FCMHandler _fcmHandler;
  late final NotificationManager _manager;

  bool _isInitialized = false;

  // ==================== ИНИЦИАЛИЗАЦИЯ ====================

  /// Главная точка входа - инициализация всей системы
  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeService();
  }

  Future<void> _initializeService() async {
    if (_isInitialized) {
      print('NotificationService already initialized, skipping');
      return;
    }

    print('🔥 [NotificationService] Starting initialization...');

    try {
      // 1. Создание всех компонентов
      await _createComponents();

      // 2. Инициализация базовых компонентов
      await _initializer.initialize();

      // 3. Инициализация FCM
      await _fcmHandler.initialize();

      // 4. Восстановление состояния
      final state = await _initializer.restoreNotificationState();
      _sender.updatePendingIds(state['pendingIds']);

      _isInitialized = true;
      print('✅ [NotificationService] Core initialization complete');

      // 5. КРИТИЧНО: Гарантированное планирование уведомлений
      print('🔥 [NotificationService] Starting notification scheduling...');
      
      // Небольшая задержка для гарантии полной инициализации
      await Future.delayed(Duration(milliseconds: 300));
      
      // Проверяем текущие уведомления ПЕРЕД планированием
      await _checkExistingNotifications();
      
      // Планируем уведомления
      final schedulingSuccess = await _scheduleNotificationsWithVerification();
      
      if (!schedulingSuccess) {
        print('⚠️ [NotificationService] First scheduling attempt failed, retrying...');
        await Future.delayed(Duration(seconds: 1));
        await _forceScheduleNotifications();
      }
      
      print('✅ [NotificationService] Full initialization complete');
      
    } catch (e, stackTrace) {
      print('❌ [NotificationService] Critical error during initialization: $e');
      print('Stack trace: $stackTrace');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Проверка существующих уведомлений
  Future<void> _checkExistingNotifications() async {
    final pending = await _localNotifications.pendingNotificationRequests();
    final now = DateTime.now();
    final todayDay = TimezoneHelper.dayOfYear(now);
    
    print('📋 [NotificationService] Checking existing notifications...');
    print('  Total pending: ${pending.length}');
    
    Map<int, int> byDay = {};
    for (final n in pending) {
      try {
        final decoded = NotificationSender.decodeNotificationId(n.id);
        byDay[decoded.dayFromId] = (byDay[decoded.dayFromId] ?? 0) + 1;
      } catch (e) {
        // Игнорируем ошибки декодирования старых ID
      }
    }
    
    print('  By day distribution:');
    byDay.forEach((day, count) {
      final label = day == todayDay ? ' (TODAY)' : day == todayDay + 1 ? ' (TOMORROW)' : '';
      print('    Day $day: $count notifications$label');
    });
  }

  /// Планирование с проверкой результата
  Future<bool> _scheduleNotificationsWithVerification() async {
    print('🔄 [NotificationService] Scheduling notifications...');
    
    // Вызываем планирование
    await _scheduler.scheduleInitialNotifications();
    
    // Ждём немного для применения изменений
    await Future.delayed(Duration(milliseconds: 200));
    
    // Проверяем результат
    final pending = await _localNotifications.pendingNotificationRequests();
    final now = DateTime.now();
    final todayDay = TimezoneHelper.dayOfYear(now);
    
    int todayCount = 0;
    int tomorrowCount = 0;
    
    for (final n in pending) {
      try {
        final decoded = NotificationSender.decodeNotificationId(n.id);
        if (decoded.dayFromId == todayDay) {
          todayCount++;
        } else if (decoded.dayFromId == todayDay + 1) {
          tomorrowCount++;
        }
      } catch (e) {
        // Игнорируем старые форматы ID
      }
    }
    
    print('📊 [NotificationService] Scheduling result:');
    print('  Today (day $todayDay): $todayCount notifications');
    print('  Tomorrow: $tomorrowCount notifications');
    print('  Total: ${pending.length} notifications');
    
    // Возвращаем true если есть уведомления на сегодня
    return todayCount > 0 || now.hour >= 21; // После 21:00 нормально не иметь уведомлений на сегодня
  }

  /// Принудительное создание уведомлений
  Future<void> _forceScheduleNotifications() async {
    print('🚨 [NotificationService] FORCE SCHEDULING ACTIVATED');
    
    final now = DateTime.now();
    
    // Если ещё не поздно, создаём экстренные уведомления
    if (now.hour < 21) {
      print('  Creating emergency notifications for today...');
      
      // Отменяем существующие на сегодня
      final todayDay = TimezoneHelper.dayOfYear(now);
      final pending = await _localNotifications.pendingNotificationRequests();
      
      for (final n in pending) {
        try {
          final decoded = NotificationSender.decodeNotificationId(n.id);
          if (decoded.dayFromId == todayDay) {
            await _localNotifications.cancel(n.id);
          }
        } catch (e) {
          // Игнорируем ошибки
        }
      }
      
      // Создаём новые уведомления через прямой вызов
      await _createEmergencyNotifications();
    }
    
    // Планируем будущие дни
    await _scheduler.scheduleFutureDaysOnly();
  }

  /// Создание экстренных уведомлений напрямую
  Future<void> _createEmergencyNotifications() async {
    final now = DateTime.now();
    
    // Загружаем тексты
    await NotificationTexts.ensureLoaded();
    
    // Времена для экстренных уведомлений
    final times = [
      now.add(Duration(minutes: 5)),    // Через 5 минут
      now.add(Duration(minutes: 60)),   // Через час
      now.add(Duration(minutes: 120)),  // Через 2 часа
    ];
    
    int created = 0;
    for (final time in times) {
      if (time.hour >= 21) continue; // Не планируем после 21:00
      
      try {
        final notificationId = _sender.generateNotificationId(
          NotificationType.waterReminder,
          when: time
        );
        
        // Создаём детали уведомления
        final androidDetails = AndroidNotificationDetails(
          'hydracoach_default_${NotificationTexts.currentLocale}',
          NotificationTexts.channelNameDefault,
          channelDescription: NotificationTexts.channelDescDefault,
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        );
        
        final iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        
        final details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );
        
        // Планируем уведомление
        await _localNotifications.zonedSchedule(
          notificationId,
          NotificationTexts.waterReminderTitle,
          NotificationTexts.notificationMorningWaterBody,
          tz.TZDateTime.from(time, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        
        created++;
        print('  ✅ Emergency notification scheduled for ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
        
      } catch (e) {
        print('  ❌ Failed to create emergency notification: $e');
      }
    }
    
    print('  Created $created emergency notifications');
  }

  /// Создание всех компонентов системы
  Future<void> _createComponents() async {
    print('🔧 [NotificationService] Creating components...');

    // Создание helpers
    _limitsHelper = NotificationLimitsHelper(_remoteConfig);

    // Создание основных компонентов
    _initializer = NotificationInitializer(
      _localNotifications,
      _messaging,
      _remoteConfig,
    );

    _sender = NotificationSender(
      _localNotifications,
      _firestore,
      _limitsHelper,
      _analytics,
    );

    _scheduler = NotificationScheduler(
      _sender,
      _limitsHelper,
      _remoteConfig,
    );

    _specificNotifications = SpecificNotifications(
      _sender,
      _limitsHelper,
      _remoteConfig,
    );

    _fcmHandler = FCMHandler(
      _messaging,
      _firestore,
      _sender,
      _analytics,
    );

    _manager = NotificationManager(
      _localNotifications,
      _sender,
      _analytics,
    );

    print('✅ [NotificationService] All components created');
  }

  // ==================== ПУБЛИЧНОЕ API - ОСНОВНЫЕ МЕТОДЫ ====================

  /// Отправка уведомления (основной метод)
  Future<void> sendNotification({
    required NotificationType type,
    required String title,
    required String body,
    DateTime? scheduledTime,
    Map<String, dynamic>? payload,
    bool skipChecks = false,
    bool silentIfQuiet = false,
  }) async {
    await _ensureInitialized();
    
    await _sender.sendNotification(
      type: type,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
      skipChecks: skipChecks,
      silentIfQuiet: silentIfQuiet,
    );
  }

  // ==================== СПЕЦИФИЧНЫЕ УВЕДОМЛЕНИЯ ====================

  /// Планирование напоминания после кофе
  Future<void> schedulePostCoffeeReminder() async {
    await _ensureInitialized();
    await _specificNotifications.schedulePostCoffeeReminder();
  }

  /// Планирование контр-напоминания после алкоголя
  Future<void> scheduleAlcoholCounterReminder(int standardDrinks) async {
    await _ensureInitialized();
    await _specificNotifications.scheduleAlcoholCounterReminder(standardDrinks);
  }

  /// Планирование плана восстановления после алкоголя (PRO)
  Future<void> scheduleAlcoholRecoveryPlan(int standardDrinks) async {
    await _ensureInitialized();
    await _specificNotifications.scheduleAlcoholRecoveryPlan(standardDrinks);
  }

  /// Планирование утреннего чек-ина
  Future<void> scheduleMorningCheckIn() async {
    await _ensureInitialized();
    await _specificNotifications.scheduleMorningCheckIn();
  }

  /// Отправка предупреждения о жаре (PRO)
  Future<void> sendHeatWarning(double heatIndex) async {
    await _ensureInitialized();
    await _specificNotifications.sendHeatWarning(heatIndex);
  }

  /// Планирование напоминания после тренировки (PRO)
  Future<void> sendWorkoutReminder({DateTime? workoutEndTime}) async {
    await _ensureInitialized();
    await _specificNotifications.sendWorkoutReminder(workoutEndTime: workoutEndTime);
  }

  /// Планирование вечернего отчета
  Future<void> scheduleEveningReport() async {
    await _ensureInitialized();
    await _specificNotifications.scheduleEveningReport();
  }

  // ==================== ПЛАНИРОВАНИЕ ====================

  /// Планирование умных напоминаний (PRO)
  Future<void> scheduleSmartReminders() async {
    await _ensureInitialized();
    await _scheduler.scheduleSmartReminders();
  }

  /// Принудительное перепланирование всех уведомлений
  Future<void> rescheduleAllNotifications() async {
    await _ensureInitialized();
    
    print('🔄 [NotificationService] Rescheduling all notifications...');
    
    // Отменяем все текущие
    await _manager.cancelAllNotifications();
    
    // Ждём немного
    await Future.delayed(Duration(milliseconds: 200));
    
    // Планируем заново с проверкой
    final success = await _scheduleNotificationsWithVerification();
    
    if (!success) {
      await _forceScheduleNotifications();
    }
    
    print('✅ [NotificationService] Rescheduling complete');
  }

  // ==================== УПРАВЛЕНИЕ УВЕДОМЛЕНИЯМИ ====================

  /// Отмена конкретного уведомления
  Future<void> cancelNotification(int id) async {
    await _ensureInitialized();
    await _manager.cancelNotification(id);
  }

  /// Отмена всех уведомлений
  Future<void> cancelAllNotifications() async {
    await _ensureInitialized();
    await _manager.cancelAllNotifications();
  }

  /// Отмена уведомлений по типам
  Future<void> cancelByTypes(Set<NotificationType> types) async {
    await _ensureInitialized();
    await _manager.cancelByTypes(types);
  }

  /// Получение списка запланированных уведомлений
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    await _ensureInitialized();
    return await _manager.getPendingNotifications();
  }

  /// Вывод подробного статуса уведомлений
  Future<void> printNotificationStatus() async {
    await _ensureInitialized();
    await _manager.printNotificationStatus();
  }

  /// Получение статистики уведомлений
  Future<Map<String, dynamic>> getNotificationStats() async {
    await _ensureInitialized();
    return await _manager.getNotificationStats();
  }

  // ==================== ТЕСТИРОВАНИЕ ====================

  /// Отправка тестового уведомления
  Future<void> sendTestNotification() async {
    await _ensureInitialized();
    await _manager.sendTestNotification();
  }

  /// Планирование тестового уведомления через 1 минуту
  Future<void> scheduleTestIn1Minute() async {
    await _ensureInitialized();
    await _manager.scheduleTestIn1Minute();
  }

  // ==================== СМЕНА ЯЗЫКА ====================

  /// Обработка смены языка приложения
  /// Пересоздает Android каналы и перепланирует уведомления с новыми текстами
  Future<void> onLocaleChanged(String localeCode) async {
    print('🌍 [NotificationService] Language change initiated: $localeCode');
    
    try {
      await _ensureInitialized();

      // Обновляем каналы для нового языка
      await _initializer.recreateChannelsForLocale(localeCode);

      // Перепланируем уведомления с новыми текстами
      await _scheduler.onLocaleChanged(localeCode);

      // Логируем в аналитику
      await _analytics.logSettingsChanged(
        setting: 'notification_locale',
        value: localeCode,
      );

      print('✅ [NotificationService] Language change completed');

    } catch (e, stackTrace) {
      print('❌ Error changing notification locale: $e');
      print('Stack trace: $stackTrace');
      
      await _analytics.logNotificationError(
        type: 'locale_change',
        error: e.toString(),
      );
    }
  }

  // ==================== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ====================

  /// Гарантия инициализации перед вызовом методов
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeService();
    }
  }

  /// Проверка статуса инициализации
  bool get isInitialized => _isInitialized;

  // ==================== ДОСТУП К КОМПОНЕНТАМ (для расширения) ====================

  /// Получение компонента отправки (для продвинутого использования)
  NotificationSender get sender {
    if (!_isInitialized) throw StateError('NotificationService not initialized');
    return _sender;
  }

  /// Получение планировщика (для продвинутого использования)
  NotificationScheduler get scheduler {
    if (!_isInitialized) throw StateError('NotificationService not initialized');
    return _scheduler;
  }

  /// Получение менеджера (для продвинутого использования)
  NotificationManager get manager {
    if (!_isInitialized) throw StateError('NotificationService not initialized');
    return _manager;
  }

  /// Получение FCM обработчика (для продвинутого использования)
  FCMHandler get fcmHandler {
    if (!_isInitialized) throw StateError('NotificationService not initialized');
    return _fcmHandler;
  }

  /// Получение специфичных уведомлений (для продвинутого использования)
  SpecificNotifications get specificNotifications {
    if (!_isInitialized) throw StateError('NotificationService not initialized');
    return _specificNotifications;
  }

  // ==================== ОТЛАДКА И МОНИТОРИНГ ====================

  /// Полный статус всей системы уведомлений
  Future<Map<String, dynamic>> getSystemStatus() async {
    await _ensureInitialized();

    return {
      'initialized': _isInitialized,
      'notifications': await _manager.getNotificationStats(),
      'scheduler': await _scheduler.getSchedulerStatus(),
      'fcm': await _fcmHandler.getPermissionStatus(),
      'limits': await _limitsHelper.isProUser(),
      'settings': await _initializer.getUserNotificationSettings(),
    };
  }

  /// Экспорт конфигурации для отладки
  Future<String> exportDebugInfo() async {
    await _ensureInitialized();
    
    final systemStatus = await getSystemStatus();
    final notificationsList = await _manager.exportNotificationsToJson();
    
    return '''
=== HydraCoach Notification System Debug ===
Time: ${DateTime.now().toIso8601String()}

System Status:
${systemStatus.toString()}

Notifications Export:
$notificationsList
    ''';
  }

  /// Очистка всех данных (для сброса или выхода пользователя)
  Future<void> cleanup() async {
    if (!_isInitialized) return;

    print('🧹 [NotificationService] Cleaning up...');
    
    try {
      // Отменяем все уведомления
      await _manager.cancelAllNotifications();
      
      // Очищаем FCM
      await _fcmHandler.cleanup();
      
      // Сбрасываем флаг инициализации
      _isInitialized = false;
      
      print('✅ [NotificationService] Cleanup completed');
    } catch (e) {
      print('❌ Error during cleanup: $e');
    }
  }
}