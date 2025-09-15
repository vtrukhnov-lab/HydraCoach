// lib/screens/liquids_catalog_screen.dart
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
import '../data/items_catalog.dart';
import '../data/catalog_item.dart';

// Import common widgets
import '../widgets/common/water_ring_widget.dart';
import '../widgets/common/volume_selection_dialog.dart';
import '../widgets/common/favorite_slot_selector.dart';
import '../widgets/common/type_selector.dart';
import '../widgets/common/items_grid.dart';
import '../widgets/common/status_cards.dart';

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
  
  // Items catalog
  final ItemsCatalog _catalog = ItemsCatalog();
  
  // PRO status
  bool _isPro = false;
  
  // Units
  String _units = 'metric';
  
  // Selected type
  LiquidType _selectedType = LiquidType.plain;
  
  // Show hydration tips
  bool _showHydrationTips = false;
  
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
  
  // Get items for current type from catalog
  List<CatalogItem> _getCurrentItems() {
    switch (_selectedType) {
      case LiquidType.plain:
        return _catalog.getWaterItems(subtype: 'plain');
      case LiquidType.enhanced:
        return _catalog.getWaterItems(subtype: 'enhanced');
      case LiquidType.beverages:
        return _catalog.getWaterItems(subtype: 'beverages');
      case LiquidType.sodas:
        return _catalog.getWaterItems(subtype: 'sodas');
    }
  }
  
  // Get today's water intake
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
      final effectiveVolume = volumeMl * hydrationFactor;
      
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
  
  // Save to favorites
  Future<void> _saveToFavorites({
    required CatalogItem item,
    required double volumeMl,
  }) async {
    final l10n = AppLocalizations.of(context);
    
    // Show favorite slot selector
    final slot = await FavoriteSlotSelector.show(
      context: context,
      favoritesManager: _favoritesManager,
      isPro: _isPro,
    );
    
    if (slot == null) return;
    
    final volumeStr = UnitsService.instance.formatVolume(volumeMl.toInt());
    final itemName = item.getName(l10n);
    
    final favorite = QuickFavorite(
      id: 'liquid_${item.id}_${volumeMl.toInt()}',
      type: 'water',
      label: '$itemName: $volumeStr',
      emoji: item.icon as String,
      volumeMl: volumeMl.toInt(),
      metadata: {
        'liquidName': itemName,
        'hydrationFactor': item.properties['hydration'] ?? 1.0,
        'sugar': item.properties['sugar'] ?? 0.0,
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
  
  // Show liquid confirmation dialog with slider
  Future<void> _showLiquidConfirmationDialog({
    required CatalogItem item,
  }) async {
    // Check if PRO liquid
    if (item.isPro && !_isPro) {
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
    
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return VolumeSelectionDialog(
          item: item,
          units: _units,
          onConfirm: (volumeMl) async {
            await _logIntake(
              name: item.getName(l10n),
              volumeMl: volumeMl,
              hydrationFactor: (item.properties['hydration'] as num? ?? 1.0).toDouble(),
              emoji: item.icon as String,
              sugar: (item.properties['sugar'] ?? 0.0) as double,
            );
            
            // Return to main screen with update
            if (mounted) {
              Navigator.of(context).pop(true); // true means data changed
            }
          },
          onSaveToFavorites: (volumeMl) async {
            await _saveToFavorites(
              item: item,
              volumeMl: volumeMl,
            );
          },
        );
      },
    );
  }
  
  Color _getStatusColor(double percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.blue;
    if (percent >= 25) return Colors.orange;
    return Colors.red;
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
    
    // Get items for current type
    final currentItems = _getCurrentItems();
    
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
          // Status card with animated water ring
          AnimatedStatusCard(
            intake: intake,
            statusColor: statusColor,
            l10n: l10n,
            units: _units,
          ).animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: -0.1, end: 0),
          
          const SizedBox(height: 24),
          
          // Type selector
          LiquidTypeSelector(
            selectedType: _selectedType,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
              });
              HapticFeedback.selectionClick();
            },
          ).animate()
            .fadeIn(duration: 300.ms, delay: 100.ms)
            .slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 20),
          
          // Items grid using catalog items
          ItemsGrid(
            items: currentItems,
            isPro: _isPro,
            title: l10n.selectDrinkType,
            onItemSelected: (item) async {
              await _showLiquidConfirmationDialog(item: item);
            },
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Hydration tips card
          if (_showHydrationTips)
            HydrationTipsCard(
              onDismiss: () => setState(() => _showHydrationTips = false),
              l10n: l10n,
            ),
        ],
      ),
    );
  }
}