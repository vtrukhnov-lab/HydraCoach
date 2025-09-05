import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
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
  
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    
    if (savedLocale != null) {
      _currentLocale = Locale(savedLocale);
    } else {
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
    }
    
    notifyListeners();
  }
  
  Future<void> setLocale(String localeCode) async {
    if (_currentLocale.languageCode == localeCode) return;
    
    _currentLocale = Locale(localeCode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);
    
    notifyListeners();
  }
  
  LocaleInfo getCurrentLocaleInfo() {
    return supportedLocales.firstWhere(
      (locale) => locale.code == _currentLocale.languageCode,
      orElse: () => supportedLocales.first,
    );
  }
}

class LocaleInfo {
  final String code;
  final String name;
  final String flag;
  
  const LocaleInfo(this.code, this.name, this.flag);
}
