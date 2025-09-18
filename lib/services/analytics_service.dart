// lib/services/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'devtodev_analytics_service.dart';

/// Сервис для работы с аналитикой (Firebase + DevToDev).
/// Централизует все события и параметры для отслеживания
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final DevToDevAnalyticsService _devToDev = DevToDevAnalyticsService();

  Future<void> _setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (error) {
      if (kDebugMode) {
        print('❌ Error setting Firebase userId: $error');
      }
    }

    if (userId == null) {
      await _devToDev.clearUserId();
    } else {
      await _devToDev.setUserId(userId);
    }
  }

  Future<void> _setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (error) {
      if (kDebugMode) {
        print('❌ Error setting Firebase user property $name: $error');
      }
    }

    await _devToDev.setUserProperty(name, value);
  }

  Future<void> _logScreenViewInternal({
    required String screenName,
    String? screenClass,
  }) async {
    final resolvedScreenClass = screenClass ?? screenName;

    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: resolvedScreenClass,
      );
    } catch (error) {
      if (kDebugMode) {
        print('❌ Error logging Firebase screen: $screenName ($error)');
      }
    }

    await _devToDev.logScreenView(
      screenName: screenName,
      screenClass: resolvedScreenClass,
    );
  }

  Future<void> _logEventInternal({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    final Map<String, Object>? firebaseParams = parameters?.map(
      (key, value) => MapEntry(key, value as Object),
    );

    try {
      await _analytics.logEvent(
        name: name,
        parameters: firebaseParams,
      );
    } catch (error) {
      if (kDebugMode) {
        print('❌ Error logging Firebase event $name: $error');
      }
    }

    await _devToDev.logEvent(name: name, parameters: parameters);
  }

  /// Получить observer для навигации (если будете использовать)
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Инициализация сервиса
  Future<void> initialize() async {
    if (kDebugMode) {
      print('📊 Analytics Service initialized');
    }

    await _devToDev.initialize();

    // Устанавливаем базовые свойства пользователя
    await setDefaultUserProperties();
  }

  /// Установка базовых свойств пользователя
  Future<void> setDefaultUserProperties() async {
    // Эти свойства помогут сегментировать пользователей
    await _setUserId(null); // Пока не устанавливаем
  }

  // ==================== USER PROPERTIES ====================
  
  /// Установить режим диеты
  Future<void> setDietMode(String mode) async {
    await _setUserProperty('diet_mode', mode);
  }

  /// Установить статус подписки
  Future<void> setProStatus(bool isPro) async {
    await _setUserProperty('is_pro', isPro.toString());
  }

  /// Установить статус уведомлений
  Future<void> setNotificationStatus(bool enabled) async {
    await _setUserProperty('notifications_enabled', enabled.toString());
  }

  /// Установить страну пользователя
  Future<void> setUserCountry(String countryCode) async {
    await _setUserProperty('country', countryCode);
  }

  // ==================== SCREEN VIEW EVENTS ====================
  
  /// Универсальный метод для логирования просмотра экрана
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _logScreenViewInternal(
      screenName: screenName,
      screenClass: screenClass,
    );

    if (kDebugMode) {
      print('📊 Screen view: $screenName');
    }
  }

  /// Общий метод для логирования событий
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _logEventInternal(name: name, parameters: parameters);

    if (kDebugMode) {
      print('📊 Event: $name');
      if (parameters != null) {
        print('   Parameters: $parameters');
      }
    }
  }

  // ==================== NOTIFICATION EVENTS ====================
  
  /// Уведомление запланировано
  Future<void> logNotificationScheduled({
    required String type,
    required DateTime scheduledTime,
    int? delayMinutes,
  }) async {
    await logEvent(
      name: 'notification_scheduled',
      parameters: {
        'notification_type': type,
        'scheduled_hour': scheduledTime.hour,
        'delay_minutes': delayMinutes ?? 0,
        'day_of_week': scheduledTime.weekday,
      },
    );
    
    if (kDebugMode) {
      print('📊 Event: notification_scheduled - $type at ${scheduledTime.hour}:${scheduledTime.minute}');
    }
  }

  /// Уведомление отправлено
  Future<void> logNotificationSent({
    required String type,
    bool isScheduled = false,
  }) async {
    await logEvent(
      name: 'notification_sent',
      parameters: {
        'notification_type': type,
        'is_scheduled': isScheduled,
        'hour': DateTime.now().hour,
      },
    );
    
    if (kDebugMode) {
      print('📊 Event: notification_sent - $type');
    }
  }

  /// Уведомление открыто
  Future<void> logNotificationOpened({
    required String type,
    String? action,
  }) async {
    await logEvent(
      name: 'notification_opened',
      parameters: {
        'notification_type': type,
        'action': action ?? 'none',
      },
    );
  }

  /// Ошибка уведомления
  Future<void> logNotificationError({
    required String type,
    required String error,
  }) async {
    await logEvent(
      name: 'notification_error',
      parameters: {
        'notification_type': type,
        'error_message': error.substring(0, 100), // Ограничиваем длину
      },
    );
  }

  /// Дубль уведомления обнаружен
  Future<void> logNotificationDuplicate({
    required String type,
    required int count,
  }) async {
    await logEvent(
      name: 'notification_duplicate',
      parameters: {
        'notification_type': type,
        'duplicate_count': count,
      },
    );
    
    if (kDebugMode) {
      print('⚠️ Duplicate notification detected: $type x$count');
    }
  }

  // ==================== CORE TRACKING EVENTS ====================
  
  /// Логирование воды
  Future<void> logWaterIntake({
    required int amount,
    required String source,
  }) async {
    await logEvent(
      name: 'water_logged',
      parameters: {
        'amount_ml': amount,
        'source': source, // 'quick', 'manual', 'preset'
        'hour': DateTime.now().hour,
      },
    );
  }

  /// Логирование электролитов
  Future<void> logElectrolyteIntake({
    required String type,
    required int amount,
  }) async {
    await logEvent(
      name: 'electrolyte_logged',
      parameters: {
        'type': type, // 'sodium', 'potassium', 'magnesium'
        'amount_mg': amount,
      },
    );
  }

  /// Логирование кофе
  Future<void> logCoffeeIntake({
    required int cups,
  }) async {
    await logEvent(
      name: 'coffee_logged',
      parameters: {
        'cups': cups,
        'hour': DateTime.now().hour,
      },
    );
  }

  /// Логирование алкоголя
  Future<void> logAlcoholIntake({
    required double standardDrinks,
    required String type,
  }) async {
    await logEvent(
      name: 'alcohol_logged',
      parameters: {
        'standard_drinks': standardDrinks,
        'type': type, // 'beer', 'wine', 'spirits', 'cocktail'
        'hour': DateTime.now().hour,
      },
    );
  }

  // ==================== GOAL & PROGRESS EVENTS ====================
  
  /// Цель достигнута
  Future<void> logGoalReached({
    required String goalType,
    required double percentage,
  }) async {
    await logEvent(
      name: 'daily_goal_reached',
      parameters: {
        'goal_type': goalType, // 'water', 'sodium', 'potassium', 'magnesium'
        'percentage': percentage.round(),
      },
    );
  }

  /// Изменение HRI статуса
  Future<void> logHRIStatusChange({
    required int fromValue,
    required int toValue,
    required String status,
  }) async {
    await logEvent(
      name: 'hri_status_changed',
      parameters: {
        'from_value': fromValue,
        'to_value': toValue,
        'status': status, // 'green', 'yellow', 'red'
        'direction': toValue > fromValue ? 'worse' : 'better',
      },
    );
  }

  /// Статус гидратации
  Future<void> logHydrationStatus({
    required String status,
  }) async {
    await logEvent(
      name: 'hydration_status',
      parameters: {
        'status': status, // 'normal', 'dehydrated', 'diluted', 'low_salt'
        'hour': DateTime.now().hour,
      },
    );
  }

  // ==================== SUBSCRIPTION EVENTS ====================
  
  /// Показ paywall
  Future<void> logPaywallShown({
    required String source,
    String? variant,
  }) async {
    await logEvent(
      name: 'paywall_shown',
      parameters: {
        'source': source, // 'onboarding', 'settings', 'feature_gate'
        'variant': variant ?? 'default',
      },
    );
  }

  /// Закрытие paywall
  Future<void> logPaywallDismissed({
    required String source,
  }) async {
    await logEvent(
      name: 'paywall_dismissed',
      parameters: {
        'source': source,
      },
    );
  }

  /// Начало подписки
  Future<void> logSubscriptionStarted({
    required String product,
    required bool isTrial,
  }) async {
    await logEvent(
      name: 'subscription_started',
      parameters: {
        'product': product, // 'monthly', 'annual', 'lifetime'
        'is_trial': isTrial,
      },
    );
  }

  /// PRO функция заблокирована
  Future<void> logProFeatureGate({
    required String feature,
  }) async {
    await logEvent(
      name: 'pro_feature_gate_hit',
      parameters: {
        'feature': feature, // 'smart_reminders', 'csv_export', etc
      },
    );
  }

  // ==================== ENGAGEMENT EVENTS ====================
  
  /// Просмотр отчета
  Future<void> logReportViewed({
    required String type,
  }) async {
    await logEvent(
      name: 'report_viewed',
      parameters: {
        'type': type, // 'daily', 'weekly'
      },
    );
  }

  /// Экспорт CSV
  Future<void> logCSVExported() async {
    await logEvent(
      name: 'csv_exported',
      parameters: {
        'date': DateTime.now().toIso8601String().split('T')[0],
      },
    );
  }

  /// Изменение настроек
  Future<void> logSettingsChanged({
    required String setting,
    required dynamic value,
  }) async {
    await logEvent(
      name: 'settings_changed',
      parameters: {
        'setting': setting,
        'value': value.toString(),
      },
    );
  }

  /// Изменение режима диеты
  Future<void> logDietModeChanged({
    required String from,
    required String to,
  }) async {
    await logEvent(
      name: 'diet_mode_changed',
      parameters: {
        'from': from,
        'to': to,
      },
    );
    
    // Также обновляем user property
    await setDietMode(to);
  }

  // ==================== ONBOARDING EVENTS ====================
  
  /// Начало онбординга
  Future<void> logOnboardingStart() async {
    await logEvent(name: 'onboarding_start');
  }

  /// Завершение онбординга
  Future<void> logOnboardingComplete() async {
    await logEvent(name: 'onboarding_complete');
  }

  /// Пропуск онбординга
  Future<void> logOnboardingSkip({
    required int step,
  }) async {
    await logEvent(
      name: 'onboarding_skip',
      parameters: {
        'step': step,
      },
    );
  }

  // ==================== APP LIFECYCLE ====================
  
  /// Открытие приложения
  Future<void> logAppOpen() async {
    await logEvent(name: 'app_open');
  }

  /// Сессия приложения
  Future<void> logSession({
    required int durationSeconds,
  }) async {
    await logEvent(
      name: 'session',
      parameters: {
        'duration_seconds': durationSeconds,
      },
    );
  }

  // ==================== DEBUG HELPERS ====================
  
  /// Тестовое событие для проверки
  Future<void> logTestEvent() async {
    await logEvent(
      name: 'test_event',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'debug': kDebugMode,
      },
    );
    
    if (kDebugMode) {
      print('📊 Test event sent to Analytics');
    }
  }

  /// Включить/выключить сбор аналитики
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
    await _devToDev.setTrackingEnabled(enabled);
  }
  
  // ==================== ACHIEVEMENT EVENTS ====================

  /// Достижение разблокировано
  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
    required String category,
    required int rewardPoints,
  }) async {
    await logEvent(
      name: 'achievement_unlocked',
      parameters: {
        'achievement_id': achievementId,
        'achievement_name': achievementName,
        'category': category,
        'reward_points': rewardPoints,
      },
    );
    
    if (kDebugMode) {
      print('📊 Achievement unlocked: $achievementName');
    }
  }

  /// Просмотр экрана достижений
  Future<void> logAchievementsScreenView() async {
    await _logScreenViewInternal(
      screenName: 'achievements',
      screenClass: 'AchievementsScreen',
    );

    if (kDebugMode) {
      print('📊 Achievements screen viewed');
    }
  }

  /// Просмотр деталей достижения (упрощенная версия для achievements_screen.dart)
  Future<void> logAchievementViewed({
    required String achievementId,
    required String achievementName,
    required String category,
    required bool isUnlocked,
  }) async {
    await logEvent(
      name: 'achievement_details_viewed',
      parameters: {
        'achievement_id': achievementId,
        'achievement_name': achievementName,
        'category': category,
        'is_unlocked': isUnlocked,
      },
    );
    
    if (kDebugMode) {
      print('📊 Achievement viewed: $achievementName');
    }
  }

  /// Просмотр деталей достижения (полная версия)
  Future<void> logAchievementDetailsViewed({
    required String achievementId,
    required String achievementName,
    required bool isUnlocked,
  }) async {
    await logEvent(
      name: 'achievement_details_viewed',
      parameters: {
        'achievement_id': achievementId,
        'achievement_name': achievementName,
        'is_unlocked': isUnlocked,
      },
    );
  }
} // закрывающая скобка класса AnalyticsService
