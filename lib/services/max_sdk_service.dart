import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'appsflyer_config.dart';

/// Сервис для работы с MAX SDK (AppLovin).
/// Управляет рекламными блоками: Interstitial, Rewarded, Banner.
///
/// ВАЖНО: Требует нативной интеграции AppLovin MAX SDK на Android/iOS.
class MaxSdkService {
  static final MaxSdkService _instance = MaxSdkService._internal();
  factory MaxSdkService() => _instance;
  MaxSdkService._internal();

  static const MethodChannel _channel = MethodChannel('max_sdk');

  bool _isInitialized = false;
  MaxSdkConfig? _config;

  bool get isInitialized => _isInitialized;

  /// Инициализация MAX SDK
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _config = maxSdkConfig;

    if (!_config!.isComplete) {
      if (kDebugMode) {
        print('⚠️ MAX SDK ключ не настроен, пропускаем инициализацию');
      }
      return;
    }

    try {
      await _channel.invokeMethod<void>('initialize', <String, dynamic>{
        'sdkKey': _config!.sdkKey,
      });

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ MAX SDK инициализирован');
        print('   SDK Key: ${_config!.sdkKey}');
      }
    } on MissingPluginException {
      if (kDebugMode) {
        print('⚠️ MAX SDK нативная реализация не найдена');
        print('   Убедитесь, что добавили AppLovin MAX SDK на Android/iOS');
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('❌ Ошибка инициализации MAX SDK: $error');
        print(stackTrace);
      }
    }
  }

  /// Загрузка Interstitial рекламы
  Future<void> loadInterstitial() async {
    if (!_isInitialized) {
      if (kDebugMode) {
        print('⚠️ MAX SDK не инициализирован');
      }
      return;
    }

    try {
      final adUnitId = _getInterstitialAdUnitId();
      await _channel.invokeMethod<void>('loadInterstitial', {
        'adUnitId': adUnitId,
      });

      if (kDebugMode) {
        print('📱 MAX Interstitial загружается: $adUnitId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка загрузки Interstitial: $error');
      }
    }
  }

  /// Показ Interstitial рекламы
  Future<bool> showInterstitial() async {
    if (!_isInitialized) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('showInterstitial');
      return result ?? false;
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка показа Interstitial: $error');
      }
      return false;
    }
  }

  /// Загрузка Rewarded рекламы
  Future<void> loadRewarded() async {
    if (!_isInitialized) {
      return;
    }

    try {
      final adUnitId = _getRewardedAdUnitId();
      await _channel.invokeMethod<void>('loadRewarded', {
        'adUnitId': adUnitId,
      });

      if (kDebugMode) {
        print('💰 MAX Rewarded загружается: $adUnitId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка загрузки Rewarded: $error');
      }
    }
  }

  /// Показ Rewarded рекламы
  Future<bool> showRewarded() async {
    if (!_isInitialized) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('showRewarded');
      return result ?? false;
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка показа Rewarded: $error');
      }
      return false;
    }
  }

  /// Создание Banner рекламы
  Future<void> createBanner() async {
    if (!_isInitialized) {
      return;
    }

    try {
      final adUnitId = _getBannerAdUnitId();
      await _channel.invokeMethod<void>('createBanner', {
        'adUnitId': adUnitId,
      });

      if (kDebugMode) {
        print('📰 MAX Banner создается: $adUnitId');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка создания Banner: $error');
      }
    }
  }

  /// Показ Banner рекламы
  Future<void> showBanner() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('showBanner');
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка показа Banner: $error');
      }
    }
  }

  /// Скрытие Banner рекламы
  Future<void> hideBanner() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('hideBanner');
    } catch (error) {
      if (kDebugMode) {
        print('❌ Ошибка скрытия Banner: $error');
      }
    }
  }

  // ==================== ВНУТРЕННИЕ МЕТОДЫ ====================

  String _getInterstitialAdUnitId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return adMobAndroidConfig.interstitialId;
      case TargetPlatform.iOS:
        return adMobIosConfig.interstitialId;
      default:
        return '';
    }
  }

  String _getRewardedAdUnitId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return adMobAndroidConfig.rewardedId;
      case TargetPlatform.iOS:
        return adMobIosConfig.rewardedId;
      default:
        return '';
    }
  }

  String _getBannerAdUnitId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return adMobAndroidConfig.bannerId;
      case TargetPlatform.iOS:
        return adMobIosConfig.bannerId;
      default:
        return '';
    }
  }
}