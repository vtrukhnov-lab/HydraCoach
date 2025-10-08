# DevToDev Ad Revenue Integration

## Обзор

DevToDev поддерживает отслеживание рекламного дохода через метод `adImpression()`. Этот документ описывает как интегрировать ad revenue tracking в HydraCoach.

## ⚠️ Важное предупреждение

**НЕ используйте SDK метод `adImpression()` если у вас настроена S2S (Server-to-Server) интеграция с рекламной сетью!**

Рекламные сети с S2S интеграцией:
- AppLovin MAX
- ironSource
- Fyber (Digital Turbine)

Для этих сетей данные о доходах автоматически передаются напрямую в DevToDev через серверную интеграцию. Использование SDK метода приведет к дублированию данных.

## Реализованные методы

### Flutter (devtodev_analytics_service.dart)

```dart
await _devToDev.adImpression(
  network: 'AppLovin',        // Название рекламной сети
  revenue: 0.45,              // Доход в USD
  placement: 'MainScreen',    // Место размещения
  unit: 'banner_main_bottom', // Ad Unit ID
);
```

### Android (DevToDevMethodHandler.kt)

Метод `adImpression` реализован через reflection API для работы с DevToDev SDK:

```kotlin
DTDAnalytics.INSTANCE.adImpression(
    network = "AppLovin",
    revenue = 0.45,
    placement = "MainScreen",
    unit = "banner_main_bottom"
)
```

## Интеграция с AppLovin MAX

Когда AppLovin MAX SDK будет полностью реализован, нужно добавить ad revenue callbacks.

### Шаг 1: Создать MaxSdkMethodHandler.kt

```kotlin
package com.playcus.hydracoach

import android.content.Context
import android.util.Log
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdRevenueListener
import com.applovin.mediation.MaxReward
import com.applovin.mediation.MaxRewardedAdListener
import com.applovin.mediation.ads.MaxInterstitialAd
import com.applovin.mediation.ads.MaxRewardedAd
import com.applovin.sdk.AppLovinSdk
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MaxSdkMethodHandler(
    private val context: Context,
    private val devToDevHandler: DevToDevMethodHandler
) : MaxAdRevenueListener {

    private val TAG = "MaxSdkMethodHandler"
    private lateinit var interstitialAd: MaxInterstitialAd
    private lateinit var rewardedAd: MaxRewardedAd

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "loadInterstitial" -> loadInterstitial(call, result)
            "showInterstitial" -> showInterstitial(result)
            "loadRewarded" -> loadRewarded(call, result)
            "showRewarded" -> showRewarded(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: MethodChannel.Result) {
        val sdkKey = call.argument<String>("sdkKey") ?: ""

        AppLovinSdk.getInstance(context).apply {
            mediationProvider = "max"
            initializeSdk {
                Log.d(TAG, "AppLovin MAX SDK initialized")
            }
        }

        result.success(null)
    }

    // MaxAdRevenueListener implementation
    override fun onAdRevenuePaid(ad: MaxAd) {
        val revenue = ad.revenue
        val networkName = ad.networkName
        val adUnitId = ad.adUnitId
        val placement = ad.placement ?: "default"

        Log.d(TAG, "Ad Revenue: $$revenue from $networkName ($adUnitId)")

        // ВАЖНО: Для AppLovin MAX с S2S интеграцией НЕ вызывайте этот метод!
        // Раскомментируйте только если S2S НЕ настроен:

        // devToDevHandler.logAdRevenue(
        //     network = networkName,
        //     revenue = revenue,
        //     placement = placement,
        //     unit = adUnitId
        // )
    }

    // ... остальные методы для загрузки и показа рекламы
}
```

### Шаг 2: Добавить метод в DevToDevMethodHandler

```kotlin
fun logAdRevenue(network: String, revenue: Double, placement: String, unit: String) {
    try {
        val clazz = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalytics")
        val instance = clazz.getDeclaredField("INSTANCE").get(null)

        val method = clazz.getDeclaredMethod(
            "adImpression",
            String::class.java,
            Double::class.java,
            String::class.java,
            String::class.java
        )
        method.invoke(instance, network, revenue, placement, unit)
        Log.d(TAG, "DevToDev ad impression logged: $network, $$revenue")
    } catch (e: Exception) {
        Log.w(TAG, "Failed to log ad impression: ${e.message}")
    }
}
```

