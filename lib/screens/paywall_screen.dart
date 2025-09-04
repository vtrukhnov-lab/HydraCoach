import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/remote_config_service.dart';
import '../services/subscription_service.dart';

enum Plan { lifetime, annual, monthly }

class PricingPack {
  final Plan plan;
  final double price; // full price in USD
  final double? originalPrice; // crossed out, if any
  final String periodLabel; // e.g. "/year", "/month", "one-time"
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
  const PaywallScreen({super.key, this.showCloseButton = true});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final RemoteConfigService _rc = RemoteConfigService.instance;

  // State
  bool _isLoading = false;
  Plan _selected = Plan.annual;
  bool _trialEnabledSwitch = true;
  bool _showAllFeatures = false;

  // In production — populate from RevenueCat/StoreKit/Play Billing offerings.
  late Map<Plan, PricingPack> _pricing;

  @override
  void initState() {
    super.initState();
    _trialEnabledSwitch = _rc.trialEnabled;
    _pricing = _mockPricing(); // replace with real offerings hookup
  }

  Map<Plan, PricingPack> _mockPricing() {
    // All USD as requested.
    return {
      Plan.lifetime: const PricingPack(
        plan: Plan.lifetime,
        price: 49.99,
        periodLabel: 'one-time',
      ),
      Plan.annual: const PricingPack(
        plan: Plan.annual,
        price: 23.99, // total per year
        originalPrice: 59.99,
        periodLabel: '/year',
        isBestValue: true,
      ),
      Plan.monthly: const PricingPack(
        plan: Plan.monthly,
        price: 4.99,
        periodLabel: '/month',
      ),
    };
  }

  // ---------- Helpers ----------
  bool get _trialGloballyEnabled => _rc.paywallShowTrial;
  bool get _trialAllowedForSelectedPlan => _selected == Plan.annual;
  bool get _showTrialSwitch => _trialGloballyEnabled && _trialAllowedForSelectedPlan;

  String _formatMoney(double v) {
    // USD only (per request)
    // Show without trailing .00 if integer
    return v == v.roundToDouble() ? '\$${v.toStringAsFixed(0)}' : '\$${v.toStringAsFixed(2)}';
  }

