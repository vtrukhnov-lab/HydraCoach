# Monetization Integration Setup

Документация по интеграции AppsFlyer, AdMob и MAX SDK в приложение HydroCoach.

## ✅ Завершено

### 1. AppsFlyer SDK
- ✅ SDK добавлен в `pubspec.yaml`
- ✅ Конфигурация создана в `lib/services/appsflyer_config.dart`
- ✅ Сервис создан в `lib/services/appsflyer_service.dart`
- ✅ Интегрирован в `AnalyticsService`

**Ключи настроены:**
- Android & iOS Dev Key: `QEcQmWqRcQNEtyk6iqNKNX`
- Bundle ID: `com.playcus.hydracoach`
- iOS App ID: `6752772787`

### 2. AdMob Configuration
- ✅ Android App ID добавлен в `AndroidManifest.xml`: `ca-app-pub-5658037951569538~8152522725`
- ✅ iOS App ID добавлен в `Info.plist`: `ca-app-pub-5658037951569538~8820120029`

**Ad Unit IDs настроены в `appsflyer_config.dart`:**

**Android:**
- Interstitial: `ceab74e2fb53cbe2`
- Rewarded: `916df6209beb8007`
- Banner: `93ba29d40d0c9ed1`

**iOS:**
- Interstitial: `9fad30996e03b5b8`
- Rewarded: `60795c12dadfad1e`
- Banner: `637af50c7df33543`

### 3. MAX SDK
- ✅ Базовая структура создана в `lib/services/max_sdk_service.dart`
- ✅ SDK Key: `5AAhiuFzwRBZXL6NRkfMQIFE9TpJ-fX4qinXb1VVTh4_1ANSv1qJJ3TSWLnV_Jaq1LLcMr7rXCqTMC0FDqZXu6`

### 4. AppsFlyer Purchase Connector
- ✅ Android Purchase Connector добавлен в `android/app/build.gradle.kts`
- ✅ iOS Purchase Connector добавлен в `ios/Podfile`
- ✅ Нативная интеграция создана в `android/app/src/main/kotlin/com/playcus/hydracoach/MainActivity.kt`
- ✅ Нативная интеграция создана в `ios/Runner/AppDelegate.swift`
- ✅ Flutter сервис создан в `lib/services/purchase_connector_service.dart`
- ✅ Автоматический запуск с задержкой 1 секунда после AppsFlyer SDK

**Важные особенности:**
- Purchase Connector автоматически отслеживает и валидирует все IAP покупки
- Исключает необходимость ручного вызова `validateAndLogInAppPurchase`
- Предотвращает дублирование revenue данных
- Поддерживает sandbox режим для тестирования

### 5. App Links & Support
- ✅ Privacy Policy добавлен в настройки: `https://www.playcus.com/privacy-policy`
- ✅ Website добавлен в настройки: `https://www.playcus.com`
- ✅ Support Email добавлен в настройки: `support@playcus.com`
- ✅ Company Address добавлен в настройки: `Thiseos 9, Flat/Office C1, Aglantzia, P.C. 2121, Nicosia, Cyprus`
- ✅ UrlLauncherService создан в `lib/services/url_launcher_service.dart`

**Data Safety документы:**
- Google Play: https://docs.google.com/spreadsheets/d/1kPc5mX9z9Nm_7YDGTK1qkH-ZoQRdbXxQ00ICc6n2ipk/edit#gid=15532220
- iOS: https://docs.google.com/spreadsheets/u/0/d/17QaT_AMP7UhtfrVNuZuznlrAyZvMDXlOpToA6-4Cpxg/htmlview#gid=1742509917

## ⚠️ Требуется дополнительная настройка

### 1. Метаданные приложения
Добавить веб-сайт в метаданные приложения:

**Google Play Console:**
- Перейти в Store Settings → Website
- Добавить: `https://www.playcus.com/`

**App Store Connect:**
- Перейти в Version Information → Marketing URL
- Добавить: `https://www.playcus.com/`

### 2. Нативная интеграция MAX SDK
MAX SDK требует добавления нативных библиотек:

**Android (build.gradle):**
```gradle
dependencies {
    implementation 'com.applovin:applovin-sdk:+'
}
```

**iOS (Podfile):**
```ruby
pod 'AppLovinSDK'
```

### 3. Нативные MethodChannel реализации
Требуется создать нативные реализации для:
- `max_sdk` MethodChannel в Android/iOS

## 🧪 Тестирование

После полной интеграции проверить:

1. **AppsFlyer Events:**
   - Установка приложения
   - События воды (water_intake)
   - События подписки (af_purchase)

2. **AdMob/MAX Ads:**
   - Загрузка Interstitial рекламы
   - Показ Rewarded рекламы
   - Отображение Banner рекламы

3. **Attribution Testing:**
   - Organic vs Non-organic пользователи
   - Deep links обработка

## 📊 События аналитики

Все события автоматически отправляются в:
- ✅ Firebase Analytics
- ✅ DevToDev Analytics
- ✅ AppsFlyer (конверсионные события)

Ключевые события для AppsFlyer ROI360:
- `af_purchase` - покупки подписок (автоматически через Purchase Connector)
- `af_complete_registration` - завершение регистрации
- `af_tutorial_completion` - завершение onboarding
- `af_start_trial` - запуск подписки/пробного периода
- `af_cancel_subscription` - отмена подписки
- `af_ars_sandbox_sdk` - события подписок (sandbox) [автоматически]
- `af_ars_sandbox_s2s` - server-to-server события [автоматически]

**ВАЖНО:** Purchase Connector автоматически генерирует события revenue, поэтому кастомные события с revenue удалены во избежание дублирования.

## 🔗 Дополнительные ресурсы

- [AppsFlyer Flutter SDK](https://github.com/AppsFlyerSDK/appsflyer-flutter-plugin)
- [MAX SDK Integration Guide](https://dash.applovin.com/documentation/mediation/flutter/getting-started/integration)
- [AdMob Flutter Setup](https://developers.google.com/admob/flutter/quick-start)