// lib/services/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:hydracoach/utils/app_logger.dart';

import 'devtodev_analytics_service.dart';
import 'appsflyer_service.dart';
import 'purchase_connector_service.dart';

/// Сервис для работы с аналитикой (Firebase + DevToDev).
/// Централизует все события и параметры для отслеживания
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _firebase = FirebaseAnalytics.instance;
  final DevToDevAnalyticsService _devToDev = DevToDevAnalyticsService();
  final AppsFlyerService _appsFlyer = AppsFlyerService();

  late final List<_AnalyticsBackend> _backends = <_AnalyticsBackend>[
    _FirebaseAnalyticsBackend(_firebase),
    _DevToDevAnalyticsBackend(_devToDev),
    _AppsFlyerAnalyticsBackend(_appsFlyer),
  ];

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    for (final backend in _backends) {
      try {
        await backend.initialize();
      } catch (e) {
        logger.e('Error initializing analytics backend: $e');
      }
    }

    _isInitialized = true;

    // Логируем AppsFlyer UID для отладки
    if (kDebugMode) {
      await _logDebugIds();
    }
  }

  /// Логирование ID для отладки в AppsFlyer
  Future<void> _logDebugIds() async {
    try {
      final appsFlyerUID = await _appsFlyer.getAppsFlyerUID();
      if (appsFlyerUID != null) {
        logger.d('📱 AppsFlyer UID: $appsFlyerUID');
        logger.d('🔍 Используйте этот ID в SDK Integration Test:');
        logger.d(
          '   https://dev.appsflyer.com/hc/docs/testing-flutter#sdk-integration-test',
        );
      }

      // Для Android также пытаемся получить Advertising ID
      if (defaultTargetPlatform == TargetPlatform.android) {
        logger.d('💡 Для поиска событий в Raw Data Export:');
        logger.d('   1. Откройте настройки Android → Google → Реклама');
        logger.d('   2. Скопируйте Advertising ID (GAID)');
        logger.d('   3. Используйте его для фильтрации в Raw Data Export');
      }
    } catch (e) {
      logger.d('❌ Ошибка получения debug IDs: $e');
    }
  }

  Future<void> checkAndEnableAppsFlyer() async {
    if (kDebugMode) {
      logger.d('🔧 НАЧИНАЕМ checkAndEnableAppsFlyer()...');
    }

    try {
      // 🔥 КРИТИЧЕСКАЯ ПОСЛЕДОВАТЕЛЬНОСТЬ для Purchase Connector:
      // 1. initialize() - инициализирует SDK с manualStart: true (НЕ запускает!)
      if (kDebugMode) {
        logger.d('🔧 Шаг 1: Инициализация AppsFlyer SDK...');
      }
      await _appsFlyer.initialize();
      if (kDebugMode) {
        logger.d(
          '✅ AppsFlyer инициализирован (но НЕ запущен из-за manualStart: true)',
        );
      }

      // 2. startSDK() - запускает SDK ПОСЛЕ обработки согласий пользователя
      if (kDebugMode) {
        logger.d('🔧 Шаг 2: Запуск AppsFlyer SDK...');
      }
      await _appsFlyer.startSDK();
      if (kDebugMode) {
        logger.d('🚀 AppsFlyer SDK запущен после согласий пользователя');
        logger.d(
          '✅ КРИТИЧЕСКАЯ ПОСЛЕДОВАТЕЛЬНОСТЬ для Purchase Connector выполнена успешно!',
        );
      }

      // 3. Инициализируем Purchase Connector для автоматической генерации af_ars_ событий
      if (kDebugMode) {
        logger.d('🔧 Шаг 3: Инициализация Purchase Connector...');
      }

      // Ждем 1 секунду после запуска SDK (рекомендация AppsFlyer)
      await Future.delayed(const Duration(seconds: 1));

      final purchaseConnector = PurchaseConnectorService();
      await purchaseConnector.initializeAndStart();

      if (kDebugMode) {
        logger.d(
          '🎯 Purchase Connector запущен - события af_ars_ будут генерироваться автоматически',
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        logger.d('❌ Error enabling AppsFlyer: $e');
        logger.d('❌ StackTrace: $stackTrace');
      }
    }

    if (kDebugMode) {
      logger.d('🔧 ЗАВЕРШИЛИ checkAndEnableAppsFlyer()');
    }
  }

  Future<void> _setUserId(String? userId) async {
    await _broadcast((backend) => backend.setUserId(userId));
  }

  Future<void> _setUserProperty(String name, String value) async {
    await _broadcast((backend) => backend.setUserProperty(name, value));
  }

  Future<void> _logScreenViewInternal({
    required String screenName,
    String? screenClass,
  }) async {
    final resolvedScreenClass = screenClass ?? screenName;

    await _broadcast(
      (backend) => backend.logScreenView(
        screenName: screenName,
        screenClass: resolvedScreenClass,
      ),
    );
  }

  Future<void> _logEventInternal({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _broadcast(
      (backend) => backend.logEvent(name: name, parameters: parameters),
    );
  }

  Future<void> _broadcast(
    Future<void> Function(_AnalyticsBackend backend) action,
  ) async {
    await Future.wait(_backends.map(action));
  }

  /// Получить observer для навигации (если будете использовать)
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _firebase);

  /// Инициализация сервиса
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    for (final backend in _backends) {
      await backend.initialize();
    }

    // Устанавливаем базовые свойства пользователя
    await setDefaultUserProperties();

    if (kDebugMode) {
      logger.d('📊 Analytics Service initialized');
    }
  }

  // AppsFlyer methods removed - SDK not currently integrated
  // These methods can be restored when AppsFlyer SDK is added back

  /// Set default user properties
  Future<void> setDefaultUserProperties() async {
    // Эти свойства помогут сегментировать пользователей
    await _setUserId(null); // Пока не устанавливаем
  }

  // ==================== UNIFIED LOGGING ====================

  /// Main unified logging method - sends to Firebase Analytics
  Future<void> log(String eventName, [Map<String, dynamic>? parameters]) async {
    // Send to Firebase Analytics
    await logEvent(name: eventName, parameters: parameters);
  }

  // ==================== USER PROPERTIES ====================

  /// Set diet mode
  Future<void> setDietMode(String mode) async {
    await _setUserProperty('diet_mode', mode);
  }

  /// Set subscription status
  Future<void> setProStatus(bool isPro) async {
    await _setUserProperty('is_pro', isPro.toString());
  }

  /// Set notification status
  Future<void> setNotificationStatus(bool enabled) async {
    await _setUserProperty('notifications_enabled', enabled.toString());
  }

  /// Set user country
  Future<void> setUserCountry(String countryCode) async {
    await _setUserProperty('country', countryCode);
  }

  // ==================== SCREEN VIEW EVENTS ====================

  /// Universal method for logging screen views
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _logScreenViewInternal(
      screenName: screenName,
      screenClass: screenClass,
    );

    if (kDebugMode) {
      logger.d('📊 Screen view: $screenName');
    }
  }

  /// General method for logging events (Firebase only)
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _logEventInternal(name: name, parameters: parameters);

    if (kDebugMode) {
      logger.d('📊 Firebase Event: $name');
      if (parameters != null) {
        logger.d('   Parameters: $parameters');
      }
    }
  }

  // ==================== SUBSCRIPTION EVENTS ====================

  /// Log subscription purchase - CRITICAL FOR APPSFLYER LIVE EVENTS
  Future<void> logSubscriptionPurchased({
    required String productId,
    required double price,
    required String currency,
    required String transactionId,
  }) async {
    // Определяем тип события в зависимости от продукта
    final eventName = productId.contains('trial')
        ? 'af_start_trial'
        : 'af_subscribe';

    // Отправляем через AppsFlyer SDK для отображения в Live Events
    await _appsFlyer.logEvent(
      eventName: eventName,
      eventValues: {
        'af_revenue': price,
        'af_currency': currency,
        'af_quantity': 1,
        'af_content_id': productId,
        'af_order_id': transactionId,
        'af_validation_method': 'purchase_connector',
      },
    );

    // Также логируем в Firebase для аналитики
    await logEvent(
      name: eventName,
      parameters: {
        'product_id': productId,
        'price': price,
        'currency': currency,
        'transaction_id': transactionId,
      },
    );

    if (kDebugMode) {
      logger.d('💰 Subscription purchased: $productId');
      logger.d('   Event: $eventName');
      logger.d('   Price: $price $currency');
      logger.d('   Transaction: $transactionId');
    }
  }

  // ==================== NOTIFICATION EVENTS ====================

  /// Notification scheduled
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
      logger.d(
        '📊 Event: notification_scheduled - $type at ${scheduledTime.hour}:${scheduledTime.minute}',
      );
    }
  }

  /// Notification sent
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
      logger.d('📊 Event: notification_sent - $type');
    }
  }

  /// Notification opened
  Future<void> logNotificationOpened({
    required String type,
    String? action,
  }) async {
    await logEvent(
      name: 'notification_opened',
      parameters: {'notification_type': type, 'action': action ?? 'none'},
    );
  }

  /// Notification error
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

  /// Duplicate notification detected
  Future<void> logNotificationDuplicate({
    required String type,
    required int count,
  }) async {
    await logEvent(
      name: 'notification_duplicate',
      parameters: {'notification_type': type, 'duplicate_count': count},
    );

    if (kDebugMode) {
      logger.d('⚠️ Duplicate notification detected: $type x$count');
    }
  }

  // ==================== CORE TRACKING EVENTS ====================

  /// Log water intake - IMPORTANT EVENT FOR APPSFLYER
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

  /// Log electrolyte intake
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

  /// Log coffee intake
  Future<void> logCoffeeIntake({required int cups}) async {
    await logEvent(
      name: 'coffee_logged',
      parameters: {'cups': cups, 'hour': DateTime.now().hour},
    );
  }

  /// Log alcohol intake
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

  /// Goal reached - IMPORTANT EVENT FOR APPSFLYER
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

  /// Water goal milestone events - ВАЖНЫЕ СОБЫТИЯ ДЛЯ КОГОРТНОГО АНАЛИЗА
  /// Отправляются ОДИН РАЗ при первом достижении milestone
  Future<void> logWaterGoalMilestone({required int totalDays}) async {
    // Определяем название события в зависимости от количества дней
    String eventName;
    switch (totalDays) {
      case 1:
        eventName = 'water_goal_100_first'; // Первый раз достиг 100%
        break;
      case 2:
        eventName = 'water_goal_100_2days'; // 2 дня с 100%
        break;
      case 3:
        eventName = 'water_goal_100_3days'; // 3 дня с 100%
        break;
      case 5:
        eventName = 'water_goal_100_5days'; // 5 дней с 100%
        break;
      case 7:
        eventName = 'water_goal_100_7days'; // 7 дней с 100%
        break;
      case 10:
        eventName = 'water_goal_100_10days'; // 10 дней с 100%
        break;
      case 14:
        eventName = 'water_goal_100_14days'; // 14 дней с 100%
        break;
      default:
        return; // Не логируем промежуточные значения
    }

    await logEvent(
      name: eventName,
      parameters: {'total_days_with_100_percent': totalDays},
    );
  }

  /// HRI status change
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

  /// Hydration status
  Future<void> logHydrationStatus({required String status}) async {
    await logEvent(
      name: 'hydration_status',
      parameters: {
        'status': status, // 'normal', 'dehydrated', 'diluted', 'low_salt'
        'hour': DateTime.now().hour,
      },
    );
  }

  // ==================== SUBSCRIPTION EVENTS - CRITICAL FOR APPSFLYER ROI360 ====================

  /// Paywall shown
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

  /// Выбор плана на paywall
  Future<void> logPaywallPlanSelected({
    required String plan,
    required String source,
    String? variant,
  }) async {
    await logEvent(
      name: 'paywall_plan_selected',
      parameters: {
        'plan': plan,
        'source': source,
        'variant': variant ?? 'default',
      },
    );
  }

  /// Переключение триала на paywall
  Future<void> logPaywallTrialToggle({
    required String source,
    required bool enabled,
  }) async {
    await logEvent(
      name: 'paywall_trial_toggled',
      parameters: {'source': source, 'enabled': enabled ? 'true' : 'false'},
    );
  }

  /// Log когда пользователь начал free trial
  Future<void> logTrialStarted({
    required String product,
    required int trialDuration,
  }) async {
    await logEvent(
      name: 'trial_started',
      parameters: {
        'product': product,
        'trial_duration_days': trialDuration,
        'source': 'app',
      },
    );
  }

  /// Закрытие paywall
  Future<void> logPaywallDismissed({
    required String source,
    String? reason,
  }) async {
    await logEvent(
      name: 'paywall_dismissed',
      parameters: {'source': source, if (reason != null) 'reason': reason},
    );
  }

  /// Попытка покупки подписки
  Future<void> logSubscriptionPurchaseAttempt({
    required String product,
    required String source,
    bool trialEnabled = false,
  }) async {
    await logEvent(
      name: 'subscription_purchase_attempt',
      parameters: {
        'product': product,
        'source': source,
        'trial_enabled': trialEnabled ? 'true' : 'false',
      },
    );
  }

  /// Результат покупки подписки
  Future<void> logSubscriptionPurchaseResult({
    required String product,
    required String source,
    required bool success,
    bool trialEnabled = false,
    String? error,
  }) async {
    await logEvent(
      name: 'subscription_purchase_result',
      parameters: {
        'product': product,
        'source': source,
        'success': success ? 'true' : 'false',
        'trial_enabled': trialEnabled ? 'true' : 'false',
        if (error != null && error.isNotEmpty) 'error': error.substring(0, 80),
      },
    );
  }

  /// Попытка восстановления подписки
  Future<void> logSubscriptionRestoreAttempt({required String source}) async {
    await logEvent(
      name: 'subscription_restore_attempt',
      parameters: {'source': source},
    );
  }

  /// Результат восстановления подписки
  Future<void> logSubscriptionRestoreResult({
    required String source,
    required bool success,
  }) async {
    await logEvent(
      name: 'subscription_restore_result',
      parameters: {'source': source, 'success': success ? 'true' : 'false'},
    );
  }

  /// PRO функция заблокирована
  Future<void> logProFeatureGate({required String feature}) async {
    await logEvent(
      name: 'pro_feature_gate_hit',
      parameters: {
        'feature': feature, // 'smart_reminders', 'csv_export', etc
      },
    );
  }

  // ==================== ENGAGEMENT EVENTS ====================

  /// Report viewed
  Future<void> logReportViewed({required String type}) async {
    await logEvent(
      name: 'report_viewed',
      parameters: {
        'type': type, // 'daily', 'weekly'
      },
    );
  }

  /// CSV exported
  Future<void> logCSVExported() async {
    await logEvent(
      name: 'csv_exported',
      parameters: {'date': DateTime.now().toIso8601String().split('T')[0]},
    );
  }

  /// Settings changed
  Future<void> logSettingsChanged({
    required String setting,
    required dynamic value,
  }) async {
    await logEvent(
      name: 'settings_changed',
      parameters: {'setting': setting, 'value': value.toString()},
    );
  }

  /// Diet mode changed
  Future<void> logDietModeChanged({
    required String from,
    required String to,
  }) async {
    await logEvent(
      name: 'diet_mode_changed',
      parameters: {'from': from, 'to': to},
    );

    // Also update user property
    await setDietMode(to);
  }

  // ==================== ONBOARDING EVENTS ====================

  /// Onboarding start
  Future<void> logOnboardingStart() async {
    await logEvent(name: 'onboarding_start');

    // Отправляем событие старта туториала в DevToDev
    // -1 означает начало туториала/онбординга
    await _devToDev.tutorial(-1);
  }

  /// Просмотр шага онбординга
  Future<void> logOnboardingStepViewed({
    required String stepId,
    required int stepIndex,
    String? screenName,
  }) async {
    await logEvent(
      name: 'onboarding_step_viewed',
      parameters: {
        'step_id': stepId,
        'step_index': stepIndex,
        if (screenName != null) 'screen_name': screenName,
      },
    );

    await logScreenView(
      screenName: screenName ?? stepId,
      screenClass: 'Onboarding$stepId',
    );
  }

  /// Завершение шага онбординга
  Future<void> logOnboardingStepCompleted({
    required String stepId,
    required int stepIndex,
  }) async {
    await logEvent(
      name: 'onboarding_step_completed',
      parameters: {'step_id': stepId, 'step_index': stepIndex},
    );

    // Отправляем прогресс туториала в DevToDev
    // Значения 1..n означают завершенные этапы туториала
    // stepIndex 0 = welcome (не считаем как шаг туториала)
    // stepIndex 1+ = реальные шаги настройки
    if (stepIndex > 0) {
      await _devToDev.tutorial(stepIndex);
    }
  }

  /// Выбор опции на онбординге
  Future<void> logOnboardingOptionSelected({
    required String stepId,
    required String option,
    required String value,
  }) async {
    await logEvent(
      name: 'onboarding_option_selected',
      parameters: {'step_id': stepId, 'option': option, 'value': value},
    );
  }

  /// Onboarding complete
  Future<void> logOnboardingComplete() async {
    await logEvent(name: 'onboarding_complete');

    // Отправляем событие завершения туториала в DevToDev
    // -2 означает что туториал успешно завершен
    await _devToDev.tutorial(-2);
  }

  /// Onboarding skip
  Future<void> logOnboardingSkip({required int step}) async {
    await logEvent(name: 'onboarding_skip', parameters: {'step': step});
  }

  /// Сохранение профиля пользователя на финальном шаге онбординга
  Future<void> logOnboardingProfileSaved({
    required double weightKg,
    required String units,
    required String dietMode,
    required bool fastingEnabled,
  }) async {
    await logEvent(
      name: 'onboarding_profile_saved',
      parameters: {
        'weight_kg': weightKg,
        'units': units,
        'diet_mode': dietMode,
        'fasting_enabled': fastingEnabled,
      },
    );
  }

  /// Показ системного запроса разрешений
  Future<void> logPermissionPrompt({
    required String permission,
    required String context,
  }) async {
    await logEvent(
      name: 'permission_prompt',
      parameters: {'permission': permission, 'context': context},
    );
  }

  /// Результат запроса разрешений
  Future<void> logPermissionResult({
    required String permission,
    required String status,
    required String context,
  }) async {
    await logEvent(
      name: 'permission_result',
      parameters: {
        'permission': permission,
        'status': status,
        'context': context,
      },
    );
  }

  // ==================== TUTORIAL EVENTS ====================

  /// Показ туториала первого добавления воды
  Future<void> logFirstIntakeTutorialShown() async {
    await logEvent(name: 'first_intake_tutorial_shown');
  }

  /// Завершение туториала первого добавления воды
  Future<void> logFirstIntakeTutorialCompleted() async {
    await logEvent(name: 'first_intake_tutorial_completed');
  }

  // ==================== APP LIFECYCLE ====================

  /// App opened
  Future<void> logAppOpen() async {
    await logEvent(name: 'app_open');
  }

  /// Session
  Future<void> logSession({required int durationSeconds}) async {
    await logEvent(
      name: 'session',
      parameters: {'duration_seconds': durationSeconds},
    );
  }

  /// Выбор вкладки нижней навигации
  Future<void> logNavigationTabSelected({required String tab}) async {
    await logEvent(name: 'navigation_tab_selected', parameters: {'tab': tab});
  }

  /// Открытие меню быстрого добавления напитков
  Future<void> logQuickAddMenuOpened() async {
    await logEvent(name: 'quick_add_menu_opened');
  }

  // ==================== DEBUG HELPERS ====================

  /// Test event for verification
  Future<void> logTestEvent() async {
    await logEvent(
      name: 'test_event',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
        'debug': kDebugMode,
      },
    );

    if (kDebugMode) {
      logger.d('📊 Test event sent to Analytics');
    }
  }

  /// Enable/disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _broadcast(
      (backend) => backend.setAnalyticsCollectionEnabled(enabled),
    );
  }

  // ==================== ACHIEVEMENT EVENTS ====================

  /// Achievement unlocked
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
      logger.d('📊 Achievement unlocked: $achievementName');
    }
  }

  /// Achievements screen view
  Future<void> logAchievementsScreenView() async {
    await _logScreenViewInternal(
      screenName: 'achievements',
      screenClass: 'AchievementsScreen',
    );

    if (kDebugMode) {
      logger.d('📊 Achievements screen viewed');
    }
  }

  /// Achievement viewed (simplified version for achievements_screen.dart)
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
      logger.d('📊 Achievement viewed: $achievementName');
    }
  }

  /// Achievement details viewed (full version)
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
}

