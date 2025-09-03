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
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/alcohol_log_screen.dart'; // НОВОЕ
import 'services/notification_service.dart' as notif;
import 'services/subscription_service.dart';
import 'services/remote_config_service.dart';
import 'services/alcohol_service.dart'; // НОВОЕ
import 'widgets/weather_card.dart';
import 'widgets/daily_report.dart';
import 'widgets/alcohol_card.dart'; // НОВОЕ
import 'widgets/alcohol_checkin_dialog.dart'; // НОВОЕ

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
        ChangeNotifierProvider(create: (context) => AlcoholService()), // НОВОЕ
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
        '/alcohol': (context) => const AlcoholLogScreen(), // НОВОЕ
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
  
  // НОВОЕ: корректировки от алкоголя
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
  
  // ОБНОВЛЕНО: добавлена корректировка от алкоголя
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
    
    // НОВОЕ: Применяем корректировку от алкоголя
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
    
    // НОВОЕ: Добавляем корректировку соли от алкоголя
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
  
  // НОВОЕ: обновление корректировок от алкоголя
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
  
  // ОБНОВЛЕНО: добавлен учет алкоголя в HRI
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
    
    // НОВОЕ: Добавляем риск от алкоголя
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
    
    // НОВОЕ: Инициализируем алкогольный сервис
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

