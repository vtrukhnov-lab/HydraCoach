# HydraCoach v2.1.5 - Changelog

## 📊 DevToDev Analytics Integration

### ✅ Subscription API (Server-Side)
- **HTTP POST интеграция** для отслеживания событий подписок через серверный API
- **Поддержка всех типов событий:**
  - `PURCHASE` - обычная покупка подписки
  - `TRIAL_PURCHASE` - покупка с триалом
  - `RENEWAL` - автоматическое продление
  - `CANCELLATION` - отмена подписки
  - `REFUND` - возврат средств
- **Автоматическая отправка** при покупке через Google Play Billing
- **Передача метаданных:**
  - transactionId, originalTransactionId
  - startDateMs, expiresDateMs
  - productId, price, currency, isTrial
  - devtodevId (получается автоматически из SDK)

**Файлы:**
- `lib/services/devtodev_analytics_service.dart:278-360`
- `lib/services/subscription_service.dart:417-437`
- `android/.../DevToDevMethodHandler.kt:285-357`

---

### 💰 Ad Revenue Tracking
- **SDK метод `adImpression()`** для отслеживания рекламного дохода
- **Интеграция с AppLovin MAX:**
  - Banner ads (320x50) - 10+ экранов
  - MREC ads (300x250) - premium placement
- **Автоматическая отправка** при получении дохода от рекламы
- **Параметры:**
  - network (название медиации сети: AdMob, Meta, Unity, etc.)
  - revenue (доход в USD)
  - placement (место размещения)
  - unit (ad unit ID)

**Файлы:**
- `lib/services/devtodev_analytics_service.dart:263-296`
- `lib/widgets/home/ad_banner_card.dart:69-74`
- `lib/widgets/home/ad_mrec_card.dart:97-102`
- `android/.../DevToDevMethodHandler.kt:329-357`

**⚠️ Важно:** Не используйте SDK метод если настроена S2S интеграция между AppLovin MAX и DevToDev (для избежания дублирования данных).

---

### 🎯 Tutorial/Onboarding Tracking
- **DevToDev tutorial() method** интегрирован в онбординг
- **Автоматическая отправка шагов:**
  - `-1` - старт онбординга
  - `1-6` - завершение каждого шага (units, weight, diet, permissions)
  - `-2` - полное завершение онбординга
- **Новые события для воронок:**
  - `first_intake_tutorial_shown` - показ туториала первого добавления воды
  - `first_intake_tutorial_completed` - завершение туториала

**Файлы:**
- `lib/services/analytics_service.dart:712-754, 830-838`
- `lib/screens/onboarding/widgets/first_intake_tutorial.dart:57, 234`

---

### 📈 Conversion Funnels Support
- **Полная поддержка DevToDev Funnels** для анализа пользовательского пути
- **Готовые воронки для настройки:**
  1. **Full Onboarding to First Action** (9 шагов) - от старта до первого добавления воды
  2. **Permissions Funnel** - принятие критических разрешений
  3. **Monetization Funnel** - путь от онбординга до покупки

**Документация:**
- `docs/integration_guides/DEVTODEV_FUNNELS_GUIDE.md` - полное руководство по настройке воронок
- Примеры настройки в DevToDev Dashboard
- Benchmark метрики и рекомендации по оптимизации

---

## 📚 Новая документация

### Интеграционные гайды
- **`DEVTODEV_INTEGRATION_STATUS.md`** - общий статус интеграции (17/26 методов реализовано, 65%)
- **`DEVTODEV_AD_REVENUE_INTEGRATION.md`** - гайд по интеграции рекламного дохода
- **`DEVTODEV_FUNNELS_GUIDE.md`** - руководство по настройке конверсионных воронок

### Что покрывает документация
- Реализованные методы DevToDev SDK
- Инструкции по S2S интеграции (AppLovin MAX → DevToDev)
- Примеры настройки воронок в Dashboard
- Troubleshooting и best practices
- Benchmark метрики для оценки конверсий

---

