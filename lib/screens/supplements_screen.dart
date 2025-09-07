// ============================================================================
// FILE: lib/screens/supplements_screen.dart
// 
// PURPOSE: Supplements Screen for vitamins and minerals
// Allows users to select and log various supplements.
// Uses the same UI/UX pattern as electrolytes_screen for consistency.
// 
// FEATURES:
// - Grid of supplement types (3 FREE, 9+ PRO)
// - Dosage input
// - Electrolyte content calculation where applicable
// - Save to favorites functionality
// - PRO gating for premium supplements
// - Purple color scheme
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/quick_favorites.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';
import '../main.dart';

class SupplementsScreen extends StatefulWidget {
  const SupplementsScreen({super.key});

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen> {
  List<Map<String, dynamic>> _supplementTypes = [];
  int _selectedIndex = 0;
  final TextEditingController _dosageController = TextEditingController(text: '1');
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
    _initializeSupplementTypes();
  }
  
  void _initializeSupplementTypes() {
    final l10n = AppLocalizations.of(context);
    
    _supplementTypes = [
      // FREE типы
      {
        'type': 'magnesium_glycinate',
        'label': l10n.magnesiumGlycinate ?? 'Magnesium Glycinate',
        'icon': Icons.medication_liquid,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 200,  // per capsule
        'isPro': false
      },
      {
        'type': 'potassium_citrate',
        'label': l10n.potassiumCitrate ?? 'Potassium Citrate',
        'icon': Icons.medication,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 99,  // per capsule (standard US dose)
        'magnesium': 0,
        'isPro': false
      },
      {
        'type': 'multivitamin',
        'label': l10n.multivitamin ?? 'Multivitamin',
        'icon': Icons.vaccines,
        'dosageUnit': 'tabs',
        'sodium': 0,
        'potassium': 50,
        'magnesium': 50,
        'isPro': false
      },
      // PRO типы
      {
        'type': 'magnesium_citrate',
        'label': l10n.magnesiumCitrate ?? 'Magnesium Citrate',
        'icon': Icons.water_drop,
        'dosageUnit': 'ml',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 30,  // per 10ml
        'isPro': true
      },
      {
        'type': 'magnesium_threonate',
        'label': l10n.magnesiumThreonate ?? 'Magnesium L-Threonate',
        'icon': Icons.psychology,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 144,  // per capsule
        'isPro': true
      },
      {
        'type': 'calcium_citrate',
        'label': l10n.calciumCitrate ?? 'Calcium Citrate',
        'icon': Icons.healing,
        'dosageUnit': 'tabs',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'zinc_glycinate',
        'label': l10n.zincGlycinate ?? 'Zinc Glycinate',
        'icon': Icons.shield,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'vitamin_d3',
        'label': l10n.vitaminD3 ?? 'Vitamin D3',
        'icon': Icons.wb_sunny,
        'dosageUnit': 'IU',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'vitamin_c',
        'label': l10n.vitaminC ?? 'Vitamin C',
        'icon': Icons.star,
        'dosageUnit': 'mg',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'b_complex',
        'label': l10n.bComplex ?? 'B-Complex',
        'icon': Icons.battery_full,
        'dosageUnit': 'tabs',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'omega3',
        'label': l10n.omega3 ?? 'Omega-3',
        'icon': Icons.favorite,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
      {
        'type': 'iron_bisglycinate',
        'label': l10n.ironBisglycinate ?? 'Iron Bisglycinate',
        'icon': Icons.fitness_center,
        'dosageUnit': 'caps',
        'sodium': 0,
        'potassium': 0,
        'magnesium': 0,
        'isPro': true
      },
    ];
  }

  void _checkForPreselectedValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          if (args['preselected'] != null) {
            final typeKey = args['preselected'];
            final index = _supplementTypes.indexWhere((s) => s['type'] == typeKey);
            if (index != -1) {
              _selectedIndex = index;
            }
          }
          if (args['dosage'] != null) {
            _dosageController.text = args['dosage'].toString();
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
    _dosageController.dispose();
    super.dispose();
  }

  void _selectSupplement(int index) {
    final supplement = _supplementTypes[index];
    if (supplement['isPro'] && !_isPro) {
      _showProPaywall();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
      // Устанавливаем рекомендуемую дозировку
      _dosageController.text = '1';
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
    if (_supplementTypes.isEmpty) {
      return {'sodium': 0, 'potassium': 0, 'magnesium': 0};
    }
    
    final supplement = _supplementTypes[_selectedIndex];
    final dosage = double.tryParse(_dosageController.text) ?? 1;
    
    return {
      'sodium': (supplement['sodium'] * dosage).round(),
      'potassium': (supplement['potassium'] * dosage).round(),
      'magnesium': (supplement['magnesium'] * dosage).round(),
    };
  }

  Future<void> _saveIntake() async {
    final l10n = AppLocalizations.of(context);
    final dosage = double.tryParse(_dosageController.text);
    
    if (dosage == null || dosage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidAmount)),
      );
      return;
    }

