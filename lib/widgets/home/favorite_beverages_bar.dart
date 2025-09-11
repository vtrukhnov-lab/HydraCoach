// lib/widgets/home/favorite_beverages_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/alcohol_intake.dart';
import '../../models/quick_favorites.dart';
import '../../providers/hydration_provider.dart';
import '../../screens/paywall_screen.dart';
import '../../services/alcohol_service.dart';
import '../../services/subscription_service.dart';
import '../../services/units_service.dart';

class FavoriteBeveragesBar extends StatefulWidget {
  final VoidCallback onUpdate;
  const FavoriteBeveragesBar({super.key, required this.onUpdate});

  @override
  State<FavoriteBeveragesBar> createState() => _FavoriteBeveragesBarState();
}

class _FavoriteBeveragesBarState extends State<FavoriteBeveragesBar> {
  final QuickFavoritesManager _favoritesManager = QuickFavoritesManager();
  bool _isPro = false;
  int? _pressedIndex;

  @override
  void initState() {
    super.initState();

    _favoritesManager.addListener(_onFavoritesChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
      _isPro = subscription.isPro;
      await _favoritesManager.init(_isPro);
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    if (_isPro != subscription.isPro) {
      _isPro = subscription.isPro;
      _favoritesManager.updateProStatus(_isPro);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _applyFavorite(QuickFavorite favorite, int index) {
    setState(() => _pressedIndex = index);

    final hydrationProvider = Provider.of<HydrationProvider>(context, listen: false);

    if (favorite.type == 'alcohol') {
      final alcoholService = Provider.of<AlcoholService>(context, listen: false);
      final alcoholTypeString = favorite.metadata?['alcoholType'] ?? 'beer';
      final alcoholType = AlcoholType.values.firstWhere(
        (type) => type.key == alcoholTypeString,
        orElse: () => AlcoholType.beer,
      );

      final intake = AlcoholIntake(
        timestamp: DateTime.now(),
        type: alcoholType,
        volumeMl: (favorite.volumeMl ?? 200).toDouble(),
        abv: (favorite.metadata?['abv'] ?? 5.0).toDouble(),
      );
      alcoholService.addIntake(intake);
    } else {
      hydrationProvider.addIntake(
        favorite.type,
        favorite.volumeMl ?? 0,
        sodium: favorite.sodiumMg ?? 0,
        potassium: favorite.potassiumMg ?? 0,
        magnesium: favorite.magnesiumMg ?? 0,
      );
    }

    widget.onUpdate();
    HapticFeedback.lightImpact();

    final l10n = AppLocalizations.of(context);
    final units = Provider.of<UnitsService>(context, listen: false);
    final displayVolume = units.formatVolume(favorite.volumeMl ?? 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${favorite.label} ($displayVolume) ${l10n.addedSuccessfully ?? "added!"}',
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    if (mounted) {
      setState(() => _pressedIndex = null);
    }
  }

  void _handleEmptySlotTap() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.createFavoriteHint ?? 'Long press a drink to add to favorites'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final favs = _favoritesManager.favorites;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == 2 ? 0 : 4),
              child: _buildFavoriteSlot(favs[index], index, l10n, isDarkMode),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFavoriteSlot(QuickFavorite? favorite, int slot, AppLocalizations l10n, bool isDarkMode) {
    final isLocked = !_isPro && slot > 0;
    final isPressed = _pressedIndex == slot;

    if (isLocked) return _buildProLockedSlot(isDarkMode, l10n);
    if (favorite == null) return _buildEmptySlot(l10n, isDarkMode);
    return _buildFilledSlot(favorite, slot, isPressed, isDarkMode);
  }

  Widget _buildFilledSlot(QuickFavorite fav, int index, bool isPressed, bool isDarkMode) {
    final units = Provider.of<UnitsService>(context, listen: false);
    final displayVolume = units.formatVolume(fav.volumeMl ?? 0, hideUnit: true);
    final color = _getModernIconColor(fav.type);
    final icon = _getIconForType(fav);

    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressedIndex = index),
        onTapUp: (_) => _applyFavorite(fav, index),
        onTapCancel: () => setState(() => _pressedIndex = null),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            boxShadow: isPressed
                ? []
                : [
                    BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 6),
              Text(
                _getLocalizedLabel(fav),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '$displayVolume ${units.volumeUnit}',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(AppLocalizations l10n, bool isDarkMode) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.grey[850]!.withOpacity(0.5), Colors.grey[900]!.withOpacity(0.3)]
              : [Colors.grey[50]!, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]!.withOpacity(0.5) : Colors.grey[300]!.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: _handleEmptySlotTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded, size: 24, color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addFavorite ?? 'Add Favorite',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProLockedSlot(bool isDarkMode, AppLocalizations l10n) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade400.withOpacity(0.8), Colors.purple.shade600.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaywallScreen(), fullscreenDialog: true),
            ).then((_) {
              final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
              _isPro = subscription.isPro;
              _favoritesManager.updateProStatus(_isPro);
              if (mounted) setState(() {});
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  'PRO',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getIconForType(QuickFavorite fav) {
    if (fav.type == 'alcohol') {
      final alcoholType = fav.metadata?['alcoholType'] ?? 'beer';
      switch (alcoholType) {
        case 'beer':
          return '🍺';
        case 'wine':
          return '🍷';
        case 'spirits':
          return '🥃';
        case 'cocktail':
          return '🍹';
        default:
          return '🍺';
      }
    }
    if (fav.emoji.isNotEmpty) return fav.emoji;

    switch (fav.type) {
      case 'water':
        return '💧';
      case 'electrolyte':
        return '⚡';
      case 'coffee':
      case 'hot':
        return '☕';
      case 'tea':
        return '🍵';
      case 'broth':
        return '🍲';
      case 'juice':
        return '🧃';
      case 'milk':
        return '🥛';
      case 'soda':
        return '🥤';
      default:
        return '🥤';
    }
  }

  Color _getModernIconColor(String type) {
    switch (type) {
      case 'water':
        return const Color(0xFF4A90E2);
      case 'electrolyte':
        return const Color(0xFFFFA502);
      case 'coffee':
      case 'hot':
        return const Color(0xFF8B4513);
      case 'tea':
        return const Color(0xFF4CAF50);
      case 'broth':
        return const Color(0xFFFF6B6B);
      case 'alcohol':
        return const Color(0xFFFFB300);
      case 'juice':
        return const Color(0xFFFF9800);
      case 'milk':
        return const Color(0xFFF5F5DC);
      case 'soda':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedLabel(QuickFavorite favorite) {
    final l10n = AppLocalizations.of(context);
    if (favorite.type == 'alcohol') return favorite.label;

    switch (favorite.type) {
      case 'water':
        return l10n.water;
      case 'electrolyte':
        return l10n.electrolyte;
      case 'coffee':
        return l10n.coffee;
      case 'tea':
        return l10n.tea;
      case 'broth':
        return l10n.broth;
      case 'juice':
        return l10n.juice;
      case 'milk':
        return l10n.drink_milk;
      case 'soda':
        return l10n.drink_soda;
      case 'hot':
        return l10n.hotDrinks;
      default:
        return favorite.label;
    }
  }
}
