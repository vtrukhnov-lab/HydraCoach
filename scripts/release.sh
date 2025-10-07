#!/bin/bash
set -e

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Получаем версию из pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | head -1 | sed 's/#.*//' | sed 's/.*version: *\([0-9.]*\)+.*/\1/' | tr -d ' ')
BUILD_NUMBER=$(grep "version:" pubspec.yaml | head -1 | sed 's/#.*//' | sed 's/.*+\([0-9]*\).*/\1/' | tr -d ' ')

if [[ -z "$VERSION" ]] || [[ -z "$BUILD_NUMBER" ]]; then
    echo -e "${RED}❌ Не удалось определить версию из pubspec.yaml${NC}"
    exit 1
fi

echo -e "\n${BOLD}🚀 HydraCoach Release Builder${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}\n"
echo -e "Версия: ${GREEN}${BOLD}$VERSION${NC} (build $BUILD_NUMBER)"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}\n"

# 1. Валидация версий
echo -e "${BLUE}📋 Шаг 1/9: Валидация синхронности версий...${NC}"
if ! bash scripts/bump_version.sh --validate >/dev/null 2>&1; then
    echo -e "${RED}❌ Версии не синхронизированы!${NC}"
    bash scripts/bump_version.sh --validate
    exit 1
fi
echo -e "${GREEN}✅ Версии синхронизированы${NC}\n"

# 2. Создание папки релиза
RELEASE_DIR="docs/release_notes/$VERSION"
echo -e "${BLUE}📂 Шаг 2/9: Создание папки релиза...${NC}"
mkdir -p "$RELEASE_DIR"
echo -e "${GREEN}✅ Папка создана: $RELEASE_DIR${NC}\n"

# 3. Очистка предыдущих сборок
echo -e "${BLUE}🧹 Шаг 3/9: Очистка предыдущих сборок...${NC}"
flutter clean >/dev/null 2>&1
cd android && ./gradlew clean >/dev/null 2>&1 && cd ..
echo -e "${GREEN}✅ Очистка выполнена${NC}\n"

# 4. Установка зависимостей
echo -e "${BLUE}📦 Шаг 4/9: Обновление зависимостей...${NC}"
flutter pub get >/dev/null 2>&1
echo -e "${GREEN}✅ Зависимости обновлены${NC}\n"

# 5. Сборка APK
echo -e "${BLUE}🔨 Шаг 5/9: Сборка APK (release)...${NC}"
echo -e "${YELLOW}   Это может занять 2-3 минуты...${NC}"
if flutter build apk --release; then
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    cp "$APK_PATH" "$RELEASE_DIR/hydracoach-$VERSION-release.apk"
    echo -e "${GREEN}✅ APK собран: $APK_SIZE${NC}"
    echo -e "${GREEN}   → $RELEASE_DIR/hydracoach-$VERSION-release.apk${NC}\n"
else
    echo -e "${RED}❌ Ошибка сборки APK${NC}"
    exit 1
fi

# 6. Сборка AAB
echo -e "${BLUE}🔨 Шаг 6/9: Сборка AAB (Google Play)...${NC}"
echo -e "${YELLOW}   Это может занять 2-3 минуты...${NC}"
if flutter build appbundle --release; then
    AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
    AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
    cp "$AAB_PATH" "$RELEASE_DIR/hydracoach-$VERSION-release.aab"
    echo -e "${GREEN}✅ AAB собран: $AAB_SIZE${NC}"
    echo -e "${GREEN}   → $RELEASE_DIR/hydracoach-$VERSION-release.aab${NC}\n"
else
    echo -e "${RED}❌ Ошибка сборки AAB${NC}"
    exit 1
fi

# 7. Генерация changelog
echo -e "${BLUE}📝 Шаг 7/9: Генерация changelog...${NC}"
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [[ -n "$LAST_TAG" ]]; then
    git log $LAST_TAG..HEAD --pretty=format:"- %s (%h)" > "$RELEASE_DIR/CHANGELOG.txt"
    COMMITS_COUNT=$(git log $LAST_TAG..HEAD --oneline | wc -l)
    echo -e "${GREEN}✅ Changelog создан: $COMMITS_COUNT коммитов с $LAST_TAG${NC}\n"
else
    git log --pretty=format:"- %s (%h)" --max-count=20 > "$RELEASE_DIR/CHANGELOG.txt"
    echo -e "${YELLOW}⚠️  Теги не найдены, показаны последние 20 коммитов${NC}\n"
fi

