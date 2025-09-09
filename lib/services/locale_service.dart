// lib/services/locale_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  ];

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  String get currentCode => _currentLocale.languageCode;

  List<Locale> get flutterSupportedLocales =>
      supportedLocales.map((e) => Locale(e.code)).toList();

  Future<void> initialize() async {
    if (kDebugMode) {
      print('[LocaleService] Initializing...');
    }
    
    final prefs = await SharedPreferences.getInstance();
    
    // Try to load saved locale
    final saved = prefs.getString('locale');
    
    if (saved != null && supportedLocales.any((l) => l.code == saved)) {
      _currentLocale = Locale(saved);
      if (kDebugMode) {
        print('[LocaleService] Loaded saved locale: $saved');
      }
    } else {
      // Try to detect system locale
      final systemLocale = WidgetsBinding.instance.window.locale;
      final isSupported = supportedLocales.any(
        (locale) => locale.code == systemLocale.languageCode
      );
      
      if (isSupported) {
        _currentLocale = Locale(systemLocale.languageCode);
      } else {
        _currentLocale = const Locale('en');
      }
      
      await prefs.setString('locale', _currentLocale.languageCode);
      if (kDebugMode) {
        print('[LocaleService] Set initial locale: ${_currentLocale.languageCode}');
      }
    }

    // Load notification texts for current locale
    await NotificationTexts.setLocale(_currentLocale.languageCode);
    if (kDebugMode) {
      print('[LocaleService] NotificationTexts initialized with: ${_currentLocale.languageCode}');
    }

    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    if (!supportedLocales.any((l) => l.code == code)) return;
    if (_currentLocale.languageCode == code) return;

    final oldLocale = _currentLocale.languageCode;
    _currentLocale = Locale(code);
    
    if (kDebugMode) {
      print('[LocaleService] Changing locale from $oldLocale to $code');
    }

    final prefs = await SharedPreferences.getInstance();
    // Save to both keys for compatibility
    await prefs.setString('locale', code);
    await prefs.setString('app_locale', code);

    // Update notification texts and reschedule locale-dependent notifications
    await NotificationTexts.setLocale(code);
    if (kDebugMode) {
      print('[LocaleService] ✅ NotificationTexts updated to $code');
    }

    try {
      await NotificationService().onLocaleChanged(code);
      if (kDebugMode) {
        print('[LocaleService] ✅ NotificationService.onLocaleChanged($code) completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[LocaleService] ❌ Error updating notifications: $e');
      }
    }

    notifyListeners();
    if (kDebugMode) {
      print('[LocaleService] ✅ Language change complete: $oldLocale → $code');
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