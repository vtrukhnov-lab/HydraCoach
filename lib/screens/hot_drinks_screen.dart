// ============================================================================
// FILE: lib/screens/hot_drinks_screen.dart
// 
// PURPOSE: Hot Drinks Screen for coffee, tea and other hot beverages
// Allows users to select and log various hot drinks with caffeine tracking.
// Uses the same UI/UX pattern as other catalog screens for consistency.
// 
// FEATURES:
// - Grid of hot drink types (3 FREE, 6 PRO)
// - Volume input with quick selection buttons
// - Caffeine content display
// - Save to favorites functionality
// - PRO gating for premium drinks
// - Brown color scheme
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';
import '../main.dart';

class HotDrinksScreen extends StatefulWidget {
  const HotDrinksScreen({super.key});

  @override
  State<HotDrinksScreen> createState() => _HotDrinksScreenState();
}

class _HotDrinksScreenState extends State<HotDrinksScreen> {
  List<Map<String, dynamic>> _drinkTypes = [];
  int _selectedIndex = 0;
  final TextEditingController _volumeController = TextEditingController(text: '200');
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;

  // Быстрые объемы для разных типов напитков
  List<int> _getQuickVolumes() {
    if (_drinkTypes.isEmpty) return [100, 200, 250];
    
    final drinkType = _drinkTypes[_selectedIndex]['type'] as String;
    switch (drinkType) {
      case 'espresso':
        return [30, 60, 90]; // Эспрессо порции
      case 'coffee':
      case 'cappuccino':
      case 'latte':
        return [150, 200, 300]; // Кофейные напитки
      case 'black_tea':
      case 'green_tea':
      case 'herbal_tea':
      case 'matcha':
        return [200, 250, 350]; // Чаи
      case 'hot_chocolate':
        return [200, 250, 300]; // Горячий шоколад
      default:
        return [150, 200, 250];
    }
  }

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
      {
        'type': 'coffee',
        'label': l10n.coffee,
        'icon': Icons.coffee,
        'defaultVolume': 200,
        'caffeine': 80,  // mg кофеина
        'isPro': false
      },
      {
        'type': 'black_tea',
        'label': l10n.blackTea ?? 'Black Tea',
        'icon': Icons.emoji_food_beverage,
        'defaultVolume': 250,
        'caffeine': 40,
        'isPro': false
      },
      {
        'type': 'herbal_tea',
        'label': l10n.herbalTea ?? 'Herbal Tea',
        'icon': Icons.local_florist,
        'defaultVolume': 250,
        'caffeine': 0,
        'isPro': false
      },
      // PRO типы
      {
        'type': 'espresso',
        'label': l10n.espresso ?? 'Espresso',
        'icon': Icons.coffee_maker,
        'defaultVolume': 30,
        'caffeine': 64,
        'isPro': true
      },
      {
        'type': 'cappuccino',
        'label': l10n.cappuccino ?? 'Cappuccino',
        'icon': Icons.coffee,
        'defaultVolume': 180,
        'caffeine': 75,
        'isPro': true
      },
      {
        'type': 'latte',
        'label': l10n.latte ?? 'Latte',
        'icon': Icons.coffee,
        'defaultVolume': 250,
        'caffeine': 75,
        'isPro': true
      },
      {
        'type': 'green_tea',
        'label': l10n.greenTea ?? 'Green Tea',
        'icon': Icons.eco,
        'defaultVolume': 250,
        'caffeine': 25,
        'isPro': true
      },
      {
        'type': 'matcha',
        'label': l10n.matcha ?? 'Matcha',
        'icon': Icons.grass,
        'defaultVolume': 200,
        'caffeine': 70,
        'isPro': true
      },
      {
        'type': 'hot_chocolate',
        'label': l10n.hotChocolate ?? 'Hot Chocolate',
        'icon': Icons.local_cafe,
        'defaultVolume': 250,
        'caffeine': 5,
        'isPro': true
      },
    ];
    
    // Set default volume for first drink
    if (_drinkTypes.isNotEmpty) {
      _volumeController.text = _drinkTypes[0]['defaultVolume'].toString();
    }
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

  int _calculateCaffeine() {
    if (_drinkTypes.isEmpty) return 0;
    
    final drink = _drinkTypes[_selectedIndex];
    final volume = double.tryParse(_volumeController.text) ?? 0;
    final defaultVolume = drink['defaultVolume'] as int;
    final caffeine = drink['caffeine'] as int;
    
    // Пропорциональный расчет кофеина
    return ((caffeine * volume) / defaultVolume).round();
  }

  Future<void> _saveIntake() async {
    final l10n = AppLocalizations.of(context);
    final volume = int.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidVolume)),
      );
      return;
    }

    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final drinkType = _drinkTypes[_selectedIndex]['type'];
    
    // Для горячих напитков всегда используем тип 'coffee' в старой системе
    // чтобы активировать post-coffee reminder
    final intakeType = drinkType == 'herbal_tea' ? 'hot' : 'coffee';
    
    provider.addIntake(intakeType, volume);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveToFavorites() async {
    final l10n = AppLocalizations.of(context);
    final volume = int.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidVolume)),
      );
      return;
    }

    final slot = await _showFavoriteSlotSelector(l10n);
    if (slot == null) return;

    final drink = _drinkTypes[_selectedIndex];
    final caffeine = _calculateCaffeine();
    
    String label = '${drink['label']} ${volume}ml';
    if (caffeine > 0) {
      label += ' (${caffeine}mg caff)';
    }
    
    final favorite = QuickFavorite(
      id: 'hot_${drink['type']}_$volume',
      type: drink['type'] == 'herbal_tea' ? 'hot' : 'coffee',
      label: label,
      emoji: '',
      volumeMl: volume,
      sodiumMg: 0,
      potassiumMg: 0,
      magnesiumMg: 0,
      metadata: {
        'hotDrinkType': drink['type'],
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
          ? Icon(Icons.coffee, color: Colors.orange.shade600)
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    final caffeine = _calculateCaffeine();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.hotDrinks ?? 'Hot Drinks'),
        elevation: 0,
        backgroundColor: Colors.brown[500],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectDrinkType ?? 'Select drink type',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid для напитков
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0, // Квадратные ячейки как в других экранах
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
                          : (isSelected ? Colors.brown[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.brown[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.2),
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
                                  size: 60, // Размер как в других экранах
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected ? Colors.brown[600] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  drink['label'],
                                  style: TextStyle(
                                    fontSize: 13, // Размер как в других экранах
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.brown[700] : Colors.grey[800]),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1, // Одна строка как в других экранах
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
                        borderSide: BorderSide(color: Colors.brown[500]!, width: 2),
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
                            ? Colors.brown[500]
                            : Colors.white,
                        foregroundColor: _volumeController.text == volume.toString()
                            ? Colors.white
                            : Colors.brown[700],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _volumeController.text == volume.toString()
                                ? Colors.brown[500]!
                                : Colors.brown[200]!,
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
                }),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Улучшенная информационная карточка
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown[50]!, Colors.brown[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (_drinkTypes.isNotEmpty) ...[
                    Icon(
                      _drinkTypes[_selectedIndex]['icon'] as IconData,
                      size: 48,
                      color: Colors.brown[600],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _drinkTypes[_selectedIndex]['label'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Объем крупным шрифтом
                    Text(
                      '${_volumeController.text.isEmpty ? '0' : _volumeController.text} ${l10n.ml}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                  
                  // Кофеин в отдельном белом блоке
                  if (caffeine > 0) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 20,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.caffeine ?? 'Caffeine'}: $caffeine mg',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco,
                            size: 20,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.caffeine != null ? '${l10n.caffeine}: 0 mg' : 'Caffeine free',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      backgroundColor: Colors.brown[500],
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