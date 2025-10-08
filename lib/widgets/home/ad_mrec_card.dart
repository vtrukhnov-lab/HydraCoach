// lib/widgets/home/ad_mrec_card.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:applovin_max/applovin_max.dart';

import '../../l10n/app_localizations.dart';
import '../../services/subscription_service.dart';
import '../../services/analytics_service.dart';
import '../../services/devtodev_analytics_service.dart';
import '../../screens/paywall_screen.dart';

/// MREC реклама карточка для free пользователей
/// Показывается после карточки электролитов
class AdMrecCard extends StatefulWidget {
  const AdMrecCard({super.key});

  @override
  State<AdMrecCard> createState() => _AdMrecCardState();
}

class _AdMrecCardState extends State<AdMrecCard> {
  static const String _adUnitId = '356d0deda25f54dd';
  bool _isAdLoaded = false;
  bool _isAdLoading = true;
  String? _adLoadError;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 MREC Card initialized with Ad Unit ID: $_adUnitId');

    // Устанавливаем таймер на 5 секунд для fallback (сокращено для лучшего UX)
    _fallbackTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isAdLoaded) {
        setState(() {
          _isAdLoading = false;
          _adLoadError = 'Timeout: Ad failed to load within 5 seconds';
        });
        debugPrint('⏰ MREC ad timeout - showing fallback');
      }
    });
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _onPremiumTap() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(source: 'ad_mrec_card'),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      // PRO активирован, карточка больше не нужна
      // Родительский виджет автоматически обновится через Provider
    }
  }

  /// Callback для отслеживания доходов от рекламы
  void _onAdRevenuePaid(MaxAd ad) {
    try {
      final analytics = AnalyticsService();
      final devToDev = DevToDevAnalyticsService();

      // Создаем дополнительные параметры согласно инструкции AppLovin MAX
      Map<String, dynamic> additionalParams = {
        'country':
            'US', // Можно получить через MaxSdk.getConfiguration().countryCode
        'ad_unit': ad.adUnitId,
        'ad_type': ad.adFormat.toString(),
        'placement': ad.placement ?? '',
      };

      // Логируем Ad Revenue в AppsFlyer через правильный API
      analytics.log('af_ad_revenue', {
        'af_mediation_network': 'AppLovin MAX',
        'af_currency': 'USD',
        'af_revenue': ad.revenue,
        'ad_unit_id': ad.adUnitId,
        'ad_format': ad.adFormat.toString(),
        'placement': ad.placement ?? '',
        'network_name': ad.networkName,
      });

      // Логируем Ad Revenue в DevToDev
      // ВАЖНО: Используйте этот метод только если НЕ настроена S2S интеграция
      // между AppLovin MAX и DevToDev!
      devToDev.adImpression(
        network: ad.networkName,
        revenue: ad.revenue,
        placement: ad.placement ?? 'mrec_default',
        unit: ad.adUnitId,
      );

      if (mounted) {
        debugPrint(
          '💰 MREC Ad Revenue tracked: \$${ad.revenue} from ${ad.networkName}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error tracking MREC ad revenue: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();
    final l10n = AppLocalizations.of(context);

    // Не показываем PRO пользователям
    if (subscription.isPro) {
      return const SizedBox.shrink();
    }

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade50, Colors.purple.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // MREC область (стандартный размер 300x250)
                Center(
                  child: Container(
                    width: 300, // MREC стандартная ширина
                    height: 250, // MREC стандартная высота
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade200,
                        width: 1,
                      ),
                    ),
                    child: _buildAdContent(),
                  ),
                ),

                const SizedBox(height: 16),

                // Текст
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.purple.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.sayGoodbyeToAds,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Кнопка Go Premium внизу
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _onPremiumTap,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      l10n.goPremium,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          curve: Curves.easeOutQuart,
        );
  }

  Widget _buildAdContent() {
    // Если реклама загружается, показываем MaxAdView
    if (_isAdLoading || _isAdLoaded) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaxAdView(
          adUnitId: _adUnitId,
          adFormat: AdFormat.mrec,
          listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {
              if (mounted) {
                _fallbackTimer
                    ?.cancel(); // Отменяем таймер при успешной загрузке
                setState(() {
                  _isAdLoaded = true;
                  _isAdLoading = false;
                  _adLoadError = null;
                });
                debugPrint('✅ MREC ad loaded successfully:');
                debugPrint('   Ad Unit ID: ${ad.adUnitId}');
                debugPrint('   Network: ${ad.networkName}');
                debugPrint('   Creative ID: ${ad.creativeId}');
                debugPrint('   DSP Name: ${ad.dspName}');

                // Логируем успешную загрузку
                try {
                  final analytics = AnalyticsService();
                  analytics.log('mrec_ad_loaded', {
                    'ad_unit_id': ad.adUnitId,
                    'network_name': ad.networkName,
                    'creative_id': ad.creativeId,
                    'dsp_name': ad.dspName,
                  });
                } catch (e) {
                  debugPrint('Failed to log MREC success: $e');
                }
              }
            },
            onAdLoadFailedCallback: (adUnitId, error) {
              if (mounted) {
                setState(() {
                  _isAdLoaded = false;
                  _isAdLoading = false;
                  _adLoadError = error.message;
                });
                debugPrint('❌ MREC ad failed to load:');
                debugPrint('   Ad Unit ID: $adUnitId');
                debugPrint('   Error Code: ${error.code}');
                debugPrint('   Error Message: ${error.message}');
                // Note: waterfallInfo and adLoadFailureInfo are not available in MaxError

                // Логируем в аналитику для отслеживания проблем
                try {
                  final analytics = AnalyticsService();
                  analytics.log('mrec_ad_load_failed', {
                    'error_code': error.code,
                    'error_message': error.message,
                    'ad_unit_id': adUnitId,
                  });
                } catch (e) {
                  debugPrint('Failed to log MREC error: $e');
                }
              }
            },
            onAdClickedCallback: (ad) {
              debugPrint('MREC ad clicked: ${ad.adUnitId}');
            },
            onAdExpandedCallback: (ad) {
              debugPrint('MREC ad expanded: ${ad.adUnitId}');
            },
            onAdCollapsedCallback: (ad) {
              debugPrint('MREC ad collapsed: ${ad.adUnitId}');
            },
            onAdRevenuePaidCallback: (ad) {
              _onAdRevenuePaid(ad);
            },
          ),
        ),
      );
    }

    // Если загрузка не удалась, показываем fallback
    return _showFallbackContent();
  }

  Widget _showFallbackContent() {
    final l10n = AppLocalizations.of(context);

    // Улучшенный fallback с анимацией и локализацией
    return InkWell(
      onTap: _onPremiumTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.purple.shade600,
              Colors.purple.shade700,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Фоновые звезды
            Positioned(
              top: 20,
              right: 30,
              child: Icon(
                Icons.star,
                color: Colors.white.withValues(alpha: 0.3),
                size: 24,
              ),
            ),
            Positioned(
              bottom: 30,
              left: 40,
              child: Icon(
                Icons.star,
                color: Colors.white.withValues(alpha: 0.2),
                size: 16,
              ),
            ),
            // Основной контент
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Анимированная иконка
                Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 40,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.1, 1.1),
                    )
                    .then()
                    .scale(
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(1.0, 1.0),
                    ),

                const SizedBox(height: 16),
                Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n?.removeAdsForever ?? 'Remove ads forever',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Маленькая кнопка upgrade
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    l10n?.upgrade ?? 'UPGRADE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
