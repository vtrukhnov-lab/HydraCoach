import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Результат расчета корректировок жары
class HeatAdjustments {
  final double waterAdjustment;
  final int sodiumAdjustment;
  
  HeatAdjustments(this.waterAdjustment, this.sodiumAdjustment);
}

class RemoteConfigService {
  static RemoteConfigService? _instance;
  static RemoteConfigService get instance => _instance ??= RemoteConfigService._();
  
  RemoteConfigService._();
  
  FirebaseRemoteConfig? _remoteConfig;
  bool _initialized = false;
  
  /// Инициализация Remote Config
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      // Настройки для разработки (частые обновления)
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode 
            ? const Duration(seconds: 10)  // Для разработки
            : const Duration(hours: 1),    // Для продакшна
        ),
      );
      
      // Значения по умолчанию (из ТЗ)
      await _remoteConfig!.setDefaults(_getDefaults());
      
      // Загружаем конфигурацию
      await _remoteConfig!.fetchAndActivate();
      
      _initialized = true;
      
      if (kDebugMode) {
        print('✅ Remote Config инициализирован');
        print('📊 Параметры загружены: ${_remoteConfig!.getAll().length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации Remote Config: $e');
      }
    }
  }
  
  /// Значения по умолчанию из ТЗ
  Map<String, dynamic> _getDefaults() {
    return {
      // 🔥 Коэффициенты формул воды (мл на кг веса)
      'water_min_per_kg': 22.0,
      'water_opt_per_kg': 30.0,
      'water_max_per_kg': 36.0,
      
      // ⚡ Электролиты базовые цели (мг в день)
      'sodium_normal': 2500,
      'sodium_keto': 3500,
      'potassium_normal': 3000,
      'potassium_keto': 3500,
      'magnesium_normal': 350,
      'magnesium_keto': 400,
      
      // 🌡️ Пороги Heat Index корректировок
      'heat_index_low': 27.0,     // HI < 27°C: без корректировок
      'heat_index_medium': 32.0,  // HI 27-32°C: +5% воды, +500мг натрия
      'heat_index_high': 39.0,    // HI 32-39°C: +8% воды, +1000мг натрия
      // HI > 39°C: +12% воды, +1500мг натрия
      
      'heat_water_adjustment_low': 0.05,    // 5%
      'heat_water_adjustment_medium': 0.08, // 8%  
      'heat_water_adjustment_high': 0.12,   // 12%
      
      'heat_sodium_adjustment_low': 500,    // мг
      'heat_sodium_adjustment_medium': 1000, // мг
      'heat_sodium_adjustment_high': 1500,   // мг
      
      // 📊 Пороги HRI и статусов гидратации
      'hydration_dehydration_threshold': 0.9,  // < 90% от цели воды
      'hydration_dilution_water_threshold': 1.15, // > 115% воды
      'hydration_dilution_sodium_threshold': 0.6, // < 60% натрия
      'hydration_low_salt_threshold': 0.5,     // < 50% натрия
      
      // 🔔 Настройки уведомлений
      'max_free_reminders': 4,            // FREE: до 4 напоминаний в день
      'coffee_reminder_delay_minutes': 45, // После кофе через 45 минут
      'reminder_spam_protection_hours': 1,  // Антиспам: 1 час между контекстными
      'reminder_daily_limit': 8,           // Максимум в день для PRO
      
      // ⏰ Тихие часы по умолчанию
      'quiet_hours_start': 22, // 22:00
      'quiet_hours_end': 7,    // 07:00
      
      // 🍽️ Режим Fasting Aware
      'fasting_aware_enabled': true,
      'fasting_electrolyte_reminder_enabled': true,
      'fasting_refeeding_ladder_enabled': true,
      
      // 💰 Настройки подписки и пейвола
      'paywall_show_trial': true,
      'trial_duration_days': 3,
      'paywall_title': 'Разблокируйте все возможности HydraCoach',
      'paywall_subtitle': 'Умные напоминания, недельные отчеты и синхронизация',
      
      // 🔧 Фич флаги для PRO функций
      'feature_smart_reminders': true,
      'feature_weekly_reports': true,
      'feature_csv_export': true,
      'feature_cloud_sync': true,
      'feature_contextual_reminders': true,
      'feature_heat_protocols': true,
      
      // 📊 SDK паблишера (Релиз 3)
      'publisher_sdk_enabled': false,
      'appsflyer_enabled': false,
      'sanctioned_countries': '["RU", "BY", "CN", "IR", "KP"]', // JSON строка
      
      // 🎯 A/B тестирование
      'ab_paywall_variant': 'default',
      'ab_onboarding_variant': 'standard',
    };
  }
  
  /// Получение значения с проверкой инициализации
  T _getValue<T>(String key, T defaultValue) {
    if (!_initialized || _remoteConfig == null) {
      return defaultValue;
    }
    
    try {
      if (T == String) {
        return _remoteConfig!.getString(key) as T;
      } else if (T == int) {
        return _remoteConfig!.getInt(key) as T;
      } else if (T == double) {
        return _remoteConfig!.getDouble(key) as T;
      } else if (T == bool) {
        return _remoteConfig!.getBool(key) as T;
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Ошибка получения параметра $key: $e');
      }
    }
    
    return defaultValue;
  }
  
  // 🔥 ФОРМУЛЫ ВОДЫ
  double get waterMinPerKg => _getValue('water_min_per_kg', 22.0);
  double get waterOptPerKg => _getValue('water_opt_per_kg', 30.0);
  double get waterMaxPerKg => _getValue('water_max_per_kg', 36.0);
  
  // ⚡ ЭЛЕКТРОЛИТЫ
  int get sodiumNormal => _getValue('sodium_normal', 2500);
  int get sodiumKeto => _getValue('sodium_keto', 3500);
  int get potassiumNormal => _getValue('potassium_normal', 3000);
  int get potassiumKeto => _getValue('potassium_keto', 3500);
  int get magnesiumNormal => _getValue('magnesium_normal', 350);
  int get magnesiumKeto => _getValue('magnesium_keto', 400);
  
  // 🌡️ HEAT INDEX ПОРОГИ
  double get heatIndexLow => _getValue('heat_index_low', 27.0);
  double get heatIndexMedium => _getValue('heat_index_medium', 32.0);
  double get heatIndexHigh => _getValue('heat_index_high', 39.0);
  
  double get heatWaterAdjustmentLow => _getValue('heat_water_adjustment_low', 0.05);
  double get heatWaterAdjustmentMedium => _getValue('heat_water_adjustment_medium', 0.08);
  double get heatWaterAdjustmentHigh => _getValue('heat_water_adjustment_high', 0.12);
  
  int get heatSodiumAdjustmentLow => _getValue('heat_sodium_adjustment_low', 500);
  int get heatSodiumAdjustmentMedium => _getValue('heat_sodium_adjustment_medium', 1000);
  int get heatSodiumAdjustmentHigh => _getValue('heat_sodium_adjustment_high', 1500);
  
  // 📊 ПОРОГИ СТАТУСОВ
  double get dehydrationThreshold => _getValue('hydration_dehydration_threshold', 0.9);
  double get dilutionWaterThreshold => _getValue('hydration_dilution_water_threshold', 1.15);
  double get dilutionSodiumThreshold => _getValue('hydration_dilution_sodium_threshold', 0.6);
  double get lowSaltThreshold => _getValue('hydration_low_salt_threshold', 0.5);
  
  // 🔔 УВЕДОМЛЕНИЯ
  int get maxFreeReminders => _getValue('max_free_reminders', 4);
  int get coffeeReminderDelayMinutes => _getValue('coffee_reminder_delay_minutes', 45);
  int get reminderSpamProtectionHours => _getValue('reminder_spam_protection_hours', 1);
  int get reminderDailyLimit => _getValue('reminder_daily_limit', 8);
  
  // ⏰ ТИХИЕ ЧАСЫ
  int get quietHoursStart => _getValue('quiet_hours_start', 22);
  int get quietHoursEnd => _getValue('quiet_hours_end', 7);
  
  // 🍽️ FASTING AWARE
  bool get fastingAwareEnabled => _getValue('fasting_aware_enabled', true);
  bool get fastingElectrolyteReminderEnabled => _getValue('fasting_electrolyte_reminder_enabled', true);
  bool get fastingRefeedingLadderEnabled => _getValue('fasting_refeeding_ladder_enabled', true);
  
  // 💰 ПОДПИСКА
  bool get paywallShowTrial => _getValue('paywall_show_trial', true);
  int get trialDurationDays => _getValue('trial_duration_days', 3);
  String get paywallTitle => _getValue('paywall_title', 'Разблокируйте все возможности HydraCoach');
  String get paywallSubtitle => _getValue('paywall_subtitle', 'Умные напоминания, недельные отчеты и синхронизация');
  
  // 🔧 ФИЧ ФЛАГИ
  bool get featureSmartReminders => _getValue('feature_smart_reminders', true);
  bool get featureWeeklyReports => _getValue('feature_weekly_reports', true);
  bool get featureCsvExport => _getValue('feature_csv_export', true);
  bool get featureCloudSync => _getValue('feature_cloud_sync', true);
  bool get featureContextualReminders => _getValue('feature_contextual_reminders', true);
  bool get featureHeatProtocols => _getValue('feature_heat_protocols', true);
  
  // 📊 SDK ПАБЛИШЕРА
  bool get publisherSdkEnabled => _getValue('publisher_sdk_enabled', false);
  bool get appsflyerEnabled => _getValue('appsflyer_enabled', false);
  
  List<String> get sanctionedCountries {
    try {
      final jsonString = _getValue('sanctioned_countries', '["RU", "BY", "CN", "IR", "KP"]');
      // В реальном приложении здесь должен быть парсинг JSON
      // Для простоты возвращаем статичный список
      return ['RU', 'BY', 'CN', 'IR', 'KP'];
    } catch (e) {
      return ['RU', 'BY', 'CN', 'IR', 'KP'];
    }
  }
  
  // 🎯 A/B ТЕСТИРОВАНИЕ
  String get abPaywallVariant => _getValue('ab_paywall_variant', 'default');
  String get abOnboardingVariant => _getValue('ab_onboarding_variant', 'standard');
  
  /// Принудительное обновление конфигурации
  Future<bool> forceRefresh() async {
    if (!_initialized || _remoteConfig == null) {
      return false;
    }
    
    try {
      await _remoteConfig!.fetchAndActivate();
      
      if (kDebugMode) {
        print('🔄 Remote Config обновлен принудительно');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка принудительного обновления: $e');
      }
      return false;
    }
  }
  
  /// Получение всех параметров (для отладки)
  Map<String, RemoteConfigValue> getAllParameters() {
    if (!_initialized || _remoteConfig == null) {
      return {};
    }
    
    return _remoteConfig!.getAll();
  }
  
  /// Расчет корректировки воды по Heat Index
  HeatAdjustments calculateHeatAdjustments(double heatIndex) {
    if (heatIndex < heatIndexLow) {
      return HeatAdjustments(0.0, 0); // Нет корректировок
    } else if (heatIndex < heatIndexMedium) {
      return HeatAdjustments(heatWaterAdjustmentLow, heatSodiumAdjustmentLow);
    } else if (heatIndex < heatIndexHigh) {
      return HeatAdjustments(heatWaterAdjustmentMedium, heatSodiumAdjustmentMedium);
    } else {
      return HeatAdjustments(heatWaterAdjustmentHigh, heatSodiumAdjustmentHigh);
    }
  }
}