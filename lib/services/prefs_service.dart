import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service for SharedPreferences to avoid repeated getInstance() calls
/// which create Futures and access platform channels.
///
/// Usage:
/// - Call PrefsService.init() once in main() before runApp()
/// - Use PrefsService.instance instead of SharedPreferences.getInstance()
class PrefsService {
  static SharedPreferences? _prefs;

  /// Get cached SharedPreferences instance.
  /// Returns cached instance if available, otherwise initializes it.
  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Initialize SharedPreferences once at app startup.
  /// Call this in main() before runApp().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Clear cached instance (for testing purposes)
  static void reset() {
    _prefs = null;
  }
}
