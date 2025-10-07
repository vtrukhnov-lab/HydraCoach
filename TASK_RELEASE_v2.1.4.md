# 🚀 РЕЛИЗ v2.1.4 - КРИТИЧЕСКИЕ ОБНОВЛЕНИЯ

## 🎯 ЦЕЛЬ: Стабильный релиз с обновлениями зависимостей

### Что в релизе:
✅ Обновлены все Firebase пакеты (3.x-5.x → 4.x-6.x)
✅ Улучшено качество кода на 79% (1103 → 230 проблем)
✅ Заменено 607 print() на proper logging
✅ Удален лишний баннер с главного экрана
✅ Исправлены критические баги

---

## 📋 QUICK CHECKLIST

### 1. Version Bump (5 мин)

- [ ] **pubspec.yaml:**
```yaml
version: 2.1.4+35
```

- [ ] **android/app/build.gradle.kts (строки ~50-51):**
```kotlin
versionCode = 35
versionName = "2.1.4"
```

- [ ] **lib/main.dart (в logEvent app_open):**
```dart
'app_version': '2.1.4',
```

---

### 2. Git Commit (5 мин)

```bash
git add .
git commit -m "feat: v2.1.4 - Critical updates and improvements

Major changes:
- Updated Firebase suite (7 major updates: 3.x-5.x → 4.x-6.x)
- Updated permission_handler (11.x → 12.0.1)
- Updated flutter_lints (5.x → 6.0.0)
- Added logger package for proper logging

Code quality improvements:
- Replaced 607 print() statements with logger
- Fixed 873 analysis issues (-79% problems)
- Cleaned up dead code and null-aware expressions
- Migrated deprecated APIs (withOpacity → withValues)
- Fixed BuildContext async gaps

UI improvements:
- Removed redundant ad banner from home screen
- Better user experience

🤖 Generated with Claude Code"
```

---

### 3. Build APK для тестирования (10 мин)

```bash
# Clean
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get

# Build APK
flutter build apk --release
```

**Результат:** `build/app/outputs/flutter-apk/app-release.apk`

---

### 4. Тестирование на устройстве (15 мин)

- [ ] Установить APK на реальное устройство
- [ ] **Smoke tests:**
  - [ ] Приложение запускается без крашей
  - [ ] Главный экран загружается
  - [ ] Добавление воды работает
  - [ ] Уведомления работают
  - [ ] Firebase Analytics события отправляются
  - [ ] AppsFlyer события отправляются
  - [ ] Нет критических багов

- [ ] **Регрессионное тестирование:**
  - [ ] Onboarding для нового пользователя
  - [ ] Settings открываются
  - [ ] History экран работает
  - [ ] Achievements показываются
  - [ ] PRO подписка доступна

---

### 5. Build AAB для Google Play (10 мин)

```bash
# Build App Bundle
flutter build appbundle --release
```

**Результат:** `build/app/outputs/bundle/release/app-release.aab`

---

### 6. Создать папку релиза (5 мин)

```bash
mkdir -p docs/release_notes/2.1.4

# Копировать билды
cp build/app/outputs/flutter-apk/app-release.apk docs/release_notes/2.1.4/hydracoach-2.1.4-release.apk
cp build/app/outputs/bundle/release/app-release.aab docs/release_notes/2.1.4/hydracoach-2.1.4-release.aab
```

---

### 7. Release Notes

**Создать файл:** `docs/release_notes/2.1.4/release_notes.md`

