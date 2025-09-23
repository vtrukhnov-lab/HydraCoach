/// Конфигурация AppsFlyer для отслеживания аттрибуции.
class AppsFlyerConfig {
  const AppsFlyerConfig({
    required this.devKey,
    required this.bundleId,
    required this.appId,
  });

  const AppsFlyerConfig.empty()
      : devKey = '',
        bundleId = '',
        appId = '';

  final String devKey;
  final String bundleId;
  final String? appId; // только для iOS

  bool get isComplete => devKey.isNotEmpty && bundleId.isNotEmpty;
}

/// Продакшн-конфигурация для Android (Google Play).
const AppsFlyerConfig appsFlyerAndroidConfig = AppsFlyerConfig(
  devKey: String.fromEnvironment(
    'APPSFLYER_DEV_KEY',
    defaultValue: 'QEcQmWqRcQNEtyk6iqNKNX',
  ),
  bundleId: String.fromEnvironment(
    'ANDROID_BUNDLE_ID',
    defaultValue: 'com.playcus.hydracoach',
  ),
  appId: null, // Android не требует App ID
);

/// Продакшн-конфигурация для iOS (App Store).
const AppsFlyerConfig appsFlyerIosConfig = AppsFlyerConfig(
  devKey: String.fromEnvironment(
    'APPSFLYER_DEV_KEY',
    defaultValue: 'QEcQmWqRcQNEtyk6iqNKNX',
  ),
  bundleId: String.fromEnvironment(
    'IOS_BUNDLE_ID',
    defaultValue: 'com.playcus.hydracoach',
  ),
  appId: String.fromEnvironment(
    'IOS_APP_ID',
    defaultValue: '6752772787',
  ),
);

/// AdMob конфигурация
class AdMobConfig {
  const AdMobConfig({
    required this.appId,
    required this.interstitialId,
    required this.rewardedId,
    required this.bannerId,
  });

  final String appId;
  final String interstitialId;
  final String rewardedId;
  final String bannerId;

  bool get isComplete =>
      appId.isNotEmpty &&
      interstitialId.isNotEmpty &&
      rewardedId.isNotEmpty &&
      bannerId.isNotEmpty;
}

/// AdMob конфигурация для Android
const AdMobConfig adMobAndroidConfig = AdMobConfig(
  appId: String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-5658037951569538~8152522725',
  ),
  interstitialId: String.fromEnvironment(
    'ADMOB_ANDROID_INTERSTITIAL_ID',
    defaultValue: 'ceab74e2fb53cbe2',
  ),
  rewardedId: String.fromEnvironment(
    'ADMOB_ANDROID_REWARDED_ID',
    defaultValue: '916df6209beb8007',
  ),
  bannerId: String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_ID',
    defaultValue: '356d0deda25f54dd',
  ),
);

/// AdMob конфигурация для iOS
const AdMobConfig adMobIosConfig = AdMobConfig(
  appId: String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: 'ca-app-pub-5658037951569538~8820120029',
  ),
  interstitialId: String.fromEnvironment(
    'ADMOB_IOS_INTERSTITIAL_ID',
    defaultValue: '9fad30996e03b5b8',
  ),
  rewardedId: String.fromEnvironment(
    'ADMOB_IOS_REWARDED_ID',
    defaultValue: '60795c12dadfad1e',
  ),
  bannerId: String.fromEnvironment(
    'ADMOB_IOS_BANNER_ID',
    defaultValue: '0612cee9830f108e',
  ),
);

/// MAX SDK конфигурация (одинаковая для всех платформ)
class MaxSdkConfig {
  const MaxSdkConfig({
    required this.sdkKey,
  });

  final String sdkKey;

  bool get isComplete => sdkKey.isNotEmpty;
}

const MaxSdkConfig maxSdkConfig = MaxSdkConfig(
  sdkKey: String.fromEnvironment(
    'MAX_SDK_KEY',
    defaultValue: '5AAhiuFzwRBZXL6NRkfMQIFE9TpJ-fX4qinXb1VVTh4_1ANSv1qJJ3TSWLnV_Jaq1LLcMr7rXCqTMC0FDqZXu6',
  ),
);