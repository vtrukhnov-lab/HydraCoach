import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY'; // Замените на реальный ключ
  static const String proEntitlementIdentifier = 'pro';
  
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();
  
  SubscriptionService._();
  
  bool _isInitialized = false;
  bool _isPro = false;
  
  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;
  
  /// Инициализация RevenueCat
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
      
      // Конфигурируем RevenueCat
      final configuration = PurchasesConfiguration(_apiKey);
      await Purchases.configure(configuration);
      
      // Проверяем текущий статус подписки
      await _checkSubscriptionStatus();
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ RevenueCat инициализирован');
        print('🔒 PRO статус: $_isPro');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации RevenueCat: $e');
      }
    }
  }
  
  /// Проверка статуса подписки
  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _isPro = customerInfo.entitlements.active[proEntitlementIdentifier] != null;
      
      if (kDebugMode) {
        print('📊 Проверка подписки завершена: $_isPro');
        print('📅 Активные подписки: ${customerInfo.entitlements.active.keys.toList()}');
      }
    } catch (e) {
      _isPro = false;
      if (kDebugMode) {
        print('❌ Ошибка проверки подписки: $e');
      }
    }
  }
  
  /// Получение доступных продуктов
  Future<List<StoreProduct>> getAvailableProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      
      if (currentOffering != null) {
        final availablePackages = currentOffering.availablePackages;
        return availablePackages.map((package) => package.storeProduct).toList();
      }
      
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка получения продуктов: $e');
      }
      return [];
    }
  }
  
  /// Покупка подписки
  Future<bool> purchaseSubscription(String productId) async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      
      if (currentOffering != null) {
        // Ищем нужный пакет
        final package = currentOffering.availablePackages.firstWhere(
          (package) => package.storeProduct.identifier == productId,
          orElse: () => throw Exception('Продукт не найден'),
        );
        
        final result = await Purchases.purchasePackage(package);
        _isPro = result.customerInfo.entitlements.active[proEntitlementIdentifier] != null;
        
        if (kDebugMode) {
          print('✅ Покупка успешна! PRO: $_isPro');
        }
        
        return _isPro;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка покупки: $e');
      }
      return false;
    }
  }
  
  /// Восстановление покупок
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _isPro = customerInfo.entitlements.active[proEntitlementIdentifier] != null;
      
      if (kDebugMode) {
        print('🔄 Покупки восстановлены! PRO: $_isPro');
      }
      
      return _isPro;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка восстановления: $e');
      }
      return false;
    }
  }
  
  /// Получение информации о клиенте
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка получения информации о клиенте: $e');
      }
      return null;
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
      'alcohol_log',           // НОВОЕ: базовый лог алкоголя
      'alcohol_harm_reduction', // НОВОЕ: карточка минимум вреда
      'alcohol_morning_checkin', // НОВОЕ: утренний чек-ин
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
      'alcohol_pre_drink': false,    // НОВОЕ
      'alcohol_recovery_plan': false, // НОВОЕ
      'alcohol_sober_calendar': false, // НОВОЕ
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
      'alcohol_pre_drink_protocol': true,    // НОВОЕ
      'alcohol_recovery_plan': true,         // НОВОЕ
      'alcohol_sober_calendar': true,        // НОВОЕ
      'alcohol_extended_checkin': true,      // НОВОЕ
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
    _isLoading = true;
    notifyListeners();
    
    await _subscriptionService.initialize();
    await loadProducts();
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Загрузка доступных продуктов
  Future<void> loadProducts() async {
    try {
      _availableProducts = await _subscriptionService.getAvailableProducts();
      notifyListeners();
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
  /// В продакшене будет заменено на реальную покупку через RevenueCat
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
      print('🎯 Алкогольные PRO функции разблокированы:');
      print('   - Pre-drink протокол');
      print('   - Recovery план на 6-12 часов');
      print('   - Трезвый календарь');
      print('   - Расширенный утренний чек-ин');
    }
  }
  
  /// Проверка доступа к функции
  bool hasFeatureAccess(String featureName) {
    return _subscriptionService.hasFeatureAccess(featureName);
  }
  
  /// Получение информации о ограничениях
  Map<String, dynamic> getFreeLimitations() {
    return _subscriptionService.getFreeLimitations();
  }
  
  Map<String, dynamic> getProFeatures() {
    return _subscriptionService.getProFeatures();
  }
}