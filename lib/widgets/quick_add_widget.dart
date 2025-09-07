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
        return Icons.water_drop;
      case 'electrolyte':
        return Icons.bolt;
      case 'coffee':
      case 'hot':
        return Icons.coffee;
      case 'supplement':
        return Icons.medication;
      case 'alcohol':
        // Определяем иконку на основе подтипа алкоголя
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
        _buildCategoryAll(l10n),
      ],
    );
  }
  
  Widget _buildCategoryWater(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.water_drop,
      iconColor: Colors.white,
      label: l10n.water,
      gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
      onTap: () {
        widget.provider.addIntake('water', 250);
        widget.onUpdate();
        _showSuccessMessage('${l10n.water} 250 ml');
      },
    );
  }
  
  Widget _buildCategoryElectrolyte(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.bolt,
      iconColor: Colors.white,
      label: l10n.electrolyte,
      gradientColors: [Colors.orange.shade400, Colors.orange.shade600],
      onTap: () {
        widget.provider.addIntake('electrolyte', 0, 
          sodium: 500, potassium: 200, magnesium: 50);
        widget.onUpdate();
        _showSuccessMessage(l10n.electrolyte);
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
  
  Widget _buildCategorySupplements(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.medication,
      iconColor: Colors.white,
      label: l10n.supplements,
      gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
      onTap: () {
        widget.provider.addIntake('supplement', 0, magnesium: 200);
        widget.onUpdate();
        _showSuccessMessage('${l10n.magnesium} 200 ${l10n.mg}');
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
  
  Widget _buildCategoryAll(AppLocalizations l10n) {
    return _buildCategoryTile(
      icon: Icons.list_alt,
      iconColor: Colors.white,
      label: l10n.all,
      gradientColors: [Colors.teal.shade400, Colors.teal.shade600],
      onTap: () async {
        if (widget.onNavigate != null) {
          widget.onNavigate!('/drink_catalog');
        } else {
          final result = await Navigator.pushNamed(context, '/drink_catalog');
          if (result == true) {
            widget.onUpdate();
          }
        }
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