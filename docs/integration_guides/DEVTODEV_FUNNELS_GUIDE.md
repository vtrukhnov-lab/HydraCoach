# DevToDev Funnels Guide - HydraCoach

## Обзор

DevToDev предоставляет мощный инструмент Conversion Funnels для анализа пользовательского пути и выявления точек отсева. В HydraCoach реализована детальная аналитика онбординга, которая идеально подходит для построения воронок.

---

## ✅ Реализованные события для воронок

### 1. Onboarding Tutorial Events (DevToDev SDK)

**Метод**: `DTDAnalytics.tutorial(step)`

| Step Value | Значение | Когда отправляется |
|-----------|----------|-------------------|
| `-1` | Старт туториала | При запуске онбординга |
| `1` | Шаг 1: Units | Выбор системы измерений |
| `2` | Шаг 2: Weight | Ввод веса |
| `3` | Шаг 3: Diet | Выбор диеты/поста |
| `4` | Шаг 4: Complete | Сохранение профиля |
| `5` | Шаг 5: Notifications | Разрешение уведомлений |
| `6` | Шаг 6: Location | Разрешение геолокации |
| `-2` | Завершение туториала | Полное завершение онбординга |
| `0` | Туториал пропущен | (не используется) |

**Код**: `lib/services/analytics_service.dart:712-754`

---

### 2. Custom Onboarding Events (Firebase + AppsFlyer)

Дополнительные детализированные события:

| Событие | Параметры | Описание |
|---------|-----------|----------|
| `onboarding_start` | - | Старт онбординга |
| `onboarding_step_viewed` | `step_id`, `step_index`, `screen_name` | Просмотр шага |
| `onboarding_step_completed` | `step_id`, `step_index` | Завершение шага |
| `onboarding_option_selected` | `step_id`, `option`, `value` | Выбор опции |
| `onboarding_profile_saved` | `weight_kg`, `units`, `diet_mode`, `fasting_enabled` | Сохранение профиля |
| `onboarding_skip` | `step` | Пропуск шага |
| `onboarding_complete` | - | Завершение онбординга |

**Step IDs:**
- `welcome` (0)
- `units` (1)
- `weight` (2)
- `diet` (3)
- `profile_summary` (4)
- `notifications_preview` (5)
- `notification_permission` (6)
- `location_preview` (7)
- `location_permission` (8)

---

## 📊 Рекомендуемые воронки

### Воронка 1: Полный онбординг + активация (Обязательная)

**Цель**: Отследить полный путь пользователя от начала до первого действия

**Шаги:**
1. `onboarding_start` - Старт онбординга
2. `onboarding_step_completed` (step_id: units) - Выбор единиц измерения
3. `onboarding_step_completed` (step_id: weight) - Ввод веса
4. `onboarding_step_completed` (step_id: diet) - Выбор диеты
5. `onboarding_profile_saved` - Сохранение профиля
6. `onboarding_complete` - Завершение онбординга
7. `paywall_shown` (source: onboarding) - Показ paywall после онбординга
8. `first_intake_tutorial_shown` - Показ туториала первого добавления
9. `water_logged` - Первое добавление воды

**Метрики:**
- Общая конверсия онбординга (start → complete): Target 70%+
- Конверсия до первого действия (start → water_logged): Target 60%+
- Drop-off на каждом шаге
- Время прохождения полного flow

**Как настроить в DevToDev:**
1. Reports → Events and Funnels → Create Funnel
2. Название: "Full Onboarding to First Action"
3. Добавить события по порядку
4. Опции:
   - Time limit: 1 час (с учетом paywall и tutorial)
   - Require all steps in order: ✅ Да (для первых 6 шагов)
   - Allow optional steps: ✅ Для paywall (может быть пропущен)
   - Count unique users: ✅ Да

**Альтернатива - короткая воронка:**
Можно создать упрощенную версию без paywall:
1. `onboarding_start`
2. `onboarding_complete`
3. `water_logged` (первое добавление)

Target: 65%+ для короткой воронки

---

### Воронка 2: Разрешения (Permissions)

**Цель**: Отследить принятие критических разрешений

