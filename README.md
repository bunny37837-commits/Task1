# TaskRemind Pro (Flutter)

TaskRemind Pro is an **offline Flutter app** for daily task reminders with Android APK output.

## Current project shape
- Pure Flutter app structure (`lib/`, `android/`, `pubspec.yaml`)
- Riverpod-based state management
- Android scaffold wired for Flutter Gradle build
- CI workflow builds release APK

## Dependencies (pinned to valid pub.dev versions)
- `flutter_overlay_window: ^0.5.0`
- `flutter_local_notifications: ^20.1.0`
- `workmanager: ^0.9.0+3`
- `permission_handler: ^12.0.1`
- `flutter_riverpod: ^3.0.3`

## CI
GitHub Actions workflow runs:
1. `flutter pub get`
2. `flutter analyze`
3. `flutter build apk --release`

## Local commands
```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```
