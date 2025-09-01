import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'screens/onboarding_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'services/weather_service.dart';
import 'services/notification_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/daily_report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем уведомления
  await NotificationService.initialize();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => HydrationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HydraCoach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

// Модели данных
class DailyGoals {
  final int waterMin;
  final int waterOpt;
  final int waterMax;
  final int sodium;
  final int potassium;
  final int magnesium;

  DailyGoals({
    required this.waterMin,
    required this.waterOpt,
    required this.waterMax,
    required this.sodium,
    required this.potassium,
    required this.magnesium,
  });
}

class Intake {
  final String id;
  final DateTime timestamp;
  final String type;
  final int volume;
  final int sodium;
  final int potassium;
  final int magnesium;

  Intake({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.volume,
    this.sodium = 0,
    this.potassium = 0,
    this.magnesium = 0,
  });
}

// Провайдер состояния
class HydrationProvider extends ChangeNotifier {
  double weight = 70;
  String dietMode = 'normal';
  String activityLevel = 'medium';
  List<Intake> todayIntakes = [];
  
  // Корректировки от погоды
  double weatherWaterAdjustment = 0;
  int weatherSodiumAdjustment = 0;
  
  late DailyGoals goals;
  
  HydrationProvider() {
    _calculateGoals();
    _loadData();
    _checkAndResetDaily();
  }
  
  void _calculateGoals() {
    int waterMin = (22 * weight).round();
    int waterOpt = (30 * weight).round();
    int waterMax = (36 * weight).round();
    
    // Применяем корректировку от погоды
    if (weatherWaterAdjustment > 0) {
      waterMin = (waterMin * (1 + weatherWaterAdjustment)).round();
      waterOpt = (waterOpt * (1 + weatherWaterAdjustment)).round();
      waterMax = (waterMax * (1 + weatherWaterAdjustment)).round();
    }
    
    int sodium = dietMode == 'keto' || dietMode == 'fasting' ? 3500 : 2500;
    int potassium = dietMode == 'keto' || dietMode == 'fasting' ? 3500 : 3000;
    int magnesium = dietMode == 'keto' || dietMode == 'fasting' ? 400 : 350;
    
    // Добавляем корректировку соли от погоды
    sodium += weatherSodiumAdjustment;
    
    goals = DailyGoals(
      waterMin: waterMin,
      waterOpt: waterOpt,
      waterMax: waterMax,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    );
  }
  
  void updateWeatherAdjustments(double waterAdjustment, int sodiumAdjustment) {
    weatherWaterAdjustment = waterAdjustment;
    weatherSodiumAdjustment = sodiumAdjustment;
    _calculateGoals();
    notifyListeners();
  }
  
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    weight = prefs.getDouble('weight') ?? 70;
    dietMode = prefs.getString('dietMode') ?? 'normal';
    activityLevel = prefs.getString('activityLevel') ?? 'medium';
    
    // Загружаем сегодняшние приемы
    final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
    final intakesJson = prefs.getStringList(todayKey) ?? [];
    
    todayIntakes = intakesJson.map((json) {
      final parts = json.split('|');
      return Intake(
        id: parts[0],
        timestamp: DateTime.parse(parts[1]),
        type: parts[2],
        volume: int.parse(parts[3]),
      