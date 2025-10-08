// lib/services/locale_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/utils/app_logger.dart';

import 'notification_texts.dart';
import 'notification_service.dart';

class LocaleService extends ChangeNotifier {
  // Singleton
  static final LocaleService _instance = LocaleService._internal();
  static LocaleService get instance => _instance;
  LocaleService._internal();

  static const List<LocaleInfo> supportedLocales = [
    LocaleInfo('en', 'English', '🇬🇧'),
    LocaleInfo('es', 'Español', '🇪🇸'),
    LocaleInfo('ru', 'Русский', '🇷🇺'),
    LocaleInfo('de', 'Deutsch', '🇩🇪'),
    LocaleInfo('ja', '日本語', '🇯🇵'),
    LocaleInfo('ko', '한국어', '🇰🇷'),
    LocaleInfo('zh', '简体中文', '🇨🇳'),
    LocaleInfo('zh_TW', '繁體中文', '🇹🇼'),
    LocaleInfo('nl', 'Nederlands', '🇳🇱'),
    LocaleInfo('pt', 'Português', '🇵🇹'),
  ];

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  String get currentCode => _getFullLocaleCode(_currentLocale);

  /// Helper method to parse locale code like 'zh_TW' into Locale('zh', 'TW')
  static Locale _parseLocaleCode(String code) {
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale(parts[0], parts[1]);
    }
    return Locale(code);
  }

  /// Helper method to get full locale code like 'zh_TW' from Locale
  static String _getFullLocaleCode(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  /// Check if system locale matches any of our supported locales
  static String? _findMatchingLocaleCode(Locale systemLocale) {
    // First try exact match with country code (e.g., zh_TW)
    final fullCode = _getFullLocaleCode(systemLocale);
    if (supportedLocales.any((l) => l.code == fullCode)) {
      return fullCode;
    }

    // Then try language code only (e.g., zh)
    if (supportedLocales.any((l) => l.code == systemLocale.languageCode)) {
      return systemLocale.languageCode;
    }

    return null;
  }

  List<Locale> get flutterSupportedLocales =>
      supportedLocales.map((e) => _parseLocaleCode(e.code)).toList();

  Future<void> initialize() async {
    if (kDebugMode) {
      logger.d('[LocaleService] Initializing...');
    }

    final prefs = await SharedPreferences.getInstance();

    // Try to load saved locale
    final saved = prefs.getString('locale');

    if (saved != null && supportedLocales.any((l) => l.code == saved)) {
      _currentLocale = _parseLocaleCode(saved);
      if (kDebugMode) {
        logger.d('[LocaleService] Loaded saved locale: $saved');
      }
    } else {
      // Try to detect system locale
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final matchingCode = _findMatchingLocaleCode(systemLocale);

      if (matchingCode != null) {
        _currentLocale = _parseLocaleCode(matchingCode);
        if (kDebugMode) {
          logger.d(
            '[LocaleService] Detected system locale: ${systemLocale.toLanguageTag()} → matched to $matchingCode',
          );
        }
      } else {
        _currentLocale = const Locale('en');
        if (kDebugMode) {
          logger.d(
            '[LocaleService] System locale ${systemLocale.toLanguageTag()} not supported, using English',
          );
        }
      }

      final codeToSave = _getFullLocaleCode(_currentLocale);
      await prefs.setString('locale', codeToSave);
      if (kDebugMode) {
        logger.d('[LocaleService] Set initial locale: $codeToSave');
      }
    }

    // Load notification texts for current locale
    final localeCodeForNotifications = _getFullLocaleCode(_currentLocale);
    await NotificationTexts.setLocale(localeCodeForNotifications);
    if (kDebugMode) {
      logger.d(
        '[LocaleService] NotificationTexts initialized with: $localeCodeForNotifications',
      );
    }

    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    if (!supportedLocales.any((l) => l.code == code)) return;

    final currentCode = _getFullLocaleCode(_currentLocale);
    if (currentCode == code) return;

    final oldLocale = currentCode;
    _currentLocale = _parseLocaleCode(code);

    if (kDebugMode) {
      logger.d('[LocaleService] Changing locale from $oldLocale to $code');
    }

    final prefs = await SharedPreferences.getInstance();
    // Save to both keys for compatibility
    await prefs.setString('locale', code);
    await prefs.setString('app_locale', code);

    // Update notification texts and reschedule locale-dependent notifications
    await NotificationTexts.setLocale(code);
    if (kDebugMode) {
      logger.d('[LocaleService] ✅ NotificationTexts updated to $code');
    }

    try {
      await NotificationService().onLocaleChanged(code);
      if (kDebugMode) {
        logger.d(
          '[LocaleService] ✅ NotificationService.onLocaleChanged($code) completed',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        logger.d('[LocaleService] ❌ Error updating notifications: $e');
      }
    }

    notifyListeners();
    if (kDebugMode) {
      logger.d(
        '[LocaleService] ✅ Language change complete: $oldLocale → $code',
      );
    }
  }

  LocaleInfo getCurrentLocaleInfo() {
    return supportedLocales.firstWhere(
      (locale) => locale.code == _currentLocale.languageCode,
      orElse: () => supportedLocales.first,
    );
  }

  String getLocaleName(String code) {
    final info = supportedLocales.firstWhere(
      (locale) => locale.code == code,
      orElse: () => supportedLocales.first,
    );
    return info.name;
  }

  String getLocaleFlag(String code) {
    final info = supportedLocales.firstWhere(
      (locale) => locale.code == code,
      orElse: () => supportedLocales.first,
    );
    return info.flag;
  }

  bool isSupported(String code) {
    return supportedLocales.any((locale) => locale.code == code);
  }

  // Static method to read locale directly from SharedPreferences
  // (useful for background processes)
  static Future<String> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale') ?? 'en';
  }
}

class LocaleInfo {
  final String code;
  final String name;
  final String flag;
  const LocaleInfo(this.code, this.name, this.flag);
}
