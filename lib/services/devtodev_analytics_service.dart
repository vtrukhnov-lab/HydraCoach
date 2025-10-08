import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hydracoach/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'devtodev_config.dart';

/// Типы событий подписки для DevToDev Subscription API
enum SubscriptionEventType {
  purchase('PURCHASE'),
  trialPurchase('TRIAL_PURCHASE'),
  trialCancellation('TRIAL_CANCELLATION'),
  renewal('RENEWAL'),
  cancellation('CANCELLATION'),
  refund('REFUND');

  const SubscriptionEventType(this.value);
  final String value;
}

/// Обертка над нативной интеграцией DevToDev Analytics.
///
/// Использует MethodChannel `devtodev_analytics`. Реальная реализация должна быть
/// добавлена на iOS и Android-платформах. В случае отсутствия реализации
/// вызовы не приводят к ошибке и просто логируются в debug-режиме.
class DevToDevAnalyticsService {
  DevToDevAnalyticsService._();

  static final DevToDevAnalyticsService _instance =
      DevToDevAnalyticsService._();

  factory DevToDevAnalyticsService() => _instance;

  static const MethodChannel _channel = MethodChannel('devtodev_analytics');

  bool _isInitialized = false;
  DevToDevCredentials _credentials = const DevToDevCredentials.empty();

  bool get isInitialized => _isInitialized;
  DevToDevCredentials get credentials => _credentials;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _credentials = _resolveCredentials();

    if (!_credentials.isComplete) {
      if (kDebugMode) {
        logger.d(
          '⚠️ DevToDev ключи не заполнены для платформы $defaultTargetPlatform. '
          'Интеграция DevToDev будет пропущена.',
        );
      }
      return;
    }

