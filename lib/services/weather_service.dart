import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class WeatherService {
  // Используем бесплатный API OpenWeatherMap
  static const String apiKey = 'c460f153f615a343e0fe5158eae73121';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  // ИЗМЕНЕНО: Отключаем демо-режим для реальной геолокации
  static const bool useDemo = false;
  
  static Future<WeatherData?> getCurrentWeather() async {
    try {
      // Если нет API ключа, используем демо-данные
      if (useDemo) {
        // Демо-данные для Бенидорма (типичная погода)
        final now = DateTime.now();
        final hour = now.hour;
        
        // Имитируем изменение температуры в течение дня
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
        final heatIndex = _calculateHeatIndex(temp, humidity);
        
        return WeatherData(
          temperature: temp,
          humidity: humidity,
          heatIndex: heatIndex,
          description: hour >= 6 && hour <= 20 ? 'Солнечно' : 'Ясно',
          city: 'Бенидорм',
        );
      }
      
      // Реальный запрос к API
      Position? position = await _getCurrentLocation();
      
      // Если не удалось получить локацию, показываем ошибку
      if (position == null) {
        print('Could not get location - check permissions');
        // Возвращаем демо-данные с указанием проблемы
        return WeatherData(
          temperature: 22,
          humidity: 60,
          heatIndex: 24,
          description: 'Нет доступа к геолокации',
          city: 'Локация неизвестна',
        );
      }
      
      // Используем реальные координаты пользователя
      double lat = position.latitude;
      double lon = position.longitude;
      
      print('Got location: $lat, $lon');
      
      final url = Uri.parse(
        '$baseUrl?lat=$lat&lon=$lon'
        '&appid=$apiKey&units=metric&lang=ru'
      );
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final temp = data['main']['temp'].toDouble();
        final humidity = data['main']['humidity'].toDouble();
        final heatIndex = _calculateHeatIndex(temp, humidity);
        
        // Сохраняем в кэш
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('lastTemp', temp);
        await prefs.setDouble('lastHumidity', humidity);
        await prefs.setDouble('lastHeatIndex', heatIndex);
        await prefs.setString('lastCity', data['name']);
        await prefs.setString('lastWeatherTime', DateTime.now().toIso8601String());
        
        return WeatherData(
          temperature: temp,
          humidity: humidity,
          heatIndex: heatIndex,
          description: data['weather'][0]['description'],
          city: data['name'],
        );
      }
    } catch (e) {
      print('Weather error: $e');
      // Возвращаем кэшированные данные или демо для Бенидорма
      final cached = await _getCachedWeather();
      if (cached != null) return cached;
      
      // Если нет кэша, возвращаем типичную погоду Бенидорма
      return WeatherData(
        temperature: 24,
        humidity: 65,
        heatIndex: 26,
        description: 'Данные недоступны',
        city: 'Бенидорм',
      );
    }
    
    return null;
  }
  
  static Future<Position?> _getCurrentLocation() async {
    try {
      // Проверяем доступность сервиса геолокации
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services disabled - asking user to enable');
        // Просим пользователя включить геолокацию
        await Geolocator.openLocationSettings();
        return null;
      }
      
      // Проверяем разрешения
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('Requesting location permission from user...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('User denied location permission');
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        print('Location permission permanently denied - opening settings');
        // Открываем настройки приложения для изменения разрешений
        await Geolocator.openAppSettings();
        return null;
      }
      
      print('Getting current position...');
      // Получаем текущую позицию с таймаутом
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Изменено на medium для баланса скорости/точности
        timeLimit: const Duration(seconds: 10),
      );
      
      print('Successfully got position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Location error: $e');
      return null;
    }
  }
  
  static double _calculateHeatIndex(double tempC, double humidity) {
    // Конвертируем в Фаренгейты для формулы
    double tempF = tempC * 9/5 + 32;
    
    // Упрощенная формула Heat Index
    if (tempF < 80) {
      return tempC; // HI не применяется при низких температурах
    }
    
    double hi = -42.379 + 
      2.04901523 * tempF + 
      10.14333127 * humidity -
      0.22475541 * tempF * humidity -
      0.00683783 * tempF * tempF -
      0.05481717 * humidity * humidity +
      0.00122874 * tempF * tempF * humidity +
      0.00085282 * tempF * humidity * humidity -
      0.00000199 * tempF * tempF * humidity * humidity;
    
    // Конвертируем обратно в Цельсий
    return (hi - 32) * 5/9;
  }
  
  static Future<WeatherData?> _getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    
    final temp = prefs.getDouble('lastTemp');
    final humidity = prefs.getDouble('lastHumidity');
    final heatIndex = prefs.getDouble('lastHeatIndex');
    final city = prefs.getString('lastCity') ?? 'Кэш';
    
    if (temp != null && humidity != null && heatIndex != null) {
      return WeatherData(
        temperature: temp,
        humidity: humidity,
        heatIndex: heatIndex,
        description: 'Кэшированные данные',
        city: city,
      );
    }
    
    return null;
  }
  
  // Расчет корректировки воды на основе Heat Index
  static double getWaterAdjustment(double heatIndex) {
    if (heatIndex < 27) return 0;
    if (heatIndex < 32) return 0.05; // +5%
    if (heatIndex < 39) return 0.08; // +8%
    if (heatIndex < 45) return 0.12; // +12%
    return 0.15; // +15% для экстремальной жары
  }
  
  // Расчет дополнительной соли
  static int getSodiumAdjustment(double heatIndex, String activityLevel) {
    int baseAdjustment = 0;
    
    if (heatIndex >= 32) baseAdjustment = 500;
    if (heatIndex >= 39) baseAdjustment = 1000;
    
    // Дополнительная корректировка для активности
    if (activityLevel == 'high') {
      baseAdjustment += 500;
    } else if (activityLevel == 'medium' && heatIndex >= 32) {
      baseAdjustment += 300;
    }
    
    return baseAdjustment;
  }
}

class WeatherData {
  final double temperature;
  final double humidity;
  final double heatIndex;
  final String description;
  final String city;
  
  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.heatIndex,
    required this.description,
    required this.city,
  });
  
  String getHeatWarning() {
    if (heatIndex < 27) {
      return 'Комфортная температура';
    } else if (heatIndex < 32) {
      return '⚠️ Повышенная температура';
    } else if (heatIndex < 39) {
      return '🔥 Жарко! Пейте больше воды';
    } else if (heatIndex < 45) {
      return '🌡️ Очень жарко! Риск обезвоживания';
    } else {
      return '☀️ Экстремальная жара! Максимальная гидратация';
    }
  }
  
  Color getHeatColor() {
    if (heatIndex < 27) return const Color(0xFF4CAF50);
    if (heatIndex < 32) return const Color(0xFFFFC107);
    if (heatIndex < 39) return const Color(0xFFFF9800);
    if (heatIndex < 45) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }
}