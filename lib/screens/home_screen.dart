import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

// === App imports ===
import '../services/hri_service.dart';
import '../services/weather_service.dart';
import '../services/subscription_service.dart';
import '../services/alcohol_service.dart';
import 'paywall_screen.dart';
import '../main.dart';
import '../widgets/quick_add_widget.dart';

// ============================================================================
// HOME SCREEN
// ============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Constants
  static const double kProgressRingSize = 140.0;
  static const double kProgressStrokeWidth = 12.0;
  static const double kCardRadius = 20.0;
  static const double kCardPadding = 20.0;
  static const double kSectionSpacing = 20.0;
  static const int kEveningReportHour = 21;
  static const int kMaxHistoryItems = 10;

  bool _showDailyReport = false;

  @override
  void initState() {
    super.initState();
    _checkDailyReport();
    _checkMorningCheckin();

    // Применяем алкогольные корректировки после первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyAlcoholAdjustments();
      _updateHRI();
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
    _applyAlcoholAdjustments();
    _updateHRI();
  }

  void _applyAlcoholAdjustments() {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    provider.updateAlcoholAdjustments(
      alcohol.totalWaterCorrection,
      alcohol.totalSodiumCorrection.round(),
    );
  }

  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= kEveningReportHour) {
      setState(() => _showDailyReport = true);
    }
  }

  void _checkMorningCheckin() async {
    // TODO: Реализовать проверку алкоголя вчера
    // final alcohol = Provider.of<AlcoholService>(context, listen: false);
    // if (alcohol.hadAlcoholYesterday()) {
    //   await Future.delayed(const Duration(seconds: 2));
    //   if (mounted) {
    //     AlcoholCheckinDialog.show(context);
    //   }
    // }
  }

  void _updateHRI() {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = Provider.of<HydrationProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);
    final alcohol = Provider.of<AlcoholService>(context);
    final hri = Provider.of<HRIService>(context);
    final weather = Provider.of<WeatherService>(context);

    final progress = provider.getProgress();
    final status = provider.getHydrationStatus(l10n);
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
                    padding: const EdgeInsets.all(kCardPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  l10n.appTitle,
                                  style: const TextStyle(
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
                              _getFormattedDate(l10n),
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
                                tooltip: l10n.getPro,
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
                  child: _buildCompactWeatherCard(weather, l10n),
                ),

                // Main Progress Card
                SliverToBoxAdapter(
                  child: _buildMainProgressCard(provider, progress, alcohol, l10n),
                ),

                // Smart Advice Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kCardPadding),
                    child: _buildSmartAdviceCard(
                      provider: provider,
                      alcoholService: alcohol,
                      hriService: hri,
                      weatherService: weather,
                      l10n: l10n,
                    ),
                  ).animate().fadeIn(delay: 450.ms),
                ),

                // HRI Status Card
                SliverToBoxAdapter(
                  child: _buildHRICard(hri, hriValue, status, l10n),
                ),

                // Quick Add Section - ИСПОЛЬЗУЕМ НОВЫЙ ВИДЖЕТ
                SliverToBoxAdapter(
                  child: _buildQuickAddSection(provider, alcohol, l10n),
                ),

                // Today's History
                if (provider.todayIntakes.isNotEmpty || alcohol.todayIntakes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildTodayHistory(provider, alcohol, l10n),
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
                child: _buildDailyReportFloatingCard(l10n),
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // UI COMPONENTS
  // =========================================================================

  Widget _buildCompactWeatherCard(WeatherService weather, AppLocalizations l10n) {
    final weatherData = weather.currentWeather;
    final heatIndex = weather.heatIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 8),
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
              const Icon(Icons.thermostat, color: Colors.white, size: 32),
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
                    weatherData?.city ?? l10n.loading,
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
                          Text(
                            l10n.heatIndex,
                            style: const TextStyle(
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
                      const Icon(
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
                    weatherData.getLocalizedDescription(context),
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
                        weatherData != null 
                            ? weatherData.getLocalizedHeatWarning(context)
                            : l10n.loadingWeather,
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
                    l10n.humidity(weatherData.humidity.round()),
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
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 10),
      padding: const EdgeInsets.all(kCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
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
              width: kProgressRingSize,
              height: kProgressRingSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: kProgressRingSize,
                    height: kProgressRingSize,
                    child: CircularProgressIndicator(
                      value: (progress['waterPercent'] ?? 0) / 100,
                      strokeWidth: kProgressStrokeWidth,
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
                      Text(
                        l10n.water,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        l10n.valueWithUnit(
                          (progress['water'] ?? 0).toInt(),
                          l10n.ml,
                        ),
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
            l10n.sodium,
            progress['sodiumPercent'] ?? 0,
            (progress['sodium'] ?? 0).toInt(),
            provider.goals.sodium,
            Colors.orange,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildElectrolyteBar(
            l10n.potassium,
            progress['potassiumPercent'] ?? 0,
            (progress['potassium'] ?? 0).toInt(),
            provider.goals.potassium,
            Colors.purple,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildElectrolyteBar(
            l10n.magnesium,
            progress['magnesiumPercent'] ?? 0,
            (progress['magnesium'] ?? 0).toInt(),
            provider.goals.magnesium,
            Colors.pink,
            l10n,
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
                    label: l10n.heatAdjustment((provider.weatherWaterAdjustment * 100).toInt()),
                    color: Colors.orange,
                  ),
                if (alcohol.totalStandardDrinks > 0)
                  _buildChip(
                    icon: Icons.local_bar,
                    label: l10n.alcoholAdjustment(alcohol.totalWaterCorrection.toInt()),
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
    required AppLocalizations l10n,
  }) {
    final waterRatio = provider.goals.waterOpt > 0 
        ? provider.totalWaterToday / provider.goals.waterOpt 
        : 0.0;
    final sodiumRatio = provider.goals.sodium > 0 
        ? provider.totalSodiumToday / provider.goals.sodium 
        : 0.0;

    final hasAlcohol = alcoholService.totalStandardDrinks > 0;
    final hi = weatherService.heatIndex ?? 0;

    final waterNeed = (provider.goals.waterOpt - provider.totalWaterToday).clamp(0, double.infinity);
    final sodiumNeed = (provider.goals.sodium - provider.totalSodiumToday).clamp(0, double.infinity);

    String title = l10n.smartAdviceTitle;
    String body = l10n.smartAdviceDefault;
    Color tone = Colors.blue.shade50;
    Color border = Colors.blue.shade300;
    IconData icon = Icons.tips_and_updates;

    if (waterRatio > 2.0) {
      title = l10n.adviceOverhydrationSevere;
      body = l10n.adviceOverhydrationSevereBody;
      tone = const Color(0xFFFFEBEE);
      border = Colors.red.shade300;
      icon = Icons.error_outline;
    } else if (waterRatio > 1.2) {
      title = l10n.adviceOverhydration;
      body = l10n.adviceOverhydrationBody;
      tone = Colors.orange.shade50;
      border = Colors.orange.shade300;
      icon = Icons.warning_amber_outlined;
    } else if (hasAlcohol) {
      title = l10n.adviceAlcoholRecovery;
      body = l10n.adviceAlcoholRecoveryBody;
      tone = Colors.orange.shade50;
      border = Colors.orange.shade300;
      icon = Icons.local_bar;
    } else if (sodiumRatio < 0.7) {
      title = l10n.adviceLowSodium;
      body = l10n.adviceLowSodiumBody(sodiumNeed.clamp(300, 1000).toInt());
      tone = Colors.amber.shade50;
      border = Colors.amber.shade300;
      icon = Icons.science_outlined;
    } else if (waterRatio < 0.5) {
      title = l10n.adviceDehydration;
      final drinkType = hi >= 32 ? l10n.electrolyte.toLowerCase() : l10n.water.toLowerCase();
      body = l10n.adviceDehydrationBody(drinkType);
      tone = Colors.blue.shade50;
      border = Colors.blue.shade300;
      icon = Icons.local_drink_outlined;
    } else if (hriService.currentHRI >= 60) {
      title = l10n.adviceHighRisk;
      body = l10n.adviceHighRiskBody;
      tone = const Color(0xFFFFF3E0);
      border = Colors.deepOrange.shade300;
      icon = Icons.priority_high_rounded;
    } else if (hi >= 32) {
      title = l10n.adviceHeat;
      body = l10n.adviceHeatBody;
      tone = const Color(0xFFFFF8E1);
      border = Colors.orange.shade300;
      icon = Icons.wb_sunny_outlined;
    } else {
      title = l10n.adviceAllGood;
      body = l10n.adviceAllGoodBody(waterNeed.clamp(200, 800).toInt());
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

  Widget _buildHRICard(HRIService hri, int hriValue, String status, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 10),
      padding: const EdgeInsets.all(kCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
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
              Text(
                l10n.hydrationStatus,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
              Text(l10n.hydrationRiskIndex),
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
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  // ИСПРАВЛЕННЫЙ МЕТОД - ИСПОЛЬЗУЕМ QuickAddWidget
  Widget _buildQuickAddSection(
    HydrationProvider provider,
    AlcoholService alcohol,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(kCardPadding),
      child: QuickAddWidget(
        provider: provider,
        onUpdate: () {
          setState(() {});
          _updateHRI();
        },
      ),
    );
  }

  Widget _buildTodayHistory(HydrationProvider provider, AlcoholService alcohol, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(kCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.todaysDrinks,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: Text(l10n.allRecords),
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
              children: _getCombinedIntakes(provider, alcohol, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportFloatingCard(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.dailyReportComingSoon),
          ),
        );
      },
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
        child: Row(
          children: [
            const Icon(Icons.analytics, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dailyReportReady,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.viewDayResults,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
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
    AppLocalizations l10n,
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
          l10n.goalFormat(current, goal, l10n.mg),
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

  List<Widget> _getCombinedIntakes(HydrationProvider provider, AlcoholService alcohol, AppLocalizations l10n) {
    final List<MapEntry<DateTime, Widget>> all = [];

    for (var intake in provider.todayIntakes) {
      all.add(MapEntry(intake.timestamp, _buildIntakeItem(intake, provider, l10n)));
    }
    for (var intake in alcohol.todayIntakes) {
      all.add(MapEntry(intake.timestamp, _buildAlcoholItem(intake, alcohol, l10n)));
    }

    all.sort((a, b) => b.key.compareTo(a.key));
    return all.take(kMaxHistoryItems).map((e) => e.value).toList();
  }

  Widget _buildIntakeItem(Intake intake, HydrationProvider provider, AppLocalizations l10n) {
    String typeIcon = '';
    String typeName = '';

    switch (intake.type) {
      case 'water':
        typeIcon = '💧';
        typeName = l10n.water;
        break;
      case 'electrolyte':
        typeIcon = '⚡';
        typeName = l10n.electrolyte;
        break;
      case 'broth':
        typeIcon = '🍲';
        typeName = l10n.broth;
        break;
      case 'coffee':
        typeIcon = '☕';
        typeName = l10n.coffee;
        break;
      case 'tea':
        typeIcon = '🍵';
        typeName = l10n.tea;
        break;
      case 'supplement':
        typeIcon = '💊';
        typeName = l10n.supplements;
        break;
      default:
        typeIcon = '🥤';
        typeName = intake.type;
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
            content: Text(l10n.itemDeleted(typeName)),
            action: SnackBarAction(
              label: l10n.undo,
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
              l10n.valueWithUnit(intake.volume, l10n.ml),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlcoholItem(dynamic intake, AlcoholService alcohol, AppLocalizations l10n) {
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
            content: Text(l10n.itemDeleted(intake.type.getLabel(context))),
            action: SnackBarAction(
              label: l10n.undo,
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
            Text(intake.type.getLabel(context)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${intake.volumeMl.toInt()} ${l10n.ml}, ${intake.abv}%',
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

  void _showPaywall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  String _getLocalizedStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'Норма':
        return l10n.hydrationStatusNormal;
      case 'Мало соли':
        return l10n.hydrationStatusLowSalt;
      case 'Разбавляешь':
        return l10n.hydrationStatusDiluted;
      case 'Недобор воды':
        return l10n.hydrationStatusDehydrated;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    if (status.contains('Normal') || status.contains('Норма')) return Colors.green;
    if (status.contains('Low salt') || status.contains('Мало соли') || 
        status.contains('Diluting') || status.contains('Разбавляешь')) {
      return Colors.orange;
    }
    if (status.contains('Under-hydrated') || status.contains('Недобор воды')) return Colors.red;
    return Colors.grey;
  }

  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }

  String _getFormattedDate(AppLocalizations l10n) {
    final now = DateTime.now();
    
    final weekDays = [
      l10n.sunday,
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
    ];
    
    final months = [
      l10n.january,
      l10n.february,
      l10n.march,
      l10n.april,
      l10n.may,
      l10n.june,
      l10n.july,
      l10n.august,
      l10n.september,
      l10n.october,
      l10n.november,
      l10n.december,
    ];
    
    return l10n.dateFormat(
      weekDays[now.weekday % 7],
      now.day,
      months[now.month - 1],
    );
  }
}