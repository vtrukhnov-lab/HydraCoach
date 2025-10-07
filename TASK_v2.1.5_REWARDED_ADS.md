# 🚀 ЗАДАЧА ДЛЯ СЛЕДУЮЩЕГО ЧАТА

## 🎯 ЦЕЛЬ: Production Build v2.1.4 с Rewarded Ads (A/B Ready)

### Требования:
✅ Работающее приложение с Rewarded Video Ads
✅ A/B тестирование управляется через Firebase Remote Config
✅ **Kill Switch** - можно выключить rewarded ads в любой момент без обновления
✅ Готово к публикации в Google Play Store

---

## 📋 CHECKLIST ДЛЯ NEXT SESSION

### PHASE 1: Финализация текущих изменений (15 мин)

- [ ] **Коммит изменений:**
  ```bash
  git add .
  git commit -m "feat: Add A/B testing for Rewarded Ads + Remove home banner

  - Added Firebase Remote Config parameters for A/B experiments
  - 6 rewarded ads A/B tests ready (placement, reward, cooldown, etc)
  - Removed AdBannerCard from home screen
  - Updated all dependencies (Firebase 4.x-6.x)
  - Replaced 607 print() with logger
  - Fixed 873 analysis issues (dead code, withOpacity, etc)
  - Code quality improved by 79%

  🤖 Generated with Claude Code"
  ```

- [ ] **Проверить git status** - все файлы закоммичены

---

### PHASE 2: Rewarded Ads Implementation (2-3 часа)

#### 2.1 Backend Services

- [ ] **Расширить MaxSdkService:**
  - Добавить rewarded ad callbacks (onLoaded, onShown, onCompleted, onFailed)
  - Интеграция с AppLovin MAX rewarded video API
  - Error handling для no fill / failed loads

- [ ] **Создать RewardedAdProvider:**
  ```dart
  lib/providers/rewarded_ad_provider.dart
  ```
  - State management (idle, loading, loaded, showing, completed)
  - Cooldown tracking (через Remote Config)
  - Daily limit management
  - Integration с Remote Config для A/B параметров

- [ ] **Создать RewardedAdManager:**
  ```dart
  lib/services/rewarded_ad_manager.dart
  ```
  - Reward selection logic (какую награду давать)
  - Apply reward (добавить воду в HydrationProvider)
  - Validation (предотвратить читы)

#### 2.2 UI Components

- [ ] **RewardedAdButton:**
  ```dart
  lib/widgets/rewarded_ad_button.dart
  ```
  - Floating button с иконкой 🎁
  - Показывать только если `rewardedAdsEnabled = true` в Remote Config
  - Пульсирующая анимация привлечения внимания
  - Cooldown indicator

- [ ] **RewardPreviewDialog:**
  ```dart
  lib/widgets/reward_preview_dialog.dart
  ```
  - Показывать ЧТО получит пользователь
  - "Смотреть видео (~30 сек)" информация
  - Кнопки: "Смотреть" / "Отмена"

- [ ] **RewardSuccessOverlay:**
  ```dart
  lib/widgets/reward_success_overlay.dart
  ```
  - Confetti анимация (через flutter_animate или confetti package)
  - "Награда получена! +250ml" текст
  - Auto-dismiss через 2.5 секунды

#### 2.3 Analytics Integration

- [ ] **Добавить события в AnalyticsService:**
  ```dart
  logRewardedAdRequested()
  logRewardedAdShown()
  logRewardedAdCompleted()
  logRewardGranted()
  logABVariantAssigned()
  ```

- [ ] **Добавить AppsFlyer события:**
  - `rewarded_ad_shown`
  - `rewarded_ad_completed`
  - `reward_granted`

---

### PHASE 3: Remote Config Kill Switch Setup (30 мин)

- [ ] **Firebase Console настройка:**
  1. Открыть Firebase Console → Remote Config
  2. Добавить параметр `rewarded_ads_enabled: true` (по умолчанию)
  3. **ВАЖНО:** Установить как **Dynamic Config** (не A/B test)
  4. Сохранить и опубликовать

