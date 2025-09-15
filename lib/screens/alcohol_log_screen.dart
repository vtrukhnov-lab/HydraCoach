// lib/screens/alcohol_log_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/alcohol_intake.dart';
import '../models/quick_favorites.dart';
import '../providers/hydration_provider.dart';
import '../services/alcohol_service.dart';
import '../services/remote_config_service.dart';
import '../services/subscription_service.dart';
import '../services/notification_service.dart';
import '../services/units_service.dart';
import '../screens/paywall_screen.dart';


// ---------- Экран ----------

class AlcoholLogScreen extends StatefulWidget {
  const AlcoholLogScreen({Key? key}) : super(key: key);

  @override
  State<AlcoholLogScreen> createState() => _AlcoholLogScreenState();
}

class _AlcoholLogScreenState extends State<AlcoholLogScreen> 
    with SingleTickerProviderStateMixin {
  
  // Animation controller
  late AnimationController _animController;
  
  // RemoteConfig
  final RemoteConfigService _remoteConfig = RemoteConfigService.instance;
  
  // Favorites manager
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  
  // PRO status
  bool _isPro = false;
  
  // Units
  String _units = 'metric';
  
  // Selected type
  AlcoholType _selectedType = AlcoholType.beer;
  
  // Show harm reduction card
  bool _showHarmReduction = false;
  
  // Popular drinks (initialized in initState)
  late final Map<AlcoholType, List<Map<String, dynamic>>> _popularDrinks;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animController.forward();
    
    _units = UnitsService.instance.units;
    _initializePopularDrinks();
    _initializePro();
  }
  
  void _initializePopularDrinks() {
    _popularDrinks = {
      AlcoholType.beer: [
        {'name': 'Light Beer', 'abv': 4.0, 'ml': 330, 'emoji': '🍺', 'sugar': 3.3, 'isPro': false},
        {'name': 'Lager', 'abv': 5.0, 'ml': 500, 'emoji': '🍺', 'sugar': 5.0, 'isPro': false},
        {'name': 'IPA', 'abv': 6.5, 'ml': 330, 'emoji': '🍺', 'sugar': 2.0, 'isPro': false},
        {'name': 'Stout', 'abv': 7.0, 'ml': 440, 'emoji': '🍺', 'sugar': 4.4, 'isPro': true},
        {'name': 'Wheat Beer', 'abv': 5.2, 'ml': 500, 'emoji': '🍺', 'sugar': 7.5, 'isPro': true},
        {'name': 'Craft Beer', 'abv': 6.0, 'ml': 355, 'emoji': '🍺', 'sugar': 3.5, 'isPro': true},
        {'name': 'Non-Alcoholic', 'abv': 0.5, 'ml': 330, 'emoji': '🍺', 'sugar': 8.0, 'isPro': true},
        {'name': 'Radler', 'abv': 2.5, 'ml': 500, 'emoji': '🍺', 'sugar': 15.0, 'isPro': true},
        {'name': 'Pilsner', 'abv': 4.8, 'ml': 500, 'emoji': '🍺', 'sugar': 3.0, 'isPro': true},
      ],
      AlcoholType.wine: [
        {'name': 'Red Wine', 'abv': 13.5, 'ml': 150, 'emoji': '🍷', 'sugar': 1.0, 'isPro': false},
        {'name': 'White Wine', 'abv': 12.0, 'ml': 150, 'emoji': '🥂', 'sugar': 1.5, 'isPro': false},
        {'name': 'Prosecco', 'abv': 11.0, 'ml': 125, 'emoji': '🍾', 'sugar': 2.0, 'isPro': false},
        {'name': 'Port', 'abv': 20.0, 'ml': 75, 'emoji': '🍷', 'sugar': 7.5, 'isPro': true},
        {'name': 'Rosé', 'abv': 12.5, 'ml': 150, 'emoji': '🍷', 'sugar': 3.0, 'isPro': true},
        {'name': 'Champagne', 'abv': 12.0, 'ml': 125, 'emoji': '🍾', 'sugar': 1.5, 'isPro': true},
        {'name': 'Dessert Wine', 'abv': 15.0, 'ml': 100, 'emoji': '🍷', 'sugar': 15.0, 'isPro': true},
        {'name': 'Sangria', 'abv': 9.0, 'ml': 200, 'emoji': '🍷', 'sugar': 18.0, 'isPro': true},
        {'name': 'Sherry', 'abv': 17.0, 'ml': 75, 'emoji': '🍷', 'sugar': 5.0, 'isPro': true},
      ],
      AlcoholType.spirits: [
        {'name': 'Vodka Shot', 'abv': 40.0, 'ml': 30, 'emoji': '🥃', 'sugar': 0.0, 'isPro': false},
        {'name': 'Whiskey', 'abv': 40.0, 'ml': 50, 'emoji': '🥃', 'sugar': 0.0, 'isPro': false},
        {'name': 'Tequila', 'abv': 38.0, 'ml': 30, 'emoji': '🥃', 'sugar': 0.0, 'isPro': false},
        {'name': 'Rum', 'abv': 37.5, 'ml': 50, 'emoji': '🥃', 'sugar': 0.0, 'isPro': true},
        {'name': 'Gin', 'abv': 40.0, 'ml': 50, 'emoji': '🥃', 'sugar': 0.0, 'isPro': true},
        {'name': 'Cognac', 'abv': 40.0, 'ml': 50, 'emoji': '🥃', 'sugar': 0.0, 'isPro': true},
        {'name': 'Liqueur', 'abv': 20.0, 'ml': 50, 'emoji': '🥃', 'sugar': 15.0, 'isPro': true},
        {'name': 'Absinthe', 'abv': 70.0, 'ml': 30, 'emoji': '🥃', 'sugar': 0.0, 'isPro': true},
        {'name': 'Brandy', 'abv': 40.0, 'ml': 50, 'emoji': '🥃', 'sugar': 0.0, 'isPro': true},
      ],
      AlcoholType.cocktail: [
        {'name': 'Mojito', 'abv': 10.0, 'ml': 250, 'emoji': '🍹', 'sugar': 25.0, 'isPro': false},
        {'name': 'Margarita', 'abv': 15.0, 'ml': 200, 'emoji': '🍹', 'sugar': 20.0, 'isPro': false},
        {'name': 'Long Island', 'abv': 22.0, 'ml': 240, 'emoji': '🍹', 'sugar': 33.0, 'isPro': false},
        {'name': 'Gin & Tonic', 'abv': 10.0, 'ml': 250, 'emoji': '🍸', 'sugar': 18.0, 'isPro': true},
        {'name': 'Piña Colada', 'abv': 10.0, 'ml': 240, 'emoji': '🍹', 'sugar': 35.0, 'isPro': true},
        {'name': 'Cosmopolitan', 'abv': 20.0, 'ml': 150, 'emoji': '🍸', 'sugar': 12.0, 'isPro': true},
        {'name': 'Mai Tai', 'abv': 17.0, 'ml': 200, 'emoji': '🍹', 'sugar': 28.0, 'isPro': true},
        {'name': 'Bloody Mary', 'abv': 12.0, 'ml': 250, 'emoji': '🍹', 'sugar': 10.0, 'isPro': true},
        {'name': 'Daiquiri', 'abv': 13.0, 'ml': 180, 'emoji': '🍹', 'sugar': 22.0, 'isPro': true},
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
  
  // Calculate standard drinks
  double _calculateSD(double volumeMl, double abv) {
    final stdDrinkGrams = _remoteConfig.getDouble('std_drink_grams') ?? 10.0;
    final ethanolGrams = volumeMl * (abv / 100.0) * 0.789;
    return ethanolGrams / stdDrinkGrams;
  }
  
  // Get today's total SD
  double _getTodayTotalSD() {
    try {
      final alcoholService = Provider.of<AlcoholService>(context, listen: false);
      return alcoholService.totalStandardDrinks;
    } catch (e) {
      return 0.0;
    }
  }
  
  // Log alcohol intake with sugar tracking
  Future<void> _logIntake({
    required AlcoholType type,
    required double volumeMl,
    required double abv,
    String? name,
    double? sugar,
  }) async {
    final intake = AlcoholIntake(
      timestamp: DateTime.now(),
      type: type,
      volumeMl: volumeMl,
      abv: abv,
    );
    
    try {
      final alcoholService = Provider.of<AlcoholService>(context, listen: false);
      await alcoholService.addIntake(intake);
      
      // If sugar is provided, we could log it
      if (sugar != null && sugar > 0) {
        print('Alcohol sugar content: ${sugar}g');
      }
      
      // Schedule notification
      try {
        final sd = intake.standardDrinks;
        await NotificationService().scheduleAlcoholCounterReminder(sd.toInt());
      } catch (e) {
        print('Failed to schedule notification: $e');
      }
    } catch (e) {
      print('Error logging intake: $e');
    }
    
    // Show harm reduction card
    setState(() {
      _showHarmReduction = true;
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Success animation
    _animController.reset();
    _animController.forward();
  }
  
  // Save to favorites from dialog
  Future<void> _saveToFavoritesFromDialog({
    required AlcoholType type,
    required double volumeMl,
    required double abv,
    required String name,
    required String emoji,
    double? sugar,
  }) async {
    final l10n = AppLocalizations.of(context);
    
    final slot = await _showFavoriteSlotSelector();
    if (slot == null) return;
    
    final volumeStr = _units == 'imperial' 
      ? '${(volumeMl / 29.5735).toStringAsFixed(1)} oz'
      : '${volumeMl.toStringAsFixed(0)} ml';
    
    final favorite = QuickFavorite(
      id: 'alcohol_${type.key}_${volumeMl.toInt()}_$abv',
      type: 'alcohol',
      label: '$name: $abv% - $volumeStr',
      emoji: emoji,
      volumeMl: volumeMl.toInt(),
      metadata: {
        'alcoholType': type.key,
        'abv': abv,
        'name': name,
        'sugar': sugar ?? 0.0,
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
  
  // Show drink confirmation dialog with slider - UPDATED VERSION
  Future<void> _showDrinkConfirmationDialog({
    required Map<String, dynamic> drink,
    required AlcoholType type,
  }) async {
    // Check if PRO drink
    final isPro = drink['isPro'] ?? false;
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
      ? (drink['ml'] / 29.5735)
      : drink['ml'].toDouble();
    
    // Volume limits based on units
    final minVolume = _units == 'imperial' ? 1.0 : 30.0;
    final maxVolume = _units == 'imperial' ? 40.0 : 1000.0;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            double getVolumeMl() {
              return _units == 'imperial' ? sliderVolume * 29.5735 : sliderVolume;
            }
            
            double getSD() {
              return _calculateSD(getVolumeMl(), drink['abv'].toDouble());
            }
            
            double getTotalSugar() {
              // Calculate sugar proportionally to volume
              final baseMl = drink['ml'].toDouble();
              final baseSugar = drink['sugar'] ?? 0.0;
              final currentMl = getVolumeMl();
              return (baseSugar * currentMl / baseMl);
            }
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(drink['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          drink['name'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${drink['abv']}% ABV',
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
                  // Volume slider only
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
                          activeTrackColor: theme.colorScheme.primary,
                          inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.2),
                          thumbColor: theme.colorScheme.primary,
                          overlayColor: theme.colorScheme.primary.withOpacity(0.1),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          value: sliderVolume,
                          min: minVolume,
                          max: maxVolume,
                          divisions: _units == 'imperial' ? 39 : 97,
                          onChanged: (value) => setState(() => sliderVolume = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Metrics display with gradients for BOTH cards
                  Row(
                    children: [
                      // SD card with gradient colors
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _getSDGradientColors(getSD()),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.local_bar,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${getSD().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'SD',
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
                      // Sugar card with gradient
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
                                'g sugar',
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
                            type: type,
                            volumeMl: getVolumeMl(),
                            abv: drink['abv'].toDouble(),
                            name: drink['name'],
                            emoji: drink['emoji'],
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
        type: type,
        volumeMl: volumeMl.toDouble(),
        abv: drink['abv'].toDouble(),
        name: drink['name'],
        sugar: drink['sugar'] ?? 0.0,
      );
    }
  }
  
  String _getTypeName(AlcoholType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case AlcoholType.beer:
        return l10n.beer;
      case AlcoholType.wine:
        return l10n.wine;
      case AlcoholType.spirits:
        return l10n.spirits;
      case AlcoholType.cocktail:
        return l10n.cocktail;
    }
  }
  
  String _getTypeEmoji(AlcoholType type) {
    switch (type) {
      case AlcoholType.beer:
        return '🍺';
      case AlcoholType.wine:
        return '🍷';
      case AlcoholType.spirits:
        return '🥃';
      case AlcoholType.cocktail:
        return '🍹';
    }
  }
  
  Color _getStatusColor(double sd) {
    if (sd <= 1.0) return Colors.green;
    if (sd <= 2.0) return Colors.orange;
    if (sd <= 3.0) return Colors.deepOrange;
    return Colors.red;
  }
  
  List<Color> _getSugarGradientColors(double grams) {
    if (grams <= 5) {
      return [Colors.green.shade400, Colors.green.shade600];
    } else if (grams <= 15) {
      return [Colors.amber.shade400, Colors.amber.shade600];
    } else if (grams <= 25) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    } else {
      return [Colors.red.shade400, Colors.red.shade600];
    }
  }
  
  // NEW FUNCTION for SD gradient colors
  List<Color> _getSDGradientColors(double sd) {
    if (sd <= 0.5) {
      return [Colors.green.shade400, Colors.green.shade600];
    } else if (sd <= 1.0) {
      return [Colors.amber.shade400, Colors.amber.shade600];
    } else if (sd <= 2.0) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    } else {
      return [Colors.red.shade400, Colors.red.shade600];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    // Update PRO status
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    // Get alcohol service for real data
    final alcoholService = Provider.of<AlcoholService>(context);
    final todaySD = alcoholService.totalStandardDrinks;
    final statusColor = _getStatusColor(todaySD);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.addAlcohol),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card - fixed to use real data
          _StatusCard(
            todaySD: todaySD,
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
          
          // Popular drinks grid
          _PopularDrinksGrid(
            type: _selectedType,
            drinks: _popularDrinks[_selectedType]!,
            units: _units,
            isPro: _isPro,
            onDrinkSelected: (drink) async {
              await _showDrinkConfirmationDialog(
                drink: drink,
                type: _selectedType,
              );
            },
            calculateSD: _calculateSD,
            l10n: l10n,
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Harm reduction card
          if (_showHarmReduction)
            _HarmReductionCard(
              onDismiss: () => setState(() => _showHarmReduction = false),
              l10n: l10n,
            ).animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    );
  }
}

// Status card widget - fixed to work properly
class _StatusCard extends StatelessWidget {
  final double todaySD;
  final Color statusColor;
  final AppLocalizations l10n;
  final String units;
  
  const _StatusCard({
    required this.todaySD,
    required this.statusColor,
    required this.l10n,
    required this.units,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (todaySD / 3.0).clamp(0.0, 1.0);
    
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
              // Circular progress - fixed
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
                          todaySD.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        Text(
                          'SD',
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
                      l10n.todayConsumed,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusMessage(todaySD, l10n),
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
          // Corrections
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CorrectionItem(
                icon: Icons.water_drop,
                value: '+${UnitsService.instance.formatVolume((todaySD * 150).toInt(), hideUnit: true)} ${UnitsService.instance.volumeUnit}',
                label: l10n.additionalWater,
                color: Colors.blue,
              ),
              _CorrectionItem(
                icon: Icons.grain,
                value: '+${(todaySD * 200).toStringAsFixed(0)} mg',
                label: l10n.additionalSodium,
                color: Colors.purple,
              ),
              _CorrectionItem(
                icon: Icons.warning,
                value: '+${(todaySD * 3).toStringAsFixed(1)}',
                label: l10n.hriRisk,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getStatusMessage(double sd, AppLocalizations l10n) {
    if (sd == 0) return 'No alcohol today';
    if (sd <= 1) return 'Moderate consumption';
    if (sd <= 2) return 'Above recommendations';
    if (sd <= 3) return 'High consumption';
    return 'Very high - consider stopping';
  }
}

// Correction item widget
class _CorrectionItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _CorrectionItem({
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
  final AlcoholType selectedType;
  final Function(AlcoholType) onTypeChanged;
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
        children: AlcoholType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? theme.colorScheme.primary 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getEmoji(type),
                      style: const TextStyle(fontSize: 20),
                    ),
                    if (type != AlcoholType.spirits) const SizedBox(width: 4),
                    if (type != AlcoholType.spirits)
                      Text(
                        _getName(type, l10n),
                        style: TextStyle(
                          color: isSelected 
                            ? theme.colorScheme.onPrimary 
                            : theme.colorScheme.onSurfaceVariant,
                          fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    // Special layout for spirits - two lines
                    if (type == AlcoholType.spirits)
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.spirits.split(' ').first,
                              style: TextStyle(
                                color: isSelected 
                                  ? theme.colorScheme.onPrimary 
                                  : theme.colorScheme.onSurfaceVariant,
                                fontWeight: isSelected 
                                  ? FontWeight.bold 
                                  : FontWeight.normal,
                                fontSize: 11,
                                height: 1.0,
                              ),
                            ),
                            if (l10n.spirits.contains(' '))
                              Text(
                                l10n.spirits.split(' ').skip(1).join(' '),
                                style: TextStyle(
                                  color: isSelected 
                                    ? theme.colorScheme.onPrimary 
                                    : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                                  fontSize: 11,
                                  height: 1.0,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  String _getEmoji(AlcoholType type) {
    switch (type) {
      case AlcoholType.beer: return '🍺';
      case AlcoholType.wine: return '🍷';
      case AlcoholType.spirits: return '🥃';
      case AlcoholType.cocktail: return '🍹';
    }
  }
  
  String _getName(AlcoholType type, AppLocalizations l10n) {
    switch (type) {
      case AlcoholType.beer: return l10n.beer;
      case AlcoholType.wine: return l10n.wine;
      case AlcoholType.spirits: return l10n.spirits;
      case AlcoholType.cocktail: return l10n.cocktail;
    }
  }
}

// Popular drinks grid - with PRO badges
class _PopularDrinksGrid extends StatelessWidget {
  final AlcoholType type;
  final List<Map<String, dynamic>> drinks;
  final String units;
  final bool isPro;
  final Function(Map<String, dynamic>) onDrinkSelected;
  final Function(double, double) calculateSD;
  final AppLocalizations l10n;
  
  const _PopularDrinksGrid({
    required this.type,
    required this.drinks,
    required this.units,
    required this.isPro,
    required this.onDrinkSelected,
    required this.calculateSD,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular ${_getTypeName(type, l10n)}',
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
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            final drink = drinks[index];
            final isDrinkPro = drink['isPro'] ?? false;
            final isLocked = isDrinkPro && !isPro;
            
            return InkWell(
              onTap: () => onDrinkSelected(drink),
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
                              drink['emoji'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              drink['name'],
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
                    if (isDrinkPro)
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
  
  String _getTypeName(AlcoholType type, AppLocalizations l10n) {
    switch (type) {
      case AlcoholType.beer: return l10n.beer;
      case AlcoholType.wine: return l10n.wine;
      case AlcoholType.spirits: return l10n.spirits;
      case AlcoholType.cocktail: return 'Cocktails';
    }
  }
}

// Harm reduction card
class _HarmReductionCard extends StatelessWidget {
  final VoidCallback onDismiss;
  final AppLocalizations l10n;
  
  const _HarmReductionCard({
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
                Icons.health_and_safety,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.minimumHarm,
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
          _buildStep('💧', 'Drink 300-500 ml water now'),
          _buildStep('🧂', 'Add a pinch of salt'),
          _buildStep('☕', 'Avoid late coffee'),
          _buildStep('🛏️', 'Go to bed early'),
        ],
      ),
    );
  }
  
  Widget _buildStep(String emoji, String text) {
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