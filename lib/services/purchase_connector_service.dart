import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Сервис для работы с AppsFlyer Purchase Connector
/// Автоматически отслеживает и валидирует IAP покупки через AppsFlyer
class PurchaseConnectorService {
  static final PurchaseConnectorService _instance = PurchaseConnectorService._internal();
  factory PurchaseConnectorService() => _instance;
  PurchaseConnectorService._internal();

  static const MethodChannel _channel = MethodChannel('hydracoach.purchase_connector');

  bool _isInitialized = false;
  bool _isObserving = false;

  bool get isInitialized => _isInitialized;
  bool get isObserving => _isObserving;

  /// Инициализация Purchase Connector
  /// Должна вызываться после инициализации AppsFlyer SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kDebugMode) {
        print('🔗 Инициализируем AppsFlyer Purchase Connector...');
      }

      final result = await _channel.invokeMethod('initializePurchaseConnector');

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ Purchase Connector инициализирован: $result');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации Purchase Connector: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Неизвестная ошибка Purchase Connector: $e');
      }
      rethrow;
    }
  }

  /// Запуск автоматического отслеживания транзакций
  /// Вызывается после инициализации AppsFlyer SDK (с задержкой в 1 секунду)
  Future<void> startObservingTransactions() async {
    if (!_isInitialized) {
      throw StateError('Purchase Connector не инициализирован. Вызовите initialize() сначала.');
    }

    if (_isObserving) {
      if (kDebugMode) {
        print('⚠️ Purchase Connector уже отслеживает транзакции');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('🔍 Запускаем отслеживание транзакций Purchase Connector...');
      }

      final result = await _channel.invokeMethod('startPurchaseConnector');

      _isObserving = true;

      if (kDebugMode) {
        print('✅ Purchase Connector начал отслеживание: $result');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка запуска отслеживания: ${e.message}');
      }
      rethrow;
    }
  }

  /// Остановка отслеживания транзакций
  Future<void> stopObservingTransactions() async {
    if (!_isObserving) {
      if (kDebugMode) {
        print('⚠️ Purchase Connector не отслеживает транзакции');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('🛑 Останавливаем отслеживание транзакций...');
      }

      final result = await _channel.invokeMethod('stopPurchaseConnector');

      _isObserving = false;

      if (kDebugMode) {
        print('✅ Purchase Connector остановлен: $result');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка остановки отслеживания: ${e.message}');
      }
      rethrow;
    }
  }

  /// Полная инициализация и запуск Purchase Connector
  /// Следует вызывать через 1 секунду после AppsFlyer.startSDK()
  Future<void> initializeAndStart() async {
    try {
      // Инициализируем
      await initialize();

      // Запускаем отслеживание
      await startObservingTransactions();

      if (kDebugMode) {
        print('🎯 Purchase Connector полностью настроен и работает');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка полной инициализации Purchase Connector: $e');
      }
      rethrow;
    }
  }

  /// Получение статуса Purchase Connector
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'isObserving': _isObserving,
    };
  }
}