// lib/services/notifications/helpers/schedule_window_helper.dart

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/services/notifications/notification_config.dart';

/// Helper для управления скользящим окном уведомлений
class ScheduleWindowHelper {
  // Размер окна в днях
  static const int windowDaysIOS = 5;      // iOS: лимит 64 уведомления
  static const int windowDaysAndroid = 7;  // Android: больше свободы
  
  // Максимальное количество уведомлений для iOS
  static const int maxIOSNotifications = 60; // Оставляем запас от лимита 64
  
  // Средняя оценка уведомлений в день
  static const int avgNotificationsPerDay = 8; // 4 воды + отчет + возможные PRO
  
  /// Получить размер окна для текущей платформы
  static int getWindowDays() {
    return Platform.isIOS ? windowDaysIOS : windowDaysAndroid;
  }
  
  /// Получить даты окна планирования
  static (DateTime start, DateTime end) getWindowDates() {
    final now = DateTime.now();
    final windowDays = getWindowDays();
    
    // Начинаем с сегодня
    final start = DateTime(now.year, now.month, now.day);
    
    // Заканчиваем через N дней
    final end = start.add(Duration(days: windowDays));
    
    return (start, end);
  }
  
  /// Проверить, нужно ли обновить окно
  static Future<bool> shouldRefreshWindow() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Когда последний раз обновляли окно
    final lastRefreshStr = prefs.getString('schedule_window_last_refresh');
    if (lastRefreshStr == null) return true;
    
    final lastRefresh = DateTime.parse(lastRefreshStr);
    final now = DateTime.now();
    
    // Обновляем если прошло больше суток
    if (now.difference(lastRefresh).inHours >= 24) {
      return true;
    }
    
    // Или если сменился день
    if (now.day != lastRefresh.day) {
      return true;
    }
    
    return false;
  }
  
  /// Сохранить время последнего обновления окна
  static Future<void> markWindowRefreshed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'schedule_window_last_refresh', 
      DateTime.now().toIso8601String()
    );
  }
  
  /// Подсчитать количество запланированных уведомлений
  static Future<int> getScheduledCount() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Храним метаданные о запланированных уведомлениях
    final scheduledData = prefs.getStringList('scheduled_notifications_meta') ?? [];
    
    // Фильтруем устаревшие
    final now = DateTime.now();
    final validCount = scheduledData.where((item) {
      try {
        final parts = item.split('|');
        if (parts.length < 2) return false;
        final scheduledTime = DateTime.parse(parts[1]);
        return scheduledTime.isAfter(now);
      } catch (e) {
        return false;
      }
    }).length;
    
    return validCount;
  }
  
  /// Сохранить метаданные о запланированном уведомлении
  static Future<void> saveScheduledMetadata(
    int id,
    DateTime scheduledTime,
    String type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    final scheduledData = prefs.getStringList('scheduled_notifications_meta') ?? [];
    
    // Формат: id|datetime|type
    final metadata = '$id|${scheduledTime.toIso8601String()}|$type';
    scheduledData.add(metadata);
    
    // Чистим старые записи (больше 10 дней)
    final cutoff = DateTime.now().subtract(const Duration(days: 10));
    final filtered = scheduledData.where((item) {
      try {
        final parts = item.split('|');
        if (parts.length < 2) return false;
        final time = DateTime.parse(parts[1]);
        return time.isAfter(cutoff);
      } catch (e) {
        return false;
      }
    }).toList();
    
    await prefs.setStringList('scheduled_notifications_meta', filtered);
  }
  
  /// Очистить метаданные устаревших уведомлений
  static Future<void> cleanupOldMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    
    final scheduledData = prefs.getStringList('scheduled_notifications_meta') ?? [];
    final now = DateTime.now();
    
    // Оставляем только будущие
    final filtered = scheduledData.where((item) {
      try {
        final parts = item.split('|');
        if (parts.length < 2) return false;
        final time = DateTime.parse(parts[1]);
        return time.isAfter(now);
      } catch (e) {
        return false;
      }
    }).toList();
    
    await prefs.setStringList('scheduled_notifications_meta', filtered);
    
    print('🧹 Cleaned up metadata: ${scheduledData.length - filtered.length} old entries removed');
  }
  
  /// Проверить, не превышен ли лимит для iOS
  static Future<bool> canScheduleMore() async {
    if (!Platform.isIOS) return true;
    
    final count = await getScheduledCount();
    return count < maxIOSNotifications;
  }
  
  /// Рассчитать, сколько дней можно запланировать
  static Future<int> calculateSafeDays() async {
    if (!Platform.isIOS) return windowDaysAndroid;
    
    final currentCount = await getScheduledCount();
    final available = maxIOSNotifications - currentCount;
    
    // Сколько дней можем покрыть с учетом среднего количества
    final safeDays = available ~/ avgNotificationsPerDay;
    
    // Но не больше максимального окна
    return safeDays.clamp(1, windowDaysIOS);
  }
}