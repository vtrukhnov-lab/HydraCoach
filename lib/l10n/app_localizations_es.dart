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
  String get january => 'enero';

  @override
  String get february => 'febrero';

  @override
  String get march => 'marzo';

  @override
  String get april => 'abril';

  @override
  String get may => 'mayo';

  @override
  String get june => 'junio';

  @override
  String get july => 'julio';

  @override
  String get august => 'agosto';

  @override
  String get september => 'septiembre';

  @override
  String get october => 'octubre';

  @override
  String get november => 'noviembre';

  @override
  String get december => 'diciembre';

  @override
  String dateFormat(String weekday, int day, String month) {
    return '$weekday, $day de $month';
  }

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingWeather => 'Cargando clima...';

  @override
  String get heatIndex => 'Índice de Calor';

  @override
  String humidity(int value) {
    return 'Humedad: $value%';
  }

  @override
  String get water => 'Agua';

  @override
  String get sodium => 'Sodio';

  @override
  String get potassium => 'Potasio';

  @override
  String get magnesium => 'Magnesio';

  @override
  String get electrolyte => 'Electrolito';

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
  String get adviceOverhydrationSevere => 'Sobrecarga de agua (>200% meta)';

  @override
  String get adviceOverhydrationSevereBody =>
      'Pausa 60-90 minutos. Añade electrolitos: 300-500 ml con 500-1000 mg de sodio.';

  @override
  String get adviceOverhydration => 'Sobrehidratación';

  @override
  String get adviceOverhydrationBody =>
      'Pausa el agua 30-60 minutos y añade ~500 mg de sodio (electrolito/caldo).';

  @override
  String get adviceAlcoholRecovery => 'Alcohol: recuperación';

  @override
  String get adviceAlcoholRecoveryBody =>
      'No más alcohol hoy. Bebe 300-500 ml de agua en pequeñas porciones y añade sodio.';

  @override
  String get adviceLowSodium => 'Bajo en sodio';

  @override
  String adviceLowSodiumBody(int amount) {
    return 'Añade ~$amount mg de sodio. Bebe moderadamente.';
  }

  @override
  String get adviceDehydration => 'Falta agua';

  @override
  String adviceDehydrationBody(String type) {
    return 'Bebe 300-500 ml de $type.';
  }

  @override
  String get adviceHighRisk => 'Alto riesgo (HRI)';

  @override
  String get adviceHighRiskBody =>
      'Bebe agua con electrolitos urgentemente (300-500 ml) y reduce la actividad.';

  @override
  String get adviceHeat => 'Calor y pérdidas';

  @override
  String get adviceHeatBody =>
      'Aumenta el agua +5-8% y añade 300-500 mg de sodio.';

  @override
  String get adviceAllGood => 'Todo va bien';

  @override
  String adviceAllGoodBody(int amount) {
    return 'Mantén el ritmo. Meta: ~$amount ml más para completar.';
  }

  @override
  String get hydrationStatus => 'Estado de Hidratación';

  @override
  String get hydrationStatusNormal => 'Normal';

  @override
  String get hydrationStatusDiluted => 'Diluyendo';

  @override
  String get hydrationStatusDehydrated => 'Falta agua';

  @override
  String get hydrationStatusLowSalt => 'Poca sal';

  @override
  String get hydrationRiskIndex => 'Índice de Riesgo de Hidratación';

  @override
  String get quickAdd => 'Añadir Rápido';

  @override
  String get add => 'Añadir';

  @override
  String get delete => 'Eliminar';

  @override
  String get todaysDrinks => 'Bebidas de Hoy';

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
  String get settings => 'Ajustes';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get reset => 'Restablecer';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSettings => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get profileSection => 'Perfil';

  @override
  String get weight => 'Peso';

  @override
  String get dietMode => 'Modo de Dieta';

  @override
  String get activityLevel => 'Nivel de Actividad';

  @override
  String get changeWeight => 'Cambiar Peso';

  @override
  String get dietModeNormal => 'Dieta Normal';

  @override
  String get dietModeKeto => 'Keto / Bajo en carbohidratos';

  @override
  String get dietModeFasting => 'Ayuno Intermitente';

  @override
  String get activityLow => 'Actividad Baja';

  @override
  String get activityMedium => 'Actividad Media';

  @override
  String get activityHigh => 'Actividad Alta';

  @override
  String get activityLowDesc => 'Trabajo de oficina, poco movimiento';

  @override
  String get activityMediumDesc => '30-60 minutos de ejercicio al día';

  @override
  String get activityHighDesc => 'Entrenamientos >1 hora';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get notificationLimit => 'Límite de Notificaciones (GRATIS)';

  @override
  String notificationUsage(int used, int limit) {
    return 'Usadas: $used de $limit';
  }

  @override
  String get waterReminders => 'Recordatorios de Agua';

  @override
  String get waterRemindersDesc => 'Recordatorios regulares durante el día';

  @override
  String get reminderFrequency => 'Frecuencia de Recordatorios';

  @override
  String timesPerDay(int count) {
    return '$count veces al día';
  }

  @override
  String maxTimesPerDay(int count) {
    return '$count veces al día (máx 4)';
  }

  @override
  String get unlimitedReminders => 'Sin límite';

  @override
  String get startOfDay => 'Inicio del Día';

  @override
  String get endOfDay => 'Fin del Día';

  @override
  String get postCoffeeReminders => 'Recordatorios Post-Café';

  @override
  String get postCoffeeRemindersDesc =>
      'Recordar beber agua después de 20 minutos';

  @override
  String get heatWarnings => 'Alertas de Calor';

  @override
  String get heatWarningsDesc => 'Notificaciones en altas temperaturas';

  @override
  String get postAlcoholReminders => 'Recordatorios Post-Alcohol';

  @override
  String get postAlcoholRemindersDesc => 'Plan de recuperación para 6-12 horas';

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
  String get metricSystem => 'Sistema Métrico';

  @override
  String get metricUnits => 'ml, kg, °C';

  @override
  String get imperialSystem => 'Sistema Imperial';

  @override
  String get imperialUnits => 'oz, lb, °F';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get rateApp => 'Calificar App';

  @override
  String get share => 'Compartir';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfUse => 'Términos de Uso';

  @override
  String get resetAllData => 'Restablecer Todos los Datos';

  @override
  String get resetDataTitle => '¿Restablecer todos los datos?';

  @override
  String get resetDataMessage =>
      'Esto eliminará todo el historial y restablecerá los ajustes a los valores predeterminados.';

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
    return 'Norma recomendada: $min-$max ml de agua al día';
  }

  @override
  String get dietPageTitle => 'Modo de Dieta';

  @override
  String get dietPageSubtitle => 'Esto afecta las necesidades de electrolitos';

  @override
  String get normalDiet => 'Dieta normal';

  @override
  String get normalDietDesc => 'Recomendaciones estándar';

  @override
  String get ketoDiet => 'Keto / Bajo en carbohidratos';

  @override
  String get ketoDietDesc => 'Mayor necesidad de sal';

  @override
  String get fastingDiet => 'Ayuno Intermitente';

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
  String get activityPageTitle => 'Nivel de Actividad';

  @override
  String get activityPageSubtitle => 'Afecta las necesidades de agua';

  @override
  String get lowActivity => 'Actividad baja';

  @override
  String get lowActivityDesc => 'Trabajo de oficina, poco movimiento';

  @override
  String get lowActivityWater => '+0 ml de agua';

  @override
  String get mediumActivity => 'Actividad media';

  @override
  String get mediumActivityDesc => '30-60 minutos de ejercicio al día';

  @override
  String get mediumActivityWater => '+350-700 ml de agua';

  @override
  String get highActivity => 'Actividad alta';

  @override
  String get highActivityDesc => 'Entrenamientos >1 hora o trabajo físico';

  @override
  String get highActivityWater => '+700-1200 ml de agua';

  @override
  String get activityAdjustmentNote =>
      'Ajustaremos las metas según tus entrenamientos';

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
  String get noRecordsToday => 'Aún no hay registros de hoy';

  @override
  String get noRecordsThisDay => 'No hay registros de este día';

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
  String get weeklyInsights => '💡 Perspectivas semanales';

  @override
  String get waterPerDay => 'Agua por día';

  @override
  String get sodiumPerDay => 'Sodio por día';

  @override
  String get potassiumPerDay => 'Potasio por día';

  @override
  String get magnesiumPerDay => 'Magnesio por día';

  @override
  String get goal => 'Meta';

  @override
  String get daysWithGoalAchieved => '✅ Días con meta alcanzada';

  @override
  String get recordsPerDay => '📝 Registros por día';

  @override
  String get insufficientDataForAnalysis =>
      'Datos insuficientes para el análisis';

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
    return 'Días con meta perfecta: $count';
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
  String get totalSD => 'SD total';

  @override
  String get forMonth => 'por mes';

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
    return '$day - $percent% de la meta';
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
    return 'Bebes $percent% menos entre semana';
  }

  @override
  String get positiveTrend => '📈 Tendencia positiva';

  @override
  String get positiveTrendMessage =>
      'Tu hidratación mejora hacia el final de la semana';

  @override
  String get decliningActivity => '📉 Actividad en descenso';

  @override
  String get decliningActivityMessage =>
      'El consumo de agua disminuye al final de la semana';

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
  String get excellentWeek => '✅ Semana excelente';

  @override
  String get continueMessage => '¡Sigue con el buen trabajo!';

  @override
  String get all => 'Todo';

  @override
  String get addAlcohol => 'Añadir alcohol';

  @override
  String get minimumHarm => 'Daño mínimo';

  @override
  String additionalWaterNeeded(int amount) {
    return '+$amount ml de agua necesaria';
  }

  @override
  String additionalSodiumNeeded(int amount) {
    return '+$amount mg de sodio agregar';
  }

  @override
  String get goToBedEarly => 'Acuéstate temprano';

  @override
  String get todayConsumed => 'Consumido hoy:';

  @override
  String get alcoholToday => 'Alcohol hoy';

  @override
  String get beer => 'Cerveza';

  @override
  String get wine => 'Vino';

  @override
  String get spirits => 'Licor';

  @override
  String get cocktail => 'Cóctel';

  @override
  String get selectDrinkType => 'Selecciona el tipo de bebida:';

  @override
  String get volume => 'Volumen (ml):';

  @override
  String get enterVolume => 'Ingresa el volumen en ml';

  @override
  String get strength => 'Graduación (%):';

  @override
  String get standardDrinks => 'Bebidas estándar:';

  @override
  String get additionalWater => 'Agua adicional';

  @override
  String get additionalSodium => 'Sodio adicional';

  @override
  String get hriRisk => 'Riesgo HRI';

  @override
  String get enterValidVolume => 'Por favor ingrese un volumen válido';

  @override
  String get weeklyHistory => 'Historial semanal';

  @override
  String get weeklyHistoryDesc =>
      'Analiza tendencias semanales, obtén perspectivas y recomendaciones';

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
  String get oneTime => 'único pago';

  @override
  String get perYear => '/año';

  @override
  String get perMonth => '/mes';

  @override
  String approximatelyPerMonth(String amount) {
    return '≈ $amount/mes';
  }

  @override
  String get startFreeTrial => 'Comenzar prueba gratis de 7 días';

  @override
  String continueWithPrice(String price) {
    return 'Continuar — $price';
  }

  @override
  String unlockForPrice(String price) {
    return 'Desbloquear por $price (único pago)';
  }

  @override
  String get enableFreeTrial => 'Habilitar prueba gratis de 7 días';

  @override
  String get noChargeToday =>
      'Sin cargo hoy. Después de 7 días, tu suscripción se renueva automáticamente a menos que la canceles.';

  @override
  String get cancelAnytime =>
      'Puedes cancelar en cualquier momento en Ajustes.';

  @override
  String get everythingInPro => 'Todo en PRO';

  @override
  String get smartReminders => 'Recordatorios inteligentes';

  @override
  String get smartRemindersDesc => 'Calor, entrenamientos, ayuno — sin spam.';

  @override
  String get weeklyReports => 'Informes semanales';

  @override
  String get weeklyReportsDesc => 'Análisis profundo + exportación CSV.';

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
  String get showAllFeatures => 'Mostrar todas las características';

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
  String get addElectrolytesToWater => 'Añade electrolitos a cada toma de agua';

  @override
  String get limitCoffeeOneCup => 'Limita el café a una taza';

  @override
  String get increaseWater10 => 'Aumenta el agua en un 10%';

  @override
  String get dontForgetElectrolytes => 'No olvides los electrolitos';

  @override
  String get startDayWithWater => 'Empieza el día con un vaso de agua';

  @override
  String get takeElectrolytesMorning => 'Toma electrolitos por la mañana';

  @override
  String purchaseFailed(String error) {
    return 'Error de compra: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Error de restauración: $error';
  }

  @override
  String get trustedByUsers => '⭐️ 4.9 — confían 12,000 usuarios';

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
      'Verifique los permisos de ubicación e internet';

  @override
  String get currentLocation => 'Ubicación actual';

  @override
  String get weatherClear => 'despejado';

  @override
  String get weatherCloudy => 'nublado';

  @override
  String get weatherOvercast => 'nublado';

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
      '🌡️ ¡Muy caliente! Riesgo de deshidratación';

  @override
  String get heatWarningHot => '🔥 ¡Calor! Beba más agua';

  @override
  String get heatWarningElevated => '⚠️ Temperatura elevada';

  @override
  String get heatWarningComfortable => 'Temperatura confortable';

  @override
  String adjustmentWater(int percent) {
    return '+$percent% agua';
  }

  @override
  String adjustmentSodium(int amount) {
    return '+$amount mg sodio';
  }
}
