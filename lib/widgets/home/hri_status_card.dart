// lib/widgets/home/hri_status_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/hri_service.dart';
import '../../services/weather_service.dart';
import '../../services/alcohol_service.dart';
import '../../providers/hydration_provider.dart';
import '../../l10n/app_localizations.dart';

class HRIStatusCard extends StatelessWidget {
  final bool isFasting;
  final String fastingSchedule;

  const HRIStatusCard({
    super.key,
    required this.isFasting,
    required this.fastingSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final hri = Provider.of<HRIService>(context);
    final provider = Provider.of<HydrationProvider>(context);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    final weather = Provider.of<WeatherService>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    final hriValue = hri.currentHRI.round();
    final status = provider.getHydrationStatus(l10n);
    final localizedHRIStatus = _getLocalizedHRIStatus(hri, l10n);
    final components = hri.getComponentsBreakdown();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.hydrationStatus, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(l10n.hydrationRiskIndex),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getHRIColor(hriValue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hri.hriZone.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getHRIColor(hriValue)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hriValue / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(_getHRIColor(hriValue)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$hriValue', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getHRIColor(hriValue))),
              const SizedBox(width: 8),
              Text(localizedHRIStatus, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _getHRIColor(hriValue))),
            ],
          ),
          if (_hasActiveFactors(components, alcohol, weather)) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(l10n.hriBreakdownTitle, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _buildActiveFactorChips(components, alcohol, weather, l10n),
            ),
          ],
          if (isFasting) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(l10n.fastingModeActive, style: TextStyle(fontSize: 12, color: Colors.purple[700], fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(fastingSchedule, style: TextStyle(fontSize: 12, color: Colors.purple[700], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  bool _hasActiveFactors(Map<String, double> components, AlcoholService alcohol, WeatherService weather) {
    return components['workouts']! > 0 ||
           components['caffeine']! > 0 ||
           alcohol.totalStandardDrinks > 0 ||
           weather.heatIndex != null;
  }

  List<Widget> _buildActiveFactorChips(Map<String, double> components, AlcoholService alcohol, WeatherService weather, AppLocalizations l10n) {
    final chips = <Widget>[];
    if (components['workouts']! > 0) chips.add(_buildFactorChip('${l10n.hriComponentWorkout} +${components['workouts']!.toInt()}', Icons.fitness_center, Colors.teal));
    if (weather.heatIndex != null) {
      final heatImpact = components['heat'] ?? 0;
      if (weather.heatIndex! < 27) chips.add(_buildFactorChip('${l10n.hriComponentHeat} OK', Icons.thermostat, Colors.green));
      else if (weather.heatIndex! < 32) chips.add(_buildFactorChip('${l10n.hriComponentHeat} +${heatImpact.toInt()}', Icons.wb_sunny, Colors.orange));
      else chips.add(_buildFactorChip('${l10n.hriComponentHeat} +${heatImpact.toInt()}', Icons.local_fire_department, Colors.red));
    }
    if (components['caffeine']! > 0) chips.add(_buildFactorChip('${l10n.hriComponentCaffeine} +${components['caffeine']!.toInt()}', Icons.coffee, Colors.brown));
    if (alcohol.totalStandardDrinks > 0) {
      final sd = alcohol.totalStandardDrinks;
      final alcoholImpact = components['alcohol'] ?? 0;
      chips.add(_buildFactorChip('${l10n.alcohol} ${sd.toStringAsFixed(1)} SD +${alcoholImpact.toInt()}', Icons.local_bar, Colors.red));
    }
    return chips;
  }

  Widget _buildFactorChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('Normal') || status.contains('Норма')) return Colors.green;
    if (status.contains('Low salt') || status.contains('Мало соли') || status.contains('Diluting') || status.contains('Разбавляешь')) return Colors.orange;
    if (status.contains('Under-hydrated') || status.contains('Недобор воды')) return Colors.red;
    return Colors.grey;
  }

  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }

  String _getLocalizedHRIStatus(HRIService hri, AppLocalizations l10n) {
    final hriValue = hri.currentHRI;
    if (hriValue <= 20) return l10n.hriStatusExcellent;
    if (hriValue <= 40) return l10n.hriStatusGood;
    if (hriValue <= 60) return l10n.hriStatusModerate;
    if (hriValue <= 80) return l10n.hriStatusHighRisk;
    return l10n.hriStatusCritical;
  }
}