// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HydraCoach';

  @override
  String get getPro => 'Get PRO';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get loadingWeather => 'Loading weather...';

  @override
  String get heatIndex => 'Heat Index';

  @override
  String humidity(int value) {
    return 'Humidity';
  }

  @override
  String get water => 'Water';

  @override
  String get liquids => 'Liquids';

  @override
  String get sodium => 'Sodium';

  @override
  String get potassium => 'Potassium';

  @override
  String get magnesium => 'Magnesium';

  @override
  String get electrolyte => 'Electrolyte';

  @override
  String get broth => 'Broth';

  @override
  String get coffee => 'Coffee';

  @override
  String get alcohol => 'Alcohol';

  @override
  String get drink => 'Drink';

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
    return 'Heat +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'Alcohol +$amount ml';
  }

  @override
  String get smartAdviceTitle => 'Tip for now';

  @override
  String get smartAdviceDefault => 'Maintain water and electrolyte balance.';

  @override
  String get adviceOverhydrationSevere => 'Water overload (>200% goal)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Pause 60-90 minutes. Add electrolytes: 300-500 ml with 500-1000 mg sodium.';

  @override
  String get adviceOverhydration => 'Overhydration';

  @override
  String get adviceOverhydrationBody =>
      'Pause water for 30-60 minutes and add ~500 mg sodium (electrolyte/broth).';

  @override
  String get adviceAlcoholRecovery => 'Alcohol: recovery';

  @override
  String get adviceAlcoholRecoveryBody =>
      'No more alcohol today. Drink 300-500 ml water in small portions and add sodium.';

  @override
  String get adviceLowSodium => 'Low sodium';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Add ~$amount mg sodium. Drink moderately.';
  }

  @override
  String get adviceDehydration => 'Under-hydrated';

  @override
  String adviceDehydrationBody(String type) {
    return 'Drink 300-500 ml $type.';
  }

  @override
  String get adviceHighRisk => 'High risk (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Urgently drink water with electrolytes (300-500 ml) and reduce activity.';

  @override
  String get adviceHeat => 'Heat and losses';

  @override
  String get adviceHeatBody =>
      'Increase water by +5-8% and add 300-500 mg sodium.';

  @override
  String get adviceAllGood => 'All on track';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Keep the pace. Target: ~$amount ml more to goal.';
  }

  @override
  String get hydrationStatus => 'Hydration Status';

  @override
  String get hydrationStatusNormal => 'Normal';

  @override
  String get hydrationStatusDiluted => 'Diluting';

  @override
  String get hydrationStatusDehydrated => 'Under-hydrated';

  @override
  String get hydrationStatusLowSalt => 'Low salt';

  @override
  String get hydrationRiskIndex => 'Hydration Risk Index';

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get todaysDrinks => 'Today\'s Drinks';

  @override
  String get allRecords => 'All records →';

  @override
  String itemDeleted(String item) {
    return '$item deleted';
  }

  @override
  String get undo => 'Undo';

  @override
  String get dailyReportReady => 'Daily report ready!';

  @override
  String get viewDayResults => 'View day results';

  @override
  String get dailyReportComingSoon =>
      'Daily report will be available in the next version';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSettings => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get profileSection => 'Profile';

  @override
  String get weight => 'Weight';

  @override
  String get dietMode => 'Diet Mode';

  @override
  String get activityLevel => 'Activity Level';

  @override
  String get changeWeight => 'Change Weight';

  @override
  String get dietModeNormal => 'Normal Diet';

  @override
  String get dietModeKeto => 'Keto / Low-carb';

  @override
  String get dietModeFasting => 'Intermittent Fasting';

  @override
  String get activityLow => 'Low Activity';

  @override
  String get activityMedium => 'Medium Activity';

  @override
  String get activityHigh => 'High Activity';

  @override
  String get activityLowDesc => 'Office work, little movement';

  @override
  String get activityMediumDesc => '30-60 minutes of exercise per day';

  @override
  String get activityHighDesc => 'Workouts >1 hour';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get notificationLimit => 'Notification Limit (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Used: $used of $limit';
  }

  @override
  String get waterReminders => 'Water Reminders';

  @override
  String get waterRemindersDesc => 'Regular reminders throughout the day';

  @override
  String get reminderFrequency => 'Reminder Frequency';

  @override
  String timesPerDay(int count) {
    return '$count times per day';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count times per day (max 4)';
  }

  @override
  String get unlimitedReminders => 'Unlimited';

  @override
  String get startOfDay => 'Start of Day';

  @override
  String get endOfDay => 'End of Day';

  @override
  String get postCoffeeReminders => 'Post-Coffee Reminders';

  @override
  String get postCoffeeRemindersDesc =>
      'Remind to drink water after 20 minutes';

  @override
  String get heatWarnings => 'Heat Warnings';

  @override
  String get heatWarningsDesc => 'Notifications in high temperatures';

  @override
  String get postAlcoholReminders => 'Post-Alcohol Reminders';

  @override
  String get postAlcoholRemindersDesc => 'Recovery plan for 6-12 hours';

  @override
  String get proFeaturesSection => 'PRO Features';

  @override
  String get unlockPro => 'Unlock PRO';

  @override
  String get unlockProDesc => 'Unlimited notifications and smart reminders';

  @override
  String get noNotificationLimit => 'No notification limit';

  @override
  String get unitsSection => 'Units';

  @override
  String get metricSystem => 'Metric System';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Imperial System';

  @override
  String get imperialUnits => 'oz, lb, °F';

  @override
  String get aboutSection => 'About';

  @override
  String get version => 'Version';

  @override
  String get rateApp => 'Rate App';

  @override
  String get share => 'Share';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get resetDataTitle => 'Reset all data?';

  @override
  String get resetDataMessage =>
      'This will delete all history and restore settings to defaults.';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get welcomeTitle => 'Welcome to\nHydraCoach';

  @override
  String get welcomeSubtitle =>
      'Smart water and electrolyte tracking\nfor keto, fasting and active life';

  @override
  String get weightPageTitle => 'Your weight';

  @override
  String get weightPageSubtitle => 'To calculate optimal water amount';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Recommended norm: $min-$max ml of water per day';
  }

  @override
  String get dietPageTitle => 'Diet Mode';

  @override
  String get dietPageSubtitle => 'This affects electrolyte needs';

  @override
  String get normalDiet => 'Normal diet';

  @override
  String get normalDietDesc => 'Standard recommendations';

  @override
  String get ketoDiet => 'Keto / Low-carb';

  @override
  String get ketoDietDesc => 'Increased salt needs';

  @override
  String get fastingDiet => 'Intermittent Fasting';

  @override
  String get fastingDietDesc => 'Special electrolyte regime';

  @override
  String get fastingSchedule => 'Fasting schedule:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Daily 8-hour window';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'One meal a day';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Alternate day fasting';

  @override
  String get activityPageTitle => 'Activity Level';

  @override
  String get activityPageSubtitle => 'Affects water needs';

  @override
  String get lowActivity => 'Low activity';

  @override
  String get lowActivityDesc => 'Office work, little movement';

  @override
  String get lowActivityWater => '+0 ml water';

  @override
  String get mediumActivity => 'Medium activity';

  @override
  String get mediumActivityDesc => '30-60 minutes of exercise per day';

  @override
  String get mediumActivityWater => '+350-700 ml water';

  @override
  String get highActivity => 'High activity';

  @override
  String get highActivityDesc => 'Workouts >1 hour or physical labor';

  @override
  String get highActivityWater => '+700-1200 ml water';

  @override
  String get activityAdjustmentNote =>
      'We\'ll adjust goals based on your workouts';

  @override
  String get day => 'Day';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noData => 'No data';

  @override
  String get noRecordsToday => 'No records for today yet';

  @override
  String get noRecordsThisDay => 'No records for this day';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get deleteRecord => 'Delete record?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return 'Delete $type $volume ml?';
  }

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get waterConsumption => '💧 Water consumption';

  @override
  String get alcoholWeek => '🍺 Alcohol this week';

  @override
  String get electrolytes => '⚡ Electrolytes';

  @override
  String get weeklyAverages => '📊 Weekly averages';

  @override
  String get monthStatistics => '📊 Month statistics';

  @override
  String get alcoholStatistics => '🍺 Alcohol statistics';

  @override
  String get alcoholStatisticsTitle => 'Alcohol statistics';

  @override
  String get weeklyInsights => '💡 Weekly insights';

  @override
  String get waterPerDay => 'Water per day';

  @override
  String get sodiumPerDay => 'Sodium per day';

  @override
  String get potassiumPerDay => 'Potassium per day';

  @override
  String get magnesiumPerDay => 'Magnesium per day';

  @override
  String get goal => 'Goal';

  @override
  String get daysWithGoalAchieved => '✅ Days with goal achieved';

  @override
  String get recordsPerDay => '📝 Records per day';

  @override
  String get insufficientDataForAnalysis => 'Insufficient data for analysis';

  @override
  String get totalVolume => 'Total volume';

  @override
  String averagePerDay(int amount) {
    return 'Average $amount ml/day';
  }

  @override
  String get activeDays => 'Active days';

  @override
  String perfectDays(int count) {
    return 'Days with perfect goal: $count';
  }

  @override
  String currentStreak(int days) {
    return 'Current streak: $days days';
  }

  @override
  String soberDaysRow(int days) {
    return 'Sober days in a row: $days';
  }

  @override
  String get keepItUp => 'Keep it up!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Water: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Alcohol: $amount SD';
  }

  @override
  String get totalSD => 'Total SD';

  @override
  String get forMonth => 'for month';

  @override
  String get daysWithAlcohol => 'Days with alcohol';

  @override
  String fromDays(int days) {
    return 'from $days';
  }

  @override
  String get soberDays => 'Sober days';

  @override
  String get excellent => 'excellent!';

  @override
  String get averageSD => 'Average SD';

  @override
  String get inDrinkingDays => 'in drinking days';

  @override
  String get bestDay => '🏆 Best day';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% of goal';
  }

  @override
  String get weekends => '📅 Weekends';

  @override
  String get weekdays => '📅 Weekdays';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'You drink $percent% less on weekends';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'You drink $percent% less on weekdays';
  }

  @override
  String get positiveTrend => '📈 Positive trend';

  @override
  String get positiveTrendMessage =>
      'Your hydration improves by the end of the week';

  @override
  String get decliningActivity => '📉 Declining activity';

  @override
  String get decliningActivityMessage =>
      'Water consumption decreases by the end of the week';

  @override
  String get lowSalt => '⚠️ Low salt';

  @override
  String lowSaltMessage(int days) {
    return 'Only $days days with normal sodium levels';
  }

  @override
  String get frequentAlcohol => '🍺 Frequent consumption';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Alcohol $days days out of 7 affects hydration';
  }

  @override
  String get excellentWeek => '✅ Excellent week';

  @override
  String get continueMessage => 'Keep up the good work!';

  @override
  String get all => 'All';

  @override
  String get addAlcohol => 'Add alcohol';

  @override
  String get minimumHarm => 'Minimum harm';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml water needed';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg sodium to add';
  }

  @override
  String get goToBedEarly => 'Go to bed early';

  @override
  String get todayConsumed => 'Today consumed:';

  @override
  String get alcoholToday => 'Alcohol today';

  @override
  String get beer => 'Beer';

  @override
  String get wine => 'Wine';

  @override
  String get spirits => 'Spirits';

  @override
  String get cocktail => 'Cocktail';

  @override
  String get selectDrinkType => 'Select drink type:';

  @override
  String get volume => 'Volume (ml):';

  @override
  String get enterVolume => 'Enter volume in ml';

  @override
  String get strength => 'Strength (%):';

  @override
  String get standardDrinks => 'Standard drinks:';

  @override
  String get additionalWater => 'Add. water';

  @override
  String get additionalSodium => 'Add. sodium';

  @override
  String get hriRisk => 'HRI risk';

  @override
  String get enterValidVolume => 'Please enter a valid volume';

  @override
  String get weeklyHistory => 'Weekly history';

  @override
  String get weeklyHistoryDesc =>
      'Analyze weekly trends, get insights and recommendations';

  @override
  String get monthlyHistory => 'Monthly history';

  @override
  String get monthlyHistoryDesc =>
      'Long-term patterns, week comparisons and deep analytics';

  @override
  String get proFunction => 'PRO function';

  @override
  String get unlockProHistory => 'Unlock PRO';

  @override
  String get unlimitedHistory => 'Unlimited history';

  @override
  String get dataExportCSV => 'Export data to CSV';

  @override
  String get detailedAnalytics => 'Detailed analytics';

  @override
  String get periodComparison => 'Period comparison';

  @override
  String get shareResult => 'Share result';

  @override
  String get retry => 'Retry';

  @override
  String get welcomeToPro => 'Welcome to PRO!';

  @override
  String get allFeaturesUnlocked => 'All features are unlocked';

  @override
  String get testMode => 'Test Mode: Using mock purchase';

  @override
  String get proStatusNote => 'PRO status will persist until app restart';

  @override
  String get startUsingPro => 'Start using PRO';

  @override
  String get lifetimeAccess => 'Lifetime access';

  @override
  String get bestValueAnnual => 'Best value — Annual';

  @override
  String get monthly => 'Monthly';

  @override
  String get oneTime => 'one-time';

  @override
  String get perYear => '/year';

  @override
  String get perMonth => '/month';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/mo';
  }

  @override
  String get startFreeTrial => 'Start 7-day free trial';

  @override
  String continueWithPrice(String price) {
    return 'Continue — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Unlock for $price (one-time)';
  }

  @override
  String get enableFreeTrial => 'Enable 7-day free trial';

  @override
  String get noChargeToday =>
      'No charge today. After 7 days, your subscription renews automatically unless canceled.';

  @override
  String get cancelAnytime => 'You can cancel anytime in Settings.';

  @override
  String get everythingInPro => 'Everything in PRO';

  @override
  String get smartReminders => 'Smart reminders';

  @override
  String get smartRemindersDesc => 'Heat, workouts, fasting — no spam.';

  @override
  String get weeklyReports => 'Weekly reports';

  @override
  String get weeklyReportsDesc => 'Deep insights + CSV export.';

  @override
  String get healthIntegrations => 'Health integrations';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit.';

  @override
  String get alcoholProtocols => 'Alcohol protocols';

  @override
  String get alcoholProtocolsDesc => 'Pre-drink prep & recovery roadmap.';

  @override
  String get fullSync => 'Full sync';

  @override
  String get fullSyncDesc => 'Unlimited history across devices.';

  @override
  String get personalCalibrations => 'Personal calibrations';

  @override
  String get personalCalibrationsDesc => 'Sweat test, urine color scale.';

  @override
  String get showAllFeatures => 'Show all features';

  @override
  String get showLess => 'Show less';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get proSubscriptionRestored => 'PRO subscription restored!';

  @override
  String get noPurchasesToRestore => 'No purchases found to restore';

  @override
  String get drinkMoreWaterToday => 'Drink more water today (+20%)';

  @override
  String get addElectrolytesToWater => 'Add electrolytes to each water intake';

  @override
  String get limitCoffeeOneCup => 'Limit coffee to one cup';

  @override
  String get increaseWater10 => 'Increase water by 10%';

  @override
  String get dontForgetElectrolytes => 'Don\'t forget electrolytes';

  @override
  String get startDayWithWater => 'Start your day with a glass of water';

  @override
  String get dontForgetElectrolytesReminder => '⚡ Don\'t forget electrolytes';

  @override
  String get startDayWithWaterReminder =>
      'Start your day with a glass of water for good wellbeing';

  @override
  String get takeElectrolytesMorning => 'Take electrolytes in the morning';

  @override
  String purchaseFailed(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — trusted by 12,000 users';

  @override
  String get bestValue => 'Best value';

  @override
  String percentOff(int percent) {
    return '-$percent% Best value';
  }

  @override
  String get weatherUnavailable => 'Weather unavailable';

  @override
  String get checkLocationPermissions =>
      'Check location permissions and internet';

  @override
  String get currentLocation => 'Current location';

  @override
  String get weatherClear => 'clear';

  @override
  String get weatherCloudy => 'cloudy';

  @override
  String get weatherOvercast => 'overcast';

  @override
  String get weatherRain => 'rain';

  @override
  String get weatherSnow => 'snow';

  @override
  String get weatherStorm => 'storm';

  @override
  String get weatherFog => 'fog';

  @override
  String get weatherDrizzle => 'drizzle';

  @override
  String get weatherSunny => 'sunny';

  @override
  String get heatWarningExtreme => '☀️ Extreme heat! Maximum hydration';

  @override
  String get heatWarningVeryHot => '🌡️ Very hot! Risk of dehydration';

  @override
  String get heatWarningHot => '🔥 Hot! Drink more water';

  @override
  String get heatWarningElevated => '⚠️ Elevated temperature';

  @override
  String get heatWarningComfortable => 'Comfortable temperature';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% water';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg sodium';
  }

  @override
  String get heatWarningCold => '❄️ Cold! Warm up and drink warm fluids';

  @override
  String get notificationChannelName => 'HydraCoach Reminders';

  @override
  String get notificationChannelDescription =>
      'Water and electrolyte reminders';

  @override
  String get urgentNotificationChannelName => 'Urgent Reminders';

  @override
  String get urgentNotificationChannelDescription =>
      'Important hydration notifications';

  @override
  String get goodMorning => '☀️ Good morning!';

  @override
  String get timeToHydrate => '💧 Time to hydrate';

  @override
  String get eveningHydration => '💧 Evening hydration';

  @override
  String get dailyReportTitle => '📊 Daily report ready';

  @override
  String get dailyReportBody => 'See how your hydration day went';

  @override
  String get maintainWaterBalance =>
      'Maintain water balance throughout the day';

  @override
  String get electrolytesTime =>
      'Time for electrolytes: add a pinch of salt to water';

  @override
  String catchUpHydration(int percent) {
    return 'You\'ve drunk only $percent% of daily norm. Time to catch up!';
  }

  @override
  String get excellentProgress =>
      'Excellent progress! A bit more to reach the goal';

  @override
  String get postCoffeeTitle => '☕ After coffee';

  @override
  String get postCoffeeBody => 'Drink 250-300 ml water to restore balance';

  @override
  String get postWorkoutTitle => '💪 After workout';

  @override
  String get postWorkoutBody =>
      'Restore electrolytes: 500 ml water + pinch of salt';

  @override
  String get heatWarningPro => '🌡️ PRO Heat warning';

  @override
  String get extremeHeatWarning =>
      'Extreme heat! Increase water consumption by 15% and add 1g salt';

  @override
  String get hotWeatherWarning =>
      'Hot! Drink 10% more water and don\'t forget electrolytes';

  @override
  String get warmWeatherWarning => 'Warm weather. Monitor your hydration';

  @override
  String get alcoholRecoveryTitle => '🍺 Recovery time';

  @override
  String get alcoholRecoveryBody =>
      'Drink 300 ml water with a pinch of salt for balance';

  @override
  String get continueHydration => '💧 Continue hydration';

  @override
  String get alcoholRecoveryBody2 =>
      'Another 500 ml water will help you recover faster';

  @override
  String get morningRecoveryTitle => '☀️ Morning recovery';

  @override
  String get morningRecoveryBody =>
      'Start the day with 500 ml water and electrolytes';

  @override
  String get testNotificationTitle => '🧪 Test notification';

  @override
  String get testNotificationBody =>
      'If you see this - instant notifications work!';

  @override
  String get scheduledTestTitle => '⏰ Scheduled test (1 min)';

  @override
  String get scheduledTestBody =>
      'This notification was scheduled 1 minute ago. Scheduling works!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService initialized';

  @override
  String get localNotificationsInitialized =>
      '✅ Local notifications initialized';

  @override
  String get androidChannelsCreated =>
      '📢 Android notification channels created';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Notifications permission: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Exact alarms permission: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM permissions: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM Token received';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCM Token saved to Firestore for user $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ Topic subscription complete';

  @override
  String foregroundMessage(String title) {
    return '📨 Foreground message: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Notification opened: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Daily notification limit reached (4/day for FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Notification scheduling error: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Showing notification immediately as fallback';

  @override
  String instantNotificationShown(String title) {
    return '📬 Instant notification shown: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 Scheduling smart reminders...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ Scheduled $count reminders';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: Post-coffee reminder scheduled';

  @override
  String get postWorkoutScheduled => '💪 Post-workout reminder scheduled';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Heat warning sent';

  @override
  String get proAlcoholRecoveryPlan =>
      '🍺 PRO: Alcohol recovery plan scheduled';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Evening report scheduled for $day.$month at 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Notification $id cancelled';
  }

  @override
  String get allNotificationsCancelled => '🗑️ All notifications cancelled';

  @override
  String get reminderSettingsSaved => '✅ Reminder settings saved';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Test notification scheduled for $time';
  }

  @override
  String get tomorrowRecommendations => 'Recommendations for tomorrow';

  @override
  String get recommendationExcellent =>
      'Excellent work! Keep it up. Try to start the day with a glass of water and maintain even consumption.';

  @override
  String get recommendationDiluted =>
      'You drink a lot of water but few electrolytes. Tomorrow add more salt or drink an electrolyte beverage. Try starting the day with salty broth.';

  @override
  String get recommendationDehydrated =>
      'Not enough water today. Tomorrow set reminders every 2 hours. Keep a water bottle in sight.';

  @override
  String get recommendationLowSalt =>
      'Low sodium levels can cause fatigue. Add a pinch of salt to water or drink broth. Especially important on keto or fasting.';

  @override
  String get recommendationGeneral =>
      'Aim for balance between water and electrolytes. Drink evenly throughout the day and don\'t forget salt in heat.';

  @override
  String get category_water => 'Water';

  @override
  String get category_hot_drinks => 'Hot Drinks';

  @override
  String get category_juice => 'Juices';

  @override
  String get category_sports => 'Sports';

  @override
  String get category_dairy => 'Dairy';

  @override
  String get category_alcohol => 'Alcohol';

  @override
  String get category_supplements => 'Supplements';

  @override
  String get category_other => 'Other';

  @override
  String get drink_water => 'Water';

  @override
  String get drink_sparkling_water => 'Sparkling Water';

  @override
  String get drink_mineral_water => 'Mineral Water';

  @override
  String get drink_coconut_water => 'Coconut Water';

  @override
  String get drink_coffee => 'Coffee';

  @override
  String get drink_espresso => 'Espresso';

  @override
  String get drink_americano => 'Americano';

  @override
  String get drink_cappuccino => 'Cappuccino';

  @override
  String get drink_latte => 'Latte';

  @override
  String get drink_black_tea => 'Black Tea';

  @override
  String get drink_green_tea => 'Green Tea';

  @override
  String get drink_herbal_tea => 'Herbal Tea';

  @override
  String get drink_matcha => 'Matcha';

  @override
  String get drink_hot_chocolate => 'Hot Chocolate';

  @override
  String get drink_orange_juice => 'Orange Juice';

  @override
  String get drink_apple_juice => 'Apple Juice';

  @override
  String get drink_grapefruit_juice => 'Grapefruit Juice';

  @override
  String get drink_tomato_juice => 'Tomato Juice';

  @override
  String get drink_vegetable_juice => 'Vegetable Juice';

  @override
  String get drink_smoothie => 'Smoothie';

  @override
  String get drink_lemonade => 'Lemonade';

  @override
  String get drink_isotonic => 'Isotonic Drink';

  @override
  String get drink_electrolyte => 'Electrolyte Drink';

  @override
  String get drink_protein_shake => 'Protein Shake';

  @override
  String get drink_bcaa => 'BCAA Drink';

  @override
  String get drink_energy => 'Energy Drink';

  @override
  String get drink_milk => 'Milk';

  @override
  String get drink_kefir => 'Kefir';

  @override
  String get drink_yogurt => 'Yogurt Drink';

  @override
  String get drink_almond_milk => 'Almond Milk';

  @override
  String get drink_soy_milk => 'Soy Milk';

  @override
  String get drink_oat_milk => 'Oat Milk';

  @override
  String get drink_beer_light => 'Light Beer';

  @override
  String get drink_beer_regular => 'Regular Beer';

  @override
  String get drink_beer_strong => 'Strong Beer';

  @override
  String get drink_wine_red => 'Red Wine';

  @override
  String get drink_wine_white => 'White Wine';

  @override
  String get drink_champagne => 'Champagne';

  @override
  String get drink_vodka => 'Vodka';

  @override
  String get drink_whiskey => 'Whiskey';

  @override
  String get drink_rum => 'Rum';

  @override
  String get drink_gin => 'Gin';

  @override
  String get drink_tequila => 'Tequila';

  @override
  String get drink_mojito => 'Mojito';

  @override
  String get drink_margarita => 'Margarita';

  @override
  String get drink_kombucha => 'Kombucha';

  @override
  String get drink_kvass => 'Kvass';

  @override
  String get drink_bone_broth => 'Bone Broth';

  @override
  String get drink_vegetable_broth => 'Vegetable Broth';

  @override
  String get drink_soda => 'Soda';

  @override
  String get drink_diet_soda => 'Diet Soda';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get favoriteLimitReached =>
      'Favorites limit reached (3 for FREE, 20 for PRO)';

  @override
  String get addFavorite => 'Add favorite';

  @override
  String get hotAndSupplements => 'Hot & Supplements';

  @override
  String get quickVolumes => 'Quick volumes:';

  @override
  String get type => 'Type:';

  @override
  String get regular => 'Regular';

  @override
  String get coconut => 'Coconut';

  @override
  String get sparkling => 'Sparkling';

  @override
  String get mineral => 'Mineral';

  @override
  String get hotDrinks => 'Hot Drinks';

  @override
  String get supplements => 'Supplements';

  @override
  String get tea => 'Tea';

  @override
  String get salt => 'Salt (1/4 tsp)';

  @override
  String get electrolyteMix => 'Electrolyte Mix';

  @override
  String get boneBroth => 'Bone Broth';

  @override
  String get favoriteAssignmentComingSoon => 'Favorite assignment coming soon';

  @override
  String get longPressToEditComingSoon => 'Long press to edit - coming soon';

  @override
  String get proSubscriptionRequired => 'PRO subscription required';

  @override
  String get saveToFavorites => 'Save to favorites';

  @override
  String get savedToFavorites => 'Saved to favorites';

  @override
  String get selectFavoriteSlot => 'Select favorite slot';

  @override
  String get slot => 'Slot';

  @override
  String get emptySlot => 'Empty slot';

  @override
  String get upgradeToUnlock => 'Upgrade to PRO to unlock';

  @override
  String get changeFavorite => 'Change favorite';

  @override
  String get removeFavorite => 'Remove favorite';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'Mineral Water';

  @override
  String get coconutWater => 'Coconut Water';

  @override
  String get lemonWater => 'Lemon Water';

  @override
  String get greenTea => 'Green Tea';

  @override
  String get amount => 'Amount';

  @override
  String get createFavoriteHint =>
      'To add a favorite, go to any drink screen below and tap \'Save to favorites\' button after setting up your drink.';

  @override
  String get sparklingWater => 'Sparkling Water';

  @override
  String get cola => 'Cola';

  @override
  String get juice => 'Juice';

  @override
  String get energyDrink => 'Energy Drink';

  @override
  String get sportsDrink => 'Sports Drink';

  @override
  String get selectElectrolyteType => 'Select electrolyte type:';

  @override
  String get saltQuarterTsp => 'Salt (1/4 tsp)';

  @override
  String get pinkSalt => 'Pink Himalayan Salt';

  @override
  String get seaSalt => 'Sea Salt';

  @override
  String get potassiumCitrate => 'Potassium Citrate';

  @override
  String get magnesiumGlycinate => 'Magnesium Glycinate';

  @override
  String get coconutWaterElectrolyte => 'Coconut Water';

  @override
  String get sportsDrinkElectrolyte => 'Sports Drink';

  @override
  String get electrolyteContent => 'Electrolyte content:';

  @override
  String sodiumContent(int amount) {
    return 'Sodium: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return 'Potassium: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Magnesium: $amount mg';
  }

  @override
  String get servings => 'Servings';

  @override
  String get enterServings => 'Enter servings';

  @override
  String get servingsUnit => 'servings';

  @override
  String get noElectrolytes => 'No electrolytes';

  @override
  String get enterValidAmount => 'Please enter a valid amount';

  @override
  String get lmntMix => 'LMNT Mix';

  @override
  String get pickleJuice => 'Pickle Juice';

  @override
  String get tomatoSalt => 'Tomato + Salt';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'Alkaline Water';

  @override
  String get celticSalt => 'Celtic Salt Water';

  @override
  String get soleWater => 'Sole Water';

  @override
  String get mineralDrops => 'Mineral Drops';

  @override
  String get bakingSoda => 'Baking Soda Water';

  @override
  String get creamTartar => 'Cream of Tartar';

  @override
  String get selectSupplementType => 'Select supplement type:';

  @override
  String get multivitamin => 'Multivitamin';

  @override
  String get magnesiumCitrate => 'Magnesium Citrate';

  @override
  String get magnesiumThreonate => 'Magnesium L-Threonate';

  @override
  String get calciumCitrate => 'Calcium Citrate';

  @override
  String get zincGlycinate => 'Zinc Glycinate';

  @override
  String get vitaminD3 => 'Vitamin D3';

  @override
  String get vitaminC => 'Vitamin C';

  @override
  String get bComplex => 'B-Complex';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => 'Iron Bisglycinate';

  @override
  String get dosage => 'Dosage';

  @override
  String get enterDosage => 'Enter dosage';

  @override
  String get noElectrolyteContent => 'No electrolyte content';

  @override
  String get blackTea => 'Black Tea';

  @override
  String get herbalTea => 'Herbal Tea';

  @override
  String get espresso => 'Espresso';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get latte => 'Latte';

  @override
  String get matcha => 'Matcha';

  @override
  String get hotChocolate => 'Hot Chocolate';

  @override
  String get caffeine => 'Caffeine';

  @override
  String get sports => 'Sports';

  @override
  String get walking => 'Walking';

  @override
  String get running => 'Running';

  @override
  String get gym => 'Gym';

  @override
  String get cycling => 'Cycling';

  @override
  String get swimming => 'Swimming';

  @override
  String get yoga => 'Yoga';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'Boxing';

  @override
  String get dancing => 'Dancing';

  @override
  String get tennis => 'Tennis';

  @override
  String get teamSports => 'Team Sports';

  @override
  String get selectActivityType => 'Select activity type:';

  @override
  String get duration => 'Duration';

  @override
  String get minutes => 'minutes';

  @override
  String get enterDuration => 'Enter duration';

  @override
  String get lowIntensity => 'Low intensity';

  @override
  String get mediumIntensity => 'Medium intensity';

  @override
  String get highIntensity => 'High intensity';

  @override
  String get recommendedIntake => 'Recommended intake:';

  @override
  String get basedOnWeight => 'Based on weight';

  @override
  String get logActivity => 'Log Activity';

  @override
  String get activityLogged => 'Activity logged';

  @override
  String get enterValidDuration => 'Please enter valid duration';

  @override
  String get sauna => 'Sauna';

  @override
  String get veryHighIntensity => 'Very high intensity';

  @override
  String get hriStatusExcellent => 'Excellent';

  @override
  String get hriStatusGood => 'Good';

  @override
  String get hriStatusModerate => 'Moderate Risk';

  @override
  String get hriStatusHighRisk => 'High Risk';

  @override
  String get hriStatusCritical => 'Critical';

  @override
  String get hriComponentWater => 'Water balance';

  @override
  String get hriComponentSodium => 'Sodium level';

  @override
  String get hriComponentPotassium => 'Potassium level';

  @override
  String get hriComponentMagnesium => 'Magnesium level';

  @override
  String get hriComponentHeat => 'Heat stress';

  @override
  String get hriComponentWorkout => 'Physical activity';

  @override
  String get hriComponentCaffeine => 'Caffeine impact';

  @override
  String get hriComponentAlcohol => 'Alcohol impact';

  @override
  String get hriComponentTime => 'Time since intake';

  @override
  String get hriComponentMorning => 'Morning factors';

  @override
  String get hriBreakdownTitle => 'Risk factors breakdown';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max pts';
  }

  @override
  String get fastingModeActive => 'Fasting mode active';

  @override
  String get fastingSuppressionNote => 'Time factor suppressed during fasting';

  @override
  String get morningCheckInTitle => 'Morning Check-in';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get feelingScale1 => 'Poor';

  @override
  String get feelingScale2 => 'Below average';

  @override
  String get feelingScale3 => 'Normal';

  @override
  String get feelingScale4 => 'Good';

  @override
  String get feelingScale5 => 'Excellent';

  @override
  String get weightChange => 'Weight change from yesterday';

  @override
  String get urineColorScale => 'Urine color (1-8 scale)';

  @override
  String get urineColor1 => '1 - Very pale';

  @override
  String get urineColor2 => '2 - Pale';

  @override
  String get urineColor3 => '3 - Light yellow';

  @override
  String get urineColor4 => '4 - Yellow';

  @override
  String get urineColor5 => '5 - Dark yellow';

  @override
  String get urineColor6 => '6 - Amber';

  @override
  String get urineColor7 => '7 - Dark amber';

  @override
  String get urineColor8 => '8 - Brown';

  @override
  String get alcoholWithDecay => 'Alcohol impact (decaying)';

  @override
  String standardDrinksToday(Object count) {
    return 'Standard drinks today: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Active caffeine: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRI Debug Info';

  @override
  String hriNormalized(Object value) {
    return 'HRI (normalized): $value/100';
  }

  @override
  String get fastingWindowActive => 'Fasting window active';

  @override
  String get eatingWindowActive => 'Eating window active';

  @override
  String nextFastingWindow(Object time) {
    return 'Next fasting: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Next eating: $time';
  }

  @override
  String get todaysWorkouts => 'Today\'s Workouts';

  @override
  String get hoursAgo => 'h ago';

  @override
  String get onboardingWelcomeTitle => 'HydraCoach — smart hydration every day';

  @override
  String get onboardingWelcomeSubtitle =>
      'Drink smarter, not more\nThe app accounts for weather, electrolytes and your habits\nHelps maintain clear mind and stable energy';

  @override
  String get onboardingBullet1 =>
      'Personal water and salt norm based on weather and you';

  @override
  String get onboardingBullet2 =>
      '\"What to do now\" tips instead of raw charts';

  @override
  String get onboardingBullet3 => 'Alcohol in standard doses with safe limits';

  @override
  String get onboardingBullet4 => 'Smart reminders without spam';

  @override
  String get onboardingStartButton => 'Start';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get onboardingPracticeFasting => 'I practice intermittent fasting';

  @override
  String get onboardingPracticeFastingDesc =>
      'Special electrolyte regime for fasting windows';

  @override
  String get onboardingProfileReady => 'Profile ready!';

  @override
  String get onboardingWaterNorm => 'Water norm';

  @override
  String get onboardingIonWillHelp =>
      'ION will help maintain balance every day';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingLocationTitle => 'Weather matters for hydration';

  @override
  String get onboardingLocationSubtitle =>
      'We\'ll account for weather and humidity. This is more accurate than just a formula by weight';

  @override
  String get onboardingWeatherExample => 'Hot today! +15% water';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg sodium for heat';

  @override
  String get onboardingEnablePermission => 'Enable';

  @override
  String get onboardingEnableLater => 'Enable later';

  @override
  String get onboardingNotificationTitle => 'Smart reminders';

  @override
  String get onboardingNotificationSubtitle =>
      'Short tips at the right moment. You can change frequency in one tap';

  @override
  String get onboardingNotifExample1 => 'Time to hydrate';

  @override
  String get onboardingNotifExample2 => 'Don\'t forget electrolytes';

  @override
  String get onboardingNotifExample3 => 'Hot! Drink more water';

  @override
  String get sportRecoveryProtocols => 'Sport recovery protocols';

  @override
  String get allDrinksAndSupplements => 'All drinks & supplements';

  @override
  String get notificationChannelDefault => 'Hydration Reminders';

  @override
  String get notificationChannelDefaultDesc =>
      'Water and electrolyte reminders';

  @override
  String get notificationChannelUrgent => 'Important Notifications';

  @override
  String get notificationChannelUrgentDesc =>
      'Heat warnings and critical hydration alerts';

  @override
  String get notificationChannelReport => 'Reports';

  @override
  String get notificationChannelReportDesc => 'Daily and weekly reports';

  @override
  String get notificationWaterTitle => '💧 Time to hydrate';

  @override
  String get notificationWaterBody => 'Don\'t forget to drink water';

  @override
  String get notificationPostCoffeeTitle => '☕ After coffee';

  @override
  String get notificationPostCoffeeBody =>
      'Drink 250-300 ml water to restore balance';

  @override
  String get notificationDailyReportTitle => '📊 Daily report ready';

  @override
  String get notificationDailyReportBody => 'See how your hydration day went';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Recovery time';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return 'Drink $ml ml water with a pinch of salt';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Heat warning';

  @override
  String get notificationHeatWarningExtremeBody =>
      'Extreme heat! +15% water and +1g salt';

  @override
  String get notificationHeatWarningHotBody =>
      'Hot! +10% water and electrolytes';

  @override
  String get notificationHeatWarningWarmBody => 'Warm. Monitor your hydration';

  @override
  String get notificationWorkoutTitle => '💪 Workout';

  @override
  String get notificationWorkoutBody => 'Don\'t forget water and electrolytes';

  @override
  String get notificationPostWorkoutTitle => '💪 After workout';

  @override
  String get notificationPostWorkoutBody =>
      '500 ml water + electrolytes for recovery';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Electrolyte time';

  @override
  String get notificationFastingElectrolyteBody =>
      'Add a pinch of salt to water or drink broth';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Recovery ${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return 'Drink $ml ml water';
  }

  @override
  String get notificationAlcoholRecoveryMidBody => 'Add electrolytes: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Tomorrow morning - control check-in';

  @override
  String get notificationMorningCheckInTitle => '☀️ Morning check-in';

  @override
  String get notificationMorningCheckInBody =>
      'How are you feeling? Rate your condition and get a plan for the day';

  @override
  String get notificationMorningWaterBody =>
      'Start your day with a glass of water';

  @override
  String notificationLowProgressBody(int percent) {
    return 'You\'ve drunk only $percent% of the norm. Time to catch up!';
  }

  @override
  String get notificationGoodProgressBody => 'Excellent progress! Keep going';

  @override
  String get notificationMaintainBalanceBody => 'Maintain water balance';

  @override
  String get notificationTestTitle => '🧪 Test notification';

  @override
  String get notificationTestBody => 'If you see this - notifications work!';

  @override
  String get notificationTestScheduledTitle => '⏰ Scheduled test';

  @override
  String get notificationTestScheduledBody =>
      'This notification was scheduled 1 minute ago';

  @override
  String get onboardingUnitsTitle => 'Choose your units';

  @override
  String get onboardingUnitsSubtitle => 'You can\'t change this later';

  @override
  String get onboardingUnitsWarning =>
      'This choice is permanent and cannot be changed later';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'gal';

  @override
  String get lb => 'lb';

  @override
  String get target => 'Target';

  @override
  String get wind => 'Wind';

  @override
  String get pressure => 'Pressure';

  @override
  String get highHeatIndexWarning =>
      'High heat index! Increase your water intake';

  @override
  String get weatherCondition => 'Condition';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get humidityLabel => 'Humidity';

  @override
  String get waterNormal => 'Normal';

  @override
  String get sodiumNormal => 'Standard';
}
