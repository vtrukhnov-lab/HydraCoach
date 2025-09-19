/// Конфигурация API-ключей для DevToDev Analytics.
///
/// В боевой сборке ключи хранятся прямо в коде, но при необходимости
/// их можно переопределить через `--dart-define`, сохранив возможность
/// тестировать другие окружения без перекомпиляции.
class DevToDevCredentials {
  const DevToDevCredentials({
    required this.appId,
    required this.secretKey,
    required this.apiKey,
  });

  const DevToDevCredentials.empty()
      : appId = '',
        secretKey = '',
        apiKey = '';

  final String appId;
  final String secretKey;
  final String apiKey;

  bool get isComplete =>
      appId.isNotEmpty && secretKey.isNotEmpty && apiKey.isNotEmpty;
}

/// Продакшн-ключи для Google Play (Android).
const DevToDevCredentials devToDevAndroidCredentials = DevToDevCredentials(
  appId: String.fromEnvironment(
    'DEVTODEV_ANDROID_APP_ID',
    defaultValue: '5b5ca03c-07de-065c-8de4-9c07375ac9b9',
  ),
  secretKey: String.fromEnvironment(
    'DEVTODEV_ANDROID_SECRET_KEY',
    defaultValue: 'oW7S2NpeB5EVR4c6GQUPmdAthlfubigs',
  ),
  apiKey: String.fromEnvironment(
    'DEVTODEV_ANDROID_API_KEY',
    defaultValue: 'ak-CRhQtT0OMj4GpIqNP7bZHWs6vUaDuF85',
  ),
);

/// Продакшн-ключи для App Store (iOS).
const DevToDevCredentials devToDevIosCredentials = DevToDevCredentials(
  appId: String.fromEnvironment(
    'DEVTODEV_IOS_APP_ID',
    defaultValue: '967dd119-476a-01fa-9591-415d27ee6af8',
  ),
  secretKey: String.fromEnvironment(
    'DEVTODEV_IOS_SECRET_KEY',
    defaultValue: 'eamugOGLJ0HfPMUBSKxAYFIjX2CkE6n5',
  ),
  apiKey: String.fromEnvironment(
    'DEVTODEV_IOS_API_KEY',
    defaultValue: 'ak-SLgUuvftC0hGDVq8iI9p1KcJ7bnQr2RF',
  ),
);
