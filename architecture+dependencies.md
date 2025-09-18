HydraCoach Project Structure
📁 Project Tree
hydracoach/
├── 📱 lib/
│   ├── main.dart                              # Точка входа приложения
│   ├── firebase_options.dart                  # Конфигурация Firebase
│   │
│   ├── 🌍 l10n/                              # Локализация
│   │   ├── app_localizations.dart             # Базовый класс локализации
│   │   ├── app_localizations_en.dart          # Английский перевод
│   │   ├── app_localizations_es.dart          # Испанский перевод
│   │   ├── app_localizations_ru.dart          # Русский перевод
│   │   ├── app_en.arb                        # Английские строки
│   │   ├── app_es.arb                        # Испанские строки
│   │   └── app_ru.arb                        # Русские строки
│   │
│   ├── 📊 data/                              # Данные и каталоги
│   │   ├── catalog_item.dart                 # Базовая модель элемента каталога
│   │   ├── items_catalog.dart                # Главный каталог всех напитков
│   │   └── items/                            # Предустановленные элементы
│   │       ├── alcohol_items.dart            # Алкогольные напитки
│   │       ├── electrolyte_items.dart        # Электролиты
│   │       ├── hot_drink_items.dart          # Горячие напитки
│   │       ├── sport_items.dart              # Спортивные напитки
│   │       ├── supplement_items.dart         # Добавки и БАДы
│   │       └── water_items.dart              # Вода и базовые жидкости
│   │
│   ├── 📦 models/                            # Модели данных
│   │   ├── achievement.dart                  # Модель достижений
│   │   ├── alcohol_intake.dart               # Модель алкогольного напитка
│   │   ├── daily_goals.dart                  # Дневные цели
│   │   ├── intake.dart                       # Базовая модель приема жидкости
│   │   └── quick_favorites.dart              # Избранные напитки
│   │
│   ├── 🎨 screens/                           # Экраны приложения
│   │   ├── main_shell.dart                   # Главная оболочка с навигацией
│   │   ├── home_screen.dart                  # Главный экран
│   │   ├── achievements_screen.dart          # Экран достижений
│   │   ├── history_screen.dart               # История (контейнер)
│   │   ├── settings_screen.dart              # Настройки
│   │   ├── notification_settings_screen.dart # Настройки уведомлений
│   │   ├── paywall_screen.dart               # Экран подписки PRO
│   │   │
│   │   ├── 📚 Каталоги напитков/
│   │   ├── alcohol_log_screen.dart           # Алкоголь (красный)
│   │   ├── liquids_catalog_screen.dart       # Жидкости (синий)
│   │   ├── hot_drinks_screen.dart            # Горячие напитки (коричневый)
│   │   ├── supplements_screen.dart           # Добавки (фиолетовый)
│   │   ├── electrolytes_screen.dart          # Электролиты (зеленый)
│   │   └── sports_screen.dart                # Спортивные напитки (оранжевый)
│   │   │
│   │   ├── 📊 history/                       # Подэкраны истории
│   │   │   ├── daily_history_screen.dart     # Дневная история
│   │   │   ├── weekly_history_screen.dart    # Недельная история
│   │   │   └── monthly_history_screen.dart   # Месячная история
│   │   │
│   │   ├── 🚀 onboarding/                    # Онбординг
│   │   │   ├── onboarding_screen.dart        # Главный экран онбординга
│   │   │   ├── pages/                        # Страницы онбординга
│   │   │   │   ├── welcome_page.dart         # Приветствие
│   │   │   │   ├── weight_page.dart          # Ввод веса
│   │   │   │   ├── units_page.dart           # Выбор системы измерений
│   │   │   │   ├── diet_page.dart            # Диета и образ жизни
│   │   │   │   ├── location_examples_page.dart      # Примеры геолокации
│   │   │   │   ├── notification_examples_page.dart  # Примеры уведомлений
│   │   │   │   └── complete_page.dart        # Завершение онбординга
│   │   │   └── widgets/
│   │   │       └── first_intake_tutorial.dart # Туториал первого добавления
│   │
│   ├── ⚙️ services/                          # Сервисы и бизнес-логика
│   │   ├── achievement_service.dart          # Управление достижениями
│   │   ├── achievement_tracker.dart          # Отслеживание прогресса достижений
│   │   ├── alcohol_service.dart              # Логика работы с алкоголем
│   │   ├── analytics_service.dart            # Аналитика Firebase
│   │   ├── feature_gate_service.dart         # Управление PRO функциями
│   │   ├── history_service.dart              # Работа с историей
│   │   ├── hri_service.dart                  # Расчет HRI индекса
│   │   ├── locale_service.dart               # Управление языками
│   │   ├── notification_service.dart         # Главный сервис уведомлений
│   │   ├── notification_texts.dart           # Тексты уведомлений
│   │   ├── remote_config_service.dart        # Remote Config Firebase
│   │   ├── subscription_service.dart         # RevenueCat подписки
│   │   ├── units_service.dart                # Конвертация единиц измерения
│   │   ├── water_progress_cache.dart         # Кеширование прогресса
│   │   ├── weather_service.dart              # Интеграция с погодой
│   │   │
│   │   └── 🔔 notifications/                 # Модульная система уведомлений
│   │       ├── fcm_handler.dart              # Обработка FCM
│   │       ├── notification_config.dart      # Конфигурация уведомлений
│   │       ├── notification_initializer.dart # Инициализация
│   │       ├── notification_manager.dart     # Менеджер уведомлений
│   │       ├── notification_scheduler.dart   # Планировщик
│   │       ├── notification_sender.dart      # Отправка уведомлений
│   │       ├── notification_types.dart       # Типы уведомлений
│   │       ├── specific_notifications.dart   # Специфичные уведомления
│   │       └── helpers/                      # Вспомогательные утилиты
│   │           ├── notification_limits_helper.dart  # Лимиты уведомлений
│   │           ├── schedule_window_helper.dart      # Временные окна
│   │           └── timezone_helper.dart             # Работа с часовыми поясами
│   │
│   ├── 📦 providers/                         # Провайдеры состояния
│   │   └── hydration_provider.dart           # Главный провайдер гидратации
│   │
│   ├── 🗄️ repositories/                      # Репозитории данных
│   │   └── achievements_repository.dart      # Репозиторий достижений
│   │
│   └── 🧩 widgets/                           # Переиспользуемые виджеты
│       ├── achievement_card.dart             # Карточка достижения
│       ├── achievement_overlay.dart          # Оверлей получения достижения
│       ├── achievement_stats_card.dart       # Статистика достижений
│       ├── alcohol_card.dart                 # Карточка алкоголя
│       ├── alcohol_checkin_dialog.dart       # Диалог утреннего чек-ина
│       ├── daily_report.dart                 # Вечерний отчет
│       ├── ion_character.dart                # Персонаж-ион
│       ├── notification_debug_panel.dart     # Панель отладки уведомлений
│       ├── pro_badge.dart                    # Бейдж PRO версии
│       ├── pro_feature_gate.dart             # Гейт для PRO функций
│       ├── quick_add_widget.dart             # Быстрое добавление
│       ├── weather_card.dart                 # Карточка погоды (дубликат?)
│       │
│       ├── 🎯 common/                        # Общие виджеты
│       │   ├── favorite_slot_selector.dart   # Выбор слота избранного
│       │   ├── items_grid.dart               # Сетка элементов каталога
│       │   ├── status_cards.dart             # Статусные карточки
│       │   ├── type_selector.dart            # Выбор типа напитка
│       │   ├── volume_selection_dialog.dart  # Диалог выбора объема
│       │   └── water_ring_widget.dart        # Кольцо прогресса воды
│       │
│       └── 🏠 home/                          # Виджеты главного экрана
│           ├── compact_electrolyte_display.dart  # Компактный вид электролитов
│           ├── electrolytes_card.dart           # Карточка электролитов
│           ├── electrolyte_bar_display.dart     # Полоски электролитов
│           ├── favorite_beverages_bar.dart      # Панель избранных напитков
│           ├── home_header.dart                 # Заголовок главного экрана
│           ├── hri_status_card.dart            # Карточка HRI статуса
│           ├── main_progress_card.dart         # Главная карточка прогресса
│           ├── smart_advice_card.dart          # Умные советы
│           ├── sugar_intake_card.dart          # Карточка потребления сахара
│           ├── today_history_section.dart      # Секция сегодняшней истории
│           └── weather_card.dart               # Карточка погоды
│
├── 🎨 assets/                                # Ресурсы
│   ├── images/                               # Изображения
│   ├── notifications/                        # JSON файлы уведомлений
│   └── l10n/                                 # ARB файлы локализации
│
└── 📋 Configuration Files
    ├── pubspec.yaml                          # Зависимости проекта
    ├── l10n.yaml                             # Конфигурация локализации
    └── analysis_options.yaml                # Правила линтера