- [ ] **Проверить в коде:**
  ```dart
  // В home_screen.dart или где показываем кнопку
  final remoteConfig = RemoteConfigService.instance;

  if (remoteConfig.rewardedAdsEnabled) {
    // Показываем RewardedAdButton
  }
  ```

- [ ] **Тестирование Kill Switch:**
  1. Запустить приложение - кнопка видна ✅
  2. В Firebase Console изменить `rewarded_ads_enabled: false`
  3. Подождать 1-2 минуты (fetch interval)
  4. Перезапустить приложение - кнопка скрыта ✅

---

### PHASE 4: Version Bump v2.1.4 (5 мин)

- [ ] **Обновить версию в 3 местах:**

**1. pubspec.yaml:**
```yaml
version: 2.1.4+35
```

**2. android/app/build.gradle.kts:**
```kotlin
versionCode = 35
versionName = "2.1.4"
```

**3. lib/main.dart (AppLifecycleManager):**
```dart
FirebaseAnalytics.instance.logEvent(
  name: 'app_open',
  parameters: {
    'app_version': '2.1.4',
    // ...
  },
);
```

---

### PHASE 5: Release Notes (10 мин)

- [ ] **Создать папку релиза:**
  ```bash
  mkdir -p docs/release_notes/2.1.4
  ```

- [ ] **Создать release_notes.md:**
  ```markdown
  # HydraCoach v2.1.4

  ## 🎬 Новое
  - Rewarded Video Ads: смотри видео - получай бонусы!
  - A/B тестирование для оптимизации UX
  - Убрали лишний баннер с главного экрана

  ## 🔧 Улучшения
  - Обновлены все Firebase пакеты (4.x-6.x)
  - Улучшено логирование (заменено 607 print на logger)
  - Исправлено 873 предупреждений кода
  - Качество кода улучшено на 79%

  ## 🐛 Исправления
  - Fixed BuildContext async gaps
  - Cleaned up dead code
  - Migrated deprecated APIs (withOpacity → withValues)
  ```

- [ ] **Создать test_checklist.md:**
  ```markdown
  # Test Checklist v2.1.4

  ## Rewarded Ads
  - [ ] Кнопка показывается на главном экране
  - [ ] Клик открывает preview dialog
  - [ ] "Смотреть" загружает и показывает видео
  - [ ] После просмотра показывается success animation
  - [ ] Награда применяется (+250ml воды)
  - [ ] Cooldown работает (1 час между просмотрами)
  - [ ] Daily limit работает (5 в день)

  ## Kill Switch
  - [ ] В Firebase изменить rewarded_ads_enabled → false
  - [ ] Кнопка исчезает после обновления конфига
  - [ ] Нет крашей при выключенных ads

  ## Core Features (Regression)
  - [ ] Добавление воды работает
  - [ ] Уведомления работают
  - [ ] AppsFlyer события отправляются
  - [ ] Нет крашей
  ```

---

### PHASE 6: Build & Test (30 мин)

- [ ] **Clean build:**
  ```bash
  cd android && ./gradlew clean && cd ..
  flutter clean
  flutter pub get
  ```

- [ ] **Build APK для тестирования:**
  ```bash
  flutter build apk --release

  # Копировать в папку релиза
  cp build/app/outputs/flutter-apk/app-release.apk docs/release_notes/2.1.4/hydracoach-2.1.4-test.apk
  ```

- [ ] **Установить на реальное устройство и протестировать:**
  - Все пункты из test_checklist.md
  - Особенно: rewarded ads flow полностью
  - Kill switch в Firebase Console

- [ ] **Если все ОК → Build AAB для Google Play:**
  ```bash
  flutter build appbundle --release

  # Копировать в папку релиза
  cp build/app/outputs/bundle/release/app-release.aab docs/release_notes/2.1.4/hydracoach-2.1.4-release.aab
  ```

---

### PHASE 7: Firebase Remote Config Production Setup (20 мин)

