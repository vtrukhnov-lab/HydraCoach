// lib/data/catalog_item.dart
import 'package:flutter/material.dart';
import '../utils/app_logger.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_logger.dart';

/// Базовый класс для элемента каталога
class CatalogItem {
  final String id;
  final String Function(AppLocalizations) getName;
  final dynamic icon; // IconData или String emoji
  final Map<String, dynamic> properties;
  final bool isPro;
  final Color? color;

  const CatalogItem({
    required this.id,
    required this.getName,
    required this.icon,
    required this.properties,
    this.isPro = false,
    this.color,
  });

  /// Получить объем по умолчанию в зависимости от системы единиц
  int getDefaultVolume(String units) {
    final volumes = properties['defaultVolume'] as Map<String, dynamic>?;
    if (volumes == null) return 250;

    final value = volumes[units] ?? volumes['metric'] ?? 250;
    return value is int ? value : (value as double).toInt();
  }

  /// Получить единицу измерения дозировки (для supplements)
  String getDosageUnit(String units) {
    final dosageUnits = properties['dosageUnit'] as Map<String, String>?;
    if (dosageUnits == null) return '';
    return dosageUnits[units] ?? dosageUnits['metric'] ?? '';
  }

  /// Получить дозировку по умолчанию (для supplements)
  num getDefaultDosage(String units) {
    if (units == 'imperial' && properties['defaultDosageImperial'] != null) {
      return properties['defaultDosageImperial'] as num;
    }
    return properties['defaultDosage'] ?? 1;
  }

  /// Получить содержание магния с учетом единиц (для supplements)
  num getMagnesiumContent(String units) {
    if (units == 'imperial' && properties['magnesiumImperial'] != null) {
      return properties['magnesiumImperial'] as num;
    }
    return properties['magnesium'] ?? 0;
  }
}
