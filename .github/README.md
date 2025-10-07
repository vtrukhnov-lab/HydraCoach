# 🤖 GitHub Actions CI/CD

Автоматизация для проекта HydraCoach.

## 📋 Workflows

### 1. CI (Continuous Integration) - `.github/workflows/ci.yml`

**Триггеры:**
- Pull Request в `main`
- Push в `main`

**Jobs:**

#### 🔬 Analyze & Format Check
- ✅ Форматирование кода (`dart format`)
- ✅ Статический анализ (`flutter analyze`)
- ✅ Проверка на `print()` statements
- ✅ Валидация синхронности версий (pubspec.yaml ↔ build.gradle.kts ↔ main.dart)

#### 🧪 Run Tests
- ✅ Запуск unit/widget тестов
- ✅ Coverage report
- ✅ Upload в Codecov (опционально)

#### 🔨 Build Debug APK
- ✅ Сборка debug APK
- ✅ Upload артефакта (хранится 7 дней)

#### 🔐 Security Checks
- ✅ Проверка на hardcoded secrets
- ✅ Проверка что key.properties не в git

---

### 2. Release Build - `.github/workflows/release.yml`

**Триггер:**
- Push git tag вида `v*.*.*` (например `v2.1.5`)

**Jobs:**

#### 🚀 Create Release Build
- ✅ Build release APK
- ✅ Build release AAB (App Bundle)
- ✅ Генерация release notes из commits
- ✅ Создание GitHub Release с артефактами

---

## 🚀 Использование

### Локальная разработка

Перед коммитом автоматически запускается **pre-commit hook**:
```bash
git add .
git commit -m "feat: новая фича"
# → запускаются проверки автоматически
```

Ручной запуск проверок:
```bash
make analyze    # flutter analyze
make format     # dart format
make test       # flutter test
```

### Pull Request

При создании PR в GitHub автоматически:
1. ✅ Проверяется форматирование
2. ✅ Запускается flutter analyze
3. ✅ Проверяются версии
4. ✅ Запускаются тесты
5. ✅ Собирается debug APK

**Статус виден в PR:**
```
✅ CI / Analyze & Format Check (pull_request)
✅ CI / Run Tests (pull_request)
✅ CI / Build Debug APK (pull_request)
✅ CI / Security Checks (pull_request)
```

### Создание релиза

**Способ 1: Автоматический (рекомендуется)**

```bash
# 1. Обновить версию
bash scripts/bump_version.sh 2.1.5

# 2. Создать коммит
git commit -am "chore: Bump version to 2.1.5"

# 3. Создать и push tag
git tag v2.1.5
git push origin v2.1.5

# → GitHub Actions автоматически:
#   - Соберет APK и AAB
#   - Создаст GitHub Release
#   - Прикрепит артефакты
```

**Способ 2: Локальный (текущий)**

```bash
# Полный релиз локально
bash scripts/release.sh

# Или через Makefile
make release
```

---

## ⚙️ Настройка Secrets

Для полной автоматизации (включая signing APK/AAB) нужно настроить secrets в GitHub:

### 1. Перейти в GitHub Repository Settings

```
Repository → Settings → Secrets and variables → Actions
```

### 2. Добавить Secrets

#### Для signing Android builds:

```bash
# 1. Конвертировать keystore в base64
base64 -i upload-keystore.jks -o keystore.b64

# 2. Скопировать содержимое keystore.b64 и создать secret:
# Name: KEYSTORE_BASE64
# Value: <содержимое keystore.b64>
```

**Необходимые secrets:**
- `KEYSTORE_BASE64` - keystore файл в base64
- `KEYSTORE_PASSWORD` - пароль keystore
- `KEY_ALIAS` - алиас ключа (обычно "upload")
- `KEY_PASSWORD` - пароль ключа

#### Для Codecov (опционально):

- `CODECOV_TOKEN` - токен из https://codecov.io

### 3. Обновить workflow для использования secrets

В `release.yml` раскомментировать секцию signing:

```yaml
- name: 🔐 Decode keystore
  run: |
    echo ${{ secrets.KEYSTORE_BASE64 }} | base64 -d > android/app/keystore.jks

- name: 📝 Create key.properties
  run: |
    cat > android/key.properties <<EOF
    storePassword=${{ secrets.KEYSTORE_PASSWORD }}
    keyPassword=${{ secrets.KEY_PASSWORD }}
    keyAlias=${{ secrets.KEY_ALIAS }}
    storeFile=keystore.jks
    EOF
```

---

## 📊 Статус Badges

Добавьте в `README.md` проекта:

```markdown
![CI Status](https://github.com/YOUR_USERNAME/HydraCoach/workflows/CI/badge.svg)
![Release](https://github.com/YOUR_USERNAME/HydraCoach/workflows/Release%20Build/badge.svg)
```

---

## 🔧 Кастомизация

### Изменить Flutter версию

В обоих workflows:
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.35.3'  # ← измените здесь
```

### Добавить новые проверки

В `ci.yml` добавьте новый step:
```yaml
- name: 🆕 Новая проверка
  run: |
    # ваши команды
```

### Изменить условия триггера

```yaml
on:
  pull_request:
    branches: [main, develop]  # ← добавить develop
  push:
    branches: [main]
    paths-ignore:           # ← игнорировать определенные файлы
      - '**.md'
      - 'docs/**'
```

---

## 🐛 Troubleshooting

### ❌ Workflow не запускается

**Проблема:** После push ничего не происходит

**Решение:**
1. Проверьте что файлы в `.github/workflows/`
2. Проверьте синтаксис YAML
3. В GitHub: Actions → Check workflow syntax

### ❌ Build fails на "flutter analyze"

**Проблема:** Много warnings/errors

**Решение:**
```bash
# Локально исправьте все ошибки:
flutter analyze

# Если нужно проигнорировать какие-то warnings:
# Добавьте в analysis_options.yaml
```

### ❌ Version sync check fails

**Проблема:** Версии не синхронизированы

**Решение:**
```bash
# Используйте скрипт для обновления:
bash scripts/bump_version.sh patch

# Проверьте синхронность:
bash scripts/bump_version.sh --validate
```

### ❌ Tests fail

**Проблема:** `flutter test` не проходит

**Решение:**
```bash
# Локально проверьте:
flutter test

# Если тестов нет - создайте базовые:
# test/example_test.dart
```

---

## 📚 Дополнительные ресурсы

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Fastlane для Flutter](https://docs.fastlane.tools/getting-started/cross-platform/flutter/)

---

## ✅ Checklist после настройки

- [ ] CI workflow запускается на PR
- [ ] Все проверки проходят (зеленые ✅)
- [ ] Release workflow создает releases при push tag
- [ ] Secrets настроены (для signing)
- [ ] Badges добавлены в README
- [ ] Команда знает как создавать релизы

---

**🎉 Готово! Теперь у вас полная CI/CD автоматизация!**
