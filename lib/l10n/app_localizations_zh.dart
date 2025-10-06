// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'HydroCoach';

  @override
  String get getPro => '获取PRO';

  @override
  String get sunday => '周日';

  @override
  String get monday => '周一';

  @override
  String get tuesday => '周二';

  @override
  String get wednesday => '周三';

  @override
  String get thursday => '周四';

  @override
  String get friday => '周五';

  @override
  String get saturday => '周六';

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
    return '$month$day日 $weekday';
  }

  @override
  String get loading => '加载中...';

  @override
  String get loadingWeather => '获取天气...';

  @override
  String get heatIndex => '热指数';

  @override
  String humidity(int value) {
    return '湿度';
  }

  @override
  String get water => '水';

  @override
  String get liquids => '液体';

  @override
  String get sodium => '钠';

  @override
  String get potassium => '钾';

  @override
  String get magnesium => '镁';

  @override
  String get electrolyte => '电解质';

  @override
  String get broth => '汤';

  @override
  String get coffee => '咖啡';

  @override
  String get alcohol => '酒精';

  @override
  String get drink => '饮品';

  @override
  String get ml => '毫升';

  @override
  String get mg => '毫克';

  @override
  String get kg => '公斤';

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
    return '高温 +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return '酒精 +$amount ml';
  }

  @override
  String get smartAdviceTitle => '当前建议';

  @override
  String get smartAdviceDefault => '保持水和电解质平衡';

  @override
  String get adviceOverhydrationSevere => '过度饮水(>目标200%)';

  @override
  String get adviceOverhydrationSevereBody =>
      '暂停60-90分钟。补充电解质: 300-500ml含钠500-1000mg';

  @override
  String get adviceOverhydration => '过度饮水';

  @override
  String get adviceOverhydrationBody => '暂停饮水30-60分钟，补充约500mg钠(电解质/汤)';

  @override
  String get adviceAlcoholRecovery => '酒精: 恢复';

  @override
  String get adviceAlcoholRecoveryBody => '今天别再喝了。少量饮用300-500ml水，补充钠';

  @override
  String get adviceLowSodium => '钠不足';

  @override
  String adviceLowSodiumBody(int amount) {
    return '补充约${amount}mg钠。适量饮水';
  }

  @override
  String get adviceDehydration => '缺水';

  @override
  String adviceDehydrationBody(String type) {
    return '饮用300-500ml $type';
  }

  @override
  String get adviceHighRisk => '高风险(HRI)';

  @override
  String get adviceHighRiskBody => '紧急饮用电解质水(300-500ml)并减少活动';

  @override
  String get adviceHeat => '高温和流失';

  @override
  String get adviceHeatBody => '水分增加5-8%，补充钠300-500mg';

  @override
  String get adviceAllGood => '进展顺利';

  @override
  String adviceAllGoodBody(int amount) {
    return '保持节奏。目标还需约${amount}ml';
  }

  @override
  String get hydrationStatus => '水分状态';

  @override
  String get hydrationStatusNormal => '正常';

  @override
  String get hydrationStatusDiluted => '稀释中';

  @override
  String get hydrationStatusDehydrated => '缺水';

  @override
  String get hydrationStatusLowSalt => '盐分不足';

  @override
  String get hydrationRiskIndex => '水分风险指数';

  @override
  String get quickAdd => '快速添加';

  @override
  String get add => '添加';

  @override
  String get delete => '删除';

  @override
  String get todaysDrinks => '今日饮品';

  @override
  String get allRecords => '全部记录 →';

  @override
  String itemDeleted(String item) {
    return '$item已删除';
  }

  @override
  String get undo => '撤销';

  @override
  String get dailyReportReady => '日报完成！';

  @override
  String get viewDayResults => '查看今日结果';

  @override
  String get dailyReportComingSoon => '日报将在下一版本提供';

  @override
  String get home => '首页';

  @override
  String get history => '历史';

  @override
  String get settings => '设置';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get reset => '重置';

  @override
  String get settingsTitle => '设置';

  @override
  String get languageSection => '语言';

  @override
  String get languageSettings => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get profileSection => '个人资料';

  @override
  String get weight => '重量';

  @override
  String get dietMode => '饮食模式';

  @override
  String get activityLevel => '活动量';

  @override
  String get changeWeight => '更改体重';

  @override
  String get dietModeNormal => '正常饮食';

  @override
  String get dietModeKeto => '生酮/低碳';

  @override
  String get dietModeFasting => '间歇禁食';

  @override
  String get activityLow => '低活动量';

  @override
  String get activityMedium => '中活动量';

  @override
  String get activityHigh => '高活动量';

  @override
  String get activityLowDesc => '办公室工作，少运动';

  @override
  String get activityMediumDesc => '每天运动30-60分钟';

  @override
  String get activityHighDesc => '运动>1小时';

  @override
  String get notificationsSection => '通知';

  @override
  String get notificationLimit => '通知限制(免费版)';

  @override
  String notificationUsage(int used, int limit) {
    return '已用: $used/$limit';
  }

  @override
  String get waterReminders => '饮水提醒';

  @override
  String get waterRemindersDesc => '全天定期提醒';

  @override
  String get reminderFrequency => '提醒频率';

  @override
  String timesPerDay(int count) {
    return '每天$count次';
  }

  @override
  String maxTimesPerDay(int count) {
    return '每天$count次(最多4次)';
  }

  @override
  String get unlimitedReminders => '无限制';

  @override
  String get startOfDay => '开始时间';

  @override
  String get endOfDay => '结束时间';

  @override
  String get postCoffeeReminders => '咖啡后提醒';

  @override
  String get postCoffeeRemindersDesc => '20分钟后提醒饮水';

  @override
  String get heatWarnings => '高温警告';

  @override
  String get heatWarningsDesc => '高温时通知';

  @override
  String get postAlcoholReminders => '饮酒后提醒';

  @override
  String get postAlcoholRemindersDesc => '6-12小时恢复计划';

  @override
  String get proFeaturesSection => 'PRO功能';

  @override
  String get unlockPro => '解锁PRO';

  @override
  String get unlockProDesc => '无限通知和智能提醒';

  @override
  String get noNotificationLimit => '无通知限制';

  @override
  String get unitsSection => '单位';

  @override
  String get metricSystem => '公制';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => '英制';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => '关于';

  @override
  String get version => '版本';

  @override
  String get rateApp => '评价应用';

  @override
  String get share => '分享';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfUse => '使用条款';

  @override
  String get resetAllData => '重置所有数据';

  @override
  String get resetDataTitle => '重置所有数据？';

  @override
  String get resetDataMessage => '将删除所有历史并恢复默认设置';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get start => '开始';

  @override
  String get welcomeTitle => '欢迎使用\nHydroCoach';

  @override
  String get welcomeSubtitle => '智能水分和电解质追踪\n适用于生酮、禁食和活跃生活';

  @override
  String get weightPageTitle => '您的体重';

  @override
  String get weightPageSubtitle => '计算最佳水分摄入量';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return '建议: 每天$min-${max}ml';
  }

  @override
  String get dietPageTitle => '饮食模式';

  @override
  String get dietPageSubtitle => '影响电解质需求';

  @override
  String get normalDiet => '正常饮食';

  @override
  String get normalDietDesc => '标准建议';

  @override
  String get ketoDiet => '生酮/低碳';

  @override
  String get ketoDietDesc => '需增加盐分';

  @override
  String get fastingDiet => '间歇禁食';

  @override
  String get fastingDietDesc => '特殊电解质方案';

  @override
  String get fastingSchedule => '禁食计划:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => '每天8小时进食窗口';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => '一日一餐';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => '隔日禁食';

  @override
  String get activityPageTitle => '活动量';

  @override
  String get activityPageSubtitle => '影响水分需求';

  @override
  String get lowActivity => '低活动量';

  @override
  String get lowActivityDesc => '办公室工作，少运动';

  @override
  String get lowActivityWater => '+0 ml';

  @override
  String get mediumActivity => '中活动量';

  @override
  String get mediumActivityDesc => '每天运动30-60分钟';

  @override
  String get mediumActivityWater => '+350-700 ml';

  @override
  String get highActivity => '高活动量';

  @override
  String get highActivityDesc => '运动>1小时或体力劳动';

  @override
  String get highActivityWater => '+700-1200 ml';

  @override
  String get activityAdjustmentNote => '根据运动调整目标';

  @override
  String get day => '日';

  @override
  String get week => '周';

  @override
  String get month => '月';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get noData => '无数据';

  @override
  String get noRecordsToday => '今天还没有记录';

  @override
  String get noRecordsThisDay => '这天没有记录';

  @override
  String get loadingData => '加载中...';

  @override
  String get deleteRecord => '删除记录？';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '删除$type $volume ml？';
  }

  @override
  String get recordDeleted => '已删除';

  @override
  String get waterConsumption => '💧 饮水量';

  @override
  String get alcoholWeek => '🍺 本周饮酒';

  @override
  String get electrolytes => '⚡ 电解质';

  @override
  String get weeklyAverages => '📊 周平均';

  @override
  String get monthStatistics => '📊 月统计';

  @override
  String get alcoholStatistics => '🍺 饮酒统计';

  @override
  String get alcoholStatisticsTitle => '饮酒统计';

  @override
  String get weeklyInsights => '💡 周洞察';

  @override
  String get waterPerDay => '每日水分';

  @override
  String get sodiumPerDay => '每日钠';

  @override
  String get potassiumPerDay => '每日钾';

  @override
  String get magnesiumPerDay => '每日镁';

  @override
  String get goal => '目标';

  @override
  String get daysWithGoalAchieved => '✅ 达标天数';

  @override
  String get recordsPerDay => '📝 每日记录';

  @override
  String get insufficientDataForAnalysis => '数据不足';

  @override
  String get totalVolume => '总量';

  @override
  String averagePerDay(int amount) {
    return '平均$amount ml/天';
  }

  @override
  String get activeDays => '活跃天数';

  @override
  String perfectDays(int count) {
    return '$count天';
  }

  @override
  String currentStreak(int days) {
    return '连续: $days天';
  }

  @override
  String soberDaysRow(int days) {
    return '连续戒酒: $days天';
  }

  @override
  String get keepItUp => '继续保持！';

  @override
  String waterAmount(int amount, int percent) {
    return '水: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return '酒精: $amount SD';
  }

  @override
  String get totalSD => '总SD';

  @override
  String get forMonth => '本月';

  @override
  String get daysWithAlcohol => '饮酒天数';

  @override
  String fromDays(int days) {
    return '$days天中';
  }

  @override
  String get soberDays => '戒酒天数';

  @override
  String get excellent => '优秀！';

  @override
  String get averageSD => '平均SD';

  @override
  String get inDrinkingDays => '饮酒日';

  @override
  String get bestDay => '🏆 最佳';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - 目标$percent%';
  }

  @override
  String get weekends => '📅 周末';

  @override
  String get weekdays => '📅 工作日';

  @override
  String drinkLessOnWeekends(int percent) {
    return '周末少喝$percent%';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return '工作日少喝$percent%';
  }

  @override
  String get positiveTrend => '📈 积极趋势';

  @override
  String get positiveTrendMessage => '周末水分摄入改善';

  @override
  String get decliningActivity => '📉 下降趋势';

  @override
  String get decliningActivityMessage => '周末水分摄入减少';

  @override
  String get lowSalt => '⚠️ 盐分不足';

  @override
  String lowSaltMessage(int days) {
    return '仅$days天钠正常';
  }

  @override
  String get frequentAlcohol => '🍺 频繁饮酒';

  @override
  String frequentAlcoholMessage(int days) {
    return '7天中$days天饮酒影响水分';
  }

  @override
  String get excellentWeek => '✅ 优秀的一周';

  @override
  String get continueMessage => '继续保持！';

  @override
  String get all => '全部';

  @override
  String get addAlcohol => '添加酒精';

  @override
  String get minimumHarm => '最小危害';

  @override
  String additionalWaterNeeded(int amount) {
    return '需补水+$amount ml';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '需补钠+$amount mg';
  }

  @override
  String get goToBedEarly => '早睡';

  @override
  String get todayConsumed => '今日摄入:';

  @override
  String get alcoholToday => '今日饮酒';

  @override
  String get beer => '啤酒';

  @override
  String get wine => '葡萄酒';

  @override
  String get spirits => '烈酒';

  @override
  String get cocktail => '鸡尾酒';

  @override
  String get selectDrinkType => '选择酒类:';

  @override
  String get volume => '容量';

  @override
  String get enterVolume => '输入ml';

  @override
  String get strength => '力量';

  @override
  String get standardDrinks => '标准杯:';

  @override
  String get additionalWater => '补水';

  @override
  String get additionalSodium => '补钠';

  @override
  String get hriRisk => 'HRI风险';

  @override
  String get enterValidVolume => '请输入有效容量';

  @override
  String get weeklyHistory => '周历史';

  @override
  String get weeklyHistoryDesc => '分析周趋势，获得见解和建议';

  @override
  String get monthlyHistory => '月历史';

  @override
  String get monthlyHistoryDesc => '长期模式、周比较和深度分析';

  @override
  String get proFunction => 'PRO功能';

  @override
  String get unlockProHistory => '解锁PRO';

  @override
  String get unlimitedHistory => '无限历史';

  @override
  String get dataExportCSV => '导出CSV';

  @override
  String get detailedAnalytics => '详细分析';

  @override
  String get periodComparison => '期间比较';

  @override
  String get shareResult => '分享结果';

  @override
  String get retry => '重试';

  @override
  String get welcomeToPro => '欢迎使用PRO！';

  @override
  String get allFeaturesUnlocked => '所有功能已解锁';

  @override
  String get testMode => '测试模式: 模拟购买';

  @override
  String get proStatusNote => 'PRO状态将保持到应用重启';

  @override
  String get startUsingPro => '开始使用PRO';

  @override
  String get lifetimeAccess => '终身访问';

  @override
  String get bestValueAnnual => '最划算 — 年付';

  @override
  String get monthly => '月付';

  @override
  String get oneTime => '一次性';

  @override
  String get perYear => '/年';

  @override
  String get perMonth => '/月';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/月';
  }

  @override
  String get startFreeTrial => '开始7天免费试用';

  @override
  String continueWithPrice(String price) {
    return '继续 — $price';
  }

  @override
  String unlockForPrice(String price) {
    return '解锁$price(一次性)';
  }

  @override
  String get enableFreeTrial => '启用7天免费试用';

  @override
  String get noChargeToday => '今天不收费。7天后自动续订，除非取消';

  @override
  String get cancelAnytime => '可随时在设置中取消';

  @override
  String get everythingInPro => 'PRO全部功能';

  @override
  String get smartReminders => '智能提醒';

  @override
  String get smartRemindersDesc => '高温、运动、禁食 — 无垃圾信息';

  @override
  String get weeklyReports => '周报告';

  @override
  String get weeklyReportsDesc => '深度洞察 + CSV导出';

  @override
  String get healthIntegrations => '健康集成';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit';

  @override
  String get alcoholProtocols => '饮酒方案';

  @override
  String get alcoholProtocolsDesc => '饮前准备和恢复路线图';

  @override
  String get fullSync => '完全同步';

  @override
  String get fullSyncDesc => '跨设备无限历史';

  @override
  String get personalCalibrations => '个人校准';

  @override
  String get personalCalibrationsDesc => '汗液测试、尿色量表';

  @override
  String get showAllFeatures => '显示全部功能';

  @override
  String get showLess => '收起';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get proSubscriptionRestored => 'PRO订阅已恢复！';

  @override
  String get noPurchasesToRestore => '没有找到要恢复的购买';

  @override
  String get drinkMoreWaterToday => '今天多喝水(+20%)';

  @override
  String get addElectrolytesToWater => '每次饮水添加电解质';

  @override
  String get limitCoffeeOneCup => '咖啡限制一杯';

  @override
  String get increaseWater10 => '水分增加10%';

  @override
  String get dontForgetElectrolytes => '别忘了电解质';

  @override
  String get startDayWithWater => '以一杯水开始新的一天';

  @override
  String get dontForgetElectrolytesReminder => '⚡ 别忘了电解质';

  @override
  String get startDayWithWaterReminder => '以一杯水开始新的一天，保持健康';

  @override
  String get takeElectrolytesMorning => '早上补充电解质';

  @override
  String purchaseFailed(String error) {
    return '购买失败: $error';
  }

  @override
  String restoreFailed(String error) {
    return '恢复失败: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — 12,000用户信赖';

  @override
  String get bestValue => '最划算';

  @override
  String percentOff(int percent) {
    return '-$percent% 最划算';
  }

  @override
  String get weatherUnavailable => '天气不可用';

  @override
  String get checkLocationPermissions => '检查位置权限和网络';

  @override
  String get recommendedNormLabel => '建议量';

  @override
  String get waterAdjustment300 => '+300 ml';

  @override
  String get waterAdjustment400 => '+400 ml';

  @override
  String get waterAdjustment200 => '+200 ml';

  @override
  String get waterAdjustmentNormal => '正常';

  @override
  String get waterAdjustment500 => '+500 ml';

  @override
  String get waterAdjustment250 => '+250 ml';

  @override
  String get waterAdjustment750 => '+750 ml';

  @override
  String get currentLocation => '当前位置';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多云';

  @override
  String get weatherOvercast => '阴天';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '暴风雨';

  @override
  String get weatherFog => '雾';

  @override
  String get weatherDrizzle => '毛毛雨';

  @override
  String get weatherSunny => '晴朗';

  @override
  String get heatWarningExtreme => '☀️ 极热！最大水分补充';

  @override
  String get heatWarningVeryHot => '🌡️ 非常热！脱水风险';

  @override
  String get heatWarningHot => '🔥 炎热！多喝水';

  @override
  String get heatWarningElevated => '⚠️ 温度升高';

  @override
  String get heatWarningComfortable => '舒适温度';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% 水';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg 钠';
  }

  @override
  String get heatWarningCold => '❄️ 寒冷！保暖并喝温热液体';

  @override
  String get notificationChannelName => 'HydroCoach提醒';

  @override
  String get notificationChannelDescription => '水和电解质提醒';

  @override
  String get urgentNotificationChannelName => '紧急提醒';

  @override
  String get urgentNotificationChannelDescription => '重要水分通知';

  @override
  String get goodMorning => '☀️ 早上好！';

  @override
  String get timeToHydrate => '💧 水分补充时间';

  @override
  String get eveningHydration => '💧 晚间水分补充';

  @override
  String get dailyReportTitle => ' 日报完成';

  @override
  String get dailyReportBody => '查看你的水分情况';

  @override
  String get maintainWaterBalance => '全天保持水分平衡';

  @override
  String get electrolytesTime => '电解质时间: 水中加少量盐';

  @override
  String catchUpHydration(int percent) {
    return '你只喝了每日目标的$percent%。该补上了！';
  }

  @override
  String get excellentProgress => '进展优秀！再接再厉达成目标';

  @override
  String get postCoffeeTitle => ' 咖啡后';

  @override
  String get postCoffeeBody => '喝250-300ml水恢复平衡';

  @override
  String get postWorkoutTitle => ' 运动后';

  @override
  String get postWorkoutBody => '恢复电解质: 500ml水 + 少量盐';

  @override
  String get heatWarningPro => '🌡️ PRO高温警告';

  @override
  String get extremeHeatWarning => '极热！水分增加15%，加1g盐';

  @override
  String get hotWeatherWarning => '炎热！多喝10%水，别忘电解质';

  @override
  String get warmWeatherWarning => '温暖。监测水分状态';

  @override
  String get alcoholRecoveryTitle => '🍺 恢复时间';

  @override
  String get alcoholRecoveryBody => '喝300ml水加少量盐恢复平衡';

  @override
  String get continueHydration => '💧 继续补水';

  @override
  String get alcoholRecoveryBody2 => '再喝500ml水帮助更快恢复';

  @override
  String get morningRecoveryTitle => '☀️ 晨间恢复';

  @override
  String get morningRecoveryBody => '以500ml水和电解质开始新的一天';

  @override
  String get testNotificationTitle => '🧪 测试通知';

  @override
  String get testNotificationBody => '如果你看到这个 - 即时通知有效！';

  @override
  String get scheduledTestTitle => '⏰ 定时测试(1分钟)';

  @override
  String get scheduledTestBody => '此通知在1分钟前安排。定时有效！';

  @override
  String get notificationServiceInitialized => '✅ 通知服务已初始化';

  @override
  String get localNotificationsInitialized => '✅ 本地通知已初始化';

  @override
  String get androidChannelsCreated => '📢 Android通知渠道已创建';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 通知权限: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 精确闹钟权限: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM权限: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM令牌已收到';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ FCM令牌已保存到用户$userId的Firestore';
  }

  @override
  String get topicSubscriptionComplete => '✅ 主题订阅完成';

  @override
  String foregroundMessage(String title) {
    return '📨 前台消息: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 通知已打开: $messageId';
  }

  @override
  String get dailyLimitReached => '⚠️ 已达每日通知限制(免费版4/天)';

  @override
  String schedulingError(String error) {
    return '❌ 通知安排错误: $error';
  }

  @override
  String get showingImmediatelyAsFallback => '作为后备立即显示通知';

  @override
  String instantNotificationShown(String title) {
    return '📬 即时通知已显示: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 正在安排智能提醒...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ 已安排$count个提醒';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: 咖啡后提醒已安排';

  @override
  String get postWorkoutScheduled => '💪 运动后提醒已安排';

  @override
  String get proHeatWarningPro => '🌡️ PRO: 高温警告已发送';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO: 酒精恢复计划已安排';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 晚间报告已安排在$day.$month 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 通知$id已取消';
  }

  @override
  String get allNotificationsCancelled => '🗑️ 所有通知已取消';

  @override
  String get reminderSettingsSaved => '✅ 提醒设置已保存';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ 测试通知已安排在$time';
  }

  @override
  String get tomorrowRecommendations => '明天的建议';

  @override
  String get recommendationExcellent => '优秀！继续保持。尝试以一杯水开始新的一天并保持均匀摄入';

  @override
  String get recommendationDiluted => '你喝了很多水但电解质少。明天多加盐或喝电解质饮料。试着以咸汤开始新的一天';

  @override
  String get recommendationDehydrated => '今天水不够。明天每2小时设置提醒。把水壶放在显眼位置';

  @override
  String get recommendationLowSalt => '低钠会导致疲劳。在水中加少量盐或喝汤。生酮或禁食时特别重要';

  @override
  String get recommendationGeneral => '目标是水和电解质平衡。全天均匀饮用，炎热时别忘盐';

  @override
  String get category_water => '水';

  @override
  String get category_hot_drinks => '热饮';

  @override
  String get category_juice => '果汁';

  @override
  String get category_sports => '运动';

  @override
  String get category_dairy => '乳制品';

  @override
  String get category_alcohol => '酒精';

  @override
  String get category_supplements => '补剂';

  @override
  String get category_other => '其他';

  @override
  String get drink_water => '水';

  @override
  String get drink_sparkling_water => '气泡水';

  @override
  String get drink_mineral_water => '矿泉水';

  @override
  String get drink_coconut_water => '椰子水';

  @override
  String get drink_coffee => '咖啡';

  @override
  String get drink_espresso => '浓缩咖啡';

  @override
  String get drink_americano => '美式咖啡';

  @override
  String get drink_cappuccino => '卡布奇诺';

  @override
  String get drink_latte => '拿铁';

  @override
  String get drink_black_tea => '红茶';

  @override
  String get drink_green_tea => '绿茶';

  @override
  String get drink_herbal_tea => '花草茶';

  @override
  String get drink_matcha => '抹茶';

  @override
  String get drink_hot_chocolate => '热巧克力';

  @override
  String get drink_orange_juice => '橙汁';

  @override
  String get drink_apple_juice => '苹果汁';

  @override
  String get drink_grapefruit_juice => '西柚汁';

  @override
  String get drink_tomato_juice => '番茄汁';

  @override
  String get drink_vegetable_juice => '蔬菜汁';

  @override
  String get drink_smoothie => '冰沙';

  @override
  String get drink_lemonade => '柠檬水';

  @override
  String get drink_isotonic => '等渗饮料';

  @override
  String get drink_electrolyte => '电解质饮料';

  @override
  String get drink_protein_shake => '蛋白奶昔';

  @override
  String get drink_bcaa => 'BCAA饮料';

  @override
  String get drink_energy => '能量饮料';

  @override
  String get drink_milk => '牛奶';

  @override
  String get drink_kefir => '克菲尔';

  @override
  String get drink_yogurt => '酸奶饮品';

  @override
  String get drink_almond_milk => '杏仁奶';

  @override
  String get drink_soy_milk => '豆奶';

  @override
  String get drink_oat_milk => '燕麦奶';

  @override
  String get drink_beer_light => '淡啤';

  @override
  String get drink_beer_regular => '普通啤酒';

  @override
  String get drink_beer_strong => '烈性啤酒';

  @override
  String get drink_wine_red => '红葡萄酒';

  @override
  String get drink_wine_white => '白葡萄酒';

  @override
  String get drink_champagne => '香槟';

  @override
  String get drink_vodka => '伏特加';

  @override
  String get drink_whiskey => '威士忌';

  @override
  String get drink_rum => '朗姆酒';

  @override
  String get drink_gin => '金酒';

  @override
  String get drink_tequila => '龙舌兰';

  @override
  String get drink_mojito => '莫吉托';

  @override
  String get drink_margarita => '玛格丽特';

  @override
  String get drink_kombucha => '康普茶';

  @override
  String get drink_kvass => '格瓦斯';

  @override
  String get drink_bone_broth => '骨汤';

  @override
  String get drink_vegetable_broth => '蔬菜汤';

  @override
  String get drink_soda => '汽水';

  @override
  String get drink_diet_soda => '无糖汽水';

  @override
  String get addedToFavorites => '已添加到收藏';

  @override
  String get favoriteLimitReached => '收藏已达上限(免费3个，PRO 20个)';

  @override
  String get addFavorite => '添加收藏';

  @override
  String get hotAndSupplements => '热饮&补剂';

  @override
  String get quickVolumes => '快速容量:';

  @override
  String get type => '类型:';

  @override
  String get regular => '普通';

  @override
  String get coconut => '椰子';

  @override
  String get sparkling => '气泡';

  @override
  String get mineral => '矿物质';

  @override
  String get hotDrinks => '热饮';

  @override
  String get supplements => '补剂';

  @override
  String get tea => '茶';

  @override
  String get salt => '盐(1/4茶匙)';

  @override
  String get electrolyteMix => '电解质混合';

  @override
  String get boneBroth => '骨汤';

  @override
  String get favoriteAssignmentComingSoon => '收藏分配即将推出';

  @override
  String get longPressToEditComingSoon => '长按编辑 - 即将推出';

  @override
  String get proSubscriptionRequired => '需要PRO订阅';

  @override
  String get saveToFavorites => '保存到收藏';

  @override
  String get savedToFavorites => '已保存到收藏';

  @override
  String get selectFavoriteSlot => '选择收藏位';

  @override
  String get slot => '位置';

  @override
  String get emptySlot => '空位';

  @override
  String get upgradeToUnlock => '升级PRO解锁';

  @override
  String get changeFavorite => '更改收藏';

  @override
  String get removeFavorite => '移除收藏';

  @override
  String get ok => '确定';

  @override
  String get mineralWater => '矿泉水';

  @override
  String get coconutWater => '椰子水';

  @override
  String get lemonWater => '柠檬水';

  @override
  String get greenTea => '绿茶';

  @override
  String get amount => '数量';

  @override
  String get createFavoriteHint => '要添加收藏，请转到下方任意饮品屏幕，设置后点击\"保存到收藏\"按钮';

  @override
  String get sparklingWater => '气泡水';

  @override
  String get cola => '可乐';

  @override
  String get juice => '果汁';

  @override
  String get energyDrink => '能量饮料';

  @override
  String get sportsDrink => '运动饮料';

  @override
  String get selectElectrolyteType => '选择电解质类型:';

  @override
  String get saltQuarterTsp => '盐(1/4茶匙)';

  @override
  String get pinkSalt => '喜马拉雅粉盐';

  @override
  String get seaSalt => '海盐';

  @override
  String get potassiumCitrate => '柠檬酸钾';

  @override
  String get magnesiumGlycinate => '甘氨酸镁';

  @override
  String get coconutWaterElectrolyte => '椰子水';

  @override
  String get sportsDrinkElectrolyte => '运动饮料';

  @override
  String get electrolyteContent => '电解质含量:';

  @override
  String sodiumContent(int amount) {
    return '钠: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return '钾: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return '镁: $amount mg';
  }

  @override
  String get servings => '份';

  @override
  String get enterServings => '输入份量';

  @override
  String get servingsUnit => '份';

  @override
  String get noElectrolytes => '无电解质';

  @override
  String get enterValidAmount => '请输入有效数量';

  @override
  String get lmntMix => 'LMNT混合';

  @override
  String get pickleJuice => '腌菜汁';

  @override
  String get tomatoSalt => '番茄+盐';

  @override
  String get ketorade => '生酮饮';

  @override
  String get alkalineWater => '碱性水';

  @override
  String get celticSalt => '凯尔特盐水';

  @override
  String get soleWater => '盐水';

  @override
  String get mineralDrops => '矿物滴剂';

  @override
  String get bakingSoda => '小苏打水';

  @override
  String get creamTartar => '酒石酸';

  @override
  String get selectSupplementType => '选择补剂类型:';

  @override
  String get multivitamin => '复合维生素';

  @override
  String get magnesiumCitrate => '柠檬酸镁';

  @override
  String get magnesiumThreonate => 'L-苏糖酸镁';

  @override
  String get calciumCitrate => '柠檬酸钙';

  @override
  String get zincGlycinate => '甘氨酸锌';

  @override
  String get vitaminD3 => '维生素D3';

  @override
  String get vitaminC => '维生素C';

  @override
  String get bComplex => 'B族维生素';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => '双甘氨酸铁';

  @override
  String get dosage => '剂量';

  @override
  String get enterDosage => '输入剂量';

  @override
  String get noElectrolyteContent => '无电解质含量';

  @override
  String get blackTea => '红茶';

  @override
  String get herbalTea => '花草茶';

  @override
  String get espresso => '浓缩咖啡';

  @override
  String get cappuccino => '卡布奇诺';

  @override
  String get latte => '拿铁';

  @override
  String get matcha => '抹茶';

  @override
  String get hotChocolate => '热巧克力';

  @override
  String get caffeine => '咖啡因';

  @override
  String get sports => '运动';

  @override
  String get walking => '步行';

  @override
  String get running => '跑步';

  @override
  String get gym => '健身房';

  @override
  String get cycling => '骑行';

  @override
  String get swimming => '游泳';

  @override
  String get yoga => '瑜伽';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => '拳击';

  @override
  String get dancing => '舞蹈';

  @override
  String get tennis => '网球';

  @override
  String get teamSports => '团队运动';

  @override
  String get selectActivityType => '选择活动类型:';

  @override
  String get duration => '时长';

  @override
  String get minutes => '分钟';

  @override
  String get enterDuration => '输入时长';

  @override
  String get lowIntensity => '低强度';

  @override
  String get mediumIntensity => '中强度';

  @override
  String get highIntensity => '高强度';

  @override
  String get recommendedIntake => '建议摄入:';

  @override
  String get basedOnWeight => '基于体重';

  @override
  String get logActivity => '记录活动';

  @override
  String get activityLogged => '活动已记录';

  @override
  String get enterValidDuration => '请输入有效时长';

  @override
  String get sauna => '桑拿';

  @override
  String get veryHighIntensity => '超高强度';

  @override
  String get hriStatusExcellent => '优秀';

  @override
  String get hriStatusGood => '良好';

  @override
  String get hriStatusModerate => '中等风险';

  @override
  String get hriStatusHighRisk => '高风险';

  @override
  String get hriStatusCritical => '危急';

  @override
  String get hriComponentWater => '水分平衡';

  @override
  String get hriComponentSodium => '钠水平';

  @override
  String get hriComponentPotassium => '钾水平';

  @override
  String get hriComponentMagnesium => '镁水平';

  @override
  String get hriComponentHeat => '热应激';

  @override
  String get hriComponentWorkout => '身体活动';

  @override
  String get hriComponentCaffeine => '咖啡因影响';

  @override
  String get hriComponentAlcohol => '酒精影响';

  @override
  String get hriComponentTime => '摄入时间';

  @override
  String get hriComponentMorning => '早晨因素';

  @override
  String get hriBreakdownTitle => '风险因素分解';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max 分';
  }

  @override
  String get fastingModeActive => '禁食模式激活';

  @override
  String get fastingSuppressionNote => '禁食期间抑制时间因素';

  @override
  String get morningCheckInTitle => '晨间检查';

  @override
  String get howAreYouFeeling => '感觉如何?';

  @override
  String get feelingScale1 => '差';

  @override
  String get feelingScale2 => '低于平均';

  @override
  String get feelingScale3 => '正常';

  @override
  String get feelingScale4 => '良好';

  @override
  String get feelingScale5 => '优秀';

  @override
  String get weightChange => '较昨天体重变化';

  @override
  String get urineColorScale => '尿色(1-8级)';

  @override
  String get urineColor1 => '1 - 很淡';

  @override
  String get urineColor2 => '2 - 淡';

  @override
  String get urineColor3 => '3 - 浅黄';

  @override
  String get urineColor4 => '4 - 黄';

  @override
  String get urineColor5 => '5 - 深黄';

  @override
  String get urineColor6 => '6 - 琥珀';

  @override
  String get urineColor7 => '7 - 深琥珀';

  @override
  String get urineColor8 => '8 - 褐色';

  @override
  String get alcoholWithDecay => '酒精影响(衰减中)';

  @override
  String standardDrinksToday(Object count) {
    return '今日标准杯: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return '活性咖啡因: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRI调试信息';

  @override
  String hriNormalized(Object value) {
    return 'HRI(标准化): $value/100';
  }

  @override
  String get fastingWindowActive => '禁食窗口激活';

  @override
  String get eatingWindowActive => '进食窗口激活';

  @override
  String nextFastingWindow(Object time) {
    return '下次禁食: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return '下次进食: $time';
  }

  @override
  String get todaysWorkouts => '今日运动';

  @override
  String get hoursAgo => '小时前';

  @override
  String get onboardingWelcomeTitle => 'HydroCoach — 每日智能水分补充';

  @override
  String get onboardingWelcomeSubtitle =>
      '更聪明地喝，而非更多\n应用考虑天气、电解质和习惯\n帮助保持清晰头脑和稳定能量';

  @override
  String get onboardingBullet1 => '基于天气和个人的水和盐标准';

  @override
  String get onboardingBullet2 => '\"现在该做什么\"提示而非原始图表';

  @override
  String get onboardingBullet3 => '标准剂量酒精及安全限制';

  @override
  String get onboardingBullet4 => '智能提醒无垃圾信息';

  @override
  String get onboardingStartButton => '开始';

  @override
  String get onboardingHaveAccount => '我已有账号';

  @override
  String get onboardingPracticeFasting => '我实践间歇禁食';

  @override
  String get onboardingPracticeFastingDesc => '禁食窗口特殊电解质方案';

  @override
  String get onboardingProfileReady => '资料完成！';

  @override
  String get onboardingWaterNorm => '水分标准';

  @override
  String get onboardingIonWillHelp => 'ION将帮助每天保持平衡';

  @override
  String get onboardingContinue => '继续';

  @override
  String get onboardingLocationTitle => '天气对水分很重要';

  @override
  String get onboardingLocationSubtitle => '我们将考虑天气和湿度。这比仅按体重公式更准确';

  @override
  String get onboardingWeatherExample => '今天热！+15%水';

  @override
  String get onboardingWeatherExampleDesc => '+500mg钠应对高温';

  @override
  String get onboardingEnablePermission => '启用';

  @override
  String get onboardingEnableLater => '稍后启用';

  @override
  String get onboardingNotificationTitle => '智能提醒';

  @override
  String get onboardingNotificationSubtitle => '适时简短提示。一键更改频率';

  @override
  String get onboardingNotifExample1 => '水分补充时间';

  @override
  String get onboardingNotifExample2 => '别忘了电解质';

  @override
  String get onboardingNotifExample3 => '热！多喝水';

  @override
  String get sportRecoveryProtocols => '运动恢复方案';

  @override
  String get allDrinksAndSupplements => '全部饮品&补剂';

  @override
  String get notificationChannelDefault => '水分提醒';

  @override
  String get notificationChannelDefaultDesc => '水和电解质提醒';

  @override
  String get notificationChannelUrgent => '重要通知';

  @override
  String get notificationChannelUrgentDesc => '高温警告和关键水分警报';

  @override
  String get notificationChannelReport => '报告';

  @override
  String get notificationChannelReportDesc => '每日和每周报告';

  @override
  String get notificationWaterTitle => '💧 水分补充时间';

  @override
  String get notificationWaterBody => '别忘了喝水';

  @override
  String get notificationPostCoffeeTitle => '☕ 咖啡后';

  @override
  String get notificationPostCoffeeBody => '喝250-300ml水恢复平衡';

  @override
  String get notificationDailyReportTitle => '📊 日报完成';

  @override
  String get notificationDailyReportBody => '查看你的水分情况';

  @override
  String get notificationAlcoholCounterTitle => '🍺 恢复时间';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return '喝${ml}ml水加少量盐';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ 高温警告';

  @override
  String get notificationHeatWarningExtremeBody => '极热！+15%水和+1g盐';

  @override
  String get notificationHeatWarningHotBody => '炎热！+10%水和电解质';

  @override
  String get notificationHeatWarningWarmBody => '温暖。监测水分';

  @override
  String get notificationWorkoutTitle => '💪 运动';

  @override
  String get notificationWorkoutBody => '别忘水和电解质';

  @override
  String get notificationPostWorkoutTitle => '💪 运动后';

  @override
  String get notificationPostWorkoutBody => '500ml水+电解质恢复';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ 电解质时间';

  @override
  String get notificationFastingElectrolyteBody => '水中加少量盐或喝汤';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 恢复$hours小时';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return '喝${ml}ml水';
  }

  @override
  String get notificationAlcoholRecoveryMidBody => '补充电解质: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody => '明早 - 检查';

  @override
  String get notificationMorningCheckInTitle => '☀️ 晨间检查';

  @override
  String get notificationMorningCheckInBody => '感觉如何? 评价状态获得当日计划';

  @override
  String get notificationMorningWaterBody => '以一杯水开始新的一天';

  @override
  String notificationLowProgressBody(int percent) {
    return '你只喝了目标的$percent%。该补上了！';
  }

  @override
  String get notificationGoodProgressBody => '进展优秀！继续';

  @override
  String get notificationMaintainBalanceBody => '保持水分平衡';

  @override
  String get notificationTestTitle => '🧪 测试通知';

  @override
  String get notificationTestBody => '如果你看到这个 - 通知有效！';

  @override
  String get notificationTestScheduledTitle => '⏰ 定时测试';

  @override
  String get notificationTestScheduledBody => '此通知在1分钟前安排';

  @override
  String get onboardingUnitsTitle => '选择单位';

  @override
  String get onboardingUnitsSubtitle => '以后无法更改';

  @override
  String get onboardingUnitsWarning => '此选择永久无法更改';

  @override
  String get oz => '盎司';

  @override
  String get fl_oz => '液盎司';

  @override
  String get gallons => '加仑';

  @override
  String get lb => '磅';

  @override
  String get target => '目标';

  @override
  String get wind => '风';

  @override
  String get pressure => '气压';

  @override
  String get highHeatIndexWarning => '高热指数！增加水分摄入';

  @override
  String get weatherCondition => '状况';

  @override
  String get feelsLike => '体感';

  @override
  String get humidityLabel => '湿度';

  @override
  String get waterNormal => '正常';

  @override
  String get sodiumNormal => '标准';

  @override
  String get addedSuccessfully => '添加成功';

  @override
  String get sugarIntake => '糖摄入';

  @override
  String get sugarToday => '今日糖消耗';

  @override
  String get totalSugar => '总糖';

  @override
  String get dailyLimit => '每日限量';

  @override
  String get addedSugar => '添加糖';

  @override
  String get naturalSugar => '天然糖';

  @override
  String get hiddenSugar => '隐藏糖';

  @override
  String get sugarFromDrinks => '饮品';

  @override
  String get sugarFromFood => '食物';

  @override
  String get sugarFromSnacks => '零食';

  @override
  String get sugarNormal => '正常';

  @override
  String get sugarModerate => '中等';

  @override
  String get sugarHigh => '高';

  @override
  String get sugarCritical => '危急';

  @override
  String get sugarRecommendationNormal => '很好！糖摄入在健康范围内';

  @override
  String get sugarRecommendationModerate => '考虑减少甜饮和零食';

  @override
  String get sugarRecommendationHigh => '糖摄入高！限制甜饮和甜点';

  @override
  String get sugarRecommendationCritical => '糖非常高！今天避免含糖饮料和甜食';

  @override
  String get noSugarIntake => '今天没有追踪糖';

  @override
  String get hriImpact => 'HRI影响';

  @override
  String get hri_component_sugar => '糖';

  @override
  String get hri_sugar_description => '高糖摄入影响水分和整体健康';

  @override
  String get tip_reduce_sweet_drinks => '用水或无糖茶替代甜饮';

  @override
  String get tip_avoid_added_sugar => '检查标签避免添加糖产品';

  @override
  String get tip_check_labels => '注意酱料和加工食品中的隐藏糖';

  @override
  String get tip_replace_soda => '用气泡水和柠檬替代汽水';

  @override
  String get sugarSources => '糖来源';

  @override
  String get drinks => '饮品';

  @override
  String get food => '食物';

  @override
  String get snacks => '零食';

  @override
  String get recommendedLimit => '建议';

  @override
  String get points => '分';

  @override
  String get drinkLightBeer => '淡啤';

  @override
  String get drinkLager => '拉格';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => '世涛';

  @override
  String get drinkWheatBeer => '小麦啤';

  @override
  String get drinkCraftBeer => '精酿啤';

  @override
  String get drinkNonAlcoholic => '无酒精';

  @override
  String get drinkRadler => '果啤';

  @override
  String get drinkPilsner => '皮尔森';

  @override
  String get drinkRedWine => '红葡萄酒';

  @override
  String get drinkWhiteWine => '白葡萄酒';

  @override
  String get drinkProsecco => '普罗塞克';

  @override
  String get drinkPort => '波特';

  @override
  String get drinkRose => '桃红';

  @override
  String get drinkDessertWine => '甜酒';

  @override
  String get drinkSangria => '桑格利亚';

  @override
  String get drinkSherry => '雪莉';

  @override
  String get drinkVodkaShot => '伏特加Shot';

  @override
  String get drinkCognac => '干邑';

  @override
  String get drinkLiqueur => '利口酒';

  @override
  String get drinkAbsinthe => '苦艾酒';

  @override
  String get drinkBrandy => '白兰地';

  @override
  String get drinkLongIsland => '长岛';

  @override
  String get drinkGinTonic => '金汤力';

  @override
  String get drinkPinaColada => '椰林飘香';

  @override
  String get drinkCosmopolitan => '大都会';

  @override
  String get drinkMaiTai => '迈泰';

  @override
  String get drinkBloodyMary => '血腥玛丽';

  @override
  String get drinkDaiquiri => '代基里';

  @override
  String popularDrinks(Object type) {
    return '流行$type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g糖';

  @override
  String get moderateConsumption => '适度消费';

  @override
  String get aboveRecommendations => '超标';

  @override
  String get highConsumption => '高消费';

  @override
  String get veryHighConsider => '非常高 - 考虑停止';

  @override
  String get noAlcoholToday => '今天无酒精';

  @override
  String get drinkWaterNow => '现在喝300-500ml水';

  @override
  String get addPinchSalt => '加少量盐';

  @override
  String get avoidLateCoffee => '避免晚上咖啡';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => '今日电解质';

  @override
  String get greatBalance => '平衡极佳！';

  @override
  String get gettingThere => '接近目标';

  @override
  String get needMoreElectrolytes => '需要更多电解质';

  @override
  String get lowElectrolyteLevels => '电解质水平低';

  @override
  String get electrolyteTips => '电解质提示';

  @override
  String get takeWithWater => '与大量水一起服用';

  @override
  String get bestBetweenMeals => '两餐之间吸收最好';

  @override
  String get startSmallAmounts => '从小量开始';

  @override
  String get extraDuringExercise => '运动时需额外';

  @override
  String get electrolytesBasic => '基础';

  @override
  String get electrolytesMixes => '混合';

  @override
  String get electrolytesPills => '药片';

  @override
  String get popularSalts => '流行盐和汤';

  @override
  String get popularMixes => '流行电解质混合';

  @override
  String get popularSupplements => '流行补剂';

  @override
  String get electrolyteSaltWater => '盐水';

  @override
  String get electrolytePinkSalt => '粉盐';

  @override
  String get electrolyteSeaSalt => '海盐';

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
  String get electrolytePotassiumChloride => '氯化钾';

  @override
  String get electrolyteMagThreonate => '苏糖酸镁';

  @override
  String get electrolyteTraceMinerals => '微量矿物质';

  @override
  String get electrolyteZMAComplex => 'ZMA复合';

  @override
  String get electrolyteMultiMineral => '多矿物质';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => '水分补充';

  @override
  String get todayHydration => '今日水分';

  @override
  String get currentIntake => '已摄入';

  @override
  String get dailyGoal => '目标';

  @override
  String get toGo => '剩余';

  @override
  String get goalReached => '目标达成！';

  @override
  String get almostThere => '快到了！';

  @override
  String get halfwayThere => '半程';

  @override
  String get keepGoing => '继续！';

  @override
  String get startDrinking => '开始饮用';

  @override
  String get plainWater => '纯净';

  @override
  String get enhancedWater => '增强';

  @override
  String get beverages => '饮料';

  @override
  String get sodas => '汽水';

  @override
  String get popularPlainWater => '流行水类型';

  @override
  String get popularEnhancedWater => '增强&注入';

  @override
  String get popularBeverages => '流行饮料';

  @override
  String get popularSodas => '流行汽水&能量';

  @override
  String get hydrationTips => '水分提示';

  @override
  String get drinkRegularly => '定期少量饮用';

  @override
  String get roomTemperature => '室温水吸收更好';

  @override
  String get addLemon => '加柠檬味道更好';

  @override
  String get limitSugary => '限制含糖饮料 - 会脱水';

  @override
  String get warmWater => '温水';

  @override
  String get iceWater => '冰水';

  @override
  String get filteredWater => '过滤水';

  @override
  String get distilledWater => '蒸馏水';

  @override
  String get springWater => '泉水';

  @override
  String get hydrogenWater => '氢水';

  @override
  String get oxygenatedWater => '富氧水';

  @override
  String get cucumberWater => '黄瓜水';

  @override
  String get limeWater => '青柠水';

  @override
  String get berryWater => '浆果水';

  @override
  String get mintWater => '薄荷水';

  @override
  String get gingerWater => '姜水';

  @override
  String get caffeineStatusNone => '今天无咖啡因';

  @override
  String caffeineStatusModerate(Object amount) {
    return '适量: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return '高: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return '非常高: ${amount}mg！';
  }

  @override
  String get caffeineDailyLimit => '每日限量: 400mg';

  @override
  String get caffeineWarningTitle => '咖啡因警告';

  @override
  String get caffeineWarning400 => '今天已超400mg咖啡因';

  @override
  String get caffeineTipWater => '多喝水补偿';

  @override
  String get caffeineTipAvoid => '今天避免更多咖啡因';

  @override
  String get caffeineTipSleep => '可能影响睡眠质量';

  @override
  String get total => '总计';

  @override
  String get cupsToday => '今日杯数';

  @override
  String get metabolizeTime => '代谢时间';

  @override
  String get aboutCaffeine => '关于咖啡因';

  @override
  String get caffeineInfo1 => '咖啡含天然咖啡因提高警觉性';

  @override
  String get caffeineInfo2 => '大多数成人每日安全限量为400mg';

  @override
  String get caffeineInfo3 => '咖啡因半衰期5-6小时';

  @override
  String get caffeineInfo4 => '多喝水补偿咖啡因利尿效应';

  @override
  String get caffeineWarningPregnant => '孕妇应限制咖啡因至200mg/天';

  @override
  String get gotIt => '明白';

  @override
  String get consumed => '已摄入';

  @override
  String get remaining => '剩余';

  @override
  String get todaysCaffeine => '今日咖啡因';

  @override
  String get alreadyInFavorites => '已在收藏中';

  @override
  String get ofRecommendedLimit => '建议限量的';

  @override
  String get aboutAlcohol => '关于酒精';

  @override
  String get alcoholInfo1 => '1标准杯等于10g纯酒精';

  @override
  String get alcoholInfo2 => '酒精脱水 — 每杯多喝250ml水';

  @override
  String get alcoholInfo3 => '添加钠帮助饮酒后保持体液';

  @override
  String get alcoholInfo4 => '每标准杯增加HRI 3-5分';

  @override
  String get alcoholWarningHealth => '过量饮酒有害健康。建议男性每天2 SD，女性1 SD';

  @override
  String get supplementsInfo1 => '补剂帮助维持电解质平衡';

  @override
  String get supplementsInfo2 => '最好随餐服用以吸收';

  @override
  String get supplementsInfo3 => '始终与大量水一起服用';

  @override
  String get supplementsInfo4 => '镁和钾是水分补充关键';

  @override
  String get supplementsWarning => '开始任何补剂方案前请咨询医疗保健提供者';

  @override
  String get fromSupplementsToday => '今日补剂摄入';

  @override
  String get minerals => '矿物质';

  @override
  String get vitamins => '维生素';

  @override
  String get essentialMinerals => '必需矿物质';

  @override
  String get otherSupplements => '其他补剂';

  @override
  String get supplementTip1 => '随餐服用补剂以更好吸收';

  @override
  String get supplementTip2 => '与补剂一起喝大量水';

  @override
  String get supplementTip3 => '全天分散多种补剂';

  @override
  String get supplementTip4 => '记录对你有效的';

  @override
  String get calciumCarbonate => '碳酸钙';

  @override
  String get traceMinerals => '微量矿物质';

  @override
  String get vitaminA => '维生素A';

  @override
  String get vitaminE => '维生素E';

  @override
  String get vitaminK2 => '维生素K2';

  @override
  String get folate => '叶酸';

  @override
  String get biotin => '生物素';

  @override
  String get probiotics => '益生菌';

  @override
  String get melatonin => '褪黑素';

  @override
  String get collagen => '胶原蛋白';

  @override
  String get glucosamine => '氨基葡萄糖';

  @override
  String get turmeric => '姜黄';

  @override
  String get coq10 => '辅酶Q10';

  @override
  String get creatine => '肌酸';

  @override
  String get ashwagandha => '南非醉茄';

  @override
  String get selectCardioActivity => '选择有氧活动';

  @override
  String get selectStrengthActivity => '选择力量活动';

  @override
  String get selectSportsActivity => '选择运动';

  @override
  String get sessions => '次';

  @override
  String get totalTime => '总时长';

  @override
  String get waterLoss => '水分流失';

  @override
  String get intensity => '强度';

  @override
  String get drinkWaterAfterWorkout => '运动后喝水';

  @override
  String get replenishElectrolytes => '补充电解质';

  @override
  String get restAndRecover => '休息和恢复';

  @override
  String get avoidSugaryDrinks => '避免含糖运动饮料';

  @override
  String get elliptical => '椭圆机';

  @override
  String get rowing => '划船';

  @override
  String get jumpRope => '跳绳';

  @override
  String get stairClimbing => '爬楼梯';

  @override
  String get bodyweight => '自重';

  @override
  String get powerlifting => '力量举';

  @override
  String get calisthenics => '健美操';

  @override
  String get resistanceBands => '阻力带';

  @override
  String get kettlebell => '壶铃';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => '大力士';

  @override
  String get pilates => '普拉提';

  @override
  String get basketball => '篮球';

  @override
  String get soccerFootball => '足球';

  @override
  String get golf => '高尔夫';

  @override
  String get martialArts => '武术';

  @override
  String get rockClimbing => '攀岩';

  @override
  String get needsToReplenish => '需要补充';

  @override
  String get electrolyteTrackingPro => '追踪钠、钾和镁目标，详细进度条';

  @override
  String get unlock => '解锁';

  @override
  String get weather => '天气';

  @override
  String get weatherTrackingPro => '追踪热指数、湿度和天气对水分目标的影响';

  @override
  String get sugarTracking => '糖追踪';

  @override
  String get sugarTrackingPro => '监测天然、添加和隐藏糖摄入及HRI影响分析';

  @override
  String get dayOverview => '日概览';

  @override
  String get tapForDetails => '点击查看详情';

  @override
  String get noDataForDay => '这天无数据';

  @override
  String get sweatLoss => '流汗损失';

  @override
  String get cardio => '有氧';

  @override
  String get workout => '运动';

  @override
  String get noWaterToday => '今天未记录水';

  @override
  String get noElectrolytesToday => '今天未记录电解质';

  @override
  String get noCoffeeToday => '今天未记录咖啡';

  @override
  String get noWorkoutsToday => '今天未记录运动';

  @override
  String get noWaterThisDay => '这天未记录水';

  @override
  String get noElectrolytesThisDay => '这天未记录电解质';

  @override
  String get noCoffeeThisDay => '这天未记录咖啡';

  @override
  String get noWorkoutsThisDay => '这天未记录运动';

  @override
  String get weeklyReport => '周报告';

  @override
  String get weeklyReportSubtitle => '深度洞察和趋势分析';

  @override
  String get workouts => '运动';

  @override
  String get workoutHydration => '运动水分';

  @override
  String workoutHydrationMessage(Object percent) {
    return '运动日你喝$percent%更多水';
  }

  @override
  String get weeklyActivity => '周活动';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return '你$days天训练了$minutes分钟';
  }

  @override
  String get workoutMinutesPerDay => '每日运动分钟';

  @override
  String get daysWithWorkouts => '运动天数';

  @override
  String get noWorkoutsThisWeek => '本周无运动';

  @override
  String get noAlcoholThisWeek => '本周无酒精';

  @override
  String get csvExported => '数据已导出为CSV';

  @override
  String get mondayShort => '周一';

  @override
  String get tuesdayShort => '周二';

  @override
  String get wednesdayShort => '周三';

  @override
  String get thursdayShort => '周四';

  @override
  String get fridayShort => '周五';

  @override
  String get saturdayShort => '周六';

  @override
  String get sundayShort => '周日';

  @override
  String get achievements => '成就';

  @override
  String get achievementsTabAll => '全部';

  @override
  String get achievementsTabHydration => '水分';

  @override
  String get achievementsTabElectrolytes => '电解质';

  @override
  String get achievementsTabSugar => '糖控制';

  @override
  String get achievementsTabAlcohol => '酒精';

  @override
  String get achievementsTabWorkout => '健身';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => '连续';

  @override
  String get achievementsTabSpecial => '特别';

  @override
  String get achievementUnlocked => '成就解锁！';

  @override
  String get achievementProgress => '进度';

  @override
  String get achievementPoints => '分';

  @override
  String get achievementRarityCommon => '普通';

  @override
  String get achievementRarityUncommon => '少见';

  @override
  String get achievementRarityRare => '稀有';

  @override
  String get achievementRarityEpic => '史诗';

  @override
  String get achievementRarityLegendary => '传说';

  @override
  String get achievementStatsUnlocked => '已解锁';

  @override
  String get achievementStatsTotal => '总分';

  @override
  String get achievementFilterAll => '全部';

  @override
  String get achievementFilterUnlocked => '已解锁';

  @override
  String get achievementSortProgress => '进度';

  @override
  String get achievementSortName => '名称';

  @override
  String get achievementSortRarity => '稀有度';

  @override
  String get achievementNoAchievements => '还没有成就';

  @override
  String get achievementKeepUsing => '继续使用应用解锁成就！';

  @override
  String get achievementFirstGlass => '第一滴';

  @override
  String get achievementFirstGlassDesc => '喝你的第一杯水';

  @override
  String get achievementHydrationGoal1 => '补水';

  @override
  String get achievementHydrationGoal1Desc => '达到每日水分目标';

  @override
  String get achievementHydrationGoal7 => '一周补水';

  @override
  String get achievementHydrationGoal7Desc => '连续7天达到水分目标';

  @override
  String get achievementHydrationGoal30 => '水分大师';

  @override
  String get achievementHydrationGoal30Desc => '连续30天达到水分目标';

  @override
  String get achievementPerfectHydration => '完美平衡';

  @override
  String get achievementPerfectHydrationDesc => '达到水分目标的90-110%';

  @override
  String get achievementEarlyBird => '早起鸟';

  @override
  String get achievementEarlyBirdDesc => '上午9点前喝第一杯水';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return '上午9点前喝$volume';
  }

  @override
  String get achievementNightOwl => '夜猫子';

  @override
  String get achievementNightOwlDesc => '下午6点前完成水分目标';

  @override
  String get achievementLiterLegend => '升级传奇';

  @override
  String get achievementLiterLegendDesc => '达到总水分里程碑';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return '总共喝$volume';
  }

  @override
  String get achievementSaltStarter => '盐起步';

  @override
  String get achievementSaltStarterDesc => '添加第一份电解质';

  @override
  String get achievementElectrolyteBalance => '平衡';

  @override
  String get achievementElectrolyteBalanceDesc => '一天内达到所有电解质目标';

  @override
  String get achievementSodiumMaster => '钠大师';

  @override
  String get achievementSodiumMasterDesc => '连续7天达到钠目标';

  @override
  String get achievementPotassiumPro => '钾专家';

  @override
  String get achievementPotassiumProDesc => '连续7天达到钾目标';

  @override
  String get achievementMagnesiumMaven => '镁达人';

  @override
  String get achievementMagnesiumMavenDesc => '连续7天达到镁目标';

  @override
  String get achievementElectrolyteExpert => '电解质专家';

  @override
  String get achievementElectrolyteExpertDesc => '30天完美电解质平衡';

  @override
  String get achievementSugarAwareness => '糖意识';

  @override
  String get achievementSugarAwarenessDesc => '首次追踪糖';

  @override
  String get achievementSugarUnder25 => '甜味控制';

  @override
  String get achievementSugarUnder25Desc => '一天保持低糖摄入';

  @override
  String achievementSugarUnder25Template(String weight) {
    return '一天糖摄入低于$weight';
  }

  @override
  String get achievementSugarWeekControl => '糖纪律';

  @override
  String get achievementSugarWeekControlDesc => '一周保持低糖摄入';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return '7天糖摄入低于$weight';
  }

  @override
  String get achievementSugarFreeDay => '无糖';

  @override
  String get achievementSugarFreeDayDesc => '完成0g添加糖的一天';

  @override
  String get achievementSugarDetective => '糖侦探';

  @override
  String get achievementSugarDetectiveDesc => '追踪隐藏糖10次';

  @override
  String get achievementSugarMaster => '糖大师';

  @override
  String get achievementSugarMasterDesc => '一个月保持超低糖摄入';

  @override
  String get achievementNoSodaWeek => '无汽水周';

  @override
  String get achievementNoSodaWeekDesc => '7天无汽水';

  @override
  String get achievementNoSodaMonth => '无汽水月';

  @override
  String get achievementNoSodaMonthDesc => '30天无汽水';

  @override
  String get achievementSweetToothTamed => '驯服甜牙';

  @override
  String get achievementSweetToothTamedDesc => '一周内每日糖减少50%';

  @override
  String get achievementAlcoholTracker => '意识';

  @override
  String get achievementAlcoholTrackerDesc => '追踪酒精消费';

  @override
  String get achievementModerateDay => '节制';

  @override
  String get achievementModerateDayDesc => '一天保持低于2 SD';

  @override
  String get achievementSoberDay => '戒酒日';

  @override
  String get achievementSoberDayDesc => '完成无酒精的一天';

  @override
  String get achievementSoberWeek => '戒酒周';

  @override
  String get achievementSoberWeekDesc => '7天无酒精';

  @override
  String get achievementSoberMonth => '戒酒月';

  @override
  String get achievementSoberMonthDesc => '30天无酒精';

  @override
  String get achievementRecoveryProtocol => '恢复专家';

  @override
  String get achievementRecoveryProtocolDesc => '饮酒后完成恢复方案';

  @override
  String get achievementFirstWorkout => '开始运动';

  @override
  String get achievementFirstWorkoutDesc => '记录第一次运动';

  @override
  String get achievementWorkoutWeek => '活跃周';

  @override
  String get achievementWorkoutWeekDesc => '一周运动3次';

  @override
  String get achievementCenturySweat => '百升汗';

  @override
  String get achievementCenturySweatDesc => '通过运动流失大量液体';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return '通过运动流失$volume';
  }

  @override
  String get achievementCardioKing => '有氧王';

  @override
  String get achievementCardioKingDesc => '完成10次有氧运动';

  @override
  String get achievementStrengthWarrior => '力量战士';

  @override
  String get achievementStrengthWarriorDesc => '完成10次力量训练';

  @override
  String get achievementHRIGreen => '绿区';

  @override
  String get achievementHRIGreenDesc => '一天保持HRI在绿区';

  @override
  String get achievementHRIWeekGreen => '安全周';

  @override
  String get achievementHRIWeekGreenDesc => '7天保持HRI在绿区';

  @override
  String get achievementHRIPerfect => '完美分数';

  @override
  String get achievementHRIPerfectDesc => '达到HRI低于20';

  @override
  String get achievementHRIRecovery => '快速恢复';

  @override
  String get achievementHRIRecoveryDesc => '一天内将HRI从红色降到绿色';

  @override
  String get achievementHRIMaster => 'HRI大师';

  @override
  String get achievementHRIMasterDesc => '30天保持HRI低于30';

  @override
  String get achievementStreak3 => '起步';

  @override
  String get achievementStreak3Desc => '3天连续';

  @override
  String get achievementStreak7 => '周战士';

  @override
  String get achievementStreak7Desc => '7天连续';

  @override
  String get achievementStreak30 => '一致性王';

  @override
  String get achievementStreak30Desc => '30天连续';

  @override
  String get achievementStreak100 => '百日俱乐部';

  @override
  String get achievementStreak100Desc => '100天连续';

  @override
  String get achievementFirstWeek => '第一周';

  @override
  String get achievementFirstWeekDesc => '使用应用7天';

  @override
  String get achievementProMember => 'PRO会员';

  @override
  String get achievementProMemberDesc => '成为PRO订阅者';

  @override
  String get achievementDataExport => '数据分析师';

  @override
  String get achievementDataExportDesc => '导出数据为CSV';

  @override
  String get achievementAllCategories => '全能';

  @override
  String get achievementAllCategoriesDesc => '每个类别至少解锁一个成就';

  @override
  String get achievementHunter => '成就猎人';

  @override
  String get achievementHunterDesc => '解锁50%的所有成就';

  @override
  String get achievementDetailsUnlockedOn => '解锁于';

  @override
  String get achievementNewUnlocked => '新成就解锁！';

  @override
  String get achievementViewAll => '查看所有成就';

  @override
  String get achievementCloseNotification => '关闭';

  @override
  String get before => '之前';

  @override
  String get after => '之后';

  @override
  String get lose => '流失';

  @override
  String get through => '通过';

  @override
  String get throughWorkouts => '通过运动';

  @override
  String get reach => '达到';

  @override
  String get daysInRow => '连续天数';

  @override
  String get completeHydrationGoal => '完成水分目标';

  @override
  String get stayUnder => '保持低于';

  @override
  String get inADay => '一天内';

  @override
  String get alcoholFree => '无酒精';

  @override
  String get complete => '完成';

  @override
  String get achieve => '达成';

  @override
  String get keep => '保持';

  @override
  String get for30Days => '30天';

  @override
  String get liters => '升';

  @override
  String get completed => '已完成';

  @override
  String get notCompleted => '未完成';

  @override
  String get days => '天';

  @override
  String get hours => '小时';

  @override
  String get times => '次';

  @override
  String get row => '连续';

  @override
  String get ofTotal => '总的';

  @override
  String get perDay => '每天';

  @override
  String get perWeek => '每周';

  @override
  String get streak => '连续';

  @override
  String get tapToDismiss => '点击关闭';

  @override
  String tutorialStep1(String volume) {
    return '你好！我将帮你开始最佳水分补充之旅。让我们喝第一口$volume！';
  }

  @override
  String tutorialStep2(String volume) {
    return '太好了！现在再添加$volume感受一下。';
  }

  @override
  String get tutorialStep3 => '出色！你已准备好独立使用HydroCoach。我会帮你达到完美水分补充！';

  @override
  String get tutorialComplete => '开始使用';

  @override
  String get onboardingNotificationExamplesTitle => '智能提醒';

  @override
  String get onboardingNotificationExamplesSubtitle => 'HydroCoach知道你何时需要水';

  @override
  String get onboardingLocationExamplesTitle => '个人建议';

  @override
  String get onboardingLocationExamplesSubtitle => '我们考虑天气提供准确建议';

  @override
  String get onboardingAllowNotifications => '允许通知';

  @override
  String get onboardingAllowLocation => '允许位置';

  @override
  String get foodCatalog => '食品目录';

  @override
  String get todaysFoodIntake => '今日食物摄入';

  @override
  String get noFoodToday => '今天未记录食物';

  @override
  String foodItemsCount(int count) {
    return '$count项食物';
  }

  @override
  String get waterFromFood => '食物水分';

  @override
  String get last => '最后';

  @override
  String get categoryFruits => '水果';

  @override
  String get categoryVegetables => '蔬菜';

  @override
  String get categorySoups => '汤类';

  @override
  String get categoryDairy => '乳制品';

  @override
  String get categoryMeat => '肉类';

  @override
  String get categoryFastFood => '快餐';

  @override
  String get weightGrams => '重量(克)';

  @override
  String get enterWeight => '输入重量';

  @override
  String get grams => '克';

  @override
  String get calories => '卡路里';

  @override
  String get waterContent => '水分含量';

  @override
  String get sugar => '糖';

  @override
  String get nutritionalInfo => '营养信息';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$weight克$calories kcal';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$weight克${water}ml水';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '$weight克${sugar}g糖';
  }

  @override
  String get addFood => '添加食物';

  @override
  String get foodAdded => '食物添加成功';

  @override
  String get enterValidWeight => '请输入有效重量';

  @override
  String get proOnlyFood => '仅PRO';

  @override
  String get unlockProForFood => '解锁PRO使用全部食物';

  @override
  String get foodTracker => '食物追踪';

  @override
  String get todaysFoodSummary => '今日食物摘要';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => '每100g';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get favoritesFeatureComingSoon => '收藏功能即将推出！';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food已添加！+$calories kcal, +$water';
  }

  @override
  String get selectWeight => '选择重量';

  @override
  String get ounces => '盎司';

  @override
  String get items => '项';

  @override
  String get tapToAddFood => '点击添加食物';

  @override
  String get noFoodLoggedToday => '今天未记录食物';

  @override
  String get lightEatingDay => '轻食日';

  @override
  String get moderateIntake => '适量摄入';

  @override
  String get goodCalorieIntake => '良好卡路里';

  @override
  String get substantialMeals => '丰盛餐';

  @override
  String get highCalorieDay => '高卡日';

  @override
  String get veryHighIntake => '超高摄入';

  @override
  String get caloriesTracker => '卡路里追踪';

  @override
  String get trackYourDailyCalorieIntake => '追踪每日卡路里摄入';

  @override
  String get unlockFoodTrackingFeatures => '解锁食物追踪功能';

  @override
  String get selectFoodType => '选择食物类型';

  @override
  String get foodApple => '苹果';

  @override
  String get foodBanana => '香蕉';

  @override
  String get foodOrange => '橙子';

  @override
  String get foodWatermelon => '西瓜';

  @override
  String get foodStrawberry => '草莓';

  @override
  String get foodGrapes => '葡萄';

  @override
  String get foodPineapple => '菠萝';

  @override
  String get foodMango => '芒果';

  @override
  String get foodPear => '梨';

  @override
  String get foodCarrot => '胡萝卜';

  @override
  String get foodBroccoli => '西兰花';

  @override
  String get foodSpinach => '菠菜';

  @override
  String get foodTomato => '番茄';

  @override
  String get foodCucumber => '黄瓜';

  @override
  String get foodBellPepper => '甜椒';

  @override
  String get foodLettuce => '生菜';

  @override
  String get foodOnion => '洋葱';

  @override
  String get foodCelery => '芹菜';

  @override
  String get foodPotato => '土豆';

  @override
  String get foodChickenSoup => '鸡汤';

  @override
  String get foodTomatoSoup => '番茄汤';

  @override
  String get foodVegetableSoup => '蔬菜汤';

  @override
  String get foodMinestrone => '意式杂菜汤';

  @override
  String get foodMisoSoup => '味噌汤';

  @override
  String get foodMushroomSoup => '蘑菇汤';

  @override
  String get foodBeefStew => '炖牛肉';

  @override
  String get foodLentilSoup => '扁豆汤';

  @override
  String get foodOnionSoup => '法式洋葱汤';

  @override
  String get foodMilk => '牛奶';

  @override
  String get foodYogurt => '希腊酸奶';

  @override
  String get foodCheese => '切达奶酪';

  @override
  String get foodCottageCheese => '乡村奶酪';

  @override
  String get foodButter => '黄油';

  @override
  String get foodCream => '稀奶油';

  @override
  String get foodIceCream => '冰淇淋';

  @override
  String get foodMozzarella => '马苏里拉';

  @override
  String get foodParmesan => '帕尔马';

  @override
  String get foodChickenBreast => '鸡胸肉';

  @override
  String get foodBeef => '碎牛肉';

  @override
  String get foodSalmon => '三文鱼';

  @override
  String get foodEggs => '鸡蛋';

  @override
  String get foodTuna => '金枪鱼';

  @override
  String get foodPork => '猪排';

  @override
  String get foodTurkey => '火鸡';

  @override
  String get foodShrimp => '虾';

  @override
  String get foodBacon => '培根';

  @override
  String get foodBigMac => '巨无霸';

  @override
  String get foodPizza => '披萨';

  @override
  String get foodFrenchFries => '炸薯条';

  @override
  String get foodChickenNuggets => '鸡块';

  @override
  String get foodHotDog => '热狗';

  @override
  String get foodTacos => '玉米卷';

  @override
  String get foodSubway => '赛百味';

  @override
  String get foodDonut => '甜甜圈';

  @override
  String get foodBurgerKing => '皇堡';

  @override
  String get foodSausage => '香肠';

  @override
  String get foodKefir => '开菲尔';

  @override
  String get foodRyazhenka => '发酵奶';

  @override
  String get foodDoner => '土耳其烤肉';

  @override
  String get foodShawarma => '沙威玛';

  @override
  String get foodBorscht => '罗宋汤';

  @override
  String get foodRamen => '拉面';

  @override
  String get foodCabbage => '卷心菜';

  @override
  String get foodPeaSoup => '豌豆汤';

  @override
  String get foodSolyanka => '酸辣汤';

  @override
  String get meals => '餐';

  @override
  String get dailyProgress => '每日进度';

  @override
  String get fromFood => '来自食物';

  @override
  String get noFoodThisWeek => '本周无食物数据';

  @override
  String get foodIntake => '食物摄入';

  @override
  String get foodStats => '食物统计';

  @override
  String get totalCalories => '总卡路里';

  @override
  String get avgCaloriesPerDay => '平均/天';

  @override
  String get daysWithFood => '进食天数';

  @override
  String get avgMealsPerDay => '餐/天';

  @override
  String get caloriesPerDay => '卡路里/天';

  @override
  String get sugarPerDay => '糖/天';

  @override
  String get foodTracking => '食物追踪';

  @override
  String get foodTrackingPro => '追踪食物对水分和HRI的影响';

  @override
  String get hydrationBalance => '水分平衡';

  @override
  String get highSodiumFood => '食物高钠';

  @override
  String get hydratingFood => '优秀补水选择';

  @override
  String get dryFood => '低水分食物';

  @override
  String get balancedFood => '均衡营养';

  @override
  String get foodAdviceEmpty => '添加餐食以追踪食物对水分的影响';

  @override
  String get foodAdviceHighSodium => '检测到高钠摄入。增加水分以平衡电解质';

  @override
  String get foodAdviceLowWater => '食物水分含量低。考虑多喝水';

  @override
  String get foodAdviceGoodHydration => '很好！食物帮助补水';

  @override
  String get foodAdviceBalanced => '营养良好！记得喝水';

  @override
  String get richInElectrolytes => '电解质丰富';

  @override
  String recommendedCalories(int calories) {
    return '建议卡路里: 约$calories kcal/天';
  }

  @override
  String get proWelcomeTitle => '欢迎使用HydraCoach PRO！';

  @override
  String get proTrialActivated => '7天试用已激活！';

  @override
  String get proFeaturePersonalizedRecommendations => '个性化建议';

  @override
  String get proFeatureAdvancedAnalytics => '高级分析';

  @override
  String get proFeatureWorkoutTracking => '运动追踪';

  @override
  String get proFeatureElectrolyteControl => '电解质控制';

  @override
  String get proFeatureSmartReminders => '智能提醒';

  @override
  String get proFeatureHriIndex => 'HRI指数';

  @override
  String get proFeatureAchievements => 'PRO成就';

  @override
  String get proFeaturePersonalizedDescription => '个人水分建议';

  @override
  String get proFeatureAdvancedDescription => '详细图表和统计';

  @override
  String get proFeatureWorkoutDescription => '运动中液体流失追踪';

  @override
  String get proFeatureElectrolyteDescription => '钠、钾、镁监测';

  @override
  String get proFeatureSmartDescription => '个性化通知';

  @override
  String get proFeatureNoMoreAds => '无广告！';

  @override
  String get proFeatureNoMoreAdsDescription => '享受无广告水分追踪';

  @override
  String get proFeatureHriDescription => '实时水分风险指数';

  @override
  String get proFeatureAchievementsDescription => '专属奖励和目标';

  @override
  String get startUsing => '开始使用';

  @override
  String get sayGoodbyeToAds => '告别广告。升级高级版';

  @override
  String get goPremium => '升级高级版';

  @override
  String get removeAdsForever => '永久移除广告';

  @override
  String get upgrade => '升级';

  @override
  String get support => '支持';

  @override
  String get companyWebsite => '公司网站';

  @override
  String get appStoreOpened => '应用商店已打开';

  @override
  String get linkCopiedToClipboard => '链接已复制';

  @override
  String get shareDialogOpened => '分享对话已打开';

  @override
  String get linkForSharingCopied => '分享链接已复制';

  @override
  String get websiteOpenedInBrowser => '网站已在浏览器打开';

  @override
  String get emailClientOpened => '邮件客户端已打开';

  @override
  String get emailCopiedToClipboard => '邮件已复制';

  @override
  String get privacyPolicyOpened => '隐私政策已打开';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '统计至$dateString';
  }

  @override
  String get monthlyInsights => '月洞察';

  @override
  String get average => '平均';

  @override
  String get daysOver => '超过天数';

  @override
  String get maximum => '最大';

  @override
  String get balance => '平衡';

  @override
  String get allNormal => '全部正常';

  @override
  String get excellentConsistency => '⭐ 出色一致';

  @override
  String get goodResults => '📊 良好结果';

  @override
  String get positiveImprovement => '积极改善';

  @override
  String get physicalActivity => '💪 身体活动';

  @override
  String get coffeeConsumption => '☕ 咖啡消费';

  @override
  String get excellentSobriety => '🎯 出色戒酒';

  @override
  String get excellentMonth => '✨ 出色的月';

  @override
  String get keepGoingMotivation => '继续保持！';

  @override
  String get daysNormal => '天正常';

  @override
  String get electrolyteBalance => '电解质平衡需注意';

  @override
  String get caffeineWarning => '安全剂量超标天数(400mg)';

  @override
  String get sugarFrequentExcess => '频繁超标糖影响水分';

  @override
  String get averagePerDayShort => '每天';

  @override
  String get highWarning => '高';

  @override
  String get normalStatus => '正常';

  @override
  String improvementToEnd(int percent) {
    return '月末改善$percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent%天有运动($hours小时)';
  }

  @override
  String coffeeAverage(String avg) {
    return '平均$avg杯/天';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent%天无酒精';
  }

  @override
  String get daySummary => '日摘要';

  @override
  String get records => '记录';

  @override
  String waterGoalAchievement(int percent) {
    return '水分目标达成: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return '运动: $count次';
  }

  @override
  String get index => '指数';

  @override
  String get status => '状态';

  @override
  String get moderateRisk => '中等风险';

  @override
  String get excess => '超标';

  @override
  String get whoLimit => 'WHO限量: 50g/天';

  @override
  String stability(int percent) {
    return '$percent%天稳定';
  }

  @override
  String goodHydration(int percent) {
    return '$percent%天良好水分';
  }

  @override
  String daysInNorm(int count) {
    return '$count天正常';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent%天良好水分';
  }

  @override
  String stabilityDays(int percent) {
    return '$percent%天稳定';
  }

  @override
  String monthEndImprovement(int percent) {
    return '月末改善$percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent%天有运动($hours小时)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return '平均$avgCups杯/天';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent%天无酒精';
  }

  @override
  String get moderateRiskStatus => '状态: 中等风险';

  @override
  String get high => '高';

  @override
  String get whoLimitPerDay => 'WHO限量: 50g/天';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'HydroCoach';

  @override
  String get getPro => '獲取PRO';

  @override
  String get sunday => '週日';

  @override
  String get monday => '週一';

  @override
  String get tuesday => '週二';

  @override
  String get wednesday => '週三';

  @override
  String get thursday => '週四';

  @override
  String get friday => '週五';

  @override
  String get saturday => '週六';

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
    return '$month$day日 $weekday';
  }

  @override
  String get loading => '載入中...';

  @override
  String get loadingWeather => '獲取天氣...';

  @override
  String get heatIndex => '熱指數';

  @override
  String humidity(int value) {
    return '濕度: $value%';
  }

  @override
  String get water => '水';

  @override
  String get liquids => '液體';

  @override
  String get sodium => '鈉';

  @override
  String get potassium => '鉀';

  @override
  String get magnesium => '鎂';

  @override
  String get electrolyte => '電解質';

  @override
  String get broth => '湯';

  @override
  String get coffee => '咖啡';

  @override
  String get alcohol => '酒精';

  @override
  String get drink => '飲品';

  @override
  String get ml => '毫升';

  @override
  String get mg => '毫克';

  @override
  String get kg => '公斤';

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
    return '高溫 +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return '酒精 +$amount ml';
  }

  @override
  String get smartAdviceTitle => '當前建議';

  @override
  String get smartAdviceDefault => '保持水和電解質平衡';

  @override
  String get adviceOverhydrationSevere => '過度飲水(>目標200%)';

  @override
  String get adviceOverhydrationSevereBody =>
      '暫停60-90分鐘。補充電解質: 300-500ml含鈉500-1000mg';

  @override
  String get adviceOverhydration => '過度飲水';

  @override
  String get adviceOverhydrationBody => '暫停飲水30-60分鐘，補充約500mg鈉(電解質/湯)';

  @override
  String get adviceAlcoholRecovery => '酒精: 恢復';

  @override
  String get adviceAlcoholRecoveryBody => '今天別再喝了。少量飲用300-500ml水，補充鈉';

  @override
  String get adviceLowSodium => '鈉不足';

  @override
  String adviceLowSodiumBody(int amount) {
    return '補充約${amount}mg鈉。適量飲水';
  }

  @override
  String get adviceDehydration => '缺水';

  @override
  String adviceDehydrationBody(String type) {
    return '飲用300-500ml $type';
  }

  @override
  String get adviceHighRisk => '高風險(HRI)';

  @override
  String get adviceHighRiskBody => '緊急飲用電解質水(300-500ml)並減少活動';

  @override
  String get adviceHeat => '高溫和流失';

  @override
  String get adviceHeatBody => '水分增加5-8%，補充鈉300-500mg';

  @override
  String get adviceAllGood => '進展順利';

  @override
  String adviceAllGoodBody(int amount) {
    return '保持節奏。目標還需約${amount}ml';
  }

  @override
  String get hydrationStatus => '水分狀態';

  @override
  String get hydrationStatusNormal => '正常';

  @override
  String get hydrationStatusDiluted => '稀釋中';

  @override
  String get hydrationStatusDehydrated => '缺水';

  @override
  String get hydrationStatusLowSalt => '鹽分不足';

  @override
  String get hydrationRiskIndex => '水分風險指數';

  @override
  String get quickAdd => '快速添加';

  @override
  String get add => '添加';

  @override
  String get delete => '刪除';

  @override
  String get todaysDrinks => '今日飲品';

  @override
  String get allRecords => '全部記錄 →';

  @override
  String itemDeleted(String item) {
    return '$item已刪除';
  }

  @override
  String get undo => '撤銷';

  @override
  String get dailyReportReady => '日報完成！';

  @override
  String get viewDayResults => '查看今日結果';

  @override
  String get dailyReportComingSoon => '日報將在下一版本提供';

  @override
  String get home => '首頁';

  @override
  String get history => '歷史';

  @override
  String get settings => '設定';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get reset => '重置';

  @override
  String get settingsTitle => '設定';

  @override
  String get languageSection => '語言';

  @override
  String get languageSettings => '語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get profileSection => '個人資料';

  @override
  String get weight => '重量';

  @override
  String get dietMode => '飲食模式';

  @override
  String get activityLevel => '活動量';

  @override
  String get changeWeight => '更改體重';

  @override
  String get dietModeNormal => '正常飲食';

  @override
  String get dietModeKeto => '生酮/低碳';

  @override
  String get dietModeFasting => '間歇禁食';

  @override
  String get activityLow => '低活動量';

  @override
  String get activityMedium => '中活動量';

  @override
  String get activityHigh => '高活動量';

  @override
  String get activityLowDesc => '辦公室工作，少運動';

  @override
  String get activityMediumDesc => '每天運動30-60分鐘';

  @override
  String get activityHighDesc => '運動>1小時';

  @override
  String get notificationsSection => '通知';

  @override
  String get notificationLimit => '通知限制(免費版)';

  @override
  String notificationUsage(int used, int limit) {
    return '已用: $used/$limit';
  }

  @override
  String get waterReminders => '飲水提醒';

  @override
  String get waterRemindersDesc => '全天定期提醒';

  @override
  String get reminderFrequency => '提醒頻率';

  @override
  String timesPerDay(int count) {
    return '每天$count次';
  }

  @override
  String maxTimesPerDay(int count) {
    return '每天$count次(最多4次)';
  }

  @override
  String get unlimitedReminders => '無限制';

  @override
  String get startOfDay => '開始時間';

  @override
  String get endOfDay => '結束時間';

  @override
  String get postCoffeeReminders => '咖啡後提醒';

  @override
  String get postCoffeeRemindersDesc => '20分鐘後提醒飲水';

  @override
  String get heatWarnings => '高溫警告';

  @override
  String get heatWarningsDesc => '高溫時通知';

  @override
  String get postAlcoholReminders => '飲酒後提醒';

  @override
  String get postAlcoholRemindersDesc => '6-12小時恢復計劃';

  @override
  String get proFeaturesSection => 'PRO功能';

  @override
  String get unlockPro => '解鎖PRO';

  @override
  String get unlockProDesc => '無限通知和智慧提醒';

  @override
  String get noNotificationLimit => '無通知限制';

  @override
  String get unitsSection => '單位';

  @override
  String get metricSystem => '公制';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => '英制';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => '關於';

  @override
  String get version => '版本';

  @override
  String get rateApp => '評價應用';

  @override
  String get share => '分享';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get termsOfUse => '使用條款';

  @override
  String get resetAllData => '重置所有資料';

  @override
  String get resetDataTitle => '重置所有資料？';

  @override
  String get resetDataMessage => '將刪除所有歷史並恢復預設設定';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get start => '開始';

  @override
  String get welcomeTitle => '歡迎使用\nHydroCoach';

  @override
  String get welcomeSubtitle => '智慧水分和電解質追蹤\n適用於生酮、禁食和活躍生活';

  @override
  String get weightPageTitle => '您的體重';

  @override
  String get weightPageSubtitle => '計算最佳水分攝入量';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return '建議: 每天$min-${max}ml';
  }

  @override
  String get dietPageTitle => '飲食模式';

  @override
  String get dietPageSubtitle => '影響電解質需求';

  @override
  String get normalDiet => '正常飲食';

  @override
  String get normalDietDesc => '標準建議';

  @override
  String get ketoDiet => '生酮/低碳';

  @override
  String get ketoDietDesc => '需增加鹽分';

  @override
  String get fastingDiet => '間歇禁食';

  @override
  String get fastingDietDesc => '特殊電解質方案';

  @override
  String get fastingSchedule => '禁食計劃:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => '每天8小時進食窗口';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => '一日一餐';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => '隔日禁食';

  @override
  String get activityPageTitle => '活動量';

  @override
  String get activityPageSubtitle => '影響水分需求';

  @override
  String get lowActivity => '低活動量';

  @override
  String get lowActivityDesc => '辦公室工作，少運動';

  @override
  String get lowActivityWater => '+0 ml';

  @override
  String get mediumActivity => '中活動量';

  @override
  String get mediumActivityDesc => '每天運動30-60分鐘';

  @override
  String get mediumActivityWater => '+350-700 ml';

  @override
  String get highActivity => '高活動量';

  @override
  String get highActivityDesc => '運動>1小時或體力勞動';

  @override
  String get highActivityWater => '+700-1200 ml';

  @override
  String get activityAdjustmentNote => '根據運動調整目標';

  @override
  String get day => '日';

  @override
  String get week => '週';

  @override
  String get month => '月';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get noData => '無資料';

  @override
  String get noRecordsToday => '今天還沒有記錄';

  @override
  String get noRecordsThisDay => '這天沒有記錄';

  @override
  String get loadingData => '載入中...';

  @override
  String get deleteRecord => '刪除記錄？';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '刪除$type $volume ml？';
  }

  @override
  String get recordDeleted => '已刪除';

  @override
  String get waterConsumption => '💧 飲水量';

  @override
  String get alcoholWeek => '🍺 本週飲酒';

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
  String get weeklyInsights => '💡 週洞察';

  @override
  String get waterPerDay => '每日水分';

  @override
  String get sodiumPerDay => '每日鈉';

  @override
  String get potassiumPerDay => '每日鉀';

  @override
  String get magnesiumPerDay => '每日鎂';

  @override
  String get goal => '目標';

  @override
  String get daysWithGoalAchieved => '✅ 達標天數';

  @override
  String get recordsPerDay => '📝 每日記錄';

  @override
  String get insufficientDataForAnalysis => '資料不足';

  @override
  String get totalVolume => '總量';

  @override
  String averagePerDay(int amount) {
    return '平均$amount ml/天';
  }

  @override
  String get activeDays => '活躍天數';

  @override
  String perfectDays(int count) {
    return '$count天';
  }

  @override
  String currentStreak(int days) {
    return '連續: $days天';
  }

  @override
  String soberDaysRow(int days) {
    return '連續戒酒: $days天';
  }

  @override
  String get keepItUp => '繼續保持！';

  @override
  String waterAmount(int amount, int percent) {
    return '水: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return '酒精: $amount SD';
  }

  @override
  String get totalSD => '總SD';

  @override
  String get forMonth => '本月';

  @override
  String get daysWithAlcohol => '飲酒天數';

  @override
  String fromDays(int days) {
    return '$days天中';
  }

  @override
  String get soberDays => '戒酒天數';

  @override
  String get excellent => '優秀！';

  @override
  String get averageSD => '平均SD';

  @override
  String get inDrinkingDays => '飲酒日';

  @override
  String get bestDay => '🏆 最佳';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - 目標$percent%';
  }

  @override
  String get weekends => '📅 週末';

  @override
  String get weekdays => '📅 工作日';

  @override
  String drinkLessOnWeekends(int percent) {
    return '週末少喝$percent%';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return '工作日少喝$percent%';
  }

  @override
  String get positiveTrend => '📈 積極趨勢';

  @override
  String get positiveTrendMessage => '週末水分攝入改善';

  @override
  String get decliningActivity => '📉 下降趨勢';

  @override
  String get decliningActivityMessage => '週末水分攝入減少';

  @override
  String get lowSalt => '⚠️ 鹽分不足';

  @override
  String lowSaltMessage(int days) {
    return '僅$days天鈉正常';
  }

  @override
  String get frequentAlcohol => '🍺 頻繁飲酒';

  @override
  String frequentAlcoholMessage(int days) {
    return '7天中$days天飲酒影響水分';
  }

  @override
  String get excellentWeek => '✅ 優秀的一週';

  @override
  String get continueMessage => '繼續保持！';

  @override
  String get all => '全部';

  @override
  String get addAlcohol => '添加酒精';

  @override
  String get minimumHarm => '最小危害';

  @override
  String additionalWaterNeeded(int amount) {
    return '需補水+$amount ml';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '需補鈉+$amount mg';
  }

  @override
  String get goToBedEarly => '早睡';

  @override
  String get todayConsumed => '今日攝入:';

  @override
  String get alcoholToday => '今日飲酒';

  @override
  String get beer => '啤酒';

  @override
  String get wine => '葡萄酒';

  @override
  String get spirits => '烈酒';

  @override
  String get cocktail => '雞尾酒';

  @override
  String get selectDrinkType => '選擇酒類:';

  @override
  String get volume => '容量';

  @override
  String get enterVolume => '輸入ml';

  @override
  String get strength => '力量';

  @override
  String get standardDrinks => '標準杯:';

  @override
  String get additionalWater => '補水';

  @override
  String get additionalSodium => '補鈉';

  @override
  String get hriRisk => 'HRI風險';

  @override
  String get enterValidVolume => '請輸入有效容量';

  @override
  String get weeklyHistory => '週歷史';

  @override
  String get weeklyHistoryDesc => '分析週趨勢，獲得見解和建議';

  @override
  String get monthlyHistory => '月歷史';

  @override
  String get monthlyHistoryDesc => '長期模式、週比較和深度分析';

  @override
  String get proFunction => 'PRO功能';

  @override
  String get unlockProHistory => '解鎖PRO';

  @override
  String get unlimitedHistory => '無限歷史';

  @override
  String get dataExportCSV => '匯出CSV';

  @override
  String get detailedAnalytics => '詳細分析';

  @override
  String get periodComparison => '期間比較';

  @override
  String get shareResult => '分享結果';

  @override
  String get retry => '重試';

  @override
  String get welcomeToPro => '歡迎使用PRO！';

  @override
  String get allFeaturesUnlocked => '所有功能已解鎖';

  @override
  String get testMode => '測試模式: 模擬購買';

  @override
  String get proStatusNote => 'PRO狀態將保持到應用重啟';

  @override
  String get startUsingPro => '開始使用PRO';

  @override
  String get lifetimeAccess => '終身訪問';

  @override
  String get bestValueAnnual => '最划算 — 年付';

  @override
  String get monthly => '月付';

  @override
  String get oneTime => '一次性';

  @override
  String get perYear => '/年';

  @override
  String get perMonth => '/月';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/月';
  }

  @override
  String get startFreeTrial => '開始7天免費試用';

  @override
  String continueWithPrice(String price) {
    return '繼續 — $price';
  }

  @override
  String unlockForPrice(String price) {
    return '解鎖$price(一次性)';
  }

  @override
  String get enableFreeTrial => '啟用7天免費試用';

  @override
  String get noChargeToday => '今天不收費。7天後自動續訂，除非取消';

  @override
  String get cancelAnytime => '可隨時在設定中取消';

  @override
  String get everythingInPro => 'PRO全部功能';

  @override
  String get smartReminders => '智慧提醒';

  @override
  String get smartRemindersDesc => '高溫、運動、禁食 — 無垃圾訊息';

  @override
  String get weeklyReports => '週報告';

  @override
  String get weeklyReportsDesc => '深度洞察 + CSV匯出';

  @override
  String get healthIntegrations => '健康整合';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit';

  @override
  String get alcoholProtocols => '飲酒方案';

  @override
  String get alcoholProtocolsDesc => '飲前準備和恢復路線圖';

  @override
  String get fullSync => '完全同步';

  @override
  String get fullSyncDesc => '跨裝置無限歷史';

  @override
  String get personalCalibrations => '個人校準';

  @override
  String get personalCalibrationsDesc => '汗液測試、尿色量表';

  @override
  String get showAllFeatures => '顯示全部功能';

  @override
  String get showLess => '收起';

  @override
  String get restorePurchases => '恢復購買';

  @override
  String get proSubscriptionRestored => 'PRO訂閱已恢復！';

  @override
  String get noPurchasesToRestore => '沒有找到要恢復的購買';

  @override
  String get drinkMoreWaterToday => '今天多喝水(+20%)';

  @override
  String get addElectrolytesToWater => '每次飲水添加電解質';

  @override
  String get limitCoffeeOneCup => '咖啡限制一杯';

  @override
  String get increaseWater10 => '水分增加10%';

  @override
  String get dontForgetElectrolytes => '別忘了電解質';

  @override
  String get startDayWithWater => '以一杯水開始新的一天';

  @override
  String get dontForgetElectrolytesReminder => '⚡ 別忘了電解質';

  @override
  String get startDayWithWaterReminder => '以一杯水開始新的一天，保持健康';

  @override
  String get takeElectrolytesMorning => '早上補充電解質';

  @override
  String purchaseFailed(String error) {
    return '購買失敗: $error';
  }

  @override
  String restoreFailed(String error) {
    return '恢復失敗: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — 12,000用戶信賴';

  @override
  String get bestValue => '最划算';

  @override
  String percentOff(int percent) {
    return '-$percent% 最划算';
  }

  @override
  String get weatherUnavailable => '天氣不可用';

  @override
  String get checkLocationPermissions => '檢查位置權限和網路';

  @override
  String get recommendedNormLabel => '建議量';

  @override
  String get waterAdjustment300 => '+300 ml';

  @override
  String get waterAdjustment400 => '+400 ml';

  @override
  String get waterAdjustment200 => '+200 ml';

  @override
  String get waterAdjustmentNormal => '正常';

  @override
  String get waterAdjustment500 => '+500 ml';

  @override
  String get waterAdjustment250 => '+250 ml';

  @override
  String get waterAdjustment750 => '+750 ml';

  @override
  String get currentLocation => '當前位置';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherOvercast => '陰天';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '暴風雨';

  @override
  String get weatherFog => '霧';

  @override
  String get weatherDrizzle => '小雨';

  @override
  String get weatherSunny => '晴朗';

  @override
  String get heatWarningExtreme => '☀️ 極端高溫！最大補水';

  @override
  String get heatWarningVeryHot => '🌡️ 非常熱！脫水風險';

  @override
  String get heatWarningHot => '🔥 炎熱！多喝水';

  @override
  String get heatWarningElevated => '⚠️ 溫度升高';

  @override
  String get heatWarningComfortable => '舒適溫度';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% 水';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg 鈉';
  }

  @override
  String get heatWarningCold => '❄️ 寒冷！保暖並喝溫熱液體';

  @override
  String get notificationChannelName => 'HydroCoach提醒';

  @override
  String get notificationChannelDescription => '水和電解質提醒';

  @override
  String get urgentNotificationChannelName => '緊急提醒';

  @override
  String get urgentNotificationChannelDescription => '重要水分通知';

  @override
  String get goodMorning => '☀️ 早上好！';

  @override
  String get timeToHydrate => '💧 水分補充時間';

  @override
  String get eveningHydration => '💧 晚間水分補充';

  @override
  String get dailyReportTitle => ' 日報完成';

  @override
  String get dailyReportBody => '查看你的水分情況';

  @override
  String get maintainWaterBalance => '全天保持水分平衡';

  @override
  String get electrolytesTime => '電解質時間: 水中加少量鹽';

  @override
  String catchUpHydration(int percent) {
    return '你只喝了每日目標的$percent%。該補上了！';
  }

  @override
  String get excellentProgress => '進展優秀！再接再厲達成目標';

  @override
  String get postCoffeeTitle => ' 咖啡後';

  @override
  String get postCoffeeBody => '喝250-300ml水恢復平衡';

  @override
  String get postWorkoutTitle => ' 運動後';

  @override
  String get postWorkoutBody => '恢復電解質: 500ml水 + 少量鹽';

  @override
  String get heatWarningPro => '🌡️ PRO高溫警告';

  @override
  String get extremeHeatWarning => '極熱！水分增加15%，加1g鹽';

  @override
  String get hotWeatherWarning => '炎熱！多喝10%水，別忘電解質';

  @override
  String get warmWeatherWarning => '溫暖。監測水分狀態';

  @override
  String get alcoholRecoveryTitle => '🍺 恢復時間';

  @override
  String get alcoholRecoveryBody => '喝300ml水加少量鹽恢復平衡';

  @override
  String get continueHydration => '💧 繼續補水';

  @override
  String get alcoholRecoveryBody2 => '再喝500ml水幫助更快恢復';

  @override
  String get morningRecoveryTitle => '☀️ 晨間恢復';

  @override
  String get morningRecoveryBody => '以500ml水和電解質開始新的一天';

  @override
  String get testNotificationTitle => '🧪 測試通知';

  @override
  String get testNotificationBody => '如果你看到這個 - 即時通知有效！';

  @override
  String get scheduledTestTitle => '⏰ 定時測試(1分鐘)';

  @override
  String get scheduledTestBody => '此通知在1分鐘前安排。定時有效！';

  @override
  String get notificationServiceInitialized => '✅ 通知服務已初始化';

  @override
  String get localNotificationsInitialized => '✅ 本地通知已初始化';

  @override
  String get androidChannelsCreated => '📢 Android通知頻道已建立';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 通知權限：$granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 精確鬧鐘權限：$granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM權限：$status';
  }

  @override
  String get fcmTokenReceived => '🔑 已收到FCM Token';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ 用戶$userId的FCM Token已儲存到Firestore';
  }

  @override
  String get topicSubscriptionComplete => '✅ 主題訂閱完成';

  @override
  String foregroundMessage(String title) {
    return '📨 前景訊息：$title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 通知已開啟：$messageId';
  }

  @override
  String get dailyLimitReached => '⚠️ 已達每日通知限制(免費版4/天)';

  @override
  String schedulingError(String error) {
    return '❌ 通知預定錯誤：$error';
  }

  @override
  String get showingImmediatelyAsFallback => '立即顯示通知作為備用';

  @override
  String instantNotificationShown(String title) {
    return '📬 已顯示即時通知：$title';
  }

  @override
  String get smartRemindersScheduled => '🧠 預定智能提醒中...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ 已預定$count個提醒';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO：咖啡後提醒已預定';

  @override
  String get postWorkoutScheduled => '💪 運動後提醒已預定';

  @override
  String get proHeatWarningPro => '🌡️ PRO：高溫警告已發送';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO：酒精恢復計劃已預定';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 晚間報告已預定於$day.$month 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 通知$id已取消';
  }

  @override
  String get allNotificationsCancelled => '🗑️ 所有通知已取消';

  @override
  String get reminderSettingsSaved => '✅ 提醒設定已儲存';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ 測試通知已預定於$time';
  }

  @override
  String get tomorrowRecommendations => '明日建議';

  @override
  String get recommendationExcellent => '優秀！保持下去。嘗試以一杯水開始新的一天並保持均勻攝取。';

  @override
  String get recommendationDiluted => '您喝很多水但電解質少。明天多加鹽或喝電解質飲料。嘗試以鹽湯開始新的一天。';

  @override
  String get recommendationDehydrated => '今天水不夠。明天每2小時設定提醒。將水瓶放在視線內。';

  @override
  String get recommendationLowSalt => '低鈉可能導致疲勞。在水中加少許鹽或喝湯。在生酮或斷食時特別重要。';

  @override
  String get recommendationGeneral => '追求水和電解質平衡。全天均勻飲水並在炎熱時別忘鹽。';

  @override
  String get category_water => '水';

  @override
  String get category_hot_drinks => '熱飲';

  @override
  String get category_juice => '果汁';

  @override
  String get category_sports => '運動';

  @override
  String get category_dairy => '乳製品';

  @override
  String get category_alcohol => '酒精';

  @override
  String get category_supplements => '補充劑';

  @override
  String get category_other => '其他';

  @override
  String get drink_water => '水';

  @override
  String get drink_sparkling_water => '氣泡水';

  @override
  String get drink_mineral_water => '礦泉水';

  @override
  String get drink_coconut_water => '椰子水';

  @override
  String get drink_coffee => '咖啡';

  @override
  String get drink_espresso => '濃縮咖啡';

  @override
  String get drink_americano => '美式';

  @override
  String get drink_cappuccino => '卡布奇諾';

  @override
  String get drink_latte => '拿鐵';

  @override
  String get drink_black_tea => '紅茶';

  @override
  String get drink_green_tea => '綠茶';

  @override
  String get drink_herbal_tea => '花草茶';

  @override
  String get drink_matcha => '抹茶';

  @override
  String get drink_hot_chocolate => '熱巧克力';

  @override
  String get drink_orange_juice => '柳橙汁';

  @override
  String get drink_apple_juice => '蘋果汁';

  @override
  String get drink_grapefruit_juice => '葡萄柚汁';

  @override
  String get drink_tomato_juice => '番茄汁';

  @override
  String get drink_vegetable_juice => '蔬菜汁';

  @override
  String get drink_smoothie => '冰沙';

  @override
  String get drink_lemonade => '檸檬水';

  @override
  String get drink_isotonic => '等滲飲料';

  @override
  String get drink_electrolyte => '電解質飲料';

  @override
  String get drink_protein_shake => '蛋白奶昔';

  @override
  String get drink_bcaa => 'BCAA';

  @override
  String get drink_energy => '能量飲料';

  @override
  String get drink_milk => '牛奶';

  @override
  String get drink_kefir => '克菲爾';

  @override
  String get drink_yogurt => '優格飲';

  @override
  String get drink_almond_milk => '杏仁奶';

  @override
  String get drink_soy_milk => '豆漿';

  @override
  String get drink_oat_milk => '燕麥奶';

  @override
  String get drink_beer_light => '淡啤酒';

  @override
  String get drink_beer_regular => '普通啤酒';

  @override
  String get drink_beer_strong => '濃啤酒';

  @override
  String get drink_wine_red => '紅酒';

  @override
  String get drink_wine_white => '白酒';

  @override
  String get drink_champagne => '香檳';

  @override
  String get drink_vodka => '伏特加';

  @override
  String get drink_whiskey => '威士忌';

  @override
  String get drink_rum => '蘭姆酒';

  @override
  String get drink_gin => '琴酒';

  @override
  String get drink_tequila => '龍舌蘭';

  @override
  String get drink_mojito => '莫希托';

  @override
  String get drink_margarita => '瑪格麗特';

  @override
  String get drink_kombucha => '康普茶';

  @override
  String get drink_kvass => '克瓦斯';

  @override
  String get drink_bone_broth => '骨湯';

  @override
  String get drink_vegetable_broth => '蔬菜湯';

  @override
  String get drink_soda => '汽水';

  @override
  String get drink_diet_soda => '無糖汽水';

  @override
  String get addedToFavorites => '已加入我的最愛';

  @override
  String get favoriteLimitReached => '已達上限(免費3個,PRO 20個)';

  @override
  String get addFavorite => '加入最愛';

  @override
  String get hotAndSupplements => '熱飲&補充劑';

  @override
  String get quickVolumes => '快速容量:';

  @override
  String get type => '類型:';

  @override
  String get regular => '普通';

  @override
  String get coconut => '椰子';

  @override
  String get sparkling => '氣泡';

  @override
  String get mineral => '礦泉';

  @override
  String get hotDrinks => '熱飲';

  @override
  String get supplements => '補充劑';

  @override
  String get tea => '茶';

  @override
  String get salt => '鹽(1/4茶匙)';

  @override
  String get electrolyteMix => '電解質混合';

  @override
  String get boneBroth => '骨湯';

  @override
  String get favoriteAssignmentComingSoon => '最愛指定即將推出';

  @override
  String get longPressToEditComingSoon => '長按編輯 - 即將推出';

  @override
  String get proSubscriptionRequired => '需要PRO訂閱';

  @override
  String get saveToFavorites => '儲存至最愛';

  @override
  String get savedToFavorites => '已儲存至最愛';

  @override
  String get selectFavoriteSlot => '選擇最愛欄位';

  @override
  String get slot => '欄位';

  @override
  String get emptySlot => '空欄位';

  @override
  String get upgradeToUnlock => '升級PRO解鎖';

  @override
  String get changeFavorite => '變更最愛';

  @override
  String get removeFavorite => '移除最愛';

  @override
  String get ok => '確定';

  @override
  String get mineralWater => '礦泉水';

  @override
  String get coconutWater => '椰子水';

  @override
  String get lemonWater => '檸檬水';

  @override
  String get greenTea => '綠茶';

  @override
  String get amount => '數量';

  @override
  String get createFavoriteHint => '要新增最愛，請前往下方飲品畫面，設定後點擊「儲存至最愛」。';

  @override
  String get sparklingWater => '氣泡水';

  @override
  String get cola => '可樂';

  @override
  String get juice => '果汁';

  @override
  String get energyDrink => '能量飲料';

  @override
  String get sportsDrink => '運動飲料';

  @override
  String get selectElectrolyteType => '選擇電解質類型:';

  @override
  String get saltQuarterTsp => '鹽(1/4茶匙)';

  @override
  String get pinkSalt => '喜馬拉雅粉鹽';

  @override
  String get seaSalt => '海鹽';

  @override
  String get potassiumCitrate => '檸檬酸鉀';

  @override
  String get magnesiumGlycinate => '甘胺酸鎂';

  @override
  String get coconutWaterElectrolyte => '椰子水';

  @override
  String get sportsDrinkElectrolyte => '運動飲料';

  @override
  String get electrolyteContent => '電解質含量:';

  @override
  String sodiumContent(int amount) {
    return '鈉: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return '鉀: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return '鎂: $amount mg';
  }

  @override
  String get servings => '份量';

  @override
  String get enterServings => '輸入份量';

  @override
  String get servingsUnit => '份';

  @override
  String get noElectrolytes => '無電解質';

  @override
  String get enterValidAmount => '請輸入有效數量';

  @override
  String get lmntMix => 'LMNT混合';

  @override
  String get pickleJuice => '醃黃瓜汁';

  @override
  String get tomatoSalt => '番茄+鹽';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => '鹼性水';

  @override
  String get celticSalt => '凱爾特鹽水';

  @override
  String get soleWater => 'Sole水';

  @override
  String get mineralDrops => '礦物質滴劑';

  @override
  String get bakingSoda => '小蘇打水';

  @override
  String get creamTartar => '酒石酸鉀';

  @override
  String get selectSupplementType => '選擇補充劑類型:';

  @override
  String get multivitamin => '綜合維生素';

  @override
  String get magnesiumCitrate => '檸檬酸鎂';

  @override
  String get magnesiumThreonate => '蘇糖酸鎂L';

  @override
  String get calciumCitrate => '檸檬酸鈣';

  @override
  String get zincGlycinate => '甘胺酸鋅';

  @override
  String get vitaminD3 => '維生素D3';

  @override
  String get vitaminC => '維生素C';

  @override
  String get bComplex => 'B群';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => '雙甘胺酸鐵';

  @override
  String get dosage => '劑量';

  @override
  String get enterDosage => '輸入劑量';

  @override
  String get noElectrolyteContent => '無電解質含量';

  @override
  String get blackTea => '紅茶';

  @override
  String get herbalTea => '花草茶';

  @override
  String get espresso => '濃縮咖啡';

  @override
  String get cappuccino => '卡布奇諾';

  @override
  String get latte => '拿鐵';

  @override
  String get matcha => '抹茶';

  @override
  String get hotChocolate => '熱巧克力';

  @override
  String get caffeine => '咖啡因';

  @override
  String get sports => '運動';

  @override
  String get walking => '步行';

  @override
  String get running => '跑步';

  @override
  String get gym => '健身房';

  @override
  String get cycling => '騎車';

  @override
  String get swimming => '游泳';

  @override
  String get yoga => '瑜伽';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => '拳擊';

  @override
  String get dancing => '跳舞';

  @override
  String get tennis => '網球';

  @override
  String get teamSports => '團隊運動';

  @override
  String get selectActivityType => '選擇活動類型:';

  @override
  String get duration => '時長';

  @override
  String get minutes => '分鐘';

  @override
  String get enterDuration => '輸入時長';

  @override
  String get lowIntensity => '低強度';

  @override
  String get mediumIntensity => '中強度';

  @override
  String get highIntensity => '高強度';

  @override
  String get recommendedIntake => '建議攝取:';

  @override
  String get basedOnWeight => '基於體重';

  @override
  String get logActivity => '記錄活動';

  @override
  String get activityLogged => '活動已記錄';

  @override
  String get enterValidDuration => '請輸入有效時長';

  @override
  String get sauna => '桑拿';

  @override
  String get veryHighIntensity => '極高強度';

  @override
  String get hriStatusExcellent => '優秀';

  @override
  String get hriStatusGood => '良好';

  @override
  String get hriStatusModerate => '中度風險';

  @override
  String get hriStatusHighRisk => '高風險';

  @override
  String get hriStatusCritical => '危急';

  @override
  String get hriComponentWater => '水分平衡';

  @override
  String get hriComponentSodium => '鈉水平';

  @override
  String get hriComponentPotassium => '鉀水平';

  @override
  String get hriComponentMagnesium => '鎂水平';

  @override
  String get hriComponentHeat => '熱壓力';

  @override
  String get hriComponentWorkout => '身體活動';

  @override
  String get hriComponentCaffeine => '咖啡因影響';

  @override
  String get hriComponentAlcohol => '酒精影響';

  @override
  String get hriComponentTime => '攝取後時間';

  @override
  String get hriComponentMorning => '晨間因子';

  @override
  String get hriBreakdownTitle => '風險因子分解';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max 分';
  }

  @override
  String get fastingModeActive => '斷食模式活躍';

  @override
  String get fastingSuppressionNote => '斷食期間時間因子被抑制';

  @override
  String get morningCheckInTitle => '晨間檢查';

  @override
  String get howAreYouFeeling => '您感覺如何？';

  @override
  String get feelingScale1 => '差';

  @override
  String get feelingScale2 => '低於平均';

  @override
  String get feelingScale3 => '正常';

  @override
  String get feelingScale4 => '好';

  @override
  String get feelingScale5 => '優秀';

  @override
  String get weightChange => '自昨天體重變化';

  @override
  String get urineColorScale => '尿液顏色(1-8級)';

  @override
  String get urineColor1 => '1 - 非常淡';

  @override
  String get urineColor2 => '2 - 淡';

  @override
  String get urineColor3 => '3 - 淺黃';

  @override
  String get urineColor4 => '4 - 黃';

  @override
  String get urineColor5 => '5 - 深黃';

  @override
  String get urineColor6 => '6 - 琥珀色';

  @override
  String get urineColor7 => '7 - 深琥珀';

  @override
  String get urineColor8 => '8 - 棕色';

  @override
  String get alcoholWithDecay => '酒精影響(衰減中)';

  @override
  String standardDrinksToday(Object count) {
    return '今天標準杯數: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return '活躍咖啡因: $amount mg';
  }

  @override
  String get hriDebugInfo => 'HRI除錯資訊';

  @override
  String hriNormalized(Object value) {
    return 'HRI(標準化): $value/100';
  }

  @override
  String get fastingWindowActive => '斷食窗口活躍';

  @override
  String get eatingWindowActive => '進食窗口活躍';

  @override
  String nextFastingWindow(Object time) {
    return '下次斷食: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return '下次進食: $time';
  }

  @override
  String get todaysWorkouts => '今日運動';

  @override
  String get hoursAgo => '小時前';

  @override
  String get onboardingWelcomeTitle => 'HydroCoach — 每天智能補水';

  @override
  String get onboardingWelcomeSubtitle =>
      '聰明喝，不是多喝\n應用程式考慮天氣、電解質和您的習慣\n幫助保持清晰思維和穩定能量';

  @override
  String get onboardingBullet1 => '基於天氣和您的個人水和鹽標準';

  @override
  String get onboardingBullet2 => '「現在該做什麼」提示而非原始圖表';

  @override
  String get onboardingBullet3 => '標準杯酒精與安全限量';

  @override
  String get onboardingBullet4 => '智能提醒無垃圾訊息';

  @override
  String get onboardingStartButton => '開始';

  @override
  String get onboardingHaveAccount => '我已有帳戶';

  @override
  String get onboardingPracticeFasting => '我實行間歇性斷食';

  @override
  String get onboardingPracticeFastingDesc => '斷食窗口特殊電解質方案';

  @override
  String get onboardingProfileReady => '配置檔已準備好！';

  @override
  String get onboardingWaterNorm => '水分標準';

  @override
  String get onboardingIonWillHelp => 'ION每天幫助保持平衡';

  @override
  String get onboardingContinue => '繼續';

  @override
  String get onboardingLocationTitle => '天氣對補水很重要';

  @override
  String get onboardingLocationSubtitle => '我們會考慮天氣和濕度。這比僅根據體重的公式更準確';

  @override
  String get onboardingWeatherExample => '今天熱！+15%水';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg鈉應對高溫';

  @override
  String get onboardingEnablePermission => '啟用';

  @override
  String get onboardingEnableLater => '稍後啟用';

  @override
  String get onboardingNotificationTitle => '智能提醒';

  @override
  String get onboardingNotificationSubtitle => '在適當時刻簡短提示。您可以一鍵改變頻率';

  @override
  String get onboardingNotifExample1 => '補水時間';

  @override
  String get onboardingNotifExample2 => '別忘電解質';

  @override
  String get onboardingNotifExample3 => '熱！多喝水';

  @override
  String get sportRecoveryProtocols => '運動恢復方案';

  @override
  String get allDrinksAndSupplements => '所有飲品&補充劑';

  @override
  String get notificationChannelDefault => '補水提醒';

  @override
  String get notificationChannelDefaultDesc => '水和電解質提醒';

  @override
  String get notificationChannelUrgent => '重要通知';

  @override
  String get notificationChannelUrgentDesc => '高溫警告和緊急補水警報';

  @override
  String get notificationChannelReport => '報告';

  @override
  String get notificationChannelReportDesc => '每日和每週報告';

  @override
  String get notificationWaterTitle => '💧 補水時間';

  @override
  String get notificationWaterBody => '別忘喝水';

  @override
  String get notificationPostCoffeeTitle => '☕ 喝咖啡後';

  @override
  String get notificationPostCoffeeBody => '喝250-300 ml水恢復平衡';

  @override
  String get notificationDailyReportTitle => '📊 每日報告已準備好';

  @override
  String get notificationDailyReportBody => '查看您的補水日';

  @override
  String get notificationAlcoholCounterTitle => '🍺 恢復時間';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return '喝$ml ml水加少許鹽';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ 高溫警告';

  @override
  String get notificationHeatWarningExtremeBody => '極端高溫！+15%水和+1g鹽';

  @override
  String get notificationHeatWarningHotBody => '熱！+10%水和電解質';

  @override
  String get notificationHeatWarningWarmBody => '溫暖。監測您的補水';

  @override
  String get notificationWorkoutTitle => '💪 運動';

  @override
  String get notificationWorkoutBody => '別忘水和電解質';

  @override
  String get notificationPostWorkoutTitle => '💪 運動後';

  @override
  String get notificationPostWorkoutBody => '500 ml水+電解質恢復';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ 電解質時間';

  @override
  String get notificationFastingElectrolyteBody => '在水中加少許鹽或喝湯';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 恢復${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return '喝$ml ml水';
  }

  @override
  String get notificationAlcoholRecoveryMidBody => '添加電解質: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody => '明早 - 控制檢查';

  @override
  String get notificationMorningCheckInTitle => '☀️ 晨間檢查';

  @override
  String get notificationMorningCheckInBody => '感覺如何？評估狀態並獲得當日計劃';

  @override
  String get notificationMorningWaterBody => '以一杯水開始新的一天';

  @override
  String notificationLowProgressBody(int percent) {
    return '您只喝了$percent%。該追上了！';
  }

  @override
  String get notificationGoodProgressBody => '優秀進展！繼續';

  @override
  String get notificationMaintainBalanceBody => '保持水分平衡';

  @override
  String get notificationTestTitle => '🧪 測試通知';

  @override
  String get notificationTestBody => '如果您看到這個 - 通知有效！';

  @override
  String get notificationTestScheduledTitle => '⏰ 預定測試';

  @override
  String get notificationTestScheduledBody => '此通知在1分鐘前預定';

  @override
  String get onboardingUnitsTitle => '選擇您的單位';

  @override
  String get onboardingUnitsSubtitle => '您稍後無法變更此設定';

  @override
  String get onboardingUnitsWarning => '此選擇是永久的且稍後無法變更';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => '加侖';

  @override
  String get lb => 'lb';

  @override
  String get target => '目標';

  @override
  String get wind => '風';

  @override
  String get pressure => '氣壓';

  @override
  String get highHeatIndexWarning => '高熱指數！增加水分攝取';

  @override
  String get weatherCondition => '狀況';

  @override
  String get feelsLike => '體感';

  @override
  String get humidityLabel => '濕度';

  @override
  String get waterNormal => '正常';

  @override
  String get sodiumNormal => '標準';

  @override
  String get addedSuccessfully => '成功添加';

  @override
  String get sugarIntake => '糖攝入';

  @override
  String get sugarToday => '今天的糖消耗';

  @override
  String get totalSugar => '總糖';

  @override
  String get dailyLimit => '每日限量';

  @override
  String get addedSugar => '添加糖';

  @override
  String get naturalSugar => '天然糖';

  @override
  String get hiddenSugar => '隱藏糖';

  @override
  String get sugarFromDrinks => '飲品';

  @override
  String get sugarFromFood => '食物';

  @override
  String get sugarFromSnacks => '零食';

  @override
  String get sugarNormal => '正常';

  @override
  String get sugarModerate => '適度';

  @override
  String get sugarHigh => '高';

  @override
  String get sugarCritical => '危急';

  @override
  String get sugarRecommendationNormal => '做得好！您的糖攝入在健康範圍內';

  @override
  String get sugarRecommendationModerate => '考慮減少甜飲料和零食';

  @override
  String get sugarRecommendationHigh => '糖攝入高！限制甜飲料和甜點';

  @override
  String get sugarRecommendationCritical => '糖非常高！今天避免含糖飲料和糖果';

  @override
  String get noSugarIntake => '今天未追蹤糖';

  @override
  String get hriImpact => 'HRI影響';

  @override
  String get hri_component_sugar => '糖';

  @override
  String get hri_sugar_description => '高糖攝入影響補水和整體健康';

  @override
  String get tip_reduce_sweet_drinks => '用水或無糖茶替代甜飲料';

  @override
  String get tip_avoid_added_sugar => '檢查標籤避免添加糖產品';

  @override
  String get tip_check_labels => '注意醬料和加工食品中的隱藏糖';

  @override
  String get tip_replace_soda => '用氣泡水加檸檬替代汽水';

  @override
  String get sugarSources => '糖來源';

  @override
  String get drinks => '飲品';

  @override
  String get snacks => '零食';

  @override
  String get recommendedLimit => '建議';

  @override
  String get points => '分';

  @override
  String get drinkLightBeer => '淡啤酒';

  @override
  String get drinkLager => '拉格';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => '黑啤';

  @override
  String get drinkWheatBeer => '小麥啤酒';

  @override
  String get drinkCraftBeer => '精釀啤酒';

  @override
  String get drinkNonAlcoholic => '無酒精';

  @override
  String get drinkRadler => '淡啤果汁';

  @override
  String get drinkPilsner => '皮爾森';

  @override
  String get drinkRedWine => '紅酒';

  @override
  String get drinkWhiteWine => '白酒';

  @override
  String get drinkProsecco => '普羅塞克';

  @override
  String get drinkPort => '波特酒';

  @override
  String get drinkRose => '粉紅酒';

  @override
  String get drinkDessertWine => '甜酒';

  @override
  String get drinkSangria => '桑格利亞';

  @override
  String get drinkSherry => '雪莉酒';

  @override
  String get drinkVodkaShot => '伏特加Shot';

  @override
  String get drinkCognac => '干邑';

  @override
  String get drinkLiqueur => '利口酒';

  @override
  String get drinkAbsinthe => '苦艾酒';

  @override
  String get drinkBrandy => '白蘭地';

  @override
  String get drinkLongIsland => '長島冰茶';

  @override
  String get drinkGinTonic => '琴通寧';

  @override
  String get drinkPinaColada => '鳳梨可樂達';

  @override
  String get drinkCosmopolitan => '柯夢波丹';

  @override
  String get drinkMaiTai => '邁泰';

  @override
  String get drinkBloodyMary => '血腥瑪莉';

  @override
  String get drinkDaiquiri => '黛克瑞';

  @override
  String popularDrinks(Object type) {
    return '熱門$type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g糖';

  @override
  String get moderateConsumption => '適度攝取';

  @override
  String get aboveRecommendations => '超過建議';

  @override
  String get highConsumption => '高攝取';

  @override
  String get veryHighConsider => '非常高 - 考慮停止';

  @override
  String get noAlcoholToday => '今天無酒精';

  @override
  String get drinkWaterNow => '現在喝300-500 ml水';

  @override
  String get addPinchSalt => '加少許鹽';

  @override
  String get avoidLateCoffee => '避免太晚喝咖啡';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => '今日電解質';

  @override
  String get greatBalance => '很好的平衡！';

  @override
  String get gettingThere => '快到了';

  @override
  String get needMoreElectrolytes => '需要更多電解質';

  @override
  String get lowElectrolyteLevels => '電解質水平低';

  @override
  String get electrolyteTips => '電解質提示';

  @override
  String get takeWithWater => '與大量水一起服用';

  @override
  String get bestBetweenMeals => '餐間吸收最好';

  @override
  String get startSmallAmounts => '從小量開始';

  @override
  String get extraDuringExercise => '運動時需要額外';

  @override
  String get electrolytesBasic => '基本';

  @override
  String get electrolytesMixes => '混合';

  @override
  String get electrolytesPills => '藥丸';

  @override
  String get popularSalts => '熱門鹽&湯';

  @override
  String get popularMixes => '熱門電解質混合';

  @override
  String get popularSupplements => '熱門補充劑';

  @override
  String get electrolyteSaltWater => '鹽水';

  @override
  String get electrolytePinkSalt => '粉鹽';

  @override
  String get electrolyteSeaSalt => '海鹽';

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
  String get electrolytePotassiumChloride => '氯化鉀';

  @override
  String get electrolyteMagThreonate => '蘇糖酸鎂';

  @override
  String get electrolyteTraceMinerals => '微量礦物質';

  @override
  String get electrolyteZMAComplex => 'ZMA複合物';

  @override
  String get electrolyteMultiMineral => '多礦物質';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => '補水';

  @override
  String get todayHydration => '今日補水';

  @override
  String get currentIntake => '已攝取';

  @override
  String get dailyGoal => '目標';

  @override
  String get toGo => '剩餘';

  @override
  String get goalReached => '達成目標！';

  @override
  String get almostThere => '快到了！';

  @override
  String get halfwayThere => '到一半';

  @override
  String get keepGoing => '繼續！';

  @override
  String get startDrinking => '開始喝水';

  @override
  String get plainWater => '純水';

  @override
  String get enhancedWater => '強化';

  @override
  String get beverages => '飲料';

  @override
  String get sodas => '汽水';

  @override
  String get popularPlainWater => '熱門水類型';

  @override
  String get popularEnhancedWater => '強化&浸泡';

  @override
  String get popularBeverages => '熱門飲料';

  @override
  String get popularSodas => '熱門汽水&能量';

  @override
  String get hydrationTips => '補水提示';

  @override
  String get drinkRegularly => '定期少量飲用';

  @override
  String get roomTemperature => '室溫水吸收更好';

  @override
  String get addLemon => '加檸檬更好喝';

  @override
  String get limitSugary => '限制含糖飲料 - 會脫水';

  @override
  String get warmWater => '溫水';

  @override
  String get iceWater => '冰水';

  @override
  String get filteredWater => '過濾水';

  @override
  String get distilledWater => '蒸餾水';

  @override
  String get springWater => '泉水';

  @override
  String get hydrogenWater => '氫水';

  @override
  String get oxygenatedWater => '含氧水';

  @override
  String get cucumberWater => '黃瓜水';

  @override
  String get limeWater => '萊姆水';

  @override
  String get berryWater => '莓果水';

  @override
  String get mintWater => '薄荷水';

  @override
  String get gingerWater => '薑水';

  @override
  String get caffeineStatusNone => '今天無咖啡因';

  @override
  String caffeineStatusModerate(Object amount) {
    return '適度: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return '高: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return '非常高: ${amount}mg！';
  }

  @override
  String get caffeineDailyLimit => '每日限量: 400mg';

  @override
  String get caffeineWarningTitle => '咖啡因警告';

  @override
  String get caffeineWarning400 => '您今天已超過400mg咖啡因';

  @override
  String get caffeineTipWater => '多喝水補償';

  @override
  String get caffeineTipAvoid => '今天避免更多咖啡因';

  @override
  String get caffeineTipSleep => '可能影響睡眠品質';

  @override
  String get total => '總計';

  @override
  String get cupsToday => '今天杯數';

  @override
  String get metabolizeTime => '代謝時間';

  @override
  String get aboutCaffeine => '關於咖啡因';

  @override
  String get caffeineInfo1 => '咖啡含天然咖啡因可提高警覺';

  @override
  String get caffeineInfo2 => '大多數成人每日安全限量400mg';

  @override
  String get caffeineInfo3 => '咖啡因半衰期5-6小時';

  @override
  String get caffeineInfo4 => '多喝水補償咖啡因利尿效應';

  @override
  String get caffeineWarningPregnant => '孕婦應限制咖啡因至200mg/天';

  @override
  String get gotIt => '知道了';

  @override
  String get consumed => '已攝取';

  @override
  String get remaining => '剩餘';

  @override
  String get todaysCaffeine => '今日咖啡因';

  @override
  String get alreadyInFavorites => '已在最愛中';

  @override
  String get ofRecommendedLimit => '佔建議限量';

  @override
  String get aboutAlcohol => '關於酒精';

  @override
  String get alcoholInfo1 => '一標準杯等於10g純酒精';

  @override
  String get alcoholInfo2 => '酒精會脫水 — 每杯多喝250ml水';

  @override
  String get alcoholInfo3 => '加鈉有助飲酒後保持體液';

  @override
  String get alcoholInfo4 => '每標準杯增加HRI 3-5分';

  @override
  String get alcoholWarningHealth => '過量飲酒有害健康。建議限量男性每天2 SD、女性1 SD。';

  @override
  String get supplementsInfo1 => '補充劑幫助維持電解質平衡';

  @override
  String get supplementsInfo2 => '最好隨餐服用以吸收';

  @override
  String get supplementsInfo3 => '總是與大量水一起服用';

  @override
  String get supplementsInfo4 => '鎂和鉀是補水的關鍵';

  @override
  String get supplementsWarning => '開始任何補充劑方案前請諮詢醫療提供者';

  @override
  String get fromSupplementsToday => '今日補充劑';

  @override
  String get minerals => '礦物質';

  @override
  String get vitamins => '維生素';

  @override
  String get essentialMinerals => '必需礦物質';

  @override
  String get otherSupplements => '其他補充劑';

  @override
  String get supplementTip1 => '與食物一起服用補充劑以更好吸收';

  @override
  String get supplementTip2 => '與補充劑一起喝大量水';

  @override
  String get supplementTip3 => '全天分散多個補充劑';

  @override
  String get supplementTip4 => '追蹤什麼對您有效';

  @override
  String get calciumCarbonate => '碳酸鈣';

  @override
  String get traceMinerals => '微量礦物質';

  @override
  String get vitaminA => '維生素A';

  @override
  String get vitaminE => '維生素E';

  @override
  String get vitaminK2 => '維生素K2';

  @override
  String get folate => '葉酸';

  @override
  String get biotin => '生物素';

  @override
  String get probiotics => '益生菌';

  @override
  String get melatonin => '褪黑激素';

  @override
  String get collagen => '膠原蛋白';

  @override
  String get glucosamine => '葡萄糖胺';

  @override
  String get turmeric => '薑黃';

  @override
  String get coq10 => '輔酶Q10';

  @override
  String get creatine => '肌酸';

  @override
  String get ashwagandha => '南非醉茄';

  @override
  String get selectCardioActivity => '選擇有氧活動';

  @override
  String get selectStrengthActivity => '選擇力量活動';

  @override
  String get selectSportsActivity => '選擇運動';

  @override
  String get sessions => '次';

  @override
  String get totalTime => '總時長';

  @override
  String get waterLoss => '水分流失';

  @override
  String get intensity => '強度';

  @override
  String get drinkWaterAfterWorkout => '運動後喝水';

  @override
  String get replenishElectrolytes => '補充電解質';

  @override
  String get restAndRecover => '休息恢復';

  @override
  String get avoidSugaryDrinks => '避免含糖運動飲料';

  @override
  String get elliptical => '橢圓機';

  @override
  String get rowing => '划船';

  @override
  String get jumpRope => '跳繩';

  @override
  String get stairClimbing => '爬樓梯';

  @override
  String get bodyweight => '體重訓練';

  @override
  String get powerlifting => '力量舉';

  @override
  String get calisthenics => '健美操';

  @override
  String get resistanceBands => '阻力帶';

  @override
  String get kettlebell => '壺鈴';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => '大力士';

  @override
  String get pilates => '普拉提';

  @override
  String get basketball => '籃球';

  @override
  String get soccerFootball => '足球';

  @override
  String get golf => '高爾夫';

  @override
  String get martialArts => '武術';

  @override
  String get rockClimbing => '攀岩';

  @override
  String get needsToReplenish => '需要補充';

  @override
  String get electrolyteTrackingPro => '追蹤鈉、鉀和鎂目標及詳細進度條';

  @override
  String get unlock => '解鎖';

  @override
  String get weather => '天氣';

  @override
  String get weatherTrackingPro => '追蹤熱指數、濕度及天氣對補水目標的影響';

  @override
  String get sugarTracking => '糖追蹤';

  @override
  String get sugarTrackingPro => '監測天然、添加和隱藏糖攝入及HRI影響分析';

  @override
  String get dayOverview => '日概覽';

  @override
  String get tapForDetails => '點擊查看詳情';

  @override
  String get noDataForDay => '此日無資料';

  @override
  String get sweatLoss => '汗液流失';

  @override
  String get cardio => '有氧';

  @override
  String get workout => '運動';

  @override
  String get noWaterToday => '今天未記錄水';

  @override
  String get noElectrolytesToday => '今天未記錄電解質';

  @override
  String get noCoffeeToday => '今天未記錄咖啡';

  @override
  String get noWorkoutsToday => '今天未記錄運動';

  @override
  String get noWaterThisDay => '此日無水記錄';

  @override
  String get noElectrolytesThisDay => '此日無電解質記錄';

  @override
  String get noCoffeeThisDay => '此日無咖啡記錄';

  @override
  String get noWorkoutsThisDay => '此日無運動記錄';

  @override
  String get weeklyReport => '週報告';

  @override
  String get weeklyReportSubtitle => '深度洞察和趨勢分析';

  @override
  String get workouts => '運動';

  @override
  String get workoutHydration => '運動水分';

  @override
  String workoutHydrationMessage(Object percent) {
    return '運動日你喝$percent%更多水';
  }

  @override
  String get weeklyActivity => '週活動';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return '你$days天訓練了$minutes分鐘';
  }

  @override
  String get workoutMinutesPerDay => '每日運動分鐘';

  @override
  String get daysWithWorkouts => '有運動的天數';

  @override
  String get noWorkoutsThisWeek => '本週無運動';

  @override
  String get noAlcoholThisWeek => '本週無酒精';

  @override
  String get csvExported => '資料已匯出至CSV';

  @override
  String get mondayShort => '一';

  @override
  String get tuesdayShort => '二';

  @override
  String get wednesdayShort => '三';

  @override
  String get thursdayShort => '四';

  @override
  String get fridayShort => '五';

  @override
  String get saturdayShort => '六';

  @override
  String get sundayShort => '日';

  @override
  String get achievements => '成就';

  @override
  String get achievementsTabAll => '全部';

  @override
  String get achievementsTabHydration => '補水';

  @override
  String get achievementsTabElectrolytes => '電解質';

  @override
  String get achievementsTabSugar => '控糖';

  @override
  String get achievementsTabAlcohol => '酒精';

  @override
  String get achievementsTabWorkout => '健身';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => '連續';

  @override
  String get achievementsTabSpecial => '特別';

  @override
  String get achievementUnlocked => '成就解鎖！';

  @override
  String get achievementProgress => '進度';

  @override
  String get achievementPoints => '分';

  @override
  String get achievementRarityCommon => '普通';

  @override
  String get achievementRarityUncommon => '罕見';

  @override
  String get achievementRarityRare => '稀有';

  @override
  String get achievementRarityEpic => '史詩';

  @override
  String get achievementRarityLegendary => '傳奇';

  @override
  String get achievementStatsUnlocked => '已解鎖';

  @override
  String get achievementStatsTotal => '總分';

  @override
  String get achievementFilterAll => '全部';

  @override
  String get achievementFilterUnlocked => '已解鎖';

  @override
  String get achievementSortProgress => '進度';

  @override
  String get achievementSortName => '名稱';

  @override
  String get achievementSortRarity => '稀有度';

  @override
  String get achievementNoAchievements => '還沒有成就';

  @override
  String get achievementKeepUsing => '繼續使用應用解鎖成就！';

  @override
  String get achievementFirstGlass => '第一滴';

  @override
  String get achievementFirstGlassDesc => '喝你的第一杯水';

  @override
  String get achievementHydrationGoal1 => '補水';

  @override
  String get achievementHydrationGoal1Desc => '達到每日水分目標';

  @override
  String get achievementHydrationGoal7 => '一週補水';

  @override
  String get achievementHydrationGoal7Desc => '連續7天達到水分目標';

  @override
  String get achievementHydrationGoal30 => '水分大師';

  @override
  String get achievementHydrationGoal30Desc => '連續30天達到水分目標';

  @override
  String get achievementPerfectHydration => '完美平衡';

  @override
  String get achievementPerfectHydrationDesc => '達到水分目標的90-110%';

  @override
  String get achievementEarlyBird => '早起鳥';

  @override
  String get achievementEarlyBirdDesc => '上午9點前喝第一杯水';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return '上午9點前喝$volume';
  }

  @override
  String get achievementNightOwl => '夜貓子';

  @override
  String get achievementNightOwlDesc => '下午6點前完成水分目標';

  @override
  String get achievementLiterLegend => '升級傳奇';

  @override
  String get achievementLiterLegendDesc => '達到總水分里程碑';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return '總共喝$volume';
  }

  @override
  String get achievementSaltStarter => '鹽起步';

  @override
  String get achievementSaltStarterDesc => '添加第一份電解質';

  @override
  String get achievementElectrolyteBalance => '平衡';

  @override
  String get achievementElectrolyteBalanceDesc => '一天內達到所有電解質目標';

  @override
  String get achievementSodiumMaster => '鈉大師';

  @override
  String get achievementSodiumMasterDesc => '連續7天達到鈉目標';

  @override
  String get achievementPotassiumPro => '鉀專家';

  @override
  String get achievementPotassiumProDesc => '連續7天達到鉀目標';

  @override
  String get achievementMagnesiumMaven => '鎂達人';

  @override
  String get achievementMagnesiumMavenDesc => '連續7天達到鎂目標';

  @override
  String get achievementElectrolyteExpert => '電解質專家';

  @override
  String get achievementElectrolyteExpertDesc => '30天完美電解質平衡';

  @override
  String get achievementSugarAwareness => '糖意識';

  @override
  String get achievementSugarAwarenessDesc => '首次追蹤糖';

  @override
  String get achievementSugarUnder25 => '甜味控制';

  @override
  String get achievementSugarUnder25Desc => '一天保持低糖攝入';

  @override
  String achievementSugarUnder25Template(String weight) {
    return '一天糖攝入低於$weight';
  }

  @override
  String get achievementSugarWeekControl => '糖紀律';

  @override
  String get achievementSugarWeekControlDesc => '一週保持低糖攝入';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return '7天糖攝入低於$weight';
  }

  @override
  String get achievementSugarFreeDay => '無糖';

  @override
  String get achievementSugarFreeDayDesc => '完成0g添加糖的一天';

  @override
  String get achievementSugarDetective => '糖偵探';

  @override
  String get achievementSugarDetectiveDesc => '追蹤隱藏糖10次';

  @override
  String get achievementSugarMaster => '糖大師';

  @override
  String get achievementSugarMasterDesc => '一個月保持超低糖攝入';

  @override
  String get achievementNoSodaWeek => '無汽水週';

  @override
  String get achievementNoSodaWeekDesc => '7天無汽水';

  @override
  String get achievementNoSodaMonth => '無汽水月';

  @override
  String get achievementNoSodaMonthDesc => '30天無汽水';

  @override
  String get achievementSweetToothTamed => '馴服甜牙';

  @override
  String get achievementSweetToothTamedDesc => '一週內每日糖減少50%';

  @override
  String get achievementAlcoholTracker => '意識';

  @override
  String get achievementAlcoholTrackerDesc => '追蹤酒精消費';

  @override
  String get achievementModerateDay => '節制';

  @override
  String get achievementModerateDayDesc => '一天保持低於2 SD';

  @override
  String get achievementSoberDay => '戒酒日';

  @override
  String get achievementSoberDayDesc => '完成無酒精的一天';

  @override
  String get achievementSoberWeek => '戒酒週';

  @override
  String get achievementSoberWeekDesc => '7天無酒精';

  @override
  String get achievementSoberMonth => '戒酒月';

  @override
  String get achievementSoberMonthDesc => '30天無酒精';

  @override
  String get achievementRecoveryProtocol => '恢復專家';

  @override
  String get achievementRecoveryProtocolDesc => '飲酒後完成恢復方案';

  @override
  String get achievementFirstWorkout => '開始運動';

  @override
  String get achievementFirstWorkoutDesc => '記錄第一次運動';

  @override
  String get achievementWorkoutWeek => '活躍週';

  @override
  String get achievementWorkoutWeekDesc => '一週運動3次';

  @override
  String get achievementCenturySweat => '百升汗';

  @override
  String get achievementCenturySweatDesc => '通過運動流失大量液體';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return '通過運動流失$volume';
  }

  @override
  String get achievementCardioKing => '有氧王';

  @override
  String get achievementCardioKingDesc => '完成10次有氧運動';

  @override
  String get achievementStrengthWarrior => '力量戰士';

  @override
  String get achievementStrengthWarriorDesc => '完成10次力量訓練';

  @override
  String get achievementHRIGreen => '綠區';

  @override
  String get achievementHRIGreenDesc => '一天保持HRI在綠區';

  @override
  String get achievementHRIWeekGreen => '安全週';

  @override
  String get achievementHRIWeekGreenDesc => '7天保持HRI在綠區';

  @override
  String get achievementHRIPerfect => '完美分數';

  @override
  String get achievementHRIPerfectDesc => '達到HRI低於20';

  @override
  String get achievementHRIRecovery => '快速恢復';

  @override
  String get achievementHRIRecoveryDesc => '一天內將HRI從紅色降到綠色';

  @override
  String get achievementHRIMaster => 'HRI大師';

  @override
  String get achievementHRIMasterDesc => '30天保持HRI低於30';

  @override
  String get achievementStreak3 => '起步';

  @override
  String get achievementStreak3Desc => '3天連續';

  @override
  String get achievementStreak7 => '週戰士';

  @override
  String get achievementStreak7Desc => '7天連續';

  @override
  String get achievementStreak30 => '一致性王';

  @override
  String get achievementStreak30Desc => '30天連續';

  @override
  String get achievementStreak100 => '百日俱樂部';

  @override
  String get achievementStreak100Desc => '100天連續';

  @override
  String get achievementFirstWeek => '第一週';

  @override
  String get achievementFirstWeekDesc => '使用應用7天';

  @override
  String get achievementProMember => 'PRO會員';

  @override
  String get achievementProMemberDesc => '成為PRO訂閱者';

  @override
  String get achievementDataExport => '資料分析師';

  @override
  String get achievementDataExportDesc => '匯出資料為CSV';

  @override
  String get achievementAllCategories => '全能';

  @override
  String get achievementAllCategoriesDesc => '每個類別至少解鎖一個成就';

  @override
  String get achievementHunter => '成就獵人';

  @override
  String get achievementHunterDesc => '解鎖50%的所有成就';

  @override
  String get achievementDetailsUnlockedOn => '解鎖於';

  @override
  String get achievementNewUnlocked => '新成就解鎖！';

  @override
  String get achievementViewAll => '查看所有成就';

  @override
  String get achievementCloseNotification => '關閉';

  @override
  String get before => '前';

  @override
  String get after => '後';

  @override
  String get lose => '失去';

  @override
  String get through => '通過';

  @override
  String get throughWorkouts => '通過運動';

  @override
  String get reach => '達到';

  @override
  String get daysInRow => '連續天數';

  @override
  String get completeHydrationGoal => '完成補水目標';

  @override
  String get stayUnder => '保持在以下';

  @override
  String get inADay => '一天內';

  @override
  String get alcoholFree => '無酒精';

  @override
  String get complete => '完成';

  @override
  String get achieve => '達成';

  @override
  String get keep => '保持';

  @override
  String get for30Days => '30天';

  @override
  String get liters => '升';

  @override
  String get completed => '已完成';

  @override
  String get notCompleted => '未完成';

  @override
  String get days => '天';

  @override
  String get hours => '小時';

  @override
  String get times => '次';

  @override
  String get row => '連續';

  @override
  String get ofTotal => '佔總數';

  @override
  String get perDay => '每天';

  @override
  String get perWeek => '每週';

  @override
  String get streak => '連續';

  @override
  String get tapToDismiss => '點擊關閉';

  @override
  String tutorialStep1(String volume) {
    return '你好！我將幫你開始最佳水分補充之旅。讓我們喝第一口$volume！';
  }

  @override
  String tutorialStep2(String volume) {
    return '太好了！現在再添加$volume感受一下。';
  }

  @override
  String get tutorialStep3 => '出色！你已準備好獨立使用HydroCoach。我會幫你達到完美水分補充！';

  @override
  String get tutorialComplete => '開始使用';

  @override
  String get onboardingNotificationExamplesTitle => '智慧提醒';

  @override
  String get onboardingNotificationExamplesSubtitle => 'HydroCoach知道你何時需要水';

  @override
  String get onboardingLocationExamplesTitle => '個人建議';

  @override
  String get onboardingLocationExamplesSubtitle => '我們考慮天氣提供準確建議';

  @override
  String get onboardingAllowNotifications => '允許通知';

  @override
  String get onboardingAllowLocation => '允許位置';

  @override
  String get foodCatalog => '食品目錄';

  @override
  String get todaysFoodIntake => '今日食物攝入';

  @override
  String get noFoodToday => '今天未記錄食物';

  @override
  String foodItemsCount(int count) {
    return '$count項食物';
  }

  @override
  String get waterFromFood => '食物水分';

  @override
  String get last => '最後';

  @override
  String get categoryFruits => '水果';

  @override
  String get categoryVegetables => '蔬菜';

  @override
  String get categorySoups => '湯類';

  @override
  String get categoryDairy => '乳製品';

  @override
  String get categoryMeat => '肉類';

  @override
  String get categoryFastFood => '快餐';

  @override
  String get weightGrams => '重量(克)';

  @override
  String get enterWeight => '輸入重量';

  @override
  String get grams => '克';

  @override
  String get calories => '卡路里';

  @override
  String get waterContent => '水分含量';

  @override
  String get sugar => '糖';

  @override
  String get nutritionalInfo => '營養資訊';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$weight克$calories kcal';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$weight克${water}ml水';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '$weight克${sugar}g糖';
  }

  @override
  String get addFood => '添加食物';

  @override
  String get foodAdded => '食物添加成功';

  @override
  String get enterValidWeight => '請輸入有效重量';

  @override
  String get proOnlyFood => '僅PRO';

  @override
  String get unlockProForFood => '解鎖PRO使用全部食物';

  @override
  String get foodTracker => '食物追蹤';

  @override
  String get todaysFoodSummary => '今日食物摘要';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => '每100g';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get favoritesFeatureComingSoon => '收藏功能即將推出！';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food已添加！+$calories kcal, +$water';
  }

  @override
  String get selectWeight => '選擇重量';

  @override
  String get ounces => '盎司';

  @override
  String get items => '項';

  @override
  String get tapToAddFood => '點擊添加食物';

  @override
  String get noFoodLoggedToday => '今天未記錄食物';

  @override
  String get lightEatingDay => '輕食日';

  @override
  String get moderateIntake => '適量攝入';

  @override
  String get goodCalorieIntake => '良好卡路里';

  @override
  String get substantialMeals => '豐盛餐';

  @override
  String get highCalorieDay => '高卡日';

  @override
  String get veryHighIntake => '超高攝入';

  @override
  String get caloriesTracker => '卡路里追蹤';

  @override
  String get trackYourDailyCalorieIntake => '追蹤每日卡路里攝入';

  @override
  String get unlockFoodTrackingFeatures => '解鎖食物追蹤功能';

  @override
  String get selectFoodType => '選擇食物類型';

  @override
  String get foodApple => '蘋果';

  @override
  String get foodBanana => '香蕉';

  @override
  String get foodOrange => '橙子';

  @override
  String get foodWatermelon => '西瓜';

  @override
  String get foodStrawberry => '草莓';

  @override
  String get foodGrapes => '葡萄';

  @override
  String get foodPineapple => '菠蘿';

  @override
  String get foodMango => '芒果';

  @override
  String get foodPear => '梨';

  @override
  String get foodCarrot => '胡蘿蔔';

  @override
  String get foodBroccoli => '西蘭花';

  @override
  String get foodSpinach => '菠菜';

  @override
  String get foodTomato => '番茄';

  @override
  String get foodCucumber => '黃瓜';

  @override
  String get foodBellPepper => '甜椒';

  @override
  String get foodLettuce => '生菜';

  @override
  String get foodOnion => '洋蔥';

  @override
  String get foodCelery => '芹菜';

  @override
  String get foodPotato => '土豆';

  @override
  String get foodChickenSoup => '雞湯';

  @override
  String get foodTomatoSoup => '番茄湯';

  @override
  String get foodVegetableSoup => '蔬菜湯';

  @override
  String get foodMinestrone => '意式雜菜湯';

  @override
  String get foodMisoSoup => '味噌湯';

  @override
  String get foodMushroomSoup => '蘑菇湯';

  @override
  String get foodBeefStew => '燉牛肉';

  @override
  String get foodLentilSoup => '扁豆湯';

  @override
  String get foodOnionSoup => '法式洋蔥湯';

  @override
  String get foodMilk => '牛奶';

  @override
  String get foodYogurt => '希臘酸奶';

  @override
  String get foodCheese => '切達奶酪';

  @override
  String get foodCottageCheese => '鄉村奶酪';

  @override
  String get foodButter => '黃油';

  @override
  String get foodCream => '稀奶油';

  @override
  String get foodIceCream => '冰淇淋';

  @override
  String get foodMozzarella => '馬蘇里拉';

  @override
  String get foodParmesan => '帕爾馬';

  @override
  String get foodChickenBreast => '雞胸肉';

  @override
  String get foodBeef => '碎牛肉';

  @override
  String get foodSalmon => '三文魚';

  @override
  String get foodEggs => '雞蛋';

  @override
  String get foodTuna => '金槍魚';

  @override
  String get foodPork => '豬排';

  @override
  String get foodTurkey => '火雞';

  @override
  String get foodShrimp => '蝦';

  @override
  String get foodBacon => '培根';

  @override
  String get foodBigMac => '巨無霸';

  @override
  String get foodPizza => '披薩';

  @override
  String get foodFrenchFries => '炸薯條';

  @override
  String get foodChickenNuggets => '雞塊';

  @override
  String get foodHotDog => '熱狗';

  @override
  String get foodTacos => '玉米卷';

  @override
  String get foodSubway => '賽百味';

  @override
  String get foodDonut => '甜甜圈';

  @override
  String get foodBurgerKing => '皇堡';

  @override
  String get foodSausage => '香腸';

  @override
  String get foodKefir => '開菲爾';

  @override
  String get foodRyazhenka => '發酵奶';

  @override
  String get foodDoner => '土耳其烤肉';

  @override
  String get foodShawarma => '沙威瑪';

  @override
  String get foodBorscht => '羅宋湯';

  @override
  String get foodRamen => '拉麵';

  @override
  String get foodCabbage => '捲心菜';

  @override
  String get foodPeaSoup => '豌豆湯';

  @override
  String get foodSolyanka => '酸辣湯';

  @override
  String get meals => '餐';

  @override
  String get dailyProgress => '每日進度';

  @override
  String get fromFood => '來自食物';

  @override
  String get noFoodThisWeek => '本週無食物資料';

  @override
  String get foodIntake => '食物攝入';

  @override
  String get foodStats => '食物統計';

  @override
  String get totalCalories => '總卡路里';

  @override
  String get avgCaloriesPerDay => '平均/天';

  @override
  String get daysWithFood => '進食天數';

  @override
  String get avgMealsPerDay => '餐/天';

  @override
  String get caloriesPerDay => '每日卡路里';

  @override
  String get sugarPerDay => '每日糖';

  @override
  String get foodTracking => '食物追蹤';

  @override
  String get foodTrackingPro => '追蹤食物對補水和HRI的影響';

  @override
  String get hydrationBalance => '補水平衡';

  @override
  String get highSodiumFood => '食物中高鈉';

  @override
  String get hydratingFood => '優秀補水選擇';

  @override
  String get dryFood => '低水分食物';

  @override
  String get balancedFood => '均衡營養';

  @override
  String get foodAdviceEmpty => '添加餐點以追蹤食物對補水的影響。';

  @override
  String get foodAdviceHighSodium => '檢測到高鈉攝入。增加水以平衡電解質。';

  @override
  String get foodAdviceLowWater => '您的食物水分含量低。考慮多喝水。';

  @override
  String get foodAdviceGoodHydration => '太好了！您的食物幫助補水。';

  @override
  String get foodAdviceBalanced => '營養良好！記得喝水。';

  @override
  String get richInElectrolytes => '富含電解質';

  @override
  String recommendedCalories(int calories) {
    return '建議卡路里: ~$calories kcal/天';
  }

  @override
  String get proWelcomeTitle => '歡迎使用HydraCoach PRO！';

  @override
  String get proTrialActivated => '您的7天試用已啟動！';

  @override
  String get proFeaturePersonalizedRecommendations => '個人化建議';

  @override
  String get proFeatureAdvancedAnalytics => '進階分析';

  @override
  String get proFeatureWorkoutTracking => '運動追蹤';

  @override
  String get proFeatureElectrolyteControl => '電解質控制';

  @override
  String get proFeatureSmartReminders => '智能提醒';

  @override
  String get proFeatureHriIndex => 'HRI指數';

  @override
  String get proFeatureAchievements => 'PRO成就';

  @override
  String get proFeaturePersonalizedDescription => '個人補水建議';

  @override
  String get proFeatureAdvancedDescription => '詳細圖表和統計';

  @override
  String get proFeatureWorkoutDescription => '運動期間體液流失追蹤';

  @override
  String get proFeatureElectrolyteDescription => '鈉、鉀、鎂監測';

  @override
  String get proFeatureSmartDescription => '個人化通知';

  @override
  String get proFeatureNoMoreAds => '不再有廣告！';

  @override
  String get proFeatureNoMoreAdsDescription => '享受無中斷補水追蹤，無任何廣告';

  @override
  String get proFeatureHriDescription => '即時補水風險指數';

  @override
  String get proFeatureAchievementsDescription => '專屬獎勵和目標';

  @override
  String get startUsing => '開始使用';

  @override
  String get sayGoodbyeToAds => '告別廣告。升級高級版。';

  @override
  String get goPremium => '升級高級版';

  @override
  String get removeAdsForever => '永久移除廣告';

  @override
  String get upgrade => '升級';

  @override
  String get support => '支援';

  @override
  String get companyWebsite => '公司網站';

  @override
  String get appStoreOpened => 'App Store已開啟';

  @override
  String get linkCopiedToClipboard => '連結已複製到剪貼板';

  @override
  String get shareDialogOpened => '分享對話框已開啟';

  @override
  String get linkForSharingCopied => '分享連結已複製';

  @override
  String get websiteOpenedInBrowser => '網站已在瀏覽器開啟';

  @override
  String get emailClientOpened => '電郵客戶端已開啟';

  @override
  String get emailCopiedToClipboard => '電郵已複製到剪貼板';

  @override
  String get privacyPolicyOpened => '隱私政策已開啟';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '統計至$dateString';
  }

  @override
  String get monthlyInsights => '每月洞察';

  @override
  String get average => '平均';

  @override
  String get daysOver => '天數超過';

  @override
  String get maximum => '最大';

  @override
  String get balance => '平衡';

  @override
  String get allNormal => '全部正常';

  @override
  String get excellentConsistency => '⭐ 出色一致';

  @override
  String get goodResults => '良好結果';

  @override
  String get positiveImprovement => '積極改善';

  @override
  String get physicalActivity => '身體活動';

  @override
  String get coffeeConsumption => '咖啡消費';

  @override
  String get excellentSobriety => '出色戒酒';

  @override
  String get excellentMonth => '出色的月';

  @override
  String get keepGoingMotivation => '繼續保持！';

  @override
  String get daysNormal => '天正常';

  @override
  String get electrolyteBalance => '電解質平衡需要關注';

  @override
  String get caffeineWarning => '超過安全劑量天數(400mg)';

  @override
  String get sugarFrequentExcess => '頻繁過量糖影響補水';

  @override
  String get averagePerDayShort => '每天';

  @override
  String get highWarning => '高';

  @override
  String get normalStatus => '正常';

  @override
  String improvementToEnd(int percent) {
    return '月末改善$percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent%天有運動($hours小時)';
  }

  @override
  String coffeeAverage(String avg) {
    return '平均$avg杯/天';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent%天無酒精';
  }

  @override
  String get daySummary => '日摘要';

  @override
  String get records => '記錄';

  @override
  String waterGoalAchievement(int percent) {
    return '水分目標達成: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return '運動: $count次';
  }

  @override
  String get index => '指數';

  @override
  String get status => '狀態';

  @override
  String get moderateRisk => '中等風險';

  @override
  String get excess => '超標';

  @override
  String get whoLimit => 'WHO限量: 50g/天';

  @override
  String stability(int percent) {
    return '$percent%天穩定';
  }

  @override
  String goodHydration(int percent) {
    return '$percent%天良好水分';
  }

  @override
  String daysInNorm(int count) {
    return '$count天正常';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent%天良好水分';
  }

  @override
  String stabilityDays(int percent) {
    return '$percent%天穩定';
  }

  @override
  String monthEndImprovement(int percent) {
    return '月末改善$percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent%天有運動($hours小時)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return '平均$avgCups杯/天';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent%天無酒精';
  }

  @override
  String get moderateRiskStatus => '狀態: 中等風險';

  @override
  String get high => '高';

  @override
  String get whoLimitPerDay => 'WHO限量: 50g/天';
}
