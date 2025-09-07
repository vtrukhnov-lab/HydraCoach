import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'dart:math' as math;

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// App imports
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/alcohol_log_screen.dart';
import 'screens/drink_catalog_screen.dart';
import 'services/notification_service.dart' as notif;
import 'services/subscription_service.dart';
import 'services/remote_config_service.dart';
import 'services/weather_service.dart';
import 'services/alcohol_service.dart';
import 'services/hri_service.dart';
import 'services/locale_service.dart';

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
  
  // Initialize Firebase only if not already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  // Initialize localization
  await LocaleService.instance.initialize();
  
  // Test notification on startup - now properly localized
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
    
    // Get saved locale for notification
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'en';
    
    // FIXED: Use localized strings instead of hardcoded
    final Map<String, Map<String, String>> localizedStartup = {
      'en': {
        'title': 'HydraCoach launched!',
        'body': 'App is ready to work with alcohol tracking!'
      },
      'ru': {
        'title': 'HydraCoach запущен!',
        'body': 'Приложение готово к работе с алкогольным трекингом!'
      },
      'es': {
        'title': '¡HydraCoach iniciado!',
        'body': '¡La aplicación está lista para trabajar con el seguimiento del alcohol!'
      }
    };
    
    final strings = localizedStartup[savedLocale] ?? localizedStartup['en']!;
    
    await testPlugin.show(
      12345,
      strings['title']!,
      strings['body']!,
      details,
    );
    
    print('✅ Test notification sent at startup');
  } catch (e) {
    print('❌ Test notification error: $e');
  }
  
  await RemoteConfigService.instance.initialize();
  await SubscriptionService.instance.initialize();
  
  // Setup Firebase Messaging
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
    print('╔══════════════════════════════════════════════════════════╗');
    print('FCM TOKEN (copy for testing):');
    print(fcmToken);
    print('╚══════════════════════════════════════════════════════════╝');
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
        ChangeNotifierProvider(create: (context) => WeatherService()),
        ChangeNotifierProvider(create: (context) => AlcoholService()),
        ChangeNotifierProvider(create: (context) => HRIService()),
        ChangeNotifierProvider.value(value: LocaleService.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        return MaterialApp(
          title: 'HydraCoach',
          debugShowCheckedModeBanner: false,
          
          // Localization
          locale: localeService.currentLocale,
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('ru'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'SF Pro Display',
            splashFactory: InkRipple.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.blue.withOpacity(0.2),
          ),
          
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/history': (context) => const HistoryScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/alcohol': (context) => const AlcoholLogScreen(),
            '/drink_catalog': (context) => const DrinkCatalogScreen(),
          },
        );
      },
    );
  }
}

// Data models
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

// Internal status enum for logic (not exposed to UI)
enum _HydrationStatusInternal {
  normal,
  diluted,
  dehydrated,
  lowSalt,
}

// Updated provider with localization support and alcohol tracking
class HydrationProvider extends ChangeNotifier {
  double weight = 70;
  String dietMode = 'normal';
  String activityLevel = 'medium';
  List<Intake> todayIntakes = [];
  
  double weatherWaterAdjustment = 0;
  int weatherSodiumAdjustment = 0;
  
  // Alcohol adjustments
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
  
  // NEW GETTERS FOR HRI SERVICE
  double get totalWaterToday {
    double total = 0;
    for (var intake in todayIntakes) {
      if (intake.type == 'water' || 
          intake.type == 'electrolyte' || 
          intake.type == 'broth') {
        total += intake.volume;
      }
    }
    return total;
  }
  
  int get totalSodiumToday {
    int total = 0;
    for (var intake in todayIntakes) {
      total += intake.sodium;
    }
    return total;
  }
  
  int get coffeeCupsToday {
    return todayIntakes.where((intake) => intake.type == 'coffee').length;
  }
  
  DateTime? get lastIntakeTime {
    if (todayIntakes.isEmpty) return null;
    return todayIntakes.last.timestamp;
  }
  // END NEW GETTERS
  
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
    // FIXED: Always start with BASE values
    int baseWaterMin = (_remoteConfig.waterMinPerKg * weight).round();
    int baseWaterOpt = (_remoteConfig.waterOptPerKg * weight).round();
    int baseWaterMax = (_remoteConfig.waterMaxPerKg * weight).round();
    
    // Start with base values
    int waterMin = baseWaterMin;
    int waterOpt = baseWaterOpt;
    int waterMax = baseWaterMax;
    
    // Apply weather correction (percentage increase from BASE)
    if (weatherWaterAdjustment > 0) {
      waterMin = (baseWaterMin * (1 + weatherWaterAdjustment)).round();
      waterOpt = (baseWaterOpt * (1 + weatherWaterAdjustment)).round();
      waterMax = (baseWaterMax * (1 + weatherWaterAdjustment)).round();
    }
    
    // Apply alcohol correction (addition to already corrected values)
    if (alcoholWaterAdjustment > 0) {
      waterMin += alcoholWaterAdjustment.round();
      waterOpt += alcoholWaterAdjustment.round();
      waterMax += alcoholWaterAdjustment.round();
    }
    
    // BASE electrolyte values
    int baseSodium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.sodiumKeto 
        : _remoteConfig.sodiumNormal;
    int basePotassium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.potassiumKeto 
        : _remoteConfig.potassiumNormal;
    int baseMagnesium = dietMode == 'keto' || dietMode == 'fasting' 
        ? _remoteConfig.magnesiumKeto 
        : _remoteConfig.magnesiumNormal;
    
    // Start with base values
    int sodium = baseSodium;
    int potassium = basePotassium;
    int magnesium = baseMagnesium;
    
    // Add weather salt correction
    sodium += weatherSodiumAdjustment;
    
