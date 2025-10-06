// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'HydroCoach';

  @override
  String get getPro => 'PRO holen';

  @override
  String get sunday => 'Sonntag';

  @override
  String get monday => 'Montag';

  @override
  String get tuesday => 'Dienstag';

  @override
  String get wednesday => 'Mittwoch';

  @override
  String get thursday => 'Donnerstag';

  @override
  String get friday => 'Freitag';

  @override
  String get saturday => 'Samstag';

  @override
  String get january => 'Januar';

  @override
  String get february => 'Februar';

  @override
  String get march => 'März';

  @override
  String get april => 'April';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Juli';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'Oktober';

  @override
  String get november => 'November';

  @override
  String get december => 'Dezember';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day. $month';
  }

  @override
  String get loading => 'Lädt...';

  @override
  String get loadingWeather => 'Wetter wird geladen...';

  @override
  String get heatIndex => 'Hitzeindex';

  @override
  String humidity(int value) {
    return 'Luftfeuchtigkeit';
  }

  @override
  String get water => 'Wasser';

  @override
  String get liquids => 'Getränke';

  @override
  String get sodium => 'Natrium';

  @override
  String get potassium => 'Kalium';

  @override
  String get magnesium => 'Magnesium';

  @override
  String get electrolyte => 'Elektrolyte';

  @override
  String get broth => 'Brühe';

  @override
  String get coffee => 'Kaffee';

  @override
  String get alcohol => 'Alkohol';

  @override
  String get drink => 'Getränk';

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
    return 'Hitze +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'Alkohol +$amount ml';
  }

  @override
  String get smartAdviceTitle => 'Tipp für jetzt';

  @override
  String get smartAdviceDefault =>
      'Wasser- und Elektrolytbalance aufrechterhalten.';

  @override
  String get adviceOverhydrationSevere => 'Wasserüberladung (>200% Ziel)';

  @override
  String get adviceOverhydrationSevereBody =>
      '60-90 Min. pausieren. Elektrolyte hinzufügen: 300-500 ml mit 500-1000 mg Natrium.';

  @override
  String get adviceOverhydration => 'Überhydratation';

  @override
  String get adviceOverhydrationBody =>
      '30-60 Min. kein Wasser und ~500 mg Natrium (Elektrolyte/Brühe) hinzufügen.';

  @override
  String get adviceAlcoholRecovery => 'Alkohol: Erholung';

  @override
  String get adviceAlcoholRecoveryBody =>
      'Heute kein Alkohol mehr. 300-500 ml Wasser in kleinen Portionen trinken und Natrium hinzufügen.';

  @override
  String get adviceLowSodium => 'Niedriger Natriumspiegel';

  @override
  String adviceLowSodiumBody(int amount) {
    return '~$amount mg Natrium hinzufügen. Mäßig trinken.';
  }

  @override
  String get adviceDehydration => 'Unterhydriert';

  @override
  String adviceDehydrationBody(String type) {
    return '300-500 ml $type trinken.';
  }

  @override
  String get adviceHighRisk => 'Hohes Risiko (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Dringend Wasser mit Elektrolyten (300-500 ml) trinken und Aktivität reduzieren.';

  @override
  String get adviceHeat => 'Hitze und Verluste';

  @override
  String get adviceHeatBody =>
      'Wasser um +5-8% erhöhen und 300-500 mg Natrium hinzufügen.';

  @override
  String get adviceAllGood => 'Alles auf Kurs';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Tempo halten. Ziel: ~$amount ml bis zum Ziel.';
  }

  @override
  String get hydrationStatus => 'Hydratationsstatus';

  @override
  String get hydrationStatusNormal => 'Normal';

  @override
  String get hydrationStatusDiluted => 'Verdünnung';

  @override
  String get hydrationStatusDehydrated => 'Unterhydriert';

  @override
  String get hydrationStatusLowSalt => 'Niedriger Salzgehalt';

  @override
  String get hydrationRiskIndex => 'Hydratationsrisikoindex';

  @override
  String get quickAdd => 'Schnell hinzufügen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get delete => 'Löschen';

  @override
  String get todaysDrinks => 'Heutige Getränke';

  @override
  String get allRecords => 'Alle Einträge →';

  @override
  String itemDeleted(String item) {
    return '$item gelöscht';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get dailyReportReady => 'Tagesbericht bereit!';

  @override
  String get viewDayResults => 'Tagesergebnisse anzeigen';

  @override
  String get dailyReportComingSoon =>
      'Tagesbericht wird in der nächsten Version verfügbar sein';

  @override
  String get home => 'Start';

  @override
  String get history => 'Verlauf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get languageSection => 'Sprache';

  @override
  String get languageSettings => 'Sprache';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get profileSection => 'Profil';

  @override
  String get weight => 'Gewicht';

  @override
  String get dietMode => 'Diätmodus';

  @override
  String get activityLevel => 'Aktivitätsniveau';

  @override
  String get changeWeight => 'Gewicht ändern';

  @override
  String get dietModeNormal => 'Normale Ernährung';

  @override
  String get dietModeKeto => 'Keto / Low-Carb';

  @override
  String get dietModeFasting => 'Intervallfasten';

  @override
  String get activityLow => 'Niedrige Aktivität';

  @override
  String get activityMedium => 'Mittlere Aktivität';

  @override
  String get activityHigh => 'Hohe Aktivität';

  @override
  String get activityLowDesc => 'Büroarbeit, wenig Bewegung';

  @override
  String get activityMediumDesc => '30-60 Min. Training pro Tag';

  @override
  String get activityHighDesc => 'Training >1 Stunde';

  @override
  String get notificationsSection => 'Benachrichtigungen';

  @override
  String get notificationLimit => 'Benachrichtigungslimit (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Verwendet: $used von $limit';
  }

  @override
  String get waterReminders => 'Wasser-Erinnerungen';

  @override
  String get waterRemindersDesc => 'Regelmäßige Erinnerungen über den Tag';

  @override
  String get reminderFrequency => 'Erinnerungshäufigkeit';

  @override
  String timesPerDay(int count) {
    return '$count Mal pro Tag';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count Mal pro Tag (max 4)';
  }

  @override
  String get unlimitedReminders => 'Unbegrenzt';

  @override
  String get startOfDay => 'Tagesbeginn';

  @override
  String get endOfDay => 'Tagesende';

  @override
  String get postCoffeeReminders => 'Nach-Kaffee-Erinnerungen';

  @override
  String get postCoffeeRemindersDesc => 'Nach 20 Minuten an Wasser erinnern';

  @override
  String get heatWarnings => 'Hitzewarnungen';

  @override
  String get heatWarningsDesc => 'Benachrichtigungen bei hohen Temperaturen';

  @override
  String get postAlcoholReminders => 'Nach-Alkohol-Erinnerungen';

  @override
  String get postAlcoholRemindersDesc => 'Erholungsplan für 6-12 Stunden';

  @override
  String get proFeaturesSection => 'PRO-Funktionen';

  @override
  String get unlockPro => 'PRO freischalten';

  @override
  String get unlockProDesc =>
      'Unbegrenzte Benachrichtigungen und intelligente Erinnerungen';

  @override
  String get noNotificationLimit => 'Kein Benachrichtigungslimit';

  @override
  String get unitsSection => 'Einheiten';

  @override
  String get metricSystem => 'Metrisches System';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Imperiales System';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => 'Über';

  @override
  String get version => 'Version';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get share => 'Teilen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get resetAllData => 'Alle Daten zurücksetzen';

  @override
  String get resetDataTitle => 'Alle Daten zurücksetzen?';

  @override
  String get resetDataMessage =>
      'Dies löscht den gesamten Verlauf und setzt Einstellungen auf Standardwerte zurück.';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get start => 'Start';

  @override
  String get welcomeTitle => 'Willkommen bei\nHydroCoach';

  @override
  String get welcomeSubtitle =>
      'Intelligente Wasser- und Elektrolyt-Verfolgung\nfür Keto, Fasten und aktives Leben';

  @override
  String get weightPageTitle => 'Dein Gewicht';

  @override
  String get weightPageSubtitle => 'Zur Berechnung der optimalen Wassermenge';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Empfohlene Norm: $min-$max ml Wasser pro Tag';
  }

  @override
  String get dietPageTitle => 'Diätmodus';

  @override
  String get dietPageSubtitle => 'Dies beeinflusst den Elektrolytbedarf';

  @override
  String get normalDiet => 'Normale Ernährung';

  @override
  String get normalDietDesc => 'Standardempfehlungen';

  @override
  String get ketoDiet => 'Keto / Low-Carb';

  @override
  String get ketoDietDesc => 'Erhöhter Salzbedarf';

  @override
  String get fastingDiet => 'Intervallfasten';

  @override
  String get fastingDietDesc => 'Spezielles Elektrolytregime';

  @override
  String get fastingSchedule => 'Fastenplan:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Täglich 8-Stunden-Fenster';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Eine Mahlzeit pro Tag';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Alternierendes Fasten';

  @override
  String get activityPageTitle => 'Aktivitätsniveau';

  @override
  String get activityPageSubtitle => 'Beeinflusst den Wasserbedarf';

  @override
  String get lowActivity => 'Niedrige Aktivität';

  @override
  String get lowActivityDesc => 'Büroarbeit, wenig Bewegung';

  @override
  String get lowActivityWater => '+0 ml Wasser';

  @override
  String get mediumActivity => 'Mittlere Aktivität';

  @override
  String get mediumActivityDesc => '30-60 Minuten Training pro Tag';

  @override
  String get mediumActivityWater => '+350-700 ml Wasser';

  @override
  String get highActivity => 'Hohe Aktivität';

  @override
  String get highActivityDesc => 'Training >1 Stunde oder körperliche Arbeit';

  @override
  String get highActivityWater => '+700-1200 ml Wasser';

  @override
  String get activityAdjustmentNote =>
      'Wir passen Ziele basierend auf deinen Workouts an';

  @override
  String get day => 'Tag';

  @override
  String get week => 'Woche';

  @override
  String get month => 'Monat';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get noData => 'Keine Daten';

  @override
  String get noRecordsToday => 'Noch keine Einträge für heute';

  @override
  String get noRecordsThisDay => 'Keine Einträge für diesen Tag';

  @override
  String get loadingData => 'Daten werden geladen...';

  @override
  String get deleteRecord => 'Eintrag löschen?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '$type $volume ml löschen?';
  }

  @override
  String get recordDeleted => 'Eintrag gelöscht';

  @override
  String get waterConsumption => '💧 Wasserkonsum';

  @override
  String get alcoholWeek => '🍺 Alkohol diese Woche';

  @override
  String get electrolytes => '⚡ Elektrolyte';

  @override
  String get weeklyAverages => '📊 Wochendurchschnitte';

  @override
  String get monthStatistics => '📊 Monatsstatistiken';

  @override
  String get alcoholStatistics => '🍺 Alkoholstatistiken';

  @override
  String get alcoholStatisticsTitle => 'Alkoholstatistiken';

  @override
  String get weeklyInsights => '💡 Wöchentliche Einblicke';

  @override
  String get waterPerDay => 'Wasser pro Tag';

  @override
  String get sodiumPerDay => 'Natrium pro Tag';

  @override
  String get potassiumPerDay => 'Kalium pro Tag';

  @override
  String get magnesiumPerDay => 'Magnesium pro Tag';

  @override
  String get goal => 'Ziel';

  @override
  String get daysWithGoalAchieved => '✅ Tage mit erreichtem Ziel';

  @override
  String get recordsPerDay => '📝 Einträge pro Tag';

  @override
  String get insufficientDataForAnalysis => 'Unzureichende Daten für Analyse';

  @override
  String get totalVolume => 'Gesamtvolumen';

  @override
  String averagePerDay(int amount) {
    return 'Durchschnitt $amount ml/Tag';
  }

  @override
  String get activeDays => 'Aktive Tage';

  @override
  String perfectDays(int count) {
    return 'Tage mit perfektem Ziel: $count';
  }

  @override
  String currentStreak(int days) {
    return 'Aktuelle Serie: $days Tage';
  }

  @override
  String soberDaysRow(int days) {
    return 'Nüchterne Tage hintereinander: $days';
  }

  @override
  String get keepItUp => 'Weiter so!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Wasser: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Alkohol: $amount SD';
  }

  @override
  String get totalSD => 'Gesamt SD';

  @override
  String get forMonth => 'Für Monat';

  @override
  String get daysWithAlcohol => 'Tage mit Alkohol';

  @override
  String fromDays(int days) {
    return 'von $days';
  }

  @override
  String get soberDays => 'Nüchterne Tage';

  @override
  String get excellent => 'ausgezeichnet!';

  @override
  String get averageSD => 'Durchschnitt SD';

  @override
  String get inDrinkingDays => 'an Trinktagen';

  @override
  String get bestDay => '🏆 Bester Tag';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% des Ziels';
  }

  @override
  String get weekends => '📅 Wochenenden';

  @override
  String get weekdays => '📅 Wochentage';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'Du trinkst $percent% weniger am Wochenende';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'Du trinkst $percent% weniger an Wochentagen';
  }

  @override
  String get positiveTrend => '📈 Positiver Trend';

  @override
  String get positiveTrendMessage =>
      'Deine Hydration verbessert sich zum Wochenende';

  @override
  String get decliningActivity => '📉 Abnehmende Aktivität';

  @override
  String get decliningActivityMessage => 'Wasserkonsum nimmt zum Wochenende ab';

  @override
  String get lowSalt => '⚠️ Wenig Salz';

  @override
  String lowSaltMessage(int days) {
    return 'Nur $days Tage mit normalen Natriumwerten';
  }

  @override
  String get frequentAlcohol => '🍺 Häufiger Konsum';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Alkohol an $days von 7 Tagen beeinflusst Hydration';
  }

  @override
  String get excellentWeek => '✅ Ausgezeichnete Woche';

  @override
  String get continueMessage => 'Weiter so!';

  @override
  String get all => 'Alle';

  @override
  String get addAlcohol => 'Alkohol hinzufügen';

  @override
  String get minimumHarm => 'Minimaler Schaden';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml Wasser benötigt';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg Natrium hinzufügen';
  }

  @override
  String get goToBedEarly => 'Früh schlafen gehen';

  @override
  String get todayConsumed => 'Heute konsumiert:';

  @override
  String get alcoholToday => 'Alkohol heute';

  @override
  String get beer => 'Bier';

  @override
  String get wine => 'Wein';

  @override
  String get spirits => 'Spirituosen';

  @override
  String get cocktail => 'Cocktail';

  @override
  String get selectDrinkType => 'Getränkeart wählen:';

  @override
  String get volume => 'Volumen';

  @override
  String get enterVolume => 'Volumen in ml eingeben';

  @override
  String get strength => 'Kraft';

  @override
  String get standardDrinks => 'Standard-Getränke:';

  @override
  String get additionalWater => 'Zusätzl. Wasser';

  @override
  String get additionalSodium => 'Zusätzl. Natrium';

  @override
  String get hriRisk => 'HRI-Risiko';

  @override
  String get enterValidVolume => 'Bitte gültiges Volumen eingeben';

  @override
  String get weeklyHistory => 'Wochenverlauf';

  @override
  String get weeklyHistoryDesc =>
      'Analysiere Wochentrends, erhalte Einblicke und Empfehlungen';

  @override
  String get monthlyHistory => 'Monatsverlauf';

  @override
  String get monthlyHistoryDesc =>
      'Langzeitmuster, Wochenvergleiche und detaillierte Analysen';

  @override
  String get proFunction => 'PRO-Funktion';

  @override
  String get unlockProHistory => 'PRO freischalten';

  @override
  String get unlimitedHistory => 'Unbegrenzter Verlauf';

  @override
  String get dataExportCSV => 'Daten als CSV exportieren';

  @override
  String get detailedAnalytics => 'Detaillierte Analysen';

  @override
  String get periodComparison => 'Periodenvergleich';

  @override
  String get shareResult => 'Ergebnis teilen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get welcomeToPro => 'Willkommen bei PRO!';

  @override
  String get allFeaturesUnlocked => 'Alle Funktionen freigeschaltet';

  @override
  String get testMode => 'Testmodus: Mock-Kauf verwendet';

  @override
  String get proStatusNote => 'PRO-Status bleibt bis App-Neustart';

  @override
  String get startUsingPro => 'PRO nutzen';

  @override
  String get lifetimeAccess => 'Lebenslanger Zugang';

  @override
  String get bestValueAnnual => 'Bestes Angebot — Jährlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get oneTime => 'einmalig';

  @override
  String get perYear => '/Jahr';

  @override
  String get perMonth => '/Monat';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/Mon.';
  }

  @override
  String get startFreeTrial => '7-Tage-Testversion starten';

  @override
  String continueWithPrice(String price) {
    return 'Weiter — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Für $price freischalten (einmalig)';
  }

  @override
  String get enableFreeTrial => '7-Tage-Testversion aktivieren';

  @override
  String get noChargeToday =>
      'Heute keine Gebühr. Nach 7 Tagen verlängert sich das Abo automatisch, wenn nicht gekündigt.';

  @override
  String get cancelAnytime =>
      'Du kannst jederzeit in den Einstellungen kündigen.';

  @override
  String get everythingInPro => 'Alles in PRO';

  @override
  String get smartReminders => 'Intelligente Erinnerungen';

  @override
  String get smartRemindersDesc => 'Hitze, Workouts, Fasten — kein Spam.';

  @override
  String get weeklyReports => 'Wöchentliche Berichte';

  @override
  String get weeklyReportsDesc => 'Tiefe Einblicke + CSV-Export.';

  @override
  String get healthIntegrations => 'Gesundheitsintegrationen';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit.';

  @override
  String get alcoholProtocols => 'Alkoholprotokolle';

  @override
  String get alcoholProtocolsDesc => 'Vor-Trink-Vorbereitung & Erholungsplan.';

  @override
  String get fullSync => 'Vollständige Synchronisation';

  @override
  String get fullSyncDesc => 'Unbegrenzter Verlauf auf allen Geräten.';

  @override
  String get personalCalibrations => 'Persönliche Kalibrierungen';

  @override
  String get personalCalibrationsDesc => 'Schweißtest, Urinfarben-Skala.';

  @override
  String get showAllFeatures => 'Alle Funktionen anzeigen';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get proSubscriptionRestored => 'PRO-Abo wiederhergestellt!';

  @override
  String get noPurchasesToRestore =>
      'Keine Käufe zum Wiederherstellen gefunden';

  @override
  String get drinkMoreWaterToday => 'Heute mehr Wasser trinken (+20%)';

  @override
  String get addElectrolytesToWater =>
      'Bei jeder Wasseraufnahme Elektrolyte hinzufügen';

  @override
  String get limitCoffeeOneCup => 'Kaffee auf eine Tasse begrenzen';

  @override
  String get increaseWater10 => 'Wasser um 10% erhöhen';

  @override
  String get dontForgetElectrolytes => 'Elektrolyte nicht vergessen';

  @override
  String get startDayWithWater => 'Tag mit einem Glas Wasser beginnen';

  @override
  String get dontForgetElectrolytesReminder => '⚡ Elektrolyte nicht vergessen';

  @override
  String get startDayWithWaterReminder =>
      'Beginne deinen Tag mit einem Glas Wasser für gutes Wohlbefinden';

  @override
  String get takeElectrolytesMorning => 'Morgens Elektrolyte nehmen';

  @override
  String purchaseFailed(String error) {
    return 'Kauf fehlgeschlagen: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — von 12.000 Nutzern vertraut';

  @override
  String get bestValue => 'Bestes Angebot';

  @override
  String percentOff(int percent) {
    return '-$percent% Bestes Angebot';
  }

  @override
  String get weatherUnavailable => 'Wetter nicht verfügbar';

  @override
  String get checkLocationPermissions =>
      'Standortberechtigungen und Internet prüfen';

  @override
  String get recommendedNormLabel => 'Empfohlene Norm';

  @override
  String get waterAdjustment300 => '+300 ml';

  @override
  String get waterAdjustment400 => '+400 ml';

  @override
  String get waterAdjustment200 => '+200 ml';

  @override
  String get waterAdjustmentNormal => 'Normal';

  @override
  String get waterAdjustment500 => '+500 ml';

  @override
  String get waterAdjustment250 => '+250 ml';

  @override
  String get waterAdjustment750 => '+750 ml';

  @override
  String get currentLocation => 'Aktueller Standort';

  @override
  String get weatherClear => 'klar';

  @override
  String get weatherCloudy => 'bewölkt';

  @override
  String get weatherOvercast => 'bedeckt';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherSnow => 'Schnee';

  @override
  String get weatherStorm => 'Sturm';

  @override
  String get weatherFog => 'Nebel';

  @override
  String get weatherDrizzle => 'Nieselregen';

  @override
  String get weatherSunny => 'sonnig';

  @override
  String get heatWarningExtreme => '☀️ Extreme Hitze! Maximale Hydration';

  @override
  String get heatWarningVeryHot => '🌡️ Sehr heiß! Dehydrierungsrisiko';

  @override
  String get heatWarningHot => '🔥 Heiß! Mehr Wasser trinken';

  @override
  String get heatWarningElevated => '⚠️ Erhöhte Temperatur';

  @override
  String get heatWarningComfortable => 'Angenehme Temperatur';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% Wasser';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg Natrium';
  }

  @override
  String get heatWarningCold =>
      '❄️ Kalt! Aufwärmen und warme Flüssigkeiten trinken';

  @override
  String get notificationChannelName => 'HydroCoach Erinnerungen';

  @override
  String get notificationChannelDescription =>
      'Wasser- und Elektrolyt-Erinnerungen';

  @override
  String get urgentNotificationChannelName => 'Dringende Erinnerungen';

  @override
  String get urgentNotificationChannelDescription =>
      'Wichtige Hydrations-Benachrichtigungen';

  @override
  String get goodMorning => '☀️ Guten Morgen!';

  @override
  String get timeToHydrate => '💧 Zeit zu hydratisieren';

  @override
  String get eveningHydration => '💧 Abend-Hydration';

  @override
  String get dailyReportTitle => ' Tagesbericht bereit';

  @override
  String get dailyReportBody => 'Sieh, wie dein Hydrationstag verlaufen ist';

  @override
  String get maintainWaterBalance =>
      'Wasserbalance über den Tag aufrechterhalten';

  @override
  String get electrolytesTime => 'Zeit für Elektrolyte: Prise Salz zum Wasser';

  @override
  String catchUpHydration(int percent) {
    return 'Du hast nur $percent% der Tagesnorm getrunken. Zeit aufzuholen!';
  }

  @override
  String get excellentProgress =>
      'Hervorragender Fortschritt! Noch ein bisschen bis zum Ziel';

  @override
  String get postCoffeeTitle => ' Nach Kaffee';

  @override
  String get postCoffeeBody =>
      '250-300 ml Wasser trinken, um Balance wiederherzustellen';

  @override
  String get postWorkoutTitle => ' Nach Workout';

  @override
  String get postWorkoutBody =>
      'Elektrolyte auffüllen: 500 ml Wasser + Prise Salz';

  @override
  String get heatWarningPro => '🌡️ PRO Hitzewarnung';

  @override
  String get extremeHeatWarning =>
      'Extreme Hitze! Wasserkonsum um 15% erhöhen und 1g Salz hinzufügen';

  @override
  String get hotWeatherWarning =>
      'Heiß! 10% mehr Wasser trinken und Elektrolyte nicht vergessen';

  @override
  String get warmWeatherWarning => 'Warmes Wetter. Hydration überwachen';

  @override
  String get alcoholRecoveryTitle => '🍺 Erholungszeit';

  @override
  String get alcoholRecoveryBody =>
      '300 ml Wasser mit Prise Salz für Balance trinken';

  @override
  String get continueHydration => '💧 Hydration fortsetzen';

  @override
  String get alcoholRecoveryBody2 =>
      'Weitere 500 ml Wasser helfen dir schneller zu erholen';

  @override
  String get morningRecoveryTitle => '☀️ Morgen-Erholung';

  @override
  String get morningRecoveryBody =>
      'Tag mit 500 ml Wasser und Elektrolyten beginnen';

  @override
  String get testNotificationTitle => '🧪 Test-Benachrichtigung';

  @override
  String get testNotificationBody =>
      'Wenn du das siehst - sofortige Benachrichtigungen funktionieren!';

  @override
  String get scheduledTestTitle => '⏰ Geplanter Test (1 Min.)';

  @override
  String get scheduledTestBody =>
      'Diese Benachrichtigung wurde vor 1 Minute geplant. Planung funktioniert!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService initialisiert';

  @override
  String get localNotificationsInitialized =>
      '✅ Lokale Benachrichtigungen initialisiert';

  @override
  String get androidChannelsCreated =>
      '📢 Android-Benachrichtigungskanäle erstellt';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Benachrichtigungsberechtigung: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Exakte Alarm-Berechtigung: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM-Berechtigungen: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM-Token empfangen';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCM-Token in Firestore für Nutzer $userId gespeichert';
  }

  @override
  String get topicSubscriptionComplete => '✅ Themen-Abonnement abgeschlossen';

  @override
  String foregroundMessage(String title) {
    return '📨 Vordergrund-Nachricht: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Benachrichtigung geöffnet: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Tägliches Benachrichtigungslimit erreicht (4/Tag für FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Benachrichtigungs-Planungsfehler: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Benachrichtigung wird sofort als Fallback angezeigt';

  @override
  String instantNotificationShown(String title) {
    return '📬 Sofortbenachrichtigung angezeigt: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 Plane intelligente Erinnerungen...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ $count Erinnerungen geplant';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: Nach-Kaffee-Erinnerung geplant';

  @override
  String get postWorkoutScheduled => '💪 Nach-Workout-Erinnerung geplant';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Hitzewarnung gesendet';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO: Alkohol-Erholungsplan geplant';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Abendbericht geplant für $day.$month um 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Benachrichtigung $id abgebrochen';
  }

  @override
  String get allNotificationsCancelled =>
      '🗑️ Alle Benachrichtigungen abgebrochen';

  @override
  String get reminderSettingsSaved => '✅ Erinnerungseinstellungen gespeichert';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Test-Benachrichtigung geplant für $time';
  }

  @override
  String get tomorrowRecommendations => 'Empfehlungen für morgen';

  @override
  String get recommendationExcellent =>
      'Hervorragende Arbeit! Weiter so. Versuche, den Tag mit einem Glas Wasser zu beginnen und gleichmäßig zu trinken.';

  @override
  String get recommendationDiluted =>
      'Du trinkst viel Wasser aber wenig Elektrolyte. Morgen mehr Salz oder ein Elektrolytgetränk. Versuche den Tag mit salziger Brühe zu beginnen.';

  @override
  String get recommendationDehydrated =>
      'Heute nicht genug Wasser. Morgen alle 2 Stunden Erinnerungen setzen. Wasserflasche in Sicht halten.';

  @override
  String get recommendationLowSalt =>
      'Niedrige Natriumwerte können Müdigkeit verursachen. Prise Salz zum Wasser oder Brühe trinken. Besonders wichtig bei Keto oder Fasten.';

  @override
  String get recommendationGeneral =>
      'Strebe Balance zwischen Wasser und Elektrolyten an. Trinke gleichmäßig über den Tag und vergiss Salz bei Hitze nicht.';

  @override
  String get category_water => 'Wasser';

  @override
  String get category_hot_drinks => 'Heiße Getränke';

  @override
  String get category_juice => 'Säfte';

  @override
  String get category_sports => 'Sport';

  @override
  String get category_dairy => 'Milchprodukte';

  @override
  String get category_alcohol => 'Alkohol';

  @override
  String get category_supplements => 'Nahrungsergänzung';

  @override
  String get category_other => 'Sonstiges';

  @override
  String get drink_water => 'Wasser';

  @override
  String get drink_sparkling_water => 'Sprudelwasser';

  @override
  String get drink_mineral_water => 'Mineralwasser';

  @override
  String get drink_coconut_water => 'Kokoswasser';

  @override
  String get drink_coffee => 'Kaffee';

  @override
  String get drink_espresso => 'Espresso';

  @override
  String get drink_americano => 'Americano';

  @override
  String get drink_cappuccino => 'Cappuccino';

  @override
  String get drink_latte => 'Latte';

  @override
  String get drink_black_tea => 'Schwarztee';

  @override
  String get drink_green_tea => 'Grüntee';

  @override
  String get drink_herbal_tea => 'Kräutertee';

  @override
  String get drink_matcha => 'Matcha';

  @override
  String get drink_hot_chocolate => 'Heiße Schokolade';

  @override
  String get drink_orange_juice => 'Orangensaft';

  @override
  String get drink_apple_juice => 'Apfelsaft';

  @override
  String get drink_grapefruit_juice => 'Grapefruitsaft';

  @override
  String get drink_tomato_juice => 'Tomatensaft';

  @override
  String get drink_vegetable_juice => 'Gemüsesaft';

  @override
  String get drink_smoothie => 'Smoothie';

  @override
  String get drink_lemonade => 'Limonade';

  @override
  String get drink_isotonic => 'Isotonisches Getränk';

  @override
  String get drink_electrolyte => 'Elektrolytgetränk';

  @override
  String get drink_protein_shake => 'Protein-Shake';

  @override
  String get drink_bcaa => 'BCAA-Getränk';

  @override
  String get drink_energy => 'Energy-Drink';

  @override
  String get drink_milk => 'Milch';

  @override
  String get drink_kefir => 'Kefir';

  @override
  String get drink_yogurt => 'Joghurt-Getränk';

  @override
  String get drink_almond_milk => 'Mandelmilch';

  @override
  String get drink_soy_milk => 'Sojamilch';

  @override
  String get drink_oat_milk => 'Hafermilch';

  @override
  String get drink_beer_light => 'Helles Bier';

  @override
  String get drink_beer_regular => 'Normales Bier';

  @override
  String get drink_beer_strong => 'Starkes Bier';

  @override
  String get drink_wine_red => 'Rotwein';

  @override
  String get drink_wine_white => 'Weißwein';

  @override
  String get drink_champagne => 'Champagner';

  @override
  String get drink_vodka => 'Wodka';

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
  String get drink_kvass => 'Kwas';

  @override
  String get drink_bone_broth => 'Knochenbrühe';

  @override
  String get drink_vegetable_broth => 'Gemüsebrühe';

  @override
  String get drink_soda => 'Limo';

  @override
  String get drink_diet_soda => 'Diät-Limo';

  @override
  String get addedToFavorites => 'Zu Favoriten hinzugefügt';

  @override
  String get favoriteLimitReached =>
      'Favoriten-Limit erreicht (3 für FREE, 20 für PRO)';

  @override
  String get addFavorite => 'Favorit hinzufügen';

  @override
  String get hotAndSupplements => 'Heiß & Nahrungsergänzung';

  @override
  String get quickVolumes => 'Schnelle Volumen:';

  @override
  String get type => 'Typ:';

  @override
  String get regular => 'Normal';

  @override
  String get coconut => 'Kokosnuss';

  @override
  String get sparkling => 'Sprudel';

  @override
  String get mineral => 'Mineral';

  @override
  String get hotDrinks => 'Heiße Getränke';

  @override
  String get supplements => 'Nahrungsergänzung';

  @override
  String get tea => 'Tee';

  @override
  String get salt => 'Salz (1/4 TL)';

  @override
  String get electrolyteMix => 'Elektrolyt-Mix';

  @override
  String get boneBroth => 'Knochenbrühe';

  @override
  String get favoriteAssignmentComingSoon => 'Favoriten-Zuweisung kommt bald';

  @override
  String get longPressToEditComingSoon =>
      'Langes Drücken zum Bearbeiten - kommt bald';

  @override
  String get proSubscriptionRequired => 'PRO-Abo erforderlich';

  @override
  String get saveToFavorites => 'Zu Favoriten speichern';

  @override
  String get savedToFavorites => 'Zu Favoriten gespeichert';

  @override
  String get selectFavoriteSlot => 'Favoriten-Slot wählen';

  @override
  String get slot => 'Slot';

  @override
  String get emptySlot => 'Leerer Slot';

  @override
  String get upgradeToUnlock => 'Auf PRO upgraden zum Freischalten';

  @override
  String get changeFavorite => 'Favorit ändern';

  @override
  String get removeFavorite => 'Favorit entfernen';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'Mineralwasser';

  @override
  String get coconutWater => 'Kokoswasser';

  @override
  String get lemonWater => 'Zitronenwasser';

  @override
  String get greenTea => 'Grüntee';

  @override
  String get amount => 'Menge';

  @override
  String get createFavoriteHint =>
      'Um einen Favoriten hinzuzufügen, gehe zu einem beliebigen Getränkebildschirm und tippe nach der Einrichtung auf \'Zu Favoriten speichern\'.';

  @override
  String get sparklingWater => 'Sprudelwasser';

  @override
  String get cola => 'Cola';

  @override
  String get juice => 'Saft';

  @override
  String get energyDrink => 'Energy-Drink';

  @override
  String get sportsDrink => 'Sportgetränk';

  @override
  String get selectElectrolyteType => 'Elektrolyt-Typ wählen:';

  @override
  String get saltQuarterTsp => 'Salz (1/4 TL)';

  @override
  String get pinkSalt => 'Rosa Himalaya-Salz';

  @override
  String get seaSalt => 'Meersalz';

  @override
  String get potassiumCitrate => 'Kaliumcitrat';

  @override
  String get magnesiumGlycinate => 'Magnesiumglycinat';

  @override
  String get coconutWaterElectrolyte => 'Kokoswasser';

  @override
  String get sportsDrinkElectrolyte => 'Sportgetränk';

  @override
  String get electrolyteContent => 'Elektrolytgehalt:';

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
  String get servings => 'Portionen';

  @override
  String get enterServings => 'Portionen eingeben';

  @override
  String get servingsUnit => 'Portionen';

  @override
  String get noElectrolytes => 'Keine Elektrolyte';

  @override
  String get enterValidAmount => 'Bitte gültige Menge eingeben';

  @override
  String get lmntMix => 'LMNT Mix';

  @override
  String get pickleJuice => 'Gurkensaft';

  @override
  String get tomatoSalt => 'Tomate + Salz';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'Basisches Wasser';

  @override
  String get celticSalt => 'Keltisches Salzwasser';

  @override
  String get soleWater => 'Sole-Wasser';

  @override
  String get mineralDrops => 'Mineraltropfen';

  @override
  String get bakingSoda => 'Natron-Wasser';

  @override
  String get creamTartar => 'Weinstein';

  @override
  String get selectSupplementType => 'Nahrungsergänzungstyp wählen:';

  @override
  String get multivitamin => 'Multivitamin';

  @override
  String get magnesiumCitrate => 'Magnesiumcitrat';

  @override
  String get magnesiumThreonate => 'Magnesium L-Threonat';

  @override
  String get calciumCitrate => 'Calciumcitrat';

  @override
  String get zincGlycinate => 'Zinkglycinat';

  @override
  String get vitaminD3 => 'Vitamin D3';

  @override
  String get vitaminC => 'Vitamin C';

  @override
  String get bComplex => 'B-Komplex';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => 'Eisenbisglycinat';

  @override
  String get dosage => 'Dosierung';

  @override
  String get enterDosage => 'Dosierung eingeben';

  @override
  String get noElectrolyteContent => 'Kein Elektrolytgehalt';

  @override
  String get blackTea => 'Schwarztee';

  @override
  String get herbalTea => 'Kräutertee';

  @override
  String get espresso => 'Espresso';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get latte => 'Latte';

  @override
  String get matcha => 'Matcha';

  @override
  String get hotChocolate => 'Heiße Schokolade';

  @override
  String get caffeine => 'Koffein';

  @override
  String get sports => 'Sport';

  @override
  String get walking => 'Gehen';

  @override
  String get running => 'Laufen';

  @override
  String get gym => 'Fitness';

  @override
  String get cycling => 'Radfahren';

  @override
  String get swimming => 'Schwimmen';

  @override
  String get yoga => 'Yoga';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'Boxen';

  @override
  String get dancing => 'Tanzen';

  @override
  String get tennis => 'Tennis';

  @override
  String get teamSports => 'Mannschaftssport';

  @override
  String get selectActivityType => 'Aktivitätstyp wählen:';

  @override
  String get duration => 'Dauer';

  @override
  String get minutes => 'Minuten';

  @override
  String get enterDuration => 'Dauer eingeben';

  @override
  String get lowIntensity => 'Niedrige Intensität';

  @override
  String get mediumIntensity => 'Mittlere Intensität';

  @override
  String get highIntensity => 'Hohe Intensität';

  @override
  String get recommendedIntake => 'Empfohlene Aufnahme:';

  @override
  String get basedOnWeight => 'Basierend auf Gewicht';

  @override
  String get logActivity => 'Aktivität protokollieren';

  @override
  String get activityLogged => 'Aktivität protokolliert';

  @override
  String get enterValidDuration => 'Bitte gültige Dauer eingeben';

  @override
  String get sauna => 'Sauna';

  @override
  String get veryHighIntensity => 'Sehr hohe Intensität';

  @override
  String get hriStatusExcellent => 'Ausgezeichnet';

  @override
  String get hriStatusGood => 'Gut';

  @override
  String get hriStatusModerate => 'Mäßiges Risiko';

  @override
  String get hriStatusHighRisk => 'Hohes Risiko';

  @override
  String get hriStatusCritical => 'Kritisch';

  @override
  String get hriComponentWater => 'Wasserbalance';

  @override
  String get hriComponentSodium => 'Natriumspiegel';

  @override
  String get hriComponentPotassium => 'Kaliumspiegel';

  @override
  String get hriComponentMagnesium => 'Magnesiumspiegel';

  @override
  String get hriComponentHeat => 'Hitzestress';

  @override
  String get hriComponentWorkout => 'Körperliche Aktivität';

  @override
  String get hriComponentCaffeine => 'Koffeineinfluss';

  @override
  String get hriComponentAlcohol => 'Alkoholeinfluss';

  @override
  String get hriComponentTime => 'Zeit seit Aufnahme';

  @override
  String get hriComponentMorning => 'Morgenfaktoren';

  @override
  String get hriBreakdownTitle => 'Risikofaktoren-Aufschlüsselung';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max Pkt.';
  }

  @override
  String get fastingModeActive => 'Fastenmodus aktiv';

  @override
  String get fastingSuppressionNote => 'Zeitfaktor während Fasten unterdrückt';

  @override
  String get morningCheckInTitle => 'Morgen-Check-in';

  @override
  String get howAreYouFeeling => 'Wie fühlst du dich?';

  @override
  String get feelingScale1 => 'Schlecht';

  @override
  String get feelingScale2 => 'Unterdurchschnittlich';

  @override
  String get feelingScale3 => 'Normal';

  @override
  String get feelingScale4 => 'Gut';

  @override
  String get feelingScale5 => 'Ausgezeichnet';

  @override
  String get weightChange => 'Gewichtsänderung seit gestern';

  @override
  String get urineColorScale => 'Urinfarbe (1-8 Skala)';

  @override
  String get urineColor1 => '1 - Sehr blass';

  @override
  String get urineColor2 => '2 - Blass';

  @override
  String get urineColor3 => '3 - Hellgelb';

  @override
  String get urineColor4 => '4 - Gelb';

  @override
  String get urineColor5 => '5 - Dunkelgelb';

  @override
  String get urineColor6 => '6 - Bernstein';

  @override
  String get urineColor7 => '7 - Dunkelbraun';

  @override
  String get urineColor8 => '8 - Braun';

  @override
  String get alcoholWithDecay => 'Alkoholeinfluss (abnehmend)';

  @override
  String standardDrinksToday(Object count) {
    return 'Standard-Getränke heute: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Aktives Koffein: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRI Debug-Info';

  @override
  String hriNormalized(Object value) {
    return 'HRI (normalisiert): $value/100';
  }

  @override
  String get fastingWindowActive => 'Fastenfenster aktiv';

  @override
  String get eatingWindowActive => 'Essensfenster aktiv';

  @override
  String nextFastingWindow(Object time) {
    return 'Nächstes Fasten: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Nächstes Essen: $time';
  }

  @override
  String get todaysWorkouts => 'Heutige Workouts';

  @override
  String get hoursAgo => 'Std. her';

  @override
  String get onboardingWelcomeTitle =>
      'HydroCoach — intelligente Hydration jeden Tag';

  @override
  String get onboardingWelcomeSubtitle =>
      'Trinke smarter, nicht mehr\nDie App berücksichtigt Wetter, Elektrolyte und deine Gewohnheiten\nHilft klaren Kopf und stabile Energie zu bewahren';

  @override
  String get onboardingBullet1 =>
      'Persönliche Wasser- und Salznorm basierend auf Wetter und dir';

  @override
  String get onboardingBullet2 => '\"Was jetzt tun\" Tipps statt roher Charts';

  @override
  String get onboardingBullet3 =>
      'Alkohol in Standarddosen mit sicheren Grenzen';

  @override
  String get onboardingBullet4 => 'Intelligente Erinnerungen ohne Spam';

  @override
  String get onboardingStartButton => 'Start';

  @override
  String get onboardingHaveAccount => 'Ich habe bereits ein Konto';

  @override
  String get onboardingPracticeFasting => 'Ich praktiziere Intervallfasten';

  @override
  String get onboardingPracticeFastingDesc =>
      'Spezielles Elektrolytregime für Fastenfenster';

  @override
  String get onboardingProfileReady => 'Profil bereit!';

  @override
  String get onboardingWaterNorm => 'Wassernorm';

  @override
  String get onboardingIonWillHelp => 'ION hilft jeden Tag Balance zu halten';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingLocationTitle => 'Wetter ist wichtig für Hydration';

  @override
  String get onboardingLocationSubtitle =>
      'Wir berücksichtigen Wetter und Luftfeuchtigkeit. Genauer als nur eine Formel nach Gewicht';

  @override
  String get onboardingWeatherExample => 'Heute heiß! +15% Wasser';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg Natrium bei Hitze';

  @override
  String get onboardingEnablePermission => 'Aktivieren';

  @override
  String get onboardingEnableLater => 'Später aktivieren';

  @override
  String get onboardingNotificationTitle => 'Intelligente Erinnerungen';

  @override
  String get onboardingNotificationSubtitle =>
      'Kurze Tipps zum richtigen Zeitpunkt. Frequenz mit einem Tippen änderbar';

  @override
  String get onboardingNotifExample1 => 'Zeit zu hydratisieren';

  @override
  String get onboardingNotifExample2 => 'Elektrolyte nicht vergessen';

  @override
  String get onboardingNotifExample3 => 'Heiß! Mehr Wasser trinken';

  @override
  String get sportRecoveryProtocols => 'Sport-Erholungsprotokolle';

  @override
  String get allDrinksAndSupplements => 'Alle Getränke & Nahrungsergänzung';

  @override
  String get notificationChannelDefault => 'Hydrations-Erinnerungen';

  @override
  String get notificationChannelDefaultDesc =>
      'Wasser- und Elektrolyt-Erinnerungen';

  @override
  String get notificationChannelUrgent => 'Wichtige Benachrichtigungen';

  @override
  String get notificationChannelUrgentDesc =>
      'Hitzewarnungen und kritische Hydrations-Alarme';

  @override
  String get notificationChannelReport => 'Berichte';

  @override
  String get notificationChannelReportDesc => 'Tages- und Wochenberichte';

  @override
  String get notificationWaterTitle => '💧 Zeit zu hydratisieren';

  @override
  String get notificationWaterBody => 'Vergiss nicht Wasser zu trinken';

  @override
  String get notificationPostCoffeeTitle => '☕ Nach Kaffee';

  @override
  String get notificationPostCoffeeBody =>
      '250-300 ml Wasser trinken, um Balance wiederherzustellen';

  @override
  String get notificationDailyReportTitle => '📊 Tagesbericht bereit';

  @override
  String get notificationDailyReportBody =>
      'Sieh, wie dein Hydrationstag verlaufen ist';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Erholungszeit';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return '$ml ml Wasser mit Prise Salz trinken';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Hitzewarnung';

  @override
  String get notificationHeatWarningExtremeBody =>
      'Extreme Hitze! +15% Wasser und +1g Salz';

  @override
  String get notificationHeatWarningHotBody =>
      'Heiß! +10% Wasser und Elektrolyte';

  @override
  String get notificationHeatWarningWarmBody => 'Warm. Hydration überwachen';

  @override
  String get notificationWorkoutTitle => '💪 Workout';

  @override
  String get notificationWorkoutBody =>
      'Wasser und Elektrolyte nicht vergessen';

  @override
  String get notificationPostWorkoutTitle => '💪 Nach Workout';

  @override
  String get notificationPostWorkoutBody =>
      '500 ml Wasser + Elektrolyte zur Erholung';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Elektrolyt-Zeit';

  @override
  String get notificationFastingElectrolyteBody =>
      'Prise Salz zum Wasser oder Brühe trinken';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Erholung ${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return '$ml ml Wasser trinken';
  }

  @override
  String get notificationAlcoholRecoveryMidBody =>
      'Elektrolyte hinzufügen: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Morgen früh - Kontroll-Check-in';

  @override
  String get notificationMorningCheckInTitle => '☀️ Morgen-Check-in';

  @override
  String get notificationMorningCheckInBody =>
      'Wie fühlst du dich? Bewerte deinen Zustand und erhalte einen Plan für den Tag';

  @override
  String get notificationMorningWaterBody =>
      'Beginne deinen Tag mit einem Glas Wasser';

  @override
  String notificationLowProgressBody(int percent) {
    return 'Du hast nur $percent% der Norm getrunken. Zeit aufzuholen!';
  }

  @override
  String get notificationGoodProgressBody =>
      'Hervorragender Fortschritt! Weiter so';

  @override
  String get notificationMaintainBalanceBody =>
      'Wasserbalance aufrechterhalten';

  @override
  String get notificationTestTitle => '🧪 Test-Benachrichtigung';

  @override
  String get notificationTestBody =>
      'Wenn du das siehst - Benachrichtigungen funktionieren!';

  @override
  String get notificationTestScheduledTitle => '⏰ Geplanter Test';

  @override
  String get notificationTestScheduledBody =>
      'Diese Benachrichtigung wurde vor 1 Minute geplant';

  @override
  String get onboardingUnitsTitle => 'Wähle deine Einheiten';

  @override
  String get onboardingUnitsSubtitle => 'Du kannst dies später nicht ändern';

  @override
  String get onboardingUnitsWarning =>
      'Diese Wahl ist dauerhaft und kann später nicht geändert werden';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'Gallonen';

  @override
  String get lb => 'lb';

  @override
  String get target => 'Ziel';

  @override
  String get wind => 'Wind';

  @override
  String get pressure => 'Druck';

  @override
  String get highHeatIndexWarning =>
      'Hoher Hitzeindex! Erhöhe deine Wasseraufnahme';

  @override
  String get weatherCondition => 'Bedingung';

  @override
  String get feelsLike => 'Gefühlt';

  @override
  String get humidityLabel => 'Luftfeuchtigkeit';

  @override
  String get waterNormal => 'Normal';

  @override
  String get sodiumNormal => 'Standard';

  @override
  String get addedSuccessfully => 'Erfolgreich hinzugefügt';

  @override
  String get sugarIntake => 'Zuckeraufnahme';

  @override
  String get sugarToday => 'Heutiger Zuckerkonsum';

  @override
  String get totalSugar => 'Gesamtzucker';

  @override
  String get dailyLimit => 'Tageslimit';

  @override
  String get addedSugar => 'Zugesetzter Zucker';

  @override
  String get naturalSugar => 'Natürlicher Zucker';

  @override
  String get hiddenSugar => 'Versteckter Zucker';

  @override
  String get sugarFromDrinks => 'Getränke';

  @override
  String get sugarFromFood => 'Essen';

  @override
  String get sugarFromSnacks => 'Snacks';

  @override
  String get sugarNormal => 'Normal';

  @override
  String get sugarModerate => 'Mäßig';

  @override
  String get sugarHigh => 'Hoch';

  @override
  String get sugarCritical => 'Kritisch';

  @override
  String get sugarRecommendationNormal =>
      'Großartig! Deine Zuckeraufnahme liegt im gesunden Bereich';

  @override
  String get sugarRecommendationModerate =>
      'Erwäge süße Getränke und Snacks zu reduzieren';

  @override
  String get sugarRecommendationHigh =>
      'Hohe Zuckeraufnahme! Begrenze süße Getränke und Desserts';

  @override
  String get sugarRecommendationCritical =>
      'Sehr hoher Zucker! Vermeide heute zuckerhaltige Getränke und Süßigkeiten';

  @override
  String get noSugarIntake => 'Heute kein Zucker erfasst';

  @override
  String get hriImpact => 'HRI-Einfluss';

  @override
  String get hri_component_sugar => 'Zucker';

  @override
  String get hri_sugar_description =>
      'Hohe Zuckeraufnahme beeinflusst Hydration und allgemeine Gesundheit';

  @override
  String get tip_reduce_sweet_drinks =>
      'Ersetze süße Getränke durch Wasser oder ungesüßten Tee';

  @override
  String get tip_avoid_added_sugar =>
      'Prüfe Etiketten und vermeide Produkte mit zugesetztem Zucker';

  @override
  String get tip_check_labels =>
      'Achte auf versteckte Zucker in Soßen und verarbeiteten Lebensmitteln';

  @override
  String get tip_replace_soda => 'Ersetze Limo durch Sprudelwasser mit Zitrone';

  @override
  String get sugarSources => 'Zuckerquellen';

  @override
  String get drinks => 'Getränke';

  @override
  String get food => 'Essen';

  @override
  String get snacks => 'Snacks';

  @override
  String get recommendedLimit => 'Empfohlen';

  @override
  String get points => 'Punkte';

  @override
  String get drinkLightBeer => 'Helles Bier';

  @override
  String get drinkLager => 'Lager';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'Stout';

  @override
  String get drinkWheatBeer => 'Weizenbier';

  @override
  String get drinkCraftBeer => 'Craft-Bier';

  @override
  String get drinkNonAlcoholic => 'Alkoholfrei';

  @override
  String get drinkRadler => 'Radler';

  @override
  String get drinkPilsner => 'Pilsner';

  @override
  String get drinkRedWine => 'Rotwein';

  @override
  String get drinkWhiteWine => 'Weißwein';

  @override
  String get drinkProsecco => 'Prosecco';

  @override
  String get drinkPort => 'Portwein';

  @override
  String get drinkRose => 'Rosé';

  @override
  String get drinkDessertWine => 'Dessertwein';

  @override
  String get drinkSangria => 'Sangria';

  @override
  String get drinkSherry => 'Sherry';

  @override
  String get drinkVodkaShot => 'Wodka Shot';

  @override
  String get drinkCognac => 'Cognac';

  @override
  String get drinkLiqueur => 'Likör';

  @override
  String get drinkAbsinthe => 'Absinth';

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
    return 'Beliebte $type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g Zucker';

  @override
  String get moderateConsumption => 'Mäßiger Konsum';

  @override
  String get aboveRecommendations => 'Über Empfehlungen';

  @override
  String get highConsumption => 'Hoher Konsum';

  @override
  String get veryHighConsider => 'Sehr hoch - erwäge zu stoppen';

  @override
  String get noAlcoholToday => 'Heute kein Alkohol';

  @override
  String get drinkWaterNow => 'Jetzt 300-500 ml Wasser trinken';

  @override
  String get addPinchSalt => 'Prise Salz hinzufügen';

  @override
  String get avoidLateCoffee => 'Späten Kaffee vermeiden';

  @override
  String abvPercent(Object percent) {
    return '$percent% Vol.';
  }

  @override
  String get todaysElectrolytes => 'Heutige Elektrolyte';

  @override
  String get greatBalance => 'Großartige Balance!';

  @override
  String get gettingThere => 'Fast da';

  @override
  String get needMoreElectrolytes => 'Mehr Elektrolyte benötigt';

  @override
  String get lowElectrolyteLevels => 'Niedrige Elektrolytwerte';

  @override
  String get electrolyteTips => 'Elektrolyt-Tipps';

  @override
  String get takeWithWater => 'Mit viel Wasser einnehmen';

  @override
  String get bestBetweenMeals => 'Am besten zwischen Mahlzeiten aufgenommen';

  @override
  String get startSmallAmounts => 'Mit kleinen Mengen beginnen';

  @override
  String get extraDuringExercise => 'Extra bei Training benötigt';

  @override
  String get electrolytesBasic => 'Basis';

  @override
  String get electrolytesMixes => 'Mischungen';

  @override
  String get electrolytesPills => 'Pillen';

  @override
  String get popularSalts => 'Beliebte Salze & Brühen';

  @override
  String get popularMixes => 'Beliebte Elektrolyt-Mischungen';

  @override
  String get popularSupplements => 'Beliebte Nahrungsergänzungen';

  @override
  String get electrolyteSaltWater => 'Salzwasser';

  @override
  String get electrolytePinkSalt => 'Rosa Salz';

  @override
  String get electrolyteSeaSalt => 'Meersalz';

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
  String get electrolytePotassiumChloride => 'Kaliumchlorid';

  @override
  String get electrolyteMagThreonate => 'Mag Threonat';

  @override
  String get electrolyteTraceMinerals => 'Spurenelemente';

  @override
  String get electrolyteZMAComplex => 'ZMA-Komplex';

  @override
  String get electrolyteMultiMineral => 'Multi-Mineral';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => 'Hydration';

  @override
  String get todayHydration => 'Heutige Hydration';

  @override
  String get currentIntake => 'Konsumiert';

  @override
  String get dailyGoal => 'Ziel';

  @override
  String get toGo => 'Verbleibend';

  @override
  String get goalReached => 'Ziel erreicht!';

  @override
  String get almostThere => 'Fast geschafft!';

  @override
  String get halfwayThere => 'Halbzeit';

  @override
  String get keepGoing => 'Weiter so';

  @override
  String get startDrinking => 'Fang an zu trinken';

  @override
  String get plainWater => 'Pur';

  @override
  String get enhancedWater => 'Angereichert';

  @override
  String get beverages => 'Getränke';

  @override
  String get sodas => 'Limonaden';

  @override
  String get popularPlainWater => 'Beliebte Wassertypen';

  @override
  String get popularEnhancedWater => 'Angereichert & Infused';

  @override
  String get popularBeverages => 'Beliebte Getränke';

  @override
  String get popularSodas => 'Beliebte Limos & Energy';

  @override
  String get hydrationTips => 'Hydrations-Tipps';

  @override
  String get drinkRegularly => 'Kleine Mengen regelmäßig trinken';

  @override
  String get roomTemperature =>
      'Zimmertemperatur-Wasser wird besser aufgenommen';

  @override
  String get addLemon => 'Zitrone für besseren Geschmack hinzufügen';

  @override
  String get limitSugary =>
      'Zuckerhaltige Getränke begrenzen - sie dehydrieren';

  @override
  String get warmWater => 'Warmes Wasser';

  @override
  String get iceWater => 'Eiswasser';

  @override
  String get filteredWater => 'Gefiltertes Wasser';

  @override
  String get distilledWater => 'Destilliertes Wasser';

  @override
  String get springWater => 'Quellwasser';

  @override
  String get hydrogenWater => 'Wasserstoffwasser';

  @override
  String get oxygenatedWater => 'Sauerstoffwasser';

  @override
  String get cucumberWater => 'Gurkenwasser';

  @override
  String get limeWater => 'Limonenwasser';

  @override
  String get berryWater => 'Beerenwasser';

  @override
  String get mintWater => 'Minzwasser';

  @override
  String get gingerWater => 'Ingwerwasser';

  @override
  String get caffeineStatusNone => 'Heute kein Koffein';

  @override
  String caffeineStatusModerate(Object amount) {
    return 'Mäßig: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return 'Hoch: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return 'Sehr hoch: ${amount}mg!';
  }

  @override
  String get caffeineDailyLimit => 'Tageslimit: 400mg';

  @override
  String get caffeineWarningTitle => 'Koffein-Warnung';

  @override
  String get caffeineWarning400 => 'Du hast heute 400mg Koffein überschritten';

  @override
  String get caffeineTipWater => 'Zusätzlich Wasser trinken zum Ausgleich';

  @override
  String get caffeineTipAvoid => 'Heute mehr Koffein vermeiden';

  @override
  String get caffeineTipSleep => 'Kann Schlafqualität beeinträchtigen';

  @override
  String get total => 'gesamt';

  @override
  String get cupsToday => 'Tassen heute';

  @override
  String get metabolizeTime => 'Zeit zum Verstoffwechseln';

  @override
  String get aboutCaffeine => 'Über Koffein';

  @override
  String get caffeineInfo1 =>
      'Kaffee enthält natürliches Koffein, das Wachsamkeit steigert';

  @override
  String get caffeineInfo2 =>
      'Tägliches Sicherheitslimit sind 400mg für die meisten Erwachsenen';

  @override
  String get caffeineInfo3 => 'Koffein-Halbwertszeit beträgt 5-6 Stunden';

  @override
  String get caffeineInfo4 =>
      'Extra Wasser trinken, um Koffeins harntreibende Wirkung auszugleichen';

  @override
  String get caffeineWarningPregnant =>
      'Schwangere sollten Koffein auf 200mg/Tag begrenzen';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get consumed => 'Konsumiert';

  @override
  String get remaining => 'verbleibend';

  @override
  String get todaysCaffeine => 'Heutiges Koffein';

  @override
  String get alreadyInFavorites => 'Bereits in Favoriten';

  @override
  String get ofRecommendedLimit => 'des empfohlenen Limits';

  @override
  String get aboutAlcohol => 'Über Alkohol';

  @override
  String get alcoholInfo1 =>
      'Ein Standardgetränk entspricht 10g reinem Alkohol';

  @override
  String get alcoholInfo2 =>
      'Alkohol dehydriert — 250ml extra Wasser pro Getränk trinken';

  @override
  String get alcoholInfo3 =>
      'Natrium hinzufügen, um Flüssigkeiten nach Trinken zu halten';

  @override
  String get alcoholInfo4 => 'Jedes Standardgetränk erhöht HRI um 3-5 Punkte';

  @override
  String get alcoholWarningHealth =>
      'Übermäßiger Alkoholkonsum schadet der Gesundheit. Empfohlenes Limit sind 2 SD für Männer und 1 SD für Frauen pro Tag.';

  @override
  String get supplementsInfo1 =>
      'Nahrungsergänzung hilft Elektrolytbalance aufrechtzuerhalten';

  @override
  String get supplementsInfo2 =>
      'Am besten zu Mahlzeiten für Aufnahme einnehmen';

  @override
  String get supplementsInfo3 => 'Immer mit viel Wasser einnehmen';

  @override
  String get supplementsInfo4 =>
      'Magnesium und Kalium sind wichtig für Hydration';

  @override
  String get supplementsWarning =>
      'Vor Beginn eines Nahrungsergänzungsregimes Arzt konsultieren';

  @override
  String get fromSupplementsToday => 'Von Nahrungsergänzung heute';

  @override
  String get minerals => 'Mineralien';

  @override
  String get vitamins => 'Vitamine';

  @override
  String get essentialMinerals => 'Essentielle Mineralien';

  @override
  String get otherSupplements => 'Andere Nahrungsergänzungen';

  @override
  String get supplementTip1 =>
      'Nahrungsergänzung mit Essen für bessere Aufnahme nehmen';

  @override
  String get supplementTip2 => 'Viel Wasser mit Nahrungsergänzung trinken';

  @override
  String get supplementTip3 =>
      'Mehrere Nahrungsergänzungen über den Tag verteilen';

  @override
  String get supplementTip4 => 'Verfolge, was für dich funktioniert';

  @override
  String get calciumCarbonate => 'Calciumcarbonat';

  @override
  String get traceMinerals => 'Spurenelemente';

  @override
  String get vitaminA => 'Vitamin A';

  @override
  String get vitaminE => 'Vitamin E';

  @override
  String get vitaminK2 => 'Vitamin K2';

  @override
  String get folate => 'Folat';

  @override
  String get biotin => 'Biotin';

  @override
  String get probiotics => 'Probiotika';

  @override
  String get melatonin => 'Melatonin';

  @override
  String get collagen => 'Kollagen';

  @override
  String get glucosamine => 'Glucosamin';

  @override
  String get turmeric => 'Kurkuma';

  @override
  String get coq10 => 'CoQ10';

  @override
  String get creatine => 'Kreatin';

  @override
  String get ashwagandha => 'Ashwagandha';

  @override
  String get selectCardioActivity => 'Kardio-Aktivität wählen';

  @override
  String get selectStrengthActivity => 'Kraft-Aktivität wählen';

  @override
  String get selectSportsActivity => 'Sport wählen';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get totalTime => 'Gesamtzeit';

  @override
  String get waterLoss => 'Wasserverlust';

  @override
  String get intensity => 'Intensität';

  @override
  String get drinkWaterAfterWorkout => 'Nach Workout Wasser trinken';

  @override
  String get replenishElectrolytes => 'Elektrolyte auffüllen';

  @override
  String get restAndRecover => 'Ausruhen und erholen';

  @override
  String get avoidSugaryDrinks => 'Zuckerhaltige Sportgetränke vermeiden';

  @override
  String get elliptical => 'Ellipsentrainer';

  @override
  String get rowing => 'Rudern';

  @override
  String get jumpRope => 'Seilspringen';

  @override
  String get stairClimbing => 'Treppensteigen';

  @override
  String get bodyweight => 'Eigengewicht';

  @override
  String get powerlifting => 'Powerlifting';

  @override
  String get calisthenics => 'Calisthenics';

  @override
  String get resistanceBands => 'Widerstandsbänder';

  @override
  String get kettlebell => 'Kettlebell';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'Strongman';

  @override
  String get pilates => 'Pilates';

  @override
  String get basketball => 'Basketball';

  @override
  String get soccerFootball => 'Fußball';

  @override
  String get golf => 'Golf';

  @override
  String get martialArts => 'Kampfkunst';

  @override
  String get rockClimbing => 'Klettern';

  @override
  String get needsToReplenish => 'Muss aufgefüllt werden';

  @override
  String get electrolyteTrackingPro =>
      'Verfolge Natrium-, Kalium- & Magnesiumziele mit detaillierten Fortschrittsbalken';

  @override
  String get unlock => 'Freischalten';

  @override
  String get weather => 'Wetter';

  @override
  String get weatherTrackingPro =>
      'Verfolge Hitzeindex, Luftfeuchtigkeit & Wettereinfluss auf Hydrationsziele';

  @override
  String get sugarTracking => 'Zucker-Verfolgung';

  @override
  String get sugarTrackingPro =>
      'Überwache natürlichen, zugesetzten & versteckten Zucker mit HRI-Einflussanalyse';

  @override
  String get dayOverview => 'Tagesübersicht';

  @override
  String get tapForDetails => 'Tippen für Details';

  @override
  String get noDataForDay => 'Keine Daten für diesen Tag';

  @override
  String get sweatLoss => 'Schweißverlust';

  @override
  String get cardio => 'Kardio';

  @override
  String get workout => 'Workout';

  @override
  String get noWaterToday => 'Heute kein Wasser erfasst';

  @override
  String get noElectrolytesToday => 'Heute keine Elektrolyte erfasst';

  @override
  String get noCoffeeToday => 'Heute kein Kaffee erfasst';

  @override
  String get noWorkoutsToday => 'Heute keine Workouts erfasst';

  @override
  String get noWaterThisDay => 'An diesem Tag kein Wasser erfasst';

  @override
  String get noElectrolytesThisDay => 'An diesem Tag keine Elektrolyte erfasst';

  @override
  String get noCoffeeThisDay => 'An diesem Tag kein Kaffee erfasst';

  @override
  String get noWorkoutsThisDay => 'An diesem Tag keine Workouts erfasst';

  @override
  String get weeklyReport => 'Wochenbericht';

  @override
  String get weeklyReportSubtitle => 'Tiefe Einblicke und Trendanalyse';

  @override
  String get workouts => 'Workouts';

  @override
  String get workoutHydration => 'Workout-Hydration';

  @override
  String workoutHydrationMessage(Object percent) {
    return 'An Workout-Tagen trinkst du $percent% mehr Wasser';
  }

  @override
  String get weeklyActivity => 'Wochenaktivität';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return 'Du hast $minutes Minuten an $days Tagen trainiert';
  }

  @override
  String get workoutMinutesPerDay => 'Workout-Minuten pro Tag';

  @override
  String get daysWithWorkouts => 'Tage mit Workouts';

  @override
  String get noWorkoutsThisWeek => 'Diese Woche keine Workouts';

  @override
  String get noAlcoholThisWeek => 'Diese Woche kein Alkohol';

  @override
  String get csvExported => 'Daten als CSV exportiert';

  @override
  String get mondayShort => 'MO';

  @override
  String get tuesdayShort => 'DI';

  @override
  String get wednesdayShort => 'MI';

  @override
  String get thursdayShort => 'DO';

  @override
  String get fridayShort => 'FR';

  @override
  String get saturdayShort => 'SA';

  @override
  String get sundayShort => 'SO';

  @override
  String get achievements => 'Erfolge';

  @override
  String get achievementsTabAll => 'Alle';

  @override
  String get achievementsTabHydration => 'Hydration';

  @override
  String get achievementsTabElectrolytes => 'Elektrolyte';

  @override
  String get achievementsTabSugar => 'Zuckerkontrolle';

  @override
  String get achievementsTabAlcohol => 'Alkohol';

  @override
  String get achievementsTabWorkout => 'Fitness';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => 'Serien';

  @override
  String get achievementsTabSpecial => 'Spezial';

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String get achievementProgress => 'Fortschritt';

  @override
  String get achievementPoints => 'Punkte';

  @override
  String get achievementRarityCommon => 'Häufig';

  @override
  String get achievementRarityUncommon => 'Ungewöhnlich';

  @override
  String get achievementRarityRare => 'Selten';

  @override
  String get achievementRarityEpic => 'Episch';

  @override
  String get achievementRarityLegendary => 'Legendär';

  @override
  String get achievementStatsUnlocked => 'Freigeschaltet';

  @override
  String get achievementStatsTotal => 'Gesamtpunkte';

  @override
  String get achievementFilterAll => 'Alle';

  @override
  String get achievementFilterUnlocked => 'Freigeschaltet';

  @override
  String get achievementSortProgress => 'Fortschritt';

  @override
  String get achievementSortName => 'Name';

  @override
  String get achievementSortRarity => 'Seltenheit';

  @override
  String get achievementNoAchievements => 'Noch keine Erfolge';

  @override
  String get achievementKeepUsing =>
      'Nutze die App weiter, um Erfolge freizuschalten!';

  @override
  String get achievementFirstGlass => 'Erster Tropfen';

  @override
  String get achievementFirstGlassDesc => 'Trinke dein erstes Glas Wasser';

  @override
  String get achievementHydrationGoal1 => 'Hydriert';

  @override
  String get achievementHydrationGoal1Desc =>
      'Erreiche dein tägliches Wasserziel';

  @override
  String get achievementHydrationGoal7 => 'Woche der Hydration';

  @override
  String get achievementHydrationGoal7Desc =>
      'Erreiche Wasserziel 7 Tage hintereinander';

  @override
  String get achievementHydrationGoal30 => 'Hydrations-Meister';

  @override
  String get achievementHydrationGoal30Desc =>
      'Erreiche Wasserziel 30 Tage hintereinander';

  @override
  String get achievementPerfectHydration => 'Perfekte Balance';

  @override
  String get achievementPerfectHydrationDesc =>
      'Erreiche 90-110% des Wasserziels';

  @override
  String get achievementEarlyBird => 'Frühaufsteher';

  @override
  String get achievementEarlyBirdDesc => 'Trinke dein erstes Wasser vor 9 Uhr';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return 'Trinke $volume vor 9 Uhr';
  }

  @override
  String get achievementNightOwl => 'Nachteule';

  @override
  String get achievementNightOwlDesc => 'Vollende Hydrationsziel vor 18 Uhr';

  @override
  String get achievementLiterLegend => 'Liter-Legende';

  @override
  String get achievementLiterLegendDesc =>
      'Erreiche deinen gesamten Hydrations-Meilenstein';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return 'Trinke $volume gesamt';
  }

  @override
  String get achievementSaltStarter => 'Salz-Starter';

  @override
  String get achievementSaltStarterDesc =>
      'Füge deine ersten Elektrolyte hinzu';

  @override
  String get achievementElectrolyteBalance => 'Ausgeglichen';

  @override
  String get achievementElectrolyteBalanceDesc =>
      'Erreiche alle Elektrolytziele an einem Tag';

  @override
  String get achievementSodiumMaster => 'Natrium-Meister';

  @override
  String get achievementSodiumMasterDesc =>
      'Erreiche Natriumziel 7 Tage hintereinander';

  @override
  String get achievementPotassiumPro => 'Kalium-Profi';

  @override
  String get achievementPotassiumProDesc =>
      'Erreiche Kaliumziel 7 Tage hintereinander';

  @override
  String get achievementMagnesiumMaven => 'Magnesium-Meister';

  @override
  String get achievementMagnesiumMavenDesc =>
      'Erreiche Magnesiumziel 7 Tage hintereinander';

  @override
  String get achievementElectrolyteExpert => 'Elektrolyt-Experte';

  @override
  String get achievementElectrolyteExpertDesc =>
      'Perfekte Elektrolytbalance für 30 Tage';

  @override
  String get achievementSugarAwareness => 'Zucker-Bewusstsein';

  @override
  String get achievementSugarAwarenessDesc => 'Verfolge Zucker zum ersten Mal';

  @override
  String get achievementSugarUnder25 => 'Zuckerkontrolle';

  @override
  String get achievementSugarUnder25Desc =>
      'Halte Zuckeraufnahme niedrig für einen Tag';

  @override
  String achievementSugarUnder25Template(String weight) {
    return 'Halte Zucker unter $weight für einen Tag';
  }

  @override
  String get achievementSugarWeekControl => 'Zucker-Disziplin';

  @override
  String get achievementSugarWeekControlDesc =>
      'Halte niedrige Zuckeraufnahme für eine Woche';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return 'Halte Zucker unter $weight für 7 Tage';
  }

  @override
  String get achievementSugarFreeDay => 'Zuckerfrei';

  @override
  String get achievementSugarFreeDayDesc =>
      'Vollende einen Tag mit 0g zugesetztem Zucker';

  @override
  String get achievementSugarDetective => 'Zucker-Detektiv';

  @override
  String get achievementSugarDetectiveDesc =>
      'Verfolge versteckte Zucker 10 Mal';

  @override
  String get achievementSugarMaster => 'Zucker-Meister';

  @override
  String get achievementSugarMasterDesc =>
      'Halte sehr niedrige Zuckeraufnahme für einen Monat';

  @override
  String get achievementNoSodaWeek => 'Limofreie Woche';

  @override
  String get achievementNoSodaWeekDesc => '7 Tage keine Limonaden';

  @override
  String get achievementNoSodaMonth => 'Limofreier Monat';

  @override
  String get achievementNoSodaMonthDesc => '30 Tage keine Limonaden';

  @override
  String get achievementSweetToothTamed => 'Naschlust gebändigt';

  @override
  String get achievementSweetToothTamedDesc =>
      'Reduziere täglichen Zucker um 50% für eine Woche';

  @override
  String get achievementAlcoholTracker => 'Bewusstsein';

  @override
  String get achievementAlcoholTrackerDesc => 'Verfolge Alkoholkonsum';

  @override
  String get achievementModerateDay => 'Mäßigung';

  @override
  String get achievementModerateDayDesc => 'Bleibe unter 2 SD an einem Tag';

  @override
  String get achievementSoberDay => 'Nüchterner Tag';

  @override
  String get achievementSoberDayDesc => 'Vollende einen alkoholfreien Tag';

  @override
  String get achievementSoberWeek => 'Nüchterne Woche';

  @override
  String get achievementSoberWeekDesc => '7 Tage alkoholfrei';

  @override
  String get achievementSoberMonth => 'Nüchterner Monat';

  @override
  String get achievementSoberMonthDesc => '30 Tage alkoholfrei';

  @override
  String get achievementRecoveryProtocol => 'Erholungs-Profi';

  @override
  String get achievementRecoveryProtocolDesc =>
      'Vollende Erholungsprotokoll nach Trinken';

  @override
  String get achievementFirstWorkout => 'In Bewegung';

  @override
  String get achievementFirstWorkoutDesc => 'Protokolliere dein erstes Workout';

  @override
  String get achievementWorkoutWeek => 'Aktive Woche';

  @override
  String get achievementWorkoutWeekDesc => '3 Mal in einer Woche trainieren';

  @override
  String get achievementCenturySweat => 'Jahrhundert-Schweiß';

  @override
  String get achievementCenturySweatDesc =>
      'Verliere signifikante Flüssigkeit durch Workouts';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return 'Verliere $volume durch Workouts';
  }

  @override
  String get achievementCardioKing => 'Kardio-König';

  @override
  String get achievementCardioKingDesc => 'Vollende 10 Kardio-Sitzungen';

  @override
  String get achievementStrengthWarrior => 'Kraft-Krieger';

  @override
  String get achievementStrengthWarriorDesc => 'Vollende 10 Kraft-Sitzungen';

  @override
  String get achievementHRIGreen => 'Grüne Zone';

  @override
  String get achievementHRIGreenDesc =>
      'Halte HRI in grüner Zone für einen Tag';

  @override
  String get achievementHRIWeekGreen => 'Sichere Woche';

  @override
  String get achievementHRIWeekGreenDesc =>
      'Halte HRI in grüner Zone für 7 Tage';

  @override
  String get achievementHRIPerfect => 'Perfekte Punktzahl';

  @override
  String get achievementHRIPerfectDesc => 'Erreiche HRI unter 20';

  @override
  String get achievementHRIRecovery => 'Schnelle Erholung';

  @override
  String get achievementHRIRecoveryDesc =>
      'Reduziere HRI von rot zu grün an einem Tag';

  @override
  String get achievementHRIMaster => 'HRI-Meister';

  @override
  String get achievementHRIMasterDesc => 'Halte HRI unter 30 für 30 Tage';

  @override
  String get achievementStreak3 => 'Einstieg';

  @override
  String get achievementStreak3Desc => '3-Tage-Serie';

  @override
  String get achievementStreak7 => 'Wochen-Krieger';

  @override
  String get achievementStreak7Desc => '7-Tage-Serie';

  @override
  String get achievementStreak30 => 'Konsistenz-König';

  @override
  String get achievementStreak30Desc => '30-Tage-Serie';

  @override
  String get achievementStreak100 => 'Jahrhundert-Club';

  @override
  String get achievementStreak100Desc => '100-Tage-Serie';

  @override
  String get achievementFirstWeek => 'Erste Woche';

  @override
  String get achievementFirstWeekDesc => 'Nutze die App 7 Tage lang';

  @override
  String get achievementProMember => 'PRO-Mitglied';

  @override
  String get achievementProMemberDesc => 'Werde PRO-Abonnent';

  @override
  String get achievementDataExport => 'Daten-Analyst';

  @override
  String get achievementDataExportDesc => 'Exportiere deine Daten nach CSV';

  @override
  String get achievementAllCategories => 'Alleskönner';

  @override
  String get achievementAllCategoriesDesc =>
      'Schalte mindestens einen Erfolg in jeder Kategorie frei';

  @override
  String get achievementHunter => 'Erfolgs-Jäger';

  @override
  String get achievementHunterDesc => 'Schalte 50% aller Erfolge frei';

  @override
  String get achievementDetailsUnlockedOn => 'Freigeschaltet am';

  @override
  String get achievementNewUnlocked => 'Neuer Erfolg freigeschaltet!';

  @override
  String get achievementViewAll => 'Alle Erfolge anzeigen';

  @override
  String get achievementCloseNotification => 'Schließen';

  @override
  String get before => 'vor';

  @override
  String get after => 'nach';

  @override
  String get lose => 'Verliere';

  @override
  String get through => 'durch';

  @override
  String get throughWorkouts => 'durch Workouts';

  @override
  String get reach => 'Erreiche';

  @override
  String get daysInRow => 'Tage hintereinander';

  @override
  String get completeHydrationGoal => 'Hydrationsziel vollenden';

  @override
  String get stayUnder => 'Bleibe unter';

  @override
  String get inADay => 'an einem Tag';

  @override
  String get alcoholFree => 'alkoholfrei';

  @override
  String get complete => 'Vollenden';

  @override
  String get achieve => 'Erreichen';

  @override
  String get keep => 'Halten';

  @override
  String get for30Days => 'für 30 Tage';

  @override
  String get liters => 'Liter';

  @override
  String get completed => 'Vollendet';

  @override
  String get notCompleted => 'Nicht vollendet';

  @override
  String get days => 'Tage';

  @override
  String get hours => 'Stunden';

  @override
  String get times => 'Mal';

  @override
  String get row => 'Reihe';

  @override
  String get ofTotal => 'von gesamt';

  @override
  String get perDay => 'pro Tag';

  @override
  String get perWeek => 'pro Woche';

  @override
  String get streak => 'Serie';

  @override
  String get tapToDismiss => 'Tippen zum Ausblenden';

  @override
  String tutorialStep1(String volume) {
    return 'Hallo! Ich helfe dir, deine optimale Hydrationsreise zu beginnen. Lass uns den ersten Schluck von $volume nehmen!';
  }

  @override
  String tutorialStep2(String volume) {
    return 'Ausgezeichnet! Nun lass uns weitere $volume hinzufügen, um zu sehen, wie es funktioniert.';
  }

  @override
  String get tutorialStep3 =>
      'Hervorragend! Du bist bereit, HydroCoach eigenständig zu nutzen. Ich bin hier, um dir zu helfen, perfekte Hydration zu erreichen!';

  @override
  String get tutorialComplete => 'Nutzung beginnen';

  @override
  String get onboardingNotificationExamplesTitle => 'Intelligente Erinnerungen';

  @override
  String get onboardingNotificationExamplesSubtitle =>
      'HydroCoach weiß, wann du Wasser brauchst';

  @override
  String get onboardingLocationExamplesTitle => 'Persönliche Ratschläge';

  @override
  String get onboardingLocationExamplesSubtitle =>
      'Wir berücksichtigen Wetter für genaue Empfehlungen';

  @override
  String get onboardingAllowNotifications => 'Benachrichtigungen erlauben';

  @override
  String get onboardingAllowLocation => 'Standort erlauben';

  @override
  String get foodCatalog => 'Lebensmittelkatalog';

  @override
  String get todaysFoodIntake => 'Heutige Nahrungsaufnahme';

  @override
  String get noFoodToday => 'Heute keine Nahrung erfasst';

  @override
  String foodItemsCount(int count) {
    return '$count Lebensmittel';
  }

  @override
  String get waterFromFood => 'Wasser aus Nahrung';

  @override
  String get last => 'Zuletzt';

  @override
  String get categoryFruits => 'Obst';

  @override
  String get categoryVegetables => 'Gemüse';

  @override
  String get categorySoups => 'Suppen';

  @override
  String get categoryDairy => 'Milchprodukte';

  @override
  String get categoryMeat => 'Fleisch';

  @override
  String get categoryFastFood => 'Fast Food';

  @override
  String get weightGrams => 'Gewicht (Gramm)';

  @override
  String get enterWeight => 'Gewicht eingeben';

  @override
  String get grams => 'g';

  @override
  String get calories => 'Kalorien';

  @override
  String get waterContent => 'Wassergehalt';

  @override
  String get sugar => 'Zucker';

  @override
  String get nutritionalInfo => 'Nährwertangaben';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$calories kcal pro ${weight}g';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$water ml Wasser pro ${weight}g';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${sugar}g Zucker pro ${weight}g';
  }

  @override
  String get addFood => 'Lebensmittel hinzufügen';

  @override
  String get foodAdded => 'Lebensmittel erfolgreich hinzugefügt';

  @override
  String get enterValidWeight => 'Bitte gültiges Gewicht eingeben';

  @override
  String get proOnlyFood => 'Nur PRO';

  @override
  String get unlockProForFood => 'PRO freischalten für alle Lebensmittel';

  @override
  String get foodTracker => 'Lebensmittel-Tracker';

  @override
  String get todaysFoodSummary => 'Heutige Lebensmittelzusammenfassung';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => 'pro 100g';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get favoritesFeatureComingSoon => 'Favoriten-Funktion kommt bald!';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food hinzugefügt! +$calories kcal, +$water';
  }

  @override
  String get selectWeight => 'Gewicht wählen';

  @override
  String get ounces => 'oz';

  @override
  String get items => 'Artikel';

  @override
  String get tapToAddFood => 'Tippen um Lebensmittel hinzuzufügen';

  @override
  String get noFoodLoggedToday => 'Heute keine Lebensmittel erfasst';

  @override
  String get lightEatingDay => 'Leichter Ess-Tag';

  @override
  String get moderateIntake => 'Mäßige Aufnahme';

  @override
  String get goodCalorieIntake => 'Gute Kalorienaufnahme';

  @override
  String get substantialMeals => 'Reichhaltige Mahlzeiten';

  @override
  String get highCalorieDay => 'Hoher Kalorien-Tag';

  @override
  String get veryHighIntake => 'Sehr hohe Aufnahme';

  @override
  String get caloriesTracker => 'Kalorien-Tracker';

  @override
  String get trackYourDailyCalorieIntake =>
      'Verfolge deine tägliche Kalorienaufnahme aus Nahrung';

  @override
  String get unlockFoodTrackingFeatures => 'Lebensmittel-Tracking freischalten';

  @override
  String get selectFoodType => 'Lebensmitteltyp wählen';

  @override
  String get foodApple => 'Apfel';

  @override
  String get foodBanana => 'Banane';

  @override
  String get foodOrange => 'Orange';

  @override
  String get foodWatermelon => 'Wassermelone';

  @override
  String get foodStrawberry => 'Erdbeere';

  @override
  String get foodGrapes => 'Weintrauben';

  @override
  String get foodPineapple => 'Ananas';

  @override
  String get foodMango => 'Mango';

  @override
  String get foodPear => 'Birne';

  @override
  String get foodCarrot => 'Karotte';

  @override
  String get foodBroccoli => 'Brokkoli';

  @override
  String get foodSpinach => 'Spinat';

  @override
  String get foodTomato => 'Tomate';

  @override
  String get foodCucumber => 'Gurke';

  @override
  String get foodBellPepper => 'Paprika';

  @override
  String get foodLettuce => 'Kopfsalat';

  @override
  String get foodOnion => 'Zwiebel';

  @override
  String get foodCelery => 'Sellerie';

  @override
  String get foodPotato => 'Kartoffel';

  @override
  String get foodChickenSoup => 'Hühnersuppe';

  @override
  String get foodTomatoSoup => 'Tomatensuppe';

  @override
  String get foodVegetableSoup => 'Gemüsesuppe';

  @override
  String get foodMinestrone => 'Minestrone';

  @override
  String get foodMisoSoup => 'Miso-Suppe';

  @override
  String get foodMushroomSoup => 'Pilzsuppe';

  @override
  String get foodBeefStew => 'Rindfleischeintopf';

  @override
  String get foodLentilSoup => 'Linsensuppe';

  @override
  String get foodOnionSoup => 'Französische Zwiebelsuppe';

  @override
  String get foodMilk => 'Milch';

  @override
  String get foodYogurt => 'Griechischer Joghurt';

  @override
  String get foodCheese => 'Cheddar-Käse';

  @override
  String get foodCottageCheese => 'Hüttenkäse';

  @override
  String get foodButter => 'Butter';

  @override
  String get foodCream => 'Sahne';

  @override
  String get foodIceCream => 'Eiscreme';

  @override
  String get foodMozzarella => 'Mozzarella';

  @override
  String get foodParmesan => 'Parmesan';

  @override
  String get foodChickenBreast => 'Hähnchenbrust';

  @override
  String get foodBeef => 'Rinderhackfleisch';

  @override
  String get foodSalmon => 'Lachs';

  @override
  String get foodEggs => 'Eier';

  @override
  String get foodTuna => 'Thunfisch';

  @override
  String get foodPork => 'Schweinekotelett';

  @override
  String get foodTurkey => 'Truthahn';

  @override
  String get foodShrimp => 'Garnelen';

  @override
  String get foodBacon => 'Speck';

  @override
  String get foodBigMac => 'Big Mac';

  @override
  String get foodPizza => 'Pizza-Stück';

  @override
  String get foodFrenchFries => 'Pommes Frites';

  @override
  String get foodChickenNuggets => 'Chicken Nuggets';

  @override
  String get foodHotDog => 'Hot Dog';

  @override
  String get foodTacos => 'Tacos';

  @override
  String get foodSubway => 'Subway Sandwich';

  @override
  String get foodDonut => 'Donut';

  @override
  String get foodBurgerKing => 'Whopper';

  @override
  String get foodSausage => 'Wurst';

  @override
  String get foodKefir => 'Kefir';

  @override
  String get foodRyazhenka => 'Rjaschenka';

  @override
  String get foodDoner => 'Döner';

  @override
  String get foodShawarma => 'Schawarma';

  @override
  String get foodBorscht => 'Borschtsch';

  @override
  String get foodRamen => 'Ramen';

  @override
  String get foodCabbage => 'Kohl';

  @override
  String get foodPeaSoup => 'Erbsensuppe';

  @override
  String get foodSolyanka => 'Soljanka';

  @override
  String get meals => 'Mahlzeiten';

  @override
  String get dailyProgress => 'Tagesfortschritt';

  @override
  String get fromFood => 'aus Nahrung';

  @override
  String get noFoodThisWeek => 'Diese Woche keine Lebensmitteldaten';

  @override
  String get foodIntake => 'Nahrungsaufnahme';

  @override
  String get foodStats => 'Lebensmittelstatistiken';

  @override
  String get totalCalories => 'Gesamtkalorien';

  @override
  String get avgCaloriesPerDay => 'Durchschn. pro Tag';

  @override
  String get daysWithFood => 'Tage mit Nahrung';

  @override
  String get avgMealsPerDay => 'Mahlzeiten pro Tag';

  @override
  String get caloriesPerDay => 'Kalorien pro Tag';

  @override
  String get sugarPerDay => 'Zucker pro Tag';

  @override
  String get foodTracking => 'Lebensmittel-Tracking';

  @override
  String get foodTrackingPro =>
      'Verfolge Nahrungseinfluss auf Hydration und HRI';

  @override
  String get hydrationBalance => 'Hydrations-Balance';

  @override
  String get highSodiumFood => 'Hoher Natriumgehalt aus Nahrung';

  @override
  String get hydratingFood => 'Großartige hydrierende Auswahl';

  @override
  String get dryFood => 'Niedriger Wassergehalt in Nahrung';

  @override
  String get balancedFood => 'Ausgewogene Ernährung';

  @override
  String get foodAdviceEmpty =>
      'Füge Mahlzeiten hinzu, um Nahrungseinfluss auf Hydration zu verfolgen.';

  @override
  String get foodAdviceHighSodium =>
      'Hohe Natriumaufnahme erkannt. Erhöhe Wasser, um Elektrolyte auszugleichen.';

  @override
  String get foodAdviceLowWater =>
      'Deine Nahrung hatte niedrigen Wassergehalt. Erwäge zusätzliches Wasser zu trinken.';

  @override
  String get foodAdviceGoodHydration =>
      'Großartig! Deine Nahrung hilft Hydration.';

  @override
  String get foodAdviceBalanced =>
      'Gute Ernährung! Vergiss nicht Wasser zu trinken.';

  @override
  String get richInElectrolytes => 'Reich an Elektrolyten';

  @override
  String recommendedCalories(int calories) {
    return 'Empfohlene Kalorien: ~$calories kcal/Tag';
  }

  @override
  String get proWelcomeTitle => 'Willkommen bei HydraCoach PRO!';

  @override
  String get proTrialActivated => 'Deine 7-Tage-Testversion ist aktiviert!';

  @override
  String get proFeaturePersonalizedRecommendations =>
      'Personalisierte Empfehlungen';

  @override
  String get proFeatureAdvancedAnalytics => 'Erweiterte Analysen';

  @override
  String get proFeatureWorkoutTracking => 'Workout-Verfolgung';

  @override
  String get proFeatureElectrolyteControl => 'Elektrolytkontrolle';

  @override
  String get proFeatureSmartReminders => 'Intelligente Erinnerungen';

  @override
  String get proFeatureHriIndex => 'HRI-Index';

  @override
  String get proFeatureAchievements => 'PRO-Erfolge';

  @override
  String get proFeaturePersonalizedDescription =>
      'Individuelle Hydrationsberatung';

  @override
  String get proFeatureAdvancedDescription =>
      'Detaillierte Charts und Statistiken';

  @override
  String get proFeatureWorkoutDescription =>
      'Flüssigkeitsverlust-Verfolgung beim Sport';

  @override
  String get proFeatureElectrolyteDescription =>
      'Natrium-, Kalium-, Magnesiumüberwachung';

  @override
  String get proFeatureSmartDescription => 'Personalisierte Benachrichtigungen';

  @override
  String get proFeatureNoMoreAds => 'Keine Werbung mehr!';

  @override
  String get proFeatureNoMoreAdsDescription =>
      'Genieße ununterbrochenes Hydrations-Tracking ohne Werbung';

  @override
  String get proFeatureHriDescription => 'Echtzeit-Hydrations-Risikoindex';

  @override
  String get proFeatureAchievementsDescription =>
      'Exklusive Belohnungen und Ziele';

  @override
  String get startUsing => 'Nutzung beginnen';

  @override
  String get sayGoodbyeToAds => 'Verabschiede dich von Werbung. Werde Premium.';

  @override
  String get goPremium => 'PREMIUM WERDEN';

  @override
  String get removeAdsForever => 'Werbung für immer entfernen';

  @override
  String get upgrade => 'UPGRADE';

  @override
  String get support => 'Support';

  @override
  String get companyWebsite => 'Unternehmenswebsite';

  @override
  String get appStoreOpened => 'App Store geöffnet';

  @override
  String get linkCopiedToClipboard => 'Link in Zwischenablage kopiert';

  @override
  String get shareDialogOpened => 'Teilen-Dialog geöffnet';

  @override
  String get linkForSharingCopied => 'Link zum Teilen kopiert';

  @override
  String get websiteOpenedInBrowser => 'Website im Browser geöffnet';

  @override
  String get emailClientOpened => 'E-Mail-Client geöffnet';

  @override
  String get emailCopiedToClipboard => 'E-Mail in Zwischenablage kopiert';

  @override
  String get privacyPolicyOpened => 'Datenschutzrichtlinie geöffnet';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Statistiken bis $dateString';
  }

  @override
  String get monthlyInsights => 'Monatseinblicke';

  @override
  String get average => 'Durchschnitt';

  @override
  String get daysOver => 'Tage über';

  @override
  String get maximum => 'Maximum';

  @override
  String get balance => 'Balance';

  @override
  String get allNormal => 'Alles normal';

  @override
  String get excellentConsistency => 'Ausgezeichnete Konsistenz';

  @override
  String get goodResults => 'Gute Ergebnisse';

  @override
  String get positiveImprovement => 'Positive Verbesserung';

  @override
  String get physicalActivity => 'Körperliche Aktivität';

  @override
  String get coffeeConsumption => 'Kaffeekonsum';

  @override
  String get excellentSobriety => 'Ausgezeichnete Nüchternheit';

  @override
  String get excellentMonth => 'Ausgezeichneter Monat';

  @override
  String get keepGoingMotivation => 'Weiter so!';

  @override
  String get daysNormal => 'Tage normal';

  @override
  String get electrolyteBalance => 'Elektrolytbalance benötigt Aufmerksamkeit';

  @override
  String get caffeineWarning => 'Tage mit Überdosis sicherer Dosis (400mg)';

  @override
  String get sugarFrequentExcess =>
      'Häufiger übermäßiger Zucker beeinflusst Hydration';

  @override
  String get averagePerDayShort => 'pro Tag';

  @override
  String get highWarning => 'Hoch';

  @override
  String get normalStatus => 'Normal';

  @override
  String improvementToEnd(int percent) {
    return 'Verbesserung zum Monatsende um $percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent% Tage mit Workouts (${hours}h)';
  }

  @override
  String coffeeAverage(String avg) {
    return 'Durchschnitt $avg Tassen/Tag';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent% Tage ohne Alkohol';
  }

  @override
  String get daySummary => 'Tageszusammenfassung';

  @override
  String get records => 'Einträge';

  @override
  String waterGoalAchievement(int percent) {
    return 'Wasserzielerreichung: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return 'Workouts: $count Sitzungen';
  }

  @override
  String get index => 'Index';

  @override
  String get status => 'Status';

  @override
  String get moderateRisk => 'Mäßiges Risiko';

  @override
  String get excess => 'Überschuss';

  @override
  String get whoLimit => 'WHO-Limit: 50g/Tag';

  @override
  String stability(int percent) {
    return 'Stabilität in $percent% der Tage';
  }

  @override
  String goodHydration(int percent) {
    return '$percent% Tage mit guter Hydration';
  }

  @override
  String daysInNorm(int count) {
    return '$count Tage in Norm';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent% Tage mit guter Hydration';
  }

  @override
  String stabilityDays(int percent) {
    return 'Stabilität in $percent% der Tage';
  }

  @override
  String monthEndImprovement(int percent) {
    return 'Monatsendverbesserung um $percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent% Tage mit Workouts (${hours}h)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return 'Durchschnitt $avgCups Tassen/Tag';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent% Tage ohne Alkohol';
  }

  @override
  String get moderateRiskStatus => 'Status: Mäßiges Risiko';

  @override
  String get high => 'Hoch';

  @override
  String get whoLimitPerDay => 'WHO-Limit: 50g/Tag';
}
