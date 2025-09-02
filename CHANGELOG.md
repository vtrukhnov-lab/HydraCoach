# Changelog

All notable changes to HydraCoach will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Planned
- Cloud sync via Firestore
- Export data to CSV/PDF
- Dark theme support
- Home screen widgets

---

## [0.1.2] - 2024-09-02
### Fixed
- **Critical notification bug**: Removed LED notification parameters that caused crashes on Android versions before Oreo (API 26)
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

---

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

---

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

---

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

### Known Issues
- Push notifications not configured
- No cloud data sync
- No data export functionality

---

## [0.0.5] - 2024-08-28
### Added
- Initial project setup
- Basic Flutter app structure
- Provider state management
- SharedPreferences for local storage

---

## Version Guidelines

### Version Numbers
- **Major (1.0.0)**: Breaking changes, major feature releases
- **Minor (0.1.0)**: New features, backwards compatible
- **Patch (0.0.1)**: Bug fixes, minor improvements

### Categories
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

---

[Unreleased]: https://github.com/vtrukhnov-lab/hydracoach/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/vtrukhnov-lab/hydracoach/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/vtrukhnov-lab/hydracoach/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/vtrukhnov-lab/hydracoach/compare/v0.0.9...v0.1.0
[0.0.9]: https://github.com/vtrukhnov-lab/hydracoach/compare/v0.0.5...v0.0.9
[0.0.5]: https://github.com/vtrukhnov-lab/hydracoach/releases/tag/v0.0.5