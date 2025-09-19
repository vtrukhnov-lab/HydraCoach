// lib/screens/onboarding_screen.dart (REFACTORED VERSION)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_service.dart';
import '../services/units_service.dart';
import 'onboarding/pages/welcome_page.dart';
import 'onboarding/pages/units_page.dart';
import 'onboarding/pages/weight_page.dart';
import 'onboarding/pages/diet_page.dart';
import 'onboarding/pages/complete_page.dart';
import 'onboarding/pages/notification_examples_page.dart';
import 'onboarding/pages/location_examples_page.dart';
import 'onboarding/widgets/first_intake_tutorial.dart';
import 'main_shell.dart';
import 'paywall_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final AnalyticsService _analytics = AnalyticsService();

  static const Map<int, String> _stepIds = {
    0: 'welcome',
    1: 'units',
    2: 'weight',
    3: 'diet',
    4: 'profile_summary',
    5: 'notifications_preview',
    6: 'notification_permission',
    7: 'location_preview',
    8: 'location_permission',
  };

  // User data
  double _weight = 70;
  String _units = 'metric';
  String _dietMode = 'normal';
  String _fastingSchedule = 'none';
  bool _isPracticingFasting = false;

  @override
  void initState() {
    super.initState();
    _units = UnitsService.instance.units;

    Future.microtask(() {
      _analytics.logOnboardingStart();
      _trackStepView(_currentPage);
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _stepIdFor(int index) => _stepIds[index] ?? 'step_$index';

  void _trackStepView(int index) {
    final stepId = _stepIdFor(index);
    _analytics.logOnboardingStepViewed(
      stepId: stepId,
      stepIndex: index,
      screenName: 'onboarding_$stepId',
    );
  }

  void _trackStepCompleted(int index) {
    final stepId = _stepIdFor(index);
    _analytics.logOnboardingStepCompleted(
      stepId: stepId,
      stepIndex: index,
    );
  }

  void _completeStep(int index) {
    if (index == 2) {
      _analytics.logOnboardingOptionSelected(
        stepId: _stepIdFor(index),
        option: 'weight_kg',
        value: _weight.toStringAsFixed(1),
      );
    }

    _trackStepCompleted(index);
  }

  String _notificationStatusToString(PermissionStatus status) {
    if (status.isGranted) {
      return 'granted';
    }
    if (status.isPermanentlyDenied) {
      return 'permanently_denied';
    }
    if (status.isDenied) {
      return 'denied';
    }
    if (status == PermissionStatus.restricted) {
      return 'restricted';
    }
    if (status == PermissionStatus.limited) {
      return 'limited';
    }
    return status.name;
  }

  String _locationStatusToString(LocationPermission status) {
    switch (status) {
      case LocationPermission.always:
        return 'always';
      case LocationPermission.whileInUse:
        return 'while_in_use';
      case LocationPermission.denied:
        return 'denied';
      case LocationPermission.deniedForever:
        return 'permanently_denied';
      case LocationPermission.unableToDetermine:
        return 'unknown';
    }
  }

  void _advanceFromNotifications({
    required String status,
    bool isSkip = false,
  }) {
    if (isSkip) {
      _analytics.logOnboardingSkip(step: 5);
    }
    _analytics.logPermissionResult(
      permission: 'notifications',
      status: status,
      context: 'onboarding',
    );
    _analytics.logOnboardingOptionSelected(
      stepId: _stepIdFor(6),
      option: 'status',
      value: status,
    );
    _trackStepCompleted(6);
    _completeStep(5);

    _pageController.animateToPage(
      7,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _advanceFromLocation({
    required String status,
    bool isSkip = false,
  }) {
    if (isSkip) {
      _analytics.logOnboardingSkip(step: 7);
    }
    _analytics.logPermissionResult(
      permission: 'location',
      status: status,
      context: 'onboarding',
    );
    _analytics.logOnboardingOptionSelected(
      stepId: _stepIdFor(8),
      option: 'status',
      value: status,
    );
    _trackStepCompleted(8);
    _completeStep(7);

    _completeOnboarding();
  }

  void _handleNotificationPermissionResult(PermissionStatus status) {
    final statusString = _notificationStatusToString(status);
    _advanceFromNotifications(status: statusString);
  }

  void _handleLocationPermissionResult(LocationPermission status) {
    final statusString = _locationStatusToString(status);
    _advanceFromLocation(status: statusString);
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator (не для welcome page)
            if (_currentPage > 0 && _currentPage < 5)
              _buildProgressIndicator(),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                  _trackStepView(page);
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 0 - Welcome Page
                  WelcomePage(
                    onStart: _goToNextPage,
                  ),
                  
                  // 1 - Units Page
                  UnitsPage(
                    selectedUnits: _units,
                    onUnitsChanged: (units) {
                      setState(() {
                        _units = units;
                      });
                      _analytics.logOnboardingOptionSelected(
                        stepId: _stepIdFor(1),
                        option: 'units_system',
                        value: units,
                      );
                    },
                    onNext: _goToNextPage,
                  ),
                  
                  // 2 - Weight Page
                  WeightPage(
                    weight: _weight,
                    units: _units,
                    onWeightChanged: (weight) {
                      setState(() {
                        _weight = weight;
                      });
                    },
                  ),
                  
                  // 3 - Diet Page
                  DietPage(
                    isPracticingFasting: _isPracticingFasting,
                    fastingSchedule: _fastingSchedule,
                    dietMode: _dietMode,
                    onFastingChanged: (isFasting) {
                      setState(() {
                        _isPracticingFasting = isFasting;
                        if (!isFasting) {
                          _dietMode = 'normal';
                          _fastingSchedule = 'none';
                        } else {
                          _dietMode = 'fasting';
                        }
                      });
                      _analytics.logOnboardingOptionSelected(
                        stepId: _stepIdFor(3),
                        option: 'fasting_enabled',
                        value: isFasting.toString(),
                      );
                    },
                    onFastingScheduleChanged: (schedule) {
                      setState(() {
                        _fastingSchedule = schedule;
                      });
                      _analytics.logOnboardingOptionSelected(
                        stepId: _stepIdFor(3),
                        option: 'fasting_schedule',
                        value: schedule,
                      );
                    },
                    onDietModeChanged: (mode) {
                      setState(() {
                        _dietMode = mode;
                        _fastingSchedule = 'none';
                      });
                      _analytics.logOnboardingOptionSelected(
                        stepId: _stepIdFor(3),
                        option: 'diet_mode',
                        value: mode,
                      );
                    },
                  ),
                  
                  // 4 - Complete Page
                  CompletePage(
                    weight: _weight,
                    units: _units,
                    dietMode: _dietMode,
                    fastingSchedule: _fastingSchedule,
                    isPracticingFasting: _isPracticingFasting,
                    onContinue: _completeBasicOnboarding,
                    onBack: _goToPreviousPage,
                  ),
                  
                  // 5 - Notification Examples
                  NotificationExamplesPage(
                    onSkip: _skipPermission,
                    onBack: () {
                      // Возвращаемся на Complete Page (индекс 4)
                      _pageController.animateToPage(
                        4,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onPermissionResult: _handleNotificationPermissionResult,
                  ),
                  
                  // 6 - Notification Permission (старая страница - можно удалить)
                  _buildNotificationPermissionPage(l10n),
                  
                  // 7 - Location Examples
                  LocationExamplesPage(
                    onSkip: _skipPermission,
                    onBack: () {
                      // Возвращаемся на NotificationExamplesPage (индекс 5)
                      _pageController.animateToPage(
                        5,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onPermissionResult: _handleLocationPermissionResult,
                  ),
                  
                  // 8 - Location Permission (старая страница - можно удалить)
                  _buildLocationPermissionPage(l10n),
                ],
              ),
            ),
            
            // Navigation buttons
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: _buildNavigationButtons(l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    // 4 шага: units, weight, diet, complete
    final totalSteps = 4;
    final currentStep = _currentPage > 4 ? 4 : _currentPage;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(totalSteps, (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: index < currentStep 
                ? const Color(0xFF2EC5FF) 
                : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().scaleX(
            begin: index < currentStep ? 0 : 1,
            end: 1,
            duration: 300.ms,
          ),
        )),
      ),
    );
  }
  
  Widget _buildNavigationButtons(AppLocalizations l10n) {
    switch (_currentPage) {
      case 0: // Welcome - кнопка встроена в страницу
      case 1: // Units - кнопка встроена в страницу  
      case 4: // Complete - кнопки встроены в страницу
      case 5: // Notification examples - кнопки встроены в страницу
      case 7: // Location examples - кнопки встроены в страницу
        return const SizedBox.shrink();
        
      case 6: // Notification permission - старая страница (можно удалить)
        return Column(
          children: [
            ElevatedButton(
              onPressed: _skipNotificationPermission,
              style: _primaryButtonStyle(),
              child: Text(
                l10n.onboardingAllowNotifications, 
                style: _buttonTextStyle(),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _skipNotificationPermission,
              child: Text(
                l10n.onboardingEnableLater,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ],
        );
        
      case 8: // Location permission - старая страница
        return Column(
          children: [
            ElevatedButton(
              onPressed: _requestLocationPermission,
              style: _primaryButtonStyle(),
              child: Text(l10n.onboardingAllowLocation, style: _buttonTextStyle()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _skipLocationPermission,
              child: Text(
                l10n.onboardingEnableLater,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ],
        );
        
      default: // Steps 2-3 (weight, diet)
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 1)
              TextButton(
                onPressed: _goToPreviousPage,
                child: Text(l10n.back, style: const TextStyle(fontSize: 16)),
              )
            else
              const SizedBox(width: 80),
            
            ElevatedButton(
              onPressed: _goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC5FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(l10n.next, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        );
    }
  }
  
  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2EC5FF),
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
    );
  }
  
  TextStyle _buttonTextStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  }

  // Permission pages that still need to be here (старые страницы - можно удалить позже)
  Widget _buildNotificationPermissionPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF2EC5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.notifications_rounded, size: 45, color: Color(0xFF2EC5FF)),
            ),
          ).animate().scale(duration: 400.ms),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.onboardingNotificationTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            l10n.onboardingNotificationSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLocationPermissionPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF2EC5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.location_on_rounded, size: 45, color: Color(0xFF2EC5FF)),
            ),
          ).animate().scale(duration: 400.ms),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.onboardingLocationTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            l10n.onboardingLocationSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ),
    );
  }
  
  // Navigation methods
  void _goToNextPage() {
    _completeStep(_currentPage);
    if (_currentPage < 8) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeBasicOnboarding() {
    _completeStep(4);
    _analytics.logOnboardingProfileSaved(
      weightKg: _weight,
      units: _units,
      dietMode: _dietMode,
      fastingEnabled: _isPracticingFasting,
    );
    _saveBasicData();
    _pageController.animateToPage(
      5, // Переход к примерам уведомлений
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  void _skipPermission() {
    if (_currentPage == 5) {
      _advanceFromNotifications(status: 'skipped', isSkip: true);
    } else if (_currentPage == 7) {
      _advanceFromLocation(status: 'skipped', isSkip: true);
    }
  }

  void _skipNotificationPermission() {
    _advanceFromNotifications(status: 'skipped', isSkip: true);
  }

  void _skipLocationPermission() {
    _advanceFromLocation(status: 'skipped', isSkip: true);
  }
  
  // Permission methods (старые - не используются)
  Future<void> _requestNotificationPermission() async {
    try {
      // Запрашиваем разрешение на уведомления
      final status = await Permission.notification.request();
      debugPrint('Notification permission status: $status');
      HapticFeedback.lightImpact();
      
      // Показываем результат в debug
      if (status == PermissionStatus.granted) {
        debugPrint('✅ Уведомления разрешены');
      } else if (status == PermissionStatus.denied) {
        debugPrint('❌ Уведомления отклонены');  
      } else {
        debugPrint('⚠️ Статус разрешений: $status');
      }
    } catch (e) {
      debugPrint('❌ Ошибка запроса разрешений: $e');
    }
    
    // Переходим к геолокации независимо от результата
    _pageController.animateToPage(
      7, // Примеры геолокации
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
      }
      
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      HapticFeedback.lightImpact();
      debugPrint('Location permission: $permission');
    } catch (e) {
      debugPrint('Location permission error: $e');
    }
    
    _completeOnboarding();
  }
  
  // Data management methods
  Future<void> _saveBasicData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', _weight);
    await prefs.setString('units', _units);
    await prefs.setString('dietMode', _dietMode);
    await prefs.setString('activityLevel', 'medium');
    await prefs.setString('fastingSchedule', _fastingSchedule);
    
    // Сохраняем выбранные единицы в UnitsService
    await UnitsService.instance.setUnits(_units);
    
    if (mounted) {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      provider.updateProfile(
        weight: _weight,
        dietMode: _dietMode,
        activityLevel: 'medium',
        fastingSchedule: _fastingSchedule,
      );
    }
  }
  
  Future<void> _completeOnboarding() async {
    // Сохраняем данные перед завершением
    await _saveBasicData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    await _analytics.logOnboardingComplete();

    if (mounted) {
      // Показываем paywall
      final bool? purchased = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaywallScreen(
            showCloseButton: true,
            source: 'onboarding',
          ),
          fullscreenDialog: true,
        ),
      );
      
      if (mounted) {
        // Показываем туториал первого глотка
        final shouldShowTutorial = prefs.getBool('tutorialCompleted') != true;
        
        if (shouldShowTutorial) {
          // Переходим в MainShell с туториалом
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const _MainShellWithTutorial()),
            (route) => false,
          );
        } else {
          // Обычный переход без туториала
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainShell()),
            (route) => false,
          );
        }
      }
    }
  }
}

// Обёртка для MainShell с туториалом
class _MainShellWithTutorial extends StatefulWidget {
  const _MainShellWithTutorial();

  @override
  State<_MainShellWithTutorial> createState() => _MainShellWithTutorialState();
}

class _MainShellWithTutorialState extends State<_MainShellWithTutorial> {
  bool _showTutorial = true;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Основной экран
        const MainShell(),
        
        // Туториальный оверлей
        if (_showTutorial)
          FirstIntakeTutorial(
            onComplete: () {
              setState(() {
                _showTutorial = false;
              });
            },
          ),
      ],
    );
  }
}