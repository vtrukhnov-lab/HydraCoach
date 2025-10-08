import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/main_shell.dart';

class AppHelpers {
  /// Restart the app by navigating to MainShell and clearing navigation stack
  static Future<void> restartApp() async {
    final navigator = MyApp.navigatorKey.currentState;

    if (navigator == null) {
      debugPrint('⚠️ Navigator key is null, cannot restart app');
      return;
    }

    // Small delay to ensure state is updated
    await Future.delayed(const Duration(milliseconds: 200));

    // Navigate to MainShell and clear stack
    await navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }
}
