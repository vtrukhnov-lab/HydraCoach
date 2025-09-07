// ============================================================================
// FILE: lib/widgets/quick_add_widget.dart
// 
// PURPOSE: Quick Add Widget for Home Screen
// Provides quick access buttons for adding water, electrolytes, and other drinks.
// Manages favorite drink slots (1 FREE, 2 additional for PRO users).
// 
// FEATURES:
// - 3x3 grid of drink categories with Material Design icons
// - 3 favorite slots with PRO gating
// - Quick tap to add preset amounts instantly
// - Long press on favorites for actions menu
// - No navigation for favorites - instant application
// - Alcohol favorites integration with AlcoholService
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/quick_favorites.dart';
import '../models/alcohol_intake.dart';
import '../services/subscription_service.dart';
import '../services/alcohol_service.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../screens/paywall_screen.dart';

class QuickAddWidget extends StatefulWidget {
  final HydrationProvider provider;
  final Function() onUpdate;
  final Function(String)? onNavigate;
  
  const QuickAddWidget({
    super.key,
    required this.provider,
    required this.onUpdate,
    this.onNavigate,
  });

  @override
  State<QuickAddWidget> createState() => _QuickAddWidgetState();
}

class _QuickAddWidgetState extends State<QuickAddWidget> {
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;
  DateTime? _lastTapTime;
  
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    _isPro = subscription.isPro;
    await _favoritesManager.init(_isPro);
    if (mounted) setState(() {});
  }
  
  bool _canTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || 
        now.difference(_lastTapTime!).inMilliseconds > 800) {
      _lastTapTime = now;
      return true;
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickAdd,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildFavoritesSection(l10n),
        const SizedBox(height: 16),
        _buildCategoriesGrid(l10n),
      ],
    );
  }
  
  Widget _buildFavoritesSection(AppLocalizations l10n) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
            child: _buildFavoriteSlot(index, l10n),
          ),
        );
      }),
    );
  }
  
  Widget _buildFavoriteSlot(int slot, AppLocalizations l10n) {
    final favorite = _favoritesManager.favorites[slot];
    final isLocked = !_isPro && slot > 0;
    
    if (isLocked) {
      return _buildProLockedSlot();
    }
    
    if (favorite == null) {
      return _buildEmptySlot(l10n);
    }
    
    return _buildFilledSlot(slot, favorite, l10n);
  }
  
  Widget _buildProLockedSlot() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openPaywall,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade50,
                Colors.purple.shade100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.purple.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 36,
                    color: Colors.purple.shade600,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purple.shade600,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 12,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'PRO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptySlot(AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddFavoriteInfo(l10n),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 32,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.addFavorite,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilledSlot(int slot, QuickFavorite favorite, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (_canTap()) {
            _applyFavorite(favorite);
          }
        },
        onLongPress: () => _showFavoriteMenu(slot, favorite, l10n),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue.shade300,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getFavoriteIcon(favorite),
                      size: 28,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        favorite.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _showFavoriteMenu(slot, favorite, l10n),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getFavoriteIcon(QuickFavorite favorite) {
    switch (favorite.type) {
      case 'water':
        // Для жидкостей проверяем подтип
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
      case 'electrolyte':
        // Для электролитов проверяем подтип
        final electrolyteType = favorite.metadata?['electrolyteType'] ?? 'salt_water';
        switch (electrolyteType) {
          case 'salt_water':
            return Icons.grain;
          case 'electrolyte_mix':
            return Icons.water_drop;
          case 'bone_broth':
            return Icons.soup_kitchen;
          case 'lmnt_mix':
            return Icons.science;
          case 'pickle_juice':
            return Icons.liquor;
          case 'tomato_salt':
            return Icons.local_drink;
          case 'ketorade':
            return Icons.battery_charging_full;
          case 'alkaline_water':
            return Icons.opacity;
          case 'celtic_salt':
            return Icons.waves;
          case 'sole_water':
            return Icons.water;
          case 'mineral_drops':
            return Icons.water_drop_outlined;
          case 'baking_soda':
            return Icons.bubble_chart;
          case 'cream_tartar':
            return Icons.auto_awesome;
          // Старые типы для обратной совместимости
          case 'salt_quarter':
            return Icons.grain;
          case 'pink_salt':
            return Icons.diamond;
          case 'sea_salt':
            return Icons.waves;
          case 'potassium_citrate':
            return Icons.medication;
          case 'magnesium_glycinate':
            return Icons.medication_liquid;
          case 'coconut_water_electrolyte':
            return Icons.eco;
          case 'sports_drink_electrolyte':
            return Icons.sports;
          default:
            return Icons.bolt;
        }
      case 'coffee':
      case 'hot':
        return Icons.coffee;
      case 'supplement':
        // Для добавок проверяем подтип
        final supplementType = favorite.metadata?['supplementType'] ?? 'multivitamin';
        switch (supplementType) {
          case 'magnesium_glycinate':
            return Icons.medication_liquid;
          case 'potassium_citrate':
            return Icons.medication;
          case 'multivitamin':
            return Icons.vaccines;
          case 'magnesium_citrate':
            return Icons.water_drop;
          case 'magnesium_threonate':
            return Icons.psychology;
          case 'calcium_citrate':
            return Icons.healing;
          case 'zinc_glycinate':
            return Icons.shield;
          case 'vitamin_d3':
            return Icons.wb_sunny;
          case 'vitamin_c':
            return Icons.star;
          case 'b_complex':
            return Icons.battery_full;
          case 'omega3':
            return Icons.favorite;
          case 'iron_bisglycinate':
            return Icons.fitness_center;
          default:
            return Icons.medication;
        }
      case 'alcohol':
        // Для алкоголя проверяем подтип
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
      default:
        return Icons.local_drink;
    }
  }
  
  Widget _buildCategoriesGrid(AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        _buildCategoryWater(l10n),
        _buildCategoryElectrolyte(l10n),
        _buildCategoryHotDrinks(l10n),
        _buildCategorySupplements(l10n),
        _buildCategoryAlcohol(l10n),
        _buildCategorySports(l10n),
      ],
    );
  }
  
  Widget _buildCategoryWater(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.water_drop,
      iconColor: Colors.white,
      label: l10n.water,
      gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
      onTap: () async {
        // Открываем новый экран Liquids вместо мгновенного добавления
        if (widget.onNavigate != null) {
          widget.onNavigate!('/liquids');
        } else {
          final result = await Navigator.pushNamed(context, '/liquids');
          if (result == true) {
            widget.onUpdate();
            await _loadFavorites(); // Обновить фавориты
          }
        }
      },
    );
  }
  
  Widget _buildCategoryElectrolyte(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.bolt,
      iconColor: Colors.white,
      label: l10n.electrolyte,
      gradientColors: [Colors.orange.shade400, Colors.orange.shade600],
      onTap: () async {
        // Открываем новый экран Electrolytes вместо мгновенного добавления
        if (widget.onNavigate != null) {
          widget.onNavigate!('/electrolytes');
        } else {
          final result = await Navigator.pushNamed(context, '/electrolytes');
          if (result == true) {
            widget.onUpdate();
            await _loadFavorites(); // Обновить фавориты
          }
        }
      },
    );
  }
  
  Widget _buildCategoryHotDrinks(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.coffee,
      iconColor: Colors.white,
      label: l10n.hotDrinks,
      gradientColors: [Colors.brown.shade400, Colors.brown.shade600],
      onTap: () {
        widget.provider.addIntake('coffee', 200);
        widget.onUpdate();
        _showSuccessMessage('${l10n.coffee} 200 ml');
      },
    );
  }
  
  // Найдите метод _buildCategorySupplements (около строки 420) и замените его на:

