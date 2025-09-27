# Релиз 2.1.3

## 📦 Файлы релиза
- **APK:** `hydracoach-2.1.3-release.apk` (106.5MB) - для тестирования
- **AAB:** `hydracoach-2.1.3-release.aab` (87.8MB) - для Google Play
- **Release Notes:** `release_notes.md` - описание изменений
- **Test Checklist:** `test_checklist.md` - чеклист для тестировщика

## 🚀 Загрузка в Google Play
```bash
# AAB готов для загрузки в Google Play Console
# Путь: docs/release_notes/2.1.3/hydracoach-2.1.3-release.aab
```

## 📱 Установка APK для тестирования
```bash
adb install -r hydracoach-2.1.3-release.apk
```

## 🎯 Основные изменения
- Интегрированы все 13 рекламных сетей через AppLovin MAX
- Добавлены баннеры на 9 экранов для бесплатных пользователей
- Исправлен баг с переносом данных на новый день
- Добавлены milestone события для аналитики

## ⚠️ Важно
- Перед загрузкой в продакшн убедитесь, что в AppLovin Dashboard настроены все рекламные сети
- Проверьте работу баннеров на реальном устройстве
- Протестируйте переход на новый день (особенно при совпадении чисел месяца)

## 📊 Версии
- **Version Code:** 34
- **Version Name:** 2.1.3
- **Min SDK:** 24 (Android 7.0)
- **Target SDK:** 35

---
**Дата сборки:** 27.09.2025