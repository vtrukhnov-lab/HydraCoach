// lib/screens/electrolytes_screen.dart
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

class ElectrolytesScreen extends StatefulWidget {
  const ElectrolytesScreen({Key? key}) : super(key: key);

  @override
  State<ElectrolytesScreen> createState() => _ElectrolytesScreenState();
}

class _ElectrolytesScreenState extends State<ElectrolytesScreen> 
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
  ElectrolyteType _selectedType = ElectrolyteType.basic;
  
  // Show tips card
  bool _showTipsCard = false;
  
  // Popular electrolytes
  late Map<ElectrolyteType, List<Map<String, dynamic>>> _popularElectrolytes;
  
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
    _initializePopularElectrolytes();
  }
  
  void _initializePopularElectrolytes() {
    final isImperial = _units == 'imperial';
    final l10n = AppLocalizations.of(context);
    
    _popularElectrolytes = {
      ElectrolyteType.basic: [
        {'name': l10n.electrolyteSaltWater, 'volume': isImperial ? 8 : 250, 'emoji': '🧂', 'sodium': 600, 'potassium': 0, 'magnesium': 0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.electrolytePinkSalt, 'volume': isImperial ? 8 : 250, 'emoji': '🩷', 'sodium': 500, 'potassium': 20, 'magnesium': 10, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.electrolyteSeaSalt, 'volume': isImperial ? 8 : 250, 'emoji': '🌊', 'sodium': 550, 'potassium': 10, 'magnesium': 5, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.boneBroth, 'volume': isImperial ? 8 : 250, 'emoji': '🍲', 'sodium': 800, 'potassium': 100, 'magnesium': 0, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.celticSalt, 'volume': isImperial ? 8 : 250, 'emoji': '🧂', 'sodium': 480, 'potassium': 40, 'magnesium': 120, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.soleWater, 'volume': isImperial ? 10 : 280, 'emoji': '💧', 'sodium': 2000, 'potassium': 0, 'magnesium': 0, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.bakingSoda, 'volume': isImperial ? 8 : 250, 'emoji': '⚪', 'sodium': 630, 'potassium': 0, 'magnesium': 0, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.pickleJuice, 'volume': isImperial ? 3 : 100, 'emoji': '🥒', 'sodium': 900, 'potassium': 70, 'magnesium': 0, 'sugar': 1.0, 'isPro': true},
        {'name': l10n.tomatoSalt, 'volume': isImperial ? 7 : 200, 'emoji': '🍅', 'sodium': 650, 'potassium': 400, 'magnesium': 0, 'sugar': 6.0, 'isPro': true},
      ],
      ElectrolyteType.mixes: [
        {'name': l10n.electrolyteMix, 'volume': isImperial ? 8 : 250, 'emoji': '⚡', 'sodium': 500, 'potassium': 200, 'magnesium': 50, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.electrolyteLMNT, 'volume': isImperial ? 8 : 250, 'emoji': '🔬', 'sodium': 1000, 'potassium': 200, 'magnesium': 60, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.ketorade, 'volume': isImperial ? 16 : 500, 'emoji': '🥤', 'sodium': 750, 'potassium': 300, 'magnesium': 100, 'sugar': 0.0, 'isPro': false},
        {'name': l10n.electrolyteNuun, 'volume': isImperial ? 16 : 500, 'emoji': '💊', 'sodium': 300, 'potassium': 150, 'magnesium': 25, 'sugar': 1.0, 'isPro': false},
        {'name': l10n.electrolyteLiquidIV, 'volume': isImperial ? 16 : 500, 'emoji': '💉', 'sodium': 500, 'potassium': 370, 'magnesium': 0, 'sugar': 11.0, 'isPro': true},
        {'name': l10n.electrolyteUltima, 'volume': isImperial ? 8 : 250, 'emoji': '🌟', 'sodium': 55, 'potassium': 250, 'magnesium': 100, 'sugar': 0.0, 'isPro': true},
        {'name': l10n.electrolytePropel, 'volume': isImperial ? 20 : 590, 'emoji': '🏃', 'sodium': 230, 'potassium': 70, 'magnesium': 0, 'sugar': 2.0, 'isPro': true},
        {'name': l10n.electrolytePedialyte, 'volume': isImperial ? 12 : 360, 'emoji': '👶', 'sodium': 370, 'potassium': 280, 'magnesium': 0, 'sugar': 9.0, 'isPro': true},
        {'name': l10n.electrolyteGatoradeZero, 'volume': isImperial ? 20 : 590, 'emoji': '🏈', 'sodium': 270, 'potassium': 75, 'magnesium': 0, 'sugar': 0.0, 'isPro': true},
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
  
  // Get today's totals
  Map<String, int> _getTodayTotals() {
    try {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      
      return {
        'sodium': provider.totalSodiumToday,
        'potassium': provider.totalPotassiumToday,
        'magnesium': provider.totalMagnesiumToday,
        'sodiumGoal': provider.goals.sodium,
        'potassiumGoal': provider.goals.potassium,
        'magnesiumGoal': provider.goals.magnesium,
      };
    } catch (e) {
      print('Error getting electrolyte totals: $e');
      return {
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'sodiumGoal': 2000,
        'potassiumGoal': 3500,
        'magnesiumGoal': 400,
      };
    }
  }
  
  // Log electrolyte intake
  Future<void> _logIntake({
    required String name,
    required int volumeMl,
    required int sodium,
    required int potassium,
    required int magnesium,
    required double sugar,
  }) async {
    try {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      provider.addIntake(
        'electrolyte',
        volumeMl,
        sodium: sodium,
        potassium: potassium,
        magnesium: magnesium,
      );
      
      // Log sugar if present
      if (sugar > 0) {
        print('Electrolyte sugar content: ${sugar}g');
      }
    } catch (e) {
      print('Error logging intake: $e');
    }
    
    // Show tips card
    setState(() {
      _showTipsCard = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Success animation
    _animController.reset();
    _animController.forward();
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
  
  Color _getSugarBadgeColor(double grams) {
    if (grams <= 5) return Colors.green.shade600;
    if (grams <= 10) return Colors.amber.shade600;
    return Colors.red.shade600;
  }
  
  // Save to favorites from dialog
  Future<void> _saveToFavoritesFromDialog({
    required String name,
    required int volumeMl,
    required String emoji,
    required int sodium,
    required int potassium,
    required int magnesium,
    required double sugar,
  }) async {
    final l10n = AppLocalizations.of(context);
    
    final slot = await _showFavoriteSlotSelector();
    if (slot == null) return;
    
    final volumeStr = UnitsService.instance.formatVolume(volumeMl);
    
    final favorite = QuickFavorite(
      id: 'electrolyte_${name}_$volumeMl',
      type: 'electrolyte',
      label: '$name: $volumeStr',
      emoji: emoji,
      volumeMl: volumeMl,
      sodiumMg: sodium,
      potassiumMg: potassium,
      magnesiumMg: magnesium,
      metadata: {
        'name': name,
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
  
  // Show electrolyte confirmation dialog with slider
  Future<void> _showElectrolyteConfirmationDialog({
    required Map<String, dynamic> electrolyte,
    required ElectrolyteType type,
  }) async {
    // Check if PRO electrolyte
    final isPro = electrolyte['isPro'] ?? false;
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
    double sliderValue = electrolyte['volume'].toDouble();
    
    // Limits based on type
    final minVolume = _units == 'imperial' ? 1.0 : 30.0;
    final maxVolume = _units == 'imperial' ? 40.0 : 1000.0;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            // Local helper functions inside StatefulBuilder
            int getVolumeMl() {
              return _units == 'imperial' 
                ? (sliderValue * 29.5735).round() 
                : sliderValue.round();
            }
            
            Map<String, int> getElectrolytes() {
              final multiplier = sliderValue / electrolyte['volume'];
              return {
                'sodium': (electrolyte['sodium'] * multiplier).round(),
                'potassium': (electrolyte['potassium'] * multiplier).round(),
                'magnesium': (electrolyte['magnesium'] * multiplier).round(),
              };
            }
            
            double getTotalSugar() {
              final baseVolume = (electrolyte['volume'] as num).toDouble();
              final baseSugar = (electrolyte['sugar'] ?? 0.0) as num;
              final currentVolume = sliderValue;
              return (baseSugar * currentVolume / baseVolume);
            }
            
            double getHRIImpact() {
              // Get actual current hydration from provider
              final provider = Provider.of<HydrationProvider>(context, listen: false);
              final currentWater = provider.totalWaterToday;
              final waterGoal = provider.goals.waterOpt.toDouble();
              
              // Calculate current ratio
              final currentRatio = waterGoal > 0 ? currentWater / waterGoal : 0.0;
              
              // Electrolyte drinks count as water
              final volumeMl = getVolumeMl().toDouble();
              final electrolytes = getElectrolytes();
              
              // Higher sodium improves hydration retention
              final sodiumFactor = electrolytes['sodium']! > 500 ? 1.1 : 1.0;
              final effectiveVolume = volumeMl * sodiumFactor;
              
              // Calculate new ratio after adding this electrolyte drink
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
              
              // Calculate HRI change from water
              final currentWaterComponent = calculateWaterComponent(currentRatio);
              final newWaterComponent = calculateWaterComponent(newRatio);
              double impact = newWaterComponent - currentWaterComponent;
              
              // Get current electrolyte levels for better calculation
              final currentSodium = provider.totalSodiumToday;
              final currentPotassium = provider.totalPotassiumToday;
              final currentMagnesium = provider.totalMagnesiumToday;
              final sodiumGoal = provider.goals.sodium.toDouble();
              final potassiumGoal = provider.goals.potassium.toDouble();
              final magnesiumGoal = provider.goals.magnesium.toDouble();
              
              // Calculate electrolyte component improvements
              if (electrolytes['sodium']! > 0 && sodiumGoal > 0) {
                final currentSodiumRatio = currentSodium / sodiumGoal;
                final newSodiumRatio = (currentSodium + electrolytes['sodium']!) / sodiumGoal;
                
                // Use actual electrolyte component formula
                double calcElectrolyteComponent(double ratio, double maxPoints) {
                  if (ratio < 0.3) return maxPoints;
                  else if (ratio < 0.7) return maxPoints * (1 - (ratio - 0.3) / 0.4);
                  else if (ratio <= 1.3) return 0;
                  else return (ratio - 1.3) * maxPoints * 0.5;
                }
                
                final currentSodiumComponent = calcElectrolyteComponent(currentSodiumRatio, 15);
                final newSodiumComponent = calcElectrolyteComponent(newSodiumRatio, 15);
                impact += newSodiumComponent - currentSodiumComponent;
              }
              
              // Add sugar impact
              final sugar = getTotalSugar();
              if (sugar > 50) {
                impact += (sugar - 50) * 0.2;
              } else if (sugar > 25) {
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
                  Text(electrolyte['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      electrolyte['name'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
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
                              '${sliderValue.toStringAsFixed(0)} ${_units == 'imperial' ? 'oz' : 'ml'}',
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
                          activeTrackColor: Colors.orange,
                          inactiveTrackColor: Colors.orange.withOpacity(0.2),
                          thumbColor: Colors.orange,
                          overlayColor: Colors.orange.withOpacity(0.1),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: sliderValue,
                          min: minVolume,
                          max: maxVolume,
                          divisions: _units == 'imperial' ? 39 : 97,
                          onChanged: (value) => setState(() => sliderValue = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Metrics display - HRI and Sugar
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
                  const SizedBox(height: 16),
                  
                  // Electrolyte content display
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
                  const SizedBox(height: 12),
                  Text(
                    UnitsService.instance.formatVolume(getVolumeMl()),
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
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop(false);
                          final totalSugar = getTotalSugar();
                          
                          await _saveToFavoritesFromDialog(
                            name: electrolyte['name'],
                            volumeMl: getVolumeMl(),
                            emoji: electrolyte['emoji'],
                            sodium: getElectrolytes()['sodium']!,
                            potassium: getElectrolytes()['potassium']!,
                            magnesium: getElectrolytes()['magnesium']!,
                            sugar: totalSugar,
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
      final multiplier = sliderValue / electrolyte['volume'];
      
      final volumeMl = _units == 'imperial' 
        ? (sliderValue * 29.5735).round() 
        : sliderValue.round();
      
      await _logIntake(
        name: electrolyte['name'],
        volumeMl: volumeMl,
        sodium: (electrolyte['sodium'] * multiplier).round(),
        potassium: (electrolyte['potassium'] * multiplier).round(),
        magnesium: (electrolyte['magnesium'] * multiplier).round(),
        sugar: (electrolyte['sugar'] ?? 0.0) * multiplier,
      );
    }
  }
  
  Widget _buildElectrolyteMetric(String label, int value, Color color) {
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
  
  // Get electrolyte indicators string
  String _getElectrolyteIndicators(Map<String, dynamic> electrolyte) {
    List<String> indicators = [];
    if (electrolyte['sodium'] > 0) indicators.add('Na');
    if (electrolyte['potassium'] > 0) indicators.add('K');
    if (electrolyte['magnesium'] > 0) indicators.add('Mg');
    return indicators.join(' • ');
  }
  
  Color _getStatusColor(Map<String, int> totals) {
    final sodiumPercent = (totals['sodium']! / totals['sodiumGoal']!) * 100;
    final potassiumPercent = (totals['potassium']! / totals['potassiumGoal']!) * 100;
    final magnesiumPercent = (totals['magnesium']! / totals['magnesiumGoal']!) * 100;
    
    final avgPercent = (sodiumPercent + potassiumPercent + magnesiumPercent) / 3;
    
    if (avgPercent >= 80) return Colors.green;
    if (avgPercent >= 50) return Colors.orange;
    return Colors.red;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    // Update PRO status
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    // Get electrolyte totals
    final totals = _getTodayTotals();
    final statusColor = _getStatusColor(totals);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.electrolyte),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          _StatusCard(
            totals: totals,
            statusColor: statusColor,
            l10n: l10n,
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
          
          // Popular electrolytes grid
          _PopularElectrolytesGrid(
            type: _selectedType,
            electrolytes: _popularElectrolytes[_selectedType]!,
            units: _units,
            isPro: _isPro,
            onElectrolyteSelected: (electrolyte) async {
              await _showElectrolyteConfirmationDialog(
                electrolyte: electrolyte,
                type: _selectedType,
              );
            },
            l10n: l10n,
            getSugarBadgeColor: _getSugarBadgeColor,
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Tips card
          if (_showTipsCard)
            _TipsCard(
              onDismiss: () => setState(() => _showTipsCard = false),
              l10n: l10n,
            ).animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    );
  }
}

// Electrolyte types enum - REMOVED supplements
enum ElectrolyteType { basic, mixes }

// Status card widget
class _StatusCard extends StatelessWidget {
  final Map<String, int> totals;
  final Color statusColor;
  final AppLocalizations l10n;
  
  const _StatusCard({
    required this.totals,
    required this.statusColor,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bolt,
                  size: 32,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.todaysElectrolytes,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusMessage(totals, l10n),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Electrolyte bars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ElectrolyteBar(
                label: 'Na',
                current: totals['sodium']!,
                goal: totals['sodiumGoal']!,
                color: Colors.blue,
              ),
              _ElectrolyteBar(
                label: 'K',
                current: totals['potassium']!,
                goal: totals['potassiumGoal']!,
                color: Colors.green,
              ),
              _ElectrolyteBar(
                label: 'Mg',
                current: totals['magnesium']!,
                goal: totals['magnesiumGoal']!,
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getStatusMessage(Map<String, int> totals, AppLocalizations l10n) {
    final sodiumPercent = (totals['sodium']! / totals['sodiumGoal']!) * 100;
    final potassiumPercent = (totals['potassium']! / totals['potassiumGoal']!) * 100;
    final magnesiumPercent = (totals['magnesium']! / totals['magnesiumGoal']!) * 100;
    
    final avgPercent = (sodiumPercent + potassiumPercent + magnesiumPercent) / 3;
    
    if (avgPercent >= 80) return l10n.greatBalance;
    if (avgPercent >= 50) return l10n.gettingThere;
    if (avgPercent >= 25) return l10n.needMoreElectrolytes;
    return l10n.lowElectrolyteLevels;
  }
}

// Electrolyte bar widget
class _ElectrolyteBar extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final Color color;
  
  const _ElectrolyteBar({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final percent = math.min((current / goal) * 100, 100).toInt();
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          '/ $goal mg',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percent%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Type selector widget - UPDATED for 2 tabs
class _TypeSelector extends StatelessWidget {
  final ElectrolyteType selectedType;
  final Function(ElectrolyteType) onTypeChanged;
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
        children: ElectrolyteType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.orange 
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
                    fontSize: 14,
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
  
  String _getName(ElectrolyteType type, AppLocalizations l10n) {
    switch (type) {
      case ElectrolyteType.basic: return l10n.electrolytesBasic;
      case ElectrolyteType.mixes: return l10n.electrolytesMixes;
    }
  }
}

// Popular electrolytes grid with indicators and sugar badges
class _PopularElectrolytesGrid extends StatelessWidget {
  final ElectrolyteType type;
  final List<Map<String, dynamic>> electrolytes;
  final String units;
  final bool isPro;
  final Function(Map<String, dynamic>) onElectrolyteSelected;
  final AppLocalizations l10n;
  final Function(double) getSugarBadgeColor;
  
  const _PopularElectrolytesGrid({
    required this.type,
    required this.electrolytes,
    required this.units,
    required this.isPro,
    required this.onElectrolyteSelected,
    required this.l10n,
    required this.getSugarBadgeColor,
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
            childAspectRatio: 0.75, // Adjusted for both indicators
          ),
          itemCount: electrolytes.length,
          itemBuilder: (context, index) {
            final electrolyte = electrolytes[index];
            final isElectrolytePro = electrolyte['isPro'] ?? false;
            final isLocked = isElectrolytePro && !isPro;
            
            // Get electrolyte indicators
            final indicators = _getElectrolyteIndicators(electrolyte);
            final sugar = (electrolyte['sugar'] ?? 0.0) as num;
            
            return InkWell(
              onTap: () => onElectrolyteSelected(electrolyte),
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
                              electrolyte['emoji'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              electrolyte['name'],
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
                          // Electrolyte indicators
                          if (indicators.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isLocked 
                                  ? Colors.grey.shade200 
                                  : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                indicators,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked 
                                    ? Colors.grey.shade400 
                                    : Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                          // Sugar indicator if present
                          if (sugar > 0.1) ...[
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isLocked 
                                  ? Colors.grey.shade200 
                                  : getSugarBadgeColor(sugar.toDouble()),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${sugar.toStringAsFixed(0)}g',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // PRO badge
                    if (isElectrolytePro)
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
  
  String _getTypeName(ElectrolyteType type, AppLocalizations l10n) {
    switch (type) {
      case ElectrolyteType.basic: return l10n.popularSalts;
      case ElectrolyteType.mixes: return l10n.popularMixes;
    }
  }
  
  String _getElectrolyteIndicators(Map<String, dynamic> electrolyte) {
    List<String> indicators = [];
    if (electrolyte['sodium'] > 0) indicators.add('Na');
    if (electrolyte['potassium'] > 0) indicators.add('K');
    if (electrolyte['magnesium'] > 0) indicators.add('Mg');
    return indicators.join(' • ');
  }
}

// Tips card
class _TipsCard extends StatelessWidget {
  final VoidCallback onDismiss;
  final AppLocalizations l10n;
  
  const _TipsCard({
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
            Colors.green.shade50,
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
                  l10n.electrolyteTips,
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
          _buildTip('💧', l10n.takeWithWater),
          _buildTip('⏰', l10n.bestBetweenMeals),
          _buildTip('🧂', l10n.startSmallAmounts),
          _buildTip('🏃', l10n.extraDuringExercise),
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