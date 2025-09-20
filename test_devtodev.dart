import 'package:flutter/foundation.dart';
import 'lib/services/devtodev_config.dart';

void main() {
  // Test iOS credentials
  print('=== iOS DevToDev Credentials ===');
  print('App ID: ${devToDevIosCredentials.appId}');
  print('Secret Key: ${devToDevIosCredentials.secretKey}');
  print('API Key: ${devToDevIosCredentials.apiKey}');
  print('Is Complete: ${devToDevIosCredentials.isComplete}');

  print('\n=== Android DevToDev Credentials ===');
  print('App ID: ${devToDevAndroidCredentials.appId}');
  print('Secret Key: ${devToDevAndroidCredentials.secretKey}');
  print('API Key: ${devToDevAndroidCredentials.apiKey}');
  print('Is Complete: ${devToDevAndroidCredentials.isComplete}');

  // Test platform resolution
  print('\n=== Platform Testing ===');
  print('Default Target Platform: $defaultTargetPlatform');

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

  print('iOS Credentials Valid: ${getCredentialsForPlatform(TargetPlatform.iOS).isComplete}');
  print('Android Credentials Valid: ${getCredentialsForPlatform(TargetPlatform.android).isComplete}');

  print('\n✅ DevToDev configuration test completed successfully!');
}