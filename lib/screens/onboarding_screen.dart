import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';
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
  
  // Данные пользователя
  double _weight = 70;
  String _dietMode = 'normal';
  String _activityLevel = 'medium';
  String _fastingSchedule = 'none';
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Индикатор прогресса
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(4, (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentPage 
                        ? Colors.blue 
                        : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ).animate().scaleX(
                    begin: index <= _currentPage ? 0 : 1,
                    end: 1,
                    duration: 300.ms,
                  ),
                )),
              ),
            ),
            
            // Страницы онбординга
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(l10n),
                  _buildWeightPage(l10n),
                  _buildDietPage(l10n),
                  _buildActivityPage(l10n),
                ],
              ),
            ),
            
            // Кнопки навигации
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(l10n.back),
                    )
                  else
                    const SizedBox(width: 80),
                  
                  ElevatedButton(
                    onPressed: _currentPage == 3 ? _completeOnboarding : () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(_currentPage == 3 ? l10n.start : l10n.next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '💧',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ).animate().scale(duration: 500.ms),
          const SizedBox(height: 40),
          Text(
            l10n.welcomeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 20),
          Text(
            l10n.welcomeSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
  
  Widget _buildWeightPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.weightPageTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.weightPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),
          
          // Слайдер веса
          Container(
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
                Text(
                  l10n.weightUnit(_weight.toInt()),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.blue.withOpacity(0.1),
                    thumbColor: Colors.blue,
                    overlayColor: Colors.blue.withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    trackHeight: 8,
                  ),
                  child: Slider(
                    value: _weight,
                    min: 40,
                    max: 150,
                    divisions: 110,
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
                    Text('40 ${l10n.kg}', style: TextStyle(color: Colors.grey[600])),
                    Text('150 ${l10n.kg}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ).animate().slideY(begin: 0.2, end: 0, duration: 300.ms),
          
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.recommendedNorm(
                      (22 * _weight).toInt(),
                      (36 * _weight).toInt(),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDietPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.dietPageTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.dietPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          
          _buildDietOption(
            'normal',
            '🍽️',
            l10n.normalDiet,
            l10n.normalDietDesc,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildDietOption(
            'keto',
            '🥑',
            l10n.ketoDiet,
            l10n.ketoDietDesc,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildDietOption(
            'fasting',
            '⏰',
            l10n.fastingDiet,
            l10n.fastingDietDesc,
            l10n,
          ),
          
          if (_dietMode == 'fasting') ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fastingSchedule,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildFastingOption('16:8', l10n.fasting16_8, l10n.fasting16_8Desc),
                  _buildFastingOption('OMAD', l10n.fastingOMAD, l10n.fastingOMADDesc),
                  _buildFastingOption('ADF', l10n.fastingADF, l10n.fastingADFDesc),
                ],
              ),
            ).animate().slideY(begin: 0.1, end: 0, duration: 200.ms),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDietOption(String value, String icon, String title, 
      String subtitle, AppLocalizations l10n) {
    final isSelected = _dietMode == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _dietMode = value;
          if (value != 'fasting') {
            _fastingSchedule = 'none';
          }
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
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
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    ).animate().scale(delay: (value == 'normal' ? 0 : value == 'keto' ? 100 : 200).ms);
  }
  
  Widget _buildFastingOption(String value, String title, String subtitle) {
    final isSelected = _fastingSchedule == value;
    
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
              activeColor: Colors.blue,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    subtitle,
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
    );
  }
  
  Widget _buildActivityPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.activityPageTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.activityPageSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          
          _buildActivityOption(
            'low',
            '🪑',
            l10n.lowActivity,
            l10n.lowActivityDesc,
            l10n.lowActivityWater,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'medium',
            '🚶',
            l10n.mediumActivity,
            l10n.mediumActivityDesc,
            l10n.mediumActivityWater,
            l10n,
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'high',
            '🏃',
            l10n.highActivity,
            l10n.highActivityDesc,
            l10n.highActivityWater,
            l10n,
          ),
          
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.activityAdjustmentNote,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityOption(String value, String icon, String title, 
      String subtitle, String extra, AppLocalizations l10n) {
    final isSelected = _activityLevel == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _activityLevel = value;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
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
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      extra,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    ).animate().scale(delay: (value == 'low' ? 0 : value == 'medium' ? 100 : 200).ms);
  }
  
  Future<void> _completeOnboarding() async {
    // Сохраняем данные
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    await prefs.setDouble('weight', _weight);
    await prefs.setString('dietMode', _dietMode);
    await prefs.setString('activityLevel', _activityLevel);
    await prefs.setString('fastingSchedule', _fastingSchedule);
    
    // Обновляем провайдер
    if (mounted) {
      final provider = Provider.of<HydrationProvider>(context, listen: false);
      provider.updateProfile(
        weight: _weight,
        dietMode: _dietMode,
        activityLevel: _activityLevel,
        fastingSchedule: _fastingSchedule,
      );
      
      // Показываем пейвол после онбординга
      final bool? purchased = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaywallScreen(showCloseButton: true),
          fullscreenDialog: true,
        ),
      );
      
      // Переходим на главный экран в любом случае (купил или закрыл)
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }
}