    try {
      await _channel.invokeMethod<void>('initialize', <String, dynamic>{
        'appId': _credentials.appId,
        'secretKey': _credentials.secretKey,
        'apiKey': _credentials.apiKey,
      });
      _isInitialized = true;
    } on MissingPluginException {
      // В сборке без нативной реализации тихо пропускаем инициализацию.
      if (kDebugMode) {
        logger.d(
          '⚠️ Плагин DevToDev не найден. Убедитесь, что добавили нативную '
          'реализацию MethodChannel devtodev_analytics.',
        );
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        logger.d('❌ Ошибка инициализации DevToDev: $error');
        logger.d(stackTrace);
      }
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('setUserId', {'userId': userId});
    } catch (error) {
      _logError('setUserId', error);
    }
  }

  Future<void> clearUserId() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('clearUserId');
    } catch (error) {
      _logError('clearUserId', error);
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('setUserProperty', {
        'name': name,
        'value': value,
      });
    } catch (error) {
      _logError('setUserProperty', error);
    }
  }

  Future<void> setTrackingEnabled(bool enabled) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('setTrackingEnabled', {
        'enabled': enabled,
      });
    } catch (error) {
      _logError('setTrackingEnabled', error);
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('logScreenView', {
        'screenName': screenName,
        'screenClass': screenClass,
      });
    } catch (error) {
      _logError('logScreenView', error);
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('logEvent', {
        'name': name,
        'parameters': parameters ?? <String, dynamic>{},
      });
    } catch (error) {
      _logError('logEvent', error);
    }
  }

  /// Отправка события о реальном платеже (подписка или покупка)
  Future<void> realCurrencyPayment({
    required String orderId,
    required double price,
    required String productId,
    required String currencyCode,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('realCurrencyPayment', {
        'orderId': orderId,
        'price': price,
        'productId': productId,
        'currencyCode': currencyCode,
      });
    } catch (error) {
      _logError('realCurrencyPayment', error);
    }
  }

  /// Отправка события о подписке
  Future<void> subscriptionPayment({
    required String orderId,
    required double price,
    required String productId,
    required String currencyCode,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('subscriptionPayment', {
        'orderId': orderId,
        'price': price,
        'productId': productId,
        'currencyCode': currencyCode,
      });
    } catch (error) {
      _logError('subscriptionPayment', error);
    }
  }

  /// Отправка события о прохождении туториала/онбординга
  Future<void> tutorial(int step) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('tutorial', {'step': step});
    } catch (error) {
      _logError('tutorial', error);
    }
  }

  /// Отправка события о повышении уровня пользователя
  Future<void> levelUp({
    required int level,
    Map<String, double>? balances,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('levelUp', {
        'level': level,
        'balances': balances,
      });
    } catch (error) {
      _logError('levelUp', error);
    }
  }

  /// Отправка текущего баланса пользователя
  Future<void> currentBalance(Map<String, double> balance) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('currentBalance', {'balance': balance});
    } catch (error) {
      _logError('currentBalance', error);
    }
  }

  /// Отправка ad impression (рекламный показ с доходом)
  ///
  /// ВАЖНО: Не используйте этот метод, если у вас настроена S2S интеграция
  /// с ad networks (AppLovin MAX, ironSource, Fyber), чтобы избежать дублирования данных.
  ///
  /// [network] - название рекламной сети (например, "AppLovin", "AdMob")
  /// [revenue] - доход за показ в USD
  /// [placement] - место размещения баннера (например, "MainScreen", "RewardedVideo")
  /// [unit] - название рекламного блока (ad unit ID)
  Future<void> adImpression({
    required String network,
    required double revenue,
    required String placement,
    required String unit,
  }) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('adImpression', {
        'network': network,
        'revenue': revenue,
        'placement': placement,
        'unit': unit,
      });

      if (kDebugMode) {
        logger.d(
          '📺 DevToDev Ad Impression: $network, \$$revenue, $placement, $unit',
        );
      }
    } catch (error) {
      _logError('adImpression', error);
    }
  }

  /// Получить DevToDev ID пользователя из нативного SDK
  Future<String?> getDevToDevId() async {
    if (!_isInitialized) {
      return null;
    }

    try {
      final result = await _channel.invokeMethod<String>('getDevToDevId');
      return result;
    } catch (error) {
      _logError('getDevToDevId', error);
      return null;
    }
  }

  /// Отправка события подписки через Server API
  /// https://docs.devtodev.com/integration/server-api/subscription-api
  Future<void> sendSubscriptionEvent({
    required SubscriptionEventType eventType,
    required String transactionId,
    required String originalTransactionId,
    required int startDateMs,
    required int expiresDateMs,
    required String productId,
    required double price,
    required String currency,
    required bool isTrial,
  }) async {
    if (!_isInitialized || !_credentials.isComplete) {
      if (kDebugMode) {
        logger.d('⚠️ DevToDev не инициализирован или ключи не заполнены');
      }
      return;
    }

    try {
      // Получаем DevToDev ID пользователя
      final devtodevId = await getDevToDevId();
      if (devtodevId == null) {
        if (kDebugMode) {
          logger.w(
            '⚠️ DevToDev ID не получен, пропускаем отправку события подписки',
          );
        }
        return;
      }

      // Формируем URL с API ключом
      final url = Uri.parse(
        'https://statgw.devtodev.com/subscriptions/api?apikey=${_credentials.apiKey}',
      );

      // Формируем тело запроса
      final body = {
        'notificationType': eventType.value,
        'transactionId': transactionId,
        'originalTransactionId': originalTransactionId,
        'startDateMs': startDateMs,
        'expiresDateMs': expiresDateMs,
        'product': productId,
        'price': price,
        'currency': currency,
        'isTrial': isTrial,
        'devtodevId': int.tryParse(devtodevId) ?? 0,
      };

      if (kDebugMode) {
        logger.i('📤 Отправка события подписки в DevToDev:');
        logger.i('   Type: ${eventType.value}');
        logger.i('   Product: $productId');
        logger.i('   Price: $price $currency');
        logger.i('   Trial: $isTrial');
        logger.i('   DevToDev ID: $devtodevId');
      }

      // Отправляем POST запрос
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          logger.i('✅ Событие подписки успешно отправлено в DevToDev');
        }
      } else {
        if (kDebugMode) {
          logger.e(
            '❌ Ошибка отправки события подписки: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        logger.e('❌ Ошибка отправки события подписки в DevToDev: $error');
        logger.d(stackTrace);
      }
    }
  }

  DevToDevCredentials _resolveCredentials() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return devToDevAndroidCredentials;
      case TargetPlatform.iOS:
        return devToDevIosCredentials;
      default:
        return const DevToDevCredentials.empty();
    }
  }

  void _logError(String method, Object error) {
    if (kDebugMode) {
      logger.d('❌ DevToDev $method error: $error');
    }
  }
}
