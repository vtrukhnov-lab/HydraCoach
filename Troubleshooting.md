# Troubleshooting Guide

Common issues and solutions for HydraCoach development and usage.

## 🚨 Build Issues

### Apple Silicon Mac Issues

**Problem:** Build fails with `PathNotFoundException: app.dill` or architecture mismatch errors.

**Cause:** Flutter using Intel x86_64 Java on ARM64 Mac.

**Solution:**
```bash
# 1. Install ARM64 Java
brew install --cask temurin@17

# 2. Set environment variables
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"' >> ~/.zshrc

# 3. Update gradle.properties
echo "org.gradle.java.home=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home" >> android/gradle.properties

# 4. Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### Geolocator Build Errors

**Problem:** Build fails with geolocator dependency errors or missing directory.

**Solution:**
```bash
# Clean everything
flutter clean
rm -rf build/
rm pubspec.lock

# Reinstall dependencies
flutter pub get

# If still fails, try recreating the missing directory
mkdir -p build/geolocator_android/.transforms/290aa5916f3f6865c8ebd22936292ff6/transformed/bundleLibRuntimeToDirDebug

# Force rebuild
flutter build apk --release --no-cache
```

### Dependency Conflicts

**Problem:** Incompatible package versions or outdated dependencies.

**Solution:**
```bash
# Check for outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Clean and reinstall
flutter clean
flutter pub get
```

### Project Cleanup

**Problem:** Multiple build folders and junk files cluttering the project.

**Solution:**
```bash
# One-liner cleanup
rm -rf build* .dart_tool* .flutter-plugins-dependencies* && flutter clean && flutter pub get
```

## 📱 Runtime Issues

### Red Screen Errors in Daily History

**Problem:** App crashes with red error screen when navigating to previous days.

**Fixed in v0.1.3** - Update to latest version.

**Manual Fix:**
- Avoid calling async operations in `build()` method
- Use `WidgetsBinding.instance.addPostFrameCallback()` for post-build operations
- Add proper error handling for SharedPreferences data

### Monthly Achievements Not Displaying

**Problem:** New achievement design not showing in APK builds.

**Solution:**
```bash
# Force complete rebuild
flutter clean
rm -rf build/
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Notification Issues

**Problem:** Push notifications not working or causing crashes.

**Solution:**
1. Check Firebase configuration files are in correct locations
2. Verify FCM token generation in debug logs
3. For Android < API 26, ensure LED notification parameters are disabled

### Weather Data Not Loading

**Problem:** Weather card shows "No data" or loading indefinitely.

**Solutions:**
- Check internet connection
- Verify geolocation permissions are granted
- Ensure OpenWeatherMap API key is valid
- Wait 5-10 minutes for API key activation (new keys only)

## 🔧 Development Issues

### Hot Reload Not Working

**Solution:**
```bash
# Stop the app
# Make changes to code
flutter hot restart  # Instead of hot reload

# For major changes, full restart
flutter run
```

### SharedPreferences Data Corruption

**Problem:** App crashes when loading historical data.

**Solution:**
```bash
# Clear app data (will lose all progress)
adb shell pm clear com.example.hydracoach

# Or reinstall
adb uninstall com.example.hydracoach
flutter install
```

### Import Conflicts

**Problem:** Multiple packages with same class names.

**Solution:**
Use import prefixes:
```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notif;
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
```

## 📲 Installation Issues

### APK Installation Failed

**Problem:** "App not installed" or "Parse error" on Android.

**Solutions:**
- Enable "Unknown sources" in Android settings
- Build with correct architecture: `flutter build apk --release`
- Check minimum SDK version compatibility
- Clear previous installation: `adb uninstall com.example.hydracoach`

### ADB Device Not Found

**Problem:** `adb devices` shows no devices or "unauthorized".

**Solutions:**
```bash
# Restart ADB server
adb kill-server
adb start-server

# Check USB debugging is enabled on phone
# Accept RSA key fingerprint on phone screen
```

## 🧪 Testing Issues

### Unit Tests Failing

**Problem:** Provider tests or SharedPreferences tests fail.

**Solution:**
```bash
# Run with proper test environment
flutter test --dart-define=FLUTTER_TEST=true

# For SharedPreferences tests
flutter test test/widget_test.dart
```

### Integration Tests Not Running

**Problem:** Real device tests fail to start.

**Solution:**
- Ensure device is connected and authorized
- Check Flutter doctor: `flutter doctor -v`
- Try with emulator first

## 📊 Performance Issues

### Slow App Startup

**Solutions:**
- Use `flutter build apk --release` for production builds
- Minimize data loading in `initState()`
- Add loading indicators for better UX

### Memory Leaks

**Solutions:**
- Properly dispose controllers in `dispose()` method
- Use `mounted` checks before calling `setState()`
- Remove listeners when widgets are disposed

## 🆘 Getting Help

If these solutions don't work:

1. **Check Flutter Doctor:**
   ```bash
   flutter doctor -v
   ```

2. **Enable Verbose Logging:**
   ```bash
   flutter run --verbose
   ```

3. **Clean Everything:**
   ```bash
   flutter clean
   rm -rf build/
   flutter pub get
   ```

4. **Create GitHub Issue:**
   Include:
   - Flutter version (`flutter --version`)
   - Device/OS information
   - Complete error logs
   - Steps to reproduce

## 📝 Useful Commands

```bash
# Project health check
flutter doctor -v
flutter analyze
flutter test

# Complete reset
flutter clean && flutter pub get

# Build variations
flutter build apk --debug          # For testing
flutter build apk --release        # For distribution
flutter build apk --profile        # For performance analysis

# Installation
adb install -r app-release.apk     # Install with replace
adb uninstall com.example.hydracoach  # Uninstall

# Debugging
flutter logs                        # Show device logs
adb logcat | grep flutter         # Android system logs
```

---

**Last Updated:** September 3, 2025 (v0.1.3)

For more help, check the main [README.md](README.md) or create an issue on GitHub.