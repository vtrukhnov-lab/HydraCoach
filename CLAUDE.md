# Claude Instructions for HydroCoach Project
Общение на русском языке
**Version Code Mismatch Issue:** Google Play "Version code X already used" despite updating pubspec.yaml → Always update ALL THREE places:
1. pubspec.yaml version (e.g., 2.1.1+31)
2. android/app/build.gradle.kts versionCode/versionName (lines 43-44)
3. lib/main.dart app_version in logEvent calls (for settings display)