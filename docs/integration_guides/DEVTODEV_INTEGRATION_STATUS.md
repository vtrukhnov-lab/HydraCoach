# DevToDev Integration Status - HydraCoach

## ✅ Реализованные компоненты

### 1. **Subscription API** ✅
- **HTTP POST метод** `sendSubscriptionEvent()` - отправка событий подписок на серверный API
- **Типы событий:** PURCHASE, TRIAL_PURCHASE, TRIAL_CANCELLATION, RENEWAL, CANCELLATION, REFUND
- **Автоматическая отправка** при покупке/восстановлении подписок через Google Play Billing
- **Файлы:**
  - `lib/services/devtodev_analytics_service.dart:278-360`
  - `lib/services/subscription_service.dart:417-437`
  - `android/app/src/main/kotlin/com/playcus/hydracoach/DevToDevMethodHandler.kt:285-357`

**Пример использования:**
```dart
await _devToDev.sendSubscriptionEvent(
  eventType: SubscriptionEventType.purchase,
  transactionId: purchaseDetails.purchaseID,
  originalTransactionId: purchaseDetails.purchaseID,
  startDateMs: now.millisecondsSinceEpoch,
  expiresDateMs: expiryDate.millisecondsSinceEpoch,
  productId: 'hydracoach_pro_yearly',
  price: 2290.0,
  currency: 'RUB',
  isTrial: false,
);
```

---

### 2. **Ad Revenue Tracking** ✅
- **SDK метод** `adImpression()` для отслеживания рекламного дохода
- **Интеграция с AppLovin MAX** через callbacks в Banner и MREC виджетах
- **Автоматическая отправка** при получении дохода от рекламы
- **Файлы:**
  - `lib/services/devtodev_analytics_service.dart:263-296`
  - `lib/widgets/home/ad_banner_card.dart:69-74`
  - `lib/widgets/home/ad_mrec_card.dart:97-102`
  - `android/app/src/main/kotlin/com/playcus/hydracoach/DevToDevMethodHandler.kt:329-357`

**Пример использования:**
```dart
devToDev.adImpression(
  network: 'AdMob',
  revenue: 0.45,
  placement: 'banner_main',
  unit: '93ba29d40d0c9ed1',
);
```

**⚠️ Важно:** Не используйте SDK метод если настроена S2S интеграция между AppLovin MAX и DevToDev (для избежания дублирования данных).

---

### 3. **Basic SDK Methods** ✅

Реализованы следующие методы:

#### User Management
- ✅ `initialize()` - инициализация SDK
- ✅ `setUserId()` - установка custom user ID
- ✅ `clearUserId()` - очистка user ID
- ✅ `getDevToDevId()` - получение DevToDev ID пользователя

#### Events & Analytics
- ✅ `logEvent()` - кастомные события с параметрами
- ✅ `logScreenView()` - отслеживание просмотров экранов
- ✅ `setUserProperty()` - установка свойств пользователя
- ✅ `setTrackingEnabled()` - включение/отключение трекинга

#### Monetization
- ✅ `realCurrencyPayment()` - события реальных платежей (legacy метод)
- ✅ `subscriptionPayment()` - события подписок (legacy метод)
- ✅ `sendSubscriptionEvent()` - **новый серверный метод подписок**
- ✅ `adImpression()` - **новый метод рекламного дохода**

#### Progression
- ✅ `tutorial()` - прохождение туториала
- ✅ `levelUp()` - повышение уровня
- ✅ `currentBalance()` - текущий баланс пользователя

---

## ⏳ Не реализованные методы (из документации)

### User Profile (Advanced)
- ⏳ `DTDUserCard.set()` - установка кастомных свойств пользователя
- ⏳ `DTDUserCard.unset()` - удаление свойств
- ⏳ `DTDUserCard.clearUser()` - очистка всех свойств
- ⏳ `replaceUserId()` - замена user ID
- ⏳ `setCheater()` -ометка читера
- ⏳ `setTester()` - отметка тестера

### Virtual Economy
- ⏳ `virtualCurrencyPayment()` - траты виртуальной валюты
- ⏳ `currencyAccrual()` - начисление виртуальной валюты

### Game Progression
- ⏳ `progressionEvent()` - события прогрессии (старт/завершение/неудача)

### Social & Referral
- ⏳ `socialNetworkConnect()` - подключение соцсетей
- ⏳ `socialNetworkPost()` - публикации в соцсетях
- ⏳ `referralEvent()` - реферальные события

---

## 🔧 Рекомендации по дальнейшей интеграции

### 1. S2S интеграция для Ad Revenue (приоритет: HIGH)
**Рекомендуется настроить** вместо SDK метода:

1. Зайти в AppLovin MAX Dashboard
2. Settings → Ad Revenue Postbacks
3. Добавить DevToDev Postback URL:
   ```
   https://statgw.devtodev.com/applovin/api?apikey=ak-CRhQtT0OMj4GpIqNP7bZHWs6vUaDuF85
   ```
4. **Закомментировать** вызовы `devToDev.adImpression()` в коде для избежания дублирования

