// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '하이드로코치';

  @override
  String get getPro => 'PRO 받기';

  @override
  String get sunday => '일요일';

  @override
  String get monday => '월요일';

  @override
  String get tuesday => '화요일';

  @override
  String get wednesday => '수요일';

  @override
  String get thursday => '목요일';

  @override
  String get friday => '금요일';

  @override
  String get saturday => '토요일';

  @override
  String get january => '1월';

  @override
  String get february => '2월';

  @override
  String get march => '3월';

  @override
  String get april => '4월';

  @override
  String get may => '5월';

  @override
  String get june => '6월';

  @override
  String get july => '7월';

  @override
  String get august => '8월';

  @override
  String get september => '9월';

  @override
  String get october => '10월';

  @override
  String get november => '11월';

  @override
  String get december => '12월';

  @override
  String dateFormat(String weekday, int day, String month) {
    return 'yyyy/MM/dd';
  }

  @override
  String get loading => '로딩 중...';

  @override
  String get loadingWeather => '날씨 로딩 중...';

  @override
  String get heatIndex => '열 지수';

  @override
  String humidity(int value) {
    return '습도';
  }

  @override
  String get water => '물';

  @override
  String get liquids => '음료';

  @override
  String get sodium => '나트륨';

  @override
  String get potassium => '칼륨';

  @override
  String get magnesium => '마그네슘';

  @override
  String get electrolyte => '전해질';

  @override
  String get broth => '육수';

  @override
  String get coffee => '커피';

  @override
  String get alcohol => '알코올';

  @override
  String get drink => '음료';

  @override
  String get ml => '밀리리터';

  @override
  String get mg => '밀리그램';

  @override
  String get kg => '킬로그램';

  @override
  String valueWithUnit(int value, String unit) {
    return '$value $unit';
  }

  @override
  String goalFormat(int current, int goal, String unit) {
    return '$current/$goal';
  }

  @override
  String heatAdjustment(int percent) {
    return '더위 조정';
  }

  @override
  String alcoholAdjustment(int amount) {
    return '알코올 조정';
  }

  @override
  String get smartAdviceTitle => '현재 조언';

  @override
  String get smartAdviceDefault => '물과 전해질 균형을 유지하세요.';

  @override
  String get adviceOverhydrationSevere => '과다 수분 섭취 심각';

  @override
  String get adviceOverhydrationSevereBody => '너무 많은 물. 물을 중단하고 소금을 추가하세요.';

  @override
  String get adviceOverhydration => '과다 수분 섭취';

  @override
  String get adviceOverhydrationBody =>
      '30-60분간 물 섭취를 중단하고 ~500mg의 나트륨을 추가하세요.';

  @override
  String get adviceAlcoholRecovery => '알코올 회복';

  @override
  String get adviceAlcoholRecoveryBody => '물과 전해질로 회복하세요. 오늘은 쉬세요.';

  @override
  String get adviceLowSodium => '나트륨 부족';

  @override
  String adviceLowSodiumBody(int amount) {
    return '~$amount mg의 나트륨을 추가하세요. 적당히 마시세요.';
  }

  @override
  String get adviceDehydration => '탈수 위험';

  @override
  String adviceDehydrationBody(String type) {
    return '지금 물을 마시세요. 전해질을 추가하는 것을 고려하세요.';
  }

  @override
  String get adviceHighRisk => '높은 위험';

  @override
  String get adviceHighRiskBody => '수분 섭취 위험이 높습니다. 즉시 물을 마시고 전해질을 추가하세요.';

  @override
  String get adviceHeat => '더위';

  @override
  String get adviceHeatBody => '뜨거운 날씨. 물과 소금을 늘리세요.';

  @override
  String get adviceAllGood => '모두 좋음';

  @override
  String adviceAllGoodBody(int amount) {
    return '완벽한 균형! 계속하세요.';
  }

  @override
  String get hydrationStatus => '수분 상태';

  @override
  String get hydrationStatusNormal => '정상';

  @override
  String get hydrationStatusDiluted => '과다 수분';

  @override
  String get hydrationStatusDehydrated => '탈수';

  @override
  String get hydrationStatusLowSalt => '낮은 소금';

  @override
  String get hydrationRiskIndex => '수분 위험 지수';

  @override
  String get quickAdd => '빠른 추가';

  @override
  String get add => '추가';

  @override
  String get delete => '삭제';

  @override
  String get todaysDrinks => '오늘의 음료';

  @override
  String get allRecords => '모든 기록';

  @override
  String itemDeleted(String item) {
    return '항목이 삭제되었습니다';
  }

  @override
  String get undo => '취소';

  @override
  String get dailyReportReady => '일일 보고서 준비됨';

  @override
  String get viewDayResults => '일일 결과 보기';

  @override
  String get dailyReportComingSoon => '일일 보고서 곧 출시';

  @override
  String get home => '홈';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get reset => '초기화';

  @override
  String get settingsTitle => '설정';

  @override
  String get languageSection => '언어';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get profileSection => '프로필';

  @override
  String get weight => '체중';

  @override
  String get dietMode => '식단 모드';

  @override
  String get activityLevel => '활동 수준';

  @override
  String get changeWeight => '체중 변경';

  @override
  String get dietModeNormal => '일반 식단';

  @override
  String get dietModeKeto => '케토 / 저탄수화물';

  @override
  String get dietModeFasting => '간헐적 단식';

  @override
  String get activityLow => '낮은 활동';

  @override
  String get activityMedium => '중간 활동';

  @override
  String get activityHigh => '높은 활동';

  @override
  String get activityLowDesc => '사무실 업무, 적은 움직임';

  @override
  String get activityMediumDesc => '하루 30-60분 운동';

  @override
  String get activityHighDesc => '1시간 이상 운동';

  @override
  String get notificationsSection => '알림';

  @override
  String get notificationLimit => '알림 제한';

  @override
  String notificationUsage(int used, int limit) {
    return '알림 사용량';
  }

  @override
  String get waterReminders => '물 알림';

  @override
  String get waterRemindersDesc => '규칙적인 수분 섭취 알림';

  @override
  String get reminderFrequency => '알림 빈도';

  @override
  String timesPerDay(int count) {
    return '회/일';
  }

  @override
  String maxTimesPerDay(int count) {
    return '최대 횟수/일';
  }

  @override
  String get unlimitedReminders => '무제한 알림';

  @override
  String get startOfDay => '하루 시작';

  @override
  String get endOfDay => '하루 종료';

  @override
  String get postCoffeeReminders => '커피 후 알림';

  @override
  String get postCoffeeRemindersDesc => '커피 후 물 마시기 알림';

  @override
  String get heatWarnings => '더위 경고';

  @override
  String get heatWarningsDesc => '뜨거운 날씨 알림';

  @override
  String get postAlcoholReminders => '알코올 후 알림';

  @override
  String get postAlcoholRemindersDesc => '알코올 회복 알림';

  @override
  String get proFeaturesSection => 'PRO 기능';

  @override
  String get unlockPro => 'PRO 잠금 해제';

  @override
  String get unlockProDesc => '모든 기능 액세스';

  @override
  String get noNotificationLimit => '제한 없음';

  @override
  String get unitsSection => '단위';

  @override
  String get metricSystem => '미터법';

  @override
  String get metricUnits => '미터법 단위';

  @override
  String get imperialSystem => '야드파운드법';

  @override
  String get imperialUnits => '야드파운드법 단위';

  @override
  String get aboutSection => '정보';

  @override
  String get version => '버전';

  @override
  String get rateApp => '앱 평가';

  @override
  String get share => '공유';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get termsOfUse => '이용약관';

  @override
  String get resetAllData => '모든 데이터 재설정';

  @override
  String get resetDataTitle => '모든 데이터를 삭제하시겠습니까?';

  @override
  String get resetDataMessage => '이 작업은 되돌릴 수 없습니다';

  @override
  String get back => '뒤로';

  @override
  String get next => '다음';

  @override
  String get start => '시작';

  @override
  String get welcomeTitle => '하이드로코치에 오신 것을 환영합니다';

  @override
  String get welcomeSubtitle => '매일 스마트한 수분 섭취';

  @override
  String get weightPageTitle => '체중';

  @override
  String get weightPageSubtitle => '정확한 계산을 위한 현재 체중';

  @override
  String weightUnit(int weight) {
    return 'kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return '권장 기준';
  }

  @override
  String get dietPageTitle => '식단 모드';

  @override
  String get dietPageSubtitle => '식단 유형이 전해질에 영향을 줍니다';

  @override
  String get normalDiet => '일반 식단';

  @override
  String get normalDietDesc => '표준 식단';

  @override
  String get ketoDiet => '케토 식단';

  @override
  String get ketoDietDesc => '저탄수화물 고지방';

  @override
  String get fastingDiet => '간헐적 단식';

  @override
  String get fastingDietDesc => '식사 기간이 있는 단식';

  @override
  String get fastingSchedule => '단식 일정';

  @override
  String get fasting16_8 => '16/8 단식';

  @override
  String get fasting16_8Desc => '16시간 단식, 8시간 식사';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => '하루 한 끼';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => '격일 단식';

  @override
  String get activityPageTitle => '활동 수준';

  @override
  String get activityPageSubtitle => '일일 활동 수준 선택';

  @override
  String get lowActivity => '낮은 활동';

  @override
  String get lowActivityDesc => '사무 업무, 최소 운동';

  @override
  String get lowActivityWater => '체중 기준 물';

  @override
  String get mediumActivity => '중간 활동';

  @override
  String get mediumActivityDesc => '30-60분 운동';

  @override
  String get mediumActivityWater => '+10% 물';

  @override
  String get highActivity => '높은 활동';

  @override
  String get highActivityDesc => '60분 이상 운동';

  @override
  String get highActivityWater => '+20% 물';

  @override
  String get activityAdjustmentNote => '활동에 따른 수분 조정';

  @override
  String get day => '일';

  @override
  String get week => '주';

  @override
  String get month => '월';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get noData => '데이터 없음';

  @override
  String get noRecordsToday => '오늘 기록이 없습니다';

  @override
  String get noRecordsThisDay => '이 날 기록 없음';

  @override
  String get loadingData => '데이터 로딩 중...';

  @override
  String get deleteRecord => '기록 삭제';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '이 기록을 삭제하시겠습니까?';
  }

  @override
  String get recordDeleted => '기록이 삭제되었습니다';

  @override
  String get waterConsumption => '물 소비';

  @override
  String get alcoholWeek => '주간 알코올';

  @override
  String get electrolytes => '전해질';

  @override
  String get weeklyAverages => '주간 평균';

  @override
  String get monthStatistics => '월간 통계';

  @override
  String get alcoholStatistics => '알코올 통계';

  @override
  String get alcoholStatisticsTitle => '알코올 통계';

  @override
  String get weeklyInsights => '주간 인사이트';

  @override
  String get waterPerDay => '하루 물 섭취량';

  @override
  String get sodiumPerDay => '하루 나트륨 섭취량';

  @override
  String get potassiumPerDay => '일당 칼륨';

  @override
  String get magnesiumPerDay => '일당 마그네슘';

  @override
  String get goal => '목표';

  @override
  String get daysWithGoalAchieved => '목표 달성 일수';

  @override
  String get recordsPerDay => '일당 기록';

  @override
  String get insufficientDataForAnalysis => '분석에 충분하지 않은 데이터';

  @override
  String get totalVolume => '총 용량';

  @override
  String averagePerDay(int amount) {
    return '일당 평균';
  }

  @override
  String get activeDays => '활동 일수';

  @override
  String perfectDays(int count) {
    return '목표 달성 일수: $count';
  }

  @override
  String currentStreak(int days) {
    return '현재 연속 $days일';
  }

  @override
  String soberDaysRow(int days) {
    return '연속 금주 일수';
  }

  @override
  String get keepItUp => '계속하세요!';

  @override
  String waterAmount(int amount, int percent) {
    return '물: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return '알코올량';
  }

  @override
  String get totalSD => '총 SD';

  @override
  String get forMonth => '월간';

  @override
  String get daysWithAlcohol => '알코올이 있는 날';

  @override
  String fromDays(int days) {
    return '$days일 중';
  }

  @override
  String get soberDays => '금주 일수';

  @override
  String get excellent => '우수!';

  @override
  String get averageSD => '평균 SD';

  @override
  String get inDrinkingDays => '음주일에';

  @override
  String get bestDay => '최고의 날';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day에 최고 실적';
  }

  @override
  String get weekends => '📅 주말';

  @override
  String get weekdays => '📅 평일';

  @override
  String drinkLessOnWeekends(int percent) {
    return '주말에 덜 마시기';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return '평일에 덜 마시기';
  }

  @override
  String get positiveTrend => '📈 긍정적 경향';

  @override
  String get positiveTrendMessage => '긍정적 경향. 계속하세요!';

  @override
  String get decliningActivity => '활동 감소';

  @override
  String get decliningActivityMessage => '활동이 감소하고 있습니다. 움직임을 늘리세요.';

  @override
  String get lowSalt => '낮은 소금';

  @override
  String lowSaltMessage(int days) {
    return '소금 섭취가 낮습니다. 전해질을 추가하세요.';
  }

  @override
  String get frequentAlcohol => '빈번한 알코올';

  @override
  String frequentAlcoholMessage(int days) {
    return '음주 빈도가 높습니다. 알코올 없는 날을 늘리는 것을 고려하세요.';
  }

  @override
  String get excellentWeek => '우수한 주';

  @override
  String get continueMessage => '계속하기';

  @override
  String get all => '모두';

  @override
  String get addAlcohol => '알코올 추가';

  @override
  String get minimumHarm => '최소 피해';

  @override
  String additionalWaterNeeded(int amount) {
    return '추가 물 필요';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '추가 나트륨 필요';
  }

  @override
  String get goToBedEarly => '일찍 자기';

  @override
  String get todayConsumed => '오늘 소비됨';

  @override
  String get alcoholToday => '오늘 알코올';

  @override
  String get beer => '맥주';

  @override
  String get wine => '와인';

  @override
  String get spirits => '증류주';

  @override
  String get cocktail => '칵테일';

  @override
  String get selectDrinkType => '음료 유형 선택';

  @override
  String get volume => '용량';

  @override
  String get enterVolume => '용량 입력';

  @override
  String get strength => '근력';

  @override
  String get standardDrinks => '표준 음주량';

  @override
  String get additionalWater => '물 추가';

  @override
  String get additionalSodium => '나트륨 추가';

  @override
  String get hriRisk => 'HRI 위험도';

  @override
  String get enterValidVolume => '올바른 양을 입력하세요';

  @override
  String get weeklyHistory => '주간 기록';

  @override
  String get weeklyHistoryDesc => '주간 경향 분석 및 권장사항';

  @override
  String get monthlyHistory => '월간 기록';

  @override
  String get monthlyHistoryDesc => '장기 패턴, 주간 비교 및 심층 분석';

  @override
  String get proFunction => 'PRO 기능';

  @override
  String get unlockProHistory => 'PRO 잠금 해제';

  @override
  String get unlimitedHistory => '무제한 기록';

  @override
  String get dataExportCSV => 'CSV로 데이터 내보내기';

  @override
  String get detailedAnalytics => '상세 분석';

  @override
  String get periodComparison => '기간 비교';

  @override
  String get shareResult => '결과 공유';

  @override
  String get retry => '재시도';

  @override
  String get welcomeToPro => 'PRO를 환영합니다!';

  @override
  String get allFeaturesUnlocked => '모든 기능이 잠금 해제됨';

  @override
  String get testMode => '테스트 모드: 모의 구매 사용';

  @override
  String get proStatusNote => 'PRO 상태는 앱 재시작 시까지 유지됩니다';

  @override
  String get startUsingPro => 'PRO 사용 시작';

  @override
  String get lifetimeAccess => '평생 이용';

  @override
  String get bestValueAnnual => '최고 가치 — 연간';

  @override
  String get monthly => '월간';

  @override
  String get oneTime => '일회성';

  @override
  String get perYear => '/년';

  @override
  String get perMonth => '/월';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/월';
  }

  @override
  String get startFreeTrial => '7일 무료 체험 시작';

  @override
  String continueWithPrice(String price) {
    return '계속하기 — $price';
  }

  @override
  String unlockForPrice(String price) {
    return '$price에 잠금 해제 (일회성)';
  }

  @override
  String get enableFreeTrial => '7일 무료 체험 활성화';

  @override
  String get noChargeToday => '오늘 청구 없음. 7일 후 자동 갱신됩니다 (취소 가능).';

  @override
  String get cancelAnytime => '설정에서 언제든지 취소할 수 있습니다.';

  @override
  String get everythingInPro => 'PRO의 모든 기능';

  @override
  String get smartReminders => '스마트 알림';

  @override
  String get smartRemindersDesc => '운동, 더위, 단식 — 스팸 없음.';

  @override
  String get weeklyReports => '주간 보고서';

  @override
  String get weeklyReportsDesc => '심층 분석 + CSV 내보내기.';

  @override
  String get healthIntegrations => '건강 연동';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit.';

  @override
  String get alcoholProtocols => '알코올 프로토콜';

  @override
  String get alcoholProtocolsDesc => '음주 준비 & 회복 로드맵.';

  @override
  String get fullSync => '전체 동기화';

  @override
  String get fullSyncDesc => '기기 간 무제한 기록.';

  @override
  String get personalCalibrations => '개인 보정';

  @override
  String get personalCalibrationsDesc => '땀 테스트, 소변 색상 스케일.';

  @override
  String get showAllFeatures => '모든 기능 표시';

  @override
  String get showLess => '간략히';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get proSubscriptionRestored => 'PRO 구독이 복원되었습니다!';

  @override
  String get noPurchasesToRestore => '복원할 구매가 없습니다';

  @override
  String get drinkMoreWaterToday => '오늘 물을 더 마시세요 (+20%)';

  @override
  String get addElectrolytesToWater => '모든 물에 전해질 추가';

  @override
  String get limitCoffeeOneCup => '커피를 하루 1잔으로 제한';

  @override
  String get increaseWater10 => '물을 10% 늘리세요';

  @override
  String get dontForgetElectrolytes => '전해질 잊지 마세요';

  @override
  String get startDayWithWater => '물 한 잔으로 하루 시작';

  @override
  String get dontForgetElectrolytesReminder => '⚡ 전해질 잊지 마세요';

  @override
  String get startDayWithWaterReminder => '건강을 위해 물 한 잔으로 하루를 시작하세요';

  @override
  String get takeElectrolytesMorning => '아침에 전해질 섭취';

  @override
  String purchaseFailed(String error) {
    return '구매 실패: $error';
  }

  @override
  String restoreFailed(String error) {
    return '복원 실패: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — 12,000명의 사용자가 신뢰';

  @override
  String get bestValue => '최고 가치';

  @override
  String percentOff(int percent) {
    return '-$percent% 최고 가치';
  }

  @override
  String get weatherUnavailable => '날씨 정보 없음';

  @override
  String get checkLocationPermissions => '위치 권한 및 인터넷 확인';

  @override
  String get recommendedNormLabel => '권장 기준';

  @override
  String get waterAdjustment300 => '+300ml';

  @override
  String get waterAdjustment400 => '+400ml';

  @override
  String get waterAdjustment200 => '+200ml';

  @override
  String get waterAdjustmentNormal => '보통';

  @override
  String get waterAdjustment500 => '+500ml';

  @override
  String get waterAdjustment250 => '+250ml';

  @override
  String get waterAdjustment750 => '+750ml';

  @override
  String get currentLocation => '현재 위치';

  @override
  String get weatherClear => '맑음';

  @override
  String get weatherCloudy => '흐림';

  @override
  String get weatherOvercast => '흐린 날';

  @override
  String get weatherRain => '비';

  @override
  String get weatherSnow => '눈';

  @override
  String get weatherStorm => '폭풍';

  @override
  String get weatherFog => '안개';

  @override
  String get weatherDrizzle => '이슬비';

  @override
  String get weatherSunny => '맑음';

  @override
  String get heatWarningExtreme => '☀️ 극심한 더위! 최대 수분 섭취';

  @override
  String get heatWarningVeryHot => '🌡️ 매우 더움! 탈수 위험';

  @override
  String get heatWarningHot => '🔥 더움! 물을 더 마시세요';

  @override
  String get heatWarningElevated => '⚠️ 높은 온도';

  @override
  String get heatWarningComfortable => '쾌적한 온도';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% 물';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+${amount}mg 나트륨';
  }

  @override
  String get heatWarningCold => '❄️ 추움! 따뜻한 음료를 마시세요';

  @override
  String get notificationChannelName => '하이드로코치 알림';

  @override
  String get notificationChannelDescription => '수분 및 전해질 알림';

  @override
  String get urgentNotificationChannelName => '긴급 알림';

  @override
  String get urgentNotificationChannelDescription => '중요한 수분 섭취 알림';

  @override
  String get goodMorning => '☀️ 좋은 아침!';

  @override
  String get timeToHydrate => '💧 수분 보충 시간';

  @override
  String get eveningHydration => '💧 저녁 수분 섭취';

  @override
  String get dailyReportTitle => ' 일일 보고서 준비';

  @override
  String get dailyReportBody => '오늘의 수분 섭취 확인';

  @override
  String get maintainWaterBalance => '하루 종일 수분 균형 유지';

  @override
  String get electrolytesTime => '전해질 시간: 물에 소금 한 꼬집';

  @override
  String catchUpHydration(int percent) {
    return '일일 기준의 $percent%만 마셨습니다. 보충할 시간!';
  }

  @override
  String get excellentProgress => '훌륭한 진행! 목표까지 조금만 더';

  @override
  String get postCoffeeTitle => ' 커피 후';

  @override
  String get postCoffeeBody => '균형 회복을 위해 250-300ml 물 마시기';

  @override
  String get postWorkoutTitle => ' 운동 후';

  @override
  String get postWorkoutBody => '전해질 회복: 500ml 물 + 소금 한 꼬집';

  @override
  String get heatWarningPro => '🌡️ PRO 더위 경고';

  @override
  String get extremeHeatWarning => '극심한 더위! 물 15% 증가 및 소금 1g 추가';

  @override
  String get hotWeatherWarning => '더움! 물 10% 증가 및 전해질 잊지 마세요';

  @override
  String get warmWeatherWarning => '따뜻한 날씨. 수분 섭취 모니터링';

  @override
  String get alcoholRecoveryTitle => '🍺 회복 시간';

  @override
  String get alcoholRecoveryBody => '균형을 위해 소금 한 꼬집과 물 300ml 마시기';

  @override
  String get continueHydration => '💧 수분 섭취 계속';

  @override
  String get alcoholRecoveryBody2 => '추가로 500ml 물을 마시면 더 빨리 회복됩니다';

  @override
  String get morningRecoveryTitle => '☀️ 아침 회복';

  @override
  String get morningRecoveryBody => '500ml 물과 전해질로 하루 시작';

  @override
  String get testNotificationTitle => '🧪 테스트 알림';

  @override
  String get testNotificationBody => '보인다면 즉시 알림이 작동합니다!';

  @override
  String get scheduledTestTitle => '⏰ 예약된 테스트 (1분)';

  @override
  String get scheduledTestBody => '이 알림은 1분 전에 예약되었습니다. 예약 작동!';

  @override
  String get notificationServiceInitialized => '✅ 알림 서비스 초기화됨';

  @override
  String get localNotificationsInitialized => '✅ 로컬 알림 초기화됨';

  @override
  String get androidChannelsCreated => '📢 안드로이드 알림 채널 생성됨';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 알림 권한: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 정확한 알람 권한: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 FCM 권한: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 FCM 토큰 수신됨';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ 사용자 $userId의 FCM 토큰이 Firestore에 저장됨';
  }

  @override
  String get topicSubscriptionComplete => '✅ 주제 구독 완료';

  @override
  String foregroundMessage(String title) {
    return '📨 포그라운드 메시지: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 알림 열림: $messageId';
  }

  @override
  String get dailyLimitReached => '⚠️ 일일 알림 제한 도달 (무료 4개/일)';

  @override
  String schedulingError(String error) {
    return '❌ 알림 예약 오류: $error';
  }

  @override
  String get showingImmediatelyAsFallback => '대체로 즉시 알림 표시';

  @override
  String instantNotificationShown(String title) {
    return '📬 즉시 알림 표시됨: $title';
  }

  @override
  String get smartRemindersScheduled => '🧠 스마트 알림 예약 중...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ $count개 알림 예약됨';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: 커피 후 알림 예약됨';

  @override
  String get postWorkoutScheduled => '💪 운동 후 알림 예약됨';

  @override
  String get proHeatWarningPro => '🌡️ PRO: 더위 경고 전송됨';

  @override
  String get proAlcoholRecoveryPlan => '🍺 PRO: 알코올 회복 계획 예약됨';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 $day.$month 21:00에 저녁 보고서 예약됨';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 알림 $id 취소됨';
  }

  @override
  String get allNotificationsCancelled => '🗑️ 모든 알림 취소됨';

  @override
  String get reminderSettingsSaved => '✅ 알림 설정 저장됨';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ $time에 테스트 알림 예약됨';
  }

  @override
  String get tomorrowRecommendations => '내일을 위한 권장사항';

  @override
  String get recommendationExcellent =>
      '훌륭합니다! 계속하세요. 물 한 잔으로 하루를 시작하고 균등하게 섭취하세요.';

  @override
  String get recommendationDiluted =>
      '물을 많이 마시지만 전해질이 부족합니다. 내일 소금을 더 추가하거나 전해질 음료를 마시세요.';

  @override
  String get recommendationDehydrated =>
      '오늘 물이 부족합니다. 내일 2시간마다 알림을 설정하세요. 물병을 눈에 보이는 곳에 두세요.';

  @override
  String get recommendationLowSalt =>
      '낮은 나트륨 수치는 피로를 유발할 수 있습니다. 물에 소금을 추가하거나 육수를 마시세요.';

  @override
  String get recommendationGeneral =>
      '물과 전해질의 균형을 목표로 하세요. 하루 종일 고르게 마시고 더위에 소금을 잊지 마세요.';

  @override
  String get category_water => '물';

  @override
  String get category_hot_drinks => '따뜻한 음료';

  @override
  String get category_juice => '주스';

  @override
  String get category_sports => '스포츠';

  @override
  String get category_dairy => '유제품';

  @override
  String get category_alcohol => '알코올';

  @override
  String get category_supplements => '보충제';

  @override
  String get category_other => '기타';

  @override
  String get drink_water => '물';

  @override
  String get drink_sparkling_water => '탄산수';

  @override
  String get drink_mineral_water => '미네랄 워터';

  @override
  String get drink_coconut_water => '코코넛 워터';

  @override
  String get drink_coffee => '커피';

  @override
  String get drink_espresso => '에스프레소';

  @override
  String get drink_americano => '아메리카노';

  @override
  String get drink_cappuccino => '카푸치노';

  @override
  String get drink_latte => '라떼';

  @override
  String get drink_black_tea => '홍차';

  @override
  String get drink_green_tea => '녹차';

  @override
  String get drink_herbal_tea => '허브차';

  @override
  String get drink_matcha => '말차';

  @override
  String get drink_hot_chocolate => '핫초코';

  @override
  String get drink_orange_juice => '오렌지 주스';

  @override
  String get drink_apple_juice => '사과 주스';

  @override
  String get drink_grapefruit_juice => '자몽 주스';

  @override
  String get drink_tomato_juice => '토마토 주스';

  @override
  String get drink_vegetable_juice => '야채 주스';

  @override
  String get drink_smoothie => '스무디';

  @override
  String get drink_lemonade => '레모네이드';

  @override
  String get drink_isotonic => '이소토닉 음료';

  @override
  String get drink_electrolyte => '전해질 음료';

  @override
  String get drink_protein_shake => '단백질 쉐이크';

  @override
  String get drink_bcaa => 'BCAA 음료';

  @override
  String get drink_energy => '에너지 음료';

  @override
  String get drink_milk => '우유';

  @override
  String get drink_kefir => '케피어';

  @override
  String get drink_yogurt => '요구르트 음료';

  @override
  String get drink_almond_milk => '아몬드 우유';

  @override
  String get drink_soy_milk => '두유';

  @override
  String get drink_oat_milk => '귀리 우유';

  @override
  String get drink_beer_light => '라이트 맥주';

  @override
  String get drink_beer_regular => '일반 맥주';

  @override
  String get drink_beer_strong => '스트롱 맥주';

  @override
  String get drink_wine_red => '레드 와인';

  @override
  String get drink_wine_white => '화이트 와인';

  @override
  String get drink_champagne => '샴페인';

  @override
  String get drink_vodka => '보드카';

  @override
  String get drink_whiskey => '위스키';

  @override
  String get drink_rum => '럼';

  @override
  String get drink_gin => '진';

  @override
  String get drink_tequila => '데킬라';

  @override
  String get drink_mojito => '모히또';

  @override
  String get drink_margarita => '마가리타';

  @override
  String get drink_kombucha => '콤부차';

  @override
  String get drink_kvass => '크바스';

  @override
  String get drink_bone_broth => '뼈 육수';

  @override
  String get drink_vegetable_broth => '야채 육수';

  @override
  String get drink_soda => '탄산음료';

  @override
  String get drink_diet_soda => '다이어트 탄산음료';

  @override
  String get addedToFavorites => '즐겨찾기에 추가됨';

  @override
  String get favoriteLimitReached => '즐겨찾기 제한 도달 (무료 3개, PRO 20개)';

  @override
  String get addFavorite => '즐겨찾기 추가';

  @override
  String get hotAndSupplements => '따뜻한 음료 & 보충제';

  @override
  String get quickVolumes => '빠른 용량:';

  @override
  String get type => '유형:';

  @override
  String get regular => '일반';

  @override
  String get coconut => '코코넛';

  @override
  String get sparkling => '탄산';

  @override
  String get mineral => '미네랄';

  @override
  String get hotDrinks => '따뜻한 음료';

  @override
  String get supplements => '보충제';

  @override
  String get tea => '차';

  @override
  String get salt => '소금 (1/4 tsp)';

  @override
  String get electrolyteMix => '전해질 믹스';

  @override
  String get boneBroth => '뼈 육수';

  @override
  String get favoriteAssignmentComingSoon => '즐겨찾기 할당 곧 출시';

  @override
  String get longPressToEditComingSoon => '길게 눌러 편집 - 곧 출시';

  @override
  String get proSubscriptionRequired => 'PRO 구독 필요';

  @override
  String get saveToFavorites => '즐겨찾기에 저장';

  @override
  String get savedToFavorites => '즐겨찾기에 저장됨';

  @override
  String get selectFavoriteSlot => '즐겨찾기 슬롯 선택';

  @override
  String get slot => '슬롯';

  @override
  String get emptySlot => '빈 슬롯';

  @override
  String get upgradeToUnlock => 'PRO로 업그레이드하여 잠금 해제';

  @override
  String get changeFavorite => '즐겨찾기 변경';

  @override
  String get removeFavorite => '즐겨찾기 제거';

  @override
  String get ok => '확인';

  @override
  String get mineralWater => '미네랄 워터';

  @override
  String get coconutWater => '코코넛 워터';

  @override
  String get lemonWater => '레몬 워터';

  @override
  String get greenTea => '녹차';

  @override
  String get amount => '양';

  @override
  String get createFavoriteHint =>
      '즐겨찾기를 추가하려면 아래 음료 화면으로 이동하여 음료를 설정한 후 \'즐겨찾기에 저장\' 버튼을 누르세요.';

  @override
  String get sparklingWater => '탄산수';

  @override
  String get cola => '콜라';

  @override
  String get juice => '주스';

  @override
  String get energyDrink => '에너지 음료';

  @override
  String get sportsDrink => '스포츠 음료';

  @override
  String get selectElectrolyteType => '전해질 유형 선택:';

  @override
  String get saltQuarterTsp => '소금 (1/4 tsp)';

  @override
  String get pinkSalt => '핑크 히말라얀 소금';

  @override
  String get seaSalt => '바다 소금';

  @override
  String get potassiumCitrate => '칼륨 시트레이트';

  @override
  String get magnesiumGlycinate => '마그네슘 글리시네이트';

  @override
  String get coconutWaterElectrolyte => '코코넛 워터';

  @override
  String get sportsDrinkElectrolyte => '스포츠 음료';

  @override
  String get electrolyteContent => '전해질 함량:';

  @override
  String sodiumContent(int amount) {
    return '나트륨: ${amount}mg';
  }

  @override
  String potassiumContent(int amount) {
    return '칼륨: ${amount}mg';
  }

  @override
  String magnesiumContent(int amount) {
    return '마그네슘: ${amount}mg';
  }

  @override
  String get servings => '서빙';

  @override
  String get enterServings => '서빙 입력';

  @override
  String get servingsUnit => '서빙';

  @override
  String get noElectrolytes => '전해질 없음';

  @override
  String get enterValidAmount => '올바른 양을 입력하세요';

  @override
  String get lmntMix => 'LMNT 믹스';

  @override
  String get pickleJuice => '피클 주스';

  @override
  String get tomatoSalt => '토마토 + 소금';

  @override
  String get ketorade => '케토레이드';

  @override
  String get alkalineWater => '알칼리수';

  @override
  String get celticSalt => '켈틱 소금 워터';

  @override
  String get soleWater => '솔레 워터';

  @override
  String get mineralDrops => '미네랄 드롭';

  @override
  String get bakingSoda => '베이킹 소다 워터';

  @override
  String get creamTartar => '크림 오브 타르타르';

  @override
  String get selectSupplementType => '보충제 유형 선택:';

  @override
  String get multivitamin => '종합 비타민';

  @override
  String get magnesiumCitrate => '마그네슘 시트레이트';

  @override
  String get magnesiumThreonate => '마그네슘 L-트레오네이트';

  @override
  String get calciumCitrate => '칼슘 시트레이트';

  @override
  String get zincGlycinate => '아연 글리시네이트';

  @override
  String get vitaminD3 => '비타민 D3';

  @override
  String get vitaminC => '비타민 C';

  @override
  String get bComplex => '비타민 B 복합체';

  @override
  String get omega3 => '오메가-3';

  @override
  String get ironBisglycinate => '철분 비스글리시네이트';

  @override
  String get dosage => '복용량';

  @override
  String get enterDosage => '복용량 입력';

  @override
  String get noElectrolyteContent => '전해질 함량 없음';

  @override
  String get blackTea => '홍차';

  @override
  String get herbalTea => '허브차';

  @override
  String get espresso => '에스프레소';

  @override
  String get cappuccino => '카푸치노';

  @override
  String get latte => '라떼';

  @override
  String get matcha => '말차';

  @override
  String get hotChocolate => '핫초코';

  @override
  String get caffeine => '카페인';

  @override
  String get sports => '스포츠';

  @override
  String get walking => '걷기';

  @override
  String get running => '달리기';

  @override
  String get gym => '헬스';

  @override
  String get cycling => '사이클링';

  @override
  String get swimming => '수영';

  @override
  String get yoga => '요가';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => '크로스핏';

  @override
  String get boxing => '복싱';

  @override
  String get dancing => '댄스';

  @override
  String get tennis => '테니스';

  @override
  String get teamSports => '팀 스포츠';

  @override
  String get selectActivityType => '활동 유형 선택:';

  @override
  String get duration => '지속 시간';

  @override
  String get minutes => '분';

  @override
  String get enterDuration => '지속 시간 입력';

  @override
  String get lowIntensity => '낮은 강도';

  @override
  String get mediumIntensity => '중간 강도';

  @override
  String get highIntensity => '높은 강도';

  @override
  String get recommendedIntake => '권장 섭취량:';

  @override
  String get basedOnWeight => '체중 기준';

  @override
  String get logActivity => '활동 기록';

  @override
  String get activityLogged => '활동 기록됨';

  @override
  String get enterValidDuration => '올바른 지속 시간을 입력하세요';

  @override
  String get sauna => '사우나';

  @override
  String get veryHighIntensity => '매우 높은 강도';

  @override
  String get hriStatusExcellent => '우수';

  @override
  String get hriStatusGood => '좋음';

  @override
  String get hriStatusModerate => '중간 위험';

  @override
  String get hriStatusHighRisk => '높은 위험';

  @override
  String get hriStatusCritical => '위험';

  @override
  String get hriComponentWater => '수분 균형';

  @override
  String get hriComponentSodium => '나트륨 수치';

  @override
  String get hriComponentPotassium => '칼륨 수치';

  @override
  String get hriComponentMagnesium => '마그네슘 수치';

  @override
  String get hriComponentHeat => '열 스트레스';

  @override
  String get hriComponentWorkout => '신체 활동';

  @override
  String get hriComponentCaffeine => '카페인 영향';

  @override
  String get hriComponentAlcohol => '알코올 영향';

  @override
  String get hriComponentTime => '섭취 이후 시간';

  @override
  String get hriComponentMorning => '아침 요인';

  @override
  String get hriBreakdownTitle => '위험 요인 분석';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max점';
  }

  @override
  String get fastingModeActive => '단식 모드 활성';

  @override
  String get fastingSuppressionNote => '단식 중 시간 요인 억제';

  @override
  String get morningCheckInTitle => '아침 체크인';

  @override
  String get howAreYouFeeling => '기분이 어떠세요?';

  @override
  String get feelingScale1 => '나쁨';

  @override
  String get feelingScale2 => '평균 이하';

  @override
  String get feelingScale3 => '보통';

  @override
  String get feelingScale4 => '좋음';

  @override
  String get feelingScale5 => '우수';

  @override
  String get weightChange => '어제 대비 체중 변화';

  @override
  String get urineColorScale => '소변 색상 (1-8 스케일)';

  @override
  String get urineColor1 => '1 - 매우 옅음';

  @override
  String get urineColor2 => '2 - 옅음';

  @override
  String get urineColor3 => '3 - 연한 노랑';

  @override
  String get urineColor4 => '4 - 노랑';

  @override
  String get urineColor5 => '5 - 진한 노랑';

  @override
  String get urineColor6 => '6 - 호박색';

  @override
  String get urineColor7 => '7 - 진한 호박색';

  @override
  String get urineColor8 => '8 - 갈색';

  @override
  String get alcoholWithDecay => '알코올 영향 (감소 중)';

  @override
  String standardDrinksToday(Object count) {
    return '오늘 표준 음주량: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return '활성 카페인: ${amount}mg';
  }

  @override
  String get hriDebugInfo => 'HRI 디버그 정보';

  @override
  String hriNormalized(Object value) {
    return 'HRI (정규화): $value/100';
  }

  @override
  String get fastingWindowActive => '단식 기간 활성';

  @override
  String get eatingWindowActive => '식사 기간 활성';

  @override
  String nextFastingWindow(Object time) {
    return '다음 단식: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return '다음 식사: $time';
  }

  @override
  String get todaysWorkouts => '오늘의 운동';

  @override
  String get hoursAgo => '시간 전';

  @override
  String get onboardingWelcomeTitle => '하이드로코치 — 매일 스마트한 수분 섭취';

  @override
  String get onboardingWelcomeSubtitle =>
      '더 많이가 아닌 더 스마트하게\n앱은 날씨, 전해질 및 습관을 고려합니다\n맑은 정신과 안정적인 에너지 유지';

  @override
  String get onboardingBullet1 => '날씨와 당신에 기반한 개인별 물과 소금 기준';

  @override
  String get onboardingBullet2 => '원시 차트 대신 \'지금 무엇을 할지\' 팁';

  @override
  String get onboardingBullet3 => '안전한 한계가 있는 표준 용량의 알코올';

  @override
  String get onboardingBullet4 => '스팸 없는 스마트 알림';

  @override
  String get onboardingStartButton => '시작';

  @override
  String get onboardingHaveAccount => '이미 계정이 있습니다';

  @override
  String get onboardingPracticeFasting => '간헐적 단식을 합니다';

  @override
  String get onboardingPracticeFastingDesc => '단식 기간을 위한 특별 전해질 체계';

  @override
  String get onboardingProfileReady => '프로필 준비 완료!';

  @override
  String get onboardingWaterNorm => '수분 기준';

  @override
  String get onboardingIonWillHelp => 'ION이 매일 균형을 유지하도록 도와드립니다';

  @override
  String get onboardingContinue => '계속하기';

  @override
  String get onboardingLocationTitle => '수분 섭취에는 날씨가 중요합니다';

  @override
  String get onboardingLocationSubtitle =>
      '날씨와 습도를 고려합니다. 체중만으로 계산하는 것보다 더 정확합니다';

  @override
  String get onboardingWeatherExample => '오늘 더워요! +15% 물';

  @override
  String get onboardingWeatherExampleDesc => '더위를 위한 +500mg 나트륨';

  @override
  String get onboardingEnablePermission => '활성화';

  @override
  String get onboardingEnableLater => '나중에 활성화';

  @override
  String get onboardingNotificationTitle => '스마트 알림';

  @override
  String get onboardingNotificationSubtitle =>
      '적절한 순간에 짧은 팁. 한 번의 탭으로 빈도 변경 가능';

  @override
  String get onboardingNotifExample1 => '수분 보충 시간';

  @override
  String get onboardingNotifExample2 => '전해질 잊지 마세요';

  @override
  String get onboardingNotifExample3 => '더워요! 물을 더 마시세요';

  @override
  String get sportRecoveryProtocols => '스포츠 회복 프로토콜';

  @override
  String get allDrinksAndSupplements => '모든 음료 & 보충제';

  @override
  String get notificationChannelDefault => '수분 섭취 알림';

  @override
  String get notificationChannelDefaultDesc => '수분 및 전해질 알림';

  @override
  String get notificationChannelUrgent => '중요 알림';

  @override
  String get notificationChannelUrgentDesc => '더위 경고 및 중요한 수분 섭취 알림';

  @override
  String get notificationChannelReport => '보고서';

  @override
  String get notificationChannelReportDesc => '일일 및 주간 보고서';

  @override
  String get notificationWaterTitle => '💧 수분 보충 시간';

  @override
  String get notificationWaterBody => '물 마시는 것을 잊지 마세요';

  @override
  String get notificationPostCoffeeTitle => '☕ 커피 후';

  @override
  String get notificationPostCoffeeBody => '균형 회복을 위해 250-300ml 물 마시기';

  @override
  String get notificationDailyReportTitle => '📊 일일 보고서 준비';

  @override
  String get notificationDailyReportBody => '오늘의 수분 섭취 확인';

  @override
  String get notificationAlcoholCounterTitle => '🍺 회복 시간';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return '소금 한 꼬집과 함께 ${ml}ml 물 마시기';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ 더위 경고';

  @override
  String get notificationHeatWarningExtremeBody => '극심한 더위! +15% 물 및 +1g 소금';

  @override
  String get notificationHeatWarningHotBody => '더워요! +10% 물 및 전해질';

  @override
  String get notificationHeatWarningWarmBody => '따뜻함. 수분 섭취 모니터링';

  @override
  String get notificationWorkoutTitle => '💪 운동';

  @override
  String get notificationWorkoutBody => '물과 전해질 잊지 마세요';

  @override
  String get notificationPostWorkoutTitle => '💪 운동 후';

  @override
  String get notificationPostWorkoutBody => '회복을 위해 500ml 물 + 전해질';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ 전해질 시간';

  @override
  String get notificationFastingElectrolyteBody => '물에 소금 한 꼬집 추가 또는 육수 마시기';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 회복 ${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return '${ml}ml 물 마시기';
  }

  @override
  String get notificationAlcoholRecoveryMidBody => '전해질 추가: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody => '내일 아침 - 컨트롤 체크인';

  @override
  String get notificationMorningCheckInTitle => '☀️ 아침 체크인';

  @override
  String get notificationMorningCheckInBody =>
      '기분이 어떠세요? 컨디션을 평가하고 하루 계획을 받으세요';

  @override
  String get notificationMorningWaterBody => '물 한 잔으로 하루를 시작하세요';

  @override
  String notificationLowProgressBody(int percent) {
    return '기준의 $percent%만 마셨습니다. 보충할 시간!';
  }

  @override
  String get notificationGoodProgressBody => '훌륭한 진행! 계속하세요';

  @override
  String get notificationMaintainBalanceBody => '수분 균형 유지';

  @override
  String get notificationTestTitle => '🧪 테스트 알림';

  @override
  String get notificationTestBody => '보인다면 알림이 작동합니다!';

  @override
  String get notificationTestScheduledTitle => '⏰ 예약된 테스트';

  @override
  String get notificationTestScheduledBody => '이 알림은 1분 전에 예약되었습니다';

  @override
  String get onboardingUnitsTitle => '단위 선택';

  @override
  String get onboardingUnitsSubtitle => '나중에 변경할 수 없습니다';

  @override
  String get onboardingUnitsWarning => '이 선택은 영구적이며 나중에 변경할 수 없습니다';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => '갤런';

  @override
  String get lb => 'lb';

  @override
  String get target => '목표';

  @override
  String get wind => '바람';

  @override
  String get pressure => '기압';

  @override
  String get highHeatIndexWarning => '높은 열 지수! 물 섭취량을 늘리세요';

  @override
  String get weatherCondition => '상태';

  @override
  String get feelsLike => '체감';

  @override
  String get humidityLabel => '습도';

  @override
  String get waterNormal => '보통';

  @override
  String get sodiumNormal => '표준';

  @override
  String get addedSuccessfully => '성공적으로 추가됨';

  @override
  String get sugarIntake => '설탕 섭취';

  @override
  String get sugarToday => '오늘의 설탕 소비';

  @override
  String get totalSugar => '총 설탕';

  @override
  String get dailyLimit => '일일 제한';

  @override
  String get addedSugar => '첨가당';

  @override
  String get naturalSugar => '천연당';

  @override
  String get hiddenSugar => '숨겨진 설탕';

  @override
  String get sugarFromDrinks => '음료';

  @override
  String get sugarFromFood => '음식';

  @override
  String get sugarFromSnacks => '간식';

  @override
  String get sugarNormal => '보통';

  @override
  String get sugarModerate => '중간';

  @override
  String get sugarHigh => '높음';

  @override
  String get sugarCritical => '위험';

  @override
  String get sugarRecommendationNormal => '잘하고 있어요! 설탕 섭취량이 건강한 범위 내입니다';

  @override
  String get sugarRecommendationModerate => '단 음료와 간식을 줄이는 것을 고려하세요';

  @override
  String get sugarRecommendationHigh => '높은 설탕 섭취! 단 음료와 디저트를 제한하세요';

  @override
  String get sugarRecommendationCritical => '매우 높은 설탕! 오늘은 단 음료와 과자를 피하세요';

  @override
  String get noSugarIntake => '오늘 추적된 설탕 없음';

  @override
  String get hriImpact => 'HRI 영향';

  @override
  String get hri_component_sugar => '설탕';

  @override
  String get hri_sugar_description => '높은 설탕 섭취는 수분 섭취와 전반적인 건강에 영향을 줍니다';

  @override
  String get tip_reduce_sweet_drinks => '단 음료를 물이나 무가당 차로 대체하세요';

  @override
  String get tip_avoid_added_sugar => '라벨을 확인하고 첨가당이 있는 제품을 피하세요';

  @override
  String get tip_check_labels => '소스와 가공식품의 숨겨진 설탕을 주의하세요';

  @override
  String get tip_replace_soda => '탄산음료를 탄산수와 레몬으로 대체하세요';

  @override
  String get sugarSources => '설탕 출처';

  @override
  String get drinks => '음료';

  @override
  String get food => '음식';

  @override
  String get snacks => '간식';

  @override
  String get recommendedLimit => '권장량';

  @override
  String get points => '점';

  @override
  String get drinkLightBeer => '라이트 맥주';

  @override
  String get drinkLager => '라거';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => '스타우트';

  @override
  String get drinkWheatBeer => '밀맥주';

  @override
  String get drinkCraftBeer => '크래프트 맥주';

  @override
  String get drinkNonAlcoholic => '무알코올';

  @override
  String get drinkRadler => '라들러';

  @override
  String get drinkPilsner => '필스너';

  @override
  String get drinkRedWine => '레드 와인';

  @override
  String get drinkWhiteWine => '화이트 와인';

  @override
  String get drinkProsecco => '프로세코';

  @override
  String get drinkPort => '포트 와인';

  @override
  String get drinkRose => '로제';

  @override
  String get drinkDessertWine => '디저트 와인';

  @override
  String get drinkSangria => '상그리아';

  @override
  String get drinkSherry => '셰리';

  @override
  String get drinkVodkaShot => '보드카 샷';

  @override
  String get drinkCognac => '코냑';

  @override
  String get drinkLiqueur => '리큐르';

  @override
  String get drinkAbsinthe => '압생트';

  @override
  String get drinkBrandy => '브랜디';

  @override
  String get drinkLongIsland => '롱아일랜드';

  @override
  String get drinkGinTonic => '진토닉';

  @override
  String get drinkPinaColada => '피나 콜라다';

  @override
  String get drinkCosmopolitan => '코스모폴리탄';

  @override
  String get drinkMaiTai => '마이 타이';

  @override
  String get drinkBloodyMary => '블러디 메리';

  @override
  String get drinkDaiquiri => '다이키리';

  @override
  String popularDrinks(Object type) {
    return '인기 $type';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g 설탕';

  @override
  String get moderateConsumption => '적당한 소비';

  @override
  String get aboveRecommendations => '권장량 초과';

  @override
  String get highConsumption => '높은 소비';

  @override
  String get veryHighConsider => '매우 높음 - 중단 고려';

  @override
  String get noAlcoholToday => '오늘 알코올 없음';

  @override
  String get drinkWaterNow => '지금 300-500ml 물 마시기';

  @override
  String get addPinchSalt => '소금 한 꼬집 추가';

  @override
  String get avoidLateCoffee => '늦은 커피 피하기';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => '오늘의 전해질';

  @override
  String get greatBalance => '훌륭한 균형!';

  @override
  String get gettingThere => '거의 다 왔어요';

  @override
  String get needMoreElectrolytes => '더 많은 전해질 필요';

  @override
  String get lowElectrolyteLevels => '낮은 전해질 수치';

  @override
  String get electrolyteTips => '전해질 팁';

  @override
  String get takeWithWater => '충분한 물과 함께 섭취';

  @override
  String get bestBetweenMeals => '식사 사이에 가장 잘 흡수됨';

  @override
  String get startSmallAmounts => '소량부터 시작';

  @override
  String get extraDuringExercise => '운동 중 추가 필요';

  @override
  String get electrolytesBasic => '기본';

  @override
  String get electrolytesMixes => '믹스';

  @override
  String get electrolytesPills => '알약';

  @override
  String get popularSalts => '인기 소금 & 육수';

  @override
  String get popularMixes => '인기 전해질 믹스';

  @override
  String get popularSupplements => '인기 보충제';

  @override
  String get electrolyteSaltWater => '소금물';

  @override
  String get electrolytePinkSalt => '핑크 소금';

  @override
  String get electrolyteSeaSalt => '바다 소금';

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
  String get electrolytePotassiumChloride => '염화칼륨';

  @override
  String get electrolyteMagThreonate => '마그 트레오네이트';

  @override
  String get electrolyteTraceMinerals => '미량 미네랄';

  @override
  String get electrolyteZMAComplex => 'ZMA 복합체';

  @override
  String get electrolyteMultiMineral => '멀티 미네랄';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => '수분 섭취';

  @override
  String get todayHydration => '오늘의 수분 섭취';

  @override
  String get currentIntake => '섭취량';

  @override
  String get dailyGoal => '목표';

  @override
  String get toGo => '남은 양';

  @override
  String get goalReached => '목표 달성!';

  @override
  String get almostThere => '거의 다 왔어요!';

  @override
  String get halfwayThere => '절반 완료';

  @override
  String get keepGoing => '계속 해보세요!';

  @override
  String get startDrinking => '마시기 시작';

  @override
  String get plainWater => '일반';

  @override
  String get enhancedWater => '강화';

  @override
  String get beverages => '음료';

  @override
  String get sodas => '탄산음료';

  @override
  String get popularPlainWater => '인기 물 유형';

  @override
  String get popularEnhancedWater => '강화 & 주입';

  @override
  String get popularBeverages => '인기 음료';

  @override
  String get popularSodas => '인기 탄산음료 & 에너지';

  @override
  String get hydrationTips => '수분 섭취 팁';

  @override
  String get drinkRegularly => '소량을 규칙적으로 마시세요';

  @override
  String get roomTemperature => '실온 물이 더 잘 흡수됩니다';

  @override
  String get addLemon => '맛을 위해 레몬 추가';

  @override
  String get limitSugary => '단 음료 제한 - 탈수를 유발합니다';

  @override
  String get warmWater => '따뜻한 물';

  @override
  String get iceWater => '얼음물';

  @override
  String get filteredWater => '정수';

  @override
  String get distilledWater => '증류수';

  @override
  String get springWater => '샘물';

  @override
  String get hydrogenWater => '수소수';

  @override
  String get oxygenatedWater => '산소수';

  @override
  String get cucumberWater => '오이 워터';

  @override
  String get limeWater => '라임 워터';

  @override
  String get berryWater => '베리 워터';

  @override
  String get mintWater => '민트 워터';

  @override
  String get gingerWater => '생강 워터';

  @override
  String get caffeineStatusNone => '오늘 카페인 없음';

  @override
  String caffeineStatusModerate(Object amount) {
    return '중간: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return '높음: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return '매우 높음: ${amount}mg!';
  }

  @override
  String get caffeineDailyLimit => '일일 제한: 400mg';

  @override
  String get caffeineWarningTitle => '카페인 경고';

  @override
  String get caffeineWarning400 => '오늘 400mg 카페인을 초과했습니다';

  @override
  String get caffeineTipWater => '보상을 위해 물을 추가로 마시세요';

  @override
  String get caffeineTipAvoid => '오늘 더 이상의 카페인을 피하세요';

  @override
  String get caffeineTipSleep => '수면 품질에 영향을 줄 수 있습니다';

  @override
  String get total => '총';

  @override
  String get cupsToday => '오늘 컵';

  @override
  String get metabolizeTime => '대사 시간';

  @override
  String get aboutCaffeine => '카페인 정보';

  @override
  String get caffeineInfo1 => '커피는 주의력을 높이는 천연 카페인을 함유합니다';

  @override
  String get caffeineInfo2 => '대부분의 성인에게 일일 안전 제한은 400mg입니다';

  @override
  String get caffeineInfo3 => '카페인 반감기는 5-6시간입니다';

  @override
  String get caffeineInfo4 => '카페인의 이뇨 효과를 보상하기 위해 물을 추가로 마시세요';

  @override
  String get caffeineWarningPregnant => '임산부는 카페인을 200mg/일로 제한해야 합니다';

  @override
  String get gotIt => '알겠습니다';

  @override
  String get consumed => '섭취량';

  @override
  String get remaining => '남은 양';

  @override
  String get todaysCaffeine => '오늘의 카페인';

  @override
  String get alreadyInFavorites => '이미 즐겨찾기에 있습니다';

  @override
  String get ofRecommendedLimit => '권장 제한의';

  @override
  String get aboutAlcohol => '알코올 정보';

  @override
  String get alcoholInfo1 => '표준 음주량 1잔은 순수 알코올 10g입니다';

  @override
  String get alcoholInfo2 => '알코올은 탈수를 유발합니다 — 음주 1잔당 물 250ml 추가';

  @override
  String get alcoholInfo3 => '음주 후 수분 유지를 위해 나트륨 추가';

  @override
  String get alcoholInfo4 => '표준 음주량 1잔은 HRI를 3-5점 증가시킵니다';

  @override
  String get alcoholWarningHealth =>
      '과도한 알코올 소비는 건강에 해롭습니다. 권장 제한은 남성 2 SD, 여성 1 SD입니다.';

  @override
  String get supplementsInfo1 => '보충제는 전해질 균형 유지에 도움을 줍니다';

  @override
  String get supplementsInfo2 => '흡수를 위해 식사와 함께 섭취하는 것이 가장 좋습니다';

  @override
  String get supplementsInfo3 => '항상 충분한 물과 함께 섭취하세요';

  @override
  String get supplementsInfo4 => '마그네슘과 칼륨은 수분 섭취의 핵심입니다';

  @override
  String get supplementsWarning => '보충제 요법을 시작하기 전에 의료 전문가와 상담하세요';

  @override
  String get fromSupplementsToday => '오늘 보충제로부터';

  @override
  String get minerals => '미네랄';

  @override
  String get vitamins => '비타민';

  @override
  String get essentialMinerals => '필수 미네랄';

  @override
  String get otherSupplements => '기타 보충제';

  @override
  String get supplementTip1 => '더 나은 흡수를 위해 음식과 함께 보충제 섭취';

  @override
  String get supplementTip2 => '보충제와 함께 충분한 물 마시기';

  @override
  String get supplementTip3 => '여러 보충제를 하루 종일 분산 섭취';

  @override
  String get supplementTip4 => '자신에게 맞는 것을 추적';

  @override
  String get calciumCarbonate => '탄산칼슘';

  @override
  String get traceMinerals => '미량 미네랄';

  @override
  String get vitaminA => '비타민 A';

  @override
  String get vitaminE => '비타민 E';

  @override
  String get vitaminK2 => '비타민 K2';

  @override
  String get folate => '엽산';

  @override
  String get biotin => '비오틴';

  @override
  String get probiotics => '프로바이오틱스';

  @override
  String get melatonin => '멜라토닌';

  @override
  String get collagen => '콜라겐';

  @override
  String get glucosamine => '글루코사민';

  @override
  String get turmeric => '강황';

  @override
  String get coq10 => 'CoQ10';

  @override
  String get creatine => '크레아틴';

  @override
  String get ashwagandha => '아슈와간다';

  @override
  String get selectCardioActivity => '유산소 활동 선택';

  @override
  String get selectStrengthActivity => '근력 활동 선택';

  @override
  String get selectSportsActivity => '스포츠 선택';

  @override
  String get sessions => '세션';

  @override
  String get totalTime => '총 시간';

  @override
  String get waterLoss => '수분 손실';

  @override
  String get intensity => '강도';

  @override
  String get drinkWaterAfterWorkout => '운동 후 물 마시기';

  @override
  String get replenishElectrolytes => '전해질 보충';

  @override
  String get restAndRecover => '휴식 및 회복';

  @override
  String get avoidSugaryDrinks => '단 스포츠 음료 피하기';

  @override
  String get elliptical => '일립티컬';

  @override
  String get rowing => '로잉';

  @override
  String get jumpRope => '줄넘기';

  @override
  String get stairClimbing => '계단 오르기';

  @override
  String get bodyweight => '맨몸 운동';

  @override
  String get powerlifting => '파워리프팅';

  @override
  String get calisthenics => '칼리스테닉스';

  @override
  String get resistanceBands => '저항 밴드';

  @override
  String get kettlebell => '케틀벨';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => '스트롱맨';

  @override
  String get pilates => '필라테스';

  @override
  String get basketball => '농구';

  @override
  String get soccerFootball => '축구';

  @override
  String get golf => '골프';

  @override
  String get martialArts => '무술';

  @override
  String get rockClimbing => '암벽 등반';

  @override
  String get needsToReplenish => '보충 필요';

  @override
  String get electrolyteTrackingPro => '나트륨, 칼륨 & 마그네슘 목표를 상세한 진행 표시줄로 추적';

  @override
  String get unlock => '잠금 해제';

  @override
  String get weather => '날씨';

  @override
  String get weatherTrackingPro => '열 지수, 습도 및 날씨가 수분 섭취 목표에 미치는 영향 추적';

  @override
  String get sugarTracking => '설탕 추적';

  @override
  String get sugarTrackingPro => 'HRI 영향 분석과 함께 천연, 첨가 및 숨겨진 설탕 섭취 모니터링';

  @override
  String get dayOverview => '일일 개요';

  @override
  String get tapForDetails => '자세히 보려면 탭';

  @override
  String get noDataForDay => '이 날의 데이터 없음';

  @override
  String get sweatLoss => '땀 손실';

  @override
  String get cardio => '유산소';

  @override
  String get workout => '운동';

  @override
  String get noWaterToday => '오늘 물 기록 없음';

  @override
  String get noElectrolytesToday => '오늘 전해질 기록 없음';

  @override
  String get noCoffeeToday => '오늘 커피 기록 없음';

  @override
  String get noWorkoutsToday => '오늘 운동 기록 없음';

  @override
  String get noWaterThisDay => '이 날 물 기록 없음';

  @override
  String get noElectrolytesThisDay => '이 날 전해질 기록 없음';

  @override
  String get noCoffeeThisDay => '이 날 커피 기록 없음';

  @override
  String get noWorkoutsThisDay => '이 날 운동 기록 없음';

  @override
  String get weeklyReport => '주간 보고서';

  @override
  String get weeklyReportSubtitle => '심층 분석 및 경향 분석';

  @override
  String get workouts => '운동';

  @override
  String get workoutHydration => '운동 수분 섭취';

  @override
  String workoutHydrationMessage(Object percent) {
    return '운동하는 날에 $percent% 더 많은 물을 마십니다';
  }

  @override
  String get weeklyActivity => '주간 활동';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return '$days일 동안 $minutes분 운동했습니다';
  }

  @override
  String get workoutMinutesPerDay => '일일 운동 분';

  @override
  String get daysWithWorkouts => '운동한 날';

  @override
  String get noWorkoutsThisWeek => '이번 주 운동 없음';

  @override
  String get noAlcoholThisWeek => '이번 주 알코올 없음';

  @override
  String get csvExported => 'CSV로 데이터 내보냄';

  @override
  String get mondayShort => '월';

  @override
  String get tuesdayShort => '화';

  @override
  String get wednesdayShort => '수';

  @override
  String get thursdayShort => '목';

  @override
  String get fridayShort => '금';

  @override
  String get saturdayShort => '토';

  @override
  String get sundayShort => '일';

  @override
  String get achievements => '업적';

  @override
  String get achievementsTabAll => '모두';

  @override
  String get achievementsTabHydration => '수분 섭취';

  @override
  String get achievementsTabElectrolytes => '전해질';

  @override
  String get achievementsTabSugar => '설탕 조절';

  @override
  String get achievementsTabAlcohol => '알코올';

  @override
  String get achievementsTabWorkout => '운동';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => '연속 기록';

  @override
  String get achievementsTabSpecial => '특별';

  @override
  String get achievementUnlocked => '업적 잠금 해제!';

  @override
  String get achievementProgress => '진행도';

  @override
  String get achievementPoints => '포인트';

  @override
  String get achievementRarityCommon => '일반';

  @override
  String get achievementRarityUncommon => '희귀';

  @override
  String get achievementRarityRare => '레어';

  @override
  String get achievementRarityEpic => '에픽';

  @override
  String get achievementRarityLegendary => '전설';

  @override
  String get achievementStatsUnlocked => '잠금 해제됨';

  @override
  String get achievementStatsTotal => '총 포인트';

  @override
  String get achievementFilterAll => '모두';

  @override
  String get achievementFilterUnlocked => '잠금 해제';

  @override
  String get achievementSortProgress => '진행도';

  @override
  String get achievementSortName => '이름';

  @override
  String get achievementSortRarity => '희귀도';

  @override
  String get achievementNoAchievements => '아직 업적이 없습니다';

  @override
  String get achievementKeepUsing => '업적을 잠금 해제하려면 앱을 계속 사용하세요!';

  @override
  String get achievementFirstGlass => '첫 방울';

  @override
  String get achievementFirstGlassDesc => '첫 번째 물 한 잔 마시기';

  @override
  String get achievementHydrationGoal1 => '수분 보충';

  @override
  String get achievementHydrationGoal1Desc => '일일 물 목표 달성';

  @override
  String get achievementHydrationGoal7 => '일주일 수분 섭취';

  @override
  String get achievementHydrationGoal7Desc => '7일 연속 물 목표 달성';

  @override
  String get achievementHydrationGoal30 => '수분 섭취 마스터';

  @override
  String get achievementHydrationGoal30Desc => '30일 연속 물 목표 달성';

  @override
  String get achievementPerfectHydration => '완벽한 균형';

  @override
  String get achievementPerfectHydrationDesc => '물 목표의 90-110% 달성';

  @override
  String get achievementEarlyBird => '이른 새';

  @override
  String get achievementEarlyBirdDesc => '오전 9시 전에 첫 물 마시기';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return '오전 9시 전에 $volume 마시기';
  }

  @override
  String get achievementNightOwl => '올빼미';

  @override
  String get achievementNightOwlDesc => '오후 6시 전에 수분 섭취 목표 완료';

  @override
  String get achievementLiterLegend => '리터 전설';

  @override
  String get achievementLiterLegendDesc => '총 수분 섭취 마일스톤 달성';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return '총 $volume 마시기';
  }

  @override
  String get achievementSaltStarter => '소금 스타터';

  @override
  String get achievementSaltStarterDesc => '첫 전해질 추가';

  @override
  String get achievementElectrolyteBalance => '균형잡힌';

  @override
  String get achievementElectrolyteBalanceDesc => '하루에 모든 전해질 목표 달성';

  @override
  String get achievementSodiumMaster => '나트륨 마스터';

  @override
  String get achievementSodiumMasterDesc => '7일 연속 나트륨 목표 달성';

  @override
  String get achievementPotassiumPro => '칼륨 프로';

  @override
  String get achievementPotassiumProDesc => '7일 연속 칼륨 목표 달성';

  @override
  String get achievementMagnesiumMaven => '마그네슘 전문가';

  @override
  String get achievementMagnesiumMavenDesc => '7일 연속 마그네슘 목표 달성';

  @override
  String get achievementElectrolyteExpert => '전해질 전문가';

  @override
  String get achievementElectrolyteExpertDesc => '30일 완벽한 전해질 균형';

  @override
  String get achievementSugarAwareness => '설탕 인식';

  @override
  String get achievementSugarAwarenessDesc => '처음으로 설탕 추적';

  @override
  String get achievementSugarUnder25 => '달콤한 조절';

  @override
  String get achievementSugarUnder25Desc => '하루 동안 낮은 설탕 섭취 유지';

  @override
  String achievementSugarUnder25Template(String weight) {
    return '하루 동안 설탕을 $weight 이하로 유지';
  }

  @override
  String get achievementSugarWeekControl => '설탕 훈련';

  @override
  String get achievementSugarWeekControlDesc => '일주일 동안 낮은 설탕 섭취 유지';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return '7일 동안 설탕을 $weight 이하로 유지';
  }

  @override
  String get achievementSugarFreeDay => '무설탕';

  @override
  String get achievementSugarFreeDayDesc => '첨가당 0g으로 하루 완료';

  @override
  String get achievementSugarDetective => '설탕 탐정';

  @override
  String get achievementSugarDetectiveDesc => '숨겨진 설탕 10회 추적';

  @override
  String get achievementSugarMaster => '설탕 마스터';

  @override
  String get achievementSugarMasterDesc => '한 달 동안 매우 낮은 설탕 섭취 유지';

  @override
  String get achievementNoSodaWeek => '일주일 무탄산음료';

  @override
  String get achievementNoSodaWeekDesc => '7일 동안 탄산음료 없음';

  @override
  String get achievementNoSodaMonth => '한 달 무탄산음료';

  @override
  String get achievementNoSodaMonthDesc => '30일 동안 탄산음료 없음';

  @override
  String get achievementSweetToothTamed => '단 것 길들임';

  @override
  String get achievementSweetToothTamedDesc => '일주일 동안 일일 설탕을 50% 줄임';

  @override
  String get achievementAlcoholTracker => '인식';

  @override
  String get achievementAlcoholTrackerDesc => '알코올 소비 추적';

  @override
  String get achievementModerateDay => '절제';

  @override
  String get achievementModerateDayDesc => '하루에 2 SD 이하 유지';

  @override
  String get achievementSoberDay => '금주일';

  @override
  String get achievementSoberDayDesc => '알코올 없는 하루 완료';

  @override
  String get achievementSoberWeek => '금주 일주일';

  @override
  String get achievementSoberWeekDesc => '7일 알코올 없음';

  @override
  String get achievementSoberMonth => '금주 한 달';

  @override
  String get achievementSoberMonthDesc => '30일 알코올 없음';

  @override
  String get achievementRecoveryProtocol => '회복 프로';

  @override
  String get achievementRecoveryProtocolDesc => '음주 후 회복 프로토콜 완료';

  @override
  String get achievementFirstWorkout => '움직이기';

  @override
  String get achievementFirstWorkoutDesc => '첫 운동 기록';

  @override
  String get achievementWorkoutWeek => '활동적인 주';

  @override
  String get achievementWorkoutWeekDesc => '일주일에 3회 운동';

  @override
  String get achievementCenturySweat => '땀 100';

  @override
  String get achievementCenturySweatDesc => '운동을 통해 상당한 수분 손실';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return '운동을 통해 $volume 손실';
  }

  @override
  String get achievementCardioKing => '유산소 왕';

  @override
  String get achievementCardioKingDesc => '10회 유산소 세션 완료';

  @override
  String get achievementStrengthWarrior => '근력 전사';

  @override
  String get achievementStrengthWarriorDesc => '10회 근력 세션 완료';

  @override
  String get achievementHRIGreen => '녹색 구역';

  @override
  String get achievementHRIGreenDesc => '하루 동안 HRI를 녹색 구역에 유지';

  @override
  String get achievementHRIWeekGreen => '안전한 주';

  @override
  String get achievementHRIWeekGreenDesc => '7일 동안 HRI를 녹색 구역에 유지';

  @override
  String get achievementHRIPerfect => '완벽한 점수';

  @override
  String get achievementHRIPerfectDesc => 'HRI 20 미만 달성';

  @override
  String get achievementHRIRecovery => '빠른 회복';

  @override
  String get achievementHRIRecoveryDesc => '하루에 HRI를 빨강에서 녹색으로 감소';

  @override
  String get achievementHRIMaster => 'HRI 마스터';

  @override
  String get achievementHRIMasterDesc => '30일 동안 HRI를 30 미만으로 유지';

  @override
  String get achievementStreak3 => '시작하기';

  @override
  String get achievementStreak3Desc => '3일 연속';

  @override
  String get achievementStreak7 => '일주일 전사';

  @override
  String get achievementStreak7Desc => '7일 연속';

  @override
  String get achievementStreak30 => '일관성의 왕';

  @override
  String get achievementStreak30Desc => '30일 연속';

  @override
  String get achievementStreak100 => '100일 클럽';

  @override
  String get achievementStreak100Desc => '100일 연속';

  @override
  String get achievementFirstWeek => '첫 주';

  @override
  String get achievementFirstWeekDesc => '7일 동안 앱 사용';

  @override
  String get achievementProMember => 'PRO 회원';

  @override
  String get achievementProMemberDesc => 'PRO 구독자 되기';

  @override
  String get achievementDataExport => '데이터 분석가';

  @override
  String get achievementDataExportDesc => 'CSV로 데이터 내보내기';

  @override
  String get achievementAllCategories => '만능 선수';

  @override
  String get achievementAllCategoriesDesc => '각 카테고리에서 최소 하나의 업적 잠금 해제';

  @override
  String get achievementHunter => '업적 사냥꾼';

  @override
  String get achievementHunterDesc => '모든 업적의 50% 잠금 해제';

  @override
  String get achievementDetailsUnlockedOn => '잠금 해제일';

  @override
  String get achievementNewUnlocked => '새로운 업적 잠금 해제!';

  @override
  String get achievementViewAll => '모든 업적 보기';

  @override
  String get achievementCloseNotification => '닫기';

  @override
  String get before => '전';

  @override
  String get after => '후';

  @override
  String get lose => '손실';

  @override
  String get through => '통해';

  @override
  String get throughWorkouts => '운동을 통해';

  @override
  String get reach => '달성';

  @override
  String get daysInRow => '일 연속';

  @override
  String get completeHydrationGoal => '수분 섭취 목표 완료';

  @override
  String get stayUnder => '이하로 유지';

  @override
  String get inADay => '하루에';

  @override
  String get alcoholFree => '알코올 없음';

  @override
  String get complete => '완료';

  @override
  String get achieve => '달성';

  @override
  String get keep => '유지';

  @override
  String get for30Days => '30일 동안';

  @override
  String get liters => '리터';

  @override
  String get completed => '완료됨';

  @override
  String get notCompleted => '완료되지 않음';

  @override
  String get days => '일';

  @override
  String get hours => '시간';

  @override
  String get times => '회';

  @override
  String get row => '연속';

  @override
  String get ofTotal => '전체의';

  @override
  String get perDay => '일당';

  @override
  String get perWeek => '주당';

  @override
  String get streak => '연속';

  @override
  String get tapToDismiss => '탭하여 닫기';

  @override
  String tutorialStep1(String volume) {
    return '안녕! 최적의 수분 섭취 여정을 시작하는 것을 도와드릴게요. $volume의 첫 모금을 마셔봅시다!';
  }

  @override
  String tutorialStep2(String volume) {
    return '훌륭해요! 이제 작동 방식을 느끼기 위해 $volume를 더 추가해봅시다.';
  }

  @override
  String get tutorialStep3 =>
      '뛰어나요! 이제 하이드로코치를 독립적으로 사용할 준비가 되었습니다. 완벽한 수분 섭취 달성을 도와드리겠습니다!';

  @override
  String get tutorialComplete => '사용 시작';

  @override
  String get onboardingNotificationExamplesTitle => '스마트 알림';

  @override
  String get onboardingNotificationExamplesSubtitle =>
      '하이드로코치는 언제 물이 필요한지 알고 있습니다';

  @override
  String get onboardingLocationExamplesTitle => '개인 조언';

  @override
  String get onboardingLocationExamplesSubtitle => '정확한 권장사항을 위해 날씨를 고려합니다';

  @override
  String get onboardingAllowNotifications => '알림 허용';

  @override
  String get onboardingAllowLocation => '위치 허용';

  @override
  String get foodCatalog => '음식 카탈로그';

  @override
  String get todaysFoodIntake => '오늘의 음식 섭취';

  @override
  String get noFoodToday => '오늘 기록된 음식 없음';

  @override
  String foodItemsCount(int count) {
    return '$count개 음식 항목';
  }

  @override
  String get waterFromFood => '음식의 수분';

  @override
  String get last => '마지막';

  @override
  String get categoryFruits => '과일';

  @override
  String get categoryVegetables => '채소';

  @override
  String get categorySoups => '수프';

  @override
  String get categoryDairy => '유제품';

  @override
  String get categoryMeat => '육류';

  @override
  String get categoryFastFood => '패스트푸드';

  @override
  String get weightGrams => '무게 (그램)';

  @override
  String get enterWeight => '무게 입력';

  @override
  String get grams => 'g';

  @override
  String get calories => '칼로리';

  @override
  String get waterContent => '수분 함량';

  @override
  String get sugar => '설탕';

  @override
  String get nutritionalInfo => '영양 정보';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '${weight}g당 $calories kcal';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '${weight}g당 ${water}ml 수분';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${weight}g당 ${sugar}g 설탕';
  }

  @override
  String get addFood => '음식 추가';

  @override
  String get foodAdded => '음식이 성공적으로 추가됨';

  @override
  String get enterValidWeight => '올바른 무게를 입력하세요';

  @override
  String get proOnlyFood => 'PRO 전용';

  @override
  String get unlockProForFood => 'PRO를 잠금 해제하여 모든 음식 항목에 액세스하세요';

  @override
  String get foodTracker => '음식 추적기';

  @override
  String get todaysFoodSummary => '오늘의 음식 요약';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => '100g당';

  @override
  String get addToFavorites => '즐겨찾기에 추가';

  @override
  String get favoritesFeatureComingSoon => '즐겨찾기 기능 곧 출시!';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food 추가됨! +$calories kcal, +$water';
  }

  @override
  String get selectWeight => '무게 선택';

  @override
  String get ounces => 'oz';

  @override
  String get items => '항목';

  @override
  String get tapToAddFood => '탭하여 음식 추가';

  @override
  String get noFoodLoggedToday => '오늘 기록된 음식 없음';

  @override
  String get lightEatingDay => '가벼운 식사일';

  @override
  String get moderateIntake => '적당한 섭취';

  @override
  String get goodCalorieIntake => '좋은 칼로리 섭취';

  @override
  String get substantialMeals => '든든한 식사';

  @override
  String get highCalorieDay => '높은 칼로리일';

  @override
  String get veryHighIntake => '매우 높은 섭취';

  @override
  String get caloriesTracker => '칼로리 추적기';

  @override
  String get trackYourDailyCalorieIntake => '일일 음식 칼로리 섭취 추적';

  @override
  String get unlockFoodTrackingFeatures => '음식 추적 기능 잠금 해제';

  @override
  String get selectFoodType => '음식 유형 선택';

  @override
  String get foodApple => '사과';

  @override
  String get foodBanana => '바나나';

  @override
  String get foodOrange => '오렌지';

  @override
  String get foodWatermelon => '수박';

  @override
  String get foodStrawberry => '딸기';

  @override
  String get foodGrapes => '포도';

  @override
  String get foodPineapple => '파인애플';

  @override
  String get foodMango => '망고';

  @override
  String get foodPear => '배';

  @override
  String get foodCarrot => '당근';

  @override
  String get foodBroccoli => '브로콜리';

  @override
  String get foodSpinach => '시금치';

  @override
  String get foodTomato => '토마토';

  @override
  String get foodCucumber => '오이';

  @override
  String get foodBellPepper => '피망';

  @override
  String get foodLettuce => '상추';

  @override
  String get foodOnion => '양파';

  @override
  String get foodCelery => '셀러리';

  @override
  String get foodPotato => '감자';

  @override
  String get foodChickenSoup => '치킨 수프';

  @override
  String get foodTomatoSoup => '토마토 수프';

  @override
  String get foodVegetableSoup => '야채 수프';

  @override
  String get foodMinestrone => '미네스트로네';

  @override
  String get foodMisoSoup => '미소 수프';

  @override
  String get foodMushroomSoup => '버섯 수프';

  @override
  String get foodBeefStew => '비프 스튜';

  @override
  String get foodLentilSoup => '렌틸 수프';

  @override
  String get foodOnionSoup => '프렌치 어니언 수프';

  @override
  String get foodMilk => '우유';

  @override
  String get foodYogurt => '그릭 요거트';

  @override
  String get foodCheese => '체다 치즈';

  @override
  String get foodCottageCheese => '코티지 치즈';

  @override
  String get foodButter => '버터';

  @override
  String get foodCream => '헤비 크림';

  @override
  String get foodIceCream => '아이스크림';

  @override
  String get foodMozzarella => '모짜렐라';

  @override
  String get foodParmesan => '파마산';

  @override
  String get foodChickenBreast => '닭가슴살';

  @override
  String get foodBeef => '갈은 소고기';

  @override
  String get foodSalmon => '연어';

  @override
  String get foodEggs => '계란';

  @override
  String get foodTuna => '참치';

  @override
  String get foodPork => '돼지 갈비';

  @override
  String get foodTurkey => '칠면조';

  @override
  String get foodShrimp => '새우';

  @override
  String get foodBacon => '베이컨';

  @override
  String get foodBigMac => '빅맥';

  @override
  String get foodPizza => '피자 조각';

  @override
  String get foodFrenchFries => '프렌치 프라이';

  @override
  String get foodChickenNuggets => '치킨 너겟';

  @override
  String get foodHotDog => '핫도그';

  @override
  String get foodTacos => '타코';

  @override
  String get foodSubway => '서브웨이 샌드위치';

  @override
  String get foodDonut => '도넛';

  @override
  String get foodBurgerKing => '와퍼';

  @override
  String get foodSausage => '소시지';

  @override
  String get foodKefir => '케피어';

  @override
  String get foodRyazhenka => '랴젠카';

  @override
  String get foodDoner => '도너';

  @override
  String get foodShawarma => '샤와르마';

  @override
  String get foodBorscht => '보르시';

  @override
  String get foodRamen => '라멘';

  @override
  String get foodCabbage => '양배추';

  @override
  String get foodPeaSoup => '완두콩 수프';

  @override
  String get foodSolyanka => '솔랸카';

  @override
  String get meals => '식사';

  @override
  String get dailyProgress => '일일 진행도';

  @override
  String get fromFood => '음식으로부터';

  @override
  String get noFoodThisWeek => '이번 주 음식 데이터 없음';

  @override
  String get foodIntake => '음식 섭취';

  @override
  String get foodStats => '음식 통계';

  @override
  String get totalCalories => '총 칼로리';

  @override
  String get avgCaloriesPerDay => '일당 평균';

  @override
  String get daysWithFood => '음식이 있는 날';

  @override
  String get avgMealsPerDay => '일당 식사';

  @override
  String get caloriesPerDay => '일당 칼로리';

  @override
  String get sugarPerDay => '일당 설탕';

  @override
  String get foodTracking => '음식 추적';

  @override
  String get foodTrackingPro => '수분 섭취 및 HRI에 대한 음식 영향 추적';

  @override
  String get hydrationBalance => '수분 균형';

  @override
  String get highSodiumFood => '음식의 높은 나트륨';

  @override
  String get hydratingFood => '훌륭한 수분 선택';

  @override
  String get dryFood => '낮은 수분 함량 음식';

  @override
  String get balancedFood => '균형 잡힌 영양';

  @override
  String get foodAdviceEmpty => '수분 섭취에 대한 음식 영향을 추적하려면 식사를 추가하세요.';

  @override
  String get foodAdviceHighSodium => '높은 나트륨 섭취가 감지되었습니다. 전해질 균형을 위해 물을 늘리세요.';

  @override
  String get foodAdviceLowWater => '음식의 수분 함량이 낮았습니다. 물을 추가로 마시는 것을 고려하세요.';

  @override
  String get foodAdviceGoodHydration => '훌륭해요! 음식이 수분 섭취에 도움이 됩니다.';

  @override
  String get foodAdviceBalanced => '좋은 영양! 물 마시는 것을 잊지 마세요.';

  @override
  String get richInElectrolytes => '전해질이 풍부함';

  @override
  String recommendedCalories(int calories) {
    return '권장 칼로리: ~$calories kcal/일';
  }

  @override
  String get proWelcomeTitle => '하이드로코치 PRO를 환영합니다!';

  @override
  String get proTrialActivated => '7일 무료 체험 활성화!';

  @override
  String get proFeaturePersonalizedRecommendations => '개인화된 권장사항';

  @override
  String get proFeatureAdvancedAnalytics => '고급 분석';

  @override
  String get proFeatureWorkoutTracking => '운동 추적';

  @override
  String get proFeatureElectrolyteControl => '전해질 조절';

  @override
  String get proFeatureSmartReminders => '스마트 알림';

  @override
  String get proFeatureHriIndex => 'HRI 지수';

  @override
  String get proFeatureAchievements => 'PRO 업적';

  @override
  String get proFeaturePersonalizedDescription => '개별 수분 섭취 조언';

  @override
  String get proFeatureAdvancedDescription => '상세 차트 및 통계';

  @override
  String get proFeatureWorkoutDescription => '스포츠 중 수분 손실 추적';

  @override
  String get proFeatureElectrolyteDescription => '나트륨, 칼륨, 마그네슘 모니터링';

  @override
  String get proFeatureSmartDescription => '개인화된 알림';

  @override
  String get proFeatureNoMoreAds => '광고 없음!';

  @override
  String get proFeatureNoMoreAdsDescription => '광고 없이 중단 없는 수분 섭취 추적 즐기기';

  @override
  String get proFeatureHriDescription => '실시간 수분 위험 지수';

  @override
  String get proFeatureAchievementsDescription => '독점 보상 및 목표';

  @override
  String get startUsing => '사용 시작';

  @override
  String get sayGoodbyeToAds => '광고에 작별 인사. 프리미엄으로 가기.';

  @override
  String get goPremium => '프리미엄 가기';

  @override
  String get removeAdsForever => '광고를 영원히 제거';

  @override
  String get upgrade => '업그레이드';

  @override
  String get support => '지원';

  @override
  String get companyWebsite => '회사 웹사이트';

  @override
  String get appStoreOpened => '앱 스토어 열림';

  @override
  String get linkCopiedToClipboard => '링크가 클립보드에 복사됨';

  @override
  String get shareDialogOpened => '공유 대화상자 열림';

  @override
  String get linkForSharingCopied => '공유 링크 복사됨';

  @override
  String get websiteOpenedInBrowser => '브라우저에서 웹사이트 열림';

  @override
  String get emailClientOpened => '이메일 클라이언트 열림';

  @override
  String get emailCopiedToClipboard => '이메일이 클립보드에 복사됨';

  @override
  String get privacyPolicyOpened => '개인정보 처리방침 열림';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString까지의 통계';
  }

  @override
  String get monthlyInsights => '월간 인사이트';

  @override
  String get average => '평균';

  @override
  String get daysOver => '초과 일수';

  @override
  String get maximum => '최대';

  @override
  String get balance => '균형';

  @override
  String get allNormal => '모두 정상';

  @override
  String get excellentConsistency => '우수한 일관성';

  @override
  String get goodResults => '좋은 결과';

  @override
  String get positiveImprovement => '긍정적 개선';

  @override
  String get physicalActivity => '신체 활동';

  @override
  String get coffeeConsumption => '커피 소비';

  @override
  String get excellentSobriety => '우수한 절주';

  @override
  String get excellentMonth => '우수한 월';

  @override
  String get keepGoingMotivation => '계속하세요!';

  @override
  String get daysNormal => '일 정상';

  @override
  String get electrolyteBalance => '전해질 균형에 주의 필요';

  @override
  String get caffeineWarning => '안전 용량 초과 일수 (400mg)';

  @override
  String get sugarFrequentExcess => '빈번한 과잉 설탕이 수분 섭취에 영향을 줌';

  @override
  String get averagePerDayShort => '일당';

  @override
  String get highWarning => '높음';

  @override
  String get normalStatus => '정상';

  @override
  String improvementToEnd(int percent) {
    return '월말까지 $percent% 개선';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '운동한 날 $percent% (${hours}h)';
  }

  @override
  String coffeeAverage(String avg) {
    return '평균 $avg잔/일';
  }

  @override
  String sobrietyPercent(int percent) {
    return '알코올 없는 날 $percent%';
  }

  @override
  String get daySummary => '일일 요약';

  @override
  String get records => '기록';

  @override
  String waterGoalAchievement(int percent) {
    return '물 목표 달성: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return '운동: $count회 세션';
  }

  @override
  String get index => '지수';

  @override
  String get status => '상태';

  @override
  String get moderateRisk => '중간 위험';

  @override
  String get excess => '과잉';

  @override
  String get whoLimit => 'WHO 제한: 50g/일';

  @override
  String stability(int percent) {
    return '$percent%의 날에 안정성';
  }

  @override
  String goodHydration(int percent) {
    return '좋은 수분 섭취 $percent% 일';
  }

  @override
  String daysInNorm(int count) {
    return '$count일 정상';
  }

  @override
  String consistencyDays(int percent) {
    return '좋은 수분 섭취 $percent% 일';
  }

  @override
  String stabilityDays(int percent) {
    return '$percent%의 날에 안정성';
  }

  @override
  String monthEndImprovement(int percent) {
    return '월말 $percent% 개선';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '운동한 날 $percent% (${hours}h)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return '평균 $avgCups잔/일';
  }

  @override
  String soberDaysPercent(int percent) {
    return '알코올 없는 날 $percent%';
  }

  @override
  String get moderateRiskStatus => '상태: 중간 위험';

  @override
  String get high => '높음';

  @override
  String get whoLimitPerDay => 'WHO 제한: 50g/일';
}