### Шаг 3: Зарегистрировать handler в MainActivity

```kotlin
class MainActivity: FlutterActivity() {
    private lateinit var devToDevHandler: DevToDevMethodHandler
    private lateinit var maxSdkHandler: MaxSdkMethodHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        devToDevHandler = DevToDevMethodHandler(this)
        maxSdkHandler = MaxSdkMethodHandler(this, devToDevHandler)

        // Регистрация MAX SDK channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "max_sdk"
        ).setMethodCallHandler { call, result ->
            maxSdkHandler.handle(call, result)
        }

        // ... остальные каналы
    }
}
```

### Шаг 4: Использование в Flutter

```dart
class MaxSdkService {
  // ... существующий код

  Future<void> _setupAdRevenueTracking() async {
    // Ad revenue автоматически отслеживается через native callbacks
    // и передается в DevToDev через MaxAdRevenueListener
  }
}
```

## S2S интеграция (рекомендуется)

Для AppLovin MAX рекомендуется использовать S2S интеграцию вместо SDK метода:

1. **Зайдите в AppLovin MAX Dashboard**
   - Settings → Ad Revenue Postbacks

2. **Добавьте DevToDev Postback URL**
   - URL: `https://statgw.devtodev.com/applovin/api?apikey=YOUR_API_KEY`
   - Замените `YOUR_API_KEY` на ваш DevToDev API ключ

3. **Настройте параметры**
   - AppLovin автоматически отправит данные о доходах в DevToDev
   - НЕ используйте SDK метод `adImpression()` при S2S интеграции

## Статус реализации

- ✅ DevToDev Flutter метод `adImpression()` реализован
- ✅ Android native метод `adImpression()` реализован
- ✅ AppLovin MAX SDK интегрирован (Flutter пакет applovin_max ^4.5.2)
- ✅ AppLovin MAX ad revenue callbacks реализованы (AdBannerCard, AdMrecCard)
- ⚠️ S2S интеграция (рекомендуется настроить в AppLovin Dashboard)

## Текущая реализация в проекте

### AdBannerCard (lib/widgets/home/ad_banner_card.dart:69-74)

```dart
devToDev.adImpression(
  network: ad.networkName,       // Название медиации сети (AdMob, Meta, etc.)
  revenue: ad.revenue,            // Доход в USD
  placement: ad.placement ?? 'banner_default',
  unit: ad.adUnitId,             // 93ba29d40d0c9ed1
);
```

### AdMrecCard (lib/widgets/home/ad_mrec_card.dart:97-102)

```dart
devToDev.adImpression(
  network: ad.networkName,
  revenue: ad.revenue,
  placement: ad.placement ?? 'mrec_default',
  unit: ad.adUnitId,             // 356d0deda25f54dd
);
```

**Где размещены баннеры:** 10+ экранов (Home, History, Daily History, Electrolytes, Food Catalog, Alcohol Log, Sports, Supplements, Liquids Catalog, Hot Drinks)

## Проверка работы

### В логах Android (adb logcat):

```
D/DevToDevMethodHandler: Logging ad impression: network=AppLovin, revenue=0.45, placement=MainScreen, unit=banner_main
D/DevToDevMethodHandler: DevToDev ad impression logged successfully
```

### В DevToDev Dashboard:

1. Перейдите в Reports → Monetization → Ad Revenue
2. Проверьте данные по рекламным сетям
3. Убедитесь, что нет дублирования (если используете S2S)

## Troubleshooting

**Дублирование данных:**
- Убедитесь, что не используете одновременно S2S и SDK метод
- Отключите один из способов интеграции

**Данные не приходят:**
- Проверьте логи Android на наличие ошибок
- Убедитесь, что DevToDev инициализирован до вызова `adImpression()`
- Проверьте, что AppLovin MAX SDK правильно настроен

**Неверные суммы дохода:**
- AppLovin MAX передает доход в USD
- Убедитесь, что не конвертируете валюту дважды
