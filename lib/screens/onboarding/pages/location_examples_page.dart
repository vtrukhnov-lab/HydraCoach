// lib/screens/onboarding/pages/location_examples_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';

class LocationExamplesPage extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const LocationExamplesPage({
    Key? key,
    required this.onSkip,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                l10n.onboardingLocationExamplesTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ).animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 12),
              
              // Подзаголовок
              Text(
                l10n.onboardingLocationExamplesSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ).animate()
                .fadeIn(duration: 500.ms, delay: 100.ms),
              
              const SizedBox(height: 32),
              
              // Примеры использования геолокации
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLocationExample(
                        context: context,
                        icon: Icons.sunny,
                        iconColor: Colors.orange,
                        emoji: '☀️',
                        title: l10n.onboardingWeatherExample,
                        body: l10n.onboardingWeatherExampleDesc,
                        delay: 200.ms,
                        theme: theme,
                        isLight: isLight,
                      ),
                      
                      _buildLocationExample(
                        context: context,
                        icon: Icons.thermostat,
                        iconColor: Colors.red,
                        emoji: '🌡️',
                        title: l10n.heatWarningHot,
                        body: l10n.drinkMoreWaterToday,
                        delay: 300.ms,
                        theme: theme,
                        isLight: isLight,
                      ),
                      
                      _buildLocationExample(
                        context: context,
                        icon: Icons.water_drop,
                        iconColor: Colors.blue,
                        emoji: '💧',
                        title: l10n.hydrationStatus,
                        body: l10n.maintainWaterBalance,
                        delay: 400.ms,
                        theme: theme,
                        isLight: isLight,
                      ),
                      
                      _buildLocationExample(
                        context: context,
                        icon: Icons.ac_unit,
                        iconColor: Colors.lightBlue,
                        emoji: '❄️',
                        title: l10n.heatWarningCold,
                        body: l10n.startDayWithWater,
                        delay: 500.ms,
                        theme: theme,
                        isLight: isLight,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Кнопки действий
              Row(
                children: [
                  // Кнопка "Назад"
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onBack();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        l10n.back,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: 500.ms)
                    .slideX(begin: -0.2, end: 0),
                  
                  const SizedBox(width: 16),
                  
                  // Кнопка "Разрешить геолокацию"
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        
                        // Показываем индикатор загрузки
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        
                        try {
                          // Проверяем включены ли службы геолокации
                          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
                          if (!serviceEnabled) {
                            debugPrint('Location services are disabled');
                            // Можно показать диалог с просьбой включить геолокацию
                          }
                          
                          // Проверяем текущие разрешения
                          var permission = await Geolocator.checkPermission();
                          
                          // Если разрешения нет - запрашиваем
                          if (permission == LocationPermission.denied) {
                            permission = await Geolocator.requestPermission();
                          }
                          
                          // Если разрешение отклонено навсегда
                          if (permission == LocationPermission.deniedForever) {
                            debugPrint('Location permissions are permanently denied');
                            // Можно показать диалог с инструкцией открыть настройки
                          }
                          
                          debugPrint('Location permission: $permission');
                          
                        } catch (e) {
                          debugPrint('Error requesting location permission: $e');
                        } finally {
                          // Закрываем индикатор загрузки
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                        
                        // Переходим дальше
                        onSkip();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.onboardingAllowLocation),
                        ],
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideX(begin: 0.2, end: 0),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка "Пропустить"
              Center(
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onSkip();
                  },
                  child: Text(
                    l10n.onboardingEnableLater,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationExample({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String emoji,
    required String title,
    required String body,
    required Duration delay,
    required ThemeData theme,
    required bool isLight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight 
            ? Colors.white 
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isLight ? 0.08 : 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка с эмодзи
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor.withOpacity(0.3),
                  size: 24,
                ),
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Содержимое примера
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: delay)
      .slideX(begin: 0.1, end: 0);
  }
}