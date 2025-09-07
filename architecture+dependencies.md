# HydraCoach - Полная архитектура проекта

## 📁 Структура проекта и зависимости

```
hydracoach/
├── lib/
│   ├── main.dart                      # Точка входа приложения
│   │                                   # - Инициализация Firebase
│   │                                   # - Настройка RemoteConfig
│   │                                   # - Запуск MyApp widget
│   │                                   # - Обработка глобальных ошибок
│   │
│   ├── config/
│   │   ├── remote_config.dart         # Управление удаленными параметрами
│   │   │                               # - Формулы расчета воды/электролитов
│   │   │                               # - Пороги HRI и Heat Index
│   │   │                               # - Параметры алкоголя (std_drink_grams и т.д.)
│   │   │                               # - Лимиты уведомлений
│   │   │
│   │   ├── app_config.dart            # Локальная конфигурация
│   │   │                               # - API ключи (погода и др.)
│   │   │                               # - Базовые URL
│   │   │                               # - Константы приложения
│   │   │
│   │   └── feature_flags.dart         # Флаги функциональности
│   │                                   # - publisher_sdk_enabled
│   │                                   # - alcohol_module_enabled
│   │                                   # - sober_mode_default
│   │
│   ├── models/
│   │   ├── user_profile.dart          # Профиль пользователя
│   │   │                               # - Вес, рост, возраст
│   │   │                               # - Режим питания (normal/keto/fasting)
│   │   │                               # - Уровень активности
│   │   │                               # - IF окна (начало/конец)
│   │   │
│   │   ├── daily_goals.dart           # Дневные цели
│   │   │                               # - min/opt/max вода
│   │   │                               # - Цели Na/K/Mg
│   │   │                               # - Корректировки от погоды/активности
│   │   │
│   │   ├── intake.dart                 # Модель приема жидкости
│   │   │                               # - Timestamp
│   │   │                               # - Тип (вода/электролит/кофе/алкоголь)
│   │   │                               # - Объем и содержание Na/K/Mg
│   │   │                               # - Источник (manual/quick/reminder)
│   │   │
│   │   ├── hydration_status.dart      # Статус гидратации
│   │   │                               # - Текущий статус (норма/разбавление/недобор)
│   │   │                               # - HRI индекс (0-100)
│   │   │                               # - Факторы риска
│   │   │
│   │   ├── alcohol_intake.dart        # Модель алкоголя [UPDATED v0.6.0]
│   │   │                               # - AlcoholType enum (beer/wine/spirits/cocktail)
│   │   │                               # - ABV и объем
│   │   │                               # - Расчет в стандартные дринки (SD)
│   │   │                               # - Методы коррекции воды/натрия
│   │   │
│   │   ├── quick_favorites.dart       # Модель фаворитов [NEW v0.6.0]
│   │   │                               # - QuickFavorite класс
│   │   │                               # - QuickFavoritesManager
│   │   │                               # - Метаданные для алкоголя
│   │   │                               # - Сохранение в SharedPreferences
│   │   │
│   │   └── subscription.dart          # Модель подписки
│   │                                   # - Статус (free/pro/trial)
│   │                                   # - Entitlement из RevenueCat
│   │                                   # - Дата истечения
│   │
│   ├── screens/
│   │   ├── main_screen.dart           # Главный экран
│   │   │                               # - 3 кольца прогресса (Вода/Na/K)
│   │   │                               # - Индикатор Mg
│   │   │                               # - Статус и HRI
│   │   │                               # - Быстрые действия
│   │   │
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart # Онбординг мастер
│   │   │   ├── weight_step.dart       # Шаг ввода веса
│   │   │   ├── diet_step.dart         # Выбор режима питания
│   │   │   ├── activity_step.dart     # Уровень активности
│   │   │   ├── fasting_step.dart      # Настройка IF окон
│   │   │   └── permissions_step.dart  # Разрешения (уведомления/гео)
│   │   │
│   │   ├── history_screen.dart        # История и аналитика
│   │   │                               # - Вкладки День/Неделя/Месяц
│   │   │                               # - Графики трендов
│   │   │                               # - Календарь-тепловая карта
│   │   │
│   │   ├── settings/
│   │   │   ├── settings_screen.dart   # Главный экран настроек
│   │   │   ├── profile_settings.dart  # Настройки профиля
│   │   │   ├── units_settings.dart    # Единицы измерения
│   │   │   ├── reminder_settings.dart # Настройки напоминаний
│   │   │   ├── subscription_settings.dart # Управление подпиской
│   │   │   └── sober_mode_settings.dart   # Трезвый режим
│   │   │
│   │   ├── alcohol/
│   │   │   ├── alcohol_log_screen.dart    # Логирование алкоголя [UPDATED v0.6.0]
│   │   │   │                               # - Сетка 3x3 (3 FREE, 6 PRO типов)
│   │   │   │                               # - Иконки 60px
│   │   │   │                               # - Формат "Type: X%" в одну строку
│   │   │   │                               # - Сохранение в фавориты с выбором слота
│   │   │   │                               # - Полная локализация
│   │   │   │
│   │   │   ├── recovery_plan_screen.dart  # План восстановления (PRO)
│   │   │   ├── sobriety_calendar.dart     # Календарь трезвости (PRO)
│   │   │   └── morning_checkin.dart       # Утренний чек-ин
│   │   │
│   │   ├── reports/
│   │   │   ├── daily_report_screen.dart   # Дневной отчет
│   │   │   └── weekly_report_screen.dart  # Недельный PRO-отчет
│   │   │
│   │   └── paywall_screen.dart        # Экран подписки
│   │                                   # - Динамические тексты из RC
│   │                                   # - A/B тесты офферов
│   │
│   ├── services/
│   │   ├── hydration_calculator.dart  # Ядро расчетов
│   │   │                               # - Базовые потребности от веса
│   │   │                               # - Корректировки (жара/активность/кофе/алкоголь)
│   │   │                               # - Расчет статусов и HRI
│   │   │
│   │   ├── weather_service.dart       # Сервис погоды
│   │   │                               # - Получение данных через API
│   │   │                               # - Расчет Heat Index
│   │   │                               # - Кеширование
│   │   │
│   │   ├── notification_service.dart  # Управление уведомлениями
│   │   │                               # - Планирование напоминаний
│   │   │                               # - Контекстные триггеры
│   │   │                               # - Анти-спам логика
│   │   │                               # - Тихие часы
│   │   │
│   │   ├── firebase_service.dart      # Firebase интеграция
│   │   │                               # - Auth
│   │   │                               # - Firestore синхронизация
│   │   │                               # - Analytics события
│   │   │                               # - Crashlytics
│   │   │
│   │   ├── revenue_cat_service.dart   # Биллинг через RevenueCat
│   │   │                               # - Проверка подписки
│   │   │                               # - Покупка/восстановление
│   │   │                               # - Кеширование статуса
│   │   │
│   │   ├── alcohol_service.dart       # Логика алкоголя [UPDATED v0.6.0]
│   │   │                               # - Расчет SD (стандартных дринков)
│   │   │                               # - Корректировки целей
│   │   │                               # - Recovery протоколы
│   │   │                               # - Интеграция с фаворитами
│   │   │
│   │   ├── publisher_sdk_adapter.dart # Адаптер для SDK издателя
│   │   │                               # - AppsFlyer интеграция
│   │   │                               # - Milestone события (pl_*)
│   │   │                               # - ATT/CMP обработка
│   │   │
│   │   └── export_service.dart        # Экспорт данных
│   │                                   # - CSV генерация
│   │                                   # - Форматирование отчетов
│   │
│   ├── widgets/
│   │   ├── quick_add_widget.dart      # Быстрое добавление [UPDATED v0.6.0]
│   │   │                               # - Категория Liquids вместо Water
│   │   │                               # - Интеграция с AlcoholService
│   │   │                               # - Динамические иконки для алкоголя
│   │   │                               # - 3 слота фаворитов (1 FREE, 2 PRO)
│   │   │
│   │   ├── progress_rings.dart        # Кольца прогресса (Вода/Na/K)
│   │   ├── mg_indicator.dart          # Индикатор магния
│   │   ├── hri_gauge.dart             # Шкала HRI
│   │   ├── weather_card.dart          # Карточка погоды с Heat Index
│   │   ├── quick_log_button.dart      # Быстрые кнопки логирования
│   │   ├── status_card.dart           # Карточка текущего статуса
│   │   ├── daily_report_card.dart     # Карточка дневного отчета
│   │   ├── alcohol_counter_card.dart  # Карточка "минимум вреда"
│   │   └── pro_feature_gate.dart      # Обертка для PRO функций
│   │
│   ├── providers/                     # State Management (Provider)
│   │   ├── user_provider.dart         # Состояние пользователя
│   │   ├── hydration_provider.dart    # Состояние гидратации
│   │   ├── goals_provider.dart        # Управление целями
│   │   ├── history_provider.dart      # История приемов
│   │   ├── subscription_provider.dart # Состояние подписки
│   │   └── alcohol_provider.dart      # Состояние алкогольного модуля
│   │
│   ├── utils/
│   │   ├── constants.dart             # Константы приложения
│   │   ├── validators.dart            # Валидаторы ввода
│   │   ├── formatters.dart            # Форматирование данных
│   │   ├── date_utils.dart            # Работа с датами/временем
│   │   └── platform_utils.dart        # Платформенные утилиты
│   │
│   └── l10n/                          # ЛОКАЛИЗАЦИЯ [UPDATED v0.6.0]
│       ├── app_en.arb                 # Английские строки + "liquids"
│       ├── app_ru.arb                 # Русские строки + "liquids"
│       ├── app_es.arb                 # Испанские строки + "liquids"
│       └── l10n.yaml                   # Конфигурация локализации
│
├── assets/
│   ├── images/                        # Изображения
│   ├── icons/                         # Иконки
│   └── fonts/                         # Шрифты
│
├── test/                              # Тесты
│   ├── unit/                          # Unit тесты
│   ├── widget/                        # Widget тесты
│   └── integration/                   # Интеграционные тесты
│
├── pubspec.yaml                       # Зависимости (v0.6.0+10)
├── analysis_options.yaml              # Правила линтера
├── CHANGELOG.md                       # История изменений (обновлен v0.6.0)
└── README.md                          # Документация

```

