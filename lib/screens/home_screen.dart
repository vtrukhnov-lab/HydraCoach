import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

// === App imports ===
import '../services/hri_service.dart';
import '../services/weather_service.dart';
import '../services/subscription_service.dart';
import '../services/alcohol_service.dart';
import '../widgets/alcohol_checkin_dialog.dart';
import 'paywall_screen.dart';
import '../main.dart';

// ============================================================================
// HOME SCREEN
// ============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDailyReport = false;

  @override
  void initState() {
    super.initState();
    _checkDailyReport();
    _checkMorningCheckin();
    _updateHRI();

    // Применяем алкогольные корректировки после первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      final alcohol = Provider.of<AlcoholService>(context, listen: false);
      provider.updateAlcoholAdjustments(
        alcohol.totalWaterCorrection,
        alcohol.totalSodiumCorrection.round(),
      );
    });

    // Подписка на изменения алкоголя
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    alcohol.addListener(_onAlcoholServiceChanged);
  }

  @override
  void dispose() {
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    alcohol.removeListener(_onAlcoholServiceChanged);
    super.dispose();
  }

  void _onAlcoholServiceChanged() {
    if (!mounted) return;
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    provider.updateAlcoholAdjustments(
      alcohol.totalWaterCorrection,
      alcohol.totalSodiumCorrection.round(),
    );
    _updateHRI();
  }

  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= 21) {
      setState(() => _showDailyReport = true);
    }
  }

  void _checkMorningCheckin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Временно показываем всегда для тестирования
      // TODO: Добавить проверку на алкоголь вчера когда метод будет реализован
      AlcoholCheckinDialog.show(context);
    }
  }

  void _updateHRI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = Provider.of<HydrationProvider>(context, listen: false);
      final hri = Provider.of<HRIService>(context, listen: false);
      final alcohol = Provider.of<AlcoholService>(context, listen: false);
      final weather = Provider.of<WeatherService>(context, listen: false);

      int activity = provider.activityLevel == 'low' 
          ? 0 
          : provider.activityLevel == 'high' 
              ? 2 
              : 1;

      DateTime? lastIntakeTime;
      if (provider.todayIntakes.isNotEmpty) {
        lastIntakeTime = provider.todayIntakes.last.timestamp;
      }

      hri.calculateHRI(
        waterIntake: provider.totalWaterToday,
        waterGoal: provider.goals.waterOpt.toDouble(),
        sodiumIntake: provider.totalSodiumToday.toDouble(),
        sodiumGoal: provider.goals.sodium.toDouble(),
        heatIndex: weather.heatIndex,
        activityLevel: activity,
        coffeeCups: provider.coffeeCupsToday,
        alcoholSD: alcohol.totalStandardDrinks,
        lastIntakeTime: lastIntakeTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);
    final alcohol = Provider.of<AlcoholService>(context);
    final hri = Provider.of<HRIService>(context);
    final weather = Provider.of<WeatherService>(context);

    final progress = provider.getProgress();
    final status = provider.getHydrationStatus();
    final hriValue = hri.currentHRI.round();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'HydraCoach',
                                  style: TextStyle(
                                    fontSize: 32, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ).animate().fadeIn(duration: 350.ms),
                                if (sub.isPro) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8, 
                                      vertical: 4
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.shade400, 
                                          Colors.amber.shade600
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.grey[600]
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!sub.isPro)
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade400, 
                                        Colors.purple.shade600
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star, 
                                    color: Colors.white, 
                                    size: 20
                                  ),
                                ),
                                onPressed: () => _showPaywall(context),
                                tooltip: 'Получить PRO',
                              ),
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () => Navigator.pushNamed(context, '/history'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () => Navigator.pushNamed(context, '/settings'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Compact Weather Card
                SliverToBoxAdapter(
                  child: _buildCompactWeatherCard(weather),
                ),

                // Main Progress Card
                SliverToBoxAdapter(
                  child: _buildMainProgressCard(provider, progress, alcohol),
                ),

                // Smart Advice Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSmartAdviceCard(
                      provider: provider,
                      alcoholService: alcohol,
                      hriService: hri,
                      weatherService: weather,
                    ),
                  ).animate().fadeIn(delay: 450.ms),
                ),

                // HRI Status Card
                SliverToBoxAdapter(
                  child: _buildHRICard(hri, hriValue, status, alcohol),
                ),

                // Quick Add Section
                SliverToBoxAdapter(
                  child: _buildQuickAddSection(provider, alcohol, hri, weather),
                ),

                // Today's History
                if (provider.todayIntakes.isNotEmpty || alcohol.todayIntakes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildTodayHistory(provider, alcohol),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // Daily Report Floating Card
            if (_showDailyReport)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildDailyReportFloatingCard(),
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // UI COMPONENTS
  // =========================================================================

  Widget _buildCompactWeatherCard(WeatherService weather) {
    final weatherData = weather.currentWeather;
    final heatIndex = weather.heatIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Первая строка - температура и город
          Row(
            children: [
              Icon(Icons.thermostat, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherData != null 
                        ? '${weatherData.temperature.round()}°C'
                        : '--°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weatherData?.city ?? 'Загрузка...',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (heatIndex != null) 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Heat Index',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${heatIndex.round()}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (heatIndex >= 32) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.warning,
                        color: Colors.yellow,
                        size: 24,
                      ),
                    ],
                  ],
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Вторая строка - описание погоды и предупреждение
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (weatherData != null) ...[
                  Text(
                    weatherData.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getWeatherIcon(heatIndex),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        weatherData?.getHeatWarning() ?? 'Загрузка погоды...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (weatherData != null && weatherData.humidity > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Влажность: ${weatherData.humidity.round()}%',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(double? heatIndex) {
    if (heatIndex == null) return Icons.cloud;
    if (heatIndex < 27) return Icons.check_circle;
    if (heatIndex < 32) return Icons.wb_sunny;
    if (heatIndex < 39) return Icons.local_fire_department;
    return Icons.warning;
  }

  Widget _buildMainProgressCard(
    HydrationProvider provider,
    Map<String, double> progress,
    AlcoholService alcohol,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Water Ring
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: (progress['waterPercent'] ?? 0) / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(progress['waterPercent'] ?? 0).toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Text(
                        'Вода',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '${(progress['water'] ?? 0).toInt()} мл',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().scale(delay: 100.ms),

          const SizedBox(height: 20),

          // Electrolyte Bars
          _buildElectrolyteBar(
            'Натрий',
            progress['sodiumPercent'] ?? 0,
            (progress['sodium'] ?? 0).toInt(),
            provider.goals.sodium,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildElectrolyteBar(
            'Калий',
            progress['potassiumPercent'] ?? 0,
            (progress['potassium'] ?? 0).toInt(),
            provider.goals.potassium,
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildElectrolyteBar(
            'Магний',
            progress['magnesiumPercent'] ?? 0,
            (progress['magnesium'] ?? 0).toInt(),
            provider.goals.magnesium,
            Colors.pink,
          ),

          // Adjustment Chips
          if (provider.weatherWaterAdjustment > 0 || alcohol.totalStandardDrinks > 0) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (provider.weatherWaterAdjustment > 0)
                  _buildChip(
                    icon: Icons.wb_sunny,
                    label: 'Жара +${(provider.weatherWaterAdjustment * 100).toInt()}%',
                    color: Colors.orange,
                  ),
                if (alcohol.totalStandardDrinks > 0)
                  _buildChip(
                    icon: Icons.local_bar,
                    label: 'Алкоголь +${alcohol.totalWaterCorrection.toInt()} мл',
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmartAdviceCard({
    required HydrationProvider provider,
    required AlcoholService alcoholService,
    required HRIService hriService,
    required WeatherService weatherService,
  }) {
    final waterRatio = provider.goals.waterOpt > 0 
        ? provider.totalWaterToday / provider.goals.waterOpt 
        : 0.0;
    final sodiumRatio = provider.goals.sodium > 0 
        ? provider.totalSodiumToday / provider.goals.sodium 
        : 0.0;

    final hasAlcohol = alcoholService.totalStandardDrinks > 0;
    final hi = weatherService.heatIndex ?? 0;

    final waterNeed = math.max(0, provider.goals.waterOpt - provider.totalWaterToday);
    final sodiumNeed = math.max(0, provider.goals.sodium - provider.totalSodiumToday);

    String title = 'Подсказка на сейчас';
    String body = 'Поддерживайте баланс воды и электролитов.';
    Color tone = Colors.blue.shade50;
    Color border = Colors.blue.shade300;
    IconData icon = Icons.tips_and_updates;

    if (waterRatio > 2.0) {
      title = 'Перепивание воды (>200% цели)';
      body = 'Сделайте паузу 60–90 минут. Добавьте электролиты: 300–500 мл с 500–1000 мг натрия.';
      tone = const Color(0xFFFFEBEE);
      border = Colors.red.shade300;
      icon = Icons.error_outline;
    } else if (waterRatio > 1.2) {
      title = 'Перепивание воды';
      body = 'Приостановите воду на 30–60 минут и добавьте ~500 мг натрия (электролит/бульон).';
      tone = Colors.orange.shade50;
      border = Colors.orange.shade300;
      icon = Icons.warning_amber_outlined;
    } else if (hasAlcohol) {
      title = 'Алкоголь: восстановление';
      body = 'Не пейте больше алкоголя сегодня. Пейте малыми порциями 300–500 мл воды и добавьте натрий.';
      tone = Colors.orange.shade50;
      border = Colors.orange.shade300;
      icon = Icons.local_bar;
    } else if (sodiumRatio < 0.7) {
      title = 'Мало натрия';
      body = 'Добавьте ~${_clampInt(sodiumNeed, 300, 1000)} мг натрия. Пейте умеренно.';
      tone = Colors.amber.shade50;
      border = Colors.amber.shade300;
      icon = Icons.science_outlined;
    } else if (waterRatio < 0.5) {
      title = 'Недобор воды';
      body = 'Выпейте 300–500 мл ${hi >= 32 ? "электролита" : "воды"}.';
      tone = Colors.blue.shade50;
      border = Colors.blue.shade300;
      icon = Icons.local_drink_outlined;
    } else if (hriService.currentHRI >= 60) {
      title = 'Высокий риск (HRI)';
      body = 'Срочно выпейте воду с электролитами (300–500 мл) и снизьте нагрузку.';
      tone = const Color(0xFFFFF3E0);
      border = Colors.deepOrange.shade300;
      icon = Icons.priority_high_rounded;
    } else if (hi >= 32) {
      title = 'Жара и потери';
      body = 'Увеличьте воду на +5–8% и добавьте 300–500 мг натрия.';
      tone = const Color(0xFFFFF8E1);
      border = Colors.orange.shade300;
      icon = Icons.wb_sunny_outlined;
    } else {
      title = 'Всё по плану';
      body = 'Держите ритм. Ориентир: ещё ~${_clampInt(waterNeed, 200, 800)} мл до цели.';
      tone = Colors.green.shade50;
      border = Colors.green.shade300;
      icon = Icons.check_circle_outline;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: border),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: border,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHRICard(HRIService hri, int hriValue, String status, AlcoholService alcohol) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Статус гидратации',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Hydration Risk Index'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getHRIColor(hriValue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hri.hriZone.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getHRIColor(hriValue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hriValue / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(_getHRIColor(hriValue)),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$hriValue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getHRIColor(hriValue),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                hri.hriStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getHRIColor(hriValue),
                ),
              ),
              if (alcohol.totalStandardDrinks > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '(+${(alcohol.totalStandardDrinks * 5).round()} от алкоголя)',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade600),
                ),
              ],
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildQuickAddSection(
    HydrationProvider provider,
    AlcoholService alcohol,
    HRIService hri,
    WeatherService weather,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Быстрое добавление',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildQuickButton(
                context,
                '💧',
                'Вода',
                '200 мл',
                Colors.blue,
                () {
                  provider.addIntake('water', 200);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              _buildQuickButton(
                context,
                '💧',
                'Вода',
                '300 мл',
                Colors.blue,
                () {
                  provider.addIntake('water', 300);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              _buildQuickButton(
                context,
                '💧',
                'Вода',
                '500 мл',
                Colors.blue,
                () {
                  provider.addIntake('water', 500);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              _buildQuickButton(
                context,
                '⚡',
                'Электролит',
                '300 мл',
                Colors.orange,
                () {
                  provider.addIntake('electrolyte', 300,
                      sodium: 500, potassium: 200, magnesium: 50);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              _buildQuickButton(
                context,
                '🍲',
                'Бульон',
                '250 мл',
                Colors.amber,
                () {
                  provider.addIntake('broth', 250, sodium: 800, potassium: 100);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              _buildQuickButton(
                context,
                '☕',
                'Кофе',
                '200 мл',
                Colors.brown,
                () {
                  provider.addIntake('coffee', 200);
                  _recalcAfterChange(provider, hri, alcohol, weather);
                },
              ),
              if (!alcohol.soberModeEnabled)
                _buildQuickButton(
                  context,
                  '🍺',
                  'Алкоголь',
                  'Добавить',
                  Colors.orange.shade600,
                  () async {
                    final result = await Navigator.pushNamed(context, '/alcohol');
                    if (result == true && mounted) setState(() {});
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayHistory(HydrationProvider provider, AlcoholService alcohol) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Сегодня выпито',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: const Text('Все записи →'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: _getCombinedIntakes(provider, alcohol),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportFloatingCard() {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const DailyReportCard(),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Дневной отчёт готов!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Посмотрите результаты дня',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 1, end: 0),
    );
  }

  // =========================================================================
  // HELPER WIDGETS & METHODS
  // =========================================================================

  Widget _buildElectrolyteBar(
    String name,
    double percent,
    int current,
    int goal,
    Color color,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (percent / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 20,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${percent.toInt()}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: percent > 50 ? Colors.white : color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$current/$goal мг',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String icon,
    String label,
    String volume,
    Color color,
    VoidCallback onPress,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  volume,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms)
        .fadeIn(duration: 300.ms, delay: 100.ms);
  }

  List<Widget> _getCombinedIntakes(HydrationProvider provider, AlcoholService alcohol) {
    final List<MapEntry<DateTime, Widget>> all = [];

    for (var intake in provider.todayIntakes) {
      all.add(MapEntry(intake.timestamp, _buildIntakeItem(intake, provider)));
    }
    for (var intake in alcohol.todayIntakes) {
      all.add(MapEntry(intake.timestamp, _buildAlcoholItem(intake, alcohol)));
    }

    all.sort((a, b) => b.key.compareTo(a.key));
    return all.take(10).map((e) => e.value).toList();
  }

  Widget _buildIntakeItem(Intake intake, HydrationProvider provider) {
    String typeIcon = '';
    String typeName = '';

    switch (intake.type) {
      case 'water':
        typeIcon = '💧';
        typeName = 'Вода';
        break;
      case 'electrolyte':
        typeIcon = '⚡';
        typeName = 'Электролит';
        break;
      case 'broth':
        typeIcon = '🍲';
        typeName = 'Бульон';
        break;
      case 'coffee':
        typeIcon = '☕';
        typeName = 'Кофе';
        break;
    }

    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(color: Colors.red),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        provider.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$typeName удалён'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                provider.addIntake(
                  intake.type,
                  intake.volume,
                  sodium: intake.sodium,
                  potassium: intake.potassium,
                  magnesium: intake.magnesium,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Text(
              '${intake.timestamp.hour.toString().padLeft(2, '0')}:'
              '${intake.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Text('$typeIcon $typeName'),
            const Spacer(),
            Text(
              '${intake.volume} мл',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcoholItem(dynamic intake, AlcoholService alcohol) {
    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(color: Colors.red),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        alcohol.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${intake.type.label} удалён'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () => alcohol.addIntake(intake),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border(bottom: BorderSide(color: Colors.orange.shade200)),
        ),
        child: Row(
          children: [
            Text(
              intake.formattedTime,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(intake.type.icon, color: Colors.orange.shade600, size: 20),
            const SizedBox(width: 8),
            Text(intake.type.label),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${intake.volumeMl.toInt()} мл, ${intake.abv}%',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  intake.formattedSD,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // UTILITY METHODS
  // =========================================================================

  void _recalcAfterChange(
    HydrationProvider provider,
    HRIService hri,
    AlcoholService alcohol,
    WeatherService weather,
  ) {
    hri.calculateHRI(
      waterIntake: provider.totalWaterToday,
      waterGoal: provider.goals.waterOpt.toDouble(),
      sodiumIntake: provider.totalSodiumToday.toDouble(),
      sodiumGoal: provider.goals.sodium.toDouble(),
      heatIndex: weather.heatIndex,
      activityLevel: provider.activityLevel == 'low'
          ? 0
          : provider.activityLevel == 'high'
              ? 2
              : 1,
      coffeeCups: provider.coffeeCupsToday,
      alcoholSD: alcohol.totalStandardDrinks,
      lastIntakeTime: DateTime.now(),
    );
  }

  void _showPaywall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Норма':
        return Colors.green;
      case 'Мало соли':
      case 'Разбавляешь':
        return Colors.orange;
      case 'Недобор воды':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    const weekDays = [
      'Воскресенье', 'Понедельник', 'Вторник', 'Среда', 
      'Четверг', 'Пятница', 'Суббота'
    ];
    return '${weekDays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }

  static int _clampInt(num v, int minV, int maxV) =>
      v.isFinite ? v.clamp(minV, maxV).toInt() : minV;
}

// ============================================================================
// DAILY REPORT CARD
// ============================================================================
class DailyReportCard extends StatelessWidget {
  const DailyReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Дневной отчёт',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text('Здесь будет детальный отчёт дня.'),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}