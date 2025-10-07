// lib/services/achievement_tracker.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../repositories/achievements_repository.dart';
import '../providers/hydration_provider.dart';
import '../services/units_service.dart';
import 'hri_service.dart';
import 'alcohol_service.dart';
import 'analytics_service.dart';
import 'subscription_service.dart';

/// Сервис для отслеживания и разблокировки достижений
class AchievementTracker extends ChangeNotifier {
  static final AchievementTracker _instance = AchievementTracker._internal();
  factory AchievementTracker() => _instance;
  AchievementTracker._internal();

  final AchievementsRepository _repository = AchievementsRepository();
  final AnalyticsService _analytics = AnalyticsService();
  final UnitsService _unitsService =
      UnitsService.instance; // ✅ ДОБАВЛЕНО: Интеграция с UnitsService

  // Очередь новых разблокированных достижений для показа
  final List<Achievement> _unlockedQueue = [];

  // Трекинг просмотренных категорий
  final Set<AchievementCategory> _viewedCategories = <AchievementCategory>{};

  // Статистика текущего дня для отслеживания
  DateTime _currentDay = DateTime.now();
  int _waterIntakesToday = 0;
  int _electrolyteIntakesToday = 0;
  bool _reachedWaterGoalToday = false;
  bool _reachedElectrolyteGoalsToday = false;
  double _minSugarToday = double.infinity;
  double _maxSugarToday = 0;
  bool _hadSodaToday = false;
  int _workoutsToday = 0;
  double _minHRIToday = double.infinity;
  double _maxHRIToday = 0;
  bool _hadAlcoholToday = false;

  // ✅ ФИКС: Трекинг стрика с правильным подсчетом дней
  DateTime? _lastStreakUpdateDate;
  int _currentStreak = 0;
  int _soberDaysStreak = 0;

  // Getters
  List<Achievement> get unlockedQueue => List.unmodifiable(_unlockedQueue);
  bool get hasUnlockedAchievements => _unlockedQueue.isNotEmpty;

  // ============================================================================
  // ИНИЦИАЛИЗАЦИЯ
  // ============================================================================

  /// Инициализация трекера
  Future<void> initialize() async {
    await _repository.initialize();
    await _loadViewedCategories();
    await _loadStreakData(); // ✅ ФИКС: Загружаем данные стрика
    _loadDailyStats();
    notifyListeners();
  }

  /// ✅ ФИКС: Загрузка данных стрика из SharedPreferences
  Future<void> _loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();

    // Загружаем последнюю дату обновления стрика
    final lastUpdateStr = prefs.getString('last_streak_update_date');
    if (lastUpdateStr != null) {
      _lastStreakUpdateDate = DateTime.parse(lastUpdateStr);
    }

    // Загружаем текущий стрик
    _currentStreak = prefs.getInt('current_streak') ?? 0;
    _soberDaysStreak = prefs.getInt('sober_days_streak') ?? 0;

