// lib/services/weather_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hydracoach/l10n/app_localizations.dart';

class WeatherService extends ChangeNotifier {
  // OpenWeatherMap
  static const String apiKey = 'c460f153f615a343e0fe5158eae73121';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Демо-режим (оффлайн)
  static const bool useDemo = false;

  WeatherData? _currentWeather;
  double? _heatIndex;

  // Guards
  static bool _fetchInProgress = false;
  static final _PermissionMutex _permMutex = _PermissionMutex();

  WeatherData? get currentWeather => _currentWeather;
  double? get heatIndex => _heatIndex;

  WeatherService() {
    loadWeather();
  }

  Future<void> loadWeather() async {
    if (_fetchInProgress) return;
    _fetchInProgress = true;
    try {
      final weather = await getCurrentWeather();
      if (weather != null) {
        _currentWeather = weather;
        _heatIndex = weather.heatIndex;
        notifyListeners();
      }
    } finally {
      _fetchInProgress = false;
    }
  }

  static Future<WeatherData?> getCurrentWeather() async {
    if (useDemo) return _demo();

    try {
      final position = await _getCurrentLocation();
      if (position == null) {
        final cached = await _getCachedWeather();
        if (cached != null) return cached;
        return WeatherData(
          temperature: 22,
          humidity: 60,
          heatIndex: _calculateHeatIndex(22, 60),
          description: 'clear',
          city: '',
        );
      }

      final lat = position.latitude;
      final lon = position.longitude;

      if (kDebugMode) debugPrint('Got location: $lat, $lon');

      // Берём язык "en", чтобы описания были предсказуемыми
      final url = Uri.parse(
        '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=en',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
        onTimeout: () => throw Exception('Timeout'),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          debugPrint('Weather error: ${response.statusCode} ${response.body}');
        }
        return await _getCachedWeather();
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      final temp = (data['main']?['temp'] as num?)?.toDouble() ?? 0.0;
      final humidity = (data['main']?['humidity'] as num?)?.toDouble() ?? 0.0;
      final heatIndex = _calculateHeatIndex(temp, humidity);

      final weatherList = (data['weather'] is List) ? data['weather'] as List : const [];
      final mainWeather = weatherList.isNotEmpty
          ? (weatherList[0]['main']?.toString().toLowerCase() ?? 'clear')
          : 'clear';
      final apiDesc = weatherList.isNotEmpty
          ? (weatherList[0]['description']?.toString().toLowerCase() ?? '')
          : '';
      final cloudsAll = (data['clouds']?['all'] as num?)?.toInt() ?? 0;

      // Маппим в короткий ключ для локализации
      String descKey;
      switch (mainWeather) {
        case 'clear':
          descKey = 'clear';
          break;
        case 'clouds':
          descKey = cloudsAll > 80 ? 'overcast' : 'cloudy';
          break;
        case 'rain':
          descKey = 'rain';
          break;
        case 'drizzle':
          descKey = 'drizzle';
          break;
        case 'thunderstorm':
          descKey = 'storm';
          break;
        case 'snow':
          descKey = 'snow';
          break;
        case 'mist':
        case 'fog':
        case 'haze':
          descKey = 'fog';
          break;
        default:
          // Фоллбек по подстрокам
          if (apiDesc.contains('overcast')) {
            descKey = 'overcast';
          } else if (apiDesc.contains('cloud')) {
            descKey = 'cloudy';
          } else if (apiDesc.contains('drizzle')) {
            descKey = 'drizzle';
          } else if (apiDesc.contains('rain')) {
            descKey = 'rain';
          } else if (apiDesc.contains('thunder')) {
            descKey = 'storm';
          } else if (apiDesc.contains('snow')) {
            descKey = 'snow';
          } else if (apiDesc.contains('fog') || apiDesc.contains('mist') || apiDesc.contains('haze')) {
            descKey = 'fog';
          } else {
            descKey = 'clear';
          }
      }

      if (kDebugMode) {
        debugPrint('===== WEATHER DEBUG =====');
        debugPrint('Main weather: $mainWeather');
        debugPrint('Description from API: $apiDesc');
        debugPrint('Clouds percentage: $cloudsAll');
        debugPrint('Final description key: $descKey');
        debugPrint('=========================');
      }

      final weather = WeatherData(
        temperature: temp,
        humidity: humidity,
        heatIndex: heatIndex,
        description: descKey,
        city: (data['name']?.toString() ?? ''),
      );

      // Кэшируем
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('lastTemp', temp);
      await prefs.setDouble('lastHumidity', humidity);
      await prefs.setDouble('lastHeatIndex', heatIndex);
      await prefs.setString('lastCity', weather.city);
      await prefs.setString('lastDescription', descKey);
      await prefs.setString('lastWeatherTime', DateTime.now().toIso8601String());

      return weather;
    } catch (e) {
      if (kDebugMode) debugPrint('Weather error: $e');
      final cached = await _getCachedWeather();
      if (cached != null) return cached;

      return WeatherData(
        temperature: 24,
        humidity: 65,
        heatIndex: _calculateHeatIndex(24, 65),
        description: 'clear',
        city: '',
      );
    }
  }

