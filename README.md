# HydraCoach 💧

Smart water and electrolyte tracking app optimized for keto, fasting, and active lifestyle.

## 🎯 Features

### Core Functionality
- **Smart Water Tracking** - Personalized daily goals based on weight, diet, and activity
- **Electrolyte Balance** - Track sodium, potassium, and magnesium intake
- **Weather Integration** - Automatic goal adjustments based on Heat Index
- **Hydration Status** - Real-time monitoring with risk assessment
- **Smart Reminders** - Context-aware notifications (post-coffee, heat warnings)

### Advanced Features
- **Diet Modes** - Optimized for normal, keto, and intermittent fasting
- **Daily Reports** - Evening summary with insights and recommendations
- **History & Analytics** - Track progress over days, weeks, and months
- **Customizable Settings** - Units, reminders, and personal preferences

## 📱 Screenshots

<details>
<summary>View Screenshots</summary>

- Main Dashboard with progress rings
- Weather card with heat adjustments
- Daily report and analytics
- History and trends
- Settings and profile

</details>

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- iOS/Android development environment

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

3. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome
```

## 🏗️ Project Structure

```
hydracoach/
├── lib/
│   ├── main.dart              # App entry point and core logic
│   ├── screens/               # App screens
│   │   ├── onboarding_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   ├── services/              # Business logic
│   │   ├── weather_service.dart
│   │   └── notification_service.dart
│   └── widgets/               # Reusable components
│       ├── weather_card.dart
│       └── daily_report.dart
├── pubspec.yaml               # Dependencies
└── README.md                  # Documentation
```

## 📊 Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Notifications**: flutter_local_notifications
- **Location**: geolocator

## 🎨 Key Algorithms

### Water Goals Calculation
```dart
waterMin = 22 ml × weight(kg)
waterOpt = 30 ml × weight(kg)
waterMax = 36 ml × weight(kg)
```

### Heat Index Adjustments
- HI < 27°C: No adjustment
- HI 27-32°C: +5% water, +500mg sodium
- HI 32-39°C: +8% water, +1000mg sodium
- HI > 39°C: +12% water, +1500mg sodium

### Hydration Status
- **Normal**: Balanced water and electrolytes
- **Dilution Risk**: Water > 115% goal, Sodium < 60% goal
- **Dehydration**: Water < 90% goal
- **Low Salt**: Sodium < 50% goal

## 🔜 Roadmap

### Phase 1: Core Features ✅
- [x] Basic water tracking
- [x] Electrolyte monitoring
- [x] Weather integration
- [x] Daily reports

### Phase 2: Enhanced Features (In Progress)
- [ ] Firebase integration for cloud sync
- [ ] Export data (CSV/PDF)
- [ ] Dark theme
- [ ] Widget support

### Phase 3: Advanced Features
- [ ] Apple Watch / WearOS apps
- [ ] AI-powered recommendations
- [ ] Social features and challenges
- [ ] Integration with fitness apps

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Viktor Trukhnov** - *Initial work* - [vtrukhnov-lab](https://github.com/vtrukhnov-lab)

## 🙏 Acknowledgments

- Inspired by the need for better hydration tracking on keto/fasting diets
- Weather data from OpenWeatherMap API
- Icons and design inspiration from Material Design

## 📧 Contact

For questions or suggestions, please open an issue or contact the maintainer.

---

**Built with ❤️ using Flutter**