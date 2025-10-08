# HydraCoach v2.1.5 Release

**Версия:** 2.1.5+36
**Version Code:** 36
**Дата релиза:** TBD
**Тип релиза:** Analytics & Monetization Enhancement

---

## 🎯 Основные изменения

Этот релиз добавляет полную интеграцию с DevToDev Analytics для детального отслеживания:
- 📊 Subscription lifecycle events (purchase, renewal, cancellation, refund)
- 💰 Ad revenue tracking (AppLovin MAX integration)
- 🎓 Tutorial/Onboarding funnel analytics
- 📈 Conversion funnels для оптимизации user journey

---

## 📦 Файлы релиза

После сборки здесь будут доступны:
- `hydracoach-2.1.5-release.apk` - для тестирования на устройствах
- `hydracoach-2.1.5-release.aab` - для загрузки в Google Play Console

---

## 🚀 Как собрать релиз

### Подготовка

1. **Проверить версии (должно быть обновлено):**
   ```bash
   # pubspec.yaml
   version: 2.1.5+36

   # android/app/build.gradle.kts
   versionCode = 36
   versionName = "2.1.5"

   # lib/main.dart
   'app_version': '2.1.5'
   ```

### Сборка APK (для тестирования)

```bash
# Очистка и сборка
cd android && ./gradlew clean && cd ..
flutter build apk --release

# Копирование в папку релиза
cp build/app/outputs/flutter-apk/app-release.apk docs/release_notes/2.1.5/hydracoach-2.1.5-release.apk
```

### Сборка AAB (для Google Play)

```bash
# Сборка App Bundle
flutter build appbundle --release

# Копирование в папку релиза
cp build/app/outputs/bundle/release/app-release.aab docs/release_notes/2.1.5/hydracoach-2.1.5-release.aab
```

**ВАЖНО:** AAB подписывается автоматически с использованием ключей из:
- Keystore: `C:/android/keys/upload-keystore.jks`
- Конфигурация: `android/key.properties`

---

## ✅ Pre-release Checklist

### Перед сборкой
- [ ] Версии обновлены во всех 3 местах (pubspec.yaml, build.gradle.kts, main.dart)
- [ ] Все тесты проходят: `flutter test`
- [ ] Код проанализирован: `flutter analyze`
- [ ] Нет критических warnings или errors

### После сборки APK
- [ ] APK установлен на тестовое устройство
- [ ] Приложение запускается без крешей
- [ ] Основные функции работают (см. test_checklist.md)
- [ ] DevToDev события отправляются (проверить логи)

### Перед загрузкой в Google Play
- [ ] AAB подписан корректно
- [ ] Все пункты test_checklist.md пройдены
- [ ] Release notes подготовлены на английском и русском
- [ ] Screenshots обновлены (если нужно)

---

## 📊 Новые возможности аналитики

### 1. Subscription Tracking
Все события подписок автоматически отправляются в DevToDev:
- Покупки (purchase, trial_purchase)
- Продления (renewal)
- Отмены (cancellation)
- Возвраты (refund)

**Проверка:**
```bash
adb logcat | grep "DevToDev.*подписки"
```

### 2. Ad Revenue Tracking
Рекламный доход отслеживается автоматически:
- Banner ads (320x50)
- MREC ads (300x250)

**Проверка:**
```bash
adb logcat | grep "Ad Revenue tracked"
```

### 3. Tutorial/Onboarding Analytics
Детальное отслеживание онбординга:
- Каждый шаг логируется в DevToDev tutorial()
- Новые события для первого действия пользователя

**Проверка:**
```bash
adb logcat | grep "tutorial"
adb logcat | grep "first_intake_tutorial"
```

---

## 🔧 Настройка после релиза

### В DevToDev Dashboard

1. **Создать воронки:**
   - Full Onboarding to First Action (9 шагов)
   - Permissions Funnel (5 шагов)
   - Monetization Funnel (4 шага)

2. **Настроить alerts:**
   - Drop-off > 20% на любом шаге онбординга
   - Ad revenue снижение > 15%
   - Subscription cancellation rate > 5%

3. **Опционально: S2S интеграция**
   - AppLovin MAX → DevToDev postback
   - URL: `https://statgw.devtodev.com/applovin/api?apikey=YOUR_KEY`

### Мониторинг первую неделю

- [ ] Проверить DevToDev Dashboard на корректность данных
- [ ] Убедиться что все события приходят
- [ ] Нет дублирования событий (subscription, ad revenue)
- [ ] Воронки показывают реалистичные конверсии

---

## 📖 Документация

### Для разработчиков
- `CHANGELOG.md` - детальный список изменений
- `test_checklist.md` - чеклист для QA тестирования
- `docs/integration_guides/DEVTODEV_INTEGRATION_STATUS.md` - статус интеграции
- `docs/integration_guides/DEVTODEV_FUNNELS_GUIDE.md` - setup guide для воронок

### Для аналитиков
- `docs/integration_guides/DEVTODEV_FUNNELS_GUIDE.md` - как настроить и читать воронки
- Benchmark метрики для оценки конверсий
- Примеры оптимизации на основе данных

---

## 🐛 Известные проблемы

- События `first_intake_tutorial_shown/completed` появятся в DevToDev только после того как пользователи обновятся на 2.1.5
- Некоторые legacy warnings в коде - не влияют на функциональность

---

## 📞 Контакты

**Разработчик:** Victor Trukhnov
**Email:** vtrukhnov.lab@gmail.com
**GitHub:** https://github.com/playcus/hydracoach

---

## 📜 История версий

- **v2.1.5** (текущая) - DevToDev Analytics Integration
- **v2.1.4** - Performance & Security Updates
- **v2.1.3** - Localization & Bug Fixes
- **v2.1.2** - Firebase Integration
