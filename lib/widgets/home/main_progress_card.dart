// lib/widgets/home/main_progress_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/hydration_provider.dart';
import '../../services/units_service.dart';
import '../../l10n/app_localizations.dart';

class MainProgressCard extends StatelessWidget {
  const MainProgressCard({super.key});

  static const double kCardRadius = 20.0;
  static const double kCardPadding = 20.0;
  static const double kProgressRingSize = 140.0;
  static const double kProgressStrokeWidth = 12.0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final units = Provider.of<UnitsService>(context);
    final l10n = AppLocalizations.of(context);
    final progress = provider.getProgress();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 10),
      padding: const EdgeInsets.all(kCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
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
          _buildWaterRing(progress, units, l10n),
          const SizedBox(height: 20),
          _buildElectrolyteBar(l10n.sodium, progress['sodiumPercent'] ?? 0, (progress['sodium'] ?? 0).toInt(), provider.goals.sodium, Colors.orange, l10n),
          const SizedBox(height: 12),
          _buildElectrolyteBar(l10n.potassium, progress['potassiumPercent'] ?? 0, (progress['potassium'] ?? 0).toInt(), provider.goals.potassium, Colors.purple, l10n),
          const SizedBox(height: 12),
          _buildElectrolyteBar(l10n.magnesium, progress['magnesiumPercent'] ?? 0, (progress['magnesium'] ?? 0).toInt(), provider.goals.magnesium, Colors.pink, l10n),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildWaterRing(Map<String, double> progress, UnitsService units, AppLocalizations l10n) {
    final waterPercent = progress['waterPercent'] ?? 0;
    final waterAmount = progress['water'] ?? 0;
    final displayVolume = units.formatVolume(waterAmount.toInt());

    return Center(
      child: SizedBox(
        width: kProgressRingSize,
        height: kProgressRingSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: kProgressRingSize,
              height: kProgressRingSize,
              child: CircularProgressIndicator(
                value: (waterPercent / 100).clamp(0.0, 1.0),
                strokeWidth: kProgressStrokeWidth,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(_getWaterColor(waterPercent)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${waterPercent.toInt()}%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _getWaterColor(waterPercent))),
                Text(l10n.water, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(displayVolume, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 100.ms);
  }

  Widget _buildElectrolyteBar(String name, double percent, int current, int goal, Color color, AppLocalizations l10n) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (percent / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 20,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text('${percent.toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: percent > 50 ? Colors.white : color)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('$current/$goal ${l10n.mg}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Color _getWaterColor(double percent) {
    if (percent < 30) return Colors.red;
    if (percent < 60) return Colors.orange;
    if (percent < 100) return Colors.blue;
    if (percent < 120) return Colors.green;
    return Colors.deepOrange;
  }
}