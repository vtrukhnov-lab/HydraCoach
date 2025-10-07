# 🎬 A/B ТЕСТИРОВАНИЕ REWARDED VIDEO ADS — HydraCoach

## 📊 ЦЕЛИ A/B ЭКСПЕРИМЕНТОВ

### Primary Metrics (Основные метрики):
- **Ad Completion Rate** (% досмотренных ads)
- **Day 7 Retention** (удержание на 7 день)
- **Free → PRO Conversion Rate** (конверсия в подписку)
- **ARPU** (средний доход с пользователя)

### Secondary Metrics (Вторичные метрики):
- Ad Request Rate (% пользователей нажавших на кнопку)
- Daily Active Users (активные пользователи)
- Session Length (длительность сессии)
- Engagement Rate (уровень вовлеченности)

---

## 🔬 ЭКСПЕРИМЕНТ #1: Placement (Расположение кнопки)

### Гипотеза:
Floating button внизу справа даст больше кликов, чем card в Settings

### Варианты:
```yaml
Control (A): floating_button
  - FAB внизу справа с 🎁 иконкой
  - Пульсирующая анимация
  - Всегда visible на главном экране

Variant B: settings_card
  - Карточка в Settings screen
  - Видна только когда юзер открывает настройки
  - Более "спокойный" UX

Variant C: after_goal
  - Показываем после достижения дневной цели
  - Popup с предложением бонуса
  - Contextual timing
```

### Метрики успеха:
- **Ad Request Rate > 20%** (control должен быть baseline)
- Variant B: ожидаем 5-10% (меньше visibility)
- Variant C: ожидаем 30-40% (contextual + motivated user)

### Firebase Remote Config:
```json
{
  "ab_rewarded_placement": {
    "control": "floating_button",
    "variantB": "settings_card",
    "variantC": "after_goal"
  }
}
```

### Код интеграции:
```dart
// lib/screens/home_screen.dart

final remoteConfig = RemoteConfigService.instance;
final placement = remoteConfig.abRewardedPlacement;

Widget _buildRewardedButton() {
  switch (placement) {
    case 'floating_button':
      return FloatingActionButton.small(
        heroTag: 'rewarded_ad',
        backgroundColor: Colors.amber,
        child: Icon(Icons.card_giftcard),
        onPressed: _showRewardedAd,
      );
    case 'settings_card':
      return SizedBox.shrink(); // Show in Settings instead
    case 'after_goal':
      return SizedBox.shrink(); // Show as dialog after goal
    default:
      return FloatingActionButton.small(...); // fallback
  }
}
```

### Analytics Events:
```dart
// Track которой вариант показан
analytics.logEvent('rewarded_button_shown', {
  'ab_variant': remoteConfig.abRewardedPlacement,
  'screen': 'home',
});

// Track клики
analytics.logEvent('rewarded_button_clicked', {
  'ab_variant': remoteConfig.abRewardedPlacement,
  'timestamp': DateTime.now().millisecondsSinceEpoch,
});
```

---

## 🔬 ЭКСПЕРИМЕНТ #2: Reward Amount (Размер награды)

### Гипотеза:
Больший reward → выше completion rate, но может снизить PRO конверсию

### Варианты:
```yaml
Control (A): 250ml water bonus
  - Стандартная награда
  - Baseline метрики

Variant B: 100ml water bonus
  - Меньшая награда
  - Ожидаем: ниже completion, но выше PRO conversion

Variant C: 500ml water bonus
  - Большая награда
  - Ожидаем: выше completion, но ниже PRO conversion
```

### Метрики успеха:
- **Optimal Balance:** High completion (>70%) + Good PRO conversion (>3%)
- Control: baseline
- Variant B: Completion -10%, PRO conversion +20%
- Variant C: Completion +15%, PRO conversion -15%

### Firebase Remote Config:
```json
{
  "ab_rewarded_reward_amount": {
    "control": 250,
    "variantB": 100,
    "variantC": 500
  }
}
```

