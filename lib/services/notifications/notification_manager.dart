// lib/services/notifications/notification_manager.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'notification_types.dart';
import 'notification_sender.dart';
import '../notification_texts.dart';
import '../analytics_service.dart';

/// Класс для управления уведомлениями: отмена, получение списка, тестирование
class NotificationManager {
  final FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationSender _notificationSender;
  final AnalyticsService _analytics;

  NotificationManager(
    this._localNotifications,
    this._notificationSender,
    this._analytics,
  );

  /// Отмена конкретного уведомления по ID
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    _notificationSender.pendingNotificationIds.remove(id);
    print('🚫 Notification cancelled: $id');
  }

  /// Отмена всех уведомлений
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    _notificationSender.pendingNotificationIds.clear();
    _notificationSender.lastNotificationIds.clear();
    print('🗑️ All notifications cancelled');
  }

  /// Отмена уведомлений по типам
  Future<void> cancelByTypes(Set<NotificationType> types) async {
    final pending = await getPendingNotifications();
    final typeIdxSet = types.map((t) => t.index).toSet();
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      if (typeIdxSet.contains(decoded.typeIdx)) {
        await cancelNotification(notification.id);
      }
    }
    
    print('🚫 Cancelled notifications for types: $types');
  }

  /// Отмена уведомлений на конкретный день
  Future<void> cancelForDay(int dayOfYear) async {
    final pending = await getPendingNotifications();
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      if (decoded.dayFromId == dayOfYear) {
        await cancelNotification(notification.id);
      }
    }
    
    print('🚫 Cancelled notifications for day: $dayOfYear');
  }

  /// Получение списка запланированных уведомлений
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  /// Подробный статус уведомлений с группировкой по типам
  Future<void> printNotificationStatus() async {
    final pending = await getPendingNotifications();
    print('\n📋 ===== NOTIFICATION STATUS =====');
    print('📋 Pending notifications: ${pending.length}');

    if (pending.isNotEmpty) {
      // Группируем по типам
      final Map<String, int> typeCount = {};
      final Map<String, List<PendingNotificationRequest>> typeNotifications = {};
      
      for (final notification in pending) {
        final decoded = NotificationSender.decodeNotificationId(notification.id);
        final typeName = decoded.typeIdx < NotificationType.values.length 
            ? NotificationType.values[decoded.typeIdx].name 
            : 'unknown_${decoded.typeIdx}';
        
        typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
        typeNotifications.putIfAbsent(typeName, () => []).add(notification);
      }
      
      // Показываем статистику по типам
      print('\n📋 Notifications by type:');
      typeCount.forEach((type, count) {
        print('  - $type: $count notifications');
      });
      
      // Показываем ближайшие 3 уведомления
      print('\n📋 Next 3 notifications:');
      for (int i = 0; i < pending.length && i < 3; i++) {
        final notification = pending[i];
        final decoded = NotificationSender.decodeNotificationId(notification.id);
        final typeName = decoded.typeIdx < NotificationType.values.length 
            ? NotificationType.values[decoded.typeIdx].name 
            : 'unknown';
        
        print('  ${i + 1}. [$typeName] ${notification.title}');
        print('     Time: Day ${decoded.dayFromId}, ${decoded.hour}:${decoded.minute.toString().padLeft(2, '0')}');
      }

      // Детальная разбивка по дням (первые 7 дней)
      print('\n📋 Schedule by days (next 7):');
      final Map<int, int> dayCount = {};
      for (final notification in pending) {
        final decoded = NotificationSender.decodeNotificationId(notification.id);
        dayCount[decoded.dayFromId] = (dayCount[decoded.dayFromId] ?? 0) + 1;
      }
      
      final sortedDays = dayCount.keys.toList()..sort();
      for (int i = 0; i < sortedDays.length && i < 7; i++) {
        final day = sortedDays[i];
        print('  Day $day: ${dayCount[day]} notifications');
      }
    }

    print('📋 =================================\n');
  }

  /// Получение статистики уведомлений
  Future<Map<String, dynamic>> getNotificationStats() async {
    final pending = await getPendingNotifications();
    final Map<String, int> typeCount = {};
    final Map<int, int> dayCount = {};
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      final typeName = decoded.typeIdx < NotificationType.values.length 
          ? NotificationType.values[decoded.typeIdx].name 
          : 'unknown';
      
      typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
      dayCount[decoded.dayFromId] = (dayCount[decoded.dayFromId] ?? 0) + 1;
    }

    return {
      'total': pending.length,
      'byType': typeCount,
      'byDay': dayCount,
      'nextNotifications': pending.take(5).map((n) => {
        'id': n.id,
        'title': n.title,
        'body': n.body,
      }).toList(),
    };
  }

  /// Поиск уведомлений по типу
  Future<List<PendingNotificationRequest>> findNotificationsByType(NotificationType type) async {
    final pending = await getPendingNotifications();
    final result = <PendingNotificationRequest>[];
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      if (decoded.typeIdx == type.index) {
        result.add(notification);
      }
    }
    
    return result;
  }

  /// Проверка существования уведомления определенного типа
  Future<bool> hasNotificationType(NotificationType type) async {
    final notifications = await findNotificationsByType(type);
    return notifications.isNotEmpty;
  }

  /// Тестовое уведомление (немедленная отправка)
  Future<void> sendTestNotification() async {
    await NotificationTexts.ensureLoaded();
    
    await _notificationSender.sendNotification(
      type: NotificationType.custom,
      title: NotificationTexts.testTitle,
      body: NotificationTexts.testBody,
      payload: {'action': 'test'},
      skipChecks: true,
    );

    await _analytics.logTestEvent();
    print('🧪 Test notification sent');
  }

  /// Тестовое запланированное уведомление (через 1 минуту)
  Future<void> scheduleTestIn1Minute() async {
    await NotificationTexts.ensureLoaded();
    
    final scheduledTime = DateTime.now().add(const Duration(minutes: 1));

    await _notificationSender.sendNotification(
      type: NotificationType.custom,
      title: NotificationTexts.testScheduledTitle,
      body: NotificationTexts.testScheduledBody,
      scheduledTime: scheduledTime,
      payload: {'action': 'test_scheduled'},
      skipChecks: true,
    );

    print('🧪 Test notification scheduled for 1 minute');
  }

  /// Очистка просроченных уведомлений (которые должны были уже сработать)
  Future<void> cleanupExpiredNotifications() async {
    final pending = await getPendingNotifications();
    final now = DateTime.now();
    int cleanedCount = 0;
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      
      // Примерная дата из ID (может быть неточной без года)
      final notificationDay = decoded.dayFromId;
      final currentDay = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
      
      // Если уведомление было запланировано на вчера или раньше
      if (notificationDay < currentDay - 1) {
        await cancelNotification(notification.id);
        cleanedCount++;
      }
    }
    
    if (cleanedCount > 0) {
      print('🧹 Cleaned up $cleanedCount expired notifications');
    }
  }

  /// Экспорт списка уведомлений в JSON для отладки
  Future<String> exportNotificationsToJson() async {
    final pending = await getPendingNotifications();
    final List<Map<String, dynamic>> exportData = [];
    
    for (final notification in pending) {
      final decoded = NotificationSender.decodeNotificationId(notification.id);
      final typeName = decoded.typeIdx < NotificationType.values.length 
          ? NotificationType.values[decoded.typeIdx].name 
          : 'unknown';
      
      exportData.add({
        'id': notification.id,
        'type': typeName,
        'typeIndex': decoded.typeIdx,
        'title': notification.title,
        'body': notification.body,
        'day': decoded.dayFromId,
        'hour': decoded.hour,
        'minute': decoded.minute,
        'payload': notification.payload,
      });
    }
    
    final result = {
      'exportTime': DateTime.now().toIso8601String(),
      'totalCount': pending.length,
      'notifications': exportData,
    };
    
    return jsonEncode(result);
  }
}