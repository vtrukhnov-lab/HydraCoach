// lib/services/notification_texts.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to load localized notification texts from assets JSON files.
/// Files live under: assets/notifications/{en|ru|es}.json
class NotificationTexts {
  static String _locale = 'en';
  static Map<String, dynamic> _current = {};
  static final Map<String, Map<String, dynamic>> _cache = {};
  static bool _ready = false;

  /// Initialize once on app start.
  static Future<void> initialize() async {
    print('[NotificationTexts] Initializing...');
    await loadLocale();                // reads 'locale' key
    print('[NotificationTexts] Loaded locale: $_locale');
    await _loadFor(_locale);
    _ready = true;
    print('[NotificationTexts] Initialization complete. Ready: $_ready');
    print('[NotificationTexts] Current texts loaded: ${_current.keys.length} keys');
  }

  /// Ensure texts are loaded (can be called multiple times safely)
  static Future<void> ensureLoaded() async {
    if (!_ready) {
      print('[NotificationTexts] Not ready, initializing...');
      await initialize();
    }
  }

  /// Read current locale from SharedPreferences ('locale' key).
  static Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    // Try multiple keys for compatibility
    String? savedLocale = prefs.getString('locale');
    if (savedLocale == null) {
      savedLocale = prefs.getString('app_locale');
    }
    _locale = savedLocale ?? 'en';
    print('[NotificationTexts] loadLocale: found "$_locale" in SharedPreferences');
  }

  /// Set locale and reload texts. Also writes 'locale' for persistence.
  static Future<void> setLocale(String locale) async {
    print('[NotificationTexts] setLocale called with: $locale');
    final prefs = await SharedPreferences.getInstance();
    // Save to both keys for compatibility
    await prefs.setString('locale', locale);
    await prefs.setString('app_locale', locale);
    _locale = locale;
    await _loadFor(locale);
    _ready = true;
    print('[NotificationTexts] Locale set to: $_locale, texts reloaded');
  }

  /// Current language code (e.g., 'en', 'ru', 'es').
  static String get currentLocale => _locale;
  static String get langCode => _locale; // alias for compatibility

  /// Fetch string by key with optional {placeholders}.
  static String get(String key, {Map<String, dynamic>? params}) {
    if (!_ready) {
      print('[NotificationTexts] WARNING: Not ready, returning key: $key');
      return key;
    }
    
    // Try to get from current texts, then from defaults
    String text = _current[key]?.toString() ?? 
                  _defaults()[key]?.toString() ?? 
                  key;
    
    if (text == key) {
      print('[NotificationTexts] WARNING: Key not found: $key, locale: $_locale');
    }
    
    // Debug logging for alcohol-related keys
    if (key.contains('alcohol')) {
      print('[NotificationTexts] Processing key: $key');
      print('[NotificationTexts] Original text: $text');
      print('[NotificationTexts] Params: $params');
    }
    
    // Replace placeholders
    if (params != null) {
      params.forEach((k, v) {
        final placeholder = '{$k}';
        if (text.contains(placeholder)) {
          print('[NotificationTexts] Replacing $placeholder with $v');
          text = text.replaceAll(placeholder, v.toString());
        }
      });
    }
    
    // Debug final result for alcohol keys
    if (key.contains('alcohol')) {
      print('[NotificationTexts] Final text: $text');
    }
    
    return text;
  }

  // ======= Convenience getters for commonly used strings =======

  static String get channelNameDefault => get('channel_name_default');
  static String get channelDescDefault => get('channel_desc_default');
  static String get channelNameUrgent => get('channel_name_urgent');
  static String get channelDescUrgent => get('channel_desc_urgent');
  static String get channelNameReport => get('channel_name_report');
  static String get channelDescReport => get('channel_desc_report');
  static String get channelNameSilent => get('channel_name_silent');
  static String get channelDescSilent => get('channel_desc_silent');

  static String get waterReminderTitle => get('water_reminder_title');
  static String waterReminderBody(int hour, double progress) =>
      get('water_reminder_body', params: {
        'progress': progress.toInt(),
      });

  static String get postCoffeeTitle => get('post_coffee_title');
  static String get postCoffeeBody => get('post_coffee_body');

  static String get alcoholCounterTitle => get('alcohol_counter_title');
  static String alcoholCounterBody(int amount) {
    print('[NotificationTexts] alcoholCounterBody called with amount: $amount');
    final result = get('alcohol_counter_body', params: {'amount': amount});
    print('[NotificationTexts] alcoholCounterBody result: $result');
    return result;
  }

  static String alcoholRecoveryStepTitle(int hour) =>
      get('alcohol_recovery_step_title', params: {'hour': hour});
  
  // ИСПРАВЛЕНО: Используем 'amount' вместо 'ml' чтобы соответствовать JSON
  static String alcoholRecoveryStepBody(int amount, bool withElectrolytes) {
    print('[NotificationTexts] alcoholRecoveryStepBody called with amount: $amount, electrolytes: $withElectrolytes');
    final result = get(withElectrolytes
        ? 'alcohol_recovery_step_body_with_electrolytes'
        : 'alcohol_recovery_step_body', params: {'amount': amount});
    print('[NotificationTexts] alcoholRecoveryStepBody result: $result');
    return result;
  }

  static String get morningCheckInTitle => get('morning_checkin_title');
  static String get morningCheckInBody => get('morning_checkin_body');

  static String get heatWarningTitle => get('heat_warning_title');
  static String heatWarningBody(double hi) {
    if (hi > 40) {
      return get('heat_warning_extreme');
    } else if (hi > 32) {
      return get('heat_warning_hot');
    } else {
      return get('heat_warning_warm');
    }
  }

  static String get postWorkoutTitle => get('post_workout_title');
  static String get postWorkoutBody => get('post_workout_body');

  static String get fastingElectrolyteTitle => get('fasting_electrolyte_title');
  static String get fastingElectrolyteBody => get('fasting_electrolyte_body');

  static String get dailyReportTitle => get('daily_report_title');
  static String get dailyReportBody => get('daily_report_body');

  static String get testTitle => get('test_notification_title');
  static String get testBody => get('test_notification_body');
  static String get testScheduledTitle => get('test_scheduled_title');
  static String get testScheduledBody => get('test_scheduled_body');

  // ======= Internal: load & cache =======

  static Future<void> _loadFor(String locale) async {
    print('[NotificationTexts] Loading texts for locale: $locale');
    
    // Check cache first
    if (_cache.containsKey(locale)) {
      _current = _cache[locale]!;
      print('[NotificationTexts] Loaded from cache: ${_current.keys.length} keys');
      return;
    }
    
    try {
      final assetPath = 'assets/notifications/$locale.json';
      print('[NotificationTexts] Loading from: $assetPath');
      
      final jsonStr = await rootBundle.loadString(assetPath);
      print('[NotificationTexts] JSON loaded, length: ${jsonStr.length}');
      
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      print('[NotificationTexts] JSON parsed, keys: ${data.keys.length}');
      
      _cache[locale] = data;
      _current = data;
      
      // Log a sample of loaded texts for verification
      print('[NotificationTexts] Sample loaded texts:');
      print('  - post_coffee_title: ${data['post_coffee_title']}');
      print('  - post_coffee_body: ${data['post_coffee_body']}');
      print('  - alcohol_counter_body: ${data['alcohol_counter_body']}');
      print('  - alcohol_recovery_step_body: ${data['alcohol_recovery_step_body']}');
      
    } catch (e) {
      print('[NotificationTexts] ERROR loading $locale: $e');
      
      // Fallback to English if not already trying English
      if (locale != 'en') {
        print('[NotificationTexts] Falling back to English...');
        await _loadFor('en');
      } else {
        // Last resort: use hardcoded defaults
        print('[NotificationTexts] Using hardcoded defaults');
        _current = _defaults();
      }
    }
  }

  /// Minimal fallback strings if assets are missing.
  static Map<String, dynamic> _defaults() => {
        'channel_name_default': 'Hydration reminders',
        'channel_desc_default': 'Reminders about water and electrolytes',
        'channel_name_urgent': 'Important alerts',
        'channel_desc_urgent': 'Heat and critical alerts',
        'channel_name_report': 'Reports',
        'channel_desc_report': 'Daily and weekly summaries',
        'channel_name_silent': 'Silent notifications',
        'channel_desc_silent': 'No sound or vibration during quiet hours',

        'water_reminder_title': 'Time to hydrate',
        'water_reminder_body': 'You have {progress}% of your goal. Keep going!',

        'post_coffee_title': 'After coffee',
        'post_coffee_body': 'Drink 250-300 ml water to restore balance',

        'alcohol_counter_title': 'Recovery time',
        'alcohol_counter_body': 'Drink {amount} ml of water with a pinch of salt',

        'alcohol_recovery_step_title': 'Recovery {hour}h',
        'alcohol_recovery_step_body': 'Drink {amount} ml of water',
        'alcohol_recovery_step_body_with_electrolytes':
            'Drink {amount} ml of water + electrolytes',

        'morning_checkin_title': 'Morning check-in',
        'morning_checkin_body': 'How do you feel today?',

        'heat_warning_title': 'Heat alert',
        'heat_warning_extreme': 'Extreme heat! +15% water and +1g salt',
        'heat_warning_hot': 'Hot! +10% water and electrolytes',
        'heat_warning_warm': 'Warm. Watch your hydration',

        'post_workout_title': 'After workout',
        'post_workout_body': '500 ml water + electrolytes',

        'fasting_electrolyte_title': 'Electrolyte time',
        'fasting_electrolyte_body': 'Add a pinch of salt or drink broth',

        'daily_report_title': 'Your daily report is ready',
        'daily_report_body': 'See how your hydration went today',

        'test_notification_title': 'Test notification',
        'test_notification_body': 'If you see this, notifications work!',
        'test_scheduled_title': 'Scheduled test',
        'test_scheduled_body': 'This notification was scheduled a minute ago',
      };
}