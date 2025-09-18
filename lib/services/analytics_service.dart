// lib/services/analytics_service.dart

import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'consent_service.dart';

/// Unified Analytics Service that combines Firebase Analytics and AppsFlyer
/// Centralizes all tracking events and user properties
/// Now with GDPR consent management through Usercentrics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Firebase Analytics
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // AppsFlyer
  AppsflyerSdk? _appsflyerSdk;
  bool _isAppsFlyerInitialized = false;
  
  // Consent Service
  final ConsentService _consentService = ConsentService();
  
  // Tracking if AppsFlyer was delayed due to consent
  bool _isWaitingForConsent = false;
  String? _pendingDevKey;
  String? _pendingAppIdIOS;
  String? _pendingAppIdAndroid;
  String? _pendingCustomerUserId;
  bool _pendingDelayStartUntilATT = false;
  bool _pendingDebug = false;
  
  /// Get observer for navigation (if you use it)
  FirebaseAnalyticsObserver get observer => 
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Initialize AppsFlyer with proper keys
  /// Now checks for user consent before initializing AppsFlyer
  Future<void> init({
    required String devKey,
    required String appIdIOS,
    required String appIdAndroid,
    String? customerUserId,
    bool delayStartUntilATT = false,
    bool debug = false,
  }) async {
    if (_isAppsFlyerInitialized) {
      if (kDebugMode) {
        print('📊 AppsFlyer already initialized');
      }
      return;
    }

    // Store parameters in case we need to wait for consent
    _pendingDevKey = devKey;
    _pendingAppIdIOS = appIdIOS;
    _pendingAppIdAndroid = appIdAndroid;
    _pendingCustomerUserId = customerUserId;
    _pendingDelayStartUntilATT = delayStartUntilATT;
    _pendingDebug = debug;

    // Initialize consent service first
    if (!_consentService.isInitialized) {
      await _consentService.initialize();
    }

    // Set up listener for consent changes
    _consentService.onConsentChanged = (hasConsent) {
      if (hasConsent && _isWaitingForConsent) {
        _initializeAppsFlyerAfterConsent();
      } else if (!hasConsent && _isAppsFlyerInitialized) {
        _disableAppsFlyer();
      }
    };

    // Check if we have consent to initialize AppsFlyer
    final hasConsent = _consentService.hasConsent;
    
    if (hasConsent) {
      // We have consent, initialize AppsFlyer immediately
      await _initializeAppsFlyer(
        devKey: devKey,
        appIdIOS: appIdIOS,
        appIdAndroid: appIdAndroid,
        customerUserId: customerUserId,
        delayStartUntilATT: delayStartUntilATT,
        debug: debug,
      );
    } else {
      // No consent yet, wait for it
      _isWaitingForConsent = true;
      if (kDebugMode) {
        print('⏸️ AppsFlyer initialization delayed - waiting for user consent');
      }
    }

    // Always initialize Firebase Analytics (it's considered essential)
    await initialize();
  }

  /// Internal method to initialize AppsFlyer after consent is given
  Future<void> _initializeAppsFlyerAfterConsent() async {
    if (!_isWaitingForConsent || _pendingDevKey == null) return;
    
    _isWaitingForConsent = false;
    
    await _initializeAppsFlyer(
      devKey: _pendingDevKey!,
      appIdIOS: _pendingAppIdIOS ?? '',
      appIdAndroid: _pendingAppIdAndroid ?? '',
      customerUserId: _pendingCustomerUserId,
      delayStartUntilATT: _pendingDelayStartUntilATT,
      debug: _pendingDebug,
    );
  }

  /// Internal method to actually initialize AppsFlyer
  Future<void> _initializeAppsFlyer({
    required String devKey,
    required String appIdIOS,
    required String appIdAndroid,
    String? customerUserId,
    bool delayStartUntilATT = false,
    bool debug = false,
  }) async {
    // Use the real key from environment or the one provided
    final actualDevKey = devKey.isNotEmpty ? devKey : 'QEcQmWqRcQNEtyk6iqNKNX';
    
    if (actualDevKey.isEmpty || actualDevKey == 'YOUR_DEV_KEY_HERE') {
      if (kDebugMode) {
        print('⚠️ AppsFlyer Dev Key not configured');
      }
      return;
    }

    // Prepare appId based on platform
    String? appIdToUse;
    if (Platform.isIOS && appIdIOS.isNotEmpty) {
      appIdToUse = appIdIOS;
    }
    
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: actualDevKey,
      appId: appIdToUse ?? '',  // Обеспечиваем что всегда String
      showDebug: debug,
      timeToWaitForATTUserAuthorization: delayStartUntilATT ? 10.0 : 0.0,
    );

    _appsflyerSdk = AppsflyerSdk(options);

    // Set up callbacks
    _appsflyerSdk!.onInstallConversionData((res) {
      if (kDebugMode) {
        print('📊 AppsFlyer onInstallConversionData: $res');
      }
      _handleConversionData(res);
    });

    _appsflyerSdk!.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          if (kDebugMode) {
            print('📊 AppsFlyer Deep link found: ${dp.deepLink}');
          }
          _handleDeepLink(dp.deepLink);
          break;
        case Status.NOT_FOUND:
          if (kDebugMode) {
            print('📊 AppsFlyer Deep link not found');
          }
          break;
        case Status.ERROR:
          if (kDebugMode) {
            print('❌ AppsFlyer Deep link error: ${dp.error}');
          }
          break;
        case Status.PARSE_ERROR:
          if (kDebugMode) {
            print('❌ AppsFlyer Deep link parsing error');
          }
          break;
      }
    });

    // Set customer user ID if provided (note: this method doesn't return a Future)
    if (customerUserId != null && customerUserId.isNotEmpty) {
      _appsflyerSdk!.setCustomerUserId(customerUserId);
    }

    // Initialize SDK
    await _appsflyerSdk!.initSdk(
      registerConversionDataCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _isAppsFlyerInitialized = true;
    
    if (kDebugMode) {
      print('✅ AppsFlyer initialized successfully with user consent');
      if (customerUserId != null) {
        print('📊 AppsFlyer Customer User ID: $customerUserId');
      }
    }
  }

  /// Disable AppsFlyer when consent is revoked
  void _disableAppsFlyer() {
    if (_isAppsFlyerInitialized && _appsflyerSdk != null) {
      _appsflyerSdk!.stop(true);
      if (kDebugMode) {
        print('🛑 AppsFlyer disabled - user revoked consent');
      }
    }
  }

  /// Initialize Firebase Analytics
  Future<void> initialize() async {
    if (kDebugMode) {
      print('📊 Firebase Analytics Service initialized');
    }
    
    // Set default user properties
    await setDefaultUserProperties();
  }

  /// Handle conversion data from AppsFlyer
  void _handleConversionData(Map<String, dynamic> data) {
    final status = data['af_status'];
    final mediaSource = data['media_source'];
    final campaign = data['campaign'];
    
    if (kDebugMode) {
      print('📊 Attribution - Status: $status, Source: $mediaSource, Campaign: $campaign');
    }
  }

  /// Handle deep links from AppsFlyer
  void _handleDeepLink(DeepLink? deepLinkObj) {
    if (deepLinkObj == null) return;
    
    final deepLinkValue = deepLinkObj.deepLinkValue;
    final mediaSource = deepLinkObj.mediaSource;
    final campaign = deepLinkObj.campaign;
    
    if (kDebugMode) {
      print('📊 Deep Link - Value: $deepLinkValue, Source: $mediaSource, Campaign: $campaign');
    }
  }

  /// Set default user properties
  Future<void> setDefaultUserProperties() async {
    try {
      await _analytics.setUserId(id: null); // Set later if needed
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error setting user properties: $e');
      }
    }
  }

  // ==================== UNIFIED LOGGING ====================
  
  /// Main unified logging method - sends to both Firebase and AppsFlyer
  /// Now checks consent before sending to AppsFlyer
  Future<void> log(String eventName, [Map<String, dynamic>? parameters]) async {
    // Send to Firebase Analytics (always, as it's essential)
    await logEvent(name: eventName, parameters: parameters);
    
    // Send to AppsFlyer only if initialized AND we have consent
    if (_isAppsFlyerInitialized && _appsflyerSdk != null && _consentService.hasConsent) {
      await _appsflyerSdk!.logEvent(eventName, parameters ?? {});
      
      if (kDebugMode) {
        print('📊 AppsFlyer Event: $eventName');
        if (parameters != null) {
          print('   Parameters: $parameters');
        }
      }
    } else if (_isAppsFlyerInitialized && !_consentService.hasConsent) {
      if (kDebugMode) {
        print('⏸️ AppsFlyer Event blocked (no consent): $eventName');
      }
    }
  }

  // ==================== USER PROPERTIES ====================
  
  /// Set diet mode
  Future<void> setDietMode(String mode) async {
    await _analytics.setUserProperty(name: 'diet_mode', value: mode);
  }

  /// Set subscription status
  Future<void> setProStatus(bool isPro) async {
    await _analytics.setUserProperty(name: 'is_pro', value: isPro.toString());
  }

  /// Set notification status
  Future<void> setNotificationStatus(bool enabled) async {
    await _analytics.setUserProperty(name: 'notifications_enabled', value: enabled.toString());
  }

  /// Set user country
  Future<void> setUserCountry(String countryCode) async {
    await _analytics.setUserProperty(name: 'country', value: countryCode);
  }

  // ==================== SCREEN VIEW EVENTS ====================
  
  /// Universal method for logging screen views
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
    
    // Also send to AppsFlyer (with consent check)
    await log('screen_view', {
      'screen_name': screenName,
      'screen_class': screenClass ?? screenName,
    });
    
    if (kDebugMode) {
      print('📊 Screen view: $screenName');
    }
  }

  /// General method for logging events (Firebase only)
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    // Convert parameters to correct type for Firebase
    final Map<String, Object>? firebaseParams = parameters?.map(
      (key, value) => MapEntry(key, value as Object),
    );
    
    await _analytics.logEvent(
      name: name,
      parameters: firebaseParams,
    );
    
    if (kDebugMode) {
      print('📊 Firebase Event: $name');
      if (parameters != null) {
        print('   Parameters: $parameters');
      }
    }
  }

  // ==================== NOTIFICATION EVENTS ====================
  
  /// Notification scheduled
  Future<void> logNotificationScheduled({
    required String type,
    required DateTime scheduledTime,
    int? delayMinutes,
  }) async {
    final params = {
      'notification_type': type,
      'scheduled_hour': scheduledTime.hour,
      'delay_minutes': delayMinutes ?? 0,
      'day_of_week': scheduledTime.weekday,
    };
    
    await log('notification_scheduled', params);
    
    if (kDebugMode) {
      print('📊 Event: notification_scheduled - $type at ${scheduledTime.hour}:${scheduledTime.minute}');
    }
  }

  /// Notification sent
  Future<void> logNotificationSent({
    required String type,
    bool isScheduled = false,
  }) async {
    await log('notification_sent', {
      'notification_type': type,
      'is_scheduled': isScheduled,
      'hour': DateTime.now().hour,
    });
    
    if (kDebugMode) {
      print('📊 Event: notification_sent - $type');
    }
  }

  /// Notification opened
  Future<void> logNotificationOpened({
    required String type,
    String? action,
  }) async {
    await log('notification_opened', {
      'notification_type': type,
      'action': action ?? 'none',
    });
  }

  /// Notification error
  Future<void> logNotificationError({
    required String type,
    required String error,
  }) async {
    await log('notification_error', {
      'notification_type': type,
      'error_message': error.substring(0, 100), // Limit length
    });
  }

  /// Duplicate notification detected
  Future<void> logNotificationDuplicate({
    required String type,
    required int count,
  }) async {
    await log('notification_duplicate', {
      'notification_type': type,
      'duplicate_count': count,
    });
    
    if (kDebugMode) {
      print('⚠️ Duplicate notification detected: $type x$count');
    }
  }

  // ==================== CORE TRACKING EVENTS ====================
  
  /// Log water intake - IMPORTANT EVENT FOR APPSFLYER
  Future<void> logWaterIntake({
    required int amount,
    required String source,
  }) async {
    final params = {
      'amount_ml': amount,
      'source': source, // 'quick', 'manual', 'preset'
      'hour': DateTime.now().hour,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await log('water_logged', params);
    
    // Also log specific AppsFlyer event (with consent check)
    if (_isAppsFlyerInitialized && _appsflyerSdk != null && _consentService.hasConsent) {
      await _appsflyerSdk!.logEvent('water_intake', {
        'af_quantity': amount.toDouble(),
        'af_description': 'ml',
        'source': source,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Log electrolyte intake
  Future<void> logElectrolyteIntake({
    required String type,
    required int amount,
  }) async {
    await log('electrolyte_logged', {
      'type': type, // 'sodium', 'potassium', 'magnesium'
      'amount_mg': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log coffee intake
  Future<void> logCoffeeIntake({
    required int cups,
  }) async {
    await log('coffee_logged', {
      'cups': cups,
      'hour': DateTime.now().hour,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Log alcohol intake
  Future<void> logAlcoholIntake({
    required double standardDrinks,
    required String type,
  }) async {
    await log('alcohol_logged', {
      'standard_drinks': standardDrinks,
      'type': type, // 'beer', 'wine', 'spirits', 'cocktail'
      'hour': DateTime.now().hour,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== GOAL & PROGRESS EVENTS ====================
  
  /// Goal reached - IMPORTANT EVENT FOR APPSFLYER
  Future<void> logGoalReached({
    required String goalType,
    required double percentage,
  }) async {
    final params = {
      'goal_type': goalType, // 'water', 'sodium', 'potassium', 'magnesium'
      'percentage': percentage.round(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await log('daily_goal_reached', params);
    
    // Special handling for water goal (with consent check)
    if (goalType == 'water' && _isAppsFlyerInitialized && _appsflyerSdk != null && _consentService.hasConsent) {
      await _appsflyerSdk!.logEvent('hydration_goal_achieved', {
        'completion_percentage': percentage.round(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// HRI status change
  Future<void> logHRIStatusChange({
    required int fromValue,
    required int toValue,
    required String status,
  }) async {
    await log('hri_status_changed', {
      'from_value': fromValue,
      'to_value': toValue,
      'status': status, // 'green', 'yellow', 'red'
      'direction': toValue > fromValue ? 'worse' : 'better',
    });
  }

  /// Hydration status
  Future<void> logHydrationStatus({
    required String status,
  }) async {
    await log('hydration_status', {
      'status': status, // 'normal', 'dehydrated', 'diluted', 'low_salt'
      'hour': DateTime.now().hour,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== SUBSCRIPTION EVENTS - CRITICAL FOR APPSFLYER ROI360 ====================
  
  /// Paywall shown
  Future<void> logPaywallShown({
    required String source,
    String? variant,
  }) async {
    await log('paywall_shown', {
      'source': source, // 'onboarding', 'settings', 'feature_gate'
      'variant': variant ?? 'default',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Paywall dismissed
  Future<void> logPaywallDismissed({
    required String source,
  }) async {
    await log('paywall_dismissed', {
      'source': source,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Subscription started - CRITICAL FOR APPSFLYER ROI360
  Future<void> logSubscriptionStarted({
    required String product,
    required bool isTrial,
    double? price,
    String? currency,
  }) async {
    final params = {
      'product': product, // 'monthly', 'annual', 'lifetime'
      'is_trial': isTrial,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    // Add price info if available
    if (price != null) params['price'] = price;
    if (currency != null) params['currency'] = currency;
    
    await log('subscription_started', params);
    
    // Special AppsFlyer revenue event for ROI360 (with consent check)
    if (_isAppsFlyerInitialized && _appsflyerSdk != null && _consentService.hasConsent && price != null && currency != null) {
      await _appsflyerSdk!.logEvent('af_subscribe', {
        'af_revenue': price,
        'af_currency': currency,
        'af_content_id': product,
        'is_trial': isTrial,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// PRO feature gate hit
  Future<void> logProFeatureGate({
    required String feature,
  }) async {
    await log('pro_feature_gate_hit', {
      'feature': feature, // 'smart_reminders', 'csv_export', etc
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== ENGAGEMENT EVENTS ====================
  
  /// Report viewed
  Future<void> logReportViewed({
    required String type,
  }) async {
    await log('report_viewed', {
      'type': type, // 'daily', 'weekly'
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// CSV exported
  Future<void> logCSVExported() async {
    await log('csv_exported', {
      'date': DateTime.now().toIso8601String().split('T')[0],
    });
  }

  /// Settings changed
  Future<void> logSettingsChanged({
    required String setting,
    required dynamic value,
  }) async {
    await log('settings_changed', {
      'setting': setting,
      'value': value.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Diet mode changed
  Future<void> logDietModeChanged({
    required String from,
    required String to,
  }) async {
    await log('diet_mode_changed', {
      'from': from,
      'to': to,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Also update user property
    await setDietMode(to);
  }

  // ==================== ONBOARDING EVENTS ====================
  
  /// Onboarding start
  Future<void> logOnboardingStart() async {
    await log('onboarding_start', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Onboarding complete
  Future<void> logOnboardingComplete() async {
    await log('onboarding_complete', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Onboarding skip
  Future<void> logOnboardingSkip({
    required int step,
  }) async {
    await log('onboarding_skip', {
      'step': step,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== APP LIFECYCLE ====================
  
  /// App opened
  Future<void> logAppOpen() async {
    await log('app_open', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Session
  Future<void> logSession({
    required int durationSeconds,
  }) async {
    await log('session', {
      'duration_seconds': durationSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== DEBUG HELPERS ====================
  
  /// Test event for verification
  Future<void> logTestEvent() async {
    await log('test_event', {
      'timestamp': DateTime.now().toIso8601String(),
      'debug': kDebugMode,
    });
    
    if (kDebugMode) {
      print('📊 Test event sent to Analytics');
    }
  }

  /// Enable/disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
    
    // Also stop/start AppsFlyer (note: stop() doesn't return a Future)
    if (_isAppsFlyerInitialized && _appsflyerSdk != null) {
      _appsflyerSdk!.stop(!enabled);
    }
  }

  /// Get AppsFlyer ID (for debugging)
  Future<String?> getAppsFlyerId() async {
    if (!_isAppsFlyerInitialized || _appsflyerSdk == null) return null;
    return await _appsflyerSdk!.getAppsFlyerUID();
  }

  /// Set user email for AppsFlyer (note: doesn't return a Future)
  Future<void> setUserEmail(String email) async {
    if (_isAppsFlyerInitialized && _appsflyerSdk != null) {
      _appsflyerSdk!.setUserEmails([email]);
    }
  }

  /// Set customer user ID for AppsFlyer (note: doesn't return a Future)
  Future<void> setCustomerUserId(String userId) async {
    if (_isAppsFlyerInitialized && _appsflyerSdk != null) {
      _appsflyerSdk!.setCustomerUserId(userId);
    }
  }
  
  // ==================== ACHIEVEMENT EVENTS ====================

  /// Achievement unlocked
  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
    required String category,
    required int rewardPoints,
  }) async {
    await log('achievement_unlocked', {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
      'category': category,
      'reward_points': rewardPoints,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('📊 Achievement unlocked: $achievementName');
    }
  }

  /// Achievements screen view
  Future<void> logAchievementsScreenView() async {
    await logScreenView(
      screenName: 'achievements',
      screenClass: 'AchievementsScreen',
    );
    
    if (kDebugMode) {
      print('📊 Achievements screen viewed');
    }
  }

  /// Achievement viewed (simplified version for achievements_screen.dart)
  Future<void> logAchievementViewed({
    required String achievementId,
    required String achievementName,
    required String category,
    required bool isUnlocked,
  }) async {
    await log('achievement_details_viewed', {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
      'category': category,
      'is_unlocked': isUnlocked,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    if (kDebugMode) {
      print('📊 Achievement viewed: $achievementName');
    }
  }

  /// Achievement details viewed (full version)
  Future<void> logAchievementDetailsViewed({
    required String achievementId,
    required String achievementName,
    required bool isUnlocked,
  }) async {
    await log('achievement_details_viewed', {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
      'is_unlocked': isUnlocked,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // ==================== CONSENT MANAGEMENT ====================
  
  /// Check if we have consent for analytics
  bool get hasAnalyticsConsent => _consentService.hasConsent;
  
  /// Check if consent service is initialized
  bool get isConsentInitialized => _consentService.isInitialized;
  
  /// Re-enable AppsFlyer if consent is given after initialization
  Future<void> checkAndEnableAppsFlyer() async {
    if (_isWaitingForConsent && _consentService.hasConsent) {
      await _initializeAppsFlyerAfterConsent();
    }
  }
}