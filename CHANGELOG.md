# Changelog
All notable changes to HydraCoach will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned
- Cloud sync via Firestore
- Export data to CSV/PDF
- Dark theme support
- Home screen widgets
- Weekly reports (PRO)
- Fasting aware mode (PRO)
- Heat protocols (PRO)

## [0.2.0] - 2025-01-17
### Added
- **PRO Subscription Architecture**
  - RevenueCat integration for subscription management
  - Paywall screen with PRO features description
  - PRO badge and indicator in main screen
  - Subscription provider with state management
  
- **Remote Config Service**
  - Firebase Remote Config integration (local mode for now)
  - Dynamic parameter management for formulas and thresholds
  - Configurable water/electrolyte coefficients
  - Heat Index adjustment thresholds
  - Hydration status parameters
  
- **PRO Features Structure** (Ready for implementation)
  - Smart reminders framework
  - Weekly reports placeholder
  - CSV export preparation
  - Cloud sync preparation
  - Fasting aware mode preparation

### Changed
- Main screen now shows PRO button for non-subscribers
- Updated to MultiProvider architecture for subscription state
- Water and electrolyte goals now use Remote Config values
- Hydration status thresholds managed remotely

### Technical
- Added `subscription_service.dart` for RevenueCat integration
- Added `remote_config_service.dart` for parameter management
- Updated main.dart with SubscriptionProvider
- Fixed RevenueCat 9.x API compatibility
- Prepared architecture for future PRO features

### Fixed
- RevenueCat API compatibility with version 9.x
- Firebase Remote Config import issues

## [0.1.3] - 2025-09-03
### Fixed
- **Critical UI Bug:** Fixed monthly achievements panel not displaying properly in APK builds
- **Daily History Crash:** Resolved red screen error when swiping through previous days
- **Infinite Loop:** Fixed build method calling async operations causing infinite rebuilds
- **Performance:** Optimized data loading for historical days to prevent UI freezing

### Changed
- **Achievement Design:** Improved monthly achievements with better purple gradient and progress indicators
- **Date Navigation:** Enhanced daily history navigation with proper error handling
- **Loading States:** Added loading indicators for better user experience when switching dates

### Technical
- Refactored DailyHistoryScreen to use proper state management
- Added `_loadedDateKey` caching to prevent unnecessary data reloading
- Improved error handling for corrupted SharedPreferences data
- Fixed `build()` method calling async operations directly

## [0.1.2] - 2024-09-02
### Fixed
- **Critical notification bug:** Removed LED notification parameters that caused crashes on Android versions before Oreo (API 26)
- All notification types now working correctly (instant, scheduled, delayed)
- Fixed PlatformException "invalid_led_details" error
- Post-coffee reminders (20-minute delay) now functional

### Changed
- Disabled LED lights for notifications to ensure compatibility with all Android versions
- Improved notification channel configuration for better reliability

### Tested
- Successfully tested on physical Android device
- Verified all notification types: instant, 10-second delay, 1-minute delay
- Confirmed scheduled notifications working properly

## [0.1.1] - 2024-09-02
### Changed
- Removed debug UI elements (FCM token button)
- Cleaned up commented debug code
- Production-ready build configuration

### Fixed
- Fixed unclosed comment blocks in main.dart
- Resolved all compiler warnings
- Fixed import conflicts between modules

### Security
- Wrapped all debug prints in kDebugMode for production safety

## [0.1.0] - 2024-09-02
### Added
- **Firebase Integration**
  - Firebase Cloud Messaging (FCM) for push notifications
  - FCM token generation and management
  - Topic subscriptions (all_users, keto_users, fasting_users)
  - Targeted and broadcast push notifications

- **Notification System**
  - Local notifications via flutter_local_notifications
  - Smart reminders based on Hydration Risk Index
  - Context-aware triggers (post-coffee, heat warnings)
  - Customizable reminder frequency and timing
  - Timezone-aware scheduling

- **Settings Enhancements**
  - Notification management UI
  - Reminder frequency controls (2-8 times per day)
  - Custom quiet hours (morning/evening times)
  - Toggle for special reminders (coffee, heat)

### Changed
- Refactored NotificationService with complete functionality
- Updated Firebase dependencies to compatible versions
- Improved settings screen with notification controls

### Fixed
- Import naming conflicts with prefixes
- Firebase package version incompatibilities
- Settings screen integration issues

## [0.0.9] - 2024-09-01
### Added
- **Core Tracking Features**
  - Water intake tracking (ml/oz)
  - Electrolyte monitoring (Na, K, Mg)
  - Quick-add preset buttons
  - Intake history with swipe-to-delete

- **Weather Integration**
  - OpenWeatherMap API integration
  - Automatic location detection
  - Heat Index calculation
  - Dynamic goal adjustments based on temperature

- **Monthly Analytics**
  - Achievement system with 10 unlockable rewards
  - Heatmap calendar showing daily progress
  - Monthly statistics and trends
  - Progress tracking for streaks and consistency

- **Personalization**
  - Onboarding flow (weight, diet mode, activity level)
  - Three diet modes: Normal, Keto, Intermittent Fasting
  - Activity levels: Low, Medium, High
  - Profile settings management

- **Visual Features**
  - Animated progress rings
  - Hydration Risk Index (HRI) indicator
  - Status badges (Normal, Dehydration, Dilution, Low Salt)
  - Weather card with real-time updates
  - Daily report modal (after 9 PM)

### Known Issues (Fixed in 0.1.3)
- Monthly achievements panel display issues in APK builds
- Daily history crashes when navigating to previous days
- Performance issues with historical data loading

## [0.0.5] - 2024-08-28
### Added
- Initial project setup
- Basic Flutter app structure
- Provider state management
- SharedPreferences for local storage

---

## Version Guidelines
### Version Numbers
- **Major (1.0.0):** Breaking changes, major feature releases
- **Minor (0.1.0):** New features, backwards compatible
- **Patch (0.0.1):** Bug fixes, minor improvements

### Categories
- **Added:** New features
- **Changed:** Changes in existing functionality
- **Deprecated:** Soon-to-be removed features
- **Removed:** Removed features
- **Fixed:** Bug fixes
- **Security:** Vulnerability fixes
- **Technical:** Code improvements, refactoring