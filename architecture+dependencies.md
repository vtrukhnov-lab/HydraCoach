HydraCoach Project Structure
📁 Project Tree
hydracoach/
├── 📱 lib/
│   ├── main.dart                          # Точка входа приложения
│   ├── firebase_options.dart              # Конфигурация Firebase
│   │
│   ├── 🌍 l10n/                          # Локализация
│   │   ├── app_localizations.dart         # Базовый класс локализации
│   │   ├── app_localizations_en.dart      # Английский
│   │   ├── app_localizations_es.dart      # Испанский
│   │   └── app_localizations_ru.dart      # Русский
│   │
│   ├── 📊 models/                        # Модели данных
│   │   ├── alcohol_intake.dart            # Модель алкогольного напитка
│   │   ├── intake.dart                    # Модель обычного приема
│   │   ├── goals.dart                     # Модель целей
│   │   └── quick_favorites.dart           # Модель избранного
│   │
│   ├── 🎨 screens/                       # Экраны приложения
│   │   ├── home_screen.dart              # Главный экран
│   │   ├── onboarding_screen.dart        # Онбординг
│   │   ├── settings_screen.dart          # Настройки
│   │   ├── paywall_screen.dart           # Экран подписки PRO
│   │   │
│   │   ├── history_screen.dart           # История (главный)
│   │   ├── history/                      # Подэкраны истории
│   │   │   ├── daily_history_screen.dart # Дневная история
│   │   │   ├── weekly_history_screen.dart # Недельная история
│   │   │   └── monthly_history_screen.dart # Месячная история
│   │   │
│   │   └── catalogs/                     # Каталоги напитков/добавок
│   │       ├── alcohol_log_screen.dart   # Алкоголь (красный)
│   │       ├── liquids_catalog_screen.dart # Жидкости (синий)
│   │       ├── hot_drinks_screen.dart    # Горячие напитки (коричневый)
│   │       └── supplements_screen.dart   # Добавки (фиолетовый)
│   │
│   ├── ⚙️ services/                      # Сервисы и бизнес-логика
│   │   ├── alcohol_service.dart          # Логика работы с алкоголем
│   │   ├── subscription_service.dart     # Управление подпиской PRO
│   │   ├── remote_config_service.dart    # Remote Config Firebase
│   │   ├── notification_service.dart     # Уведомления ⚡ v0.7.0
│   │   ├── weather_service.dart          # Погода и Heat Index
│   │   ├── hri_service.dart             # Расчет HRI индекса
│   │   ├── locale_service.dart           # Управление языками
│   │   └── feature_gate_service.dart     # Гейтинг PRO функций
│   │
│   ├── 📦 providers/                     # Провайдеры (временно)
│   │   └── hydration_provider.dart       # TODO: → services/hydration_service.dart
│   │
│   └── 🧩 widgets/                       # Переиспользуемые виджеты
│       ├── quick_add_widget.dart         # Быстрое добавление
│       ├── alcohol_card.dart             # Карточка алкоголя
│       ├── alcohol_checkin_dialog.dart   # Диалог утреннего чек-ина
│       └── daily_report.dart             # Виджет дневного отчета
│
├── 🎨 assets/                            # Ресурсы
│   ├── images/                           # Изображения
│   │   └── app_icon.png                  # Иконка приложения
│   ├── notifications/                    # JSON файлы для уведомлений
│   │   ├── en.json                       # Английские тексты
│   │   ├── es.json                       # Испанские тексты
│   │   └── ru.json                       # Русские тексты
│   └── l10n/                             # Файлы переводов
│       ├── app_en.arb                    # Английский
│       ├── app_es.arb                    # Испанский
│       └── app_ru.arb                    # Русский
│
├── 📋 Configuration Files
│   ├── pubspec.yaml                      # Зависимости проекта (v0.7.0)
│   ├── l10n.yaml                         # Конфигурация локализации
│   ├── .gitignore                        # Git игнорирование
│   └── analysis_options.yaml             # Правила линтера
│
├── 📱 Platform Specific
│   ├── android/                          # Android конфигурация
│   │   └── app/
│   │       ├── build.gradle              # Android сборка
│   │       └── src/main/AndroidManifest.xml
│   ├── ios/                              # iOS конфигурация
│   │   └── Runner/
│   │       └── Info.plist
│   └── web/                              # Web конфигурация
│
└── 📚 Documentation
    ├── README.md                          # Основная документация
    ├── CHANGELOG.md                       # История изменений (v0.7.0)
    └── PROJECT_STRUCTURE.md              # Этот файл
🏗️ Architecture Overview
Services (Business Logic)

notification_service.dart ⚡ - Полностью переработан в v0.7.0

Сохранение событийных уведомлений при смене языка
Умное восстановление времени для ID после 16:40
Поддержка двойной схемы ID для обратной совместимости


alcohol_service.dart - Управление алкогольными напитками
weather_service.dart - Интеграция с OpenWeatherMap
hri_service.dart - Расчет индекса риска гидратации
subscription_service.dart - RevenueCat интеграция
locale_service.dart - Управление языками приложения

Models (Data Structures)

intake.dart - Базовая модель приема жидкости
alcohol_intake.dart - Расширенная модель для алкоголя
goals.dart - Дневные цели по воде и электролитам
quick_favorites.dart - Избранные напитки для быстрого доступа

Screens (UI)

home_screen.dart - Главный экран с кольцами прогресса
catalogs/ - 4 каталога напитков с цветовой кодировкой
history/ - 3 режима просмотра истории (день/неделя/месяц)
paywall_screen.dart - Экран покупки PRO подписки

Widgets (Reusable Components)

quick_add_widget.dart - Кнопки быстрого добавления
alcohol_card.dart - Отображение алкогольной статистики
daily_report.dart - Вечерний отчет о гидратации