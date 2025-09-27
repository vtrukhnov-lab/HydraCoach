# Claude Instructions for HydroCoach Project
Общение на русском языке
Все задачи которые требуют утвердить логику - сначала утверждаются со мной. Если легкий багофикс - утверждать не надо
**Version Code Mismatch Issue:** Google Play "Version code X already used" despite updating pubspec.yaml → Always update ALL THREE places:
1. pubspec.yaml version (e.g., 2.1.1+31)
2. android/app/build.gradle.kts versionCode/versionName (lines 43-44)
3. lib/main.dart app_version in logEvent calls (for settings display)

## 📦 Инструкция по сборке релизов

### Подготовка к релизу
1. **Обновить версию в ТРЕХ местах:**
   - `pubspec.yaml`: version: X.X.X+YY (например 2.1.3+33)
   - `android/app/build.gradle.kts`: versionCode и versionName (строки ~50-51)
   - `lib/main.dart`: app_version в logEvent вызовах

2. **Создать папку для версии:**
   ```bash
   mkdir -p docs/release_notes/X.X.X
   ```

### Сборка Android релизов

#### APK для тестирования:
```bash
# Очистка и сборка APK
cd android && ./gradlew clean && cd ..
flutter build apk --release

# Копирование в папку релиза
cp build/app/outputs/flutter-apk/app-release.apk docs/release_notes/X.X.X/hydracoach-X.X.X-release.apk
```

#### AAB для Google Play:
```bash
# Сборка AAB (App Bundle)
flutter build appbundle --release

# Копирование в папку релиза
cp build/app/outputs/bundle/release/app-release.aab docs/release_notes/X.X.X/hydracoach-X.X.X-release.aab
```

**ВАЖНО:** AAB подписывается автоматически с использованием ключей из:
- Keystore: `C:/android/keys/upload-keystore.jks`
- Конфигурация: `android/key.properties`

### Структура папки релиза
```
docs/release_notes/X.X.X/
├── hydracoach-X.X.X-release.apk    # Для тестирования
├── hydracoach-X.X.X-release.aab    # Для Google Play
├── release_notes.md                 # Описание изменений
├── test_checklist.md                # Чеклист для тестера
└── README.md                        # Общая информация о релизе
```

### После сборки
1. Протестировать APK на реальном устройстве
2. Проверить все пункты из test_checklist.md
3. Загрузить AAB в Google Play Console
4. Обновить описание релиза в консоли