// lib/widgets/home/ad_banner_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:applovin_max/applovin_max.dart';

import '../../l10n/app_localizations.dart';
import '../../services/subscription_service.dart';
import '../../services/analytics_service.dart';
import '../../screens/paywall_screen.dart';

/// Тонкий баннер 320x50 для показа выше HRI статуса
/// Показывается только для free пользователей
class AdBannerCard extends StatefulWidget {
  const AdBannerCard({super.key});

  @override
  State<AdBannerCard> createState() => _AdBannerCardState();
}

class _AdBannerCardState extends State<AdBannerCard> {
  static const String _adUnitId =
      '93ba29d40d0c9ed1'; // Banner Unit ID для Android
  bool _isAdLoaded = false;

  void _onPremiumTap() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(source: 'ad_banner_card'),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      // PRO активирован, карточка больше не нужна
    }
  }

  /// Callback для отслеживания доходов от рекламы
  void _onAdRevenuePaid(MaxAd ad) {
    try {
      final analytics = AnalyticsService();

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

      if (mounted) {
        debugPrint(
          '💰 Banner Ad Revenue tracked: \$${ad.revenue} from ${ad.networkName}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error tracking Banner ad revenue: $e');
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
      height: 60, // Немного больше чем 50 для padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildBannerContent(),
      ),
    );
  }

  Widget _buildBannerContent() {
    // Реальный баннер от AppLovin MAX
    return MaxAdView(
      adUnitId: _adUnitId,
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
            // Показываем fallback при ошибке
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && !_isAdLoaded) {
                _showFallbackBanner();
              }
            });
          }
        },
        onAdClickedCallback: (ad) {
          debugPrint('Banner ad clicked: ${ad.adUnitId}');
        },
        onAdExpandedCallback: (ad) {
          debugPrint('Banner ad expanded: ${ad.adUnitId}');
        },
        onAdCollapsedCallback: (ad) {
          debugPrint('Banner ad collapsed: ${ad.adUnitId}');
        },
        onAdRevenuePaidCallback: (ad) {
          _onAdRevenuePaid(ad);
        },
      ),
    );
  }

  Widget _showFallbackBanner() {
    // Fallback - тонкий баннер "Get Premium"
    return InkWell(
      onTap: _onPremiumTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.purple.shade400, Colors.purple.shade600],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Remove ads with Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