    // Проверяем, не пропустили ли мы дни
    await _validateStreak();
  }

  /// ✅ ФИКС: Валидация стрика (сброс при пропуске дней)
  Future<void> _validateStreak() async {
    if (_lastStreakUpdateDate == null) return;

    final now = DateTime.now();
    final daysSinceLastUpdate = _daysBetween(_lastStreakUpdateDate!, now);

    // Если пропустили больше 1 дня - сбрасываем стрик
    if (daysSinceLastUpdate > 1) {
      _currentStreak = 0;
      _soberDaysStreak = 0;
      await _saveStreakData();
    }
  }

  /// ✅ ФИКС: Сохранение данных стрика
  Future<void> _saveStreakData() async {
    final prefs = await SharedPreferences.getInstance();

    if (_lastStreakUpdateDate != null) {
      await prefs.setString(
        'last_streak_update_date',
        _lastStreakUpdateDate!.toIso8601String(),
      );
    }

    await prefs.setInt('current_streak', _currentStreak);
    await prefs.setInt('sober_days_streak', _soberDaysStreak);
  }

  /// ✅ ФИКС: Вычисление количества дней между датами
  int _daysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return endDate.difference(startDate).inDays;
  }

  /// Загрузка просмотренных категорий из SharedPreferences
  Future<void> _loadViewedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final viewed = prefs.getStringList('viewed_achievement_categories') ?? [];
    _viewedCategories.clear();
    for (final categoryName in viewed) {
      try {
        final category = AchievementCategory.values.firstWhere(
          (c) => c.name == categoryName,
        );
        _viewedCategories.add(category);
      } catch (e) {
        // Ignore invalid category names
      }
    }
  }

  /// Сохранение просмотренных категорий в SharedPreferences
  Future<void> _saveViewedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoryNames = _viewedCategories.map((c) => c.name).toList();
    await prefs.setStringList('viewed_achievement_categories', categoryNames);
  }

  /// Загрузка статистики дня
  void _loadDailyStats() {
    final now = DateTime.now();
    if (!_isSameDay(now, _currentDay)) {
      _resetDailyStats();
      _currentDay = now;
    }
  }

  /// Сброс ежедневной статистики
  void _resetDailyStats() {
    _waterIntakesToday = 0;
    _electrolyteIntakesToday = 0;
    _reachedWaterGoalToday = false;
    _reachedElectrolyteGoalsToday = false;
    _minSugarToday = double.infinity;
    _maxSugarToday = 0;
    _hadSodaToday = false;
    _workoutsToday = 0;
    _minHRIToday = double.infinity;
    _maxHRIToday = 0;
    _hadAlcoholToday = false;
  }

  // ============================================================================
  // ✅ НОВЫЕ МЕТОДЫ ДЛЯ КОНВЕРТАЦИИ ЕДИНИЦ
  // ============================================================================

  /// ✅ ИСПРАВЛЕНО: Конвертировать мл в текущие единицы пользователя для объемов
  double _convertVolumeToUserUnits(int volumeMl) {
    return _unitsService.toDisplayVolume(volumeMl);
  }

  /// ✅ ИСПРАВЛЕНО: Конвертировать граммы в текущие единицы пользователя для весов
  double _convertWeightToUserUnits(double weightGrams) {
    // Конвертируем граммы в кг, потом в единицы отображения
    final weightKg = weightGrams / 1000.0;
    return _unitsService.toDisplayWeight(weightKg);
  }

  /// ✅ ДОБАВЛЕНО: Получить локализованный максимальный прогресс для достижения
  int _getLocalizedMaxProgress(String achievementId) {
    final achievement = _repository.getAchievement(achievementId);
    if (achievement == null) return 1;

    return achievement.getLocalizedMaxProgress();
  }

  // ============================================================================
  // НОВЫЕ МЕТОДЫ ДЛЯ ИНДИКАТОРОВ ПО КАТЕГОРИЯМ
  // ============================================================================

  /// Получить количество новых достижений по категориям
  Map<AchievementCategory, int> getNewAchievementsByCategory() {
    final result = <AchievementCategory, int>{};

    for (final achievement in _unlockedQueue) {
      result[achievement.category] = (result[achievement.category] ?? 0) + 1;
    }

    return result;
  }

  /// Проверить есть ли новые достижения в категории
  bool hasNewInCategory(AchievementCategory category) {
    return _unlockedQueue.any(
      (achievement) => achievement.category == category,
    );
  }

  /// Получить количество новых достижений в категории
  int getNewCountInCategory(AchievementCategory category) {
    return _unlockedQueue
        .where((achievement) => achievement.category == category)
        .length;
  }

  /// Отметить категорию как просмотренную
  Future<void> markCategoryAsViewed(AchievementCategory category) async {
    _viewedCategories.add(category);

    // Удаляем достижения этой категории из очереди
    _unlockedQueue.removeWhere(
      (achievement) => achievement.category == category,
    );

    await _saveViewedCategories();
    notifyListeners();
  }

  /// Проверить была ли категория просмотрена с момента последних новых достижений
  bool isCategoryViewed(AchievementCategory category) {
    return _viewedCategories.contains(category) && !hasNewInCategory(category);
  }

  /// Получить все категории с новыми достижениями
  List<AchievementCategory> getCategoriesWithNewAchievements() {
    final categories = <AchievementCategory>{};
    for (final achievement in _unlockedQueue) {
      categories.add(achievement.category);
    }
    return categories.toList();
  }

  /// Очистить все новые достижения (отметить все как просмотренные)
  Future<void> markAllAsViewed() async {
    for (final achievement in _unlockedQueue) {
      _viewedCategories.add(achievement.category);
    }
    _unlockedQueue.clear();
    await _saveViewedCategories();
    notifyListeners();
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - HYDRATION
  // ============================================================================

  /// ✅ ИСПРАВЛЕНО: Отслеживание добавления воды с конвертацией единиц
  Future<void> trackWaterIntake({
    required int volumeMl,
    required double currentProgress,
    required double goalProgress,
  }) async {
    _loadDailyStats();

    // First Glass
    if (_waterIntakesToday == 0 && volumeMl > 0) {
      await _checkAndUnlock('first_glass');
    }
    _waterIntakesToday++;

    // Hydration Goals
    if (!_reachedWaterGoalToday && goalProgress >= 100) {
      _reachedWaterGoalToday = true;
      await _checkAndUnlock('hydration_goal_1');
      await _incrementProgress('hydration_goal_7');
      await _incrementProgress('hydration_goal_30');
    }

    // Perfect Balance (90-110%)
    if (goalProgress >= 90 && goalProgress <= 110) {
      await _checkAndUnlock('perfect_hydration');
    }

    // ✅ ИСПРАВЛЕНО: Early Bird - используем локализованный максимальный прогресс
    final now = DateTime.now();
    if (now.hour < 9) {
      final earlyBirdGoal = _getLocalizedMaxProgress('early_bird');
      final currentProgressUserUnits = _convertVolumeToUserUnits(
        currentProgress.round(),
      );

      if (currentProgressUserUnits >= earlyBirdGoal) {
        await _checkAndUnlock('early_bird');
      }
    }

    // Night Owl (complete before 6 PM)
    if (now.hour < 18 && goalProgress >= 100) {
      await _checkAndUnlock('night_owl');
    }

    // ✅ ИСПРАВЛЕНО: Liter Legend - используем конвертированный прогресс
    final literLegendProgressUserUnits = _convertVolumeToUserUnits(
      currentProgress.round(),
    );
    await _updateProgress('liter_legend', literLegendProgressUserUnits.round());

    // ✅ ФИКС: Обновляем стрик только раз в день
    await _updateStreakIfNeeded();
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - ELECTROLYTES
  // ============================================================================

  /// Отслеживание добавления электролитов
  Future<void> trackElectrolyteIntake({
    required int sodiumMg,
    required int potassiumMg,
    required int magnesiumMg,
    required bool reachedSodiumGoal,
    required bool reachedPotassiumGoal,
    required bool reachedMagnesiumGoal,
  }) async {
    _loadDailyStats();

    // Salt Starter
    if (_electrolyteIntakesToday == 0 &&
        (sodiumMg > 0 || potassiumMg > 0 || magnesiumMg > 0)) {
      await _checkAndUnlock('salt_starter');
    }
    _electrolyteIntakesToday++;

    // Electrolyte Balance (all goals in one day)
    if (!_reachedElectrolyteGoalsToday &&
        reachedSodiumGoal &&
        reachedPotassiumGoal &&
        reachedMagnesiumGoal) {
      _reachedElectrolyteGoalsToday = true;
      await _checkAndUnlock('electrolyte_balance');
      await _incrementProgress('electrolyte_expert');
    }

    // Individual electrolyte streaks
    if (reachedSodiumGoal) {
      await _incrementProgress('sodium_master');
    }
    if (reachedPotassiumGoal) {
      await _incrementProgress('potassium_pro');
    }
    if (reachedMagnesiumGoal) {
      await _incrementProgress('magnesium_maven');
    }
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - SUGAR
  // ============================================================================

  /// ✅ ИСПРАВЛЕНО: Отслеживание потребления сахара с конвертацией единиц
  Future<void> trackSugarIntake({
    required double totalGrams,
    required double addedSugarGrams,
    required double hiddenSugarGrams,
    required bool fromSoda,
  }) async {
    _loadDailyStats();

    // Sugar Awareness (first tracking)
    final sugarAwareness = _repository.getAchievement('sugar_awareness');
    if (sugarAwareness != null && !sugarAwareness.isUnlocked) {
      await _checkAndUnlock('sugar_awareness');
    }

    // Track min/max sugar for the day
    _minSugarToday = totalGrams < _minSugarToday ? totalGrams : _minSugarToday;
    _maxSugarToday = totalGrams > _maxSugarToday ? totalGrams : _maxSugarToday;

    // Track if had soda
    if (fromSoda) {
      _hadSodaToday = true;
    }

    // Hidden sugar detective
    if (hiddenSugarGrams > 0) {
      await _incrementProgress('sugar_detective');
    }
  }

  /// ✅ ИСПРАВЛЕНО: Проверка сахара в конце дня с локализованными лимитами
  Future<void> checkDailySugarAchievements() async {
    _loadDailyStats();

    // ✅ ИСПРАВЛЕНО: Sugar under 25g - используем локализованные лимиты
    final sugarLimitUserUnits = _convertWeightToUserUnits(
      25.0,
    ); // 25г в единицах пользователя
    final maxSugarUserUnits = _convertWeightToUserUnits(_maxSugarToday);

    if (maxSugarUserUnits < sugarLimitUserUnits) {
      await _checkAndUnlock('sugar_under_25');
      await _incrementProgress('sugar_week_control');
      await _incrementProgress('sugar_master');
    }

    // Sugar free day (0g added sugar)
    if (_maxSugarToday == 0) {
      await _checkAndUnlock('sugar_free_day');
    }

    // No soda streaks
    if (!_hadSodaToday) {
      await _incrementProgress('no_soda_week');
      await _incrementProgress('no_soda_month');
    }

    // Sweet tooth tamed (check weekly reduction)
    await _checkSugarReduction();
  }

  /// Проверка снижения потребления сахара
  Future<void> _checkSugarReduction() async {
    // TODO: Implement weekly sugar reduction tracking
    // Compare current week average to previous week
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - ALCOHOL
  // ============================================================================

  /// Отслеживание потребления алкоголя
  Future<void> trackAlcoholIntake({
    required double standardDrinks,
    required bool completedRecovery,
  }) async {
    _loadDailyStats();

    if (standardDrinks > 0) {
      _hadAlcoholToday = true;

      // Alcohol tracker
      await _checkAndUnlock('alcohol_tracker');

      // Moderation (under 2 SD)
      if (standardDrinks < 2) {
        await _checkAndUnlock('moderate_day');
      }

      // Recovery protocol
      if (completedRecovery) {
        await _checkAndUnlock('recovery_protocol');
      }

      // Reset sober streak
      _soberDaysStreak = 0;
    }
  }

  /// Проверка трезвых дней
  Future<void> checkSoberDay() async {
    _loadDailyStats();

    if (!_hadAlcoholToday) {
      _soberDaysStreak++;

      // Sober achievements
      await _checkAndUnlock('sober_day');
      await _updateProgress('sober_week', _soberDaysStreak);
      await _updateProgress('sober_month', _soberDaysStreak);
    }
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - WORKOUTS
  // ============================================================================

  /// ✅ ИСПРАВЛЕНО: Отслеживание тренировок с конвертацией потери воды
  Future<void> trackWorkout({
    required String type,
    required int durationMinutes,
    required int waterLossMl,
    required String category,
  }) async {
    _loadDailyStats();

    // First workout
    if (_workoutsToday == 0) {
      await _checkAndUnlock('first_workout');
    }
    _workoutsToday++;

    // Workout week
    await _incrementProgress('workout_week');

    // ✅ ИСПРАВЛЕНО: Century sweat - конвертируем потерю воды в единицы пользователя
    final waterLossUserUnits = _convertVolumeToUserUnits(waterLossMl);
    await _updateProgress('century_sweat', waterLossUserUnits.round());

    // Category specific
    if (category == 'cardio') {
      await _incrementProgress('cardio_king');
    } else if (category == 'strength') {
      await _incrementProgress('strength_warrior');
    }
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - HRI
  // ============================================================================

  /// Отслеживание HRI
  Future<void> trackHRI({
    required double hriValue,
    required String status,
  }) async {
    _loadDailyStats();

    // Track min/max HRI
    _minHRIToday = hriValue < _minHRIToday ? hriValue : _minHRIToday;
    _maxHRIToday = hriValue > _maxHRIToday ? hriValue : _maxHRIToday;

    // Perfect score (under 20)
    if (hriValue < 20) {
      await _checkAndUnlock('hri_perfect');
    }

    // Quick recovery (from red to green)
    if (_maxHRIToday > 60 && hriValue < 30) {
      await _checkAndUnlock('hri_recovery');
    }
  }

  /// Проверка HRI в конце дня
  Future<void> checkDailyHRIAchievements() async {
    _loadDailyStats();

    // Green zone achievements
    if (_maxHRIToday <= 30) {
      await _checkAndUnlock('hri_green');
      await _incrementProgress('hri_week_green');
      await _incrementProgress('hri_master');
    }
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - STREAKS - ✅ ИСПРАВЛЕНО
  // ============================================================================

  /// ✅ ФИКС: Обновление стриков только раз в день
  Future<void> _updateStreakIfNeeded() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Проверяем, обновляли ли стрик сегодня
    if (_lastStreakUpdateDate != null) {
      final lastUpdateDay = DateTime(
        _lastStreakUpdateDate!.year,
        _lastStreakUpdateDate!.month,
        _lastStreakUpdateDate!.day,
      );

      // Если уже обновляли сегодня - не обновляем повторно
      if (today.isAtSameMomentAs(lastUpdateDay)) {
        return;
      }
    }

    // Проверяем, не пропустили ли вчера
    if (_lastStreakUpdateDate != null) {
      final daysSinceLastUpdate = _daysBetween(_lastStreakUpdateDate!, now);

      if (daysSinceLastUpdate > 1) {
        // Пропустили дни - сбрасываем стрик
        _currentStreak = 1; // Сегодня первый день нового стрика
      } else if (daysSinceLastUpdate == 1) {
        // Вчера тоже использовали - продолжаем стрик
        _currentStreak++;
      }
      // daysSinceLastUpdate == 0 быть не может, т.к. мы уже проверили выше
    } else {
      // Первый раз используем приложение
      _currentStreak = 1;
    }

    // Обновляем дату последнего обновления
    _lastStreakUpdateDate = now;

    // Сохраняем
    await _saveStreakData();

    // Обновляем достижения стриков
    await _updateProgress('streak_3', _currentStreak);
    await _updateProgress('streak_7', _currentStreak);
    await _updateProgress('streak_30', _currentStreak);
    await _updateProgress('streak_100', _currentStreak);
  }

  // ============================================================================
  // ОТСЛЕЖИВАНИЕ СОБЫТИЙ - SPECIAL
  // ============================================================================

  /// Отслеживание дней использования
  Future<void> trackDayUsage() async {
    await _incrementProgress('first_week');
  }

  /// Отслеживание PRO подписки
  Future<void> trackProSubscription(bool isPro) async {
    if (isPro) {
      await _checkAndUnlock('pro_member');
    }
  }

  /// Отслеживание экспорта данных
  Future<void> trackDataExport() async {
    await _checkAndUnlock('data_export');

    // Analytics
    await _analytics.logCSVExported();
  }

  /// Проверка мета-достижений
  Future<void> checkMetaAchievements() async {
    // All categories achievement
    final achievements = _repository.getAllAchievements();
    final unlockedCategories = <AchievementCategory>{};

    for (final achievement in achievements) {
      if (achievement.isUnlocked &&
          achievement.category != AchievementCategory.special) {
        unlockedCategories.add(achievement.category);
      }
    }

    await _updateProgress('all_categories', unlockedCategories.length);

    // Achievement hunter (50% of all)
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    await _updateProgress('achievement_hunter', unlockedCount);
  }

  // ============================================================================
  // ✅ ИСПРАВЛЕННЫЕ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ============================================================================

  /// ✅ ИСПРАВЛЕНО: Проверить и разблокировать достижение
  Future<void> _checkAndUnlock(String achievementId) async {
    final unlocked = await _repository.updateProgress(achievementId, 1);
    if (unlocked != null) {
      _onAchievementUnlocked(unlocked);
    }
  }

  /// ✅ ИСПРАВЛЕНО: Увеличить прогресс на 1
  Future<void> _incrementProgress(String achievementId) async {
    final unlocked = await _repository.incrementProgress(achievementId);
    if (unlocked != null) {
      _onAchievementUnlocked(unlocked);
    }
  }

  /// ✅ ИСПРАВЛЕНО: Обновить прогресс до определенного значения
  /// ВАЖНО: Этот метод теперь корректно работает с локализованными максимальными значениями
  Future<void> _updateProgress(String achievementId, int progress) async {
    final unlocked = await _repository.updateProgress(achievementId, progress);
    if (unlocked != null) {
      _onAchievementUnlocked(unlocked);
    }
  }

  /// Обработка разблокировки достижения
  void _onAchievementUnlocked(Achievement achievement) {
    // Добавляем в очередь для показа
    _unlockedQueue.add(achievement);

    // Удаляем категорию из просмотренных, если там появилось новое достижение
    _viewedCategories.remove(achievement.category);

    // Тактильная обратная связь
    HapticFeedback.mediumImpact();

    // Логируем в аналитику
    _analytics.logEvent(
      name: 'achievement_unlocked',
      parameters: {
        'achievement_id': achievement.id,
        'achievement_name': achievement.name,
        'category': achievement.category.name,
        'rarity': achievement.rarity.name,
        'reward_points': achievement.rewardPoints,
      },
    );

    // Проверяем мета-достижения
    checkMetaAchievements();

    // Уведомляем слушателей
    notifyListeners();
  }

  /// Удалить достижение из очереди показа
  void removeFromQueue(Achievement achievement) {
    _unlockedQueue.remove(achievement);
    notifyListeners();
  }

  /// Проверка одинаковый ли день
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // ============================================================================
  // ПУБЛИЧНЫЕ МЕТОДЫ ДЛЯ UI
  // ============================================================================

  /// Получить все достижения
  List<Achievement> getAllAchievements() {
    return _repository.getAllAchievements();
  }

  /// Получить достижения по категории
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return _repository.getAchievementsByCategory(category);
  }

  /// Получить разблокированные достижения
  List<Achievement> getUnlockedAchievements() {
    return _repository.getUnlockedAchievements();
  }

  /// Получить достижения близкие к разблокировке
  List<Achievement> getNearlyUnlockedAchievements() {
    return _repository.getNearlyUnlockedAchievements();
  }

  /// Получить статистику
  Map<String, dynamic> getStatistics() {
    return _repository.getStatistics();
  }

  /// Синхронизация при логине
  Future<void> syncWithFirestore() async {
    await _repository.syncWithFirestore();
  }
}
