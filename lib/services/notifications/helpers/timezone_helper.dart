// lib/services/notifications/helpers/timezone_helper.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../notification_config.dart';

/// Helper для работы с временными зонами
class TimezoneHelper {
  // Не создаем экземпляры
  TimezoneHelper._();

  /// Инициализация временной зоны приложения
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    String timeZoneName;

    try {
      // Определяем тайм-зону по смещению
      final now = DateTime.now();
      final offset = now.timeZoneOffset;

      // Мапим популярные смещения на тайм-зоны
      timeZoneName = _getTimezoneByOffset(offset);

      print('🌍 Detected timezone offset: ${offset.inHours}h, using: $timeZoneName');
    } catch (e) {
      print('⚠️ Failed to detect timezone: $e');
      // Fallback на сохраненную или дефолтную
      final prefs = await SharedPreferences.getInstance();
      timeZoneName = prefs.getString(NotificationConfig.prefUserTimezone) ?? 'Europe/Madrid';
    }

    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print('🌍 Timezone set to: $timeZoneName');

      // Сохраняем для будущего использования
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(NotificationConfig.prefUserTimezone, timeZoneName);
    } catch (e) {
      print('⚠️ Failed to set timezone $timeZoneName, using UTC');
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Определение временной зоны по смещению
  static String _getTimezoneByOffset(Duration offset) {
    final hours = offset.inHours;
    
    switch (hours) {
      case 0:
        return 'Europe/London'; // GMT
      case 1:
        return 'Europe/Madrid'; // CET (зимой)
      case 2:
        return 'Europe/Madrid'; // CET (летом) - можно улучшить детекцию
      case 3:
        return 'Europe/Moscow'; // MSK
      case -5:
        return 'America/New_York'; // EST
      case -8:
        return 'America/Los_Angeles'; // PST
      default:
        // Для других смещений используем сохраненную или дефолтную
        return _getFallbackTimezone();
    }
  }

  /// Получение fallback временной зоны
  static String _getFallbackTimezone() {
    // Пытаемся получить из SharedPreferences синхронно (если уже загружено)
    // Иначе возвращаем дефолт
    return 'Europe/Madrid';
  }

  /// Конвертация DateTime в TZDateTime
  static tz.TZDateTime toTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Получение текущего времени в локальной временной зоне
  static tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  /// Проверка, находится ли время в указанном диапазоне
  static bool isTimeInRange(DateTime time, String startStr, String endStr) {
    final currentMinutes = time.hour * 60 + time.minute;
    
    final startParts = startStr.split(':');
    final endParts = endStr.split(':');
    
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    
    if (startMinutes > endMinutes) {
      // Интервал через полночь
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      // Обычный интервал
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  /// Корректировка времени для избежания указанного диапазона (например, тихие часы)
  static DateTime adjustTimeToAvoidRange(
    DateTime scheduledTime,
    String rangeStart,
    String rangeEnd,
  ) {
    if (!isTimeInRange(scheduledTime, rangeStart, rangeEnd)) {
      return scheduledTime;
    }

    final endParts = rangeEnd.split(':');
    
    // Переносим на конец диапазона
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
    
    return adjusted;
  }

  /// Получение дня года (1-366)
  static int dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }
}