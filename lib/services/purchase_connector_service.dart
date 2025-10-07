import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:hydracoach/utils/app_logger.dart';

/// Сервис для работы с AppsFlyer Purchase Connector
/// Автоматически отслеживает и валидирует IAP покупки через AppsFlyer
class PurchaseConnectorService {
  static final PurchaseConnectorService _instance =
      PurchaseConnectorService._internal();
  factory PurchaseConnectorService() => _instance;
  PurchaseConnectorService._internal();

  static const MethodChannel _channel = MethodChannel(
    'hydracoach.purchase_connector',
  );

  // AppsFlyer Purchase Connector instance
  PurchaseConnector? _purchaseConnector;

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
        logger.i('🔗 Инициализируем AppsFlyer Purchase Connector...');
      }

      // Создаем конфигурацию Purchase Connector
      final config = PurchaseConnectorConfiguration(
        // Включаем отслеживание подписок
        logSubscriptions: true,
        // Включаем отслеживание обычных покупок
        logInApps: true,
        // Автоматическое переключение sandbox/production
        sandbox: kDebugMode, // true в debug, false в release
      );

      // Инициализируем Purchase Connector
      _purchaseConnector = PurchaseConnector(config: config);

      _isInitialized = true;

      if (kDebugMode) {
        logger.i('✅ Purchase Connector инициализирован через Flutter SDK');
        logger.i('   - logSubscriptions: true');
        logger.i('   - logInApps: true');
        logger.i(
          '   - sandbox: $kDebugMode (${kDebugMode ? 'test' : 'production'} mode)',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('❌ Ошибка инициализации Purchase Connector: $e');
      }
      rethrow;
    }
  }

  /// Запуск автоматического отслеживания транзакций
  /// Вызывается после инициализации AppsFlyer SDK (с задержкой в 1 секунду)
  Future<void> startObservingTransactions() async {
    if (!_isInitialized || _purchaseConnector == null) {
      throw StateError(
        'Purchase Connector не инициализирован. Вызовите initialize() сначала.',
      );
    }

    if (_isObserving) {
      if (kDebugMode) {
        logger.w('⚠️ Purchase Connector уже отслеживает транзакции');
      }
      return;
    }

    try {
      if (kDebugMode) {
        logger.i('🔍 Запускаем отслеживание транзакций Purchase Connector...');
      }

      // Запускаем Purchase Connector через Flutter SDK
      _purchaseConnector!.startObservingTransactions();

      _isObserving = true;

      if (kDebugMode) {
        logger.i('✅ Purchase Connector начал отслеживание через Flutter SDK');
        logger.i(
          '🎯 Теперь события будут автоматически отправляться с префиксом af_ars_',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('❌ Ошибка запуска отслеживания: $e');
      }
      rethrow;
    }
  }

  /// Остановка отслеживания транзакций
  Future<void> stopObservingTransactions() async {
    if (!_isObserving || _purchaseConnector == null) {
      if (kDebugMode) {
        logger.w('⚠️ Purchase Connector не отслеживает транзакции');
      }
      return;
    }

    try {
      if (kDebugMode) {
        logger.i('🛑 Останавливаем отслеживание транзакций...');
      }

      // Останавливаем Purchase Connector через Flutter SDK
      _purchaseConnector!.stopObservingTransactions();

      _isObserving = false;

      if (kDebugMode) {
        logger.i('✅ Purchase Connector остановлен через Flutter SDK');
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('❌ Ошибка остановки отслеживания: $e');
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
        logger.i('🎯 Purchase Connector полностью настроен и работает');
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('❌ Ошибка полной инициализации Purchase Connector: $e');
      }
      rethrow;
    }
  }

  /// Получение статуса Purchase Connector
  Map<String, dynamic> getStatus() {
    return {'isInitialized': _isInitialized, 'isObserving': _isObserving};
  }
}
