import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // Для kDebugMode
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Добавлен импорт
import 'dart:math' as math;

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// App imports
import 'screens/onboarding_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'services/notification_service.dart' as notif; // Префикс для избежания конфликта
import 'services/subscription_service.dart'; // НОВОЕ: сервис подписки
import 'services/remote_config_service.dart'; // НОВОЕ: Remote Config
import 'widgets/weather_card.dart';
import 'widgets/daily_report.dart';

// Background message handler (должен быть top-level функцией)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Обрабатываем уведомления в фоне
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print('Background message: ${message.messageId}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ТЕСТ: Простейшая инициализация уведомлений
  try {
    final FlutterLocalNotificationsPlugin testPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    
    await testPlugin.initialize(initSettings);
    
    // Создаем канал
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'test_channel',
      'Test Channel',
      importance: Importance.max,
    );
    
    await testPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    // Показываем тестовое уведомление
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
      'Приложение готово к работе с PRO функциями!',
      details,
    );
    
    print('✅ Тестовое уведомление отправлено при запуске');
  } catch (e) {
    print('❌ Ошибка тестового уведомления: $e');
  }
  
  // Инициализируем Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 📊 НОВОЕ: Инициализируем Remote Config
  await RemoteConfigService.instance.initialize();
  
  // 💰 НОВОЕ: Инициализируем RevenueCat (подписки)
  await SubscriptionService.instance.initialize();
  
  // Настраиваем Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Запрашиваем разрешения для iOS
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
  
  // Получаем FCM токен
  final fcmToken = await messaging.getToken();
  
  // Выводим токен в консоль разными способами
  if (kDebugMode) {
    print('════════════════════════════════════════════════════════════');
    print('FCM TOKEN (скопируйте для тестирования):');
    print(fcmToken ?? 'Token not available');
    print('════════════════════════════════════════════════════════════');
    
    debugPrint('FCM Token получен: ${fcmToken?.substring(0, 20)}...');
  }
  
  // Показываем токен через 3 секунды после запуска
  if (fcmToken != null && kDebugMode) {
    Future.delayed(const Duration(seconds: 3), () {
      print('');
      print('🔑 FCM TOKEN для Firebase Console:');
      print(fcmToken);
      print('');
    });
  }
  
  // Инициализируем локальные уведомления (для отображения push в foreground)
  await notif.NotificationService.initialize();
  
  // Обрабатываем foreground сообщения
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }
    
    // Показываем локальное уведомление
    if (message.notification != null) {
      await notif.NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: message.notification?.title ?? 'HydraCoach',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    }
  });
  
  // Обрабатываем нажатия на уведомления
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Message clicked: ${message.messageId}');
    }
    // TODO: Навигация к нужному экрану
  });
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // НОВОЕ: MultiProvider для управления состоянием подписки
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HydrationProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
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

// Обновленный провайдер состояния с Remote Config
class HydrationProvider extends ChangeNotifier {
  double weight = 70;
  String dietMode = 'normal';
  String activityLevel = 'medium';
  List<Intake> todayIntakes = [];
  
  // Корректировки от погоды
  double weatherWaterAdjustment = 0;
  int weatherSodiumAdjustment = 0;
  
  late DailyGoals goals;
  
  // НОВОЕ: доступ к Remote Config
  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;
  
  HydrationProvider() {
    _calculateGoals();
    _loadData();
    _checkAndResetDaily();
    _subscribeFCMTopics();
  }
  
  // Подписываемся на FCM топики на основе настроек
  void _subscribeFCMTopics() async {
    final messaging = FirebaseMessaging.instance;
    
    // Подписываемся на общие уведомления
    await messaging.subscribeToTopic('all_users');
    
    // Подписываемся на топики по режиму питания
    if (dietMode == 'keto') {
      await messaging.subscribeToTopic('keto_users');
    } else if (dietMode == 'fasting') {
      await messaging.subscribeToTopic('fasting_users');
    }
    
    // Подписываемся на погодные предупреждения
    await messaging.subscribeToTopic('weather_alerts');
  }
  
  // ОБНОВЛЕНО: используем Remote Config для формул
  void _calculateGoals() {
    // Используем коэффициенты из Remote Config вместо хардкода
    int waterMin = (_remoteConfig.waterMinPerKg * weight).round();
    int waterOpt = (_remoteConfig.waterOptPerKg * weight).round();
    int waterMax = (_remoteConfig.waterMaxPerKg * weight).round();
    
    // Применяем корректировку от погоды
    if (weatherWaterAdjustment > 0) {
      waterMin = (waterMin * (1 + weatherWaterAdjustment)).round();
      waterOpt = (waterOpt * (1 + weatherWaterAdjustment)).round();
      waterMax = (waterMax * (1 + weatherWaterAdjustment)).round();
    }
    
    // Электролиты из Remote Config
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
    
    // Сохраняем прогресс для уведомлений
    final progress = getProgress();
    await prefs.setDouble('waterProgress', progress['waterPercent']!);
  }
  
