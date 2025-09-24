// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'HydroCoach';

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
    return 'Humedad';
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
  String get welcomeTitle => 'Bienvenido a\nHydroCoach';

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
    return '$count días';
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
  String get volume => 'Volumen';

  @override
  String get enterVolume => 'Ingresa volumen en ml';

  @override
  String get strength => 'Fuerza';

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
  String get notificationChannelName => 'Recordatorios HydroCoach';

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
  String get dailyReportTitle => ' Informe diario listo';

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
  String get postCoffeeTitle => ' Después del café';

  @override
  String get postCoffeeBody =>
      'Bebe 250-300 ml de agua para restaurar el equilibrio';

  @override
  String get postWorkoutTitle => ' Después del entrenamiento';

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
  String get boneBroth => 'Caldo de huesos';

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

  @override
  String get sparklingWater => 'Agua con gas';

  @override
  String get cola => 'Cola';

  @override
  String get juice => 'Jugo';

  @override
  String get energyDrink => 'Bebida energética';

  @override
  String get sportsDrink => 'Bebida deportiva';

  @override
  String get selectElectrolyteType => 'Seleccionar tipo de electrolito:';

  @override
  String get saltQuarterTsp => 'Sal (1/4 cdta)';

  @override
  String get pinkSalt => 'Sal rosa del Himalaya';

  @override
  String get seaSalt => 'Sal marina';

  @override
  String get potassiumCitrate => 'Citrato de potasio';

  @override
  String get magnesiumGlycinate => 'Glicinato de magnesio';

  @override
  String get coconutWaterElectrolyte => 'Agua de coco';

  @override
  String get sportsDrinkElectrolyte => 'Bebida deportiva';

  @override
  String get electrolyteContent => 'Contenido de electrolitos:';

  @override
  String sodiumContent(int amount) {
    return 'Sodio: $amount mg';
  }

  @override
  String potassiumContent(int amount) {
    return 'Potasio: $amount mg';
  }

  @override
  String magnesiumContent(int amount) {
    return 'Magnesio: $amount mg';
  }

  @override
  String get servings => 'Porciones';

  @override
  String get enterServings => 'Ingrese porciones';

  @override
  String get servingsUnit => 'porciones';

  @override
  String get noElectrolytes => 'Sin electrolitos';

  @override
  String get enterValidAmount => 'Por favor ingrese una cantidad válida';

  @override
  String get lmntMix => 'Mezcla LMNT';

  @override
  String get pickleJuice => 'Jugo de pepinillos';

  @override
  String get tomatoSalt => 'Tomate + sal';

  @override
  String get ketorade => 'Ketorade';

  @override
  String get alkalineWater => 'Agua alcalina';

  @override
  String get celticSalt => 'Sal celta';

  @override
  String get soleWater => 'Agua de sol';

  @override
  String get mineralDrops => 'Gotas minerales';

  @override
  String get bakingSoda => 'Agua con bicarbonato';

  @override
  String get creamTartar => 'Crémor tártaro';

  @override
  String get selectSupplementType => 'Seleccionar tipo de suplemento:';

  @override
  String get multivitamin => 'Multivitamínico';

  @override
  String get magnesiumCitrate => 'Citrato de magnesio';

  @override
  String get magnesiumThreonate => 'L-treonato de magnesio';

  @override
  String get calciumCitrate => 'Citrato de calcio';

  @override
  String get zincGlycinate => 'Glicinato de zinc';

  @override
  String get vitaminD3 => 'Vitamina D3';

  @override
  String get vitaminC => 'Vitamina C';

  @override
  String get bComplex => 'Complejo B';

  @override
  String get omega3 => 'Omega-3';

  @override
  String get ironBisglycinate => 'Bisglicinato de hierro';

  @override
  String get dosage => 'Dosificación';

  @override
  String get enterDosage => 'Ingrese la dosis';

  @override
  String get noElectrolyteContent => 'Sin electrolitos';

  @override
  String get blackTea => 'Té Negro';

  @override
  String get herbalTea => 'Té de Hierbas';

  @override
  String get espresso => 'Espresso';

  @override
  String get cappuccino => 'Cappuccino';

  @override
  String get latte => 'Latte';

  @override
  String get matcha => 'Matcha';

  @override
  String get hotChocolate => 'Chocolate Caliente';

  @override
  String get caffeine => 'Cafeína';

  @override
  String get sports => 'Deportes';

  @override
  String get walking => 'Caminar';

  @override
  String get running => 'Correr';

  @override
  String get gym => 'Gimnasio';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get swimming => 'Natación';

  @override
  String get yoga => 'Yoga';

  @override
  String get hiit => 'HIIT';

  @override
  String get crossfit => 'CrossFit';

  @override
  String get boxing => 'Boxeo';

  @override
  String get dancing => 'Baile';

  @override
  String get tennis => 'Tenis';

  @override
  String get teamSports => 'Deportes de equipo';

  @override
  String get selectActivityType => 'Seleccionar tipo de actividad:';

  @override
  String get duration => 'Duración';

  @override
  String get minutes => 'minutos';

  @override
  String get enterDuration => 'Ingrese duración';

  @override
  String get lowIntensity => 'Intensidad baja';

  @override
  String get mediumIntensity => 'Intensidad media';

  @override
  String get highIntensity => 'Intensidad alta';

  @override
  String get recommendedIntake => 'Ingesta recomendada:';

  @override
  String get basedOnWeight => 'Basado en peso';

  @override
  String get logActivity => 'Registrar actividad';

  @override
  String get activityLogged => 'Actividad registrada';

  @override
  String get enterValidDuration => 'Ingrese una duración válida';

  @override
  String get sauna => 'Sauna';

  @override
  String get veryHighIntensity => 'Intensidad muy alta';

  @override
  String get hriStatusExcellent => 'Excelente';

  @override
  String get hriStatusGood => 'Bueno';

  @override
  String get hriStatusModerate => 'Riesgo Moderado';

  @override
  String get hriStatusHighRisk => 'Riesgo Alto';

  @override
  String get hriStatusCritical => 'Crítico';

  @override
  String get hriComponentWater => 'Balance de agua';

  @override
  String get hriComponentSodium => 'Nivel de sodio';

  @override
  String get hriComponentPotassium => 'Nivel de potasio';

  @override
  String get hriComponentMagnesium => 'Nivel de magnesio';

  @override
  String get hriComponentHeat => 'Estrés por calor';

  @override
  String get hriComponentWorkout => 'Actividad física';

  @override
  String get hriComponentCaffeine => 'Impacto de cafeína';

  @override
  String get hriComponentAlcohol => 'Impacto de alcohol';

  @override
  String get hriComponentTime => 'Tiempo desde ingesta';

  @override
  String get hriComponentMorning => 'Factores matutinos';

  @override
  String get hriBreakdownTitle => 'Desglose de factores de riesgo';

  @override
  String hriComponentValue(Object component, Object max, Object value) {
    return '$component: $value/$max pts';
  }

  @override
  String get fastingModeActive => 'Modo ayuno activo';

  @override
  String get fastingSuppressionNote => 'Factor tiempo suprimido durante ayuno';

  @override
  String get morningCheckInTitle => 'Chequeo Matutino';

  @override
  String get howAreYouFeeling => '¿Cómo te sientes?';

  @override
  String get feelingScale1 => 'Mal';

  @override
  String get feelingScale2 => 'Por debajo del promedio';

  @override
  String get feelingScale3 => 'Normal';

  @override
  String get feelingScale4 => 'Bien';

  @override
  String get feelingScale5 => 'Excelente';

  @override
  String get weightChange => 'Cambio de peso desde ayer';

  @override
  String get urineColorScale => 'Color de orina (escala 1-8)';

  @override
  String get urineColor1 => '1 - Muy pálido';

  @override
  String get urineColor2 => '2 - Pálido';

  @override
  String get urineColor3 => '3 - Amarillo claro';

  @override
  String get urineColor4 => '4 - Amarillo';

  @override
  String get urineColor5 => '5 - Amarillo oscuro';

  @override
  String get urineColor6 => '6 - Ámbar';

  @override
  String get urineColor7 => '7 - Ámbar oscuro';

  @override
  String get urineColor8 => '8 - Marrón';

  @override
  String get alcoholWithDecay => 'Impacto de alcohol (decayendo)';

  @override
  String standardDrinksToday(Object count) {
    return 'Bebidas estándar hoy: $count';
  }

  @override
  String activeCaffeineLevel(Object amount) {
    return 'Cafeína activa: $amount mg';
  }

  @override
  String get hriDebugInfo => 'Info Depuración HRI';

  @override
  String hriNormalized(Object value) {
    return 'HRI (normalizado): $value/100';
  }

  @override
  String get fastingWindowActive => 'Ventana de ayuno activa';

  @override
  String get eatingWindowActive => 'Ventana de alimentación activa';

  @override
  String nextFastingWindow(Object time) {
    return 'Próximo ayuno: $time';
  }

  @override
  String nextEatingWindow(Object time) {
    return 'Próxima comida: $time';
  }

  @override
  String get todaysWorkouts => 'Entrenamientos de hoy';

  @override
  String get hoursAgo => 'h atrás';

  @override
  String get onboardingWelcomeTitle =>
      'HydroCoach — hidratación inteligente cada día';

  @override
  String get onboardingWelcomeSubtitle =>
      'Bebe de forma más inteligente, no más\nLa app considera el clima, electrolitos y tus hábitos\nAyuda a mantener mente clara y energía estable';

  @override
  String get onboardingBullet1 =>
      'Norma personal de agua y sales según el clima y tú';

  @override
  String get onboardingBullet2 =>
      'Consejos de «qué hacer ahora» en lugar de gráficos vacíos';

  @override
  String get onboardingBullet3 =>
      'Alcohol en dosis estándar con límites seguros';

  @override
  String get onboardingBullet4 => 'Recordatorios inteligentes sin spam';

  @override
  String get onboardingStartButton => 'Comenzar';

  @override
  String get onboardingHaveAccount => 'Ya tengo una cuenta';

  @override
  String get onboardingPracticeFasting => 'Practico ayuno intermitente';

  @override
  String get onboardingPracticeFastingDesc =>
      'Régimen especial de electrolitos para ventanas de ayuno';

  @override
  String get onboardingProfileReady => '¡Perfil listo!';

  @override
  String get onboardingWaterNorm => 'Norma de agua';

  @override
  String get onboardingIonWillHelp =>
      'ION te ayudará a mantener el equilibrio cada día';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingLocationTitle => 'El clima importa para la hidratación';

  @override
  String get onboardingLocationSubtitle =>
      'Consideraremos el clima y la humedad. Es más preciso que solo una fórmula por peso';

  @override
  String get onboardingWeatherExample => '¡Hoy hace calor! +15% de agua';

  @override
  String get onboardingWeatherExampleDesc => '+500 mg de sodio por el calor';

  @override
  String get onboardingEnablePermission => 'Activar';

  @override
  String get onboardingEnableLater => 'Activar más tarde';

  @override
  String get onboardingNotificationTitle => 'Recordatorios inteligentes';

  @override
  String get onboardingNotificationSubtitle =>
      'Consejos breves en el momento justo. Puedes cambiar la frecuencia con un toque';

  @override
  String get onboardingNotifExample1 => 'Hora de hidratarse';

  @override
  String get onboardingNotifExample2 => 'No olvides los electrolitos';

  @override
  String get onboardingNotifExample3 => '¡Calor! Bebe más agua';

  @override
  String get sportRecoveryProtocols => 'Protocolos de recuperación deportiva';

  @override
  String get allDrinksAndSupplements => 'Todas las bebidas y suplementos';

  @override
  String get notificationChannelDefault => 'Recordatorios de hidratación';

  @override
  String get notificationChannelDefaultDesc =>
      'Recordatorios de agua y electrolitos';

  @override
  String get notificationChannelUrgent => 'Notificaciones importantes';

  @override
  String get notificationChannelUrgentDesc =>
      'Alertas de calor y estados críticos';

  @override
  String get notificationChannelReport => 'Informes';

  @override
  String get notificationChannelReportDesc => 'Informes diarios y semanales';

  @override
  String get notificationWaterTitle => '💧 Hora de hidratarse';

  @override
  String get notificationWaterBody => 'No olvides beber agua';

  @override
  String get notificationPostCoffeeTitle => '☕ Después del café';

  @override
  String get notificationPostCoffeeBody =>
      'Bebe 250-300 ml de agua para restaurar el equilibrio';

  @override
  String get notificationDailyReportTitle => '📊 Informe diario listo';

  @override
  String get notificationDailyReportBody => 'Ve cómo fue tu día de hidratación';

  @override
  String get notificationAlcoholCounterTitle => '🍺 Tiempo de recuperación';

  @override
  String notificationAlcoholCounterBody(int ml) {
    return 'Bebe $ml ml de agua con una pizca de sal';
  }

  @override
  String get notificationHeatWarningTitle => '🌡️ Alerta de calor';

  @override
  String get notificationHeatWarningExtremeBody =>
      '¡Calor extremo! +15% agua y +1g sal';

  @override
  String get notificationHeatWarningHotBody =>
      '¡Calor! +10% agua y electrolitos';

  @override
  String get notificationHeatWarningWarmBody =>
      'Cálido. Monitorea tu hidratación';

  @override
  String get notificationWorkoutTitle => '💪 Entrenamiento';

  @override
  String get notificationWorkoutBody => 'No olvides agua y electrolitos';

  @override
  String get notificationPostWorkoutTitle => '💪 Después del entrenamiento';

  @override
  String get notificationPostWorkoutBody =>
      '500 ml agua + electrolitos para recuperación';

  @override
  String get notificationFastingElectrolyteTitle => '⚡ Hora de electrolitos';

  @override
  String get notificationFastingElectrolyteBody =>
      'Agrega una pizca de sal al agua o bebe caldo';

  @override
  String notificationAlcoholRecoveryStepTitle(int hours) {
    return '💧 Recuperación ${hours}h';
  }

  @override
  String notificationAlcoholRecoveryStepBody(int ml) {
    return 'Bebe $ml ml de agua';
  }

  @override
  String get notificationAlcoholRecoveryMidBody =>
      'Agrega electrolitos: Na/K/Mg';

  @override
  String get notificationAlcoholRecoveryFinalBody =>
      'Mañana por la mañana - chequeo de control';

  @override
  String get notificationMorningCheckInTitle => '☀️ Chequeo matutino';

  @override
  String get notificationMorningCheckInBody =>
      '¿Cómo te sientes? Evalúa tu estado y obtén un plan para el día';

  @override
  String get notificationMorningWaterBody =>
      'Comienza tu día con un vaso de agua';

  @override
  String notificationLowProgressBody(int percent) {
    return 'Solo has bebido $percent% de la norma. ¡Es hora de ponerse al día!';
  }

  @override
  String get notificationGoodProgressBody => '¡Excelente progreso! Continúa';

  @override
  String get notificationMaintainBalanceBody => 'Mantén el equilibrio hídrico';

  @override
  String get notificationTestTitle => '🧪 Notificación de prueba';

  @override
  String get notificationTestBody =>
      'Si ves esto, ¡las notificaciones funcionan!';

  @override
  String get notificationTestScheduledTitle => '⏰ Prueba programada';

  @override
  String get notificationTestScheduledBody =>
      'Esta notificación fue programada hace un minuto';

  @override
  String get onboardingUnitsTitle => 'Elige tus unidades';

  @override
  String get onboardingUnitsSubtitle => 'No podrás cambiarlo más tarde';

  @override
  String get onboardingUnitsWarning =>
      'Esta elección es permanente y no se puede cambiar después';

  @override
  String get oz => 'oz';

  @override
  String get fl_oz => 'fl oz';

  @override
  String get gallons => 'galones';

  @override
  String get lb => 'lb';

  @override
  String get target => 'Objetivo';

  @override
  String get wind => 'Viento';

  @override
  String get pressure => 'Presión';

  @override
  String get highHeatIndexWarning =>
      '¡Índice de calor alto! Aumente su consumo de agua';

  @override
  String get weatherCondition => 'Condición';

  @override
  String get feelsLike => 'Sensación';

  @override
  String get humidityLabel => 'Humedad';

  @override
  String get waterNormal => 'Normal';

  @override
  String get sodiumNormal => 'Estándar';

  @override
  String get addedSuccessfully => 'Añadido con éxito';

  @override
  String get sugarIntake => 'Consumo de azúcar';

  @override
  String get sugarToday => 'Azúcar de hoy';

  @override
  String get totalSugar => 'Azúcar total';

  @override
  String get dailyLimit => 'Límite diario';

  @override
  String get addedSugar => 'Azúcar añadido';

  @override
  String get naturalSugar => 'Azúcar natural';

  @override
  String get hiddenSugar => 'Azúcar oculto';

  @override
  String get sugarFromDrinks => 'Bebidas';

  @override
  String get sugarFromFood => 'Comida';

  @override
  String get sugarFromSnacks => 'Snacks';

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
      '¡Excelente! Tu consumo de azúcar está dentro de los límites saludables';

  @override
  String get sugarRecommendationModerate =>
      'Considera reducir las bebidas y snacks dulces';

  @override
  String get sugarRecommendationHigh =>
      '¡Alto consumo de azúcar! Limita las bebidas dulces y postres';

  @override
  String get sugarRecommendationCritical =>
      '¡Demasiado azúcar! Evita bebidas y dulces hoy';

  @override
  String get noSugarIntake => 'No se ha registrado azúcar hoy';

  @override
  String get hriImpact => 'Impacto en HRI';

  @override
  String get hri_component_sugar => 'Azúcar';

  @override
  String get hri_sugar_description =>
      'El alto consumo de azúcar afecta la hidratación y la salud';

  @override
  String get tip_reduce_sweet_drinks =>
      'Reemplaza las bebidas dulces con agua o té sin azúcar';

  @override
  String get tip_avoid_added_sugar =>
      'Revisa las etiquetas y evita productos con azúcares añadidos';

  @override
  String get tip_check_labels =>
      'Cuidado con los azúcares ocultos en salsas y alimentos procesados';

  @override
  String get tip_replace_soda =>
      'Reemplaza los refrescos con agua con gas y limón';

  @override
  String get sugarSources => 'Fuentes de azúcar';

  @override
  String get drinks => 'Bebidas';

  @override
  String get food => 'Comida';

  @override
  String get snacks => 'Snacks';

  @override
  String get recommendedLimit => 'Recomendado';

  @override
  String get points => 'puntos';

  @override
  String get drinkLightBeer => 'Cerveza Light';

  @override
  String get drinkLager => 'Lager';

  @override
  String get drinkIPA => 'IPA';

  @override
  String get drinkStout => 'Stout';

  @override
  String get drinkWheatBeer => 'Cerveza de Trigo';

  @override
  String get drinkCraftBeer => 'Cerveza Artesanal';

  @override
  String get drinkNonAlcoholic => 'Sin Alcohol';

  @override
  String get drinkRadler => 'Radler';

  @override
  String get drinkPilsner => 'Pilsner';

  @override
  String get drinkRedWine => 'Vino Tinto';

  @override
  String get drinkWhiteWine => 'Vino Blanco';

  @override
  String get drinkProsecco => 'Prosecco';

  @override
  String get drinkPort => 'Oporto';

  @override
  String get drinkRose => 'Rosado';

  @override
  String get drinkDessertWine => 'Vino de Postre';

  @override
  String get drinkSangria => 'Sangría';

  @override
  String get drinkSherry => 'Jerez';

  @override
  String get drinkVodkaShot => 'Chupito de Vodka';

  @override
  String get drinkCognac => 'Coñac';

  @override
  String get drinkLiqueur => 'Licor';

  @override
  String get drinkAbsinthe => 'Absenta';

  @override
  String get drinkBrandy => 'Brandy';

  @override
  String get drinkLongIsland => 'Long Island';

  @override
  String get drinkGinTonic => 'Gin Tonic';

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
    return '$type populares';
  }

  @override
  String get standardDrinksUnit => 'TE';

  @override
  String get gramsSugar => 'g azúcar';

  @override
  String get moderateConsumption => 'Consumo moderado';

  @override
  String get aboveRecommendations => 'Por encima de las recomendaciones';

  @override
  String get highConsumption => 'Consumo alto';

  @override
  String get veryHighConsider => 'Muy alto - considera parar';

  @override
  String get noAlcoholToday => 'Sin alcohol hoy';

  @override
  String get drinkWaterNow => 'Bebe 300-500 ml de agua ahora';

  @override
  String get addPinchSalt => 'Añade una pizca de sal';

  @override
  String get avoidLateCoffee => 'Evita el café tarde';

  @override
  String abvPercent(Object percent) {
    return '$percent% alc.';
  }

  @override
  String get todaysElectrolytes => 'Electrolitos de hoy';

  @override
  String get greatBalance => '¡Gran balance!';

  @override
  String get gettingThere => 'Casi ahí';

  @override
  String get needMoreElectrolytes => 'Necesitas más electrolitos';

  @override
  String get lowElectrolyteLevels => 'Niveles bajos de electrolitos';

  @override
  String get electrolyteTips => 'Consejos de Electrolitos';

  @override
  String get takeWithWater => 'Tomar con mucha agua';

  @override
  String get bestBetweenMeals => 'Mejor absorción entre comidas';

  @override
  String get startSmallAmounts => 'Empieza con cantidades pequeñas';

  @override
  String get extraDuringExercise => 'Extra necesario durante el ejercicio';

  @override
  String get electrolytesBasic => 'Básico';

  @override
  String get electrolytesMixes => 'Mezclas';

  @override
  String get electrolytesPills => 'Pastillas';

  @override
  String get popularSalts => 'Sales y Caldos Populares';

  @override
  String get popularMixes => 'Mezclas de Electrolitos Populares';

  @override
  String get popularSupplements => 'Suplementos Populares';

  @override
  String get electrolyteSaltWater => 'Agua con Sal';

  @override
  String get electrolytePinkSalt => 'Sal Rosa';

  @override
  String get electrolyteSeaSalt => 'Sal Marina';

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
  String get electrolytePotassiumChloride => 'Cloruro de Potasio';

  @override
  String get electrolyteMagThreonate => 'Treonato de Magnesio';

  @override
  String get electrolyteTraceMinerals => 'Minerales Traza';

  @override
  String get electrolyteZMAComplex => 'Complejo ZMA';

  @override
  String get electrolyteMultiMineral => 'Multimineral';

  @override
  String get electrolyteLMNT => 'LMNT';

  @override
  String get hydration => 'Hidratación';

  @override
  String get todayHydration => 'Hidratación de hoy';

  @override
  String get currentIntake => 'Consumido';

  @override
  String get dailyGoal => 'Meta';

  @override
  String get toGo => 'Restante';

  @override
  String get goalReached => '¡Meta alcanzada!';

  @override
  String get almostThere => '¡Casi llegas!';

  @override
  String get halfwayThere => 'A mitad de camino';

  @override
  String get keepGoing => '¡Sigue así!';

  @override
  String get startDrinking => 'Empieza a beber';

  @override
  String get plainWater => 'Simple';

  @override
  String get enhancedWater => 'Mejorada';

  @override
  String get beverages => 'Bebidas';

  @override
  String get sodas => 'Refrescos';

  @override
  String get popularPlainWater => 'Tipos de agua populares';

  @override
  String get popularEnhancedWater => 'Agua mejorada e infusionada';

  @override
  String get popularBeverages => 'Bebidas populares';

  @override
  String get popularSodas => 'Refrescos y energéticas';

  @override
  String get hydrationTips => 'Consejos de hidratación';

  @override
  String get drinkRegularly => 'Bebe pequeñas cantidades regularmente';

  @override
  String get roomTemperature =>
      'El agua a temperatura ambiente se absorbe mejor';

  @override
  String get addLemon => 'Añade limón para mejor sabor';

  @override
  String get limitSugary => 'Limita las bebidas azucaradas - deshidratan';

  @override
  String get warmWater => 'Agua tibia';

  @override
  String get iceWater => 'Agua helada';

  @override
  String get filteredWater => 'Agua filtrada';

  @override
  String get distilledWater => 'Agua destilada';

  @override
  String get springWater => 'Agua de manantial';

  @override
  String get hydrogenWater => 'Agua hidrogenada';

  @override
  String get oxygenatedWater => 'Agua oxigenada';

  @override
  String get cucumberWater => 'Agua de pepino';

  @override
  String get limeWater => 'Agua de lima';

  @override
  String get berryWater => 'Agua de bayas';

  @override
  String get mintWater => 'Agua de menta';

  @override
  String get gingerWater => 'Agua de jengibre';

  @override
  String get caffeineStatusNone => 'Sin cafeína hoy';

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
    return 'Muy alto: ${amount}mg!';
  }

  @override
  String get caffeineDailyLimit => 'Límite diario: 400mg';

  @override
  String get caffeineWarningTitle => 'Advertencia de cafeína';

  @override
  String get caffeineWarning400 => 'Has excedido 400mg de cafeína hoy';

  @override
  String get caffeineTipWater => 'Bebe agua extra para compensar';

  @override
  String get caffeineTipAvoid => 'Evita más cafeína hoy';

  @override
  String get caffeineTipSleep => 'Puede afectar tu calidad de sueño';

  @override
  String get total => 'total';

  @override
  String get cupsToday => 'Tazas hoy';

  @override
  String get metabolizeTime => 'Tiempo para metabolizar';

  @override
  String get aboutCaffeine => 'Acerca de la cafeína';

  @override
  String get caffeineInfo1 =>
      'El café contiene cafeína natural que aumenta el estado de alerta';

  @override
  String get caffeineInfo2 =>
      'El límite diario seguro es 400mg para la mayoría de adultos';

  @override
  String get caffeineInfo3 => 'La vida media de la cafeína es de 5-6 horas';

  @override
  String get caffeineInfo4 =>
      'Bebe agua extra para compensar el efecto diurético';

  @override
  String get caffeineWarningPregnant =>
      'Las mujeres embarazadas deben limitar la cafeína a 200mg/día';

  @override
  String get gotIt => 'Entendido';

  @override
  String get consumed => 'Consumido';

  @override
  String get remaining => 'restante';

  @override
  String get todaysCaffeine => 'Cafeína de hoy';

  @override
  String get alreadyInFavorites => 'Ya está en favoritos';

  @override
  String get ofRecommendedLimit => 'of recommended limit';

  @override
  String get aboutAlcohol => 'Acerca del Alcohol';

  @override
  String get alcoholInfo1 =>
      'Una bebida estándar equivale a 10g de alcohol puro';

  @override
  String get alcoholInfo2 =>
      'El alcohol deshidrata — bebe 250ml extra de agua por bebida';

  @override
  String get alcoholInfo3 =>
      'Añade sodio para ayudar a retener líquidos después de beber';

  @override
  String get alcoholInfo4 =>
      'Cada bebida estándar aumenta el HRI en 3-5 puntos';

  @override
  String get alcoholWarningHealth =>
      'El consumo excesivo de alcohol es perjudicial para la salud. El límite recomendado es 2 BE para hombres y 1 BE para mujeres al día.';

  @override
  String get supplementsInfo1 =>
      'Los suplementos ayudan a mantener el equilibrio de electrolitos';

  @override
  String get supplementsInfo2 => 'Mejor tomar con las comidas para absorción';

  @override
  String get supplementsInfo3 => 'Siempre tome con abundante agua';

  @override
  String get supplementsInfo4 =>
      'Magnesio y potasio son clave para la hidratación';

  @override
  String get supplementsWarning =>
      'Consulte con su médico antes de comenzar cualquier régimen de suplementos';

  @override
  String get fromSupplementsToday => 'De suplementos hoy';

  @override
  String get minerals => 'Minerales';

  @override
  String get vitamins => 'Vitaminas';

  @override
  String get essentialMinerals => 'Minerales esenciales';

  @override
  String get otherSupplements => 'Otros suplementos';

  @override
  String get supplementTip1 =>
      'Tome suplementos con comida para mejor absorción';

  @override
  String get supplementTip2 => 'Beba mucha agua con suplementos';

  @override
  String get supplementTip3 => 'Espacie los suplementos durante el día';

  @override
  String get supplementTip4 => 'Registre lo que funciona para usted';

  @override
  String get calciumCarbonate => 'Carbonato de Calcio';

  @override
  String get traceMinerals => 'Minerales Traza';

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
  String get selectCardioActivity => 'Seleccionar actividad cardio';

  @override
  String get selectStrengthActivity => 'Seleccionar entrenamiento de fuerza';

  @override
  String get selectSportsActivity => 'Seleccionar deporte';

  @override
  String get sessions => 'sesiones';

  @override
  String get totalTime => 'Tiempo total';

  @override
  String get waterLoss => 'Pérdida de agua';

  @override
  String get intensity => 'Intensidad';

  @override
  String get drinkWaterAfterWorkout => 'Bebe agua después del entrenamiento';

  @override
  String get replenishElectrolytes => 'Reponer electrolitos';

  @override
  String get restAndRecover => 'Descansar y recuperarse';

  @override
  String get avoidSugaryDrinks => 'Evitar bebidas deportivas azucaradas';

  @override
  String get elliptical => 'Elíptica';

  @override
  String get rowing => 'Remo';

  @override
  String get jumpRope => 'Saltar la cuerda';

  @override
  String get stairClimbing => 'Subir escaleras';

  @override
  String get bodyweight => 'Peso corporal';

  @override
  String get powerlifting => 'Powerlifting';

  @override
  String get calisthenics => 'Calistenia';

  @override
  String get resistanceBands => 'Bandas de resistencia';

  @override
  String get kettlebell => 'Pesas rusas';

  @override
  String get trx => 'TRX';

  @override
  String get strongman => 'Hombre fuerte';

  @override
  String get pilates => 'Pilates';

  @override
  String get basketball => 'Baloncesto';

  @override
  String get soccerFootball => 'Fútbol';

  @override
  String get golf => 'Golf';

  @override
  String get martialArts => 'Artes marciales';

  @override
  String get rockClimbing => 'Escalada en roca';

  @override
  String get needsToReplenish => 'Necesita reponer';

  @override
  String get electrolyteTrackingPro =>
      'Rastrea los objetivos de sodio, potasio y magnesio con barras de progreso detalladas';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get weather => 'Clima';

  @override
  String get weatherTrackingPro =>
      'Rastrea el índice de calor, humedad e impacto del clima en los objetivos de hidratación';

  @override
  String get sugarTracking => 'Seguimiento de Azúcar';

  @override
  String get sugarTrackingPro =>
      'Monitorea la ingesta de azúcar natural, añadido y oculto con análisis de impacto HRI';

  @override
  String get dayOverview => 'Resumen del día';

  @override
  String get tapForDetails => 'Toca para detalles';

  @override
  String get noDataForDay => 'Sin datos para este día';

  @override
  String get sweatLoss => 'pérdida de sudor';

  @override
  String get cardio => 'Cardio';

  @override
  String get workout => 'Ejercicio';

  @override
  String get noWaterToday => 'No se registró agua hoy';

  @override
  String get noElectrolytesToday => 'No se registraron electrolitos hoy';

  @override
  String get noCoffeeToday => 'No se registró café hoy';

  @override
  String get noWorkoutsToday => 'No se registraron ejercicios hoy';

  @override
  String get noWaterThisDay => 'No se registró agua este día';

  @override
  String get noElectrolytesThisDay => 'No se registraron electrolitos este día';

  @override
  String get noCoffeeThisDay => 'No se registró café este día';

  @override
  String get noWorkoutsThisDay => 'No se registraron ejercicios este día';

  @override
  String get weeklyReport => 'Reporte Semanal';

  @override
  String get weeklyReportSubtitle => 'Análisis profundo de tendencias';

  @override
  String get workouts => 'Entrenamientos';

  @override
  String get workoutHydration => 'Hidratación en entrenamientos';

  @override
  String workoutHydrationMessage(Object percent) {
    return 'En días de entrenamiento bebes $percent% más agua';
  }

  @override
  String get weeklyActivity => 'Actividad Semanal';

  @override
  String weeklyActivityMessage(Object days, Object minutes) {
    return 'Entrenaste $minutes minutos en $days días';
  }

  @override
  String get workoutMinutesPerDay => 'Minutos de entrenamiento por día';

  @override
  String get daysWithWorkouts => 'días con entrenamientos';

  @override
  String get noWorkoutsThisWeek => 'Sin entrenamientos esta semana';

  @override
  String get noAlcoholThisWeek => 'Sin alcohol esta semana';

  @override
  String get csvExported => 'Datos exportados a CSV';

  @override
  String get mondayShort => 'LUN';

  @override
  String get tuesdayShort => 'MAR';

  @override
  String get wednesdayShort => 'MIÉ';

  @override
  String get thursdayShort => 'JUE';

  @override
  String get fridayShort => 'VIE';

  @override
  String get saturdayShort => 'SÁB';

  @override
  String get sundayShort => 'DOM';

  @override
  String get achievements => 'Logros';

  @override
  String get achievementsTabAll => 'Todos';

  @override
  String get achievementsTabHydration => 'Hidratación';

  @override
  String get achievementsTabElectrolytes => 'Electrolitos';

  @override
  String get achievementsTabSugar => 'Control Azúcar';

  @override
  String get achievementsTabAlcohol => 'Alcohol';

  @override
  String get achievementsTabWorkout => 'Ejercicio';

  @override
  String get achievementsTabHRI => 'HRI';

  @override
  String get achievementsTabStreaks => 'Rachas';

  @override
  String get achievementsTabSpecial => 'Especiales';

  @override
  String get achievementUnlocked => '¡Logro desbloqueado!';

  @override
  String get achievementProgress => 'Progreso';

  @override
  String get achievementPoints => 'puntos';

  @override
  String get achievementRarityCommon => 'Común';

  @override
  String get achievementRarityUncommon => 'Poco común';

  @override
  String get achievementRarityRare => 'Raro';

  @override
  String get achievementRarityEpic => 'Épico';

  @override
  String get achievementRarityLegendary => 'Legendario';

  @override
  String get achievementStatsUnlocked => 'Desbloqueados';

  @override
  String get achievementStatsTotal => 'Puntos totales';

  @override
  String get achievementFilterAll => 'Todos';

  @override
  String get achievementFilterUnlocked => 'Desbloqueados';

  @override
  String get achievementSortProgress => 'Progreso';

  @override
  String get achievementSortName => 'Nombre';

  @override
  String get achievementSortRarity => 'Rareza';

  @override
  String get achievementNoAchievements => 'Aún no hay logros';

  @override
  String get achievementKeepUsing =>
      '¡Sigue usando la app para desbloquear logros!';

  @override
  String get achievementFirstGlass => 'Primera gota';

  @override
  String get achievementFirstGlassDesc => 'Bebe tu primer vaso de agua';

  @override
  String get achievementHydrationGoal1 => 'Hidratado';

  @override
  String get achievementHydrationGoal1Desc => 'Alcanza tu meta diaria de agua';

  @override
  String get achievementHydrationGoal7 => 'Semana de hidratación';

  @override
  String get achievementHydrationGoal7Desc =>
      'Alcanza la meta de agua 7 días seguidos';

  @override
  String get achievementHydrationGoal30 => 'Maestro de hidratación';

  @override
  String get achievementHydrationGoal30Desc =>
      'Alcanza la meta de agua 30 días seguidos';

  @override
  String get achievementPerfectHydration => 'Equilibrio perfecto';

  @override
  String get achievementPerfectHydrationDesc =>
      'Logra 90-110% de tu meta de agua';

  @override
  String get achievementEarlyBird => 'Madrugador';

  @override
  String get achievementEarlyBirdDesc =>
      'Bebe tu primera agua antes de las 9 AM';

  @override
  String achievementEarlyBirdTemplate(String volume) {
    return 'Bebe $volume antes de las 9 AM';
  }

  @override
  String get achievementNightOwl => 'Búho nocturno';

  @override
  String get achievementNightOwlDesc =>
      'Completa la meta de hidratación antes de las 6 PM';

  @override
  String get achievementLiterLegend => 'Leyenda de litros';

  @override
  String get achievementLiterLegendDesc =>
      'Alcanza tu hito total de hidratación';

  @override
  String achievementLiterLegendTemplate(String volume) {
    return 'Bebe $volume en total';
  }

  @override
  String get achievementSaltStarter => 'Iniciado en sal';

  @override
  String get achievementSaltStarterDesc => 'Añade tus primeros electrolitos';

  @override
  String get achievementElectrolyteBalance => 'Equilibrado';

  @override
  String get achievementElectrolyteBalanceDesc =>
      'Alcanza todas las metas de electrolitos en un día';

  @override
  String get achievementSodiumMaster => 'Maestro del sodio';

  @override
  String get achievementSodiumMasterDesc =>
      'Alcanza la meta de sodio 7 días seguidos';

  @override
  String get achievementPotassiumPro => 'Pro del potasio';

  @override
  String get achievementPotassiumProDesc =>
      'Alcanza la meta de potasio 7 días seguidos';

  @override
  String get achievementMagnesiumMaven => 'Experto en magnesio';

  @override
  String get achievementMagnesiumMavenDesc =>
      'Alcanza la meta de magnesio 7 días seguidos';

  @override
  String get achievementElectrolyteExpert => 'Experto en electrolitos';

  @override
  String get achievementElectrolyteExpertDesc =>
      'Equilibrio perfecto de electrolitos por 30 días';

  @override
  String get achievementSugarAwareness => 'Conciencia del azúcar';

  @override
  String get achievementSugarAwarenessDesc => 'Rastrea azúcar por primera vez';

  @override
  String get achievementSugarUnder25 => 'Control dulce';

  @override
  String get achievementSugarUnder25Desc =>
      'Mantén el consumo de azúcar bajo por un día';

  @override
  String achievementSugarUnder25Template(String weight) {
    return 'Mantén el azúcar bajo $weight por un día';
  }

  @override
  String get achievementSugarWeekControl => 'Disciplina azucarera';

  @override
  String get achievementSugarWeekControlDesc =>
      'Mantén bajo consumo de azúcar por una semana';

  @override
  String achievementSugarWeekControlTemplate(String weight) {
    return 'Mantén el azúcar bajo $weight por 7 días';
  }

  @override
  String get achievementSugarFreeDay => 'Sin azúcar';

  @override
  String get achievementSugarFreeDayDesc =>
      'Completa un día con 0g de azúcar añadida';

  @override
  String get achievementSugarDetective => 'Detective del azúcar';

  @override
  String get achievementSugarDetectiveDesc =>
      'Rastrea azúcares ocultos 10 veces';

  @override
  String get achievementSugarMaster => 'Maestro del azúcar';

  @override
  String get achievementSugarMasterDesc =>
      'Mantén consumo muy bajo de azúcar por un mes';

  @override
  String get achievementNoSodaWeek => 'Semana sin refresco';

  @override
  String get achievementNoSodaWeekDesc => 'Sin refrescos por 7 días';

  @override
  String get achievementNoSodaMonth => 'Mes sin refresco';

  @override
  String get achievementNoSodaMonthDesc => 'Sin refrescos por 30 días';

  @override
  String get achievementSweetToothTamed => 'Goloso domesticado';

  @override
  String get achievementSweetToothTamedDesc =>
      'Reduce el azúcar diario 50% por una semana';

  @override
  String get achievementAlcoholTracker => 'Conciencia';

  @override
  String get achievementAlcoholTrackerDesc => 'Rastrea el consumo de alcohol';

  @override
  String get achievementModerateDay => 'Moderación';

  @override
  String get achievementModerateDayDesc => 'Mantente bajo 2 UD en un día';

  @override
  String get achievementSoberDay => 'Día sobrio';

  @override
  String get achievementSoberDayDesc => 'Completa un día sin alcohol';

  @override
  String get achievementSoberWeek => 'Semana sobria';

  @override
  String get achievementSoberWeekDesc => '7 días sin alcohol';

  @override
  String get achievementSoberMonth => 'Mes sobrio';

  @override
  String get achievementSoberMonthDesc => '30 días sin alcohol';

  @override
  String get achievementRecoveryProtocol => 'Pro de la recuperación';

  @override
  String get achievementRecoveryProtocolDesc =>
      'Completa el protocolo de recuperación después de beber';

  @override
  String get achievementFirstWorkout => 'A moverse';

  @override
  String get achievementFirstWorkoutDesc => 'Registra tu primer entrenamiento';

  @override
  String get achievementWorkoutWeek => 'Semana activa';

  @override
  String get achievementWorkoutWeekDesc => 'Entrena 3 veces en una semana';

  @override
  String get achievementCenturySweat => 'Sudor del siglo';

  @override
  String get achievementCenturySweatDesc =>
      'Pierde fluido significativo a través de entrenamientos';

  @override
  String achievementCenturySweatTemplate(String volume) {
    return 'Pierde $volume a través de entrenamientos';
  }

  @override
  String get achievementCardioKing => 'Rey del cardio';

  @override
  String get achievementCardioKingDesc => 'Completa 10 sesiones de cardio';

  @override
  String get achievementStrengthWarrior => 'Guerrero de fuerza';

  @override
  String get achievementStrengthWarriorDesc => 'Completa 10 sesiones de fuerza';

  @override
  String get achievementHRIGreen => 'Zona verde';

  @override
  String get achievementHRIGreenDesc => 'Mantén HRI en zona verde por un día';

  @override
  String get achievementHRIWeekGreen => 'Semana segura';

  @override
  String get achievementHRIWeekGreenDesc =>
      'Mantén HRI en zona verde por 7 días';

  @override
  String get achievementHRIPerfect => 'Puntuación perfecta';

  @override
  String get achievementHRIPerfectDesc => 'Logra HRI bajo 20';

  @override
  String get achievementHRIRecovery => 'Recuperación rápida';

  @override
  String get achievementHRIRecoveryDesc =>
      'Reduce HRI de rojo a verde en un día';

  @override
  String get achievementHRIMaster => 'Maestro HRI';

  @override
  String get achievementHRIMasterDesc => 'Mantén HRI bajo 30 por 30 días';

  @override
  String get achievementStreak3 => 'Empezando';

  @override
  String get achievementStreak3Desc => 'Racha de 3 días';

  @override
  String get achievementStreak7 => 'Guerrero semanal';

  @override
  String get achievementStreak7Desc => 'Racha de 7 días';

  @override
  String get achievementStreak30 => 'Rey de la consistencia';

  @override
  String get achievementStreak30Desc => 'Racha de 30 días';

  @override
  String get achievementStreak100 => 'Club del siglo';

  @override
  String get achievementStreak100Desc => 'Racha de 100 días';

  @override
  String get achievementFirstWeek => 'Primera semana';

  @override
  String get achievementFirstWeekDesc => 'Usa la app por 7 días';

  @override
  String get achievementProMember => 'Miembro PRO';

  @override
  String get achievementProMemberDesc => 'Conviértete en suscriptor PRO';

  @override
  String get achievementDataExport => 'Analista de datos';

  @override
  String get achievementDataExportDesc => 'Exporta tus datos a CSV';

  @override
  String get achievementAllCategories => 'Todoterreno';

  @override
  String get achievementAllCategoriesDesc =>
      'Desbloquea al menos un logro en cada categoría';

  @override
  String get achievementHunter => 'Cazador de logros';

  @override
  String get achievementHunterDesc => 'Desbloquea el 50% de todos los logros';

  @override
  String get achievementDetailsUnlockedOn => 'Desbloqueado el';

  @override
  String get achievementNewUnlocked => '¡Nuevo logro desbloqueado!';

  @override
  String get achievementViewAll => 'Ver todos los logros';

  @override
  String get achievementCloseNotification => 'Cerrar';

  @override
  String get before => 'antes';

  @override
  String get after => 'después';

  @override
  String get lose => 'Pierde';

  @override
  String get through => 'a través';

  @override
  String get throughWorkouts => 'a través de entrenamientos';

  @override
  String get reach => 'Alcanza';

  @override
  String get daysInRow => 'días seguidos';

  @override
  String get completeHydrationGoal => 'Completa la meta de hidratación';

  @override
  String get stayUnder => 'Mantente bajo';

  @override
  String get inADay => 'en un día';

  @override
  String get alcoholFree => 'sin alcohol';

  @override
  String get complete => 'Completa';

  @override
  String get achieve => 'Logra';

  @override
  String get keep => 'Mantén';

  @override
  String get for30Days => 'por 30 días';

  @override
  String get liters => 'litros';

  @override
  String get completed => 'Completado';

  @override
  String get notCompleted => 'No completado';

  @override
  String get days => 'días';

  @override
  String get hours => 'horas';

  @override
  String get times => 'veces';

  @override
  String get row => 'seguidos';

  @override
  String get ofTotal => 'del total';

  @override
  String get perDay => 'por día';

  @override
  String get perWeek => 'por semana';

  @override
  String get streak => 'racha';

  @override
  String get tapToDismiss => 'Toca para cerrar';

  @override
  String tutorialStep1(String volume) {
    return '¡Hola! Te ayudaré a comenzar tu viaje hacia la hidratación óptima. ¡Tomemos el primer trago de $volume!';
  }

  @override
  String tutorialStep2(String volume) {
    return '¡Excelente! Ahora agreguemos otros $volume para sentir cómo funciona.';
  }

  @override
  String get tutorialStep3 =>
      '¡Sobresaliente! Estás listo para usar HydroCoach de forma independiente. ¡Estaré aquí para ayudarte a lograr la hidratación perfecta!';

  @override
  String get tutorialComplete => 'Comenzar a usar';

  @override
  String get onboardingNotificationExamplesTitle =>
      'Recordatorios Inteligentes';

  @override
  String get onboardingNotificationExamplesSubtitle =>
      'HydroCoach sabe cuándo necesitas agua';

  @override
  String get onboardingLocationExamplesTitle => 'Consejos Personales';

  @override
  String get onboardingLocationExamplesSubtitle =>
      'Consideramos el clima para recomendaciones precisas';

  @override
  String get onboardingAllowNotifications => 'Permitir Notificaciones';

  @override
  String get onboardingAllowLocation => 'Permitir Ubicación';

  @override
  String get foodCatalog => 'Catálogo de Alimentos';

  @override
  String get todaysFoodIntake => 'Comida de Hoy';

  @override
  String get noFoodToday => 'No hay alimentos registrados hoy';

  @override
  String foodItemsCount(int count) {
    return '$count alimentos';
  }

  @override
  String get waterFromFood => 'Agua de alimentos';

  @override
  String get last => 'Último';

  @override
  String get categoryFruits => 'Frutas';

  @override
  String get categoryVegetables => 'Verduras';

  @override
  String get categorySoups => 'Sopas';

  @override
  String get categoryDairy => 'Lácteos';

  @override
  String get categoryMeat => 'Carne';

  @override
  String get categoryFastFood => 'Comida Rápida';

  @override
  String get weightGrams => 'Peso (gramos)';

  @override
  String get enterWeight => 'Ingresar peso';

  @override
  String get grams => 'g';

  @override
  String get calories => 'Calorías';

  @override
  String get waterContent => 'Contenido de Agua';

  @override
  String get sugar => 'Azúcar';

  @override
  String get nutritionalInfo => 'Información Nutricional';

  @override
  String caloriesPerWeight(int calories, int weight) {
    return '$calories kcal por ${weight}g';
  }

  @override
  String waterPerWeight(int water, int weight) {
    return '$water ml de agua por ${weight}g';
  }

  @override
  String sugarPerWeight(String sugar, int weight) {
    return '${sugar}g de azúcar por ${weight}g';
  }

  @override
  String get addFood => 'Agregar Alimento';

  @override
  String get foodAdded => 'Alimento agregado exitosamente';

  @override
  String get enterValidWeight => 'Por favor, ingrese un peso válido';

  @override
  String get proOnlyFood => 'Solo PRO';

  @override
  String get unlockProForFood =>
      'Desbloquea PRO para acceder a todos los alimentos';

  @override
  String get foodTracker => 'Rastreador de Comida';

  @override
  String get todaysFoodSummary => 'Resumen de Comida de Hoy';

  @override
  String get kcal => 'kcal';

  @override
  String get per100g => 'por 100g';

  @override
  String get addToFavorites => 'Agregar a favoritos';

  @override
  String get favoritesFeatureComingSoon =>
      '¡La función de favoritos llegará pronto!';

  @override
  String foodAddedSuccess(String food, int calories, String water) {
    return '¡$food agregado! +$calories kcal, +$water';
  }

  @override
  String get selectWeight => 'Seleccionar Peso';

  @override
  String get ounces => 'oz';

  @override
  String get items => 'elementos';

  @override
  String get tapToAddFood => 'Toca para agregar comida';

  @override
  String get noFoodLoggedToday => 'No se registró comida hoy';

  @override
  String get lightEatingDay => 'Día de comida ligera';

  @override
  String get moderateIntake => 'Consumo moderado';

  @override
  String get goodCalorieIntake => 'Buen consumo de calorías';

  @override
  String get substantialMeals => 'Comidas sustanciales';

  @override
  String get highCalorieDay => 'Día alto en calorías';

  @override
  String get veryHighIntake => 'Consumo muy alto';

  @override
  String get caloriesTracker => 'Rastreador de Calorías';

  @override
  String get trackYourDailyCalorieIntake =>
      'Rastrea tu consumo diario de calorías de los alimentos';

  @override
  String get unlockFoodTrackingFeatures =>
      'Desbloquea las funciones de seguimiento de comida';

  @override
  String get selectFoodType => 'Selecciona tipo de comida';

  @override
  String get foodApple => 'Manzana';

  @override
  String get foodBanana => 'Plátano';

  @override
  String get foodOrange => 'Naranja';

  @override
  String get foodWatermelon => 'Sandía';

  @override
  String get foodStrawberry => 'Fresa';

  @override
  String get foodGrapes => 'Uvas';

  @override
  String get foodPineapple => 'Piña';

  @override
  String get foodMango => 'Mango';

  @override
  String get foodPear => 'Pera';

  @override
  String get foodCarrot => 'Zanahoria';

  @override
  String get foodBroccoli => 'Brócoli';

  @override
  String get foodSpinach => 'Espinaca';

  @override
  String get foodTomato => 'Tomate';

  @override
  String get foodCucumber => 'Pepino';

  @override
  String get foodBellPepper => 'Pimiento';

  @override
  String get foodLettuce => 'Lechuga';

  @override
  String get foodOnion => 'Cebolla';

  @override
  String get foodCelery => 'Apio';

  @override
  String get foodPotato => 'Papa';

  @override
  String get foodChickenSoup => 'Sopa de Pollo';

  @override
  String get foodTomatoSoup => 'Sopa de Tomate';

  @override
  String get foodVegetableSoup => 'Sopa de Verduras';

  @override
  String get foodMinestrone => 'Minestrone';

  @override
  String get foodMisoSoup => 'Sopa de Miso';

  @override
  String get foodMushroomSoup => 'Sopa de Champiñones';

  @override
  String get foodBeefStew => 'Estofado de Res';

  @override
  String get foodLentilSoup => 'Sopa de Lentejas';

  @override
  String get foodOnionSoup => 'Sopa de Cebolla Francesa';

  @override
  String get foodMilk => 'Leche';

  @override
  String get foodYogurt => 'Yogur Griego';

  @override
  String get foodCheese => 'Queso Cheddar';

  @override
  String get foodCottageCheese => 'Requesón';

  @override
  String get foodButter => 'Mantequilla';

  @override
  String get foodCream => 'Crema Espesa';

  @override
  String get foodIceCream => 'Helado';

  @override
  String get foodMozzarella => 'Mozzarella';

  @override
  String get foodParmesan => 'Parmesano';

  @override
  String get foodChickenBreast => 'Pechuga de Pollo';

  @override
  String get foodBeef => 'Carne Molida';

  @override
  String get foodSalmon => 'Salmón';

  @override
  String get foodEggs => 'Huevos';

  @override
  String get foodTuna => 'Atún';

  @override
  String get foodPork => 'Chuleta de Cerdo';

  @override
  String get foodTurkey => 'Pavo';

  @override
  String get foodShrimp => 'Camarones';

  @override
  String get foodBacon => 'Tocino';

  @override
  String get foodBigMac => 'Big Mac';

  @override
  String get foodPizza => 'Porción de Pizza';

  @override
  String get foodFrenchFries => 'Papas Fritas';

  @override
  String get foodChickenNuggets => 'Nuggets de Pollo';

  @override
  String get foodHotDog => 'Perro Caliente';

  @override
  String get foodTacos => 'Tacos';

  @override
  String get foodSubway => 'Sándwich de Subway';

  @override
  String get foodDonut => 'Donut';

  @override
  String get foodBurgerKing => 'Whopper';

  @override
  String get foodSausage => 'Salchicha';

  @override
  String get foodKefir => 'Kéfir';

  @override
  String get foodRyazhenka => 'Ryazhenka';

  @override
  String get foodDoner => 'Döner';

  @override
  String get foodShawarma => 'Shawarma';

  @override
  String get foodBorscht => 'Borscht';

  @override
  String get foodRamen => 'Ramen';

  @override
  String get foodCabbage => 'Repollo';

  @override
  String get foodPeaSoup => 'Sopa de Guisantes';

  @override
  String get foodSolyanka => 'Solyanka';

  @override
  String get meals => 'comidas';

  @override
  String get dailyProgress => 'Progreso diario';

  @override
  String get fromFood => 'de alimentos';

  @override
  String get noFoodThisWeek => 'No hay datos de comida esta semana';

  @override
  String get foodIntake => 'Consumo de alimentos';

  @override
  String get foodStats => 'Estadísticas de alimentación';

  @override
  String get totalCalories => 'Calorías totales';

  @override
  String get avgCaloriesPerDay => 'Promedio por día';

  @override
  String get daysWithFood => 'Días con comida';

  @override
  String get avgMealsPerDay => 'Comidas por día';

  @override
  String get caloriesPerDay => 'Calorías por día';

  @override
  String get sugarPerDay => 'Azúcar por día';

  @override
  String get foodTracking => 'Seguimiento de alimentos';

  @override
  String get foodTrackingPro =>
      'Rastrea el impacto de los alimentos en la hidratación y HRI';

  @override
  String get hydrationBalance => 'Balance de hidratación';

  @override
  String get highSodiumFood => 'Alto sodio de alimentos';

  @override
  String get hydratingFood => 'Excelentes opciones hidratantes';

  @override
  String get dryFood => 'Alimentos con bajo contenido de agua';

  @override
  String get balancedFood => 'Nutrición equilibrada';

  @override
  String get foodAdviceEmpty =>
      'Agrega comidas para rastrear el impacto de los alimentos en la hidratación.';

  @override
  String get foodAdviceHighSodium =>
      'Se detectó alto consumo de sodio. Aumenta el agua para equilibrar los electrolitos.';

  @override
  String get foodAdviceLowWater =>
      'Tu comida tenía bajo contenido de agua. Considera beber agua extra.';

  @override
  String get foodAdviceGoodHydration =>
      '¡Genial! Tu comida ayuda a la hidratación.';

  @override
  String get foodAdviceBalanced => '¡Buena nutrición! Recuerda beber agua.';

  @override
  String get richInElectrolytes => 'Rico en electrolitos';

  @override
  String recommendedCalories(int calories) {
    return 'Calorías recomendadas: ~$calories kcal/día';
  }

  @override
  String get proWelcomeTitle => '¡Bienvenido a HydraCoach PRO!';

  @override
  String get proTrialActivated => '¡Tu prueba de 7 días activada!';

  @override
  String get proFeaturePersonalizedRecommendations =>
      'Recomendaciones personalizadas';

  @override
  String get proFeatureAdvancedAnalytics => 'Análisis avanzado';

  @override
  String get proFeatureWorkoutTracking => 'Seguimiento de entrenamientos';

  @override
  String get proFeatureElectrolyteControl => 'Control de electrolitos';

  @override
  String get proFeatureSmartReminders => 'Recordatorios inteligentes';

  @override
  String get proFeatureHriIndex => 'Índice HRI';

  @override
  String get proFeatureAchievements => 'Logros PRO';

  @override
  String get proFeaturePersonalizedDescription =>
      'Consejos individuales de hidratación';

  @override
  String get proFeatureAdvancedDescription =>
      'Gráficos detallados y estadísticas';

  @override
  String get proFeatureWorkoutDescription =>
      'Seguimiento de pérdida de líquidos durante el deporte';

  @override
  String get proFeatureElectrolyteDescription =>
      'Monitoreo de sodio, potasio, magnesio';

  @override
  String get proFeatureSmartDescription => 'Notificaciones personalizadas';

  @override
  String get proFeatureNoMoreAds => '¡No más anuncios!';

  @override
  String get proFeatureNoMoreAdsDescription =>
      'Disfruta del seguimiento de hidratación sin interrupciones de publicidad';

  @override
  String get proFeatureHriDescription =>
      'Índice de riesgo de hidratación en tiempo real';

  @override
  String get proFeatureAchievementsDescription =>
      'Recompensas y objetivos exclusivos';

  @override
  String get startUsing => 'Comenzar a usar';

  @override
  String get sayGoodbyeToAds => 'Dile adiós a los anuncios. Hazte Premium.';

  @override
  String get goPremium => 'HAZTE PREMIUM';

  @override
  String get removeAdsForever => 'Eliminar anuncios para siempre';

  @override
  String get upgrade => 'ACTUALIZAR';

  @override
  String get support => 'Soporte';

  @override
  String get companyWebsite => 'Sitio web de la empresa';

  @override
  String get appStoreOpened => 'App Store abierto';

  @override
  String get linkCopiedToClipboard => 'Enlace copiado al portapapeles';

  @override
  String get shareDialogOpened => 'Diálogo de compartir abierto';

  @override
  String get linkForSharingCopied => 'Enlace para compartir copiado';

  @override
  String get websiteOpenedInBrowser => 'Sitio web abierto en el navegador';

  @override
  String get emailClientOpened => 'Cliente de email abierto';

  @override
  String get emailCopiedToClipboard => 'Email copiado al portapapeles';

  @override
  String get privacyPolicyOpened => 'Política de privacidad abierta';

  @override
  String statisticsTo(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Statistics until $dateString';
  }

  @override
  String get monthlyInsights => 'Monthly Insights';

  @override
  String get average => 'Average';

  @override
  String get daysOver => 'Days over';

  @override
  String get maximum => 'Maximum';

  @override
  String get balance => 'Balance';

  @override
  String get allNormal => 'All normal';

  @override
  String get excellentConsistency => '⭐ Excelente consistencia';

  @override
  String get goodResults => '📊 Buenos resultados';

  @override
  String get positiveImprovement => 'Positive improvement';

  @override
  String get physicalActivity => '💪 Actividad física';

  @override
  String get coffeeConsumption => '☕ Consumo de café';

  @override
  String get excellentSobriety => '🎯 Excelente sobriedad';

  @override
  String get excellentMonth => '✨ Excelente mes';

  @override
  String get keepGoingMotivation => 'Keep it up!';

  @override
  String get daysNormal => 'days normal';

  @override
  String get electrolyteBalance => 'Electrolyte balance needs attention';

  @override
  String get caffeineWarning => 'Days with overdose of safe dose (400mg)';

  @override
  String get sugarFrequentExcess => 'Frequent excess sugar affects hydration';

  @override
  String get averagePerDayShort => 'per day';

  @override
  String get highWarning => 'High';

  @override
  String get normalStatus => 'Normal';

  @override
  String improvementToEnd(int percent) {
    return 'Improvement towards end of month by $percent%';
  }

  @override
  String workoutActivity(int percent, String hours) {
    return '$percent% days with workouts (${hours}h)';
  }

  @override
  String coffeeAverage(String avg) {
    return 'Average $avg cups/day';
  }

  @override
  String sobrietyPercent(int percent) {
    return '$percent% days without alcohol';
  }

  @override
  String get daySummary => 'Day Summary';

  @override
  String get records => 'Records';

  @override
  String waterGoalAchievement(int percent) {
    return 'Water goal achievement: $percent%';
  }

  @override
  String workoutSessions(int count) {
    return 'Workouts: $count sessions';
  }

  @override
  String get index => 'Index';

  @override
  String get status => 'Status';

  @override
  String get moderateRisk => 'Moderate risk';

  @override
  String get excess => 'Excess';

  @override
  String get whoLimit => 'WHO limit: 50g/day';

  @override
  String stability(int percent) {
    return 'Stability in $percent% of days';
  }

  @override
  String goodHydration(int percent) {
    return '$percent% days with good hydration';
  }

  @override
  String daysInNorm(int count) {
    return '$count días en norma';
  }

  @override
  String consistencyDays(int percent) {
    return '$percent% días con buena hidratación';
  }

  @override
  String stabilityDays(int percent) {
    return 'Estabilidad en $percent% de días';
  }

  @override
  String monthEndImprovement(int percent) {
    return 'Mejora a fin de mes del $percent%';
  }

  @override
  String workoutDaysPercent(int percent, String hours) {
    return '$percent% días con entrenamientos (${hours}h)';
  }

  @override
  String averageCupsPerDay(String avgCups) {
    return 'Promedio $avgCups tazas/día';
  }

  @override
  String soberDaysPercent(int percent) {
    return '$percent% días sin alcohol';
  }

  @override
  String get moderateRiskStatus => 'Estado: Riesgo moderado';

  @override
  String get high => 'Alto';

  @override
  String get whoLimitPerDay => 'Límite OMS: 50g/día';
}
