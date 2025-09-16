// lib/widgets/common/volume_selection_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../services/units_service.dart';
import '../../data/catalog_item.dart';

/// Enhanced dialog for volume/serving selection with electrolyte support
class VolumeSelectionDialog extends StatefulWidget {
  final CatalogItem item;
  final Function(double volumeMl) onConfirm;
  final Function(double volumeMl) onSaveToFavorites;
  final String units;
  final bool showElectrolytes;
  final Color? sliderColor;

  const VolumeSelectionDialog({
    super.key,
    required this.item,
    required this.onConfirm,
    required this.onSaveToFavorites,
    required this.units,
    this.showElectrolytes = false,
    this.sliderColor,
  });

  /// Static method for easy showing
  static Future<void> show({
    required BuildContext context,
    required CatalogItem item,
    required Function(double volumeMl) onConfirm,
    required Function(double volumeMl) onSaveToFavorites,
    required String units,
    bool showElectrolytes = false,
    Color? sliderColor,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return VolumeSelectionDialog(
          item: item,
          onConfirm: onConfirm,
          onSaveToFavorites: onSaveToFavorites,
          units: units,
          showElectrolytes: showElectrolytes,
          sliderColor: sliderColor,
        );
      },
    );
  }

  @override
  State<VolumeSelectionDialog> createState() => _VolumeSelectionDialogState();
}

class _VolumeSelectionDialogState extends State<VolumeSelectionDialog> {
  late double sliderVolume;
  late double minVolume;
  late double maxVolume;

  @override
  void initState() {
    super.initState();
    _initializeVolumes();
  }

  void _initializeVolumes() {
    // Set min/max based on type
    if (widget.showElectrolytes) {
      minVolume = widget.units == 'imperial' ? 1.0 : 30.0;
      maxVolume = widget.units == 'imperial' ? 40.0 : 1000.0;
    } else {
      minVolume = widget.units == 'imperial' ? 4.0 : 100.0;
      maxVolume = widget.units == 'imperial' ? 40.0 : 1000.0;
    }

    // Safe initialization of slider value
    try {
      final defaultVol = widget.item.getDefaultVolume(widget.units);
      
      // Validate the value
      if (defaultVol == null || 
          defaultVol.isNaN || 
          defaultVol.isInfinite || 
          defaultVol <= 0) {
        // Use sensible default
        sliderVolume = _getDefaultVolume();
      } else {
        sliderVolume = defaultVol.toDouble();
      }
    } catch (e) {
      print('Error getting default volume: $e');
      sliderVolume = _getDefaultVolume();
    }
    
    // Ensure value is within bounds
    sliderVolume = sliderVolume.clamp(minVolume, maxVolume);
  }

  double _getDefaultVolume() {
    // Return sensible defaults based on units
    if (widget.units == 'imperial') {
      return 8.0; // 8 oz
    } else {
      return 250.0; // 250 ml
    }
  }

  double getVolumeMl() {
    if (widget.units == 'imperial') {
      return sliderVolume * 29.5735;
    }
    return sliderVolume;
  }

  double getHydrationValue() {
    final hydration = widget.item.properties['hydration'] as num? ?? 1.0;
    return getVolumeMl() * hydration.toDouble();
  }

  Map<String, int> getElectrolytes() {
    if (!widget.showElectrolytes) {
      return {'sodium': 0, 'potassium': 0, 'magnesium': 0};
    }
    
    try {
      final baseVolume = widget.item.getDefaultVolume(widget.units)?.toDouble() ?? _getDefaultVolume();
      if (baseVolume <= 0) {
        return {'sodium': 0, 'potassium': 0, 'magnesium': 0};
      }
      
      final multiplier = sliderVolume / baseVolume;
      
      return {
        'sodium': ((widget.item.properties['sodium'] ?? 0) * multiplier).round(),
        'potassium': ((widget.item.properties['potassium'] ?? 0) * multiplier).round(),
        'magnesium': ((widget.item.properties['magnesium'] ?? 0) * multiplier).round(),
      };
    } catch (e) {
      print('Error calculating electrolytes: $e');
      return {'sodium': 0, 'potassium': 0, 'magnesium': 0};
    }
  }

  double getTotalSugar() {
    try {
      final baseVolume = widget.item.getDefaultVolume(widget.units)?.toDouble() ?? _getDefaultVolume();
      if (baseVolume <= 0) return 0.0;
      
      final baseSugar = (widget.item.properties['sugar'] ?? 0.0) as num;
      return (baseSugar * sliderVolume / baseVolume);
    } catch (e) {
      print('Error calculating sugar: $e');
      return 0.0;
    }
  }

  double getCaffeine() {
    try {
      final baseVolume = widget.item.getDefaultVolume(widget.units)?.toDouble() ?? _getDefaultVolume();
      if (baseVolume <= 0) return 0.0;
      
      final baseCaffeine = (widget.item.properties['caffeineMgPer100ml'] ?? 0.0) as num;
      return (baseCaffeine * getVolumeMl() / 100);
    } catch (e) {
      print('Error calculating caffeine: $e');
      return 0.0;
    }
  }

