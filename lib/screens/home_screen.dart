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
import '../widgets/home/sugar_intake_card.dart'; // НОВЫЙ ИМПОРТ

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // УБРАЛИ: static const int kEveningReportHour = 21;
  // УБРАЛИ: bool _showDailyReport = false;
  
  String _fastingSchedule = '16:8';
  bool _isInitialized = false;
  int _favoritesUpdateCounter = 0; // Счетчик для обновления избранного
  
  // PageView controller для свайпа между экранами
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
    
    // Добавляем слушатель для отслеживания изменений страницы
    _pageController.addListener(() {
      if (_pageController.page != null) {
        final newPage = _pageController.page!.round();
        if (newPage != _currentPage) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    });
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
      // Обновляем избранное при возврате в приложение
      setState(() {
        _favoritesUpdateCounter++;
      });
    }
  }

  Future<void> _initialize() async {
    await _loadPreferences();
    // УБРАЛИ: _checkDailyReport();

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

  // УБРАЛИ метод _checkDailyReport()

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
    
    // NEW: Получаем данные о сахаре
    final sugarData = provider.getSugarIntakeData();

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
      sugarIntake: sugarData.totalGrams,  // NEW: Передаем данные о сахаре
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
        child: CustomScrollView(
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
                    height: 520, // Высота достаточная для всех карточек
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        // Первый экран - кольца прогресса
                        MainProgressCard(
                          onUpdate: () {
                            setState(() {});
                            _updateHRI();
                          },
                        ),
                        // Второй экран - погода
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: WeatherCard(),
                        ),
                        // ТРЕТИЙ ЭКРАН - SUGAR INTAKE (НОВОЕ)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: SugarIntakeCard(),
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
      ),
    );
  }

  // Виджет индикатора точек для PageView - ОБНОВЛЕНО ДЛЯ 3 СТРАНИЦ
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3, // ИЗМЕНЕНО: Теперь 3 страницы вместо 2
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
              boxShadow: _currentPage == index
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }

  // УБРАЛИ метод _buildDailyReportCard()
}