## 🆕 Изменения в версии 0.6.0

### Новые файлы:
- `models/quick_favorites.dart` - Система фаворитов для быстрого доступа

### Обновленные модули:

#### `alcohol_log_screen.dart` (580 строк, оптимизировано с 700)
- Сетка 3x3 с 9 типами алкоголя
- Иконки увеличены до 60px
- Формат текста "Beer: 5%" в одну строку
- Унифицированные иконки:
  - 🍺 Beer → `Icons.sports_bar`
  - 🍷 Wine → `Icons.wine_bar`
  - 🥃 Spirits/Vodka/Whiskey/Rum/Gin/Tequila → `Icons.liquor`
  - 🍹 Cocktail → `Icons.local_drink`
- Полная локализация без хардкода
- Интеграция с фаворитами

#### `quick_add_widget.dart`
- Переименована категория Water → Liquids
- Интеграция с AlcoholService для алкогольных фаворитов
- Динамическое определение иконок на основе типа алкоголя
- Метод `_getFavoriteIcon()` с поддержкой всех типов напитков

#### `alcohol_service.dart`
- Полная интеграция с фаворитами
- Методы для добавления через быстрый доступ
- Корректное обновление истории и HRI

## 🌍 Система локализации

### Обновления в ARB файлах (v0.6.0):

