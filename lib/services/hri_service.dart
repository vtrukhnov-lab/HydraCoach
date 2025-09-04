import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'remote_config_service.dart';

class HRIService extends ChangeNotifier {
  static const String _hriKey = 'current_hri';
  static const String _lastUpdateKey = 'hri_last_update';

  double _currentHRI = 50.0;
  DateTime _lastUpdate = DateTime.now();

  // Текущее состояние факторов (кэш последнего полного расчёта)
  double _waterIntakeRatio = 0.0;
  double _sodiumRatio = 0.0;
  double _heatIndexFactor = 0.0;
  double _activityFactor = 0.0;
  double _caffeineFactor = 0.0;
  double _alcoholFactor = 0.0;
  double _timeSinceLastIntake = 0.0;
  double _sleepQuality = 1.0;
  double _morningWeight = 0.0;
  int _urineColor = 3;

  // «Память» для водного компонента — чтобы не было скачков
  double _lastWaterRatio = 0.0;
  double _lastWaterComponent = 40.0;

  double get currentHRI => _currentHRI;
  DateTime get lastUpdate => _lastUpdate;

  String get hriZone {
    if (_currentHRI <= 30) return 'green';
    if (_currentHRI <= 60) return 'yellow';
    return 'red';
  }

  String get hriStatus {
    if (_currentHRI <= 20) return 'Отличная гидратация';
    if (_currentHRI <= 40) return 'Хорошая гидратация';
    if (_currentHRI <= 60) return 'Умеренный риск';
    if (_currentHRI <= 80) return 'Повышенный риск';
    return 'Критический риск';
  }

  HRIService() {
    _loadHRI();
  }

  Future<void> _loadHRI() async {
    final prefs = await SharedPreferences.getInstance();
    _currentHRI = prefs.getDouble(_hriKey) ?? 50.0;

    final lastUpdateMillis = prefs.getInt(_lastUpdateKey);
    if (lastUpdateMillis != null) {
      _lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    }

    _lastWaterRatio = 0.0;
    _lastWaterComponent = 40.0;
    notifyListeners();
  }