    // Add alcohol salt correction
    sodium += alcoholSodiumAdjustment;
    
    // Create final goals
    goals = DailyGoals(
      waterMin: waterMin,
      waterOpt: waterOpt,
      waterMax: waterMax,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    );
    
    // Debug info
    if (kDebugMode) {
      print('=== Goals Calculation Debug ===');
      print('Weight: $weight kg');
      print('Base water: $baseWaterOpt ml');
      print('Weather adjustment: ${(weatherWaterAdjustment * 100).toStringAsFixed(1)}%');
      print('Alcohol adjustment: ${alcoholWaterAdjustment.toStringAsFixed(0)} ml');
      print('Final water goal: $waterOpt ml');
      print('Base sodium: $baseSodium mg');
      print('Weather sodium adj: $weatherSodiumAdjustment mg');
      print('Alcohol sodium adj: $alcoholSodiumAdjustment mg');
      print('Final sodium goal: $sodium mg');
      print('==============================');
    }
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
  
  // Save method
  Future<void> _saveIntakes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayKey = 'intakes_${DateTime.now().toIso8601String().split('T')[0]}';
      
      final intakesJson = todayIntakes.map((intake) {
        return '${intake.id}|${intake.timestamp.toIso8601String()}|${intake.type}|'
               '${intake.volume}|${intake.sodium}|${intake.potassium}|${intake.magnesium}';
      }).toList();
      
      await prefs.setStringList(todayKey, intakesJson);
      
      final progress = getProgress();
      await prefs.setDouble('waterProgress', progress['waterPercent']!);
      
      if (kDebugMode) {
        print('✅ Saved ${todayIntakes.length} records');
        print('📊 Water progress: ${progress['waterPercent']?.toStringAsFixed(1)}%');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Save error: $e');
      }
    }
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
  
  // FIXED: Synchronous method for adding water with instant UI updates
  void addIntake(String type, int volume, {int sodium = 0, int potassium = 0, int magnesium = 0}) {
    // Add to list
    todayIntakes.add(Intake(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: type,
      volume: volume,
      sodium: sodium,
      potassium: potassium,
      magnesium: magnesium,
    ));
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    if (kDebugMode) {
      print('➕ Added: $type, volume: $volume ml');
      print('📋 Total records: ${todayIntakes.length}');
    }
    
    // IMPORTANT: First notify UI about changes
    notifyListeners();
    
    // Then save asynchronously (don't wait for completion)
    _saveIntakes().then((_) {
      if (kDebugMode) {
        print('💾 Data saved to SharedPreferences');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('❌ Save error: $error');
      }
    });
    
    // Schedule post-coffee reminder
    if (type == 'coffee') {
      notif.NotificationService().schedulePostCoffeeReminder().then((success) {
        if (kDebugMode && success) {
          print('☕ Post-coffee reminder scheduled');
        }
      });
    }
  }
  
  void removeIntake(String id) {
    todayIntakes.removeWhere((intake) => intake.id == id);
    
    // First update UI
    notifyListeners();
    
    // Then save
    _saveIntakes().then((_) {
      if (kDebugMode) {
        print('➖ Deleted record: $id');
      }
    });
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
  
  // Private method to get internal status enum (for logic)
  _HydrationStatusInternal _getInternalHydrationStatus() {
    final progress = getProgress();
    final waterRatio = progress['water']! / goals.waterOpt;
    final sodiumRatio = progress['sodium']! / goals.sodium;
    
    if (waterRatio > _remoteConfig.dilutionWaterThreshold && 
        sodiumRatio < _remoteConfig.dilutionSodiumThreshold) {
      return _HydrationStatusInternal.diluted;
    } else if (waterRatio < _remoteConfig.dehydrationThreshold) {
      return _HydrationStatusInternal.dehydrated;
    } else if (sodiumRatio < _remoteConfig.lowSaltThreshold) {
      return _HydrationStatusInternal.lowSalt;
    } else {
      return _HydrationStatusInternal.normal;
    }
  }
  
  // Public method to get localized status string
  String getHydrationStatus(AppLocalizations l10n) {
    final status = _getInternalHydrationStatus();
    
    switch (status) {
      case _HydrationStatusInternal.normal:
        return l10n.hydrationStatusNormal;
      case _HydrationStatusInternal.diluted:
        return l10n.hydrationStatusDiluted;
      case _HydrationStatusInternal.dehydrated:
        return l10n.hydrationStatusDehydrated;
      case _HydrationStatusInternal.lowSalt:
        return l10n.hydrationStatusLowSalt;
    }
  }
  
  int getHRI(AlcoholService? alcoholService) {
    final status = _getInternalHydrationStatus();
    int baseHRI = 0;
    
    // Use internal enum for logic
    switch (status) {
      case _HydrationStatusInternal.normal:
        baseHRI = 15;
        break;
      case _HydrationStatusInternal.lowSalt:
        baseHRI = 45;
        break;
      case _HydrationStatusInternal.dehydrated:
        baseHRI = 55;
        break;
      case _HydrationStatusInternal.diluted:
        baseHRI = 65;
        break;
    }
    
    // Add weather risk
    if (weatherWaterAdjustment > 0.1) {
      baseHRI += 10;
    }
    
    // Add alcohol risk
    if (alcoholService != null) {
      baseHRI += alcoholService.totalHRIModifier.round();
    }
    
    return math.min(baseHRI, 100);
  }
}

// Splash screen
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
    // Initialize subscription
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    await subscriptionProvider.initialize();
    
    // Initialize alcohol service
    final alcoholService = Provider.of<AlcoholService>(context, listen: false);
    await alcoholService.init();
    
    // Check onboarding
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