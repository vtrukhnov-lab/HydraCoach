import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/drink_categories.dart';
import '../constants/drink_database.dart';
import '../models/extended_intake.dart';
import '../models/favorite_drinks.dart';
import '../services/subscription_service.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class DrinkCatalogScreen extends StatefulWidget {
  const DrinkCatalogScreen({super.key});

  @override
  State<DrinkCatalogScreen> createState() => _DrinkCatalogScreenState();
}

class _DrinkCatalogScreenState extends State<DrinkCatalogScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FavoriteDrinksManager _favoritesManager = FavoriteDrinksManager();
  bool _isProUser = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DrinkCategory.values.length + 2, // +2 for "All" and "Favorites"
      vsync: this,
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    final subscriptionService = Provider.of<SubscriptionProvider>(context, listen: false);
    _isProUser = subscriptionService.isPro;
    await _favoritesManager.init(_isProUser);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _selectDrink(DrinkType drink) {
    // Check availability
    if (drink.isPremium && !_isProUser) {
      _showProRequiredDialog();
      return;
    }
    
    // Show drink customization dialog
    _showDrinkCustomizationDialog(drink);
  }

  void _showDrinkCustomizationDialog(DrinkType drink) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DrinkCustomizationSheet(
        drink: drink,
        favoritesManager: _favoritesManager,
        onAdd: (ExtendedIntake intake) {
          _addIntake(intake);
        },
      ),
    );
  }

  void _addIntake(ExtendedIntake intake) {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Convert to old format for compatibility
    final legacy = intake.toLegacyIntake();
    provider.addIntake(
      legacy['type'] as String,
      legacy['volume'] as int,
      sodium: legacy['sodium'] as int,
      potassium: legacy['potassium'] as int,
      magnesium: legacy['magnesium'] as int,
    );
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${intake.drinkEmoji} Added ${intake.formattedVolume}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PRO Feature'),
        content: const Text('This drink is available in PRO version. Upgrade to access 50+ drinks and supplements!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to paywall
            },
            child: const Text('Upgrade to PRO'),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(DrinkCategory category) {
    // Simple English names for now
    switch (category) {
      case DrinkCategory.water:
        return 'Water';
      case DrinkCategory.hotDrinks:
        return 'Hot';
      case DrinkCategory.juice:
        return 'Juices';
      case DrinkCategory.sports:
        return 'Sports';
      case DrinkCategory.dairy:
        return 'Dairy';
      case DrinkCategory.alcohol:
        return 'Alcohol';
      case DrinkCategory.supplements:
        return 'Supplements';
      case DrinkCategory.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink Catalog'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search drinks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Category tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  const Tab(text: '⭐ Favorites'),
                  const Tab(text: '🔥 Popular'),
                  ...DrinkCategory.values.map((category) {
                    return Tab(
                      text: '${category.emoji} ${_getCategoryDisplayName(category)}',
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Favorites tab
          _buildFavoritesTab(),
          // Popular tab
          _buildPopularTab(),
          // Category tabs
          ...DrinkCategory.values.map((category) {
            return _buildDrinksGrid(
              DrinkDatabase.getDrinksByCategory(category),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    if (_favoritesManager.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap ⭐ on any drink to add it here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoritesManager.favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favoritesManager.favorites[index];
        final drink = DrinkDatabase.findById(favorite.drinkId);
        
        if (drink == null) return const SizedBox();
        
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(favorite.emoji, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(favorite.getDisplayName()),
            subtitle: Text('${favorite.defaultVolumeMl.round()} ml'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (favorite.defaultSupplementIds.isNotEmpty)
                  Chip(
                    label: Text('+${favorite.defaultSupplementIds.length}'),
                    backgroundColor: Colors.purple[100],
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () => _quickAddFavorite(favorite),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            onTap: () => _showDrinkCustomizationDialog(drink),
            onLongPress: () => _editFavorite(favorite),
          ),
        );
      },
    );
  }

  Widget _buildPopularTab() {
    final popularDrinks = DrinkDatabase.getPopularDrinks();
    return _buildDrinksGrid(popularDrinks);
  }

  Widget _buildDrinksGrid(List<DrinkType> drinks) {
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      drinks = drinks.where((drink) {
        final name = drink.nameKey.toLowerCase().replaceAll('_', ' ');
        return name.contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final drink = drinks[index];
        final isFavorite = _favoritesManager.isFavorite(drink.id);
        final isLocked = drink.isPremium && !_isProUser;
        
        return InkWell(
          onTap: () => _selectDrink(drink),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isLocked 
                  ? Colors.grey[100] 
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLocked 
                    ? Colors.grey[300]! 
                    : Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      drink.emoji,
                      style: TextStyle(
                        fontSize: 36,
                        color: isLocked ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      drink.nameKey.replaceAll('_', ' ').replaceAll('drink ', ''),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isLocked ? Colors.grey : null,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${drink.defaultVolumeMl.round()} ml',
                      style: TextStyle(
                        fontSize: 11,
                        color: isLocked ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                // Lock icon for PRO items
                if (isLocked)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Favorite star
                if (isFavorite)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _quickAddFavorite(FavoriteDrink favorite) {
    final intake = ExtendedIntake(
      timestamp: DateTime.now(),
      drinkId: favorite.drinkId,
      volumeMl: favorite.defaultVolumeMl,
      supplementIds: favorite.defaultSupplementIds,
      hasIce: favorite.hasIce,
    );
    
    _addIntake(intake);
  }

  void _editFavorite(FavoriteDrink favorite) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Long press to edit - coming soon!')),
    );
  }
}

// Drink customization widget
class DrinkCustomizationSheet extends StatefulWidget {
  final DrinkType drink;
  final FavoriteDrinksManager favoritesManager;
  final Function(ExtendedIntake) onAdd;

  const DrinkCustomizationSheet({
    super.key,
    required this.drink,
    required this.favoritesManager,
    required this.onAdd,
  });

  @override
  State<DrinkCustomizationSheet> createState() => _DrinkCustomizationSheetState();
}

class _DrinkCustomizationSheetState extends State<DrinkCustomizationSheet> {
  late double _volume;
  bool _hasIce = false;
  List<String> _selectedSupplements = [];
  
  @override
  void initState() {
    super.initState();
    _volume = widget.drink.defaultVolumeMl;
    
    // Load favorite settings if exists
    final favorite = widget.favoritesManager.getFavoriteByDrinkId(widget.drink.id);
    if (favorite != null) {
      _volume = favorite.defaultVolumeMl;
      _hasIce = favorite.hasIce;
      _selectedSupplements = List.from(favorite.defaultSupplementIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
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
                
                // Drink header
                Row(
                  children: [
                    Text(
                      widget.drink.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.drink.nameKey.replaceAll('_', ' ').replaceAll('drink ', '').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.drink.hydrationCoefficient != 1.0)
                            Text(
                              'Hydration: ${(widget.drink.hydrationCoefficient * 100).round()}%',
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
                const SizedBox(height: 24),
                
                // Volume selector
                const Text(
                  'Volume',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${_volume.round()} ml'),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 50,
                        max: 1000,
                        divisions: 19,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                // Quick volume buttons
                Wrap(
                  spacing: 8,
                  children: [100, 200, 250, 330, 500, 750].map((vol) {
                    return ChoiceChip(
                      label: Text('$vol ml'),
                      selected: _volume == vol.toDouble(),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _volume = vol.toDouble();
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                
                // Ice option
                if (widget.drink.canAddIce)
                  CheckboxListTile(
                    title: const Text('Add ice'),
                    subtitle: const Text('Reduces effective volume by 15%'),
                    value: _hasIce,
                    onChanged: (value) {
                      setState(() {
                        _hasIce = value ?? false;
                      });
                    },
                  ),
                
                // Electrolyte info
                if (widget.drink.sodiumPer100ml > 0 || 
                    widget.drink.potassiumPer100ml > 0 || 
                    widget.drink.magnesiumPer100ml > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Electrolytes per serving:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (widget.drink.sodiumPer100ml > 0)
                          Text('Sodium: ${(widget.drink.sodiumPer100ml * _volume / 100).round()} mg'),
                        if (widget.drink.potassiumPer100ml > 0)
                          Text('Potassium: ${(widget.drink.potassiumPer100ml * _volume / 100).round()} mg'),
                        if (widget.drink.magnesiumPer100ml > 0)
                          Text('Magnesium: ${(widget.drink.magnesiumPer100ml * _volume / 100).round()} mg'),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addToFavorites,
                        icon: const Icon(Icons.star_border),
                        label: const Text('Save as Favorite'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _addDrink,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addDrink() {
    final intake = ExtendedIntake(
      timestamp: DateTime.now(),
      drinkId: widget.drink.id,
      volumeMl: _volume,
      supplementIds: _selectedSupplements,
      hasIce: _hasIce,
    );
    
    widget.onAdd(intake);
  }

  void _addToFavorites() async {
    final l10n = AppLocalizations.of(context); // FIXED: Added this line
    
    final favorite = FavoriteDrink(
      drinkId: widget.drink.id,
      defaultVolumeMl: _volume,
      defaultSupplementIds: _selectedSupplements,
      hasIce: _hasIce,
    );
    
    final success = await widget.favoritesManager.addFavorite(favorite);
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.addedToFavorites)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.favoriteLimitReached)),
        );
      }
    }
  }
}