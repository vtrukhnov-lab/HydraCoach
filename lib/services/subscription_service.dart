import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String proEntitlementIdentifier = 'pro';
  
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();
  
  SubscriptionService._();
  
  bool _isInitialized = false;
  bool _isPro = false;
  
  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;
  
  /// Инициализация сервиса подписок (временная заглушка)
  /// TODO: Интегрировать с AppsFlyer ROI360 когда будет готово
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Загружаем сохраненный PRO статус из локального хранилища
      final prefs = await SharedPreferences.getInstance();
      _isPro = prefs.getBool('is_pro') ?? false;
      
      // Проверяем срок действия подписки если есть
      final expiresAtStr = prefs.getString('pro_expires_at');
      if (expiresAtStr != null) {
        final expiresAt = DateTime.tryParse(expiresAtStr);
        if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
          // Подписка истекла
          _isPro = false;
          await prefs.setBool('is_pro', false);
          await prefs.remove('pro_expires_at');
        }
      }
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ Subscription Service инициализирован (заглушка)');
        print('🔒 PRO статус: $_isPro');
        print('⚠️ TODO: Интегрировать AppsFlyer ROI360 для реальных покупок');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации Subscription Service: $e');
      }
    }
  }
  
  /// Получение доступных продуктов (заглушка)
  Future<List<StoreProduct>> getAvailableProducts() async {
    // Возвращаем тестовые продукты для разработки
    return [
      StoreProduct(
        identifier: 'hydracoach_monthly',
        title: 'HydraCoach PRO Monthly',
        description: 'Unlimited reminders, CSV export, and more',
        price: 4.99,
        priceString: '\$4.99',
      ),
      StoreProduct(
        identifier: 'hydracoach_annual',
        title: 'HydraCoach PRO Annual',
        description: 'Save 40% with annual subscription',
        price: 35.99,
        priceString: '\$35.99',
      ),
    ];
  }
  
  /// Покупка подписки (заглушка)
  Future<bool> purchaseSubscription(String productId) async {
    try {
      if (kDebugMode) {
        print('⚠️ Покупка подписки (заглушка): $productId');
        print('TODO: Интегрировать с AppsFlyer ROI360');
      }
      
      // Для тестирования активируем PRO
      _isPro = true;
      
      // Сохраняем в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_pro', true);
      
      // Устанавливаем срок действия в зависимости от продукта
      final expiresAt = productId.contains('annual')
          ? DateTime.now().add(const Duration(days: 365))
          : DateTime.now().add(const Duration(days: 30));
      
      await prefs.setString('pro_expires_at', expiresAt.toIso8601String());
      
      if (kDebugMode) {
        print('✅ Покупка успешна (заглушка)! PRO: $_isPro');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка покупки: $e');
      }
      return false;
    }
  }
  
  /// Восстановление покупок (заглушка)
  Future<bool> restorePurchases() async {
    try {
      if (kDebugMode) {
        print('⚠️ Восстановление покупок (заглушка)');
        print('TODO: Интегрировать с AppsFlyer ROI360');
      }
      
      // Для тестирования просто возвращаем сохраненный статус
      final prefs = await SharedPreferences.getInstance();
      _isPro = prefs.getBool('is_pro') ?? false;
      
      if (kDebugMode) {
        print('🔄 Покупки восстановлены (заглушка)! PRO: $_isPro');
      }
      
      return _isPro;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка восстановления: $e');
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
    // FREE функции всегда доступны
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
    
    // PRO функции требуют подписки
    return _isPro;
  }
  
  /// Получение ограничений FREE версии
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
  
  /// Получение PRO возможностей
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
}

/// Provider для управления состоянием подписки
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  
  bool get isPro => _subscriptionService.isPro;
  bool get isInitialized => _subscriptionService.isInitialized;
  
  List<StoreProduct> _availableProducts = [];
  List<StoreProduct> get availableProducts => _availableProducts;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  /// Инициализация подписки
  Future<void> initialize() async {
    // КРИТИЧНО: НЕ вызываем notifyListeners() в начале
    // чтобы избежать setState during build
    _isLoading = true;
    
    await _subscriptionService.initialize();
    await loadProducts();
    
    _isLoading = false;
    
    // КРИТИЧНО: Откладываем уведомление об изменениях
    // используя Future.microtask чтобы избежать setState during build
    await Future.microtask(() {
      notifyListeners();
    });
  }
  
  /// Загрузка доступных продуктов
  Future<void> loadProducts() async {
    try {
      _availableProducts = await _subscriptionService.getAvailableProducts();
      // Уведомляем только если это не происходит во время build
      if (!_isLoading) {
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка загрузки продуктов: $e');
      }
    }
  }
  
  /// Покупка подписки
  Future<bool> purchaseSubscription(String productId) async {
    _isLoading = true;
    notifyListeners();
    
    final success = await _subscriptionService.purchaseSubscription(productId);
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// Восстановление покупок
  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();
    
    final success = await _subscriptionService.restorePurchases();
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// ЗАГЛУШКА для тестирования покупки PRO версии
  /// TODO: Заменить на реальную интеграцию с AppsFlyer ROI360
  Future<void> mockPurchase() async {
    _isLoading = true;
    notifyListeners();
    
    // Имитируем процесс покупки
    await Future.delayed(const Duration(seconds: 2));
    
    // Устанавливаем PRO статус
    _subscriptionService._isPro = true;
    
    // Сохраняем в SharedPreferences для персистентности
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro', true);
    await prefs.setString('pro_expires_at', 
      DateTime.now().add(const Duration(days: 365)).toIso8601String()); // Годовая подписка
    
    _isLoading = false;
    notifyListeners();
    
    if (kDebugMode) {
      print('✅ Mock purchase completed - PRO activated');
      print('⚠️ TODO: Интегрировать с AppsFlyer ROI360 для реальных покупок');
    }
  }
  
  /// Проверка доступа к функции
  bool hasFeatureAccess(String featureName) {
    return _subscriptionService.hasFeatureAccess(featureName);
  }
  
  /// Получение информации об ограничениях
  Map<String, dynamic> getFreeLimitations() {
    return _subscriptionService.getFreeLimitations();
  }
  
  Map<String, dynamic> getProFeatures() {
    return _subscriptionService.getProFeatures();
  }
}