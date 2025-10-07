# 🔐 Миграция API ключей в Firebase Remote Config

## Проблема

OpenWeatherMap API ключ **hardcoded** в `lib/services/weather_service.dart:15`:

```dart
static const String apiKey = 'c460f153f615a343e0fe5158eae73121';
```

**Риски:**
- ❌ API ключ виден в исходном коде
- ❌ Можно извлечь через reverse engineering APK
- ❌ Нельзя изменить ключ без релиза
- ❌ Злоумышленники могут использовать ключ

---

## ✅ Решение: Firebase Remote Config

Firebase Remote Config позволяет:
- ✅ Хранить API ключи безопасно на сервере
- ✅ Менять ключи без релиза приложения
- ✅ Разные ключи для dev/prod
- ✅ Удаленное отключение если ключ скомпрометирован

---

## 🚀 Шаг 1: Добавить ключ в Firebase Console

### 1.1 Откройте Firebase Console

1. Зайдите в [Firebase Console](https://console.firebase.google.com)
2. Выберите проект **HydraCoach**
3. В левом меню: **Remote Config**

### 1.2 Создайте новый параметр

**Нажмите "Add parameter":**

```
Parameter key: openweathermap_api_key
Default value: c460f153f615a343e0fe5158eae73121
Description: OpenWeatherMap API key for weather data
```

**Настройте условие для разработки (опционально):**

- Нажмите **"Add value for condition"**
- Create new condition: `App ID matches .*\.dev`
- Value: `YOUR_DEV_API_KEY_HERE` (если есть отдельный dev ключ)

### 1.3 Опубликуйте изменения

- Нажмите **"Publish changes"**
- Подтвердите публикацию

---

## 🔧 Шаг 2: Обновить RemoteConfigService

### 2.1 Добавить метод для API ключа

Файл: `lib/services/remote_config_service.dart`

```dart
// Добавьте в класс RemoteConfigService

/// Получить OpenWeatherMap API ключ
String getOpenWeatherMapApiKey() {
  if (_remoteConfig == null) {
    // Fallback если Remote Config не инициализирован
    logger.w('⚠️ Remote Config не инициализирован, используется fallback API ключ');
    return 'c460f153f615a343e0fe5158eae73121';
  }

  final apiKey = _remoteConfig!.getString('openweathermap_api_key');

  if (apiKey.isEmpty) {
    logger.w('⚠️ API ключ не найден в Remote Config, используется fallback');
    return 'c460f153f615a343e0fe5158eae73121';
  }

  // В production НЕ логируем полный ключ
  if (kDebugMode) {
    logger.i('🔑 Загружен API ключ: ${apiKey.substring(0, 8)}...');
  }

  return apiKey;
}
```

### 2.2 Добавить default значение

В методе `_getDefaults()` добавьте:

```dart
Map<String, dynamic> _getDefaults() {
  return {
    // ... существующие defaults ...

    'openweathermap_api_key': 'c460f153f615a343e0fe5158eae73121',
  };
}
```

---

## 🌡️ Шаг 3: Обновить WeatherService

### 3.1 Удалить hardcoded ключ

Файл: `lib/services/weather_service.dart`

**Было:**
```dart
class WeatherService extends ChangeNotifier {
  // OpenWeatherMap
  static const String apiKey = 'c460f153f615a343e0fe5158eae73121';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
```

**Стало:**
```dart
import 'package:hydracoach/services/remote_config_service.dart';

class WeatherService extends ChangeNotifier {
  // OpenWeatherMap
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // API ключ загружается из Firebase Remote Config
  String get apiKey => RemoteConfigService.instance.getOpenWeatherMapApiKey();
```

### 3.2 Обновить использование apiKey

Найдите строку **118** где используется `$apiKey`:

**Было:**
```dart
final url = Uri.parse(
  '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=en',
);
```

**Стало:**
```dart
final apiKey = RemoteConfigService.instance.getOpenWeatherMapApiKey();
final url = Uri.parse(
  '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=en',
);
```

---

## ✅ Шаг 4: Тестирование

### 4.1 Проверка инициализации

Убедитесь что Remote Config инициализируется в `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Инициализация Remote Config
  await RemoteConfigService.instance.initialize();

  // ... остальной код ...
}
```

### 4.2 Проверка в логах

После запуска приложения проверьте логи:

```
✅ Remote Config инициализирован
📊 Параметры загружены: X
🔑 Загружен API ключ: c460f153...
```

### 4.3 Проверка погоды

1. Откройте приложение
2. Тапните на Weather Card
3. Проверьте что погода загружается корректно
4. В логах должно быть: `🌡️ Weather loaded: temp=...`

---

## 🔐 Шаг 5: Удалить старый ключ из кода

После успешного тестирования:

### 5.1 Замените ключ на placeholder

В fallback значениях используйте недействительный ключ:

```dart
// RemoteConfigService defaults
'openweathermap_api_key': 'INVALID_KEY_USE_REMOTE_CONFIG',

// WeatherService fallback
logger.w('⚠️ Remote Config не инициализирован, используется fallback API ключ');
return 'INVALID_KEY_USE_REMOTE_CONFIG';  // Это вызовет ошибку и сразу видно
```

Таким образом если Remote Config не работает - будет явная ошибка.

### 5.2 Проверьте что нет других мест

```bash
# Поиск всех упоминаний ключа
grep -r "c460f153f615a343e0fe5158eae73121" lib/
grep -r "openweathermap" lib/ -i
```

---

## 📱 Шаг 6: Обновление существующих пользователей

### Плавная миграция (рекомендуется)

**Версия 2.1.5:**
- Добавить чтение из Remote Config
- Оставить hardcoded ключ как fallback
- Опубликовать релиз

**Версия 2.1.6 (через 1-2 недели):**
- Убедиться что все пользователи обновились
- Заменить hardcoded ключ на INVALID
- Теперь все используют Remote Config

### Проверка покрытия

В Firebase Analytics можно посмотреть процент пользователей на версии 2.1.5+

---

## 🚨 План действий при компрометации ключа

Если API ключ скомпрометирован (например через reverse engineering):

### Немедленно:

1. **Создать новый ключ в OpenWeatherMap:**
   ```
   https://openweathermap.org/api_keys
   ```

2. **Обновить Firebase Remote Config:**
   ```
   openweathermap_api_key: NEW_KEY_HERE
   → Publish changes
   ```

3. **Отключить старый ключ в OpenWeatherMap**

4. **Результат:**
   - ✅ Все пользователи получат новый ключ через 1 час (minimumFetchInterval)
   - ✅ Не нужно выпускать новый релиз
   - ✅ Старые APK с hardcoded ключом перестанут работать

---

## 📊 Мониторинг

### Firebase Remote Config Analytics

Можно отслеживать:
- Сколько пользователей получили новый параметр
- Какие значения активны (dev/prod)
- Как часто происходит fetch

### Firebase Analytics Events

Логировать успешность загрузки погоды:

```dart
// В WeatherService.getCurrentWeather()
if (response.statusCode == 200) {
  AnalyticsService().log('weather_loaded', {
    'source': 'remote_config',
    'api_key_length': apiKey.length,
  });
} else if (response.statusCode == 401) {
  AnalyticsService().log('weather_api_unauthorized', {
    'source': 'remote_config',
  });
}
```

---

## 🎯 Checklist

После миграции проверьте:

- [ ] API ключ добавлен в Firebase Remote Config
- [ ] Default значение настроено в RemoteConfigService
- [ ] WeatherService читает ключ из Remote Config
- [ ] Hardcoded ключ заменен на fallback
- [ ] Приложение запускается и погода загружается
- [ ] В логах видно: `🔑 Загружен API ключ: ...`
- [ ] Протестировано на реальном устройстве
- [ ] Релиз выпущен с новой логикой

---

## 🔗 Дополнительные ресурсы

- [Firebase Remote Config Docs](https://firebase.google.com/docs/remote-config)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [Best Practices for API Keys](https://cloud.google.com/docs/authentication/api-keys)

---

**⚠️ После миграции НЕ коммитьте реальные API ключи в код!**
