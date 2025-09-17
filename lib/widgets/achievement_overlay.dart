import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/achievement.dart';
import '../l10n/app_localizations.dart';

class AchievementOverlay extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;
  final Duration displayDuration;

  const AchievementOverlay({
    super.key,
    required this.achievement,
    this.onDismiss,
    this.displayDuration = const Duration(seconds: 4),
  });

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _progressController;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: widget.displayDuration,
      vsync: this,
    );

    _controller.forward();
    _progressController.forward().then((_) {
      if (!_isDismissed && mounted) {
        _dismiss();
      }
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;

    HapticFeedback.lightImpact();
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: _dismiss,
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: Curves.elasticOut.transform(_controller.value),
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (1 - _controller.value) * 50,
                    ),
                    child: Opacity(
                      opacity: _controller.value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Progress bar
                            Container(
                              height: 3,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.outline.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: 1 - _progressController.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Header
                            Text(
                              l10n.achievementUnlocked,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ).animate().fadeIn(delay: 200.ms),

                            const SizedBox(height: 16),

                            // Achievement icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _getRarityColor(widget.achievement.rarity)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getRarityColor(widget.achievement.rarity),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.achievement.icon,
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                            )
                                .animate()
                                .scale(delay: 300.ms, duration: 600.ms)
                                .then()
                                .shake(duration: 200.ms),

                            const SizedBox(height: 20),

                            // Achievement name
                            Text(
                              _getLocalizedTitle(l10n),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 400.ms),

                            const SizedBox(height: 8),

                            // Achievement description
                            Text(
                              _getLocalizedDescription(l10n),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 500.ms),

                            const SizedBox(height: 20),

                            // Rarity badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getRarityColor(widget.achievement.rarity),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getRarityText(l10n, widget.achievement.rarity),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ).animate().fadeIn(delay: 600.ms),

                            const SizedBox(height: 16),

                            // Dismiss hint
                            Text(
                              l10n.tapToDismiss,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            ).animate().fadeIn(delay: 800.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n) {
    // For now, return the name as is
    // In production, you would use l10n with achievement IDs
    return widget.achievement.name;
  }

  String _getLocalizedDescription(AppLocalizations l10n) {
    // For now, return the description as is
    // In production, you would use l10n with achievement IDs
    return widget.achievement.description;
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey.shade600;
      case AchievementRarity.uncommon:
        return Colors.green.shade600;
      case AchievementRarity.rare:
        return Colors.blue.shade600;
      case AchievementRarity.epic:
        return Colors.purple.shade600;
      case AchievementRarity.legendary:
        return Colors.amber.shade600;
    }
  }

  String _getRarityText(AppLocalizations l10n, AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return l10n.achievementRarityCommon;
      case AchievementRarity.uncommon:
        return l10n.achievementRarityUncommon;
      case AchievementRarity.rare:
        return l10n.achievementRarityRare;
      case AchievementRarity.epic:
        return l10n.achievementRarityEpic;
      case AchievementRarity.legendary:
        return l10n.achievementRarityLegendary;
    }
  }

  // Static method to show overlay
  static void show({
    required BuildContext context,
    required Achievement achievement,
    Duration displayDuration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => AchievementOverlay(
        achievement: achievement,
        displayDuration: displayDuration,
        onDismiss: () {
          entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }
}