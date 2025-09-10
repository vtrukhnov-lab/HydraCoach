// ============================================================================
// FILE: lib/screens/hot_drinks_screen.dart
// 
// PURPOSE: Hot Drinks Screen with Imperial/Metric support
// Tracks various hot beverages and their caffeine content for HRI calculation.
// Supports both metric (ml) and imperial (fl oz) units.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../services/subscription_service.dart';
import '../services/units_service.dart';
import '../services/hri_service.dart';
import '../screens/paywall_screen.dart';
import 'package:hydracoach/providers/hydration_provider.dart';

class HotDrinksScreen extends StatefulWidget {
  const HotDrinksScreen({super.key});

  @override
  State<HotDrinksScreen> createState() => _HotDrinksScreenState();
}

class _HotDrinksScreenState extends State<HotDrinksScreen> {
  List<Map<String, dynamic>> _drinkTypes = [];
  int _selectedIndex = 0;
  final TextEditingController _volumeController = TextEditingController();
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;
  String _units = 'metric';

  @override
  void initState() {
    super.initState();
    _units = UnitsService.instance.units;
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
    final isImperial = _units == 'imperial';
    
    _drinkTypes = [
      // FREE drinks
      {
        'type': 'coffee',
        'label': l10n.coffee,
        'icon': Icons.coffee,
        'defaultVolume': isImperial ? 8 : 200,  // 8 oz / 200 ml
        'caffeineMgPer100ml': 40,
        'isPro': false,
        'color': Colors.brown,
      },
      {
        'type': 'black_tea',
        'label': l10n.blackTea,
        'icon': Icons.emoji_food_beverage,
        'defaultVolume': isImperial ? 8 : 250,  // 8 oz / 250 ml
        'caffeineMgPer100ml': 20,
        'isPro': false,
        'color': Colors.brown[800],
      },
      {
        'type': 'herbal_tea',
        'label': l10n.herbalTea,
        'icon': Icons.local_florist,
        'defaultVolume': isImperial ? 8 : 250,  // 8 oz / 250 ml
        'caffeineMgPer100ml': 0,
        'isPro': false,
        'color': Colors.green[700],
      },
      
      // PRO drinks
      {
        'type': 'espresso',
        'label': l10n.espresso,
        'icon': Icons.coffee_maker,
        'defaultVolume': isImperial ? 1 : 30,  // 1 oz / 30 ml
        'caffeineMgPer100ml': 212,
        'isPro': true,
        'color': Colors.brown[900],
      },
      {
        'type': 'cappuccino',
        'label': l10n.cappuccino,
        'icon': Icons.free_breakfast,
        'defaultVolume': isImperial ? 6 : 180,  // 6 oz / 180 ml
        'caffeineMgPer100ml': 42,
        'isPro': true,
        'color': Colors.brown[600],
      },
      {
        'type': 'latte',
        'label': l10n.latte,
        'icon': Icons.local_cafe,
        'defaultVolume': isImperial ? 8 : 250,  // 8 oz / 250 ml
        'caffeineMgPer100ml': 30,
        'isPro': true,
        'color': Colors.brown[400],
      },
      {
        'type': 'green_tea',
        'label': l10n.greenTea,
        'icon': Icons.eco,
        'defaultVolume': isImperial ? 8 : 250,  // 8 oz / 250 ml
        'caffeineMgPer100ml': 12,
        'isPro': true,
        'color': Colors.green[600],
      },
      {
        'type': 'matcha',
        'label': l10n.matcha,
        'icon': Icons.grass,
        'defaultVolume': isImperial ? 6 : 200,  // 6 oz / 200 ml
        'caffeineMgPer100ml': 35,
        'isPro': true,
        'color': Colors.green[800],
      },
      {
        'type': 'hot_chocolate',
        'label': l10n.hotChocolate,
        'icon': Icons.cake,
        'defaultVolume': isImperial ? 8 : 250,  // 8 oz / 250 ml
        'caffeineMgPer100ml': 2,
        'isPro': true,
        'color': Colors.brown[300],
      },
    ];
    
    if (_drinkTypes.isNotEmpty) {
      _volumeController.text = _drinkTypes[0]['defaultVolume'].toString();
    }
  }