- [ ] **Установить production параметры:**
  ```json
  {
    "rewarded_ads_enabled": true,
    "ab_rewarded_placement": "floating_button",
    "ab_rewarded_reward_amount": 250,
    "ab_rewarded_cooldown_minutes": 60,
    "ab_rewarded_daily_limit": 5,
    "ab_rewarded_button_text": "watch_earn",
    "ab_rewarded_animation": "confetti"
  }
  ```

- [ ] **Опубликовать изменения** в Firebase Console

- [ ] **ВАЖНО:** Не создавать A/B эксперименты пока приложение не в store!
  - Сначала релиз с дефолтными значениями
  - Потом через 3-5 дней запускать эксперименты

---

### PHASE 8: Google Play Upload (15 мин)

- [ ] **Открыть Google Play Console**

- [ ] **Создать новый релиз (Internal/Closed/Production track):**
  - Upload: `hydracoach-2.1.4-release.aab`
  - Release Name: `2.1.4 - Rewarded Ads + A/B Testing`

- [ ] **Release Notes (English):**
  ```
  What's New:
  • Rewarded Video Ads: Watch videos to earn bonuses!
  • Improved app stability and performance
  • Updated dependencies for better security
  • Bug fixes and optimizations
  ```

- [ ] **Release Notes (Russian):**
  ```
  Что нового:
  • Рекламные бонусы: смотрите видео и получайте награды!
  • Улучшена стабильность и производительность
  • Обновлены зависимости для безопасности
  • Исправлены ошибки и оптимизации
  ```

- [ ] **Submit for Review**

---

### PHASE 9: Post-Release Monitoring (ongoing)

- [ ] **Мониторить Firebase Analytics:**
  - `rewarded_ad_shown` events
  - `rewarded_ad_completed` events
  - Completion rate > 60%?

- [ ] **Мониторить Crashlytics:**
  - Нет новых крашей от rewarded ads?
  - Crash-free rate > 99%?

- [ ] **Мониторить AppLovin MAX Dashboard:**
  - eCPM > $0.50?
  - Fill rate > 80%?
  - Revenue растет?

- [ ] **Через 3-5 дней после релиза:**
  - Собрать baseline метрики
  - Запустить первый A/B эксперимент (Placement)

---

## 🎯 SUCCESS CRITERIA

### Приложение готово к релизу если:
✅ Rewarded ads работают end-to-end
✅ Kill switch проверен и работает
✅ Нет крашей при тестировании
✅ APK/AAB подписаны правильными ключами
✅ Версия обновлена во всех 3 местах
✅ Firebase Remote Config настроен

### После релиза:
✅ Completion rate > 60%
✅ Crash-free rate > 99%
✅ ARPU увеличился минимум на $0.05
✅ Day 7 retention не упала > 3%

---

## 📚 ПОЛЕЗНЫЕ ССЫЛКИ

- **Brainstorm Doc:** `docs/AB_TESTING_REWARDED_ADS.md`
- **Remote Config Service:** `lib/services/remote_config_service.dart`
- **Current Version:** 2.1.3+34
- **Target Version:** 2.1.4+35

---

## 💡 БЫСТРЫЙ СТАРТ ДЛЯ NEXT SESSION

**Скажи Claude:**
```
Привет! Продолжаем с прошлого раза.
Читай файл TASK_NEXT_SESSION.md и начинай выполнять по пунктам.
Начни с PHASE 1 (коммит изменений), потом PHASE 2 (rewarded ads implementation).
```

---

## ⚠️ ВАЖНЫЕ ЗАМЕТКИ

1. **НЕ запускать A/B эксперименты до релиза** - сначала базовая версия в store
2. **Kill switch обязателен** - должен работать 100%
3. **Тестировать на реальном устройстве** перед загрузкой в store
4. **APK/AAB должны быть подписаны production ключами**
5. **После релиза ждать 3-5 дней перед A/B тестами** для baseline метрик

---

**Estimated Time:** 4-5 часов work
**Priority:** HIGH 🔴
**Complexity:** MEDIUM 🟡

---

Готово! 🚀 Загружай в следующей сессии!
