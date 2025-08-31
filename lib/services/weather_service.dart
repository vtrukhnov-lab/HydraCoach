import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class WeatherService {
  // Используем бесплатный API OpenWeatherMap
  static const String apiKey = 'YOUR_API_KEY'; // Получите на openweathermap.org
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  // Для демо используем фиксированные данные
  static const bool useDemo = true;
  
  static Future<WeatherData?> getCurrentWeather() async {
    try {
      // Для демо возвращаем тестовые данные
      if (useDemo) {
        return WeatherData(
          temperature: 28,
          humidity: 65,
          heatIndex: 32,
          description: 'Ясно',
          city: 'Москва',
        );
      }
      
      // Реальный запрос к API (когда будет ключ)
      Position? position = await _getCurrentLocation();
      if (position == null) return null;
      
      final url = Uri.parse(
        '$baseUrl?lat=${position.latitude}&lon=${position.longitude}'
        '&appid=$apiKey&units=metric&lang=ru'
      );
      
      final response = await http.get(url);
      
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
      // Возвращаем кэшированные данные
      return await _getCachedWeather();
    }
    
    return null;
  }
  
  static Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
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
    
    if (temp != null && humidity != null && heatIndex != null) {
      return WeatherData(
        temperature: temp,
        humidity: humidity,
        heatIndex: heatIndex,
        description: 'Кэшированные данные',
        city: '',
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