  // Быстрые объемы в зависимости от типа напитка
  List<int> _getQuickVolumes() {
    if (_drinkTypes.isEmpty) return _units == 'imperial' ? [6, 8, 12] : [100, 200, 250];
    
    final drinkType = _drinkTypes[_selectedIndex]['type'] as String;
    final isImperial = _units == 'imperial';
    
    switch (drinkType) {
      case 'espresso':
        return isImperial ? [1, 2, 3] : [30, 60, 90];
      case 'coffee':
      case 'cappuccino':
        return isImperial ? [6, 8, 10] : [150, 200, 250];
      case 'latte':
        return isImperial ? [8, 10, 12] : [200, 250, 350];
      case 'black_tea':
      case 'green_tea':
      case 'herbal_tea':
      case 'matcha':
        return isImperial ? [8, 10, 12] : [200, 250, 350];
      case 'hot_chocolate':
        return isImperial ? [8, 10, 12] : [200, 250, 300];
      default:
        return isImperial ? [6, 8, 10] : [150, 200, 250];
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
            // Конвертируем из мл в текущие единицы
            final volumeMl = args['volume'] as int;
            final displayVolume = _units == 'imperial' 
              ? (volumeMl / 29.5735).round() 
              : volumeMl;
            _volumeController.text = displayVolume.toString();
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

  // Точный расчет кофеина на основе объема
  double _calculateCaffeine() {
    if (_drinkTypes.isEmpty) return 0;
    
    final drink = _drinkTypes[_selectedIndex];
    var volume = double.tryParse(_volumeController.text) ?? 0;
    
    // Конвертируем в мл для расчетов
    final volumeMl = _units == 'imperial' ? volume * 29.5735 : volume;
    
    final caffeinePer100ml = drink['caffeineMgPer100ml'] as int;
    
    // Кофеин = (мг на 100мл) * (объем / 100)
    return (caffeinePer100ml * volumeMl / 100);
  }

  // Определяем источник напитка для HRI
  String _getDrinkSource() {
    if (_drinkTypes.isEmpty) return 'unknown';
    
    final drinkType = _drinkTypes[_selectedIndex]['type'] as String;
    switch (drinkType) {
      case 'espresso':
      case 'cappuccino':
      case 'latte':
        return 'espresso_based';
      case 'coffee':
        return 'coffee';
      case 'black_tea':
      case 'green_tea':
        return 'tea';
      case 'matcha':
        return 'matcha';
      case 'hot_chocolate':
        return 'chocolate';
      case 'herbal_tea':
        return 'herbal';
      default:
        return drinkType;
    }
  }

  Future<void> _saveIntake() async {
    final l10n = AppLocalizations.of(context);
    var volume = int.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterValidVolume),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Конвертируем в мл для сохранения
    final volumeMl = _units == 'imperial' 
      ? (volume * 29.5735).round()
      : volume;

    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final hriService = Provider.of<HRIService>(context, listen: false);
    
    final caffeine = _calculateCaffeine();
    final drinkSource = _getDrinkSource();
    final drinkLabel = _drinkTypes[_selectedIndex]['label'];
    
    // Добавляем воду в систему гидратации
    // Используем тип 'coffee' только для напитков с кофеином для активации напоминаний
    final intakeType = caffeine > 0 ? 'coffee' : 'hot';
    provider.addIntake(intakeType, volumeMl);
    
    // ВАЖНО: Добавляем кофеин в HRI Service если он есть
    if (caffeine > 0) {
      await hriService.addCaffeineIntake(caffeine, source: drinkSource);
      
      // Показываем уведомление о кофеине
      if (mounted) {
        final volumeUnit = _units == 'imperial' ? (l10n.oz ?? 'oz') : l10n.ml;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$drinkLabel added: $volume$volumeUnit (${caffeine.toStringAsFixed(0)}mg caffeine)'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Для напитков без кофеина
      if (mounted) {
        final volumeUnit = _units == 'imperial' ? (l10n.oz ?? 'oz') : l10n.ml;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$drinkLabel added: $volume$volumeUnit (caffeine-free)'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _saveToFavorites() async {
    final l10n = AppLocalizations.of(context);
    var volume = int.tryParse(_volumeController.text);
    
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidVolume)),
      );
      return;
    }

    final slot = await _showFavoriteSlotSelector(l10n);
    if (slot == null) return;

    // Конвертируем в мл для сохранения
    final volumeMl = _units == 'imperial' 
      ? (volume * 29.5735).round()
      : volume;

    final drink = _drinkTypes[_selectedIndex];
    final caffeine = _calculateCaffeine();
    
    final volumeUnit = _units == 'imperial' ? (l10n.oz ?? 'oz') : l10n.ml;
    String label = '${drink['label']} $volume$volumeUnit';
    if (caffeine > 0) {
      label += ' (${caffeine.toStringAsFixed(0)}mg)';
    }
    
    final favorite = QuickFavorite(
      id: 'hot_${drink['type']}_$volumeMl',
      type: caffeine > 0 ? 'coffee' : 'hot',
      label: label,
      emoji: '',
      volumeMl: volumeMl,
      sodiumMg: 0,
      potassiumMg: 0,
      magnesiumMg: 0,
      metadata: {
        'hotDrinkType': drink['type'],
        'caffeine': caffeine,
        'source': _getDrinkSource(),
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
    final volumeUnit = _units == 'imperial' ? (l10n.oz ?? 'oz') : l10n.ml;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.hotDrinks),
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
              l10n.selectDrinkType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Drink selection grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: _drinkTypes.length,
              itemBuilder: (context, index) {
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
                                  size: 60,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected 
                                          ? (drink['color'] as Color? ?? Colors.brown[600]) 
                                          : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  drink['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.brown[700] : Colors.grey[800]),
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
            
            // Volume input section
            Text(
              l10n.volume,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
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
                      suffixText: volumeUnit,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Quick volume buttons
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
            
            // Information card
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
                      color: _drinkTypes[_selectedIndex]['color'] as Color? ?? Colors.brown[600],
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
                    Text(
                      '${_volumeController.text.isEmpty ? '0' : _volumeController.text} $volumeUnit',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                  
                  // Caffeine indicator
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
                          caffeine > 0 ? Icons.bolt : Icons.eco,
                          size: 20,
                          color: caffeine > 0 ? Colors.orange[700] : Colors.green[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          caffeine > 0 
                              ? '${l10n.caffeine}: ${caffeine.toStringAsFixed(0)} mg'
                              : '${l10n.caffeine}: 0 mg',
                          style: TextStyle(
                            fontSize: caffeine > 0 ? 16 : 14,
                            fontWeight: caffeine > 0 ? FontWeight.w600 : FontWeight.w500,
                            color: caffeine > 0 ? Colors.orange[700] : Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Caffeine impact on HRI
                  if (caffeine > 50) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'HRI impact: +${(caffeine / 100 * 2).toStringAsFixed(1)} points',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
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
            
            // Action buttons
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