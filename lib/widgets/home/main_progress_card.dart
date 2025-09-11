// lib/widgets/home/main_progress_card.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/hydration_provider.dart';
import '../../services/units_service.dart';
import 'electrolyte_bar_display.dart';
import 'favorite_beverages_bar.dart';

class MainProgressCard extends StatefulWidget {
  final VoidCallback onUpdate;
  const MainProgressCard({super.key, required this.onUpdate});

  @override
  State<MainProgressCard> createState() => _MainProgressCardState();
}

class _MainProgressCardState extends State<MainProgressCard> {
  static const double kCardRadius = 20.0;
  static const double kCardPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final units = Provider.of<UnitsService>(context);
    final l10n = AppLocalizations.of(context);
    final progress = provider.getProgress();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kCardPadding, vertical: 10),
      padding: const EdgeInsets.fromLTRB(kCardPadding, kCardPadding, kCardPadding, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
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
          // Водяной круг с волновой анимацией
          _WaterRingWithText(
            consumed: provider.totalWaterToday.round(),
            goal: provider.goals.waterOpt,
            units: units,
            l10n: l10n,
          ),
          // Электролиты
          ElectrolyteBarDisplay(
            sodiumCurrent: (progress['sodium'] ?? 0).toInt(),
            sodiumGoal: provider.goals.sodium,
            potassiumCurrent: (progress['potassium'] ?? 0).toInt(),
            potassiumGoal: provider.goals.potassium,
            magnesiumCurrent: (progress['magnesium'] ?? 0).toInt(),
            magnesiumGoal: provider.goals.magnesium,
          ),
          const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),
          // Избранные напитки
          FavoriteBeveragesBar(onUpdate: widget.onUpdate),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}

// Виджет с кругом и текстом внутри
class _WaterRingWithText extends StatelessWidget {
  final int consumed;
  final int goal;
  final UnitsService units;
  final AppLocalizations l10n;

  const _WaterRingWithText({
    required this.consumed,
    required this.goal,
    required this.units,
    required this.l10n,
  });

  Color _getWaterColor(double percent) {
    if (percent < 30) return Colors.red;
    if (percent < 60) return Colors.orange;
    if (percent < 100) return Colors.blue;
    if (percent < 120) return Colors.green;
    return Colors.deepOrange;
  }

