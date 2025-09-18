import 'package:flutter/material.dart';
import 'package:usercentrics_sdk/usercentrics_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentService {
  static const String _consentGivenKey = 'consent_given';
  static const String _hasShownBannerKey = 'has_shown_consent_banner';
  
  // Usercentrics Settings ID для вашего приложения
  static const String settingsId = 'UxKlz-EOgB16Ne';
  
  // AppsFlyer Template ID
  static const String appsFlyerTemplateId = 'Gx9iMF__f';
  
  bool _isInitialized = false;
  bool _hasConsent = false;
  
  // Callback для уведомления об изменении согласия
  Function(bool)? onConsentChanged;
  
  // Singleton паттерн
  static final ConsentService _instance = ConsentService._internal();
  factory ConsentService() => _instance;
  ConsentService._internal();
  
  // Проверка, было ли дано согласие
  bool get hasConsent => _hasConsent;
  bool get isInitialized => _isInitialized;
  
  // Инициализация Usercentrics
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('ConsentService: Инициализация Usercentrics...');
      
      // Инициализация Usercentrics SDK
      Usercentrics.initialize(
        settingsId: settingsId,
        loggerLevel: UsercentricsLoggerLevel.debug,
      );
      
      _isInitialized = true;
      
      debugPrint('ConsentService: Usercentrics инициализирован');
      
      // Проверяем текущий статус согласия
      await _checkCurrentConsent();
      
      // Проверяем, нужно ли показать баннер
      final status = await Usercentrics.status;
      if (status.shouldCollectConsent) {
        debugPrint('ConsentService: Необходимо собрать согласие');
        // Баннер будет показан в UI
      } else {
        debugPrint('ConsentService: Согласие уже получено или не требуется');
      }
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка инициализации - $e');
      // В случае ошибки считаем, что согласия нет
      _hasConsent = false;
      _isInitialized = false;
    }
  }
  
  // Проверка текущего статуса согласия для AppsFlyer
  Future<void> _checkCurrentConsent() async {
    try {
      // Получаем текущий статус согласий
      final status = await Usercentrics.status;
      
      // Ищем согласие для AppsFlyer по Template ID
      final appsFlyerConsent = status.consents.firstWhere(
        (consent) => consent.templateId == appsFlyerTemplateId,
        orElse: () => UsercentricsServiceConsent(
          templateId: appsFlyerTemplateId,
          status: false,
          category: 'explicit',
          type: null,
          version: '',
          dataProcessor: '',
          isEssential: false,
          history: [],
        ),
      );
      
      _hasConsent = appsFlyerConsent.status;
      
      debugPrint('ConsentService: Согласие AppsFlyer = $_hasConsent');
      
      // Сохраняем в SharedPreferences для быстрого доступа
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_consentGivenKey, _hasConsent);
      
      // Уведомляем об изменении согласия
      onConsentChanged?.call(_hasConsent);
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка проверки согласия - $e');
      _hasConsent = false;
    }
  }
  
  // Показать баннер согласия
  Future<void> showConsentBanner(BuildContext context) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      debugPrint('ConsentService: Показываем баннер согласия...');
      
      // Показываем первый слой (баннер) с настройками
      final response = await Usercentrics.showFirstLayer(
        settings: const BannerSettings(
          firstLayer: FirstLayerStyleSettings(
            backgroundColor: Color(0xFFFFFFFF),
            cornerRadius: 20,
            overlayColor: Color(0x4D000000),
          ),
          general: GeneralStyleSettings(
            textColor: Color(0xFF000000),
          ),
        ),
      );
      
      debugPrint('ConsentService: Ответ пользователя - ${response?.userInteraction}');
      
      // Обрабатываем ответ
      if (response != null) {
        await _handleUserResponse(response);
        
        // Сохраняем, что баннер был показан
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_hasShownBannerKey, true);
      }
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка показа баннера - $e');
    }
  }
  
  // Показать настройки конфиденциальности (второй слой)
  Future<void> showPrivacySettings(BuildContext context) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      debugPrint('ConsentService: Открываем настройки конфиденциальности...');
      
      // Показываем второй слой (детальные настройки)
      final response = await Usercentrics.showSecondLayer(
        settings: BannerSettings(
          secondLayer: SecondLayerStyleSettings(
            showCloseButton: true,
            buttonLayout: ButtonLayout.row(
              buttons: [
                const ButtonSettings(type: ButtonType.save),
                const ButtonSettings(type: ButtonType.acceptAll),
              ],
            ),
          ),
        ),
      );
      
      debugPrint('ConsentService: Ответ из настроек - ${response?.userInteraction}');
      
      // Обрабатываем ответ
      if (response != null) {
        await _handleUserResponse(response);
      }
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка показа настроек - $e');
    }
  }
  
  // Обработка ответа пользователя
  Future<void> _handleUserResponse(UsercentricsConsentUserResponse response) async {
    // Проверяем новый статус согласия
    await _checkCurrentConsent();
    
    debugPrint('ConsentService: Consents -> ${response.consents}');
    debugPrint('ConsentService: User Interaction -> ${response.userInteraction}');
    
    // Можно здесь добавить логику применения согласий к сервисам
    _applyConsent(response.consents);
  }
  
  // Применение согласий к сервисам
  void _applyConsent(List<UsercentricsServiceConsent>? consents) {
    if (consents == null) return;
    
    for (final consent in consents) {
      debugPrint('ConsentService: Applying consent for ${consent.dataProcessor}: ${consent.status}');
      
      // Здесь можно добавить логику включения/отключения конкретных SDK
      if (consent.templateId == appsFlyerTemplateId) {
        _hasConsent = consent.status;
        onConsentChanged?.call(consent.status);
      }
    }
  }
  
  // Проверить, нужно ли показывать баннер при запуске
  Future<bool> shouldShowConsentBanner() async {
    try {
      // Проверяем, был ли уже показан баннер
      final prefs = await SharedPreferences.getInstance();
      final hasShownBanner = prefs.getBool(_hasShownBannerKey) ?? false;
      
      if (hasShownBanner) {
        return false; // Баннер уже был показан
      }
      
      // Проверяем через Usercentrics
      final status = await Usercentrics.status;
      return status.shouldCollectConsent;
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка проверки необходимости баннера - $e');
      return false;
    }
  }
  
  // Сбросить все согласия (для тестирования)
  Future<void> resetConsent() async {
    try {
      debugPrint('ConsentService: Сброс всех согласий...');
      
      // В новой версии SDK нет метода reset(), 
      // поэтому просто очищаем локальные данные
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_consentGivenKey);
      await prefs.remove(_hasShownBannerKey);
      
      _hasConsent = false;
      
      // Для полного сброса нужно будет переинициализировать SDK
      _isInitialized = false;
      
      debugPrint('ConsentService: Согласия сброшены (локально)');
      debugPrint('ConsentService: Для полного сброса переустановите приложение');
      
    } catch (e) {
      debugPrint('ConsentService: Ошибка сброса согласий - $e');
    }
  }
  
  // Получить статус согласия из кеша (быстрый доступ)
  Future<bool> getCachedConsent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_consentGivenKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}