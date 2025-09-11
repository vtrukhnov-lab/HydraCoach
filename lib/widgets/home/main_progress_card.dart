// lib/widgets/home/main_progress_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/hydration_provider.dart';
import '../../services/units_service.dart';
import 'electrolyte_bar_display.dart';
import 'favorite_beverages_bar.dart';

// ИЗМЕНЕНИЕ 1: Превращаем виджет в StatefulWidget для управления анимацией
class MainProgressCard extends StatefulWidget {
  final VoidCallback onUpdate;
  const MainProgressCard({super.key, required this.onUpdate});

  @override
  State<MainProgressCard> createState() => _MainProgressCardState();
}

class _MainProgressCardState extends State<MainProgressCard> with SingleTickerProviderStateMixin {
  // Задаем константы здесь для удобства
  static const double kCardRadius = 20.0;
  static const double kCardPadding = 20.0;
  static const double kProgressRingSize = 150.0;
  static const double kProgressStrokeWidth = 14.0;

  // ИЗМЕНЕНИЕ 2: Создаем контроллер анимации
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  // Переменная для хранения предыдущего значения, чтобы анимация шла от него
  double _oldProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллер
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Получаем начальное значение прогресса
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final initialProgress = (provider.getProgress()['waterPercent'] ?? 0) / 100.0;

    // Создаем анимацию от 0 до начального значения
    _progressAnimation = Tween<double>(
      begin: _oldProgress,
      end: initialProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    // Запускаем анимацию при первом показе виджета
    _controller.forward();
  }

  @override
  void didUpdateWidget(MainProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ИЗМЕНЕНИЕ 3: Этот метод срабатывает, когда данные обновляются
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final newProgress = (provider.getProgress()['waterPercent'] ?? 0) / 100.0;

    // Обновляем анимацию: теперь она будет идти от старого значения к новому
    _progressAnimation = Tween<double>(
      begin: _oldProgress, // Начинаем с предыдущего значения
      end: newProgress,    // Анимируем к новому
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    // Перезапускаем анимацию и сохраняем новое значение как "старое" для следующего раза
    _controller.forward(from: 0.0);
    _oldProgress = newProgress;
  }

  @override
  void dispose() {
    // Обязательно "убиваем" контроллер, чтобы избежать утечек памяти
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получаем зависимости, как и раньше
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
          // ИЗМЕНЕНИЕ 4: Оборачиваем круг в AnimatedBuilder
          _buildAnimatedWaterRing(units, l10n, provider.goals.waterOpt.toDouble()),
          ElectrolyteBarDisplay(
            sodiumCurrent: (progress['sodium'] ?? 0).toInt(),
            sodiumGoal: provider.goals.sodium,
            potassiumCurrent: (progress['potassium'] ?? 0).toInt(),
            potassiumGoal: provider.goals.potassium,
            magnesiumCurrent: (progress['magnesium'] ?? 0).toInt(),
            magnesiumGoal: provider.goals.magnesium,
          ),
          const Divider(height: 20, thickness: 1, indent: 20, endIndent: 20),
          FavoriteBeveragesBar(onUpdate: widget.onUpdate),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildAnimatedWaterRing(UnitsService units, AppLocalizations l10n, double waterGoal) {
    // AnimatedBuilder перерисовывает виджет на каждом кадре анимации
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animatedValue = _progressAnimation.value;
        final animatedPercent = animatedValue * 100;
        final animatedVolume = animatedValue * waterGoal;
        final displayVolume = units.formatVolume(animatedVolume.toInt());
        final color = _getWaterColor(animatedPercent);

        return SizedBox(
          width: kProgressRingSize,
          height: kProgressRingSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: kProgressRingSize,
                height: kProgressRingSize,
                child: CircularProgressIndicator(
                  value: animatedValue, // Используем значение из анимации
                  strokeWidth: kProgressStrokeWidth,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${animatedPercent.toInt()}%',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(l10n.water, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    displayVolume,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getWaterColor(double percent) {
    if (percent < 30) return Colors.red;
    if (percent < 60) return Colors.orange;
    if (percent < 100) return Colors.blue;
    if (percent < 120) return Colors.green;
    return Colors.deepOrange;
  }
}