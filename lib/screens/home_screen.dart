// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Localization
import '../l10n/app_localizations.dart';

// Services
import '../services/hri_service.dart';
import '../services/weather_service.dart';
import '../services/alcohol_service.dart';
import '../services/units_service.dart';

// Providers
import '../providers/hydration_provider.dart';

// Widgets
import '../widgets/home/home_header.dart';
import '../widgets/home/weather_card.dart';
import '../widgets/home/main_progress_card.dart';
import '../widgets/home/smart_advice_card.dart';
import '../widgets/home/hri_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const int kEveningReportHour = 21;

  bool _showDailyReport = false;
  String _fastingSchedule = '16:8';
  bool _isInitialized = false;
  
  // PageView controller для свайпа между экранами
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    try {
      final alcohol = Provider.of<AlcoholService>(context, listen: false);
      alcohol.removeListener(_onAlcoholChanged);
      final weather = Provider.of<WeatherService>(context, listen: false);
      weather.removeListener(_onWeatherChanged);
    } catch (e) {
      print("Error removing listeners: $e");
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateHRI();
    }
  }

  Future<void> _initialize() async {
    await _loadPreferences();
    _checkDailyReport();

    final alcohol = Provider.of<AlcoholService>(context, listen: false);
    alcohol.addListener(_onAlcoholChanged);

    final weather = Provider.of<WeatherService>(context, listen: false);
    weather.addListener(_onWeatherChanged);
    await weather.loadWeather();

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
      print('Morning check-in needed after alcohol');
    }
  }

  void _onAlcoholChanged() {
    if (!mounted) return;
    _applyAlcoholAdjustments();
    _updateHRI();
  }

  void _onWeatherChanged() {
    if (!mounted) return;
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

    DateTime? lastIntakeTime = provider.todayIntakes.isNotEmpty ? provider.todayIntakes.last.timestamp : null;
    bool isFasting = _isCurrentlyFasting(provider);
    hri.setFastingStatus(isFasting);

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
      case '16:8': return hour < 12 || hour >= 20;
      case 'OMAD': return hour < 18 || hour >= 19;
      case 'ADF':
        final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
        return dayOfYear % 2 == 0;
      default: return hour < 12 || hour >= 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Заголовок
                const SliverToBoxAdapter(child: HomeHeader()),
                
                // PageView с карточками
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // PageView с фиксированной высотой
                      SizedBox(
                        height: 520, // Высота достаточная для обеих карточек
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            // Первый экран - кольца прогрессаr
                            MainProgressCard(
                              onUpdate: () {
                                setState(() {});
                                _updateHRI();
                              },
                            ),
                            // Второй экран - погода (весь функционал внутри виджета)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: WeatherCard(),
                            ),
                          ],
                        ),
                      ),
                      // Индикатор точек
                      _buildPageIndicator(),
                    ],
                  ),
                ),
                
                // Умные советы
                const SliverToBoxAdapter(child: SmartAdviceCard()),
                
                // Статус HRI
                SliverToBoxAdapter(
                  child: HRIStatusCard(
                    isFasting: _isCurrentlyFasting(provider),
                    fastingSchedule: _fastingSchedule,
                  ),
                ),
                
                // Отступ внизу для навигации
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 80),
                  sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
              ],
            ),
            
            // Карточка дневного отчета (вечером)
            if (_showDailyReport)
              Positioned(
                bottom: 110,
                left: 20,
                right: 20,
                child: _buildDailyReportCard(l10n),
              ),
          ],
        ),
      ),
    );
  }

  // Виджет индикатора точек для PageView
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          2, // Количество страниц
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index 
                ? Colors.blue 
                : Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

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
          gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade800]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            const Icon(Icons.analytics, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.dailyReportReady, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(l10n.viewDayResults, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 1, end: 0);
  }
}