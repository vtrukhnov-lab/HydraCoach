import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math' as math;

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// App imports
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';  // ДОБАВЛЕН ИМПОРТ
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/alcohol_log_screen.dart';
import 'services/notification_service.dart' as notif;
import 'services/subscription_service.dart';
import 'services/remote_config_service.dart';
import 'services/alcohol_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/daily_report.dart';
import 'widgets/alcohol_card.dart';
import 'widgets/alcohol_checkin_dialog.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print('Background message: ${message.messageId}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем Firebase только если еще не инициализирован
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  // Тестовое уведомление при запуске
  try {
    final FlutterLocalNotificationsPlugin testPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    
    await testPlugin.initialize(initSettings);
    
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'test_channel',
      'Test Channel',
      importance: Importance.max,
    );
    
    await testPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Channel',
      importance: Importance.max,
      priority: Priority.max,
    );
    
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    
    await testPlugin.show(
      12345,
      'HydraCoach запущен!',
      'Приложение готово к работе с алкогольным трекингом!',
      details,
    );
    
    print('✅ Тестовое уведомление отправлено при запуске');
  } catch (e) {
    print('❌ Ошибка тестового уведомления: $e');
  }
  
  await RemoteConfigService.instance.initialize();
  await SubscriptionService.instance.initialize();
  
  // Настраиваем Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  
  final fcmToken = await messaging.getToken();
  
  if (kDebugMode && fcmToken != null) {
    print('════════════════════════════════════════════════════════════');
    print('FCM TOKEN (скопируйте для тестирования):');
    print(fcmToken);
    print('════════════════════════════════════════════════════════════');
  }
  
  await notif.NotificationService.initialize();
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }
    
    if (message.notification != null) {
      await notif.NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: message.notification?.title ?? 'HydraCoach',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    }
  });
  
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Message clicked: ${message.messageId}');
    }
  });
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HydrationProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => AlcoholService()),
      ],
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
        '/alcohol': (context) => const AlcoholLogScreen(),
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

// Обновленный провайдер состояния с учетом алкоголя
class HydrationProvider extends ChangeNotifier {
  double weight = 70;
  String dietMode = 'normal';
  String activityLevel = 'medium';
  List<Intake> todayIntakes = [];
  
  double weatherWaterAdjustment = 0;
  int weatherSodiumAdjustment = 0;
  
  // Корректировки от алкоголя
  double alcoholWaterAdjustment = 0;
  int alcoholSodiumAdjustment = 0;
  
  late DailyGoals goals;
  
  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;
  
  HydrationProvider() {
    _calculateGoals();
    _loadData();
    _checkAndResetDaily();
    _subscribeFCMTopics();
  }
  
  void _subscribeFCMTopics() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic('all_users');
    
    if (dietMode == 'keto') {
      await messaging.subscribeToTopic('keto_users');
    } else if (dietMode == 'fasting') {
      await messaging.subscribeToTopic('fasting_users');
    }
    