    final amounts = _calculateElectrolytes();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Сохраняем как прием добавки
    provider.addIntake(
      'supplement',
      0, // Без объема воды
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
    final dosage = double.tryParse(_dosageController.text);
    
    if (dosage == null || dosage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidAmount)),
      );
      return;
    }

    final slot = await _showFavoriteSlotSelector(l10n);
    if (slot == null) return;

    final supplement = _supplementTypes[_selectedIndex];
    final amounts = _calculateElectrolytes();
    final dosageInt = dosage.toInt();
    final dosageText = dosage == dosageInt ? '$dosageInt' : dosage.toStringAsFixed(1);
    final label = '${supplement['label']} $dosageText ${supplement['dosageUnit']}';
    
    final favorite = QuickFavorite(
      id: 'supplement_${supplement['type']}_${dosage.toInt()}',
      type: 'supplement',
      label: label,
      emoji: '',
      volumeMl: 0,
      sodiumMg: amounts['sodium']!,
      potassiumMg: amounts['potassium']!,
      magnesiumMg: amounts['magnesium']!,
      metadata: {
        'supplementType': supplement['type'],
        'dosage': dosage,
        'dosageUnit': supplement['dosageUnit'],
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
        backgroundColor: currentFavorite != null ? Colors.purple.shade50 : Colors.green.shade50,
        child: currentFavorite != null 
          ? Icon(_getFavoriteIcon(currentFavorite), color: Colors.purple.shade600)
          : Icon(Icons.add, color: Colors.green.shade600),
      ),
      title: Text('${l10n.slot} ${slot + 1}'),
      subtitle: currentFavorite != null 
        ? Text(currentFavorite.label)
        : Text(l10n.emptySlot),
      trailing: currentFavorite != null 
        ? Icon(Icons.swap_horiz, color: Colors.purple.shade400)
        : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pop(context, slot),
    );
  }
  
  IconData _getFavoriteIcon(QuickFavorite favorite) {
    final supplementType = favorite.metadata?['supplementType'] ?? 'multivitamin';
    final supplement = _supplementTypes.firstWhere(
      (s) => s['type'] == supplementType,
      orElse: () => {'icon': Icons.medication},
    );
    return supplement['icon'] as IconData;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    final electrolyteAmounts = _calculateElectrolytes();
    final hasElectrolytes = electrolyteAmounts['sodium']! > 0 || 
                           electrolyteAmounts['potassium']! > 0 || 
                           electrolyteAmounts['magnesium']! > 0;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.supplements),
        elevation: 0,
        backgroundColor: Colors.purple[500],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectSupplementType ?? 'Select supplement type:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid для добавок
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _supplementTypes.isEmpty ? 12 : _supplementTypes.length,
              itemBuilder: (context, index) {
                if (_supplementTypes.isEmpty) {
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
                
                final supplement = _supplementTypes[index];
                final isSelected = _selectedIndex == index;
                final isLocked = supplement['isPro'] && !_isPro;
                
                return GestureDetector(
                  onTap: () => _selectSupplement(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isLocked 
                          ? Colors.grey[50] 
                          : (isSelected ? Colors.purple[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.purple[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
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
                                  supplement['icon'] as IconData,
                                  size: 32,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected ? Colors.purple[600] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  supplement['label'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.purple[700] : Colors.grey[800]),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
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
              l10n.dosage ?? 'Dosage',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dosageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.enterDosage ?? 'Enter dosage',
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
                  borderSide: BorderSide(color: Colors.purple[500]!, width: 2),
                ),
                suffixText: _supplementTypes.isNotEmpty 
                    ? _supplementTypes[_selectedIndex]['dosageUnit']
                    : '',
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Информационная карточка
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[50]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.medication,
                    size: 48,
                    color: Colors.purple[600],
                  ),
                  const SizedBox(height: 12),
                  if (_supplementTypes.isNotEmpty)
                    Text(
                      _supplementTypes[_selectedIndex]['label'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 8),
                  if (hasElectrolytes) ...[
                    Text(
                      l10n.electrolyteContent,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple[800],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                  ] else
                    Text(
                      l10n.noElectrolyteContent ?? 'No electrolyte content',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple[600],
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
                      backgroundColor: Colors.purple[500],
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