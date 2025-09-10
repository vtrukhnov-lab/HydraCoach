import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../widgets/ion_character.dart';
import '../services/units_service.dart';
import 'home_screen.dart';
import 'paywall_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // User data
  double _weight = 70; // Всегда храним в кг
  String _units = 'metric'; // Выбор единиц измерения
  String _dietMode = 'normal';
  String _fastingSchedule = 'none';
  bool _isPracticingFasting = false;
  
  @override
  void initState() {
    super.initState();
    // Загружаем текущие единицы измерения из UnitsService
    _units = UnitsService.instance.units;
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(l10n),
                  _buildUnitsPage(l10n),      // 1. Единицы (сначала)
                  _buildWeightPage(l10n),      // 2. Вес
                  _buildDietPage(l10n),        // 3. Диета
                  _buildCompletePage(l10n),    // 4. Завершение
                  _buildLocationPermissionPage(l10n),
                  _buildNotificationPermissionPage(l10n),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: _buildNavigationButtons(l10n),
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
      case 0: // Welcome
        return Column(
          children: [
            ElevatedButton(
              onPressed: _goToNextPage,
              style: _primaryButtonStyle(),
              child: Text(l10n.onboardingStartButton, style: _buttonTextStyle()),
            ),
          ],
        );
        
      case 4: // Complete
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _goToPreviousPage,
              child: Text(
                l10n.back,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _completeBasicOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC5FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(l10n.onboardingContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        );
        
      case 5: // Location
      case 6: // Notifications
        return Column(
          children: [
            ElevatedButton(
              onPressed: _currentPage == 5 
                ? _requestLocationPermission 
                : _requestNotificationPermission,
              style: _primaryButtonStyle(),
              child: Text(l10n.onboardingEnablePermission, style: _buttonTextStyle()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _skipPermission,
              child: Text(
                l10n.onboardingEnableLater,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          ],
        );
        
      default: // Steps 1-3
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
  
  Widget _buildWelcomePage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const IonCharacter(
            size: 120,
            mood: IonMood.happy,
            showGlow: true,
          ).animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut)
            .then()
            .shimmer(duration: 2000.ms, color: const Color(0xFF8AF5A3).withOpacity(0.2)),
          
          const SizedBox(height: 24),
          
          Text(
            l10n.onboardingWelcomeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 12),
          
          Text(
            l10n.onboardingWelcomeSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.3),
          ).animate().fadeIn(delay: 500.ms),
          
          const SizedBox(height: 24),
          
          ..._buildBenefitBullets(l10n),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  List<Widget> _buildBenefitBullets(AppLocalizations l10n) {
    final bullets = [
      l10n.onboardingBullet1,
      l10n.onboardingBullet2,
      l10n.onboardingBullet3,
      l10n.onboardingBullet4,
    ];
    
    return bullets.asMap().entries.map((entry) {
      final index = entry.key;
      final text = entry.value;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF2EC5FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check, size: 14, color: Color(0xFF2EC5FF)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14, height: 1.3)),
            ),
          ],
        ),
      ).animate()
        .slideX(begin: -0.2, end: 0, delay: (700 + index * 100).ms)
        .fadeIn(delay: (700 + index * 100).ms);
    }).toList();
  }
  
  // СТРАНИЦА 1: Единицы измерения
  Widget _buildUnitsPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const IonCharacter(size: 100, mood: IonMood.happy, showGlow: false)
            .animate().fadeIn(),
          
          const SizedBox(height: 24),
          
          Text(
            l10n.onboardingUnitsTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            l10n.onboardingUnitsSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          
          const SizedBox(height: 30),
          
          // Metric option
          GestureDetector(
            onTap: () {
              setState(() {
                _units = 'metric';
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: _units == 'metric' 
                  ? const Color(0xFF2EC5FF).withOpacity(0.1)
                  : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _units == 'metric' 
                    ? const Color(0xFF2EC5FF)
                    : Colors.grey[300]!,
                  width: _units == 'metric' ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2EC5FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('🌍', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.metricSystem,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _units == 'metric' 
                              ? const Color(0xFF2EC5FF)
                              : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.metricUnits,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (_units == 'metric')
                    const Icon(Icons.check_circle, color: Color(0xFF2EC5FF), size: 26),
                ],
              ),
            ),
          ).animate().scale(delay: 100.ms),
          
          // Imperial option
          GestureDetector(
            onTap: () {
              setState(() {
                _units = 'imperial';
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _units == 'imperial' 
                  ? const Color(0xFF2EC5FF).withOpacity(0.1)
                  : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _units == 'imperial' 
                    ? const Color(0xFF2EC5FF)
                    : Colors.grey[300]!,
                  width: _units == 'imperial' ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2EC5FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('🇺🇸', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.imperialSystem,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _units == 'imperial' 
                              ? const Color(0xFF2EC5FF)
                              : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.imperialUnits,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (_units == 'imperial')
                    const Icon(Icons.check_circle, color: Color(0xFF2EC5FF), size: 26),
                ],
              ),
            ),
          ).animate().scale(delay: 200.ms),
        ],
      ),
    );
  }
  
  // СТРАНИЦА 2: Вес
  Widget _buildWeightPage(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const IonCharacter(size: 100, mood: IonMood.happy, showGlow: false)
                  .animate().fadeIn(),
                
                const SizedBox(height: 20),
                
                Text(
                  l10n.weightPageTitle,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  l10n.weightPageSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                
                const SizedBox(height: 24),
                
                _buildWeightSelector(l10n),
                
                const SizedBox(height: 16),
                
                _buildWaterNormInfo(l10n),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildWeightSelector(AppLocalizations l10n) {
    // Отображаем вес в выбранных единицах, но храним всегда в кг
    final bool isImperial = _units == 'imperial';
    final int displayWeight = isImperial ? (_weight * 2.20462).round() : _weight.toInt();
    final String weightUnit = isImperial ? 'lb' : l10n.kg;
    const int minWeightKg = 50;
    const int maxWeightKg = 200;
    final int minDisplay = isImperial ? (minWeightKg * 2.20462).round() : minWeightKg;
    final int maxDisplay = isImperial ? (maxWeightKg * 2.20462).round() : maxWeightKg;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EC5FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                displayWeight.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2EC5FF),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                weightUnit,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2EC5FF),
              inactiveTrackColor: const Color(0xFF2EC5FF).withOpacity(0.1),
              thumbColor: const Color(0xFF2EC5FF),
              overlayColor: const Color(0xFF2EC5FF).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 8,
            ),
            child: Slider(
              value: _weight,
              min: minWeightKg.toDouble(),
              max: maxWeightKg.toDouble(),
              divisions: maxWeightKg - minWeightKg,
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
                HapticFeedback.selectionClick();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$minDisplay $weightUnit', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
              Text('$maxDisplay $weightUnit', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
  
  Widget _buildWaterNormInfo(AppLocalizations l10n) {
    // Показываем норму воды в выбранных единицах
    final bool isImperial = _units == 'imperial';
    final minWater = isImperial 
      ? ((22 * _weight) / 29.5735).toInt() 
      : (22 * _weight).toInt();
    final maxWater = isImperial 
      ? ((36 * _weight) / 29.5735).toInt() 
      : (36 * _weight).toInt();
    final waterUnit = isImperial ? 'oz' : l10n.ml;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF8AF5A3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8AF5A3).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop_outlined, color: Color(0xFF2EC5FF), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${l10n.recommendedNorm(minWater, maxWater).split(':')[0]}: $minWater-$maxWater $waterUnit',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2EC5FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
  
  // СТРАНИЦА 3: Диета
  Widget _buildDietPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const IonCharacter(size: 100, mood: IonMood.happy, showGlow: false)
            .animate().fadeIn(),
          
          const SizedBox(height: 20),
          
          Text(
            l10n.dietPageTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            l10n.dietPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          
          const SizedBox(height: 24),
          
          _buildFastingOption(l10n),
          
          if (_isPracticingFasting) ...[
            const SizedBox(height: 16),
            _buildFastingSchedules(l10n),
          ],
          
          const SizedBox(height: 16),
          
          _buildDietOption('normal', '🍽️', l10n.normalDiet, l10n.normalDietDesc, l10n),
          
          const SizedBox(height: 10),
          
          _buildDietOption('keto', '🥑', l10n.ketoDiet, l10n.ketoDietDesc, l10n),
        ],
      ),
    );
  }
  
  Widget _buildFastingOption(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPracticingFasting = !_isPracticingFasting;
          if (!_isPracticingFasting) {
            _dietMode = 'normal';
            _fastingSchedule = 'none';
          } else {
            _dietMode = 'fasting';
          }
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _isPracticingFasting 
            ? const Color(0xFF2EC5FF).withOpacity(0.1)
            : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isPracticingFasting 
              ? const Color(0xFF2EC5FF)
              : Colors.grey[300]!,
            width: _isPracticingFasting ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isPracticingFasting 
                    ? const Color(0xFF2EC5FF)
                    : Colors.grey[400]!,
                  width: 2,
                ),
                color: _isPracticingFasting 
                  ? const Color(0xFF2EC5FF)
                  : Colors.transparent,
              ),
              child: _isPracticingFasting
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingPracticeFasting,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _isPracticingFasting 
                        ? const Color(0xFF2EC5FF)
                        : Colors.black,
                    ),
                  ),
                  Text(
                    l10n.onboardingPracticeFastingDesc,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 100.ms);
  }
  
  Widget _buildFastingSchedules(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2EC5FF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.fastingSchedule,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildFastingScheduleOption('16:8', l10n.fasting16_8, l10n.fasting16_8Desc),
          _buildFastingScheduleOption('OMAD', l10n.fastingOMAD, l10n.fastingOMADDesc),
          _buildFastingScheduleOption('ADF', l10n.fastingADF, l10n.fastingADFDesc),
        ],
      ),
    ).animate().slideY(begin: 0.1, end: 0, duration: 300.ms);
  }
  
  Widget _buildFastingScheduleOption(String value, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _fastingSchedule = value;
        });
        HapticFeedback.selectionClick();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _fastingSchedule,
              onChanged: (val) {
                setState(() {
                  _fastingSchedule = val!;
                });
              },
              activeColor: const Color(0xFF2EC5FF),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDietOption(String value, String icon, String title, 
      String subtitle, AppLocalizations l10n) {
    final isSelected = _dietMode == value && !_isPracticingFasting;
    
    return GestureDetector(
      onTap: () {
        if (!_isPracticingFasting) {
          setState(() {
            _dietMode = value;
            _fastingSchedule = 'none';
          });
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF2EC5FF).withOpacity(0.1)
            : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFF2EC5FF)
              : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF2EC5FF) : Colors.black,
                    ),
                  ),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2EC5FF), size: 22),
          ],
        ),
      ),
    ).animate().scale(delay: (value == 'normal' ? 200 : 300).ms);
  }
  
  // СТРАНИЦА 4: Завершение
  Widget _buildCompletePage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const IonCharacter(
            size: 120,
            mood: IonMood.proud,
            showGlow: true,
          ).animate()
            .scale(duration: 500.ms, curve: Curves.elasticOut)
            .then()
            .shake(duration: 300.ms),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.onboardingProfileReady,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 16),
          
          _buildSummaryCard(l10n),
          
          const SizedBox(height: 24),
          
          Text(
            l10n.onboardingIonWillHelp,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(AppLocalizations l10n) {
    // Показываем в выбранных единицах
    final bool isImperial = _units == 'imperial';
    final waterNorm = isImperial
      ? ((30 * _weight) / 29.5735).toInt()
      : (30 * _weight).toInt();
    final waterUnit = isImperial ? 'oz' : l10n.ml;
    
    final displayWeight = isImperial
      ? '${(_weight * 2.20462).round()} lb'
      : '${_weight.round()} ${l10n.kg}';
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EC5FF).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            Icons.water_drop,
            l10n.onboardingWaterNorm,
            '$waterNorm $waterUnit',
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            Icons.monitor_weight,
            l10n.weight,
            displayWeight,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            Icons.straighten,
            l10n.unitsSection,
            _units == 'metric' ? l10n.metricSystem : l10n.imperialSystem,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            Icons.restaurant,
            l10n.dietMode,
            _getDietModeText(l10n),
          ),
          if (_isPracticingFasting && _fastingSchedule != 'none') ...[
            const SizedBox(height: 10),
            _buildSummaryRow(
              Icons.schedule,
              l10n.fastingSchedule,
              _fastingSchedule,
            ),
          ],
        ],
      ),
    ).animate().slideY(begin: 0.2, end: 0, delay: 500.ms);
  }
  
  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2EC5FF), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2EC5FF),
          ),
        ),
      ],
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
          
          const SizedBox(height: 30),
          
          _buildWeatherExample(l10n),
        ],
      ),
    );
  }
  
  Widget _buildWeatherExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('☀️', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingWeatherExample,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  l10n.onboardingWeatherExampleDesc,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.2, end: 0, delay: 600.ms);
  }
  
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
          
          const SizedBox(height: 20),
          
          ..._buildNotificationExamples(l10n),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  
  List<Widget> _buildNotificationExamples(AppLocalizations l10n) {
    final examples = [
      (Icons.water_drop, l10n.onboardingNotifExample1, const Color(0xFF2EC5FF)),
      (Icons.bolt, l10n.onboardingNotifExample2, const Color(0xFFFFA726)),
      (Icons.wb_sunny, l10n.onboardingNotifExample3, const Color(0xFFFF7043)),
      (Icons.coffee, '☕ ${l10n.postCoffeeTitle}', const Color(0xFF795548)),
     (Icons.fitness_center, '💪 ${l10n.postWorkoutTitle}', const Color(0xFF9C27B0)),
     (Icons.assessment, '📊 ${l10n.dailyReportTitle}', const Color(0xFF4CAF50)),
    ];
    
    return examples.asMap().entries.map((entry) {
      final index = entry.key;
      final icon = entry.value.$1;
      final text = entry.value.$2;
      final color = entry.value.$3;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text, 
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate()
        .slideX(begin: 0.2, end: 0, delay: (600 + index * 100).ms)
        .fadeIn(delay: (600 + index * 100).ms);
    }).toList();
  }
  
  String _getDietModeText(AppLocalizations l10n) {
    if (_isPracticingFasting) {
      return l10n.fastingDiet;
    }
    switch (_dietMode) {
      case 'keto':
        return l10n.ketoDiet;
      case 'normal':
      default:
        return l10n.normalDiet;
    }
  }
  
  void _goToNextPage() {
    if (_currentPage < 6) {
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
    _saveBasicData();
    _pageController.animateToPage(
      5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
      }
      
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      print('Location permission: $permission');
    } catch (e) {
      print('Location permission error: $e');
    }
    
    _pageController.animateToPage(
      6,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      print('Notification permission: $status');
      
      if (status.isGranted) {
        // Уведомления будут инициализированы после перезапуска
      }
    } catch (e) {
      print('Notification permission error: $e');
    }
    
    await _completeOnboarding();
  }
  
  void _skipPermission() {
    if (_currentPage == 5) {
      _pageController.animateToPage(
        6,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }
  
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    
    if (mounted) {
      final bool? purchased = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaywallScreen(showCloseButton: true),
          fullscreenDialog: true,
        ),
      );
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }
}