### Код интеграции:
```dart
// lib/services/rewarded_ad_manager.dart

Future<void> applyWaterBonus() async {
  final remoteConfig = RemoteConfigService.instance;
  final bonusAmount = remoteConfig.abRewardedRewardAmount;

  await hydrationProvider.addIntake(
    'water',
    bonusAmount,
    source: 'rewarded_ad_bonus',
    name: 'Ad Reward Bonus',
  );

  // Track
  analytics.logEvent('reward_applied', {
    'ab_variant_amount': bonusAmount,
    'type': 'water_bonus',
  });
}
```

---

## 🔬 ЭКСПЕРИМЕНТ #3: Cooldown Duration (Время ожидания)

### Гипотеза:
Shorter cooldown → больше просмотров per user, но может раздражать

### Варианты:
```yaml
Control (A): 60 minutes
  - 1 час между просмотрами
  - Baseline

Variant B: 30 minutes
  - 30 минут между просмотрами
  - Ожидаем: +50% impressions, но риск ad fatigue

Variant C: 120 minutes
  - 2 часа между просмотрами
  - Ожидаем: -30% impressions, но выше quality
```

### Метрики успеха:
- **Ads per DAU:** Control ~2-3, B ~4-5, C ~1-2
- **Retention:** Не должно упасть > 5%
- **Ad Fatigue Score:** Track decline rate после 3-го просмотра

### Firebase Remote Config:
```json
{
  "ab_rewarded_cooldown_minutes": {
    "control": 60,
    "variantB": 30,
    "variantC": 120
  }
}
```

### Код интеграции:
```dart
// lib/providers/rewarded_ad_provider.dart

Duration get cooldownDuration {
  final remoteConfig = RemoteConfigService.instance;
  final minutes = remoteConfig.abRewardedCooldownMinutes;
  return Duration(minutes: minutes);
}

bool canShowAd() {
  if (_lastAdShown == null) return true;
  final elapsed = DateTime.now().difference(_lastAdShown!);
  return elapsed >= cooldownDuration;
}
```

---

## 🔬 ЭКСПЕРИМЕНТ #4: Daily Limit (Лимит в день)

### Гипотеза:
Higher limit → больше revenue, но может каннибализировать PRO subscriptions

### Варианты:
```yaml
Control (A): 5 ads/day
  - Стандартный лимит
  - Baseline

Variant B: 3 ads/day
  - Более строгий лимит
  - Ожидаем: быстрее упрутся в лимит → больше PRO conversions

Variant C: 10 ads/day
  - Unlimited-like experience
  - Ожидаем: больше ad revenue, но меньше PRO conversions
```

### Метрики успеха:
- **Total Revenue per User:** Ads revenue + Subscription revenue
- Control: $0.20 ARPU
- Variant B: $0.15 ads + $0.10 subs = $0.25 total
- Variant C: $0.30 ads + $0.05 subs = $0.35 total

### Firebase Remote Config:
```json
{
  "ab_rewarded_daily_limit": {
    "control": 5,
    "variantB": 3,
    "variantC": 10
  }
}
```

---

## 🔬 ЭКСПЕРИМЕНТ #5: Button Copy (Текст кнопки)

### Гипотеза:
Action-oriented copy ("Watch & Earn") > Generic copy ("Get Bonus")

### Варианты:
```yaml
Control (A): "watch_earn"
  RU: "🎬 Смотреть и заработать"
  EN: "🎬 Watch & Earn"

Variant B: "get_bonus"
  RU: "🎁 Получить бонус"
  EN: "🎁 Get Bonus"

Variant C: "unlock_reward"
  RU: "⭐ Разблокировать награду"
  EN: "⭐ Unlock Reward"
```

### Метрики успеха:
- **Click-through Rate (CTR):** Control должен быть baseline
- Ожидаем: A ~25%, B ~20%, C ~30%

### Firebase Remote Config:
```json
{
  "ab_rewarded_button_text": {
    "control": "watch_earn",
    "variantB": "get_bonus",
    "variantC": "unlock_reward"
  }
}
```

### Код интеграции:
```dart
// lib/widgets/rewarded_ad_button.dart

String _getButtonText(BuildContext context) {
  final remoteConfig = RemoteConfigService.instance;
  final variant = remoteConfig.abRewardedButtonText;
  final l10n = AppLocalizations.of(context);

  switch (variant) {
    case 'watch_earn':
      return '🎬 ${l10n.watchAndEarn}';
    case 'get_bonus':
      return '🎁 ${l10n.getBonus}';
    case 'unlock_reward':
      return '⭐ ${l10n.unlockReward}';
    default:
      return '🎬 ${l10n.watchAndEarn}';
  }
}
```

