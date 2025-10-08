import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'analytics_service.dart';
import 'devtodev_analytics_service.dart'
    show DevToDevAnalyticsService, SubscriptionEventType;
import 'package:hydracoach/utils/app_logger.dart';

/*
🧪 НАСТРОЙКА ТЕСТОВЫХ ПОКУПОК В GOOGLE PLAY CONSOLE:

1. Перейдите в Google Play Console → Ваше приложение → Testing → Closed testing
2. Создайте тестовую дорожку (например, "Internal Testing")
3. Добавьте тестовые аккаунты в список тестеров:
   - test@playcus.com
   - vtrukhnov.lab@gmail.com
   - qa@playcus.com
   - и другие из списка _testAccounts

4. В разделе "Monetization" → "Products" → "In-app products":
   - Создайте продукты подписки
   - Установите тестовые цены
   - Тестовые аккаунты смогут покупать бесплатно

5. В Release Management → Test tracks → Internal Testing:
   - Загрузите APK/AAB с этим кодом
   - Тестеры получат ссылку для установки

РЕЗУЛЬТАТ:
- Тестовые аккаунты: покупки БЕСПЛАТНО (но события аналитики логируются)
- Обычные пользователи: ПЛАТНЫЕ покупки
- Все события отслеживаются в Firebase/AppsFlyer
*/

class SubscriptionProduct {
  const SubscriptionProduct({
    required this.identifier,
    required this.title,
    required this.description,
    required this.priceText,
    required this.billingPeriod,
  });

  final String identifier;
  final String title;
  final String description;
  final String priceText;
  final Duration billingPeriod;
}

// Временные заглушки для типов RevenueCat
class StoreProduct {
  final String identifier;
  final String title;
  final String description;
  final double price;
  final String priceString;

  StoreProduct({
    required this.identifier,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
  });
}

class SubscriptionService extends ChangeNotifier {
  static SubscriptionService? _instance;
  static SubscriptionService get instance =>
      _instance ??= SubscriptionService._();

  SubscriptionService._();

  static const _isProKey = 'is_pro';
  static const _proExpiresAtKey = 'pro_expires_at';
  static const _isTrialKey = 'is_trial';
  static const _trialUsedKey = 'trial_used';

  // Google Play subscription product IDs
  static const String _yearlyProductId = 'hydracoach_pro_yearly';
  static const String _yearlyNoTrialProductId =
      'hydracoach_pro_yearly_no_trial';
  static const String _monthlyProductId = 'hydracoach_pro_monthly';

  // Google Play one-time purchase (lifetime)
  static const String _lifetimeProductId = 'hydracoach_pro_lifetime';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Список тестовых аккаунтов Google Play для бесплатного тестирования
  static const List<String> _testAccounts = [
    'test@playcus.com',
    'tester1@playcus.com',
    'tester2@playcus.com',
    'qa@playcus.com',
    'beta@playcus.com',
    'vtrukhnov.lab@gmail.com', // Основной разработчик
    // Добавьте свои тестовые аккаунты сюда
  ];

  // Дополнительные тестовые аккаунты, добавленные в рантайме
  static final List<String> _runtimeTestAccounts = [];

  final AnalyticsService _analytics = AnalyticsService();
  final DevToDevAnalyticsService _devToDev = DevToDevAnalyticsService();

  static const List<SubscriptionProduct> _defaultProducts = [
    SubscriptionProduct(
      identifier: 'hydracoach_pro_yearly',
      title: 'HydraCoach PRO — Годовая',
      description:
          'Все PRO функции, включая продвинутые напоминания и алкогольные протоколы',
      priceText: '2 290 ₽ / год',
      billingPeriod: Duration(days: 365),
    ),
    SubscriptionProduct(
      identifier: 'hydracoach_pro_monthly',
      title: 'HydraCoach PRO — Месячная',
      description: 'Гибкий доступ к PRO функционалу с помесячной оплатой',
      priceText: '249 ₽ / месяц',
      billingPeriod: Duration(days: 30),
    ),
  ];

  bool _isInitialized = false;
  bool _isPro = false;
  bool _isTrial = false;
  bool _trialUsed = false;
  List<ProductDetails> _products = [];

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;
  bool get isTrial => _isTrial;
  bool get trialUsed => _trialUsed;
  bool get canStartTrial => !_trialUsed;
  List<ProductDetails> get products => _products;

  // Геттеры для конкретных продуктов
  ProductDetails? get yearlyProduct {
    final products = _products.where((p) => p.id == _yearlyProductId);
    // Prefer non-free products to handle Google Play test products
    return products
            .where(
              (p) =>
                  p.price != 'Free' && !p.price.toLowerCase().contains('free'),
            )
            .firstOrNull ??
        products.firstOrNull;
  }

