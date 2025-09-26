# Настройка Sensitive файлов для HydraCoach

## Важные файлы для сборки (НЕ коммитить в публичный репозиторий!)

### Android сборка:
1. **Keystore файл**: `C:/android/keys/upload-keystore.jks`
   - Используется для подписи APK/AAB для Google Play
   - Хранится отдельно от проекта

2. **key.properties**: `android/key.properties`
   - Содержит пароли к keystore
   - УЖЕ в .gitignore ✅

3. **google-services.json**: `android/app/google-services.json`
   - Firebase конфигурация для Android
   - УЖЕ в .gitignore ✅

### iOS сборка:
1. **GoogleService-Info.plist**: `ios/Runner/GoogleService-Info.plist`
   - Firebase конфигурация для iOS
   - УЖЕ в .gitignore ✅

## Рекомендации по безопасному хранению:

### Вариант 1: Приватный репозиторий для ключей
Создайте отдельный ПРИВАТНЫЙ репозиторий `hydracoach-keys` с:
```
/android/
  - upload-keystore.jks
  - key.properties
  - google-services.json
/ios/
  - GoogleService-Info.plist
```

### Вариант 2: Зашифрованный архив
1. Создайте архив со всеми sensitive файлами
2. Зашифруйте его паролем
3. Храните в облаке (Google Drive, Dropbox)

### Вариант 3: Переменные окружения (для CI/CD)
Для GitHub Actions или других CI/CD:
- Сохраните содержимое файлов как секреты
- Восстанавливайте их при сборке

## Инструкция для других разработчиков:

1. Склонируйте основной репозиторий
2. Получите sensitive файлы от владельца проекта
3. Разместите их:
   - `android/key.properties`
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - Keystore по пути из key.properties

## ВАЖНО:
- НИКОГДА не коммитьте эти файлы в публичный репозиторий
- Регулярно меняйте пароли keystore
- Используйте разные ключи для debug и release