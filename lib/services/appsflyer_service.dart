import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

import 'appsflyer_config.dart';
import 'purchase_connector_service.dart';

/// Сервис для работы с AppsFlyer SDK.
/// Отслеживает атрибуцию, conversion события и интеграцию с кампаниями.
class AppsFlyerService {
  static final AppsFlyerService _instance = AppsFlyerService._internal();
  factory AppsFlyerService() => _instance;
  AppsFlyerService._internal();

  AppsflyerSdk? _appsflyerSdk;
  bool _isInitialized = false;
  final PurchaseConnectorService _purchaseConnector = PurchaseConnectorService();

  bool get isInitialized => _isInitialized;

  /// Инициализация AppsFlyer SDK
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      final config = _resolveConfig();

      if (!config.isComplete) {
        if (kDebugMode) {
          print('⚠️ AppsFlyer конфигурация неполная, пропускаем инициализацию');
        }
        return;
      }

      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: config.devKey,
        appId: config.appId ?? '', // только для iOS, пустая строка для Android
        showDebug: kDebugMode,
        timeToWaitForATTUserAuthorization: 15, // iOS 14.5+ ATT
        disableAdvertisingIdentifier: false,
        disableCollectASA: false, // Apple Search Ads
      );

      _appsflyerSdk = AppsflyerSdk(options);

      // Настраиваем callbacks
      _appsflyerSdk!.onAppOpenAttribution((data) {
        if (kDebugMode) {
          print('📱 AppsFlyer onAppOpenAttribution: $data');
        }
        _handleDeepLink(data);
      });

      _appsflyerSdk!.onInstallConversionData((data) {
        if (kDebugMode) {
          print('📊 AppsFlyer onInstallConversionData: $data');
        }
        _handleInstallConversion(data);
      });

      _appsflyerSdk!.onDeepLinking((data) {
        if (kDebugMode) {
          print('🔗 AppsFlyer onDeepLinking: $data');
        }
        _handleDeepLink(data.deepLink?.clickEvent);
      });

      // Инициализируем SDK
      await _appsflyerSdk!.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ AppsFlyer SDK инициализирован');
        print('   Dev Key: ${config.devKey}');
        print('   Bundle ID: ${config.bundleId}');
        if (config.appId != null) {
          print('   App ID: ${config.appId}');
        }
      }

      // Запускаем Purchase Connector с задержкой 1 секунда после AppsFlyer SDK
      // Это критически важно для корректной работы Purchase Connector
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          await _purchaseConnector.initializeAndStart();
          if (kDebugMode) {
            print('🎯 Purchase Connector запущен успешно');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Ошибка запуска Purchase Connector: $e');
          }
        }
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации AppsFlyer: $error');
        print(stackTrace);
      }
    }
  }

  /// Логирование событий в AppsFlyer
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? eventValues,
  }) async {
    if (!_isInitialized || _appsflyerSdk == null) {
      if (kDebugMode) {
        print('⚠️ AppsFlyer не инициализирован, событие пропущено: $eventName');
      }
      return;
    }

    try {
      await _appsflyerSdk!.logEvent(eventName, eventValues ?? {});

      if (kDebugMode) {
        print('📊 AppsFlyer Event: $eventName');
        if (eventValues != null && eventValues.isNotEmpty) {
          print('   Parameters: $eventValues');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка отправки AppsFlyer события $eventName: $error');
      }
    }
  }

  /// Получение AppsFlyer UID
  Future<String?> getAppsFlyerUID() async {
    if (!_isInitialized || _appsflyerSdk == null) {
      return null;
    }

    try {
      return await _appsflyerSdk!.getAppsFlyerUID();
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка получения AppsFlyer UID: $error');
      }
      return null;
    }
  }

  /// Установка дополнительных данных пользователя
  Future<void> setCustomerUserId(String customerId) async {
    if (!_isInitialized || _appsflyerSdk == null) {
      return;
    }

    try {
      _appsflyerSdk!.setCustomerUserId(customerId);

      if (kDebugMode) {
        print('👤 AppsFlyer Customer ID установлен: $customerId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка установки Customer ID: $error');
      }
    }
  }

  // ==================== CONVERSION EVENTS ====================

  /// Завершенная покупка подписки с IAP валидацией
  Future<void> logPurchase({
    required String product,
    required double revenue,
    required String currency,
    String? orderId,
    String? purchaseToken,
    String? transactionId,
    Map<String, dynamic>? additionalParams,
  }) async {
    final eventValues = {
      'af_revenue': revenue,
      'af_currency': currency,
      'af_product_id': product,
      if (orderId != null) 'af_order_id': orderId,
      if (purchaseToken != null) 'af_purchase_token': purchaseToken,
      if (transactionId != null) 'af_transaction_id': transactionId,
      ...?additionalParams,
    };

    await logEvent(
      eventName: 'af_purchase',
      eventValues: eventValues,
    );
  }

  /// Валидация покупки через AppsFlyer (Android)
  /// DEPRECATED: Используется Purchase Connector для автоматической валидации
  Future<void> validateAndLogAndroidPurchase({
    required String productId,
    required String purchaseToken,
    required double price,
    required String currency,
    Map<String, dynamic>? additionalData,
  }) async {
    if (kDebugMode) {
      print('⚠️ validateAndLogAndroidPurchase deprecated - используйте Purchase Connector');
      print('   Product: $productId, Price: $price $currency');
    }

    // Purchase Connector автоматически обрабатывает валидацию
    // Этот метод оставлен для совместимости, но не используется
  }

  /// Валидация покупки через AppsFlyer (iOS)
  /// DEPRECATED: Используется Purchase Connector для автоматической валидации
  Future<void> validateAndLogIOSPurchase({
    required String productId,
    required String transactionId,
    required double price,
    required String currency,
    Map<String, dynamic>? additionalData,
  }) async {
    if (kDebugMode) {
      print('⚠️ validateAndLogIOSPurchase deprecated - используйте Purchase Connector');
      print('   Product: $productId, Price: $price $currency');
    }

    // Purchase Connector автоматически обрабатывает валидацию
    // Этот метод оставлен для совместимости, но не используется
  }

  /// Завершенная регистрация
  Future<void> logCompleteRegistration({
    String? method,
  }) async {
    await logEvent(
      eventName: 'af_complete_registration',
      eventValues: {
        if (method != null) 'af_registration_method': method,
      },
    );
  }

  /// Завершенное руководство/onboarding
  Future<void> logCompleteTutorial() async {
    await logEvent(eventName: 'af_tutorial_completion');
  }

  /// Достижение уровня (можно использовать для прогресса в гидратации)
  Future<void> logLevelAchieved({
    required int level,
    String? description,
  }) async {
    await logEvent(
      eventName: 'af_level_achieved',
      eventValues: {
        'af_level': level,
        if (description != null) 'af_description': description,
      },
    );
  }

  /// Поиск (можно использовать для поиска в настройках/FAQ)
  Future<void> logSearch({
    required String searchString,
    String? category,
  }) async {
    await logEvent(
      eventName: 'af_search',
      eventValues: {
        'af_search_string': searchString,
        if (category != null) 'af_content_type': category,
      },
    );
  }

  /// Событие запуска подписки (для дополнительной аналитики)
  Future<void> logSubscriptionStart({
    required String productId,
    required String billingPeriod,
    required String source,
  }) async {
    await logEvent(
      eventName: 'af_start_trial', // Стандартное AppsFlyer событие
      eventValues: {
        'af_product_id': productId,
        'af_billing_period': billingPeriod,
        'af_source': source,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Событие отмены подписки (важно для retention анализа)
  Future<void> logSubscriptionCancel({
    required String productId,
    required String reason,
  }) async {
    await logEvent(
      eventName: 'af_cancel_subscription', // Стандартное AppsFlyer событие
      eventValues: {
        'af_product_id': productId,
        'af_cancellation_reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Логирование доходов от рекламы (Ad Revenue)
  /// Интегрируется с AppLovin MAX для отслеживания доходов от показов рекламы
  Future<void> logAdRevenue({
    required String mediationNetwork, // 'AppLovin MAX'
    required String currencyCode, // 'USD'
    required double revenue,
    required Map<String, dynamic> additionalParams,
  }) async {
    if (!_isInitialized || _appsflyerSdk == null) {
      if (kDebugMode) {
        print('⚠️ AppsFlyer не инициализирован, Ad Revenue событие пропущено');
      }
      return;
    }

    try {
      // Используем AppsFlyer Ad Revenue API с правильными параметрами
      final adRevenueData = {
        'af_mediation_network': mediationNetwork,
        'af_currency': currencyCode,
        'af_revenue': revenue,
        ...additionalParams,
      };

      await logEvent(
        eventName: 'af_ad_revenue',
        eventValues: adRevenueData,
      );

      if (kDebugMode) {
        print('💰 AppsFlyer Ad Revenue logged:');
        print('   Network: $mediationNetwork');
        print('   Revenue: $revenue $currencyCode');
        print('   Additional params: $additionalParams');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка отправки Ad Revenue: $error');
      }
    }
  }

  // ==================== ВНУТРЕННИЕ МЕТОДЫ ====================

  AppsFlyerConfig _resolveConfig() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return appsFlyerAndroidConfig;
      case TargetPlatform.iOS:
        return appsFlyerIosConfig;
      default:
        return const AppsFlyerConfig.empty();
    }
  }

  void _handleInstallConversion(Map<dynamic, dynamic> data) {
    // Обработка данных о конверсии установки
    if (kDebugMode) {
      print('📊 Install Conversion Data:');
      data.forEach((key, value) {
        print('  $key: $value');
      });
    }

    // Здесь можно добавить логику для обработки органического vs. неорганического трафика
    // и настройки персонализации в зависимости от источника

    final isOrganic = data['is_first_launch'] == true &&
                      (data['af_status'] == 'Organic' || data['media_source'] == null);

    if (kDebugMode) {
      print('📊 User Type: ${isOrganic ? 'Organic' : 'Non-Organic'}');
    }
  }

  void _handleDeepLink(Map<dynamic, dynamic>? data) {
    if (data == null) return;

    if (kDebugMode) {
      print('🔗 Deep Link Data:');
      data.forEach((key, value) {
        print('  $key: $value');
      });
    }

    // Здесь можно добавить логику для обработки deep links
    // Например, открытие определенных экранов или функций
  }
}