---

## 🔬 ЭКСПЕРИМЕНТ #6: Success Animation (Анимация успеха)

### Гипотеза:
Confetti анимация → выше perceived value, больше повторных просмотров

### Варианты:
```yaml
Control (A): "confetti"
  - Full-screen конфетти
  - 2.5 секунды показ
  - Celebratory feel

Variant B: "simple"
  - Простой checkmark fade in/out
  - 1 секунда показ
  - Minimalist

Variant C: "celebration"
  - Confetti + звук + haptic feedback
  - 3 секунды показ
  - Maximum celebration
```

### Метрики успеха:
- **Repeat Ad Watch Rate:** % пользователей смотрящих >1 ad в день
- Control: 40%
- Variant B: 30% (less exciting)
- Variant C: 50% (most rewarding)

### Firebase Remote Config:
```json
{
  "ab_rewarded_animation": {
    "control": "confetti",
    "variantB": "simple",
    "variantC": "celebration"
  }
}
```

### Код интеграции:
```dart
// lib/widgets/reward_success_overlay.dart

void _showSuccessAnimation() {
  final remoteConfig = RemoteConfigService.instance;
  final animation = remoteConfig.abRewardedAnimation;

  switch (animation) {
    case 'confetti':
      _confettiController.play();
      Future.delayed(Duration(milliseconds: 2500), () => Navigator.pop(context));
      break;
    case 'simple':
      // Just show checkmark
      Future.delayed(Duration(milliseconds: 1000), () => Navigator.pop(context));
      break;
    case 'celebration':
      _confettiController.play();
      HapticFeedback.heavyImpact();
      // Play success sound
      Future.delayed(Duration(milliseconds: 3000), () => Navigator.pop(context));
      break;
  }
}
```

---

## 📊 АНАЛИТИКА ДЛЯ A/B ТЕСТОВ

### События для трекинга:

```dart
// lib/services/analytics_service.dart

// 1. User assigned to variant
Future<void> logABVariantAssigned({
  required String experimentName,
  required String variantName,
}) async {
  await logEvent('ab_variant_assigned', {
    'experiment': experimentName,
    'variant': variantName,
  });
}

// 2. Ad impression с вариантом
Future<void> logRewardedAdShown({
  required String placement,
  required int rewardAmount,
  required int cooldownMinutes,
  required int dailyLimit,
}) async {
  await logEvent('rewarded_ad_shown', {
    'ab_placement': placement,
    'ab_reward_amount': rewardAmount,
    'ab_cooldown': cooldownMinutes,
    'ab_daily_limit': dailyLimit,
  });
}

// 3. Ad completed с вариантом
Future<void> logRewardedAdCompleted({
  required String animationType,
  required int watchTimeSeconds,
}) async {
  await logEvent('rewarded_ad_completed', {
    'ab_animation': animationType,
    'watch_time_sec': watchTimeSeconds,
  });
}

// 4. PRO purchase с историей ads
Future<void> logPurchaseWithAdHistory({
  required String productId,
  required int totalAdsWatched,
  required int daysWithAds,
}) async {
  await logEvent('purchase_completed', {
    'product_id': productId,
    'ads_watched_before_purchase': totalAdsWatched,
    'days_using_ads': daysWithAds,
  });
}
```

### User Properties для сегментации:

```dart
// Устанавливаем user property при первом показе ad
analytics.setUserProperty(
  name: 'rewarded_ads_user',
  value: 'true',
);

// Трекаем вариант эксперимента
analytics.setUserProperty(
  name: 'ab_rewarded_placement',
  value: remoteConfig.abRewardedPlacement,
);

analytics.setUserProperty(
  name: 'ab_rewarded_amount',
  value: remoteConfig.abRewardedRewardAmount.toString(),
);
```

---

## 🎯 ПРИОРИТИЗАЦИЯ ЭКСПЕРИМЕНТОВ

### Phase 1 (First 2 weeks):
1. **Experiment #1: Placement** ← START HERE
   - Самый высокий impact
   - Быстрые результаты (3-5 дней)
   - Определит baseline metrics