// Главный экран с интеграцией алкоголя
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDailyReport = false;
  
  @override
  void initState() {
    super.initState();
    _checkDailyReport();
    _checkMorningCheckin(); // НОВОЕ
  }
  
  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= 21) {
      setState(() {
        _showDailyReport = true;
      });
    }
  }
  
  // НОВОЕ: проверка утреннего чек-ина
  void _checkMorningCheckin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      AlcoholCheckinDialog.show(context);
    }
  }
    
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final alcoholService = Provider.of<AlcoholService>(context); // НОВОЕ
    
    // НОВОЕ: обновляем корректировки от алкоголя
    provider.updateAlcoholAdjustments(
      alcoholService.totalWaterCorrection,
      alcoholService.totalSodiumCorrection.round(),
    );
    
    final progress = provider.getProgress();
    final status = provider.getHydrationStatus();
    final hri = provider.getHRI(alcoholService); // Передаем alcoholService
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Заголовок с PRO индикатором
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'HydraCoach',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).animate().fadeIn(duration: 500.ms),
                                if (subscriptionProvider.isPro) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber.shade400, Colors.amber.shade600],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!subscriptionProvider.isPro)
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.star, color: Colors.white, size: 20),
                                ),
                                onPressed: () {
                                  _showPaywall(context, subscriptionProvider);
                                },
                                tooltip: 'Получить PRO',
                              ),
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () {
                                Navigator.pushNamed(context, '/history');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Карточка погоды
                SliverToBoxAdapter(
                  child: WeatherCard(
                    onWeatherUpdate: (waterAdjustment, sodiumAdjustment) {
                      provider.updateWeatherAdjustments(
                        waterAdjustment, 
                        sodiumAdjustment
                      );
                    },
                  ),
                ),
                
                // НОВОЕ: Индикатор алкоголя
                const SliverToBoxAdapter(
                  child: AlcoholIndicator(),
                ),
                
                // Кольца прогресса
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProgressRing(
                              'Вода',
                              progress['waterPercent']!,
                              Colors.blue,
                              '${progress['water']!.toInt()}',
                              '${provider.goals.waterOpt} мл',
                            ).animate().scale(delay: 100.ms),
                            _buildProgressRing(
                              'Na',
                              progress['sodiumPercent']!,
                              Colors.orange,
                              '${progress['sodium']!.toInt()}',
                              '${provider.goals.sodium} мг',
                            ).animate().scale(delay: 200.ms),
                            _buildProgressRing(
                              'K',
                              progress['potassiumPercent']!,
                              Colors.purple,
                              '${progress['potassium']!.toInt()}',
                              '${provider.goals.potassium} мг',
                            ).animate().scale(delay: 300.ms),
                          ],
                        ),
                        // НОВОЕ: показываем корректировки
                        if (provider.weatherWaterAdjustment > 0 || alcoholService.totalStandardDrinks > 0) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (provider.weatherWaterAdjustment > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.wb_sunny,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Жара +${(provider.weatherWaterAdjustment * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (alcoholService.totalStandardDrinks > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_bar,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Алкоголь +${alcoholService.totalWaterCorrection.toInt()} мл',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Магний индикатор
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('Магний (Mg):'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress['magnesiumPercent']! / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation(Colors.pink),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${progress['magnesium']!.toInt()}/${provider.goals.magnesium} мг',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ),
                
                // НОВОЕ: Карточка минимум вреда (если пил алкоголь)
                const SliverToBoxAdapter(
                  child: AlcoholCard(),
                ),
                
                // Статус карточка
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Статус гидратации',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Hydration Risk Index'),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: hri / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(_getHRIColor(hri)),
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '$hri',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getHRIColor(hri),
                              ),
                            ),
                            // НОВОЕ: показываем влияние алкоголя на HRI
                            if (alcoholService.totalStandardDrinks > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(+${alcoholService.totalHRIModifier.round()} от алкоголя)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ),
                
                // Быстрые кнопки с алкоголем
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Быстрое добавление',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '200 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 200),
                            ),
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '300 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 300),
                            ),
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '500 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 500),
                            ),
                            _buildQuickButton(
                              context,
                              '⚡',
                              'Электролит',
                              '300 мл',
                              Colors.orange,
                              () => provider.addIntake('electrolyte', 300,
                                sodium: 500, potassium: 200, magnesium: 50),
                            ),
                            _buildQuickButton(
                              context,
                              '🍲',
                              'Бульон',
                              '250 мл',
                              Colors.amber,
                              () => provider.addIntake('broth', 250,
                                sodium: 800, potassium: 100),
                            ),
                            _buildQuickButton(
                              context,
                              '☕',
                              'Кофе',
                              '200 мл',
                              Colors.brown,
                              () => provider.addIntake('coffee', 200),
                            ),
                            // НОВОЕ: кнопка алкоголя
                            if (!alcoholService.soberModeEnabled)
                              _buildQuickButton(
                                context,
                                '🍺',
                                'Алкоголь',
                                'Добавить',
                                Colors.orange.shade600,
                                () async {
                                  final result = await Navigator.pushNamed(context, '/alcohol');
                                  if (result == true) {
                                    // Обновились данные алкоголя
                                    setState(() {});
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // История приемов
                if (provider.todayIntakes.isNotEmpty || alcoholService.todayIntakes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сегодня выпито',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/history');
                                },
                                child: const Text('Все записи →'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ...provider.todayIntakes
                                    .take(5)
                                    .toList()
                                    .reversed
                                    .map((intake) => _buildIntakeItem(intake, provider)),
                                // НОВОЕ: показываем алкогольные приемы
                                ...alcoholService.todayIntakes
                                    .map((intake) => _buildAlcoholItem(intake, alcoholService)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
            
            // Плавающий отчет (показывается вечером)
            if (_showDailyReport)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.9,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: const DailyReportCard(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Дневной отчет готов!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Посмотрите результаты дня',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 1, end: 0),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // НОВОЕ: виджет для алкогольного приема
  Widget _buildAlcoholItem(intake, AlcoholService alcoholService) {
    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        alcoholService.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${intake.type.label} удален'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                alcoholService.addIntake(intake);
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.orange.shade200),
          ),
        ),
        child: Row(
          children: [
            Text(
              intake.formattedTime,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(intake.type.icon, color: Colors.orange.shade600, size: 20),
            const SizedBox(width: 8),
            Text(intake.type.label),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${intake.volumeMl.toInt()} мл, ${intake.abv}%',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  intake.formattedSD,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showPaywall(BuildContext context, SubscriptionProvider subscriptionProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    RemoteConfigService.instance.paywallTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    RemoteConfigService.instance.paywallSubtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFeatureItem('🧠', 'Умные напоминания', 'Контекстные уведомления по погоде и активности'),
                  _buildFeatureItem('📊', 'Недельные отчеты', 'Детальная аналитика и рекомендации'),
                  _buildFeatureItem('📁', 'Экспорт данных', 'Сохранение истории в CSV формате'),
                  _buildFeatureItem('☁️', 'Облачная синхронизация', 'Доступ с любого устройства'),
                  _buildFeatureItem('🍽️', 'Режим поста', 'Специальные напоминания для IF/OMAD'),
                  _buildFeatureItem('🔥', 'Протоколы жары', 'Подготовка к экстремальным условиям'),
                  _buildFeatureItem('🍺', 'Recovery план', 'Пошаговое восстановление после алкоголя'), // НОВОЕ
                  _buildFeatureItem('📅', 'Трезвый календарь', 'Отслеживание трезвых дней'), // НОВОЕ
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: subscriptionProvider.isLoading ? null : () async {
                        // ЗАГЛУШКА: сразу активируем PRO
                        await subscriptionProvider.mockPurchase();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ PRO версия активирована!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: subscriptionProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Получить PRO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  TextButton(
                    onPressed: () async {
                      final success = await subscriptionProvider.restorePurchases();
                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success 
                            ? 'Покупки восстановлены!' 
                            : 'Активных покупок не найдено'
                          ),
                        ),
                      );
                    },
                    child: const Text('Восстановить покупки'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressRing(String label, double percent, Color color, String current, String goal) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percent.toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          current,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          goal,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickButton(BuildContext context, String icon, String label, 
      String volume, Color color, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              volume,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 100.ms);
  }
  
  Widget _buildIntakeItem(Intake intake, HydrationProvider provider) {
    String typeIcon = '';
    String typeName = '';
    
    switch (intake.type) {
      case 'water':
        typeIcon = '💧';
        typeName = 'Вода';
        break;
      case 'electrolyte':
        typeIcon = '⚡';
        typeName = 'Электролит';
        break;
      case 'broth':
        typeIcon = '🍲';
        typeName = 'Бульон';
        break;
      case 'coffee':
        typeIcon = '☕';
        typeName = 'Кофе';
        break;
    }
    
    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        provider.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$typeName удален'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                provider.addIntake(
                  intake.type,
                  intake.volume,
                  sodium: intake.sodium,
                  potassium: intake.potassium,
                  magnesium: intake.magnesium,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Text(
              '${intake.timestamp.hour.toString().padLeft(2, '0')}:${intake.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Text('$typeIcon $typeName'),
            const Spacer(),
            Text(
              '${intake.volume} мл',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Норма':
        return Colors.green;
      case 'Мало соли':
      case 'Разбавляешь':
        return Colors.orange;
      case 'Недобор воды':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
                   'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    const weekDays = ['Воскресенье', 'Понедельник', 'Вторник', 'Среда',
                     'Четверг', 'Пятница', 'Суббота'];
    
    return '${weekDays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }
}