  String _ctaText() {
    final pack = _pricing[_selected]!;
    if (_showTrialSwitch && _trialEnabledSwitch) {
      return 'Start 7-day free trial';
    }
    // Non-trial CTA (plan price with period)
    switch (_selected) {
      case Plan.annual:
        // show both total and per month
        final perMonth = pack.price / 12;
        return 'Continue — ${_formatMoney(pack.price)} / year  •  ≈ ${_formatMoney(perMonth)}/mo';
      case Plan.monthly:
        return 'Continue — ${_formatMoney(pack.price)} / month';
      case Plan.lifetime:
        return 'Unlock for ${_formatMoney(pack.price)} (one-time)';
    }
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => widget.showCloseButton, // блокируем back если нельзя закрыть
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1214) : const Color(0xFFF8FAFA),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header / Illustration
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.cyan.withOpacity(0.08) : Colors.cyan.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Text('💧', style: TextStyle(fontSize: 80))),
                          ).animate().scale(),
                          const SizedBox(height: 20),
                          Text(
                            _rc.paywallSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF2D3436),
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 8),
                          // Social proof (optional; from RC)
                          if (_rc.paywallShowTrial)
                            Text(
                              '⭐️ 4.9 — trusted by 12,000 users',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Pricing & CTA
                  Expanded(
                    flex: 3,
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
                            _buildPricingOptions(isDark),
                            const SizedBox(height: 16),
                            if (_showTrialSwitch) _buildTrialToggle(isDark),
                            const SizedBox(height: 16),
                            _buildCtaButton(isDark),
                            const SizedBox(height: 8),
                            _buildAutoRenewNote(isDark),
                            const SizedBox(height: 24),
                            _buildFeatures(isDark),
                            const SizedBox(height: 16),
                            _buildPoliciesAndRestore(isDark),
                            const SizedBox(height: 8),
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
                    onPressed: () => Navigator.of(context).pop(),
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

  // ---------- Widgets ----------
  Widget _buildPricingOptions(bool isDark) {
    final tilesBg = isDark ? const Color(0x1412FFFF) : const Color(0xFFF3F8F8);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: tilesBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _pricingTile(_pricing[Plan.lifetime]!, isDark),
          const SizedBox(height: 8),
          _pricingTile(_pricing[Plan.annual]!, isDark),
          const SizedBox(height: 8),
          _pricingTile(_pricing[Plan.monthly]!, isDark),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _pricingTile(PricingPack pack, bool isDark) {
    final isSelected = _selected == pack.plan;
    final highlight = pack.isBestValue;

    final bg = isSelected
        ? (isDark ? const Color(0xFF0E2330) : Colors.cyan.shade50)
        : (isDark ? const Color(0xFF12161A) : Colors.white);

    final borderColor = isSelected
        ? (isDark ? const Color(0xFF2FB8E9) : Colors.cyan.shade400)
        : (highlight ? (isDark ? const Color(0xFF1E7896) : Colors.cyan.shade200) : (isDark ? Colors.white10 : Colors.grey.shade200));

    final textMain = isDark ? Colors.white : const Color(0xFF2D3436);

    // computed helpers
    final original = pack.originalPrice != null ? _formatMoney(pack.originalPrice!) : null;
    final price = _formatMoney(pack.price);

    final isAnnual = pack.plan == Plan.annual;
    final perMonthLabel = isAnnual ? '≈ ${_formatMoney(pack.price / 12)}/mo' : null;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
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
                    color: (isDark ? Colors.cyanAccent.withOpacity(0.08) : Colors.cyan.withOpacity(0.15)),
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
                    border: Border.all(color: isSelected ? Colors.cyan : (isDark ? Colors.white30 : Colors.grey.shade400), width: 2),
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
                      // title
                      Text(
                        switch (pack.plan) {
                          Plan.lifetime => _rc.paywallLifetimeText.isNotEmpty ? _rc.paywallLifetimeText : 'Lifetime access',
                          Plan.annual => 'Best value — Annual',
                          Plan.monthly => 'Monthly',
                        },
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textMain),
                      ),
                      const SizedBox(height: 4),
                      // price row
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? (isDark ? Colors.cyanAccent : Colors.cyan.shade700) : textMain,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(pack.periodLabel, style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                          if (original != null) ...[
                            const SizedBox(width: 8),
                            Text(original,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                )),
                          ],
                          if (perMonthLabel != null) ...[
                            const SizedBox(width: 10),
                            Text(perMonthLabel,
                                style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // badge
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
                    original != null ? '-${_discountPercent(pack.price, pack.originalPrice!).toStringAsFixed(0)}%  Best value' : 'Best value',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _discountPercent(double price, double original) => (1 - price / original) * 100;

  Widget _buildTrialToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12161A) : const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _rc.paywallTrialText.isNotEmpty ? _rc.paywallTrialText : 'Enable 7-day free trial',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF2D3436)),
            ),
          ),
          CupertinoSwitch(
            value: _trialEnabledSwitch,
            activeColor: Colors.cyan,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _trialEnabledSwitch = v);
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 380.ms);
  }

  Widget _buildCtaButton(bool isDark) {
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
                : Text(_ctaText(), textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 450.ms).slideY();
  }

  Widget _buildAutoRenewNote(bool isDark) {
    final color = isDark ? Colors.white70 : Colors.grey.shade700;
    final isTrial = _showTrialSwitch && _trialEnabledSwitch;
    final lines = [
      if (isTrial) 'No charge today. After 7 days, your subscription renews automatically unless canceled.',
      'You can cancel anytime in Settings.',
    ];
    return Text(lines.join(' '), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color, height: 1.3));
  }

  Widget _buildFeatures(bool isDark) {
    final baseColor = isDark ? Colors.white : const Color(0xFF2D3436);
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;

    final all = <Map<String, dynamic>>[
      {'icon': Icons.notifications_active, 'title': 'Smart reminders', 'desc': 'Heat, workouts, fasting — no spam.'},
      {'icon': Icons.analytics, 'title': 'Weekly reports', 'desc': 'Deep insights + CSV export.'},
      {'icon': Icons.health_and_safety, 'title': 'Health integrations', 'desc': 'Apple Health & Google Fit.'},
      {'icon': Icons.local_bar, 'title': 'Alcohol protocols', 'desc': 'Pre-drink prep & recovery roadmap.'},
      {'icon': Icons.sync, 'title': 'Full sync', 'desc': 'Unlimited history across devices.'},
      {'icon': Icons.tune, 'title': 'Personal calibrations', 'desc': 'Sweat test, urine color scale.'},
    ];

    final visible = _showAllFeatures ? all : all.take(4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Everything in PRO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: baseColor)),
        const SizedBox(height: 14),
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
          child: Text(_showAllFeatures ? 'Show less' : 'Show all features',
              style: TextStyle(fontSize: 13, color: isDark ? Colors.cyanAccent : Colors.cyan.shade700)),
        ),
      ],
    );
  }

  Widget _buildPoliciesAndRestore(bool isDark) {
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
            TextButton(onPressed: _openPrivacy, child: Text('Privacy Policy', style: linkStyle)),
            Text(' • ', style: TextStyle(color: isDark ? Colors.white24 : Colors.grey.shade400)),
            TextButton(onPressed: _openTerms, child: Text('Terms of Use', style: linkStyle)),
          ],
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleRestore,
          child: Text('Restore purchases',
              style: TextStyle(
                fontSize: 12,
                color: _isLoading ? (isDark ? Colors.white38 : Colors.grey) : (isDark ? Colors.cyanAccent : Colors.cyan.shade700),
              )),
        ),
      ],
    );
  }

  // ---------- Actions ----------
  Future<void> _handlePurchase() async {
    if (_isLoading) return;
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    try {
      // Получаем провайдер подписки
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      
      // Определяем ID продукта на основе выбранного плана
      String productId;
      switch (_selected) {
        case Plan.lifetime:
          productId = 'lifetime_pro';
          break;
        case Plan.annual:
          productId = 'annual_pro';
          break;
        case Plan.monthly:
          productId = 'monthly_pro';
          break;
      }
      
      // ВРЕМЕННО: Используем mock покупку для тестирования
      // TODO: Заменить на реальную покупку через RevenueCat когда будет API ключ
      print('🛍️ Initiating purchase for plan: ${_selected.name}');
      print('📦 Product ID: $productId');
      
      // Активируем PRO через mock покупку
      await subscriptionProvider.mockPurchase();
      
      // В реальной версии будет:
      // final success = await subscriptionProvider.purchaseSubscription(productId);
      // if (!success) throw Exception('Purchase failed');

      if (!mounted) return;
      
      // Показываем успешный диалог
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: Icon(Icons.check_circle, size: 48, color: Colors.green.shade500),
              ),
              const SizedBox(height: 20),
              const Text('Welcome to PRO!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('All features are unlocked', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Test Mode: Using mock purchase',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PRO status will persist until app restart',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
                Navigator.of(context).pop(true); // Закрываем пейвол с результатом true
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Start using PRO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            )
          ],
        ),
      );
      
      print('✅ PRO activated successfully!');
      print('🎯 Features unlocked:');
      print('   • Smart reminders');
      print('   • Alcohol recovery protocols');
      print('   • Weekly PRO reports');
      print('   • Unlimited sync');
      
    } catch (e) {
      if (!mounted) return;
      print('❌ Purchase error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    if (_isLoading) return;
    HapticFeedback.selectionClick();
    setState(() => _isLoading = true);
    
    try {
      // Получаем провайдер подписки
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      
      print('🔄 Attempting to restore purchases...');
      
      // Пытаемся восстановить покупки
      final restored = await subscriptionProvider.restorePurchases();
      
      if (!mounted) return;
      
      if (restored) {
        print('✅ Purchases restored successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PRO subscription restored!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Закрываем пейвол если подписка восстановлена
        Navigator.of(context).pop(true);
      } else {
        print('ℹ️ No purchases to restore');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No purchases found to restore'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('❌ Restore error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restore failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openPrivacy() {
    // TODO: Открыть URL политики конфиденциальности
    print('📄 Opening Privacy Policy...');
  }

  void _openTerms() {
    // TODO: Открыть URL условий использования
    print('📄 Opening Terms of Use...');
  }
}