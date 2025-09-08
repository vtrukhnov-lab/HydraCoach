// ============================================================================
// FILE: lib/screens/alcohol_log_screen.dart
// 
// PURPOSE: Alcohol Logging Screen
// Allows users to log alcohol consumption with automatic hydration adjustments.
// Calculates standard drinks (SD) and required water/sodium corrections.
// 
// FEATURES:
// - 3x3 grid of alcohol types (3 FREE, 6 PRO)
// - Auto-calculation of standard drinks based on volume and ABV
// - Quick volume selection buttons
// - Shows hydration corrections needed (water, sodium, HRI impact)
// - Save to favorites functionality
// - PRO gating for premium alcohol types
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/alcohol_intake.dart';
import '../models/quick_favorites.dart';
import '../services/alcohol_service.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';

class AlcoholLogScreen extends StatefulWidget {
  const AlcoholLogScreen({super.key});

  @override
  State<AlcoholLogScreen> createState() => _AlcoholLogScreenState();
}

class _AlcoholLogScreenState extends State<AlcoholLogScreen> {
  AlcoholType _selectedType = AlcoholType.beer;
  final TextEditingController _volumeController = TextEditingController(text: '500');
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;
  
  List<Map<String, dynamic>> _drinkTypes = [];
  int _selectedIndex = 0;
  
  // Быстрые объемы для разных типов напитков
  List<int> _getQuickVolumes() {
    if (_drinkTypes.isEmpty) return [330, 500, 750];
    
    final drinkType = _drinkTypes[_selectedIndex]['type'] as AlcoholType;
    switch (drinkType) {
      case AlcoholType.beer:
        return [330, 500, 750]; // Стандартные объемы пива
      case AlcoholType.wine:
        return [150, 250, 375]; // Стандартные объемы вина
      case AlcoholType.spirits:
        final subtype = _drinkTypes[_selectedIndex]['subtype'];
        if (subtype != null) {
          return [30, 50, 100]; // Для конкретных крепких напитков
        }
        return [50, 100, 200]; // Общие крепкие напитки
      case AlcoholType.cocktail:
        return [200, 300, 400]; // Стандартные объемы коктейлей
      default:
        return [250, 500, 750];
    }
  }
  
  double get _standardDrinks {
    final volume = double.tryParse(_volumeController.text) ?? 0;
    final abv = _drinkTypes.isEmpty ? 5.0 : _drinkTypes[_selectedIndex]['abv'] as double;
    return AlcoholIntake(
      timestamp: DateTime.now(),
      type: _selectedType,
      volumeMl: volume,
      abv: abv,
    ).standardDrinks;
  }
  