**Преимущества S2S:**
- ✅ Более точные данные (не зависят от клиента)
- ✅ Нет потерь данных при проблемах на клиенте
- ✅ Автоматическая интеграция - не нужно обновлять код

---

### 2. Расширенные события пользователей (приоритет: MEDIUM)

Если требуется более детальная аналитика пользователей, можно добавить:

```dart
// User Profile API
await _devToDev.setUserProperty('vip_status', 'gold');
await _devToDev.setUserProperty('last_hydration_ml', '2500');

// Virtual Economy (если добавите игрофикацию)
await _devToDev.virtualCurrencyPayment(
  purchaseName: 'unlock_achievement',
  purchaseAmount: 1,
  purchaseType: 'points',
  price: 100,
  currencyName: 'hydration_points',
);
```

---

### 3. Progression Events для Gamification (приоритет: LOW)

Если добавите игровую механику с уровнями/достижениями:

```dart
// Старт прохождения уровня
await _devToDev.progressionEvent(
  status: ProgressionStatus.start,
  location: 'weekly_challenge',
  level: 1,
);

// Завершение уровня
await _devToDev.progressionEvent(
  status: ProgressionStatus.complete,
  location: 'weekly_challenge',
  level: 1,
  spent: {'time_minutes': 45},
  earned: {'hydration_points': 500},
);
```

---

## 📊 Текущая статистика интеграции

| Категория | Реализовано | Доступно | % |
|-----------|-------------|----------|---|
| **Subscription API** | 1/1 | 1 | 100% |
| **Ad Revenue** | 1/1 | 1 | 100% |
| **User Management** | 4/7 | 7 | 57% |
| **Events & Analytics** | 4/4 | 4 | 100% |
| **Monetization** | 4/4 | 4 | 100% |
| **Progression** | 3/6 | 6 | 50% |
| **Social** | 0/3 | 3 | 0% |
| **ИТОГО** | **17/26** | 26 | **65%** |

---

## 🎯 Приоритетные задачи

### Высокий приоритет
1. ✅ ~~Subscription API~~ (готово)
2. ✅ ~~Ad Revenue tracking~~ (готово)
3. ⏳ **S2S интеграция для Ad Revenue** (требуется настройка в AppLovin Dashboard)

### Средний приоритет
4. ⏳ User Profile расширенные методы (по требованию)
5. ⏳ Virtual Economy (если добавите игрофикацию)

### Низкий приоритет
6. ⏳ Progression Events (если добавите игровую механику)
7. ⏳ Social Network интеграции (если добавите соцсети)

---

## 📖 Документация

- **Subscription API:** `docs/integration_guides/DEVTODEV_SUBSCRIPTION_API.md`
- **Ad Revenue:** `docs/integration_guides/DEVTODEV_AD_REVENUE_INTEGRATION.md`
- **Общая настройка:** `docs/integration_guides/DEVTODEV_SETUP.md`

---

## 🧪 Тестирование

### Проверка Subscription Events

1. Сделайте тестовую покупку подписки
2. Проверьте логи Android:
   ```bash
   adb logcat | grep -i "devtodev"
   ```
3. Должны увидеть:
   ```
   📤 Отправка события подписки в DevToDev:
      Type: PURCHASE
      Product: hydracoach_pro_yearly
      Price: 2290.0 RUB
      DevToDev ID: 12345678
   ✅ Событие подписки успешно отправлено в DevToDev
   ```

### Проверка Ad Revenue

1. Дождитесь показа баннера/MREC
2. Проверьте логи:
   ```bash
   adb logcat | grep -i "ad revenue"
   ```
3. Должны увидеть:
   ```
   💰 Banner Ad Revenue tracked: $0.45 from AdMob
   📺 DevToDev Ad Impression: AdMob, $0.45, banner_main, 93ba29d40d0c9ed1
   ```

### Проверка в DevToDev Dashboard

1. Зайдите в [DevToDev Dashboard](https://go.devtodev.com)
2. **Subscriptions:** Reports → Monetization → Subscriptions
3. **Ad Revenue:** Reports → Monetization → Ad Revenue
4. Данные появляются с задержкой 5-15 минут

---

## ⚠️ Важные замечания

1. **Subscription API** - серверная интеграция через HTTP POST, не дублируется с SDK методом
2. **Ad Revenue** - используйте **либо** SDK метод **либо** S2S интеграцию, не оба
3. **DevToDev ID** - получается автоматически из нативного SDK, не требует ручной настройки
4. **API Keys** - хранятся в `lib/services/devtodev_config.dart`, разные для Android/iOS

---

## 🔗 Полезные ссылки

- [DevToDev Subscription API](https://docs.devtodev.com/integration/server-api/subscription-api)
- [DevToDev Ad Revenue API](https://docs.devtodev.com/3rd-party-sources/ad-revenue/ad-revenue-api)
- [DevToDev Android SDK v2](https://docs.devtodev.com/integration/integration-of-sdk-v2/setting-up-events/basic-methods)
- [AppLovin MAX Dashboard](https://dash.applovin.com)
