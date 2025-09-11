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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    final subscription = Provider.of<SubscriptionProvider>(context, listen: false);
    await _favoritesManager.init(subscription.isPro);

    if (mounted) {
      setState(() {
        _isPro = subscription.isPro;
      });
    }
  }

  void _applyFavorite(QuickFavorite favorite, int index) async {
    setState(() {
      _pressedIndex = index;
    });

    final hydrationProvider = Provider.of<HydrationProvider>(context, listen: false);

    if (favorite.type == 'alcohol') {
      final alcoholService = Provider.of<AlcoholService>(context, listen: false);
      final alcoholTypeString = favorite.metadata?['basicAlcoholType'] ?? 
                                favorite.metadata?['alcoholType'] ?? 'beer';
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

    final units = Provider.of<UnitsService>(context, listen: false);
    final displayVolume = units.formatVolume(favorite.volumeMl ?? 0);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${favorite.label} ($displayVolume) added!',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _pressedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == 2 ? 0 : 4,
              ),
              child: _buildFavoriteSlot(index, l10n, isDarkMode),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFavoriteSlot(int slot, AppLocalizations l10n, bool isDarkMode) {
    final favorite = _favoritesManager.favorites[slot];
    final isLocked = !_isPro && slot > 0;
    final isPressed = _pressedIndex == slot;

    if (isLocked) {
      return _buildProLockedSlot(isDarkMode);
    }
    if (favorite == null) {
      return _buildEmptySlot(l10n, isDarkMode);
    }
    return _buildFilledSlot(favorite, slot, isPressed, isDarkMode);
  }

  Widget _buildFilledSlot(QuickFavorite fav, int index, bool isPressed, bool isDarkMode) {
    final units = Provider.of<UnitsService>(context, listen: false);
    final displayVolume = units.formatVolume(fav.volumeMl ?? 0, hideUnit: true);
    final color = _getModernIconColor(fav.type);
    final icon = _getIconForType(fav.type);

    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressedIndex = index),
        onTapUp: (_) => _applyFavorite(fav, index),
        onTapCancel: () => setState(() => _pressedIndex = null),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: isPressed ? [] : [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                fav.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$displayVolume ${units.volumeUnit}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
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
      height: 100,
      decoration: BoxDecoration(
        color: isDarkMode 
          ? Colors.grey[900]?.withOpacity(0.3)
          : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
            ? Colors.grey[800]!
            : Colors.grey[300]!,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Show bottom sheet to add favorite
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Hold drink button to add to favorites'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 28,
              color: isDarkMode 
                ? Colors.grey[600]
                : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addFavorite,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDarkMode 
                  ? Colors.grey[600]
                  : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProLockedSlot(bool isDarkMode) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400.withOpacity(0.8),
            Colors.purple.shade600.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaywallScreen(),
                fullscreenDialog: true,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getIconForType(String type) {
    switch (type) {
      case 'water': return '💧';
      case 'electrolyte': return '⚡';
      case 'coffee': 
      case 'hot': return '☕';
      case 'tea': return '🍵';
      case 'broth': return '🍲';
      case 'alcohol': return '🍺';
      case 'juice': return '🧃';
      case 'milk': return '🥛';
      case 'soda': return '🥤';
      default: return '🥤';
    }
  }

  Color _getModernIconColor(String type) {
    switch (type) {
      case 'water': return const Color(0xFF4A90E2);
      case 'electrolyte': return const Color(0xFFFFA502);
      case 'coffee': 
      case 'hot': return const Color(0xFF8B4513);
      case 'tea': return const Color(0xFF4CAF50);
      case 'broth': return const Color(0xFFFF6B6B);
      case 'alcohol': return const Color(0xFFFFB300);
      case 'juice': return const Color(0xFFFF9800);
      case 'milk': return const Color(0xFFF5F5DC);
      case 'soda': return const Color(0xFF9C27B0);
      default: return Colors.grey;
    }
  }
}