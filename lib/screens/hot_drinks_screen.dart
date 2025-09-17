// ============================================================================
// FILE: lib/screens/hot_drinks_screen.dart
// 
// PURPOSE: Hot Drinks Screen with enhanced caffeine tracking
// Uses common components and beautiful UI similar to liquids screen
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../providers/hydration_provider.dart';
import '../services/subscription_service.dart';
import '../services/units_service.dart';
import '../services/hri_service.dart';
import '../screens/paywall_screen.dart';
import '../data/items_catalog.dart';
import '../data/catalog_item.dart';

// Import common widgets
import '../widgets/common/volume_selection_dialog.dart';
import '../widgets/common/favorite_slot_selector.dart';
import '../widgets/common/type_selector.dart';
import '../widgets/common/items_grid.dart';
import '../widgets/common/status_cards.dart';

class HotDrinksScreen extends StatefulWidget {
  const HotDrinksScreen({super.key});

  @override
  State<HotDrinksScreen> createState() => _HotDrinksScreenState();
}

class _HotDrinksScreenState extends State<HotDrinksScreen> 
    with SingleTickerProviderStateMixin {
  
  // Animation controller
  late AnimationController _animController;
  
  // Favorites manager
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  
  // Items catalog
  final ItemsCatalog _catalog = ItemsCatalog();
  
  // Units
  String _units = 'metric';
  
  // Selected type
  HotDrinkType _selectedType = HotDrinkType.coffee;
  
  // Show caffeine warning
  bool _showCaffeineWarning = false;
  
  // Today's caffeine tracking
  int _todayCaffeine = 0;
  int _cupsConsumed = 0;
  
  // Daily caffeine limit (from remote config or default)
  static const int _maxCaffeine = 400;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animController.forward();
    
    _units = UnitsService.instance.units;
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    // Wait for frame to be ready
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    // Get PRO status from provider (not stored locally)
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    
    // Initialize favorites with current PRO status
    await _favoritesManager.init(subscription.isPro);
    
    // Get today's caffeine from HRIService
    final hriService = Provider.of<HRIService>(context, listen: false);
    _todayCaffeine = hriService.getTodaysCaffeine() ?? 0;
    
    if (mounted) setState(() {});
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  
  // Get items for current type from catalog
  List<CatalogItem> _getCurrentItems() {
    final allItems = _catalog.getItemsForCategory(ItemCategory.hotDrink);
    
    switch (_selectedType) {
      case HotDrinkType.coffee:
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('coffee') || 
            type.contains('espresso') || 
            type.contains('cappuccino') || 
            type.contains('latte') ||
            type.contains('macchiato') ||
            type.contains('mocha') ||
            type.contains('flat_white') ||
            type.contains('decaf') ||
            type.contains('turkish') ||
            type.contains('americano')
          );
        }).toList();
        
      case HotDrinkType.tea:
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('tea') || 
            type.contains('matcha') ||
            type.contains('chai') ||
            type.contains('earl') ||
            type.contains('chamomile') ||
            type.contains('peppermint') ||
            type.contains('rooibos')
          );
        }).toList();
        
      case HotDrinkType.other:
        return allItems.where((item) {
          final type = item.properties['type'] as String?;
          return type != null && (
            type.contains('chocolate') ||
            type.contains('cocoa') ||
            type.contains('turmeric') ||
            type.contains('cider') ||
            type.contains('ginger') ||
            type.contains('lemon') ||
            type.contains('hot_water')
          );
        }).toList();
    }
  }
  
  // Get caffeine intake data for status card
  Map<String, dynamic> _getCaffeineIntake() {
    final percent = _maxCaffeine > 0 
      ? ((_todayCaffeine / _maxCaffeine) * 100).clamp(0.0, 150.0)
      : 0.0;
    
    return {
      'current': _todayCaffeine,
      'max': _maxCaffeine,
      'percent': percent,
      'cups': _cupsConsumed,
    };
  }
  
  // Log hot drink intake
  Future<void> _logIntake({
    required CatalogItem item,
    required double volumeMl,
  }) async {
    try {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      final hriService = Provider.of<HRIService>(context, listen: false);
      final l10n = AppLocalizations.of(context);
      
      // Calculate proportional caffeine
      final baseCaffeine = (item.properties['caffeineMgPer100ml'] ?? 0) as num;
      final caffeine = (baseCaffeine * volumeMl / 100).round();
      
      // CRITICAL: Set context for AchievementService to work
      provider.setContext(context);
      
      // Determine intake type based on item type and caffeine content
      final itemType = item.properties['type'] as String? ?? '';
      final intakeType = (itemType.contains('coffee') && caffeine > 0) ? 'coffee' : 'water';
      
      // Add to hydration system with correct type
      provider.addIntake(
        intakeType,  // Now 'coffee' for coffee drinks with caffeine
        volumeMl.round(),
        sodium: 0,
        potassium: 0,
        magnesium: 0,
      );
      
      // Add caffeine to HRI if present
      if (caffeine > 0) {
        await hriService.addCaffeineIntake(caffeine.toDouble());
        
        // Update local counters
        setState(() {
          _todayCaffeine += caffeine;
          _cupsConsumed++;
        });
        
        // Check if warning needed
        if (_todayCaffeine > _maxCaffeine) {
          setState(() => _showCaffeineWarning = true);
        }
        
        // Show caffeine info snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('${caffeine}mg ${l10n.caffeine}'),
                  const Spacer(),
                  Text(
                    '${l10n.total}: ${_todayCaffeine}mg',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: _todayCaffeine > _maxCaffeine 
                ? Colors.red[600] 
                : Colors.brown[600],
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
      
      // Haptic feedback
      HapticFeedback.mediumImpact();
      
      // Success animation
      _animController.reset();
      _animController.forward();
      
    } catch (e) {
      print('Error logging hot drink: $e');
    }
  }
  
  // Save to favorites
  Future<void> _saveToFavorites({
    required CatalogItem item,
    required double volumeMl,
  }) async {
    final l10n = AppLocalizations.of(context);
    
    // Get current PRO status from provider
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    final isPro = subscription.isPro;
    
    // Show favorite slot selector with current PRO status
    final slot = await FavoriteSlotSelector.show(
      context: context,
      favoritesManager: _favoritesManager,
      isPro: isPro,
    );
    
    if (slot == null) return;
    
    // Calculate caffeine for label
    final baseCaffeine = (item.properties['caffeineMgPer100ml'] ?? 0) as num;
    final caffeine = (baseCaffeine * volumeMl / 100).round();
    
    final volumeStr = UnitsService.instance.formatVolume(volumeMl.toInt());
    final itemName = item.getName(l10n);
    var label = '$itemName $volumeStr';
    if (caffeine > 0) {
      label += ' (${caffeine}mg)';
    }
    
    final favorite = QuickFavorite(
      id: 'hot_${item.id}_${volumeMl.toInt()}',
      type: 'water',
      label: label,
      emoji: item.icon as String,
      volumeMl: volumeMl.toInt(),
      sodiumMg: 0,
      potassiumMg: 0,
      magnesiumMg: 0,
      metadata: {
        'hotDrinkType': item.properties['type'],
        'caffeine': caffeine,
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
  
  // Show hot drink dialog
Future<void> _showHotDrinkDialog(CatalogItem item) async {
  // Get current PRO status from provider
  final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
  final isPro = subscription.isPro;
  
  // Check if PRO drink
  if (item.isPro && !isPro) {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
    
    // После возврата из paywall проверяем статус снова
    final updatedSubscription = Provider.of<SubscriptionProvider>(context, listen: false);
    if (!updatedSubscription.isPro) {
      // Подписка не куплена - выходим
      return;
    }
    // Подписка куплена - продолжаем показывать диалог
  }
  
  // Обновляем favorites manager с актуальным PRO статусом
  final currentSubscription = Provider.of<SubscriptionProvider>(context, listen: false);
  await _favoritesManager.init(currentSubscription.isPro);
  
  await VolumeSelectionDialog.show(
    context: context,
    item: item,
    units: _units,
    sliderColor: Colors.blue,
    onConfirm: (volumeMl) async {
      await _logIntake(item: item, volumeMl: volumeMl);
      
      // Return to main screen with update
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    },
    onSaveToFavorites: (volumeMl) async {
      await _saveToFavorites(item: item, volumeMl: volumeMl);
    },
  );
}
  
  // Show caffeine info dialog
  void _showCaffeineInfoDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.coffee, color: Colors.brown, size: 28),
            const SizedBox(width: 12),
            Text(l10n.aboutCaffeine),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('☕', l10n.caffeineInfo1),
              const SizedBox(height: 12),
              _buildInfoRow('⚡', l10n.caffeineInfo2),
              const SizedBox(height: 12),
              _buildInfoRow('⏰', l10n.caffeineInfo3),
              const SizedBox(height: 12),
              _buildInfoRow('💧', l10n.caffeineInfo4),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.caffeineWarningPregnant,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
  
  Color _getStatusColor(double percent) {
    if (percent == 0) return Colors.green;
    if (percent <= 50) return Colors.blue;
    if (percent <= 100) return Colors.orange;
    return Colors.red;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    // Get PRO status from provider (always current)
    final subscription = Provider.of<SubscriptionProvider>(context);
    final isPro = subscription.isPro;
    
    // Get current items
    final currentItems = _getCurrentItems();
    
    // Get caffeine intake
    final intake = _getCaffeineIntake();
    final statusColor = _getStatusColor(intake['percent'] as double);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.hotDrinks),
        elevation: 0,
        backgroundColor: Colors.brown[500],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enhanced caffeine status card with ring
          CaffeineStatusCard(
            todayCaffeine: _todayCaffeine,
            l10n: l10n,
            onInfoTap: _showCaffeineInfoDialog,
          ).animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: -0.1, end: 0),
          
          const SizedBox(height: 24),
          
          // Type selector
          HotDrinkTypeSelector(
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
          
          // Items grid - uses current PRO status
          ItemsGrid(
            items: currentItems,
            isPro: isPro,  // Always current from Provider
            title: _getGridTitle(),
            onItemSelected: (item) async {
              await _showHotDrinkDialog(item);
            },
            showSugarIndicators: false,
            showElectrolyteIndicators: false,
          ).animate()
            .fadeIn(duration: 300.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Quick stats cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  title: '$_cupsConsumed',
                  subtitle: l10n.cupsToday,
                  icon: Icons.coffee,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoCard(
                  title: _getTimeToMetabolize(),
                  subtitle: l10n.metabolizeTime,
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
              ),
            ],
          ).animate()
            .fadeIn(duration: 300.ms, delay: 300.ms)
            .slideY(begin: 0.1, end: 0),
          
          const SizedBox(height: 24),
          
          // Caffeine warning tips
          if (_showCaffeineWarning)
            HydrationTipsCard(
              onDismiss: () => setState(() => _showCaffeineWarning = false),
              l10n: l10n,
              customTips: [
                TipItem(emoji: '⚠️', text: l10n.caffeineWarning400),
                TipItem(emoji: '💧', text: l10n.caffeineTipWater),
                TipItem(emoji: '🚫', text: l10n.caffeineTipAvoid),
                TipItem(emoji: '😴', text: l10n.caffeineTipSleep),
              ],
            ).animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    );
  }
  
  String _getGridTitle() {
    final l10n = AppLocalizations.of(context);
    switch (_selectedType) {
      case HotDrinkType.coffee:
        return l10n.coffee;
      case HotDrinkType.tea:
        return l10n.tea;
      case HotDrinkType.other:
        return l10n.category_other;
    }
  }
  
  String _getTimeToMetabolize() {
    // Caffeine half-life is ~5 hours
    if (_todayCaffeine == 0) return '0h';
    
    // Simple estimation: 5 hours for half, 10 hours for most
    final hours = (_todayCaffeine / 50).clamp(1, 10).round();
    return '~${hours}h';
  }
}