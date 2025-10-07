# 🚨 КРИТИЧНО: Security Fix Required!

## ❌ Проблема: Пароли Keystore в Git

**Обнаружена критичная уязвимость:** Файл `android/key.properties` с паролями keystore был закоммичен в git репозиторий!

### Текущие exposed пароли:
```
storePassword=HydraCoach5575Secure!
keyPassword=HydraCoach5575Secure!
```

**Риск:** Любой с доступом к репозиторию может:
- Подписывать поддельные версии приложения
- Загружать вредоносные обновления в Google Play
- Украсть identity приложения

---

## ✅ Немедленные действия (СРОЧНО!)

### Шаг 1: Смените пароли keystore

**ВАЖНО:** Старые пароли уже скомпрометированы, их нужно сменить!

```bash
# 1. Создайте НОВЫЙ keystore с НОВЫМИ паролями
keytool -genkeypair -v \
  -keystore C:/android/keys/upload-keystore-new.jks \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass "NEW_SECURE_PASSWORD_HERE" \
  -keypass "NEW_SECURE_PASSWORD_HERE"

# 2. В Google Play Console обновите signing key
#    Play Console → Release → Setup → App signing
```

### Шаг 2: Удалите файл из git истории

```bash
# Удалите key.properties из git (но оставьте локально)
git rm --cached android/key.properties

# Закоммитьте удаление
git commit -m "security: Remove key.properties from git (exposed passwords)"

# ОПЦИОНАЛЬНО: Очистите git историю (удалит пароли из всех commits)
# ⚠️  Это переписывает историю! Координируйте с командой!
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch android/key.properties" \
  --prune-empty --tag-name-filter cat -- --all
```

### Шаг 3: Создайте новый key.properties

```bash
# Создайте новый файл (он уже в .gitignore)
cp android/key.properties.example android/key.properties

# Отредактируйте с НОВЫМИ паролями
nano android/key.properties
```

Пример содержимого:
```properties
storePassword=YOUR_NEW_SUPER_SECURE_PASSWORD
keyPassword=YOUR_NEW_SUPER_SECURE_PASSWORD
keyAlias=upload
storeFile=C:/android/keys/upload-keystore-new.jks
```

### Шаг 4: Проверьте .gitignore

```bash
# Убедитесь что key.properties в .gitignore
grep "key.properties" .gitignore

# Если нет - добавьте:
echo "android/key.properties" >> .gitignore
```

### Шаг 5: Проверьте что файл больше не tracked

```bash
git status | grep key.properties
# Не должно быть вывода (файл ignored)
```

---

## 🔐 Альтернатива: Переменные окружения

Ещё более безопасный способ - использовать environment variables:

### 1. Создайте переменные окружения

**Windows:**
```powershell
[System.Environment]::SetEnvironmentVariable("KEYSTORE_PASSWORD", "your-password", "User")
[System.Environment]::SetEnvironmentVariable("KEY_PASSWORD", "your-password", "User")
```

**Linux/Mac:**
```bash
echo 'export KEYSTORE_PASSWORD="your-password"' >> ~/.bashrc
echo 'export KEY_PASSWORD="your-password"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Обновите android/key.properties

```properties
storePassword=${KEYSTORE_PASSWORD}
keyPassword=${KEY_PASSWORD}
keyAlias=upload
storeFile=C:/android/keys/upload-keystore.jks
```

### 3. Обновите android/app/build.gradle.kts

Добавьте fallback для локальной разработки:

```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Читаем из переменных окружения или файла
val storePassword = System.getenv("KEYSTORE_PASSWORD")
    ?: keystoreProperties.getProperty("storePassword")
val keyPassword = System.getenv("KEY_PASSWORD")
    ?: keystoreProperties.getProperty("keyPassword")
```

---

## 📋 Чеклист проверки

После выполнения всех шагов:

- [ ] Новый keystore создан с новыми паролями
- [ ] `android/key.properties` удален из git (`git rm --cached`)
- [ ] `android/key.properties` в .gitignore
- [ ] Новый `key.properties` создан локально (не в git)
- [ ] `git status` не показывает `key.properties`
- [ ] Сборка релиза работает: `flutter build apk --release`
- [ ] Google Play Console обновлен с новым signing key (если используется app signing)

---

## 🚀 После фикса

1. **Force push** (если очищали историю):
   ```bash
   git push origin --force --all
   git push origin --force --tags
   ```

2. **Уведомите команду** что нужно:
   ```bash
   git pull --force
   # И создать свой локальный key.properties
   ```

3. **Мониторинг**: Проверьте Google Play Console на подозрительные загрузки

---

## 🔗 Дополнительная информация

- [Android App Signing Best Practices](https://developer.android.com/studio/publish/app-signing)
- [Git Remove Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [Securing Android KeyStore](https://developer.android.com/privacy-and-security/keystore)

---

**⚠️  Это не drill! Пожалуйста, выполните эти шаги как можно скорее!**
