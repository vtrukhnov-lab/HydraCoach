# HydraCoach 💧

Smart water and electrolyte tracking app optimized for keto, fasting, and active lifestyle.

## ✨ Features

### Core Features (FREE)
- **Smart Water Tracking** - Personalized daily goals based on weight, diet, and activity
- **Electrolyte Balance** - Track sodium, potassium, and magnesium intake
- **Weather Integration** - Automatic goal adjustments based on Heat Index
- **Hydration Status** - Real-time monitoring with HRI (Hydration Risk Index)
- **Smart Reminders** - Context-aware notifications (post-coffee, heat warnings)
- **Diet Modes** - Optimized for normal, keto, and intermittent fasting
- **Daily Reports** - Evening summary with insights and recommendations
- **Alcohol Tracking** - Log drinks and get hydration corrections

### PRO Features (Subscription)
- **Advanced Reminders** - Workout protocols, fasting-aware notifications
- **Recovery Plans** - Step-by-step hydration after alcohol
- **Sobriety Calendar** - Track and celebrate alcohol-free days
- **Unlimited Sync** - Full cloud backup and multi-device support
- **Weekly PRO Reports** - Deep analytics with CSV export
- **Health Integrations** - Apple Health / Google Fit sync
- **Calibration Tools** - Sweat rate testing, urine color tracking

## 📱 Screenshots

<details>
<summary>View Screenshots</summary>

- Main Dashboard with progress rings
- Weather card with heat adjustments
- Daily report and analytics
- History and trends
- Alcohol tracking and recovery
- Settings and profile

</details>

## 🛠️ Tech Stack

- **Framework:** Flutter 3.0+
- **State Management:** Provider
- **Backend:** Firebase (Auth, Firestore, Remote Config)
- **Billing:** RevenueCat
- **Analytics:** Firebase Analytics + AppsFlyer
- **Localization:** Flutter ARB (EN/RU/ES)
- **Local Storage:** SharedPreferences
- **Charts:** fl_chart
- **Notifications:** flutter_local_notifications

## 📁 Project Structure

```
hydracoach/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/                   # Configuration
│   │   ├── remote_config.dart    # Remote parameters
│   │   └── feature_flags.dart    # Feature toggles
│   ├── models/                   # Data models
│   ├── screens/                  # UI screens
│   │   ├── main_screen.dart      # Dashboard
│   │   ├── onboarding/           # Onboarding flow
│   │   ├── alcohol/              # Alcohol features
│   │   └── settings/             # Settings
│   ├── services/                 # Business logic
│   │   ├── hydration_calculator.dart
│   │   ├── weather_service.dart
│   │   ├── notification_service.dart
│   │   └── revenue_cat_service.dart
│   ├── widgets/                  # Reusable UI components
│   ├── providers/                # State management
│   ├── utils/                    # Utilities
│   └── l10n/                     # Localization files
│       ├── app_en.arb
│       ├── app_ru.arb
│       └── app_es.arb
├── assets/                       # Images, icons, fonts
├── test/                         # Tests
└── pubspec.yaml                  # Dependencies
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- iOS/Android development environment
- Firebase project configured
- RevenueCat account for billing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/vtrukhnov-lab/HydraCoach.git
cd HydraCoach
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate localization files:
```bash
flutter gen-l10n
```

4. Configure Firebase:
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)

5. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your API keys
```

6. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web (limited functionality)
flutter run -d chrome
```

## 🧮 Core Algorithms

### Water Calculation
```
Base formulas (ml/day):
- Minimum: 22 ml × weight(kg)
- Optimal: 30 ml × weight(kg)
- Maximum: 36 ml × weight(kg)

Adjustments:
- Heat Index corrections
- Activity level multipliers
- Coffee/alcohol compensations
- Fasting mode modifications
```

### Electrolyte Targets
```
Normal mode:
- Sodium: 2000mg
- Potassium: 3500mg
- Magnesium: 400mg

Keto mode:
- Sodium: 3000-5000mg
- Potassium: 3500-4700mg
- Magnesium: 400-600mg
```

### Hydration Risk Index (HRI)
```
Factors (0-100 scale):
- Heat Index impact
- Physical activity level
- Caffeine intake
- Alcohol consumption
- Sleep quality
- Urine color (PRO)

Risk zones:
- Green: 0-30 (Good)
- Yellow: 31-60 (Caution)
- Red: 61-100 (Risk)
```

## 🌍 Localization

The app supports multiple languages through ARB files:

- **English** (en) - Primary language
- **Russian** (ru) - Русский
- **Spanish** (es) - Español

To add a new language:
1. Create `app_XX.arb` in `lib/l10n/`
2. Translate all keys from `app_en.arb`
3. Run `flutter gen-l10n`

## 🔧 Configuration

### Remote Config Parameters

Key parameters managed remotely via Firebase:

- Water calculation formulas
- Electrolyte targets by diet mode
- Heat Index thresholds
- Notification limits
- Alcohol correction factors
- HRI risk thresholds
- Feature flags

### Environment Variables

Required in `.env`:
```
WEATHER_API_KEY=your_openweather_key
REVENUE_CAT_API_KEY=your_revenuecat_key
APPSFLYER_DEV_KEY=your_appsflyer_key
```

## 📊 Analytics Events

Key events tracked:
- Onboarding completion
- Water/electrolyte logging
- Hydration status changes
- Reminder interactions
- Subscription events
- Alcohol tracking
- Report generation

## 🧪 Testing

Run tests:
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit

# Widget tests
flutter test test/widget

# Integration tests
flutter test integration_test
```

## 📦 Build & Release

### Android
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

## 🗺️ Roadmap

- [ ] Phase 1: Core hydration tracking (Released ✅)
- [ ] Phase 2: PRO subscription model (In Progress 🚧)
- [ ] Phase 3: Alcohol awareness module (In Progress 🚧)
- [ ] Phase 4: Publisher SDK integration
- [ ] Phase 5: Advanced features
  - [ ] Apple Watch / WearOS apps
  - [ ] AI recommendations
  - [ ] Social challenges
  - [ ] Meal tracking integration

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards

- Follow Flutter style guide
- Add tests for new features
- Update localization files
- Document complex logic
- Keep commits atomic

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Weather data from OpenWeatherMap API
- Icons from Material Design
- Billing infrastructure by RevenueCat
- Analytics by Firebase & AppsFlyer
- Special thanks to the keto/fasting community for feedback

## 📞 Support

For questions or support:
- Open an issue on GitHub
- Email: support@hydracoach.app
- Documentation: [docs.hydracoach.app](https://docs.hydracoach.app)

## 👨‍💻 Author

**Viktor Trukhnov**
- GitHub: [@vtrukhnov-lab](https://github.com/vtrukhnov-lab)
- Email: viktor@hydracoach.app

---

Built with ❤️ using Flutter