2. **Experiment #2: Reward Amount**
   - Критично для баланса ads vs PRO
   - Нужно 7 дней данных

### Phase 2 (Weeks 3-4):
3. **Experiment #4: Daily Limit**
   - После того как знаем оптимальный reward
   - Баланс revenue vs user experience

4. **Experiment #5: Button Copy**
   - Quick win, low risk
   - Может дать +5-10% CTR

### Phase 3 (Month 2):
5. **Experiment #3: Cooldown Duration**
   - Оптимизация frequency
   - Нужно много данных для анализа ad fatigue

6. **Experiment #6: Success Animation**
   - Polish UX
   - Влияние на retention

---

## 🔧 FIREBASE REMOTE CONFIG SETUP

### Создание экспериментов в Firebase Console:

1. **Перейти в Firebase Console → Remote Config**
2. **Создать параметры:**
   ```
   ab_rewarded_placement: String
   ab_rewarded_reward_amount: Number
   ab_rewarded_cooldown_minutes: Number
   ab_rewarded_daily_limit: Number
   ab_rewarded_button_text: String
   ab_rewarded_animation: String
   ```

3. **Создать A/B эксперимент:**
   - Name: "Rewarded Ads Placement Test"
   - Target: 100% of users (control 33% / B 33% / C 34%)
   - Goal: Maximize `rewarded_ad_completed` event
   - Duration: 14 days

4. **Настроить варианты:**
   ```yaml
   Control A:
     ab_rewarded_placement: "floating_button"

   Variant B:
     ab_rewarded_placement: "settings_card"

   Variant C:
     ab_rewarded_placement: "after_goal"
   ```

---

## 📈 DASHBOARD ДЛЯ МОНИТОРИНГА

### Google Analytics (Firebase Analytics) Dashboards:

**Dashboard #1: Ad Performance Overview**
- Ad Request Rate (by variant)
- Completion Rate (by variant)
- Revenue per User (by variant)
- Daily Active Ad Watchers

**Dashboard #2: Conversion Funnel**
```
100% Users Active
  ↓
XX% See Rewarded Button
  ↓
XX% Tap Button (CTR)
  ↓
XX% Watch Ad (Load Success)
  ↓
XX% Complete Ad (Completion Rate)
  ↓
XX% Convert to PRO (within 7 days)
```

**Dashboard #3: A/B Test Results**
- Per-variant metrics comparison
- Statistical significance (p-value < 0.05)
- Confidence intervals
- Winner declaration

### Custom Events для Dashboard:

```dart
// Funnel tracking
analytics.logEvent('rewarded_funnel_button_seen');
analytics.logEvent('rewarded_funnel_button_tapped');
analytics.logEvent('rewarded_funnel_ad_loading');
analytics.logEvent('rewarded_funnel_ad_shown');
analytics.logEvent('rewarded_funnel_ad_completed');
analytics.logEvent('rewarded_funnel_reward_applied');
```

---

## ✅ SUCCESS CRITERIA

### Для запуска в production:

**Minimum Requirements:**
- ✅ Completion Rate > 60%
- ✅ Day 7 Retention не упала > 3%
- ✅ ARPU увеличился минимум на $0.05
- ✅ No increase in crashes/ANRs

**Winning Variant Criteria:**
- Statistical significance: p-value < 0.05
- Sample size: минимум 1000 users per variant
- Duration: минимум 7 дней данных
- Revenue lift: минимум +10% vs control

---

## 🚀 ROLLOUT PLAN

### Week 1-2:
- ✅ Deploy code with Remote Config integration
- ✅ Test all variants manually
- ✅ Launch Experiment #1 (Placement) to 100% users

### Week 3-4:
- ✅ Analyze Experiment #1 results
- ✅ Pick winner, rollout to 100%
- ✅ Launch Experiment #2 (Reward Amount)

### Month 2:
- ✅ Continue iterating through experiments
- ✅ Optimize based on learnings
- ✅ Scale winner variants

### Month 3+:
- ✅ Ongoing optimization
- ✅ Seasonal adjustments
- ✅ New experiment ideas based on data

---

Готов к настройке в Firebase Console! 🚀
