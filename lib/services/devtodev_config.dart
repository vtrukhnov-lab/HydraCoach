/// Конфигурация API-ключей для DevToDev Analytics.
///
/// Ключи прокидываются через флаги `--dart-define` при сборке приложения:
/// ```
/// flutter run --dart-define=DEVTODEV_ANDROID_KEY=<ANDROID_KEY> \
///            --dart-define=DEVTODEV_IOS_KEY=<IOS_KEY>
/// ```
///
/// Если ключи не указаны, интеграция DevToDev будет пропущена, чтобы приложение
/// могло продолжить работу только с Firebase Analytics.
const String devToDevAndroidAppKey = String.fromEnvironment(
  'DEVTODEV_ANDROID_KEY',
  defaultValue: '',
);

const String devToDevIosAppKey = String.fromEnvironment(
  'DEVTODEV_IOS_KEY',
  defaultValue: '',
);
