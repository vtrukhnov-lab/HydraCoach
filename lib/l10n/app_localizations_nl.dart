// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'HydroCoach';

  @override
  String get getPro => 'PRO halen';

  @override
  String get sunday => 'Zondag';

  @override
  String get monday => 'Maandag';

  @override
  String get tuesday => 'Dinsdag';

  @override
  String get wednesday => 'Woensdag';

  @override
  String get thursday => 'Donderdag';

  @override
  String get friday => 'Vrijdag';

  @override
  String get saturday => 'Zaterdag';

  @override
  String get january => 'Januari';

  @override
  String get february => 'Februari';

  @override
  String get march => 'Maart';

  @override
  String get april => 'April';

  @override
  String get may => 'Mei';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Juli';

  @override
  String get august => 'Augustus';

  @override
  String get september => 'September';

  @override
  String get october => 'Oktober';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String get loading => 'Laden...';

  @override
  String get loadingWeather => 'Weer laden...';

  @override
  String get heatIndex => 'Hitteindex';

  @override
  String humidity(int value) {
    return 'Vochtigheid';
  }

  @override
  String get water => 'Water';

  @override
  String get liquids => 'Vloeistoffen';

  @override
  String get sodium => 'Natrium';

  @override
  String get potassium => 'Kalium';

  @override
  String get magnesium => 'Magnesium';

  @override
  String get electrolyte => 'Elektrolyt';

  @override
  String get broth => 'Bouillon';

  @override
  String get coffee => 'Koffie';

  @override
  String get alcohol => 'Alcohol';

  @override
  String get drink => 'Drank';

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
    return 'Hitte +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'Alcohol +$amount ml';
  }

  @override
  String get smartAdviceTitle => 'Tip voor nu';

  @override
  String get smartAdviceDefault => 'Houd water- en elektrolytenbalans.';

  @override
  String get adviceOverhydrationSevere => 'Wateroverlast (>200% doel)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Pauzeer 60-90 min. Elektrolyten toevoegen: 300-500 ml met 500-1000 mg natrium.';

  @override
  String get adviceOverhydration => 'Overhydratie';

  @override
  String get adviceOverhydrationBody =>
      'Pauzeer water 30-60 min en voeg ~500 mg natrium toe (elektrolyt/bouillon).';

  @override
  String get adviceAlcoholRecovery => 'Alcohol: herstel';

  @override
  String get adviceAlcoholRecoveryBody =>
      'Geen alcohol meer vandaag. Drink 300-500 ml water in kleine porties en voeg natrium toe.';

  @override
  String get adviceLowSodium => 'Weinig natrium';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Voeg ~$amount mg natrium toe. Drink matig.';
  }

  @override
  String get adviceDehydration => 'Gedehydrateerd';

  @override
  String adviceDehydrationBody(String type) {
    return 'Drink 300-500 ml $type.';
  }

  @override
  String get adviceHighRisk => 'Hoog risico (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Dringend water met elektrolyten drinken (300-500 ml) en activiteit verminderen.';

  @override
  String get adviceHeat => 'Hitte en verliezen';

  @override
  String get adviceHeatBody =>
      'Verhoog water met +5-8% en voeg 300-500 mg natrium toe.';

  @override
  String get adviceAllGood => 'Alles op koers';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Houd het tempo. Doel: nog ~$amount ml.';
  }

  @override
  String get hydrationStatus => 'Hydratiestatus';

  @override
  String get hydrationStatusNormal => 'Normaal';

  @override
  String get hydrationStatusDiluted => 'Verdunnen';

  @override
  String get hydrationStatusDehydrated => 'Gedehydrateerd';

  @override
  String get hydrationStatusLowSalt => 'Weinig zout';

  @override
  String get hydrationRiskIndex => 'Hydratie-risicoindex';

  @override
  String get quickAdd => 'Snel toevoegen';

  @override
  String get add => 'Toevoegen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get todaysDrinks => 'Vandaag gedronken';

  @override
  String get allRecords => 'Alle records →';

  @override
  String itemDeleted(String item) {
    return '$item verwijderd';
  }

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get dailyReportReady => 'Dagrapport klaar!';

  @override
  String get viewDayResults => 'Bekijk dagresultaten';

  @override
  String get dailyReportComingSoon => 'Dagrapport komt binnenkort';

  @override
  String get home => 'Start';

  @override
  String get history => 'Geschiedenis';

  @override
  String get settings => 'Instellingen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get reset => 'Resetten';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get languageSection => 'Taal';

  @override
  String get languageSettings => 'Taal';

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get profileSection => 'Profiel';

  @override
  String get weight => 'Gewicht';

  @override
  String get dietMode => 'Dieetmodus';

  @override
  String get activityLevel => 'Activiteitsniveau';

  @override
  String get changeWeight => 'Gewicht wijzigen';

  @override
  String get dietModeNormal => 'Normaal dieet';

  @override
  String get dietModeKeto => 'Keto / Low-carb';

  @override
  String get dietModeFasting => 'Intermitterend vasten';

  @override
  String get activityLow => 'Lage activiteit';

  @override
  String get activityMedium => 'Gemiddelde activiteit';

  @override
  String get activityHigh => 'Hoge activiteit';

  @override
  String get activityLowDesc => 'Kantoorwerk, weinig beweging';

  @override
  String get activityMediumDesc => '30-60 min sport per dag';

  @override
  String get activityHighDesc => 'Training >1 uur';

  @override
  String get notificationsSection => 'Meldingen';

  @override
  String get notificationLimit => 'Meldingslimiet (GRATIS)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Gebruikt: $used van $limit';
  }

  @override
  String get waterReminders => 'Waterherinneringen';

  @override
  String get waterRemindersDesc => 'Regelmatige herinneringen gedurende de dag';

  @override
  String get reminderFrequency => 'Herinneringsfrequentie';

  @override
  String timesPerDay(int count) {
    return '$count keer per dag';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count keer per dag (max 4)';
  }

  @override
  String get unlimitedReminders => 'Onbeperkt';

  @override
  String get startOfDay => 'Begin van de dag';

  @override
  String get endOfDay => 'Einde van de dag';

  @override
  String get postCoffeeReminders => 'Na-koffie herinneringen';

  @override
  String get postCoffeeRemindersDesc =>
      'Herinnering om na 20 min water te drinken';

  @override
  String get heatWarnings => 'Hittewaarschuwingen';

  @override
  String get heatWarningsDesc => 'Meldingen bij hoge temperaturen';

  @override
  String get postAlcoholReminders => 'Na-alcohol herinneringen';

  @override
  String get postAlcoholRemindersDesc => 'Herstelplan voor 6-12 uur';

  @override
  String get proFeaturesSection => 'PRO Functies';

  @override
  String get unlockPro => 'PRO ontgrendelen';

  @override
  String get unlockProDesc => 'Onbeperkte meldingen en slimme herinneringen';

  @override
  String get noNotificationLimit => 'Geen meldingslimiet';

  @override
  String get unitsSection => 'Eenheden';

  @override
  String get metricSystem => 'Metrisch systeem';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Imperiaal systeem';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => 'Over';

  @override
  String get version => 'Versie';

  @override
  String get rateApp => 'App beoordelen';

  @override
  String get share => 'Delen';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsOfUse => 'Gebruiksvoorwaarden';

  @override
  String get resetAllData => 'Alle gegevens resetten';

  @override
  String get resetDataTitle => 'Alle gegevens resetten?';

  @override
  String get resetDataMessage =>
      'Dit verwijdert alle geschiedenis en herstelt standaardinstellingen.';

  @override
  String get back => 'Terug';

  @override
  String get next => 'Volgende';

  @override
  String get start => 'Starten';

  @override
  String get welcomeTitle => 'Welkom bij\nHydroCoach';

  @override
  String get welcomeSubtitle =>
      'Slimme water- en elektrolytentracking\nvoor keto, vasten en actief leven';

  @override
  String get weightPageTitle => 'Jouw gewicht';

  @override
  String get weightPageSubtitle => 'Om optimale waterhoeveelheid te berekenen';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Aanbevolen norm: $min-$max ml water per dag';
  }

  @override
  String get dietPageTitle => 'Dieetmodus';

  @override
  String get dietPageSubtitle => 'Dit beïnvloedt elektrolytenbehoefte';

  @override
  String get normalDiet => 'Normaal dieet';

  @override
  String get normalDietDesc => 'Standaardaanbevelingen';

  @override
  String get ketoDiet => 'Keto / Low-carb';

  @override
  String get ketoDietDesc => 'Verhoogde zoutbehoefte';

  @override
  String get fastingDiet => 'Intermitterend vasten';

  @override
  String get fastingDietDesc => 'Speciaal elektrolytenregime';

  @override
  String get fastingSchedule => 'Vastenschema:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Dagelijks 8-uurs venster';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Eén maaltijd per dag';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Afwisselend dagvasten';

  @override
  String get activityPageTitle => 'Activiteitsniveau';

  @override
  String get activityPageSubtitle => 'Beïnvloedt waterbehoefte';

  @override
  String get lowActivity => 'Lage activiteit';

  @override
  String get lowActivityDesc => 'Kantoorwerk, weinig beweging';

  @override
  String get lowActivityWater => '+0 ml water';

  @override
  String get mediumActivity => 'Gemiddelde activiteit';

  @override
  String get mediumActivityDesc => '30-60 min sport per dag';

  @override
  String get mediumActivityWater => '+350-700 ml water';

  @override
  String get highActivity => 'Hoge activiteit';

  @override
  String get highActivityDesc => 'Training >1 uur of fysiek werk';

  @override
  String get highActivityWater => '+700-1200 ml water';

  @override
  String get activityAdjustmentNote =>
      'We passen doelen aan op basis van je training';

  @override
  String get day => 'Dag';

  @override
  String get week => 'Week';

  @override
  String get month => 'Maand';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get noData => 'Geen gegevens';

  @override
  String get noRecordsToday => 'Nog geen records vandaag';

  @override
  String get noRecordsThisDay => 'Geen records voor deze dag';

  @override
  String get loadingData => 'Gegevens laden...';

  @override
  String get deleteRecord => 'Record verwijderen?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '$type $volume ml verwijderen?';
  }

  @override
  String get recordDeleted => 'Record verwijderd';

  @override
  String get waterConsumption => '💧 Waterverbruik';

  @override
  String get alcoholWeek => '🍺 Alcohol deze week';

  @override
  String get electrolytes => '⚡ Elektrolyten';

  @override
  String get weeklyAverages => '📊 Weekgemiddeldes';

  @override
  String get monthStatistics => '📊 Maandstatistieken';

  @override
  String get alcoholStatistics => '🍺 Alcoholstatistieken';

  @override
  String get alcoholStatisticsTitle => 'Alcoholstatistieken';

  @override
  String get weeklyInsights => '💡 Weekinzichten';

  @override
  String get waterPerDay => 'Water per dag';

  @override
  String get sodiumPerDay => 'Natrium per dag';

  @override
  String get potassiumPerDay => 'Kalium per dag';

  @override
  String get magnesiumPerDay => 'Magnesium per dag';

  @override
  String get goal => 'Doel';

  @override
  String get daysWithGoalAchieved => '✅ Dagen met doel behaald';

  @override
  String get recordsPerDay => '📝 Records per dag';

  @override
  String get insufficientDataForAnalysis => 'Onvoldoende gegevens voor analyse';

  @override
  String get totalVolume => 'Totaal volume';

  @override
  String averagePerDay(int amount) {
    return 'Gemiddeld $amount ml/dag';
  }

  @override
  String get activeDays => 'Actieve dagen';

  @override
  String perfectDays(int count) {
    return '$count dagen';
  }

  @override
  String currentStreak(int days) {
    return 'Huidige reeks: $days dagen';
  }

  @override
  String soberDaysRow(int days) {
    return 'Nuchtere dagen op rij: $days';
  }

  @override
  String get keepItUp => 'Ga zo door!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Water: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Alcohol: $amount SD';
  }

  @override
  String get totalSD => 'Totaal SD';

  @override
  String get forMonth => 'Voor maand';

  @override
  String get daysWithAlcohol => 'Dagen met alcohol';

  @override
  String fromDays(int days) {
    return 'van $days';
  }

  @override
  String get soberDays => 'Nuchtere dagen';

  @override
  String get excellent => 'uitstekend!';

  @override
  String get averageSD => 'Gemiddeld SD';

  @override
  String get inDrinkingDays => 'op drinkdagen';

  @override
  String get bestDay => '🏆 Beste dag';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% van doel';
  }

  @override
  String get weekends => '📅 Weekenden';

  @override
  String get weekdays => '📅 Weekdagen';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'Je drinkt $percent% minder in weekenden';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'Je drinkt $percent% minder op weekdagen';
  }

  @override
  String get positiveTrend => '📈 Positieve trend';

  @override
  String get positiveTrendMessage => 'Je hydratie verbetert tegen het weekend';

  @override
  String get decliningActivity => '📉 Afnemende activiteit';

  @override
  String get decliningActivityMessage =>
      'Waterverbruik neemt af tegen het weekend';

  @override
  String get lowSalt => '⚠️ Weinig zout';

  @override
  String lowSaltMessage(int days) {
    return 'Slechts $days dagen met normale natriumwaarden';
  }

  @override
  String get frequentAlcohol => '🍺 Frequent verbruik';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Alcohol $days dagen van de 7 beïnvloedt hydratie';
  }

  @override
  String get excellentWeek => '✅ Uitstekende week';

  @override
  String get continueMessage => 'Ga zo door!';

  @override
  String get all => 'Alles';

  @override
  String get addAlcohol => 'Alcohol toevoegen';

  @override
  String get minimumHarm => 'Minimale schade';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml water nodig';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg natrium toevoegen';
  }

  @override
  String get goToBedEarly => 'Vroeg naar bed';

  @override
  String get todayConsumed => 'Vandaag geconsumeerd:';

  @override
  String get alcoholToday => 'Alcohol vandaag';

  @override
  String get beer => 'Bier';

  @override
  String get wine => 'Wijn';

  @override
  String get spirits => 'Sterke drank';

  @override
  String get cocktail => 'Cocktail';

  @override
  String get selectDrinkType => 'Selecteer dranktype:';

  @override
  String get volume => 'Volume';

  @override
  String get enterVolume => 'Voer volume in ml in';

  @override
  String get strength => 'Kracht';

  @override
  String get standardDrinks => 'Standaardglazen:';

  @override
  String get additionalWater => 'Extra water';

  @override
  String get additionalSodium => 'Extra natrium';

  @override
  String get hriRisk => 'HRI risico';

  @override
  String get enterValidVolume => 'Voer geldig volume in';

  @override
  String get weeklyHistory => 'Weekgeschiedenis';

  @override
  String get weeklyHistoryDesc =>
      'Analyseer wekelijkse trends, krijg inzichten en aanbevelingen';

  @override
  String get monthlyHistory => 'Maandgeschiedenis';

  @override
  String get monthlyHistoryDesc =>
      'Lange-termijn patronen, week vergelijkingen en diepe analytics';

  @override
  String get proFunction => 'PRO functie';

  @override
  String get unlockProHistory => 'PRO ontgrendelen';

  @override
  String get unlimitedHistory => 'Onbeperkte geschiedenis';

  @override
  String get dataExportCSV => 'Exporteer data naar CSV';

  @override
  String get detailedAnalytics => 'Gedetailleerde analytics';

  @override
  String get periodComparison => 'Periode vergelijking';

  @override
  String get shareResult => 'Resultaat delen';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get welcomeToPro => 'Welkom bij PRO!';

  @override
  String get allFeaturesUnlocked => 'Alle functies ontgrendeld';

  @override
  String get testMode => 'Testmodus: Mock aankoop gebruikt';

  @override
  String get proStatusNote => 'PRO status blijft tot app herstart';

  @override
  String get startUsingPro => 'Start met PRO';

  @override
  String get lifetimeAccess => 'Levenslange toegang';

  @override
  String get bestValueAnnual => 'Beste waarde — Jaarlijks';

  @override
  String get monthly => 'Maandelijks';

  @override
  String get oneTime => 'eenmalig';

  @override
  String get perYear => '/jaar';

  @override
  String get perMonth => '/maand';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/mnd';
  }

  @override
  String get startFreeTrial => 'Start 7-dagen gratis proef';

  @override
  String continueWithPrice(String price) {
    return 'Doorgaan — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Ontgrendel voor $price (eenmalig)';
  }

  @override
  String get enableFreeTrial => 'Activeer 7-dagen gratis proef';

  @override
  String get noChargeToday =>
      'Geen kosten vandaag. Na 7 dagen vernieuwt abonnement automatisch tenzij geannuleerd.';

  @override
  String get cancelAnytime => 'Annuleren kan altijd in Instellingen.';

  @override
  String get everythingInPro => 'Alles in PRO';

  @override
  String get smartReminders => 'Slimme herinneringen';

  @override
  String get smartRemindersDesc => 'Hitte, trainingen, vasten — geen spam.';

  @override
  String get weeklyReports => 'Weekrapporten';

  @override
  String get weeklyReportsDesc => 'Diepe inzichten + CSV export.';

  @override
  String get healthIntegrations => 'Gezondheids integraties';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit.';

  @override
  String get alcoholProtocols => 'Alcohol protocollen';

  @override
  String get alcoholProtocolsDesc => 'Pre-drink prep & herstelplan.';

  @override
  String get fullSync => 'Volledige sync';

  @override
  String get fullSyncDesc => 'Onbeperkte geschiedenis op alle apparaten.';

  @override
  String get personalCalibrations => 'Persoonlijke kalibraties';

  @override
  String get personalCalibrationsDesc => 'Zweet test, urine kleurschaal.';

  @override
  String get showAllFeatures => 'Toon alle functies';

  @override
  String get showLess => 'Toon minder';

  @override
  String get restorePurchases => 'Herstel aankopen';

  @override
  String get proSubscriptionRestored => 'PRO abonnement hersteld!';

  @override
  String get noPurchasesToRestore => 'Geen aankopen gevonden om te herstellen';

  @override
  String get drinkMoreWaterToday => 'Drink meer water vandaag (+20%)';

  @override
  String get addElectrolytesToWater =>
      'Voeg elektrolyten toe aan elke waterinname';

  @override
  String get limitCoffeeOneCup => 'Beperk koffie tot één kop';

  @override
  String get increaseWater10 => 'Verhoog water met 10%';

  @override
  String get dontForgetElectrolytes => 'Vergeet elektrolyten niet';

  @override
  String get startDayWithWater => 'Start je dag met een glas water';

  @override
  String get dontForgetElectrolytesReminder => '⚡ Vergeet elektrolyten niet';

  @override
  String get startDayWithWaterReminder =>
      'Start je dag met een glas water voor goed welzijn';

  @override
  String get takeElectrolytesMorning => 'Neem elektrolyten in de ochtend';

  @override
  String purchaseFailed(String error) {
    return 'Aankoop mislukt: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Herstellen mislukt: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — vertrouwd door 12.000 gebruikers';

  @override
  String get bestValue => 'Beste waarde';

  @override
  String percentOff(int percent) {
    return '-$percent% Beste waarde';
  }

  @override
  String get weatherUnavailable => 'Weer niet beschikbaar';

  @override
  String get checkLocationPermissions =>
      'Controleer locatie permissies en internet';

  @override
  String get recommendedNormLabel => 'Aanbevolen norm';

  @override
  String get waterAdjustment300 => '+300 ml';

  @override
  String get waterAdjustment400 => '+400 ml';

  @override
  String get waterAdjustment200 => '+200 ml';

  @override
  String get waterAdjustmentNormal => 'Normaal';

  @override
  String get waterAdjustment500 => '+500 ml';

  @override
  String get waterAdjustment250 => '+250 ml';

  @override
  String get waterAdjustment750 => '+750 ml';

  @override
  String get currentLocation => 'Huidige locatie';

  @override
  String get weatherClear => 'helder';

  @override
  String get weatherCloudy => 'bewolkt';

  @override
  String get weatherOvercast => 'zwaar bewolkt';

  @override
  String get weatherRain => 'regen';

  @override
  String get weatherSnow => 'sneeuw';

  @override
  String get weatherStorm => 'storm';

  @override
  String get weatherFog => 'mist';

  @override
  String get weatherDrizzle => 'motregen';

  @override
  String get weatherSunny => 'zonnig';

  @override
  String get heatWarningExtreme => '☀️ Extreme hitte! Maximale hydratie';

  @override
  String get heatWarningVeryHot => '🌡️ Erg heet! Risico op dehydratie';

  @override
  String get heatWarningHot => '🔥 Heet! Drink meer water';

  @override
  String get heatWarningElevated => '⚠️ Verhoogde temperatuur';

  @override
  String get heatWarningComfortable => 'Comfortabele temperatuur';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% water';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg natrium';
  }

  @override
  String get heatWarningCold => '❄️ Koud! Warm op en drink warme vloeistoffen';

  @override
  String get notificationChannelName => 'HydroCoach Herinneringen';

  @override
  String get notificationChannelDescription =>
      'Water en elektrolyten herinneringen';

  @override
  String get urgentNotificationChannelName => 'Urgente Herinneringen';

  @override
  String get urgentNotificationChannelDescription =>
      'Belangrijke hydratie meldingen';

  @override
  String get goodMorning => '☀️ Goedemorgen!';

  @override
  String get timeToHydrate => '💧 Tijd om te hydrateren';

  @override
  String get eveningHydration => '💧 Avond hydratie';

  @override
  String get dailyReportTitle => 'Dagrapport klaar';

  @override
  String get dailyReportBody => 'Zie hoe je hydratiedag verliep';

  @override
  String get maintainWaterBalance => 'Houd waterbalans de hele dag';

  @override
  String get electrolytesTime =>
      'Tijd voor elektrolyten: voeg snufje zout toe aan water';

  @override
  String catchUpHydration(int percent) {
    return 'Je hebt slechts $percent% van dagelijkse norm gedronken. Tijd om in te halen!';
  }

  @override
  String get excellentProgress =>
      'Uitstekende vooruitgang! Nog een beetje tot het doel';

  @override
  String get postCoffeeTitle => 'Na koffie';

  @override
  String get postCoffeeBody => 'Drink 250-300 ml water om balans te herstellen';

  @override
  String get postWorkoutTitle => 'Na training';

  @override
  String get postWorkoutBody =>
      'Herstel elektrolyten: 500 ml water + snufje zout';

  @override
  String get heatWarningPro => '🌡️ PRO Hittewaarschuwing';

  @override
  String get extremeHeatWarning =>
      'Extreme hitte! Verhoog waterverbruik met 15% en voeg 1g zout toe';

  @override
  String get hotWeatherWarning =>
      'Heet! Drink 10% meer water en vergeet elektrolyten niet';

  @override
  String get warmWeatherWarning => 'Warm weer. Monitor je hydratie';

  @override
  String get alcoholRecoveryTitle => '🍺 Hersteltijd';

  @override
  String get alcoholRecoveryBody =>
      'Drink 300 ml water met snufje zout voor balans';

  @override
  String get continueHydration => '💧 Ga door met hydrateren';

  @override
  String get alcoholRecoveryBody2 =>
      'Nog 500 ml water helpt je sneller herstellen';

  @override
  String get morningRecoveryTitle => '☀️ Ochtend herstel';

  @override
  String get morningRecoveryBody =>
      'Start de dag met 500 ml water en elektrolyten';

  @override
  String get testNotificationTitle => '🧪 Test melding';

  @override
  String get testNotificationBody =>
      'Als je dit ziet - instant meldingen werken!';

  @override
  String get scheduledTestTitle => '⏰ Geplande test (1 min)';

  @override
  String get scheduledTestBody =>
      'Deze melding werd 1 minuut geleden gepland. Planning werkt!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService geïnitialiseerd';

  @override
  String get localNotificationsInitialized =>
      '✅ Lokale meldingen geïnitialiseerd';

  @override
  String get androidChannelsCreated => '📢 Android melding kanalen aangemaakt';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Meldingen permissie: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Exacte alarmen permissie: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM permissies: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM Token ontvangen';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCM Token opgeslagen in Firestore voor gebruiker $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ Topic abonnement compleet';

  @override
  String foregroundMessage(String title) {
    return '📨 Voorgrond bericht: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Melding geopend: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Dagelijkse meldinglimiet bereikt (4/dag voor FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Melding planningsfout: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Melding direct getoond als fallback';

  @override
  String instantNotificationShown(String title) {
    return '📬 Instant melding getoond: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 Slimme herinneringen plannen...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ $count herinneringen gepland';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: Na-koffie herinnering gepland';

  @override
  String get postWorkoutScheduled => '💪 Na-training herinnering gepland';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Hittewaarschuwing verzonden';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO: Alcohol herstelplan gepland';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Avondrapport gepland voor $day.$month om 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Melding $id geannuleerd';
  }

  @override
  String get allNotificationsCancelled => '🗑️ Alle meldingen geannuleerd';

  @override
  String get reminderSettingsSaved => '✅ Herinnering instellingen opgeslagen';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Test melding gepland voor $time';
  }

  @override
  String get tomorrowRecommendations => 'Aanbevelingen voor morgen';

  @override
  String get recommendationExcellent =>
      'Uitstekend werk! Ga zo door. Probeer de dag te starten met een glas water en houd gelijk verbruik aan.';

  @override
  String get recommendationDiluted =>
      'Je drinkt veel water maar weinig elektrolyten. Voeg morgen meer zout toe of drink elektrolytendrank. Probeer de dag te starten met zoute bouillon.';

  @override
  String get recommendationDehydrated =>
      'Niet genoeg water vandaag. Stel morgen herinneringen in elke 2 uur. Houd waterfles in zicht.';

  @override
  String get recommendationLowSalt =>
      'Lage natriumwaarden kunnen vermoeidheid veroorzaken. Voeg snufje zout toe aan water of drink bouillon. Vooral belangrijk bij keto of vasten.';

  @override
  String get recommendationGeneral =>
      'Streef naar balans tussen water en elektrolyten. Drink gelijkmatig gedurende de dag en vergeet zout niet bij hitte.';

  @override
  String get category_water => 'Water';

  @override
  String get category_hot_drinks => 'Warme Dranken';

  @override
  String get category_juice => 'Sappen';

  @override
  String get category_sports => 'Sport';

  @override
  String get category_dairy => 'Zuivel';

  @override
  String get category_alcohol => 'Alcohol';

  @override
  String get category_supplements => 'Supplementen';

  @override
  String get category_other => 'Overige';

  @override
  String get drink_water => 'Water';

  @override
  String get drink_sparkling_water => 'Bruisend Water';

  @override
  String get drink_mineral_water => 'Mineraalwater';

  @override
  String get drink_coconut_water => 'Kokoswater';

  @override
  String get drink_coffee => 'Koffie';

  @override
  String get drink_espresso => 'Espresso';

  @override
  String get drink_americano => 'Americano';

  @override
  String get drink_cappuccino => 'Cappuccino';

  @override
  String get drink_latte => 'Latte';

  @override
  String get drink_black_tea => 'Zwarte Thee';

  @override
  String get drink_green_tea => 'Groene Thee';

  @override
  String get drink_herbal_tea => 'Kruidenthee';

  @override
  String get drink_matcha => 'Matcha';

  @override
  String get drink_hot_chocolate => 'Warme Chocolademelk';

  @override
  String get drink_orange_juice => 'Sinaasappelsap';

  @override
  String get drink_apple_juice => 'Appelsap';

  @override
  String get drink_grapefruit_juice => 'Grapefruitsap';

  @override
  String get drink_tomato_juice => 'Tomatensap';

  @override
  String get drink_vegetable_juice => 'Groentesap';

  @override
  String get drink_smoothie => 'Smoothie';

  @override
  String get drink_lemonade => 'Limonade';

  @override
  String get drink_isotonic => 'Isotone Drank';

  @override
  String get drink_electrolyte => 'Elektrolytendrank';

  @override
  String get drink_protein_shake => 'Proteïneshake';

  @override
  String get drink_bcaa => 'BCAA Drank';

  @override
  String get drink_energy => 'Energiedrank';

  @override
  String get drink_milk => 'Melk';

  @override
  String get drink_kefir => 'Kefir';

  @override
  String get drink_yogurt => 'Yoghurtdrank';

  @override
  String get drink_almond_milk => 'Amandelmelk';

  @override
  String get drink_soy_milk => 'Sojamelk';

  @override
  String get drink_oat_milk => 'Havermelk';

  @override
  String get drink_beer_light => 'Licht Bier';

  @override
  String get drink_beer_regular => 'Normaal Bier';

  @override
  String get drink_beer_strong => 'Sterk Bier';

  @override
  String get drink_wine_red => 'Rode Wijn';

  @override
  String get drink_wine_white => 'Witte Wijn';

  @override
  String get drink_champagne => 'Champagne';

  @override
  String get drink_vodka => 'Wodka';

  @override
  String get drink_whiskey => 'Whisky';

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
  String get drink_bone_broth => 'Bottenbouillon';

  @override
  String get drink_vegetable_broth => 'Groentebouillon';

  @override
  String get drink_soda => 'Frisdrank';

  @override
  String get drink_diet_soda => 'Light Frisdrank';

  @override
  String get addedToFavorites => 'Toegevoegd aan favorieten';

  @override
  String get favoriteLimitReached =>
      'Favorietenlimiet bereikt (3 voor FREE, 20 voor PRO)';

  @override
  String get addFavorite => 'Favoriet toevoegen';

  @override
  String get hotAndSupplements => 'Warm & Supplementen';

  @override
  String get quickVolumes => 'Snelle volumes:';

  @override
  String get type => 'Type:';

  @override
  String get regular => 'Normaal';

  @override
  String get coconut => 'Kokos';

  @override
  String get sparkling => 'Bruisend';

  @override
  String get mineral => 'Mineraal';

  @override
  String get hotDrinks => 'Warme Dranken';

  @override
  String get supplements => 'Supplementen';

  @override
  String get tea => 'Thee';

  @override
  String get salt => 'Zout (1/4 tl)';

  @override
  String get electrolyteMix => 'Elektrolyten Mix';

  @override
  String get boneBroth => 'Bottenbouillon';

  @override
  String get favoriteAssignmentComingSoon =>
      'Favoriet toewijzen komt binnenkort';

  @override
  String get longPressToEditComingSoon =>
      'Lang drukken om te bewerken - komt binnenkort';

  @override
  String get proSubscriptionRequired => 'PRO abonnement vereist';

  @override
  String get saveToFavorites => 'Opslaan als favoriet';

  @override
  String get savedToFavorites => 'Opgeslagen als favoriet';

  @override
  String get selectFavoriteSlot => 'Selecteer favoriet slot';

  @override
  String get slot => 'Slot';

  @override
  String get emptySlot => 'Leeg slot';

  @override
  String get upgradeToUnlock => 'Upgrade naar PRO om te ontgrendelen';

  @override
  String get changeFavorite => 'Favoriet wijzigen';

  @override
  String get removeFavorite => 'Favoriet verwijderen';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'Mineraalwater';

  @override
  String get coconutWater => 'Kokoswater';

  @override
  String get lemonWater => 'Citroenwater';

  @override
  String get greenTea => 'Groene Thee';

  @override
  String get amount => 'Hoeveelheid';

  @override
  String get createFavoriteHint =>
      'Om een favoriet toe te voegen, ga naar een drankscherm hieronder en tik op \'Opslaan als favoriet\' knop na instellen van je drank.';

  @override
  String get sparklingWater => 'Bruisend Water';

  @override
  String get cola => 'Cola';

  @override
  String get juice => 'Sap';

  @override
  String get energyDrink => 'Energiedrank';

  @override
  String get sportsDrink => 'Sportdrank';

  @override
  String get selectElectrolyteType => 'Selecteer elektrolyt type:';

  @override
  String get saltQuarterTsp => 'Zout (1/4 tl)';

  @override
  String get pinkSalt => 'Roze Himalayazout';

  @override
  String get seaSalt => 'Zeezout';

  @override
  String get potassiumCitrate => 'Kaliumcitraat';

  @override
  String get magnesiumGlycinate => 'Magnesiumglycinaat';

  @override
  String get coconutWaterElectrolyte => 'Kokoswater';

  @override
  String get sportsDrinkElectrolyte => 'Sportdrank';

  @override
  String get electrolyteContent => 'Elektrolyten inhoud:';

  @override
  String sodiumContent(int amount) {
    return 'Natrium: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return 'Kalium: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Magnesium: $amount mg';
  }

  @override
  String get servings => 'Porties';

  @override
  String get enterServings => 'Voer porties in';

  @override
  String get servingsUnit => 'porties';

  @override
  String get noElectrolytes => 'Geen elektrolyten';

  @override
  String get enterValidAmount => 'Voer geldig bedrag in';

  @override
  String get lmntMix => 'LMNT Mix';

  @override
  String get pickleJuice => 'Augurkensap';

  @override
  String get tomatoSalt => 'Tomaat + Zout';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'Alkalisch Water';

  @override
  String get celticSalt => 'Keltisch Zoutwater';

  @override
  String get soleWater => 'Sole Water';

  @override
  String get mineralDrops => 'Minerale Druppels';

  @override
  String get bakingSoda => 'Zuiveringszoutwater';

  @override
  String get creamTartar => 'Wijnsteen';

  @override
  String get selectSupplementType => 'Selecteer supplement type:';

  @override
  String get multivitamin => 'Multivitamine';

  @override
  String get magnesiumCitrate => 'Magnesiumcitraat';

  @override
  String get magnesiumThreonate => 'Magnesium L-Threonaat';

  @override
  String get calciumCitrate => 'Calciumcitraat';

  @override
  String get zincGlycinate => 'Zinkglycinaat';

  @override
  String get vitaminD3 => 'Vitamine D3';

  @override
  String get vitaminC => 'Vitamine C';

  @override
  String get bComplex => 'B-Complex';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => 'IJzerbisglycinaat';

  @override
  String get dosage => 'Dosering';

  @override
  String get enterDosage => 'Voer dosering in';

  @override
  String get noElectrolyteContent => 'Geen elektrolyten inhoud';

  @override
  String get blackTea => 'Zwarte Thee';

  @override
  String get herbalTea => 'Kruidenthee';

  @override
  String get espresso => 'Espresso';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get latte => 'Latte';

  @override
  String get matcha => 'Matcha';

  @override
  String get hotChocolate => 'Warme Chocolademelk';

  @override
  String get caffeine => 'Cafeïne';

  @override
  String get sports => 'Sport';

  @override
  String get walking => 'Wandelen';

  @override
  String get running => 'Hardlopen';

  @override
  String get gym => 'Sportschool';

  @override
  String get cycling => 'Fietsen';

  @override
  String get swimming => 'Zwemmen';

  @override
  String get yoga => 'Yoga';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'Boksen';

  @override
  String get dancing => 'Dansen';

  @override
  String get tennis => 'Tennis';

  @override
  String get teamSports => 'Teamsport';

  @override
  String get selectActivityType => 'Selecteer activiteit type:';

  @override
  String get duration => 'Duur';

  @override
  String get minutes => 'minuten';

  @override
  String get enterDuration => 'Voer duur in';

  @override
  String get lowIntensity => 'Lage intensiteit';

  @override
  String get mediumIntensity => 'Gemiddelde intensiteit';

  @override
  String get highIntensity => 'Hoge intensiteit';

  @override
  String get recommendedIntake => 'Aanbevolen inname:';

  @override
  String get basedOnWeight => 'Op basis van gewicht';

  @override
  String get logActivity => 'Log Activiteit';

  @override
  String get activityLogged => 'Activiteit gelogd';

  @override
  String get enterValidDuration => 'Voer geldige duur in';

  @override
  String get sauna => 'Sauna';

  @override
  String get veryHighIntensity => 'Zeer hoge intensiteit';

  @override
  String get hriStatusExcellent => 'Uitstekend';

  @override
  String get hriStatusGood => 'Goed';

  @override
  String get hriStatusModerate => 'Matig Risico';

  @override
  String get hriStatusHighRisk => 'Hoog Risico';

  @override
  String get hriStatusCritical => 'Kritiek';

  @override
  String get hriComponentWater => 'Waterbalans';

  @override
  String get hriComponentSodium => 'Natriumniveau';

  @override
  String get hriComponentPotassium => 'Kaliumniveau';

  @override
  String get hriComponentMagnesium => 'Magnesiumniveau';

  @override
  String get hriComponentHeat => 'Hittestress';

  @override
  String get hriComponentWorkout => 'Fysieke activiteit';

  @override
  String get hriComponentCaffeine => 'Cafeïne impact';

  @override
  String get hriComponentAlcohol => 'Alcohol impact';

  @override
  String get hriComponentTime => 'Tijd sinds inname';

  @override
  String get hriComponentMorning => 'Ochtend factoren';

  @override
  String get hriBreakdownTitle => 'Risico factoren uitsplitsing';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max pts';
  }

  @override
  String get fastingModeActive => 'Vastenmodus actief';

  @override
  String get fastingSuppressionNote => 'Tijdfactor onderdrukt tijdens vasten';

  @override
  String get morningCheckInTitle => 'Ochtend Check-in';

  @override
  String get howAreYouFeeling => 'Hoe voel je je?';

  @override
  String get feelingScale1 => 'Slecht';

  @override
  String get feelingScale2 => 'Onder gemiddeld';

  @override
  String get feelingScale3 => 'Normaal';

  @override
  String get feelingScale4 => 'Goed';

  @override
  String get feelingScale5 => 'Uitstekend';

  @override
  String get weightChange => 'Gewichtsverandering sinds gisteren';

  @override
  String get urineColorScale => 'Urine kleur (1-8 schaal)';

  @override
  String get urineColor1 => '1 - Zeer bleek';

  @override
  String get urineColor2 => '2 - Bleek';

  @override
  String get urineColor3 => '3 - Lichtgeel';

  @override
  String get urineColor4 => '4 - Geel';

  @override
  String get urineColor5 => '5 - Donkergeel';

  @override
  String get urineColor6 => '6 - Amber';

  @override
  String get urineColor7 => '7 - Donker amber';

  @override
  String get urineColor8 => '8 - Bruin';

  @override
  String get alcoholWithDecay => 'Alcohol impact (afnemend)';

  @override
  String standardDrinksToday(Object count) {
    return 'Standaardglazen vandaag: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Actieve cafeïne: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRI Debug Info';

  @override
  String hriNormalized(Object value) {
    return 'HRI (genormaliseerd): $value/100';
  }

  @override
  String get fastingWindowActive => 'Vastenvenster actief';

  @override
  String get eatingWindowActive => 'Eetvenster actief';

  @override
  String nextFastingWindow(Object time) {
    return 'Volgend vasten: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Volgend eten: $time';
  }

  @override
  String get todaysWorkouts => 'Trainingen Vandaag';

  @override
  String get hoursAgo => 'u geleden';

  @override
  String get onboardingWelcomeTitle => 'HydroCoach — slimme hydratie elke dag';

  @override
  String get onboardingWelcomeSubtitle =>
      'Drink slimmer, niet meer\nDe app houdt rekening met weer, elektrolyten en je gewoontes\nHelpt heldere geest en stabiele energie behouden';

  @override
  String get onboardingBullet1 =>
      'Persoonlijke water en zout norm op basis van weer en jou';

  @override
  String get onboardingBullet2 =>
      '\"Wat nu te doen\" tips in plaats van ruwe grafieken';

  @override
  String get onboardingBullet3 =>
      'Alcohol in standaarddoses met veilige limieten';

  @override
  String get onboardingBullet4 => 'Slimme herinneringen zonder spam';

  @override
  String get onboardingStartButton => 'Starten';

  @override
  String get onboardingHaveAccount => 'Ik heb al een account';

  @override
  String get onboardingPracticeFasting => 'Ik praktiseer intermitterend vasten';

  @override
  String get onboardingPracticeFastingDesc =>
      'Speciaal elektrolyten regime voor vastenvensters';

  @override
  String get onboardingProfileReady => 'Profiel klaar!';

  @override
  String get onboardingWaterNorm => 'Water norm';

  @override
  String get onboardingIonWillHelp => 'ION helpt dagelijks balans behouden';

  @override
  String get onboardingContinue => 'Doorgaan';

  @override
  String get onboardingLocationTitle => 'Weer is belangrijk voor hydratie';

  @override
  String get onboardingLocationSubtitle =>
      'We houden rekening met weer en vochtigheid. Dit is nauwkeuriger dan alleen formule op basis van gewicht';

  @override
  String get onboardingWeatherExample => 'Heet vandaag! +15% water';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg natrium voor hitte';

  @override
  String get onboardingEnablePermission => 'Inschakelen';

  @override
  String get onboardingEnableLater => 'Later inschakelen';

  @override
  String get onboardingNotificationTitle => 'Slimme herinneringen';

  @override
  String get onboardingNotificationSubtitle =>
      'Korte tips op het juiste moment. Je kunt frequentie in één tik wijzigen';

  @override
  String get onboardingNotifExample1 => 'Tijd om te hydrateren';

  @override
  String get onboardingNotifExample2 => 'Vergeet elektrolyten niet';

  @override
  String get onboardingNotifExample3 => 'Heet! Drink meer water';

  @override
  String get sportRecoveryProtocols => 'Sport herstelprotocollen';

  @override
  String get allDrinksAndSupplements => 'Alle dranken & supplementen';

  @override
  String get notificationChannelDefault => 'Hydratie Herinneringen';

  @override
  String get notificationChannelDefaultDesc =>
      'Water en elektrolyten herinneringen';

  @override
  String get notificationChannelUrgent => 'Belangrijke Meldingen';

  @override
  String get notificationChannelUrgentDesc =>
      'Hittewaarschuwingen en kritieke hydratie waarschuwingen';

  @override
  String get notificationChannelReport => 'Rapporten';

  @override
  String get notificationChannelReportDesc =>
      'Dagelijkse en wekelijkse rapporten';

  @override
  String get notificationWaterTitle => '💧 Tijd om te hydrateren';

  @override
  String get notificationWaterBody => 'Vergeet niet water te drinken';

  @override
  String get notificationPostCoffeeTitle => '☕ Na koffie';

  @override
  String get notificationPostCoffeeBody =>
      'Drink 250-300 ml water om balans te herstellen';

  @override
  String get notificationDailyReportTitle => '📊 Dagrapport klaar';

  @override
  String get notificationDailyReportBody => 'Zie hoe je hydratiedag verliep';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Hersteltijd';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return 'Drink $ml ml water met snufje zout';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Hittewaarschuwing';

  @override
  String get notificationHeatWarningExtremeBody =>
      'Extreme hitte! +15% water en +1g zout';

  @override
  String get notificationHeatWarningHotBody =>
      'Heet! +10% water en elektrolyten';

  @override
  String get notificationHeatWarningWarmBody => 'Warm. Monitor je hydratie';

  @override
  String get notificationWorkoutTitle => '💪 Training';

  @override
  String get notificationWorkoutBody => 'Vergeet water en elektrolyten niet';

  @override
  String get notificationPostWorkoutTitle => '💪 Na training';

  @override
  String get notificationPostWorkoutBody =>
      '500 ml water + elektrolyten voor herstel';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Elektrolyten tijd';

  @override
  String get notificationFastingElectrolyteBody =>
      'Voeg snufje zout toe aan water of drink bouillon';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Herstel ${hours}u';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return 'Drink $ml ml water';
  }

  @override
  String get notificationAlcoholRecoveryMidBody =>
      'Voeg elektrolyten toe: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Morgenochtend - controle check-in';

  @override
  String get notificationMorningCheckInTitle => '☀️ Ochtend check-in';

  @override
  String get notificationMorningCheckInBody =>
      'Hoe voel je je? Beoordeel je conditie en krijg een plan voor de dag';

  @override
  String get notificationMorningWaterBody => 'Start je dag met een glas water';

  @override
  String notificationLowProgressBody(int percent) {
    return 'Je hebt slechts $percent% van de norm gedronken. Tijd om in te halen!';
  }

  @override
  String get notificationGoodProgressBody =>
      'Uitstekende vooruitgang! Ga zo door';

  @override
  String get notificationMaintainBalanceBody => 'Houd waterbalans';

  @override
  String get notificationTestTitle => '🧪 Test melding';

  @override
  String get notificationTestBody => 'Als je dit ziet - meldingen werken!';

  @override
  String get notificationTestScheduledTitle => '⏰ Geplande test';

  @override
  String get notificationTestScheduledBody =>
      'Deze melding werd 1 minuut geleden gepland';

  @override
  String get onboardingUnitsTitle => 'Kies je eenheden';

  @override
  String get onboardingUnitsSubtitle => 'Je kunt dit later niet wijzigen';

  @override
  String get onboardingUnitsWarning =>
      'Deze keuze is permanent en kan later niet worden gewijzigd';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'gal';

  @override
  String get lb => 'lb';

  @override
  String get target => 'Doel';

  @override
  String get wind => 'Wind';

  @override
  String get pressure => 'Druk';

  @override
  String get highHeatIndexWarning => 'Hoge hitteindex! Verhoog je waterinname';

  @override
  String get weatherCondition => 'Conditie';

  @override
  String get feelsLike => 'Voelt Als';

  @override
  String get humidityLabel => 'Vochtigheid';

  @override
  String get waterNormal => 'Normaal';

  @override
  String get sodiumNormal => 'Standaard';

  @override
  String get addedSuccessfully => 'Succesvol toegevoegd';

  @override
  String get sugarIntake => 'Suikerinname';

  @override
  String get sugarToday => 'Suikerverbruik vandaag';

  @override
  String get totalSugar => 'Totale Suiker';

  @override
  String get dailyLimit => 'Dagelijkse Limiet';

  @override
  String get addedSugar => 'Toegevoegde Suiker';

  @override
  String get naturalSugar => 'Natuurlijke Suiker';

  @override
  String get hiddenSugar => 'Verborgen Suiker';

  @override
  String get sugarFromDrinks => 'Dranken';

  @override
  String get sugarFromFood => 'Eten';

  @override
  String get sugarFromSnacks => 'Snacks';

  @override
  String get sugarNormal => 'Normaal';

  @override
  String get sugarModerate => 'Matig';

  @override
  String get sugarHigh => 'Hoog';

  @override
  String get sugarCritical => 'Kritiek';

  @override
  String get sugarRecommendationNormal =>
      'Goed bezig! Je suikerinname is binnen gezonde limieten';

  @override
  String get sugarRecommendationModerate =>
      'Overweeg om zoete dranken en snacks te verminderen';

  @override
  String get sugarRecommendationHigh =>
      'Hoge suikerinname! Beperk zoete dranken en desserts';

  @override
  String get sugarRecommendationCritical =>
      'Zeer hoge suiker! Vermijd suikerhoudende dranken en snoep vandaag';

  @override
  String get noSugarIntake => 'Geen suiker gelogd vandaag';

  @override
  String get hriImpact => 'HRI Impact';

  @override
  String get hri_component_sugar => 'Suiker';

  @override
  String get hri_sugar_description =>
      'Hoge suikerinname beïnvloedt hydratie en algehele gezondheid';

  @override
  String get tip_reduce_sweet_drinks =>
      'Vervang zoete dranken door water of ongezoete thee';

  @override
  String get tip_avoid_added_sugar =>
      'Controleer labels en vermijd producten met toegevoegde suikers';

  @override
  String get tip_check_labels =>
      'Wees bewust van verborgen suikers in sauzen en verwerkte voedingsmiddelen';

  @override
  String get tip_replace_soda =>
      'Vervang frisdrank door bruisend water met citroen';

  @override
  String get sugarSources => 'Suikerbronnen';

  @override
  String get drinks => 'Dranken';

  @override
  String get food => 'Eten';

  @override
  String get snacks => 'Snacks';

  @override
  String get recommendedLimit => 'Aanbevolen';

  @override
  String get points => 'punten';

  @override
  String get drinkLightBeer => 'Licht Bier';

  @override
  String get drinkLager => 'Lager';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'Stout';

  @override
  String get drinkWheatBeer => 'Tarwebier';

  @override
  String get drinkCraftBeer => 'Craft Bier';

  @override
  String get drinkNonAlcoholic => 'Alcoholvrij';

  @override
  String get drinkRadler => 'Radler';

  @override
  String get drinkPilsner => 'Pilsner';

  @override
  String get drinkRedWine => 'Rode Wijn';

  @override
  String get drinkWhiteWine => 'Witte Wijn';

  @override
  String get drinkProsecco => 'Prosecco';

  @override
  String get drinkPort => 'Port';

  @override
  String get drinkRose => 'Rosé';

  @override
  String get drinkDessertWine => 'Dessertwijn';

  @override
  String get drinkSangria => 'Sangria';

  @override
  String get drinkSherry => 'Sherry';

  @override
  String get drinkVodkaShot => 'Wodka Shot';

  @override
  String get drinkCognac => 'Cognac';

  @override
  String get drinkLiqueur => 'Likeur';

  @override
  String get drinkAbsinthe => 'Absint';

  @override
  String get drinkBrandy => 'Brandy';

  @override
  String get drinkLongIsland => 'Long Island';

  @override
  String get drinkGinTonic => 'Gin & Tonic';

  @override
  String get drinkPinaColada => 'Piña Colada';

  @override
  String get drinkCosmopolitan => 'Cosmopolitan';

  @override
  String get drinkMaiTai => 'Mai Tai';

  @override
  String get drinkBloodyMary => 'Bloody Mary';

  @override
  String get drinkDaiquiri => 'Daiquiri';

  @override
  String popularDrinks(Object type) {
    return 'Populaire $type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g suiker';

  @override
  String get moderateConsumption => 'Matig verbruik';

  @override
  String get aboveRecommendations => 'Boven aanbevelingen';

  @override
  String get highConsumption => 'Hoog verbruik';

  @override
  String get veryHighConsider => 'Zeer hoog - overweeg te stoppen';

  @override
  String get noAlcoholToday => 'Geen alcohol vandaag';

  @override
  String get drinkWaterNow => 'Drink nu 300-500 ml water';

  @override
  String get addPinchSalt => 'Voeg snufje zout toe';

  @override
  String get avoidLateCoffee => 'Vermijd late koffie';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => 'Elektrolyten Vandaag';

  @override
  String get greatBalance => 'Goede balans!';

  @override
  String get gettingThere => 'Bijna goed';

  @override
  String get needMoreElectrolytes => 'Meer elektrolyten nodig';

  @override
  String get lowElectrolyteLevels => 'Lage elektrolyten niveaus';

  @override
  String get electrolyteTips => 'Elektrolyten Tips';

  @override
  String get takeWithWater => 'Neem met veel water';

  @override
  String get bestBetweenMeals => 'Best tussen maaltijden opgenomen';

  @override
  String get startSmallAmounts => 'Begin met kleine hoeveelheden';

  @override
  String get extraDuringExercise => 'Extra nodig tijdens oefening';

  @override
  String get electrolytesBasic => 'Basis';

  @override
  String get electrolytesMixes => 'Mixen';

  @override
  String get electrolytesPills => 'Pillen';

  @override
  String get popularSalts => 'Populaire Zouten & Bouillons';

  @override
  String get popularMixes => 'Populaire Elektrolyten Mixen';

  @override
  String get popularSupplements => 'Populaire Supplementen';

  @override
  String get electrolyteSaltWater => 'Zoutwater';

  @override
  String get electrolytePinkSalt => 'Roze Zout';

  @override
  String get electrolyteSeaSalt => 'Zeezout';

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
  String get electrolytePotassiumChloride => 'Kaliumchloride';

  @override
  String get electrolyteMagThreonate => 'Mag Threonaat';

  @override
  String get electrolyteTraceMinerals => 'Spoormineralen';

  @override
  String get electrolyteZMAComplex => 'ZMA Complex';

  @override
  String get electrolyteMultiMineral => 'Multi-Mineraal';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => 'Hydratie';

  @override
  String get todayHydration => 'Hydratie Vandaag';

  @override
  String get currentIntake => 'Verbruikt';

  @override
  String get dailyGoal => 'Doel';

  @override
  String get toGo => 'Resterend';

  @override
  String get goalReached => 'Doel bereikt!';

  @override
  String get almostThere => 'Bijna daar!';

  @override
  String get halfwayThere => 'Halverwege';

  @override
  String get keepGoing => 'Ga door!';

  @override
  String get startDrinking => 'Begin met drinken';

  @override
  String get plainWater => 'Puur';

  @override
  String get enhancedWater => 'Verrijkt';

  @override
  String get beverages => 'Dranken';

  @override
  String get sodas => 'Frisdranken';

  @override
  String get popularPlainWater => 'Populaire Water Types';

  @override
  String get popularEnhancedWater => 'Verrijkt & Infused';

  @override
  String get popularBeverages => 'Populaire Dranken';

  @override
  String get popularSodas => 'Populaire Frisdranken & Energy';

  @override
  String get hydrationTips => 'Hydratie Tips';

  @override
  String get drinkRegularly => 'Drink regelmatig kleine hoeveelheden';

  @override
  String get roomTemperature => 'Kamertemperatuur water neemt beter op';

  @override
  String get addLemon => 'Voeg citroen toe voor betere smaak';

  @override
  String get limitSugary => 'Beperk suikerhoudende dranken - ze dehydrateren';

  @override
  String get warmWater => 'Warm Water';

  @override
  String get iceWater => 'IJs Water';

  @override
  String get filteredWater => 'Gefilterd Water';

  @override
  String get distilledWater => 'Gedistilleerd Water';

  @override
  String get springWater => 'Bronwater';

  @override
  String get hydrogenWater => 'Waterstof Water';

  @override
  String get oxygenatedWater => 'Zuurstof Water';

  @override
  String get cucumberWater => 'Komkommer Water';

  @override
  String get limeWater => 'Limoen Water';

  @override
  String get berryWater => 'Bessen Water';

  @override
  String get mintWater => 'Munt Water';

  @override
  String get gingerWater => 'Gember Water';

  @override
  String get caffeineStatusNone => 'Geen cafeïne vandaag';

  @override
  String caffeineStatusModerate(Object amount) {
    return 'Matig: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return 'Hoog: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return 'Zeer hoog: ${amount}mg!';
  }

  @override
  String get caffeineDailyLimit => 'Dagelijkse limiet: 400mg';

  @override
  String get caffeineWarningTitle => 'Cafeïne Waarschuwing';

  @override
  String get caffeineWarning400 =>
      'Je hebt vandaag meer dan 400mg cafeïne genomen';

  @override
  String get caffeineTipWater => 'Drink extra water om te compenseren';

  @override
  String get caffeineTipAvoid => 'Vermijd vandaag meer cafeïne';

  @override
  String get caffeineTipSleep => 'Kan je slaapkwaliteit beïnvloeden';

  @override
  String get total => 'Totaal';

  @override
  String get cupsToday => 'Kopjes vandaag';

  @override
  String get metabolizeTime => 'Tijd om te metaboliseren';

  @override
  String get aboutCaffeine => 'Over Cafeïne';

  @override
  String get caffeineInfo1 =>
      'Koffie bevat natuurlijke cafeïne die alertheid verhoogt';

  @override
  String get caffeineInfo2 =>
      'Dagelijkse veilige limiet is 400mg voor de meeste volwassenen';

  @override
  String get caffeineInfo3 => 'Cafeïne halfwaardetijd is 5-6 uur';

  @override
  String get caffeineInfo4 =>
      'Drink extra water om cafeïne\'s diuretisch effect te compenseren';

  @override
  String get caffeineWarningPregnant =>
      'Zwangere vrouwen moeten cafeïne beperken tot 200mg/dag';

  @override
  String get gotIt => 'Begrepen';

  @override
  String get consumed => 'Verbruikt';

  @override
  String get remaining => 'remaining';

  @override
  String get todaysCaffeine => 'Cafeïne Vandaag';

  @override
  String get alreadyInFavorites => 'Al in favorieten';

  @override
  String get ofRecommendedLimit => 'van aanbevolen limiet';

  @override
  String get aboutAlcohol => 'Over Alcohol';

  @override
  String get alcoholInfo1 => 'Eén standaardglas is gelijk aan 10g pure alcohol';

  @override
  String get alcoholInfo2 =>
      'Alcohol dehydrateert — drink 250ml extra water per glas';

  @override
  String get alcoholInfo3 =>
      'Voeg natrium toe om vloeistoffen na drinken te behouden';

  @override
  String get alcoholInfo4 => 'Elk standaardglas verhoogt HRI met 3-5 punten';

  @override
  String get alcoholWarningHealth =>
      'Overmatig alcoholgebruik is schadelijk voor gezondheid. De aanbevolen limiet is 2 SD voor mannen en 1 SD voor vrouwen per dag.';

  @override
  String get supplementsInfo1 =>
      'Supplementen helpen elektrolytenbalans behouden';

  @override
  String get supplementsInfo2 => 'Best ingenomen met maaltijden voor opname';

  @override
  String get supplementsInfo3 => 'Altijd innemen met veel water';

  @override
  String get supplementsInfo4 =>
      'Magnesium en kalium zijn essentieel voor hydratie';

  @override
  String get supplementsWarning =>
      'Raadpleeg zorgverlener voordat je supplementen regime start';

  @override
  String get fromSupplementsToday => 'Van Supplementen Vandaag';

  @override
  String get minerals => 'Mineralen';

  @override
  String get vitamins => 'Vitamines';

  @override
  String get essentialMinerals => 'Essentiële Mineralen';

  @override
  String get otherSupplements => 'Andere Supplementen';

  @override
  String get supplementTip1 =>
      'Neem supplementen met voedsel voor betere opname';

  @override
  String get supplementTip2 => 'Drink veel water met supplementen';

  @override
  String get supplementTip3 => 'Verdeel meerdere supplementen over de dag';

  @override
  String get supplementTip4 => 'Houd bij wat voor jou werkt';

  @override
  String get calciumCarbonate => 'Calciumcarbonaat';

  @override
  String get traceMinerals => 'Spoormineralen';

  @override
  String get vitaminA => 'Vitamine A';

  @override
  String get vitaminE => 'Vitamine E';

  @override
  String get vitaminK2 => 'Vitamine K2';

  @override
  String get folate => 'Folaat';

  @override
  String get biotin => 'Biotine';

  @override
  String get probiotics => 'Probiotica';

  @override
  String get melatonin => 'Melatonine';

  @override
  String get collagen => 'Collageen';

  @override
  String get glucosamine => 'Glucosamine';

  @override
  String get turmeric => 'Kurkuma';

  @override
  String get coq10 => 'CoQ10';

  @override
  String get creatine => 'Creatine';

  @override
  String get ashwagandha => 'Ashwagandha';

  @override
  String get selectCardioActivity => 'Selecteer Cardio Activiteit';

  @override
  String get selectStrengthActivity => 'Selecteer Kracht Activiteit';

  @override
  String get selectSportsActivity => 'Selecteer Sport';

  @override
  String get sessions => 'Sessies';

  @override
  String get totalTime => 'Totale Tijd';

  @override
  String get waterLoss => 'Waterverlies';

  @override
  String get intensity => 'Intensiteit';

  @override
  String get drinkWaterAfterWorkout => 'Drink water na training';

  @override
  String get replenishElectrolytes => 'Vul elektrolyten aan';

  @override
  String get restAndRecover => 'Rust en herstel';

  @override
  String get avoidSugaryDrinks => 'Vermijd suikerhoudende sportdranken';

  @override
  String get elliptical => 'Crosstrainer';

  @override
  String get rowing => 'Roeien';

  @override
  String get jumpRope => 'Touwtjespringen';

  @override
  String get stairClimbing => 'Traplopen';

  @override
  String get bodyweight => 'Lichaamsgewicht';

  @override
  String get powerlifting => 'Powerlifting';

  @override
  String get calisthenics => 'Calisthenics';

  @override
  String get resistanceBands => 'Weerstandsbanden';

  @override
  String get kettlebell => 'Kettlebell';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'Strongman';

  @override
  String get pilates => 'Pilates';

  @override
  String get basketball => 'Basketbal';

  @override
  String get soccerFootball => 'Voetbal';

  @override
  String get golf => 'Golf';

  @override
  String get martialArts => 'Vechtsporten';

  @override
  String get rockClimbing => 'Rotsklimmen';

  @override
  String get needsToReplenish => 'Moet aanvullen';

  @override
  String get electrolyteTrackingPro =>
      'Volg natrium, kalium & magnesium doelen met gedetailleerde voortgangsbalken';

  @override
  String get unlock => 'Ontgrendel';

  @override
  String get weather => 'Weer';

  @override
  String get weatherTrackingPro =>
      'Volg hitteindex, vochtigheid & weer impact op hydratie doelen';

  @override
  String get sugarTracking => 'Suiker Tracking';

  @override
  String get sugarTrackingPro =>
      'Monitor natuurlijke, toegevoegde & verborgen suikerinname met HRI impact analyse';

  @override
  String get dayOverview => 'Dag Overzicht';

  @override
  String get tapForDetails => 'Tik voor details';

  @override
  String get noDataForDay => 'Geen data voor deze dag';

  @override
  String get sweatLoss => 'zweetverlies';

  @override
  String get cardio => 'Cardio';

  @override
  String get workout => 'Training';

  @override
  String get noWaterToday => 'Geen water geregistreerd vandaag';

  @override
  String get noElectrolytesToday => 'Geen elektrolyten geregistreerd vandaag';

  @override
  String get noCoffeeToday => 'Geen koffie geregistreerd vandaag';

  @override
  String get noWorkoutsToday => 'Geen trainingen geregistreerd vandaag';

  @override
  String get noWaterThisDay => 'Geen water geregistreerd deze dag';

  @override
  String get noElectrolytesThisDay =>
      'Geen elektrolyten geregistreerd deze dag';

  @override
  String get noCoffeeThisDay => 'Geen koffie geregistreerd deze dag';

  @override
  String get noWorkoutsThisDay => 'Geen trainingen geregistreerd deze dag';

  @override
  String get weeklyReport => 'Weekrapport';

  @override
  String get weeklyReportSubtitle => 'Diepe inzichten en trends analyse';

  @override
  String get workouts => 'Trainingen';

  @override
  String get workoutHydration => 'Training Hydratie';

  @override
  String workoutHydrationMessage(Object percent) {
    return 'Op trainingsdagen drink je $percent% meer water';
  }

  @override
  String get weeklyActivity => 'Wekelijkse Activiteit';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return 'Je hebt $minutes minuten getraind over $days dagen';
  }

  @override
  String get workoutMinutesPerDay => 'Trainingsminuten per dag';

  @override
  String get daysWithWorkouts => 'dagen met trainingen';

  @override
  String get noWorkoutsThisWeek => 'Geen trainingen deze week';

  @override
  String get noAlcoholThisWeek => 'Geen alcohol deze week';

  @override
  String get csvExported => 'Data geëxporteerd naar CSV';

  @override
  String get mondayShort => 'MA';

  @override
  String get tuesdayShort => 'DI';

  @override
  String get wednesdayShort => 'WO';

  @override
  String get thursdayShort => 'DO';

  @override
  String get fridayShort => 'VR';

  @override
  String get saturdayShort => 'ZA';

  @override
  String get sundayShort => 'ZO';

  @override
  String get achievements => 'Prestaties';

  @override
  String get achievementsTabAll => 'Alles';

  @override
  String get achievementsTabHydration => 'Hydratie';

  @override
  String get achievementsTabElectrolytes => 'Elektrolyten';

  @override
  String get achievementsTabSugar => 'Suiker Controle';

  @override
  String get achievementsTabAlcohol => 'Alcohol';

  @override
  String get achievementsTabWorkout => 'Fitness';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => 'Reeksen';

  @override
  String get achievementsTabSpecial => 'Speciaal';

  @override
  String get achievementUnlocked => 'Prestatie Ontgrendeld!';

  @override
  String get achievementProgress => 'Voortgang';

  @override
  String get achievementPoints => 'punten';

  @override
  String get achievementRarityCommon => 'Gewoon';

  @override
  String get achievementRarityUncommon => 'Ongewoon';

  @override
  String get achievementRarityRare => 'Zeldzaam';

  @override
  String get achievementRarityEpic => 'Episch';

  @override
  String get achievementRarityLegendary => 'Legendarisch';

  @override
  String get achievementStatsUnlocked => 'Ontgrendeld';

  @override
  String get achievementStatsTotal => 'Totaal Punten';

  @override
  String get achievementFilterAll => 'Alles';

  @override
  String get achievementFilterUnlocked => 'Ontgrendeld';

  @override
  String get achievementSortProgress => 'Voortgang';

  @override
  String get achievementSortName => 'Naam';

  @override
  String get achievementSortRarity => 'Zeldzaamheid';

  @override
  String get achievementNoAchievements => 'Nog geen prestaties';

  @override
  String get achievementKeepUsing =>
      'Blijf de app gebruiken om prestaties te ontgrendelen!';

  @override
  String get achievementFirstGlass => 'Eerste Druppel';

  @override
  String get achievementFirstGlassDesc => 'Drink je eerste glas water';

  @override
  String get achievementHydrationGoal1 => 'Gehydrateerd';

  @override
  String get achievementHydrationGoal1Desc => 'Bereik je dagelijkse waterdoel';

  @override
  String get achievementHydrationGoal7 => 'Week van Hydratie';

  @override
  String get achievementHydrationGoal7Desc => 'Bereik waterdoel 7 dagen op rij';

  @override
  String get achievementHydrationGoal30 => 'Hydratie Master';

  @override
  String get achievementHydrationGoal30Desc =>
      'Bereik waterdoel 30 dagen op rij';

  @override
  String get achievementPerfectHydration => 'Perfecte Balans';

  @override
  String get achievementPerfectHydrationDesc => 'Bereik 90-110% van waterdoel';

  @override
  String get achievementEarlyBird => 'Vroege Vogel';

  @override
  String get achievementEarlyBirdDesc => 'Drink je eerste water voor 9 uur';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return 'Drink $volume voor 9 uur';
  }

  @override
  String get achievementNightOwl => 'Nacht Uil';

  @override
  String get achievementNightOwlDesc => 'Voltooi hydratie doel voor 18 uur';

  @override
  String get achievementLiterLegend => 'Liter Legende';

  @override
  String get achievementLiterLegendDesc => 'Bereik je totale hydratie mijlpaal';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return 'Drink $volume totaal';
  }

  @override
  String get achievementSaltStarter => 'Zout Starter';

  @override
  String get achievementSaltStarterDesc => 'Voeg je eerste elektrolyten toe';

  @override
  String get achievementElectrolyteBalance => 'Gebalanceerd';

  @override
  String get achievementElectrolyteBalanceDesc =>
      'Bereik alle elektrolyten doelen in één dag';

  @override
  String get achievementSodiumMaster => 'Natrium Master';

  @override
  String get achievementSodiumMasterDesc =>
      'Bereik natrium doel 7 dagen op rij';

  @override
  String get achievementPotassiumPro => 'Kalium Pro';

  @override
  String get achievementPotassiumProDesc => 'Bereik kalium doel 7 dagen op rij';

  @override
  String get achievementMagnesiumMaven => 'Magnesium Maven';

  @override
  String get achievementMagnesiumMavenDesc =>
      'Bereik magnesium doel 7 dagen op rij';

  @override
  String get achievementElectrolyteExpert => 'Elektrolyten Expert';

  @override
  String get achievementElectrolyteExpertDesc =>
      'Perfecte elektrolyten balans 30 dagen';

  @override
  String get achievementSugarAwareness => 'Suiker Bewustzijn';

  @override
  String get achievementSugarAwarenessDesc => 'Volg suiker voor eerste keer';

  @override
  String get achievementSugarUnder25 => 'Zoete Controle';

  @override
  String get achievementSugarUnder25Desc =>
      'Houd suikerinname laag voor een dag';

  @override
  String achievementSugarUnder25Template(String weight) {
    return 'Houd suiker onder $weight voor een dag';
  }

  @override
  String get achievementSugarWeekControl => 'Suiker Discipline';

  @override
  String get achievementSugarWeekControlDesc =>
      'Houd lage suikerinname aan een week';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return 'Houd suiker onder $weight voor 7 dagen';
  }

  @override
  String get achievementSugarFreeDay => 'Suikervrij';

  @override
  String get achievementSugarFreeDayDesc =>
      'Voltooi dag met 0g toegevoegde suiker';

  @override
  String get achievementSugarDetective => 'Suiker Detective';

  @override
  String get achievementSugarDetectiveDesc => 'Volg verborgen suikers 10 keer';

  @override
  String get achievementSugarMaster => 'Suiker Master';

  @override
  String get achievementSugarMasterDesc =>
      'Houd zeer lage suikerinname aan een maand';

  @override
  String get achievementNoSodaWeek => 'Frisdrank Vrije Week';

  @override
  String get achievementNoSodaWeekDesc => 'Geen frisdrank 7 dagen';

  @override
  String get achievementNoSodaMonth => 'Frisdrank Vrije Maand';

  @override
  String get achievementNoSodaMonthDesc => 'Geen frisdrank 30 dagen';

  @override
  String get achievementSweetToothTamed => 'Zoetekauw Getemd';

  @override
  String get achievementSweetToothTamedDesc =>
      'Verminder dagelijkse suiker met 50% een week';

  @override
  String get achievementAlcoholTracker => 'Bewustzijn';

  @override
  String get achievementAlcoholTrackerDesc => 'Volg alcoholverbruik';

  @override
  String get achievementModerateDay => 'Matiging';

  @override
  String get achievementModerateDayDesc => 'Blijf onder 2 SD op een dag';

  @override
  String get achievementSoberDay => 'Nuchtere Dag';

  @override
  String get achievementSoberDayDesc => 'Voltooi alcoholvrije dag';

  @override
  String get achievementSoberWeek => 'Nuchtere Week';

  @override
  String get achievementSoberWeekDesc => '7 dagen alcoholvrij';

  @override
  String get achievementSoberMonth => 'Nuchtere Maand';

  @override
  String get achievementSoberMonthDesc => '30 dagen alcoholvrij';

  @override
  String get achievementRecoveryProtocol => 'Herstel Pro';

  @override
  String get achievementRecoveryProtocolDesc =>
      'Voltooi herstelprotocol na drinken';

  @override
  String get achievementFirstWorkout => 'Ga Bewegen';

  @override
  String get achievementFirstWorkoutDesc => 'Log je eerste training';

  @override
  String get achievementWorkoutWeek => 'Actieve Week';

  @override
  String get achievementWorkoutWeekDesc => 'Train 3 keer in een week';

  @override
  String get achievementCenturySweat => 'Century Zweet';

  @override
  String get achievementCenturySweatDesc =>
      'Verlies significant vocht door trainingen';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return 'Verlies $volume door trainingen';
  }

  @override
  String get achievementCardioKing => 'Cardio Koning';

  @override
  String get achievementCardioKingDesc => 'Voltooi 10 cardio sessies';

  @override
  String get achievementStrengthWarrior => 'Kracht Krijger';

  @override
  String get achievementStrengthWarriorDesc => 'Voltooi 10 kracht sessies';

  @override
  String get achievementHRIGreen => 'Groene Zone';

  @override
  String get achievementHRIGreenDesc => 'Houd HRI in groene zone een dag';

  @override
  String get achievementHRIWeekGreen => 'Veilige Week';

  @override
  String get achievementHRIWeekGreenDesc => 'Houd HRI in groene zone 7 dagen';

  @override
  String get achievementHRIPerfect => 'Perfecte Score';

  @override
  String get achievementHRIPerfectDesc => 'Bereik HRI onder 20';

  @override
  String get achievementHRIRecovery => 'Snel Herstel';

  @override
  String get achievementHRIRecoveryDesc =>
      'Verminder HRI van rood naar groen in één dag';

  @override
  String get achievementHRIMaster => 'HRI Master';

  @override
  String get achievementHRIMasterDesc => 'Houd HRI onder 30 voor 30 dagen';

  @override
  String get achievementStreak3 => 'Aan Beginnen';

  @override
  String get achievementStreak3Desc => '3-dagen reeks';

  @override
  String get achievementStreak7 => 'Week Krijger';

  @override
  String get achievementStreak7Desc => '7-dagen reeks';

  @override
  String get achievementStreak30 => 'Consistentie Koning';

  @override
  String get achievementStreak30Desc => '30-dagen reeks';

  @override
  String get achievementStreak100 => 'Century Club';

  @override
  String get achievementStreak100Desc => '100-dagen reeks';

  @override
  String get achievementFirstWeek => 'Eerste Week';

  @override
  String get achievementFirstWeekDesc => 'Gebruik app 7 dagen';

  @override
  String get achievementProMember => 'PRO Lid';

  @override
  String get achievementProMemberDesc => 'Word PRO abonnee';

  @override
  String get achievementDataExport => 'Data Analist';

  @override
  String get achievementDataExportDesc => 'Exporteer je data naar CSV';

  @override
  String get achievementAllCategories => 'Alleskunner';

  @override
  String get achievementAllCategoriesDesc =>
      'Ontgrendel minstens één prestatie in elke categorie';

  @override
  String get achievementHunter => 'Prestatie Jager';

  @override
  String get achievementHunterDesc => 'Ontgrendel 50% van alle prestaties';

  @override
  String get achievementDetailsUnlockedOn => 'Ontgrendeld op';

  @override
  String get achievementNewUnlocked => 'Nieuwe prestatie ontgrendeld!';

  @override
  String get achievementViewAll => 'Bekijk alle prestaties';

  @override
  String get achievementCloseNotification => 'Sluiten';

  @override
  String get before => 'voor';

  @override
  String get after => 'na';

  @override
  String get lose => 'Verlies';

  @override
  String get through => 'door';

  @override
  String get throughWorkouts => 'door trainingen';

  @override
  String get reach => 'Bereik';

  @override
  String get daysInRow => 'dagen op rij';

  @override
  String get completeHydrationGoal => 'Voltooi hydratie doel';

  @override
  String get stayUnder => 'Blijf onder';

  @override
  String get inADay => 'op een dag';

  @override
  String get alcoholFree => 'alcoholvrij';

  @override
  String get complete => 'Voltooi';

  @override
  String get achieve => 'Bereik';

  @override
  String get keep => 'Houd';

  @override
  String get for30Days => 'voor 30 dagen';

  @override
  String get liters => 'liters';

  @override
  String get completed => 'Voltooid';

  @override
  String get notCompleted => 'Niet voltooid';

  @override
  String get days => 'dagen';

  @override
  String get hours => 'uren';

  @override
  String get times => 'keer';

  @override
  String get row => 'rij';

  @override
  String get ofTotal => 'van totaal';

  @override
  String get perDay => 'per dag';

  @override
  String get perWeek => 'per week';

  @override
  String get streak => 'reeks';

  @override
  String get tapToDismiss => 'Tik om te sluiten';

  @override
  String tutorialStep1(String volume) {
    return 'Hoi! Ik help je starten met je optimale hydratie reis. Laten we de eerste slok nemen van $volume!';
  }

  @override
  String tutorialStep2(String volume) {
    return 'Uitstekend! Nu voegen we nog $volume toe om te voelen hoe het werkt.';
  }

  @override
  String get tutorialStep3 =>
      'Geweldig! Je bent klaar om HydroCoach zelfstandig te gebruiken. Ik ben hier om je te helpen perfecte hydratie te bereiken!';

  @override
  String get tutorialComplete => 'Begin met gebruiken';

  @override
  String get onboardingNotificationExamplesTitle => 'Slimme Herinneringen';

  @override
  String get onboardingNotificationExamplesSubtitle =>
      'HydroCoach weet wanneer je water nodig hebt';

  @override
  String get onboardingLocationExamplesTitle => 'Persoonlijk Advies';

  @override
  String get onboardingLocationExamplesSubtitle =>
      'We houden rekening met weer voor nauwkeurige aanbevelingen';

  @override
  String get onboardingAllowNotifications => 'Sta Meldingen Toe';

  @override
  String get onboardingAllowLocation => 'Sta Locatie Toe';

  @override
  String get foodCatalog => 'Voedsel Catalogus';

  @override
  String get todaysFoodIntake => 'Voedselinname Vandaag';

  @override
  String get noFoodToday => 'Geen voedsel gelogd vandaag';

  @override
  String foodItemsCount(int count) {
    return '$count voedsel items';
  }

  @override
  String get waterFromFood => 'Water uit voedsel';

  @override
  String get last => 'Laatste';

  @override
  String get categoryFruits => 'Fruit';

  @override
  String get categoryVegetables => 'Groenten';

  @override
  String get categorySoups => 'Soepen';

  @override
  String get categoryDairy => 'Dairy';

  @override
  String get categoryMeat => 'Vlees';

  @override
  String get categoryFastFood => 'Fast Food';

  @override
  String get weightGrams => 'Gewicht (gram)';

  @override
  String get enterWeight => 'Voer gewicht in';

  @override
  String get grams => 'g';

  @override
  String get calories => 'Calorieën';

  @override
  String get waterContent => 'Watergehalte';

  @override
  String get sugar => 'Suiker';

  @override
  String get nutritionalInfo => 'Voedingsinfo';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$calories kcal per ${weight}g';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$water ml water per ${weight}g';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${sugar}g suiker per ${weight}g';
  }

  @override
  String get addFood => 'Voedsel Toevoegen';

  @override
  String get foodAdded => 'Voedsel succesvol toegevoegd';

  @override
  String get enterValidWeight => 'Voer geldig gewicht in';

  @override
  String get proOnlyFood => 'Alleen PRO';

  @override
  String get unlockProForFood =>
      'Ontgrendel PRO voor toegang tot alle voedselitems';

  @override
  String get foodTracker => 'Voedsel Tracker';

  @override
  String get todaysFoodSummary => 'Voedsel Samenvatting Vandaag';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => 'per 100g';

  @override
  String get addToFavorites => 'Toevoegen aan favorieten';

  @override
  String get favoritesFeatureComingSoon =>
      'Favorieten functie komt binnenkort!';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food toegevoegd! +$calories kcal, +$water';
  }

  @override
  String get selectWeight => 'Selecteer Gewicht';

  @override
  String get ounces => 'oz';

  @override
  String get items => 'items';

  @override
  String get tapToAddFood => 'Tik om voedsel toe te voegen';

  @override
  String get noFoodLoggedToday => 'Geen voedsel gelogd vandaag';

  @override
  String get lightEatingDay => 'Lichte eetdag';

  @override
  String get moderateIntake => 'Matige inname';

  @override
  String get goodCalorieIntake => 'Goede calorieën inname';

  @override
  String get substantialMeals => 'Substantiële maaltijden';

  @override
  String get highCalorieDay => 'Hoge calorieën dag';

  @override
  String get veryHighIntake => 'Zeer hoge inname';

  @override
  String get caloriesTracker => 'Calorieën Tracker';

  @override
  String get trackYourDailyCalorieIntake =>
      'Volg je dagelijkse calorieën inname uit voedsel';

  @override
  String get unlockFoodTrackingFeatures =>
      'Ontgrendel voedsel tracking functies';

  @override
  String get selectFoodType => 'Selecteer voedsel type';

  @override
  String get foodApple => 'Appel';

  @override
  String get foodBanana => 'Banaan';

  @override
  String get foodOrange => 'Sinaasappel';

  @override
  String get foodWatermelon => 'Watermeloen';

  @override
  String get foodStrawberry => 'Aardbei';

  @override
  String get foodGrapes => 'Druiven';

  @override
  String get foodPineapple => 'Ananas';

  @override
  String get foodMango => 'Mango';

  @override
  String get foodPear => 'Peer';

  @override
  String get foodCarrot => 'Wortel';

  @override
  String get foodBroccoli => 'Broccoli';

  @override
  String get foodSpinach => 'Spinazie';

  @override
  String get foodTomato => 'Tomaat';

  @override
  String get foodCucumber => 'Komkommer';

  @override
  String get foodBellPepper => 'Paprika';

  @override
  String get foodLettuce => 'Sla';

  @override
  String get foodOnion => 'Ui';

  @override
  String get foodCelery => 'Selderij';

  @override
  String get foodPotato => 'Aardappel';

  @override
  String get foodChickenSoup => 'Kippensoep';

  @override
  String get foodTomatoSoup => 'Tomatensoep';

  @override
  String get foodVegetableSoup => 'Groentensoep';

  @override
  String get foodMinestrone => 'Minestrone';

  @override
  String get foodMisoSoup => 'Misosoep';

  @override
  String get foodMushroomSoup => 'Champignonsoep';

  @override
  String get foodBeefStew => 'Runderstoofpot';

  @override
  String get foodLentilSoup => 'Linzensoep';

  @override
  String get foodOnionSoup => 'Franse Uiensoep';

  @override
  String get foodMilk => 'Melk';

  @override
  String get foodYogurt => 'Griekse Yoghurt';

  @override
  String get foodCheese => 'Cheddar Kaas';

  @override
  String get foodCottageCheese => 'Hüttenkäse';

  @override
  String get foodButter => 'Boter';

  @override
  String get foodCream => 'Slagroom';

  @override
  String get foodIceCream => 'IJs';

  @override
  String get foodMozzarella => 'Mozzarella';

  @override
  String get foodParmesan => 'Parmezaan';

  @override
  String get foodChickenBreast => 'Kipfilet';

  @override
  String get foodBeef => 'Gehakt';

  @override
  String get foodSalmon => 'Zalm';

  @override
  String get foodEggs => 'Eieren';

  @override
  String get foodTuna => 'Tonijn';

  @override
  String get foodPork => 'Varkenskotelet';

  @override
  String get foodTurkey => 'Kalkoen';

  @override
  String get foodShrimp => 'Garnaal';

  @override
  String get foodBacon => 'Spek';

  @override
  String get foodBigMac => 'Big Mac';

  @override
  String get foodPizza => 'Pizza Punt';

  @override
  String get foodFrenchFries => 'Patat';

  @override
  String get foodChickenNuggets => 'Kipnuggets';

  @override
  String get foodHotDog => 'Hotdog';

  @override
  String get foodTacos => 'Taco\'s';

  @override
  String get foodSubway => 'Subway Sandwich';

  @override
  String get foodDonut => 'Donut';

  @override
  String get foodBurgerKing => 'Whopper';

  @override
  String get foodSausage => 'Worst';

  @override
  String get foodKefir => 'Kefir';

  @override
  String get foodRyazhenka => 'Ryazhenka';

  @override
  String get foodDoner => 'Döner';

  @override
  String get foodShawarma => 'Shawarma';

  @override
  String get foodBorscht => 'Borsjt';

  @override
  String get foodRamen => 'Ramen';

  @override
  String get foodCabbage => 'Kool';

  @override
  String get foodPeaSoup => 'Erwtensoep';

  @override
  String get foodSolyanka => 'Solyanka';

  @override
  String get meals => 'maaltijden';

  @override
  String get dailyProgress => 'Dagelijkse Voortgang';

  @override
  String get fromFood => 'uit voedsel';

  @override
  String get noFoodThisWeek => 'Geen voedseldata deze week';

  @override
  String get foodIntake => 'Voedselinname';

  @override
  String get foodStats => 'Voedselstatistieken';

  @override
  String get totalCalories => 'Totaal calorieën';

  @override
  String get avgCaloriesPerDay => 'Gem. per dag';

  @override
  String get daysWithFood => 'Dagen met voedsel';

  @override
  String get avgMealsPerDay => 'Maaltijden per dag';

  @override
  String get caloriesPerDay => 'Calorieën per dag';

  @override
  String get sugarPerDay => 'Suiker per dag';

  @override
  String get foodTracking => 'Voedsel Tracking';

  @override
  String get foodTrackingPro => 'Volg voedsel impact op hydratie en HRI';

  @override
  String get hydrationBalance => 'Hydratie Balans';

  @override
  String get highSodiumFood => 'Hoog natrium uit voedsel';

  @override
  String get hydratingFood => 'Uitstekende hydraterende keuzes';

  @override
  String get dryFood => 'Laag watergehalte voedsel';

  @override
  String get balancedFood => 'Gebalanceerde voeding';

  @override
  String get foodAdviceEmpty =>
      'Voeg maaltijden toe om voedsel impact op hydratie te volgen.';

  @override
  String get foodAdviceHighSodium =>
      'Hoge natriuminname gedetecteerd. Verhoog water om elektrolyten te balanceren.';

  @override
  String get foodAdviceLowWater =>
      'Je voedsel had laag watergehalte. Overweeg extra water te drinken.';

  @override
  String get foodAdviceGoodHydration => 'Geweldig! Je voedsel helpt hydratie.';

  @override
  String get foodAdviceBalanced =>
      'Goede voeding! Vergeet niet water te drinken.';

  @override
  String get richInElectrolytes => 'Rijk aan elektrolyten';

  @override
  String recommendedCalories(int calories) {
    return 'Aanbevolen calorieën: ~$calories kcal/dag';
  }

  @override
  String get proWelcomeTitle => 'Welkom bij HydraCoach PRO!';

  @override
  String get proTrialActivated => 'Je 7-dagen proef geactiveerd!';

  @override
  String get proFeaturePersonalizedRecommendations =>
      'Gepersonaliseerde aanbevelingen';

  @override
  String get proFeatureAdvancedAnalytics => 'Geavanceerde analytics';

  @override
  String get proFeatureWorkoutTracking => 'Training tracking';

  @override
  String get proFeatureElectrolyteControl => 'Elektrolyten controle';

  @override
  String get proFeatureSmartReminders => 'Slimme herinneringen';

  @override
  String get proFeatureHriIndex => 'HRI index';

  @override
  String get proFeatureAchievements => 'PRO prestaties';

  @override
  String get proFeaturePersonalizedDescription => 'Individueel hydratie advies';

  @override
  String get proFeatureAdvancedDescription =>
      'Gedetailleerde grafieken en statistieken';

  @override
  String get proFeatureWorkoutDescription =>
      'Vochtverlies tracking tijdens sport';

  @override
  String get proFeatureElectrolyteDescription =>
      'Natrium, kalium, magnesium monitoring';

  @override
  String get proFeatureSmartDescription => 'Gepersonaliseerde meldingen';

  @override
  String get proFeatureNoMoreAds => 'Geen advertenties meer!';

  @override
  String get proFeatureNoMoreAdsDescription =>
      'Geniet van ononderbroken hydratie tracking zonder advertenties';

  @override
  String get proFeatureHriDescription => 'Real-time hydratie risicoindex';

  @override
  String get proFeatureAchievementsDescription =>
      'Exclusieve beloningen en doelen';

  @override
  String get startUsing => 'Begin met gebruiken';

  @override
  String get sayGoodbyeToAds => 'Zeg vaarwel tegen advertenties. Ga Premium.';

  @override
  String get goPremium => 'GA PREMIUM';

  @override
  String get removeAdsForever => 'Verwijder advertenties voor altijd';

  @override
  String get upgrade => 'UPGRADE';

  @override
  String get support => 'Ondersteuning';

  @override
  String get companyWebsite => 'Bedrijfswebsite';

  @override
  String get appStoreOpened => 'App Store geopend';

  @override
  String get linkCopiedToClipboard => 'Link gekopieerd naar klembord';

  @override
  String get shareDialogOpened => 'Deel dialoog geopend';

  @override
  String get linkForSharingCopied => 'Link voor delen gekopieerd';

  @override
  String get websiteOpenedInBrowser => 'Website geopend in browser';

  @override
  String get emailClientOpened => 'E-mailclient geopend';

  @override
  String get emailCopiedToClipboard => 'E-mail gekopieerd naar klembord';

  @override
  String get privacyPolicyOpened => 'Privacybeleid geopend';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Statistieken tot $dateString';
  }

  @override
  String get monthlyInsights => 'Maandelijkse Inzichten';

  @override
  String get average => 'Gemiddeld';

  @override
  String get daysOver => 'Dagen over';

  @override
  String get maximum => 'Maximum';

  @override
  String get balance => 'Balans';

  @override
  String get allNormal => 'Alles normaal';

  @override
  String get excellentConsistency => 'Uitstekende consistentie';

  @override
  String get goodResults => 'Goede resultaten';

  @override
  String get positiveImprovement => 'Positieve verbetering';

  @override
  String get physicalActivity => 'Fysieke activiteit';

  @override
  String get coffeeConsumption => 'Koffieverbruik';

  @override
  String get excellentSobriety => 'Uitstekende nuchterheid';

  @override
  String get excellentMonth => 'Uitstekende maand';

  @override
  String get keepGoingMotivation => 'Ga zo door!';

  @override
  String get daysNormal => 'dagen normaal';

  @override
  String get electrolyteBalance => 'Elektrolyten balans heeft aandacht nodig';

  @override
  String get caffeineWarning => 'Dagen met overdosis van veilige dosis (400mg)';

  @override
  String get sugarFrequentExcess =>
      'Frequent teveel suiker beïnvloedt hydratie';

  @override
  String get averagePerDayShort => 'per dag';

  @override
  String get highWarning => 'Hoog';

  @override
  String get normalStatus => 'Normaal';

  @override
  String improvementToEnd(int percent) {
    return 'Verbetering richting einde maand met $percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent% dagen met trainingen (${hours}u)';
  }

  @override
  String coffeeAverage(String avg) {
    return 'Gemiddeld $avg kopjes/dag';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent% dagen zonder alcohol';
  }

  @override
  String get daySummary => 'Dag Samenvatting';

  @override
  String get records => 'Records';

  @override
  String waterGoalAchievement(int percent) {
    return 'Water doel bereikt: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return 'Trainingen: $count sessies';
  }

  @override
  String get index => 'Index';

  @override
  String get status => 'Status';

  @override
  String get moderateRisk => 'Matig risico';

  @override
  String get excess => 'Overschot';

  @override
  String get whoLimit => 'WHO limiet: 50g/dag';

  @override
  String stability(int percent) {
    return 'Stabiliteit in $percent% van dagen';
  }

  @override
  String goodHydration(int percent) {
    return '$percent% dagen met goede hydratie';
  }

  @override
  String daysInNorm(int count) {
    return '$count dagen in norm';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent% dagen met goede hydratie';
  }

  @override
  String stabilityDays(int percent) {
    return 'Stabiliteit in $percent% van dagen';
  }

  @override
  String monthEndImprovement(int percent) {
    return 'Einde-maand verbetering met $percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent% dagen met trainingen (${hours}u)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return 'Gemiddeld $avgCups kopjes/dag';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent% dagen zonder alcohol';
  }

  @override
  String get moderateRiskStatus => 'Status: Matig risico';

  @override
  String get high => 'Hoog';

  @override
  String get whoLimitPerDay => 'WHO limiet: 50g/dag';
}