  void _checkAndResetDaily() {
    // Проверяем, нужно ли сбросить данные за день
    final now = DateTime.now();
    const lastResetKey = 'lastReset';
    
    SharedPreferences.getInstance().then((prefs) {
      final lastResetStr = prefs.getString(lastResetKey);
      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);
        if (lastReset.day != now.day) {
          // Новый день - сбрасываем данные
          todayIntakes.clear();
          prefs.setString(lastResetKey, now.toIso8601String());
          notifyListeners();
          
          // Планируем вечерний отчет
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
    _subscribeFCMTopics(); // Обновляем подписки
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
    
    // Проверяем, нужно ли отправить напоминание после кофе
    if (type == 'coffee') {
      // Используем правильное планирование через NotificationService
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
  
  // ОБНОВЛЕНО: используем пороги из Remote Config
  String getHydrationStatus() {
    final progress = getProgress();
    final waterRatio = progress['water']! / goals.waterOpt;
    final sodiumRatio = progress['sodium']! / goals.sodium;
    
    // Используем пороги из Remote Config вместо хардкода
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
  
  int getHRI() {
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
  
  // ОБНОВЛЕНО: инициализируем подписку при запуске
  Future<void> _initializeApp() async {
    // Инициализируем подписку
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    await subscriptionProvider.initialize();
    
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
            // НОВОЕ: показываем индикатор загрузки подписки
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

// Главный экран (ОБНОВЛЕН с PRO индикатором и пейволом)
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
  }
  
  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= 21) {
      setState(() {
        _showDailyReport = true;
      });
    }
  }
    
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context); // НОВОЕ
    final progress = provider.getProgress();
    final status = provider.getHydrationStatus();
    final hri = provider.getHRI();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ОБНОВЛЕН: заголовок с PRO индикатором
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
                                // НОВОЕ: PRO бейдж
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
                            // НОВОЕ: кнопка PRO (если не подписан)
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
                            // КНОПКА ДЛЯ ТЕСТИРОВАНИЯ УВЕДОМЛЕНИЙ
                            IconButton(
                              icon: const Icon(Icons.notifications_active, color: Colors.orange),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (context) => Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const Text(
                                          '🧪 Тестирование уведомлений',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Проверьте работу разных типов уведомлений',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                        ),
                                        const SizedBox(height: 20),
                                        
                                        // Мгновенное уведомление
                                        Card(
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              child: Icon(Icons.flash_on, color: Colors.white),
                                            ),
                                            title: const Text('Мгновенное'),
                                            subtitle: const Text('Появится сразу'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              await notif.NotificationService().sendTestNotification();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('✅ Мгновенное уведомление отправлено'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        // Быстрый тест (10 секунд)
                                        Card(
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.purple,
                                              child: Icon(Icons.timer_10, color: Colors.white),
                                            ),
                                            title: const Text('Быстрый тест'),
                                            subtitle: const Text('Через 10 секунд'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              await notif.NotificationService().scheduleTestNotificationIn10Seconds();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('⚡ Уведомление запланировано через 10 секунд'),
                                                  backgroundColor: Colors.purple,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        // Уведомление через 1 минуту
                                        Card(
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.orange,
                                              child: Icon(Icons.timer, color: Colors.white),
                                            ),
                                            title: const Text('Тест планирования'),
                                            subtitle: const Text('Через 1 минуту'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              await notif.NotificationService().scheduleTestNotificationIn1Minute();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('⏰ Уведомление запланировано через 1 минуту'),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        // Полный тест
                                        Card(
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.teal,
                                              child: Icon(Icons.rocket_launch, color: Colors.white),
                                            ),
                                            title: const Text('Полный тест'),
                                            subtitle: const Text('3 уведомления: сразу, 10 сек, 1 мин'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              await notif.NotificationService().runFullTest();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('🚀 Запущен полный тест (3 уведомления)'),
                                                  backgroundColor: Colors.teal,
                                                  duration: Duration(seconds: 5),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const Divider(height: 24),
                                        
                                        // Проверка статуса
                                        Card(
                                          color: Colors.grey[50],
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(Icons.list_alt, color: Colors.white),
                                            ),
                                            title: const Text('Статус очереди'),
                                            subtitle: const Text('Список запланированных'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              await notif.NotificationService().checkNotificationStatus();
                                              Navigator.pop(context);
                                              if (kDebugMode) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('📋 Смотрите консоль для списка запланированных'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 8),
                                        
                                        // Отменить все
                                        Card(
                                          color: Colors.red[50],
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.cancel, color: Colors.white),
                                            ),
                                            title: const Text('Отменить все'),
                                            subtitle: const Text('Очистить очередь уведомлений'),
                                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                            onTap: () async {
                                              // Показываем диалог подтверждения
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) => AlertDialog(
                                                  title: const Text('Подтверждение'),
                                                  content: const Text('Отменить все запланированные уведомления?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(dialogContext),
                                                      child: const Text('Нет'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await notif.NotificationService().cancelAllNotifications();
                                                        Navigator.pop(dialogContext);
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('🗑️ Все уведомления отменены'),
                                                            backgroundColor: Colors.red,
                                                          ),
                                                        );
                                                      },
                                                      child: const Text('Да', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              tooltip: 'Тест уведомлений',
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
                        if (provider.weatherWaterAdjustment > 0) ...[
                          const SizedBox(height: 16),
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
                                  'Цели увеличены из-за жары',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
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
                        Text(
                          '$hri',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getHRIColor(hri),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ),
                
                // Быстрые кнопки
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // История приемов
                if (provider.todayIntakes.isNotEmpty)
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
                              children: provider.todayIntakes
                                  .take(5)
                                  .toList()
                                  .reversed
                                  .map((intake) => _buildIntakeItem(intake, provider))
                                  .toList(),
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
  
  // НОВОЕ: пейвол для подписки
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
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Заголовок
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
            
            // PRO возможности
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
                ],
              ),
            ),
            
            // Кнопки
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Кнопка подписки
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: subscriptionProvider.isLoading ? null : () async {
                        // TODO: Показать выбор тарифа и купить
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Функция покупки будет добавлена в следующем обновлении')),
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
                  
                  // Восстановить покупки
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