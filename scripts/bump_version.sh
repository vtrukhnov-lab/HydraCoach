#!/bin/bash
set -e

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Файлы для обновления
PUBSPEC="pubspec.yaml"
GRADLE="android/app/build.gradle.kts"
MAIN_DART="lib/main.dart"

print_usage() {
    cat << EOF
Автоматическое обновление версии HydraCoach в ТРЕХ местах

Использование:
  bash scripts/bump_version.sh patch      # 2.1.4 -> 2.1.5
  bash scripts/bump_version.sh minor      # 2.1.4 -> 2.2.0
  bash scripts/bump_version.sh major      # 2.1.4 -> 3.0.0
  bash scripts/bump_version.sh 2.1.5      # Явно указать версию
  bash scripts/bump_version.sh --validate # Только проверка синхронности

Обновляет:
  1. pubspec.yaml - version: X.X.X+YY
  2. android/app/build.gradle.kts - versionCode/versionName
  3. lib/main.dart - app_version в analytics
EOF
}

get_current_version() {
    # Читаем версию из pubspec.yaml
    if ! grep -q "version:" "$PUBSPEC"; then
        echo -e "${RED}❌ Не найдена версия в $PUBSPEC${NC}"
        exit 1
    fi

    local version_line=$(grep "version:" "$PUBSPEC" | head -1 | sed 's/#.*//')  # Убираем комментарии
    VERSION=$(echo "$version_line" | sed 's/.*version: *\([0-9.]*\)+.*/\1/' | tr -d ' ')
    BUILD=$(echo "$version_line" | sed 's/.*+\([0-9]*\).*/\1/' | tr -d ' ')

    if [[ -z "$VERSION" ]] || [[ -z "$BUILD" ]]; then
        echo -e "${RED}❌ Не удалось распарсить версию из $PUBSPEC${NC}"
        echo -e "${YELLOW}Версия: '$VERSION', Build: '$BUILD'${NC}"
        exit 1
    fi
}

bump_version() {
    local bump_type=$1
    local IFS='.'
    read -ra VERSION_PARTS <<< "$VERSION"
    local major="${VERSION_PARTS[0]}"
    local minor="${VERSION_PARTS[1]}"
    local patch="${VERSION_PARTS[2]}"

    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        [0-9]*.[0-9]*.[0-9]*)
            # Явно указана версия
            IFS='.' read -ra VERSION_PARTS <<< "$bump_type"
            major="${VERSION_PARTS[0]}"
            minor="${VERSION_PARTS[1]}"
            patch="${VERSION_PARTS[2]}"
            ;;
        *)
            echo -e "${RED}❌ Неверный тип: $bump_type${NC}"
            print_usage
            exit 1
            ;;
    esac

    NEW_VERSION="$major.$minor.$patch"
    NEW_BUILD=$((BUILD + 1))
}

update_pubspec() {
    # Обновляем pubspec.yaml
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/version: *[0-9.]*+[0-9]*/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC"
    else
        # Linux/Git Bash
        sed -i "s/version: *[0-9.]*+[0-9]*/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC"
    fi
    echo -e "${GREEN}✅ pubspec.yaml:${NC} version: $NEW_VERSION+$NEW_BUILD"
}

update_gradle() {
    # Обновляем build.gradle.kts
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/versionCode = [0-9]*/versionCode = $NEW_BUILD/" "$GRADLE"
        sed -i '' "s/versionName = \"[0-9.]*\"/versionName = \"$NEW_VERSION\"/" "$GRADLE"
    else
        sed -i "s/versionCode = [0-9]*/versionCode = $NEW_BUILD/" "$GRADLE"
        sed -i "s/versionName = \"[0-9.]*\"/versionName = \"$NEW_VERSION\"/" "$GRADLE"
    fi
    echo -e "${GREEN}✅ build.gradle.kts:${NC} versionCode=$NEW_BUILD, versionName=\"$NEW_VERSION\""
}