## 🔧 Технические детали

### Реализованные DevToDev методы (17 из 26)

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
- ✅ `realCurrencyPayment()` - события реальных платежей (legacy)
- ✅ `subscriptionPayment()` - события подписок (legacy)
- ✅ **`sendSubscriptionEvent()`** - новый серверный метод подписок
- ✅ **`adImpression()`** - новый метод рекламного дохода

#### Progression
- ✅ `tutorial()` - прохождение туториала/онбординга
- ✅ `levelUp()` - повышение уровня
- ✅ `currentBalance()` - текущий баланс пользователя

---

## 📊 Измеримые улучшения

| Метрика | Возможность |
|---------|-------------|
| **Subscription Tracking** | 100% покрытие всех событий подписок |
| **Ad Revenue Tracking** | Автоматическое отслеживание с AppLovin MAX |
| **Onboarding Funnel** | Детальная аналитика 9-шаговой воронки |
| **Tutorial Completion** | Точное определение drop-off точек |
| **User Segmentation** | Экспорт user IDs по этапам воронок |

---

## 🎯 Что это дает

### Для аналитики
- **Детальные воронки** - выявление точек отсева пользователей
- **Revenue tracking** - полное отслеживание подписок и рекламного дохода
- **Cohort analysis** - сравнение конверсий между когортами
- **A/B testing support** - измерение влияния изменений

### Для монетизации
- **Subscription events** - отслеживание всего lifecycle подписок
- **Ad revenue** - автоматический учет дохода с рекламы (SDK или S2S)
- **Purchase funnel** - оптимизация пути к покупке

### Для оптимизации
- **Tutorial drop-off** - понимание где пользователи застревают
- **Permission acceptance** - оптимизация запросов разрешений
- **Activation rate** - измерение первого действия пользователя

---

## 🚀 Следующие шаги

### Требуется от паблишера
1. **Создать воронки в DevToDev Dashboard:**
   - Full Onboarding to First Action
   - Permissions Funnel
   - Monetization Funnel

2. **Опционально: S2S интеграция для Ad Revenue**
   - AppLovin Dashboard → Settings → Ad Revenue Postbacks
   - Добавить URL: `https://statgw.devtodev.com/applovin/api?apikey=YOUR_KEY`
   - При S2S отключить SDK метод `adImpression()` для избежания дублирования

3. **Собрать baseline данные:**
   - 1-2 недели данных для определения current state
   - Установить benchmark метрики
   - Начать оптимизацию на основе данных

---

## ⚠️ Breaking Changes
Нет breaking changes - все изменения обратно совместимы.

---

## 🐛 Известные проблемы
- События `first_intake_tutorial_shown/completed` появятся в DevToDev Dashboard только после того как хотя бы один пользователь пройдет обновленную версию приложения
- Некоторые legacy warning в коде (unused variables, dead code в if(false) блоках) - не влияют на функциональность

---

**Дата релиза:** TBD
**Версия кода:** 36
**Версия приложения:** 2.1.5

## 📱 Системные требования

### Android
- **Минимальная версия:** API 28 (Android 9.0)
- **Целевая версия:** API 35 (Android 15)

### iOS
- **Минимальная версия:** iOS 15.0

---

## 📖 Документация

### Основные файлы
- `docs/integration_guides/DEVTODEV_INTEGRATION_STATUS.md` - статус интеграции
- `docs/integration_guides/DEVTODEV_AD_REVENUE_INTEGRATION.md` - ad revenue setup
- `docs/integration_guides/DEVTODEV_FUNNELS_GUIDE.md` - funnels setup

### Полезные ссылки
- [DevToDev Dashboard](https://go.devtodev.com)
- [DevToDev Subscription API Docs](https://docs.devtodev.com/integration/server-api/subscription-api)
- [DevToDev Funnels Docs](https://docs.devtodev.com/reports-and-functionality/project-related-reports-and-fuctionality/events-and-funnels)
- [AppLovin MAX Integration](https://docs.applovin.com)