**Шаги:**
1. `onboarding_profile_saved` - Профиль сохранен
2. `onboarding_step_viewed` (step_id: notifications_preview) - Показ preview уведомлений
3. `permission_result` (permission: notifications, status: granted) - Разрешение дано
4. `onboarding_step_viewed` (step_id: location_preview) - Показ preview геолокации
5. `permission_result` (permission: location, status: granted/while_in_use) - Разрешение дано

**Метрики:**
- % пользователей давших разрешение на уведомления
- % пользователей давших разрешение на геолокацию
- Влияние разрешений на retention

**Как настроить:**
1. Reports → Events and Funnels → Create Funnel
2. Название: "Permissions Funnel"
3. Опции:
   - Time limit: 10 минут
   - Allow skipping steps: ✅ Да (пользователи могут пропускать)

---

### Воронка 3: Полный путь к покупке (Monetization)

**Цель**: Отследить путь от онбординга до покупки

**Шаги:**
1. `onboarding_complete` - Завершение онбординга
2. `paywall_shown` (source: onboarding) - Показ paywall после онбординга
3. `af_initiate_checkout` - Начало checkout
4. `af_purchase` или `subscription_purchased` - Покупка

**Метрики:**
- Immediate purchase rate (покупки сразу после онбординга)
- Paywall conversion rate
- Average time to purchase

**Как настроить:**
1. Reports → Events and Funnels → Create Funnel
2. Название: "Onboarding to Purchase"
3. Опции:
   - Time limit: 7 дней
   - Count first occurrence only: ✅ Да

---

## 🎯 Примеры использования воронок

### Анализ drop-off точек

**Проблема**: Высокий отсев на шаге Weight

**Решение:**
1. Зайти в Funnel Report → Onboarding Completion
2. Увидеть что 30% пользователей уходят на Weight Page
3. Проверить `onboarding_option_selected` для weight - возможно ошибка валидации
4. A/B тест: упростить интерфейс ввода веса

---

### Сегментация пользователей

**Создание сегментов:**

1. **Completed Onboarding Segment**
   - Users who completed: `onboarding_complete`
   - Use case: Push notifications, retention campaigns

2. **Dropped at Weight Segment**
   - Users who viewed: `onboarding_step_viewed` (weight)
   - Users who didn't complete: `onboarding_step_completed` (weight)
   - Use case: Re-engagement email, simplified onboarding

3. **Permissions Deniers Segment**
   - Users who completed onboarding
   - Users with `permission_result` (status: denied)
   - Use case: In-app prompt для повторного запроса

---

### Когортный анализ

**Вопрос**: Меняется ли конверсия онбординга со временем?

**Анализ:**
1. Reports → Funnels → Onboarding Completion
2. Group by: Week/Month cohorts
3. Метрика: Overall conversion rate
4. Тренд: Улучшается/Ухудшается после изменений?

---

## 🔧 Настройка в DevToDev Dashboard

### Шаг 1: Создание воронки

