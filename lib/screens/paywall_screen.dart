import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import 'package:hydracoach/l10n/app_localizations.dart';
import '../services/analytics_service.dart';
import '../services/remote_config_service.dart';
import '../services/subscription_service.dart';
import '../services/url_launcher_service.dart';
import '../widgets/ion_character.dart';
import 'pro_welcome_screen.dart';

enum Plan { lifetime, annual, monthly }

class PricingPack {
  final Plan plan;
  final String price; // real price from Google Play Store
  final String? originalPrice; // crossed out, if any
  final String periodLabel; // kept for compatibility
  final bool isBestValue; // highlight annual

  const PricingPack({
    required this.plan,
    required this.price,
    this.originalPrice,
    required this.periodLabel,
    this.isBestValue = false,
  });
}

class PaywallScreen extends StatefulWidget {
  final bool showCloseButton;
  final String source;
  final String? variant;

  const PaywallScreen({
    super.key,
    this.showCloseButton = true,
    this.source = 'unknown',
    this.variant,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final RemoteConfigService _rc = RemoteConfigService.instance;
  final AnalyticsService _analytics = AnalyticsService();

  // State
  bool _isLoading = false;
  Plan _selected = Plan.annual;
  bool _trialEnabledSwitch = true;
  bool _showAllFeatures = false;
  bool _dismissLogged = false;
  bool _waitingForPurchase = false; // Флаг ожидания результата покупки
  Timer? _purchaseCheckTimer; // Таймер для проверки статуса покупки

  // pricing loaded from Google Play Store
  Map<Plan, PricingPack> _pricing = {};

  @override
  void initState() {
    super.initState();
    _trialEnabledSwitch = _rc.trialEnabled;
    _loadRealPricing();
    _analytics.logPaywallShown(
      source: widget.source,
      variant: widget.variant,
    );

    // Слушаем изменения PRO статуса для обработки результата покупки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      subscriptionProvider.addListener(_onProStatusChanged);
    });
  }


  // Обработчик изменения PRO статуса
  void _onProStatusChanged() {
    print('🔔 PRO status changed - waiting: $_waitingForPurchase');
    if (!_waitingForPurchase) return;

    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    print('🔔 PRO status: ${subscriptionProvider.isPro}');
    if (subscriptionProvider.isPro) {
      print('✅ Purchase successful! Showing ProWelcomeScreen');
      _waitingForPurchase = false;
      _handlePurchaseSuccess();
    }
  }

  // Запуск таймера для проверки PRO статуса (backup на случай если listener не сработает)
  void _startPurchaseCheckTimer() {
    _purchaseCheckTimer?.cancel();
    _purchaseCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_waitingForPurchase || !mounted) {
        timer.cancel();
        return;
      }

      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      print('⏰ Timer check - PRO status: ${subscriptionProvider.isPro}');
      if (subscriptionProvider.isPro) {
        timer.cancel();
        _waitingForPurchase = false;
        _handlePurchaseSuccess();
      }

