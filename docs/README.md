# HydroCoach Documentation

## 📁 Structure

### `/integration_guides`
Интеграционные гайды для внешних сервисов:
- `APPLOVIN_MAX_INTEGRATION.md` - AppLovin MAX реклама и монетизация
- `MEDIATION_SETUP.md` - Настройка медиированных рекламных сетей
- `APPSFLYER_EVENTS.md` - События и аналитика AppsFlyer
- `DEVTODEV_SETUP.md` - DevToDev аналитика
- `PURCHASE_CONNECTOR_SETUP.md` - AppsFlyer Purchase Connector для валидации покупок
- `MONETIZATION_SETUP.md` - Общая стратегия монетизации
- `analytics_events.md` - Список всех аналитических событий

### `/build_guides`
Инструкции по сборке приложения:
- `BUILD_IOS.md` - Сборка для iOS/App Store
- `SENSITIVE_FILES_SETUP.md` - Настройка чувствительных файлов (ключи, сертификаты)

### `/troubleshooting`
Решение проблем:
- `Troubleshooting.md` - Известные проблемы и их решения

### `/release_notes`
История версий:
- `2.1.3.md` - Последний релиз

## 🔑 Важные файлы в корне проекта

- `README.md` - Основная документация проекта
- `CHANGELOG.md` - История изменений
- `CLAUDE.md` - Инструкции для AI-ассистента
- `architecture+dependencies.md` - Архитектура и зависимости

## 📱 Ключевые интеграции

### Аналитика
- **AppsFlyer** - атрибуция и маркетинговая аналитика
- **DevToDev** - продуктовая аналитика и монетизация
- **Firebase** - crashlytics, remote config, messaging

### Монетизация
- **AppLovin MAX** - рекламная медиация (13+ сетей)
- **Google Play Billing** - подписки
- **StoreKit** - подписки iOS

### Рекламные сети (через AppLovin MAX)
- Google AdMob & Ad Manager
- Meta Audience Network
- Unity Ads
- IronSource
- Mintegral
- Chartboost
- И еще 7+ сетей

## 🛠 Полезные команды

```bash
# Android сборка
cd android && ./gradlew clean && ./gradlew assembleRelease

# iOS сборка
cd ios && pod install && flutter build ios

# Запуск с логами
flutter run --verbose

# Проверка интеграции рекламы
adb logcat | grep -i applovin
```

## 📞 Контакты

- **Publisher**: Playcus
- **Developer**: [Ваша команда]
- **Support**: support@hydracoach.app