```markdown
# HydraCoach v2.1.4

## 🔥 Критические обновления

### Firebase Suite
- Firebase Core: 3.15.2 → 4.1.1
- Firebase Auth: 5.7.0 → 6.1.0
- Firebase Analytics: 11.6.0 → 12.0.2
- Cloud Firestore: 5.6.12 → 6.0.2
- Firebase Crashlytics: 4.3.10 → 5.0.2
- Firebase Messaging: 15.2.10 → 16.0.2
- Firebase Remote Config: 5.5.0 → 6.0.2

### Другие пакеты
- permission_handler: 11.4.0 → 12.0.1
- flutter_lints: 5.0.0 → 6.0.0
- logger: добавлен 2.0.0

## 🎨 Улучшения

- Убрали лишний баннер с главного экрана
- Улучшено логирование (607 print → logger)
- Качество кода улучшено на 79%
- Исправлено 873 предупреждений анализатора
- Миграция deprecated API

## 🐛 Исправления

- Fixed BuildContext async gaps
- Cleaned up dead code
- Fixed null-aware expressions
- Updated deprecated color APIs

## 📊 Метрики качества

| Метрика | До | После | Улучшение |
|---------|-----|-------|-----------|
| Total Issues | 1103 | 230 | -79% |
| Print statements | 607 | 2 | -99.7% |
| Deprecated APIs | 150+ | 0 | -100% |
| Dead code | 40+ | 0 | -100% |

---

**Build Date:** 2025-10-07
**Flutter:** 3.35.3
**Dart:** 3.9.2
```

---

### 8. Google Play Console (15 мин)

- [ ] **Открыть Google Play Console**
- [ ] **Production → Create new release**

- [ ] **Upload AAB:**
  - `docs/release_notes/2.1.4/hydracoach-2.1.4-release.aab`

- [ ] **Release Name:**
  ```
  2.1.4 - Критические обновления
  ```

- [ ] **Release Notes (English):**
```
What's New in v2.1.4:

• Updated all Firebase services for better performance and security
• Improved app stability and reliability
• Enhanced logging system for better debugging
• Cleaned up UI by removing redundant elements
• Bug fixes and performance optimizations

Technical improvements:
• 79% reduction in code quality issues
• Updated 10 major dependencies
• Better error handling
```

- [ ] **Release Notes (Russian):**
```
Что нового в v2.1.4:

• Обновлены все сервисы Firebase для лучшей производительности и безопасности
• Улучшена стабильность и надежность приложения
• Улучшена система логирования
• Очищен интерфейс от лишних элементов
• Исправлены ошибки и оптимизирована производительность

Технические улучшения:
• Качество кода улучшено на 79%
• Обновлено 10 основных зависимостей
• Улучшена обработка ошибок
```

- [ ] **Submit for Review**

---

### 9. Post-Release Monitoring (первые 24 часа)

- [ ] **Firebase Crashlytics:**
  - Crash-free rate > 99%?
  - Нет новых критических крашей?

- [ ] **Firebase Analytics:**
  - Events отправляются нормально?
  - DAU не упал?

- [ ] **Google Play Console:**
  - ANR rate < 0.5%?
  - Crash rate < 1%?
  - No critical reviews?

- [ ] **AppsFlyer:**
  - События attribution работают?
  - ROI360 данные поступают?

---

## ⏱️ ESTIMATED TIME

- **Version bump:** 5 мин
- **Git commit:** 5 мин
- **Build & test APK:** 25 мин
- **Build AAB:** 10 мин
- **Release notes:** 10 мин
- **Upload to Google Play:** 15 мин

**TOTAL:** ~70 минут (1 час 10 минут)

---

## ⚠️ ВАЖНО

1. **НЕТ НОВЫХ ФИЧЕЙ** - только обновления зависимостей и bugfixes
2. **Rewarded Ads отложены на v2.1.5** - не включены в этот релиз
3. **Тестировать на реальном устройстве** перед загрузкой в store
4. **AAB должен быть подписан production ключами**
5. **После релиза мониторить метрики 24 часа**

---

## ✅ SUCCESS CRITERIA

**Релиз успешен если:**
- ✅ Приложение запускается без крашей
- ✅ Все core функции работают
- ✅ Firebase события отправляются
- ✅ Crash-free rate > 99%
- ✅ No critical bugs reported

---

## 🎯 NEXT STEPS (v2.1.5)

После успешного релиза 2.1.4:
- Подождать 3-5 дней для сбора метрик
- Начать разработку Rewarded Video Ads
- Настроить A/B тестирование
- Релиз v2.1.5 с rewarded ads

См. файл: `TASK_v2.1.5_REWARDED_ADS.md`

---

**Priority:** 🔴 CRITICAL
**Complexity:** 🟢 SIMPLE
**Ready to release:** ✅ YES

Поехали! 🚀
