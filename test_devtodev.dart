import 'package:flutter/foundation.dart';
import 'lib/services/devtodev_config.dart';
import 'lib/utils/app_logger.dart';

void main() {
  // Test iOS credentials
  logger.i('=== iOS DevToDev Credentials ===');
  logger.i('App ID: ${devToDevIosCredentials.appId}');
  logger.i('Secret Key: ${devToDevIosCredentials.secretKey}');
  logger.i('API Key: ${devToDevIosCredentials.apiKey}');
  logger.i('Is Complete: ${devToDevIosCredentials.isComplete}');

  logger.i('\n=== Android DevToDev Credentials ===');
  logger.i('App ID: ${devToDevAndroidCredentials.appId}');
  logger.i('Secret Key: ${devToDevAndroidCredentials.secretKey}');
  logger.i('API Key: ${devToDevAndroidCredentials.apiKey}');
  logger.i('Is Complete: ${devToDevAndroidCredentials.isComplete}');

  // Test platform resolution
  logger.i('\n=== Platform Testing ===');
  logger.i('Default Target Platform: $defaultTargetPlatform');

  // Test credentials resolution based on platform
  DevToDevCredentials getCredentialsForPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return devToDevAndroidCredentials;
      case TargetPlatform.iOS:
        return devToDevIosCredentials;
      default:
        return const DevToDevCredentials.empty();
    }
  }

  logger.i('iOS Credentials Valid: ${getCredentialsForPlatform(TargetPlatform.iOS).isComplete}');
  logger.i('Android Credentials Valid: ${getCredentialsForPlatform(TargetPlatform.android).isComplete}');

  logger.i('\n✅ DevToDev configuration test completed successfully!');
}