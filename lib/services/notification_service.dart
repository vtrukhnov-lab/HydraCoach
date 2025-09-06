// lib/services/notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io';
import 'dart:math';

import '../l10n/app_localizations.dart';
import 'locale_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static const String channelId = 'hydracoach_notifications';
  
  // Flag for initialization check
  bool _isInitialized = false;

  // ==================== INITIALIZATION ====================
  
  static Future<void> initialize() async {
    final service = NotificationService();
    await service._initializeLocalNotifications();
    await service._initializeFirebaseMessaging();
    await service._initializeTimezone();
    
    // Request exact alarm permission for Android 12+
    await service._requestExactAlarmPermission();
    
    print('✅ NotificationService initialized');
  }

  Future<void> _initializeTimezone() async {
    // IMPORTANT: Using latest_all for full timezone support
    tz.initializeTimeZones();
    
    // Determine local timezone
    final String timeZoneName = await _getTimeZoneName();
    print('🌍 Using timezone: $timeZoneName');
    
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('⚠️ Failed to set timezone $timeZoneName, using Moscow');
      tz.setLocalLocation(tz.getLocation('Europe/Moscow'));
    }
  }
  
  Future<String> _getTimeZoneName() async {
    // Can be determined automatically or use fixed
    // For Russia usually Europe/Moscow
    return 'Europe/Moscow';
  }

  Future<void> _initializeLocalNotifications() async {
    // Android settings with proper icon
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    
    // General settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // Initialize with callback for handling taps
    final bool? initialized = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );
    
    if (initialized == true) {
      _isInitialized = true;
      print('✅ Local notifications initialized');
      
      // Create Android notification channels
      if (Platform.isAndroid) {
        await _createAndroidNotificationChannels();
      }
      
      // Check pending notifications
      await checkNotificationStatus();
    } else {
      print('❌ Local notifications initialization error');
    }
  }

  Future<void> _createAndroidNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) return;
    
    // Get localized strings
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    // Main channel
    final channel = AndroidNotificationChannel(
      channelId,
      _getLocalizedString('notificationChannelName', locale),
      description: _getLocalizedString('notificationChannelDescription', locale),
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: false,  // Disable LED
    );
    
    await androidPlugin.createNotificationChannel(channel);
    
    // Channel for urgent notifications
    final urgentChannel = AndroidNotificationChannel(
      'hydracoach_urgent',
      _getLocalizedString('urgentNotificationChannelName', locale),
      description: _getLocalizedString('urgentNotificationChannelDescription', locale),
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );
    
    await androidPlugin.createNotificationChannel(urgentChannel);
    
    print('📢 Android notification channels created');
  }
  
  // Request exact alarm permission for Android 12+
  Future<void> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        // Request notification permission (Android 13+)
        final notificationGranted = await androidPlugin.requestNotificationsPermission();
        print('📝 Notifications permission: $notificationGranted');
        
        // Request exact alarm permission (Android 12+)
        final exactAlarmGranted = await androidPlugin.requestExactAlarmsPermission();
        print('📝 Exact alarms permission: $exactAlarmGranted');
      }
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permissions
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('📱 FCM permissions: ${settings.authorizationStatus}');
    
    // Get and save FCM token
    await _saveFCMToken();
    
    // Listen for token updates
    _messaging.onTokenRefresh.listen(_updateFCMToken);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
    
    // Check if app was opened from notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }
  }

  // ==================== FCM TOKEN ====================
  
  Future<void> _saveFCMToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      
      print('🔑 FCM Token received: ${token.substring(0, 20)}...');
      
      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      
      // Save to Firestore if user exists
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
          'notificationsEnabled': true,
        }, SetOptions(merge: true));
        
        print('✅ FCM Token saved to Firestore for user ${user.uid}');
      }
      
      // Subscribe to topics
      await _subscribeToTopics();
      
    } catch (e) {
      print('❌ FCM token save error: $e');
    }
  }

  Future<void> _updateFCMToken(String token) async {
    print('🔄 FCM Token updated');
    await _saveFCMToken();
  }

  Future<void> _subscribeToTopics() async {
    // Subscribe to general topics
    await _messaging.subscribeToTopic('all_users');
    await _messaging.subscribeToTopic('daily_reminders');
    
    // Subscribe to topics based on settings
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('dietMode') ?? 'normal';
    
    if (dietMode == 'keto') {
      await _messaging.subscribeToTopic('keto_users');
    } else if (dietMode == 'fasting') {
      await _messaging.subscribeToTopic('fasting_users');
    }
    
    print('✅ Topic subscription complete');
  }

  // ==================== MESSAGE HANDLING ====================
  
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground message: ${message.notification?.title ?? ''}');
    
    // Show local notification
    if (message.notification != null) {
      await showNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'HydraCoach',
        body: message.notification!.body ?? '',
        payload: message.data['action'] ?? 'open_app',
      );
    }
    
    // Process data
    _processMessageData(message.data);
  }

  void _handleNotificationOpen(RemoteMessage message) {
    print('📱 Notification opened: ${message.messageId ?? ''}');
    _processMessageData(message.data);
  }

  void _processMessageData(Map<String, dynamic> data) {
    final action = data['action'];
    
    switch (action) {
      case 'drink_water':
        print('Action: Drink water');
        break;
      case 'add_electrolytes':
        print('Action: Add electrolytes');
        break;
      case 'daily_report':
        print('Action: Show report');
        break;
      default:
        print('Action: ${action ?? "unknown"}');
    }
  }
  
  // ==================== PRO CHECKS ====================
  
  // Notification counter for FREE users
  Future<int> _getTodayNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDate = prefs.getString('notification_count_reset_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastResetDate != today) {
      // New day - reset counter
      await prefs.setInt('daily_notification_count', 0);
      await prefs.setString('notification_count_reset_date', today);
      return 0;
    }
    
    return prefs.getInt('daily_notification_count') ?? 0;
  }
  
  Future<void> _incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await _getTodayNotificationCount();
    await prefs.setInt('daily_notification_count', count + 1);
  }
  
  // Check limit for FREE users
  Future<bool> canSendNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    
    if (isPro) {
      return true; // PRO users without limits
    }
    
    final count = await _getTodayNotificationCount();
    return count < 4; // FREE users - max 4 notifications per day
  }
  
  // Check PRO feature availability
  Future<bool> hasProFeature(String feature) async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    
    // FREE features - always available
    const freeFeatures = ['basic_reminder', 'daily_report'];
    if (freeFeatures.contains(feature)) {
      return true;
    }
    
    // PRO features - require subscription
    return isPro;
  }

  // ==================== LOCAL NOTIFICATIONS ====================
  
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    DateTime? scheduledTime,
  }) async {
    // Check limit for FREE users
    if (!await canSendNotification()) {
      print('⚠️ Daily notification limit reached (4/day for FREE)');
      return;
    }
    
    // Ensure service is initialized
    if (!_isInitialized) {
      print('⚠️ NotificationService not initialized, initializing...');
      await initialize();
    }
    
    // Get current locale for notification channel
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getLocalizedString('notificationChannelName', locale),
      channelDescription: _getLocalizedString('notificationChannelDescription', locale),
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'HydraCoach',
      icon: '@mipmap/ic_launcher',
      color: const Color.fromARGB(255, 33, 150, 243),
      enableVibration: true,
      playSound: true,
      enableLights: false,
      showWhen: true,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'HydraCoach',
      ),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
      autoCancel: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    if (scheduledTime != null) {
      // Check that time is in the future
      if (scheduledTime.isBefore(DateTime.now())) {
        print('⚠️ Time already passed, showing notification immediately');
        await _localNotifications.show(id, title, body, details, payload: payload);
        await _incrementNotificationCount();
        return;
      }
      
      try {
        // Convert to TZDateTime properly
        final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
          scheduledTime,
          tz.local,
        );
        
        print('📅 Scheduling notification:');
        print('   ID: $id');
        print('   Title: $title');
        print('   Scheduled for: $scheduledTime');
        
        // Schedule notification with proper parameters
        await _localNotifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
        
        await _incrementNotificationCount();
        print('✅ Notification successfully scheduled with ID: $id');
        
      } catch (e, stackTrace) {
        print('❌ Notification scheduling error: $e');
        print('Stack trace: $stackTrace');
        
        // If failed to schedule, show immediately
        print('Showing notification immediately as fallback');
        await _localNotifications.show(id, title, body, details, payload: payload);
        await _incrementNotificationCount();
      }
    } else {
      // Show immediately
      await _localNotifications.show(id, title, body, details, payload: payload);
      await _incrementNotificationCount();
      print('📬 Instant notification shown: $title');
    }
  }

  // ==================== SMART REMINDERS ====================
  
  Future<void> scheduleSmartReminders() async {
    print('🧠 Scheduling smart reminders...');
    
    // Cancel old reminders
    await cancelAllNotifications();
    
    final prefs = await SharedPreferences.getInstance();
    final dietMode = prefs.getString('dietMode') ?? 'normal';
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    // Get current progress
    final waterProgress = prefs.getDouble('waterProgress') ?? 0;
    
    // Base reminders throughout the day
    final now = DateTime.now();
    final reminders = <DateTime>[];
    
    // Morning reminder (8:00)
    reminders.add(DateTime(now.year, now.month, now.day, 8, 0));
    
    // Daily reminders depending on mode
    if (dietMode == 'fasting') {
      // For fasting - focus on electrolytes
      reminders.add(DateTime(now.year, now.month, now.day, 10, 0)); // Electrolytes
      reminders.add(DateTime(now.year, now.month, now.day, 14, 0)); // Water
      reminders.add(DateTime(now.year, now.month, now.day, 18, 0)); // Electrolytes
    } else {
      // Normal mode - even reminders
      reminders.add(DateTime(now.year, now.month, now.day, 10, 0));
      reminders.add(DateTime(now.year, now.month, now.day, 12, 30));
      reminders.add(DateTime(now.year, now.month, now.day, 15, 0));
      reminders.add(DateTime(now.year, now.month, now.day, 17, 30));
      reminders.add(DateTime(now.year, now.month, now.day, 20, 0));
    }
    
    // Evening report (21:00)
    reminders.add(DateTime(now.year, now.month, now.day, 21, 0));
    
    // Schedule reminders
    int notificationId = 1000;
    for (final reminderTime in reminders) {
      if (reminderTime.isAfter(now)) {
        final title = _getReminderTitle(reminderTime.hour, dietMode, locale);
        final body = _getReminderBody(reminderTime.hour, dietMode, waterProgress, locale);
        
        await showNotification(
          id: notificationId++,
          title: title,
          body: body,
          scheduledTime: reminderTime,
          payload: 'smart_reminder',
        );
      }
    }
    
    print('✅ Scheduled ${notificationId - 1000} reminders');
  }

  String _getReminderTitle(int hour, String dietMode, String locale) {
    if (hour == 8) return _getLocalizedString('goodMorning', locale);
    if (hour == 21) return _getLocalizedString('dailyReportTitle', locale);
    if (hour < 12) return _getLocalizedString('timeToHydrate', locale);
    if (hour < 17) return _getLocalizedString('dontForgetElectrolytesReminder', locale);
    return _getLocalizedString('eveningHydration', locale);
  }

  String _getReminderBody(int hour, String dietMode, double progress, String locale) {
    if (hour == 8) {
      return _getLocalizedString('startDayWithWaterReminder', locale);
    }
    
    if (hour == 21) {
      return _getLocalizedString('dailyReportBody', locale);
    }
    
    if (dietMode == 'fasting' && (hour == 10 || hour == 18)) {
      return _getLocalizedString('electrolytesTime', locale);
    }
    
    if (progress < 30) {
      return _getLocalizedString('catchUpHydration', locale).replaceAll('{percent}', '${progress.toInt()}');
    }
    
    if (progress < 60) {
      return _getLocalizedString('excellentProgress', locale);
    }
    
    return _getLocalizedString('maintainWaterBalance', locale);
  }

  // ==================== PRO REMINDERS ====================
  
  // Post-coffee reminder (PRO)
  Future<bool> schedulePostCoffeeReminder() async {
    // Check PRO status
    if (!await hasProFeature('post_coffee_reminder')) {
      print('⚠️ Post-coffee reminders - PRO feature');
      return false;
    }
    
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    // Schedule reminder in 20 minutes
    final reminderTime = DateTime.now().add(const Duration(minutes: 20));
    
    await showNotification(
      id: 2000 + Random().nextInt(1000),
      title: _getLocalizedString('postCoffeeTitle', locale),
      body: _getLocalizedString('postCoffeeBody', locale),
      scheduledTime: reminderTime,
      payload: 'post_coffee',
    );
    
    print('☕ PRO: Post-coffee reminder scheduled');
    return true;
  }
  
  // Post-workout reminder (basic)
  Future<void> schedulePostWorkoutReminder() async {
    final locale = LocaleService.instance.currentLocale.languageCode;
    final reminderTime = DateTime.now().add(const Duration(minutes: 30));
    
    await showNotification(
      id: 3000 + Random().nextInt(1000),
      title: _getLocalizedString('postWorkoutTitle', locale),
      body: _getLocalizedString('postWorkoutBody', locale),
      scheduledTime: reminderTime,
      payload: 'post_workout',
    );
    
    print('💪 Post-workout reminder scheduled');
  }
  
  // Heat warning (PRO)
  Future<bool> sendHeatWarning(double heatIndex) async {
    // Check PRO status
    if (!await hasProFeature('heat_warnings')) {
      print('⚠️ Heat warnings - PRO feature');
      return false;
    }
    
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    String message;
    if (heatIndex > 40) {
      message = _getLocalizedString('extremeHeatWarning', locale);
    } else if (heatIndex > 32) {
      message = _getLocalizedString('hotWeatherWarning', locale);
    } else {
      message = _getLocalizedString('warmWeatherWarning', locale);
    }
    
    await showNotification(
      id: Random().nextInt(1000),
      title: _getLocalizedString('heatWarningPro', locale),
      body: message,
      payload: 'heat_warning',
    );
    
    print('🌡️ PRO: Heat warning sent');
    return true;
  }
  
  // Post-alcohol reminder (PRO)
  Future<bool> schedulePostAlcoholReminder() async {
    // Check PRO status
    if (!await hasProFeature('post_alcohol_reminder')) {
      print('⚠️ Post-alcohol reminders - PRO feature');
      return false;
    }
    
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    // Schedule series of recovery reminders
    final now = DateTime.now();
    
    // In 30 minutes - first reminder
    await showNotification(
      id: 4000 + Random().nextInt(100),
      title: _getLocalizedString('alcoholRecoveryTitle', locale),
      body: _getLocalizedString('alcoholRecoveryBody', locale),
      scheduledTime: now.add(const Duration(minutes: 30)),
      payload: 'post_alcohol_1',
    );
    
    // In 2 hours - second reminder
    await showNotification(
      id: 4100 + Random().nextInt(100),
      title: _getLocalizedString('continueHydration', locale),
      body: _getLocalizedString('alcoholRecoveryBody2', locale),
      scheduledTime: now.add(const Duration(hours: 2)),
      payload: 'post_alcohol_2',
    );
    
    // Next morning
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 8, 0);
    await showNotification(
      id: 4200 + Random().nextInt(100),
      title: _getLocalizedString('morningRecoveryTitle', locale),
      body: _getLocalizedString('morningRecoveryBody', locale),
      scheduledTime: tomorrow,
      payload: 'post_alcohol_morning',
    );
    
    print('🍺 PRO: Alcohol recovery plan scheduled');
    return true;
  }
  
  // Evening report (basic)
  Future<void> scheduleEveningReport() async {
    final locale = LocaleService.instance.currentLocale.languageCode;
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 21, 0);
    
    // If already after 21:00, schedule for tomorrow
    if (now.hour >= 21) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    await showNotification(
      id: 999999, // Fixed ID for evening report
      title: _getLocalizedString('dailyReportTitle', locale),
      body: _getLocalizedString('dailyReportBody', locale),
      scheduledTime: scheduledTime,
      payload: 'evening_report',
    );
    
    print('📊 Evening report scheduled for ${scheduledTime.day}.${scheduledTime.month} at 21:00');
  }

  // ==================== NOTIFICATION MANAGEMENT ====================
  
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    print('🚫 Notification $id cancelled');
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }
  
  // Static method for saving settings
  Future<void> saveSettings(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('remindersEnabled', settings.enabled);
    await prefs.setInt('reminderFrequency', settings.frequency);
    await prefs.setString('morningTime', settings.morningTime);
    await prefs.setString('eveningTime', settings.eveningTime);
    await prefs.setBool('postCoffeeReminder', settings.postCoffee);
    await prefs.setBool('heatWarnings', settings.heatWarnings);
    await prefs.setBool('postAlcoholReminder', settings.postAlcohol);
    
    // Restart reminders if enabled
    if (settings.enabled) {
      await scheduleSmartReminders();
    } else {
      await cancelAllNotifications();
    }
    
    print('✅ Reminder settings saved');
  }
  
  // Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats() async {
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    final todayCount = await _getTodayNotificationCount();
    final pending = await getPendingNotifications();
    
    return {
      'is_pro': isPro,
      'today_count': todayCount,
      'daily_limit': isPro ? -1 : 4, // -1 = unlimited
      'remaining_today': isPro ? -1 : (4 - todayCount),
      'pending_notifications': pending.length,
      'features': {
        'basic_reminders': true,
        'post_coffee': isPro,
        'heat_warnings': isPro,
        'post_alcohol': isPro,
        'smart_contextual': isPro,
      }
    };
  }

  // ==================== TAP HANDLERS ====================
  
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Notification tapped: ${response.payload}');
    _handleNotificationAction(response.payload);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    print('📱 Background notification tapped: ${response.payload}');
    _handleNotificationAction(response.payload);
  }

  static void _handleNotificationAction(String? payload) {
    if (payload == null) return;
    
    switch (payload) {
      case 'smart_reminder':
        print('Open main screen');
        break;
      case 'post_coffee':
        print('Add water after coffee');
        break;
      case 'post_workout':
        print('Add electrolytes after workout');
        break;
      case 'post_alcohol_1':
      case 'post_alcohol_2':
      case 'post_alcohol_morning':
        print('Show alcohol recovery plan');
        break;
      case 'daily_report':
      case 'evening_report':
        print('Show daily report');
        break;
      case 'heat_warning':
        print('Show heat recommendations');
        break;
      case 'test':
      case 'test_scheduled':
        print('Test notification processed');
        break;
    }
  }

  // ==================== TESTING ====================
  
  // Instant test notification
  Future<void> sendTestNotification() async {
    final locale = LocaleService.instance.currentLocale.languageCode;
    
    await showNotification(
      id: 999,
      title: _getLocalizedString('testNotificationTitle', locale),
      body: _getLocalizedString('testNotificationBody', locale),
      payload: 'test',
    );
  }
  
  // Test notification in 1 minute
  Future<void> scheduleTestNotificationIn1Minute() async {
    final locale = LocaleService.instance.currentLocale.languageCode;
    final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
    
    await showNotification(
      id: 998,
      title: _getLocalizedString('scheduledTestTitle', locale),
      body: _getLocalizedString('scheduledTestBody', locale),
      scheduledTime: scheduledTime,
      payload: 'test_scheduled',
    );
    
    final timeStr = '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}';
    print('⏰ Test notification scheduled for $timeStr');
  }
  
  // Check notification status
  Future<void> checkNotificationStatus() async {
    final pending = await getPendingNotifications();
    print('');
    print('📋 ===== NOTIFICATION STATUS =====');
    print('📋 Scheduled notifications: ${pending.length}');
    if (pending.isNotEmpty) {
      print('📋 List:');
      for (var notification in pending) {
        print('   - ID: ${notification.id}');
        print('     Title: ${notification.title}');
        print('     Body: ${notification.body}');
        print('     Payload: ${notification.payload}');
      }
    }
    print('📋 =============================');
    print('');
  }

  // ==================== LOCALIZATION HELPER ====================
  
  static String _getLocalizedString(String key, String locale) {
    // FIXED: Complete localization with all three languages
    final Map<String, Map<String, String>> localizedStrings = {
      'en': {
        'notificationChannelName': 'HydraCoach Reminders',
        'notificationChannelDescription': 'Water and electrolyte reminders',
        'urgentNotificationChannelName': 'Urgent Reminders',
        'urgentNotificationChannelDescription': 'Important hydration notifications',
        'goodMorning': '☀️ Good morning!',
        'startDayWithWaterReminder': 'Start your day with a glass of water for good wellbeing',
        'timeToHydrate': '💧 Time to hydrate',
        'dontForgetElectrolytesReminder': '⚡ Don\'t forget electrolytes',
        'eveningHydration': '💧 Evening hydration',
        'dailyReportTitle': '📊 Daily report ready',
        'dailyReportBody': 'See how your hydration day went',
        'maintainWaterBalance': 'Maintain water balance throughout the day',
        'electrolytesTime': 'Time for electrolytes: add a pinch of salt to water',
        'catchUpHydration': 'You\'ve drunk only {percent}% of daily norm. Time to catch up!',
        'excellentProgress': 'Excellent progress! A bit more to reach the goal',
        'postCoffeeTitle': '☕ After coffee',
        'postCoffeeBody': 'Drink 250-300 ml water to restore balance',
        'postWorkoutTitle': '💪 After workout',
        'postWorkoutBody': 'Restore electrolytes: 500 ml water + pinch of salt',
        'heatWarningPro': '🌡️ PRO Heat warning',
        'extremeHeatWarning': 'Extreme heat! Increase water consumption by 15% and add 1g salt',
        'hotWeatherWarning': 'Hot! Drink 10% more water and don\'t forget electrolytes',
        'warmWeatherWarning': 'Warm weather. Monitor your hydration',
        'alcoholRecoveryTitle': '🍺 Recovery time',
        'alcoholRecoveryBody': 'Drink 300 ml water with a pinch of salt for balance',
        'continueHydration': '💧 Continue hydration',
        'alcoholRecoveryBody2': 'Another 500 ml water will help you recover faster',
        'morningRecoveryTitle': '☀️ Morning recovery',
        'morningRecoveryBody': 'Start the day with 500 ml water and electrolytes',
        'testNotificationTitle': '🧪 Test notification',
        'testNotificationBody': 'If you see this - instant notifications work!',
        'scheduledTestTitle': '⏰ Scheduled test (1 min)',
        'scheduledTestBody': 'This notification was scheduled 1 minute ago. Scheduling works!',
      },
      'ru': {
        'notificationChannelName': 'Напоминания HydraCoach',
        'notificationChannelDescription': 'Напоминания о воде и электролитах',
        'urgentNotificationChannelName': 'Срочные напоминания',
        'urgentNotificationChannelDescription': 'Важные уведомления о гидратации',
        'goodMorning': '☀️ Доброе утро!',
        'startDayWithWaterReminder': 'Начните день со стакана воды для хорошего самочувствия',
        'timeToHydrate': '💧 Время гидратации',
        'dontForgetElectrolytesReminder': '⚡ Не забывайте об электролитах',
        'eveningHydration': '💧 Вечерняя гидратация',
        'dailyReportTitle': '📊 Дневной отчёт готов',
        'dailyReportBody': 'Посмотрите, как прошёл ваш день гидратации',
        'maintainWaterBalance': 'Поддерживайте водный баланс в течение дня',
        'electrolytesTime': 'Время для электролитов: добавьте щепотку соли в воду',
        'catchUpHydration': 'Вы выпили только {percent}% дневной нормы. Время наверстать!',
        'excellentProgress': 'Отличный прогресс! Ещё немного до цели',
        'postCoffeeTitle': '☕ После кофе',
        'postCoffeeBody': 'Выпейте 250-300 мл воды для восстановления баланса',
        'postWorkoutTitle': '💪 После тренировки',
        'postWorkoutBody': 'Восстановите электролиты: 500 мл воды + щепотка соли',
        'heatWarningPro': '🌡️ PRO Предупреждение о жаре',
        'extremeHeatWarning': 'Экстремальная жара! Увеличьте потребление воды на 15% и добавьте 1г соли',
        'hotWeatherWarning': 'Жарко! Пейте на 10% больше воды и не забывайте об электролитах',
        'warmWeatherWarning': 'Тёплая погода. Следите за гидратацией',
        'alcoholRecoveryTitle': '🍺 Время восстановления',
        'alcoholRecoveryBody': 'Выпейте 300 мл воды со щепоткой соли для баланса',
        'continueHydration': '💧 Продолжайте гидратацию',
        'alcoholRecoveryBody2': 'Ещё 500 мл воды помогут вам быстрее восстановиться',
        'morningRecoveryTitle': '☀️ Утреннее восстановление',
        'morningRecoveryBody': 'Начните день с 500 мл воды и электролитов',
        'testNotificationTitle': '🧪 Тестовое уведомление',
        'testNotificationBody': 'Если вы видите это - мгновенные уведомления работают!',
        'scheduledTestTitle': '⏰ Запланированный тест (1 мин)',
        'scheduledTestBody': 'Это уведомление было запланировано минуту назад. Планирование работает!',
      },
      'es': {
        'notificationChannelName': 'Recordatorios HydraCoach',
        'notificationChannelDescription': 'Recordatorios de agua y electrolitos',
        'urgentNotificationChannelName': 'Recordatorios urgentes',
        'urgentNotificationChannelDescription': 'Notificaciones importantes de hidratación',
        'goodMorning': '☀️ ¡Buenos días!',
        'startDayWithWaterReminder': 'Comienza el día con un vaso de agua para el bienestar',
        'timeToHydrate': '💧 Hora de hidratarse',
        'dontForgetElectrolytesReminder': '⚡ No olvides los electrolitos',
        'eveningHydration': '💧 Hidratación nocturna',
        'dailyReportTitle': '📊 Informe diario listo',
        'dailyReportBody': 'Ve cómo fue tu día de hidratación',
        'maintainWaterBalance': 'Mantén el equilibrio hídrico durante el día',
        'electrolytesTime': 'Hora de electrolitos: agrega una pizca de sal al agua',
        'catchUpHydration': 'Solo has bebido {percent}% de la norma diaria. ¡Es hora de ponerse al día!',
        'excellentProgress': '¡Excelente progreso! Un poco más para alcanzar la meta',
        'postCoffeeTitle': '☕ Después del café',
        'postCoffeeBody': 'Bebe 250-300 ml de agua para restaurar el equilibrio',
        'postWorkoutTitle': '💪 Después del entrenamiento',
        'postWorkoutBody': 'Restaura electrolitos: 500 ml agua + pizca de sal',
        'heatWarningPro': '🌡️ PRO Alerta de calor',
        'extremeHeatWarning': '¡Calor extremo! Aumenta el consumo de agua en 15% y agrega 1g de sal',
        'hotWeatherWarning': '¡Calor! Bebe 10% más agua y no olvides los electrolitos',
        'warmWeatherWarning': 'Clima cálido. Monitorea tu hidratación',
        'alcoholRecoveryTitle': '🍺 Tiempo de recuperación',
        'alcoholRecoveryBody': 'Bebe 300 ml agua con una pizca de sal para equilibrio',
        'continueHydration': '💧 Continúa la hidratación',
        'alcoholRecoveryBody2': 'Otros 500 ml de agua te ayudarán a recuperarte más rápido',
        'morningRecoveryTitle': '☀️ Recuperación matutina',
        'morningRecoveryBody': 'Comienza el día con 500 ml agua y electrolitos',
        'testNotificationTitle': '🧪 Notificación de prueba',
        'testNotificationBody': 'Si ves esto - ¡las notificaciones instantáneas funcionan!',
        'scheduledTestTitle': '⏰ Prueba programada (1 min)',
        'scheduledTestBody': 'Esta notificación fue programada hace 1 minuto. ¡La programación funciona!',
      }
    };
    
    return localizedStrings[locale]?[key] ?? localizedStrings['en']?[key] ?? key;
  }
}

// ==================== SETTINGS CLASS ====================

class ReminderSettings {
  final bool enabled;
  final int frequency;
  final String morningTime;
  final String eveningTime;
  final bool postCoffee;
  final bool heatWarnings;
  final bool postAlcohol;
  
  ReminderSettings({
    required this.enabled,
    required this.frequency,
    required this.morningTime,
    required this.eveningTime,
    required this.postCoffee,
    required this.heatWarnings,
    required this.postAlcohol,
  });
}