abstract class _AnalyticsBackend {
  Future<void> initialize();

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty(String name, String value);

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  });

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  });

  Future<void> setAnalyticsCollectionEnabled(bool enabled);
}

class _FirebaseAnalyticsBackend implements _AnalyticsBackend {
  _FirebaseAnalyticsBackend(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> initialize() async {
    // Firebase не требует дополнительной инициализации здесь
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (error) {
      if (kDebugMode) {
        logger.d('❌ Error setting Firebase userId: $error');
      }
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (error) {
      if (kDebugMode) {
        logger.d('❌ Error setting Firebase user property $name: $error');
      }
    }
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (error) {
      if (kDebugMode) {
        logger.d('❌ Error logging Firebase screen: $screenName ($error)');
      }
    }
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    final Map<String, Object>? firebaseParams = parameters?.map(
      (key, value) => MapEntry(key, value as Object),
    );

    try {
      await _analytics.logEvent(name: name, parameters: firebaseParams);
    } catch (error) {
      if (kDebugMode) {
        logger.d('❌ Error logging Firebase event $name: $error');
      }
    }
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (error) {
      if (kDebugMode) {
        logger.d('❌ Error toggling Firebase analytics collection: $error');
      }
    }
  }
}

class _DevToDevAnalyticsBackend implements _AnalyticsBackend {
  _DevToDevAnalyticsBackend(this._devToDev);

  final DevToDevAnalyticsService _devToDev;

  @override
  Future<void> initialize() => _devToDev.initialize();

  @override
  Future<void> setUserId(String? userId) async {
    if (userId == null) {
      await _devToDev.clearUserId();
    } else {
      await _devToDev.setUserId(userId);
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    await _devToDev.setUserProperty(name, value);
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    await _devToDev.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _devToDev.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _devToDev.setTrackingEnabled(enabled);
  }
}

class _AppsFlyerAnalyticsBackend implements _AnalyticsBackend {
  _AppsFlyerAnalyticsBackend(this._appsFlyer);

  final AppsFlyerService _appsFlyer;

  @override
  Future<void> initialize() => _appsFlyer.initialize();

  @override
  Future<void> setUserId(String? userId) async {
    if (userId != null) {
      await _appsFlyer.setCustomerUserId(userId);
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    // AppsFlyer doesn't have direct user properties, but we can log custom events
    await _appsFlyer.logEvent(
      eventName: 'user_property_set',
      eventValues: {name: value},
    );
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    await _appsFlyer.logEvent(
      eventName: 'screen_view',
      eventValues: {'screen_name': screenName, 'screen_class': screenClass},
    );
  }

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _appsFlyer.logEvent(eventName: name, eventValues: parameters);
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    // AppsFlyer doesn't have a direct method to disable collection
    // This would need to be handled at SDK initialization level
  }
}