  double getHRIImpact() {
    try {
      final volumeMl = getVolumeMl();
      final hydrationFactor = (widget.item.properties['hydration'] as num? ?? 1.0).toDouble();
      final effectiveVolume = volumeMl * hydrationFactor;
      
      // Base impact (negative is good)
      double impact = -(effectiveVolume / 2000.0 * 10);
      
      // Electrolyte bonus
      if (widget.showElectrolytes) {
        final electrolytes = getElectrolytes();
        final sodium = electrolytes['sodium'] ?? 0;
        if (sodium > 500) {
          impact -= 3;
        } else if (sodium > 0) {
          impact -= 1;
        }
      }
      
      // Sugar penalty
      final sugar = getTotalSugar();
      if (sugar > 50) {
        impact += (sugar - 50) * 0.2;
      } else if (sugar > 25) {
        impact += (sugar - 25) * 0.1;
      }
      
      // Caffeine impact
      final caffeine = getCaffeine();
      if (caffeine > 0) {
        impact += (caffeine * 0.02).clamp(0, 5);
      }
      
      return impact;
    } catch (e) {
      print('Error calculating HRI impact: $e');
      return 0.0;
    }
  }

  List<Color> getHRIGradientColors() {
    final impact = getHRIImpact();
    if (impact <= -5) {
      return [Colors.green.shade400, Colors.green.shade600];
    } else if (impact <= 0) {
      return [Colors.amber.shade400, Colors.amber.shade600];
    } else if (impact <= 5) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    } else {
      return [Colors.red.shade400, Colors.red.shade600];
    }
  }

  List<Color> getSugarGradientColors(double grams) {
    if (grams <= 5) {
      return [Colors.green.shade400, Colors.green.shade600];
    } else if (grams <= 15) {
      return [Colors.amber.shade400, Colors.amber.shade600];
    } else if (grams <= 30) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    } else {
      return [Colors.red.shade400, Colors.red.shade600];
    }
  }

  bool get hasSignificantElectrolytes {
    if (!widget.showElectrolytes) return false;
    final e = getElectrolytes();
    return (e['sodium'] ?? 0) > 0 || 
           (e['potassium'] ?? 0) > 0 || 
           (e['magnesium'] ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final itemName = widget.item.getName(l10n);
    final hydration = (widget.item.properties['hydration'] as num? ?? 1.0);
    final sliderActiveColor = widget.sliderColor ?? Colors.blue;
    final caffeine = getCaffeine();
    final sugar = getTotalSugar();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Text(
            widget.item.icon as String? ?? '🥤',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(fontSize: 18),
                ),
                if (!widget.showElectrolytes && hydration != 1.0)
                  Text(
                    '${(hydration * 100).toInt()}% ${l10n.hydration.toLowerCase()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Volume slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.volume,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${sliderVolume.toStringAsFixed(0)} ${widget.units == 'imperial' ? 'oz' : 'ml'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: sliderActiveColor,
                    inactiveTrackColor: sliderActiveColor.withOpacity(0.2),
                    thumbColor: sliderActiveColor,
                    overlayColor: sliderActiveColor.withOpacity(0.1),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  ),
                  child: Slider(
                    value: sliderVolume.clamp(minVolume, maxVolume),
                    min: minVolume,
                    max: maxVolume,
                    divisions: widget.units == 'imperial' ? 36 : 90,
                    onChanged: (value) {
                      setState(() => sliderVolume = value);
                      HapticFeedback.selectionClick();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Metrics display
            Row(
              children: [
                // HRI Impact card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: getHRIGradientColors(),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${getHRIImpact() > 0 ? "+" : ""}${getHRIImpact().toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.hriImpact,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Sugar card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: getSugarGradientColors(sugar),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cake,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sugar.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          l10n.gramsSugar ?? 'g sugar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Electrolyte content
            if (widget.showElectrolytes && hasSignificantElectrolytes) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildElectrolyteMetric(
                      'Na',
                      getElectrolytes()['sodium']!,
                      Colors.blue,
                    ),
                    _buildElectrolyteMetric(
                      'K',
                      getElectrolytes()['potassium']!,
                      Colors.green,
                    ),
                    _buildElectrolyteMetric(
                      'Mg',
                      getElectrolytes()['magnesium']!,
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
            
            // Caffeine display
            if (caffeine > 0.5) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 16, color: Colors.brown.shade700),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.caffeine}: ${caffeine.round()} mg',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add button
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onConfirm(getVolumeMl());
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: sliderActiveColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Save to Favorites button
            SizedBox(
              width: double.infinity,
              height: 53,
              child: OutlinedButton.icon(
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  await widget.onSaveToFavorites(getVolumeMl());
                },
                icon: const Icon(Icons.star_border),
                label: Text(l10n.saveToFavorites ?? 'Save to favorites'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.amber[700],
                  side: BorderSide(color: Colors.amber[600]!, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElectrolyteMetric(String label, int value, Color color) {
    if (value == 0) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$label mg',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}