  static Future<Position?> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) debugPrint('Location services disabled');
        await Geolocator.openLocationSettings();
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await _permMutex.runIfFree(() async {
          if (kDebugMode) debugPrint('Requesting location permission...');
          permission = await Geolocator.requestPermission();
        });
        if (permission == LocationPermission.denied) {
          if (kDebugMode) debugPrint('User denied location permission');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) debugPrint('Location permission permanently denied');
        await Geolocator.openAppSettings();
        return null;
      }

      if (kDebugMode) debugPrint('Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      if (kDebugMode) {
        debugPrint('Successfully got position: ${position.latitude}, ${position.longitude}');
      }
      return position;
    } catch (e) {
      if (kDebugMode) debugPrint('Location error: $e');
      return null;
    }
  }

  static double _calculateHeatIndex(double tempC, double humidity) {
    // NOAA формула в °F, переводим туда-обратно
    final tempF = tempC * 9 / 5 + 32;

    if (tempF < 80) {
      // при низких температурах HI ~= T
      return tempC;
    }

    final hiF = -42.379 +
        2.04901523 * tempF +
        10.14333127 * humidity -
        0.22475541 * tempF * humidity -
        0.00683783 * tempF * tempF -
        0.05481717 * humidity * humidity +
        0.00122874 * tempF * tempF * humidity +
        0.00085282 * tempF * humidity * humidity -
        0.00000199 * tempF * tempF * humidity * humidity;

    return (hiF - 32) * 5 / 9;
  }

  static Future<WeatherData?> _getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final temp = prefs.getDouble('lastTemp');
    final humidity = prefs.getDouble('lastHumidity');
    final heatIndex = prefs.getDouble('lastHeatIndex');
    final city = prefs.getString('lastCity') ?? '';
    final description = prefs.getString('lastDescription') ?? 'clear';

    if (temp != null && humidity != null && heatIndex != null) {
      if (kDebugMode) debugPrint('Loading cached weather with description: $description');
      return WeatherData(
        temperature: temp,
        humidity: humidity,
        heatIndex: heatIndex,
        description: description,
        city: city,
      );
    }
    return null;
  }

  // Используется в UI
  static double getWaterAdjustment(double heatIndex) {
    if (heatIndex < 27) return 0;
    if (heatIndex < 32) return 0.05; // +5%
    if (heatIndex < 39) return 0.08; // +8%
    if (heatIndex < 45) return 0.12; // +12%
    return 0.15; // +15% для экстремальной жары
  }

  // Используется в UI
  static int getSodiumAdjustment(double heatIndex, String activityLevel) {
    int base = 0;
    if (heatIndex >= 32) base = 500;
    if (heatIndex >= 39) base = 1000;

    if (activityLevel == 'high') {
      base += 500;
    } else if (activityLevel == 'medium' && heatIndex >= 32) {
      base += 300;
    }
    return base;
  }

  // Демо-набор
  static WeatherData _demo() {
    final now = DateTime.now();
    final hour = now.hour;

    double temp = 22.0;
    if (hour >= 6 && hour < 10) {
      temp = 18 + (hour - 6);
    } else if (hour >= 10 && hour < 14) {
      temp = 22 + (hour - 10) * 1.5;
    } else if (hour >= 14 && hour < 18) {
      temp = 28 - (hour - 14) * 0.5;
    } else if (hour >= 18 && hour < 22) {
      temp = 26 - (hour - 18) * 1.5;
    } else {
      temp = 20;
    }

    final humidity = 60.0 + (hour < 12 ? 10 : -5);
    final hi = _calculateHeatIndex(temp, humidity);

    return WeatherData(
      temperature: temp,
      humidity: humidity,
      heatIndex: hi,
      description: hour >= 6 && hour <= 20 ? 'sunny' : 'clear',
      city: 'Demo City',
    );
  }
}

