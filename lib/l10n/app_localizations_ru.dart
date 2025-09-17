// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'HydraCoach';

  @override
  String get getPro => 'Получить PRO';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get monday => 'Понедельник';

  @override
  String get tuesday => 'Вторник';

  @override
  String get wednesday => 'Среда';

  @override
  String get thursday => 'Четверг';

  @override
  String get friday => 'Пятница';

  @override
  String get saturday => 'Суббота';

  @override
  String get january => 'Январь';

  @override
  String get february => 'Февраль';

  @override
  String get march => 'Март';

  @override
  String get april => 'Апрель';

  @override
  String get may => 'Май';

  @override
  String get june => 'Июнь';

  @override
  String get july => 'Июль';

  @override
  String get august => 'Август';

  @override
  String get september => 'Сентябрь';

  @override
  String get october => 'Октябрь';

  @override
  String get november => 'Ноябрь';

  @override
  String get december => 'Декабрь';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String get loading => 'Загрузка...';

  @override
  String get loadingWeather => 'Загрузка погоды...';

  @override
  String get heatIndex => 'Индекс жары';

  @override
  String humidity(int value) {
    return 'Влажность';
  }

  @override
  String get water => 'Вода';

  @override
  String get liquids => 'Напитки';

  @override
  String get sodium => 'Натрий';

  @override
  String get potassium => 'Калий';

  @override
  String get magnesium => 'Магний';

  @override
  String get electrolyte => 'Электролиты';

  @override
  String get broth => 'Бульон';

  @override
  String get coffee => 'Кофе';

  @override
  String get alcohol => 'Алкоголь';

  @override
  String get drink => 'Напиток';

  @override
  String get ml => 'мл';

  @override
  String get mg => 'мг';

  @override
  String get kg => 'кг';

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
    return 'Жара +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'Алкоголь +$amount мл';
  }

  @override
  String get smartAdviceTitle => 'Совет на сейчас';

  @override
  String get smartAdviceDefault => 'Поддерживайте баланс воды и электролитов.';

  @override
  String get adviceOverhydrationSevere => 'Перегидратация (>200% цели)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Пауза 60-90 минут. Добавьте электролиты: 300-500 мл с 500-1000 мг натрия.';

  @override
  String get adviceOverhydration => 'Перегидратация';

  @override
  String get adviceOverhydrationBody =>
      'Пауза с водой на 30-60 минут и добавьте ~500 мг натрия (электролиты/бульон).';

  @override
  String get adviceAlcoholRecovery => 'Алкоголь: восстановление';

  @override
  String get adviceAlcoholRecoveryBody =>
      'Больше никакого алкоголя сегодня. Пейте 300-500 мл воды маленькими порциями и добавьте натрий.';

  @override
  String get adviceLowSodium => 'Мало натрия';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Добавьте ~$amount мг натрия. Пейте умеренно.';
  }

  @override
  String get adviceDehydration => 'Недогидратация';

  @override
  String adviceDehydrationBody(String type) {
    return 'Выпейте 300-500 мл $type.';
  }

  @override
  String get adviceHighRisk => 'Высокий риск (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Срочно пейте воду с электролитами (300-500 мл) и снизьте активность.';

  @override
  String get adviceHeat => 'Жара и потери';

  @override
  String get adviceHeatBody =>
      'Увеличьте воду на +5-8% и добавьте 300-500 мг натрия.';

  @override
  String get adviceAllGood => 'Всё идёт по плану';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Держите темп. Цель: ещё ~$amount мл до цели.';
  }

  @override
  String get hydrationStatus => 'Статус гидратации';

  @override
  String get hydrationStatusNormal => 'Норма';

  @override
  String get hydrationStatusDiluted => 'Разбавляете';

  @override
  String get hydrationStatusDehydrated => 'Недогидратация';

  @override
  String get hydrationStatusLowSalt => 'Мало соли';

  @override
  String get hydrationRiskIndex => 'Индекс риска гидратации';

  @override
  String get quickAdd => 'Быстрое добавление';

  @override
  String get add => 'Добавить';

  @override
  String get delete => 'Удалить';

  @override
  String get todaysDrinks => 'Напитки сегодня';

  @override
  String get allRecords => 'Все записи →';

  @override
  String itemDeleted(String item) {
    return '$item удалено';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get dailyReportReady => 'Дневной отчёт готов!';

  @override
  String get viewDayResults => 'Посмотреть результаты дня';

  @override
  String get dailyReportComingSoon =>
      'Дневной отчёт будет доступен в следующей версии';

  @override
  String get home => 'Главная';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get cancel => 'Отменить';

  @override
  String get save => 'Сохранить';

  @override
  String get reset => 'Сбросить';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageSection => 'Язык';

  @override
  String get languageSettings => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get profileSection => 'Профиль';

  @override
  String get weight => 'Вес';

  @override
  String get dietMode => 'Режим питания';

  @override
  String get activityLevel => 'Уровень активности';

  @override
  String get changeWeight => 'Изменить вес';

  @override
  String get dietModeNormal => 'Обычное питание';

  @override
  String get dietModeKeto => 'Кето / Низкоуглеводная';

  @override
  String get dietModeFasting => 'Интервальное голодание';

  @override
  String get activityLow => 'Низкая активность';

  @override
  String get activityMedium => 'Средняя активность';

  @override
  String get activityHigh => 'Высокая активность';

  @override
  String get activityLowDesc => 'Офисная работа, малое движение';

  @override
  String get activityMediumDesc => '30-60 минут упражнений в день';

  @override
  String get activityHighDesc => 'Тренировки >1 часа';

  @override
  String get notificationsSection => 'Уведомления';

  @override
  String get notificationLimit => 'Лимит уведомлений (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Использовано: $used из $limit';
  }

  @override
  String get waterReminders => 'Напоминания о воде';

  @override
  String get waterRemindersDesc => 'Регулярные напоминания в течение дня';

  @override
  String get reminderFrequency => 'Частота напоминаний';

  @override
  String timesPerDay(int count) {
    return '$count раз в день';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count раз в день (макс 4)';
  }

  @override
  String get unlimitedReminders => 'Без ограничений';

  @override
  String get startOfDay => 'Начало дня';

  @override
  String get endOfDay => 'Конец дня';

  @override
  String get postCoffeeReminders => 'Напоминания после кофе';

  @override
  String get postCoffeeRemindersDesc => 'Напомнить пить воду через 20 минут';

  @override
  String get heatWarnings => 'Предупреждения о жаре';

  @override
  String get heatWarningsDesc => 'Уведомления при высокой температуре';

  @override
  String get postAlcoholReminders => 'Напоминания после алкоголя';

  @override
  String get postAlcoholRemindersDesc => 'План восстановления на 6-12 часов';

  @override
  String get proFeaturesSection => 'PRO функции';

  @override
  String get unlockPro => 'Разблокировать PRO';

  @override
  String get unlockProDesc => 'Без ограничений уведомлений и умные напоминания';

  @override
  String get noNotificationLimit => 'Без лимита уведомлений';

  @override
  String get unitsSection => 'Единицы измерения';

  @override
  String get metricSystem => 'Метрическая система';

  @override
  String get metricUnits => 'мл, кг, °C';

  @override
  String get imperialSystem => 'Имперская система';

  @override
  String get imperialUnits => 'унции, фунты, °F';

  @override
  String get aboutSection => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get share => 'Поделиться';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get resetAllData => 'Сбросить все данные';

  @override
  String get resetDataTitle => 'Сбросить все данные?';

  @override
  String get resetDataMessage =>
      'Это удалит всю историю и восстановит настройки по умолчанию.';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get start => 'Начать';

  @override
  String get welcomeTitle => 'Добро пожаловать в\nHydraCoach';

  @override
  String get welcomeSubtitle =>
      'Умное отслеживание воды и электролитов\nдля кето, поста и активной жизни';

  @override
  String get weightPageTitle => 'Ваш вес';

  @override
  String get weightPageSubtitle => 'Для расчёта оптимального количества воды';

  @override
  String weightUnit(int weight) {
    return '$weight кг';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Рекомендуемая норма: $min-$max мл воды в день';
  }

  @override
  String get dietPageTitle => 'Режим питания';

  @override
  String get dietPageSubtitle => 'Это влияет на потребности в электролитах';

  @override
  String get normalDiet => 'Обычное питание';

  @override
  String get normalDietDesc => 'Стандартные рекомендации';

  @override
  String get ketoDiet => 'Кето / Низкоуглеводная';

  @override
  String get ketoDietDesc => 'Повышенная потребность в соли';

  @override
  String get fastingDiet => 'Интервальное голодание';

  @override
  String get fastingDietDesc => 'Особый режим электролитов';

  @override
  String get fastingSchedule => 'График голодания:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Ежедневное 8-часовое окно';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Один приём пищи в день';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Голодание через день';

  @override
  String get activityPageTitle => 'Уровень активности';

  @override
  String get activityPageSubtitle => 'Влияет на потребности в воде';

  @override
  String get lowActivity => 'Низкая активность';

  @override
  String get lowActivityDesc => 'Офисная работа, малое движение';

  @override
  String get lowActivityWater => '+0 мл воды';

  @override
  String get mediumActivity => 'Средняя активность';

  @override
  String get mediumActivityDesc => '30-60 минут упражнений в день';

  @override
  String get mediumActivityWater => '+350-700 мл воды';

  @override
  String get highActivity => 'Высокая активность';

  @override
  String get highActivityDesc => 'Тренировки >1 часа или физический труд';

  @override
  String get highActivityWater => '+700-1200 мл воды';

  @override
  String get activityAdjustmentNote =>
      'Мы будем корректировать цели на основе ваших тренировок';

  @override
  String get day => 'День';

  @override
  String get week => 'Неделя';

  @override
  String get month => 'Месяц';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get noData => 'Нет данных';

  @override
  String get noRecordsToday => 'Сегодня записей пока нет';

  @override
  String get noRecordsThisDay => 'В этот день записей нет';

  @override
  String get loadingData => 'Загрузка данных...';

  @override
  String get deleteRecord => 'Удалить запись?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return 'Удалить $type $volume мл?';
  }

  @override
  String get recordDeleted => 'Запись удалена';

  @override
  String get waterConsumption => '💧 Потребление воды';

  @override
  String get alcoholWeek => '🍺 Алкоголь за неделю';

  @override
  String get electrolytes => '⚡ Электролиты';

  @override
  String get weeklyAverages => '📊 Недельные средние';

  @override
  String get monthStatistics => '📊 Статистика месяца';

  @override
  String get alcoholStatistics => '🍺 Статистика алкоголя';

  @override
  String get alcoholStatisticsTitle => 'Статистика алкоголя';

  @override
  String get weeklyInsights => '💡 Недельные инсайты';

  @override
  String get waterPerDay => 'Воды в день';

  @override
  String get sodiumPerDay => 'Натрия в день';

  @override
  String get potassiumPerDay => 'Калия в день';

  @override
  String get magnesiumPerDay => 'Магния в день';

  @override
  String get goal => 'Цель';

  @override
  String get daysWithGoalAchieved => '✅ Дней с достигнутой целью';

  @override
  String get recordsPerDay => '📝 Записей в день';

  @override
  String get insufficientDataForAnalysis => 'Недостаточно данных для анализа';

  @override
  String get totalVolume => 'Общий объём';

  @override
  String averagePerDay(int amount) {
    return 'В среднем $amount мл/день';
  }

  @override
  String get activeDays => 'Активные дни';

  @override
  String perfectDays(int count) {
    return 'Дней с идеальной целью: $count';
  }

  @override
  String currentStreak(int days) {
    return 'Текущая серия: $days дней';
  }

  @override
  String soberDaysRow(int days) {
    return 'Трезвых дней подряд: $days';
  }

  @override
  String get keepItUp => 'Так держать!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Вода: $amount мл ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Алкоголь: $amount SD';
  }

  @override
  String get totalSD => 'Всего SD';

  @override
  String get forMonth => 'за месяц';

  @override
  String get daysWithAlcohol => 'Дней с алкоголем';

  @override
  String fromDays(int days) {
    return 'из $days';
  }

  @override
  String get soberDays => 'Трезвые дни';

  @override
  String get excellent => 'отлично!';

  @override
  String get averageSD => 'Средний SD';

  @override
  String get inDrinkingDays => 'в дни употребления';

  @override
  String get bestDay => '🏆 Лучший день';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% от цели';
  }

  @override
  String get weekends => '📅 Выходные';

  @override
  String get weekdays => '📅 Будни';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'В выходные вы пьёте на $percent% меньше';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'В будни вы пьёте на $percent% меньше';
  }

  @override
  String get positiveTrend => '📈 Позитивная тенденция';

  @override
  String get positiveTrendMessage =>
      'Ваша гидратация улучшается к концу недели';

  @override
  String get decliningActivity => '📉 Снижение активности';

  @override
  String get decliningActivityMessage =>
      'Потребление воды снижается к концу недели';

  @override
  String get lowSalt => '⚠️ Мало соли';

  @override
  String lowSaltMessage(int days) {
    return 'Только $days дней с нормальным уровнем натрия';
  }

  @override
  String get frequentAlcohol => '🍺 Частое употребление';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Алкоголь $days дней из 7 влияет на гидратацию';
  }

  @override
  String get excellentWeek => '✅ Отличная неделя';

  @override
  String get continueMessage => 'Продолжайте в том же духе!';

  @override
  String get all => 'Все';

  @override
  String get addAlcohol => 'Добавить алкоголь';

  @override
  String get minimumHarm => 'Минимум вреда';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount мл воды нужно';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount мг натрия добавить';
  }

  @override
  String get goToBedEarly => 'Лечь спать пораньше';

  @override
  String get todayConsumed => 'Сегодня употреблено:';

  @override
  String get alcoholToday => 'Алкоголь сегодня';

  @override
  String get beer => 'Пиво';

  @override
  String get wine => 'Вино';

  @override
  String get spirits => 'Крепкие напитки';

  @override
  String get cocktail => 'Коктейль';

  @override
  String get selectDrinkType => 'Выберите тип напитка:';

  @override
  String get volume => 'Объём';

  @override
  String get enterVolume => 'Введите объём в мл';

  @override
  String get strength => 'Силовые';

  @override
  String get standardDrinks => 'Стандартные дринки:';

  @override
  String get additionalWater => 'Доп. вода';

  @override
  String get additionalSodium => 'Доп. натрий';

  @override
  String get hriRisk => 'Риск HRI';

  @override
  String get enterValidVolume => 'Пожалуйста, введите корректный объём';

  @override
  String get weeklyHistory => 'Недельная история';

  @override
  String get weeklyHistoryDesc =>
      'Анализ недельных трендов, инсайты и рекомендации';

  @override
  String get monthlyHistory => 'Месячная история';

  @override
  String get monthlyHistoryDesc =>
      'Долгосрочные паттерны, сравнение недель и глубокая аналитика';

  @override
  String get proFunction => 'PRO функция';

  @override
  String get unlockProHistory => 'Разблокировать PRO';

  @override
  String get unlimitedHistory => 'Безлимитная история';

  @override
  String get dataExportCSV => 'Экспорт данных в CSV';

  @override
  String get detailedAnalytics => 'Детальная аналитика';

  @override
  String get periodComparison => 'Сравнение периодов';

  @override
  String get shareResult => 'Поделиться результатом';

  @override
  String get retry => 'Повторить';

  @override
  String get welcomeToPro => 'Добро пожаловать в PRO!';

  @override
  String get allFeaturesUnlocked => 'Все функции разблокированы';

  @override
  String get testMode => 'Тестовый режим: Используется мок-покупка';

  @override
  String get proStatusNote => 'PRO статус сохранится до перезапуска приложения';

  @override
  String get startUsingPro => 'Начать использовать PRO';

  @override
  String get lifetimeAccess => 'Пожизненный доступ';

  @override
  String get bestValueAnnual => 'Лучшая цена — Годовая';

  @override
  String get monthly => 'Месячная';

  @override
  String get oneTime => 'разовый';

  @override
  String get perYear => '/год';

  @override
  String get perMonth => '/мес';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/мес';
  }

  @override
  String get startFreeTrial => 'Начать 7-дневную пробную версию';

  @override
  String continueWithPrice(String price) {
    return 'Продолжить — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Разблокировать за $price (разовый)';
  }

  @override
  String get enableFreeTrial => 'Включить 7-дневную пробную версию';

  @override
  String get noChargeToday =>
      'Никаких списаний сегодня. Через 7 дней ваша подписка автоматически продлится, если не отменить.';

  @override
  String get cancelAnytime => 'Вы можете отменить в любое время в Настройках.';

  @override
  String get everythingInPro => 'Всё в PRO';

  @override
  String get smartReminders => 'Умные напоминания';

  @override
  String get smartRemindersDesc => 'Жара, тренировки, пост — без спама.';

  @override
  String get weeklyReports => 'Недельные отчёты';

  @override
  String get weeklyReportsDesc => 'Глубокие инсайты + экспорт CSV.';

  @override
  String get healthIntegrations => 'Интеграции здоровья';

  @override
  String get healthIntegrationsDesc => 'Apple Health и Google Fit.';

  @override
  String get alcoholProtocols => 'Алкогольные протоколы';

  @override
  String get alcoholProtocolsDesc => 'Подготовка до и план восстановления.';

  @override
  String get fullSync => 'Полная синхронизация';

  @override
  String get fullSyncDesc => 'Безлимитная история на всех устройствах.';

  @override
  String get personalCalibrations => 'Персональные калибровки';

  @override
  String get personalCalibrationsDesc => 'Тест пота, шкала цвета мочи.';

  @override
  String get showAllFeatures => 'Показать все функции';

  @override
  String get showLess => 'Показать меньше';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get proSubscriptionRestored => 'PRO подписка восстановлена!';

  @override
  String get noPurchasesToRestore => 'Покупок для восстановления не найдено';

  @override
  String get drinkMoreWaterToday => 'Пейте больше воды сегодня (+20%)';

  @override
  String get addElectrolytesToWater =>
      'Добавляйте электролиты в каждый приём воды';

  @override
  String get limitCoffeeOneCup => 'Ограничьте кофе одной чашкой';

  @override
  String get increaseWater10 => 'Увеличьте воду на 10%';

  @override
  String get dontForgetElectrolytes => 'Не забывайте об электролитах';

  @override
  String get startDayWithWater => 'Начните день со стакана воды';

  @override
  String get dontForgetElectrolytesReminder => '⚡ Не забывайте об электролитах';

  @override
  String get startDayWithWaterReminder =>
      'Начните день со стакана воды для хорошего самочувствия';

  @override
  String get takeElectrolytesMorning => 'Принимайте электролиты утром';

  @override
  String purchaseFailed(String error) {
    return 'Покупка не удалась: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Восстановление не удалось: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — доверие 12,000 пользователей';

  @override
  String get bestValue => 'Лучшая цена';

  @override
  String percentOff(int percent) {
    return '-$percent% Лучшая цена';
  }

  @override
  String get weatherUnavailable => 'Погода недоступна';

  @override
  String get checkLocationPermissions =>
      'Проверьте разрешения геолокации и интернет';

  @override
  String get currentLocation => 'Текущее местоположение';

  @override
  String get weatherClear => 'ясно';

  @override
  String get weatherCloudy => 'облачно';

  @override
  String get weatherOvercast => 'пасмурно';

  @override
  String get weatherRain => 'дождь';

  @override
  String get weatherSnow => 'снег';

  @override
  String get weatherStorm => 'гроза';

  @override
  String get weatherFog => 'туман';

  @override
  String get weatherDrizzle => 'морось';

  @override
  String get weatherSunny => 'солнечно';

  @override
  String get heatWarningExtreme =>
      '☀️ Экстремальная жара! Максимальная гидратация';

  @override
  String get heatWarningVeryHot => '🌡️ Очень жарко! Риск обезвоживания';

  @override
  String get heatWarningHot => '🔥 Жарко! Пейте больше воды';

  @override
  String get heatWarningElevated => '⚠️ Повышенная температура';

  @override
  String get heatWarningComfortable => 'Комфортная температура';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% воды';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount мг натрия';
  }

  @override
  String get heatWarningCold =>
      '❄️ Холодно! Согревайтесь и пейте тёплые жидкости';

  @override
  String get notificationChannelName => 'Напоминания HydraCoach';

  @override
  String get notificationChannelDescription =>
      'Напоминания о воде и электролитах';

  @override
  String get urgentNotificationChannelName => 'Срочные напоминания';

  @override
  String get urgentNotificationChannelDescription =>
      'Важные уведомления о гидратации';

  @override
  String get goodMorning => '☀️ Доброе утро!';

  @override
  String get timeToHydrate => '💧 Время гидратации';

  @override
  String get eveningHydration => '💧 Вечерняя гидратация';

  @override
  String get dailyReportTitle => '📊 Дневной отчёт готов';

  @override
  String get dailyReportBody => 'Посмотрите, как прошёл ваш день гидратации';

  @override
  String get maintainWaterBalance =>
      'Поддерживайте водный баланс в течение дня';

  @override
  String get electrolytesTime =>
      'Время для электролитов: добавьте щепотку соли в воду';

  @override
  String catchUpHydration(int percent) {
    return 'Вы выпили только $percent% дневной нормы. Время наверстать!';
  }

  @override
  String get excellentProgress => 'Отличный прогресс! Ещё немного до цели';

  @override
  String get postCoffeeTitle => '☕ После кофе';

  @override
  String get postCoffeeBody =>
      'Выпейте 250-300 мл воды для восстановления баланса';

  @override
  String get postWorkoutTitle => '💪 После тренировки';

  @override
  String get postWorkoutBody =>
      'Восстановите электролиты: 500 мл воды + щепотка соли';

  @override
  String get heatWarningPro => '🌡️ PRO Предупреждение о жаре';

  @override
  String get extremeHeatWarning =>
      'Экстремальная жара! Увеличьте потребление воды на 15% и добавьте 1г соли';

  @override
  String get hotWeatherWarning =>
      'Жарко! Пейте на 10% больше воды и не забывайте об электролитах';

  @override
  String get warmWeatherWarning => 'Тёплая погода. Следите за гидратацией';

  @override
  String get alcoholRecoveryTitle => '🍺 Время восстановления';

  @override
  String get alcoholRecoveryBody =>
      'Выпейте 300 мл воды со щепоткой соли для баланса';

  @override
  String get continueHydration => '💧 Продолжайте гидратацию';

  @override
  String get alcoholRecoveryBody2 =>
      'Ещё 500 мл воды помогут вам быстрее восстановиться';

  @override
  String get morningRecoveryTitle => '☀️ Утреннее восстановление';

  @override
  String get morningRecoveryBody => 'Начните день с 500 мл воды и электролитов';

  @override
  String get testNotificationTitle => '🧪 Тестовое уведомление';

  @override
  String get testNotificationBody =>
      'Если вы видите это - мгновенные уведомления работают!';

  @override
  String get scheduledTestTitle => '⏰ Запланированный тест (1 мин)';

  @override
  String get scheduledTestBody =>
      'Это уведомление было запланировано минуту назад. Планирование работает!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService инициализирован';

  @override
  String get localNotificationsInitialized =>
      '✅ Локальные уведомления инициализированы';

  @override
  String get androidChannelsCreated => '📢 Android каналы уведомлений созданы';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Разрешение уведомлений: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Разрешение точных будильников: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM разрешения: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM Токен получен';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCM Токен сохранён в Firestore для пользователя $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ Подписка на тему завершена';

  @override
  String foregroundMessage(String title) {
    return '📨 Сообщение на переднем плане: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Уведомление открыто: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Достигнут дневной лимит уведомлений (4/день для FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Ошибка планирования уведомления: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Показываем уведомление немедленно как резервный вариант';

  @override
  String instantNotificationShown(String title) {
    return '📬 Мгновенное уведомление показано: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 Планирование умных напоминаний...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ Запланировано $count напоминаний';
  }

  @override
  String get proPostCoffeeScheduled =>
      '☕ PRO: Напоминание после кофе запланировано';

  @override
  String get postWorkoutScheduled =>
      '💪 Напоминание после тренировки запланировано';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Предупреждение о жаре отправлено';

  @override
  String get proAlcoholRecoveryPlan =>
      '🍺 PRO: План восстановления после алкоголя запланирован';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Вечерний отчёт запланирован на $day.$month в 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Уведомление $id отменено';
  }

  @override
  String get allNotificationsCancelled => '🗑️ Все уведомления отменены';

  @override
  String get reminderSettingsSaved => '✅ Настройки напоминаний сохранены';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Тестовое уведомление запланировано на $time';
  }

  @override
  String get tomorrowRecommendations => 'Рекомендации на завтра';

  @override
  String get recommendationExcellent =>
      'Отличная работа! Продолжайте в том же духе. Старайтесь начинать день со стакана воды и поддерживать равномерное потребление.';

  @override
  String get recommendationDiluted =>
      'Вы пьете много воды, но мало электролитов. Завтра добавьте больше соли или выпейте электролитный напиток. Попробуйте начать день с соленого бульона.';

  @override
  String get recommendationDehydrated =>
      'Недостаточно воды сегодня. Завтра поставьте напоминания каждые 2 часа. Держите бутылку воды на видном месте.';

  @override
  String get recommendationLowSalt =>
      'Низкий уровень натрия может вызвать усталость. Добавьте щепотку соли в воду или выпейте бульон. Особенно важно на кето или при голодании.';

  @override
  String get recommendationGeneral =>
      'Стремитесь к балансу воды и электролитов. Пейте равномерно в течение дня и не забывайте про соль в жару.';

  @override
  String get category_water => 'Вода';

  @override
  String get category_hot_drinks => 'Горячие напитки';

  @override
  String get category_juice => 'Соки';

  @override
  String get category_sports => 'Спортивные';

  @override
  String get category_dairy => 'Молочные';

  @override
  String get category_alcohol => 'Алкоголь';

  @override
  String get category_supplements => 'Добавки';

  @override
  String get category_other => 'Другое';

  @override
  String get drink_water => 'Вода';

  @override
  String get drink_sparkling_water => 'Газированная вода';

  @override
  String get drink_mineral_water => 'Минеральная вода';

  @override
  String get drink_coconut_water => 'Кокосовая вода';

  @override
  String get drink_coffee => 'Кофе';

  @override
  String get drink_espresso => 'Эспрессо';

  @override
  String get drink_americano => 'Американо';

  @override
  String get drink_cappuccino => 'Капучино';

  @override
  String get drink_latte => 'Латте';

  @override
  String get drink_black_tea => 'Черный чай';

  @override
  String get drink_green_tea => 'Зеленый чай';

  @override
  String get drink_herbal_tea => 'Травяной чай';

  @override
  String get drink_matcha => 'Матча';

  @override
  String get drink_hot_chocolate => 'Горячий шоколад';

  @override
  String get drink_orange_juice => 'Апельсиновый сок';

  @override
  String get drink_apple_juice => 'Яблочный сок';

  @override
  String get drink_grapefruit_juice => 'Грейпфрутовый сок';

  @override
  String get drink_tomato_juice => 'Томатный сок';

  @override
  String get drink_vegetable_juice => 'Овощной сок';

  @override
  String get drink_smoothie => 'Смузи';

  @override
  String get drink_lemonade => 'Лимонад';

  @override
  String get drink_isotonic => 'Изотоник';

  @override
  String get drink_electrolyte => 'Электролитный напиток';

  @override
  String get drink_protein_shake => 'Протеиновый коктейль';

  @override
  String get drink_bcaa => 'BCAA напиток';

  @override
  String get drink_energy => 'Энергетик';

  @override
  String get drink_milk => 'Молоко';

  @override
  String get drink_kefir => 'Кефир';

  @override
  String get drink_yogurt => 'Йогурт питьевой';

  @override
  String get drink_almond_milk => 'Миндальное молоко';

  @override
  String get drink_soy_milk => 'Соевое молоко';

  @override
  String get drink_oat_milk => 'Овсяное молоко';

  @override
  String get drink_beer_light => 'Легкое пиво';

  @override
  String get drink_beer_regular => 'Обычное пиво';

  @override
  String get drink_beer_strong => 'Крепкое пиво';

  @override
  String get drink_wine_red => 'Красное вино';

  @override
  String get drink_wine_white => 'Белое вино';

  @override
  String get drink_champagne => 'Шампанское';

  @override
  String get drink_vodka => 'Водка';

  @override
  String get drink_whiskey => 'Виски';

  @override
  String get drink_rum => 'Ром';

  @override
  String get drink_gin => 'Джин';

  @override
  String get drink_tequila => 'Текила';

  @override
  String get drink_mojito => 'Мохито';

  @override
  String get drink_margarita => 'Маргарита';

  @override
  String get drink_kombucha => 'Комбуча';

  @override
  String get drink_kvass => 'Квас';

  @override
  String get drink_bone_broth => 'Костный бульон';

  @override
  String get drink_vegetable_broth => 'Овощной бульон';

  @override
  String get drink_soda => 'Газировка';

  @override
  String get drink_diet_soda => 'Диетическая газировка';

  @override
  String get addedToFavorites => 'Добавлено в избранное';

  @override
  String get favoriteLimitReached =>
      'Достигнут лимит избранного (3 для FREE, 20 для PRO)';

  @override
  String get addFavorite => 'Добавить избранное';

  @override
  String get hotAndSupplements => 'Горячее и добавки';

  @override
  String get quickVolumes => 'Быстрые объемы:';

  @override
  String get type => 'Тип:';

  @override
  String get regular => 'Обычная';

  @override
  String get coconut => 'Кокосовая';

  @override
  String get sparkling => 'Газированная';

  @override
  String get mineral => 'Минеральная';

  @override
  String get hotDrinks => 'Горячие напитки';

  @override
  String get supplements => 'Добавки';

  @override
  String get tea => 'Чай';

  @override
  String get salt => 'Соль (1/4 ч.л.)';

  @override
  String get electrolyteMix => 'Электролитная смесь';

  @override
  String get boneBroth => 'Костный бульон';

  @override
  String get favoriteAssignmentComingSoon =>
      'Назначение избранного скоро будет доступно';

  @override
  String get longPressToEditComingSoon =>
      'Долгое нажатие для редактирования - скоро';

  @override
  String get proSubscriptionRequired => 'Требуется подписка PRO';

  @override
  String get saveToFavorites => 'Сохранить в избранное';

  @override
  String get savedToFavorites => 'Сохранено в избранное';

  @override
  String get selectFavoriteSlot => 'Выберите слот избранного';

  @override
  String get slot => 'Слот';

  @override
  String get emptySlot => 'Пустой слот';

  @override
  String get upgradeToUnlock => 'Обновитесь до PRO для разблокировки';

  @override
  String get changeFavorite => 'Изменить избранное';

  @override
  String get removeFavorite => 'Удалить из избранного';

  @override
  String get ok => 'ОК';

  @override
  String get mineralWater => 'Минеральная вода';

  @override
  String get coconutWater => 'Кокосовая вода';

  @override
  String get lemonWater => 'Вода с лимоном';

  @override
  String get greenTea => 'Зеленый чай';

  @override
  String get amount => 'Количество';

  @override
  String get createFavoriteHint =>
      'Чтобы добавить избранное, перейдите в любой экран напитка ниже и нажмите кнопку \'Сохранить в избранное\' после настройки напитка.';

  @override
  String get sparklingWater => 'Газированная вода';

  @override
  String get cola => 'Кола';

  @override
  String get juice => 'Сок';

  @override
  String get energyDrink => 'Энергетик';

  @override
  String get sportsDrink => 'Спортивный напиток';

  @override
  String get selectElectrolyteType => 'Выберите тип электролита:';

  @override
  String get saltQuarterTsp => 'Соль (1/4 ч.л.)';

  @override
  String get pinkSalt => 'Розовая гималайская соль';

  @override
  String get seaSalt => 'Морская соль';

  @override
  String get potassiumCitrate => 'Цитрат калия';

  @override
  String get magnesiumGlycinate => 'Глицинат магния';

  @override
  String get coconutWaterElectrolyte => 'Кокосовая вода';

  @override
  String get sportsDrinkElectrolyte => 'Спортивный напиток';

  @override
  String get electrolyteContent => 'Содержание электролитов:';

  @override
  String sodiumContent(int amount) {
    return 'Натрий: $amount мг';
  }

  @override
  String potassiumContent(int amount) {
    return 'Калий: $amount мг';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Магний: $amount мг';
  }

  @override
  String get servings => 'Порции';

  @override
  String get enterServings => 'Введите количество порций';

  @override
  String get servingsUnit => 'порций';

  @override
  String get noElectrolytes => 'Нет электролитов';

  @override
  String get enterValidAmount => 'Введите корректное количество';

  @override
  String get lmntMix => 'LMNT Микс';

  @override
  String get pickleJuice => 'Огуречный рассол';

  @override
  String get tomatoSalt => 'Томатный сок + соль';

  @override
  String get ketorade => 'Кеторейд';

  @override
  String get alkalineWater => 'Щелочная вода';

  @override
  String get celticSalt => 'Кельтская соль';

  @override
  String get soleWater => 'Соляной раствор';

  @override
  String get mineralDrops => 'Минеральные капли';

  @override
  String get bakingSoda => 'Содовая вода';

  @override
  String get creamTartar => 'Винный камень';

  @override
  String get selectSupplementType => 'Выберите тип добавки:';

  @override
  String get multivitamin => 'Мультивитамины';

  @override
  String get magnesiumCitrate => 'Цитрат магния';

  @override
  String get magnesiumThreonate => 'L-треонат магния';

  @override
  String get calciumCitrate => 'Цитрат кальция';

  @override
  String get zincGlycinate => 'Глицинат цинка';

  @override
  String get vitaminD3 => 'Витамин D3';

  @override
  String get vitaminC => 'Витамин C';

  @override
  String get bComplex => 'B-комплекс';

  @override
  String get omega3 => 'Омега-3';

  @override
  String get ironBisglycinate => 'Бисглицинат железа';

  @override
  String get dosage => 'Дозировка';

  @override
  String get enterDosage => 'Введите дозировку';

  @override
  String get noElectrolyteContent => 'Нет электролитов';

  @override
  String get blackTea => 'Черный чай';

  @override
  String get herbalTea => 'Травяной чай';

  @override
  String get espresso => 'Эспрессо';

  @override
  String get cappuccino => 'Капучино';

  @override
  String get latte => 'Латте';

  @override
  String get matcha => 'Матча';

  @override
  String get hotChocolate => 'Горячий шоколад';

  @override
  String get caffeine => 'Кофеин';

  @override
  String get sports => 'Спорт';

  @override
  String get walking => 'Ходьба';

  @override
  String get running => 'Бег';

  @override
  String get gym => 'Тренажерный зал';

  @override
  String get cycling => 'Велосипед';

  @override
  String get swimming => 'Плавание';

  @override
  String get yoga => 'Йога';

  @override
  String get hiit => 'ВИИТ';

  @override
  String get crossfit => 'Кроссфит';

  @override
  String get boxing => 'Бокс';

  @override
  String get dancing => 'Танцы';

  @override
  String get tennis => 'Теннис';

  @override
  String get teamSports => 'Командный спорт';

  @override
  String get selectActivityType => 'Выберите тип активности:';

  @override
  String get duration => 'Длительность';

  @override
  String get minutes => 'минут';

  @override
  String get enterDuration => 'Введите длительность';

  @override
  String get lowIntensity => 'Низкая интенсивность';

  @override
  String get mediumIntensity => 'Средняя интенсивность';

  @override
  String get highIntensity => 'Высокая интенсивность';

  @override
  String get recommendedIntake => 'Рекомендуемый прием:';

  @override
  String get basedOnWeight => 'На основе веса';

  @override
  String get logActivity => 'Записать активность';

  @override
  String get activityLogged => 'Активность записана';

  @override
  String get enterValidDuration => 'Введите корректную длительность';

  @override
  String get sauna => 'Сауна';

  @override
  String get veryHighIntensity => 'Очень высокая интенсивность';

  @override
  String get hriStatusExcellent => 'Отлично';

  @override
  String get hriStatusGood => 'Хорошо';

  @override
  String get hriStatusModerate => 'Умеренный риск';

  @override
  String get hriStatusHighRisk => 'Высокий риск';

  @override
  String get hriStatusCritical => 'Критично';

  @override
  String get hriComponentWater => 'Баланс воды';

  @override
  String get hriComponentSodium => 'Уровень натрия';

  @override
  String get hriComponentPotassium => 'Уровень калия';

  @override
  String get hriComponentMagnesium => 'Уровень магния';

  @override
  String get hriComponentHeat => 'Тепловой стресс';

  @override
  String get hriComponentWorkout => 'Физическая активность';

  @override
  String get hriComponentCaffeine => 'Влияние кофеина';

  @override
  String get hriComponentAlcohol => 'Влияние алкоголя';

  @override
  String get hriComponentTime => 'Время с последнего приёма';

  @override
  String get hriComponentMorning => 'Утренние факторы';

  @override
  String get hriBreakdownTitle => 'Разбор факторов риска';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max баллов';
  }

  @override
  String get fastingModeActive => 'Режим поста активен';

  @override
  String get fastingSuppressionNote => 'Фактор времени подавлен во время поста';

  @override
  String get morningCheckInTitle => 'Утренний чек-ин';

  @override
  String get howAreYouFeeling => 'Как вы себя чувствуете?';

  @override
  String get feelingScale1 => 'Плохо';

  @override
  String get feelingScale2 => 'Ниже среднего';

  @override
  String get feelingScale3 => 'Нормально';

  @override
  String get feelingScale4 => 'Хорошо';

  @override
  String get feelingScale5 => 'Отлично';

  @override
  String get weightChange => 'Изменение веса со вчера';

  @override
  String get urineColorScale => 'Цвет мочи (шкала 1-8)';

  @override
  String get urineColor1 => '1 - Очень бледный';

  @override
  String get urineColor2 => '2 - Бледный';

  @override
  String get urineColor3 => '3 - Светло-жёлтый';

  @override
  String get urineColor4 => '4 - Жёлтый';

  @override
  String get urineColor5 => '5 - Тёмно-жёлтый';

  @override
  String get urineColor6 => '6 - Янтарный';

  @override
  String get urineColor7 => '7 - Тёмно-янтарный';

  @override
  String get urineColor8 => '8 - Коричневый';

  @override
  String get alcoholWithDecay => 'Влияние алкоголя (затухающее)';

  @override
  String standardDrinksToday(Object count) {
    return 'Стандартных дринков сегодня: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Активный кофеин: $amount мг';
  }

  @override
  String get hriDebugInfo => 'Отладка HRI';

  @override
  String hriNormalized(Object value) {
    return 'HRI (нормализован): $value/100';
  }

  @override
  String get fastingWindowActive => 'Окно поста активно';

  @override
  String get eatingWindowActive => 'Окно питания активно';

  @override
  String nextFastingWindow(Object time) {
    return 'Следующий пост: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Следующий приём пищи: $time';
  }

  @override
  String get todaysWorkouts => 'Тренировки сегодня';

  @override
  String get hoursAgo => 'ч назад';

  @override
  String get onboardingWelcomeTitle =>
      'HydraCoach — умная гидратация каждый день';

  @override
  String get onboardingWelcomeSubtitle =>
      'Пей умнее, а не больше\nПриложение учитывает погоду, электролиты и твои привычки\nПомогает держать ясную голову и стабильную энергию';

  @override
  String get onboardingBullet1 =>
      'Индивидуальная норма воды и солей по погоде и тебе';

  @override
  String get onboardingBullet2 =>
      'Подсказки «что делать сейчас» вместо голых графиков';

  @override
  String get onboardingBullet3 =>
      'Алкоголь в стандартных дозах с безопасными лимитами';

  @override
  String get onboardingBullet4 => 'Умные напоминания без спама';

  @override
  String get onboardingStartButton => 'Начать';

  @override
  String get onboardingHaveAccount => 'У меня уже есть аккаунт';

  @override
  String get onboardingPracticeFasting => 'Я практикую интервальное голодание';

  @override
  String get onboardingPracticeFastingDesc =>
      'Особый режим электролитов для окон поста';

  @override
  String get onboardingProfileReady => 'Профиль готов!';

  @override
  String get onboardingWaterNorm => 'Норма воды';

  @override
  String get onboardingIonWillHelp => 'ION поможет держать баланс каждый день';

  @override
  String get onboardingContinue => 'Продолжить';

  @override
  String get onboardingLocationTitle => 'Погода важна для гидратации';

  @override
  String get onboardingLocationSubtitle =>
      'Учтём погоду и влажность. Это точнее чем просто формула по весу';

  @override
  String get onboardingWeatherExample => 'Сегодня жарко! +15% воды';

  @override
  String get onboardingWeatherExampleDesc => '+500 мг натрия на жару';

  @override
  String get onboardingEnablePermission => 'Включить';

  @override
  String get onboardingEnableLater => 'Включить позже';

  @override
  String get onboardingNotificationTitle => 'Умные напоминания';

  @override
  String get onboardingNotificationSubtitle =>
      'Короткие подсказки в нужный момент. Можно менять частоту в один тап';

  @override
  String get onboardingNotifExample1 => 'Время пить воду';

  @override
  String get onboardingNotifExample2 => 'Не забудь электролиты';

  @override
  String get onboardingNotifExample3 => 'Жарко! Пей больше воды';

  @override
  String get sportRecoveryProtocols => 'Протоколы восстановления после спорта';

  @override
  String get allDrinksAndSupplements => 'Все напитки и добавки';

  @override
  String get notificationChannelDefault => 'Напоминания о гидратации';

  @override
  String get notificationChannelDefaultDesc =>
      'Напоминания о воде и электролитах';

  @override
  String get notificationChannelUrgent => 'Важные уведомления';

  @override
  String get notificationChannelUrgentDesc =>
      'Предупреждения о жаре и критических состояниях';

  @override
  String get notificationChannelReport => 'Отчеты';

  @override
  String get notificationChannelReportDesc => 'Дневные и недельные отчеты';

  @override
  String get notificationWaterTitle => '💧 Время гидратации';

  @override
  String get notificationWaterBody => 'Не забудьте выпить воды';

  @override
  String get notificationPostCoffeeTitle => '☕ После кофе';

  @override
  String get notificationPostCoffeeBody =>
      'Выпейте 250-300 мл воды для восстановления баланса';

  @override
  String get notificationDailyReportTitle => '📊 Дневной отчет готов';

  @override
  String get notificationDailyReportBody =>
      'Посмотрите, как прошел ваш день гидратации';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Время восстановления';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return 'Выпейте $ml мл воды с щепоткой соли';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Предупреждение о жаре';

  @override
  String get notificationHeatWarningExtremeBody =>
      'Экстремальная жара! +15% воды и +1г соли';

  @override
  String get notificationHeatWarningHotBody => 'Жарко! +10% воды и электролиты';

  @override
  String get notificationHeatWarningWarmBody => 'Тепло. Следите за гидратацией';

  @override
  String get notificationWorkoutTitle => '💪 Тренировка';

  @override
  String get notificationWorkoutBody => 'Не забудьте воду и электролиты';

  @override
  String get notificationPostWorkoutTitle => '💪 После тренировки';

  @override
  String get notificationPostWorkoutBody =>
      '500 мл воды + электролиты для восстановления';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Время электролитов';

  @override
  String get notificationFastingElectrolyteBody =>
      'Добавьте щепотку соли в воду или выпейте бульон';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Восстановление $hoursч';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return 'Выпейте $ml мл воды';
  }

  @override
  String get notificationAlcoholRecoveryMidBody =>
      'Добавьте электролиты: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Завтра утром - контрольный чек-ин';

  @override
  String get notificationMorningCheckInTitle => '☀️ Утренний чек-ин';

  @override
  String get notificationMorningCheckInBody =>
      'Как самочувствие? Оцените состояние и получите план на день';

  @override
  String get notificationMorningWaterBody => 'Начните день со стакана воды';

  @override
  String notificationLowProgressBody(int percent) {
    return 'Вы выпили только $percent% нормы. Время наверстать!';
  }

  @override
  String get notificationGoodProgressBody => 'Отличный прогресс! Продолжайте';

  @override
  String get notificationMaintainBalanceBody => 'Поддерживайте водный баланс';

  @override
  String get notificationTestTitle => '🧪 Тест уведомления';

  @override
  String get notificationTestBody =>
      'Если вы видите это - уведомления работают!';

  @override
  String get notificationTestScheduledTitle => '⏰ Запланированный тест';

  @override
  String get notificationTestScheduledBody =>
      'Это уведомление было запланировано минуту назад';

  @override
  String get onboardingUnitsTitle => 'Выберите единицы измерения';

  @override
  String get onboardingUnitsSubtitle => 'Это нельзя будет изменить позже';

  @override
  String get onboardingUnitsWarning =>
      'Этот выбор окончательный и не может быть изменен позже';

  @override
  String get oz => 'унц';

  @override
  String get fl_oz => 'жид. унц';

  @override
  String get gallons => 'галлонов';

  @override
  String get lb => 'фунт';

  @override
  String get target => 'Цель';

  @override
  String get wind => 'Ветер';

  @override
  String get pressure => 'Давление';

  @override
  String get highHeatIndexWarning =>
      'Высокий тепловой индекс! Увеличьте потребление воды';

  @override
  String get weatherCondition => 'Погода';

  @override
  String get feelsLike => 'Ощущается';

  @override
  String get humidityLabel => 'Влажность';

  @override
  String get waterNormal => 'Норма';

  @override
  String get sodiumNormal => 'Стандарт';

  @override
  String get addedSuccessfully => 'Успешно добавлено';

  @override
  String get sugarIntake => 'Потребление сахара';

  @override
  String get sugarToday => 'Сахар сегодня';

  @override
  String get totalSugar => 'Всего сахара';

  @override
  String get dailyLimit => 'Дневной лимит';

  @override
  String get addedSugar => 'Добавленный сахар';

  @override
  String get naturalSugar => 'Натуральный сахар';

  @override
  String get hiddenSugar => 'Скрытый сахар';

  @override
  String get sugarFromDrinks => 'Drinks';

  @override
  String get sugarFromFood => 'Food';

  @override
  String get sugarFromSnacks => 'Snacks';

  @override
  String get sugarNormal => 'Норма';

  @override
  String get sugarModerate => 'Умеренно';

  @override
  String get sugarHigh => 'Высокое';

  @override
  String get sugarCritical => 'Критическое';

  @override
  String get sugarRecommendationNormal =>
      'Отлично! Потребление сахара в здоровых пределах';

  @override
  String get sugarRecommendationModerate =>
      'Стоит уменьшить сладкие напитки и перекусы';

  @override
  String get sugarRecommendationHigh =>
      'Высокое потребление сахара! Ограничьте сладкие напитки и десерты';

  @override
  String get sugarRecommendationCritical =>
      'Очень много сахара! Избегайте сладких напитков и сладостей сегодня';

  @override
  String get noSugarIntake => 'Сахар сегодня не отслеживался';

  @override
  String get hriImpact => 'Влияние на HRI';

  @override
  String get hri_component_sugar => 'Sugar';

  @override
  String get hri_sugar_description =>
      'High sugar intake affects hydration and overall health';

  @override
  String get tip_reduce_sweet_drinks =>
      'Replace sweet drinks with water or unsweetened tea';

  @override
  String get tip_avoid_added_sugar =>
      'Check labels and avoid products with added sugars';

  @override
  String get tip_check_labels =>
      'Be aware of hidden sugars in sauces and processed foods';

  @override
  String get tip_replace_soda => 'Replace soda with sparkling water and lemon';

  @override
  String get sugarSources => 'Источники сахара';

  @override
  String get drinks => 'Напитки';

  @override
  String get food => 'Еда';

  @override
  String get snacks => 'Перекусы';

  @override
  String get recommendedLimit => 'Рекомендуемый';

  @override
  String get points => 'баллов';

  @override
  String get drinkLightBeer => 'Светлое пиво';

  @override
  String get drinkLager => 'Лагер';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'Стаут';

  @override
  String get drinkWheatBeer => 'Пшеничное пиво';

  @override
  String get drinkCraftBeer => 'Крафтовое пиво';

  @override
  String get drinkNonAlcoholic => 'Безалкогольное';

  @override
  String get drinkRadler => 'Радлер';

  @override
  String get drinkPilsner => 'Пилснер';

  @override
  String get drinkRedWine => 'Красное вино';

  @override
  String get drinkWhiteWine => 'Белое вино';

  @override
  String get drinkProsecco => 'Просекко';

  @override
  String get drinkPort => 'Портвейн';

  @override
  String get drinkRose => 'Розе';

  @override
  String get drinkDessertWine => 'Десертное вино';

  @override
  String get drinkSangria => 'Сангрия';

  @override
  String get drinkSherry => 'Херес';

  @override
  String get drinkVodkaShot => 'Рюмка водки';

  @override
  String get drinkCognac => 'Коньяк';

  @override
  String get drinkLiqueur => 'Ликёр';

  @override
  String get drinkAbsinthe => 'Абсент';

  @override
  String get drinkBrandy => 'Бренди';

  @override
  String get drinkLongIsland => 'Лонг Айленд';

  @override
  String get drinkGinTonic => 'Джин-тоник';

  @override
  String get drinkPinaColada => 'Пина Колада';

  @override
  String get drinkCosmopolitan => 'Космополитен';

  @override
  String get drinkMaiTai => 'Май Тай';

  @override
  String get drinkBloodyMary => 'Кровавая Мэри';

  @override
  String get drinkDaiquiri => 'Дайкири';

  @override
  String popularDrinks(Object type) {
    return 'Популярные $type';
  }

  @override
  String get standardDrinksUnit => 'СД';

  @override
  String get gramsSugar => 'г сахара';

  @override
  String get moderateConsumption => 'Умеренное потребление';

  @override
  String get aboveRecommendations => 'Выше рекомендаций';

  @override
  String get highConsumption => 'Высокое потребление';

  @override
  String get veryHighConsider => 'Очень высокое - стоит остановиться';

  @override
  String get noAlcoholToday => 'Сегодня без алкоголя';

  @override
  String get drinkWaterNow => 'Выпейте 300-500 мл воды сейчас';

  @override
  String get addPinchSalt => 'Добавьте щепотку соли';

  @override
  String get avoidLateCoffee => 'Избегайте позднего кофе';

  @override
  String abvPercent(Object percent) {
    return '$percent% алк.';
  }

  @override
  String get todaysElectrolytes => 'Электролиты сегодня';

  @override
  String get greatBalance => 'Отличный баланс!';

  @override
  String get gettingThere => 'Уже близко';

  @override
  String get needMoreElectrolytes => 'Нужно больше электролитов';

  @override
  String get lowElectrolyteLevels => 'Низкий уровень электролитов';

  @override
  String get electrolyteTips => 'Советы по электролитам';

  @override
  String get takeWithWater => 'Принимайте с большим количеством воды';

  @override
  String get bestBetweenMeals => 'Лучше усваивается между приемами пищи';

  @override
  String get startSmallAmounts => 'Начинайте с малых доз';

  @override
  String get extraDuringExercise => 'Больше нужно при нагрузках';

  @override
  String get electrolytesBasic => 'Базовые';

  @override
  String get electrolytesMixes => 'Смеси';

  @override
  String get electrolytesPills => 'Таблетки';

  @override
  String get popularSalts => 'Популярные соли и бульоны';

  @override
  String get popularMixes => 'Популярные электролитные смеси';

  @override
  String get popularSupplements => 'Популярные добавки';

  @override
  String get electrolyteSaltWater => 'Соленая вода';

  @override
  String get electrolytePinkSalt => 'Розовая соль';

  @override
  String get electrolyteSeaSalt => 'Морская соль';

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
  String get electrolytePotassiumChloride => 'Хлорид калия';

  @override
  String get electrolyteMagThreonate => 'Треонат магния';

  @override
  String get electrolyteTraceMinerals => 'Микроэлементы';

  @override
  String get electrolyteZMAComplex => 'ZMA комплекс';

  @override
  String get electrolyteMultiMineral => 'Мультиминералы';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => 'Гидратация';

  @override
  String get todayHydration => 'Гидратация сегодня';

  @override
  String get currentIntake => 'Выпито';

  @override
  String get dailyGoal => 'Цель';

  @override
  String get toGo => 'Осталось';

  @override
  String get goalReached => 'Цель достигнута!';

  @override
  String get almostThere => 'Почти у цели!';

  @override
  String get halfwayThere => 'Половина пути';

  @override
  String get keepGoing => 'Продолжайте';

  @override
  String get startDrinking => 'Начните пить';

  @override
  String get plainWater => 'Обычная';

  @override
  String get enhancedWater => 'Улучшенная';

  @override
  String get beverages => 'Напитки';

  @override
  String get sodas => 'Газировки';

  @override
  String get popularPlainWater => 'Популярные виды воды';

  @override
  String get popularEnhancedWater => 'Вода с добавками';

  @override
  String get popularBeverages => 'Популярные напитки';

  @override
  String get popularSodas => 'Газировки и энергетики';

  @override
  String get hydrationTips => 'Советы по гидратации';

  @override
  String get drinkRegularly => 'Пейте понемногу регулярно';

  @override
  String get roomTemperature => 'Вода комнатной температуры усваивается лучше';

  @override
  String get addLemon => 'Добавьте лимон для вкуса';

  @override
  String get limitSugary => 'Ограничьте сладкие напитки - они обезвоживают';

  @override
  String get warmWater => 'Теплая вода';

  @override
  String get iceWater => 'Ледяная вода';

  @override
  String get filteredWater => 'Фильтрованная вода';

  @override
  String get distilledWater => 'Дистиллированная вода';

  @override
  String get springWater => 'Родниковая вода';

  @override
  String get hydrogenWater => 'Водородная вода';

  @override
  String get oxygenatedWater => 'Кислородная вода';

  @override
  String get cucumberWater => 'Огуречная вода';

  @override
  String get limeWater => 'Лаймовая вода';

  @override
  String get berryWater => 'Ягодная вода';

  @override
  String get mintWater => 'Мятная вода';

  @override
  String get gingerWater => 'Имбирная вода';

  @override
  String get caffeineStatusNone => 'Кофеина сегодня нет';

  @override
  String caffeineStatusModerate(Object amount) {
    return 'Умеренно: $amountмг';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return 'Много: $amountмг';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return 'Очень много: $amountмг!';
  }

  @override
  String get caffeineDailyLimit => 'Дневной лимит: 400мг';

  @override
  String get caffeineWarningTitle => 'Предупреждение о кофеине';

  @override
  String get caffeineWarning400 => 'Вы превысили 400мг кофеина сегодня';

  @override
  String get caffeineTipWater => 'Пейте больше воды для компенсации';

  @override
  String get caffeineTipAvoid => 'Избегайте кофеина сегодня';

  @override
  String get caffeineTipSleep => 'Может повлиять на качество сна';

  @override
  String get total => 'всего';

  @override
  String get cupsToday => 'Чашек сегодня';

  @override
  String get metabolizeTime => 'Время метаболизма';

  @override
  String get aboutCaffeine => 'О кофеине';

  @override
  String get caffeineInfo1 =>
      'Кофе содержит натуральный кофеин, повышающий бодрость';

  @override
  String get caffeineInfo2 => 'Безопасная суточная норма для взрослых — 400 мг';

  @override
  String get caffeineInfo3 => 'Период полураспада кофеина — 5-6 часов';

  @override
  String get caffeineInfo4 =>
      'Пейте больше воды для компенсации мочегонного эффекта';

  @override
  String get caffeineWarningPregnant =>
      'Беременным следует ограничить кофеин до 200 мг/день';

  @override
  String get gotIt => 'Понятно';

  @override
  String get consumed => 'Выпито';

  @override
  String get remaining => 'осталось';

  @override
  String get todaysCaffeine => 'Кофеин сегодня';

  @override
  String get alreadyInFavorites => 'Уже в избранном';

  @override
  String get ofRecommendedLimit => 'от рекомендуемого лимита';

  @override
  String get aboutAlcohol => 'Об алкоголе';

  @override
  String get alcoholInfo1 =>
      'Один стандартный напиток равен 10г чистого спирта';

  @override
  String get alcoholInfo2 =>
      'Алкоголь обезвоживает — выпейте 250мл воды на каждый напиток';

  @override
  String get alcoholInfo3 =>
      'Добавьте соль, чтобы удержать жидкость после алкоголя';

  @override
  String get alcoholInfo4 =>
      'Каждый стандартный напиток повышает HRI на 3-5 пунктов';

  @override
  String get alcoholWarningHealth =>
      'Чрезмерное употребление алкоголя вредит здоровью. Рекомендуемый лимит: 2 СН для мужчин и 1 СН для женщин в день.';

  @override
  String get supplementsInfo1 =>
      'Добавки помогают поддерживать баланс электролитов';

  @override
  String get supplementsInfo2 => 'Лучше принимать во время еды для усвоения';

  @override
  String get supplementsInfo3 => 'Всегда запивайте большим количеством воды';

  @override
  String get supplementsInfo4 => 'Магний и калий ключевые для гидратации';

  @override
  String get supplementsWarning =>
      'Проконсультируйтесь с врачом перед началом приема добавок';

  @override
  String get fromSupplementsToday => 'Из добавок сегодня';

  @override
  String get minerals => 'Минералы';

  @override
  String get vitamins => 'Витамины';

  @override
  String get essentialMinerals => 'Основные минералы';

  @override
  String get otherSupplements => 'Другие добавки';

  @override
  String get supplementTip1 => 'Принимайте добавки с едой для лучшего усвоения';

  @override
  String get supplementTip2 => 'Пейте много воды с добавками';

  @override
  String get supplementTip3 => 'Распределяйте прием добавок в течение дня';

  @override
  String get supplementTip4 => 'Отслеживайте что работает для вас';

  @override
  String get calciumCarbonate => 'Карбонат кальция';

  @override
  String get traceMinerals => 'Микроэлементы';

  @override
  String get vitaminA => 'Витамин А';

  @override
  String get vitaminE => 'Витамин Е';

  @override
  String get vitaminK2 => 'Витамин К2';

  @override
  String get folate => 'Фолат';

  @override
  String get biotin => 'Биотин';

  @override
  String get probiotics => 'Пробиотики';

  @override
  String get melatonin => 'Мелатонин';

  @override
  String get collagen => 'Коллаген';

  @override
  String get glucosamine => 'Глюкозамин';

  @override
  String get turmeric => 'Куркума';

  @override
  String get coq10 => 'Коэнзим Q10';

  @override
  String get creatine => 'Креатин';

  @override
  String get ashwagandha => 'Ашваганда';

  @override
  String get selectCardioActivity => 'Выберите кардио активность';

  @override
  String get selectStrengthActivity => 'Выберите силовую тренировку';

  @override
  String get selectSportsActivity => 'Выберите вид спорта';

  @override
  String get sessions => 'сессий';

  @override
  String get totalTime => 'Общее время';

  @override
  String get waterLoss => 'Потеря воды';

  @override
  String get intensity => 'Интенсивность';

  @override
  String get drinkWaterAfterWorkout => 'Пейте воду после тренировки';

  @override
  String get replenishElectrolytes => 'Восполните электролиты';

  @override
  String get restAndRecover => 'Отдыхайте и восстанавливайтесь';

  @override
  String get avoidSugaryDrinks => 'Избегайте сладких спортивных напитков';

  @override
  String get elliptical => 'Эллиптический тренажер';

  @override
  String get rowing => 'Гребля';

  @override
  String get jumpRope => 'Скакалка';

  @override
  String get stairClimbing => 'Подъем по лестнице';

  @override
  String get bodyweight => 'Собственный вес';

  @override
  String get powerlifting => 'Пауэрлифтинг';

  @override
  String get calisthenics => 'Калистеника';

  @override
  String get resistanceBands => 'Резиновые ленты';

  @override
  String get kettlebell => 'Гири';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'Силовой экстрим';

  @override
  String get pilates => 'Пилатес';

  @override
  String get basketball => 'Баскетбол';

  @override
  String get soccerFootball => 'Футбол';

  @override
  String get golf => 'Гольф';

  @override
  String get martialArts => 'Боевые искусства';

  @override
  String get rockClimbing => 'Скалолазание';

  @override
  String get needsToReplenish => 'Необходимо восполнить';

  @override
  String get electrolyteTrackingPro =>
      'Отслеживайте цели натрия, калия и магния с детальными индикаторами';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get weather => 'Погода';

  @override
  String get weatherTrackingPro =>
      'Отслеживайте индекс жары, влажность и влияние погоды на цели гидратации';

  @override
  String get sugarTracking => 'Отслеживание сахара';

  @override
  String get sugarTrackingPro =>
      'Контролируйте натуральный, добавленный и скрытый сахар с анализом влияния на HRI';

  @override
  String get dayOverview => 'Обзор дня';

  @override
  String get tapForDetails => 'Нажмите для подробностей';

  @override
  String get noDataForDay => 'Нет данных за этот день';

  @override
  String get sweatLoss => 'потеря пота';

  @override
  String get cardio => 'Кардио';

  @override
  String get workout => 'Тренировка';

  @override
  String get noWaterToday => 'Вода не записана сегодня';

  @override
  String get noElectrolytesToday => 'Электролиты не записаны сегодня';

  @override
  String get noCoffeeToday => 'Кофе не записан сегодня';

  @override
  String get noWorkoutsToday => 'Тренировки не записаны сегодня';

  @override
  String get noWaterThisDay => 'Вода не записана в этот день';

  @override
  String get noElectrolytesThisDay => 'Электролиты не записаны в этот день';

  @override
  String get noCoffeeThisDay => 'Кофе не записан в этот день';

  @override
  String get noWorkoutsThisDay => 'Тренировки не записаны в этот день';

  @override
  String get weeklyReport => 'Недельный отчет';

  @override
  String get weeklyReportSubtitle => 'Глубокая аналитика и анализ трендов';

  @override
  String get workouts => 'Тренировки';

  @override
  String get workoutHydration => 'Гидратация в тренировки';

  @override
  String workoutHydrationMessage(Object percent) {
    return 'В дни тренировок вы пьете на $percent% больше воды';
  }

  @override
  String get weeklyActivity => 'Недельная активность';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return 'Вы тренировались $minutes минут за $days дней';
  }

  @override
  String get workoutMinutesPerDay => 'Минут тренировок в день';

  @override
  String get daysWithWorkouts => 'дней с тренировками';

  @override
  String get noWorkoutsThisWeek => 'Нет тренировок на этой неделе';

  @override
  String get noAlcoholThisWeek => 'Нет алкоголя на этой неделе';

  @override
  String get csvExported => 'Данные экспортированы в CSV';

  @override
  String get mondayShort => 'ПН';

  @override
  String get tuesdayShort => 'ВТ';

  @override
  String get wednesdayShort => 'СР';

  @override
  String get thursdayShort => 'ЧТ';

  @override
  String get fridayShort => 'ПТ';

  @override
  String get saturdayShort => 'СБ';

  @override
  String get sundayShort => 'ВС';

  @override
  String get achievements => 'Достижения';

  @override
  String get achievementsTabAll => 'Все';

  @override
  String get achievementsTabHydration => 'Гидратация';

  @override
  String get achievementsTabElectrolytes => 'Электролиты';

  @override
  String get achievementsTabSugar => 'Контроль сахара';

  @override
  String get achievementsTabAlcohol => 'Алкоголь';

  @override
  String get achievementsTabWorkout => 'Фитнес';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => 'Серии';

  @override
  String get achievementsTabSpecial => 'Особые';

  @override
  String get achievementUnlocked => 'Достижение разблокировано!';

  @override
  String get achievementProgress => 'Прогресс';

  @override
  String get achievementPoints => 'очков';

  @override
  String get achievementRarityCommon => 'Обычное';

  @override
  String get achievementRarityUncommon => 'Необычное';

  @override
  String get achievementRarityRare => 'Редкое';

  @override
  String get achievementRarityEpic => 'Эпичное';

  @override
  String get achievementRarityLegendary => 'Легендарное';

  @override
  String get achievementStatsUnlocked => 'Открыто';

  @override
  String get achievementStatsTotal => 'Всего очков';

  @override
  String get achievementFilterAll => 'Все';

  @override
  String get achievementFilterUnlocked => 'Открытые';

  @override
  String get achievementSortProgress => 'Прогресс';

  @override
  String get achievementSortName => 'Название';

  @override
  String get achievementSortRarity => 'Редкость';

  @override
  String get achievementNoAchievements => 'Достижений пока нет';

  @override
  String get achievementKeepUsing =>
      'Продолжайте использовать приложение для разблокировки достижений!';

  @override
  String get achievementFirstGlass => 'Первая капля';

  @override
  String get achievementFirstGlassDesc => 'Выпейте свой первый стакан воды';

  @override
  String get achievementHydrationGoal1 => 'Увлажнен';

  @override
  String get achievementHydrationGoal1Desc => 'Достигните дневной цели по воде';

  @override
  String get achievementHydrationGoal7 => 'Неделя гидратации';

  @override
  String get achievementHydrationGoal7Desc =>
      'Достигайте цели по воде 7 дней подряд';

  @override
  String get achievementHydrationGoal30 => 'Мастер гидратации';

  @override
  String get achievementHydrationGoal30Desc =>
      'Достигайте цели по воде 30 дней подряд';

  @override
  String get achievementPerfectHydration => 'Идеальный баланс';

  @override
  String get achievementPerfectHydrationDesc =>
      'Достигните 90-110% от цели по воде';

  @override
  String get achievementEarlyBird => 'Ранняя пташка';

  @override
  String get achievementEarlyBirdDesc => 'Выпейте первую воду до 9 утра';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return 'Выпейте $volume до 9 утра';
  }

  @override
  String get achievementNightOwl => 'Ночная сова';

  @override
  String get achievementNightOwlDesc => 'Выполните цель гидратации до 18:00';

  @override
  String get achievementLiterLegend => 'Легенда литров';

  @override
  String get achievementLiterLegendDesc => 'Достигните общей цели гидратации';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return 'Выпейте $volume всего';
  }

  @override
  String get achievementSaltStarter => 'Новичок в соли';

  @override
  String get achievementSaltStarterDesc => 'Добавьте первые электролиты';

  @override
  String get achievementElectrolyteBalance => 'Сбалансированный';

  @override
  String get achievementElectrolyteBalanceDesc =>
      'Достигните всех целей по электролитам за день';

  @override
  String get achievementSodiumMaster => 'Мастер натрия';

  @override
  String get achievementSodiumMasterDesc =>
      'Достигайте цели по натрию 7 дней подряд';

  @override
  String get achievementPotassiumPro => 'Про калий';

  @override
  String get achievementPotassiumProDesc =>
      'Достигайте цели по калию 7 дней подряд';

  @override
  String get achievementMagnesiumMaven => 'Эксперт магния';

  @override
  String get achievementMagnesiumMavenDesc =>
      'Достигайте цели по магнию 7 дней подряд';

  @override
  String get achievementElectrolyteExpert => 'Эксперт электролитов';

  @override
  String get achievementElectrolyteExpertDesc =>
      'Идеальный баланс электролитов 30 дней';

  @override
  String get achievementSugarAwareness => 'Осознание сахара';

  @override
  String get achievementSugarAwarenessDesc => 'Впервые отследите сахар';

  @override
  String get achievementSugarUnder25 => 'Сладкий контроль';

  @override
  String get achievementSugarUnder25Desc =>
      'Держите потребление сахара низким в течение дня';

  @override
  String achievementSugarUnder25Template(String weight) {
    return 'Держите сахар под $weight в день';
  }

  @override
  String get achievementSugarWeekControl => 'Сахарная дисциплина';

  @override
  String get achievementSugarWeekControlDesc =>
      'Поддерживайте низкое потребление сахара неделю';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return 'Держите сахар под $weight 7 дней';
  }

  @override
  String get achievementSugarFreeDay => 'Без сахара';

  @override
  String get achievementSugarFreeDayDesc =>
      'Проведите день с 0г добавленного сахара';

  @override
  String get achievementSugarDetective => 'Детектив сахара';

  @override
  String get achievementSugarDetectiveDesc => 'Отследите скрытые сахара 10 раз';

  @override
  String get achievementSugarMaster => 'Мастер сахара';

  @override
  String get achievementSugarMasterDesc =>
      'Поддерживайте очень низкое потребление сахара месяц';

  @override
  String get achievementNoSodaWeek => 'Неделя без газировки';

  @override
  String get achievementNoSodaWeekDesc => '7 дней без газированных напитков';

  @override
  String get achievementNoSodaMonth => 'Месяц без газировки';

  @override
  String get achievementNoSodaMonthDesc => '30 дней без газированных напитков';

  @override
  String get achievementSweetToothTamed => 'Приручен сладкоежка';

  @override
  String get achievementSweetToothTamedDesc =>
      'Уменьшите дневной сахар на 50% в течение недели';

  @override
  String get achievementAlcoholTracker => 'Осознанность';

  @override
  String get achievementAlcoholTrackerDesc => 'Отследите потребление алкоголя';

  @override
  String get achievementModerateDay => 'Умеренность';

  @override
  String get achievementModerateDayDesc => 'Оставайтесь под 2 СД в день';

  @override
  String get achievementSoberDay => 'Трезвый день';

  @override
  String get achievementSoberDayDesc => 'Проведите день без алкоголя';

  @override
  String get achievementSoberWeek => 'Трезвая неделя';

  @override
  String get achievementSoberWeekDesc => '7 дней без алкоголя';

  @override
  String get achievementSoberMonth => 'Трезвый месяц';

  @override
  String get achievementSoberMonthDesc => '30 дней без алкоголя';

  @override
  String get achievementRecoveryProtocol => 'Мастер восстановления';

  @override
  String get achievementRecoveryProtocolDesc =>
      'Выполните протокол восстановления после питья';

  @override
  String get achievementFirstWorkout => 'Начни движение';

  @override
  String get achievementFirstWorkoutDesc => 'Запишите свою первую тренировку';

  @override
  String get achievementWorkoutWeek => 'Активная неделя';

  @override
  String get achievementWorkoutWeekDesc => 'Тренируйтесь 3 раза в неделю';

  @override
  String get achievementCenturySweat => 'Столетний пот';

  @override
  String get achievementCenturySweatDesc =>
      'Потеряйте значительное количество жидкости через тренировки';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return 'Потеряйте $volume через тренировки';
  }

  @override
  String get achievementCardioKing => 'Король кардио';

  @override
  String get achievementCardioKingDesc => 'Выполните 10 кардио-сессий';

  @override
  String get achievementStrengthWarrior => 'Воин силы';

  @override
  String get achievementStrengthWarriorDesc => 'Выполните 10 силовых сессий';

  @override
  String get achievementHRIGreen => 'Зеленая зона';

  @override
  String get achievementHRIGreenDesc => 'Держите HRI в зеленой зоне день';

  @override
  String get achievementHRIWeekGreen => 'Безопасная неделя';

  @override
  String get achievementHRIWeekGreenDesc => 'Держите HRI в зеленой зоне 7 дней';

  @override
  String get achievementHRIPerfect => 'Идеальный счет';

  @override
  String get achievementHRIPerfectDesc => 'Достигните HRI ниже 20';

  @override
  String get achievementHRIRecovery => 'Быстрое восстановление';

  @override
  String get achievementHRIRecoveryDesc =>
      'Снизьте HRI с красного до зеленого за день';

  @override
  String get achievementHRIMaster => 'Мастер HRI';

  @override
  String get achievementHRIMasterDesc =>
      'Держите HRI ниже 30 в течение 30 дней';

  @override
  String get achievementStreak3 => 'Начинающий';

  @override
  String get achievementStreak3Desc => '3-дневная серия';

  @override
  String get achievementStreak7 => 'Воин недели';

  @override
  String get achievementStreak7Desc => '7-дневная серия';

  @override
  String get achievementStreak30 => 'Король постоянства';

  @override
  String get achievementStreak30Desc => '30-дневная серия';

  @override
  String get achievementStreak100 => 'Клуб столетия';

  @override
  String get achievementStreak100Desc => '100-дневная серия';

  @override
  String get achievementFirstWeek => 'Первая неделя';

  @override
  String get achievementFirstWeekDesc => 'Используйте приложение 7 дней';

  @override
  String get achievementProMember => 'PRO участник';

  @override
  String get achievementProMemberDesc => 'Станьте PRO подписчиком';

  @override
  String get achievementDataExport => 'Аналитик данных';

  @override
  String get achievementDataExportDesc => 'Экспортируйте данные в CSV';

  @override
  String get achievementAllCategories => 'Мастер на все руки';

  @override
  String get achievementAllCategoriesDesc =>
      'Разблокируйте хотя бы одно достижение в каждой категории';

  @override
  String get achievementHunter => 'Охотник за достижениями';

  @override
  String get achievementHunterDesc => 'Разблокируйте 50% всех достижений';

  @override
  String get achievementDetailsUnlockedOn => 'Разблокировано';

  @override
  String get achievementNewUnlocked => 'Новое достижение разблокировано!';

  @override
  String get achievementViewAll => 'Показать все достижения';

  @override
  String get achievementCloseNotification => 'Закрыть';

  @override
  String get before => 'до';

  @override
  String get after => 'после';

  @override
  String get lose => 'Потеряйте';

  @override
  String get through => 'через';

  @override
  String get throughWorkouts => 'через тренировки';

  @override
  String get reach => 'Достигните';

  @override
  String get daysInRow => 'дней подряд';

  @override
  String get completeHydrationGoal => 'Выполните цель гидратации';

  @override
  String get stayUnder => 'Оставайтесь под';

  @override
  String get inADay => 'в день';

  @override
  String get alcoholFree => 'без алкоголя';

  @override
  String get complete => 'Выполните';

  @override
  String get achieve => 'Достигните';

  @override
  String get keep => 'Держите';

  @override
  String get for30Days => '30 дней';

  @override
  String get liters => 'литров';

  @override
  String get completed => 'Выполнено';

  @override
  String get notCompleted => 'Не выполнено';

  @override
  String get days => 'дней';

  @override
  String get hours => 'часов';

  @override
  String get times => 'раз';

  @override
  String get row => 'подряд';

  @override
  String get ofTotal => 'из всего';

  @override
  String get perDay => 'в день';

  @override
  String get perWeek => 'в неделю';

  @override
  String get streak => 'серия';

  @override
  String get tapToDismiss => 'Нажмите чтобы закрыть';
}
