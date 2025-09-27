import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'devtodev_config.dart';

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
        print(
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
        print(
          '⚠️ Плагин DevToDev не найден. Убедитесь, что добавили нативную '
          'реализацию MethodChannel devtodev_analytics.',
        );
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации DevToDev: $error');
        print(stackTrace);
      }
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('setUserId', {
        'userId': userId,
      });
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
      await _channel.invokeMethod<void>('tutorial', {
        'step': step,
      });
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
      await _channel.invokeMethod<void>('currentBalance', {
        'balance': balance,
      });
    } catch (error) {
      _logError('currentBalance', error);
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
      print('❌ DevToDev $method error: $error');
    }
  }
}
