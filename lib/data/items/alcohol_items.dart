// lib/data/items/alcohol_items.dart
import '../catalog_item.dart';

class AlcoholItems {
  // Beer
  static List<CatalogItem> getBeer() {
    return [
      CatalogItem(
        id: 'alcohol_light_beer',
        getName: (l10n) => 'Light Beer',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 330, 'imperial': 12},
          'abv': 4.0,
          'sugar': 3.3,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_lager',
        getName: (l10n) => 'Lager',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 500, 'imperial': 17},
          'abv': 5.0,
          'sugar': 5.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_ipa',
        getName: (l10n) => 'IPA',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 330, 'imperial': 12},
          'abv': 6.5,
          'sugar': 2.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_stout',
        getName: (l10n) => 'Stout',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 440, 'imperial': 15},
          'abv': 7.0,
          'sugar': 4.4,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_wheat_beer',
        getName: (l10n) => 'Wheat Beer',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 500, 'imperial': 17},
          'abv': 5.2,
          'sugar': 7.5,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_craft_beer',
        getName: (l10n) => 'Craft Beer',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 355, 'imperial': 12},
          'abv': 6.0,
          'sugar': 3.5,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_non_alcoholic',
        getName: (l10n) => 'Non-Alcoholic',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 330, 'imperial': 12},
          'abv': 0.5,
          'sugar': 8.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_radler',
        getName: (l10n) => 'Radler',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 500, 'imperial': 17},
          'abv': 2.5,
          'sugar': 15.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_pilsner',
        getName: (l10n) => 'Pilsner',
        icon: '🍺',
        properties: {
          'type': 'beer',
          'defaultVolume': {'metric': 500, 'imperial': 17},
          'abv': 4.8,
          'sugar': 3.0,
        },
        isPro: true,
      ),
    ];
  }

  // Wine
  static List<CatalogItem> getWine() {
    return [
      CatalogItem(
        id: 'alcohol_red_wine',
        getName: (l10n) => 'Red Wine',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 150, 'imperial': 5},
          'abv': 13.5,
          'sugar': 1.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_white_wine',
        getName: (l10n) => 'White Wine',
        icon: '🥂',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 150, 'imperial': 5},
          'abv': 12.0,
          'sugar': 1.5,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_prosecco',
        getName: (l10n) => 'Prosecco',
        icon: '🍾',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 125, 'imperial': 4},
          'abv': 11.0,
          'sugar': 2.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_port',
        getName: (l10n) => 'Port',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 75, 'imperial': 3},
          'abv': 20.0,
          'sugar': 7.5,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_rose',
        getName: (l10n) => 'Rosé',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 150, 'imperial': 5},
          'abv': 12.5,
          'sugar': 3.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_champagne',
        getName: (l10n) => 'Champagne',
        icon: '🍾',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 125, 'imperial': 4},
          'abv': 12.0,
          'sugar': 1.5,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_dessert_wine',
        getName: (l10n) => 'Dessert Wine',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 100, 'imperial': 3},
          'abv': 15.0,
          'sugar': 15.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_sangria',
        getName: (l10n) => 'Sangria',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 200, 'imperial': 7},
          'abv': 9.0,
          'sugar': 18.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_sherry',
        getName: (l10n) => 'Sherry',
        icon: '🍷',
        properties: {
          'type': 'wine',
          'defaultVolume': {'metric': 75, 'imperial': 3},
          'abv': 17.0,
          'sugar': 5.0,
        },
        isPro: true,
      ),
    ];
  }

  // Spirits
  static List<CatalogItem> getSpirits() {
    return [
      CatalogItem(
        id: 'alcohol_vodka',
        getName: (l10n) => 'Vodka Shot',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 30, 'imperial': 1},
          'abv': 40.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_whiskey',
        getName: (l10n) => 'Whiskey',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 40.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_tequila',
        getName: (l10n) => 'Tequila',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 30, 'imperial': 1},
          'abv': 38.0,
          'sugar': 0.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_rum',
        getName: (l10n) => 'Rum',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 37.5,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_gin',
        getName: (l10n) => 'Gin',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 40.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_cognac',
        getName: (l10n) => 'Cognac',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 40.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_liqueur',
        getName: (l10n) => 'Liqueur',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 20.0,
          'sugar': 15.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_absinthe',
        getName: (l10n) => 'Absinthe',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 30, 'imperial': 1},
          'abv': 70.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_brandy',
        getName: (l10n) => 'Brandy',
        icon: '🥃',
        properties: {
          'type': 'spirits',
          'defaultVolume': {'metric': 50, 'imperial': 2},
          'abv': 40.0,
          'sugar': 0.0,
        },
        isPro: true,
      ),
    ];
  }

  // Cocktails
  static List<CatalogItem> getCocktails() {
    return [
      CatalogItem(
        id: 'alcohol_mojito',
        getName: (l10n) => 'Mojito',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'abv': 10.0,
          'sugar': 25.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_margarita',
        getName: (l10n) => 'Margarita',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 200, 'imperial': 7},
          'abv': 15.0,
          'sugar': 20.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_long_island',
        getName: (l10n) => 'Long Island',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'abv': 22.0,
          'sugar': 33.0,
        },
        isPro: false,
      ),
      CatalogItem(
        id: 'alcohol_gin_tonic',
        getName: (l10n) => 'Gin & Tonic',
        icon: '🍸',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'abv': 10.0,
          'sugar': 18.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_pina_colada',
        getName: (l10n) => 'Piña Colada',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 240, 'imperial': 8},
          'abv': 10.0,
          'sugar': 35.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_cosmopolitan',
        getName: (l10n) => 'Cosmopolitan',
        icon: '🍸',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 150, 'imperial': 5},
          'abv': 20.0,
          'sugar': 12.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_mai_tai',
        getName: (l10n) => 'Mai Tai',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 200, 'imperial': 7},
          'abv': 17.0,
          'sugar': 28.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_bloody_mary',
        getName: (l10n) => 'Bloody Mary',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 250, 'imperial': 8},
          'abv': 12.0,
          'sugar': 10.0,
        },
        isPro: true,
      ),
      CatalogItem(
        id: 'alcohol_daiquiri',
        getName: (l10n) => 'Daiquiri',
        icon: '🍹',
        properties: {
          'type': 'cocktail',
          'defaultVolume': {'metric': 180, 'imperial': 6},
          'abv': 13.0,
          'sugar': 22.0,
        },
        isPro: true,
      ),
    ];
  }

  // Получить все элементы
  static List<CatalogItem> getAllItems() {
    return [...getBeer(), ...getWine(), ...getSpirits(), ...getCocktails()];
  }

  // Получить элементы по типу
  static List<CatalogItem> getByType(String type) {
    switch (type) {
      case 'beer':
        return getBeer();
      case 'wine':
        return getWine();
      case 'spirits':
        return getSpirits();
      case 'cocktail':
        return getCocktails();
      default:
        return [];
    }
  }
}
