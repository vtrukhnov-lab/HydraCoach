// lib/services/notifications/notification_types.dart

/// Типы уведомлений в приложении HydraCoach
enum NotificationType {
  // FREE уведомления
  waterReminder, // Базовое напоминание о воде
  postCoffee, // После кофе (1 раз)
  dailyReport, // Вечерний отчет
  alcoholCounter, // Контр-пинг после алкоголя
  // PRO уведомления
  smartReminder, // Умное контекстное
  heatWarning, // Предупреждение о жаре
  workoutReminder, // Напоминание при тренировке (только POST-workout)
  fastingElectrolyte, // Электролиты в пост
  alcoholRecovery, // План восстановления
  morningCheckIn, // Утренний чек-ин
  // SYSTEM
  custom, // Кастомные уведомления (FCM, тесты и т.д.)
}

/// Расширение для удобной работы с типами
extension NotificationTypeExtension on NotificationType {
  /// Является ли тип PRO-функцией
  bool get isPro {
    return [
      NotificationType.smartReminder,
      NotificationType.heatWarning,
      NotificationType.workoutReminder,
      NotificationType.fastingElectrolyte,
      NotificationType.alcoholRecovery,
      NotificationType.morningCheckIn,
    ].contains(this);
  }

  /// Является ли тип singleton (должен быть единственным)
  bool get isSingleton {
    return [
      NotificationType.dailyReport,
      NotificationType.morningCheckIn,
      NotificationType.heatWarning,
      NotificationType.postCoffee,
    ].contains(this);
  }

  /// Минимальный интервал между уведомлениями этого типа
  Duration get minInterval {
    switch (this) {
      case NotificationType.postCoffee:
        return const Duration(hours: 2);
      case NotificationType.waterReminder:
        return const Duration(hours: 1);
      case NotificationType.dailyReport:
        return const Duration(hours: 23);
      case NotificationType.alcoholCounter:
        return const Duration(hours: 1);
      case NotificationType.smartReminder:
        return const Duration(minutes: 30);
      case NotificationType.workoutReminder:
        return const Duration(hours: 2);
      default:
        return const Duration(minutes: 30);
    }
  }

  /// Приоритет уведомления для выбора канала
  NotificationPriority get priority {
    switch (this) {
      case NotificationType.heatWarning:
      case NotificationType.workoutReminder:
        return NotificationPriority.urgent;
      case NotificationType.dailyReport:
        return NotificationPriority.normal;
      default:
        return NotificationPriority.high;
    }
  }
}

/// Приоритеты уведомлений
enum NotificationPriority {
  urgent, // Максимальный приоритет
  high, // Высокий приоритет
  normal, // Обычный приоритет
  low, // Низкий приоритет (тихие)
}
