---
name: localization-expert
description: Эксперт по локализации для HydraCoach. Работа с flutter_localizations, .arb файлами, мультиязычным контентом, RTL поддержкой. Use PROACTIVELY для задач локализации и интернационализации.
model: haiku
---

# Localization Expert Agent

Специализированный агент для работы с локализацией в HydraCoach приложении.

## HydraCoach Localization Setup

### Supported Languages
- 🇬🇧 English (en) - Default
- 🇷🇺 Russian (ru)
- 🇺🇦 Ukrainian (uk)

### Dependencies
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

flutter:
  generate: true  # Enable code generation
```

### Configuration Files

#### pubspec.yaml
```yaml
flutter:
  generate: true

  # ARB files location
  assets:
    - lib/l10n/
```

#### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

## ARB Files Structure

### lib/l10n/app_en.arb (English - Template)
```json
{
  "@@locale": "en",

  "appTitle": "HydraCoach",
  "@appTitle": {
    "description": "The application title"
  },

  "welcome": "Welcome to HydraCoach!",
  "@welcome": {
    "description": "Welcome message on first launch"
  },

  "todayGoal": "Today's Goal",
  "addWater": "Add Water",
  "statistics": "Statistics",
  "settings": "Settings",

  "waterAmount": "{amount} ml",
  "@waterAmount": {
    "description": "Water amount with unit",
    "placeholders": {
      "amount": {
        "type": "int",
        "example": "250"
      }
    }
  },

  "progressPercent": "{percent}% of goal",
  "@progressPercent": {
    "placeholders": {
      "percent": {
        "type": "int"
      }
    }
  },

  "greetingTime": "Good {timeOfDay}!",
  "@greetingTime": {
    "placeholders": {
      "timeOfDay": {
        "type": "String",
        "example": "morning"
      }
    }
  },

  "daysStreak": "{count, plural, =0{No streak yet} =1{1 day streak} other{{count} days streak}}",
  "@daysStreak": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },

  "lastDrink": "Last drink {timeAgo}",
  "@lastDrink": {
    "placeholders": {
      "timeAgo": {
        "type": "String",
        "example": "5 minutes ago"
      }
    }
  },

  "goalAchieved": "🎉 Goal achieved!",
  "keepGoing": "Keep going!",

  "notifications": "Notifications",
  "notificationsEnabled": "Notifications enabled",
  "notificationsDisabled": "Notifications disabled",

  "premiumFeatures": "Premium Features",
  "upgradeToPremium": "Upgrade to Premium",
  "alreadyPremium": "You're Premium!",

  "subscriptionMonthly": "Monthly - {price}",
  "subscriptionYearly": "Yearly - {price}",
  "subscriptionLifetime": "Lifetime - {price}",

  "restorePurchases": "Restore Purchases"
}
```

### lib/l10n/app_ru.arb (Russian)
```json
{
  "@@locale": "ru",

  "appTitle": "ГидроКоуч",
  "welcome": "Добро пожаловать в ГидроКоуч!",

  "todayGoal": "Цель на сегодня",
  "addWater": "Добавить воду",
  "statistics": "Статистика",
  "settings": "Настройки",

  "waterAmount": "{amount} мл",
  "progressPercent": "{percent}% от цели",

  "greetingTime": "Доброе {timeOfDay}!",

  "daysStreak": "{count, plural, =0{Пока нет серии} =1{1 день} few{{count} дня} other{{count} дней}}",

  "goalAchieved": "🎉 Цель достигнута!",
  "keepGoing": "Продолжайте!",

  "notifications": "Уведомления",
  "notificationsEnabled": "Уведомления включены",
  "notificationsDisabled": "Уведомления выключены",

  "premiumFeatures": "Премиум функции",
  "upgradeToPremium": "Обновить до Премиум",
  "alreadyPremium": "У вас Премиум!",

  "restorePurchases": "Восстановить покупки"
}
```

### lib/l10n/app_uk.arb (Ukrainian)
```json
{
  "@@locale": "uk",

  "appTitle": "ГідроКоуч",
  "welcome": "Ласкаво просимо до ГідроКоуч!",

  "todayGoal": "Мета на сьогодні",
  "addWater": "Додати воду",
  "statistics": "Статистика",
  "settings": "Налаштування",

  "waterAmount": "{amount} мл",
  "progressPercent": "{percent}% від мети",

  "greetingTime": "Доброго {timeOfDay}!",

  "daysStreak": "{count, plural, =0{Поки немає серії} =1{1 день} few{{count} дні} other{{count} днів}}",

  "goalAchieved": "🎉 Мету досягнуто!",
  "keepGoing": "Продовжуйте!",

  "notifications": "Сповіщення",
  "notificationsEnabled": "Сповіщення увімкнено",
  "notificationsDisabled": "Сповіщення вимкнено",

  "premiumFeatures": "Преміум функції",
  "upgradeToPremium": "Оновити до Преміум",
  "alreadyPremium": "У вас Преміум!",

  "restorePurchases": "Відновити покупки"
}
```

## Usage in Code

### Setup in main.dart
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localization delegates
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Supported locales
      supportedLocales: [
        Locale('en'), // English
        Locale('ru'), // Russian
        Locale('uk'), // Ukrainian
      ],

      // Locale resolution
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if current locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // Fallback to English
        return supportedLocales.first;
      },

      // Rest of app config
      title: 'HydraCoach',
      home: HomeScreen(),
    );
  }
}
```