      // Остановить через 30 секунд если статус не изменился
      if (timer.tick >= 30) {
        print('⏰ Timer expired - stopping purchase check');
        timer.cancel();
        setState(() => _waitingForPurchase = false);
      }
    });
  }

  // Обработка успешной покупки
  Future<void> _handlePurchaseSuccess() async {
    if (!mounted) return;

    print('🎉 Showing ProWelcomeScreen');
    // Показываем экран приветствия
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProWelcomeScreen(),
        fullscreenDialog: true,
      ),
    );

    _logPaywallDismiss('purchase_success');
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    if (!_dismissLogged) {
      _logPaywallDismiss('dispose');
    }
    // Убираем listener и таймер
    _purchaseCheckTimer?.cancel();
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    subscriptionProvider.removeListener(_onProStatusChanged);
    super.dispose();
  }

  void _loadRealPricing() {
    final subscriptionService = SubscriptionService.instance;

    // Get real prices from Google Play Store
    final lifetimeProduct = subscriptionService.lifetimeProduct;
    final yearlyProduct = subscriptionService.yearlyProduct;
    final monthlyProduct = subscriptionService.monthlyProduct;

    _pricing = {
      Plan.lifetime: PricingPack(
        plan: Plan.lifetime,
        price: lifetimeProduct?.price ?? '\$49.99',
        periodLabel: 'one-time',
      ),
      Plan.annual: PricingPack(
        plan: Plan.annual,
        price: yearlyProduct?.price ?? '\$23.99',
        originalPrice: null, // Remove hardcoded original price
        periodLabel: '/year',
        isBestValue: true,
      ),
      Plan.monthly: PricingPack(
        plan: Plan.monthly,
        price: monthlyProduct?.price ?? '\$4.99',
        periodLabel: '/month',
      ),
    };

    if (mounted) {
      setState(() {}); // Trigger rebuild with real prices
    }
  }

  // ---------- Helpers ----------
  bool get _trialGloballyEnabled {
    final enabled = _rc.paywallShowTrial;
    print('🧪 DEBUG: _trialGloballyEnabled = $enabled');
    return enabled;
  }

  bool get _trialAllowedForSelectedPlan {
    final allowed = _selected == Plan.annual;
    print('🧪 DEBUG: _trialAllowedForSelectedPlan = $allowed (selected: $_selected)');
    return allowed;
  }

  bool get _showTrialSwitch {
    final show = _trialGloballyEnabled && _trialAllowedForSelectedPlan;
    print('🧪 DEBUG: _showTrialSwitch = $show (global: $_trialGloballyEnabled, allowed: $_trialAllowedForSelectedPlan)');
    return show;
  }

  String _formatMoney(String price) => price;

  String _ctaText(AppLocalizations l10n) {
    final pack = _pricing[_selected]!;
    if (_showTrialSwitch && _trialEnabledSwitch) return l10n.startFreeTrial;

    // без триала — короткая локализованная CTA
    return switch (_selected) {
      Plan.lifetime => l10n.unlockForPrice(_formatMoney(pack.price)),
      Plan.annual => l10n.continueWithPrice(_formatMoney(pack.price)),
      Plan.monthly => l10n.continueWithPrice(_formatMoney(pack.price)),
    };
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (widget.showCloseButton) {
          _logPaywallDismiss('system_back');
        }
        return widget.showCloseButton;
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1214) : const Color(0xFFF8FAFA),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header with Ion and benefits
                  Container(
                    height: 240,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Ion Character on the left
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: const IonCharacter(
                              size: 120,
                              mood: IonMood.proud,
                              showGlow: true,
                            ).animate()
                              .scale(duration: 600.ms, curve: Curves.elasticOut)
                              .then()
                              .shimmer(duration: 2000.ms, color: const Color(0xFF8AF5A3).withOpacity(0.2)),
                          ),
                        ),
                        // Benefits on the right
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.unlockPro,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF2D3436),
                                  ),
                                ).animate().fadeIn(delay: 300.ms),
                                const SizedBox(height: 8),
                                _buildQuickBenefit(Icons.notifications_active, l10n.smartReminders, isDark),
                                const SizedBox(height: 4),
                                _buildQuickBenefit(Icons.analytics, l10n.weeklyReports, isDark),
                                const SizedBox(height: 4),
                                _buildQuickBenefit(Icons.block, l10n.proFeatureNoMoreAds, isDark),
                                const SizedBox(height: 4),
                                _buildQuickBenefit(Icons.health_and_safety, l10n.healthIntegrations, isDark),
                                const SizedBox(height: 4),
                                _buildQuickBenefit(Icons.local_bar, l10n.alcoholProtocols, isDark),
                              ].animate(interval: 100.ms).fadeIn(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pricing & CTA
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B0E10) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildPricingOptions(isDark, l10n),
                            const SizedBox(height: 16),
                            if (_showTrialSwitch) _buildTrialToggle(isDark, l10n),
                            const SizedBox(height: 16),
                            _buildCtaButton(isDark, l10n),
                            const SizedBox(height: 8),
                            _buildAutoRenewNote(isDark, l10n),
                            const SizedBox(height: 24),
                            _buildPoliciesAndRestore(isDark, l10n),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Close
              if (widget.showCloseButton)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      _logPaywallDismiss('close_button');
                      Navigator.of(context).pop();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white12 : Colors.white.withOpacity(0.9)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 20, color: isDark ? Colors.white : const Color(0xFF2D3436)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBenefit(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: Colors.cyan),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Widgets ----------
  Widget _buildPricingOptions(bool isDark, AppLocalizations l10n) {
    final tilesBg = isDark ? const Color(0x1412FFFF) : const Color(0xFFF3F8F8);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: tilesBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _pricingTile(_pricing[Plan.lifetime]!, isDark, l10n),
          const SizedBox(height: 8),
          _pricingTile(_pricing[Plan.annual]!, isDark, l10n),
          const SizedBox(height: 8),
          _pricingTile(_pricing[Plan.monthly]!, isDark, l10n),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _pricingTile(PricingPack pack, bool isDark, AppLocalizations l10n) {
    final isSelected = _selected == pack.plan;
    final highlight = pack.isBestValue;

    final bg = isSelected
        ? (isDark ? const Color(0xFF0E2330) : Colors.cyan.shade50)
        : (isDark ? const Color(0xFF12161A) : Colors.white);

    final borderColor = isSelected
        ? (isDark ? const Color(0xFF2FB8E9) : Colors.cyan.shade400)
        : (highlight ? (isDark ? const Color(0xFF1E7896) : Colors.cyan.shade200)
                     : (isDark ? Colors.white10 : Colors.grey.shade200));

    final textMain = isDark ? Colors.white : const Color(0xFF2D3436);

    final original = pack.originalPrice;
    final price = pack.price;

    final isAnnual = pack.plan == Plan.annual;
    String? perMonthLabel;
    if (isAnnual) {
      final subscriptionService = SubscriptionService.instance;
      final yearlyProduct = subscriptionService.yearlyProduct;
      if (yearlyProduct != null) {
        // Calculate monthly price from yearly product
        final yearlyPrice = yearlyProduct.rawPrice;
        final monthlyEquivalent = yearlyPrice / 12;
        final currencySymbol = yearlyProduct.currencySymbol;
        perMonthLabel = l10n.approximatelyPerMonth('$currencySymbol${monthlyEquivalent.toStringAsFixed(2)}');
      }
    }

    // FIXED: Всегда используем локализацию, не Remote Config
    final title = switch (pack.plan) {
      Plan.lifetime => l10n.lifetimeAccess,
      Plan.annual  => l10n.bestValueAnnual,
      Plan.monthly => l10n.monthly,
    };

    // локализованный период
    final periodText = switch (pack.plan) {
      Plan.lifetime => l10n.oneTime,   // "единоразово"
      Plan.annual   => l10n.perYear,   // "/год"
      Plan.monthly  => l10n.perMonth,  // "/месяц"
    };

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (_selected != pack.plan) {
          _analytics.logPaywallPlanSelected(
            plan: pack.plan.name,
            source: widget.source,
            variant: widget.variant,
          );
        }
        setState(() => _selected = pack.plan);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          gradient: (isAnnual && isSelected)
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0E2330), const Color(0xFF0B1720)]
                      : [Colors.cyan.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? Colors.cyanAccent.withOpacity(0.08)
                                   : Colors.cyan.withOpacity(0.15)),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                // radio
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.cyan : (isDark ? Colors.white30 : Colors.grey.shade400),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 11,
                            height: 11,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textMain)),
                      const SizedBox(height: 4),

                      // одна строка с ценой, периодом, зачёркнутой ценой и ≈/mo
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600),
                          children: [
                            TextSpan(
                              text: price,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? (isDark ? Colors.cyanAccent : Colors.cyan.shade700) : textMain,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(text: periodText),
                            if (original != null) ...[
                              const TextSpan(text: '  '),
                              TextSpan(
                                text: original,
                                style: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            if (perMonthLabel != null) ...[
                              const TextSpan(text: '   •   '),
                              TextSpan(text: perMonthLabel),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // badge (без дубля "Best value")
            if (highlight)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade400, Colors.pink.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Text(
                    original != null
                        ? l10n.percentOff(_discountPercent(pack.price, original).round())
                        : l10n.bestValue,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _discountPercent(String price, String original) {
    // Extract numeric values from price strings
    final priceNum = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    final originalNum = double.tryParse(original.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    if (originalNum == 0) return 0;
    return (1 - priceNum / originalNum) * 100;
  }

  void _logPaywallDismiss(String reason) {
    if (_dismissLogged) {
      return;
    }
    _dismissLogged = true;
    _analytics.logPaywallDismissed(
      source: widget.source,
      reason: reason,
    );
  }

  Widget _buildTrialToggle(bool isDark, AppLocalizations l10n) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final canStartTrial = subscriptionProvider.canStartTrial;
    print('🧪 DEBUG: _buildTrialToggle called - canStartTrial = $canStartTrial, _trialEnabledSwitch = $_trialEnabledSwitch');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _trialEnabledSwitch && canStartTrial
            ? LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !_trialEnabledSwitch || !canStartTrial
            ? (isDark ? const Color(0xFF12161A) : const Color(0xFFF8FAFA))
            : null,
        borderRadius: BorderRadius.circular(16),
        border: _trialEnabledSwitch && canStartTrial
            ? Border.all(color: Colors.green.shade300, width: 2)
            : null,
      ),
      child: Row(
        children: [
          if (_trialEnabledSwitch && canStartTrial) ...[
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  canStartTrial ? '7 days FREE trial' : 'Trial already used',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _trialEnabledSwitch && canStartTrial
                        ? Colors.white
                        : (isDark ? Colors.white : const Color(0xFF2D3436)),
                  ),
                ),
                if (canStartTrial)
                  Text(
                    canStartTrial ? (
                        SubscriptionService.instance.yearlyProduct != null
                        ? 'Then ${SubscriptionService.instance.yearlyProduct!.price}/year'
                        : 'Then €23.99/year'
                      ) : 'Then €23.99/year',
                    style: TextStyle(
                      fontSize: 12,
                      color: _trialEnabledSwitch
                          ? Colors.white70
                          : (isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: CupertinoSwitch(
              value: _trialEnabledSwitch && canStartTrial,
              activeColor: Colors.white,
              trackColor: canStartTrial
                  ? (_trialEnabledSwitch ? Colors.green.shade200 : Colors.grey.shade300)
                  : Colors.grey.shade400,
              onChanged: canStartTrial
                  ? (v) {
                      HapticFeedback.selectionClick();
                      setState(() => _trialEnabledSwitch = v);
                      _analytics.logPaywallTrialToggle(
                        source: widget.source,
                        enabled: v,
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 380.ms);
  }

  Widget _buildCtaButton(bool isDark, AppLocalizations l10n) {
    final disabled = _isLoading;
    return GestureDetector(
      onTap: disabled ? null : _handlePurchase,
      child: AnimatedOpacity(
        duration: 200.ms,
        opacity: disabled ? 0.6 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    _ctaText(l10n),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 450.ms).slideY();
  }

  Widget _buildAutoRenewNote(bool isDark, AppLocalizations l10n) {
    final color = isDark ? Colors.white70 : Colors.grey.shade700;
    
    // Показываем разный текст в зависимости от триала
    final text = (_showTrialSwitch && _trialEnabledSwitch) 
        ? l10n.noChargeToday 
        : l10n.cancelAnytime;
    
    return Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color, height: 1.3));
  }

  Widget _buildFeatures(bool isDark, AppLocalizations l10n) {
    final baseColor = isDark ? Colors.white : const Color(0xFF2D3436);
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;

    final all = <Map<String, dynamic>>[
      {'icon': Icons.notifications_active, 'title': l10n.smartReminders, 'desc': l10n.smartRemindersDesc},
      {'icon': Icons.analytics, 'title': l10n.weeklyReports, 'desc': l10n.weeklyReportsDesc},
      {'icon': Icons.block, 'title': l10n.proFeatureNoMoreAds, 'desc': l10n.proFeatureNoMoreAdsDescription},
      {'icon': Icons.health_and_safety, 'title': l10n.healthIntegrations, 'desc': l10n.healthIntegrationsDesc},
      {'icon': Icons.local_bar, 'title': l10n.alcoholProtocols, 'desc': l10n.alcoholProtocolsDesc},
      {'icon': Icons.sync, 'title': l10n.fullSync, 'desc': l10n.fullSyncDesc},
      {'icon': Icons.tune, 'title': l10n.personalCalibrations, 'desc': l10n.personalCalibrationsDesc},
    ];

    final visible = _showAllFeatures ? all : all.take(4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...visible.map((f) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(f['icon'] as IconData, color: Colors.cyan.shade600, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f['title'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor)),
                      const SizedBox(height: 2),
                      Text(f['desc'] as String, style: TextStyle(fontSize: 12, color: subColor, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => setState(() => _showAllFeatures = !_showAllFeatures),
          child: Text(_showAllFeatures ? l10n.showLess : l10n.showAllFeatures,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.cyanAccent : Colors.cyan.shade700)),
        ),
      ],
    );
  }

  Widget _buildPoliciesAndRestore(bool isDark, AppLocalizations l10n) {
    final linkStyle = TextStyle(
      fontSize: 11,
      color: isDark ? Colors.white70 : Colors.grey.shade700,
      decoration: TextDecoration.underline,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: _openPrivacy, child: Text(l10n.privacyPolicy, style: linkStyle)),
            Text(' • ', style: TextStyle(color: isDark ? Colors.white24 : Colors.grey.shade400)),
            TextButton(onPressed: _openTerms, child: Text(l10n.termsOfUse, style: linkStyle)),
          ],
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleRestore,
          child: Text(
            l10n.restorePurchases,
            style: TextStyle(
              fontSize: 12,
              color: _isLoading ? (isDark ? Colors.white38 : Colors.grey) : (isDark ? Colors.cyanAccent : Colors.cyan.shade700),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Actions ----------
  Future<void> _handlePurchase() async {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) return;
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    final bool trialEnabledForAnalytics = _showTrialSwitch && _trialEnabledSwitch;

    try {
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);

      // ID продукта по плану
      String productId;
      switch (_selected) {
        case Plan.lifetime:
          productId = 'hydracoach_pro_lifetime'; // отдельный one-time purchase продукт
          break;
        case Plan.annual:
          // Выбираем правильный продукт в зависимости от переключателя trial
          productId = (_showTrialSwitch && _trialEnabledSwitch)
              ? 'hydracoach_pro_yearly'
              : 'hydracoach_pro_yearly_no_trial';
          break;
        case Plan.monthly:
          productId = 'hydracoach_pro_monthly';
          break;
      }

      // Всегда инициируем покупку через Google Play
      print('🛍️ Initiating purchase for plan: ${_selected.name}');
      print('📦 Product ID: $productId');

      _analytics.logSubscriptionPurchaseAttempt(
        product: _selected.name,
        source: widget.source,
        trialEnabled: trialEnabledForAnalytics,
      );

      // Устанавливаем флаг ожидания покупки
      print('🛍️ Setting _waitingForPurchase = true for $productId');
      setState(() => _waitingForPurchase = true);

      // Инициируем покупку - результат придет через purchaseStream
      await subscriptionProvider.purchaseSubscription(productId);

      // Запускаем таймер как дополнительную защиту на случай если listener не сработает
      _startPurchaseCheckTimer();

      // Не проверяем success сразу - ждем результата из purchaseStream
      // purchaseSubscription только инициирует покупку, реальный результат асинхронный
      return; // Выходим из метода, результат обработается в _onProStatusChanged
    } catch (e) {
      if (!mounted) return;
      print('❌ Purchase error: $e');
      _analytics.logSubscriptionPurchaseResult(
        product: _selected.name,
        source: widget.source,
        success: false,
        trialEnabled: trialEnabledForAnalytics,
        error: e.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseFailed(e.toString())),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) return;
    HapticFeedback.selectionClick();
    setState(() => _isLoading = true);

    try {
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      print('🔄 Attempting to restore purchases...');
      _analytics.logSubscriptionRestoreAttempt(source: widget.source);
      final restored = await subscriptionProvider.restorePurchases();

      if (!mounted) return;

      if (restored) {
        print('✅ Purchases restored successfully!');
        _analytics.logSubscriptionRestoreResult(
          source: widget.source,
          success: true,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.proSubscriptionRestored),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _logPaywallDismiss('restore_success');
        Navigator.of(context).pop(true);
      } else {
        print('ℹ️ No purchases to restore');
        _analytics.logSubscriptionRestoreResult(
          source: widget.source,
          success: false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noPurchasesToRestore),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('❌ Restore error: $e');
      _analytics.logSubscriptionRestoreResult(
        source: widget.source,
        success: false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.restoreFailed(e.toString())),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openPrivacy() async {
    print('📄 Opening Privacy Policy...');
    final success = await UrlLauncherService.openPrivacyPolicy();

    if (!mounted) return;

    if (!success) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.linkCopiedToClipboard),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _openTerms() async {
    print('📄 Opening Terms of Service...');
    final success = await UrlLauncherService.openTermsOfService();

    if (!mounted) return;

    if (!success) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.linkCopiedToClipboard),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

}