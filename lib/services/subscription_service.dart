import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_service.dart';
import 'appsflyer_service.dart';

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

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();

  SubscriptionService._();

  static const _isProKey = 'is_pro';
  static const _proExpiresAtKey = 'pro_expires_at';

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
  final AppsFlyerService _appsFlyer = AppsFlyerService();

  static const List<SubscriptionProduct> _defaultProducts = [
    SubscriptionProduct(
      identifier: 'hydracoach_pro_yearly',
      title: 'HydraCoach PRO — Годовая',
      description: 'Все PRO функции, включая продвинутые напоминания и алкогольные протоколы',
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

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;

  /// Проверяет, является ли текущий пользователь тестовым
  bool _isTestAccount() {
    // В реальном приложении здесь должна быть логика получения email пользователя
    // Например, через Firebase Auth, Google Sign-In, или другой метод аутентификации

    // Для демонстрации используем debug режим или можно добавить проверку email
    if (kDebugMode) {
      // В debug режиме считаем всех тестовыми для удобства разработки
      return true;
    }

    // TODO: Здесь добавить получение email текущего пользователя
    // final userEmail = getCurrentUserEmail();
    // return _testAccounts.contains(userEmail) || _runtimeTestAccounts.contains(userEmail);

    return false;
  }

  /// Добавить тестовый аккаунт в рантайме (только для debug)
  static void addTestAccount(String email) {
    if (kDebugMode && !_runtimeTestAccounts.contains(email)) {
      _runtimeTestAccounts.add(email);
      print('🧪 Added test account: $email');
    }
  }

  /// Получить список всех тестовых аккаунтов
  static List<String> getTestAccounts() {
    return [..._testAccounts, ..._runtimeTestAccounts];
  }

  /// "Инициализация" подписки: загружаем локальные данные и сбрасываем просроченные
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _restoreFromStorage();

    _isInitialized = true;

    if (kDebugMode) {
      print('✅ SubscriptionService initialized (mock)');
      print('🔒 PRO status: $_isPro');
    }
  }

  Future<void> _restoreFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIsPro = prefs.getBool(_isProKey) ?? false;
    final expiryIso = prefs.getString(_proExpiresAtKey);
    DateTime? expiry;

    if (expiryIso != null) {
      expiry = DateTime.tryParse(expiryIso);
    }

    if (storedIsPro && expiry != null) {
      if (DateTime.now().isBefore(expiry)) {
        _isPro = true;
        return;
      }

      // Подписка истекла — чистим флаги
      await prefs.remove(_isProKey);
      await prefs.remove(_proExpiresAtKey);
    }

    _isPro = storedIsPro && expiry == null;
  }

  /// Получение доступных продуктов подписки (мок-данные)
  Future<List<SubscriptionProduct>> getAvailableProducts() async {
    return List.unmodifiable(_defaultProducts);
  }

  /// Заглушка покупки подписки
  Future<bool> purchaseSubscription(String productId) async {
    final product = _defaultProducts.firstWhere(
      (item) => item.identifier == productId,
      orElse: () => throw Exception('Продукт не найден'),
    );

    final isTestUser = _isTestAccount();

    if (isTestUser) {
      // Для тестовых пользователей - бесплатная активация PRO
      await _activatePro(product.billingPeriod);

      if (kDebugMode) {
        print('🧪 TEST USER: Подписка активирована бесплатно');
      }
    } else {
      // Для обычных пользователей - реальная покупка
      // TODO: Здесь должна быть интеграция с реальной системой платежей
      // Например, RevenueCat, Google Play Billing, etc.

      if (kDebugMode) {
        // В debug режиме активируем мок для тестирования
        await _activatePro(product.billingPeriod);
        print('💰 REAL USER: Покупка обработана (мок-режим)');
      } else {
        // В релизе - покупки пока недоступны
        if (kDebugMode) {
          print('❌ REAL USER: Покупки пока не реализованы в релизе');
        }
        return false;
      }
    }

    // Получаем цену из priceText для аналитики
    final priceMatch = RegExp(r'(\d[\d\s]*\d|\d+)').firstMatch(product.priceText);
    final price = priceMatch != null
        ? double.tryParse(priceMatch.group(1)!.replaceAll(' ', '')) ?? 0.0
        : 0.0;
    final currency = product.priceText.contains('₽') ? 'RUB' : 'USD';

    // Логируем аналитику с отметкой о типе пользователя
    await _analytics.logSubscriptionStarted(
      product: product.identifier,
      isTrial: isTestUser, // Помечаем тестовые покупки как trial
      price: isTestUser ? 0.0 : price, // Для тестовых - цена 0
      currency: currency,
    );

    // Дополнительная аналитика для разделения тестовых и реальных событий
    if (isTestUser) {
      if (kDebugMode) {
        print('📊 Analytics: Test purchase logged (price: 0)');
      }
    } else {
      if (kDebugMode) {
        print('📊 Analytics: Real purchase logged (price: $price $currency)');
      }
    }

    // ВАЖНО: Purchase Connector автоматически обрабатывает валидацию покупок
    // Не нужно вызывать _validatePurchaseWithAppsFlyer, чтобы избежать дублирования
    // await _validatePurchaseWithAppsFlyer(product);

    if (kDebugMode) {
      print('💰 Purchase Connector автоматически обработает эту покупку');
    }

    if (kDebugMode) {
      print('✅ Mock purchase completed for ${product.identifier}');
    }

    return _isPro;
  }

  /// Заглушка восстановления покупок
  Future<bool> restorePurchases() async {
    await _restoreFromStorage();

    if (kDebugMode) {
      print('🔄 Mock restore completed. PRO: $_isPro');
    }

    return _isPro;
  }

  /// Обновление статуса подписки
  Future<void> _activatePro(Duration billingPeriod) async {
    _isPro = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProKey, true);
    final expiryDate = DateTime.now().add(billingPeriod);
    await prefs.setString(_proExpiresAtKey, expiryDate.toIso8601String());
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

    return {
      'isPro': _isPro,
      'expiresAt': expiryIso,
    };
  }

  /// Принудительное обнуление PRO статуса (удобно для тестов)
  Future<void> resetSubscription() async {
    _isPro = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isProKey);
    await prefs.remove(_proExpiresAtKey);
  }

  /// Мок-покупка для тестирования — годовая подписка
  Future<void> mockPurchase() async {
    await purchaseSubscription(_defaultProducts.first.identifier);
  }

  /// Валидация покупки через AppsFlyer SDK Connector
  Future<void> _validatePurchaseWithAppsFlyer(SubscriptionProduct product) async {
    try {
      // Получаем цену из priceText (парсим "2 290 ₽ / год" -> 2290.0)
      final priceMatch = RegExp(r'(\d[\d\s]*\d|\d+)').firstMatch(product.priceText);
      final price = priceMatch != null
          ? double.tryParse(priceMatch.group(1)!.replaceAll(' ', '')) ?? 0.0
          : 0.0;

      final currency = product.priceText.contains('₽') ? 'RUB' : 'USD';

      if (kDebugMode) {
        print('💰 AppsFlyer IAP Validation for ${product.identifier}');
        print('   Price: $price $currency');
      }

      // Отправляем базовое событие покупки в AppsFlyer
      await _appsFlyer.logPurchase(
        product: product.identifier,
        revenue: price,
        currency: currency,
        orderId: 'mock_order_${DateTime.now().millisecondsSinceEpoch}',
        additionalParams: {
          'billing_period': product.billingPeriod.inDays.toString(),
          'product_title': product.title,
          'purchase_source': 'mock',
        },
      );

      // TODO: Когда будет реальный IAP, добавить платформо-специфичную валидацию:
      //
      // Android:
      // await _appsFlyer.validateAndLogAndroidPurchase(
      //   productId: product.identifier,
      //   purchaseToken: realPurchaseToken,
      //   price: price,
      //   currency: currency,
      // );
      //
      // iOS:
      // await _appsFlyer.validateAndLogIOSPurchase(
      //   productId: product.identifier,
      //   transactionId: realTransactionId,
      //   price: price,
      //   currency: currency,
      // );

    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка валидации покупки через AppsFlyer: $error');
      }
    }
  }
}

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService.instance;

  bool get isPro => _subscriptionService.isPro;
  bool get isInitialized => _subscriptionService.isInitialized;

  List<SubscriptionProduct> _availableProducts = const [];
  List<SubscriptionProduct> get availableProducts => _availableProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
      if (kDebugMode) {
        print('❌ Ошибка загрузки продуктов: $e');
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

  Future<void> mockPurchase() async {
    _isLoading = true;
    notifyListeners();

    await _subscriptionService.mockPurchase();

    _isLoading = false;
    notifyListeners();

    if (kDebugMode) {
      print('✅ Mock purchase completed - PRO activated');
    }
  }

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