  ProductDetails? get yearlyNoTrialProduct {
    final products = _products.where((p) => p.id == _yearlyNoTrialProductId);
    // Prefer non-free products to handle Google Play test products
    return products
            .where(
              (p) =>
                  p.price != 'Free' && !p.price.toLowerCase().contains('free'),
            )
            .firstOrNull ??
        products.firstOrNull;
  }

  ProductDetails? get monthlyProduct {
    final products = _products.where((p) => p.id == _monthlyProductId);
    // Prefer non-free products to handle Google Play test products
    return products
            .where(
              (p) =>
                  p.price != 'Free' && !p.price.toLowerCase().contains('free'),
            )
            .firstOrNull ??
        products.firstOrNull;
  }

  ProductDetails? get lifetimeProduct {
    final products = _products.where((p) => p.id == _lifetimeProductId);
    // Prefer non-free products to handle Google Play test products
    return products
            .where(
              (p) =>
                  p.price != 'Free' && !p.price.toLowerCase().contains('free'),
            )
            .firstOrNull ??
        products.firstOrNull;
  }

  /// Проверяет, является ли текущий пользователь тестовым
  bool _isTestAccount() {
    // В релизе блокируем все тестовые покупки - только реальные платежи
    // TODO: В будущем добавить проверку email пользователя
    // final userEmail = getCurrentUserEmail();
    // return _testAccounts.contains(userEmail) || _runtimeTestAccounts.contains(userEmail);

    // Пока что в релизе никто не является тестовым пользователем
    return false;
  }

  // RELEASE: Test account methods removed for production

  /// Получить список всех тестовых аккаунтов
  static List<String> getTestAccounts() {
    return [..._testAccounts, ..._runtimeTestAccounts];
  }

  /// Инициализация подписки: подключение к Google Play и загрузка продуктов
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _restoreFromStorage();

