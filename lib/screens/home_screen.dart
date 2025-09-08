// lib/screens/home_screen.dart
// 
// Main home screen - Complete rewrite with all fixes
// Shows hydration status, HRI, active factors, and daily progress

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Localization
import '../l10n/app_localizations.dart';

// Services
import '../services/hri_service.dart';
import '../services/weather_service.dart';
import '../services/subscription_service.dart';
import '../services/alcohol_service.dart';

// Providers
import '../providers/hydration_provider.dart';

// Models
import '../models/intake.dart';

// Screens
import 'paywall_screen.dart';

// Widgets
import '../widgets/quick_add_widget.dart';
import '../widgets/ion_character.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // ============================================================================
  // CONSTANTS
  // ============================================================================
  
  static const double kCardRadius = 20.0;
  static const double kCardPadding = 20.0;
  static const double kProgressRingSize = 140.0;
  static const double kProgressStrokeWidth = 12.0;
  static const int kEveningReportHour = 21;
  static const int kMaxHistoryItems = 10;

  // ============================================================================
  // STATE
  // ============================================================================
  
  bool _showDailyReport = false;
  String _fastingSchedule = '16:8';
  Key _quickAddKey = UniqueKey();
  bool _isInitialized = false;

  // ============================================================================
  // LIFECYCLE
  // ============================================================================
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    alcohol.removeListener(_onAlcoholChanged);
    final weather = Provider.of<WeatherService>(context, listen: false);
    weather.removeListener(_onWeatherChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Empty - no extra updates needed here
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshQuickAdd();
      _updateHRI();
    }
  }

  // ============================================================================
  // INITIALIZATION
  // ============================================================================
  
  Future<void> _initialize() async {
    // Load user preferences
    await _loadPreferences();
    
    // Check if we should show daily report
    _checkDailyReport();
    
    // Setup listeners
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    alcohol.addListener(_onAlcoholChanged);

    // Listen for weather updates to recalc HRI immediately when data arrives
    final weather = Provider.of<WeatherService>(context, listen: false);
    weather.addListener(_onWeatherChanged);
    // Ensure a fetch is in flight on startup (guarded in the service)
    await weather.loadWeather();
    
    // Initialize HRI after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyAlcoholAdjustments();
      _updateHRI();
      _checkMorningCheckin();
      setState(() => _isInitialized = true);
    });
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _fastingSchedule = prefs.getString('fastingSchedule') ?? '16:8';
      });
    }
  }

  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= kEveningReportHour) {
      setState(() => _showDailyReport = true);
    }
  }

  void _checkMorningCheckin() {
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    
    if (alcohol.totalStandardDrinks > 0 && DateTime.now().hour < 12) {
      // TODO: Show morning check-in dialog
      print('Morning check-in needed after alcohol');
    }
  }

  // ============================================================================
  // UPDATE METHODS
  // ============================================================================
  
  void _refreshQuickAdd() {
    if (mounted) {
      setState(() {
        _quickAddKey = UniqueKey();
      });
    }
  }

  void _onAlcoholChanged() {
    if (!mounted) return;
    _applyAlcoholAdjustments();
    _updateHRI();
  }

  void _onWeatherChanged() {
    if (!mounted) return;
    // Update HRI when weather data changes
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

  void _updateHRI() {
    if (!mounted) return;

    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final hri = Provider.of<HRIService>(context, listen: false);
    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    final weather = Provider.of<WeatherService>(context, listen: false);

    // Get last intake time
    DateTime? lastIntakeTime;
    if (provider.todayIntakes.isNotEmpty) {
      lastIntakeTime = provider.todayIntakes.last.timestamp;
    }

    // Check if fasting
    bool isFasting = _isCurrentlyFasting(provider);
    hri.setFastingStatus(isFasting);

    // Update HRI with all parameters
    hri.calculateHRI(
      waterIntake: provider.totalWaterToday,
      waterGoal: provider.goals.waterOpt.toDouble(),
      sodiumIntake: provider.totalSodiumToday.toDouble(),
      sodiumGoal: provider.goals.sodium.toDouble(),
      potassiumIntake: provider.totalPotassiumToday.toDouble(),
      potassiumGoal: provider.goals.potassium.toDouble(),
      magnesiumIntake: provider.totalMagnesiumToday.toDouble(),
      magnesiumGoal: provider.goals.magnesium.toDouble(),
      heatIndex: weather.heatIndex,
      coffeeCups: provider.coffeeCupsToday,
      alcoholSD: alcohol.totalStandardDrinks,
      lastIntakeTime: lastIntakeTime,
      userWeightKg: provider.weight,
    );
  }

  bool _isCurrentlyFasting(HydrationProvider provider) {
    if (provider.dietMode != 'fasting') return false;
    
    final hour = DateTime.now().hour;
    switch (_fastingSchedule) {
      case '16:8':
        return hour < 12 || hour >= 20;
      case 'OMAD':
        return hour < 18 || hour >= 19;
      case 'ADF':
        final dayOfYear = DateTime.now().difference(
          DateTime(DateTime.now().year, 1, 1)
        ).inDays;
        return dayOfYear % 2 == 0;
      default:
        return hour < 12 || hour >= 20;
    }
  }

  // ============================================================================
  // BUILD METHOD
  // ============================================================================
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = Provider.of<HydrationProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);
    final alcohol = Provider.of<AlcoholService>(context);
    final hri = Provider.of<HRIService>(context);
    final weather = Provider.of<WeatherService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(l10n, sub),
                ),

                // Weather Card
                SliverToBoxAdapter(
                  child: _buildWeatherCard(weather, l10n),
                ),

                // Main Progress Card
                SliverToBoxAdapter(
                  child: _buildMainProgressCard(provider, l10n),
                ),

                // Smart Advice Card with Ion
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kCardPadding),
                    child: _buildSmartAdviceCard(provider, alcohol, hri, weather, l10n),
                  ).animate().fadeIn(delay: 450.ms),
                ),

                // HRI Status Card
                SliverToBoxAdapter(
                  child: _buildHRIStatusCard(hri, provider, alcohol, weather, l10n),
                ),

                // Workouts Section
                if (hri.todayWorkouts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildWorkoutsSection(hri, l10n),
                  ),

                // Quick Add Section
                SliverToBoxAdapter(
                  child: _buildQuickAddSection(provider, l10n),
                ),

                // Today's History
                if (provider.todayIntakes.isNotEmpty || alcohol.todayIntakes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildTodayHistory(provider, alcohol, l10n),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),

            // Daily Report Overlay
            if (_showDailyReport)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildDailyReportCard(l10n),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS - HEADER
  // ============================================================================
  
  Widget _buildHeader(AppLocalizations l10n, SubscriptionProvider sub) {
    return Container(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 350.ms),
                  if (sub.isPro) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade400, Colors.amber.shade600],
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
                  color: Colors.grey[600],
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
                        colors: [Colors.purple.shade400, Colors.purple.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star, color: Colors.white, size: 20),
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
    );
  }

  // ============================================================================
  // UI BUILDERS - WEATHER
  // ============================================================================
  
  Widget _buildWeatherCard(WeatherService weather, AppLocalizations l10n) {
    final weatherData = weather.currentWeather;
    final heatIndex = weather.heatIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getWeatherGradient(heatIndex),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            _getWeatherIcon(heatIndex),
            color: Colors.white,
            size: 32,
          ),
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
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  // ============================================================================
  // UI BUILDERS - MAIN PROGRESS
  // ============================================================================
  
  Widget _buildMainProgressCard(HydrationProvider provider, AppLocalizations l10n) {
    final progress = provider.getProgress();
    
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
          _buildWaterRing(progress, l10n),
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
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildWaterRing(Map<String, double> progress, AppLocalizations l10n) {
    final waterPercent = progress['waterPercent'] ?? 0;
    final waterAmount = progress['water'] ?? 0;
    
    return Center(
      child: SizedBox(
        width: kProgressRingSize,
        height: kProgressRingSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress ring
            SizedBox(
              width: kProgressRingSize,
              height: kProgressRingSize,
              child: CircularProgressIndicator(
                value: (waterPercent / 100).clamp(0.0, 1.0),
                strokeWidth: kProgressStrokeWidth,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  _getWaterColor(waterPercent),
                ),
              ),
            ),
            // Center text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${waterPercent.toInt()}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getWaterColor(waterPercent),
                  ),
                ),
                Text(
                  l10n.water,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${waterAmount.toInt()} ${l10n.ml}',
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
    ).animate().scale(delay: 100.ms);
  }

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
          width: 100,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
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
          '$current/$goal ${l10n.mg}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // UI BUILDERS - SMART ADVICE WITH ION
  // ============================================================================
  
  Widget _buildSmartAdviceCard(
    HydrationProvider provider,
    AlcoholService alcoholService,
    HRIService hriService,
    WeatherService weatherService,
    AppLocalizations l10n,
  ) {
    final advice = _getSmartAdvice(provider, alcoholService, hriService, weatherService, l10n);
    
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: advice['tone'] as Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: advice['border'] as Color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ion персонаж - увеличенный размер
          SizedBox(
            width: 65,
            height: 65,
            child: IonCharacter(
              size: 55,
              mood: advice['ionMood'] as IonMood,
              showGlow: false,
              showElectrolytes: false,
              hydrationLevel: advice['ionHydrationLevel'] as HydrationLevel,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  advice['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: advice['border'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advice['body'] as String,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSmartAdvice(
    HydrationProvider provider,
    AlcoholService alcoholService,
    HRIService hriService,
    WeatherService weatherService,
    AppLocalizations l10n,
  ) {
    final waterRatio = provider.goals.waterOpt > 0 
        ? provider.totalWaterToday / provider.goals.waterOpt 
        : 0.0;
    final sodiumRatio = provider.goals.sodium > 0 
        ? provider.totalSodiumToday / provider.goals.sodium 
        : 0.0;

    // Critical overhydration
    if (waterRatio > 2.0) {
      return {
        'title': l10n.adviceOverhydrationSevere,
        'body': l10n.adviceOverhydrationSevereBody,
        'tone': const Color(0xFFFFEBEE),
        'border': Colors.red.shade300,
        'icon': Icons.error_outline,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.high,
      };
    }

    // Mild overhydration
    if (waterRatio > 1.2) {
      return {
        'title': l10n.adviceOverhydration,
        'body': l10n.adviceOverhydrationBody,
        'tone': Colors.orange.shade50,
        'border': Colors.orange.shade300,
        'icon': Icons.warning_amber_outlined,
        'ionMood': IonMood.thinking,
        'ionHydrationLevel': HydrationLevel.high,
      };
    }

    // Alcohol recovery needed
    if (alcoholService.totalStandardDrinks > 0) {
      return {
        'title': l10n.adviceAlcoholRecovery,
        'body': l10n.adviceAlcoholRecoveryBody,
        'tone': Colors.orange.shade50,
        'border': Colors.orange.shade300,
        'icon': Icons.local_bar,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    // Low sodium
    if (sodiumRatio < 0.7) {
      final sodiumNeed = (provider.goals.sodium - provider.totalSodiumToday)
          .clamp(300, 1000);
      return {
        'title': l10n.adviceLowSodium,
        'body': l10n.adviceLowSodiumBody(sodiumNeed),
        'tone': Colors.amber.shade50,
        'border': Colors.amber.shade300,
        'icon': Icons.science_outlined,
        'ionMood': IonMood.thinking,
        'ionHydrationLevel': HydrationLevel.normal,
      };
    }

    // Dehydration
    if (waterRatio < 0.5) {
      return {
        'title': l10n.adviceDehydration,
        'body': l10n.adviceDehydrationBody(l10n.water.toLowerCase()),
        'tone': Colors.blue.shade50,
        'border': Colors.blue.shade300,
        'icon': Icons.local_drink_outlined,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    // High HRI
    if (hriService.currentHRI >= 60) {
      return {
        'title': l10n.adviceHighRisk,
        'body': l10n.adviceHighRiskBody,
        'tone': const Color(0xFFFFF3E0),
        'border': Colors.deepOrange.shade300,
        'icon': Icons.priority_high_rounded,
        'ionMood': IonMood.worried,
        'ionHydrationLevel': HydrationLevel.low,
      };
    }

    // All good
    final waterNeed = (provider.goals.waterOpt - provider.totalWaterToday)
        .clamp(200, 800);
    return {
      'title': l10n.adviceAllGood,
      'body': l10n.adviceAllGoodBody(waterNeed.toInt()),
      'tone': Colors.green.shade50,
      'border': Colors.green.shade300,
      'icon': Icons.check_circle_outline,
      'ionMood': IonMood.happy,
      'ionHydrationLevel': HydrationLevel.perfect,
    };
  }

  // ============================================================================
  // UI BUILDERS - HRI STATUS CARD
  // ============================================================================
  
  Widget _buildHRIStatusCard(
    HRIService hri,
    HydrationProvider provider,
    AlcoholService alcohol,
    WeatherService weather,
    AppLocalizations l10n,
  ) {
    final hriValue = hri.currentHRI.round();
    final status = provider.getHydrationStatus(l10n);
    final localizedHRIStatus = _getLocalizedHRIStatus(hri, l10n);
    final components = hri.getComponentsBreakdown();
    final isFasting = _isCurrentlyFasting(provider);
    
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
          // Header with status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.hydrationStatus,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
          
          // HRI Label with zone badge
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
          
          // HRI Progress bar
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
          
          // HRI Value and status
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
                localizedHRIStatus,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getHRIColor(hriValue),
                ),
              ),
            ],
          ),
          
          // Active factors
          if (_hasActiveFactors(components, alcohol, weather)) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l10n.hriBreakdownTitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _buildActiveFactorChips(components, alcohol, weather, l10n),
            ),
          ],
          
          // Fasting mode indicator
          if (isFasting) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.purple,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.fastingModeActive,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _fastingSchedule,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  bool _hasActiveFactors(
    Map<String, double> components,
    AlcoholService alcohol,
    WeatherService weather,
  ) {
    return components['workouts']! > 0 ||
           components['caffeine']! > 0 ||
           alcohol.totalStandardDrinks > 0 ||
           weather.heatIndex != null;
  }

  List<Widget> _buildActiveFactorChips(
    Map<String, double> components,
    AlcoholService alcohol,
    WeatherService weather,
    AppLocalizations l10n,
  ) {
    final chips = <Widget>[];
    
    // Workouts
    if (components['workouts']! > 0) {
      chips.add(_buildFactorChip(
        '${l10n.hriComponentWorkout} +${components['workouts']!.toInt()}',
        Icons.fitness_center,
        Colors.teal,
      ));
    }
    
    // Heat/Weather - Always show if we have data
    if (weather.heatIndex != null) {
      final heatImpact = components['heat'] ?? 0;
      String label;
      Color color;
      IconData icon;
      
      if (weather.heatIndex! < 27) {
        label = '${l10n.hriComponentHeat} OK';
        color = Colors.green;
        icon = Icons.thermostat;
      } else if (weather.heatIndex! < 32) {
        label = '${l10n.hriComponentHeat} +${heatImpact.toInt()}';
        color = Colors.orange;
        icon = Icons.wb_sunny;
      } else {
        label = '${l10n.hriComponentHeat} +${heatImpact.toInt()}';
        color = Colors.red;
        icon = Icons.local_fire_department;
      }
      
      chips.add(_buildFactorChip(label, icon, color));
    }
    
    // Caffeine
    if (components['caffeine']! > 0) {
      chips.add(_buildFactorChip(
        '${l10n.hriComponentCaffeine} +${components['caffeine']!.toInt()}',
        Icons.coffee,
        Colors.brown,
      ));
    }
    
    // Alcohol
    if (alcohol.totalStandardDrinks > 0) {
      final sd = alcohol.totalStandardDrinks;
      final alcoholImpact = components['alcohol'] ?? 0;
      chips.add(_buildFactorChip(
        '${l10n.alcohol} ${sd.toStringAsFixed(1)} SD +${alcoholImpact.toInt()}',
        Icons.local_bar,
        Colors.red,
      ));
    }
    
    return chips;
  }

  Widget _buildFactorChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS - WORKOUTS
  // ============================================================================
  
  Widget _buildWorkoutsSection(HRIService hri, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(kCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.teal[600], size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.todaysWorkouts ?? 'Today\'s Activities',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: hri.todayWorkouts.map((workout) {
                return _buildWorkoutItem(workout, l10n);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Workout workout, AppLocalizations l10n) {
    final hoursSince = DateTime.now().difference(workout.timestamp).inHours;
    final impact = workout.getHRIImpact();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getWorkoutIcon(workout.type),
              color: Colors.teal[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getWorkoutLabel(workout.type, l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} ${l10n.minutes} • '
                  '${_getIntensityLabel(workout.intensity, l10n)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$hoursSince${l10n.hoursAgo}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'HRI +${impact.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.teal[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS - QUICK ADD
  // ============================================================================
  
  Widget _buildQuickAddSection(HydrationProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(kCardPadding),
      child: QuickAddWidget(
        key: _quickAddKey,
        provider: provider,
        onUpdate: () {
          setState(() {});
          _updateHRI();
        },
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS - TODAY'S HISTORY
  // ============================================================================
  
  Widget _buildTodayHistory(
    HydrationProvider provider,
    AlcoholService alcohol,
    AppLocalizations l10n,
  ) {
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _getCombinedIntakes(provider, alcohol, l10n),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getCombinedIntakes(
    HydrationProvider provider,
    AlcoholService alcohol,
    AppLocalizations l10n,
  ) {
    final List<MapEntry<DateTime, Widget>> all = [];

    // Add regular intakes
    for (var intake in provider.todayIntakes) {
      all.add(MapEntry(
        intake.timestamp,
        _buildIntakeItem(intake, l10n),
      ));
    }

    // Add alcohol intakes
    for (var intake in alcohol.todayIntakes) {
      all.add(MapEntry(
        intake.timestamp,
        _buildAlcoholItem(intake, l10n),
      ));
    }

    // Sort by time (newest first)
    all.sort((a, b) => b.key.compareTo(a.key));
    
    // Take only latest items
    return all.take(kMaxHistoryItems).map((e) => e.value).toList();
  }

  Widget _buildIntakeItem(Intake intake, AppLocalizations l10n) {
    final typeData = _getIntakeTypeData(intake.type, l10n);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            intake.formattedTime,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Text('${typeData['icon']} ${typeData['name']}'),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${intake.volume} ${l10n.ml}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (intake.totalElectrolytes > 0)
                Text(
                  'Na: ${intake.sodium} K: ${intake.potassium} Mg: ${intake.magnesium}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlcoholItem(dynamic intake, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.orange.shade200),
        ),
      ),
      child: Row(
        children: [
          Text(
            intake.formattedTime,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Icon(
            intake.type.icon,
            color: Colors.orange.shade600,
            size: 20,
          ),
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS - DAILY REPORT
  // ============================================================================
  
  Widget _buildDailyReportCard(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dailyReportComingSoon)),
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
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    ).animate()
       .fadeIn(duration: 400.ms)
       .slideY(begin: 1, end: 0);
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  void _showPaywall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  Color _getWaterColor(double percent) {
    if (percent < 30) return Colors.red;
    if (percent < 60) return Colors.orange;
    if (percent < 100) return Colors.blue;
    if (percent < 120) return Colors.green;
    return Colors.deepOrange;
  }

  Color _getStatusColor(String status) {
    if (status.contains('Normal') || status.contains('Норма')) {
      return Colors.green;
    }
    if (status.contains('Low salt') || 
        status.contains('Мало соли') ||
        status.contains('Diluting') || 
        status.contains('Разбавляешь')) {
      return Colors.orange;
    }
    if (status.contains('Under-hydrated') || 
        status.contains('Недобор воды')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }

  String _getLocalizedHRIStatus(HRIService hri, AppLocalizations l10n) {
    final hriValue = hri.currentHRI;
    
    if (hriValue <= 20) return l10n.hriStatusExcellent;
    if (hriValue <= 40) return l10n.hriStatusGood;
    if (hriValue <= 60) return l10n.hriStatusModerate;
    if (hriValue <= 80) return l10n.hriStatusHighRisk;
    return l10n.hriStatusCritical;
  }

  List<Color> _getWeatherGradient(double? heatIndex) {
    if (heatIndex == null) {
      return [Colors.blue.shade400, Colors.blue.shade600];
    }
    if (heatIndex < 20) {
      return [Colors.blue.shade400, Colors.blue.shade600];
    }
    if (heatIndex < 30) {
      return [Colors.green.shade400, Colors.green.shade600];
    }
    if (heatIndex < 40) {
      return [Colors.orange.shade400, Colors.orange.shade600];
    }
    return [Colors.red.shade400, Colors.red.shade600];
  }

  IconData _getWeatherIcon(double? heatIndex) {
    if (heatIndex == null) return Icons.thermostat;
    if (heatIndex < 20) return Icons.ac_unit;
    if (heatIndex < 30) return Icons.thermostat;
    if (heatIndex < 40) return Icons.wb_sunny;
    return Icons.local_fire_department;
  }

  IconData _getWorkoutIcon(String type) {
    switch (type) {
      case 'walking': return Icons.directions_walk;
      case 'running': return Icons.directions_run;
      case 'gym': return Icons.fitness_center;
      case 'swimming': return Icons.pool;
      case 'cycling': return Icons.directions_bike;
      case 'yoga': return Icons.self_improvement;
      case 'sauna': return Icons.hot_tub;
      default: return Icons.sports;
    }
  }

  String _getWorkoutLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'walking': return l10n.walking;
      case 'running': return l10n.running;
      case 'gym': return l10n.gym;
      case 'swimming': return l10n.swimming;
      case 'cycling': return l10n.cycling;
      case 'yoga': return l10n.yoga;
      case 'sauna': return l10n.sauna;
      default: return type;
    }
  }

  String _getIntensityLabel(int intensity, AppLocalizations l10n) {
    switch (intensity) {
      case 1:
      case 2:
        return l10n.lowIntensity;
      case 3:
        return l10n.mediumIntensity;
      case 4:
        return l10n.highIntensity;
      case 5:
        return l10n.veryHighIntensity;
      default:
        return '';
    }
  }

  Map<String, String> _getIntakeTypeData(String type, AppLocalizations l10n) {
    switch (type) {
      case 'water':
        return {'icon': '💧', 'name': l10n.water};
      case 'electrolyte':
        return {'icon': '⚡', 'name': l10n.electrolyte};
      case 'broth':
        return {'icon': '🍲', 'name': l10n.broth};
      case 'coffee':
        return {'icon': '☕', 'name': l10n.coffee};
      case 'tea':
        return {'icon': '🍵', 'name': l10n.tea};
      default:
        return {'icon': '🥤', 'name': type};
    }
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
    
    return '${weekDays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }
}