# 8. Создание README релиза
echo -e "${BLUE}📄 Шаг 8/9: Создание README релиза...${NC}"
cat > "$RELEASE_DIR/README.md" <<EOF
# HydraCoach v$VERSION

**Дата релиза:** $(date +%Y-%m-%d)
**Build:** $BUILD_NUMBER
**Минимальная Android версия:** 9.0 (API 28)

## 📦 Файлы

- \`hydracoach-$VERSION-release.apk\` ($APK_SIZE) - для тестирования
- \`hydracoach-$VERSION-release.aab\` ($AAB_SIZE) - для Google Play Console

## 📋 Установка

### APK (для тестирования)
\`\`\`bash
adb install -r hydracoach-$VERSION-release.apk
\`\`\`

### AAB (для Google Play)
1. Зайти в [Google Play Console](https://play.google.com/console)
2. Release → Testing → Internal testing
3. Create new release
4. Upload \`hydracoach-$VERSION-release.aab\`
5. Заполнить release notes
6. Review & rollout

## 📝 Изменения

См. файл \`CHANGELOG.txt\` для детального списка изменений.

## ✅ Чеклист тестирования

### Базовая функциональность
- [ ] Приложение запускается без крэшей
- [ ] Добавление порции воды работает
- [ ] Прогресс отображается корректно
- [ ] Уведомления приходят вовремя
- [ ] История сохраняется между запусками

### Регрессионное тестирование
- [ ] Daily reset в полночь работает
- [ ] Статистика корректна (weekly/monthly)
- [ ] Settings сохраняются
- [ ] Subscription система работает (если premium user)
- [ ] Реклама показывается (если free user)
- [ ] Firebase Analytics логирует события

### UI/UX
- [ ] Нет overflow ошибок на разных экранах
- [ ] Анимации плавные
- [ ] Все тексты локализованы
- [ ] Нет визуальных глюков

### Performance
- [ ] Нет лагов при взаимодействии
- [ ] Startup время < 2 секунд
- [ ] Battery drain приемлемый

## 🚀 Post-Release

После успешного тестирования:

1. **Создать git tag**
   \`\`\`bash
   git tag -a v$VERSION -m "Release v$VERSION (build $BUILD_NUMBER)"
   git push --tags
   \`\`\`

2. **Загрузить в Google Play Console**
   - Internal testing → Production
   - Staged rollout: 10% → 50% → 100%

3. **Мониторинг первые 24 часа**
   - Crash-free rate > 99%
   - ANR rate < 0.1%
   - User ratings >= 4.0

## 📊 Build Info

- Flutter SDK: $(flutter --version | head -1)
- Dart SDK: $(dart --version | head -1 | awk '{print $4}')
- Build date: $(date)
- Keystore: upload-keystore.jks

## ⚠️ Known Issues

- Нет известных критичных проблем

---

Generated by HydraCoach Release Builder
EOF

echo -e "${GREEN}✅ README создан${NC}\n"

# 9. Финальные шаги
echo -e "${BLUE}🎁 Шаг 9/9: Финализация...${NC}"
echo -e "${GREEN}✅ Релиз готов!${NC}\n"

echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}🎉 Релиз v$VERSION успешно собран!${NC}\n"

echo -e "${YELLOW}📁 Файлы релиза:${NC}"
ls -lh "$RELEASE_DIR" | tail -n +2 | awk '{printf "   %s  %s\n", $5, $9}'

echo -e "\n${YELLOW}💡 Следующие шаги:${NC}"
echo -e "   1. Протестируйте APK: ${BLUE}adb install -r $RELEASE_DIR/hydracoach-$VERSION-release.apk${NC}"
echo -e "   2. Пройдите чеклист в ${BLUE}$RELEASE_DIR/README.md${NC}"
echo -e "   3. Загрузите AAB в Google Play Console"
echo -e "   4. Создайте git tag: ${BLUE}git tag v$VERSION && git push --tags${NC}\n"

# Опциональное создание git tag
read -p "$(echo -e ${YELLOW}Создать git tag v$VERSION сейчас? ${NC}[y/N]: )" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git tag -a "v$VERSION" -m "Release v$VERSION (build $BUILD_NUMBER)"
    echo -e "${GREEN}✅ Git tag v$VERSION создан${NC}"
    echo -e "${YELLOW}   Не забудьте: git push --tags${NC}"
fi

echo -e "\n${GREEN}${BOLD}✨ Готово! Хорошего релиза!${NC}\n"
