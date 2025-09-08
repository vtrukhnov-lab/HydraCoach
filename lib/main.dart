import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

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
import 'screens/liquids_catalog_screen.dart';
import 'screens/electrolytes_screen.dart';
import 'screens/supplements_screen.dart';
import 'screens/hot_drinks_screen.dart';
import 'screens/sports_screen.dart';
import 'services/notification_service.dart' as notif;
import 'services/subscription_service.dart';
import 'services/remote_config_service.dart';
import 'services/weather_service.dart';
import 'services/alcohol_service.dart';
import 'services/hri_service.dart';
import 'services/locale_service.dart';

// Providers - теперь в отдельном файле
import 'providers/hydration_provider.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  print('FCM Token: $fcmToken');
  
  await notif.NotificationService.initialize();
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    
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
    print('A new onMessageOpenedApp event was published!');
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
            '/liquids': (context) => const LiquidsCatalogScreen(),
            '/electrolytes': (context) => const ElectrolytesScreen(),
            '/supplements': (context) => const SupplementsScreen(),
            '/hot_drinks': (context) => const HotDrinksScreen(),
            '/sports': (context) => const SportsScreen(),
          },
        );
      },
    );
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