update_main_dart() {
    # Обновляем lib/main.dart
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/'app_version': '[0-9.]*'/'app_version': '$NEW_VERSION'/" "$MAIN_DART"
    else
        sed -i "s/'app_version': '[0-9.]*'/'app_version': '$NEW_VERSION'/" "$MAIN_DART"
    fi
    echo -e "${GREEN}✅ lib/main.dart:${NC} app_version: '$NEW_VERSION'"
}

validate_sync() {
    echo -e "\n${BLUE}🔍 Проверка синхронности версий...${NC}\n"

    # Читаем версии из всех трех файлов
    local version_line=$(grep "version:" "$PUBSPEC" | head -1 | sed 's/#.*//')
    local pubspec_ver=$(echo "$version_line" | sed 's/.*version: *\([0-9.]*\)+.*/\1/' | tr -d ' ')
    local pubspec_build=$(echo "$version_line" | sed 's/.*+\([0-9]*\).*/\1/' | tr -d ' ')

    local gradle_ver=$(grep "versionName" "$GRADLE" | sed 's/.*versionName = "\([0-9.]*\)".*/\1/')
    local gradle_build=$(grep "versionCode" "$GRADLE" | sed 's/.*versionCode = \([0-9]*\).*/\1/')

    local main_ver=$(grep "'app_version'" "$MAIN_DART" | sed "s/.*'app_version': '\([0-9.]*\)'.*/\1/")

    echo -e "📄 pubspec.yaml:        $pubspec_ver+$pubspec_build"
    echo -e "🤖 build.gradle.kts:   $gradle_ver (build $gradle_build)"
    echo -e "🎯 lib/main.dart:       $main_ver"
    echo ""

    local errors=0

    if [[ "$pubspec_ver" != "$gradle_ver" ]]; then
        echo -e "${RED}❌ Версия не совпадает: pubspec ($pubspec_ver) != gradle ($gradle_ver)${NC}"
        errors=1
    fi

    if [[ "$pubspec_ver" != "$main_ver" ]]; then
        echo -e "${RED}❌ Версия не совпадает: pubspec ($pubspec_ver) != main.dart ($main_ver)${NC}"
        errors=1
    fi

    if [[ "$pubspec_build" != "$gradle_build" ]]; then
        echo -e "${RED}❌ Build number не совпадает: pubspec ($pubspec_build) != gradle ($gradle_build)${NC}"
        errors=1
    fi

    if [[ $errors -eq 0 ]]; then
        echo -e "${GREEN}✅ Все версии синхронизированы: $pubspec_ver+$pubspec_build${NC}"
        return 0
    else
        return 1
    fi
}

# Проверка аргументов
if [[ $# -lt 1 ]]; then
    print_usage
    exit 1
fi

# Режим валидации
if [[ "$1" == "--validate" ]]; then
    validate_sync
    exit $?
fi

# Получаем текущую версию
get_current_version

echo -e "\n${BOLD}📦 HydraCoach Version Bumper${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}\n"
echo -e "Текущая версия: ${YELLOW}$VERSION+$BUILD${NC}"

# Вычисляем новую версию
bump_version "$1"

echo -e "Новая версия:   ${GREEN}${BOLD}$NEW_VERSION+$NEW_BUILD${NC}\n"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}\n"

# Обновляем файлы
update_pubspec
update_gradle
update_main_dart

# Валидация
echo -e "\n${BLUE}══════════════════════════════════════════════════${NC}"
if validate_sync; then
    echo -e "\n${GREEN}${BOLD}🎉 Версия успешно обновлена до $NEW_VERSION+$NEW_BUILD!${NC}"
    echo -e "\n${YELLOW}💡 Следующие шаги:${NC}"
    echo -e "   1. Проверьте изменения: git diff"
    echo -e "   2. Закоммитьте: git commit -am \"chore: Bump version to $NEW_VERSION\""
    echo -e "   3. Создайте тег: git tag v$NEW_VERSION"
    exit 0
else
    echo -e "\n${RED}⚠️  Обнаружены несоответствия! Проверьте файлы вручную.${NC}"
    exit 1
fi
