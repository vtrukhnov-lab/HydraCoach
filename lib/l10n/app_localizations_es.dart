// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'HydraCoach';

  @override
  String get getPro => 'Obtener PRO';

  @override
  String get sunday => 'Domingo';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day de $month';
  }

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingWeather => 'Cargando el clima...';

  @override
  String get heatIndex => 'Índice de calor';

  @override
  String humidity(int value) {
    return 'Humedad: $value%';
  }

  @override
  String get water => 'Agua';

  @override
  String get liquids => 'Líquidos';

  @override
  String get sodium => 'Sodio';

  @override
  String get potassium => 'Potasio';

  @override
  String get magnesium => 'Magnesio';

  @override
  String get electrolyte => 'Electrolitos';

  @override
  String get broth => 'Caldo';

  @override
  String get coffee => 'Café';

  @override
  String get alcohol => 'Alcohol';

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
    return 'Alcohol +$amount ml';
  }

  @override
  String get smartAdviceTitle => 'Consejo para ahora';

  @override
  String get smartAdviceDefault =>
      'Mantén el equilibrio de agua y electrolitos.';

  @override
  String get adviceOverhydrationSevere =>
      'Sobrehidratación severa (>200% objetivo)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Pausa 60-90 minutos. Agrega electrolitos: 300-500 ml con 500-1000 mg sodio.';

  @override
  String get adviceOverhydration => 'Sobrehidratación';

  @override
  String get adviceOverhydrationBody =>
      'Pausa el agua por 30-60 minutos y agrega ~500 mg sodio (electrolitos/caldo).';

  @override
  String get adviceAlcoholRecovery => 'Alcohol: recuperación';

  @override
  String get adviceAlcoholRecoveryBody =>
      'No más alcohol hoy. Bebe 300-500 ml agua en porciones pequeñas y agrega sodio.';

  @override
  String get adviceLowSodium => 'Poco sodio';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Agrega ~$amount mg sodio. Bebe moderadamente.';
  }

  @override
  String get adviceDehydration => 'Deshidratado';

  @override
  String adviceDehydrationBody(String type) {
    return 'Bebe 300-500 ml de $type.';
  }

  @override
  String get adviceHighRisk => 'Alto riesgo (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Urgentemente bebe agua con electrolitos (300-500 ml) y reduce actividad.';

  @override
  String get adviceHeat => 'Calor y pérdidas';

  @override
  String get adviceHeatBody => 'Aumenta agua +5-8% y agrega 300-500 mg sodio.';

  @override
  String get adviceAllGood => 'Todo en marcha';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Mantén el ritmo. Objetivo: ~$amount ml más para la meta.';
  }

  @override
  String get hydrationStatus => 'Estado de hidratación';

  @override
  String get hydrationStatusNormal => 'Normal';

  @override
  String get hydrationStatusDiluted => 'Diluyendo';

  @override
  String get hydrationStatusDehydrated => 'Deshidratado';

  @override
  String get hydrationStatusLowSalt => 'Poca sal';

  @override
  String get hydrationRiskIndex => 'Índice de riesgo de hidratación';

  @override
  String get quickAdd => 'Agregar rápido';

  @override
  String get add => 'Agregar';

  @override
  String get delete => 'Eliminar';

  @override
  String get todaysDrinks => 'Bebidas de hoy';

  @override
  String get allRecords => 'Todos los registros →';

  @override
  String itemDeleted(String item) {
    return '$item eliminado';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get dailyReportReady => '¡Informe diario listo!';

  @override
  String get viewDayResults => 'Ver resultados del día';

  @override
  String get dailyReportComingSoon =>
      'El informe diario estará disponible en la próxima versión';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get reset => 'Restablecer';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSettings => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get profileSection => 'Perfil';

  @override
  String get weight => 'Peso';

  @override
  String get dietMode => 'Modo de dieta';

  @override
  String get activityLevel => 'Nivel de actividad';

  @override
  String get changeWeight => 'Cambiar peso';

  @override
  String get dietModeNormal => 'Dieta normal';

  @override
  String get dietModeKeto => 'Keto / Baja en carbohidratos';

  @override
  String get dietModeFasting => 'Ayuno intermitente';

  @override
  String get activityLow => 'Actividad baja';

  @override
  String get activityMedium => 'Actividad media';

  @override
  String get activityHigh => 'Actividad alta';

  @override
  String get activityLowDesc => 'Trabajo de oficina, poco movimiento';

  @override
  String get activityMediumDesc => '30-60 minutos de ejercicio por día';

  @override
  String get activityHighDesc => 'Entrenamientos >1 hora';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get notificationLimit => 'Límite de notificaciones (FREE)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Usado: $used de $limit';
  }

  @override
  String get waterReminders => 'Recordatorios de agua';

  @override
  String get waterRemindersDesc => 'Recordatorios regulares durante el día';

  @override
  String get reminderFrequency => 'Frecuencia de recordatorios';

  @override
  String timesPerDay(int count) {
    return '$count veces por día';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count veces por día (máx 4)';
  }

  @override
  String get unlimitedReminders => 'Ilimitado';

  @override
  String get startOfDay => 'Inicio del día';

  @override
  String get endOfDay => 'Fin del día';

  @override
  String get postCoffeeReminders => 'Recordatorios post-café';

  @override
  String get postCoffeeRemindersDesc =>
      'Recordar beber agua después de 20 minutos';

  @override
  String get heatWarnings => 'Alertas de calor';

  @override
  String get heatWarningsDesc => 'Notificaciones en altas temperaturas';

  @override
  String get postAlcoholReminders => 'Recordatorios post-alcohol';

  @override
  String get postAlcoholRemindersDesc => 'Plan de recuperación por 6-12 horas';

  @override
  String get proFeaturesSection => 'Funciones PRO';

  @override
  String get unlockPro => 'Desbloquear PRO';

  @override
  String get unlockProDesc =>
      'Notificaciones ilimitadas y recordatorios inteligentes';

  @override
  String get noNotificationLimit => 'Sin límite de notificaciones';

  @override
  String get unitsSection => 'Unidades';

  @override
  String get metricSystem => 'Sistema métrico';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Sistema imperial';

  @override
  String get imperialUnits => 'oz, lb, °F';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get rateApp => 'Calificar app';

  @override
  String get share => 'Compartir';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get resetAllData => 'Restablecer todos los datos';

  @override
  String get resetDataTitle => '¿Restablecer todos los datos?';

  @override
  String get resetDataMessage =>
      'Esto eliminará todo el historial y restaurará la configuración por defecto.';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get start => 'Comenzar';

  @override
  String get welcomeTitle => 'Bienvenido a\nHydraCoach';

  @override
  String get welcomeSubtitle =>
      'Seguimiento inteligente de agua y electrolitos\npara keto, ayuno y vida activa';

  @override
  String get weightPageTitle => 'Tu peso';

  @override
  String get weightPageSubtitle => 'Para calcular la cantidad óptima de agua';

  @override
  String weightUnit(int weight) {
    return '$weight kg';
  }

  @override
  String recommendedNorm(int min, int max) {
    return 'Norma recomendada: $min-$max ml de agua por día';
  }

  @override
  String get dietPageTitle => 'Modo de dieta';

  @override
  String get dietPageSubtitle => 'Esto afecta las necesidades de electrolitos';

  @override
  String get normalDiet => 'Dieta normal';

  @override
  String get normalDietDesc => 'Recomendaciones estándar';

  @override
  String get ketoDiet => 'Keto / Baja en carbohidratos';

  @override
  String get ketoDietDesc => 'Necesidades aumentadas de sal';

  @override
  String get fastingDiet => 'Ayuno intermitente';

  @override
  String get fastingDietDesc => 'Régimen especial de electrolitos';

  @override
  String get fastingSchedule => 'Horario de ayuno:';

  @override
  String get fasting16_8 => '16:8';

  @override
  String get fasting16_8Desc => 'Ventana diaria de 8 horas';

  @override
  String get fastingOMAD => 'OMAD';

  @override
  String get fastingOMADDesc => 'Una comida al día';

  @override
  String get fastingADF => 'ADF';

  @override
  String get fastingADFDesc => 'Ayuno en días alternos';

  @override
  String get activityPageTitle => 'Nivel de actividad';

  @override
  String get activityPageSubtitle => 'Afecta las necesidades de agua';

  @override
  String get lowActivity => 'Actividad baja';

  @override
  String get lowActivityDesc => 'Trabajo de oficina, poco movimiento';

  @override
  String get lowActivityWater => '+0 ml agua';

  @override
  String get mediumActivity => 'Actividad media';

  @override
  String get mediumActivityDesc => '30-60 minutos de ejercicio por día';

  @override
  String get mediumActivityWater => '+350-700 ml agua';

  @override
  String get highActivity => 'Actividad alta';

  @override
  String get highActivityDesc => 'Entrenamientos >1 hora o trabajo físico';

  @override
  String get highActivityWater => '+700-1200 ml agua';

  @override
  String get activityAdjustmentNote =>
      'Ajustaremos objetivos basados en tus entrenamientos';

  @override
  String get day => 'Día';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mes';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get noData => 'Sin datos';

  @override
  String get noRecordsToday => 'Aún no hay registros para hoy';

  @override
  String get noRecordsThisDay => 'No hay registros para este día';

  @override
  String get loadingData => 'Cargando datos...';

  @override
  String get deleteRecord => '¿Eliminar registro?';

  @override
  String deleteRecordMessage(String type, int volume) {
    return '¿Eliminar $type $volume ml?';
  }

  @override
  String get recordDeleted => 'Registro eliminado';

  @override
  String get waterConsumption => '💧 Consumo de agua';

  @override
  String get alcoholWeek => '🍺 Alcohol esta semana';

  @override
  String get electrolytes => '⚡ Electrolitos';

  @override
  String get weeklyAverages => '📊 Promedios semanales';

  @override
  String get monthStatistics => '📊 Estadísticas del mes';

  @override
  String get alcoholStatistics => '🍺 Estadísticas de alcohol';

  @override
  String get alcoholStatisticsTitle => 'Estadísticas de alcohol';

  @override
  String get weeklyInsights => '💡 Insights semanales';

  @override
  String get waterPerDay => 'Agua por día';

  @override
  String get sodiumPerDay => 'Sodio por día';

  @override
  String get potassiumPerDay => 'Potasio por día';

  @override
  String get magnesiumPerDay => 'Magnesio por día';

  @override
  String get goal => 'Objetivo';

  @override
  String get daysWithGoalAchieved => '✅ Días con objetivo logrado';

  @override
  String get recordsPerDay => '📝 Registros por día';

  @override
  String get insufficientDataForAnalysis => 'Datos insuficientes para análisis';

  @override
  String get totalVolume => 'Volumen total';

  @override
  String averagePerDay(int amount) {
    return 'Promedio $amount ml/día';
  }

  @override
  String get activeDays => 'Días activos';

  @override
  String perfectDays(int count) {
    return 'Días con objetivo perfecto: $count';
  }

  @override
  String currentStreak(int days) {
    return 'Racha actual: $days días';
  }

  @override
  String soberDaysRow(int days) {
    return 'Días sobrios seguidos: $days';
  }

  @override
  String get keepItUp => '¡Sigue así!';

  @override
  String waterAmount(int amount, int percent) {
    return 'Agua: $amount ml ($percent%)';
  }

  @override
  String alcoholAmount(String amount) {
    return 'Alcohol: $amount SD';
  }

  @override
  String get totalSD => 'Total SD';

  @override
  String get forMonth => 'del mes';

  @override
  String get daysWithAlcohol => 'Días con alcohol';

  @override
  String fromDays(int days) {
    return 'de $days';
  }

  @override
  String get soberDays => 'Días sobrios';

  @override
  String get excellent => '¡excelente!';

  @override
  String get averageSD => 'SD promedio';

  @override
  String get inDrinkingDays => 'en días de consumo';

  @override
  String get bestDay => '🏆 Mejor día';

  @override
  String bestDayMessage(String day, int percent) {
    return '$day - $percent% del objetivo';
  }

  @override
  String get weekends => '📅 Fines de semana';

  @override
  String get weekdays => '📅 Días laborables';

  @override
  String drinkLessOnWeekends(int percent) {
    return 'Bebes $percent% menos los fines de semana';
  }

  @override
  String drinkLessOnWeekdays(int percent) {
    return 'Bebes $percent% menos los días laborables';
  }

  @override
  String get positiveTrend => '📈 Tendencia positiva';

  @override
  String get positiveTrendMessage =>
      'Tu hidratación mejora hacia el final de la semana';

  @override
  String get decliningActivity => '📉 Actividad decreciente';

  @override
  String get decliningActivityMessage =>
      'El consumo de agua disminuye hacia el final de la semana';

  @override
  String get lowSalt => '⚠️ Poca sal';

  @override
  String lowSaltMessage(int days) {
    return 'Solo $days días con niveles normales de sodio';
  }

  @override
  String get frequentAlcohol => '🍺 Consumo frecuente';

  @override
  String frequentAlcoholMessage(int days) {
    return 'Alcohol $days días de 7 afecta la hidratación';
  }

  @override
  String get excellentWeek => '✅ Excelente semana';

  @override
  String get continueMessage => '¡Continúa con el buen trabajo!';

  @override
  String get all => 'Todo';

  @override
  String get addAlcohol => 'Agregar alcohol';

  @override
  String get minimumHarm => 'Daño mínimo';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml agua necesaria';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg sodio para agregar';
  }

  @override
  String get goToBedEarly => 'Acostarse temprano';

  @override
  String get todayConsumed => 'Consumido hoy:';

  @override
  String get alcoholToday => 'Alcohol hoy';

  @override
  String get beer => 'Cerveza';

  @override
  String get wine => 'Vino';

  @override
  String get spirits => 'Licores';

  @override
  String get cocktail => 'Cóctel';

  @override
  String get selectDrinkType => 'Selecciona tipo de bebida:';

  @override
  String get volume => 'Volumen (ml):';

  @override
  String get enterVolume => 'Ingresa volumen en ml';

  @override
  String get strength => 'Graduación (%):';

  @override
  String get standardDrinks => 'Bebidas estándar:';

  @override
  String get additionalWater => 'Agua adic.';

  @override
  String get additionalSodium => 'Sodio adic.';

  @override
  String get hriRisk => 'Riesgo HRI';

  @override
  String get enterValidVolume => 'Por favor ingresa un volumen válido';

  @override
  String get weeklyHistory => 'Historial semanal';

  @override
  String get weeklyHistoryDesc =>
      'Analiza tendencias semanales, insights y recomendaciones';

  @override
  String get monthlyHistory => 'Historial mensual';

  @override
  String get monthlyHistoryDesc =>
      'Patrones a largo plazo, comparación de semanas y análisis profundo';

  @override
  String get proFunction => 'Función PRO';

  @override
  String get unlockProHistory => 'Desbloquear PRO';

  @override
  String get unlimitedHistory => 'Historial ilimitado';

  @override
  String get dataExportCSV => 'Exportar datos a CSV';

  @override
  String get detailedAnalytics => 'Análisis detallado';

  @override
  String get periodComparison => 'Comparación de períodos';

  @override
  String get shareResult => 'Compartir resultado';

  @override
  String get retry => 'Reintentar';

  @override
  String get welcomeToPro => '¡Bienvenido a PRO!';

  @override
  String get allFeaturesUnlocked => 'Todas las funciones están desbloqueadas';

  @override
  String get testMode => 'Modo de prueba: Usando compra simulada';

  @override
  String get proStatusNote => 'El estado PRO persistirá hasta reiniciar la app';

  @override
  String get startUsingPro => 'Comenzar a usar PRO';

  @override
  String get lifetimeAccess => 'Acceso de por vida';

  @override
  String get bestValueAnnual => 'Mejor valor — Anual';

  @override
  String get monthly => 'Mensual';

  @override
  String get oneTime => 'una vez';

  @override
  String get perYear => '/año';

  @override
  String get perMonth => '/mes';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/mes';
  }

  @override
  String get startFreeTrial => 'Iniciar prueba gratuita de 7 días';

  @override
  String continueWithPrice(String price) {
    return 'Continuar — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Desbloquear por $price (una vez)';
  }

  @override
  String get enableFreeTrial => 'Habilitar prueba gratuita de 7 días';

  @override
  String get noChargeToday =>
      'Sin cargo hoy. Después de 7 días, tu suscripción se renueva automáticamente a menos que la canceles.';

  @override
  String get cancelAnytime =>
      'Puedes cancelar en cualquier momento en Configuración.';

  @override
  String get everythingInPro => 'Todo en PRO';

  @override
  String get smartReminders => 'Recordatorios inteligentes';

  @override
  String get smartRemindersDesc => 'Calor, entrenamientos, ayuno — sin spam.';

  @override
  String get weeklyReports => 'Informes semanales';

  @override
  String get weeklyReportsDesc => 'Insights profundos + exportación CSV.';

  @override
  String get healthIntegrations => 'Integraciones de salud';

  @override
  String get healthIntegrationsDesc => 'Apple Health y Google Fit.';

  @override
  String get alcoholProtocols => 'Protocolos de alcohol';

  @override
  String get alcoholProtocolsDesc =>
      'Preparación previa y hoja de ruta de recuperación.';

  @override
  String get fullSync => 'Sincronización completa';

  @override
  String get fullSyncDesc => 'Historial ilimitado en todos los dispositivos.';

  @override
  String get personalCalibrations => 'Calibraciones personales';

  @override
  String get personalCalibrationsDesc =>
      'Prueba de sudor, escala de color de orina.';

  @override
  String get showAllFeatures => 'Mostrar todas las funciones';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get proSubscriptionRestored => '¡Suscripción PRO restaurada!';

  @override
  String get noPurchasesToRestore => 'No se encontraron compras para restaurar';

  @override
  String get drinkMoreWaterToday => 'Bebe más agua hoy (+20%)';

  @override
  String get addElectrolytesToWater =>
      'Agrega electrolitos a cada ingesta de agua';

  @override
  String get limitCoffeeOneCup => 'Limita el café a una taza';

  @override
  String get increaseWater10 => 'Aumenta el agua en 10%';

  @override
  String get dontForgetElectrolytes => 'No olvides los electrolitos';

  @override
  String get startDayWithWater => 'Comienza el día con un vaso de agua';

  @override
  String get dontForgetElectrolytesReminder => '⚡ No olvides los electrolitos';

  @override
  String get startDayWithWaterReminder =>
      'Comienza el día con un vaso de agua para el bienestar';

  @override
  String get takeElectrolytesMorning => 'Toma electrolitos por la mañana';

  @override
  String purchaseFailed(String error) {
    return 'Compra fallida: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restauración fallida: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — confiado por 12,000 usuarios';

  @override
  String get bestValue => 'Mejor valor';

  @override
  String percentOff(int percent) {
    return '-$percent% Mejor valor';
  }

  @override
  String get weatherUnavailable => 'Clima no disponible';

  @override
  String get checkLocationPermissions =>
      'Verifica permisos de ubicación e internet';

  @override
  String get currentLocation => 'Ubicación actual';

  @override
  String get weatherClear => 'despejado';

  @override
  String get weatherCloudy => 'nublado';

  @override
  String get weatherOvercast => 'encapotado';

  @override
  String get weatherRain => 'lluvia';

  @override
  String get weatherSnow => 'nieve';

  @override
  String get weatherStorm => 'tormenta';

  @override
  String get weatherFog => 'niebla';

  @override
  String get weatherDrizzle => 'llovizna';

  @override
  String get weatherSunny => 'soleado';

  @override
  String get heatWarningExtreme => '☀️ ¡Calor extremo! Hidratación máxima';

  @override
  String get heatWarningVeryHot =>
      '🌡️ ¡Muy caluroso! Riesgo de deshidratación';

  @override
  String get heatWarningHot => '🔥 ¡Calor! Bebe más agua';

  @override
  String get heatWarningElevated => '⚠️ Temperatura elevada';

  @override
  String get heatWarningComfortable => 'Temperatura cómoda';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% agua';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg sodio';
  }

  @override
  String get heatWarningCold => '❄️ ¡Frío! Abrígate y bebe líquidos calientes';

  @override
  String get notificationChannelName => 'Recordatorios HydraCoach';

  @override
  String get notificationChannelDescription =>
      'Recordatorios de agua y electrolitos';

  @override
  String get urgentNotificationChannelName => 'Recordatorios urgentes';

  @override
  String get urgentNotificationChannelDescription =>
      'Notificaciones importantes de hidratación';

  @override
  String get goodMorning => '☀️ ¡Buenos días!';

  @override
  String get timeToHydrate => '💧 Hora de hidratarse';

  @override
  String get eveningHydration => '💧 Hidratación nocturna';

  @override
  String get dailyReportTitle => '📊 Informe diario listo';

  @override
  String get dailyReportBody => 'Ve cómo fue tu día de hidratación';

  @override
  String get maintainWaterBalance =>
      'Mantén el equilibrio hídrico durante el día';

  @override
  String get electrolytesTime =>
      'Hora de electrolitos: agrega una pizca de sal al agua';

  @override
  String catchUpHydration(int percent) {
    return 'Solo has bebido $percent% de la norma diaria. ¡Es hora de ponerse al día!';
  }

  @override
  String get excellentProgress =>
      '¡Excelente progreso! Un poco más para alcanzar la meta';

  @override
  String get postCoffeeTitle => '☕ Después del café';

  @override
  String get postCoffeeBody =>
      'Bebe 250-300 ml de agua para restaurar el equilibrio';

  @override
  String get postWorkoutTitle => '💪 Después del entrenamiento';

  @override
  String get postWorkoutBody =>
      'Restaura electrolitos: 500 ml agua + pizca de sal';

  @override
  String get heatWarningPro => '🌡️ PRO Alerta de calor';

  @override
  String get extremeHeatWarning =>
      '¡Calor extremo! Aumenta el consumo de agua en 15% y agrega 1g de sal';

  @override
  String get hotWeatherWarning =>
      '¡Calor! Bebe 10% más agua y no olvides los electrolitos';

  @override
  String get warmWeatherWarning => 'Clima cálido. Monitorea tu hidratación';

  @override
  String get alcoholRecoveryTitle => '🍺 Tiempo de recuperación';

  @override
  String get alcoholRecoveryBody =>
      'Bebe 300 ml agua con una pizca de sal para equilibrio';

  @override
  String get continueHydration => '💧 Continúa la hidratación';

  @override
  String get alcoholRecoveryBody2 =>
      'Otros 500 ml de agua te ayudarán a recuperarte más rápido';

  @override
  String get morningRecoveryTitle => '☀️ Recuperación matutina';

  @override
  String get morningRecoveryBody =>
      'Comienza el día con 500 ml agua y electrolitos';

  @override
  String get testNotificationTitle => '🧪 Notificación de prueba';

  @override
  String get testNotificationBody =>
      'Si ves esto - ¡las notificaciones instantáneas funcionan!';

  @override
  String get scheduledTestTitle => '⏰ Prueba programada (1 min)';

  @override
  String get scheduledTestBody =>
      'Esta notificación fue programada hace 1 minuto. ¡La programación funciona!';

  @override
  String get notificationServiceInitialized =>
      '✅ NotificationService inicializado';

  @override
  String get localNotificationsInitialized =>
      '✅ Notificaciones locales inicializadas';

  @override
  String get androidChannelsCreated =>
      '📢 Canales de notificación Android creados';

  @override
  String notificationsPermissionGranted(String granted) {
    return '📝 Permiso de notificaciones: $granted';
  }

  @override
  String exactAlarmsPermissionGranted(String granted) {
    return '📝 Permiso de alarmas exactas: $granted';
  }

  @override
  String fcmPermissions(String status) {
    return '📱 Permisos FCM: $status';
  }

  @override
  String get fcmTokenReceived => '🔑 Token FCM recibido';

  @override
  String fcmTokenSaved(String userId) {
    return '✅ Token FCM guardado en Firestore para usuario $userId';
  }

  @override
  String get topicSubscriptionComplete => '✅ Suscripción a tema completa';

  @override
  String foregroundMessage(String title) {
    return '📨 Mensaje en primer plano: $title';
  }

  @override
  String notificationOpened(String messageId) {
    return '📱 Notificación abierta: $messageId';
  }

  @override
  String get dailyLimitReached =>
      '⚠️ Límite diario de notificaciones alcanzado (4/día para FREE)';

  @override
  String schedulingError(String error) {
    return '❌ Error de programación de notificación: $error';
  }

  @override
  String get showingImmediatelyAsFallback =>
      'Mostrando notificación inmediatamente como respaldo';

  @override
  String instantNotificationShown(String title) {
    return '📬 Notificación instantánea mostrada: $title';
  }

  @override
  String get smartRemindersScheduled =>
      '🧠 Programando recordatorios inteligentes...';

  @override
  String smartRemindersComplete(int count) {
    return '✅ Programados $count recordatorios';
  }

  @override
  String get proPostCoffeeScheduled =>
      '☕ PRO: Recordatorio post-café programado';

  @override
  String get postWorkoutScheduled =>
      '💪 Recordatorio post-entrenamiento programado';

  @override
  String get proHeatWarningPro => '🌡️ PRO: Alerta de calor enviada';

  @override
  String get proAlcoholRecoveryPlan =>
      '🍺 PRO: Plan de recuperación de alcohol programado';

  @override
  String eveningReportScheduled(int day, int month) {
    return '📊 Informe nocturno programado para $day.$month a las 21:00';
  }

  @override
  String notificationCancelled(int id) {
    return '🚫 Notificación $id cancelada';
  }

  @override
  String get allNotificationsCancelled =>
      '🗑️ Todas las notificaciones canceladas';

  @override
  String get reminderSettingsSaved =>
      '✅ Configuración de recordatorios guardada';

  @override
  String testNotificationScheduledFor(String time) {
    return '⏰ Notificación de prueba programada para $time';
  }

  @override
  String get tomorrowRecommendations => 'Recomendaciones para mañana';

  @override
  String get recommendationExcellent =>
      '¡Excelente trabajo! Sigue así. Intenta comenzar el día con un vaso de agua y mantén un consumo equilibrado.';

  @override
  String get recommendationDiluted =>
      'Bebes mucha agua pero pocos electrolitos. Mañana agrega más sal o bebe una bebida electrolítica. Prueba comenzar el día con caldo salado.';

  @override
  String get recommendationDehydrated =>
      'No suficiente agua hoy. Mañana establece recordatorios cada 2 horas. Mantén una botella de agua a la vista.';

  @override
  String get recommendationLowSalt =>
      'Los niveles bajos de sodio pueden causar fatiga. Agrega una pizca de sal al agua o bebe caldo. Especialmente importante en keto o ayuno.';

  @override
  String get recommendationGeneral =>
      'Apunta al equilibrio entre agua y electrolitos. Bebe uniformemente durante el día y no olvides la sal en el calor.';

  @override
  String get category_water => 'Agua';

  @override
  String get category_hot_drinks => 'Bebidas calientes';

  @override
  String get category_juice => 'Jugos';

  @override
  String get category_sports => 'Deportivas';

  @override
  String get category_dairy => 'Lácteos';

  @override
  String get category_alcohol => 'Alcohol';

  @override
  String get category_supplements => 'Suplementos';

  @override
  String get category_other => 'Otros';

  @override
  String get drink_water => 'Agua';

  @override
  String get drink_sparkling_water => 'Agua con gas';

  @override
  String get drink_mineral_water => 'Agua mineral';

  @override
  String get drink_coconut_water => 'Agua de coco';

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
  String get drink_black_tea => 'Té negro';

  @override
  String get drink_green_tea => 'Té verde';

  @override
  String get drink_herbal_tea => 'Té de hierbas';

  @override
  String get drink_matcha => 'Matcha';

  @override
  String get drink_hot_chocolate => 'Chocolate caliente';

  @override
  String get drink_orange_juice => 'Jugo de naranja';

  @override
  String get drink_apple_juice => 'Jugo de manzana';

  @override
  String get drink_grapefruit_juice => 'Jugo de toronja';

  @override
  String get drink_tomato_juice => 'Jugo de tomate';

  @override
  String get drink_vegetable_juice => 'Jugo de vegetales';

  @override
  String get drink_smoothie => 'Batido';

  @override
  String get drink_lemonade => 'Limonada';

  @override
  String get drink_isotonic => 'Bebida isotónica';

  @override
  String get drink_electrolyte => 'Bebida electrolítica';

  @override
  String get drink_protein_shake => 'Batido de proteína';

  @override
  String get drink_bcaa => 'Bebida BCAA';

  @override
  String get drink_energy => 'Bebida energética';

  @override
  String get drink_milk => 'Leche';

  @override
  String get drink_kefir => 'Kéfir';

  @override
  String get drink_yogurt => 'Yogur bebible';

  @override
  String get drink_almond_milk => 'Leche de almendra';

  @override
  String get drink_soy_milk => 'Leche de soja';

  @override
  String get drink_oat_milk => 'Leche de avena';

  @override
  String get drink_beer_light => 'Cerveza ligera';

  @override
  String get drink_beer_regular => 'Cerveza regular';

  @override
  String get drink_beer_strong => 'Cerveza fuerte';

  @override
  String get drink_wine_red => 'Vino tinto';

  @override
  String get drink_wine_white => 'Vino blanco';

  @override
  String get drink_champagne => 'Champán';

  @override
  String get drink_vodka => 'Vodka';

  @override
  String get drink_whiskey => 'Whisky';

  @override
  String get drink_rum => 'Ron';

  @override
  String get drink_gin => 'Ginebra';

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
  String get drink_bone_broth => 'Caldo de hueso';

  @override
  String get drink_vegetable_broth => 'Caldo de verduras';

  @override
  String get drink_soda => 'Refresco';

  @override
  String get drink_diet_soda => 'Refresco dietético';

  @override
  String get addedToFavorites => 'Añadido a favoritos';

  @override
  String get favoriteLimitReached =>
      'Límite de favoritos alcanzado (3 para FREE, 20 para PRO)';

  @override
  String get addFavorite => 'Añadir favorito';

  @override
  String get hotAndSupplements => 'Calientes y Suplementos';

  @override
  String get quickVolumes => 'Volúmenes rápidos:';

  @override
  String get type => 'Tipo:';

  @override
  String get regular => 'Regular';

  @override
  String get coconut => 'Coco';

  @override
  String get sparkling => 'Con gas';

  @override
  String get mineral => 'Mineral';

  @override
  String get hotDrinks => 'Bebidas calientes';

  @override
  String get supplements => 'Suplementos';

  @override
  String get tea => 'Té';

  @override
  String get salt => 'Sal (1/4 cdta)';

  @override
  String get electrolyteMix => 'Mezcla de electrolitos';

  @override
  String get boneBroth => 'Caldo de hueso';

  @override
  String get favoriteAssignmentComingSoon =>
      'Asignación de favoritos próximamente';

  @override
  String get longPressToEditComingSoon =>
      'Mantén presionado para editar - próximamente';

  @override
  String get proSubscriptionRequired => 'Suscripción PRO requerida';

  @override
  String get saveToFavorites => 'Guardar en favoritos';

  @override
  String get savedToFavorites => 'Guardado en favoritos';

  @override
  String get selectFavoriteSlot => 'Seleccionar ranura de favorito';

  @override
  String get slot => 'Ranura';

  @override
  String get emptySlot => 'Ranura vacía';

  @override
  String get upgradeToUnlock => 'Actualiza a PRO para desbloquear';

  @override
  String get changeFavorite => 'Cambiar favorito';

  @override
  String get removeFavorite => 'Eliminar de favoritos';

  @override
  String get ok => 'OK';

  @override
  String get mineralWater => 'Agua mineral';

  @override
  String get coconutWater => 'Agua de coco';

  @override
  String get lemonWater => 'Agua con limón';

  @override
  String get greenTea => 'Té verde';

  @override
  String get amount => 'Cantidad';

  @override
  String get createFavoriteHint =>
      'Para agregar un favorito, vaya a cualquier pantalla de bebida a continuación y toque el botón \'Guardar en favoritos\' después de configurar su bebida.';
}