Widget _buildCategorySupplements(AppLocalizations l10n) {
  return _buildCategoryTile(
    icon: Icons.medication,
    iconColor: Colors.white,
    label: l10n.supplements,
    gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
    onTap: () async {
      // Открываем экран Supplements вместо мгновенного добавления
      if (widget.onNavigate != null) {
        widget.onNavigate!('/supplements');
      } else {
        final result = await Navigator.pushNamed(context, '/supplements');
        if (result == true) {
          widget.onUpdate();
          await _loadFavorites(); // Обновить фавориты
        }
      }
    },
  );
}
  
  Widget _buildCategoryAlcohol(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.sports_bar,
      iconColor: Colors.white,
      label: l10n.alcohol,
      gradientColors: [Colors.red.shade500, Colors.red.shade700],
      onTap: () async {
        if (widget.onNavigate != null) {
          widget.onNavigate!('/alcohol');
        } else {
          final result = await Navigator.pushNamed(context, '/alcohol');
          if (result == true) {
            widget.onUpdate();
            await _loadFavorites();
          }
        }
      },
    );
  }
  
  Widget _buildCategorySports(AppLocalizations l10n) {
  return _buildCategoryTile(
    icon: Icons.fitness_center,
    iconColor: Colors.white,
    label: 'Sports', // TODO: добавить в локализацию
    gradientColors: [Colors.teal.shade400, Colors.teal.shade600],
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sports tracking coming soon!'),
          duration: const Duration(seconds: 2),
        ),
      );
    },
  );
}
  
  Widget _buildCategoryTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _applyFavorite(QuickFavorite favorite) async {
    // Для алкоголя - напрямую добавляем через AlcoholService
    if (favorite.type == 'alcohol') {
      final alcoholService = Provider.of<AlcoholService>(context, listen: false);
      
      // Получаем тип алкоголя из metadata
      // Пробуем сначала basicAlcoholType (новый формат), потом alcoholType (старый формат)
      final alcoholTypeString = favorite.metadata?['basicAlcoholType'] ?? 
                               favorite.metadata?['alcoholType'] ?? 
                               'beer';
      
      // Конвертируем строку в AlcoholType
      final alcoholType = AlcoholType.values.firstWhere(
        (type) => type.key == alcoholTypeString,
        orElse: () => AlcoholType.beer,
      );
      
      // Создаем AlcoholIntake
      final intake = AlcoholIntake(
        timestamp: DateTime.now(),
        type: alcoholType,
        volumeMl: (favorite.volumeMl ?? 200).toDouble(),
        abv: (favorite.metadata?['abv'] ?? 5.0).toDouble(),
      );
      
      // Добавляем через сервис
      await alcoholService.addIntake(intake);
      
      // Обновляем UI
      widget.onUpdate();
      HapticFeedback.lightImpact();
      _showSuccessMessage('${favorite.label} added');
      
      // Debug log
      print('DEBUG: Added alcohol intake via favorite - Type: ${alcoholType.key}, Volume: ${intake.volumeMl}ml, ABV: ${intake.abv}%');
      return;
    }
    
    // Для остальных типов - добавляем напрямую через provider
    widget.provider.addIntake(
      favorite.type,
      favorite.volumeMl ?? 0,
      sodium: favorite.sodiumMg ?? 0,
      potassium: favorite.potassiumMg ?? 0,
      magnesium: favorite.magnesiumMg ?? 0,
    );
    widget.onUpdate();
    
    HapticFeedback.lightImpact();
    _showSuccessMessage('${favorite.label} added');
  }
  
  void _showAddFavoriteInfo(AppLocalizations l10n) {
    showModalBottomSheet(
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.addFavorite,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'To add a favorite, go to any drink screen and tap "Save to favorites" button.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.ok),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFavoriteMenu(int slot, QuickFavorite favorite, AppLocalizations l10n) {
    showModalBottomSheet(
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
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade50,
                child: Icon(Icons.play_arrow, color: Colors.green.shade700),
              ),
              title: Text(l10n.quickAdd),
              subtitle: Text(favorite.label),
              onTap: () {
                Navigator.pop(context);
                _applyFavorite(favorite);
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade50,
                child: Icon(Icons.delete_outline, color: Colors.red.shade700),
              ),
              title: Text(l10n.removeFavorite),
              onTap: () {
                _favoritesManager.removeFavorite(slot);
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showSuccessMessage(String message) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(message),
            const Spacer(),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                l10n.undo,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _openPaywall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}