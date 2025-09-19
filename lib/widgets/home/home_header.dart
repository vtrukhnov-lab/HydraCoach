// lib/widgets/home/home_header.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Локализация
import '../../l10n/app_localizations.dart';

// Сервисы
import '../../services/subscription_service.dart';

// Экраны
import '../../screens/paywall_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  // Вспомогательный метод для форматирования даты
  String _getFormattedDate(AppLocalizations l10n) {
    final now = DateTime.now();
    final weekDays = [
      l10n.sunday, l10n.monday, l10n.tuesday, l10n.wednesday,
      l10n.thursday, l10n.friday, l10n.saturday,
    ];
    final months = [
      l10n.january, l10n.february, l10n.march, l10n.april, l10n.may, l10n.june,
      l10n.july, l10n.august, l10n.september, l10n.october, l10n.november, l10n.december,
    ];
    
    return '${weekDays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }

  // Метод для показа Paywall
  void _showPaywall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(source: 'home_header'),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sub = Provider.of<SubscriptionProvider>(context);
    const kCardPadding = 20.0;

    return Container(
      padding: const EdgeInsets.all(kCardPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Левая часть - название и дата
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 350.ms),
                    if (sub.isPro) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber.shade400, Colors.amber.shade600],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getFormattedDate(l10n),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Правая часть - только кнопка PRO (если пользователь не PRO)
          if (!sub.isPro)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.purple.shade600],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
              onPressed: () => _showPaywall(context),
              tooltip: l10n.getPro,
            ),
          
          // УБРАЛИ: IconButton для истории
          // УБРАЛИ: IconButton для настроек
        ],
      ),
    );
  }
}