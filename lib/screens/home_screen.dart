// lib/screens/home_screen.dart
// 
// Main home screen - Refactored with separate UI widgets AND Sticky Quick Add feature

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
import '../services/units_service.dart';

// Providers
import '../providers/hydration_provider.dart';

// Widgets
import '../widgets/quick_add_widget.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/weather_card.dart';
import '../widgets/home/main_progress_card.dart';
import '../widgets/home/smart_advice_card.dart';
import '../widgets/home/hri_status_card.dart';
import '../widgets/home/today_history_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // ============================================================================
  // CONSTANTS
  // ============================================================================
  
  static const int kEveningReportHour = 21;
  static const double kStickyQuickAddScrollOffset = 280.0;

  // ============================================================================
  // STATE
  // ============================================================================
  
  // 1. Контроллер скролла и флаг для управления "липким" виджетом
  final ScrollController _scrollController = ScrollController();
  bool _showStickyQuickAdd = false;

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
    // Добавляем слушатель к контроллеру
    _scrollController.addListener(_scrollListener);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Очищаем ресурсы контроллера и слушателя
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    
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
      _refreshQuickAdd();
      _updateHRI();
    }
  }

  // ============================================================================
  // SCROLL LISTENER LOGIC
  // ============================================================================

  // 2. Логика слушателя: меняем флаг в зависимости от смещения
  void _scrollListener() {
    if (_scrollController.offset > kStickyQuickAddScrollOffset && !_showStickyQuickAdd) {
      if (mounted) {
        setState(() {
          _showStickyQuickAdd = true;
        });
      }
    } else if (_scrollController.offset <= kStickyQuickAddScrollOffset && _showStickyQuickAdd) {
      if (mounted) {
        setState(() {
          _showStickyQuickAdd = false;
        });
      }
    }
  }

  // ============================================================================
  // INITIALIZATION & CORE LOGIC
  // ============================================================================
  
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

  // ============================================================================
  // BUILD METHOD
  // ============================================================================
  
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
        child: Stack(
          children: [
            CustomScrollView(
              // 3. Привязка контроллера к списку
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: HomeHeader()),
                const SliverToBoxAdapter(child: WeatherCard()),
                const SliverToBoxAdapter(child: MainProgressCard()),
                const SliverToBoxAdapter(child: SmartAdviceCard()),
                SliverToBoxAdapter(
                  child: HRIStatusCard(
                    isFasting: _isCurrentlyFasting(provider),
                    fastingSchedule: _fastingSchedule,
                  ),
                ),
                
                // 4. Встроенный Quick Add теперь отображается по условию
                if (!_showStickyQuickAdd)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: QuickAddWidget(
                        key: _quickAddKey,
                        provider: provider,
                        onUpdate: () {
                          setState(() {});
                          _updateHRI();
                        },
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: TodayHistorySection()),

                // 5. Увеличиваем нижний отступ, чтобы "док" не перекрывал контент
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),

            if (_showDailyReport)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _buildDailyReportCard(l10n),
              ),
            
            // 6. Добавляем "липкий" виджет в Stack
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStickyQuickAdd(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // UI BUILDERS
  // ============================================================================

  // 7. Метод для построения анимированного "липкого" виджета
  Widget _buildStickyQuickAdd() {
    final provider = Provider.of<HydrationProvider>(context, listen: false);

    return AnimatedSlide(
      offset: _showStickyQuickAdd ? Offset.zero : const Offset(0, 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _showStickyQuickAdd ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 220),
        // IgnorePointer предотвращает случайные нажатия на невидимый виджет
        child: IgnorePointer(
          ignoring: !_showStickyQuickAdd,
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  spreadRadius: -4,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            // SafeArea защищает от системных элементов (например, "полоска" навигации)
            child: SafeArea(
              top: false,
              child: QuickAddWidget(
                key: _quickAddKey,
                provider: provider,
                onUpdate: () {
                  setState(() {});
                  _updateHRI();
                },
              ),
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