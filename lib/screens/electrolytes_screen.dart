// ============================================================================
// FILE: lib/screens/electrolytes_screen.dart
// 
// PURPOSE: Electrolytes Screen with consistent UI/UX
// Allows users to select and log various electrolyte supplements.
// Matches the style of alcohol and hot drinks screens.
// 
// FEATURES:
// - 3x4 grid of electrolyte types (3 FREE, 9 PRO)
// - Volume input with quick preset buttons
// - Proportional calculation of Na/K/Mg based on volume
// - Save to favorites functionality
// - PRO gating for premium electrolyte types
// - Orange color scheme
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';
import '../main.dart';

class ElectrolytesScreen extends StatefulWidget {
  const ElectrolytesScreen({super.key});

  @override
  State<ElectrolytesScreen> createState() => _ElectrolytesScreenState();
}

class _ElectrolytesScreenState extends State<ElectrolytesScreen> {
  List<Map<String, dynamic>> _electrolyteTypes = [];
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
    _initializeElectrolyteTypes();
  }
  
  void _initializeElectrolyteTypes() {
    final l10n = AppLocalizations.of(context);
    
    _electrolyteTypes = [
      // FREE типы
      {
        'type': 'salt_water',
        'label': l10n.saltQuarterTsp,
        'icon': Icons.grain,
        'defaultVolume': 250,
        'sodium': 600,      // на 250ml
        'potassium': 0,
        'magnesium': 0,
        'isPro': false
      },
      {
        'type': 'electrolyte_mix',
        'label': l10n.electrolyteMix,
        'icon': Icons.water_drop,
        'defaultVolume': 250,
        'sodium': 500,
        'potassium': 200,
        'magnesium': 50,
        'isPro': false
      },
      {
        'type': 'bone_broth',
        'label': l10n.boneBroth,
        'icon': Icons.soup_kitchen,
        'defaultVolume': 250,
        'sodium': 800,
        'potassium': 100,
        'magnesium': 0,
        'isPro': false
      },
      // PRO типы
      {
        'type': 'lmnt_mix',
        'label': l10n.lmntMix ?? 'LMNT Mix',
        'icon': Icons.science,
        'defaultVolume': 250,
        'sodium': 1000,
        'potassium': 200,
        'magnesium': 60,
        'isPro': true
      },
      {
        'type': 'pickle_juice',
        'label': l10n.pickleJuice ?? 'Pickle Juice',
        'icon': Icons.liquor,
        'defaultVolume': 100,
        'sodium': 900,
        'potassium': 70,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'tomato_salt',
        'label': l10n.tomatoSalt ?? 'Tomato + Salt',
        'icon': Icons.local_drink,
        'defaultVolume': 200,
        'sodium': 650,
        'potassium': 400,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'ketorade',
        'label': l10n.ketorade ?? 'Ketorade',
        'icon': Icons.battery_charging_full,
        'defaultVolume': 500,
        'sodium': 750,
        'potassium': 300,
        'magnesium': 100,
        'isPro': true
      },
      {
        'type': 'alkaline_water',
        'label': l10n.alkalineWater ?? 'Alkaline Water',
        'icon': Icons.opacity,
        'defaultVolume': 500,
        'sodium': 100,
        'potassium': 50,
        'magnesium': 30,
        'isPro': true
      },
      {
        'type': 'celtic_salt',
        'label': l10n.celticSalt ?? 'Celtic Salt',
        'icon': Icons.waves,
        'defaultVolume': 250,
        'sodium': 480,
        'potassium': 40,
        'magnesium': 120,
        'isPro': true
      },
      {
        'type': 'sole_water',
        'label': l10n.soleWater ?? 'Sole Water',
        'icon': Icons.water,
        'defaultVolume': 280,
        'sodium': 2000,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'mineral_drops',
        'label': l10n.mineralDrops ?? 'Mineral Drops',
        'icon': Icons.water_drop_outlined,
        'defaultVolume': 500,
        'sodium': 50,
        'potassium': 100,
        'magnesium': 200,
        'isPro': true
      },
      {
        'type': 'baking_soda',
        'label': l10n.bakingSoda ?? 'Baking Soda',
        'icon': Icons.bubble_chart,
        'defaultVolume': 250,
        'sodium': 630,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
    ];
    
    // Set default volume for first electrolyte
    if (_electrolyteTypes.isNotEmpty) {
      _volumeController.text = _electrolyteTypes[0]['defaultVolume'].toString();
    }
  }

  void _checkForPreselectedValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          if (args['preselected'] != null) {
            final typeKey = args['preselected'];
            final index = _electrolyteTypes.indexWhere((e) => e['type'] == typeKey);
            if (index != -1) {
              _selectedIndex = index;
              _volumeController.text = _electrolyteTypes[index]['defaultVolume'].toString();
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

  void _selectElectrolyte(int index) {
    final electrolyte = _electrolyteTypes[index];
    if (electrolyte['isPro'] && !_isPro) {
      _showProPaywall();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
      _volumeController.text = electrolyte['defaultVolume'].toString();
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

  Map<String, int> _calculateElectrolytes() {
    if (_electrolyteTypes.isEmpty) {
      return {'sodium': 0, 'potassium': 0, 'magnesium': 0};
    }
    
    final electrolyte = _electrolyteTypes[_selectedIndex];
    final volume = double.tryParse(_volumeController.text) ?? 250;
    final defaultVolume = (electrolyte['defaultVolume'] as int).toDouble();
    
    // Calculate electrolytes proportionally to volume
    final ratio = volume / defaultVolume;
    
    return {
      'sodium': (electrolyte['sodium'] * ratio).round(),
      'potassium': (electrolyte['potassium'] * ratio).round(),
      'magnesium': (electrolyte['magnesium'] * ratio).round(),
    };
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

    final amounts = _calculateElectrolytes();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    provider.addIntake(
      'electrolyte',
      volume,
      sodium: amounts['sodium']!,
      potassium: amounts['potassium']!,
      magnesium: amounts['magnesium']!,
    );

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

    final electrolyte = _electrolyteTypes[_selectedIndex];
    final amounts = _calculateElectrolytes();
    final label = '${electrolyte['label']} ${volume}ml';
    
    final favorite = QuickFavorite(
      id: 'electrolyte_${electrolyte['type']}_$volume',
      type: 'electrolyte',
      label: label,
      emoji: '',
      volumeMl: volume,
      sodiumMg: amounts['sodium']!,
      potassiumMg: amounts['potassium']!,
      magnesiumMg: amounts['magnesium']!,
      metadata: {
        'electrolyteType': electrolyte['type'],
        'volume': volume,
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
          backgroundColor: Colors.orange.shade50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.star, color: Colors.orange.shade600),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.lock, size: 12, color: Colors.orange.shade600),
              ),
            ],
          ),
        ),
        title: Text('${l10n.slot} ${slot + 1} (PRO)'),
        subtitle: Text(l10n.upgradeToUnlock),
        trailing: Icon(Icons.lock_outline, color: Colors.orange.shade400),
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
    final electrolyteType = favorite.metadata?['electrolyteType'] ?? 'salt_water';
    final electrolyte = _electrolyteTypes.firstWhere(
      (e) => e['type'] == electrolyteType,
      orElse: () => {'icon': Icons.bolt},
    );
    return electrolyte['icon'] as IconData;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    final electrolyteAmounts = _calculateElectrolytes();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.electrolyte),
        elevation: 0,
        backgroundColor: Colors.orange[500],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectElectrolyteType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid for electrolytes
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: _electrolyteTypes.isEmpty ? 12 : _electrolyteTypes.length,
              itemBuilder: (context, index) {
                if (_electrolyteTypes.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }
                
                final electrolyte = _electrolyteTypes[index];
                final isSelected = _selectedIndex == index;
                final isLocked = electrolyte['isPro'] && !_isPro;
                
                return GestureDetector(
                  onTap: () => _selectElectrolyte(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isLocked 
                          ? Colors.grey[50] 
                          : (isSelected ? Colors.orange[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.orange[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
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
                                  electrolyte['icon'] as IconData,
                                  size: 60,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected ? Colors.orange[600] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  electrolyte['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.orange[700] : Colors.grey[800]),
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
                                color: Colors.orange.shade600,
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
            Row(
              children: [
                Expanded(
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
                        borderSide: BorderSide(color: Colors.orange[500]!, width: 2),
                      ),
                      suffixText: l10n.ml,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Quick volume buttons
                Wrap(
                  spacing: 8,
                  children: [
                    _buildVolumeChip('250'),
                    _buildVolumeChip('500'),
                    _buildVolumeChip('750'),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Information card with electrolyte content
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[50]!, Colors.orange[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.bolt,
                    size: 48,
                    color: Colors.orange[600],
                  ),
                  const SizedBox(height: 12),
                  if (_electrolyteTypes.isNotEmpty)
                    Text(
                      _electrolyteTypes[_selectedIndex]['label'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${_volumeController.text} ${l10n.ml}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.orange[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.electrolyteContent,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (electrolyteAmounts['sodium']! > 0)
                          _buildElectrolyteRow(
                            l10n.sodiumContent(electrolyteAmounts['sodium']!),
                            Colors.blue,
                          ),
                        if (electrolyteAmounts['potassium']! > 0)
                          _buildElectrolyteRow(
                            l10n.potassiumContent(electrolyteAmounts['potassium']!),
                            Colors.green,
                          ),
                        if (electrolyteAmounts['magnesium']! > 0)
                          _buildElectrolyteRow(
                            l10n.magnesiumContent(electrolyteAmounts['magnesium']!),
                            Colors.purple,
                          ),
                        if (electrolyteAmounts['sodium'] == 0 && 
                            electrolyteAmounts['potassium'] == 0 && 
                            electrolyteAmounts['magnesium'] == 0)
                          Text(
                            l10n.noElectrolytes,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
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
                      backgroundColor: Colors.orange[500],
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

  Widget _buildVolumeChip(String volume) {
    final isSelected = _volumeController.text == volume;
    return ActionChip(
      label: Text('$volume ml'),
      onPressed: () {
        setState(() {
          _volumeController.text = volume;
        });
      },
      backgroundColor: isSelected ? Colors.orange[100] : Colors.grey[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildElectrolyteRow(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}