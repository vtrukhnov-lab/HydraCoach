# AppsFlyer Events в HydraCoach

## 🤖 Автоматические события AppsFlyer (без кода)
- `install` - установка приложения
- `re-engagement` - повторное вовлечение
- `re-attribution` - повторная атрибуция
- `uninstall` - удаление (через silent push)
- `update` - обновление приложения

## 📊 Кастомные события трекинга

### 🎯 Milestone события (уникальные, один раз на пользователя)
- `onboarding_complete` - завершение онбординга ✅ Реализовано
- `water_goal_100_first` - первый раз достиг 100% воды (в любой день) ✅ Реализовано
- `water_goal_100_2days` - достиг 100% воды в 2 разных дня (накопительно) ✅ Реализовано
- `water_goal_100_3days` - достиг 100% воды в 3 разных дня (накопительно) ✅ Реализовано
- `water_goal_100_5days` - достиг 100% воды в 5 разных дней (накопительно) ✅ Реализовано
- `water_goal_100_7days` - достиг 100% воды в 7 разных дней (накопительно) ✅ Реализовано
- `water_goal_100_10days` - достиг 100% воды в 10 разных дней (накопительно) ✅ Реализовано
- `water_goal_100_14days` - достиг 100% воды в 14 разных дней (накопительно) ✅ Реализовано

### 💳 События подписки и Paywall

- `trial_started` - начало триала (product, trial_duration)
- `subscription_purchase_attempt` - попытка покупки (product_id, price)
- `subscription_purchase_result` - результат покупки (success, product_id, error)
- `subscription_restore_attempt` - попытка восстановления
- `subscription_restore_result` - результат восстановления (success, products_restored)
- `pro_feature_gate_hit` - попытка доступа к PRO функции (feature_name, source)

### 🔔 События уведомлений
все удалить 

### 📈 События аналитики и отчетов
все удалить 

### ⚙️ События настроек
все удалить 

### 📱 События приложения
- `app_open` - открытие приложения
- `session` - сессия (duration_seconds)

### 🧪 Тестовые события


## 💰 События покупок (автоматические через Purchase Connector)

Purchase Connector автоматически генерирует S2S события с префиксом `af_ars_`:
- `af_ars_in_app_purchase` - покупка в приложении
- `af_ars_subscription_renewal` - продление подписки
- `af_ars_subscription_cancellation` - отмена подписки
- `af_ars_sandbox_s2s` - тестовая покупка (в sandbox)

**Важно:** НЕ отправляем вручную `af_subscribe` или `af_purchase` чтобы избежать дублирования!

## 📍 Специальные события AppsFlyer

Эти события имеют особое значение для AppsFlyer:
- `af_start_trial` - начало триала (генерируется автоматически)
- Conversion события обрабатываются через `onInstallConversionData`
- Deep linking через `onDeepLinking`
- Attribution через `onAppOpenAttribution`

## 🔧 Реализация

Все события проходят через централизованный `AnalyticsService` который:
1. Отправляет в Firebase Analytics
2. Отправляет в DevToDev
3. Отправляет в AppsFlyer (если инициализирован и есть согласие)

Purchase Connector настроен в `purchase_connector_service.dart` и автоматически обрабатывает события покупок.