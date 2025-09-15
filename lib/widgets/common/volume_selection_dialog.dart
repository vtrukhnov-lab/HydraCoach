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
    Key? key,
    required this.item,
    required this.onConfirm,
    required this.onSaveToFavorites,
    required this.units,
    this.showElectrolytes = false,
    this.sliderColor,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    sliderVolume = widget.item.getDefaultVolume(widget.units).toDouble();
  }

  // Get volume limits based on units and item type
  double get minVolume {
    // For electrolytes, allow smaller volumes
    if (widget.showElectrolytes) {
      return widget.units == 'imperial' ? 1.0 : 30.0;
    }
    return widget.units == 'imperial' ? 4.0 : 100.0;
  }

  double get maxVolume {
    // For electrolytes, may need larger volumes
    if (widget.showElectrolytes) {
      return widget.units == 'imperial' ? 40.0 : 1000.0;
    }
    return widget.units == 'imperial' ? 40.0 : 1000.0;
  }

  // Helper functions
  double getVolumeMl() {
    return widget.units == 'imperial' ? sliderVolume * 29.5735 : sliderVolume;
  }

  double getHydrationValue() {
    final hydration = widget.item.properties['hydration'] as num? ?? 1.0;
    return getVolumeMl() * hydration.toDouble();
  }

  // Calculate proportional electrolytes
  Map<String, int> getElectrolytes() {
    if (!widget.showElectrolytes) return {};
    
    final baseVolume = widget.item.getDefaultVolume(widget.units).toDouble();
    final multiplier = sliderVolume / baseVolume;
    
    return {
      'sodium': ((widget.item.properties['sodium'] ?? 0) * multiplier).round(),
      'potassium': ((widget.item.properties['potassium'] ?? 0) * multiplier).round(),
      'magnesium': ((widget.item.properties['magnesium'] ?? 0) * multiplier).round(),
    };
  }

  double getTotalSugar() {
    final baseVolume = widget.item.getDefaultVolume(widget.units).toDouble();
    final baseSugar = (widget.item.properties['sugar'] ?? 0.0) as num;
    final currentVolume = sliderVolume;
    return (baseSugar * currentVolume / baseVolume);
  }

  double getHRIImpact() {
    final volumeMl = getVolumeMl();
    final hydrationFactor = (widget.item.properties['hydration'] as num? ?? 1.0).toDouble();
    final effectiveVolume = volumeMl * hydrationFactor;
    
    // Base impact calculation
    double impact = -(effectiveVolume / 2000.0 * 10); // Negative is good
    
    // Electrolyte bonus if applicable
    if (widget.showElectrolytes) {
      final electrolytes = getElectrolytes();
      if (electrolytes['sodium']! > 500) {
        impact -= 3; // High sodium helps retention
      } else if (electrolytes['sodium']! > 0) {
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
    final caffeine = (widget.item.properties['caffeine'] ?? 0) as num;
    if (caffeine > 0) {
      final caffeineMultiplier = sliderVolume / widget.item.getDefaultVolume(widget.units);
      impact += (caffeine * caffeineMultiplier * 0.02).clamp(0, 5);
    }
    
    return impact;
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
    return (e['sodium'] ?? 0) > 0 || (e['potassium'] ?? 0) > 0 || (e['magnesium'] ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final itemName = widget.item.getName(l10n);
    final hydration = (widget.item.properties['hydration'] as num? ?? 1.0);
    final sliderActiveColor = widget.sliderColor ?? Colors.blue;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Text(widget.item.icon as String, style: const TextStyle(fontSize: 28)),
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
      content: Column(
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                  value: sliderVolume,
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
          
          // Metrics display with gradients
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
                      colors: getSugarGradientColors(getTotalSugar()),
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
                        '${getTotalSugar().toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l10n.gramsSugar,
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
          
          // Electrolyte content display (if applicable)
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
          // Caffeine display (if applicable)
          if ((widget.item.properties['caffeine'] ?? 0) > 0) ...[
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
                    '${l10n.caffeine}: ${((widget.item.properties['caffeine'] ?? 0) * sliderVolume / widget.item.getDefaultVolume(widget.units)).round()} mg',
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
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add button - full width
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
            // Save to Favorites button - full width
            SizedBox(
              width: double.infinity,
              height: 53,
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.onSaveToFavorites(getVolumeMl());
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.star_border),
                label: Text(l10n.saveToFavorites),
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
    // Only show if value is significant
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