// lib/services/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Сервис для работы с аналитикой Firebase
/// Централизует все события и параметры для отслеживания
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  /// Получить observer для навигации (если будете использовать)
  FirebaseAnalyticsObserver get observer => 
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Инициализация сервиса
  Future<void> initialize() async {
    if (kDebugMode) {
      print('📊 Analytics Service initialized');
    }
    
    // Устанавливаем базовые свойства пользователя
    await setDefaultUserProperties();
  }

  /// Установка базовых свойств пользователя
  Future<void> setDefaultUserProperties() async {
    try {
      // Эти свойства помогут сегментировать пользователей
      await _analytics.setUserId(id: null); // Пока не устанавливаем
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error setting user properties: $e');
      }
    }
  }

  // ==================== USER PROPERTIES ====================
  
  /// Установить режим диеты
  Future<void> setDietMode(String mode) async {
    await _analytics.setUserProperty(name: 'diet_mode', value: mode);
  }

  /// Установить статус подписки
  Future<void> setProStatus(bool isPro) async {
    await _analytics.setUserProperty(name: 'is_pro', value: isPro.toString());
  }

  /// Установить статус уведомлений
  Future<void> setNotificationStatus(bool enabled) async {
    await _analytics.setUserProperty(name: 'notifications_enabled', value: enabled.toString());
  }

  /// Установить страну пользователя
  Future<void> setUserCountry(String countryCode) async {
    await _analytics.setUserProperty(name: 'country', value: countryCode);
  }

  // ==================== NOTIFICATION EVENTS ====================
  
  /// Уведомление запланировано
  Future<void> logNotificationScheduled({
    required String type,
    required DateTime scheduledTime,
    int? delayMinutes,
  }) async {
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
      name: 'report_viewed',
      parameters: {
        'type': type, // 'daily', 'weekly'
      },
    );
  }

  /// Экспорт CSV
  Future<void> logCSVExported() async {
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(
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
    await _analytics.logEvent(name: 'onboarding_start');
  }

  /// Завершение онбординга
  Future<void> logOnboardingComplete() async {
    await _analytics.logEvent(name: 'onboarding_complete');
  }

  /// Пропуск онбординга
  Future<void> logOnboardingSkip({
    required int step,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_skip',
      parameters: {
        'step': step,
      },
    );
  }

  // ==================== APP LIFECYCLE ====================
  
  /// Открытие приложения
  Future<void> logAppOpen() async {
    await _analytics.logEvent(name: 'app_open');
  }

  /// Сессия приложения
  Future<void> logSession({
    required int durationSeconds,
  }) async {
    await _analytics.logEvent(
      name: 'session',
      parameters: {
        'duration_seconds': durationSeconds,
      },
    );
  }

  // ==================== DEBUG HELPERS ====================
  
  /// Тестовое событие для проверки
  Future<void> logTestEvent() async {
    await _analytics.logEvent(
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
  }
}