    // Проверяем доступность покупок
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ In-app purchases not available');
      }
      _isInitialized = true;
      return;
    }

    // Настраиваем слушатель покупок
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        // RELEASE: Debug mode disabled
        if (false) {
          logger.e('❌ Purchase stream error: $error');
        }
      },
    );

    // Загружаем продукты
    await _loadProducts();

    _isInitialized = true;

    // RELEASE: Debug mode disabled
    if (false) {
      logger.i('✅ SubscriptionService initialized');
      logger.i('🔒 PRO status: $_isPro');
      logger.i('📦 Products loaded: ${_products.length}');
    }
  }

  Future<void> _restoreFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIsPro = prefs.getBool(_isProKey) ?? false;
    final storedIsTrial = prefs.getBool(_isTrialKey) ?? false;
    final storedTrialUsed = prefs.getBool(_trialUsedKey) ?? false;
    final expiryIso = prefs.getString(_proExpiresAtKey);
    DateTime? expiry;

    _trialUsed = storedTrialUsed;

    if (expiryIso != null) {
      expiry = DateTime.tryParse(expiryIso);
    }

    if (storedIsPro) {
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        // Активная подписка с датой истечения
        _isPro = true;
        _isTrial = storedIsTrial;
        // RELEASE: Debug mode disabled
        if (false) {
          logger.i(
            '✅ Активная подписка найдена, истекает: ${expiry.toIso8601String()}',
          );
        }
        return;
      } else if (expiry != null && DateTime.now().isAfter(expiry)) {
        // Подписка истекла — чистим флаги
        // RELEASE: Debug mode disabled
        if (false) {
          logger.i('⏰ Подписка истекла: ${expiry.toIso8601String()}');
        }
        await prefs.remove(_isProKey);
        await prefs.remove(_proExpiresAtKey);
        await prefs.remove(_isTrialKey);
        _isPro = false;
        _isTrial = false;
        return;
      } else if (expiry == null) {
        // Legacy подписка без даты истечения
        _isPro = true;
        _isTrial = false;
        // RELEASE: Debug mode disabled
        if (false) {
          logger.i('✅ Legacy подписка без даты истечения');
        }
        return;
      }
    }

    // Нет активной подписки
    _isPro = false;
    _isTrial = false;
  }

  /// Загрузка продуктов подписки из Google Play
  Future<void> _loadProducts() async {
    try {
      final Set<String> productIds = {
        _yearlyProductId,
        _yearlyNoTrialProductId,
        _monthlyProductId,
        _lifetimeProductId,
      };
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails(productIds);

      if (response.error != null) {
        // RELEASE: Debug mode disabled
        if (false) {
          logger.e('❌ Failed to load products: ${response.error}');
        }
        return;
      }

      _products = response.productDetails;

      // RELEASE: Debug mode disabled
      if (false) {
        logger.i('📦 Loaded ${_products.length} products:');
        for (final product in _products) {
          logger.i('   - ${product.id}: ${product.price}');
        }
      }
    } catch (e) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Error loading products: $e');
      }
    }
  }

  /// Обработчик обновлений покупок
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  /// Обработка конкретной покупки
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased ||
        purchaseDetails.status == PurchaseStatus.restored) {
      // Покупка успешна - активируем PRO
      final product = _products.firstWhere(
        (p) => p.id == purchaseDetails.productID,
        orElse: () => throw Exception('Product not found'),
      );

      Duration billingPeriod;
      if (purchaseDetails.productID == _lifetimeProductId) {
        // Lifetime покупка - никогда не истекает (100 лет)
        billingPeriod = const Duration(days: 36500);
      } else if (purchaseDetails.productID == _yearlyProductId ||
          purchaseDetails.productID == _yearlyNoTrialProductId) {
        billingPeriod = const Duration(days: 365);
      } else {
        billingPeriod = const Duration(days: 30);
      }

      await _activatePro(billingPeriod);

      // 🔥 Purchase Connector автоматически отправит af_ars_ события
      // Дополнительно отправляем стандартные события AppsFlyer для Live Events
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        try {
          // Получаем цену и валюту из продукта
          double price = 0.0;
          String currency = 'USD';

          // В Android rawPrice и currencyCode могут быть недоступны, используем price
          if (product.price.isNotEmpty) {
            // Парсим цену из строки (например "$35.99" -> 35.99)
            final priceString = product.price.replaceAll(RegExp(r'[^\d.]'), '');
            price = double.tryParse(priceString) ?? 0.0;

            // Пытаемся определить валюту из символа
            if (product.price.contains('€')) {
              currency = 'EUR';
            } else if (product.price.contains('£')) {
              currency = 'GBP';
            } else if (product.price.contains('₽')) {
              currency = 'RUB';
            } else if (product.price.contains('\$')) {
              currency = 'USD';
            }
          }

          // НЕ НУЖНО! Purchase Connector автоматически отправляет af_ars_subscribe через S2S
          // SDK событие af_subscribe не нужно - это дублирование
          // final eventName = purchaseDetails.productID.contains('trial') ? 'af_start_trial' : 'af_subscribe';
          // await _analytics.logSubscriptionPurchased(
          //   productId: purchaseDetails.productID,
          //   price: price,
          //   currency: currency,
          //   transactionId: purchaseDetails.purchaseID ?? '',
          // );

          // 📊 Отправляем событие платежа в DevToDev (legacy метод)
          await _devToDev.subscriptionPayment(
            orderId:
                purchaseDetails.purchaseID ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            price: price,
            productId: purchaseDetails.productID,
            currencyCode: currency,
          );

          // 📊 Отправляем событие подписки через DevToDev Subscription API
          final now = DateTime.now();
          final expiryDate = now.add(billingPeriod);
          final isTrial = purchaseDetails.productID == _yearlyProductId;

          await _devToDev.sendSubscriptionEvent(
            eventType: isTrial
                ? SubscriptionEventType.trialPurchase
                : SubscriptionEventType.purchase,
            transactionId:
                purchaseDetails.purchaseID ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            originalTransactionId:
                purchaseDetails.purchaseID ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            startDateMs: now.millisecondsSinceEpoch,
            expiresDateMs: expiryDate.millisecondsSinceEpoch,
            productId: purchaseDetails.productID,
            price: price,
            currency: currency,
            isTrial: isTrial,
          );

          if (kDebugMode) {
            logger.i('💰 Subscription purchased: ${purchaseDetails.productID}');
            logger.i(
              '   Purchase Connector отправит S2S событие: af_ars_sandbox_s2s',
            );
            logger.i(
              '   SDK событие af_subscribe НЕ отправляется (избегаем дублирования)',
            );
            logger.i(
              '📊 DevToDev: subscriptionPayment отправлено (${purchaseDetails.productID}, $price $currency)',
            );
            logger.i(
              '📊 DevToDev Subscription API: ${isTrial ? "TRIAL_PURCHASE" : "PURCHASE"} событие отправлено',
            );
          }
        } catch (e) {
          if (kDebugMode) {
            logger.w('⚠️ Ошибка отправки события подписки: $e');
          }
        }
      }

      // RELEASE: Debug mode disabled
      if (true) {
        final action = purchaseDetails.status == PurchaseStatus.restored
            ? 'restored'
            : 'completed';
        logger.i('✅ Purchase $action: ${purchaseDetails.productID}');
      }
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Purchase failed: ${purchaseDetails.error}');
      }
    }

    // Завершаем покупку для Android
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// Получение доступных продуктов подписки (мок-данные)
  Future<List<SubscriptionProduct>> getAvailableProducts() async {
    return List.unmodifiable(_defaultProducts);
  }

  /// Покупка годовой подписки с учетом trial переключателя
  Future<bool> purchaseYearlySubscription({required bool withTrial}) async {
    final productId = withTrial ? _yearlyProductId : _yearlyNoTrialProductId;
    return purchaseSubscription(productId);
  }

  /// Покупка подписки через Google Play Billing
  Future<bool> purchaseSubscription(String productId) async {
    if (!_isInitialized) {
      throw Exception('SubscriptionService not initialized');
    }

    // Проверяем, доступны ли покупки
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      throw Exception('In-app purchases not available');
    }

    // Находим продукт
    logger.d('🔍 Looking for product: $productId');
    logger.d('🔍 Available products: ${_products.map((p) => p.id).join(', ')}');
    final ProductDetails? product = _products
        .where((p) => p.id == productId)
        .firstOrNull;
    if (product == null) {
      logger.e('❌ Product not found: $productId');
      throw Exception('Product not found: $productId');
    }

    try {
      // Временно включаем логирование для отладки
      logger.i('🛍️ Starting purchase for: ${product.id}');
      logger.i('💰 Price: ${product.price}');

      // Создаем параметры покупки
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Инициируем покупку
      final bool purchaseResult = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      // RELEASE: Debug mode disabled
      if (false) {
        logger.i('🔄 Purchase initiated: $purchaseResult');
      }

      // Возвращаем false - реальный результат придет через purchaseStream
      // Это предотвращает преждевременную активацию PRO статуса
      return false;
    } catch (e) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Purchase error: $e');
      }
      rethrow;
    }
  }

  /// Восстановление покупок через Google Play
  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      throw Exception('SubscriptionService not initialized');
    }

    try {
      // RELEASE: Debug mode disabled
      if (true) {
        logger.i('🔄 Starting restore purchases...');
        logger.i('🔄 Current PRO status before restore: $_isPro');
      }

      // DEBUG: Симуляция successful restore для тестирования без реальных покупок
      if (kDebugMode && false) {
        // Включи `true` для тестирования
        logger.d('🧪 DEBUG: Simulating successful restore...');
        await _activatePro(const Duration(days: 365), isTrial: false);
        logger.i('✅ DEBUG: Simulated restore completed. PRO status: $_isPro');
        return true;
      }

      // Восстанавливаем покупки через Google Play
      await _inAppPurchase.restorePurchases();

      // RELEASE: Debug mode disabled
      if (true) {
        logger.i(
          '🔄 restorePurchases() called, waiting for purchaseStream updates...',
        );
      }

      // Ждем немного чтобы purchaseStream успел обработать восстановленные покупки
      await Future.delayed(const Duration(milliseconds: 500));

      // Также загружаем из локального хранилища
      await _restoreFromStorage();

      // RELEASE: Debug mode disabled
      if (true) {
        logger.i('✅ Restore completed. PRO status: $_isPro');
      }

      return _isPro;
    } catch (e) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Restore error: $e');
      }
      rethrow;
    }
  }

  /// Обновление статуса подписки
  Future<void> _activatePro(
    Duration billingPeriod, {
    bool isTrial = false,
  }) async {
    _isPro = true;
    _isTrial = isTrial;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProKey, true);
    await prefs.setBool(_isTrialKey, isTrial);

    if (isTrial) {
      await prefs.setBool(_trialUsedKey, true);
      _trialUsed = true;
    }

    final expiryDate = DateTime.now().add(billingPeriod);
    await prefs.setString(_proExpiresAtKey, expiryDate.toIso8601String());

    // RELEASE: Debug mode disabled
    if (false) {
      logger.i('✅ PRO активирован до: ${expiryDate.toIso8601String()}');
      logger.i('   Trial: $isTrial');
    }

    // Уведомляем слушателей об изменении статуса подписки
    notifyListeners();
  }

  /// Начать бесплатный пробный период (7 дней)
  Future<bool> startFreeTrial() async {
    if (_trialUsed || _isPro) {
      return false; // Уже использован или уже есть подписка
    }

    try {
      await _activatePro(const Duration(days: 7), isTrial: true);

      // Логируем начало trial
      await _analytics.logTrialStarted(
        product: _yearlyProductId,
        trialDuration: 7,
      );

      // RELEASE: Debug mode disabled
      if (false) {
        logger.i('🎯 7-дневный пробный период начат!');
      }

      return true;
    } catch (e) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Ошибка запуска пробного периода: $e');
      }
      return false;
    }
  }

  /// Проверка доступности PRO функции
  bool hasProAccess() {
    return _isPro;
  }

  /// Проверка доступности конкретной функции
  bool hasFeatureAccess(String featureName) {
    const freeFeatures = {
      'basic_tracking',
      'weather_integration',
      'simple_reminders',
      'daily_report',
      'basic_history',
      'alcohol_log',
      'alcohol_harm_reduction',
      'alcohol_morning_checkin',
    };

    if (freeFeatures.contains(featureName)) {
      return true;
    }

    return _isPro;
  }

  Map<String, dynamic> getFreeLimitations() {
    return {
      'max_daily_reminders': 4,
      'history_days': 30,
      'export_available': false,
      'smart_reminders': false,
      'fasting_aware': false,
      'cloud_sync': false,
      'weekly_reports': false,
      'alcohol_pre_drink': false,
      'alcohol_recovery_plan': false,
      'alcohol_sober_calendar': false,
    };
  }

  Map<String, dynamic> getProFeatures() {
    return {
      'unlimited_reminders': true,
      'unlimited_history': true,
      'csv_export': true,
      'smart_reminders': true,
      'fasting_aware_mode': true,
      'cloud_sync': true,
      'weekly_reports': true,
      'contextual_reminders': true,
      'heat_protocols': true,
      'multi_device': true,
      'alcohol_pre_drink_protocol': true,
      'alcohol_recovery_plan': true,
      'alcohol_sober_calendar': true,
      'alcohol_extended_checkin': true,
    };
  }

  /// Мок получения customer info (для совместимости с существующим кодом)
  Future<Map<String, dynamic>> getCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryIso = prefs.getString(_proExpiresAtKey);

    return {'isPro': _isPro, 'expiresAt': expiryIso};
  }

  /// Принудительное обнуление PRO статуса (удобно для тестов)
  Future<void> resetSubscription() async {
    _isPro = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isProKey);
    await prefs.remove(_proExpiresAtKey);
  }

  // RELEASE: Mock purchase method removed for production

  /// Очистка ресурсов
  void dispose() {
    _subscription.cancel();
  }

  // 🔥 УДАЛЕНЫ legacy методы валидации - Purchase Connector делает это автоматически!
  // Теперь события af_ars_* генерируются автоматически через Purchase Connector
}

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService.instance;

  bool get isPro => _subscriptionService.isPro;
  bool get isInitialized => _subscriptionService.isInitialized;
  bool get isTrial => _subscriptionService.isTrial;
  bool get trialUsed => _subscriptionService.trialUsed;
  bool get canStartTrial => _subscriptionService.canStartTrial;

  List<SubscriptionProduct> _availableProducts = const [];
  List<SubscriptionProduct> get availableProducts => _availableProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SubscriptionProvider() {
    // Слушаем изменения от SubscriptionService
    _subscriptionService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    // Когда SubscriptionService обновляется, уведомляем наших слушателей
    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptionService.removeListener(_onServiceChanged);
    super.dispose();
  }

  Future<void> initialize() async {
    _isLoading = true;

    await _subscriptionService.initialize();
    await loadProducts();

    _isLoading = false;

    await Future.microtask(notifyListeners);
  }

  Future<void> loadProducts() async {
    try {
      _availableProducts = await _subscriptionService.getAvailableProducts();
      if (!_isLoading) {
        notifyListeners();
      }
    } catch (e) {
      // RELEASE: Debug mode disabled
      if (false) {
        logger.e('❌ Ошибка загрузки продуктов: $e');
      }
    }
  }

  Future<bool> purchaseSubscription(String productId) async {
    _isLoading = true;
    notifyListeners();

    final success = await _subscriptionService.purchaseSubscription(productId);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();

    final success = await _subscriptionService.restorePurchases();

    _isLoading = false;
    notifyListeners();

    return success;
  }

  /// Начать бесплатный пробный период
  Future<bool> startFreeTrial() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _subscriptionService.startFreeTrial();
      notifyListeners();
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // RELEASE: Mock purchase method removed for production

  bool hasFeatureAccess(String featureName) {
    return _subscriptionService.hasFeatureAccess(featureName);
  }

  Map<String, dynamic> getFreeLimitations() {
    return _subscriptionService.getFreeLimitations();
  }

  Map<String, dynamic> getProFeatures() {
    return _subscriptionService.getProFeatures();
  }
}
