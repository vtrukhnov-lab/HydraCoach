// lib/data/items/sport_items.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../catalog_item.dart';

class SportItems {
  static List<CatalogItem> getAllItems() {
    return [
      // FREE activities
      CatalogItem(
        id: 'sport_walking',
        getName: (l10n) => l10n.walking,
        icon: Icons.directions_walk,
        properties: {
          'type': 'walking',
          'intensity': 'low',
          'intensityValue': 2,
          'mlPerKgPerHour': 12,
          'sodiumMgPerHour': 200,
          'potassiumMgPerHour': 50,
          'magnesiumMgPerHour': 10,
        },
        isPro: false,
        color: Colors.green,
      ),
      CatalogItem(
        id: 'sport_running',
        getName: (l10n) => l10n.running,
        icon: Icons.directions_run,
        properties: {
          'type': 'running',
          'intensity': 'medium',
          'intensityValue': 3,
          'mlPerKgPerHour': 17,
          'sodiumMgPerHour': 400,
          'potassiumMgPerHour': 100,
          'magnesiumMgPerHour': 20,
        },
        isPro: false,
        color: Colors.orange,
      ),
      CatalogItem(
        id: 'sport_gym',
        getName: (l10n) => l10n.gym,
        icon: Icons.fitness_center,
        properties: {
          'type': 'gym',
          'intensity': 'high',
          'intensityValue': 4,
          'mlPerKgPerHour': 24,
          'sodiumMgPerHour': 600,
          'potassiumMgPerHour': 150,
          'magnesiumMgPerHour': 30,
        },
        isPro: false,
        color: Colors.red,
      ),
      // PRO activities
      CatalogItem(
        id: 'sport_cycling',
        getName: (l10n) => l10n.cycling,
        icon: Icons.directions_bike,
        properties: {
          'type': 'cycling',
          'intensity': 'medium',
          'intensityValue': 3,
          'mlPerKgPerHour': 16,
          'sodiumMgPerHour': 350,
          'potassiumMgPerHour': 90,
          'magnesiumMgPerHour': 18,
        },
        isPro: true,
        color: Colors.orange,
      ),
      CatalogItem(
        id: 'sport_swimming',
        getName: (l10n) => l10n.swimming,
        icon: Icons.pool,
        properties: {
          'type': 'swimming',
          'intensity': 'high',
          'intensityValue': 4,
          'mlPerKgPerHour': 20,
          'sodiumMgPerHour': 300,
          'potassiumMgPerHour': 80,
          'magnesiumMgPerHour': 15,
        },
        isPro: true,
        color: Colors.blue,
      ),
      CatalogItem(
        id: 'sport_yoga',
        getName: (l10n) => l10n.yoga,
        icon: Icons.self_improvement,
        properties: {
          'type': 'yoga',
          'intensity': 'low',
          'intensityValue': 1,
          'mlPerKgPerHour': 10,
          'sodiumMgPerHour': 150,
          'potassiumMgPerHour': 40,
          'magnesiumMgPerHour': 8,
        },
        isPro: true,
        color: Colors.purple,
      ),
      CatalogItem(
        id: 'sport_hiit',
        getName: (l10n) => l10n.hiit,
        icon: Icons.flash_on,
        properties: {
          'type': 'hiit',
          'intensity': 'very_high',
          'intensityValue': 5,
          'mlPerKgPerHour': 30,
          'sodiumMgPerHour': 800,
          'potassiumMgPerHour': 200,
          'magnesiumMgPerHour': 40,
        },
        isPro: true,
        color: Colors.deepOrange,
      ),
      CatalogItem(
        id: 'sport_crossfit',
        getName: (l10n) => l10n.crossfit,
        icon: Icons.sports_mma,
        properties: {
          'type': 'crossfit',
          'intensity': 'very_high',
          'intensityValue': 5,
          'mlPerKgPerHour': 28,
          'sodiumMgPerHour': 700,
          'potassiumMgPerHour': 180,
          'magnesiumMgPerHour': 35,
        },
        isPro: true,
        color: Colors.deepOrange,
      ),
      CatalogItem(
        id: 'sport_boxing',
        getName: (l10n) => l10n.boxing,
        icon: Icons.sports_kabaddi,
        properties: {
          'type': 'boxing',
          'intensity': 'high',
          'intensityValue': 4,
          'mlPerKgPerHour': 25,
          'sodiumMgPerHour': 650,
          'potassiumMgPerHour': 160,
          'magnesiumMgPerHour': 32,
        },
        isPro: true,
        color: Colors.red,
      ),
      CatalogItem(
        id: 'sport_dancing',
        getName: (l10n) => l10n.dancing,
        icon: Icons.music_note,
        properties: {
          'type': 'dancing',
          'intensity': 'medium',
          'intensityValue': 3,
          'mlPerKgPerHour': 15,
          'sodiumMgPerHour': 300,
          'potassiumMgPerHour': 75,
          'magnesiumMgPerHour': 15,
        },
        isPro: true,
        color: Colors.pink,
      ),
      CatalogItem(
        id: 'sport_tennis',
        getName: (l10n) => l10n.tennis,
        icon: Icons.sports_tennis,
        properties: {
          'type': 'tennis',
          'intensity': 'medium',
          'intensityValue': 3,
          'mlPerKgPerHour': 18,
          'sodiumMgPerHour': 450,
          'potassiumMgPerHour': 110,
          'magnesiumMgPerHour': 22,
        },
        isPro: true,
        color: Colors.lime,
      ),
      CatalogItem(
        id: 'sport_team_sports',
        getName: (l10n) => l10n.teamSports,
        icon: Icons.sports_soccer,
        properties: {
          'type': 'team_sports',
          'intensity': 'high',
          'intensityValue': 4,
          'mlPerKgPerHour': 22,
          'sodiumMgPerHour': 500,
          'potassiumMgPerHour': 130,
          'magnesiumMgPerHour': 25,
        },
        isPro: true,
        color: Colors.green,
      ),
    ];
  }

  // Получить описание интенсивности
  static String getIntensityLabel(String intensity, AppLocalizations l10n) {
    switch (intensity) {
      case 'low':
        return l10n.lowIntensity;
      case 'medium':
        return l10n.mediumIntensity;
      case 'high':
        return l10n.highIntensity;
      case 'very_high':
        return l10n.veryHighIntensity;
      default:
        return intensity;
    }
  }

  // Получить цвет интенсивности
  static Color getIntensityColor(String intensity) {
    switch (intensity) {
      case 'low':
        return Colors.green;
      case 'medium':
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