🏗️ Architecture Overview
Core Services (Бизнес-логика)
Система уведомлений (Модульная архитектура)

notification_service.dart - Главный сервис координации
notifications/ - Модульная подсистема:

Планировщик, отправитель, менеджер
FCM интеграция
Хелперы для временных окон и лимитов



Достижения и геймификация

achievement_service.dart - Управление достижениями
achievement_tracker.dart - Отслеживание прогресса
achievements_repository.dart - Хранение данных достижений

Основные сервисы

hydration_provider.dart - Центральный провайдер состояния
history_service.dart - Работа с историей приемов
units_service.dart - Конвертация метрических/имперских единиц
water_progress_cache.dart - Оптимизация производительности

Data Layer (Слой данных)
Каталоги напитков

data/items/ - 6 категорий предустановленных напитков
catalog_item.dart - Базовая модель элемента
items_catalog.dart - Централизованный доступ к каталогам

Модели данных

intake.dart - Базовая модель приема
alcohol_intake.dart - Расширенная модель для алкоголя
achievement.dart - Модель достижения
daily_goals.dart - Цели на день

UI Layer (Интерфейс)
Экраны

main_shell.dart - Навигационная оболочка
6 каталогов напитков с цветовой кодировкой
3 режима истории - день/неделя/месяц
Онбординг - 7 шагов настройки

Виджеты

common/ - Переиспользуемые компоненты
home/ - Компоненты главного экрана (11 виджетов)
Специализированные виджеты (достижения, PRO, отладка)

🔄 Основные изменения в структуре
✅ Добавлено:

📊 data/ - Новая структура для каталогов и предустановленных элементов
🏆 Система достижений - Полный стек от сервиса до UI
🔔 Модульные уведомления - Разделение на подмодули в notifications/
🎯 6 типов каталогов - Вместо 4 (добавлены спорт и электролиты)
🏠 home/ виджеты - 11 специализированных компонентов
📱 main_shell.dart - Новая навигационная оболочка