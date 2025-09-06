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
  String get january => 'января';

  @override
  String get february => 'февраля';

  @override
  String get march => 'марта';

  @override
  String get april => 'апреля';

  @override
  String get may => 'мая';

  @override
  String get june => 'июня';

  @override
  String get july => 'июля';

  @override
  String get august => 'августа';

  @override
  String get september => 'сентября';

  @override
  String get october => 'октября';

  @override
  String get november => 'ноября';

  @override
  String get december => 'декабря';

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
    return 'Влажность: $value%';
  }

  @override
  String get water => 'Вода';

  @override
  String get sodium => 'Натрий';

  @override
  String get potassium => 'Калий';

  @override
  String get magnesium => 'Магний';

  @override
  String get electrolyte => 'Электролит';

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
  String get smartAdviceTitle => 'Подсказка на сейчас';

  @override
  String get smartAdviceDefault => 'Поддерживайте баланс воды и электролитов.';

  @override
  String get adviceOverhydrationSevere => 'Перепивание воды (>200% цели)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Сделайте паузу 60–90 минут. Добавьте электролиты: 300–500 мл с 500–1000 мг натрия.';

  @override
  String get adviceOverhydration => 'Перепивание воды';

  @override
  String get adviceOverhydrationBody =>
      'Приостановите воду на 30–60 минут и добавьте ~500 мг натрия (электролит/бульон).';

  @override
  String get adviceAlcoholRecovery => 'Алкоголь: восстановление';

  @override
  String get adviceAlcoholRecoveryBody =>
      'Не пейте больше алкоголя сегодня. Пейте малыми порциями 300–500 мл воды и добавьте натрий.';

  @override
  String get adviceLowSodium => 'Мало натрия';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Добавьте ~$amount мг натрия. Пейте умеренно.';
  }

  @override
  String get adviceDehydration => 'Недобор воды';

  @override
  String adviceDehydrationBody(String type) {
    return 'Выпейте 300–500 мл $type.';
  }

  @override
  String get adviceHighRisk => 'Высокий риск (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Срочно выпейте воду с электролитами (300–500 мл) и снизьте нагрузку.';

  @override
  String get adviceHeat => 'Жара и потери';

  @override
  String get adviceHeatBody =>
      'Увеличьте воду на +5–8% и добавьте 300–500 мг натрия.';

  @override
  String get adviceAllGood => 'Всё по плану';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Держите ритм. Ориентир: ещё ~$amount мл до цели.';
  }

  @override
  String get hydrationStatus => 'Статус гидратации';

  @override
  String get hydrationStatusNormal => 'Норма';

  @override
  String get hydrationStatusDiluted => 'Разбавляешь';

  @override
  String get hydrationStatusDehydrated => 'Недобор воды';

  @override
  String get hydrationStatusLowSalt => 'Мало соли';

  @override
  String get hydrationRiskIndex => 'Hydration Risk Index';

  @override
  String get quickAdd => 'Быстрое добавление';

  @override
  String get add => 'Добавить';

  @override
  String get delete => 'Удалить';

  @override
  String get todaysDrinks => 'Сегодня выпито';

  @override
  String get allRecords => 'Все записи →';

  @override
  String itemDeleted(String item) {
    return '$item удалён';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get dailyReportReady => 'Дневной отчёт готов!';

  @override
  String get viewDayResults => 'Посмотрите результаты дня';

  @override
  String get dailyReportComingSoon =>
      'Дневной отчет будет доступен в следующей версии';

  @override
  String get home => 'Главная';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get cancel => 'Отмена';

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
  String get dietModeKeto => 'Кето / Низкоуглеводное';

  @override
  String get dietModeFasting => 'Интервальное голодание';

  @override
  String get activityLow => 'Низкая активность';

  @override
  String get activityMedium => 'Средняя активность';

  @override
  String get activityHigh => 'Высокая активность';

  @override
  String get activityLowDesc => 'Офисная работа, мало движения';

  @override
  String get activityMediumDesc => '30-60 минут упражнений в день';

  @override
  String get activityHighDesc => 'Тренировки >1 часа';

  @override
  String get notificationsSection => 'Уведомления';

  @override
  String get notificationLimit => 'Лимит уведомлений (БЕСПЛАТНО)';

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
  String get postCoffeeRemindersDesc => 'Напомнить выпить воду через 20 минут';

  @override
  String get heatWarnings => 'Предупреждения о жаре';

  @override
  String get heatWarningsDesc => 'Уведомления при высокой температуре';

  @override
  String get postAlcoholReminders => 'Напоминания после алкоголя';

  @override
  String get postAlcoholRemindersDesc => 'План восстановления на 6-12 часов';

  @override
  String get proFeaturesSection => 'PRO возможности';

  @override
  String get unlockPro => 'Разблокировать PRO';

  @override
  String get unlockProDesc => 'Безлимитные уведомления и умные напоминания';

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
  String get imperialUnits => 'oz, lb, °F';

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
      'Это действие удалит всю историю и вернет настройки к значениям по умолчанию.';

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
      'Умный трекинг воды и электролитов\nдля кето, поста и активной жизни';

  @override
  String get weightPageTitle => 'Ваш вес';

  @override
  String get weightPageSubtitle => 'Для расчета оптимального количества воды';

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
  String get dietPageSubtitle => 'Это влияет на потребность в электролитах';

  @override
  String get normalDiet => 'Обычное питание';

  @override
  String get normalDietDesc => 'Стандартные рекомендации';

  @override
  String get ketoDiet => 'Кето / Низкоуглеводное';

  @override
  String get ketoDietDesc => 'Повышенная потребность в соли';

  @override
  String get fastingDiet => 'Интервальное голодание';

  @override
  String get fastingDietDesc => 'Особый режим электролитов';

  @override
  String get fastingSchedule => 'Расписание голодания:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Ежедневное окно 8 часов';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Один прием пищи в день';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Через день';

  @override
  String get activityPageTitle => 'Уровень активности';

  @override
  String get activityPageSubtitle => 'Влияет на потребность в воде';

  @override
  String get lowActivity => 'Низкая активность';

  @override
  String get lowActivityDesc => 'Офисная работа, мало движения';

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
  String get noRecordsToday => 'Пока нет записей на сегодня';

  @override
  String get noRecordsThisDay => 'Нет записей за этот день';

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
  String get weeklyAverages => '📊 Средние показатели за неделю';

  @override
  String get monthStatistics => '📊 Статистика месяца';

  @override
  String get alcoholStatistics => '🍺 Статистика алкоголя';

  @override
  String get alcoholStatisticsTitle => 'Статистика алкоголя';

  @override
  String get weeklyInsights => '💡 Инсайты недели';

  @override
  String get waterPerDay => 'Вода в день';

  @override
  String get sodiumPerDay => 'Натрий в день';

  @override
  String get potassiumPerDay => 'Калий в день';

  @override
  String get magnesiumPerDay => 'Магний в день';

  @override
  String get goal => 'Цель';

  @override
  String get daysWithGoalAchieved => '✅ Дней с достижением цели';

  @override
  String get recordsPerDay => '📝 Записей в день';

  @override
  String get insufficientDataForAnalysis => 'Недостаточно данных для анализа';

  @override
  String get totalVolume => 'Общий объем';

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
    return 'Трезвые дни подряд: $days';
  }

  @override
  String get keepItUp => 'Продолжайте в том же духе!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Вода: $amount мл ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Алкоголь: $amount SD';
  }

  @override
  String get totalSD => 'Общее SD';

  @override
  String get forMonth => 'за месяц';

  @override
  String get daysWithAlcohol => 'Дней с алкоголем';

  @override
  String fromDays(int days) {
    return 'из $days';
  }

  @override
  String get soberDays => 'Трезвых дней';

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
    return 'В выходные вы пьете на $percent% меньше';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'В будни вы пьете на $percent% меньше';
  }

  @override
  String get positiveTrend => '📈 Положительный тренд';

  @override
  String get positiveTrendMessage =>
      'Ваша гидратация улучшается к концу недели';

  @override
  String get decliningActivity => '📉 Снижение активности';

  @override
  String get decliningActivityMessage =>
      'К концу недели потребление воды снижается';

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
    return '+$amount мл воды нужно выпить';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount мг натрия добавить';
  }

  @override
  String get goToBedEarly => 'Ложитесь спать раньше';

  @override
  String get todayConsumed => 'Сегодня выпито:';

  @override
  String get alcoholToday => 'Алкоголь сегодня';

  @override
  String get beer => 'Пиво';

  @override
  String get wine => 'Вино';

  @override
  String get spirits => 'Крепкий';

  @override
  String get cocktail => 'Коктейль';

  @override
  String get selectDrinkType => 'Выберите тип напитка:';

  @override
  String get volume => 'Объем (мл):';

  @override
  String get enterVolume => 'Введите объем в мл';

  @override
  String get strength => 'Крепость (%):';

  @override
  String get standardDrinks => 'Стандартные дринки:';

  @override
  String get additionalWater => 'Доп. вода';

  @override
  String get additionalSodium => 'Доп. натрий';

  @override
  String get hriRisk => 'HRI риск';

  @override
  String get enterValidVolume => 'Введите корректный объем';

  @override
  String get weeklyHistory => 'Недельная история';

  @override
  String get weeklyHistoryDesc =>
      'Анализируйте тренды за неделю, получайте инсайты и рекомендации';

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
  String get unlimitedHistory => 'Неограниченная история';

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
  String get testMode => 'Тестовый режим: Используется имитация покупки';

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
  String get oneTime => 'единоразово';

  @override
  String get perYear => '/год';

  @override
  String get perMonth => '/месяц';

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
    return 'Разблокировать за $price (единоразово)';
  }

  @override
  String get enableFreeTrial => 'Включить 7-дневную пробную версию';

  @override
  String get noChargeToday =>
      'Сегодня без оплаты. Через 7 дней подписка продлится автоматически, если вы не отмените её.';

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
  String get alcoholProtocols => 'Протоколы алкоголя';

  @override
  String get alcoholProtocolsDesc => 'Подготовка и план восстановления.';

  @override
  String get fullSync => 'Полная синхронизация';

  @override
  String get fullSyncDesc => 'Неограниченная история на всех устройствах.';

  @override
  String get personalCalibrations => 'Личные калибровки';

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
  String get noPurchasesToRestore => 'Покупки для восстановления не найдены';

  @override
  String get drinkMoreWaterToday => 'Пейте больше воды сегодня (+20%)';

  @override
  String get addElectrolytesToWater =>
      'Добавьте электролиты к каждому приему воды';

  @override
  String get limitCoffeeOneCup => 'Ограничьте кофе одной чашкой';

  @override
  String get increaseWater10 => 'Увеличьте воду на 10%';

  @override
  String get dontForgetElectrolytes => 'Не забывайте про электролиты';

  @override
  String get startDayWithWater => 'Начните день со стакана воды';

  @override
  String get takeElectrolytesMorning => 'Примите электролиты с утра';

  @override
  String purchaseFailed(String error) {
    return 'Ошибка покупки: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Ошибка восстановления: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — доверяют 12 000 пользователей';

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
  String get currentLocation => 'Текущая локация';

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
  String get heatWarningCold => '❄️ Холодно! Согрейтесь и пейте тёплые напитки';
}
