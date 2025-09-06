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
    return 'Humidity: $value%';
  }

  @override
  String get water => 'Water';

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
}