1. Зайти в [DevToDev Dashboard](https://go.devtodev.com)
2. Reports → Events and Funnels
3. Click "Create Funnel"

### Шаг 2: Конфигурация

**Основные настройки:**

| Параметр | Рекомендация | Описание |
|----------|--------------|----------|
| Funnel Name | Описательное название | "Onboarding Completion", "Permissions Funnel" |
| Time Limit | 30 минут - 7 дней | Зависит от воронки |
| Require Order | ✅ Да для линейных воронок | Онбординг - линейный процесс |
| Unique Users | ✅ Да | Считаем уникальных пользователей |
| First Session Only | ❌ Нет (обычно) | Онбординг может прерваться |

**Параметры шагов:**

- ✅ **Mandatory steps** - обязательные шаги (units, weight, diet)
- 🔄 **Optional steps** - опциональные (permissions)
- ⚡ **Alternative steps** - альтернативные варианты

### Шаг 3: Анализ данных

**Метрики для отслеживания:**

1. **Overall Conversion Rate**
   - % пользователей прошедших всю воронку
   - Target: >70% для онбординга

2. **Step-by-Step Conversion**
   - Конверсия между соседними шагами
   - Выявление проблемных точек

3. **Time Metrics**
   - Average time to complete
   - Distribution of completion times

4. **Cohort Comparison**
   - Разные версии app
   - A/B тесты
   - Временные тренды

---

## 📈 Ожидаемые результаты

### Benchmark метрики для HydraCoach

| Метрика | Target | Good | Excellent |
|---------|--------|------|-----------|
| Onboarding Completion Rate | 70%+ | 80%+ | 90%+ |
| Step-by-step Drop (avg) | <10% | <7% | <5% |
| Time to Complete | <5 min | <3 min | <2 min |
| Notifications Permission | 50%+ | 65%+ | 80%+ |
| Location Permission | 30%+ | 45%+ | 60%+ |
| Immediate Purchase Rate | 2%+ | 5%+ | 10%+ |

---

## 🚀 Оптимизация на основе воронок

### Если низкая общая конверсия онбординга:

1. **Упростить процесс**
   - Убрать необязательные шаги
   - Показывать прогресс (уже реализовано)
   - Добавить "Skip for now"

2. **Улучшить UX**
   - Анимации и микровзаимодействия (есть)
   - Понятные инструкции
   - Визуализация ценности

3. **A/B тесты**
   - Разное количество шагов
   - Разный порядок шагов
   - С/без paywall после онбординга

### Если низкая конверсия разрешений:

1. **Better Permission Rationale**
   - Объяснить ценность (уже есть preview pages)
   - Показать примеры (есть)
   - Social proof

2. **Timing**
   - Отложить запрос разрешений
   - Запрашивать когда пользователь видит ценность
   - Contextual prompts

---

## 📱 Интеграция с другими инструментами

### Экспорт сегментов

DevToDev позволяет экспортировать user IDs из воронок:

1. Reports → Funnels → Select Funnel
2. Click "Export Users"
3. Выбрать шаг воронки
4. Экспорт в CSV

**Use cases:**
- Email кампании для re-engagement
- Push notifications для специфичных сегментов
- Lookalike audiences в Facebook/Google Ads

### Cross-tool analysis

**DevToDev + Firebase:**
- DevToDev: Детальные воронки онбординга
- Firebase: User properties, retention, A/B tests

**DevToDev + AppsFlyer:**
- DevToDev: Подробная аналитика поведения
- AppsFlyer: Attribution, ad revenue, ROAS

---

## ✅ Checklist реализации

- ✅ DevToDev SDK инициализирован
- ✅ Tutorial events отправляются (-1, 1-6, -2)
- ✅ Custom events онбординга логируются
- ✅ Permission events отслеживаются
- ⏳ **Воронки созданы в DevToDev Dashboard** (требуется настройка)
- ⏳ **Baseline metrics собраны** (1-2 недели данных)
- ⏳ **Оптимизация на основе данных** (continuous)

---

## 🔗 Полезные ссылки

- [DevToDev Funnels Documentation](https://docs.devtodev.com/reports-and-functionality/project-related-reports-and-fuctionality/events-and-funnels)
- [Tutorial Method Documentation](https://docs.devtodev.com/integration/integration-of-sdk-v2/setting-up-events/basic-methods#tutorial)
- [Custom Events Documentation](https://docs.devtodev.com/integration/integration-of-sdk-v2/setting-up-events/secondary-methods)
- [DevToDev Dashboard](https://go.devtodev.com)

---

## 💡 Pro Tips

1. **Не переоптимизируйте рано**
   - Собирайте данные минимум 1-2 недели
   - Достаточный sample size для статистической значимости

2. **Комбинируйте количественные и качественные данные**
   - Воронки показывают "что"
   - User interviews показывают "почему"

3. **Iterate based on data**
   - Делайте изменения по одному
   - Измеряйте impact каждого изменения
   - A/B тесты для валидации гипотез

4. **Мониторьте тренды**
   - Weekly/monthly cohort analysis
   - Влияние обновлений app на конверсию
   - Seasonal patterns

---

## Примечания

**Текущие данные:**
- DevToDev tutorial() отправляет: -1 (start), 1-6 (steps), -2 (complete)
- Firebase/AppsFlyer логируют детальные custom events
- Все данные real-time доступны в DevToDev Dashboard

**Следующие шаги:**
1. ✅ Собрать baseline данные (1-2 недели)
2. Создать рекомендованные воронки в Dashboard
3. Провести первый анализ
4. Выявить топ-3 проблемные точки
5. Начать A/B тесты для оптимизации