    await messaging.subscribeToTopic('weather_alerts');
  }
  
  void _calculateGoals() {
    int waterMin = (_remoteConfig.waterMinPerKg * weight).round();
    int waterOpt = (_remoteConfig.waterOptPerKg * weight).round();
    int waterMax = (_remoteConfig.waterMaxPerKg * weight).round();
    
    // Применяем корректировку от погоды
    if (weatherWaterAdjustment > 0) {
      waterMin = (waterMin * (1 + weatherWaterAdjustment)).round();
      waterOpt = (waterOpt * (1 + weatherWaterAdjustment)).round();
      waterMax = (waterMax * (1 + weatherWaterAdjustment)).round();
    }
    
    // Применяем корректировку от алкоголя
    if (alcoholWaterAdjustment > 0) {
      waterMin += alcoholWaterAdjustment.round();
      waterOpt += alcoholWaterAdjustment.round();
      waterMax += alcoholWaterAdjustment.round();
    }
    
    int sodium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.sodiumKeto 
        : _remoteConfig.sodiumNormal;
    int potassium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.potassiumKeto 
        : _remoteConfig.potassiumNormal;
    int magnesium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.magnesiumKeto 
        : _remoteConfig.magnesiumNormal;
    
    // Добавляем корректировку соли от погоды
    sodium += weatherSodiumAdjustment;
    
    // Добавляем корректировку соли от алкоголя
    sodium += alcoholSodiumAdjustment;
    
    goals = DailyGoals(
      waterMin: waterMin,
      waterOpt: waterOpt,
      waterMax: waterMax,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    );
  }
  
  void updateAlcoholAdjustments(double waterAdjustment, int sodiumAdjustment) {
    alcoholWaterAdjustment = waterAdjustment;
    alcoholSodiumAdjustment = sodiumAdjustment;
    _calculateGoals();
    notifyListeners();
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
    
    final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
    final intakesJson = prefs.getStringList(todayKey) ?? [];
    
    todayIntakes = intakesJson.map((json) {
      final parts = json.split('|');
      return Intake(
        id: parts[0],
        timestamp: DateTime.parse(parts[1]),
        type: parts[2],
        volume: int.parse(parts[3]),
        sodium: int.parse(parts[4]),
        potassium: int.parse(parts[5]),
        magnesium: int.parse(parts[6]),
      );
    }).toList();
    
    _calculateGoals();
    notifyListeners();
  }
  
  Future<void> _saveIntakes() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
    
    final intakesJson = todayIntakes.map((intake) {
      return '${intake.id}|${intake.timestamp.toIso8601String()}|${intake.type}|'
             '${intake.volume}|${intake.sodium}|${intake.potassium}|${intake.magnesium}';
    }).toList();
    
    await prefs.setStringList(todayKey, intakesJson);
    
    final progress = getProgress();
    await prefs.setDouble('waterProgress', progress['waterPercent']!);
  }
  
  void _checkAndResetDaily() {
    final now = DateTime.now();
    const lastResetKey = 'lastReset';
    
    SharedPreferences.getInstance().then((prefs) {
      final lastResetStr = prefs.getString(lastResetKey);
      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);
        if (lastReset.day != now.day) {
          todayIntakes.clear();
          prefs.setString(lastResetKey, now.toIso8601String());
          notifyListeners();
          
          notif.NotificationService().scheduleEveningReport();
        }
      } else {
        prefs.setString(lastResetKey, now.toIso8601String());
      }
    });
  }
  
  void updateProfile({
    required double weight,
    required String dietMode,
    required String activityLevel,
    String? fastingSchedule,
  }) {
    this.weight = weight;
    this.dietMode = dietMode;
    this.activityLevel = activityLevel;
    _calculateGoals();
    _saveProfile();
    _subscribeFCMTopics();
    notifyListeners();
  }
  
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', weight);
    await prefs.setString('dietMode', dietMode);
    await prefs.setString('activityLevel', activityLevel);
  }
  
  void addIntake(String type, int volume, {int sodium = 0, int potassium = 0, int magnesium = 0}) {
    todayIntakes.add(Intake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
      volume: volume,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    ));
    
    HapticFeedback.lightImpact();
    _saveIntakes();
    notifyListeners();
    
    if (type == 'coffee') {
      notif.NotificationService().schedulePostCoffeeReminder();
      
      if (kDebugMode) {
        print('☕ Напоминание после кофе запланировано');
      }
    }
  }
  
  void removeIntake(String id) {
    todayIntakes.removeWhere((intake) => intake.id == id);
    _saveIntakes();
    notifyListeners();
  }
  
  Map<String, double> getProgress() {
    int totalWater = 0;
    int totalSodium = 0;
    int totalPotassium = 0;
    int totalMagnesium = 0;
    
    for (var intake in todayIntakes) {
      if (intake.type == 'water' || intake.type == 'electrolyte' || intake.type == 'broth') {
        totalWater += intake.volume;
      }
      totalSodium += intake.sodium;
      totalPotassium += intake.potassium;
      totalMagnesium += intake.magnesium;
    }
    
    return {
      'water': totalWater.toDouble(),
      'waterPercent': math.min((totalWater / goals.waterOpt) * 100, 100),
      'sodium': totalSodium.toDouble(),
      'sodiumPercent': math.min((totalSodium / goals.sodium) * 100, 100),
      'potassium': totalPotassium.toDouble(),
      'potassiumPercent': math.min((totalPotassium / goals.potassium) * 100, 100),
      'magnesium': totalMagnesium.toDouble(),
      'magnesiumPercent': math.min((totalMagnesium / goals.magnesium) * 100, 100),
    };
  }
  
  String getHydrationStatus() {
    final progress = getProgress();
    final waterRatio = progress['water']! / goals.waterOpt;
    final sodiumRatio = progress['sodium']! / goals.sodium;
    
    if (waterRatio > _remoteConfig.dilutionWaterThreshold && 
        sodiumRatio < _remoteConfig.dilutionSodiumThreshold) {
      return 'Разбавляешь';
    } else if (waterRatio < _remoteConfig.dehydrationThreshold) {
      return 'Недобор воды';
    } else if (sodiumRatio < _remoteConfig.lowSaltThreshold) {
      return 'Мало соли';
    } else {
      return 'Норма';
    }
  }
  
  int getHRI(AlcoholService? alcoholService) {
    final status = getHydrationStatus();
    int baseHRI = 0;
    
    switch (status) {
      case 'Норма': baseHRI = 15; break;
      case 'Мало соли': baseHRI = 45; break;
      case 'Недобор воды': baseHRI = 55; break;
      case 'Разбавляешь': baseHRI = 65; break;
    }
    
    // Добавляем риск от погоды
    if (weatherWaterAdjustment > 0.1) {
      baseHRI += 10;
    }
    
    // Добавляем риск от алкоголя
    if (alcoholService != null) {
      baseHRI += alcoholService.totalHRIModifier.round();
    }
    
    return math.min(baseHRI, 100);
  }
}

// Экран загрузки
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Инициализируем подписку
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    await subscriptionProvider.initialize();
    
    // Инициализируем алкогольный сервис
    final alcoholService = Provider.of<AlcoholService>(context, listen: false);
    await alcoholService.init();
    
    // Проверяем онбординг
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboardingCompleted') ?? false;
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => completed ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💧',
              style: TextStyle(fontSize: 80),
            ).animate()
              .scale(duration: 500.ms)
              .then()
              .shake(delay: 500.ms),
            const SizedBox(height: 20),
            const Text(
              'HydraCoach',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
            Consumer<SubscriptionProvider>(
              builder: (context, subscription, child) {
                if (subscription.isLoading) {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}