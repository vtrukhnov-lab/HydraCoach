// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ハイドロコーチ';

  @override
  String get getPro => 'PROを取得';

  @override
  String get sunday => '日曜日';

  @override
  String get monday => '月曜日';

  @override
  String get tuesday => '火曜日';

  @override
  String get wednesday => '水曜日';

  @override
  String get thursday => '木曜日';

  @override
  String get friday => '金曜日';

  @override
  String get saturday => '土曜日';

  @override
  String get january => '1月';

  @override
  String get february => '2月';

  @override
  String get march => '3月';

  @override
  String get april => '4月';

  @override
  String get may => '5月';

  @override
  String get june => '6月';

  @override
  String get july => '7月';

  @override
  String get august => '8月';

  @override
  String get september => '9月';

  @override
  String get october => '10月';

  @override
  String get november => '11月';

  @override
  String get december => '12月';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday、$day日 $month';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get loadingWeather => '天気を読み込んでいます...';

  @override
  String get heatIndex => '熱中症指数';

  @override
  String humidity(int value) {
    return '湿度';
  }

  @override
  String get water => '水';

  @override
  String get liquids => '飲料';

  @override
  String get sodium => 'ナトリウム';

  @override
  String get potassium => 'カリウム';

  @override
  String get magnesium => 'マグネシウム';

  @override
  String get electrolyte => '電解質';

  @override
  String get broth => 'スープ';

  @override
  String get coffee => 'コーヒー';

  @override
  String get alcohol => 'アルコール';

  @override
  String get drink => '飲み物';

  @override
  String get ml => 'ml';

  @override
  String get mg => 'mg';

  @override
  String get kg => 'kg';

  @override
  String valueWithUnit(int value, String unit) {
    return '$value $unit';
  }

  @override
  String goalFormat(int current, int goal, String unit) {
    return '$current/$goal $unit';
  }

  @override
  String heatAdjustment(int percent) {
    return '暑さ +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'アルコール +$amount ml';
  }

  @override
  String get smartAdviceTitle => '現在のアドバイス';

  @override
  String get smartAdviceDefault => '水と電解質のバランスを保ちましょう。';

  @override
  String get adviceOverhydrationSevere => '水の過剰摂取（目標の200％以上）';

  @override
  String get adviceOverhydrationSevereBody =>
      '60-90分間休止してください。電解質を追加：300-500 mlに500-1000 mgのナトリウムを加えてください。';

  @override
  String get adviceOverhydration => '水の過剰摂取';

  @override
  String get adviceOverhydrationBody =>
      '30-60分間水を控え、約500 mgのナトリウム（電解質/スープ）を追加してください。';

  @override
  String get adviceAlcoholRecovery => 'アルコール：回復';

  @override
  String get adviceAlcoholRecoveryBody =>
      '今日はこれ以上アルコールを控えてください。少量ずつ300-500 mlの水を飲み、ナトリウムを追加してください。';

  @override
  String get adviceLowSodium => '低ナトリウム';

  @override
  String adviceLowSodiumBody(int amount) {
    return '約$amount mgのナトリウムを追加してください。適度に飲んでください。';
  }

  @override
  String get adviceDehydration => '水分不足';

  @override
  String adviceDehydrationBody(String type) {
    return '300-500 ml の$typeを飲んでください。';
  }

  @override
  String get adviceHighRisk => '高リスク（HRI）';

  @override
  String get adviceHighRiskBody => '至急、水と電解質を（300-500 ml）飲み、活動を減らしてください。';

  @override
  String get adviceHeat => '暑さと失水';

  @override
  String get adviceHeatBody => '水分を5-8％増やし、300-500 mgのナトリウムを追加してください。';

  @override
  String get adviceAllGood => '順調です';

  @override
  String adviceAllGoodBody(int amount) {
    return 'このペースを保ってください。目標まであと約$amount mlです。';
  }

  @override
  String get hydrationStatus => '水分状態';

  @override
  String get hydrationStatusNormal => '正常';

  @override
  String get hydrationStatusDiluted => '薄い';

  @override
  String get hydrationStatusDehydrated => '不足';

  @override
  String get hydrationStatusLowSalt => '塩分不足';

  @override
  String get hydrationRiskIndex => '水分リスク指数';

  @override
  String get quickAdd => 'クイック追加';

  @override
  String get add => '追加';

  @override
  String get delete => '削除';

  @override
  String get todaysDrinks => '今日の飲み物';

  @override
  String get allRecords => '全記録 →';

  @override
  String itemDeleted(String item) {
    return '$item を削除';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get dailyReportReady => '日報準備完了！';

  @override
  String get viewDayResults => '結果を見る';

  @override
  String get dailyReportComingSoon => '日報は次版で利用可能';

  @override
  String get home => 'ホーム';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get reset => 'リセット';

  @override
  String get settingsTitle => '設定';

  @override
  String get languageSection => '言語';

  @override
  String get languageSettings => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get profileSection => 'プロフィール';

  @override
  String get weight => '重量';

  @override
  String get dietMode => '食事モード';

  @override
  String get activityLevel => '活動レベル';

  @override
  String get changeWeight => '体重を変更';

  @override
  String get dietModeNormal => '通常食';

  @override
  String get dietModeKeto => 'ケト/低炭水化物';

  @override
  String get dietModeFasting => '断続的断食';

  @override
  String get activityLow => '低活動';

  @override
  String get activityMedium => '中活動';

  @override
  String get activityHigh => '高活動';

  @override
  String get activityLowDesc => 'デスクワーク、少ない運動';

  @override
  String get activityMediumDesc => '30-60分/日の運動';

  @override
  String get activityHighDesc => '1時間以上の運動';

  @override
  String get notificationsSection => '通知';

  @override
  String get notificationLimit => '通知制限 (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return '使用: $used/$limit';
  }

  @override
  String get waterReminders => '水分リマインダー';

  @override
  String get waterRemindersDesc => '1日を通じた定期リマインダー';

  @override
  String get reminderFrequency => '頻度';

  @override
  String timesPerDay(int count) {
    return '1日$count回';
  }

  @override
  String maxTimesPerDay(int count) {
    return '1日$count回 (最大4)';
  }

  @override
  String get unlimitedReminders => '無制限';

  @override
  String get startOfDay => '開始時刻';

  @override
  String get endOfDay => '終了時刻';

  @override
  String get postCoffeeReminders => 'コーヒー後';

  @override
  String get postCoffeeRemindersDesc => '20分後に水分補給を通知';

  @override
  String get heatWarnings => '暑熱警告';

  @override
  String get heatWarningsDesc => '高温時の通知';

  @override
  String get postAlcoholReminders => '飲酒後';

  @override
  String get postAlcoholRemindersDesc => '6-12時間の回復計画';

  @override
  String get proFeaturesSection => 'PRO機能';

  @override
  String get unlockPro => 'PROを解除';

  @override
  String get unlockProDesc => '無制限の通知とスマートリマインダー';

  @override
  String get noNotificationLimit => '通知制限なし';

  @override
  String get unitsSection => '単位';

  @override
  String get metricSystem => 'メートル法';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'ヤード・ポンド法';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => 'について';

  @override
  String get version => 'バージョン';

  @override
  String get rateApp => '評価する';

  @override
  String get share => '共有';

  @override
  String get privacyPolicy => 'プライバシー';

  @override
  String get termsOfUse => '利用規約';

  @override
  String get resetAllData => '全データ削除';

  @override
  String get resetDataTitle => '全データを削除？';

  @override
  String get resetDataMessage => '履歴を削除し設定をリセットします。';

  @override
  String get back => '戻る';

  @override
  String get next => '次へ';

  @override
  String get start => '開始';

  @override
  String get welcomeTitle => 'HydroCoachへ\nようこそ';

  @override
  String get welcomeSubtitle => 'ケト、断食、活動的な\n生活のための水分と電解質管理';

  @override
  String get weightPageTitle => '体重';

  @override
  String get weightPageSubtitle => '最適な水分量を計算';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return '推奨: 1日$min-$max ml';
  }

  @override
  String get dietPageTitle => '食事モード';

  @override
  String get dietPageSubtitle => '電解質の必要量に影響';

  @override
  String get normalDiet => '通常食';

  @override
  String get normalDietDesc => '標準推奨';

  @override
  String get ketoDiet => 'ケト/低炭水化物';

  @override
  String get ketoDietDesc => '塩分必要量増加';

  @override
  String get fastingDiet => '断続的断食';

  @override
  String get fastingDietDesc => '特別な電解質管理';

  @override
  String get fastingSchedule => '断食スケジュール:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => '8時間の食事時間';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => '1日1食';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => '隔日断食';

  @override
  String get activityPageTitle => '活動レベル';

  @override
  String get activityPageSubtitle => '水分必要量に影響';

  @override
  String get lowActivity => '低活動';

  @override
  String get lowActivityDesc => 'デスクワーク、少ない運動';

  @override
  String get lowActivityWater => '+0 ml';

  @override
  String get mediumActivity => '中活動';

  @override
  String get mediumActivityDesc => '30-60分/日の運動';

  @override
  String get mediumActivityWater => '+350-700 ml';

  @override
  String get highActivity => '高活動';

  @override
  String get highActivityDesc => '1時間以上の運動';

  @override
  String get highActivityWater => '+700-1200 ml';

  @override
  String get activityAdjustmentNote => '運動に基づき目標を調整';

  @override
  String get day => '日';

  @override
  String get week => '週';

  @override
  String get month => '月';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get noData => 'データなし';

  @override
  String get noRecordsToday => '今日の記録なし';

  @override
  String get noRecordsThisDay => 'この日の記録なし';

  @override
  String get loadingData => '読込中...';

  @override
  String get deleteRecord => '記録を削除？';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '$type $volume ml を削除？';
  }

  @override
  String get recordDeleted => '削除完了';

  @override
  String get waterConsumption => '💧 水分摂取';

  @override
  String get alcoholWeek => '🍺 今週の飲酒';

  @override
  String get electrolytes => '⚡ 電解質';

  @override
  String get weeklyAverages => '📊 週平均';

  @override
  String get monthStatistics => '📊 月統計';

  @override
  String get alcoholStatistics => '🍺 飲酒統計';

  @override
  String get alcoholStatisticsTitle => '飲酒統計';

  @override
  String get weeklyInsights => '💡 週の洞察';

  @override
  String get waterPerDay => '1日の水分';

  @override
  String get sodiumPerDay => '1日のNa';

  @override
  String get potassiumPerDay => '1日のK';

  @override
  String get magnesiumPerDay => '1日のMg';

  @override
  String get goal => '目標';

  @override
  String get daysWithGoalAchieved => '✅ 達成日数';

  @override
  String get recordsPerDay => '📝 記録/日';

  @override
  String get insufficientDataForAnalysis => '分析データ不足';

  @override
  String get totalVolume => '総量';

  @override
  String averagePerDay(int amount) {
    return '平均 $amount ml/日';
  }

  @override
  String get activeDays => '活動日';

  @override
  String perfectDays(int count) {
    return '$count日';
  }

  @override
  String currentStreak(int days) {
    return '連続: $days日';
  }

  @override
  String soberDaysRow(int days) {
    return '連続休酒: $days日';
  }

  @override
  String get keepItUp => '続けよう！';

  @override
  String waterAmount(int amount, int percent) {
    return '水: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return '飲酒: $amount SD';
  }

  @override
  String get totalSD => '総SD';

  @override
  String get forMonth => '月間';

  @override
  String get daysWithAlcohol => '飲酒日';

  @override
  String fromDays(int days) {
    return '$days日中';
  }

  @override
  String get soberDays => '休酒日';

  @override
  String get excellent => '素晴らしい！';

  @override
  String get averageSD => '平均SD';

  @override
  String get inDrinkingDays => '飲酒日';

  @override
  String get bestDay => '🏆 最高の日';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent%';
  }

  @override
  String get weekends => '📅 週末';

  @override
  String get weekdays => '📅 平日';

  @override
  String drinkLessOnWeekends(int percent) {
    return '週末は$percent%少ない';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return '平日は$percent%少ない';
  }

  @override
  String get positiveTrend => '📈 良好傾向';

  @override
  String get positiveTrendMessage => '水分摂取が週末に向上';

  @override
  String get decliningActivity => '📉 減少傾向';

  @override
  String get decliningActivityMessage => '週末に水分摂取が減少';

  @override
  String get lowSalt => '⚠️ 塩分不足';

  @override
  String lowSaltMessage(int days) {
    return '$days日のみ正常なNaレベル';
  }

  @override
  String get frequentAlcohol => '🍺 頻繁な飲酒';

  @override
  String frequentAlcoholMessage(int days) {
    return '7日中$days日の飲酒は水分に影響';
  }

  @override
  String get excellentWeek => '✅ 素晴らしい週';

  @override
  String get continueMessage => '続けましょう！';

  @override
  String get all => '全て';

  @override
  String get addAlcohol => '飲酒を追加';

  @override
  String get minimumHarm => '最小限の害';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml必要';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg Na追加';
  }

  @override
  String get goToBedEarly => '早く就寝';

  @override
  String get todayConsumed => '今日の摂取:';

  @override
  String get alcoholToday => '今日の飲酒';

  @override
  String get beer => 'ビール';

  @override
  String get wine => 'ワイン';

  @override
  String get spirits => 'スピリッツ';

  @override
  String get cocktail => 'カクテル';

  @override
  String get selectDrinkType => '種類を選択:';

  @override
  String get volume => '量';

  @override
  String get enterVolume => 'ml を入力';

  @override
  String get strength => '筋力';

  @override
  String get standardDrinks => '標準ドリンク:';

  @override
  String get additionalWater => '追加水分';

  @override
  String get additionalSodium => '追加Na';

  @override
  String get hriRisk => 'HRIリスク';

  @override
  String get enterValidVolume => '有効な量を入力';

  @override
  String get weeklyHistory => '週履歴';

  @override
  String get weeklyHistoryDesc => '週の傾向分析と洞察';

  @override
  String get monthlyHistory => '月履歴';

  @override
  String get monthlyHistoryDesc => '長期パターンと詳細分析';

  @override
  String get proFunction => 'PRO機能';

  @override
  String get unlockProHistory => 'PROを解除';

  @override
  String get unlimitedHistory => '無制限履歴';

  @override
  String get dataExportCSV => 'CSV出力';

  @override
  String get detailedAnalytics => '詳細分析';

  @override
  String get periodComparison => '期間比較';

  @override
  String get shareResult => '結果を共有';

  @override
  String get retry => '再試行';

  @override
  String get welcomeToPro => 'PROへようこそ！';

  @override
  String get allFeaturesUnlocked => '全機能が解除されました';

  @override
  String get testMode => 'テストモード: モック購入';

  @override
  String get proStatusNote => 'PROステータスはアプリ再起動まで継続';

  @override
  String get startUsingPro => 'PROを使い始める';

  @override
  String get lifetimeAccess => '永久アクセス';

  @override
  String get bestValueAnnual => '最高の価値 — 年額';

  @override
  String get monthly => '月額';

  @override
  String get oneTime => '1回';

  @override
  String get perYear => '/年';

  @override
  String get perMonth => '/月';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/月';
  }

  @override
  String get startFreeTrial => '7日間無料';

  @override
  String continueWithPrice(String price) {
    return '続行 — $price';
  }

  @override
  String unlockForPrice(String price) {
    return '$priceで解除 (1回)';
  }

  @override
  String get enableFreeTrial => '7日間無料を有効';

  @override
  String get noChargeToday => '今日は請求なし。7日後にキャンセルしない限り自動更新。';

  @override
  String get cancelAnytime => 'いつでも設定からキャンセル可能。';

  @override
  String get everythingInPro => 'PROの全機能';

  @override
  String get smartReminders => 'スマートリマインダー';

  @override
  String get smartRemindersDesc => '暑さ、運動、断食 — スパムなし。';

  @override
  String get weeklyReports => '週次レポート';

  @override
  String get weeklyReportsDesc => '深い洞察 + CSV出力。';

  @override
  String get healthIntegrations => 'ヘルス連携';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit。';

  @override
  String get alcoholProtocols => '飲酒プロトコル';

  @override
  String get alcoholProtocolsDesc => '事前準備と回復ロードマップ。';

  @override
  String get fullSync => '完全同期';

  @override
  String get fullSyncDesc => 'デバイス間で無制限履歴。';

  @override
  String get personalCalibrations => '個人調整';

  @override
  String get personalCalibrationsDesc => '発汗テスト、尿色スケール。';

  @override
  String get showAllFeatures => '全機能を表示';

  @override
  String get showLess => '少なく表示';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get proSubscriptionRestored => 'PRO復元完了！';

  @override
  String get noPurchasesToRestore => '復元する購入なし';

  @override
  String get drinkMoreWaterToday => '今日は水を多く (+20%)';

  @override
  String get addElectrolytesToWater => '各水分に電解質追加';

  @override
  String get limitCoffeeOneCup => 'コーヒーを1杯に制限';

  @override
  String get increaseWater10 => '水を10%増加';

  @override
  String get dontForgetElectrolytes => '電解質を忘れずに';

  @override
  String get startDayWithWater => '朝の水で1日を開始';

  @override
  String get dontForgetElectrolytesReminder => '⚡ 電解質を忘れずに';

  @override
  String get startDayWithWaterReminder => '朝の水で良好な健康';

  @override
  String get takeElectrolytesMorning => '朝に電解質を摂取';

  @override
  String purchaseFailed(String error) {
    return '購入失敗: $error';
  }

  @override
  String restoreFailed(String error) {
    return '復元失敗: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — 12,000人が信頼';

  @override
  String get bestValue => '最高の価値';

  @override
  String percentOff(int percent) {
    return '-$percent% 最高の価値';
  }

  @override
  String get weatherUnavailable => '天気データなし';

  @override
  String get checkLocationPermissions => '位置情報とネット接続を確認';

  @override
  String get recommendedNormLabel => '推奨基準';

  @override
  String get waterAdjustment300 => '+300 ml';

  @override
  String get waterAdjustment400 => '+400 ml';

  @override
  String get waterAdjustment200 => '+200 ml';

  @override
  String get waterAdjustmentNormal => '通常';

  @override
  String get waterAdjustment500 => '+500 ml';

  @override
  String get waterAdjustment250 => '+250 ml';

  @override
  String get waterAdjustment750 => '+750 ml';

  @override
  String get currentLocation => '現在地';

  @override
  String get weatherClear => '晴れ';

  @override
  String get weatherCloudy => '曇り';

  @override
  String get weatherOvercast => 'どんより';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '嵐';

  @override
  String get weatherFog => '霧';

  @override
  String get weatherDrizzle => '霧雨';

  @override
  String get weatherSunny => '快晴';

  @override
  String get heatWarningExtreme => '☀️ 極暑！最大の水分補給';

  @override
  String get heatWarningVeryHot => '🌡️ 猛暑！脱水リスク';

  @override
  String get heatWarningHot => '🔥 暑い！水を多く';

  @override
  String get heatWarningElevated => '⚠️ 高温';

  @override
  String get heatWarningComfortable => '快適な温度';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% 水';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg Na';
  }

  @override
  String get heatWarningCold => '❄️ 寒い！温かい飲み物';

  @override
  String get notificationChannelName => 'HydroCoachリマインダー';

  @override
  String get notificationChannelDescription => '水と電解質のリマインダー';

  @override
  String get urgentNotificationChannelName => '緊急リマインダー';

  @override
  String get urgentNotificationChannelDescription => '重要な水分通知';

  @override
  String get goodMorning => '☀️ おはよう！';

  @override
  String get timeToHydrate => '💧 水分補給の時間';

  @override
  String get eveningHydration => '💧 夜の水分補給';

  @override
  String get dailyReportTitle => ' 日報準備完了';

  @override
  String get dailyReportBody => '今日の水分状態を確認';

  @override
  String get maintainWaterBalance => '1日を通じて水分バランスを維持';

  @override
  String get electrolytesTime => '電解質の時間: 水に一つまみの塩';

  @override
  String catchUpHydration(int percent) {
    return '$percent%のみ達成。補給の時間！';
  }

  @override
  String get excellentProgress => '素晴らしい進捗！もう少し';

  @override
  String get postCoffeeTitle => ' コーヒー後';

  @override
  String get postCoffeeBody => '250-300 mlの水でバランス回復';

  @override
  String get postWorkoutTitle => ' 運動後';

  @override
  String get postWorkoutBody => '電解質を回復: 500 ml水 + 一つまみの塩';

  @override
  String get heatWarningPro => '🌡️ PRO暑熱警告';

  @override
  String get extremeHeatWarning => '極暑！水を15%増加し塩1g追加';

  @override
  String get hotWeatherWarning => '暑い！水を10%多く、電解質を忘れずに';

  @override
  String get warmWeatherWarning => '温暖。水分補給を監視';

  @override
  String get alcoholRecoveryTitle => '🍺 回復時間';

  @override
  String get alcoholRecoveryBody => '300 mlの水に一つまみの塩でバランス';

  @override
  String get continueHydration => '💧 水分補給を継続';

  @override
  String get alcoholRecoveryBody2 => 'さらに500 mlの水で早い回復';

  @override
  String get morningRecoveryTitle => '☀️ 朝の回復';

  @override
  String get morningRecoveryBody => '500 mlの水と電解質で1日を開始';

  @override
  String get testNotificationTitle => '🧪 テスト通知';

  @override
  String get testNotificationBody => 'これが見えれば即時通知が機能！';

  @override
  String get scheduledTestTitle => '⏰ スケジュールテスト (1分)';

  @override
  String get scheduledTestBody => 'この通知は1分前にスケジュール。機能中！';

  @override
  String get notificationServiceInitialized => '✅ 通知サービス初期化';

  @override
  String get localNotificationsInitialized => '✅ ローカル通知初期化';

  @override
  String get androidChannelsCreated => '📢 Androidチャンネル作成';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 通知権限: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 正確なアラーム権限: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM権限: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCMトークン受信';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCMトークンをFirestoreに保存 $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ トピック購読完了';

  @override
  String foregroundMessage(String title) {
    return '📨 フォアグラウンドメッセージ: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 通知を開く: $messageId';
  }

  @override
  String get dailyLimitReached => '⚠️ 1日の通知上限 (4/日 FREE)';

  @override
  String schedulingError(String error) {
    return '❌ 通知スケジュールエラー: $error';
  }

  @override
  String get showingImmediatelyAsFallback => '即座に通知を表示';

  @override
  String instantNotificationShown(String title) {
    return '📬 即時通知表示: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 スマートリマインダー設定中...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ $count件のリマインダー設定完了';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: コーヒー後リマインダー設定';

  @override
  String get postWorkoutScheduled => '💪 運動後リマインダー設定';

  @override
  String get proHeatWarningPro => '🌡️ PRO: 暑熱警告送信';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO: 飲酒回復計画設定';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 夜間レポート設定 $day.$month 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 通知$idキャンセル';
  }

  @override
  String get allNotificationsCancelled => '🗑️ 全通知キャンセル';

  @override
  String get reminderSettingsSaved => '✅ リマインダー設定保存';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ テスト通知設定: $time';
  }

  @override
  String get tomorrowRecommendations => '明日への推奨';

  @override
  String get recommendationExcellent => '素晴らしい！朝に水を飲み均等に摂取を。';

  @override
  String get recommendationDiluted => '水が多く電解質が少ない。明日は塩を追加。';

  @override
  String get recommendationDehydrated => '水不足。明日は2時間ごとにリマインダーを設定。';

  @override
  String get recommendationLowSalt => 'Naが低いと疲労。水に塩を追加またはスープ。';

  @override
  String get recommendationGeneral => '水と電解質のバランスを目指す。1日を通じて均等に。';

  @override
  String get category_water => '水';

  @override
  String get category_hot_drinks => '温かい飲み物';

  @override
  String get category_juice => 'ジュース';

  @override
  String get category_sports => 'スポーツ';

  @override
  String get category_dairy => '乳製品';

  @override
  String get category_alcohol => 'アルコール';

  @override
  String get category_supplements => 'サプリ';

  @override
  String get category_other => 'その他';

  @override
  String get drink_water => '水';

  @override
  String get drink_sparkling_water => '炭酸水';

  @override
  String get drink_mineral_water => 'ミネラル水';

  @override
  String get drink_coconut_water => 'ココナッツ水';

  @override
  String get drink_coffee => 'コーヒー';

  @override
  String get drink_espresso => 'エスプレッソ';

  @override
  String get drink_americano => 'アメリカーノ';

  @override
  String get drink_cappuccino => 'カプチーノ';

  @override
  String get drink_latte => 'ラテ';

  @override
  String get drink_black_tea => '紅茶';

  @override
  String get drink_green_tea => '緑茶';

  @override
  String get drink_herbal_tea => 'ハーブティー';

  @override
  String get drink_matcha => '抹茶';

  @override
  String get drink_hot_chocolate => 'ホットチョコ';

  @override
  String get drink_orange_juice => 'オレンジジュース';

  @override
  String get drink_apple_juice => 'アップルジュース';

  @override
  String get drink_grapefruit_juice => 'グレープフルーツ';

  @override
  String get drink_tomato_juice => 'トマトジュース';

  @override
  String get drink_vegetable_juice => '野菜ジュース';

  @override
  String get drink_smoothie => 'スムージー';

  @override
  String get drink_lemonade => 'レモネード';

  @override
  String get drink_isotonic => 'アイソトニック';

  @override
  String get drink_electrolyte => '電解質ドリンク';

  @override
  String get drink_protein_shake => 'プロテインシェイク';

  @override
  String get drink_bcaa => 'BCAA';

  @override
  String get drink_energy => 'エナジー';

  @override
  String get drink_milk => '牛乳';

  @override
  String get drink_kefir => 'ケフィア';

  @override
  String get drink_yogurt => '飲むヨーグルト';

  @override
  String get drink_almond_milk => 'アーモンドミルク';

  @override
  String get drink_soy_milk => '豆乳';

  @override
  String get drink_oat_milk => 'オーツミルク';

  @override
  String get drink_beer_light => 'ライトビール';

  @override
  String get drink_beer_regular => 'ビール';

  @override
  String get drink_beer_strong => '濃いビール';

  @override
  String get drink_wine_red => '赤ワイン';

  @override
  String get drink_wine_white => '白ワイン';

  @override
  String get drink_champagne => 'シャンパン';

  @override
  String get drink_vodka => 'ウォッカ';

  @override
  String get drink_whiskey => 'ウイスキー';

  @override
  String get drink_rum => 'ラム';

  @override
  String get drink_gin => 'ジン';

  @override
  String get drink_tequila => 'テキーラ';

  @override
  String get drink_mojito => 'モヒート';

  @override
  String get drink_margarita => 'マルガリータ';

  @override
  String get drink_kombucha => 'コンブチャ';

  @override
  String get drink_kvass => 'クワス';

  @override
  String get drink_bone_broth => '骨スープ';

  @override
  String get drink_vegetable_broth => '野菜スープ';

  @override
  String get drink_soda => 'ソーダ';

  @override
  String get drink_diet_soda => 'ダイエットソーダ';

  @override
  String get addedToFavorites => 'お気に入りに追加';

  @override
  String get favoriteLimitReached => '上限到達 (FREE 3, PRO 20)';

  @override
  String get addFavorite => 'お気に入り追加';

  @override
  String get hotAndSupplements => '温かい飲み物&サプリ';

  @override
  String get quickVolumes => 'クイック量:';

  @override
  String get type => '種類:';

  @override
  String get regular => '通常';

  @override
  String get coconut => 'ココナッツ';

  @override
  String get sparkling => '炭酸';

  @override
  String get mineral => 'ミネラル';

  @override
  String get hotDrinks => '温かい飲み物';

  @override
  String get supplements => 'サプリ';

  @override
  String get tea => 'お茶';

  @override
  String get salt => '塩 (1/4 tsp)';

  @override
  String get electrolyteMix => '電解質ミックス';

  @override
  String get boneBroth => '骨スープ';

  @override
  String get favoriteAssignmentComingSoon => 'お気に入り割当は近日公開';

  @override
  String get longPressToEditComingSoon => '長押しで編集 - 近日公開';

  @override
  String get proSubscriptionRequired => 'PRO購読が必要';

  @override
  String get saveToFavorites => 'お気に入りに保存';

  @override
  String get savedToFavorites => 'お気に入りに保存完了';

  @override
  String get selectFavoriteSlot => 'スロット選択';

  @override
  String get slot => 'スロット';

  @override
  String get emptySlot => '空きスロット';

  @override
  String get upgradeToUnlock => 'PROで解除';

  @override
  String get changeFavorite => 'お気に入り変更';

  @override
  String get removeFavorite => 'お気に入り削除';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'ミネラル水';

  @override
  String get coconutWater => 'ココナッツ水';

  @override
  String get lemonWater => 'レモン水';

  @override
  String get greenTea => '緑茶';

  @override
  String get amount => '量';

  @override
  String get createFavoriteHint => 'お気に入り追加は飲み物画面で「お気に入りに保存」をタップ。';

  @override
  String get sparklingWater => '炭酸水';

  @override
  String get cola => 'コーラ';

  @override
  String get juice => 'ジュース';

  @override
  String get energyDrink => 'エナジー';

  @override
  String get sportsDrink => 'スポーツ';

  @override
  String get selectElectrolyteType => '電解質タイプを選択:';

  @override
  String get saltQuarterTsp => '塩 (1/4 tsp)';

  @override
  String get pinkSalt => 'ピンク塩';

  @override
  String get seaSalt => '海塩';

  @override
  String get potassiumCitrate => 'クエン酸K';

  @override
  String get magnesiumGlycinate => 'グリシン酸Mg';

  @override
  String get coconutWaterElectrolyte => 'ココナッツ水';

  @override
  String get sportsDrinkElectrolyte => 'スポーツドリンク';

  @override
  String get electrolyteContent => '電解質含有量:';

  @override
  String sodiumContent(int amount) {
    return 'Na: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return 'K: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Mg: $amount mg';
  }

  @override
  String get servings => '回分';

  @override
  String get enterServings => '回分を入力';

  @override
  String get servingsUnit => '回分';

  @override
  String get noElectrolytes => '電解質なし';

  @override
  String get enterValidAmount => '有効な量を入力';

  @override
  String get lmntMix => 'LMNTミックス';

  @override
  String get pickleJuice => 'ピクルス汁';

  @override
  String get tomatoSalt => 'トマト+塩';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'アルカリ水';

  @override
  String get celticSalt => 'ケルト塩水';

  @override
  String get soleWater => 'ソール水';

  @override
  String get mineralDrops => 'ミネラルドロップ';

  @override
  String get bakingSoda => '重曹水';

  @override
  String get creamTartar => '酒石酸';

  @override
  String get selectSupplementType => 'サプリタイプを選択:';

  @override
  String get multivitamin => 'マルチビタミン';

  @override
  String get magnesiumCitrate => 'クエン酸Mg';

  @override
  String get magnesiumThreonate => 'L-トレオン酸Mg';

  @override
  String get calciumCitrate => 'クエン酸Ca';

  @override
  String get zincGlycinate => 'グリシン酸Zn';

  @override
  String get vitaminD3 => 'ビタミンD3';

  @override
  String get vitaminC => 'ビタミンC';

  @override
  String get bComplex => 'Bコンプレックス';

  @override
  String get omega3 => 'オメガ3';

  @override
  String get ironBisglycinate => 'ビスグリシン酸Fe';

  @override
  String get dosage => '用量';

  @override
  String get enterDosage => '用量を入力';

  @override
  String get noElectrolyteContent => '電解質含有なし';

  @override
  String get blackTea => '紅茶';

  @override
  String get herbalTea => 'ハーブティー';

  @override
  String get espresso => 'エスプレッソ';

  @override
  String get cappuccino => 'カプチーノ';

  @override
  String get latte => 'ラテ';

  @override
  String get matcha => '抹茶';

  @override
  String get hotChocolate => 'ホットチョコ';

  @override
  String get caffeine => 'カフェイン';

  @override
  String get sports => 'スポーツ';

  @override
  String get walking => 'ウォーキング';

  @override
  String get running => 'ランニング';

  @override
  String get gym => 'ジム';

  @override
  String get cycling => 'サイクリング';

  @override
  String get swimming => '水泳';

  @override
  String get yoga => 'ヨガ';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'ボクシング';

  @override
  String get dancing => 'ダンス';

  @override
  String get tennis => 'テニス';

  @override
  String get teamSports => 'チームスポーツ';

  @override
  String get selectActivityType => '活動タイプを選択:';

  @override
  String get duration => '時間';

  @override
  String get minutes => '分';

  @override
  String get enterDuration => '時間を入力';

  @override
  String get lowIntensity => '低強度';

  @override
  String get mediumIntensity => '中強度';

  @override
  String get highIntensity => '高強度';

  @override
  String get recommendedIntake => '推奨摂取:';

  @override
  String get basedOnWeight => '体重基準';

  @override
  String get logActivity => '活動を記録';

  @override
  String get activityLogged => '活動を記録完了';

  @override
  String get enterValidDuration => '有効な時間を入力';

  @override
  String get sauna => 'サウナ';

  @override
  String get veryHighIntensity => '超高強度';

  @override
  String get hriStatusExcellent => '優秀';

  @override
  String get hriStatusGood => '良好';

  @override
  String get hriStatusModerate => '中リスク';

  @override
  String get hriStatusHighRisk => '高リスク';

  @override
  String get hriStatusCritical => '危険';

  @override
  String get hriComponentWater => '水分バランス';

  @override
  String get hriComponentSodium => 'Naレベル';

  @override
  String get hriComponentPotassium => 'Kレベル';

  @override
  String get hriComponentMagnesium => 'Mgレベル';

  @override
  String get hriComponentHeat => '暑熱ストレス';

  @override
  String get hriComponentWorkout => '身体活動';

  @override
  String get hriComponentCaffeine => 'カフェイン影響';

  @override
  String get hriComponentAlcohol => 'アルコール影響';

  @override
  String get hriComponentTime => '摂取からの時間';

  @override
  String get hriComponentMorning => '朝の要因';

  @override
  String get hriBreakdownTitle => 'リスク要因の内訳';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max pt';
  }

  @override
  String get fastingModeActive => '断食モード有効';

  @override
  String get fastingSuppressionNote => '断食中は時間要因を抑制';

  @override
  String get morningCheckInTitle => '朝のチェックイン';

  @override
  String get howAreYouFeeling => '体調は？';

  @override
  String get feelingScale1 => '悪い';

  @override
  String get feelingScale2 => '平均以下';

  @override
  String get feelingScale3 => '普通';

  @override
  String get feelingScale4 => '良い';

  @override
  String get feelingScale5 => '最高';

  @override
  String get weightChange => '昨日からの体重変化';

  @override
  String get urineColorScale => '尿の色 (1-8スケール)';

  @override
  String get urineColor1 => '1 - 非常に薄い';

  @override
  String get urineColor2 => '2 - 薄い';

  @override
  String get urineColor3 => '3 - 薄黄';

  @override
  String get urineColor4 => '4 - 黄';

  @override
  String get urineColor5 => '5 - 濃黄';

  @override
  String get urineColor6 => '6 - 琥珀';

  @override
  String get urineColor7 => '7 - 濃琥珀';

  @override
  String get urineColor8 => '8 - 褐色';

  @override
  String get alcoholWithDecay => 'アルコール影響 (減衰中)';

  @override
  String standardDrinksToday(Object count) {
    return '今日の標準ドリンク: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return '活性カフェイン: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRIデバッグ情報';

  @override
  String hriNormalized(Object value) {
    return 'HRI (正規化): $value/100';
  }

  @override
  String get fastingWindowActive => '断食時間有効';

  @override
  String get eatingWindowActive => '食事時間有効';

  @override
  String nextFastingWindow(Object time) {
    return '次の断食: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return '次の食事: $time';
  }

  @override
  String get todaysWorkouts => '今日の運動';

  @override
  String get hoursAgo => '時間前';

  @override
  String get onboardingWelcomeTitle => 'HydroCoach — 毎日のスマート水分補給';

  @override
  String get onboardingWelcomeSubtitle =>
      'スマートに飲もう、多くではなく\n天候、電解質、習慣を考慮\n明快な思考と安定エネルギーを維持';

  @override
  String get onboardingBullet1 => '天候とあなたに基づく個人の水と塩の基準';

  @override
  String get onboardingBullet2 => '生のグラフではなく「今何をすべきか」のヒント';

  @override
  String get onboardingBullet3 => '安全な限度での標準用量でのアルコール';

  @override
  String get onboardingBullet4 => 'スパムなしのスマートリマインダー';

  @override
  String get onboardingStartButton => '開始';

  @override
  String get onboardingHaveAccount => '既にアカウントあり';

  @override
  String get onboardingPracticeFasting => '断続的断食を実践';

  @override
  String get onboardingPracticeFastingDesc => '断食時間用の特別な電解質管理';

  @override
  String get onboardingProfileReady => 'プロフィール準備完了！';

  @override
  String get onboardingWaterNorm => '水分基準';

  @override
  String get onboardingIonWillHelp => 'IONが毎日のバランス維持を支援';

  @override
  String get onboardingContinue => '続行';

  @override
  String get onboardingLocationTitle => '天候は水分補給に重要';

  @override
  String get onboardingLocationSubtitle => '天候と湿度を考慮。体重だけの公式より正確';

  @override
  String get onboardingWeatherExample => '今日は暑い！+15%水';

  @override
  String get onboardingWeatherExampleDesc => '暑さ用+500 mg Na';

  @override
  String get onboardingEnablePermission => '有効にする';

  @override
  String get onboardingEnableLater => '後で有効化';

  @override
  String get onboardingNotificationTitle => 'スマートリマインダー';

  @override
  String get onboardingNotificationSubtitle => '適切な瞬間の短いヒント。頻度はワンタップで変更可能';

  @override
  String get onboardingNotifExample1 => '水分補給の時間';

  @override
  String get onboardingNotifExample2 => '電解質を忘れずに';

  @override
  String get onboardingNotifExample3 => '暑い！水を多く';

  @override
  String get sportRecoveryProtocols => 'スポーツ回復プロトコル';

  @override
  String get allDrinksAndSupplements => '全飲料&サプリ';

  @override
  String get notificationChannelDefault => '水分リマインダー';

  @override
  String get notificationChannelDefaultDesc => '水と電解質のリマインダー';

  @override
  String get notificationChannelUrgent => '重要通知';

  @override
  String get notificationChannelUrgentDesc => '暑熱警告と重要な水分アラート';

  @override
  String get notificationChannelReport => 'レポート';

  @override
  String get notificationChannelReportDesc => '日次と週次レポート';

  @override
  String get notificationWaterTitle => '💧 水分補給の時間';

  @override
  String get notificationWaterBody => '水を忘れずに';

  @override
  String get notificationPostCoffeeTitle => '☕ コーヒー後';

  @override
  String get notificationPostCoffeeBody => '250-300 mlの水でバランス回復';

  @override
  String get notificationDailyReportTitle => '📊 日報準備完了';

  @override
  String get notificationDailyReportBody => '今日の水分状態を確認';

  @override
  String get notificationAlcoholCounterTitle => '🍺 回復時間';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return '$ml mlの水に塩を一つまみ';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ 暑熱警告';

  @override
  String get notificationHeatWarningExtremeBody => '極暑！+15%水と塩1g';

  @override
  String get notificationHeatWarningHotBody => '暑い！+10%水と電解質';

  @override
  String get notificationHeatWarningWarmBody => '温暖。水分補給を監視';

  @override
  String get notificationWorkoutTitle => '💪 運動';

  @override
  String get notificationWorkoutBody => '水と電解質を忘れずに';

  @override
  String get notificationPostWorkoutTitle => '💪 運動後';

  @override
  String get notificationPostWorkoutBody => '500 ml水 + 電解質で回復';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ 電解質の時間';

  @override
  String get notificationFastingElectrolyteBody => '水に塩を一つまみまたはスープ';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 回復${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return '$ml mlの水を飲む';
  }

  @override
  String get notificationAlcoholRecoveryMidBody => '電解質追加: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody => '明朝 - 管理チェックイン';

  @override
  String get notificationMorningCheckInTitle => '☀️ 朝のチェックイン';

  @override
  String get notificationMorningCheckInBody => '体調は？条件を評価し1日の計画を取得';

  @override
  String get notificationMorningWaterBody => '朝の水で1日を開始';

  @override
  String notificationLowProgressBody(int percent) {
    return '$percent%のみ達成。補給の時間！';
  }

  @override
  String get notificationGoodProgressBody => '素晴らしい進捗！続けよう';

  @override
  String get notificationMaintainBalanceBody => '水分バランスを維持';

  @override
  String get notificationTestTitle => '🧪 テスト通知';

  @override
  String get notificationTestBody => '見えれば通知機能中！';

  @override
  String get notificationTestScheduledTitle => '⏰ スケジュールテスト';

  @override
  String get notificationTestScheduledBody => 'この通知は1分前にスケジュール';

  @override
  String get onboardingUnitsTitle => '単位を選択';

  @override
  String get onboardingUnitsSubtitle => '後で変更不可';

  @override
  String get onboardingUnitsWarning => 'この選択は永久で後から変更不可';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'ガロン';

  @override
  String get lb => 'lb';

  @override
  String get target => '目標';

  @override
  String get wind => '風';

  @override
  String get pressure => '気圧';

  @override
  String get highHeatIndexWarning => '高熱中症指数！水分摂取を増加';

  @override
  String get weatherCondition => '状態';

  @override
  String get feelsLike => '体感';

  @override
  String get humidityLabel => '湿度';

  @override
  String get waterNormal => '通常';

  @override
  String get sodiumNormal => '標準';

  @override
  String get addedSuccessfully => '追加成功';

  @override
  String get sugarIntake => '砂糖摂取';

  @override
  String get sugarToday => '今日の砂糖消費';

  @override
  String get totalSugar => '総砂糖';

  @override
  String get dailyLimit => '1日の上限';

  @override
  String get addedSugar => '添加砂糖';

  @override
  String get naturalSugar => '天然砂糖';

  @override
  String get hiddenSugar => '隠れた砂糖';

  @override
  String get sugarFromDrinks => '飲料';

  @override
  String get sugarFromFood => '食品';

  @override
  String get sugarFromSnacks => 'スナック';

  @override
  String get sugarNormal => '通常';

  @override
  String get sugarModerate => '中程度';

  @override
  String get sugarHigh => '高';

  @override
  String get sugarCritical => '危険';

  @override
  String get sugarRecommendationNormal => '素晴らしい！砂糖摂取は健康な範囲内';

  @override
  String get sugarRecommendationModerate => '甘い飲料とスナックを減らす検討を';

  @override
  String get sugarRecommendationHigh => '砂糖摂取高！甘い飲料とデザートを制限';

  @override
  String get sugarRecommendationCritical => '砂糖超過！今日は甘い飲料とお菓子を避けて';

  @override
  String get noSugarIntake => '今日の砂糖追跡なし';

  @override
  String get hriImpact => 'HRI影響';

  @override
  String get hri_component_sugar => '砂糖';

  @override
  String get hri_sugar_description => '高砂糖摂取は水分補給と全体的な健康に影響';

  @override
  String get tip_reduce_sweet_drinks => '甘い飲料を水または無糖茶に置換';

  @override
  String get tip_avoid_added_sugar => 'ラベルを確認し添加砂糖製品を避ける';

  @override
  String get tip_check_labels => 'ソースと加工食品の隠れた砂糖に注意';

  @override
  String get tip_replace_soda => 'ソーダを炭酸水とレモンに置換';

  @override
  String get sugarSources => '砂糖源';

  @override
  String get drinks => '飲料';

  @override
  String get food => '食品';

  @override
  String get snacks => 'スナック';

  @override
  String get recommendedLimit => '推奨';

  @override
  String get points => 'ポイント';

  @override
  String get drinkLightBeer => 'ライトビール';

  @override
  String get drinkLager => 'ラガー';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'スタウト';

  @override
  String get drinkWheatBeer => '小麦ビール';

  @override
  String get drinkCraftBeer => 'クラフトビール';

  @override
  String get drinkNonAlcoholic => 'ノンアルコール';

  @override
  String get drinkRadler => 'ラドラー';

  @override
  String get drinkPilsner => 'ピルスナー';

  @override
  String get drinkRedWine => '赤ワイン';

  @override
  String get drinkWhiteWine => '白ワイン';

  @override
  String get drinkProsecco => 'プロセッコ';

  @override
  String get drinkPort => 'ポートワイン';

  @override
  String get drinkRose => 'ロゼ';

  @override
  String get drinkDessertWine => 'デザートワイン';

  @override
  String get drinkSangria => 'サングリア';

  @override
  String get drinkSherry => 'シェリー';

  @override
  String get drinkVodkaShot => 'ウォッカショット';

  @override
  String get drinkCognac => 'コニャック';

  @override
  String get drinkLiqueur => 'リキュール';

  @override
  String get drinkAbsinthe => 'アブサン';

  @override
  String get drinkBrandy => 'ブランデー';

  @override
  String get drinkLongIsland => 'ロングアイランド';

  @override
  String get drinkGinTonic => 'ジントニック';

  @override
  String get drinkPinaColada => 'ピニャコラーダ';

  @override
  String get drinkCosmopolitan => 'コスモポリタン';

  @override
  String get drinkMaiTai => 'マイタイ';

  @override
  String get drinkBloodyMary => 'ブラッディマリー';

  @override
  String get drinkDaiquiri => 'ダイキリ';

  @override
  String popularDrinks(Object type) {
    return '人気の$type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g 砂糖';

  @override
  String get moderateConsumption => '適度な消費';

  @override
  String get aboveRecommendations => '推奨以上';

  @override
  String get highConsumption => '高消費';

  @override
  String get veryHighConsider => '超高 - 停止検討を';

  @override
  String get noAlcoholToday => '今日の飲酒なし';

  @override
  String get drinkWaterNow => '今すぐ300-500 mlの水';

  @override
  String get addPinchSalt => '塩を一つまみ追加';

  @override
  String get avoidLateCoffee => '遅いコーヒーを避ける';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => '今日の電解質';

  @override
  String get greatBalance => '素晴らしいバランス！';

  @override
  String get gettingThere => '近づいている';

  @override
  String get needMoreElectrolytes => '電解質をもっと必要';

  @override
  String get lowElectrolyteLevels => '電解質レベル低';

  @override
  String get electrolyteTips => '電解質のヒント';

  @override
  String get takeWithWater => 'たっぷりの水と一緒に';

  @override
  String get bestBetweenMeals => '食間が最適';

  @override
  String get startSmallAmounts => '少量から開始';

  @override
  String get extraDuringExercise => '運動中は追加必要';

  @override
  String get electrolytesBasic => '基本';

  @override
  String get electrolytesMixes => 'ミックス';

  @override
  String get electrolytesPills => '錠剤';

  @override
  String get popularSalts => '人気の塩&スープ';

  @override
  String get popularMixes => '人気の電解質ミックス';

  @override
  String get popularSupplements => '人気のサプリ';

  @override
  String get electrolyteSaltWater => '塩水';

  @override
  String get electrolytePinkSalt => 'ピンク塩';

  @override
  String get electrolyteSeaSalt => '海塩';

  @override
  String get electrolyteNuun => 'Nuun';

  @override
  String get electrolyteLiquidIV => 'Liquid IV';

  @override
  String get electrolyteUltima => 'Ultima';

  @override
  String get electrolytePropel => 'Propel';

  @override
  String get electrolytePedialyte => 'Pedialyte';

  @override
  String get electrolyteGatoradeZero => 'Gatorade Zero';

  @override
  String get electrolytePotassiumChloride => '塩化K';

  @override
  String get electrolyteMagThreonate => 'Mg トレオネート';

  @override
  String get electrolyteTraceMinerals => '微量ミネラル';

  @override
  String get electrolyteZMAComplex => 'ZMA複合';

  @override
  String get electrolyteMultiMineral => 'マルチミネラル';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => '水分補給';

  @override
  String get todayHydration => '今日の水分補給';

  @override
  String get currentIntake => '摂取済';

  @override
  String get dailyGoal => '目標';

  @override
  String get toGo => '残り';

  @override
  String get goalReached => '目標達成！';

  @override
  String get almostThere => 'もうすぐ！';

  @override
  String get halfwayThere => '半分';

  @override
  String get keepGoing => '続けよう！';

  @override
  String get startDrinking => '飲み始めよう';

  @override
  String get plainWater => 'プレーン';

  @override
  String get enhancedWater => '強化';

  @override
  String get beverages => '飲料';

  @override
  String get sodas => 'ソーダ';

  @override
  String get popularPlainWater => '人気の水タイプ';

  @override
  String get popularEnhancedWater => '強化&注入';

  @override
  String get popularBeverages => '人気の飲料';

  @override
  String get popularSodas => '人気のソーダ&エナジー';

  @override
  String get hydrationTips => '水分補給のヒント';

  @override
  String get drinkRegularly => '少量を定期的に';

  @override
  String get roomTemperature => '室温の水が吸収良好';

  @override
  String get addLemon => 'レモンで味向上';

  @override
  String get limitSugary => '甘い飲料を制限 - 脱水';

  @override
  String get warmWater => '温水';

  @override
  String get iceWater => '氷水';

  @override
  String get filteredWater => '濾過水';

  @override
  String get distilledWater => '蒸留水';

  @override
  String get springWater => '湧水';

  @override
  String get hydrogenWater => '水素水';

  @override
  String get oxygenatedWater => '酸素水';

  @override
  String get cucumberWater => 'きゅうり水';

  @override
  String get limeWater => 'ライム水';

  @override
  String get berryWater => 'ベリー水';

  @override
  String get mintWater => 'ミント水';

  @override
  String get gingerWater => '生姜水';

  @override
  String get caffeineStatusNone => '今日のカフェインなし';

  @override
  String caffeineStatusModerate(Object amount) {
    return '中程度: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return '高: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return '超高: ${amount}mg！';
  }

  @override
  String get caffeineDailyLimit => '1日の上限: 400mg';

  @override
  String get caffeineWarningTitle => 'カフェイン警告';

  @override
  String get caffeineWarning400 => '今日400mgカフェイン超過';

  @override
  String get caffeineTipWater => '補償のため追加の水を';

  @override
  String get caffeineTipAvoid => '今日はカフェインを避けて';

  @override
  String get caffeineTipSleep => '睡眠の質に影響する可能性';

  @override
  String get total => '総計';

  @override
  String get cupsToday => '今日のカップ';

  @override
  String get metabolizeTime => '代謝時間';

  @override
  String get aboutCaffeine => 'カフェインについて';

  @override
  String get caffeineInfo1 => 'コーヒーには覚醒を高める天然カフェインが含まれる';

  @override
  String get caffeineInfo2 => '1日の安全上限はほとんどの成人で400mg';

  @override
  String get caffeineInfo3 => 'カフェイン半減期は5-6時間';

  @override
  String get caffeineInfo4 => 'カフェインの利尿作用を補う追加の水を';

  @override
  String get caffeineWarningPregnant => '妊婦はカフェインを200mg/日に制限すべき';

  @override
  String get gotIt => '了解';

  @override
  String get consumed => '摂取済';

  @override
  String get remaining => '残り';

  @override
  String get todaysCaffeine => '今日のカフェイン';

  @override
  String get alreadyInFavorites => '既にお気に入り';

  @override
  String get ofRecommendedLimit => '推奨上限の';

  @override
  String get aboutAlcohol => 'アルコールについて';

  @override
  String get alcoholInfo1 => '1標準ドリンク = 純アルコール10g';

  @override
  String get alcoholInfo2 => 'アルコールは脱水 — ドリンクごとに250ml追加の水';

  @override
  String get alcoholInfo3 => '飲酒後にNaを追加して体液保持を支援';

  @override
  String get alcoholInfo4 => '各標準ドリンクはHRIを3-5ポイント増加';

  @override
  String get alcoholWarningHealth => '過度のアルコール消費は健康に有害。推奨上限は男性2 SD、女性1 SD/日。';

  @override
  String get supplementsInfo1 => 'サプリは電解質バランス維持を支援';

  @override
  String get supplementsInfo2 => '食事と共に摂取が吸収に最適';

  @override
  String get supplementsInfo3 => '常にたっぷりの水と一緒に';

  @override
  String get supplementsInfo4 => 'MgとKは水分補給の鍵';

  @override
  String get supplementsWarning => 'サプリ開始前に医療提供者に相談';

  @override
  String get fromSupplementsToday => '今日のサプリから';

  @override
  String get minerals => 'ミネラル';

  @override
  String get vitamins => 'ビタミン';

  @override
  String get essentialMinerals => '必須ミネラル';

  @override
  String get otherSupplements => 'その他のサプリ';

  @override
  String get supplementTip1 => '吸収向上のため食事と共に';

  @override
  String get supplementTip2 => 'サプリと共にたっぷりの水';

  @override
  String get supplementTip3 => '複数のサプリは1日を通じて間隔を空ける';

  @override
  String get supplementTip4 => '効果を追跡';

  @override
  String get calciumCarbonate => '炭酸Ca';

  @override
  String get traceMinerals => '微量ミネラル';

  @override
  String get vitaminA => 'ビタミンA';

  @override
  String get vitaminE => 'ビタミンE';

  @override
  String get vitaminK2 => 'ビタミンK2';

  @override
  String get folate => '葉酸';

  @override
  String get biotin => 'ビオチン';

  @override
  String get probiotics => 'プロバイオティクス';

  @override
  String get melatonin => 'メラトニン';

  @override
  String get collagen => 'コラーゲン';

  @override
  String get glucosamine => 'グルコサミン';

  @override
  String get turmeric => 'ターメリック';

  @override
  String get coq10 => 'CoQ10';

  @override
  String get creatine => 'クレアチン';

  @override
  String get ashwagandha => 'アシュワガンダ';

  @override
  String get selectCardioActivity => '有酸素活動を選択';

  @override
  String get selectStrengthActivity => '筋力活動を選択';

  @override
  String get selectSportsActivity => 'スポーツを選択';

  @override
  String get sessions => '回';

  @override
  String get totalTime => '総時間';

  @override
  String get waterLoss => '水分損失';

  @override
  String get intensity => '強度';

  @override
  String get drinkWaterAfterWorkout => '運動後に水';

  @override
  String get replenishElectrolytes => '電解質を補充';

  @override
  String get restAndRecover => '休息と回復';

  @override
  String get avoidSugaryDrinks => '甘いスポーツドリンクを避ける';

  @override
  String get elliptical => 'エリプティカル';

  @override
  String get rowing => 'ローイング';

  @override
  String get jumpRope => '縄跳び';

  @override
  String get stairClimbing => '階段昇り';

  @override
  String get bodyweight => '自重';

  @override
  String get powerlifting => 'パワーリフティング';

  @override
  String get calisthenics => 'カリステニクス';

  @override
  String get resistanceBands => 'レジスタンスバンド';

  @override
  String get kettlebell => 'ケトルベル';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'ストロングマン';

  @override
  String get pilates => 'ピラティス';

  @override
  String get basketball => 'バスケ';

  @override
  String get soccerFootball => 'サッカー';

  @override
  String get golf => 'ゴルフ';

  @override
  String get martialArts => '格闘技';

  @override
  String get rockClimbing => 'ロッククライミング';

  @override
  String get needsToReplenish => '補充が必要';

  @override
  String get electrolyteTrackingPro => 'Na、K、Mg目標を詳細な進捗バーで追跡';

  @override
  String get unlock => '解除';

  @override
  String get weather => '天候';

  @override
  String get weatherTrackingPro => '熱中症指数、湿度、天候が水分補給目標に与える影響を追跡';

  @override
  String get sugarTracking => '砂糖追跡';

  @override
  String get sugarTrackingPro => '天然、添加、隠れた砂糖摂取をHRI影響分析で監視';

  @override
  String get dayOverview => '日の概要';

  @override
  String get tapForDetails => 'タップで詳細';

  @override
  String get noDataForDay => 'この日のデータなし';

  @override
  String get sweatLoss => '発汗損失';

  @override
  String get cardio => '有酸素';

  @override
  String get workout => '運動';

  @override
  String get noWaterToday => '今日の水記録なし';

  @override
  String get noElectrolytesToday => '今日の電解質記録なし';

  @override
  String get noCoffeeToday => '今日のコーヒー記録なし';

  @override
  String get noWorkoutsToday => '今日の運動なし';

  @override
  String get noWaterThisDay => 'この日の水記録なし';

  @override
  String get noElectrolytesThisDay => 'この日の電解質記録なし';

  @override
  String get noCoffeeThisDay => 'この日のコーヒー記録なし';

  @override
  String get noWorkoutsThisDay => 'この日の運動なし';

  @override
  String get weeklyReport => '週次レポート';

  @override
  String get weeklyReportSubtitle => '深い洞察と傾向分析';

  @override
  String get workouts => '運動';

  @override
  String get workoutHydration => '運動水分補給';

  @override
  String workoutHydrationMessage(Object percent) {
    return '運動日は$percent%多く水を飲む';
  }

  @override
  String get weeklyActivity => '週の活動';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return '$days日で$minutes分運動';
  }

  @override
  String get workoutMinutesPerDay => '1日の運動分';

  @override
  String get daysWithWorkouts => '運動日';

  @override
  String get noWorkoutsThisWeek => '今週の運動なし';

  @override
  String get noAlcoholThisWeek => '今週の飲酒なし';

  @override
  String get csvExported => 'CSVへ出力完了';

  @override
  String get mondayShort => '月';

  @override
  String get tuesdayShort => '火';

  @override
  String get wednesdayShort => '水';

  @override
  String get thursdayShort => '木';

  @override
  String get fridayShort => '金';

  @override
  String get saturdayShort => '土';

  @override
  String get sundayShort => '日';

  @override
  String get achievements => '達成';

  @override
  String get achievementsTabAll => '全て';

  @override
  String get achievementsTabHydration => '水分';

  @override
  String get achievementsTabElectrolytes => '電解質';

  @override
  String get achievementsTabSugar => '砂糖管理';

  @override
  String get achievementsTabAlcohol => 'アルコール';

  @override
  String get achievementsTabWorkout => '運動';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => '連続';

  @override
  String get achievementsTabSpecial => '特別';

  @override
  String get achievementUnlocked => '達成解除！';

  @override
  String get achievementProgress => '進捗';

  @override
  String get achievementPoints => 'ポイント';

  @override
  String get achievementRarityCommon => '一般';

  @override
  String get achievementRarityUncommon => '珍しい';

  @override
  String get achievementRarityRare => 'レア';

  @override
  String get achievementRarityEpic => 'エピック';

  @override
  String get achievementRarityLegendary => '伝説';

  @override
  String get achievementStatsUnlocked => '解除済';

  @override
  String get achievementStatsTotal => '総ポイント';

  @override
  String get achievementFilterAll => '全て';

  @override
  String get achievementFilterUnlocked => '解除済';

  @override
  String get achievementSortProgress => '進捗';

  @override
  String get achievementSortName => '名前';

  @override
  String get achievementSortRarity => 'レアリティ';

  @override
  String get achievementNoAchievements => '達成なし';

  @override
  String get achievementKeepUsing => 'アプリ使用で達成を解除！';

  @override
  String get achievementFirstGlass => '最初の一滴';

  @override
  String get achievementFirstGlassDesc => '最初の水を飲む';

  @override
  String get achievementHydrationGoal1 => '水分補給';

  @override
  String get achievementHydrationGoal1Desc => '1日の目標達成';

  @override
  String get achievementHydrationGoal7 => '1週間水分補給';

  @override
  String get achievementHydrationGoal7Desc => '7日連続目標達成';

  @override
  String get achievementHydrationGoal30 => '水分マスター';

  @override
  String get achievementHydrationGoal30Desc => '30日連続目標達成';

  @override
  String get achievementPerfectHydration => '完璧バランス';

  @override
  String get achievementPerfectHydrationDesc => '目標の90-110%達成';

  @override
  String get achievementEarlyBird => '早起き';

  @override
  String get achievementEarlyBirdDesc => '9時前に最初の水';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return '$volumeを9時前';
  }

  @override
  String get achievementNightOwl => '夜更かし';

  @override
  String get achievementNightOwlDesc => '18時前に目標完了';

  @override
  String get achievementLiterLegend => 'リットル伝説';

  @override
  String get achievementLiterLegendDesc => '総水分マイルストーン';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return '$volume総量達成';
  }

  @override
  String get achievementSaltStarter => '塩スターター';

  @override
  String get achievementSaltStarterDesc => '最初の電解質追加';

  @override
  String get achievementElectrolyteBalance => 'バランス';

  @override
  String get achievementElectrolyteBalanceDesc => '1日で全電解質目標達成';

  @override
  String get achievementSodiumMaster => 'Naマスター';

  @override
  String get achievementSodiumMasterDesc => '7日連続Na目標達成';

  @override
  String get achievementPotassiumPro => 'Kプロ';

  @override
  String get achievementPotassiumProDesc => '7日連続K目標達成';

  @override
  String get achievementMagnesiumMaven => 'Mg達人';

  @override
  String get achievementMagnesiumMavenDesc => '7日連続Mg目標達成';

  @override
  String get achievementElectrolyteExpert => '電解質専門家';

  @override
  String get achievementElectrolyteExpertDesc => '30日完璧電解質';

  @override
  String get achievementSugarAwareness => '砂糖認識';

  @override
  String get achievementSugarAwarenessDesc => '初回砂糖追跡';

  @override
  String get achievementSugarUnder25 => '甘味管理';

  @override
  String get achievementSugarUnder25Desc => '1日低砂糖維持';

  @override
  String achievementSugarUnder25Template(String weight) {
    return '$weight以下で1日';
  }

  @override
  String get achievementSugarWeekControl => '砂糖規律';

  @override
  String get achievementSugarWeekControlDesc => '1週間低砂糖維持';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return '$weight以下で7日';
  }

  @override
  String get achievementSugarFreeDay => '砂糖ゼロ';

  @override
  String get achievementSugarFreeDayDesc => '添加砂糖0gで1日完了';

  @override
  String get achievementSugarDetective => '砂糖探偵';

  @override
  String get achievementSugarDetectiveDesc => '隠れ砂糖10回追跡';

  @override
  String get achievementSugarMaster => '砂糖マスター';

  @override
  String get achievementSugarMasterDesc => '1ヶ月超低砂糖維持';

  @override
  String get achievementNoSodaWeek => 'ソーダなし1週';

  @override
  String get achievementNoSodaWeekDesc => '7日ソーダなし';

  @override
  String get achievementNoSodaMonth => 'ソーダなし1月';

  @override
  String get achievementNoSodaMonthDesc => '30日ソーダなし';

  @override
  String get achievementSweetToothTamed => '甘党克服';

  @override
  String get achievementSweetToothTamedDesc => '1週で砂糖50%削減';

  @override
  String get achievementAlcoholTracker => '認識';

  @override
  String get achievementAlcoholTrackerDesc => '飲酒追跡';

  @override
  String get achievementModerateDay => '節度';

  @override
  String get achievementModerateDayDesc => '1日2SD以下維持';

  @override
  String get achievementSoberDay => '禁酒日';

  @override
  String get achievementSoberDayDesc => '飲酒なし1日完了';

  @override
  String get achievementSoberWeek => '禁酒1週';

  @override
  String get achievementSoberWeekDesc => '7日飲酒なし';

  @override
  String get achievementSoberMonth => '禁酒1月';

  @override
  String get achievementSoberMonthDesc => '30日飲酒なし';

  @override
  String get achievementRecoveryProtocol => '回復プロ';

  @override
  String get achievementRecoveryProtocolDesc => '飲酒後回復完了';

  @override
  String get achievementFirstWorkout => '始動';

  @override
  String get achievementFirstWorkoutDesc => '初回運動記録';

  @override
  String get achievementWorkoutWeek => '活動週';

  @override
  String get achievementWorkoutWeekDesc => '週3回運動';

  @override
  String get achievementCenturySweat => '百汗';

  @override
  String get achievementCenturySweatDesc => '運動で大量水分損失';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return '$volume運動損失';
  }

  @override
  String get achievementCardioKing => '有酸素王';

  @override
  String get achievementCardioKingDesc => '有酸素10回完了';

  @override
  String get achievementStrengthWarrior => '筋力戦士';

  @override
  String get achievementStrengthWarriorDesc => '筋力10回完了';

  @override
  String get achievementHRIGreen => '緑ゾーン';

  @override
  String get achievementHRIGreenDesc => 'HRI緑で1日維持';

  @override
  String get achievementHRIWeekGreen => '安全週';

  @override
  String get achievementHRIWeekGreenDesc => 'HRI緑で7日維持';

  @override
  String get achievementHRIPerfect => '完璧スコア';

  @override
  String get achievementHRIPerfectDesc => 'HRI 20以下達成';

  @override
  String get achievementHRIRecovery => '迅速回復';

  @override
  String get achievementHRIRecoveryDesc => '1日でHRI赤→緑';

  @override
  String get achievementHRIMaster => 'HRIマスター';

  @override
  String get achievementHRIMasterDesc => '30日HRI 30以下維持';

  @override
  String get achievementStreak3 => '開始';

  @override
  String get achievementStreak3Desc => '3日連続';

  @override
  String get achievementStreak7 => '週戦士';

  @override
  String get achievementStreak7Desc => '7日連続';

  @override
  String get achievementStreak30 => '継続王';

  @override
  String get achievementStreak30Desc => '30日連続';

  @override
  String get achievementStreak100 => '百日会';

  @override
  String get achievementStreak100Desc => '100日連続';

  @override
  String get achievementFirstWeek => '初週';

  @override
  String get achievementFirstWeekDesc => '7日使用';

  @override
  String get achievementProMember => 'PRO会員';

  @override
  String get achievementProMemberDesc => 'PRO登録';

  @override
  String get achievementDataExport => '分析家';

  @override
  String get achievementDataExportDesc => 'CSV出力';

  @override
  String get achievementAllCategories => '万能';

  @override
  String get achievementAllCategoriesDesc => '全カテゴリで達成解除';

  @override
  String get achievementHunter => '達成ハンター';

  @override
  String get achievementHunterDesc => '50%達成解除';

  @override
  String get achievementDetailsUnlockedOn => '解除日';

  @override
  String get achievementNewUnlocked => '新達成解除！';

  @override
  String get achievementViewAll => '全達成表示';

  @override
  String get achievementCloseNotification => '閉じる';

  @override
  String get before => '前';

  @override
  String get after => '後';

  @override
  String get lose => '損失';

  @override
  String get through => '経由';

  @override
  String get throughWorkouts => '運動経由';

  @override
  String get reach => '達成';

  @override
  String get daysInRow => '日連続';

  @override
  String get completeHydrationGoal => '水分目標完了';

  @override
  String get stayUnder => '以下維持';

  @override
  String get inADay => '1日で';

  @override
  String get alcoholFree => '飲酒なし';

  @override
  String get complete => '完了';

  @override
  String get achieve => '達成';

  @override
  String get keep => '維持';

  @override
  String get for30Days => '30日間';

  @override
  String get liters => 'リットル';

  @override
  String get completed => '完了';

  @override
  String get notCompleted => '未完了';

  @override
  String get days => '日';

  @override
  String get hours => '時間';

  @override
  String get times => '回';

  @override
  String get row => '連続';

  @override
  String get ofTotal => '総計の';

  @override
  String get perDay => '/日';

  @override
  String get perWeek => '/週';

  @override
  String get streak => '連続';

  @override
  String get tapToDismiss => 'タップで閉じる';

  @override
  String tutorialStep1(String volume) {
    return 'こんにちは！最適な水分補給の旅を始めます。最初の$volumeを飲みましょう！';
  }

  @override
  String tutorialStep2(String volume) {
    return '素晴らしい！もう$volume追加して仕組みを感じましょう。';
  }

  @override
  String get tutorialStep3 => '優秀！HydroCoachを独立して使用する準備完了。完璧な水分補給達成を支援します！';

  @override
  String get tutorialComplete => '使用開始';

  @override
  String get onboardingNotificationExamplesTitle => 'スマート通知';

  @override
  String get onboardingNotificationExamplesSubtitle => '必要な時を知っています';

  @override
  String get onboardingLocationExamplesTitle => '個人助言';

  @override
  String get onboardingLocationExamplesSubtitle => '天候考慮で正確推奨';

  @override
  String get onboardingAllowNotifications => '通知許可';

  @override
  String get onboardingAllowLocation => '位置情報許可';

  @override
  String get foodCatalog => '食品カタログ';

  @override
  String get todaysFoodIntake => '今日の食事';

  @override
  String get noFoodToday => '今日の食事記録なし';

  @override
  String foodItemsCount(int count) {
    return '$count品目';
  }

  @override
  String get waterFromFood => '食品から水分';

  @override
  String get last => '最終';

  @override
  String get categoryFruits => '果物';

  @override
  String get categoryVegetables => '野菜';

  @override
  String get categorySoups => 'スープ';

  @override
  String get categoryDairy => '乳製品';

  @override
  String get categoryMeat => '肉';

  @override
  String get categoryFastFood => 'ファストフード';

  @override
  String get weightGrams => '重量(グラム)';

  @override
  String get enterWeight => '重量入力';

  @override
  String get grams => 'g';

  @override
  String get calories => 'カロリー';

  @override
  String get waterContent => '水分含有';

  @override
  String get sugar => '砂糖';

  @override
  String get nutritionalInfo => '栄養情報';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '${weight}gあたり$calories kcal';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '${weight}gあたり$water ml水';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${weight}gあたり${sugar}g砂糖';
  }

  @override
  String get addFood => '食品追加';

  @override
  String get foodAdded => '食品追加成功';

  @override
  String get enterValidWeight => '有効な重量を入力';

  @override
  String get proOnlyFood => 'PROのみ';

  @override
  String get unlockProForFood => 'PRO解除で全食品利用';

  @override
  String get foodTracker => '食品追跡';

  @override
  String get todaysFoodSummary => '今日の食事要約';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => '100gあたり';

  @override
  String get addToFavorites => 'お気に入り追加';

  @override
  String get favoritesFeatureComingSoon => 'お気に入り機能近日公開！';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food追加！+$calories kcal, +$water';
  }

  @override
  String get selectWeight => '重量選択';

  @override
  String get ounces => 'oz';

  @override
  String get items => '品';

  @override
  String get tapToAddFood => 'タップで食品追加';

  @override
  String get noFoodLoggedToday => '今日の食品記録なし';

  @override
  String get lightEatingDay => '軽食日';

  @override
  String get moderateIntake => '中程度摂取';

  @override
  String get goodCalorieIntake => '良好カロリー';

  @override
  String get substantialMeals => '充実食事';

  @override
  String get highCalorieDay => '高カロリー日';

  @override
  String get veryHighIntake => '超高摂取';

  @override
  String get caloriesTracker => 'カロリー追跡';

  @override
  String get trackYourDailyCalorieIntake => '1日カロリー摂取追跡';

  @override
  String get unlockFoodTrackingFeatures => '食品追跡機能解除';

  @override
  String get selectFoodType => '食品種類選択';

  @override
  String get foodApple => 'リンゴ';

  @override
  String get foodBanana => 'バナナ';

  @override
  String get foodOrange => 'オレンジ';

  @override
  String get foodWatermelon => 'スイカ';

  @override
  String get foodStrawberry => 'イチゴ';

  @override
  String get foodGrapes => 'ブドウ';

  @override
  String get foodPineapple => 'パイナップル';

  @override
  String get foodMango => 'マンゴー';

  @override
  String get foodPear => '梨';

  @override
  String get foodCarrot => 'ニンジン';

  @override
  String get foodBroccoli => 'ブロッコリー';

  @override
  String get foodSpinach => 'ホウレン草';

  @override
  String get foodTomato => 'トマト';

  @override
  String get foodCucumber => 'キュウリ';

  @override
  String get foodBellPepper => 'ピーマン';

  @override
  String get foodLettuce => 'レタス';

  @override
  String get foodOnion => '玉ねぎ';

  @override
  String get foodCelery => 'セロリ';

  @override
  String get foodPotato => 'ジャガイモ';

  @override
  String get foodChickenSoup => 'チキンスープ';

  @override
  String get foodTomatoSoup => 'トマトスープ';

  @override
  String get foodVegetableSoup => '野菜スープ';

  @override
  String get foodMinestrone => 'ミネストローネ';

  @override
  String get foodMisoSoup => '味噌汁';

  @override
  String get foodMushroomSoup => 'マッシュルームスープ';

  @override
  String get foodBeefStew => 'ビーフシチュー';

  @override
  String get foodLentilSoup => 'レンズ豆スープ';

  @override
  String get foodOnionSoup => 'オニオンスープ';

  @override
  String get foodMilk => '牛乳';

  @override
  String get foodYogurt => 'ギリシャヨーグルト';

  @override
  String get foodCheese => 'チェダーチーズ';

  @override
  String get foodCottageCheese => 'カッテージチーズ';

  @override
  String get foodButter => 'バター';

  @override
  String get foodCream => '生クリーム';

  @override
  String get foodIceCream => 'アイスクリーム';

  @override
  String get foodMozzarella => 'モッツァレラ';

  @override
  String get foodParmesan => 'パルメザン';

  @override
  String get foodChickenBreast => '鶏胸肉';

  @override
  String get foodBeef => '挽き肉';

  @override
  String get foodSalmon => 'サーモン';

  @override
  String get foodEggs => '卵';

  @override
  String get foodTuna => 'ツナ';

  @override
  String get foodPork => 'ポークチョップ';

  @override
  String get foodTurkey => '七面鳥';

  @override
  String get foodShrimp => 'エビ';

  @override
  String get foodBacon => 'ベーコン';

  @override
  String get foodBigMac => 'ビッグマック';

  @override
  String get foodPizza => 'ピザスライス';

  @override
  String get foodFrenchFries => 'フライドポテト';

  @override
  String get foodChickenNuggets => 'チキンナゲット';

  @override
  String get foodHotDog => 'ホットドッグ';

  @override
  String get foodTacos => 'タコス';

  @override
  String get foodSubway => 'サブウェイサンド';

  @override
  String get foodDonut => 'ドーナツ';

  @override
  String get foodBurgerKing => 'ワッパー';

  @override
  String get foodSausage => 'ソーセージ';

  @override
  String get foodKefir => 'ケフィア';

  @override
  String get foodRyazhenka => 'リャジェンカ';

  @override
  String get foodDoner => 'ドネル';

  @override
  String get foodShawarma => 'シャワルマ';

  @override
  String get foodBorscht => 'ボルシチ';

  @override
  String get foodRamen => 'ラーメン';

  @override
  String get foodCabbage => 'キャベツ';

  @override
  String get foodPeaSoup => '豆スープ';

  @override
  String get foodSolyanka => 'ソリャンカ';

  @override
  String get meals => '食';

  @override
  String get dailyProgress => '1日進捗';

  @override
  String get fromFood => '食品から';

  @override
  String get noFoodThisWeek => '今週の食品データなし';

  @override
  String get foodIntake => '食事摂取';

  @override
  String get foodStats => '食品統計';

  @override
  String get totalCalories => '総カロリー';

  @override
  String get avgCaloriesPerDay => '平均/日';

  @override
  String get daysWithFood => '食事日';

  @override
  String get avgMealsPerDay => '食/日';

  @override
  String get caloriesPerDay => 'カロリー/日';

  @override
  String get sugarPerDay => '砂糖/日';

  @override
  String get foodTracking => '食品追跡';

  @override
  String get foodTrackingPro => '食品の水分とHRI影響追跡';

  @override
  String get hydrationBalance => '水分バランス';

  @override
  String get highSodiumFood => '食品から高Na';

  @override
  String get hydratingFood => '素晴らしい水分選択';

  @override
  String get dryFood => '低水分食品';

  @override
  String get balancedFood => 'バランス栄養';

  @override
  String get foodAdviceEmpty => '水分影響追跡のため食事追加';

  @override
  String get foodAdviceHighSodium => '高Na検出。水分増量でバランス';

  @override
  String get foodAdviceLowWater => '食品水分低。追加の水を検討';

  @override
  String get foodAdviceGoodHydration => '素晴らしい！食品が水分補助';

  @override
  String get foodAdviceBalanced => '良い栄養！水を忘れずに';

  @override
  String get richInElectrolytes => '電解質豊富';

  @override
  String recommendedCalories(int calories) {
    return '推奨カロリー: 約$calories kcal/日';
  }

  @override
  String get proWelcomeTitle => 'HydraCoach PROへようこそ！';

  @override
  String get proTrialActivated => '7日トライアル有効化！';

  @override
  String get proFeaturePersonalizedRecommendations => '個人推奨';

  @override
  String get proFeatureAdvancedAnalytics => '高度分析';

  @override
  String get proFeatureWorkoutTracking => '運動追跡';

  @override
  String get proFeatureElectrolyteControl => '電解質管理';

  @override
  String get proFeatureSmartReminders => 'スマート通知';

  @override
  String get proFeatureHriIndex => 'HRI指数';

  @override
  String get proFeatureAchievements => 'PRO達成';

  @override
  String get proFeaturePersonalizedDescription => '個人水分助言';

  @override
  String get proFeatureAdvancedDescription => '詳細グラフと統計';

  @override
  String get proFeatureWorkoutDescription => 'スポーツ中の水分損失追跡';

  @override
  String get proFeatureElectrolyteDescription => 'Na、K、Mg監視';

  @override
  String get proFeatureSmartDescription => '個人通知';

  @override
  String get proFeatureNoMoreAds => '広告なし！';

  @override
  String get proFeatureNoMoreAdsDescription => '広告なしで水分追跡を楽しむ';

  @override
  String get proFeatureHriDescription => 'リアルタイム水分リスク指数';

  @override
  String get proFeatureAchievementsDescription => '専用報酬と目標';

  @override
  String get startUsing => '使用開始';

  @override
  String get sayGoodbyeToAds => '広告にさよなら。プレミアムへ。';

  @override
  String get goPremium => 'プレミアムへ';

  @override
  String get removeAdsForever => '広告永久削除';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get support => 'サポート';

  @override
  String get companyWebsite => '会社ウェブサイト';

  @override
  String get appStoreOpened => 'ストア開封';

  @override
  String get linkCopiedToClipboard => 'リンクコピー';

  @override
  String get shareDialogOpened => '共有開封';

  @override
  String get linkForSharingCopied => '共有リンクコピー';

  @override
  String get websiteOpenedInBrowser => 'ブラウザで開封';

  @override
  String get emailClientOpened => 'メール開封';

  @override
  String get emailCopiedToClipboard => 'メールコピー';

  @override
  String get privacyPolicyOpened => 'プライバシー開封';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringまでの統計';
  }

  @override
  String get monthlyInsights => '月間分析';

  @override
  String get average => '平均';

  @override
  String get daysOver => '超過日';

  @override
  String get maximum => '最大';

  @override
  String get balance => 'バランス';

  @override
  String get allNormal => '全て正常';

  @override
  String get excellentConsistency => '⭐ 優秀一貫性';

  @override
  String get goodResults => '📊 良好結果';

  @override
  String get positiveImprovement => '良好改善';

  @override
  String get physicalActivity => '💪 身体活動';

  @override
  String get coffeeConsumption => '☕ コーヒー消費';

  @override
  String get excellentSobriety => '🎯 優秀禁酒';

  @override
  String get excellentMonth => '✨ 優秀な月';

  @override
  String get keepGoingMotivation => '続けよう！';

  @override
  String get daysNormal => '日正常';

  @override
  String get electrolyteBalance => '電解質要注意';

  @override
  String get caffeineWarning => '安全用量超過日(400mg)';

  @override
  String get sugarFrequentExcess => '頻繁超過砂糖が水分影響';

  @override
  String get averagePerDayShort => '/日';

  @override
  String get highWarning => '高';

  @override
  String get normalStatus => '正常';

  @override
  String improvementToEnd(int percent) {
    return '月末に向け$percent%改善';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent%日に運動(${hours}h)';
  }

  @override
  String coffeeAverage(String avg) {
    return '平均$avg杯/日';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent%日飲酒なし';
  }

  @override
  String get daySummary => '日要約';

  @override
  String get records => '記録';

  @override
  String waterGoalAchievement(int percent) {
    return '水分目標達成: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return '運動: $count回';
  }

  @override
  String get index => '指数';

  @override
  String get status => '状態';

  @override
  String get moderateRisk => '中リスク';

  @override
  String get excess => '超過';

  @override
  String get whoLimit => 'WHO上限: 50g/日';

  @override
  String stability(int percent) {
    return '$percent%日で安定';
  }

  @override
  String goodHydration(int percent) {
    return '$percent%日良好水分';
  }

  @override
  String daysInNorm(int count) {
    return '$count日正常範囲';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent%日良好水分';
  }

  @override
  String stabilityDays(int percent) {
    return '$percent%日で安定';
  }

  @override
  String monthEndImprovement(int percent) {
    return '月末$percent%改善';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent%日運動(${hours}h)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return '平均$avgCups杯/日';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent%日飲酒なし';
  }

  @override
  String get moderateRiskStatus => '状態: 中リスク';

  @override
  String get high => '高';

  @override
  String get whoLimitPerDay => 'WHO上限: 50g/日';
}
