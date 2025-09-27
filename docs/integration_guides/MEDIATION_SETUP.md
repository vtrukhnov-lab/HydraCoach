# AppLovin MAX Mediation Setup Guide

## ✅ Интеграция завершена

### Android
Добавлены все адаптеры медиированных сетей в `android/app/build.gradle.kts`:
- Google AdMob & Ad Manager
- Meta (Facebook)
- Mintegral
- Unity Ads
- IronSource
- Chartboost
- DT Exchange (Fyber)
- Liftoff Monetize (Vungle)
- BidMachine
- Ogury
- MobileFuse
- Moloco

### iOS
Добавлены все Pod зависимости в `ios/Podfile`:
- Те же сети, что и для Android
- SKAdNetwork идентификаторы в Info.plist
- AppLovin SDK Key в Info.plist

## 🔧 Следующие шаги

### 1. Обновить зависимости

**Android:**
```bash
cd android
./gradlew clean
./gradlew build
```

**iOS:**
```bash
cd ios
pod repo update
pod install
```

### 2. Настройка в AppLovin Dashboard

Паблишер (Playcus) должен настроить в [AppLovin Dashboard](https://dash.applovin.com):

#### Для каждой медиированной сети:
1. Добавить учетные данные сети (App ID, Ad Unit IDs)
2. Настроить Waterfall или Bidding
3. Установить eCPM floors

#### Примеры необходимых данных:

**Google AdMob:**
- App ID: `ca-app-pub-5658037951569538~8152522725` (Android)
- App ID: `ca-app-pub-5658037951569538~8820120029` (iOS)
- Ad Unit IDs для каждого типа рекламы

**Meta (Facebook):**
- App ID из Facebook Developer Console
- Placement IDs

**Unity Ads:**
- Game ID
- Placement IDs

### 3. Тестирование медиации

В коде добавить для тестирования:
```dart
// lib/main.dart или где инициализируется AppLovin MAX

import 'package:applovin_max/applovin_max.dart';

// Включить тестовый режим
await MaxSdk.setVerboseLogging(true);

// Установить тестовые устройства
await MaxSdk.setTestDeviceAdvertisingIds([
  'YOUR_ANDROID_ADVERTISING_ID', // GAID
  'YOUR_IOS_IDFA',               // IDFA
]);

// Показать медиацию дебаггер
await MaxSdk.showMediationDebugger();
```

### 4. Проверка интеграции

Используйте [AppLovin Mediation Debugger](https://dash.applovin.com/documentation/mediation/flutter/testing-networks/mediation-debugger):

1. Запустите приложение на устройстве
2. Вызовите `MaxSdk.showMediationDebugger()`
3. Проверьте статус каждой сети:
   - ✅ Зеленый - сеть готова
   - ⚠️ Желтый - требуется настройка
   - ❌ Красный - ошибка интеграции

## 📊 Ожидаемые результаты

С медиацией вы получите:
- **Fill Rate**: 95-99% (vs 60-70% с одной сетью)
- **eCPM увеличение**: 30-50%
- **Автоматическая оптимизация**: AppLovin выбирает самую дорогую рекламу

## ⚠️ Важные моменты

1. **Конфигурация сетей** - все настройки делаются в AppLovin Dashboard, не в коде
2. **App-ads.txt** - добавьте записи всех сетей на ваш сайт
3. **Privacy** - обновите Privacy Policy с упоминанием всех рекламных партнеров
4. **GDPR/CCPA** - AppLovin автоматически передает согласия всем сетям

## 🔍 Отладка

Если реклама не показывается:
1. Проверьте логи: `adb logcat | grep -i applovin`
2. Убедитесь что Ad Unit IDs правильные
3. Проверьте Mediation Debugger
4. Убедитесь что аккаунты сетей активны

## 📱 Контакты для настройки

Паблишеру (Playcus) нужно:
1. Создать/настроить аккаунты в каждой рекламной сети
2. Получить App IDs и Ad Unit IDs
3. Добавить их в AppLovin Dashboard
4. Предоставить нам финальные Ad Unit IDs для каждого типа рекламы

## 🎯 Приоритет сетей

Рекомендуемый waterfall (от высокого к низкому eCPM):
1. Google AdMob
2. Meta Audience Network
3. Unity Ads
4. AppLovin Exchange
5. Mintegral
6. IronSource
7. Остальные сети

AppLovin MAX автоматически оптимизирует это на основе реальных данных.