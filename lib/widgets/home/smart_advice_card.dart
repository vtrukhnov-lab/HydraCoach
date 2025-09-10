// lib/widgets/home/smart_advice_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/hydration_provider.dart';
import '../../services/alcohol_service.dart';
import '../../services/hri_service.dart';
import '../../services/weather_service.dart';
import '../../services/units_service.dart';
import '../../l10n/app_localizations.dart';
import '../ion_character.dart';

class SmartAdviceCard extends StatelessWidget {
  const SmartAdviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    final hri = Provider.of<HRIService>(context, listen: false);
    final weather = Provider.of<WeatherService>(context, listen: false);
    final units = Provider.of<UnitsService>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    final advice = _getSmartAdvice(provider, alcohol, hri, weather, units, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: advice['tone'] as Color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: advice['border'] as Color),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: IonCharacter(
                size: 55,
                mood: advice['ionMood'] as IonMood,
                showGlow: false,
                showElectrolytes: false,
                hydrationLevel: advice['ionHydrationLevel'] as HydrationLevel,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    advice['title'] as String,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: advice['border'] as Color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    advice['body'] as String,
                    style: TextStyle(fontSize: 13.5, color: Colors.grey[800], height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 450.ms),
    );
  }

  Map<String, dynamic> _getSmartAdvice(
    HydrationProvider provider,
    AlcoholService alcoholService,
    HRIService hriService,
    WeatherService weatherService,
    UnitsService units,
    AppLocalizations l10n,
  ) {
    final waterRatio = provider.goals.waterOpt > 0 ? provider.totalWaterToday / provider.goals.waterOpt : 0.0;
    final sodiumRatio = provider.goals.sodium > 0 ? provider.totalSodiumToday / provider.goals.sodium : 0.0;

    if (waterRatio > 2.0) {
      final volumeToShow = units.formatVolume(500);
      return {
        'title': l10n.adviceOverhydrationSevere,
        'body': 'Pause 60-90 minutes. Add electrolytes: $volumeToShow with 500-1000 mg sodium.',
        'tone': const Color(0xFFFFEBEE),
        'border': Colors.red.shade300,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.high,
      };
    }

    if (waterRatio > 1.2) {
      return {
        'title': l10n.adviceOverhydration,
        'body': l10n.adviceOverhydrationBody,
        'tone': Colors.orange.shade50,
        'border': Colors.orange.shade300,
        'ionMood': IonMood.thinking,
        'ionHydrationLevel': HydrationLevel.high,
      };
    }

    if (alcoholService.totalStandardDrinks > 0) {
      final volumeToShow = units.formatVolume(400);
      return {
        'title': l10n.adviceAlcoholRecovery,
        'body': 'No more alcohol today. Drink $volumeToShow in small portions and add sodium.',
        'tone': Colors.orange.shade50,
        'border': Colors.orange.shade300,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    if (sodiumRatio < 0.7) {
      final sodiumNeed = (provider.goals.sodium - provider.totalSodiumToday).clamp(300, 1000);
      return {
        'title': l10n.adviceLowSodium,
        'body': l10n.adviceLowSodiumBody(sodiumNeed),
        'tone': Colors.amber.shade50,
        'border': Colors.amber.shade300,
        'ionMood': IonMood.thinking,
        'ionHydrationLevel': HydrationLevel.normal,
      };
    }

    if (waterRatio < 0.5) {
      final volumeToShow = units.formatVolume(400);
      return {
        'title': l10n.adviceDehydration,
        'body': 'Drink $volumeToShow ${l10n.water.toLowerCase()}.',
        'tone': Colors.blue.shade50,
        'border': Colors.blue.shade300,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    if (hriService.currentHRI >= 60) {
      final volumeToShow = units.formatVolume(400);
      return {
        'title': l10n.adviceHighRisk,
        'body': 'Urgently drink water with electrolytes ($volumeToShow) and reduce activity.',
        'tone': const Color(0xFFFFF3E0),
        'border': Colors.deepOrange.shade300,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    final waterNeed = (provider.goals.waterOpt - provider.totalWaterToday).clamp(200, 800);
    final displayNeed = units.formatVolume(waterNeed.toInt(), hideUnit: true);
    return {
      'title': l10n.adviceAllGood,
      'body': 'Keep the pace. Target: ~$displayNeed ${units.volumeUnit} more to goal.',
      'tone': Colors.green.shade50,
      'border': Colors.green.shade300,
      'ionMood': IonMood.happy,
      'ionHydrationLevel': HydrationLevel.perfect,
    };
  }
}