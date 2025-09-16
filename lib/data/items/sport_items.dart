// lib/data/items/sport_items.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../catalog_item.dart';

class SportItems {
  static List<CatalogItem> getAllItems() {
    return [
      // ============= CARDIO CATEGORY (9 items: 3 FREE + 6 PRO) =============
      // FREE cardio items
      CatalogItem(
        id: 'sport_walking',
        getName: (l10n) => l10n.walking,
        icon: '🚶',
        properties: {
          'category': 'cardio',
          'intensity': 'low',
          'intensityValue': 2,
          'defaultMinutes': 30,
          'met': 3.5,
          'naPerL': 800,
          'kPerL': 200,
          'mgPerL': 40,
          'sweatRate': 400, // ml/hour base
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.green,
      ),
      CatalogItem(
        id: 'sport_running',
        getName: (l10n) => l10n.running,
        icon: '🏃',
        properties: {
          'category': 'cardio',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 30,
          'met': 8.0,
          'naPerL': 900,
          'kPerL': 250,
          'mgPerL': 45,
          'sweatRate': 800,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.orange,
      ),
      CatalogItem(
        id: 'sport_cycling',
        getName: (l10n) => l10n.cycling,
        icon: '🚴',
        properties: {
          'category': 'cardio',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 45,
          'met': 7.0,
          'naPerL': 850,
          'kPerL': 220,
          'mgPerL': 42,
          'sweatRate': 700,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.blue,
      ),
      
      // PRO cardio items
      CatalogItem(
        id: 'sport_swimming',
        getName: (l10n) => l10n.swimming,
        icon: '🏊',
        properties: {
          'category': 'cardio',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 30,
          'met': 9.0,
          'naPerL': 700, // Less sodium loss in water
          'kPerL': 180,
          'mgPerL': 35,
          'sweatRate': 600,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.cyan,
      ),
      CatalogItem(
        id: 'sport_elliptical',
        getName: (l10n) => 'Elliptical',
        icon: '🏋️',
        properties: {
          'category': 'cardio',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 30,
          'met': 6.0,
          'naPerL': 800,
          'kPerL': 200,
          'mgPerL': 40,
          'sweatRate': 650,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.purple,
      ),
      CatalogItem(
        id: 'sport_rowing',
        getName: (l10n) => 'Rowing',
        icon: '🚣',
        properties: {
          'category': 'cardio',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 20,
          'met': 8.5,
          'naPerL': 950,
          'kPerL': 280,
          'mgPerL': 50,
          'sweatRate': 900,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.teal,
      ),
      CatalogItem(
        id: 'sport_jump_rope',
        getName: (l10n) => 'Jump Rope',
        icon: '🪢',
        properties: {
          'category': 'cardio',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 15,
          'met': 11.0,
          'naPerL': 1000,
          'kPerL': 300,
          'mgPerL': 55,
          'sweatRate': 1000,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.red,
      ),
      CatalogItem(
        id: 'sport_stairs',
        getName: (l10n) => 'Stair Climbing',
        icon: '🪜',
        properties: {
          'category': 'cardio',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 20,
          'met': 7.5,
          'naPerL': 900,
          'kPerL': 240,
          'mgPerL': 45,
          'sweatRate': 750,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.brown,
      ),
      CatalogItem(
        id: 'sport_dancing',
        getName: (l10n) => l10n.dancing,
        icon: '💃',
        properties: {
          'category': 'cardio',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 45,
          'met': 5.5,
          'naPerL': 750,
          'kPerL': 200,
          'mgPerL': 38,
          'sweatRate': 600,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.pink,
      ),

      // ============= STRENGTH CATEGORY (9 items: 3 FREE + 6 PRO) =============
      // FREE strength items
      CatalogItem(
        id: 'sport_gym',
        getName: (l10n) => l10n.gym,
        icon: '💪',
        properties: {
          'category': 'strength',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 45,
          'met': 6.0,
          'naPerL': 850,
          'kPerL': 220,
          'mgPerL': 45,
          'sweatRate': 700,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.indigo,
      ),
      CatalogItem(
        id: 'sport_crossfit',
        getName: (l10n) => l10n.crossfit,
        icon: '🏋️',
        properties: {
          'category': 'strength',
          'intensity': 'high',
          'intensityValue': 5,
          'defaultMinutes': 30,
          'met': 10.0,
          'naPerL': 1100,
          'kPerL': 320,
          'mgPerL': 60,
          'sweatRate': 1100,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.deepOrange,
      ),
      CatalogItem(
        id: 'sport_bodyweight',
        getName: (l10n) => 'Bodyweight',
        icon: '🤸',
        properties: {
          'category': 'strength',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 30,
          'met': 5.0,
          'naPerL': 800,
          'kPerL': 200,
          'mgPerL': 40,
          'sweatRate': 600,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.green,
      ),
      
      // PRO strength items
      CatalogItem(
        id: 'sport_powerlifting',
        getName: (l10n) => 'Powerlifting',
        icon: '🏋️‍♂️',
        properties: {
          'category': 'strength',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 60,
          'met': 6.0,
          'naPerL': 900,
          'kPerL': 250,
          'mgPerL': 50,
          'sweatRate': 800,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.grey,
      ),
      CatalogItem(
        id: 'sport_calisthenics',
        getName: (l10n) => 'Calisthenics',
        icon: '🤾',
        properties: {
          'category': 'strength',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 40,
          'met': 6.5,
          'naPerL': 850,
          'kPerL': 220,
          'mgPerL': 45,
          'sweatRate': 700,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.blue,
      ),
      CatalogItem(
        id: 'sport_resistance_bands',
        getName: (l10n) => 'Resistance Bands',
        icon: '🎯',
        properties: {
          'category': 'strength',
          'intensity': 'low',
          'intensityValue': 2,
          'defaultMinutes': 30,
          'met': 4.0,
          'naPerL': 700,
          'kPerL': 180,
          'mgPerL': 35,
          'sweatRate': 500,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.purple,
      ),
      CatalogItem(
        id: 'sport_kettlebell',
        getName: (l10n) => 'Kettlebell',
        icon: '🔔',
        properties: {
          'category': 'strength',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 25,
          'met': 8.0,
          'naPerL': 950,
          'kPerL': 270,
          'mgPerL': 52,
          'sweatRate': 850,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.orange,
      ),
      CatalogItem(
        id: 'sport_trx',
        getName: (l10n) => 'TRX',
        icon: '🪢',
        properties: {
          'category': 'strength',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 30,
          'met': 7.0,
          'naPerL': 850,
          'kPerL': 230,
          'mgPerL': 45,
          'sweatRate': 700,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.yellow[700]!,
      ),
      CatalogItem(
        id: 'sport_strongman',
        getName: (l10n) => 'Strongman',
        icon: '🦾',
        properties: {
          'category': 'strength',
          'intensity': 'high',
          'intensityValue': 5,
          'defaultMinutes': 45,
          'met': 9.0,
          'naPerL': 1200,
          'kPerL': 350,
          'mgPerL': 65,
          'sweatRate': 1200,
          'indoorCapable': false,
        },
        isPro: true,
        color: Colors.red[900]!,
      ),

      // ============= SPORTS & ACTIVITIES CATEGORY (9 items: 3 FREE + 6 PRO) =============
      // FREE sports items
      CatalogItem(
        id: 'sport_yoga',
        getName: (l10n) => l10n.yoga,
        icon: '🧘',
        properties: {
          'category': 'sports',
          'intensity': 'low',
          'intensityValue': 1,
          'defaultMinutes': 60,
          'met': 3.0,
          'naPerL': 600,
          'kPerL': 150,
          'mgPerL': 30,
          'sweatRate': 300,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.purple[300]!,
      ),
      CatalogItem(
        id: 'sport_pilates',
        getName: (l10n) => 'Pilates',
        icon: '🧘‍♀️',
        properties: {
          'category': 'sports',
          'intensity': 'low',
          'intensityValue': 2,
          'defaultMinutes': 45,
          'met': 3.5,
          'naPerL': 650,
          'kPerL': 170,
          'mgPerL': 32,
          'sweatRate': 400,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.cyan[300]!,
      ),
      CatalogItem(
        id: 'sport_boxing',
        getName: (l10n) => l10n.boxing,
        icon: '🥊',
        properties: {
          'category': 'sports',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 30,
          'met': 9.5,
          'naPerL': 1000,
          'kPerL': 280,
          'mgPerL': 55,
          'sweatRate': 950,
          'indoorCapable': true,
        },
        isPro: false,
        color: Colors.red,
      ),
      
      // PRO sports items
      CatalogItem(
        id: 'sport_tennis',
        getName: (l10n) => l10n.tennis,
        icon: '🎾',
        properties: {
          'category': 'sports',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 60,
          'met': 7.3,
          'naPerL': 900,
          'kPerL': 240,
          'mgPerL': 46,
          'sweatRate': 800,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.lime,
      ),
      CatalogItem(
        id: 'sport_basketball',
        getName: (l10n) => 'Basketball',
        icon: '🏀',
        properties: {
          'category': 'sports',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 45,
          'met': 8.0,
          'naPerL': 950,
          'kPerL': 260,
          'mgPerL': 50,
          'sweatRate': 900,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.orange[700]!,
      ),
      CatalogItem(
        id: 'sport_soccer',
        getName: (l10n) => 'Soccer/Football',
        icon: '⚽',
        properties: {
          'category': 'sports',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 45,
          'met': 8.5,
          'naPerL': 1000,
          'kPerL': 270,
          'mgPerL': 52,
          'sweatRate': 950,
          'indoorCapable': false,
        },
        isPro: true,
        color: Colors.green[700]!,
      ),
      CatalogItem(
        id: 'sport_golf',
        getName: (l10n) => 'Golf',
        icon: '⛳',
        properties: {
          'category': 'sports',
          'intensity': 'low',
          'intensityValue': 2,
          'defaultMinutes': 120,
          'met': 3.8,
          'naPerL': 700,
          'kPerL': 180,
          'mgPerL': 35,
          'sweatRate': 400,
          'indoorCapable': false,
        },
        isPro: true,
        color: Colors.green[300]!,
      ),
      CatalogItem(
        id: 'sport_martial_arts',
        getName: (l10n) => 'Martial Arts',
        icon: '🥋',
        properties: {
          'category': 'sports',
          'intensity': 'high',
          'intensityValue': 4,
          'defaultMinutes': 45,
          'met': 10.0,
          'naPerL': 1050,
          'kPerL': 290,
          'mgPerL': 56,
          'sweatRate': 1000,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.red[700]!,
      ),
      CatalogItem(
        id: 'sport_climbing',
        getName: (l10n) => 'Rock Climbing',
        icon: '🧗',
        properties: {
          'category': 'sports',
          'intensity': 'moderate',
          'intensityValue': 3,
          'defaultMinutes': 60,
          'met': 8.0,
          'naPerL': 900,
          'kPerL': 250,
          'mgPerL': 48,
          'sweatRate': 750,
          'indoorCapable': true,
        },
        isPro: true,
        color: Colors.brown[600]!,
      ),
    ];
  }

  /// Get sports items by category
  static List<CatalogItem> getByCategory(String category) {
    return getAllItems().where((item) => 
      item.properties['category'] == category
    ).toList();
  }

  /// Get intensity label
  static String getIntensityLabel(String intensity, AppLocalizations l10n) {
    switch (intensity) {
      case 'low':
        return l10n.lowIntensity;
      case 'moderate':
        return l10n.mediumIntensity;
      case 'high':
        return l10n.highIntensity;
      case 'very_high':
        return l10n.veryHighIntensity ?? 'Very High';
      default:
        return intensity;
    }
  }

  /// Get intensity color
  static Color getIntensityColor(String intensity) {
    switch (intensity) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'very_high':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}