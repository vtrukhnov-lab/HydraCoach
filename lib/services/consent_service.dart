import 'package:flutter/material.dart';
import 'package:usercentrics_sdk/usercentrics_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentService {
  static const String _consentGivenKey = 'consent_given';
  static const String _hasShownBannerKey = 'has_shown_consent_banner';

  // Usercentrics Ruleset ID от паблишера (settingsId должен быть пустым)
  static const String settingsId = 'UxKlz-EOgB16Ne';

  // Template IDs от паблишера для основных сервисов
  static const String appsFlyerTemplateId = 'Gx9iMF__f';
  static const String firebaseTemplateId = '42vRvlulK96R-F';
  static const String appLovinTemplateId = 'fHczTMzX8';
  static const String googleAdsTemplateId = 'S1_9Vsuj-Q';

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
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Инициализация Usercentrics...');

      // Инициализация Usercentrics SDK
      // По требованию паблишера: settingsId оставляем пустым, используем только ruleSetId
      Usercentrics.initialize(
        ruleSetId: settingsId, // UxKlz-EOgB16Ne это Ruleset ID
        loggerLevel: UsercentricsLoggerLevel.debug,
      );

      _isInitialized = true;

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Usercentrics инициализирован');

      // Проверяем текущий статус согласия
      await _checkCurrentConsent();

      // Проверяем, нужно ли показать баннер
      final status = await Usercentrics.status;
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: shouldCollectConsent = ${status.shouldCollectConsent}');
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: User location: ${status.location}');
      if (status.shouldCollectConsent) {
        // RELEASE: Debug logging disabled
        // debugPrint('ConsentService: Необходимо собрать согласие');
        // Баннер будет показан в UI
      } else {
        // RELEASE: Debug logging disabled
        // debugPrint('ConsentService: Согласие уже получено или не требуется');
      }
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка инициализации - $e');
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

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Всего согласий найдено: ${status.consents.length}');
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ищем Template ID: $appsFlyerTemplateId');

      // Логируем все Template ID для отладки
      for (final consent in status.consents) {
        // RELEASE: Debug logging disabled
        // debugPrint('ConsentService: Found consent - Template ID: ${consent.templateId}, Status: ${consent.status}, Processor: ${consent.dataProcessor}');
      }

      // Ищем согласие для AppsFlyer по Template ID
      UsercentricsServiceConsent? appsFlyerConsent;
      try {
        appsFlyerConsent = status.consents.firstWhere(
          (consent) => consent.templateId == appsFlyerTemplateId,
        );
        _hasConsent = appsFlyerConsent.status;
        // RELEASE: Debug logging disabled
        // debugPrint('ConsentService: Найдено согласие AppsFlyer: $_hasConsent');
      } catch (e) {
        // Template ID не найден в конфигурации - значит согласие не требуется или конфигурация неправильная
        // RELEASE: Debug logging disabled
        // debugPrint('ConsentService: Template ID $appsFlyerTemplateId не найден в конфигурации');
        _hasConsent = false;
      }

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Итоговое согласие AppsFlyer = $_hasConsent');

      // Сохраняем в SharedPreferences для быстрого доступа
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_consentGivenKey, _hasConsent);

      // Уведомляем об изменении согласия
      onConsentChanged?.call(_hasConsent);
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка проверки согласия - $e');
      _hasConsent = false;
    }
  }

  // Показать баннер согласия
  Future<void> showConsentBanner(BuildContext context) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Показываем баннер согласия...');

      // Показываем первый слой (баннер) с настройками
      final response = await Usercentrics.showFirstLayer(
        settings: const BannerSettings(
          firstLayer: FirstLayerStyleSettings(
            backgroundColor: Color(0xFFFFFFFF),
            cornerRadius: 20,
            overlayColor: Color(0x4D000000),
          ),
          general: GeneralStyleSettings(textColor: Color(0xFF000000)),
        ),
      );

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ответ пользователя - ${response?.userInteraction}');

      // Обрабатываем ответ
      if (response != null) {
        await _handleUserResponse(response);

        // Сохраняем, что баннер был показан
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_hasShownBannerKey, true);
      }
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка показа баннера - $e');
    }
  }

  // Показать настройки конфиденциальности (второй слой)
  Future<void> showPrivacySettings(BuildContext context) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Открываем настройки конфиденциальности...');

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

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ответ из настроек - ${response?.userInteraction}');

      // Обрабатываем ответ
      if (response != null) {
        await _handleUserResponse(response);
      }
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка показа настроек - $e');
    }
  }

  // Обработка ответа пользователя
  Future<void> _handleUserResponse(
    UsercentricsConsentUserResponse response,
  ) async {
    // Проверяем новый статус согласия
    await _checkCurrentConsent();

    debugPrint('ConsentService: Consents -> ${response.consents}');
    debugPrint(
      'ConsentService: User Interaction -> ${response.userInteraction}',
    );

    // Можно здесь добавить логику применения согласий к сервисам
    _applyConsent(response.consents);
  }

  // Применение согласий к сервисам
  void _applyConsent(List<UsercentricsServiceConsent>? consents) {
    if (consents == null) return;

    for (final consent in consents) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Applying consent for ${consent.dataProcessor}: ${consent.status}');

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
      // Проверяем через Usercentrics
      final status = await Usercentrics.status;
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: shouldCollectConsent = ${status.shouldCollectConsent}');
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: User location: ${status.location}');
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Consent template count: ${status.consents.length}');

      return status.shouldCollectConsent;
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка проверки необходимости баннера - $e');
      return false;
    }
  }

  // Принудительный показ баннера для тестирования
  Future<void> forceShowConsentBanner(BuildContext context) async {
    try {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: 🧪 ПРИНУДИТЕЛЬНЫЙ показ баннера для тестирования...');

      await resetConsent(); // Сбрасываем локальные данные
      await initialize(); // Переинициализируем

      // Принудительно показываем баннер
      final response = await Usercentrics.showFirstLayer(
        settings: const BannerSettings(
          firstLayer: FirstLayerStyleSettings(
            backgroundColor: Color(0xFFFFFFFF),
            cornerRadius: 20,
            overlayColor: Color(0x4D000000),
          ),
          general: GeneralStyleSettings(textColor: Color(0xFF000000)),
        ),
      );

      if (response != null) {
        await _handleUserResponse(response);
      }
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка принудительного показа: $e');
    }
  }

  // Сбросить все согласия (для тестирования)
  Future<void> resetConsent() async {
    try {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Сброс всех согласий...');

      // В новой версии SDK нет метода reset(),
      // поэтому просто очищаем локальные данные
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_consentGivenKey);
      await prefs.remove(_hasShownBannerKey);

      _hasConsent = false;

      // Для полного сброса нужно будет переинициализировать SDK
      _isInitialized = false;

      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Согласия сброшены (локально)');
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Для полного сброса переустановите приложение');
    } catch (e) {
      // RELEASE: Debug logging disabled
      // debugPrint('ConsentService: Ошибка сброса согласий - $e');
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