  double get _waterCorrection => _standardDrinks * 150;
  double get _sodiumCorrection => _standardDrinks * 200;
  double get _hriModifier => (_standardDrinks * 3.0).clamp(0, 15);

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
      {'type': AlcoholType.beer, 'label': l10n.beer, 'icon': Icons.sports_bar, 'abv': 5.0, 'isPro': false, 'defaultVolume': 500},
      {'type': AlcoholType.wine, 'label': l10n.wine, 'icon': Icons.wine_bar, 'abv': 12.0, 'isPro': false, 'defaultVolume': 150},
      {'type': AlcoholType.spirits, 'label': l10n.spirits, 'icon': Icons.liquor, 'abv': 40.0, 'isPro': false, 'defaultVolume': 50},
      // PRO типы
      {'type': AlcoholType.cocktail, 'label': l10n.cocktail, 'icon': Icons.local_drink, 'abv': 15.0, 'isPro': true, 'defaultVolume': 200},
      {'type': AlcoholType.spirits, 'label': l10n.drink_vodka, 'icon': Icons.liquor, 'abv': 40.0, 'isPro': true, 'subtype': 'vodka', 'defaultVolume': 50},
      {'type': AlcoholType.spirits, 'label': l10n.drink_whiskey, 'icon': Icons.liquor, 'abv': 40.0, 'isPro': true, 'subtype': 'whiskey', 'defaultVolume': 50},
      {'type': AlcoholType.spirits, 'label': l10n.drink_rum, 'icon': Icons.liquor, 'abv': 38.0, 'isPro': true, 'subtype': 'rum', 'defaultVolume': 50},
      {'type': AlcoholType.spirits, 'label': l10n.drink_tequila, 'icon': Icons.liquor, 'abv': 40.0, 'isPro': true, 'subtype': 'tequila', 'defaultVolume': 30},
      {'type': AlcoholType.spirits, 'label': l10n.drink_gin, 'icon': Icons.liquor, 'abv': 40.0, 'isPro': true, 'subtype': 'gin', 'defaultVolume': 50},
    ];
  }

  void _checkForPreselectedValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          if (args['preselected'] != null) {
            final typeKey = args['preselected'];
            final index = _drinkTypes.indexWhere((d) => 
              d['type'].key == typeKey || d['subtype'] == typeKey
            );
            if (index != -1) {
              _selectedIndex = index;
              _selectedType = _drinkTypes[index]['type'] as AlcoholType;
              // Устанавливаем рекомендуемый объем
              _volumeController.text = _drinkTypes[index]['defaultVolume'].toString();
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
      _selectedType = drink['type'] as AlcoholType;
      // Устанавливаем рекомендуемый объем при выборе напитка
      _volumeController.text = drink['defaultVolume'].toString();
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

    final intake = AlcoholIntake(
      timestamp: DateTime.now(),
      type: _selectedType,
      volumeMl: volume,
      abv: _drinkTypes[_selectedIndex]['abv'] as double,
    );

    final alcoholService = Provider.of<AlcoholService>(context, listen: false);
    await alcoholService.addIntake(intake);

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
    final abv = drink['abv'] as double;
    final label = '${drink['label']}: ${abv.toStringAsFixed(0)}%';
    final iconName = (drink['icon'] as IconData).codePoint.toString();
    
    final favorite = QuickFavorite(
      id: 'alcohol_${_selectedType.key}_${volume.toInt()}_${abv.toStringAsFixed(1)}',
      type: 'alcohol',
      label: label,
      emoji: '', // Не используем эмодзи
      volumeMl: volume.toInt(),
      metadata: {
        'alcoholType': _selectedType.key,
        'abv': abv,
        'subtype': drink['subtype'],
        'iconName': iconName, // Сохраняем информацию об иконке
      },
    );

    await _favoritesManager.saveFavorite(slot, favorite);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.savedToFavorites} (Slot ${slot + 1})'),
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
    final alcoholType = favorite.metadata?['alcoholType'] ?? 'beer';
    switch (alcoholType) {
      case 'beer':
        return Icons.sports_bar;
      case 'wine':
        return Icons.wine_bar;
      case 'spirits':
        return Icons.liquor;
      case 'cocktail':
        return Icons.local_drink;
      default:
        return Icons.local_drink;
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
        title: Text(l10n.addAlcohol),
        elevation: 0,
        backgroundColor: Colors.red[500],
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
                          : (isSelected ? Colors.red[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.red[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
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
                                      : (isSelected ? Colors.red[500] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${drink['label']}: ${(drink['abv'] as double).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.red[700] : Colors.grey[800]),
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
            
            // Поле ввода с быстрыми кнопками как в других экранах
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
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
                        borderSide: BorderSide(color: Colors.red[500]!, width: 2),
                      ),
                      suffixText: l10n.ml,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Быстрые кнопки выбора объема
                ..._getQuickVolumes().map((volume) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _volumeController.text = volume.toString();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _volumeController.text == volume.toString()
                            ? Colors.red[500]
                            : Colors.white,
                        foregroundColor: _volumeController.text == volume.toString()
                            ? Colors.white
                            : Colors.red[700],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _volumeController.text == volume.toString()
                                ? Colors.red[500]!
                                : Colors.red[200]!,
                            width: 1.5,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        volume.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
            
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[50]!, Colors.red[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.standardDrinks,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_standardDrinks.toStringAsFixed(1)} SD',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCorrectionItem(
                        '+${_waterCorrection.toStringAsFixed(0)} ${l10n.ml}',
                        l10n.additionalWater,
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      _buildCorrectionItem(
                        '+${_sodiumCorrection.toStringAsFixed(0)} ${l10n.mg}',
                        l10n.additionalSodium,
                        Icons.grain,
                        Colors.purple,
                      ),
                      _buildCorrectionItem(
                        '+${_hriModifier.toStringAsFixed(1)}',
                        l10n.hriRisk,
                        Icons.warning,
                        Colors.orange,
                      ),
                    ],
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
                      backgroundColor: Colors.red[500],
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
  
  Widget _buildCorrectionItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}