#### Добавлены ключи:
```json
// app_en.arb
"liquids": "Liquids"

// app_ru.arb  
"liquids": "Напитки"

// app_es.arb
"liquids": "Líquidos"
```

### Правила локализации:
1. **НИКОГДА не хардкодить строки в коде**
2. **Всегда добавлять в app_en.arb первым**
3. **Использовать параметры для динамических значений**
4. **Использовать select/plural для вариативности**

## 🔄 Remote Config параметры

### Алкогольные параметры:
```dart
// Стандартный дринк
static const stdDrinkGrams = 'std_drink_grams';  // 10г

// Корректировки на SD
static const alcoholDrinkBonusMl = 'alcohol_drink_bonus_ml';  // 150мл
static const naPerSdMg = 'na_per_sd_mg';  // 200мг

// Влияние на HRI
static const alcHriRiskPerSd = 'alc_hri_risk_per_sd';  // 3.0
static const alcHriRiskCap = 'alc_hri_risk_cap';  // 15.0
```

## 🏗️ Зависимости между модулями (v0.6.0)

### Новые связи:
1. **quick_add_widget.dart** → **alcohol_service.dart** (прямая интеграция)
2. **alcohol_log_screen.dart** → **quick_favorites.dart** (сохранение)
3. **quick_favorites.dart** → **SharedPreferences** (персистентность)

### Критические зависимости:
1. **main.dart** → инициализирует все сервисы включая AlcoholService
2. **AlcoholService** → влияет на HydrationCalculator через корректировки
3. **QuickAddWidget** → использует AlcoholService для логирования
4. **Все экраны с алкоголем** → полная локализация через AppLocalizations

## 🔐 Гейтинг PRO функций (алкоголь)

### FREE (3 типа):
- Beer
- Wine  
- Spirits

### PRO (6 дополнительных):
- Cocktail
- Vodka
- Whiskey
- Rum
- Tequila
- Gin

### Фавориты:
- 1 слот FREE
- 2 дополнительных слота PRO

## 📱 UI/UX стандарты (v0.6.0)

### Размеры элементов:
- Иконки в сетке выбора: **60px**
- Иконки в фаворитах: **28px**
- Иконки в категориях: **42px**

### Форматы текста:
- Алкоголь: **"Type: X%"** (например, "Beer: 5%")
- Одна строка с `maxLines: 1`
- `TextOverflow.ellipsis` для длинных названий

### Цветовая схема алкоголя:
- Основной: `Colors.red[500]`
- Выбранный: `Colors.red[50]` фон, `Colors.red[400]` граница
- Заблокированный PRO: `Colors.grey[50]` фон

## ⚠️ Важные изменения для разработчиков

### v0.6.0 Breaking Changes:
1. **Категория Water переименована в Liquids** - обновите все ссылки
2. **Эмодзи заменены на Material Icons** - удалите старый код с эмодзи
3. **AlcoholService обязателен для фаворитов** - добавьте Provider

### Миграция:
```dart
// Старый код (удалить):
String emoji = '🍺';

// Новый код:
IconData icon = Icons.sports_bar;
```

## 🚀 Следующие шаги

1. Добавить экран выбора напитков для категории Liquids
2. Реализовать pre-drink и recovery протоколы (PRO)
3. Добавить календарь трезвости (PRO)
4. Интегрировать с Apple Health/Google Fit
5. Добавить виджеты для домашнего экрана