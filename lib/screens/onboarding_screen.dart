import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

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
                  _buildWelcomePage(),
                  _buildWeightPage(),
                  _buildDietPage(),
                  _buildActivityPage(),
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
                      child: const Text('Назад'),
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
                    child: Text(_currentPage == 3 ? 'Начать' : 'Далее'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomePage() {
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
          const Text(
            'Добро пожаловать в\nHydraCoach',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 20),
          Text(
            'Умный трекинг воды и электролитов\nдля кето, поста и активной жизни',
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
  
  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ваш вес',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Для расчета оптимального количества воды',
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
                  '${_weight.toInt()} кг',
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
                    Text('40 кг', style: TextStyle(color: Colors.grey[600])),
                    Text('150 кг', style: TextStyle(color: Colors.grey[600])),
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
                    'Рекомендуемая норма: ${(22 * _weight).toInt()}-${(36 * _weight).toInt()} мл воды в день',
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
  
  Widget _buildDietPage() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Режим питания',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Это влияет на потребность в электролитах',
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
            'Обычное питание',
            'Стандартные рекомендации',
          ),
          const SizedBox(height: 12),
          _buildDietOption(
            'keto',
            '🥑',
            'Кето / Низкоуглеводное',
            'Повышенная потребность в соли',
          ),
          const SizedBox(height: 12),
          _buildDietOption(
            'fasting',
            '⏰',
            'Интервальное голодание',
            'Особый режим электролитов',
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
                  const Text(
                    'Расписание голодания:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildFastingOption('16:8', '16:8', 'Ежедневное окно 8 часов'),
                  _buildFastingOption('OMAD', 'OMAD', 'Один прием пищи в день'),
                  _buildFastingOption('ADF', 'ADF', 'Через день'),
                ],
              ),
            ).animate().slideY(begin: 0.1, end: 0, duration: 200.ms),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDietOption(String value, String icon, String title, String subtitle) {
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
  
  Widget _buildActivityPage() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Уровень активности',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Влияет на потребность в воде',
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
            'Низкая активность',
            'Офисная работа, мало движения',
            '+0 мл воды',
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'medium',
            '🚶',
            'Средняя активность',
            '30-60 минут упражнений в день',
            '+350-700 мл воды',
          ),
          const SizedBox(height: 12),
          _buildActivityOption(
            'high',
            '🏃',
            'Высокая активность',
            'Тренировки >1 часа или физический труд',
            '+700-1200 мл воды',
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
                const Expanded(
                  child: Text(
                    'Мы будем корректировать цели на основе ваших тренировок',
                    style: TextStyle(
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
      String subtitle, String extra) {
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
      
      // Переходим на главный экран
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }
}