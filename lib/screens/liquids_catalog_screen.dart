// ============================================================================
// FILE: lib/screens/liquids_catalog_screen.dart
// 
// PURPOSE: Liquids Catalog Screen (Based on Alcohol Log Screen template)
// Allows users to select and log various liquid/drink types.
// Uses the same UI/UX pattern as alcohol_log_screen for consistency.
// 
// FEATURES:
// - 3x3 grid of drink types (3 FREE, 6 PRO)
// - Volume input with validation
// - Save to favorites functionality
// - PRO gating for premium drink types
// - Consistent design with alcohol screen
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';
import '../main.dart';

class LiquidsCatalogScreen extends StatefulWidget {
  const LiquidsCatalogScreen({super.key});

  @override
  State<LiquidsCatalogScreen> createState() => _LiquidsCatalogScreenState();
}

class _LiquidsCatalogScreenState extends State<LiquidsCatalogScreen> {
  // Состояние экрана - точно как в AlcoholLogScreen
  List<Map<String, dynamic>> _drinkTypes = [];
  int _selectedIndex = 0;
  final TextEditingController _volumeController = TextEditingController(text: '250');
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    _checkForPreselectedValues();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeDrinkTypes();
  }
  
  void _initializeDrinkTypes() {
    final l10n = AppLocalizations.of(context);
    
    _drinkTypes = [
      // FREE типы
      {'type': 'water', 'label': l10n.water, 'icon': Icons.water_drop, 'isPro': false},
      {'type': 'sparkling', 'label': l10n.sparklingWater, 'icon': Icons.bubble_chart, 'isPro': false},
      {'type': 'lemon', 'label': l10n.lemonWater, 'icon': Icons.eco, 'isPro': false},
      // PRO типы
      {'type': 'coconut', 'label': l10n.coconutWater, 'icon': Icons.beach_access, 'isPro': true},
      {'type': 'mineral', 'label': l10n.mineralWater, 'icon': Icons.opacity, 'isPro': true},
      {'type': 'cola', 'label': l10n.cola, 'icon': Icons.local_drink, 'isPro': true},
      {'type': 'juice', 'label': l10n.juice, 'icon': Icons.local_bar, 'isPro': true},
      {'type': 'energy', 'label': l10n.energyDrink, 'icon': Icons.battery_charging_full, 'isPro': true},
      {'type': 'sports', 'label': l10n.sportsDrink, 'icon': Icons.fitness_center, 'isPro': true},
    ];
  }

  void _checkForPreselectedValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          if (args['preselected'] != null) {
            final typeKey = args['preselected'];
            final index = _drinkTypes.indexWhere((d) => d['type'] == typeKey);
            if (index != -1) {
              _selectedIndex = index;
            }
          }
          if (args['volume'] != null) {
            _volumeController.text = args['volume'].toString();
          }
        });
      }
    });
  }

  Future<void> _initializeFavorites() async {
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    _isPro = subscription.isPro;
    await _favoritesManager.init(_isPro);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  void _selectDrink(int index) {
    final drink = _drinkTypes[index];
    if (drink['isPro'] && !_isPro) {
      _showProPaywall();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showProPaywall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _saveIntake() async {
    final l10n = AppLocalizations.of(context);
    final volume = double.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidVolume)),
      );
      return;
    }

    final drink = _drinkTypes[_selectedIndex];
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Сохраняем как обычный прием жидкости
    provider.addIntake(
      drink['type'] as String,
      volume.toInt(),
      sodium: 0,
      potassium: 0,
      magnesium: 0,
    );

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveToFavorites() async {
    final l10n = AppLocalizations.of(context);
    final volume = double.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidVolume)),
      );
      return;
    }

    final slot = await _showFavoriteSlotSelector(l10n);
    if (slot == null) return;

    final drink = _drinkTypes[_selectedIndex];
    final label = '${drink['label']} ${volume.toInt()}${l10n.ml}';
    
    final favorite = QuickFavorite(
      id: 'liquid_${drink['type']}_${volume.toInt()}',
      type: 'water', // Используем 'water' как тип для всех жидкостей
      label: label,
      emoji: '', // Не используем эмодзи
      volumeMl: volume.toInt(),
      metadata: {
        'liquidType': drink['type'],
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
      Navigator.of(context).pop(true);
    }
  }

  Future<int?> _showFavoriteSlotSelector(AppLocalizations l10n) async {
    return await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.selectFavoriteSlot,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < 3; i++) ...[
              _buildSlotOption(i, l10n),
              if (i < 2) const SizedBox(height: 12),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotOption(int slot, AppLocalizations l10n) {
    final isLocked = !_isPro && slot > 0;
    final currentFavorite = _favoritesManager.favorites[slot];
    
    if (isLocked) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.star, color: Colors.purple.shade600),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.lock, size: 12, color: Colors.purple.shade600),
              ),
            ],
          ),
        ),
        title: Text('${l10n.slot} ${slot + 1} (PRO)'),
        subtitle: Text(l10n.upgradeToUnlock),
        trailing: Icon(Icons.lock_outline, color: Colors.purple.shade400),
        onTap: () {
          Navigator.pop(context);
          _showProPaywall();
        },
      );
    }
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: currentFavorite != null ? Colors.orange.shade50 : Colors.green.shade50,
        child: currentFavorite != null 
          ? Icon(_getFavoriteIcon(currentFavorite), color: Colors.orange.shade600)
          : Icon(Icons.add, color: Colors.green.shade600),
      ),
      title: Text('${l10n.slot} ${slot + 1}'),
      subtitle: currentFavorite != null 
        ? Text(currentFavorite.label)
        : Text(l10n.emptySlot),
      trailing: currentFavorite != null 
        ? Icon(Icons.swap_horiz, color: Colors.orange.shade400)
        : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pop(context, slot),
    );
  }
  
  IconData _getFavoriteIcon(QuickFavorite favorite) {
    final liquidType = favorite.metadata?['liquidType'] ?? 'water';
    switch (liquidType) {
      case 'water':
        return Icons.water_drop;
      case 'sparkling':
        return Icons.bubble_chart;
      case 'lemon':
        return Icons.eco;
      case 'coconut':
        return Icons.beach_access;
      case 'mineral':
        return Icons.opacity;
      case 'cola':
        return Icons.local_drink;
      case 'juice':
        return Icons.local_bar;
      case 'energy':
        return Icons.battery_charging_full;
      case 'sports':
        return Icons.fitness_center;
      default:
        return Icons.water_drop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.selectDrinkType),
        elevation: 0,
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectDrinkType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: _drinkTypes.isEmpty ? 9 : _drinkTypes.length,
              itemBuilder: (context, index) {
                if (_drinkTypes.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.grey[400]),
                      ),
                    ),
                  );
                }
                
                final drink = _drinkTypes[index];
                final isSelected = _selectedIndex == index;
                final isLocked = drink['isPro'] && !_isPro;
                
                return GestureDetector(
                  onTap: () => _selectDrink(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isLocked 
                          ? Colors.grey[50] 
                          : (isSelected ? Colors.blue[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.blue[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  drink['icon'] as IconData,
                                  size: 60,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected ? Colors.blue[500] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  drink['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.blue[700] : Colors.grey[800]),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isLocked)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
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
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            Text(
              l10n.volume,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _volumeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.enterVolume,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[500]!, width: 2),
                ),
                suffixText: l10n.ml,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Информационная карточка о выбранном напитке (вместо расчетов SD)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    _drinkTypes.isNotEmpty 
                        ? _drinkTypes[_selectedIndex]['icon'] as IconData
                        : Icons.water_drop,
                    size: 48,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _drinkTypes.isNotEmpty 
                        ? _drinkTypes[_selectedIndex]['label']
                        : '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_volumeController.text.isEmpty ? '0' : _volumeController.text} ${l10n.ml}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveIntake,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(
                      l10n.add,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _saveToFavorites,
                    icon: const Icon(Icons.star_border),
                    label: Text(
                      l10n.saveToFavorites,
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.amber[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.amber[600]!, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}