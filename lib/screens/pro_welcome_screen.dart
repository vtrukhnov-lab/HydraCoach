import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

class ProWelcomeScreen extends StatefulWidget {
  const ProWelcomeScreen({super.key});

  @override
  State<ProWelcomeScreen> createState() => _ProWelcomeScreenState();
}

class _ProWelcomeScreenState extends State<ProWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Устанавливаем цвет системных панелей
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Определяем планшет ли это
    final isTablet = screenWidth > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2),
              const Color(0xFF50C9C3),
              const Color(0xFF4A90E2).withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: isTablet ? screenWidth * 0.15 : screenWidth * 0.06,
                      right: isTablet ? screenWidth * 0.15 : screenWidth * 0.06,
                      top: screenHeight * 0.03,
                      bottom: screenHeight * 0.03,
                    ),
                    child: Column(
                      children: [
                        // Большая радостная иконка с пульсацией
                        SizedBox(
                          height: isTablet
                              ? screenHeight * 0.2
                              : screenHeight * 0.25,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: isTablet
                                        ? screenWidth * 0.15
                                        : screenWidth * 0.25,
                                    height: isTablet
                                        ? screenWidth * 0.15
                                        : screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '🎉',
                                        style: TextStyle(
                                          fontSize: isTablet
                                              ? screenWidth * 0.08
                                              : screenWidth * 0.15,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Заголовок и подзаголовок
                        SizedBox(
                          height: screenHeight * 0.15,
                          child: Column(
                            children: [
                              Text(
                                l10n.proWelcomeTitle,
                                style: TextStyle(
                                  fontSize: isTablet
                                      ? screenWidth * 0.04
                                      : screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                l10n.proTrialActivated,
                                style: TextStyle(
                                  fontSize: isTablet
                                      ? screenWidth * 0.025
                                      : screenWidth * 0.045,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Список фич
                        Container(
                          margin: EdgeInsets.only(
                            top: screenHeight * 0.025,
                            bottom: screenHeight * 0.015,
                          ),
                          child: Column(
                            children: [
                              _buildFeatureCard(
                                '🚫',
                                l10n.proFeatureNoMoreAds,
                                l10n.proFeatureNoMoreAdsDescription,
                                0,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '💧',
                                l10n.proFeaturePersonalizedRecommendations,
                                l10n.proFeaturePersonalizedDescription,
                                200,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '📊',
                                l10n.proFeatureAdvancedAnalytics,
                                l10n.proFeatureAdvancedDescription,
                                400,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '🏃‍♂️',
                                l10n.proFeatureWorkoutTracking,
                                l10n.proFeatureWorkoutDescription,
                                600,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '🧂',
                                l10n.proFeatureElectrolyteControl,
                                l10n.proFeatureElectrolyteDescription,
                                800,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '🎯',
                                l10n.proFeatureSmartReminders,
                                l10n.proFeatureSmartDescription,
                                1000,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '📈',
                                l10n.proFeatureHriIndex,
                                l10n.proFeatureHriDescription,
                                1200,
                                screenWidth,
                              ),
                              _buildFeatureCard(
                                '🏆',
                                l10n.proFeatureAchievements,
                                l10n.proFeatureAchievementsDescription,
                                1400,
                                screenWidth,
                              ),
                            ],
                          ),
                        ),

                        // Кнопка
                        SizedBox(
                          height: screenHeight * 0.12,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: screenHeight * 0.07,
                              margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                              ),
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF4A90E2),
                                  elevation: 8,
                                  shadowColor: Colors.black.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  l10n.startUsing,
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? screenWidth * 0.025
                                        : screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String icon,
    String title,
    String description,
    int delayMs,
    double screenWidth,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value * 1400 - delayMs) / 200;
        final opacity = progress.clamp(0.0, 1.0);
        final translateY = (1 - progress.clamp(0.0, 1.0)) * 30;

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: EdgeInsets.only(bottom: screenWidth * 0.025),
              padding: EdgeInsets.all(screenWidth * 0.035),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: TextStyle(fontSize: screenWidth * 0.06),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.01),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