  Future<void> _saveHRI() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_hriKey, _currentHRI);
    await prefs.setInt(_lastUpdateKey, _lastUpdate.millisecondsSinceEpoch);
  }

  // ---- вспомогательные кривые ------------------------------------------------------

  double _waterComponentByRatio(double r) {
    if (r < 0.5) {
      return 40 * (1 - r * 2);           // 0..0.5 → 40..0
    } else if (r < 0.8) {
      return 20 * (1 - (r - 0.5) / 0.3); // 0.5..0.8 → 20..0
    } else if (r <= 1.2) {
      return 0;                          // оптимум
    } else {
      return min(20, (r - 1.2) * 50);    // перепивание
    }
  }

  double _sodiumComponentByRatio(double r) {
    if (r < 0.3) return 20;
    if (r < 0.7) return 20 * (1 - (r - 0.3) / 0.4);
    if (r <= 1.3) return 0;
    return min(10, (r - 1.3) * 20);
  }

  // Монокламп для воды:
  // - При событии приёма и r выросло (и ≤1.2) — компонент НЕ может вырасти.
  // - При системном изменении цели (r упало и ≤1.2) — тоже не даём ухудшить компонент рывком.
  double _clampWaterComponent({
    required double newComponent,
    required double newRatio,
    required bool likelyIntakeEvent,
  }) {
    final bool ratioGrew = newRatio >= _lastWaterRatio - 1e-9;
    final bool ratioDropped = newRatio < _lastWaterRatio - 1e-9;

    if (newRatio <= 1.2) {
      if (likelyIntakeEvent && ratioGrew) {
        return min(newComponent, _lastWaterComponent);
      }
      if (!likelyIntakeEvent && ratioDropped) {
        return min(newComponent, _lastWaterComponent);
      }
    }
    return newComponent;
  }

  // ------------------------------------------------------------------------------
  Future<void> calculateHRI({
    required double waterIntake,
    required double waterGoal,
    required double sodiumIntake,
    required double sodiumGoal,
    double? heatIndex,
    int activityLevel = 0,
    int coffeeCups = 0,
    double alcoholSD = 0.0,
    DateTime? lastIntakeTime,
    double? morningWeightChange,
    int? urineColorValue,
    double? sleepQualityValue,
  }) async {
    // 1) Вода
    _waterIntakeRatio = waterGoal > 0 ? (waterIntake / waterGoal) : 0.0;
    double waterComponentRaw = _waterComponentByRatio(_waterIntakeRatio);

    final bool likelyIntakeEvent =
        lastIntakeTime != null || DateTime.now().difference(_lastUpdate).inMinutes <= 2;

    final double waterComponent = _clampWaterComponent(
      newComponent: waterComponentRaw,
      newRatio: _waterIntakeRatio,
      likelyIntakeEvent: likelyIntakeEvent,
    );

    // 2) Натрий
    _sodiumRatio = sodiumGoal > 0 ? (sodiumIntake / sodiumGoal) : 0.0;
    final double sodiumComponent = _sodiumComponentByRatio(_sodiumRatio);

    // 3) Жара (Heat Index)
    _heatIndexFactor = 0.0;
    if (heatIndex != null) {
      if (heatIndex < 27) _heatIndexFactor = 0;
      else if (heatIndex < 32) _heatIndexFactor = 5;
      else if (heatIndex < 39) _heatIndexFactor = 10;
      else _heatIndexFactor = 15;
    }

    // 4) Активность
    _activityFactor = activityLevel * 3.5; // как было

    // 5) Кофеин
    _caffeineFactor = min(8.0, coffeeCups * 2.0);

    // 6) Алкоголь
    final rc = RemoteConfigService.instance;
    final alcPerSD = rc.getDouble('alc_hri_risk_per_sd'); // по умолчанию 5.0
    final alcCap = rc.getDouble('alc_hri_risk_cap');      // по умолчанию 15.0
    _alcoholFactor = min(alcCap, max(0.0, alcoholSD) * alcPerSD);

    // 7) Время с последнего приёма
    _timeSinceLastIntake = 0.0;
    if (lastIntakeTime != null) {
      final h = DateTime.now().difference(lastIntakeTime).inHours;
      if (h > 3) _timeSinceLastIntake = min(10.0, (h - 3) * 2.0);
    }

    // 8) Утро (вес/цвет мочи/сон)
    double morning = 0.0;
    if (morningWeightChange != null && morningWeightChange < -2.0) morning += 3;
    if (urineColorValue != null) {
      _urineColor = urineColorValue;
      if (_urineColor >= 6) morning += 4;
      else if (_urineColor >= 4) morning += 2;
    }
    if (sleepQualityValue != null) {
      _sleepQuality = sleepQualityValue;
      if (_sleepQuality < 0.5) morning += 3;
    }

    // Сумма
    double total = waterComponent +
        sodiumComponent +
        _heatIndexFactor +
        _activityFactor +
        _caffeineFactor +
        _alcoholFactor +
        _timeSinceLastIntake +
        morning;

    _currentHRI = max(0, min(100, total));
    _lastUpdate = DateTime.now();

    // запоминаем водную историю для клампа
    _lastWaterRatio = _waterIntakeRatio;
    _lastWaterComponent = waterComponent;

    if (kDebugMode) {
      print('=== HRI Calculation ===');
      print('Water: $waterComponent (ratio: $_waterIntakeRatio)');
      print('Sodium: $sodiumComponent (ratio: $_sodiumRatio)');
      print('Heat: $_heatIndexFactor');
      print('Activity: $_activityFactor');
      print('Caffeine: $_caffeineFactor');
      print('Alcohol: $_alcoholFactor');
      print('Time: $_timeSinceLastIntake');
      print('Morning: $morning');
      print('TOTAL HRI: $_currentHRI');
      print('===================');
    }

    await _saveHRI();
    notifyListeners();
  }

  // Быстрый апдейт после питья
  Future<void> quickUpdate({
    required double waterIntake,
    required double waterGoal,
    double? sodiumIntake,   // можно не передавать — возьмём прошлое
    double? sodiumGoal,     // можно не передавать — возьмём прошлое
    DateTime? intakeTime,
  }) async {
    _waterIntakeRatio = waterGoal > 0 ? (waterIntake / waterGoal) : 0.0;
    _timeSinceLastIntake = 0.0;

    final raw = _waterComponentByRatio(_waterIntakeRatio);
    final clamped = _clampWaterComponent(
      newComponent: raw,
      newRatio: _waterIntakeRatio,
      likelyIntakeEvent: true,
    );

    double sodiumComponent;
    if (sodiumIntake != null && sodiumGoal != null && sodiumGoal > 0) {
      _sodiumRatio = sodiumIntake / sodiumGoal;
      sodiumComponent = _sodiumComponentByRatio(_sodiumRatio);
    } else {
      // пересчитаем из текущего _sodiumRatio
      sodiumComponent = _sodiumComponentByRatio(_sodiumRatio);
    }

    double total = clamped +
        sodiumComponent +
        _heatIndexFactor +
        _activityFactor +
        _caffeineFactor +
        _alcoholFactor +
        _timeSinceLastIntake;

    _currentHRI = max(0, min(100, total));
    _lastUpdate = DateTime.now();

    _lastWaterRatio = _waterIntakeRatio;
    _lastWaterComponent = clamped;

    if (kDebugMode) {
      print('=== HRI Quick Update ===');
      print('Water ratio: $_waterIntakeRatio');
      print('Water component: $clamped');
      print('Total HRI: $_currentHRI');
      print('=====================');
    }

    await _saveHRI();
    notifyListeners();
  }

  Future<void> updateMorningCheckIn({
    required int feeling, // 1..5
    double? weightChange,
    int? urineColor,
  }) async {
    _sleepQuality = feeling / 5.0;
    _morningWeight = weightChange ?? 0;
    _urineColor = urineColor ?? 3;
    notifyListeners();
  }

  Future<void> resetDaily() async {
    _currentHRI = 50.0;
    _alcoholFactor = 0;
    _caffeineFactor = 0;
    _activityFactor = 0;
    _lastUpdate = DateTime.now();

    _lastWaterRatio = 0.0;
    _lastWaterComponent = 40.0;

    await _saveHRI();
    notifyListeners();
  }
}
