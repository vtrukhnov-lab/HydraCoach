// lib/services/notifications/helpers/notification_limits_helper.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hydracoach/utils/app_logger.dart';

import '../notification_config.dart';
import '../notification_types.dart';

/// Helper для проверки лимитов и ограничений уведомлений
class NotificationLimitsHelper {
  final FirebaseRemoteConfig _remoteConfig;

  NotificationLimitsHelper(this._remoteConfig);

  /// Проверка, является ли пользователь PRO
  Future<bool> isProUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(NotificationConfig.prefIsPro) ?? false;
  }

  /// Проверка на дубликат уведомления
  Future<bool> isDuplicateNotification(
    NotificationType type,
    DateTime? lastTime, {
    Duration? minInterval,
  }) async {
    if (lastTime == null) return false;

    final requiredInterval = minInterval ?? type.minInterval;
    final timeSinceLastPassed = DateTime.now().difference(lastTime);

    if (timeSinceLastPassed < requiredInterval) {
      logger.w(
        'Duplicate prevention: $type was sent ${timeSinceLastPassed.inMinutes} min ago',
      );
      return true;
    }

    return false;
  }

  /// Проверка дневного лимита для FREE пользователей
  Future<bool> checkDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем дату последнего сброса
    final lastReset =
        prefs.getString(NotificationConfig.prefNotificationLimitReset) ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      // Новый день - сбрасываем счетчик
      await prefs.setInt(NotificationConfig.prefNotificationCountToday, 0);
      await prefs.setString(
        NotificationConfig.prefNotificationLimitReset,
        today,
      );
      return true;
    }

    // Проверяем текущий счетчик
    final count =
        prefs.getInt(NotificationConfig.prefNotificationCountToday) ?? 0;
    final maxFree = _remoteConfig.getInt(
      NotificationConfig.rcMaxFreeNotifications,
    );
    final limit = maxFree > 0
        ? maxFree
        : NotificationConfig.maxFreeNotificationsDaily;

    return count < limit;
  }

  /// Увеличение счетчика уведомлений
  Future<void> incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count =
        prefs.getInt(NotificationConfig.prefNotificationCountToday) ?? 0;
    await prefs.setInt(
      NotificationConfig.prefNotificationCountToday,
      count + 1,
    );
  }

  /// Проверка анти-спама
  Future<bool> checkAntiSpam({int? overrideMinutes}) async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем включен ли анти-спам
    final antiSpamEnabled =
        prefs.getBool(NotificationConfig.prefAntiSpamEnabled) ?? true;
    if (!antiSpamEnabled) return true;

    // Проверяем время последнего уведомления
    final lastTime =
        prefs.getInt(NotificationConfig.prefLastNotificationTime) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Минимальный интервал
    final rc = _remoteConfig.getInt(NotificationConfig.rcAntiSpamInterval);
    final isPro = await isProUser();
    final defaultMinutes = isPro
        ? NotificationConfig.proAntiSpamMinutes
        : NotificationConfig.freeAntiSpamMinutes;
    final minMinutes = overrideMinutes ?? (rc > 0 ? rc : defaultMinutes);
    final intervalMs = minMinutes * 60 * 1000;

    if (now - lastTime < intervalMs) {
      logger.d(
        'Anti-spam: too soon since last notification (need $minMinutes min)',
      );
      return false;
    }

    return true;
  }

  /// Сохранение времени последнего уведомления
  Future<void> saveLastNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      NotificationConfig.prefLastNotificationTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Проверка суточного лимита для PRO пользователей
  Future<bool> checkProDailyCap() async {
    final prefs = await SharedPreferences.getInstance();

    // Проверяем дату последнего сброса
    final lastReset = prefs.getString(NotificationConfig.prefProCapReset) ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      await prefs.setInt(NotificationConfig.prefProSentToday, 0);
      await prefs.setString(NotificationConfig.prefProCapReset, today);
    }

    final sent = prefs.getInt(NotificationConfig.prefProSentToday) ?? 0;

    final soft = _remoteConfig.getInt(NotificationConfig.rcProDailyCap);
    final hard = _remoteConfig.getInt(NotificationConfig.rcProHardCap);
    final softCap = soft > 0 ? soft : NotificationConfig.proDailySoftCap;
    final hardCap = hard > 0 ? hard : NotificationConfig.proDailyHardCap;

    if (sent >= hardCap) return false; // жесткий стоп

    if (sent >= softCap) {
      // Мягкий кап достигнут – не стопорим, но можно логировать
      logger.w('PRO soft cap reached ($sent/$softCap)');
    }

    return true;
  }

  /// Увеличение счетчика PRO уведомлений
  Future<void> incrementProCount() async {
    if (!await isProUser()) return;

    final prefs = await SharedPreferences.getInstance();
    final sent = prefs.getInt(NotificationConfig.prefProSentToday) ?? 0;
    await prefs.setInt(NotificationConfig.prefProSentToday, sent + 1);
  }

  /// Проверка тихих часов
  Future<bool> isInQuietHours() async {
    // Тихие часы только для PRO
    final isPro = await isProUser();
    if (!isPro) return false;

    final prefs = await SharedPreferences.getInstance();

    // Проверяем включены ли тихие часы
    final quietEnabled =
        prefs.getBool(NotificationConfig.prefQuietHoursEnabled) ?? true;
    if (!quietEnabled) return false;

    // Получаем время начала и конца
    final startStr =
        prefs.getString(NotificationConfig.prefQuietHoursStart) ??
        NotificationConfig.defaultQuietHoursStart;
    final endStr =
        prefs.getString(NotificationConfig.prefQuietHoursEnd) ??
        NotificationConfig.defaultQuietHoursEnd;

    return isInQuietHoursAt(DateTime.now(), startStr, endStr);
  }

  /// Проверка, попадает ли указанное время в тихие часы
  bool isInQuietHoursAt(DateTime dt, String startStr, String endStr) {
    final currentMinutes = dt.hour * 60 + dt.minute;

    final startParts = startStr.split(':');
    final endParts = endStr.split(':');

    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    if (startMinutes > endMinutes) {
      // Интервал через полночь
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    } else {
      // Обычный интервал
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    }
  }

  /// Корректировка времени для тихих часов
  Future<DateTime> adjustForQuietHours(DateTime scheduledTime) async {
    if (!await isInQuietHours()) {
      return scheduledTime;
    }

    final prefs = await SharedPreferences.getInstance();
    final endStr =
        prefs.getString(NotificationConfig.prefQuietHoursEnd) ??
        NotificationConfig.defaultQuietHoursEnd;
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

    logger.i(
      'Notification rescheduled from $scheduledTime to $adjusted (quiet hours)',
    );
    return adjusted;
  }

  /// Проверка окна поста
  Future<bool> isInFastingWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final dietMode =
        prefs.getString(NotificationConfig.prefDietMode) ?? 'normal';

    if (dietMode != 'fasting') return false;

    // Получаем расписание поста
    final windowStart =
        prefs.getInt(NotificationConfig.prefFastingWindowStart) ?? 20; // 20:00
    final windowEnd =
        prefs.getInt(NotificationConfig.prefFastingWindowEnd) ?? 12; // 12:00

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

  /// Проверка, нужно ли отправлять уведомление в режиме поста
  Future<bool> shouldSendQuietFastingReminder() async {
    // В режиме поста отправляем только электролитные напоминания
    final isFasting = await isInFastingWindow();
    if (!isFasting) return true;

    final prefs = await SharedPreferences.getInstance();
    final quietFasting =
        prefs.getBool(NotificationConfig.prefQuietFastingMode) ?? false;

    return !quietFasting; // Если тихий режим - не отправляем
  }

  /// Комплексная проверка возможности отправки
  Future<bool> canSendNotification() async {
    final isPro = await isProUser();

    // Проверяем антиспам для всех
    final okInterval = await checkAntiSpam();
    if (!okInterval) return false;

    // FREE пользователи - дополнительно проверяем дневной лимит
    if (!isPro) {
      return await checkDailyLimit();
    }

    return true;
  }
}
