// lib/screens/liquids_catalog_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../providers/hydration_provider.dart';
import '../services/subscription_service.dart';
import '../services/units_service.dart';
import '../screens/paywall_screen.dart';

// ---------- Main Screen ----------

class LiquidsCatalogScreen extends StatefulWidget {
  const LiquidsCatalogScreen({Key? key}) : super(key: key);

  @override
  State<LiquidsCatalogScreen> createState() => _LiquidsCatalogScreenState();
}

class _LiquidsCatalogScreenState extends State<LiquidsCatalogScreen> 
    with SingleTickerProviderStateMixin {
  
  // Animation controller
  late AnimationController _animController;
  
  // Favorites manager
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  
  // PRO status
  bool _isPro = false;
  
  // Units
  String _units = 'metric';
  
  // Selected type
  LiquidType _selectedType = LiquidType.plain;
  
  // Show hydration tips
  bool _showHydrationTips = false;
  
  // Popular liquids (initialized in initState)
  late final Map<LiquidType, List<Map<String, dynamic>>> _popularLiquids;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animController.forward();
    
    _units = UnitsService.instance.units;
    _initializePro();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize popular liquids here where context is available
    _initializePopularLiquids();
  }
  
  void _initializePopularLiquids() {
    final isImperial = _units == 'imperial';
    final l10n = AppLocalizations.of(context);
    
    _popularLiquids = {
      LiquidType.plain: [
        {'name': l10n.water, 'volume': isImperial ? 8 : 250, 'emoji': '💧', 'hydration': 1.0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.warmWater, 'volume': isImperial ? 10 : 300, 'emoji': '♨️', 'hydration': 1.0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.iceWater, 'volume': isImperial ? 12 : 350, 'emoji': '🧊', 'hydration': 1.0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.filteredWater, 'volume': isImperial ? 16 : 500, 'emoji': '💧', 'hydration': 1.0, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.alkalineWater, 'volume': isImperial ? 8 : 250, 'emoji': '💙', 'hydration': 1.05, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.distilledWater, 'volume': isImperial ? 12 : 350, 'emoji': '💦', 'hydration': 0.95, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.springWater, 'volume': isImperial ? 16 : 500, 'emoji': '🏔️', 'hydration': 1.0, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.hydrogenWater, 'volume': isImperial ? 10 : 300, 'emoji': '⚛️', 'hydration': 1.1, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.oxygenatedWater, 'volume': isImperial ? 8 : 250, 'emoji': '🫧', 'hydration': 1.0, 'sugar': 0.0, 'isPro': true},
      ],
      LiquidType.enhanced: [
        {'name': l10n.lemonWater, 'volume': isImperial ? 8 : 250, 'emoji': '🍋', 'hydration': 1.0, 'sugar': 0.5, 'isPro': false},
        {'name': l10n.sparklingWater, 'volume': isImperial ? 12 : 330, 'emoji': '✨', 'hydration': 0.95, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.mineralWater, 'volume': isImperial ? 16 : 500, 'emoji': '🪨', 'hydration': 1.0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.coconutWater, 'volume': isImperial ? 11 : 330, 'emoji': '🥥', 'hydration': 1.2, 'sugar': 9.0, 'isPro': false},
        {'name': l10n.cucumberWater, 'volume': isImperial ? 10 : 300, 'emoji': '🥒', 'hydration': 1.0, 'sugar': 0.3, 'isPro': true},
        {'name': l10n.limeWater, 'volume': isImperial ? 8 : 250, 'emoji': '🈯', 'hydration': 1.0, 'sugar': 0.5, 'isPro': true},
        {'name': l10n.berryWater, 'volume': isImperial ? 12 : 350, 'emoji': '🫐', 'hydration': 1.0, 'sugar': 2.0, 'isPro': true},
        {'name': l10n.mintWater, 'volume': isImperial ? 10 : 300, 'emoji': '🌿', 'hydration': 1.0, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.gingerWater, 'volume': isImperial ? 8 : 250, 'emoji': '🫚', 'hydration': 0.95, 'sugar': 0.5, 'isPro': true},
      ],
      LiquidType.beverages: [
        {'name': l10n.greenTea, 'volume': isImperial ? 8 : 250, 'emoji': '🍵', 'hydration': 0.98, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.blackTea, 'volume': isImperial ? 8 : 250, 'emoji': '☕', 'hydration': 0.96, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.herbalTea, 'volume': isImperial ? 10 : 300, 'emoji': '🌺', 'hydration': 1.0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.sportsDrink, 'volume': isImperial ? 20 : 590, 'emoji': '🏃', 'hydration': 1.15, 'sugar': 34.0, 'isPro': false},
        {'name': l10n.drink_orange_juice, 'volume': isImperial ? 8 : 240, 'emoji': '🍊', 'hydration': 0.85, 'sugar': 21.0, 'isPro': true},
        {'name': l10n.drink_apple_juice, 'volume': isImperial ? 8 : 240, 'emoji': '🍎', 'hydration': 0.85, 'sugar': 24.0, 'isPro': true},
        {'name': l10n.drink_milk, 'volume': isImperial ? 8 : 240, 'emoji': '🥛', 'hydration': 0.9, 'sugar': 12.0, 'isPro': true},
        {'name': l10n.drink_almond_milk, 'volume': isImperial ? 8 : 240, 'emoji': '🥜', 'hydration': 0.95, 'sugar': 1.0, 'isPro': true},
        {'name': l10n.drink_kombucha, 'volume': isImperial ? 8 : 250, 'emoji': '🫖', 'hydration': 0.9, 'sugar': 4.0, 'isPro': true},
      ],
      LiquidType.sodas: [
        {'name': 'Coca-Cola', 'volume': isImperial ? 12 : 355, 'emoji': '🥤', 'hydration': 0.6, 'sugar': 39.0, 'isPro': false},
        {'name': 'Pepsi', 'volume': isImperial ? 12 : 355, 'emoji': '🥤', 'hydration': 0.6, 'sugar': 41.0, 'isPro': false},
        {'name': 'Mountain Dew', 'volume': isImperial ? 12 : 355, 'emoji': '🥤', 'hydration': 0.5, 'sugar': 46.0, 'isPro': false},
        {'name': 'Dr Pepper', 'volume': isImperial ? 12 : 355, 'emoji': '🥤', 'hydration': 0.6, 'sugar': 40.0, 'isPro': true},
        {'name': 'Sprite', 'volume': isImperial ? 12 : 355, 'emoji': '🥤', 'hydration': 0.65, 'sugar': 38.0, 'isPro': true},
        {'name': 'Fanta Orange', 'volume': isImperial ? 12 : 355, 'emoji': '🍊', 'hydration': 0.6, 'sugar': 44.0, 'isPro': true},
        {'name': 'Red Bull', 'volume': isImperial ? 8.4 : 250, 'emoji': '⚡', 'hydration': 0.75, 'sugar': 27.0, 'isPro': true},
        {'name': 'Monster Energy', 'volume': isImperial ? 16 : 473, 'emoji': '👹', 'hydration': 0.7, 'sugar': 54.0, 'isPro': true},
        {'name': 'Gatorade', 'volume': isImperial ? 20 : 590, 'emoji': '⚡', 'hydration': 1.1, 'sugar': 34.0, 'isPro': true},
      ],
    };
  }
  
  Future<void> _initializePro() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    _isPro = subscription.isPro;
    await _favoritesManager.init(_isPro);
    if (mounted) setState(() {});
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  
  // Get today's water intake - FIXED type handling
  Map<String, dynamic> _getTodayIntake() {
    try {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      final waterGoal = provider.goals.waterOpt;
      final currentWater = provider.totalWaterToday;
      final percent = waterGoal > 0 
        ? ((currentWater / waterGoal) * 100).clamp(0.0, 100.0)
        : 0.0;
      
      return {
        'current': currentWater.toInt(),
        'goal': waterGoal,
        'percent': percent,
      };
    } catch (e) {
      return {
        'current': 0,
        'goal': 2000,
        'percent': 0.0,
      };
    }
  }
  
  // Calculate hydration value
  double _calculateHydrationValue(double volumeMl, double hydrationFactor) {
    return volumeMl * hydrationFactor;
  }
  
  // Log liquid intake
  Future<void> _logIntake({
    required String name,
    required double volumeMl,
    required double hydrationFactor,
    required String emoji,
    required double sugar,
  }) async {
    try {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      
      // Calculate effective hydration
      final effectiveVolume = _calculateHydrationValue(volumeMl, hydrationFactor);
      
      provider.addIntake(
        'water',
        effectiveVolume.toInt(),
        sodium: 0,
        potassium: 0,
        magnesium: 0,
      );
      
      // Log sugar if present
      if (sugar > 0) {
        print('Liquid sugar content: ${sugar}g');
      }
    } catch (e) {
      print('Error logging intake: $e');
    }
    
    // Show hydration tips
    setState(() {
      _showHydrationTips = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Success animation
    _animController.reset();
    _animController.forward();
  }
  
  // Save to favorites from dialog
  Future<void> _saveToFavoritesFromDialog({
    required String name,
    required double volumeMl,
    required String emoji,
    required double hydrationFactor,
    required double sugar,
  }) async {
    final l10n = AppLocalizations.of(context);
    
    final slot = await _showFavoriteSlotSelector();
    if (slot == null) return;
    
    final volumeStr = UnitsService.instance.formatVolume(volumeMl.toInt());
    
    final favorite = QuickFavorite(
      id: 'liquid_${name}_${volumeMl.toInt()}',
      type: 'water',
      label: '$name: $volumeStr',
      emoji: emoji,
      volumeMl: volumeMl.toInt(),
      metadata: {
        'liquidName': name,
        'hydrationFactor': hydrationFactor,
        'sugar': sugar,
      },
    );
    
    await _favoritesManager.saveFavorite(slot, favorite);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.savedToFavorites} (${l10n.slot} ${slot + 1})'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<int?> _showFavoriteSlotSelector() async {
    final l10n = AppLocalizations.of(context);
    return await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(dialogContext).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.selectFavoriteSlot,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < 3; i++) ...[
              _buildSlotOption(i, l10n, dialogContext),
              if (i < 2) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSlotOption(int slot, AppLocalizations l10n, BuildContext dialogContext) {
    final isLocked = !_isPro && slot > 0;
    final currentFavorite = _favoritesManager.favorites[slot];
    
    if (isLocked) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade50,
          child: const Icon(Icons.lock, color: Colors.purple),
        ),
        title: Text('${l10n.slot} ${slot + 1} (PRO)'),
        subtitle: Text(l10n.upgradeToUnlock),
        onTap: () {
          Navigator.pop(dialogContext);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaywallScreen(),
              fullscreenDialog: true,
            ),
          );
        },
      );
    }
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: currentFavorite != null 
          ? Colors.orange.shade50 
          : Colors.green.shade50,
        child: Icon(
          currentFavorite != null ? Icons.star : Icons.add,
          color: currentFavorite != null 
            ? Colors.orange.shade600 
            : Colors.green.shade600,
        ),
      ),
      title: Text('${l10n.slot} ${slot + 1}'),
      subtitle: Text(
        currentFavorite != null 
          ? currentFavorite.label 
          : l10n.emptySlot,
      ),
      onTap: () => Navigator.pop(dialogContext, slot),
    );
  }
  
  // Show liquid confirmation dialog with slider
  Future<void> _showLiquidConfirmationDialog({
    required Map<String, dynamic> liquid,
    required LiquidType type,
  }) async {
    // Check if PRO liquid
    final isPro = liquid['isPro'] ?? false;
    if (isPro && !_isPro) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaywallScreen(),
          fullscreenDialog: true,
        ),
      );
      return;
    }
    
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    // Initial value for slider
    double sliderVolume = _units == 'imperial' 
      ? (liquid['volume'] as num).toDouble()
      : (liquid['volume'] as num).toDouble();
    
    // Volume limits based on units
    final minVolume = _units == 'imperial' ? 4.0 : 100.0;
    final maxVolume = _units == 'imperial' ? 40.0 : 1000.0;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            // Local helper functions inside StatefulBuilder
            double getVolumeMl() {
              return _units == 'imperial' ? sliderVolume * 29.5735 : sliderVolume;
            }
            
            double getHydrationValue() {
              return _calculateHydrationValue(getVolumeMl(), (liquid['hydration'] as num).toDouble());
            }
            
            double getTotalSugar() {
              // Calculate sugar proportionally to volume
              final baseVolume = (liquid['volume'] as num).toDouble();
              final baseSugar = (liquid['sugar'] ?? 0.0) as num;
              final currentVolume = sliderVolume;
              return (baseSugar * currentVolume / baseVolume);
            }
            
            double getHRIImpact() {
              // Get actual current hydration from provider
              final provider = Provider.of<HydrationProvider>(context, listen: false);
              final currentWater = provider.totalWaterToday;
              final waterGoal = provider.goals.waterOpt.toDouble();
              
              // Calculate current ratio
              final currentRatio = waterGoal > 0 ? currentWater / waterGoal : 0.0;
              
              // Calculate effective hydration from this liquid
              final volumeMl = getVolumeMl();
              final hydrationFactor = (liquid['hydration'] as num).toDouble();
              final effectiveVolume = volumeMl * hydrationFactor;
              
              // Calculate new ratio after adding this liquid
              final volumeRatio = waterGoal > 0 ? effectiveVolume / waterGoal : 0.0;
              final newRatio = (currentRatio + volumeRatio).clamp(0.0, 2.0);
              
              // Calculate water component using actual formula from HRI service
              double calculateWaterComponent(double ratio) {
                if (ratio < 0.5) {
                  return 40 * (1 - ratio * 2);
                } else if (ratio < 0.8) {
                  return 20 * (1 - (ratio - 0.5) / 0.3);
                } else if (ratio <= 1.2) {
                  return 0;
                } else {
                  return 20.0 < (ratio - 1.2) * 50 ? 20.0 : (ratio - 1.2) * 50;
                }
              }
              
              // Calculate HRI change
              final currentWaterComponent = calculateWaterComponent(currentRatio);
              final newWaterComponent = calculateWaterComponent(newRatio);
              double impact = newWaterComponent - currentWaterComponent;
              
              // Add sugar impact (from remote config: 0.2 multiplier, 50g threshold)
              final sugar = getTotalSugar();
              if (sugar > 50) {
                impact += (sugar - 50) * 0.2;
              } else if (sugar > 25) {
                // Add mild penalty for moderate sugar
                impact += (sugar - 25) * 0.1;
              }
              
              return impact;
            }
            
            List<Color> getHRIGradientColors() {
              final impact = getHRIImpact();
              if (impact <= 0) {
                return [Colors.green.shade400, Colors.green.shade600];
              } else if (impact <= 5) {
                return [Colors.amber.shade400, Colors.amber.shade600];
              } else if (impact <= 10) {
                return [Colors.orange.shade400, Colors.orange.shade600];
              } else {
                return [Colors.red.shade400, Colors.red.shade600];
              }
            }
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(liquid['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          liquid['name'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${((liquid['hydration'] as num) * 100).toInt()}% ${l10n.hydration.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
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
                              '${sliderVolume.toStringAsFixed(0)} ${_units == 'imperial' ? 'oz' : 'ml'}',
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
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.blue.withOpacity(0.2),
                          thumbColor: Colors.blue,
                          overlayColor: Colors.blue.withOpacity(0.1),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: sliderVolume,
                          min: minVolume,
                          max: maxVolume,
                          divisions: _units == 'imperial' ? 36 : 90,
                          onChanged: (value) => setState(() => sliderVolume = value),
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
                              colors: _getSugarGradientColors(getTotalSugar()),
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
                  const SizedBox(height: 12),
                  Text(
                    UnitsService.instance.formatVolume(getVolumeMl().toInt()),
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
                        onPressed: () async {
                          Navigator.of(dialogContext).pop(false);
                          await _saveToFavoritesFromDialog(
                            name: liquid['name'],
                            volumeMl: getVolumeMl(),
                            emoji: liquid['emoji'],
                            hydrationFactor: (liquid['hydration'] as num).toDouble(),
                            sugar: getTotalSugar(),
                          );
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
          },
        );
      },
    );
    
    // If confirmed, log the intake
    if (result == true) {
      final volumeMl = UnitsService.instance.toMilliliters(sliderVolume);
      
      await _logIntake(
        name: liquid['name'],
        volumeMl: volumeMl.toDouble(),
        hydrationFactor: (liquid['hydration'] as num).toDouble(),
        emoji: liquid['emoji'],
        sugar: (liquid['sugar'] ?? 0.0) as double,
      );
    }
  }
  
  List<Color> _getHydrationGradientColors(double factor) {
    if (factor >= 1.0) {
      return [Colors.blue.shade400, Colors.blue.shade600];
    } else if (factor >= 0.9) {
      return [Colors.cyan.shade400, Colors.cyan.shade600];
    } else if (factor >= 0.7) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    } else {
      return [Colors.red.shade400, Colors.red.shade600];
    }
  }
  
  List<Color> _getSugarGradientColors(double grams) {
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
  
  Color _getStatusColor(double percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.blue;
    if (percent >= 25) return Colors.orange;
    return Colors.red;
  }
  
  // Fixed version of _getStatusMessage
  String _getStatusMessage(double percent, AppLocalizations l10n) {
    if (percent >= 100) return l10n.goalReached;
    if (percent >= 75) return l10n.almostThere;
    if (percent >= 50) return l10n.halfwayThere;
    if (percent >= 25) return l10n.keepGoing;
    return l10n.startDrinking;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    // Update PRO status
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    // Get water intake
    final intake = _getTodayIntake();
    final statusColor = _getStatusColor((intake['percent'] as double));
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.selectDrinkType),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          _StatusCard(
            intake: intake,
            statusColor: statusColor,
            l10n: l10n,
            units: _units,
          ).animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: -0.1, end: 0),
          
          const SizedBox(height: 24),
          
          // Type selector
          _TypeSelector(
            selectedType: _selectedType,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
            l10n: l10n,
          ).animate()
            .fadeIn(duration: 300.ms, delay: 100.ms)
            .slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 20),
          
          // Popular liquids grid
          _PopularLiquidsGrid(
            type: _selectedType,
            liquids: _popularLiquids[_selectedType]!,
            units: _units,
            isPro: _isPro,
            onLiquidSelected: (liquid) async {
              await _showLiquidConfirmationDialog(
                liquid: liquid,
                type: _selectedType,
              );
            },
            l10n: l10n,
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Hydration tips card
          if (_showHydrationTips)
            _HydrationTipsCard(
              onDismiss: () => setState(() => _showHydrationTips = false),
              l10n: l10n,
            ).animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    );
  }
}

