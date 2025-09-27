# Настройка DevToDev Analytics в HydraCoach

## 📊 Обзор интеграции

DevToDev предоставляет углубленную аналитику для мобильных приложений, включая монетизацию, retention и поведение пользователей.

## ✅ Текущий статус интеграции

### Платформы
- ✅ **Android**: DevToDev SDK v2.5.1 интегрирован
- ✅ **iOS**: DevToDev SDK v2.6.0 интегрирован через CocoaPods

### Ключевые события

#### 1. Монетизация
- ✅ **subscriptionPayment** - отправляется при покупке подписки
  - Параметры: orderId, price, productId, currencyCode
  - Интегрировано в `SubscriptionService._handlePurchase()`

- ✅ **realCurrencyPayment** - для разовых покупок (готов к использованию)
  - Параметры: orderId, price, productId, currencyCode

#### 2. Онбординг и туториал
- ✅ **tutorial(-2)** - отправляется при завершении онбординга
  - Значения: -1 (начало), 0 (пропущен), 1..N (шаги), -2 (завершен)
  - Интегрировано в `AnalyticsService.logOnboardingComplete()`

#### 3. Прогресс пользователя (готовы к использованию)
- ⏳ **levelUp** - повышение уровня пользователя
- ⏳ **currentBalance** - текущий баланс виртуальной валюты

## 🔧 Технические детали

### Flutter сервис
```dart
// lib/services/devtodev_analytics_service.dart
DevToDevAnalyticsService() {
  // Автоматически инициализируется с ключами из devtodev_config.dart
}
```

### Android реализация
```kotlin
// android/app/src/main/kotlin/.../DevToDevMethodHandler.kt
- Использует reflection для работы с SDK
- Поддерживает разные версии SDK
- Логирует события через DTDAnalytics.INSTANCE
```

### iOS реализация
```swift
// ios/Runner/AppDelegate.swift
- DevToDevBridge класс для интеграции
- Использует runtime селекторы для вызова методов SDK
- Поддерживает разные версии SDK
```

## 📈 Что отслеживаем

### Основные метрики
1. **Монетизация**
   - Все подписки (месячные, годовые)
   - Конверсия из trial в платную подписку
   - LTV и ARPU

2. **Воронка онбординга**
   - Завершение онбординга
   - Точки отвала

3. **Retention**
   - DAU, MAU
   - Retention по дням (1, 3, 7, 14, 30)

4. **Custom события**
   - Все события из Firebase дублируются в DevToDev
   - water_goal_100_* milestone события

## 🚀 Проверка работы

### Android
```bash
# Смотрим логи DevToDev
adb logcat | grep -E "DevToDev|DTD"
```

### iOS
```bash
# В Xcode console фильтруем по "DevToDev"
```

### Dashboard DevToDev
1. Заходим в [DevToDev Dashboard](https://app.devtodev.com)
2. Проверяем раздел "Real-time"
3. Смотрим "Custom Events" для проверки событий

## ⚠️ Известные проблемы и решения

### Проблема: События не появляются в дашборде
**Решение**:
- Проверить инициализацию SDK в логах
- Убедиться что используются правильные App ID и Secret Key
- События могут появляться с задержкой до 5 минут

### Проблема: Платежи не трекаются
**Решение**:
- Проверить что вызывается `subscriptionPayment` при покупке
- Убедиться что price > 0 и currencyCode корректный

### Проблема: Flutter не поддерживается официально
**Решение**:
- Используем Method Channel для нативной интеграции
- Android и iOS handlers обрабатывают вызовы из Flutter

## 📝 TODO
- [ ] Добавить трекинг уровней пользователя (levelUp)
- [ ] Добавить трекинг виртуальной валюты если будет добавлена
- [ ] Настроить push-уведомления через DevToDev
- [ ] Интегрировать A/B тесты

## 🔑 Credentials

### Android (Production)
- App ID: `5b5ca03c-07de-065c-8de4-9c07375ac9b9`
- Secret Key: `oW7S2NpeB5EVR4c6GQUPmdAthlfubigs`
- API Key: `ak-CRhQtT0OMj4GpIqNP7bZHWs6vUaDuF85`

### iOS (Production)
- App ID: `967dd119-476a-01fa-9591-415d27ee6af8`
- Secret Key: `eamugOGLJ0HfPMUBSKxAYFIjX2CkE6n5`
- API Key: `ak-SLgUuvftC0hGDVq8iI9p1KcJ7bnQr2RF`

## 📚 Документация
- [DevToDev SDK v2 Documentation](https://docs.devtodev.com/integration/integration-of-sdk-v2)
- [Basic Methods](https://docs.devtodev.com/integration/integration-of-sdk-v2/setting-up-events/basic-methods)
- [Subscriptions](https://docs.devtodev.com/integration/integration-of-sdk-v2/setting-up-events/basic-methods#subscriptions)