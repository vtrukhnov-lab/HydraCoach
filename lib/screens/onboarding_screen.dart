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
  double _weight = 70;
  String _dietMode = 'normal';
  String _fastingSchedule = 'none';
  bool _isPracticingFasting = false;
  
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
            // Progress indicator
            if (_currentPage > 0 && _currentPage < 4)
              _buildProgressIndicator(),
            
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(l10n),
                  _buildWeightPage(l10n),
                  _buildDietPage(l10n),
                  _buildCompletePage(l10n),
                  _buildLocationPermissionPage(l10n),
                  _buildNotificationPermissionPage(l10n),
                ],
              ),
            ),
            
            // Navigation
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(3, (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: index < _currentPage 
                ? const Color(0xFF2EC5FF) 
                : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().scaleX(
            begin: index < _currentPage ? 0 : 1,
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
        
      case 3: // Complete
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
        
      case 4: // Location
      case 5: // Notifications
        return Column(
          children: [
            ElevatedButton(
              onPressed: _currentPage == 4 
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
        
      default: // Steps 1-2
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const IonCharacter(
            size: 140,
            mood: IonMood.happy,
            showGlow: true,
          ).animate()
            .scale(duration: 600.ms, curve: Curves.elasticOut)
            .then()
            .shimmer(duration: 2000.ms, color: const Color(0xFF8AF5A3).withOpacity(0.2)),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.onboardingWelcomeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 16),
          
          Text(
            l10n.onboardingWelcomeSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.3),
          ).animate().fadeIn(delay: 500.ms),
          
          const SizedBox(height: 30),
          
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF2EC5FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check, size: 16, color: Color(0xFF2EC5FF)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
            ),
          ],
        ),
      ).animate()
        .slideX(begin: -0.2, end: 0, delay: (700 + index * 100).ms)
        .fadeIn(delay: (700 + index * 100).ms);
    }).toList();
  }
  
  Widget _buildWeightPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IonCharacter(size: 120, mood: IonMood.happy, showGlow: false)
            .animate().fadeIn(),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.weightPageTitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            l10n.weightPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          
          const SizedBox(height: 40),
          
          _buildWeightSelector(l10n),
          
          const SizedBox(height: 20),
          
          _buildWaterNormInfo(l10n),
        ],
      ),
    );
  }
  
  Widget _buildWeightSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
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
                _weight.toInt().toString(),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2EC5FF),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.kg,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2EC5FF),
              inactiveTrackColor: const Color(0xFF2EC5FF).withOpacity(0.1),
              thumbColor: const Color(0xFF2EC5FF),
              overlayColor: const Color(0xFF2EC5FF).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              trackHeight: 10,
            ),
            child: Slider(
              value: _weight,
              min: 50,
              max: 200,
              divisions: 150,
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
              Text('50 ${l10n.kg}', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              Text('200 ${l10n.kg}', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
  
  Widget _buildWaterNormInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Icon(Icons.water_drop_outlined, color: Color(0xFF2EC5FF), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.recommendedNorm((22 * _weight).toInt(), (36 * _weight).toInt()),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2EC5FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
  
  Widget _buildDietPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const IonCharacter(size: 120, mood: IonMood.happy, showGlow: false)
            .animate().fadeIn(),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.dietPageTitle,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            l10n.dietPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          
          const SizedBox(height: 30),
          
          _buildFastingOption(l10n),
          
          if (_isPracticingFasting) ...[
            const SizedBox(height: 20),
            _buildFastingSchedules(l10n),
          ],
          
          const SizedBox(height: 20),
          
          _buildDietOption('normal', '🍽️', l10n.normalDiet, l10n.normalDietDesc, l10n),
          
          const SizedBox(height: 12),
          
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
        padding: const EdgeInsets.all(16),
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
              width: 24,
              height: 24,
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
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingPracticeFasting,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isPracticingFasting 
                        ? const Color(0xFF2EC5FF)
                        : Colors.black,
                    ),
                  ),
                  Text(
                    l10n.onboardingPracticeFastingDesc,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
      padding: const EdgeInsets.all(16),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
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
        padding: const EdgeInsets.symmetric(vertical: 6),
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
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
        padding: const EdgeInsets.all(16),
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
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF2EC5FF) : Colors.black,
                    ),
                  ),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2EC5FF)),
          ],
        ),
      ),
    ).animate().scale(delay: (value == 'normal' ? 200 : 300).ms);
  }
  
  Widget _buildCompletePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IonCharacter(
            size: 140,
            mood: IonMood.proud,
            showGlow: true,
          ).animate()
            .scale(duration: 500.ms, curve: Curves.elasticOut)
            .then()
            .shake(duration: 300.ms),
          
          const SizedBox(height: 40),
          
          Text(
            l10n.onboardingProfileReady,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 20),
          
          _buildSummaryCard(l10n),
          
          const SizedBox(height: 30),
          
          Text(
            l10n.onboardingIonWillHelp,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            '${(30 * _weight).toInt()} ${l10n.ml}',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            Icons.restaurant,
            l10n.dietMode,
            _getDietModeText(l10n),
          ),
          if (_isPracticingFasting) ...[
            const SizedBox(height: 12),
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
        Icon(icon, color: const Color(0xFF2EC5FF), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2EC5FF),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLocationPermissionPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2EC5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.location_on_rounded, size: 50, color: Color(0xFF2EC5FF)),
            ),
          ).animate().scale(duration: 400.ms),
          
          const SizedBox(height: 40),
          
          Text(
            l10n.onboardingLocationTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            l10n.onboardingLocationSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
          ),
          
          const SizedBox(height: 40),
          
          _buildWeatherExample(l10n),
        ],
      ),
    );
  }
  
  Widget _buildWeatherExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('☀️', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.onboardingWeatherExample,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  l10n.onboardingWeatherExampleDesc,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2EC5FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.notifications_rounded, size: 50, color: Color(0xFF2EC5FF)),
            ),
          ).animate().scale(duration: 400.ms),
          
          const SizedBox(height: 40),
          
          Text(
            l10n.onboardingNotificationTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            l10n.onboardingNotificationSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
          ),
          
          const SizedBox(height: 30),
          
          ..._buildNotificationExamples(l10n),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  List<Widget> _buildNotificationExamples(AppLocalizations l10n) {
    final examples = [
      (Icons.water_drop, l10n.onboardingNotifExample1, const Color(0xFF2EC5FF)),
      (Icons.bolt, l10n.onboardingNotifExample2, const Color(0xFFFFA726)),
      (Icons.wb_sunny, l10n.onboardingNotifExample3, const Color(0xFFFF7043)),
      (Icons.coffee_outlined, 'After coffee reminder', const Color(0xFF8D6E63)),
      (Icons.fitness_center, 'Post-workout recovery', const Color(0xFF66BB6A)),
      (Icons.nightlight_round, 'Evening hydration check', const Color(0xFF5C6BC0)),
    ];
    
    return examples.asMap().entries.map((entry) {
      final index = entry.key;
      final icon = entry.value.$1;
      final text = entry.value.$2;
      final color = entry.value.$3;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(12),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text, 
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (index == 0)
                      Text(
                        'Personalized timing based on your routine',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (index == 1)
                      Text(
                        'Essential for keto and fasting',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (index == 2)
                      Text(
                        'Weather-based adjustments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
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
    if (_currentPage < 3) {
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
      4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _requestLocationPermission() async {
    // Запрашиваем разрешение на геолокацию через geolocator
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Сервис локации выключен
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
    
    // Переходим к уведомлениям
    _pageController.animateToPage(
      5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> _requestNotificationPermission() async {
    // Запрашиваем разрешение на уведомления через permission_handler
    try {
      final status = await Permission.notification.request();
      print('Notification permission: $status');
      
      if (status.isGranted) {
        // Инициализируем уведомления если разрешено
        // Это будет сделано в main.dart после перезапуска
      }
    } catch (e) {
      print('Notification permission error: $e');
    }
    
    // Завершаем онбординг
    await _completeOnboarding();
  }
  
  void _skipPermission() {
    if (_currentPage == 4) {
      _pageController.animateToPage(
        5,
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
    await prefs.setString('dietMode', _dietMode);
    await prefs.setString('activityLevel', 'medium');
    await prefs.setString('fastingSchedule', _fastingSchedule);
    
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