// Liquid types enum
enum LiquidType { plain, enhanced, beverages, sodas }

// Status card widget - FIXED type handling
class _StatusCard extends StatelessWidget {
  final Map<String, dynamic> intake;
  final Color statusColor;
  final AppLocalizations l10n;
  final String units;
  
  const _StatusCard({
    required this.intake,
    required this.statusColor,
    required this.l10n,
    required this.units,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = intake['percent'] as double;
    final progress = (percent / 100.0).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(statusColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percent.toInt()}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        Text(
                          l10n.hydration,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todayHydration,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusMessage(percent, l10n),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(statusColor),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.water_drop,
                value: UnitsService.instance.formatVolume(intake['current'] as int, hideUnit: true),
                label: l10n.currentIntake,
                color: Colors.blue,
              ),
              _StatItem(
                icon: Icons.flag,
                value: UnitsService.instance.formatVolume(intake['goal'] as int, hideUnit: true),
                label: l10n.dailyGoal,
                color: Colors.green,
              ),
              _StatItem(
                icon: Icons.trending_up,
                value: UnitsService.instance.formatVolume(
                  ((intake['goal'] as int) - (intake['current'] as int)).clamp(0, 999999),
                  hideUnit: true
                ),
                label: l10n.toGo,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getStatusMessage(double percent, AppLocalizations l10n) {
    if (percent >= 100) return l10n.goalReached;
    if (percent >= 75) return l10n.almostThere;
    if (percent >= 50) return l10n.halfwayThere;
    if (percent >= 25) return l10n.keepGoing;
    return l10n.startDrinking;
  }
}

// Stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// Type selector widget
class _TypeSelector extends StatelessWidget {
  final LiquidType selectedType;
  final Function(LiquidType) onTypeChanged;
  final AppLocalizations l10n;
  
  const _TypeSelector({
    required this.selectedType,
    required this.onTypeChanged,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: LiquidType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.blue 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getName(type, l10n),
                  style: TextStyle(
                    color: isSelected 
                      ? Colors.white 
                      : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  String _getName(LiquidType type, AppLocalizations l10n) {
    switch (type) {
      case LiquidType.plain: return l10n.plainWater;
      case LiquidType.enhanced: return l10n.enhancedWater;
      case LiquidType.beverages: return l10n.beverages;
      case LiquidType.sodas: return l10n.sodas;
    }
  }
}

// Popular liquids grid
class _PopularLiquidsGrid extends StatelessWidget {
  final LiquidType type;
  final List<Map<String, dynamic>> liquids;
  final String units;
  final bool isPro;
  final Function(Map<String, dynamic>) onLiquidSelected;
  final AppLocalizations l10n;
  
  const _PopularLiquidsGrid({
    required this.type,
    required this.liquids,
    required this.units,
    required this.isPro,
    required this.onLiquidSelected,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getTypeName(type, l10n),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: liquids.length,
          itemBuilder: (context, index) {
            final liquid = liquids[index];
            final isLiquidPro = liquid['isPro'] ?? false;
            final isLocked = isLiquidPro && !isPro;
            
            return InkWell(
              onTap: () => onLiquidSelected(liquid),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isLocked 
                    ? theme.colorScheme.surface.withOpacity(0.5)
                    : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLocked
                      ? theme.colorScheme.outline.withOpacity(0.1)
                      : theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isLocked ? 0.02 : 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: isLocked ? 0.5 : 1.0,
                            child: Text(
                              liquid['emoji'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              liquid['name'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isLocked 
                                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                                  : theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // PRO badge
                    if (isLiquidPro)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // Gray overlay for locked items
                    if (isLocked)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  String _getTypeName(LiquidType type, AppLocalizations l10n) {
    switch (type) {
      case LiquidType.plain: return l10n.popularPlainWater;
      case LiquidType.enhanced: return l10n.popularEnhancedWater;
      case LiquidType.beverages: return l10n.popularBeverages;
      case LiquidType.sodas: return l10n.popularSodas;
    }
  }
}

// Hydration tips card
class _HydrationTipsCard extends StatelessWidget {
  final VoidCallback onDismiss;
  final AppLocalizations l10n;
  
  const _HydrationTipsCard({
    required this.onDismiss,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.cyan.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.hydrationTips,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip('💧', l10n.drinkRegularly),
          _buildTip('🌡️', l10n.roomTemperature),
          _buildTip('🍋', l10n.addLemon),
          _buildTip('⚠️', l10n.limitSugary),
        ],
      ),
    );
  }
  
  Widget _buildTip(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}