class _PermissionMutex {
  bool _inProgress = false;
  Completer<void>? _completer;

  Future<void> runIfFree(Future<void> Function() action) async {
    if (_inProgress) {
      await _completer?.future;
      return;
    }
    _inProgress = true;
    _completer = Completer<void>();
    try {
      await action();
    } finally {
      _inProgress = false;
      _completer?.complete();
      _completer = null;
    }
  }
}

class WeatherData {
  final double temperature;
  final double humidity;
  final double heatIndex;
  /// Короткий ключ: clear/cloudy/overcast/rain/drizzle/storm/snow/fog/sunny
  final String description;
  final String city;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.heatIndex,
    required this.description,
    required this.city,
  });

  // Локализованный текст состояния
  String getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final key = description.trim().toLowerCase();

    switch (key) {
      case 'clear':
        return l10n.weatherClear;
      case 'cloudy':
        return l10n.weatherCloudy;
      case 'overcast':
        return l10n.weatherOvercast;
      case 'rain':
        return l10n.weatherRain;
      case 'drizzle':
        return l10n.weatherDrizzle;
      case 'storm':
        return l10n.weatherStorm;
      case 'snow':
        return l10n.weatherSnow;
      case 'fog':
        return l10n.weatherFog;
      case 'sunny':
        return l10n.weatherSunny;
    }

    // Фоллбеки для длинных строк OpenWeather
    if (key.contains('overcast')) return l10n.weatherOvercast;
    if (key.contains('cloud')) return l10n.weatherCloudy;
    if (key.contains('rain')) return l10n.weatherRain;
    if (key.contains('drizzle')) return l10n.weatherDrizzle;
    if (key.contains('thunder')) return l10n.weatherStorm;
    if (key.contains('snow')) return l10n.weatherSnow;
    if (key.contains('fog') || key.contains('mist') || key.contains('haze')) return l10n.weatherFog;
    if (key.contains('sun')) return l10n.weatherSunny;

    return description;
  }

// Предупреждение по индексу жары (ключи как в твоём ARB)
  String getLocalizedHeatWarning(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Полоса «холодно»
    if (heatIndex <= 10) return l10n.heatWarningCold;

    if (heatIndex >= 39) {
      return l10n.heatWarningVeryHot;   // было Danger/High → используем VeryHot
    } else if (heatIndex >= 32) {
      return l10n.heatWarningHot;       // было High → используем Hot
    } else if (heatIndex >= 27) {
      return l10n.heatWarningElevated;
    } else {
      return l10n.heatWarningComfortable;
    }
  }

  // Цвет по HI
  Color getHeatColor() {
    if (heatIndex < 27) return const Color(0xFF4CAF50);
    if (heatIndex < 32) return const Color(0xFFFFC107);
    if (heatIndex < 39) return const Color(0xFFFF9800);
    if (heatIndex < 45) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }
}
