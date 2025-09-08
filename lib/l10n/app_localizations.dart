import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'HydraCoach'**
  String get appTitle;

  /// Get PRO tooltip
  ///
  /// In en, this message translates to:
  /// **'Get PRO'**
  String get getPro;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Date format pattern
  ///
  /// In en, this message translates to:
  /// **'{weekday}, {day} {month}'**
  String dateFormat(String weekday, int day, String month);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingWeather.
  ///
  /// In en, this message translates to:
  /// **'Loading weather...'**
  String get loadingWeather;

  /// No description provided for @heatIndex.
  ///
  /// In en, this message translates to:
  /// **'Heat Index'**
  String get heatIndex;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity: {value}%'**
  String humidity(int value);

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @liquids.
  ///
  /// In en, this message translates to:
  /// **'Liquids'**
  String get liquids;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get potassium;

  /// No description provided for @magnesium.
  ///
  /// In en, this message translates to:
  /// **'Magnesium'**
  String get magnesium;

  /// No description provided for @electrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte'**
  String get electrolyte;

  /// No description provided for @broth.
  ///
  /// In en, this message translates to:
  /// **'Broth'**
  String get broth;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get alcohol;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @mg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get mg;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @valueWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String valueWithUnit(int value, String unit);

  /// No description provided for @goalFormat.
  ///
  /// In en, this message translates to:
  /// **'{current}/{goal} {unit}'**
  String goalFormat(int current, int goal, String unit);

  /// No description provided for @heatAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Heat +{percent}%'**
  String heatAdjustment(int percent);

  /// No description provided for @alcoholAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Alcohol +{amount} ml'**
  String alcoholAdjustment(int amount);

  /// No description provided for @smartAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Tip for now'**
  String get smartAdviceTitle;

  /// No description provided for @smartAdviceDefault.
  ///
  /// In en, this message translates to:
  /// **'Maintain water and electrolyte balance.'**
  String get smartAdviceDefault;

  /// No description provided for @adviceOverhydrationSevere.
  ///
  /// In en, this message translates to:
  /// **'Water overload (>200% goal)'**
  String get adviceOverhydrationSevere;

  /// No description provided for @adviceOverhydrationSevereBody.
  ///
  /// In en, this message translates to:
  /// **'Pause 60-90 minutes. Add electrolytes: 300-500 ml with 500-1000 mg sodium.'**
  String get adviceOverhydrationSevereBody;

  /// No description provided for @adviceOverhydration.
  ///
  /// In en, this message translates to:
  /// **'Overhydration'**
  String get adviceOverhydration;

  /// No description provided for @adviceOverhydrationBody.
  ///
  /// In en, this message translates to:
  /// **'Pause water for 30-60 minutes and add ~500 mg sodium (electrolyte/broth).'**
  String get adviceOverhydrationBody;

  /// No description provided for @adviceAlcoholRecovery.
  ///
  /// In en, this message translates to:
  /// **'Alcohol: recovery'**
  String get adviceAlcoholRecovery;

  /// No description provided for @adviceAlcoholRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'No more alcohol today. Drink 300-500 ml water in small portions and add sodium.'**
  String get adviceAlcoholRecoveryBody;

  /// No description provided for @adviceLowSodium.
  ///
  /// In en, this message translates to:
  /// **'Low sodium'**
  String get adviceLowSodium;

  /// No description provided for @adviceLowSodiumBody.
  ///
  /// In en, this message translates to:
  /// **'Add ~{amount} mg sodium. Drink moderately.'**
  String adviceLowSodiumBody(int amount);

  /// No description provided for @adviceDehydration.
  ///
  /// In en, this message translates to:
  /// **'Under-hydrated'**
  String get adviceDehydration;

  /// No description provided for @adviceDehydrationBody.
  ///
  /// In en, this message translates to:
  /// **'Drink 300-500 ml {type}.'**
  String adviceDehydrationBody(String type);

  /// No description provided for @adviceHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High risk (HRI)'**
  String get adviceHighRisk;

  /// No description provided for @adviceHighRiskBody.
  ///
  /// In en, this message translates to:
  /// **'Urgently drink water with electrolytes (300-500 ml) and reduce activity.'**
  String get adviceHighRiskBody;

  /// No description provided for @adviceHeat.
  ///
  /// In en, this message translates to:
  /// **'Heat and losses'**
  String get adviceHeat;

  /// No description provided for @adviceHeatBody.
  ///
  /// In en, this message translates to:
  /// **'Increase water by +5-8% and add 300-500 mg sodium.'**
  String get adviceHeatBody;

  /// No description provided for @adviceAllGood.
  ///
  /// In en, this message translates to:
  /// **'All on track'**
  String get adviceAllGood;

  /// No description provided for @adviceAllGoodBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the pace. Target: ~{amount} ml more to goal.'**
  String adviceAllGoodBody(int amount);

  /// No description provided for @hydrationStatus.
  ///
  /// In en, this message translates to:
  /// **'Hydration Status'**
  String get hydrationStatus;

  /// No description provided for @hydrationStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get hydrationStatusNormal;

  /// No description provided for @hydrationStatusDiluted.
  ///
  /// In en, this message translates to:
  /// **'Diluting'**
  String get hydrationStatusDiluted;

  /// No description provided for @hydrationStatusDehydrated.
  ///
  /// In en, this message translates to:
  /// **'Under-hydrated'**
  String get hydrationStatusDehydrated;

  /// No description provided for @hydrationStatusLowSalt.
  ///
  /// In en, this message translates to:
  /// **'Low salt'**
  String get hydrationStatusLowSalt;

  /// No description provided for @hydrationRiskIndex.
  ///
  /// In en, this message translates to:
  /// **'Hydration Risk Index'**
  String get hydrationRiskIndex;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @todaysDrinks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Drinks'**
  String get todaysDrinks;

  /// No description provided for @allRecords.
  ///
  /// In en, this message translates to:
  /// **'All records →'**
  String get allRecords;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'{item} deleted'**
  String itemDeleted(String item);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @dailyReportReady.
  ///
  /// In en, this message translates to:
  /// **'Daily report ready!'**
  String get dailyReportReady;

  /// No description provided for @viewDayResults.
  ///
  /// In en, this message translates to:
  /// **'View day results'**
  String get viewDayResults;

  /// No description provided for @dailyReportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Daily report will be available in the next version'**
  String get dailyReportComingSoon;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @dietMode.
  ///
  /// In en, this message translates to:
  /// **'Diet Mode'**
  String get dietMode;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @changeWeight.
  ///
  /// In en, this message translates to:
  /// **'Change Weight'**
  String get changeWeight;

  /// No description provided for @dietModeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal Diet'**
  String get dietModeNormal;

  /// No description provided for @dietModeKeto.
  ///
  /// In en, this message translates to:
  /// **'Keto / Low-carb'**
  String get dietModeKeto;

  /// No description provided for @dietModeFasting.
  ///
  /// In en, this message translates to:
  /// **'Intermittent Fasting'**
  String get dietModeFasting;

  /// No description provided for @activityLow.
  ///
  /// In en, this message translates to:
  /// **'Low Activity'**
  String get activityLow;

  /// No description provided for @activityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium Activity'**
  String get activityMedium;

  /// No description provided for @activityHigh.
  ///
  /// In en, this message translates to:
  /// **'High Activity'**
  String get activityHigh;

  /// No description provided for @activityLowDesc.
  ///
  /// In en, this message translates to:
  /// **'Office work, little movement'**
  String get activityLowDesc;

  /// No description provided for @activityMediumDesc.
  ///
  /// In en, this message translates to:
  /// **'30-60 minutes of exercise per day'**
  String get activityMediumDesc;

  /// No description provided for @activityHighDesc.
  ///
  /// In en, this message translates to:
  /// **'Workouts >1 hour'**
  String get activityHighDesc;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @notificationLimit.
  ///
  /// In en, this message translates to:
  /// **'Notification Limit (FREE)'**
  String get notificationLimit;

  /// No description provided for @notificationUsage.
  ///
  /// In en, this message translates to:
  /// **'Used: {used} of {limit}'**
  String notificationUsage(int used, int limit);

  /// No description provided for @waterReminders.
  ///
  /// In en, this message translates to:
  /// **'Water Reminders'**
  String get waterReminders;

  /// No description provided for @waterRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular reminders throughout the day'**
  String get waterRemindersDesc;

  /// No description provided for @reminderFrequency.
  ///
  /// In en, this message translates to:
  /// **'Reminder Frequency'**
  String get reminderFrequency;

  /// No description provided for @timesPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} times per day'**
  String timesPerDay(int count);

  /// No description provided for @maxTimesPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} times per day (max 4)'**
  String maxTimesPerDay(int count);

  /// No description provided for @unlimitedReminders.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimitedReminders;

  /// No description provided for @startOfDay.
  ///
  /// In en, this message translates to:
  /// **'Start of Day'**
  String get startOfDay;

  /// No description provided for @endOfDay.
  ///
  /// In en, this message translates to:
  /// **'End of Day'**
  String get endOfDay;

  /// No description provided for @postCoffeeReminders.
  ///
  /// In en, this message translates to:
  /// **'Post-Coffee Reminders'**
  String get postCoffeeReminders;

  /// No description provided for @postCoffeeRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Remind to drink water after 20 minutes'**
  String get postCoffeeRemindersDesc;

  /// No description provided for @heatWarnings.
  ///
  /// In en, this message translates to:
  /// **'Heat Warnings'**
  String get heatWarnings;

  /// No description provided for @heatWarningsDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications in high temperatures'**
  String get heatWarningsDesc;

  /// No description provided for @postAlcoholReminders.
  ///
  /// In en, this message translates to:
  /// **'Post-Alcohol Reminders'**
  String get postAlcoholReminders;

  /// No description provided for @postAlcoholRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Recovery plan for 6-12 hours'**
  String get postAlcoholRemindersDesc;

  /// No description provided for @proFeaturesSection.
  ///
  /// In en, this message translates to:
  /// **'PRO Features'**
  String get proFeaturesSection;

  /// No description provided for @unlockPro.
  ///
  /// In en, this message translates to:
  /// **'Unlock PRO'**
  String get unlockPro;

  /// No description provided for @unlockProDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited notifications and smart reminders'**
  String get unlockProDesc;

  /// No description provided for @noNotificationLimit.
  ///
  /// In en, this message translates to:
  /// **'No notification limit'**
  String get noNotificationLimit;

  /// No description provided for @unitsSection.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsSection;

  /// No description provided for @metricSystem.
  ///
  /// In en, this message translates to:
  /// **'Metric System'**
  String get metricSystem;

  /// No description provided for @metricUnits.
  ///
  /// In en, this message translates to:
  /// **'ml, kg, °C'**
  String get metricUnits;

  /// No description provided for @imperialSystem.
  ///
  /// In en, this message translates to:
  /// **'Imperial System'**
  String get imperialSystem;

  /// No description provided for @imperialUnits.
  ///
  /// In en, this message translates to:
  /// **'oz, lb, °F'**
  String get imperialUnits;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetDataTitle;

  /// No description provided for @resetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all history and restore settings to defaults.'**
  String get resetDataMessage;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nHydraCoach'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart water and electrolyte tracking\nfor keto, fasting and active life'**
  String get welcomeSubtitle;

  /// No description provided for @weightPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weight'**
  String get weightPageTitle;

  /// No description provided for @weightPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To calculate optimal water amount'**
  String get weightPageSubtitle;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg'**
  String weightUnit(int weight);

  /// No description provided for @recommendedNorm.
  ///
  /// In en, this message translates to:
  /// **'Recommended norm: {min}-{max} ml of water per day'**
  String recommendedNorm(int min, int max);

  /// No description provided for @dietPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet Mode'**
  String get dietPageTitle;

  /// No description provided for @dietPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This affects electrolyte needs'**
  String get dietPageSubtitle;

  /// No description provided for @normalDiet.
  ///
  /// In en, this message translates to:
  /// **'Normal diet'**
  String get normalDiet;

  /// No description provided for @normalDietDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard recommendations'**
  String get normalDietDesc;

  /// No description provided for @ketoDiet.
  ///
  /// In en, this message translates to:
  /// **'Keto / Low-carb'**
  String get ketoDiet;

  /// No description provided for @ketoDietDesc.
  ///
  /// In en, this message translates to:
  /// **'Increased salt needs'**
  String get ketoDietDesc;

  /// No description provided for @fastingDiet.
  ///
  /// In en, this message translates to:
  /// **'Intermittent Fasting'**
  String get fastingDiet;

  /// No description provided for @fastingDietDesc.
  ///
  /// In en, this message translates to:
  /// **'Special electrolyte regime'**
  String get fastingDietDesc;

  /// No description provided for @fastingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Fasting schedule:'**
  String get fastingSchedule;

  /// No description provided for @fasting16_8.
  ///
  /// In en, this message translates to:
  /// **'16:8'**
  String get fasting16_8;

  /// No description provided for @fasting16_8Desc.
  ///
  /// In en, this message translates to:
  /// **'Daily 8-hour window'**
  String get fasting16_8Desc;

  /// No description provided for @fastingOMAD.
  ///
  /// In en, this message translates to:
  /// **'OMAD'**
  String get fastingOMAD;

  /// No description provided for @fastingOMADDesc.
  ///
  /// In en, this message translates to:
  /// **'One meal a day'**
  String get fastingOMADDesc;

  /// No description provided for @fastingADF.
  ///
  /// In en, this message translates to:
  /// **'ADF'**
  String get fastingADF;

  /// No description provided for @fastingADFDesc.
  ///
  /// In en, this message translates to:
  /// **'Alternate day fasting'**
  String get fastingADFDesc;

  /// No description provided for @activityPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityPageTitle;

  /// No description provided for @activityPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Affects water needs'**
  String get activityPageSubtitle;

  /// No description provided for @lowActivity.
  ///
  /// In en, this message translates to:
  /// **'Low activity'**
  String get lowActivity;

  /// No description provided for @lowActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Office work, little movement'**
  String get lowActivityDesc;

  /// No description provided for @lowActivityWater.
  ///
  /// In en, this message translates to:
  /// **'+0 ml water'**
  String get lowActivityWater;

  /// No description provided for @mediumActivity.
  ///
  /// In en, this message translates to:
  /// **'Medium activity'**
  String get mediumActivity;

  /// No description provided for @mediumActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'30-60 minutes of exercise per day'**
  String get mediumActivityDesc;

  /// No description provided for @mediumActivityWater.
  ///
  /// In en, this message translates to:
  /// **'+350-700 ml water'**
  String get mediumActivityWater;

  /// No description provided for @highActivity.
  ///
  /// In en, this message translates to:
  /// **'High activity'**
  String get highActivity;

  /// No description provided for @highActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Workouts >1 hour or physical labor'**
  String get highActivityDesc;

  /// No description provided for @highActivityWater.
  ///
  /// In en, this message translates to:
  /// **'+700-1200 ml water'**
  String get highActivityWater;

  /// No description provided for @activityAdjustmentNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll adjust goals based on your workouts'**
  String get activityAdjustmentNote;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noRecordsToday.
  ///
  /// In en, this message translates to:
  /// **'No records for today yet'**
  String get noRecordsToday;

  /// No description provided for @noRecordsThisDay.
  ///
  /// In en, this message translates to:
  /// **'No records for this day'**
  String get noRecordsThisDay;

  /// No description provided for @loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete record?'**
  String get deleteRecord;

  /// No description provided for @deleteRecordMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {type} {volume} ml?'**
  String deleteRecordMessage(String type, int volume);

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// No description provided for @waterConsumption.
  ///
  /// In en, this message translates to:
  /// **'💧 Water consumption'**
  String get waterConsumption;

  /// No description provided for @alcoholWeek.
  ///
  /// In en, this message translates to:
  /// **'🍺 Alcohol this week'**
  String get alcoholWeek;

  /// No description provided for @electrolytes.
  ///
  /// In en, this message translates to:
  /// **'⚡ Electrolytes'**
  String get electrolytes;

  /// No description provided for @weeklyAverages.
  ///
  /// In en, this message translates to:
  /// **'📊 Weekly averages'**
  String get weeklyAverages;

  /// No description provided for @monthStatistics.
  ///
  /// In en, this message translates to:
  /// **'📊 Month statistics'**
  String get monthStatistics;

  /// No description provided for @alcoholStatistics.
  ///
  /// In en, this message translates to:
  /// **'🍺 Alcohol statistics'**
  String get alcoholStatistics;

  /// No description provided for @alcoholStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alcohol statistics'**
  String get alcoholStatisticsTitle;

  /// No description provided for @weeklyInsights.
  ///
  /// In en, this message translates to:
  /// **'💡 Weekly insights'**
  String get weeklyInsights;

  /// No description provided for @waterPerDay.
  ///
  /// In en, this message translates to:
  /// **'Water per day'**
  String get waterPerDay;

  /// No description provided for @sodiumPerDay.
  ///
  /// In en, this message translates to:
  /// **'Sodium per day'**
  String get sodiumPerDay;

  /// No description provided for @potassiumPerDay.
  ///
  /// In en, this message translates to:
  /// **'Potassium per day'**
  String get potassiumPerDay;

  /// No description provided for @magnesiumPerDay.
  ///
  /// In en, this message translates to:
  /// **'Magnesium per day'**
  String get magnesiumPerDay;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @daysWithGoalAchieved.
  ///
  /// In en, this message translates to:
  /// **'✅ Days with goal achieved'**
  String get daysWithGoalAchieved;

  /// No description provided for @recordsPerDay.
  ///
  /// In en, this message translates to:
  /// **'📝 Records per day'**
  String get recordsPerDay;

  /// No description provided for @insufficientDataForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Insufficient data for analysis'**
  String get insufficientDataForAnalysis;

  /// No description provided for @totalVolume.
  ///
  /// In en, this message translates to:
  /// **'Total volume'**
  String get totalVolume;

  /// No description provided for @averagePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average {amount} ml/day'**
  String averagePerDay(int amount);

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get activeDays;

  /// No description provided for @perfectDays.
  ///
  /// In en, this message translates to:
  /// **'Days with perfect goal: {count}'**
  String perfectDays(int count);

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak: {days} days'**
  String currentStreak(int days);

  /// No description provided for @soberDaysRow.
  ///
  /// In en, this message translates to:
  /// **'Sober days in a row: {days}'**
  String soberDaysRow(int days);

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get keepItUp;

  /// No description provided for @waterAmount.
  ///
  /// In en, this message translates to:
  /// **'Water: {amount} ml ({percent}%)'**
  String waterAmount(int amount, int percent);

  /// No description provided for @alcoholAmount.
  ///
  /// In en, this message translates to:
  /// **'Alcohol: {amount} SD'**
  String alcoholAmount(String amount);

  /// No description provided for @totalSD.
  ///
  /// In en, this message translates to:
  /// **'Total SD'**
  String get totalSD;

  /// No description provided for @forMonth.
  ///
  /// In en, this message translates to:
  /// **'for month'**
  String get forMonth;

  /// No description provided for @daysWithAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Days with alcohol'**
  String get daysWithAlcohol;

  /// No description provided for @fromDays.
  ///
  /// In en, this message translates to:
  /// **'from {days}'**
  String fromDays(int days);

  /// No description provided for @soberDays.
  ///
  /// In en, this message translates to:
  /// **'Sober days'**
  String get soberDays;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'excellent!'**
  String get excellent;

  /// No description provided for @averageSD.
  ///
  /// In en, this message translates to:
  /// **'Average SD'**
  String get averageSD;

  /// No description provided for @inDrinkingDays.
  ///
  /// In en, this message translates to:
  /// **'in drinking days'**
  String get inDrinkingDays;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'🏆 Best day'**
  String get bestDay;

  /// No description provided for @bestDayMessage.
  ///
  /// In en, this message translates to:
  /// **'{day} - {percent}% of goal'**
  String bestDayMessage(String day, int percent);

  /// No description provided for @weekends.
  ///
  /// In en, this message translates to:
  /// **'📅 Weekends'**
  String get weekends;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'📅 Weekdays'**
  String get weekdays;

  /// No description provided for @drinkLessOnWeekends.
  ///
  /// In en, this message translates to:
  /// **'You drink {percent}% less on weekends'**
  String drinkLessOnWeekends(int percent);

  /// No description provided for @drinkLessOnWeekdays.
  ///
  /// In en, this message translates to:
  /// **'You drink {percent}% less on weekdays'**
  String drinkLessOnWeekdays(int percent);

  /// No description provided for @positiveTrend.
  ///
  /// In en, this message translates to:
  /// **'📈 Positive trend'**
  String get positiveTrend;

  /// No description provided for @positiveTrendMessage.
  ///
  /// In en, this message translates to:
  /// **'Your hydration improves by the end of the week'**
  String get positiveTrendMessage;

  /// No description provided for @decliningActivity.
  ///
  /// In en, this message translates to:
  /// **'📉 Declining activity'**
  String get decliningActivity;

  /// No description provided for @decliningActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'Water consumption decreases by the end of the week'**
  String get decliningActivityMessage;

  /// No description provided for @lowSalt.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Low salt'**
  String get lowSalt;

  /// No description provided for @lowSaltMessage.
  ///
  /// In en, this message translates to:
  /// **'Only {days} days with normal sodium levels'**
  String lowSaltMessage(int days);

  /// No description provided for @frequentAlcohol.
  ///
  /// In en, this message translates to:
  /// **'🍺 Frequent consumption'**
  String get frequentAlcohol;

  /// No description provided for @frequentAlcoholMessage.
  ///
  /// In en, this message translates to:
  /// **'Alcohol {days} days out of 7 affects hydration'**
  String frequentAlcoholMessage(int days);

  /// No description provided for @excellentWeek.
  ///
  /// In en, this message translates to:
  /// **'✅ Excellent week'**
  String get excellentWeek;

  /// No description provided for @continueMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep up the good work!'**
  String get continueMessage;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @addAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Add alcohol'**
  String get addAlcohol;

  /// No description provided for @minimumHarm.
  ///
  /// In en, this message translates to:
  /// **'Minimum harm'**
  String get minimumHarm;

  /// No description provided for @additionalWaterNeeded.
  ///
  /// In en, this message translates to:
  /// **'+{amount} ml water needed'**
  String additionalWaterNeeded(int amount);

  /// No description provided for @additionalSodiumNeeded.
  ///
  /// In en, this message translates to:
  /// **'+{amount} mg sodium to add'**
  String additionalSodiumNeeded(int amount);

  /// No description provided for @goToBedEarly.
  ///
  /// In en, this message translates to:
  /// **'Go to bed early'**
  String get goToBedEarly;

  /// No description provided for @todayConsumed.
  ///
  /// In en, this message translates to:
  /// **'Today consumed:'**
  String get todayConsumed;

  /// No description provided for @alcoholToday.
  ///
  /// In en, this message translates to:
  /// **'Alcohol today'**
  String get alcoholToday;

  /// No description provided for @beer.
  ///
  /// In en, this message translates to:
  /// **'Beer'**
  String get beer;

  /// No description provided for @wine.
  ///
  /// In en, this message translates to:
  /// **'Wine'**
  String get wine;

  /// No description provided for @spirits.
  ///
  /// In en, this message translates to:
  /// **'Spirits'**
  String get spirits;

  /// No description provided for @cocktail.
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get cocktail;

  /// No description provided for @selectDrinkType.
  ///
  /// In en, this message translates to:
  /// **'Select drink type:'**
  String get selectDrinkType;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume (ml):'**
  String get volume;

  /// No description provided for @enterVolume.
  ///
  /// In en, this message translates to:
  /// **'Enter volume in ml'**
  String get enterVolume;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength (%):'**
  String get strength;

  /// No description provided for @standardDrinks.
  ///
  /// In en, this message translates to:
  /// **'Standard drinks:'**
  String get standardDrinks;

  /// No description provided for @additionalWater.
  ///
  /// In en, this message translates to:
  /// **'Add. water'**
  String get additionalWater;

  /// No description provided for @additionalSodium.
  ///
  /// In en, this message translates to:
  /// **'Add. sodium'**
  String get additionalSodium;

  /// No description provided for @hriRisk.
  ///
  /// In en, this message translates to:
  /// **'HRI risk'**
  String get hriRisk;

  /// No description provided for @enterValidVolume.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid volume'**
  String get enterValidVolume;

  /// No description provided for @weeklyHistory.
  ///
  /// In en, this message translates to:
  /// **'Weekly history'**
  String get weeklyHistory;

  /// No description provided for @weeklyHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze weekly trends, get insights and recommendations'**
  String get weeklyHistoryDesc;

  /// No description provided for @monthlyHistory.
  ///
  /// In en, this message translates to:
  /// **'Monthly history'**
  String get monthlyHistory;

  /// No description provided for @monthlyHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Long-term patterns, week comparisons and deep analytics'**
  String get monthlyHistoryDesc;

  /// No description provided for @proFunction.
  ///
  /// In en, this message translates to:
  /// **'PRO function'**
  String get proFunction;

  /// No description provided for @unlockProHistory.
  ///
  /// In en, this message translates to:
  /// **'Unlock PRO'**
  String get unlockProHistory;

  /// No description provided for @unlimitedHistory.
  ///
  /// In en, this message translates to:
  /// **'Unlimited history'**
  String get unlimitedHistory;

  /// No description provided for @dataExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export data to CSV'**
  String get dataExportCSV;

  /// No description provided for @detailedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Detailed analytics'**
  String get detailedAnalytics;

  /// No description provided for @periodComparison.
  ///
  /// In en, this message translates to:
  /// **'Period comparison'**
  String get periodComparison;

  /// No description provided for @shareResult.
  ///
  /// In en, this message translates to:
  /// **'Share result'**
  String get shareResult;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @welcomeToPro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PRO!'**
  String get welcomeToPro;

  /// No description provided for @allFeaturesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All features are unlocked'**
  String get allFeaturesUnlocked;

  /// No description provided for @testMode.
  ///
  /// In en, this message translates to:
  /// **'Test Mode: Using mock purchase'**
  String get testMode;

  /// No description provided for @proStatusNote.
  ///
  /// In en, this message translates to:
  /// **'PRO status will persist until app restart'**
  String get proStatusNote;

  /// No description provided for @startUsingPro.
  ///
  /// In en, this message translates to:
  /// **'Start using PRO'**
  String get startUsingPro;

  /// No description provided for @lifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access'**
  String get lifetimeAccess;

  /// No description provided for @bestValueAnnual.
  ///
  /// In en, this message translates to:
  /// **'Best value — Annual'**
  String get bestValueAnnual;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'one-time'**
  String get oneTime;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get perYear;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @approximatelyPerMonth.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}/mo'**
  String approximatelyPerMonth(String amount);

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 7-day free trial'**
  String get startFreeTrial;

  /// No description provided for @continueWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Continue — {price}'**
  String continueWithPrice(String price);

  /// No description provided for @unlockForPrice.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {price} (one-time)'**
  String unlockForPrice(String price);

  /// No description provided for @enableFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Enable 7-day free trial'**
  String get enableFreeTrial;

  /// No description provided for @noChargeToday.
  ///
  /// In en, this message translates to:
  /// **'No charge today. After 7 days, your subscription renews automatically unless canceled.'**
  String get noChargeToday;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can cancel anytime in Settings.'**
  String get cancelAnytime;

  /// No description provided for @everythingInPro.
  ///
  /// In en, this message translates to:
  /// **'Everything in PRO'**
  String get everythingInPro;

  /// No description provided for @smartReminders.
  ///
  /// In en, this message translates to:
  /// **'Smart reminders'**
  String get smartReminders;

  /// No description provided for @smartRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Heat, workouts, fasting — no spam.'**
  String get smartRemindersDesc;

  /// No description provided for @weeklyReports.
  ///
  /// In en, this message translates to:
  /// **'Weekly reports'**
  String get weeklyReports;

  /// No description provided for @weeklyReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep insights + CSV export.'**
  String get weeklyReportsDesc;

  /// No description provided for @healthIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Health integrations'**
  String get healthIntegrations;

  /// No description provided for @healthIntegrationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Apple Health & Google Fit.'**
  String get healthIntegrationsDesc;

  /// No description provided for @alcoholProtocols.
  ///
  /// In en, this message translates to:
  /// **'Alcohol protocols'**
  String get alcoholProtocols;

  /// No description provided for @alcoholProtocolsDesc.
  ///
  /// In en, this message translates to:
  /// **'Pre-drink prep & recovery roadmap.'**
  String get alcoholProtocolsDesc;

  /// No description provided for @fullSync.
  ///
  /// In en, this message translates to:
  /// **'Full sync'**
  String get fullSync;

  /// No description provided for @fullSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited history across devices.'**
  String get fullSyncDesc;

  /// No description provided for @personalCalibrations.
  ///
  /// In en, this message translates to:
  /// **'Personal calibrations'**
  String get personalCalibrations;

  /// No description provided for @personalCalibrationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Sweat test, urine color scale.'**
  String get personalCalibrationsDesc;

  /// No description provided for @showAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Show all features'**
  String get showAllFeatures;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @proSubscriptionRestored.
  ///
  /// In en, this message translates to:
  /// **'PRO subscription restored!'**
  String get proSubscriptionRestored;

  /// No description provided for @noPurchasesToRestore.
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore'**
  String get noPurchasesToRestore;

  /// No description provided for @drinkMoreWaterToday.
  ///
  /// In en, this message translates to:
  /// **'Drink more water today (+20%)'**
  String get drinkMoreWaterToday;

  /// No description provided for @addElectrolytesToWater.
  ///
  /// In en, this message translates to:
  /// **'Add electrolytes to each water intake'**
  String get addElectrolytesToWater;

  /// No description provided for @limitCoffeeOneCup.
  ///
  /// In en, this message translates to:
  /// **'Limit coffee to one cup'**
  String get limitCoffeeOneCup;

  /// No description provided for @increaseWater10.
  ///
  /// In en, this message translates to:
  /// **'Increase water by 10%'**
  String get increaseWater10;

  /// No description provided for @dontForgetElectrolytes.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget electrolytes'**
  String get dontForgetElectrolytes;

  /// No description provided for @startDayWithWater.
  ///
  /// In en, this message translates to:
  /// **'Start your day with a glass of water'**
  String get startDayWithWater;

  /// No description provided for @dontForgetElectrolytesReminder.
  ///
  /// In en, this message translates to:
  /// **'⚡ Don\'t forget electrolytes'**
  String get dontForgetElectrolytesReminder;

  /// No description provided for @startDayWithWaterReminder.
  ///
  /// In en, this message translates to:
  /// **'Start your day with a glass of water for good wellbeing'**
  String get startDayWithWaterReminder;

  /// No description provided for @takeElectrolytesMorning.
  ///
  /// In en, this message translates to:
  /// **'Take electrolytes in the morning'**
  String get takeElectrolytesMorning;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String purchaseFailed(String error);

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// No description provided for @trustedByUsers.
  ///
  /// In en, this message translates to:
  /// **'⭐️ 4.9 — trusted by 12,000 users'**
  String get trustedByUsers;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get bestValue;

  /// No description provided for @percentOff.
  ///
  /// In en, this message translates to:
  /// **'-{percent}% Best value'**
  String percentOff(int percent);

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather unavailable'**
  String get weatherUnavailable;

  /// No description provided for @checkLocationPermissions.
  ///
  /// In en, this message translates to:
  /// **'Check location permissions and internet'**
  String get checkLocationPermissions;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'clear'**
  String get weatherClear;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'rain'**
  String get weatherRain;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'snow'**
  String get weatherSnow;

  /// No description provided for @weatherStorm.
  ///
  /// In en, this message translates to:
  /// **'storm'**
  String get weatherStorm;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'fog'**
  String get weatherFog;

  /// No description provided for @weatherDrizzle.
  ///
  /// In en, this message translates to:
  /// **'drizzle'**
  String get weatherDrizzle;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'sunny'**
  String get weatherSunny;

  /// No description provided for @heatWarningExtreme.
  ///
  /// In en, this message translates to:
  /// **'☀️ Extreme heat! Maximum hydration'**
  String get heatWarningExtreme;

  /// No description provided for @heatWarningVeryHot.
  ///
  /// In en, this message translates to:
  /// **'🌡️ Very hot! Risk of dehydration'**
  String get heatWarningVeryHot;

  /// No description provided for @heatWarningHot.
  ///
  /// In en, this message translates to:
  /// **'🔥 Hot! Drink more water'**
  String get heatWarningHot;

  /// No description provided for @heatWarningElevated.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Elevated temperature'**
  String get heatWarningElevated;

  /// No description provided for @heatWarningComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable temperature'**
  String get heatWarningComfortable;

  /// No description provided for @adjustmentWater.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% water'**
  String adjustmentWater(int percent);

  /// No description provided for @adjustmentSodium.
  ///
  /// In en, this message translates to:
  /// **'+{amount} mg sodium'**
  String adjustmentSodium(int amount);

  /// No description provided for @heatWarningCold.
  ///
  /// In en, this message translates to:
  /// **'❄️ Cold! Warm up and drink warm fluids'**
  String get heatWarningCold;

  /// Name of the notification channel
  ///
  /// In en, this message translates to:
  /// **'HydraCoach Reminders'**
  String get notificationChannelName;

  /// Description of the notification channel
  ///
  /// In en, this message translates to:
  /// **'Water and electrolyte reminders'**
  String get notificationChannelDescription;

  /// Name of the urgent notification channel
  ///
  /// In en, this message translates to:
  /// **'Urgent Reminders'**
  String get urgentNotificationChannelName;

  /// Description of the urgent notification channel
  ///
  /// In en, this message translates to:
  /// **'Important hydration notifications'**
  String get urgentNotificationChannelDescription;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'☀️ Good morning!'**
  String get goodMorning;

  /// No description provided for @timeToHydrate.
  ///
  /// In en, this message translates to:
  /// **'💧 Time to hydrate'**
  String get timeToHydrate;

  /// No description provided for @eveningHydration.
  ///
  /// In en, this message translates to:
  /// **'💧 Evening hydration'**
  String get eveningHydration;

  /// No description provided for @dailyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Daily report ready'**
  String get dailyReportTitle;

  /// No description provided for @dailyReportBody.
  ///
  /// In en, this message translates to:
  /// **'See how your hydration day went'**
  String get dailyReportBody;

  /// No description provided for @maintainWaterBalance.
  ///
  /// In en, this message translates to:
  /// **'Maintain water balance throughout the day'**
  String get maintainWaterBalance;

  /// No description provided for @electrolytesTime.
  ///
  /// In en, this message translates to:
  /// **'Time for electrolytes: add a pinch of salt to water'**
  String get electrolytesTime;

  /// No description provided for @catchUpHydration.
  ///
  /// In en, this message translates to:
  /// **'You\'ve drunk only {percent}% of daily norm. Time to catch up!'**
  String catchUpHydration(int percent);

  /// No description provided for @excellentProgress.
  ///
  /// In en, this message translates to:
  /// **'Excellent progress! A bit more to reach the goal'**
  String get excellentProgress;

  /// No description provided for @postCoffeeTitle.
  ///
  /// In en, this message translates to:
  /// **'☕ After coffee'**
  String get postCoffeeTitle;

  /// No description provided for @postCoffeeBody.
  ///
  /// In en, this message translates to:
  /// **'Drink 250-300 ml water to restore balance'**
  String get postCoffeeBody;

  /// No description provided for @postWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'💪 After workout'**
  String get postWorkoutTitle;

  /// No description provided for @postWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Restore electrolytes: 500 ml water + pinch of salt'**
  String get postWorkoutBody;

  /// No description provided for @heatWarningPro.
  ///
  /// In en, this message translates to:
  /// **'🌡️ PRO Heat warning'**
  String get heatWarningPro;

  /// No description provided for @extremeHeatWarning.
  ///
  /// In en, this message translates to:
  /// **'Extreme heat! Increase water consumption by 15% and add 1g salt'**
  String get extremeHeatWarning;

  /// No description provided for @hotWeatherWarning.
  ///
  /// In en, this message translates to:
  /// **'Hot! Drink 10% more water and don\'t forget electrolytes'**
  String get hotWeatherWarning;

  /// No description provided for @warmWeatherWarning.
  ///
  /// In en, this message translates to:
  /// **'Warm weather. Monitor your hydration'**
  String get warmWeatherWarning;

  /// No description provided for @alcoholRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'🍺 Recovery time'**
  String get alcoholRecoveryTitle;

  /// No description provided for @alcoholRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Drink 300 ml water with a pinch of salt for balance'**
  String get alcoholRecoveryBody;

  /// No description provided for @continueHydration.
  ///
  /// In en, this message translates to:
  /// **'💧 Continue hydration'**
  String get continueHydration;

  /// No description provided for @alcoholRecoveryBody2.
  ///
  /// In en, this message translates to:
  /// **'Another 500 ml water will help you recover faster'**
  String get alcoholRecoveryBody2;

  /// No description provided for @morningRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'☀️ Morning recovery'**
  String get morningRecoveryTitle;

  /// No description provided for @morningRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Start the day with 500 ml water and electrolytes'**
  String get morningRecoveryBody;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'🧪 Test notification'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'If you see this - instant notifications work!'**
  String get testNotificationBody;

  /// No description provided for @scheduledTestTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ Scheduled test (1 min)'**
  String get scheduledTestTitle;

  /// No description provided for @scheduledTestBody.
  ///
  /// In en, this message translates to:
  /// **'This notification was scheduled 1 minute ago. Scheduling works!'**
  String get scheduledTestBody;

  /// No description provided for @notificationServiceInitialized.
  ///
  /// In en, this message translates to:
  /// **'✅ NotificationService initialized'**
  String get notificationServiceInitialized;

  /// No description provided for @localNotificationsInitialized.
  ///
  /// In en, this message translates to:
  /// **'✅ Local notifications initialized'**
  String get localNotificationsInitialized;

  /// No description provided for @androidChannelsCreated.
  ///
  /// In en, this message translates to:
  /// **'📢 Android notification channels created'**
  String get androidChannelsCreated;

  /// No description provided for @notificationsPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'📝 Notifications permission: {granted}'**
  String notificationsPermissionGranted(String granted);

  /// No description provided for @exactAlarmsPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'📝 Exact alarms permission: {granted}'**
  String exactAlarmsPermissionGranted(String granted);

  /// No description provided for @fcmPermissions.
  ///
  /// In en, this message translates to:
  /// **'📱 FCM permissions: {status}'**
  String fcmPermissions(String status);

  /// No description provided for @fcmTokenReceived.
  ///
  /// In en, this message translates to:
  /// **'🔑 FCM Token received'**
  String get fcmTokenReceived;

  /// No description provided for @fcmTokenSaved.
  ///
  /// In en, this message translates to:
  /// **'✅ FCM Token saved to Firestore for user {userId}'**
  String fcmTokenSaved(String userId);

  /// No description provided for @topicSubscriptionComplete.
  ///
  /// In en, this message translates to:
  /// **'✅ Topic subscription complete'**
  String get topicSubscriptionComplete;

  /// No description provided for @foregroundMessage.
  ///
  /// In en, this message translates to:
  /// **'📨 Foreground message: {title}'**
  String foregroundMessage(String title);

  /// No description provided for @notificationOpened.
  ///
  /// In en, this message translates to:
  /// **'📱 Notification opened: {messageId}'**
  String notificationOpened(String messageId);

  /// No description provided for @dailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Daily notification limit reached (4/day for FREE)'**
  String get dailyLimitReached;

  /// No description provided for @schedulingError.
  ///
  /// In en, this message translates to:
  /// **'❌ Notification scheduling error: {error}'**
  String schedulingError(String error);

  /// No description provided for @showingImmediatelyAsFallback.
  ///
  /// In en, this message translates to:
  /// **'Showing notification immediately as fallback'**
  String get showingImmediatelyAsFallback;

  /// No description provided for @instantNotificationShown.
  ///
  /// In en, this message translates to:
  /// **'📬 Instant notification shown: {title}'**
  String instantNotificationShown(String title);

  /// No description provided for @smartRemindersScheduled.
  ///
  /// In en, this message translates to:
  /// **'🧠 Scheduling smart reminders...'**
  String get smartRemindersScheduled;

  /// No description provided for @smartRemindersComplete.
  ///
  /// In en, this message translates to:
  /// **'✅ Scheduled {count} reminders'**
  String smartRemindersComplete(int count);

  /// No description provided for @proPostCoffeeScheduled.
  ///
  /// In en, this message translates to:
  /// **'☕ PRO: Post-coffee reminder scheduled'**
  String get proPostCoffeeScheduled;

  /// No description provided for @postWorkoutScheduled.
  ///
  /// In en, this message translates to:
  /// **'💪 Post-workout reminder scheduled'**
  String get postWorkoutScheduled;

  /// No description provided for @proHeatWarningPro.
  ///
  /// In en, this message translates to:
  /// **'🌡️ PRO: Heat warning sent'**
  String get proHeatWarningPro;

  /// No description provided for @proAlcoholRecoveryPlan.
  ///
  /// In en, this message translates to:
  /// **'🍺 PRO: Alcohol recovery plan scheduled'**
  String get proAlcoholRecoveryPlan;

  /// No description provided for @eveningReportScheduled.
  ///
  /// In en, this message translates to:
  /// **'📊 Evening report scheduled for {day}.{month} at 21:00'**
  String eveningReportScheduled(int day, int month);

  /// No description provided for @notificationCancelled.
  ///
  /// In en, this message translates to:
  /// **'🚫 Notification {id} cancelled'**
  String notificationCancelled(int id);

  /// No description provided for @allNotificationsCancelled.
  ///
  /// In en, this message translates to:
  /// **'🗑️ All notifications cancelled'**
  String get allNotificationsCancelled;

  /// No description provided for @reminderSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'✅ Reminder settings saved'**
  String get reminderSettingsSaved;

  /// No description provided for @testNotificationScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'⏰ Test notification scheduled for {time}'**
  String testNotificationScheduledFor(String time);

  /// No description provided for @tomorrowRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations for tomorrow'**
  String get tomorrowRecommendations;

  /// No description provided for @recommendationExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent work! Keep it up. Try to start the day with a glass of water and maintain even consumption.'**
  String get recommendationExcellent;

  /// No description provided for @recommendationDiluted.
  ///
  /// In en, this message translates to:
  /// **'You drink a lot of water but few electrolytes. Tomorrow add more salt or drink an electrolyte beverage. Try starting the day with salty broth.'**
  String get recommendationDiluted;

  /// No description provided for @recommendationDehydrated.
  ///
  /// In en, this message translates to:
  /// **'Not enough water today. Tomorrow set reminders every 2 hours. Keep a water bottle in sight.'**
  String get recommendationDehydrated;

  /// No description provided for @recommendationLowSalt.
  ///
  /// In en, this message translates to:
  /// **'Low sodium levels can cause fatigue. Add a pinch of salt to water or drink broth. Especially important on keto or fasting.'**
  String get recommendationLowSalt;

  /// No description provided for @recommendationGeneral.
  ///
  /// In en, this message translates to:
  /// **'Aim for balance between water and electrolytes. Drink evenly throughout the day and don\'t forget salt in heat.'**
  String get recommendationGeneral;

  /// No description provided for @category_water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get category_water;

  /// No description provided for @category_hot_drinks.
  ///
  /// In en, this message translates to:
  /// **'Hot Drinks'**
  String get category_hot_drinks;

  /// No description provided for @category_juice.
  ///
  /// In en, this message translates to:
  /// **'Juices'**
  String get category_juice;

  /// No description provided for @category_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get category_sports;

  /// No description provided for @category_dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get category_dairy;

  /// No description provided for @category_alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get category_alcohol;

  /// No description provided for @category_supplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get category_supplements;

  /// No description provided for @category_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get category_other;

  /// No description provided for @drink_water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get drink_water;

  /// No description provided for @drink_sparkling_water.
  ///
  /// In en, this message translates to:
  /// **'Sparkling Water'**
  String get drink_sparkling_water;

  /// No description provided for @drink_mineral_water.
  ///
  /// In en, this message translates to:
  /// **'Mineral Water'**
  String get drink_mineral_water;

  /// No description provided for @drink_coconut_water.
  ///
  /// In en, this message translates to:
  /// **'Coconut Water'**
  String get drink_coconut_water;

  /// No description provided for @drink_coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get drink_coffee;

  /// No description provided for @drink_espresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get drink_espresso;

  /// No description provided for @drink_americano.
  ///
  /// In en, this message translates to:
  /// **'Americano'**
  String get drink_americano;

  /// No description provided for @drink_cappuccino.
  ///
  /// In en, this message translates to:
  /// **'Cappuccino'**
  String get drink_cappuccino;

  /// No description provided for @drink_latte.
  ///
  /// In en, this message translates to:
  /// **'Latte'**
  String get drink_latte;

  /// No description provided for @drink_black_tea.
  ///
  /// In en, this message translates to:
  /// **'Black Tea'**
  String get drink_black_tea;

  /// No description provided for @drink_green_tea.
  ///
  /// In en, this message translates to:
  /// **'Green Tea'**
  String get drink_green_tea;

  /// No description provided for @drink_herbal_tea.
  ///
  /// In en, this message translates to:
  /// **'Herbal Tea'**
  String get drink_herbal_tea;

  /// No description provided for @drink_matcha.
  ///
  /// In en, this message translates to:
  /// **'Matcha'**
  String get drink_matcha;

  /// No description provided for @drink_hot_chocolate.
  ///
  /// In en, this message translates to:
  /// **'Hot Chocolate'**
  String get drink_hot_chocolate;

  /// No description provided for @drink_orange_juice.
  ///
  /// In en, this message translates to:
  /// **'Orange Juice'**
  String get drink_orange_juice;

  /// No description provided for @drink_apple_juice.
  ///
  /// In en, this message translates to:
  /// **'Apple Juice'**
  String get drink_apple_juice;

  /// No description provided for @drink_grapefruit_juice.
  ///
  /// In en, this message translates to:
  /// **'Grapefruit Juice'**
  String get drink_grapefruit_juice;

  /// No description provided for @drink_tomato_juice.
  ///
  /// In en, this message translates to:
  /// **'Tomato Juice'**
  String get drink_tomato_juice;

  /// No description provided for @drink_vegetable_juice.
  ///
  /// In en, this message translates to:
  /// **'Vegetable Juice'**
  String get drink_vegetable_juice;

  /// No description provided for @drink_smoothie.
  ///
  /// In en, this message translates to:
  /// **'Smoothie'**
  String get drink_smoothie;

  /// No description provided for @drink_lemonade.
  ///
  /// In en, this message translates to:
  /// **'Lemonade'**
  String get drink_lemonade;

  /// No description provided for @drink_isotonic.
  ///
  /// In en, this message translates to:
  /// **'Isotonic Drink'**
  String get drink_isotonic;

  /// No description provided for @drink_electrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte Drink'**
  String get drink_electrolyte;

  /// No description provided for @drink_protein_shake.
  ///
  /// In en, this message translates to:
  /// **'Protein Shake'**
  String get drink_protein_shake;

  /// No description provided for @drink_bcaa.
  ///
  /// In en, this message translates to:
  /// **'BCAA Drink'**
  String get drink_bcaa;

  /// No description provided for @drink_energy.
  ///
  /// In en, this message translates to:
  /// **'Energy Drink'**
  String get drink_energy;

  /// No description provided for @drink_milk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get drink_milk;

  /// No description provided for @drink_kefir.
  ///
  /// In en, this message translates to:
  /// **'Kefir'**
  String get drink_kefir;

  /// No description provided for @drink_yogurt.
  ///
  /// In en, this message translates to:
  /// **'Yogurt Drink'**
  String get drink_yogurt;

  /// No description provided for @drink_almond_milk.
  ///
  /// In en, this message translates to:
  /// **'Almond Milk'**
  String get drink_almond_milk;

  /// No description provided for @drink_soy_milk.
  ///
  /// In en, this message translates to:
  /// **'Soy Milk'**
  String get drink_soy_milk;

  /// No description provided for @drink_oat_milk.
  ///
  /// In en, this message translates to:
  /// **'Oat Milk'**
  String get drink_oat_milk;

  /// No description provided for @drink_beer_light.
  ///
  /// In en, this message translates to:
  /// **'Light Beer'**
  String get drink_beer_light;

  /// No description provided for @drink_beer_regular.
  ///
  /// In en, this message translates to:
  /// **'Regular Beer'**
  String get drink_beer_regular;

  /// No description provided for @drink_beer_strong.
  ///
  /// In en, this message translates to:
  /// **'Strong Beer'**
  String get drink_beer_strong;

  /// No description provided for @drink_wine_red.
  ///
  /// In en, this message translates to:
  /// **'Red Wine'**
  String get drink_wine_red;

  /// No description provided for @drink_wine_white.
  ///
  /// In en, this message translates to:
  /// **'White Wine'**
  String get drink_wine_white;

  /// No description provided for @drink_champagne.
  ///
  /// In en, this message translates to:
  /// **'Champagne'**
  String get drink_champagne;

  /// No description provided for @drink_vodka.
  ///
  /// In en, this message translates to:
  /// **'Vodka'**
  String get drink_vodka;

  /// No description provided for @drink_whiskey.
  ///
  /// In en, this message translates to:
  /// **'Whiskey'**
  String get drink_whiskey;

  /// No description provided for @drink_rum.
  ///
  /// In en, this message translates to:
  /// **'Rum'**
  String get drink_rum;

  /// No description provided for @drink_gin.
  ///
  /// In en, this message translates to:
  /// **'Gin'**
  String get drink_gin;

  /// No description provided for @drink_tequila.
  ///
  /// In en, this message translates to:
  /// **'Tequila'**
  String get drink_tequila;

  /// No description provided for @drink_mojito.
  ///
  /// In en, this message translates to:
  /// **'Mojito'**
  String get drink_mojito;

  /// No description provided for @drink_margarita.
  ///
  /// In en, this message translates to:
  /// **'Margarita'**
  String get drink_margarita;

  /// No description provided for @drink_kombucha.
  ///
  /// In en, this message translates to:
  /// **'Kombucha'**
  String get drink_kombucha;

  /// No description provided for @drink_kvass.
  ///
  /// In en, this message translates to:
  /// **'Kvass'**
  String get drink_kvass;

  /// No description provided for @drink_bone_broth.
  ///
  /// In en, this message translates to:
  /// **'Bone Broth'**
  String get drink_bone_broth;

  /// No description provided for @drink_vegetable_broth.
  ///
  /// In en, this message translates to:
  /// **'Vegetable Broth'**
  String get drink_vegetable_broth;

  /// No description provided for @drink_soda.
  ///
  /// In en, this message translates to:
  /// **'Soda'**
  String get drink_soda;

  /// No description provided for @drink_diet_soda.
  ///
  /// In en, this message translates to:
  /// **'Diet Soda'**
  String get drink_diet_soda;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @favoriteLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Favorites limit reached (3 for FREE, 20 for PRO)'**
  String get favoriteLimitReached;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add favorite'**
  String get addFavorite;

  /// No description provided for @hotAndSupplements.
  ///
  /// In en, this message translates to:
  /// **'Hot & Supplements'**
  String get hotAndSupplements;

  /// No description provided for @quickVolumes.
  ///
  /// In en, this message translates to:
  /// **'Quick volumes:'**
  String get quickVolumes;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get type;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @coconut.
  ///
  /// In en, this message translates to:
  /// **'Coconut'**
  String get coconut;

  /// No description provided for @sparkling.
  ///
  /// In en, this message translates to:
  /// **'Sparkling'**
  String get sparkling;

  /// No description provided for @mineral.
  ///
  /// In en, this message translates to:
  /// **'Mineral'**
  String get mineral;

  /// No description provided for @hotDrinks.
  ///
  /// In en, this message translates to:
  /// **'Hot Drinks'**
  String get hotDrinks;

  /// No description provided for @supplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get supplements;

  /// No description provided for @tea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get tea;

  /// No description provided for @salt.
  ///
  /// In en, this message translates to:
  /// **'Salt (1/4 tsp)'**
  String get salt;

  /// No description provided for @electrolyteMix.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte Mix'**
  String get electrolyteMix;

  /// No description provided for @boneBroth.
  ///
  /// In en, this message translates to:
  /// **'Bone Broth'**
  String get boneBroth;

  /// No description provided for @favoriteAssignmentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Favorite assignment coming soon'**
  String get favoriteAssignmentComingSoon;

  /// No description provided for @longPressToEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Long press to edit - coming soon'**
  String get longPressToEditComingSoon;

  /// No description provided for @proSubscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'PRO subscription required'**
  String get proSubscriptionRequired;

  /// Button to save current settings as favorite
  ///
  /// In en, this message translates to:
  /// **'Save to favorites'**
  String get saveToFavorites;

  /// Success message when saved to favorites
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get savedToFavorites;

  /// Title for favorite slot selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select favorite slot'**
  String get selectFavoriteSlot;

  /// Favorite slot label
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get slot;

  /// Label for empty favorite slot
  ///
  /// In en, this message translates to:
  /// **'Empty slot'**
  String get emptySlot;

  /// Message for locked PRO slots
  ///
  /// In en, this message translates to:
  /// **'Upgrade to PRO to unlock'**
  String get upgradeToUnlock;

  /// Option to change existing favorite
  ///
  /// In en, this message translates to:
  /// **'Change favorite'**
  String get changeFavorite;

  /// Option to remove favorite
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get removeFavorite;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Mineral water drink type
  ///
  /// In en, this message translates to:
  /// **'Mineral Water'**
  String get mineralWater;

  /// Coconut water drink type
  ///
  /// In en, this message translates to:
  /// **'Coconut Water'**
  String get coconutWater;

  /// Lemon water drink type
  ///
  /// In en, this message translates to:
  /// **'Lemon Water'**
  String get lemonWater;

  /// Green tea drink type
  ///
  /// In en, this message translates to:
  /// **'Green Tea'**
  String get greenTea;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @createFavoriteHint.
  ///
  /// In en, this message translates to:
  /// **'To add a favorite, go to any drink screen below and tap \'Save to favorites\' button after setting up your drink.'**
  String get createFavoriteHint;

  /// Sparkling water drink type
  ///
  /// In en, this message translates to:
  /// **'Sparkling Water'**
  String get sparklingWater;

  /// Cola drink type
  ///
  /// In en, this message translates to:
  /// **'Cola'**
  String get cola;

  /// Juice drink type
  ///
  /// In en, this message translates to:
  /// **'Juice'**
  String get juice;

  /// Energy drink type
  ///
  /// In en, this message translates to:
  /// **'Energy Drink'**
  String get energyDrink;

  /// Sports drink type
  ///
  /// In en, this message translates to:
  /// **'Sports Drink'**
  String get sportsDrink;

  /// Prompt to select electrolyte type
  ///
  /// In en, this message translates to:
  /// **'Select electrolyte type:'**
  String get selectElectrolyteType;

  /// Quarter teaspoon of salt
  ///
  /// In en, this message translates to:
  /// **'Salt (1/4 tsp)'**
  String get saltQuarterTsp;

  /// Pink Himalayan salt type
  ///
  /// In en, this message translates to:
  /// **'Pink Himalayan Salt'**
  String get pinkSalt;

  /// Sea salt type
  ///
  /// In en, this message translates to:
  /// **'Sea Salt'**
  String get seaSalt;

  /// Potassium citrate supplement
  ///
  /// In en, this message translates to:
  /// **'Potassium Citrate'**
  String get potassiumCitrate;

  /// Magnesium glycinate supplement
  ///
  /// In en, this message translates to:
  /// **'Magnesium Glycinate'**
  String get magnesiumGlycinate;

  /// Coconut water as electrolyte source
  ///
  /// In en, this message translates to:
  /// **'Coconut Water'**
  String get coconutWaterElectrolyte;

  /// Sports drink as electrolyte source
  ///
  /// In en, this message translates to:
  /// **'Sports Drink'**
  String get sportsDrinkElectrolyte;

  /// Label for electrolyte content display
  ///
  /// In en, this message translates to:
  /// **'Electrolyte content:'**
  String get electrolyteContent;

  /// Sodium content display
  ///
  /// In en, this message translates to:
  /// **'Sodium: {amount} mg'**
  String sodiumContent(int amount);

  /// Potassium content display
  ///
  /// In en, this message translates to:
  /// **'Potassium: {amount} mg'**
  String potassiumContent(int amount);

  /// Magnesium content display
  ///
  /// In en, this message translates to:
  /// **'Magnesium: {amount} mg'**
  String magnesiumContent(int amount);

  /// Servings label
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// Prompt to enter number of servings
  ///
  /// In en, this message translates to:
  /// **'Enter servings'**
  String get enterServings;

  /// Unit for servings
  ///
  /// In en, this message translates to:
  /// **'servings'**
  String get servingsUnit;

  /// Message when no electrolytes present
  ///
  /// In en, this message translates to:
  /// **'No electrolytes'**
  String get noElectrolytes;

  /// Error message for invalid amount
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @lmntMix.
  ///
  /// In en, this message translates to:
  /// **'LMNT Mix'**
  String get lmntMix;

  /// No description provided for @pickleJuice.
  ///
  /// In en, this message translates to:
  /// **'Pickle Juice'**
  String get pickleJuice;

  /// No description provided for @tomatoSalt.
  ///
  /// In en, this message translates to:
  /// **'Tomato + Salt'**
  String get tomatoSalt;

  /// No description provided for @ketorade.
  ///
  /// In en, this message translates to:
  /// **'Ketorade'**
  String get ketorade;

  /// No description provided for @alkalineWater.
  ///
  /// In en, this message translates to:
  /// **'Alkaline Water'**
  String get alkalineWater;

  /// No description provided for @celticSalt.
  ///
  /// In en, this message translates to:
  /// **'Celtic Salt Water'**
  String get celticSalt;

  /// No description provided for @soleWater.
  ///
  /// In en, this message translates to:
  /// **'Sole Water'**
  String get soleWater;

  /// No description provided for @mineralDrops.
  ///
  /// In en, this message translates to:
  /// **'Mineral Drops'**
  String get mineralDrops;

  /// No description provided for @bakingSoda.
  ///
  /// In en, this message translates to:
  /// **'Baking Soda Water'**
  String get bakingSoda;

  /// No description provided for @creamTartar.
  ///
  /// In en, this message translates to:
  /// **'Cream of Tartar'**
  String get creamTartar;

  /// No description provided for @selectSupplementType.
  ///
  /// In en, this message translates to:
  /// **'Select supplement type:'**
  String get selectSupplementType;

  /// No description provided for @multivitamin.
  ///
  /// In en, this message translates to:
  /// **'Multivitamin'**
  String get multivitamin;

  /// No description provided for @magnesiumCitrate.
  ///
  /// In en, this message translates to:
  /// **'Magnesium Citrate'**
  String get magnesiumCitrate;

  /// No description provided for @magnesiumThreonate.
  ///
  /// In en, this message translates to:
  /// **'Magnesium L-Threonate'**
  String get magnesiumThreonate;

  /// No description provided for @calciumCitrate.
  ///
  /// In en, this message translates to:
  /// **'Calcium Citrate'**
  String get calciumCitrate;

  /// No description provided for @zincGlycinate.
  ///
  /// In en, this message translates to:
  /// **'Zinc Glycinate'**
  String get zincGlycinate;

  /// No description provided for @vitaminD3.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D3'**
  String get vitaminD3;

  /// No description provided for @vitaminC.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get vitaminC;

  /// No description provided for @bComplex.
  ///
  /// In en, this message translates to:
  /// **'B-Complex'**
  String get bComplex;

  /// No description provided for @omega3.
  ///
  /// In en, this message translates to:
  /// **'Omega-3'**
  String get omega3;

  /// No description provided for @ironBisglycinate.
  ///
  /// In en, this message translates to:
  /// **'Iron Bisglycinate'**
  String get ironBisglycinate;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @enterDosage.
  ///
  /// In en, this message translates to:
  /// **'Enter dosage'**
  String get enterDosage;

  /// No description provided for @noElectrolyteContent.
  ///
  /// In en, this message translates to:
  /// **'No electrolyte content'**
  String get noElectrolyteContent;

  /// No description provided for @blackTea.
  ///
  /// In en, this message translates to:
  /// **'Black Tea'**
  String get blackTea;

  /// No description provided for @herbalTea.
  ///
  /// In en, this message translates to:
  /// **'Herbal Tea'**
  String get herbalTea;

  /// No description provided for @espresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get espresso;

  /// No description provided for @cappuccino.
  ///
  /// In en, this message translates to:
  /// **'Cappuccino'**
  String get cappuccino;

  /// No description provided for @latte.
  ///
  /// In en, this message translates to:
  /// **'Latte'**
  String get latte;

  /// No description provided for @matcha.
  ///
  /// In en, this message translates to:
  /// **'Matcha'**
  String get matcha;

  /// No description provided for @hotChocolate.
  ///
  /// In en, this message translates to:
  /// **'Hot Chocolate'**
  String get hotChocolate;

  /// No description provided for @caffeine.
  ///
  /// In en, this message translates to:
  /// **'Caffeine'**
  String get caffeine;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @cycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// No description provided for @swimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get swimming;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @hiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get hiit;

  /// No description provided for @crossfit.
  ///
  /// In en, this message translates to:
  /// **'CrossFit'**
  String get crossfit;

  /// No description provided for @boxing.
  ///
  /// In en, this message translates to:
  /// **'Boxing'**
  String get boxing;

  /// No description provided for @dancing.
  ///
  /// In en, this message translates to:
  /// **'Dancing'**
  String get dancing;

  /// No description provided for @tennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get tennis;

  /// No description provided for @teamSports.
  ///
  /// In en, this message translates to:
  /// **'Team Sports'**
  String get teamSports;

  /// No description provided for @selectActivityType.
  ///
  /// In en, this message translates to:
  /// **'Select activity type:'**
  String get selectActivityType;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @enterDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter duration'**
  String get enterDuration;

  /// No description provided for @lowIntensity.
  ///
  /// In en, this message translates to:
  /// **'Low intensity'**
  String get lowIntensity;

  /// No description provided for @mediumIntensity.
  ///
  /// In en, this message translates to:
  /// **'Medium intensity'**
  String get mediumIntensity;

  /// No description provided for @highIntensity.
  ///
  /// In en, this message translates to:
  /// **'High intensity'**
  String get highIntensity;

  /// No description provided for @recommendedIntake.
  ///
  /// In en, this message translates to:
  /// **'Recommended intake:'**
  String get recommendedIntake;

  /// No description provided for @basedOnWeight.
  ///
  /// In en, this message translates to:
  /// **'Based on weight'**
  String get basedOnWeight;

  /// No description provided for @logActivity.
  ///
  /// In en, this message translates to:
  /// **'Log Activity'**
  String get logActivity;

  /// No description provided for @activityLogged.
  ///
  /// In en, this message translates to:
  /// **'Activity logged'**
  String get activityLogged;

  /// No description provided for @enterValidDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid duration'**
  String get enterValidDuration;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