  @override
  Widget build(BuildContext context) {
    final percent = goal > 0 ? (consumed / goal * 100).clamp(0.0, 200.0).toDouble() : 0.0;
    final color = _getWaterColor(percent);
    
    // Форматируем объем с учетом выбранной системы измерения
    final displayVolume = units.formatVolume(consumed);
    final goalDisplay = units.formatVolume(goal);
    
    // Определяем цвет текста на основе процента заполнения
    // Используем более мягкие оттенки вместо резкого черного
    final bool useWhiteText = percent > 65;
    final primaryTextColor = useWhiteText 
      ? Colors.white 
      : const Color(0xFF37474F); // Мягкий сине-серый вместо черного
    final secondaryTextColor = useWhiteText 
      ? Colors.white.withOpacity(0.9) 
      : const Color(0xFF607D8B); // Более светлый сине-серый для второстепенного текста

    return SizedBox(
      width: 220,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Цель сверху круга с правильными единицами
          Positioned(
            top: 0,
            child: Text(
              'Target: $goalDisplay',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Анимированный круг с волной
          Positioned(
            top: 20,
            child: _WaterRingBare(
              consumedMl: consumed,
              goalMl: goal,
              size: 220,
              ringColor: color,
              ringBgColor: Colors.grey[300]!,
              waterColor: color,
            ),
          ),
          // Текст поверх круга
          Positioned(
            top: 20,
            child: SizedBox(
              width: 220,
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Отображаем объем в правильных единицах
                  Text(
                    displayVolume,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Процент
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: useWhiteText
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: useWhiteText
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${percent.toInt()}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== МИНИМАЛЬНЫЙ КРУГ С ВОЛНОЙ И ПРОГРЕСС-ДУГОЙ =====

class _WaterRingBare extends StatefulWidget {
  final int consumedMl;
  final int goalMl;
  final double size;
  final Color ringColor;
  final Color ringBgColor;
  final Color waterColor;

  const _WaterRingBare({
    required this.consumedMl,
    required this.goalMl,
    required this.size,
    required this.ringColor,
    required this.ringBgColor,
    required this.waterColor,
  });

  @override
  State<_WaterRingBare> createState() => _WaterRingBareState();
}

class _WaterRingBareState extends State<_WaterRingBare>
    with TickerProviderStateMixin {
  late final AnimationController _waveCtrl;
  late final AnimationController _progressCtrl;
  double _animatedProgress = 0;

  double get _targetProgress {
    if (widget.goalMl <= 0) return 0;
    final p = widget.consumedMl / widget.goalMl;
    return p.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _animatedProgress = _targetProgress;

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..addListener(() {
        setState(() {
          final t = Curves.easeInOut.transform(_progressCtrl.value);
          _animatedProgress =
              (_animatedProgress * (1 - t)) + (_targetProgress * t);
        });
      });
  }

  @override
  void didUpdateWidget(covariant _WaterRingBare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consumedMl != widget.consumedMl ||
        oldWidget.goalMl != widget.goalMl) {
      _progressCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _waveCtrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _WaterPainter(
              progress: _animatedProgress,
              t: _waveCtrl.value,
              ringColor: widget.ringColor,
              ringBgColor: widget.ringBgColor,
              waterColor: widget.waterColor,
            ),
          );
        },
      ),
    );
  }
}

class _WaterPainter extends CustomPainter {
  final double progress;
  final double t;
  final Color ringColor;
  final Color ringBgColor;
  final Color waterColor;

  _WaterPainter({
    required this.progress,
    required this.t,
    required this.ringColor,
    required this.ringBgColor,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final c = Offset(w / 2, h / 2);
    final r = math.min(w, h) / 2;

    // Фон ободка
    final ringBgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16
      ..color = ringBgColor;
    canvas.drawCircle(c, r - 8, ringBgPaint);

    // Вода (через клип по кругу)
    final clip = Path()..addOval(Rect.fromCircle(center: c, radius: r - 16));
    canvas.save();
    canvas.clipPath(clip);

    final level = (1.0 - progress) * (h - 32) + 16;
    _drawWave(canvas, size, level, t, waterColor.withOpacity(0.85), 10, 1.6);
    _drawWave(canvas, size, level + 4, (t + 0.35) % 1.0, waterColor.withOpacity(0.6), 7, 2.3);

    // Блик сверху
    final gloss = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.25), Colors.transparent],
        stops: const [0.0, 0.4],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.4), gloss);

    canvas.restore();

    // Тонкая внутренняя кромка
    final glass = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(c, r - 16, glass);

    // Прогресс-дуга (сплошной цвет без градиента для избежания резких переходов)
    final sweep = (math.pi * 2) * progress;
    if (sweep > 0.001) {
      final rect = Rect.fromCircle(center: c, radius: r - 8);

      final ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16
        ..color = ringColor;

      canvas.drawArc(rect, -math.pi / 2, sweep, false, ring);

      // Точка на конце дуги
      final endAngle = -math.pi / 2 + sweep;
      final end = Offset(
        c.dx + (r - 8) * math.cos(endAngle),
        c.dy + (r - 8) * math.sin(endAngle),
      );
      
      // Светящаяся точка
      final glowPaint = Paint()
        ..color = ringColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(end, 8, glowPaint);
      
      final dotPaint = Paint()..color = ringColor;
      canvas.drawCircle(end, 5, dotPaint);
    }
  }

  void _drawWave(Canvas canvas, Size size, double levelY, double t,
      Color color, double amp, double freq) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, levelY);

    final width = size.width;
    for (double x = 0; x <= width; x += 2) {
      final y = levelY +
          math.sin((x / width * math.pi * 2 * freq) + t * math.pi * 2) * amp;
      path.lineTo(x, y);
    }

    path.lineTo(width, size.height);
    path.close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaterPainter old) {
    return old.progress != progress ||
        old.t != t ||
        old.ringColor != ringColor ||
        old.ringBgColor != ringBgColor ||
        old.waterColor != waterColor;
  }
}