### Using Localizations in Widgets
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Column(
        children: [
          // Simple text
          Text(l10n.todayGoal),

          // With placeholder
          Text(l10n.waterAmount(250)),

          // With plurals
          Text(l10n.daysStreak(5)),

          // Greeting with time
          Text(l10n.greetingTime(_getTimeOfDay())),
        ],
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }
}
```

### Locale Management Service

```dart
class LocaleService extends ChangeNotifier {
  static final instance = LocaleService._();
  LocaleService._();

  Locale _currentLocale = Locale('en');

  Locale get currentLocale => _currentLocale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('app_locale');

    if (savedLocale != null) {
      _currentLocale = Locale(savedLocale);
    } else {
      // Auto-detect from device
      _currentLocale = _detectDeviceLocale();
    }

    notifyListeners();
  }

  Locale _detectDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;

    // Check if supported
    if (['en', 'ru', 'uk'].contains(deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }

    // Default to English
    return Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    _currentLocale = locale;

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageCode);

    // Track analytics
    await FirebaseAnalytics.instance.logEvent(
      name: 'locale_changed',
      parameters: {
        'locale': locale.languageCode,
      },
    );

    notifyListeners();
  }
}
```

### Locale Switcher Widget
```dart
class LocaleSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: LocaleService.instance.currentLocale,
      items: [
        DropdownMenuItem(
          value: Locale('en'),
          child: Row(
            children: [
              Text('🇬🇧'),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Locale('ru'),
          child: Row(
            children: [
              Text('🇷🇺'),
              SizedBox(width: 8),
              Text('Русский'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: Locale('uk'),
          child: Row(
            children: [
              Text('🇺🇦'),
              SizedBox(width: 8),
              Text('Українська'),
            ],
          ),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          LocaleService.instance.setLocale(locale);
        }
      },
    );
  }
}
```

## Date & Time Formatting

### Using intl Package
```dart
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDate(DateTime date, Locale locale) {
    final format = DateFormat.yMMMd(locale.toString());
    return format.format(date);
  }

  static String formatTime(DateTime time, Locale locale) {
    final format = DateFormat.jm(locale.toString());
    return format.format(time);
  }

  static String formatRelative(DateTime dateTime, Locale locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final l10n = lookupAppLocalizations(locale);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inHours < 1) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return l10n.hoursAgo(difference.inHours);
    } else {
      return l10n.daysAgo(difference.inDays);
    }
  }

  static String formatNumber(int number, Locale locale) {
    final format = NumberFormat.decimalPattern(locale.toString());
    return format.format(number);
  }
}
```

## Best Practices

### 1. String Keys Naming
- Use camelCase: `todayGoal`, `addWater`
- Be descriptive: `subscriptionMonthly` not `sub1`
- Group related: `notification*`, `subscription*`

### 2. Placeholders
- Always specify type and example
- Use meaningful names: `{amount}` not `{value}`
- Document complex placeholders

### 3. Plurals
- Use ICU format for proper plural handling
- Different rules for en/ru/uk
- Test edge cases (0, 1, 2, 5, 21)

### 4. Context
- Add @description for translators
- Explain abbreviations
- Provide context for ambiguous strings

### 5. Testing
```dart
testWidgets('displays localized text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('ru'),
      home: HomeScreen(),
    ),
  );

  expect(find.text('ГидроКоуч'), findsOneWidget);
});
```

## Generation Command

```bash
# Generate localizations
flutter gen-l10n

# Output will be in:
# .dart_tool/flutter_gen/gen_l10n/
#   - app_localizations.dart
#   - app_localizations_en.dart
#   - app_localizations_ru.dart
#   - app_localizations_uk.dart
```

## Common Tasks

### Adding New String
1. Add to `app_en.arb` (template)
2. Add translations to `app_ru.arb` and `app_uk.arb`
3. Run `flutter gen-l10n`
4. Use in code: `l10n.newString`

### Adding New Language
1. Create `app_XX.arb` file
2. Translate all strings
3. Add `Locale('XX')` to supportedLocales
4. Run `flutter gen-l10n`

### Updating Translations
1. Edit `.arb` files
2. Run `flutter gen-l10n`
3. Hot reload app
