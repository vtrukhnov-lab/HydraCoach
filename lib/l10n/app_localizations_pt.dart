// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'HydroCoach';

  @override
  String get getPro => 'PRO';

  @override
  String get sunday => 'Domingo';

  @override
  String get monday => 'Segunda';

  @override
  String get tuesday => 'Terça';

  @override
  String get wednesday => 'Quarta';

  @override
  String get thursday => 'Quinta';

  @override
  String get friday => 'Sexta';

  @override
  String get saturday => 'Sábado';

  @override
  String get january => 'Janeiro';

  @override
  String get february => 'Fevereiro';

  @override
  String get march => 'Março';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Maio';

  @override
  String get june => 'Junho';

  @override
  String get july => 'Julho';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Setembro';

  @override
  String get october => 'Outubro';

  @override
  String get november => 'Novembro';

  @override
  String get december => 'Dezembro';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day $month';
  }

  @override
  String get loading => 'Carregando...';

  @override
  String get loadingWeather => 'Carregando clima...';

  @override
  String get heatIndex => 'Índice de Calor';

  @override
  String humidity(int value) {
    return 'Umidade';
  }

  @override
  String get water => 'Água';

  @override
  String get liquids => 'Líquidos';

  @override
  String get sodium => 'Sódio';

  @override
  String get potassium => 'Potássio';

  @override
  String get magnesium => 'Magnésio';

  @override
  String get electrolyte => 'Eletrólito';

  @override
  String get broth => 'Caldo';

  @override
  String get coffee => 'Café';

  @override
  String get alcohol => 'Álcool';

  @override
  String get drink => 'Bebida';

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
    return 'Calor +$percent%';
  }

  @override
  String alcoholAdjustment(int amount) {
    return 'Álcool +$amount ml';
  }

  @override
  String get smartAdviceTitle => 'Dica de agora';

  @override
  String get smartAdviceDefault => 'Mantenha água e eletrólitos balanceados.';

  @override
  String get adviceOverhydrationSevere => 'Excesso de água (>200% meta)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Pause 60-90 min. Adicione eletrólitos: 300-500 ml com 500-1000 mg sódio.';

  @override
  String get adviceOverhydration => 'Sobre-hidratação';

  @override
  String get adviceOverhydrationBody =>
      'Pause água por 30-60 min e adicione ~500 mg sódio (eletrólito/caldo).';

  @override
  String get adviceAlcoholRecovery => 'Álcool: recuperação';

  @override
  String get adviceAlcoholRecoveryBody =>
      'Sem álcool hoje. Beba 300-500 ml água em pequenas porções e adicione sódio.';

  @override
  String get adviceLowSodium => 'Pouco sódio';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Adicione ~$amount mg sódio. Beba moderadamente.';
  }

  @override
  String get adviceDehydration => 'Sub-hidratado';

  @override
  String adviceDehydrationBody(String type) {
    return 'Beba 300-500 ml $type.';
  }

  @override
  String get adviceHighRisk => 'Alto risco (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Beba água com eletrólitos urgente (300-500 ml) e reduza atividade.';

  @override
  String get adviceHeat => 'Calor e perdas';

  @override
  String get adviceHeatBody =>
      'Aumente água em +5-8% e adicione 300-500 mg sódio.';

  @override
  String get adviceAllGood => 'Tudo certo';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Continue assim. Meta: ~$amount ml até a meta.';
  }

  @override
  String get hydrationStatus => 'Status Hidratação';

  @override
  String get hydrationStatusNormal => 'Normal';

  @override
  String get hydrationStatusDiluted => 'Diluindo';

  @override
  String get hydrationStatusDehydrated => 'Sub-hidratado';

  @override
  String get hydrationStatusLowSalt => 'Pouco sal';

  @override
  String get hydrationRiskIndex => 'Índice Risco Hidratação';

  @override
  String get quickAdd => 'Adicionar Rápido';

  @override
  String get add => 'Adicionar';

  @override
  String get delete => 'Deletar';

  @override
  String get todaysDrinks => 'Bebidas de Hoje';

  @override
  String get allRecords => 'Todos registros →';

  @override
  String itemDeleted(String item) {
    return '$item deletado';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get dailyReportReady => 'Relatório diário pronto!';

  @override
  String get viewDayResults => 'Ver resultados do dia';

  @override
  String get dailyReportComingSoon => 'Relatório diário em breve';

  @override
  String get home => 'Início';

  @override
  String get history => 'Histórico';

  @override
  String get settings => 'Ajustes';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get reset => 'Resetar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSettings => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get profileSection => 'Perfil';

  @override
  String get weight => 'Peso';

  @override
  String get dietMode => 'Modo Dieta';

  @override
  String get activityLevel => 'Nível Atividade';

  @override
  String get changeWeight => 'Mudar Peso';

  @override
  String get dietModeNormal => 'Dieta Normal';

  @override
  String get dietModeKeto => 'Keto / Low-carb';

  @override
  String get dietModeFasting => 'Jejum Intermitente';

  @override
  String get activityLow => 'Atividade Baixa';

  @override
  String get activityMedium => 'Atividade Média';

  @override
  String get activityHigh => 'Atividade Alta';

  @override
  String get activityLowDesc => 'Trabalho escritório, pouco movimento';

  @override
  String get activityMediumDesc => '30-60 min exercício/dia';

  @override
  String get activityHighDesc => 'Treinos >1 hora';

  @override
  String get notificationsSection => 'Notificações';

  @override
  String get notificationLimit => 'Limite Notificações (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Usado: $used de $limit';
  }

  @override
  String get waterReminders => 'Lembretes Água';

  @override
  String get waterRemindersDesc => 'Lembretes regulares ao longo do dia';

  @override
  String get reminderFrequency => 'Frequência Lembretes';

  @override
  String timesPerDay(int count) {
    return '$count vezes/dia';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count vezes/dia (máx 4)';
  }

  @override
  String get unlimitedReminders => 'Ilimitado';

  @override
  String get startOfDay => 'Início do Dia';

  @override
  String get endOfDay => 'Fim do Dia';

  @override
  String get postCoffeeReminders => 'Lembretes Pós-Café';

  @override
  String get postCoffeeRemindersDesc => 'Lembrar de beber água após 20 min';

  @override
  String get heatWarnings => 'Avisos de Calor';

  @override
  String get heatWarningsDesc => 'Notificações em altas temperaturas';

  @override
  String get postAlcoholReminders => 'Lembretes Pós-Álcool';

  @override
  String get postAlcoholRemindersDesc => 'Plano recuperação por 6-12 horas';

  @override
  String get proFeaturesSection => 'Recursos PRO';

  @override
  String get unlockPro => 'Desbloquear PRO';

  @override
  String get unlockProDesc =>
      'Notificações ilimitadas e lembretes inteligentes';

  @override
  String get noNotificationLimit => 'Sem limite notificações';

  @override
  String get unitsSection => 'Unidades';

  @override
  String get metricSystem => 'Sistema Métrico';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Sistema Imperial';

  @override
  String get imperialUnits => 'fl oz, lb, °F';

  @override
  String get aboutSection => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get rateApp => 'Avaliar App';

  @override
  String get share => 'Compartilhar';

  @override
  String get privacyPolicy => 'Política Privacidade';

  @override
  String get termsOfUse => 'Termos de Uso';

  @override
  String get resetAllData => 'Resetar Todos Dados';

  @override
  String get resetDataTitle => 'Resetar todos dados?';

  @override
  String get resetDataMessage =>
      'Isso vai deletar histórico e restaurar ajustes padrão.';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get start => 'Iniciar';

  @override
  String get welcomeTitle => 'Bem-vindo ao\nHydroCoach';

  @override
  String get welcomeSubtitle =>
      'Rastreamento inteligente de água e eletrólitos\npara keto, jejum e vida ativa';

  @override
  String get weightPageTitle => 'Seu peso';

  @override
  String get weightPageSubtitle => 'Para calcular quantidade ideal de água';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Norma recomendada: $min-$max ml água/dia';
  }

  @override
  String get dietPageTitle => 'Modo Dieta';

  @override
  String get dietPageSubtitle => 'Isso afeta necessidades de eletrólitos';

  @override
  String get normalDiet => 'Dieta normal';

  @override
  String get normalDietDesc => 'Recomendações padrão';

  @override
  String get ketoDiet => 'Keto / Low-carb';

  @override
  String get ketoDietDesc => 'Mais necessidade de sal';

  @override
  String get fastingDiet => 'Jejum Intermitente';

  @override
  String get fastingDietDesc => 'Regime especial eletrólitos';

  @override
  String get fastingSchedule => 'Horário jejum:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Janela diária 8 horas';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Uma refeição por dia';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Jejum dia alternado';

  @override
  String get activityPageTitle => 'Nível Atividade';

  @override
  String get activityPageSubtitle => 'Afeta necessidades de água';

  @override
  String get lowActivity => 'Atividade baixa';

  @override
  String get lowActivityDesc => 'Trabalho escritório, pouco movimento';

  @override
  String get lowActivityWater => '+0 ml água';

  @override
  String get mediumActivity => 'Atividade média';

  @override
  String get mediumActivityDesc => '30-60 min exercício/dia';

  @override
  String get mediumActivityWater => '+350-700 ml água';

  @override
  String get highActivity => 'Atividade alta';

  @override
  String get highActivityDesc => 'Treinos >1h ou trabalho físico';

  @override
  String get highActivityWater => '+700-1200 ml água';

  @override
  String get activityAdjustmentNote => 'Vamos ajustar metas com seus treinos';

  @override
  String get day => 'Dia';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mês';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get noData => 'Sem dados';

  @override
  String get noRecordsToday => 'Sem registros hoje ainda';

  @override
  String get noRecordsThisDay => 'Sem registros neste dia';

  @override
  String get loadingData => 'Carregando dados...';

  @override
  String get deleteRecord => 'Deletar registro?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return 'Deletar $type $volume ml?';
  }

  @override
  String get recordDeleted => 'Registro deletado';

  @override
  String get waterConsumption => '💧 Consumo água';

  @override
  String get alcoholWeek => '🍺 Álcool nesta semana';

  @override
  String get electrolytes => '⚡ Eletrólitos';

  @override
  String get weeklyAverages => '📊 Médias semanais';

  @override
  String get monthStatistics => '📊 Estatísticas mês';

  @override
  String get alcoholStatistics => '🍺 Estatísticas álcool';

  @override
  String get alcoholStatisticsTitle => 'Estatísticas álcool';

  @override
  String get weeklyInsights => '💡 Insights semanais';

  @override
  String get waterPerDay => 'Água/dia';

  @override
  String get sodiumPerDay => 'Sódio/dia';

  @override
  String get potassiumPerDay => 'Potássio/dia';

  @override
  String get magnesiumPerDay => 'Magnésio/dia';

  @override
  String get goal => 'Meta';

  @override
  String get daysWithGoalAchieved => '✅ Dias com meta alcançada';

  @override
  String get recordsPerDay => '📝 Registros/dia';

  @override
  String get insufficientDataForAnalysis => 'Dados insuficientes pra análise';

  @override
  String get totalVolume => 'Volume total';

  @override
  String averagePerDay(int amount) {
    return 'Média $amount ml/dia';
  }

  @override
  String get activeDays => 'Dias ativos';

  @override
  String perfectDays(int count) {
    return '$count dias';
  }

  @override
  String currentStreak(int days) {
    return 'Sequência atual: $days dias';
  }

  @override
  String soberDaysRow(int days) {
    return 'Dias sóbrio em sequência: $days';
  }

  @override
  String get keepItUp => 'Continue assim!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Água: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Álcool: $amount SD';
  }

  @override
  String get totalSD => 'Total SD';

  @override
  String get forMonth => 'Do mês';

  @override
  String get daysWithAlcohol => 'Dias com álcool';

  @override
  String fromDays(int days) {
    return 'de $days';
  }

  @override
  String get soberDays => 'Dias sóbrio';

  @override
  String get excellent => 'excelente!';

  @override
  String get averageSD => 'SD médio';

  @override
  String get inDrinkingDays => 'em dias c/ bebida';

  @override
  String get bestDay => '🏆 Melhor dia';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% da meta';
  }

  @override
  String get weekends => '📅 Fins de semana';

  @override
  String get weekdays => '📅 Dias úteis';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'Você bebe $percent% menos nos fins de semana';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'Você bebe $percent% menos nos dias úteis';
  }

  @override
  String get positiveTrend => '📈 Tendência positiva';

  @override
  String get positiveTrendMessage => 'Sua hidratação melhora no fim da semana';

  @override
  String get decliningActivity => '📉 Atividade declinando';

  @override
  String get decliningActivityMessage =>
      'Consumo água diminui no fim da semana';

  @override
  String get lowSalt => '⚠️ Pouco sal';

  @override
  String lowSaltMessage(int days) {
    return 'Apenas $days dias com níveis normais de sódio';
  }

  @override
  String get frequentAlcohol => '🍺 Consumo frequente';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Álcool $days dias de 7 afeta hidratação';
  }

  @override
  String get excellentWeek => '✅ Excelente semana';

  @override
  String get continueMessage => 'Continue o bom trabalho!';

  @override
  String get all => 'Tudo';

  @override
  String get addAlcohol => 'Adicionar álcool';

  @override
  String get minimumHarm => 'Dano mínimo';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml água necessária';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg sódio pra adicionar';
  }

  @override
  String get goToBedEarly => 'Vá dormir cedo';

  @override
  String get todayConsumed => 'Consumido hoje:';

  @override
  String get alcoholToday => 'Álcool hoje';

  @override
  String get beer => 'Cerveja';

  @override
  String get wine => 'Vinho';

  @override
  String get spirits => 'Destilados';

  @override
  String get cocktail => 'Coquetel';

  @override
  String get selectDrinkType => 'Selecionar tipo bebida:';

  @override
  String get volume => 'Volume';

  @override
  String get enterVolume => 'Digitar volume em ml';

  @override
  String get strength => 'Força';

  @override
  String get standardDrinks => 'Doses padrão:';

  @override
  String get additionalWater => 'Água adic.';

  @override
  String get additionalSodium => 'Sódio adic.';

  @override
  String get hriRisk => 'Risco HRI';

  @override
  String get enterValidVolume => 'Digite volume válido';

  @override
  String get weeklyHistory => 'Histórico semanal';

  @override
  String get weeklyHistoryDesc =>
      'Analise tendências semanais, insights e recomendações';

  @override
  String get monthlyHistory => 'Histórico mensal';

  @override
  String get monthlyHistoryDesc =>
      'Padrões longo prazo, comparações e análises profundas';

  @override
  String get proFunction => 'Função PRO';

  @override
  String get unlockProHistory => 'Desbloquear PRO';

  @override
  String get unlimitedHistory => 'Histórico ilimitado';

  @override
  String get dataExportCSV => 'Exportar dados CSV';

  @override
  String get detailedAnalytics => 'Análises detalhadas';

  @override
  String get periodComparison => 'Comparação períodos';

  @override
  String get shareResult => 'Compartilhar resultado';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get welcomeToPro => 'Bem-vindo ao PRO!';

  @override
  String get allFeaturesUnlocked => 'Todos recursos desbloqueados';

  @override
  String get testMode => 'Modo Teste: Usando compra fictícia';

  @override
  String get proStatusNote => 'Status PRO persiste até reiniciar app';

  @override
  String get startUsingPro => 'Começar usar PRO';

  @override
  String get lifetimeAccess => 'Acesso vitalício';

  @override
  String get bestValueAnnual => 'Melhor valor — Anual';

  @override
  String get monthly => 'Mensal';

  @override
  String get oneTime => 'único';

  @override
  String get perYear => '/ano';

  @override
  String get perMonth => '/mês';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/mês';
  }

  @override
  String get startFreeTrial => 'Iniciar teste 7 dias grátis';

  @override
  String continueWithPrice(String price) {
    return 'Continuar — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Desbloquear por $price (único)';
  }

  @override
  String get enableFreeTrial => 'Habilitar teste 7 dias grátis';

  @override
  String get noChargeToday =>
      'Sem cobrança hoje. Após 7 dias, assinatura renova automaticamente a não ser que cancelada.';

  @override
  String get cancelAnytime => 'Pode cancelar qualquer hora em Ajustes.';

  @override
  String get everythingInPro => 'Tudo no PRO';

  @override
  String get smartReminders => 'Lembretes inteligentes';

  @override
  String get smartRemindersDesc => 'Calor, treinos, jejum — sem spam.';

  @override
  String get weeklyReports => 'Relatórios semanais';

  @override
  String get weeklyReportsDesc => 'Insights profundos + export CSV.';

  @override
  String get healthIntegrations => 'Integrações saúde';

  @override
  String get healthIntegrationsDesc => 'Apple Health & Google Fit.';

  @override
  String get alcoholProtocols => 'Protocolos álcool';

  @override
  String get alcoholProtocolsDesc =>
      'Preparação pré-bebida & roteiro recuperação.';

  @override
  String get fullSync => 'Sincronização completa';

  @override
  String get fullSyncDesc => 'Histórico ilimitado entre dispositivos.';

  @override
  String get personalCalibrations => 'Calibrações pessoais';

  @override
  String get personalCalibrationsDesc => 'Teste suor, escala cor urina.';

  @override
  String get showAllFeatures => 'Mostrar todos recursos';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get proSubscriptionRestored => 'Assinatura PRO restaurada!';

  @override
  String get noPurchasesToRestore => 'Nenhuma compra pra restaurar';

  @override
  String get drinkMoreWaterToday => 'Beba mais água hoje (+20%)';

  @override
  String get addElectrolytesToWater => 'Adicione eletrólitos a cada água';

  @override
  String get limitCoffeeOneCup => 'Limite café a uma xícara';

  @override
  String get increaseWater10 => 'Aumente água em 10%';

  @override
  String get dontForgetElectrolytes => 'Não esqueça eletrólitos';

  @override
  String get startDayWithWater => 'Comece dia com copo d\'água';

  @override
  String get dontForgetElectrolytesReminder => '⚡ Não esqueça eletrólitos';

  @override
  String get startDayWithWaterReminder =>
      'Comece dia com copo d\'água pra bem-estar';

  @override
  String get takeElectrolytesMorning => 'Tome eletrólitos pela manhã';

  @override
  String purchaseFailed(String error) {
    return 'Compra falhou: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restauração falhou: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — confiado por 12.000 usuários';

  @override
  String get bestValue => 'Melhor valor';

  @override
  String percentOff(int percent) {
    return '-$percent% Melhor valor';
  }

  @override
  String get weatherUnavailable => 'Clima indisponível';

  @override
  String get checkLocationPermissions =>
      'Verifique permissões localização e internet';

  @override
  String get recommendedNormLabel => 'Norma recomendada';

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
  String get currentLocation => 'Localização atual';

  @override
  String get weatherClear => 'limpo';

  @override
  String get weatherCloudy => 'nublado';

  @override
  String get weatherOvercast => 'encoberto';

  @override
  String get weatherRain => 'chuva';

  @override
  String get weatherSnow => 'neve';

  @override
  String get weatherStorm => 'tempestade';

  @override
  String get weatherFog => 'neblina';

  @override
  String get weatherDrizzle => 'garoa';

  @override
  String get weatherSunny => 'ensolarado';

  @override
  String get heatWarningExtreme => '☀️ Calor extremo! Hidratação máxima';

  @override
  String get heatWarningVeryHot => '🌡️ Muito quente! Risco desidratação';

  @override
  String get heatWarningHot => '🔥 Quente! Beba mais água';

  @override
  String get heatWarningElevated => '⚠️ Temperatura elevada';

  @override
  String get heatWarningComfortable => 'Temperatura confortável';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% água';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg sódio';
  }

  @override
  String get heatWarningCold => '❄️ Frio! Aqueça-se e beba líquidos quentes';

  @override
  String get notificationChannelName => 'Lembretes HydroCoach';

  @override
  String get notificationChannelDescription => 'Lembretes água e eletrólitos';

  @override
  String get urgentNotificationChannelName => 'Lembretes Urgentes';

  @override
  String get urgentNotificationChannelDescription =>
      'Notificações hidratação importantes';

  @override
  String get goodMorning => '☀️ Bom dia!';

  @override
  String get timeToHydrate => '💧 Hora de hidratar';

  @override
  String get eveningHydration => '💧 Hidratação noturna';

  @override
  String get dailyReportTitle => ' Relatório diário pronto';

  @override
  String get dailyReportBody => 'Veja como foi seu dia de hidratação';

  @override
  String get maintainWaterBalance => 'Mantenha balanço água ao longo do dia';

  @override
  String get electrolytesTime => 'Hora eletrólitos: adicione pitada sal à água';

  @override
  String catchUpHydration(int percent) {
    return 'Você bebeu só $percent% da norma diária. Hora recuperar!';
  }

  @override
  String get excellentProgress => 'Progresso excelente! Mais um pouco pra meta';

  @override
  String get postCoffeeTitle => ' Após café';

  @override
  String get postCoffeeBody => 'Beba 250-300 ml água pra restaurar balanço';

  @override
  String get postWorkoutTitle => ' Após treino';

  @override
  String get postWorkoutBody =>
      'Restaure eletrólitos: 500 ml água + pitada sal';

  @override
  String get heatWarningPro => '🌡️ Aviso calor PRO';

  @override
  String get extremeHeatWarning =>
      'Calor extremo! Aumente consumo água em 15% e adicione 1g sal';

  @override
  String get hotWeatherWarning =>
      'Quente! Beba 10% mais água e não esqueça eletrólitos';

  @override
  String get warmWeatherWarning => 'Clima quente. Monitore sua hidratação';

  @override
  String get alcoholRecoveryTitle => '🍺 Hora recuperação';

  @override
  String get alcoholRecoveryBody =>
      'Beba 300 ml água com pitada sal pro balanço';

  @override
  String get continueHydration => '💧 Continue hidratação';

  @override
  String get alcoholRecoveryBody2 =>
      'Mais 500 ml água vão ajudar recuperar mais rápido';

  @override
  String get morningRecoveryTitle => '☀️ Recuperação matinal';

  @override
  String get morningRecoveryBody => 'Comece dia com 500 ml água e eletrólitos';

  @override
  String get testNotificationTitle => '🧪 Notificação teste';

  @override
  String get testNotificationBody =>
      'Se vê isso - notificações instantâneas funcionam!';

  @override
  String get scheduledTestTitle => '⏰ Teste agendado (1 min)';

  @override
  String get scheduledTestBody =>
      'Esta notificação foi agendada 1 min atrás. Agendamento funciona!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService inicializado';

  @override
  String get localNotificationsInitialized =>
      '✅ Notificações locais inicializadas';

  @override
  String get androidChannelsCreated => '📢 Canais notificação Android criados';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Permissão notificações: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Permissão alarmes exatos: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 Permissões FCM: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 Token FCM recebido';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ Token FCM salvo no Firestore pra usuário $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ Inscrição tópico completa';

  @override
  String foregroundMessage(String title) {
    return '📨 Mensagem foreground: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Notificação aberta: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Limite diário notificações atingido (4/dia FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Erro agendamento notificação: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Mostrando notificação imediatamente como fallback';

  @override
  String instantNotificationShown(String title) {
    return '📬 Notificação instantânea mostrada: $title';
  }

  @override
  String get smartRemindersScheduled =>
      '🧠 Agendando lembretes inteligentes...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ Agendados $count lembretes';
  }

  @override
  String get proPostCoffeeScheduled => '☕ PRO: Lembrete pós-café agendado';

  @override
  String get postWorkoutScheduled => '💪 Lembrete pós-treino agendado';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Aviso calor enviado';

  @override
  String get proAlcoholRecoveryPlan =>
      '🍺 PRO: Plano recuperação álcool agendado';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Relatório noturno agendado pra $day.$month às 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Notificação $id cancelada';
  }

  @override
  String get allNotificationsCancelled => '🗑️ Todas notificações canceladas';

  @override
  String get reminderSettingsSaved => '✅ Ajustes lembretes salvos';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Notificação teste agendada pra $time';
  }

  @override
  String get tomorrowRecommendations => 'Recomendações pra amanhã';

  @override
  String get recommendationExcellent =>
      'Trabalho excelente! Continue assim. Tente começar dia com copo d\'água e manter consumo uniforme.';

  @override
  String get recommendationDiluted =>
      'Você bebe muita água mas poucos eletrólitos. Amanhã adicione mais sal ou beba bebida eletrolítica. Tente começar dia com caldo salgado.';

  @override
  String get recommendationDehydrated =>
      'Pouca água hoje. Amanhã ajuste lembretes a cada 2 horas. Mantenha garrafa d\'água à vista.';

  @override
  String get recommendationLowSalt =>
      'Níveis baixos sódio podem causar fadiga. Adicione pitada sal à água ou beba caldo. Especialmente importante em keto ou jejum.';

  @override
  String get recommendationGeneral =>
      'Busque balanço entre água e eletrólitos. Beba uniformemente ao longo do dia e não esqueça sal no calor.';

  @override
  String get category_water => 'Água';

  @override
  String get category_hot_drinks => 'Bebidas Quentes';

  @override
  String get category_juice => 'Sucos';

  @override
  String get category_sports => 'Esportivas';

  @override
  String get category_dairy => 'Lácteos';

  @override
  String get category_alcohol => 'Álcool';

  @override
  String get category_supplements => 'Suplementos';

  @override
  String get category_other => 'Outros';

  @override
  String get drink_water => 'Água';

  @override
  String get drink_sparkling_water => 'Água com Gás';

  @override
  String get drink_mineral_water => 'Água Mineral';

  @override
  String get drink_coconut_water => 'Água de Coco';

  @override
  String get drink_coffee => 'Café';

  @override
  String get drink_espresso => 'Espresso';

  @override
  String get drink_americano => 'Americano';

  @override
  String get drink_cappuccino => 'Cappuccino';

  @override
  String get drink_latte => 'Latte';

  @override
  String get drink_black_tea => 'Chá Preto';

  @override
  String get drink_green_tea => 'Chá Verde';

  @override
  String get drink_herbal_tea => 'Chá Ervas';

  @override
  String get drink_matcha => 'Matcha';

  @override
  String get drink_hot_chocolate => 'Chocolate Quente';

  @override
  String get drink_orange_juice => 'Suco Laranja';

  @override
  String get drink_apple_juice => 'Suco Maçã';

  @override
  String get drink_grapefruit_juice => 'Suco Toranja';

  @override
  String get drink_tomato_juice => 'Suco Tomate';

  @override
  String get drink_vegetable_juice => 'Suco Vegetal';

  @override
  String get drink_smoothie => 'Smoothie';

  @override
  String get drink_lemonade => 'Limonada';

  @override
  String get drink_isotonic => 'Bebida Isotônica';

  @override
  String get drink_electrolyte => 'Bebida Eletrolítica';

  @override
  String get drink_protein_shake => 'Shake Proteína';

  @override
  String get drink_bcaa => 'Bebida BCAA';

  @override
  String get drink_energy => 'Energético';

  @override
  String get drink_milk => 'Leite';

  @override
  String get drink_kefir => 'Kefir';

  @override
  String get drink_yogurt => 'Bebida Iogurte';

  @override
  String get drink_almond_milk => 'Leite Amêndoa';

  @override
  String get drink_soy_milk => 'Leite Soja';

  @override
  String get drink_oat_milk => 'Leite Aveia';

  @override
  String get drink_beer_light => 'Cerveja Leve';

  @override
  String get drink_beer_regular => 'Cerveja Normal';

  @override
  String get drink_beer_strong => 'Cerveja Forte';

  @override
  String get drink_wine_red => 'Vinho Tinto';

  @override
  String get drink_wine_white => 'Vinho Branco';

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
  String get drink_bone_broth => 'Caldo Ossos';

  @override
  String get drink_vegetable_broth => 'Caldo Vegetal';

  @override
  String get drink_soda => 'Refrigerante';

  @override
  String get drink_diet_soda => 'Refri Diet';

  @override
  String get addedToFavorites => 'Adicionado aos favoritos';

  @override
  String get favoriteLimitReached =>
      'Limite favoritos atingido (3 FREE, 20 PRO)';

  @override
  String get addFavorite => 'Adicionar favorito';

  @override
  String get hotAndSupplements => 'Quentes & Suplementos';

  @override
  String get quickVolumes => 'Volumes rápidos:';

  @override
  String get type => 'Tipo:';

  @override
  String get regular => 'Normal';

  @override
  String get coconut => 'Coco';

  @override
  String get sparkling => 'Com gás';

  @override
  String get mineral => 'Mineral';

  @override
  String get hotDrinks => 'Bebidas Quentes';

  @override
  String get supplements => 'Suplementos';

  @override
  String get tea => 'Chá';

  @override
  String get salt => 'Sal (1/4 colher chá)';

  @override
  String get electrolyteMix => 'Mix Eletrólitos';

  @override
  String get boneBroth => 'Caldo Ossos';

  @override
  String get favoriteAssignmentComingSoon => 'Atribuição favorito em breve';

  @override
  String get longPressToEditComingSoon =>
      'Pressione longo pra editar - em breve';

  @override
  String get proSubscriptionRequired => 'Assinatura PRO necessária';

  @override
  String get saveToFavorites => 'Salvar nos favoritos';

  @override
  String get savedToFavorites => 'Salvo nos favoritos';

  @override
  String get selectFavoriteSlot => 'Selecionar slot favorito';

  @override
  String get slot => 'Slot';

  @override
  String get emptySlot => 'Slot vazio';

  @override
  String get upgradeToUnlock => 'Atualize pro PRO pra desbloquear';

  @override
  String get changeFavorite => 'Mudar favorito';

  @override
  String get removeFavorite => 'Remover favorito';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'Água Mineral';

  @override
  String get coconutWater => 'Água de Coco';

  @override
  String get lemonWater => 'Água com Limão';

  @override
  String get greenTea => 'Chá Verde';

  @override
  String get amount => 'Quantidade';

  @override
  String get createFavoriteHint =>
      'Pra adicionar favorito, vá a qualquer tela bebida abaixo e toque botão \'Salvar nos favoritos\' após configurar sua bebida.';

  @override
  String get sparklingWater => 'Água com Gás';

  @override
  String get cola => 'Cola';

  @override
  String get juice => 'Suco';

  @override
  String get energyDrink => 'Energético';

  @override
  String get sportsDrink => 'Bebida Esportiva';

  @override
  String get selectElectrolyteType => 'Selecionar tipo eletrólito:';

  @override
  String get saltQuarterTsp => 'Sal (1/4 colher chá)';

  @override
  String get pinkSalt => 'Sal Rosa do Himalaia';

  @override
  String get seaSalt => 'Sal Marinho';

  @override
  String get potassiumCitrate => 'Citrato Potássio';

  @override
  String get magnesiumGlycinate => 'Glicinato Magnésio';

  @override
  String get coconutWaterElectrolyte => 'Água de Coco';

  @override
  String get sportsDrinkElectrolyte => 'Bebida Esportiva';

  @override
  String get electrolyteContent => 'Conteúdo eletrólitos:';

  @override
  String sodiumContent(int amount) {
    return 'Sódio: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return 'Potássio: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Magnésio: $amount mg';
  }

  @override
  String get servings => 'Porções';

  @override
  String get enterServings => 'Digite porções';

  @override
  String get servingsUnit => 'porções';

  @override
  String get noElectrolytes => 'Sem eletrólitos';

  @override
  String get enterValidAmount => 'Digite quantidade válida';

  @override
  String get lmntMix => 'Mix LMNT';

  @override
  String get pickleJuice => 'Suco Picles';

  @override
  String get tomatoSalt => 'Tomate + Sal';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'Água Alcalina';

  @override
  String get celticSalt => 'Água Sal Celta';

  @override
  String get soleWater => 'Água Sole';

  @override
  String get mineralDrops => 'Gotas Minerais';

  @override
  String get bakingSoda => 'Água Bicarbonato';

  @override
  String get creamTartar => 'Cremor Tártaro';

  @override
  String get selectSupplementType => 'Selecionar tipo suplemento:';

  @override
  String get multivitamin => 'Multivitamínico';

  @override
  String get magnesiumCitrate => 'Citrato Magnésio';

  @override
  String get magnesiumThreonate => 'L-Treonato Magnésio';

  @override
  String get calciumCitrate => 'Citrato Cálcio';

  @override
  String get zincGlycinate => 'Glicinato Zinco';

  @override
  String get vitaminD3 => 'Vitamina D3';

  @override
  String get vitaminC => 'Vitamina C';

  @override
  String get bComplex => 'Complexo B';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => 'Bisglicinato Ferro';

  @override
  String get dosage => 'Dosagem';

  @override
  String get enterDosage => 'Digite dosagem';

  @override
  String get noElectrolyteContent => 'Sem conteúdo eletrólitos';

  @override
  String get blackTea => 'Chá Preto';

  @override
  String get herbalTea => 'Chá Ervas';

  @override
  String get espresso => 'Espresso';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get latte => 'Latte';

  @override
  String get matcha => 'Matcha';

  @override
  String get hotChocolate => 'Chocolate Quente';

  @override
  String get caffeine => 'Cafeína';

  @override
  String get sports => 'Esportes';

  @override
  String get walking => 'Caminhada';

  @override
  String get running => 'Corrida';

  @override
  String get gym => 'Academia';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get swimming => 'Natação';

  @override
  String get yoga => 'Yoga';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'Boxe';

  @override
  String get dancing => 'Dança';

  @override
  String get tennis => 'Tênis';

  @override
  String get teamSports => 'Esportes Equipe';

  @override
  String get selectActivityType => 'Selecionar tipo atividade:';

  @override
  String get duration => 'Duração';

  @override
  String get minutes => 'minutos';

  @override
  String get enterDuration => 'Digite duração';

  @override
  String get lowIntensity => 'Intensidade baixa';

  @override
  String get mediumIntensity => 'Intensidade média';

  @override
  String get highIntensity => 'Intensidade alta';

  @override
  String get recommendedIntake => 'Ingestão recomendada:';

  @override
  String get basedOnWeight => 'Baseado no peso';

  @override
  String get logActivity => 'Registrar Atividade';

  @override
  String get activityLogged => 'Atividade registrada';

  @override
  String get enterValidDuration => 'Digite duração válida';

  @override
  String get sauna => 'Sauna';

  @override
  String get veryHighIntensity => 'Intensidade muito alta';

  @override
  String get hriStatusExcellent => 'Excelente';

  @override
  String get hriStatusGood => 'Bom';

  @override
  String get hriStatusModerate => 'Risco Moderado';

  @override
  String get hriStatusHighRisk => 'Alto Risco';

  @override
  String get hriStatusCritical => 'Crítico';

  @override
  String get hriComponentWater => 'Balanço água';

  @override
  String get hriComponentSodium => 'Nível sódio';

  @override
  String get hriComponentPotassium => 'Nível potássio';

  @override
  String get hriComponentMagnesium => 'Nível magnésio';

  @override
  String get hriComponentHeat => 'Estresse calor';

  @override
  String get hriComponentWorkout => 'Atividade física';

  @override
  String get hriComponentCaffeine => 'Impacto cafeína';

  @override
  String get hriComponentAlcohol => 'Impacto álcool';

  @override
  String get hriComponentTime => 'Tempo desde ingestão';

  @override
  String get hriComponentMorning => 'Fatores matinais';

  @override
  String get hriBreakdownTitle => 'Fatores risco detalhados';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max pts';
  }

  @override
  String get fastingModeActive => 'Modo jejum ativo';

  @override
  String get fastingSuppressionNote => 'Fator tempo suprimido durante jejum';

  @override
  String get morningCheckInTitle => 'Check-in Matinal';

  @override
  String get howAreYouFeeling => 'Como se sente?';

  @override
  String get feelingScale1 => 'Péssimo';

  @override
  String get feelingScale2 => 'Abaixo média';

  @override
  String get feelingScale3 => 'Normal';

  @override
  String get feelingScale4 => 'Bom';

  @override
  String get feelingScale5 => 'Excelente';

  @override
  String get weightChange => 'Mudança peso desde ontem';

  @override
  String get urineColorScale => 'Cor urina (escala 1-8)';

  @override
  String get urineColor1 => '1 - Muito pálido';

  @override
  String get urineColor2 => '2 - Pálido';

  @override
  String get urineColor3 => '3 - Amarelo claro';

  @override
  String get urineColor4 => '4 - Amarelo';

  @override
  String get urineColor5 => '5 - Amarelo escuro';

  @override
  String get urineColor6 => '6 - Âmbar';

  @override
  String get urineColor7 => '7 - Âmbar escuro';

  @override
  String get urineColor8 => '8 - Marrom';

  @override
  String get alcoholWithDecay => 'Impacto álcool (decaindo)';

  @override
  String standardDrinksToday(Object count) {
    return 'Doses padrão hoje: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Cafeína ativa: $amount mg';
  }

  @override
  String get hriDebugInfo => 'Info Debug HRI';

  @override
  String hriNormalized(Object value) {
    return 'HRI (normalizado): $value/100';
  }

  @override
  String get fastingWindowActive => 'Janela jejum ativa';

  @override
  String get eatingWindowActive => 'Janela alimentação ativa';

  @override
  String nextFastingWindow(Object time) {
    return 'Próximo jejum: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Próxima alimentação: $time';
  }

  @override
  String get todaysWorkouts => 'Treinos de Hoje';

  @override
  String get hoursAgo => 'h atrás';

  @override
  String get onboardingWelcomeTitle =>
      'HydroCoach — hidratação inteligente todo dia';

  @override
  String get onboardingWelcomeSubtitle =>
      'Beba mais inteligente, não mais\nO app considera clima, eletrólitos e seus hábitos\nAjuda manter mente clara e energia estável';

  @override
  String get onboardingBullet1 =>
      'Norma pessoal água e sal baseada em clima e você';

  @override
  String get onboardingBullet2 =>
      'Dicas \"O que fazer agora\" em vez de gráficos crus';

  @override
  String get onboardingBullet3 => 'Álcool em doses padrão com limites seguros';

  @override
  String get onboardingBullet4 => 'Lembretes inteligentes sem spam';

  @override
  String get onboardingStartButton => 'Iniciar';

  @override
  String get onboardingHaveAccount => 'Já tenho conta';

  @override
  String get onboardingPracticeFasting => 'Pratico jejum intermitente';

  @override
  String get onboardingPracticeFastingDesc =>
      'Regime especial eletrólitos pra janelas jejum';

  @override
  String get onboardingProfileReady => 'Perfil pronto!';

  @override
  String get onboardingWaterNorm => 'Norma água';

  @override
  String get onboardingIonWillHelp => 'ION vai ajudar manter balanço todo dia';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingLocationTitle => 'Clima importa pra hidratação';

  @override
  String get onboardingLocationSubtitle =>
      'Vamos considerar clima e umidade. Isso é mais preciso que só fórmula por peso';

  @override
  String get onboardingWeatherExample => 'Quente hoje! +15% água';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg sódio pro calor';

  @override
  String get onboardingEnablePermission => 'Habilitar';

  @override
  String get onboardingEnableLater => 'Habilitar depois';

  @override
  String get onboardingNotificationTitle => 'Lembretes inteligentes';

  @override
  String get onboardingNotificationSubtitle =>
      'Dicas curtas no momento certo. Pode mudar frequência em um toque';

  @override
  String get onboardingNotifExample1 => 'Hora de hidratar';

  @override
  String get onboardingNotifExample2 => 'Não esqueça eletrólitos';

  @override
  String get onboardingNotifExample3 => 'Quente! Beba mais água';

  @override
  String get sportRecoveryProtocols => 'Protocolos recuperação esportiva';

  @override
  String get allDrinksAndSupplements => 'Todas bebidas & suplementos';

  @override
  String get notificationChannelDefault => 'Lembretes Hidratação';

  @override
  String get notificationChannelDefaultDesc => 'Lembretes água e eletrólitos';

  @override
  String get notificationChannelUrgent => 'Notificações Importantes';

  @override
  String get notificationChannelUrgentDesc =>
      'Avisos calor e alertas críticos hidratação';

  @override
  String get notificationChannelReport => 'Relatórios';

  @override
  String get notificationChannelReportDesc => 'Relatórios diários e semanais';

  @override
  String get notificationWaterTitle => '💧 Hora de hidratar';

  @override
  String get notificationWaterBody => 'Não esqueça de beber água';

  @override
  String get notificationPostCoffeeTitle => '☕ Após café';

  @override
  String get notificationPostCoffeeBody =>
      'Beba 250-300 ml água pra restaurar balanço';

  @override
  String get notificationDailyReportTitle => '📊 Relatório diário pronto';

  @override
  String get notificationDailyReportBody =>
      'Veja como foi seu dia de hidratação';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Hora recuperação';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return 'Beba $ml ml água com pitada sal';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Aviso calor';

  @override
  String get notificationHeatWarningExtremeBody =>
      'Calor extremo! +15% água e +1g sal';

  @override
  String get notificationHeatWarningHotBody =>
      'Quente! +10% água e eletrólitos';

  @override
  String get notificationHeatWarningWarmBody =>
      'Quente. Monitore sua hidratação';

  @override
  String get notificationWorkoutTitle => '💪 Treino';

  @override
  String get notificationWorkoutBody => 'Não esqueça água e eletrólitos';

  @override
  String get notificationPostWorkoutTitle => '💪 Após treino';

  @override
  String get notificationPostWorkoutBody =>
      '500 ml água + eletrólitos pra recuperação';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Hora eletrólitos';

  @override
  String get notificationFastingElectrolyteBody =>
      'Adicione pitada sal à água ou beba caldo';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Recuperação ${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return 'Beba $ml ml água';
  }

  @override
  String get notificationAlcoholRecoveryMidBody =>
      'Adicione eletrólitos: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Amanhã manhã - check-in controle';

  @override
  String get notificationMorningCheckInTitle => '☀️ Check-in matinal';

  @override
  String get notificationMorningCheckInBody =>
      'Como se sente? Avalie sua condição e receba plano pro dia';

  @override
  String get notificationMorningWaterBody => 'Comece dia com copo d\'água';

  @override
  String notificationLowProgressBody(int percent) {
    return 'Você bebeu só $percent% da norma. Hora recuperar!';
  }

  @override
  String get notificationGoodProgressBody => 'Progresso excelente! Continue';

  @override
  String get notificationMaintainBalanceBody => 'Mantenha balanço água';

  @override
  String get notificationTestTitle => '🧪 Notificação teste';

  @override
  String get notificationTestBody => 'Se vê isso - notificações funcionam!';

  @override
  String get notificationTestScheduledTitle => '⏰ Teste agendado';

  @override
  String get notificationTestScheduledBody =>
      'Esta notificação foi agendada 1 min atrás';

  @override
  String get onboardingUnitsTitle => 'Escolha suas unidades';

  @override
  String get onboardingUnitsSubtitle => 'Não pode mudar depois';

  @override
  String get onboardingUnitsWarning =>
      'Esta escolha é permanente e não pode ser mudada depois';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'gal';

  @override
  String get lb => 'lb';

  @override
  String get target => 'Meta';

  @override
  String get wind => 'Vento';

  @override
  String get pressure => 'Pressão';

  @override
  String get highHeatIndexWarning => 'Índice calor alto! Aumente ingestão água';

  @override
  String get weatherCondition => 'Condição';

  @override
  String get feelsLike => 'Sensação';

  @override
  String get humidityLabel => 'Umidade';

  @override
  String get waterNormal => 'Normal';

  @override
  String get sodiumNormal => 'Padrão';

  @override
  String get addedSuccessfully => 'Adicionado com sucesso';

  @override
  String get sugarIntake => 'Ingestão Açúcar';

  @override
  String get sugarToday => 'Consumo açúcar hoje';

  @override
  String get totalSugar => 'Açúcar Total';

  @override
  String get dailyLimit => 'Limite Diário';

  @override
  String get addedSugar => 'Açúcar Adicionado';

  @override
  String get naturalSugar => 'Açúcar Natural';

  @override
  String get hiddenSugar => 'Açúcar Oculto';

  @override
  String get sugarFromDrinks => 'Bebidas';

  @override
  String get sugarFromFood => 'Comida';

  @override
  String get sugarFromSnacks => 'Lanches';

  @override
  String get sugarNormal => 'Normal';

  @override
  String get sugarModerate => 'Moderado';

  @override
  String get sugarHigh => 'Alto';

  @override
  String get sugarCritical => 'Crítico';

  @override
  String get sugarRecommendationNormal =>
      'Ótimo trabalho! Ingestão açúcar dentro limites saudáveis';

  @override
  String get sugarRecommendationModerate =>
      'Considere reduzir bebidas doces e lanches';

  @override
  String get sugarRecommendationHigh =>
      'Ingestão açúcar alta! Limite bebidas doces e sobremesas';

  @override
  String get sugarRecommendationCritical =>
      'Açúcar muito alto! Evite bebidas e doces açucarados hoje';

  @override
  String get noSugarIntake => 'Nenhum açúcar rastreado hoje';

  @override
  String get hriImpact => 'Impacto HRI';

  @override
  String get hri_component_sugar => 'Açúcar';

  @override
  String get hri_sugar_description =>
      'Alta ingestão açúcar afeta hidratação e saúde geral';

  @override
  String get tip_reduce_sweet_drinks =>
      'Substitua bebidas doces por água ou chá sem açúcar';

  @override
  String get tip_avoid_added_sugar =>
      'Verifique rótulos e evite produtos com açúcares adicionados';

  @override
  String get tip_check_labels =>
      'Atenção aos açúcares ocultos em molhos e processados';

  @override
  String get tip_replace_soda => 'Substitua refri por água com gás e limão';

  @override
  String get sugarSources => 'Fontes Açúcar';

  @override
  String get drinks => 'Bebidas';

  @override
  String get food => 'Comida';

  @override
  String get snacks => 'Lanches';

  @override
  String get recommendedLimit => 'Recomendado';

  @override
  String get points => 'pontos';

  @override
  String get drinkLightBeer => 'Cerveja Leve';

  @override
  String get drinkLager => 'Lager';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'Stout';

  @override
  String get drinkWheatBeer => 'Cerveja Trigo';

  @override
  String get drinkCraftBeer => 'Cerveja Artesanal';

  @override
  String get drinkNonAlcoholic => 'Sem Álcool';

  @override
  String get drinkRadler => 'Radler';

  @override
  String get drinkPilsner => 'Pilsner';

  @override
  String get drinkRedWine => 'Vinho Tinto';

  @override
  String get drinkWhiteWine => 'Vinho Branco';

  @override
  String get drinkProsecco => 'Prosecco';

  @override
  String get drinkPort => 'Porto';

  @override
  String get drinkRose => 'Rosé';

  @override
  String get drinkDessertWine => 'Vinho Sobremesa';

  @override
  String get drinkSangria => 'Sangria';

  @override
  String get drinkSherry => 'Xerez';

  @override
  String get drinkVodkaShot => 'Shot Vodka';

  @override
  String get drinkCognac => 'Conhaque';

  @override
  String get drinkLiqueur => 'Licor';

  @override
  String get drinkAbsinthe => 'Absinto';

  @override
  String get drinkBrandy => 'Brandy';

  @override
  String get drinkLongIsland => 'Long Island';

  @override
  String get drinkGinTonic => 'Gin & Tônica';

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
    return '$type Popular';
  }

  @override
  String get standardDrinksUnit => 'SD';

  @override
  String get gramsSugar => 'g açúcar';

  @override
  String get moderateConsumption => 'Consumo moderado';

  @override
  String get aboveRecommendations => 'Acima recomendações';

  @override
  String get highConsumption => 'Consumo alto';

  @override
  String get veryHighConsider => 'Muito alto - considere parar';

  @override
  String get noAlcoholToday => 'Sem álcool hoje';

  @override
  String get drinkWaterNow => 'Beba 300-500 ml água agora';

  @override
  String get addPinchSalt => 'Adicione pitada sal';

  @override
  String get avoidLateCoffee => 'Evite café tarde';

  @override
  String abvPercent(Object percent) {
    return '$percent% ABV';
  }

  @override
  String get todaysElectrolytes => 'Eletrólitos de Hoje';

  @override
  String get greatBalance => 'Ótimo balanço!';

  @override
  String get gettingThere => 'Chegando lá';

  @override
  String get needMoreElectrolytes => 'Precisa mais eletrólitos';

  @override
  String get lowElectrolyteLevels => 'Níveis eletrólitos baixos';

  @override
  String get electrolyteTips => 'Dicas Eletrólitos';

  @override
  String get takeWithWater => 'Tome com bastante água';

  @override
  String get bestBetweenMeals => 'Melhor absorção entre refeições';

  @override
  String get startSmallAmounts => 'Comece com pequenas quantidades';

  @override
  String get extraDuringExercise => 'Extra necessário durante exercício';

  @override
  String get electrolytesBasic => 'Básico';

  @override
  String get electrolytesMixes => 'Mixes';

  @override
  String get electrolytesPills => 'Pílulas';

  @override
  String get popularSalts => 'Sais & Caldos Populares';

  @override
  String get popularMixes => 'Mixes Eletrólitos Populares';

  @override
  String get popularSupplements => 'Suplementos Populares';

  @override
  String get electrolyteSaltWater => 'Água com Sal';

  @override
  String get electrolytePinkSalt => 'Sal Rosa';

  @override
  String get electrolyteSeaSalt => 'Sal Marinho';

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
  String get electrolytePotassiumChloride => 'Cloreto Potássio';

  @override
  String get electrolyteMagThreonate => 'Mag Treonato';

  @override
  String get electrolyteTraceMinerals => 'Minerais Traço';

  @override
  String get electrolyteZMAComplex => 'Complexo ZMA';

  @override
  String get electrolyteMultiMineral => 'Multi-Mineral';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => 'Hidratação';

  @override
  String get todayHydration => 'Hidratação Hoje';

  @override
  String get currentIntake => 'Consumido';

  @override
  String get dailyGoal => 'Meta';

  @override
  String get toGo => 'Faltam';

  @override
  String get goalReached => 'Meta alcançada!';

  @override
  String get almostThere => 'Quase lá!';

  @override
  String get halfwayThere => 'Metade';

  @override
  String get keepGoing => 'Continue!';

  @override
  String get startDrinking => 'Comece beber';

  @override
  String get plainWater => 'Normal';

  @override
  String get enhancedWater => 'Melhorada';

  @override
  String get beverages => 'Bebidas';

  @override
  String get sodas => 'Refris';

  @override
  String get popularPlainWater => 'Tipos Água Populares';

  @override
  String get popularEnhancedWater => 'Melhorada & Infusão';

  @override
  String get popularBeverages => 'Bebidas Populares';

  @override
  String get popularSodas => 'Refris & Energéticos Populares';

  @override
  String get hydrationTips => 'Dicas Hidratação';

  @override
  String get drinkRegularly => 'Beba pequenas quantidades regularmente';

  @override
  String get roomTemperature => 'Água temp ambiente absorve melhor';

  @override
  String get addLemon => 'Adicione limão pra melhor sabor';

  @override
  String get limitSugary => 'Limite bebidas doces - desidratam';

  @override
  String get warmWater => 'Água Morna';

  @override
  String get iceWater => 'Água Gelada';

  @override
  String get filteredWater => 'Água Filtrada';

  @override
  String get distilledWater => 'Água Destilada';

  @override
  String get springWater => 'Água Nascente';

  @override
  String get hydrogenWater => 'Água Hidrogenada';

  @override
  String get oxygenatedWater => 'Água Oxigenada';

  @override
  String get cucumberWater => 'Água Pepino';

  @override
  String get limeWater => 'Água Lima';

  @override
  String get berryWater => 'Água Frutas Vermelhas';

  @override
  String get mintWater => 'Água Hortelã';

  @override
  String get gingerWater => 'Água Gengibre';

  @override
  String get caffeineStatusNone => 'Sem cafeína hoje';

  @override
  String caffeineStatusModerate(Object amount) {
    return 'Moderado: ${amount}mg';
  }

  @override
  String caffeineStatusHigh(Object amount) {
    return 'Alto: ${amount}mg';
  }

  @override
  String caffeineStatusVeryHigh(Object amount) {
    return 'Muito alto: ${amount}mg!';
  }

  @override
  String get caffeineDailyLimit => 'Limite diário: 400mg';

  @override
  String get caffeineWarningTitle => 'Aviso Cafeína';

  @override
  String get caffeineWarning400 => 'Você excedeu 400mg cafeína hoje';

  @override
  String get caffeineTipWater => 'Beba água extra pra compensar';

  @override
  String get caffeineTipAvoid => 'Evite mais cafeína hoje';

  @override
  String get caffeineTipSleep => 'Pode afetar qualidade sono';

  @override
  String get total => 'total';

  @override
  String get cupsToday => 'Xícaras hoje';

  @override
  String get metabolizeTime => 'Tempo metabolizar';

  @override
  String get aboutCaffeine => 'Sobre Cafeína';

  @override
  String get caffeineInfo1 => 'Café contém cafeína natural que aumenta alerta';

  @override
  String get caffeineInfo2 =>
      'Limite seguro diário é 400mg pra maioria adultos';

  @override
  String get caffeineInfo3 => 'Meia-vida cafeína é 5-6 horas';

  @override
  String get caffeineInfo4 =>
      'Beba água extra pra compensar efeito diurético da cafeína';

  @override
  String get caffeineWarningPregnant =>
      'Grávidas devem limitar cafeína a 200mg/dia';

  @override
  String get gotIt => 'Entendi';

  @override
  String get consumed => 'Consumed';

  @override
  String get remaining => 'remaining';

  @override
  String get todaysCaffeine => 'Cafeína de Hoje';

  @override
  String get alreadyInFavorites => 'Já nos favoritos';

  @override
  String get ofRecommendedLimit => 'do limite recomendado';

  @override
  String get aboutAlcohol => 'Sobre Álcool';

  @override
  String get alcoholInfo1 => 'Uma dose padrão igual 10g álcool puro';

  @override
  String get alcoholInfo2 =>
      'Álcool desidrata — beba 250ml água extra por dose';

  @override
  String get alcoholInfo3 =>
      'Adicione sódio pra ajudar reter fluidos após beber';

  @override
  String get alcoholInfo4 => 'Cada dose padrão aumenta HRI em 3-5 pontos';

  @override
  String get alcoholWarningHealth =>
      'Consumo excessivo álcool prejudica saúde. Limite recomendado é 2 SD homens e 1 SD mulheres por dia.';

  @override
  String get supplementsInfo1 =>
      'Suplementos ajudam manter balanço eletrólitos';

  @override
  String get supplementsInfo2 => 'Melhor tomar com refeições pra absorção';

  @override
  String get supplementsInfo3 => 'Sempre tome com bastante água';

  @override
  String get supplementsInfo4 => 'Magnésio e potássio chave pra hidratação';

  @override
  String get supplementsWarning =>
      'Consulte profissional saúde antes iniciar regime suplementos';

  @override
  String get fromSupplementsToday => 'De Suplementos Hoje';

  @override
  String get minerals => 'Minerais';

  @override
  String get vitamins => 'Vitaminas';

  @override
  String get essentialMinerals => 'Minerais Essenciais';

  @override
  String get otherSupplements => 'Outros Suplementos';

  @override
  String get supplementTip1 =>
      'Tome suplementos com comida pra melhor absorção';

  @override
  String get supplementTip2 => 'Beba bastante água com suplementos';

  @override
  String get supplementTip3 => 'Espalhe múltiplos suplementos ao longo do dia';

  @override
  String get supplementTip4 => 'Acompanhe o que funciona pra você';

  @override
  String get calciumCarbonate => 'Carbonato Cálcio';

  @override
  String get traceMinerals => 'Minerais Traço';

  @override
  String get vitaminA => 'Vitamina A';

  @override
  String get vitaminE => 'Vitamina E';

  @override
  String get vitaminK2 => 'Vitamina K2';

  @override
  String get folate => 'Folato';

  @override
  String get biotin => 'Biotina';

  @override
  String get probiotics => 'Probióticos';

  @override
  String get melatonin => 'Melatonina';

  @override
  String get collagen => 'Colágeno';

  @override
  String get glucosamine => 'Glucosamina';

  @override
  String get turmeric => 'Cúrcuma';

  @override
  String get coq10 => 'CoQ10';

  @override
  String get creatine => 'Creatina';

  @override
  String get ashwagandha => 'Ashwagandha';

  @override
  String get selectCardioActivity => 'Selecionar Atividade Cardio';

  @override
  String get selectStrengthActivity => 'Selecionar Atividade Força';

  @override
  String get selectSportsActivity => 'Selecionar Esporte';

  @override
  String get sessions => 'sessões';

  @override
  String get totalTime => 'Tempo Total';

  @override
  String get waterLoss => 'Perda Água';

  @override
  String get intensity => 'Intensity';

  @override
  String get drinkWaterAfterWorkout => 'Beba água após treino';

  @override
  String get replenishElectrolytes => 'Reponha eletrólitos';

  @override
  String get restAndRecover => 'Descanse e recupere';

  @override
  String get avoidSugaryDrinks => 'Evite bebidas esportivas açucaradas';

  @override
  String get elliptical => 'Elíptico';

  @override
  String get rowing => 'Remo';

  @override
  String get jumpRope => 'Pular Corda';

  @override
  String get stairClimbing => 'Escadas';

  @override
  String get bodyweight => 'Peso Corporal';

  @override
  String get powerlifting => 'Powerlifting';

  @override
  String get calisthenics => 'Calistenia';

  @override
  String get resistanceBands => 'Faixas Resistência';

  @override
  String get kettlebell => 'Kettlebell';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'Strongman';

  @override
  String get pilates => 'Pilates';

  @override
  String get basketball => 'Basquete';

  @override
  String get soccerFootball => 'Futebol';

  @override
  String get golf => 'Golfe';

  @override
  String get martialArts => 'Artes Marciais';

  @override
  String get rockClimbing => 'Escalada';

  @override
  String get needsToReplenish => 'Precisa repor';

  @override
  String get electrolyteTrackingPro =>
      'Rastreie sódio, potássio & magnésio com barras progresso detalhadas';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get weather => 'Clima';

  @override
  String get weatherTrackingPro =>
      'Rastreie índice calor, umidade & impacto clima nas metas hidratação';

  @override
  String get sugarTracking => 'Rastreamento Açúcar';

  @override
  String get sugarTrackingPro =>
      'Monitore ingestão açúcar natural, adicionado & oculto com análise impacto HRI';

  @override
  String get dayOverview => 'Visão Geral Dia';

  @override
  String get tapForDetails => 'Toque pra detalhes';

  @override
  String get noDataForDay => 'Sem dados pra este dia';

  @override
  String get sweatLoss => 'perda suor';

  @override
  String get cardio => 'Cardio';

  @override
  String get workout => 'Treino';

  @override
  String get noWaterToday => 'Nenhuma água registrada hoje';

  @override
  String get noElectrolytesToday => 'Nenhum eletrólito registrado hoje';

  @override
  String get noCoffeeToday => 'Nenhum café registrado hoje';

  @override
  String get noWorkoutsToday => 'Nenhum treino registrado hoje';

  @override
  String get noWaterThisDay => 'Nenhuma água registrada neste dia';

  @override
  String get noElectrolytesThisDay => 'Nenhum eletrólito registrado neste dia';

  @override
  String get noCoffeeThisDay => 'Nenhum café registrado neste dia';

  @override
  String get noWorkoutsThisDay => 'Nenhum treino registrado neste dia';

  @override
  String get weeklyReport => 'Relatório Semanal';

  @override
  String get weeklyReportSubtitle => 'Insights profundos e análise tendências';

  @override
  String get workouts => 'Treinos';

  @override
  String get workoutHydration => 'Hidratação Treino';

  @override
  String workoutHydrationMessage(Object percent) {
    return 'Em dias treino você bebe $percent% mais água';
  }

  @override
  String get weeklyActivity => 'Atividade Semanal';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return 'Você treinou $minutes minutos em $days dias';
  }

  @override
  String get workoutMinutesPerDay => 'Minutos treino por dia';

  @override
  String get daysWithWorkouts => 'dias com treinos';

  @override
  String get noWorkoutsThisWeek => 'Nenhum treino esta semana';

  @override
  String get noAlcoholThisWeek => 'Nenhum álcool esta semana';

  @override
  String get csvExported => 'Dados exportados pra CSV';

  @override
  String get mondayShort => 'SEG';

  @override
  String get tuesdayShort => 'TER';

  @override
  String get wednesdayShort => 'QUA';

  @override
  String get thursdayShort => 'QUI';

  @override
  String get fridayShort => 'SEX';

  @override
  String get saturdayShort => 'SÁB';

  @override
  String get sundayShort => 'DOM';

  @override
  String get achievements => 'Conquistas';

  @override
  String get achievementsTabAll => 'Todas';

  @override
  String get achievementsTabHydration => 'Hidratação';

  @override
  String get achievementsTabElectrolytes => 'Eletrólitos';

  @override
  String get achievementsTabSugar => 'Controle Açúcar';

  @override
  String get achievementsTabAlcohol => 'Álcool';

  @override
  String get achievementsTabWorkout => 'Fitness';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => 'Sequências';

  @override
  String get achievementsTabSpecial => 'Especial';

  @override
  String get achievementUnlocked => 'Conquista Desbloqueada!';

  @override
  String get achievementProgress => 'Progresso';

  @override
  String get achievementPoints => 'pontos';

  @override
  String get achievementRarityCommon => 'Comum';

  @override
  String get achievementRarityUncommon => 'Incomum';

  @override
  String get achievementRarityRare => 'Raro';

  @override
  String get achievementRarityEpic => 'Épico';

  @override
  String get achievementRarityLegendary => 'Lendário';

  @override
  String get achievementStatsUnlocked => 'Desbloqueado';

  @override
  String get achievementStatsTotal => 'Pontos Totais';

  @override
  String get achievementFilterAll => 'Todas';

  @override
  String get achievementFilterUnlocked => 'Desbloqueadas';

  @override
  String get achievementSortProgress => 'Progresso';

  @override
  String get achievementSortName => 'Nome';

  @override
  String get achievementSortRarity => 'Raridade';

  @override
  String get achievementNoAchievements => 'Nenhuma conquista ainda';

  @override
  String get achievementKeepUsing =>
      'Continue usando app pra desbloquear conquistas!';

  @override
  String get achievementFirstGlass => 'Primeira Gota';

  @override
  String get achievementFirstGlassDesc => 'Beba seu primeiro copo d\'água';

  @override
  String get achievementHydrationGoal1 => 'Hidratado';

  @override
  String get achievementHydrationGoal1Desc => 'Alcance meta água diária';

  @override
  String get achievementHydrationGoal7 => 'Semana Hidratação';

  @override
  String get achievementHydrationGoal7Desc =>
      'Alcance meta água por 7 dias seguidos';

  @override
  String get achievementHydrationGoal30 => 'Mestre Hidratação';

  @override
  String get achievementHydrationGoal30Desc =>
      'Alcance meta água por 30 dias seguidos';

  @override
  String get achievementPerfectHydration => 'Balanço Perfeito';

  @override
  String get achievementPerfectHydrationDesc => 'Alcance 90-110% da meta água';

  @override
  String get achievementEarlyBird => 'Madrugador';

  @override
  String get achievementEarlyBirdDesc => 'Beba primeira água antes 9h';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return 'Beba $volume antes 9h';
  }

  @override
  String get achievementNightOwl => 'Coruja Noite';

  @override
  String get achievementNightOwlDesc => 'Complete meta hidratação antes 18h';

  @override
  String get achievementLiterLegend => 'Lenda Litro';

  @override
  String get achievementLiterLegendDesc => 'Alcance marco total hidratação';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return 'Beba $volume total';
  }

  @override
  String get achievementSaltStarter => 'Iniciante Sal';

  @override
  String get achievementSaltStarterDesc => 'Adicione primeiros eletrólitos';

  @override
  String get achievementElectrolyteBalance => 'Balanceado';

  @override
  String get achievementElectrolyteBalanceDesc =>
      'Alcance todas metas eletrólitos em um dia';

  @override
  String get achievementSodiumMaster => 'Mestre Sódio';

  @override
  String get achievementSodiumMasterDesc =>
      'Alcance meta sódio 7 dias seguidos';

  @override
  String get achievementPotassiumPro => 'Pro Potássio';

  @override
  String get achievementPotassiumProDesc =>
      'Alcance meta potássio 7 dias seguidos';

  @override
  String get achievementMagnesiumMaven => 'Expert Magnésio';

  @override
  String get achievementMagnesiumMavenDesc =>
      'Alcance meta magnésio 7 dias seguidos';

  @override
  String get achievementElectrolyteExpert => 'Expert Eletrólitos';

  @override
  String get achievementElectrolyteExpertDesc =>
      'Balanço perfeito eletrólitos por 30 dias';

  @override
  String get achievementSugarAwareness => 'Consciência Açúcar';

  @override
  String get achievementSugarAwarenessDesc =>
      'Rastreie açúcar pela primeira vez';

  @override
  String get achievementSugarUnder25 => 'Controle Doce';

  @override
  String get achievementSugarUnder25Desc =>
      'Mantenha ingestão açúcar baixa por um dia';

  @override
  String achievementSugarUnder25Template(String weight) {
    return 'Mantenha açúcar abaixo $weight por um dia';
  }

  @override
  String get achievementSugarWeekControl => 'Disciplina Açúcar';

  @override
  String get achievementSugarWeekControlDesc =>
      'Mantenha ingestão açúcar baixa por semana';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return 'Mantenha açúcar abaixo $weight por 7 dias';
  }

  @override
  String get achievementSugarFreeDay => 'Sem Açúcar';

  @override
  String get achievementSugarFreeDayDesc =>
      'Complete dia com 0g açúcar adicionado';

  @override
  String get achievementSugarDetective => 'Detetive Açúcar';

  @override
  String get achievementSugarDetectiveDesc =>
      'Rastreie açúcares ocultos 10 vezes';

  @override
  String get achievementSugarMaster => 'Mestre Açúcar';

  @override
  String get achievementSugarMasterDesc =>
      'Mantenha ingestão açúcar muito baixa por mês';

  @override
  String get achievementNoSodaWeek => 'Semana Sem Refri';

  @override
  String get achievementNoSodaWeekDesc => 'Sem refris por 7 dias';

  @override
  String get achievementNoSodaMonth => 'Mês Sem Refri';

  @override
  String get achievementNoSodaMonthDesc => 'Sem refris por 30 dias';

  @override
  String get achievementSweetToothTamed => 'Dente Doce Domado';

  @override
  String get achievementSweetToothTamedDesc =>
      'Reduza açúcar diário 50% por semana';

  @override
  String get achievementAlcoholTracker => 'Consciência';

  @override
  String get achievementAlcoholTrackerDesc => 'Rastreie consumo álcool';

  @override
  String get achievementModerateDay => 'Moderação';

  @override
  String get achievementModerateDayDesc => 'Fique abaixo 2 SD num dia';

  @override
  String get achievementSoberDay => 'Dia Sóbrio';

  @override
  String get achievementSoberDayDesc => 'Complete dia sem álcool';

  @override
  String get achievementSoberWeek => 'Semana Sóbrio';

  @override
  String get achievementSoberWeekDesc => '7 dias sem álcool';

  @override
  String get achievementSoberMonth => 'Mês Sóbrio';

  @override
  String get achievementSoberMonthDesc => '30 dias sem álcool';

  @override
  String get achievementRecoveryProtocol => 'Pro Recuperação';

  @override
  String get achievementRecoveryProtocolDesc =>
      'Complete protocolo recuperação após beber';

  @override
  String get achievementFirstWorkout => 'Mexa-se';

  @override
  String get achievementFirstWorkoutDesc => 'Registre primeiro treino';

  @override
  String get achievementWorkoutWeek => 'Semana Ativa';

  @override
  String get achievementWorkoutWeekDesc => 'Treine 3 vezes numa semana';

  @override
  String get achievementCenturySweat => 'Século Suor';

  @override
  String get achievementCenturySweatDesc =>
      'Perca fluido significativo através treinos';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return 'Perca $volume através treinos';
  }

  @override
  String get achievementCardioKing => 'Rei Cardio';

  @override
  String get achievementCardioKingDesc => 'Complete 10 sessões cardio';

  @override
  String get achievementStrengthWarrior => 'Guerreiro Força';

  @override
  String get achievementStrengthWarriorDesc => 'Complete 10 sessões força';

  @override
  String get achievementHRIGreen => 'Zona Verde';

  @override
  String get achievementHRIGreenDesc => 'Mantenha HRI zona verde por dia';

  @override
  String get achievementHRIWeekGreen => 'Semana Segura';

  @override
  String get achievementHRIWeekGreenDesc =>
      'Mantenha HRI zona verde por 7 dias';

  @override
  String get achievementHRIPerfect => 'Pontuação Perfeita';

  @override
  String get achievementHRIPerfectDesc => 'Alcance HRI abaixo 20';

  @override
  String get achievementHRIRecovery => 'Recuperação Rápida';

  @override
  String get achievementHRIRecoveryDesc =>
      'Reduza HRI de vermelho pra verde em um dia';

  @override
  String get achievementHRIMaster => 'Mestre HRI';

  @override
  String get achievementHRIMasterDesc => 'Mantenha HRI abaixo 30 por 30 dias';

  @override
  String get achievementStreak3 => 'Começando';

  @override
  String get achievementStreak3Desc => 'Sequência 3 dias';

  @override
  String get achievementStreak7 => 'Guerreiro Semana';

  @override
  String get achievementStreak7Desc => 'Sequência 7 dias';

  @override
  String get achievementStreak30 => 'Rei Consistência';

  @override
  String get achievementStreak30Desc => 'Sequência 30 dias';

  @override
  String get achievementStreak100 => 'Clube Século';

  @override
  String get achievementStreak100Desc => 'Sequência 100 dias';

  @override
  String get achievementFirstWeek => 'Primeira Semana';

  @override
  String get achievementFirstWeekDesc => 'Use app por 7 dias';

  @override
  String get achievementProMember => 'Membro PRO';

  @override
  String get achievementProMemberDesc => 'Torne-se assinante PRO';

  @override
  String get achievementDataExport => 'Analista Dados';

  @override
  String get achievementDataExportDesc => 'Exporte dados pra CSV';

  @override
  String get achievementAllCategories => 'Pau Pra Toda Obra';

  @override
  String get achievementAllCategoriesDesc =>
      'Desbloqueie pelo menos uma conquista em cada categoria';

  @override
  String get achievementHunter => 'Caçador Conquistas';

  @override
  String get achievementHunterDesc => 'Desbloqueie 50% de todas conquistas';

  @override
  String get achievementDetailsUnlockedOn => 'Desbloqueado em';

  @override
  String get achievementNewUnlocked => 'Nova conquista desbloqueada!';

  @override
  String get achievementViewAll => 'Ver todas conquistas';

  @override
  String get achievementCloseNotification => 'Fechar';

  @override
  String get before => 'antes';

  @override
  String get after => 'após';

  @override
  String get lose => 'Perder';

  @override
  String get through => 'através';

  @override
  String get throughWorkouts => 'através treinos';

  @override
  String get reach => 'Alcançar';

  @override
  String get daysInRow => 'dias seguidos';

  @override
  String get completeHydrationGoal => 'Complete meta hidratação';

  @override
  String get stayUnder => 'Fique abaixo';

  @override
  String get inADay => 'num dia';

  @override
  String get alcoholFree => 'sem álcool';

  @override
  String get complete => 'Complete';

  @override
  String get achieve => 'Alcance';

  @override
  String get keep => 'Mantenha';

  @override
  String get for30Days => 'por 30 dias';

  @override
  String get liters => 'litros';

  @override
  String get completed => 'Completado';

  @override
  String get notCompleted => 'Não completado';

  @override
  String get days => 'dias';

  @override
  String get hours => 'horas';

  @override
  String get times => 'vezes';

  @override
  String get row => 'seguidos';

  @override
  String get ofTotal => 'do total';

  @override
  String get perDay => 'por dia';

  @override
  String get perWeek => 'por semana';

  @override
  String get streak => 'sequência';

  @override
  String get tapToDismiss => 'Toque pra dispensar';

  @override
  String tutorialStep1(String volume) {
    return 'Oi! Vou ajudar começar jornada hidratação ideal. Vamos tomar primeiro gole de $volume!';
  }

  @override
  String tutorialStep2(String volume) {
    return 'Excelente! Agora adicione mais $volume pra sentir como funciona.';
  }

  @override
  String get tutorialStep3 =>
      'Excepcional! Você está pronto pra usar HydroCoach independentemente. Vou estar aqui pra ajudar alcançar hidratação perfeita!';

  @override
  String get tutorialComplete => 'Começar usar';

  @override
  String get onboardingNotificationExamplesTitle => 'Lembretes Inteligentes';

  @override
  String get onboardingNotificationExamplesSubtitle =>
      'HydroCoach sabe quando precisa água';

  @override
  String get onboardingLocationExamplesTitle => 'Conselho Pessoal';

  @override
  String get onboardingLocationExamplesSubtitle =>
      'Consideramos clima pra recomendações precisas';

  @override
  String get onboardingAllowNotifications => 'Permitir Notificações';

  @override
  String get onboardingAllowLocation => 'Permitir Localização';

  @override
  String get foodCatalog => 'Catálogo Comida';

  @override
  String get todaysFoodIntake => 'Ingestão Comida Hoje';

  @override
  String get noFoodToday => 'Nenhuma comida registrada hoje';

  @override
  String foodItemsCount(int count) {
    return '$count itens comida';
  }

  @override
  String get waterFromFood => 'Água de comida';

  @override
  String get last => 'Último';

  @override
  String get categoryFruits => 'Frutas';

  @override
  String get categoryVegetables => 'Vegetais';

  @override
  String get categorySoups => 'Sopas';

  @override
  String get categoryDairy => 'Laticínios';

  @override
  String get categoryMeat => 'Carne';

  @override
  String get categoryFastFood => 'Fast Food';

  @override
  String get weightGrams => 'Peso (gramas)';

  @override
  String get enterWeight => 'Digite peso';

  @override
  String get grams => 'g';

  @override
  String get calories => 'Calorias';

  @override
  String get waterContent => 'Conteúdo Água';

  @override
  String get sugar => 'Açúcar';

  @override
  String get nutritionalInfo => 'Info Nutricional';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$calories kcal por ${weight}g';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$water ml água por ${weight}g';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${sugar}g açúcar por ${weight}g';
  }

  @override
  String get addFood => 'Adicionar Comida';

  @override
  String get foodAdded => 'Comida adicionada com sucesso';

  @override
  String get enterValidWeight => 'Digite peso válido';

  @override
  String get proOnlyFood => 'Apenas PRO';

  @override
  String get unlockProForFood =>
      'Desbloqueie PRO pra acessar todos itens comida';

  @override
  String get foodTracker => 'Rastreador Comida';

  @override
  String get todaysFoodSummary => 'Resumo Comida Hoje';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => 'por 100g';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get favoritesFeatureComingSoon => 'Recurso favoritos em breve!';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '$food adicionado! +$calories kcal, +$water';
  }

  @override
  String get selectWeight => 'Selecionar Peso';

  @override
  String get ounces => 'oz';

  @override
  String get items => 'itens';

  @override
  String get tapToAddFood => 'Toque pra adicionar comida';

  @override
  String get noFoodLoggedToday => 'Nenhuma comida registrada hoje';

  @override
  String get lightEatingDay => 'Dia comendo leve';

  @override
  String get moderateIntake => 'Ingestão moderada';

  @override
  String get goodCalorieIntake => 'Boa ingestão calorias';

  @override
  String get substantialMeals => 'Refeições substanciais';

  @override
  String get highCalorieDay => 'Dia alto calorias';

  @override
  String get veryHighIntake => 'Ingestão muito alta';

  @override
  String get caloriesTracker => 'Rastreador Calorias';

  @override
  String get trackYourDailyCalorieIntake =>
      'Rastreie ingestão calorias diária de comida';

  @override
  String get unlockFoodTrackingFeatures =>
      'Desbloqueie recursos rastreamento comida';

  @override
  String get selectFoodType => 'Selecionar tipo comida';

  @override
  String get foodApple => 'Maçã';

  @override
  String get foodBanana => 'Banana';

  @override
  String get foodOrange => 'Laranja';

  @override
  String get foodWatermelon => 'Melancia';

  @override
  String get foodStrawberry => 'Morango';

  @override
  String get foodGrapes => 'Uvas';

  @override
  String get foodPineapple => 'Abacaxi';

  @override
  String get foodMango => 'Manga';

  @override
  String get foodPear => 'Pera';

  @override
  String get foodCarrot => 'Cenoura';

  @override
  String get foodBroccoli => 'Brócolis';

  @override
  String get foodSpinach => 'Espinafre';

  @override
  String get foodTomato => 'Tomate';

  @override
  String get foodCucumber => 'Pepino';

  @override
  String get foodBellPepper => 'Pimentão';

  @override
  String get foodLettuce => 'Alface';

  @override
  String get foodOnion => 'Cebola';

  @override
  String get foodCelery => 'Aipo';

  @override
  String get foodPotato => 'Batata';

  @override
  String get foodChickenSoup => 'Sopa Frango';

  @override
  String get foodTomatoSoup => 'Sopa Tomate';

  @override
  String get foodVegetableSoup => 'Sopa Vegetais';

  @override
  String get foodMinestrone => 'Minestrone';

  @override
  String get foodMisoSoup => 'Sopa Missô';

  @override
  String get foodMushroomSoup => 'Sopa Cogumelos';

  @override
  String get foodBeefStew => 'Ensopado Carne';

  @override
  String get foodLentilSoup => 'Sopa Lentilha';

  @override
  String get foodOnionSoup => 'Sopa Cebola Francesa';

  @override
  String get foodMilk => 'Leite';

  @override
  String get foodYogurt => 'Iogurte Grego';

  @override
  String get foodCheese => 'Queijo Cheddar';

  @override
  String get foodCottageCheese => 'Queijo Cottage';

  @override
  String get foodButter => 'Manteiga';

  @override
  String get foodCream => 'Creme Leite';

  @override
  String get foodIceCream => 'Sorvete';

  @override
  String get foodMozzarella => 'Mozzarella';

  @override
  String get foodParmesan => 'Parmesão';

  @override
  String get foodChickenBreast => 'Peito Frango';

  @override
  String get foodBeef => 'Carne Moída';

  @override
  String get foodSalmon => 'Salmão';

  @override
  String get foodEggs => 'Ovos';

  @override
  String get foodTuna => 'Atum';

  @override
  String get foodPork => 'Costeleta Porco';

  @override
  String get foodTurkey => 'Peru';

  @override
  String get foodShrimp => 'Camarão';

  @override
  String get foodBacon => 'Bacon';

  @override
  String get foodBigMac => 'Big Mac';

  @override
  String get foodPizza => 'Fatia Pizza';

  @override
  String get foodFrenchFries => 'Batata Frita';

  @override
  String get foodChickenNuggets => 'Nuggets Frango';

  @override
  String get foodHotDog => 'Cachorro-Quente';

  @override
  String get foodTacos => 'Tacos';

  @override
  String get foodSubway => 'Sanduíche Subway';

  @override
  String get foodDonut => 'Rosquinha';

  @override
  String get foodBurgerKing => 'Whopper';

  @override
  String get foodSausage => 'Salsicha';

  @override
  String get foodKefir => 'Kefir';

  @override
  String get foodRyazhenka => 'Ryazhenka';

  @override
  String get foodDoner => 'Döner';

  @override
  String get foodShawarma => 'Shawarma';

  @override
  String get foodBorscht => 'Borsch';

  @override
  String get foodRamen => 'Ramen';

  @override
  String get foodCabbage => 'Repolho';

  @override
  String get foodPeaSoup => 'Sopa Ervilha';

  @override
  String get foodSolyanka => 'Solyanka';

  @override
  String get meals => 'refeições';

  @override
  String get dailyProgress => 'Progresso Diário';

  @override
  String get fromFood => 'de comida';

  @override
  String get noFoodThisWeek => 'Sem dados comida esta semana';

  @override
  String get foodIntake => 'Ingestão Comida';

  @override
  String get foodStats => 'Estatísticas Comida';

  @override
  String get totalCalories => 'Calorias totais';

  @override
  String get avgCaloriesPerDay => 'Média por dia';

  @override
  String get daysWithFood => 'Dias com comida';

  @override
  String get avgMealsPerDay => 'Refeições por dia';

  @override
  String get caloriesPerDay => 'Calorias por dia';

  @override
  String get sugarPerDay => 'Açúcar por dia';

  @override
  String get foodTracking => 'Rastreamento Comida';

  @override
  String get foodTrackingPro => 'Rastreie impacto comida na hidratação e HRI';

  @override
  String get hydrationBalance => 'Balanço Hidratação';

  @override
  String get highSodiumFood => 'Alto sódio de comida';

  @override
  String get hydratingFood => 'Ótimas escolhas hidratantes';

  @override
  String get dryFood => 'Comida baixo conteúdo água';

  @override
  String get balancedFood => 'Nutrição balanceada';

  @override
  String get foodAdviceEmpty =>
      'Adicione refeições pra rastrear impacto comida na hidratação.';

  @override
  String get foodAdviceHighSodium =>
      'Alta ingestão sódio detectada. Aumente água pra balancear eletrólitos.';

  @override
  String get foodAdviceLowWater =>
      'Sua comida teve baixo conteúdo água. Considere beber água extra.';

  @override
  String get foodAdviceGoodHydration => 'Ótimo! Sua comida ajuda hidratação.';

  @override
  String get foodAdviceBalanced => 'Boa nutrição! Lembre de beber água.';

  @override
  String get richInElectrolytes => 'Rico em eletrólitos';

  @override
  String recommendedCalories(int calories) {
    return 'Calorias recomendadas: ~$calories kcal/dia';
  }

  @override
  String get proWelcomeTitle => 'Bem-vindo ao HydraCoach PRO!';

  @override
  String get proTrialActivated => 'Seu teste 7 dias ativado!';

  @override
  String get proFeaturePersonalizedRecommendations =>
      'Recomendações personalizadas';

  @override
  String get proFeatureAdvancedAnalytics => 'Análises avançadas';

  @override
  String get proFeatureWorkoutTracking => 'Rastreamento treinos';

  @override
  String get proFeatureElectrolyteControl => 'Controle eletrólitos';

  @override
  String get proFeatureSmartReminders => 'Lembretes inteligentes';

  @override
  String get proFeatureHriIndex => 'Índice HRI';

  @override
  String get proFeatureAchievements => 'Conquistas PRO';

  @override
  String get proFeaturePersonalizedDescription =>
      'Conselhos hidratação individuais';

  @override
  String get proFeatureAdvancedDescription =>
      'Gráficos e estatísticas detalhadas';

  @override
  String get proFeatureWorkoutDescription =>
      'Rastreamento perda fluido durante esportes';

  @override
  String get proFeatureElectrolyteDescription =>
      'Monitoramento sódio, potássio, magnésio';

  @override
  String get proFeatureSmartDescription => 'Notificações personalizadas';

  @override
  String get proFeatureNoMoreAds => 'Sem mais ADs!';

  @override
  String get proFeatureNoMoreAdsDescription =>
      'Aproveite rastreamento hidratação ininterrupto sem anúncios';

  @override
  String get proFeatureHriDescription =>
      'Índice risco hidratação em tempo real';

  @override
  String get proFeatureAchievementsDescription =>
      'Recompensas e metas exclusivas';

  @override
  String get startUsing => 'Começar usar';

  @override
  String get sayGoodbyeToAds => 'Diga adeus aos anúncios. Vá Premium.';

  @override
  String get goPremium => 'VÁ PREMIUM';

  @override
  String get removeAdsForever => 'Remova anúncios pra sempre';

  @override
  String get upgrade => 'ATUALIZAR';

  @override
  String get support => 'Suporte';

  @override
  String get companyWebsite => 'Site Empresa';

  @override
  String get appStoreOpened => 'App Store aberta';

  @override
  String get linkCopiedToClipboard => 'Link copiado área transferência';

  @override
  String get shareDialogOpened => 'Diálogo compartilhar aberto';

  @override
  String get linkForSharingCopied => 'Link pra compartilhar copiado';

  @override
  String get websiteOpenedInBrowser => 'Site aberto no navegador';

  @override
  String get emailClientOpened => 'Cliente email aberto';

  @override
  String get emailCopiedToClipboard => 'Email copiado área transferência';

  @override
  String get privacyPolicyOpened => 'Política privacidade aberta';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Estatísticas até $dateString';
  }

  @override
  String get monthlyInsights => 'Insights Mensais';

  @override
  String get average => 'Média';

  @override
  String get daysOver => 'Dias acima';

  @override
  String get maximum => 'Máximo';

  @override
  String get balance => 'Balanço';

  @override
  String get allNormal => 'Tudo normal';

  @override
  String get excellentConsistency => 'Consistência excelente';

  @override
  String get goodResults => 'Bons resultados';

  @override
  String get positiveImprovement => 'Melhoria positiva';

  @override
  String get physicalActivity => 'Atividade física';

  @override
  String get coffeeConsumption => 'Consumo café';

  @override
  String get excellentSobriety => 'Sobriedade excelente';

  @override
  String get excellentMonth => 'Mês excelente';

  @override
  String get keepGoingMotivation => 'Continue assim!';

  @override
  String get daysNormal => 'dias normal';

  @override
  String get electrolyteBalance => 'Balanço eletrólitos precisa atenção';

  @override
  String get caffeineWarning => 'Dias com overdose dose segura (400mg)';

  @override
  String get sugarFrequentExcess => 'Excesso açúcar frequente afeta hidratação';

  @override
  String get averagePerDayShort => 'por dia';

  @override
  String get highWarning => 'Alto';

  @override
  String get normalStatus => 'Normal';

  @override
  String improvementToEnd(int percent) {
    return 'Melhoria até fim mês em $percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent% dias com treinos (${hours}h)';
  }

  @override
  String coffeeAverage(String avg) {
    return 'Média $avg xícaras/dia';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent% dias sem álcool';
  }

  @override
  String get daySummary => 'Resumo Dia';

  @override
  String get records => 'Registros';

  @override
  String waterGoalAchievement(int percent) {
    return 'Alcance meta água: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return 'Treinos: $count sessões';
  }

  @override
  String get index => 'Índice';

  @override
  String get status => 'Status';

  @override
  String get moderateRisk => 'Risco moderado';

  @override
  String get excess => 'Excesso';

  @override
  String get whoLimit => 'Limite OMS: 50g/dia';

  @override
  String stability(int percent) {
    return 'Estabilidade em $percent% dos dias';
  }

  @override
  String goodHydration(int percent) {
    return '$percent% dias com boa hidratação';
  }

  @override
  String daysInNorm(int count) {
    return '$count dias na norma';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent% dias com boa hidratação';
  }

  @override
  String stabilityDays(int percent) {
    return 'Estabilidade em $percent% dos dias';
  }

  @override
  String monthEndImprovement(int percent) {
    return 'Melhoria fim mês em $percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent% dias com treinos (${hours}h)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return 'Média $avgCups xícaras/dia';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent% dias sem álcool';
  }

  @override
  String get moderateRiskStatus => 'Status: Risco moderado';

  @override
  String get high => 'Alto';

  @override
  String get whoLimitPerDay => 'Limite OMS: 50g/dia';
}
