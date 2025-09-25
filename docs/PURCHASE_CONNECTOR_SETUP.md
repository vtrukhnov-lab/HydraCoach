# AppsFlyer Purchase Connector для Flutter приложений

## 📋 Оглавление
1. [Что такое Purchase Connector](#что-такое-purchase-connector)
2. [Преимущества использования](#преимущества-использования)
3. [Пошаговая настройка](#пошаговая-настройка)
4. [Важные моменты](#важные-моменты)
5. [Отладка и тестирование](#отладка-и-тестирование)
6. [Частые ошибки](#частые-ошибки)

## Что такое Purchase Connector

AppsFlyer Purchase Connector - это инструмент для автоматической валидации и отслеживания внутренних покупок (IAP) в мобильных приложениях. Он работает на уровне S2S (Server-to-Server) API и автоматически валидирует все покупки через серверы Apple/Google.

### Ключевые особенности:
- **Автоматическая валидация** всех покупок через S2S API
- **Защита от мошенничества** - валидация чеков на стороне сервера
- **Единая точка правды** - нет дублирования событий
- **Автоматическое переключение** между sandbox и production

## Преимущества использования

### ✅ Что дает Purchase Connector:
1. **Автоматическая отправка событий** с префиксом `af_ars_`:
   - `af_ars_subscribe` - подписки
   - `af_ars_inapp` - разовые покупки
   - В sandbox режиме добавляется суффикс `_sandbox_s2s`

2. **Валидация на стороне сервера** - защита от взломанных покупок

3. **Детальная информация** о покупке:
   - Цена и валюта
   - Тип продукта (подписка/разовая)
   - Статус валидации
   - Order ID для сверки

### ❌ Что НЕ нужно делать при использовании Purchase Connector:
- Отправлять SDK события `af_subscribe` или `af_purchase` вручную
- Валидировать чеки самостоятельно
- Переключать sandbox/production режимы вручную

## Пошаговая настройка

### Шаг 1: Добавление зависимостей

#### pubspec.yaml
```yaml
dependencies:
  appsflyer_sdk: ^6.14.3
  in_app_purchase: ^3.2.0
```

#### android/app/build.gradle.kts
```kotlin
dependencies {
    // Google Play Billing (обязательно для Android)
    implementation("com.android.billingclient:billing:7.1.1")

    // AppsFlyer Purchase Connector
    implementation("com.appsflyer:purchase-connector:2.1.0") {
        isTransitive = true
    }
}
```

#### android/gradle.properties
```properties
# Включаем Purchase Connector для Android
appsflyer.enable_purchase_connector=true
```

### Шаг 2: Создание сервиса Purchase Connector

```dart
import 'package:flutter/foundation.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class PurchaseConnectorService {
  static final PurchaseConnectorService _instance =
      PurchaseConnectorService._internal();
  factory PurchaseConnectorService() => _instance;
  PurchaseConnectorService._internal();

  PurchaseConnector? _purchaseConnector;
  bool _isInitialized = false;
  bool _isObserving = false;

  /// Инициализация Purchase Connector
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Создаем конфигурацию
      final config = PurchaseConnectorConfiguration(
        // Включаем отслеживание подписок
        logSubscriptions: true,
        // Включаем отслеживание разовых покупок
        logInApps: true,
        // Автоматическое переключение sandbox/production
        sandbox: kDebugMode,
      );

      // Инициализируем Purchase Connector
      _purchaseConnector = PurchaseConnector(config: config);
      _isInitialized = true;

      if (kDebugMode) {
        print('✅ Purchase Connector инициализирован');
      }
    } catch (e) {
      print('❌ Ошибка инициализации: $e');
      rethrow;
    }
  }

  /// Запуск отслеживания транзакций
  Future<void> startObservingTransactions() async {
    if (!_isInitialized || _purchaseConnector == null) {
      throw StateError('Purchase Connector не инициализирован');
    }

    if (_isObserving) return;

    try {
      _purchaseConnector!.startObservingTransactions();
      _isObserving = true;

      if (kDebugMode) {
        print('✅ Purchase Connector начал отслеживание');
      }
    } catch (e) {
      print('❌ Ошибка запуска: $e');
      rethrow;
    }
  }

  /// Полная инициализация и запуск
  Future<void> initializeAndStart() async {
    await initialize();
    await startObservingTransactions();
  }
}
```

### Шаг 3: Интеграция в main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Инициализируем AppsFlyer SDK
  final appsFlyerSdk = AppsflyerSdk(options);
  await appsFlyerSdk.initSdk();

  // 2. Запускаем AppsFlyer SDK
  await appsFlyerSdk.startSDK();

  // 3. ВАЖНО: Ждем 1 секунду после startSDK()
  await Future.delayed(const Duration(seconds: 1));

  // 4. Инициализируем и запускаем Purchase Connector
  final purchaseConnector = PurchaseConnectorService();
  await purchaseConnector.initializeAndStart();

  runApp(MyApp());
}
```

### Шаг 4: Обработка покупок (НЕ отправляем дубли!)

```dart
class SubscriptionService {
  // Обработка покупки
  Future<void> processPurchase(PurchaseDetails purchase) async {
    // Валидируем покупку через in_app_purchase
    if (purchase.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchase);
    }

    // ✅ ПРАВИЛЬНО: Просто обрабатываем покупку
    // Purchase Connector автоматически отправит S2S событие
    if (kDebugMode) {
      print('💰 Покупка обработана: ${purchase.productID}');
      print('   Purchase Connector отправит S2S событие');
    }

    // ❌ НЕПРАВИЛЬНО: НЕ отправляем SDK события!
    // await appsFlyerSdk.logEvent('af_subscribe', {...});
    // Это создаст дубликат события!

    // Обновляем UI/состояние приложения
    updateSubscriptionStatus(purchase);
  }
}
```

## Важные моменты

### 🔑 Ключевые правила:

1. **Порядок инициализации критичен:**
   - Сначала AppsFlyer SDK init и start
   - Задержка 1 секунда
   - Затем Purchase Connector

2. **Автоматическое переключение sandbox/production:**
   ```dart
   sandbox: kDebugMode  // true в debug, false в release
   ```

3. **События отправляются автоматически:**
   - В production: `af_ars_subscribe`, `af_ars_inapp`
   - В sandbox: `af_ars_sandbox_s2s`

4. **НЕ дублируйте события:**
   - Purchase Connector сам отправляет все нужные события
   - Не нужно вызывать `logEvent('af_subscribe')`

### 🔐 Для GDPR/Consent Management:

Если используете Usercentrics или другой consent manager:

```dart
// 1. Сначала получаем consent
final hasConsent = await consentService.checkConsent();

// 2. Запускаем AppsFlyer только после согласия
if (hasConsent) {
  await appsFlyerSdk.startSDK();
  await Future.delayed(Duration(seconds: 1));
  await purchaseConnector.initializeAndStart();
}
```

## Отладка и тестирование

### Проверка в логах:

```
✅ Успешная инициализация:
🔗 Инициализируем AppsFlyer Purchase Connector...
✅ Purchase Connector инициализирован через Flutter SDK
   - logSubscriptions: true
   - logInApps: true
   - sandbox: true (test mode)
🔍 Запускаем отслеживание транзакций...
✅ Purchase Connector начал отслеживание

✅ Успешная покупка:
🎯 Purchase detected: monthly_subscription
💎 Validating subscription via S2S API...
✅ Purchase validated successfully
📊 Event sent: af_ars_sandbox_s2s
```

### Проверка в AppsFlyer Dashboard:

1. **Live Events** - события с префиксом `af_ars_` должны появляться
2. **Raw Data Export** - проверьте S2S события
3. **Validation** - статус должен быть "validated"

## Частые ошибки

### ❌ Ошибка 1: События не появляются в Dashboard

**Причина:** Purchase Connector запущен до AppsFlyer SDK

**Решение:**
```dart
// Правильный порядок
await appsFlyerSdk.startSDK();
await Future.delayed(Duration(seconds: 1));  // Критично!
await purchaseConnector.initializeAndStart();
```

### ❌ Ошибка 2: Дублирование событий

**Причина:** Отправка SDK событий вручную + Purchase Connector

**Решение:** Удалите все вызовы:
```dart
// Удалите эти строки:
appsFlyerSdk.logEvent('af_subscribe', {...});
appsFlyerSdk.logEvent('af_purchase', {...});
```

### ❌ Ошибка 3: Purchase Connector не инициализирован

**Причина:** Отсутствует флаг в gradle.properties

**Решение:** Добавьте в android/gradle.properties:
```properties
appsflyer.enable_purchase_connector=true
```

### ❌ Ошибка 4: События только в Raw Data, не в Live Events

**Причина:** Неправильная конфигурация sandbox режима

**Решение:** Используйте автоматическое переключение:
```dart
sandbox: kDebugMode  // Не hardcode true/false!
```

## Полезные ссылки

- [Официальная документация](https://github.com/AppsFlyerSDK/appsflyer-flutter-plugin/blob/master/doc/PurchaseConnector.md)
- [AppsFlyer Flutter Plugin](https://pub.dev/packages/appsflyer_sdk)
- [In-App Purchase Plugin](https://pub.dev/packages/in_app_purchase)

---

**Последнее обновление:** Декабрь 2024
**Версия AppsFlyer SDK:** 6.14.3
**Версия Purchase Connector:** 2.1.0